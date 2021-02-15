Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F6631C222
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBOTEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:04:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhBOTEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:04:33 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F8FC0613D6
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 11:03:47 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id w36so12158916lfu.4
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 11:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=s2C8PR7Gw4nEOJjGQJh6Mj6huaxWG6Cou9QsccUmAuA=;
        b=qNGCMbvYw/SuMQffIqeeQ0c2icVOpqU4R6jom0su94hoz2p7qz1SMas0Ty+qv/D5jb
         4Mk1bdruniODXXLZ0gqrI6QYp9sX70TgN7c6+4+VF4R4reOB0e9K52sm8vt+7ZKD3MJA
         DoeXzioosVJgtO/lKCjhMmxLPbabKiSBcRE4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=s2C8PR7Gw4nEOJjGQJh6Mj6huaxWG6Cou9QsccUmAuA=;
        b=NiQmmorQoJNOXUtffpis/3TiIpySkE0UcQP+sdIJmQKQ7AmiCGV3JsS4eYKQwYOdS2
         9jjy/dgy26Q7rcouSekQRoe3YwTftxvUvi0yLWrAAxyIhN0o4LO757vtPaMfW1qWJ6Tf
         dwFkJbPW4UKoJxiDUA09UtcTIZRT86Fj9HWU+ntZOlt6u/SVLu1kTlfmsCURJV6Srmfc
         FdF0qelPW09615/QG1Px6lnYOpzzZIx9q5AucT7UVQQmnsfgfUWs2pGq+FDrThosRbZq
         WcDGFOqVEIv7BS6+HTXPwQMZ0Dnj8J5baGzRVcUT5101CFsQPyhHgVVGpdn5R/tMjpmJ
         O0wQ==
X-Gm-Message-State: AOAM530xiX07b0BjMFPY1f2wOJutYSc2XEkoMz7hYcnJdAIKyo7W8T1L
        +VPHSYffVW9C4+Ve4q8o+CibaA==
X-Google-Smtp-Source: ABdhPJyk2gE5I+5RXz4Iki3O88Ruc5DilknvQWG0LZF/ygyZlaEroo4fH80n0fyCu5hZEawJIb91Lg==
X-Received: by 2002:ac2:4349:: with SMTP id o9mr10385634lfl.415.1613415825757;
        Mon, 15 Feb 2021 11:03:45 -0800 (PST)
Received: from cloudflare.com (83.24.183.171.ipv4.supernova.orange.pl. [83.24.183.171])
        by smtp.gmail.com with ESMTPSA id w9sm1793224lfn.308.2021.02.15.11.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:03:45 -0800 (PST)
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-3-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v3 2/5] skmsg: get rid of struct sk_psock_parser
In-reply-to: <20210213214421.226357-3-xiyou.wangcong@gmail.com>
Date:   Mon, 15 Feb 2021 20:03:44 +0100
Message-ID: <87lfbp40hb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 10:44 PM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> struct sk_psock_parser is embedded in sk_psock, it is
> unnecessary as skb verdict also uses ->saved_data_ready.
> We can simply fold these fields into sk_psock, and get rid
> of ->enabled.
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
