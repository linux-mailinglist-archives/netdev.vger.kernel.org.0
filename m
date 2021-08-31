Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2565C3FD007
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240843AbhHaXqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhHaXqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:46:32 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C678EC061575;
        Tue, 31 Aug 2021 16:45:36 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id a13so1720029iol.5;
        Tue, 31 Aug 2021 16:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZZLNKF/O4vAdXcyP90BNU8m0wh5n7SxsQvUMCo0M93A=;
        b=vFk8TPzgINiiBYoCobcjUuDHPDk+KlcHOPMQQykE12LPqHNMSFqKA2UUEEXHCkfrrv
         EI9x9Wl0fzRd/kMXY/4YrDt3/kj5WG/m+4Caxi5gp4p6hDHy9GSBCEZTsiwfpTUamTpI
         VfC25LCmAxLslTBFvoHs9l2LZSdtFde/NpAxOh/Sqiakx0QkAhKkFI5uU/gVin3lSo/j
         +TjlBctxRot9pOIlZh6gclhyM4sKj7j5G00y8OUrP9kfKD02/YU/ZqyPPOnFE9g1HCGr
         800Q4SxxZ3EYWVoKzrn30jgdYfsr4qlIwl4Nc4V45cE8Omed7BsePM2aNySev/ooBrUo
         45zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZZLNKF/O4vAdXcyP90BNU8m0wh5n7SxsQvUMCo0M93A=;
        b=KgNflE7ofydE4ZixxvoJ5ntRzHA6mh0YRR2wxG3FlNqn7O9EI2XouOWgY05pBewd7D
         e12kyOJXj06ljH8cx8pei3JJCT51YLbOkuand9rzwQlWyBe+KmVdHLaZFsxth3djBKnP
         YACo6m1JeFwJkb4Ty+nu8JyPGsGmUNL7z79QymdEAIy25Hi4rvaufmVIjrxNn3tXiJeL
         3EzZ/Nhwm+RRc+2an8EfJPtFvW0/II5EJViOGgNcoMN85bEp47nSATz9tI4noHEvi684
         OMZrzbO3pUyRozdQwZ1gL4+vbomrx/EajJeNi8NhIz0eTrSShLdzUobvxOntssywi4Cf
         rm3A==
X-Gm-Message-State: AOAM530HOnzG8Nh/8J81QpKRvXcDERO1TFxNYYElwndw9P2+QK6cgNj9
        0zUWd/Uz435fyv+9vGoYfTxKcjXWKms=
X-Google-Smtp-Source: ABdhPJzsUmrhBMPC9LLPW6RHyjkqGJuheMrlnUcg3vxzkEhaMgaRSl7FFo9iwuCuU0mebAZV5D2+og==
X-Received: by 2002:a5e:9819:: with SMTP id s25mr25102798ioj.63.1630453535446;
        Tue, 31 Aug 2021 16:45:35 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id o11sm10839521ilf.86.2021.08.31.16.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:45:35 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:45:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ebf1925fe0_6b8720860@john-XPS-13-9370.notmuch>
In-Reply-To: <855da36f6c4f5fca872f1cfd13842374945db88f.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <855da36f6c4f5fca872f1cfd13842374945db88f.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 09/18] net: mvneta: enable jumbo frames for
 XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Enable the capability to receive jumbo frames even if the interface is
> running in XDP mode
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
