Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6704A883B
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbiBCQBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:01:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235036AbiBCQBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643904108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FP5r9XEYAfG7IgAXOTZgdlbgnK6ZhwtirZ/Z53Mk54c=;
        b=axm8JWWR/Ron1M0AOLD8nNwJyQbwrO/XRktRzYP/UdDZ2VqN5c8wKPbcFuLVPKbIStb97A
        oquH8IP8kqnANvXfR8vJ9h1zK7DkzUtHUUScIj80anfTKAUVtkfYC+hvuSEGGGqgXGSs0q
        X1L2LHPULomuReytyjzmrpmD2FGywEU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-eTJ4OPAZPMmwM9HiP78iIQ-1; Thu, 03 Feb 2022 11:01:47 -0500
X-MC-Unique: eTJ4OPAZPMmwM9HiP78iIQ-1
Received: by mail-wr1-f70.google.com with SMTP id s17-20020adf9791000000b001e274a1233bso796512wrb.2
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 08:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FP5r9XEYAfG7IgAXOTZgdlbgnK6ZhwtirZ/Z53Mk54c=;
        b=1cUTSTdqW5NG2jHnWm2ZxGOFZaEau+jLNFVT1v5cZ4Pi1CDyZLgaO7shebWldMAeYs
         9dGWwKplg+ruu8asBMBEpAU4jCCd84aKeu9Zz/rQr9MKlhmJQ85cwZq5aleYDLq2b2Zg
         fbmmrwnesY2nrlt+DVjp2e/xFFpwPLfzgX9/Pv40L2zghCQIgjy5Atm6FxD7D4EEzCbp
         1x/nB7vXlZOmLkDI+4RfPL7tzDcoXy7SHsg+ORq5gFVC14/7nzNUBzaSSithQLHXoVOI
         4mJaQCdmutI3oVv1ggECpPzz8FDY+1SexrrwXpyDIKoHtMXUkG4Oqe8prHqiHjVSSiRJ
         sCfQ==
X-Gm-Message-State: AOAM530WcfBKq8qTXI5WWgPmTuLtQ9eZheUhIQZxH9CJD6UA0s1chdVn
        PBwXQQ68u+61x4TbNMSGrFVT/YhRE8JznJlcLVOEwOSRvouY/BaI3rA+nf2Y2PLtFneMAHjOwQt
        4wfYTB2fMmCG3SKLQ
X-Received: by 2002:adf:dec3:: with SMTP id i3mr28665797wrn.691.1643904106222;
        Thu, 03 Feb 2022 08:01:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw9SfqXirepul5gLwDUixFMBJNayDhnQP+30f7/g9Cnw7QZcFPPw05rFnQ5sAqfDfYe8mAXOw==
X-Received: by 2002:adf:dec3:: with SMTP id i3mr28665780wrn.691.1643904105989;
        Thu, 03 Feb 2022 08:01:45 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id n13sm19632812wrv.94.2022.02.03.08.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:01:45 -0800 (PST)
Message-ID: <0d270dc73553e5deb1a195f4ae84f2795eb1b167.camel@redhat.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Date:   Thu, 03 Feb 2022 17:01:44 +0100
In-Reply-To: <20220203015140.3022854-10-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
         <20220203015140.3022854-10-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, MAX_SKB_FRAGS value is 17.
> 
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.
> 
> But with zero copy, we use order-0 pages.
> 
> For BIG TCP to show its full potential, we increase MAX_SKB_FRAGS
> to be able to fit 45 segments per skb.
> 
> This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> does not support skbs with frag list.
> 
> We have used this MAX_SKB_FRAGS value for years at Google before
> we deployed 4K MTU, with no adverse effect.
> Back then, goal was to be able to receive full size (64KB) GRO
> packets without the frag_list overhead.

IIRC, while backporting some changes to an older RHEL kernel, we had to
increase the skb overhead due to kabi issue.

That caused some measurable regressions because some drivers (e.g.
ixgbe) where not able any more to allocate multiple (skb) heads from
the same page. 

All the above subject to some noise - it's a fainting memory.

I'll try to do some tests with the H/W I have handy, but it could take
a little time due to conflicting scheduling here.

Thanks,

Paolo

