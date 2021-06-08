Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF1839F722
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbhFHMzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 08:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhFHMzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 08:55:47 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4167EC061574;
        Tue,  8 Jun 2021 05:53:54 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id ci15so32424238ejc.10;
        Tue, 08 Jun 2021 05:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NfCuVPvzFIfxPPOCm0KJdAVeKqhCgjwmUXu8quPxjw0=;
        b=iclmVVzKLd1ex/Bpb5tGyOtYrCY0wJWDMKPKZiQuYSgKo4zBAen/lNqqYAiqOjvNkW
         ztP73KzW5azR1sVt+FqcN7dJvKpipI5hbp1dp2u7pKNImiJaSKtDp7xhQC/Xf+G8rXCa
         IebvSMPiRakx6DkaYIRUz4/R0WJ5YBgw1oJihecTUXq4s57fiBTp65uycTlaN9PMVQw4
         8x951nFPD43h+lW5vvw2nCwgcHvhkDqYy2DShJE74yNl2QbdSQl0whXG0nBdIX/Rm5fn
         AbopjSe1mHEuY9NdIY55PBOsOf+k3lefYpolA6OWXG2KFYj82jEuCT3lpiYU9MQAGaM7
         8GvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NfCuVPvzFIfxPPOCm0KJdAVeKqhCgjwmUXu8quPxjw0=;
        b=MgZB9QZqir4HlRcFsjPqWkzmUvoKa06w9YaLSDmiaZCUc6DQmk4Nyi1sYDU33oMQYU
         FZ4I3wGurSN2Gs9klH1SRihTX14M+m2HDaalaXr4m2Kd0rIShAB2P5P/ti+TM/C3Ltpl
         kmCO/faexRSS6wK9iML14yDfWgEzZe/IXwXtH9wNfN5hF8n0QrEA/evOCd4lrKmGuHzS
         rmSaeNQ/Q6KFtBVCAwGwvG+8KuHkfutLecWR3AAloLI4NdPWewIG3P/x1rg/xmB3CrX/
         3mxkHBWGGk9yODUqDZpgKVgDNKU6DiyNAMUrdJYA73rcKYOr4TrfTYnbpiSnPCmeDgGh
         jqCA==
X-Gm-Message-State: AOAM533RCtoRUQq/CgM/UT6GcWdOODaBliT8lbN30+cqIZABQ9Gyx5OM
        XSk/zMEC8YWXJ9pneK2dYjE=
X-Google-Smtp-Source: ABdhPJywWiWcEWCBIjXvyG1AGF+7sXPYW5tOHMNPfsrhOcELBDoeyjLbdsgmXJFZGXQoBGIPFGROyg==
X-Received: by 2002:a17:906:3649:: with SMTP id r9mr747133ejb.408.1623156832814;
        Tue, 08 Jun 2021 05:53:52 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r17sm8797810edt.33.2021.06.08.05.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 05:53:52 -0700 (PDT)
Date:   Tue, 8 Jun 2021 15:53:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
Subject: Re: [PATCH net-next v2 0/3] Some optimization for lockless qdisc
Message-ID: <20210608125349.7azp7zeae3oq3izc@skbuf>
References: <1622684880-39895-1-git-send-email-linyunsheng@huawei.com>
 <20210603113548.2d71b4d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603113548.2d71b4d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 11:35:48AM -0700, Jakub Kicinski wrote:
> On Thu, 3 Jun 2021 09:47:57 +0800 Yunsheng Lin wrote:
> > Patch 1: remove unnecessary seqcount operation.
> > Patch 2: implement TCQ_F_CAN_BYPASS.
> > Patch 3: remove qdisc->empty.
> > 
> > Performance data for pktgen in queue_xmit mode + dummy netdev
> > with pfifo_fast:
> > 
> >  threads    unpatched           patched             delta
> >     1       2.60Mpps            3.21Mpps             +23%
> >     2       3.84Mpps            5.56Mpps             +44%
> >     4       5.52Mpps            5.58Mpps             +1%
> >     8       2.77Mpps            2.76Mpps             -0.3%
> >    16       2.24Mpps            2.23Mpps             +0.4%
> > 
> > Performance for IP forward testing: 1.05Mpps increases to
> > 1.16Mpps, about 10% improvement.
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Any idea why these patches are deferred in patchwork?
https://patchwork.kernel.org/project/netdevbpf/cover/1622684880-39895-1-git-send-email-linyunsheng@huawei.com/
