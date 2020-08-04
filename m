Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3688A23B224
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgHDBOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgHDBON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:14:13 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73926C06174A;
        Mon,  3 Aug 2020 18:14:13 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c16so20982095ils.8;
        Mon, 03 Aug 2020 18:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ybAe4fA1vax96lVLa3/RcMUltUaH6klWCGzwlFp5R7o=;
        b=HB/K/C+Vkg0jZ9EwhhrQ/Uyp242lFMqR89VCSYNq496MBBJM0jugg1VkgsRKGFh5zL
         kKcKFqCJRnU19RxdFWGY1oRCWH1fRckWf/pIyzvtlFUMp1k3B3aTkIEk7XaEFLtuoKlV
         ZFFHYraupIwdU/JiqrmW1edgASYoX7NcO0NRfzkIzpBVq956V8Z2FuT8i/tKQGn/mZfC
         vj4KNm9tXwAw5HVSxxXutsxcadII1safgy1XqreodToRv78Nk8p4wJHYEzYWKF2Phl/A
         gLyw0dEB4dAHHNw0nf2ehKJrguGQ0AlA1M0c7szWtJ+fxHPgZykjDp3KGVswI1FcowGR
         HVFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ybAe4fA1vax96lVLa3/RcMUltUaH6klWCGzwlFp5R7o=;
        b=i4AsIfyfBSoPeoDEqPHqXHVBDwwIk8CDyw3b7/+Ceavep61EHNrvRXgiMYP25eOI2f
         y27RX9YYQCF7EE7HblljhFtvf7qlNhIrUWxJaRAr7PLme+TOWpp5M+Spu8pDrOO6FcfN
         vS9x09XQytwTN2ug6y5vKEz/cCRJORCPhyxxshoHLhqPaFoELYUtUllsvn0zQHWVfXOT
         yzZwRZFRUlp0iFUYUuag8mMzACKO/pTgqrSBaWwx8YYAal2vSareZK0eaVDgfM3XDvGQ
         P87lMXEYuH4DWqdh5HjLxUnpkjNK/fJjznKF8g3m0wduiJocWwn76TANfAHlGZVK/mDo
         9w6w==
X-Gm-Message-State: AOAM530xKYc8gXD2bP1tAwm72RYm9CC+oxcpf0gBVwdfSsJGIu3an0fB
        0JKDS0rOrBqv7sq3tf2FttA=
X-Google-Smtp-Source: ABdhPJwNG8pOgFjtHRS2QcjN/akK30r0R8GnZQTW1Tbh2nkLNBnoT8mFofB7bFxglrJNwRpHoXMu1w==
X-Received: by 2002:a05:6e02:508:: with SMTP id d8mr2206691ils.98.1596503652469;
        Mon, 03 Aug 2020 18:14:12 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s85sm12068767ilk.77.2020.08.03.18.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 18:14:11 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:14:05 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Message-ID: <5f28b65d3148a_62272b02d7c945b439@john-XPS-13-9370.notmuch>
In-Reply-To: <20200803231039.2682896-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
 <20200803231039.2682896-1-kafai@fb.com>
Subject: RE: [RFC PATCH v4 bpf-next 04/12] tcp: Add saw_unknown to struct
 tcp_options_received
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> In a later patch, the bpf prog only wants to be called to handle
> a header option if that particular header option cannot be handled by
> the kernel.  This unknown option could be written by the peer's bpf-prog.
> It could also be a new standard option that the running kernel does not
> support it while a bpf-prog can handle it.
> 
> This patch adds a "saw_unknown" bit to "struct tcp_options_received"
> and it uses an existing one byte hole to do that.  "saw_unknown" will
> be set in tcp_parse_options() if it sees an option that the kernel
> cannot handle.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
