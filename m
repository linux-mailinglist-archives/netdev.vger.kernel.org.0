Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC50F5018BC
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiDNQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbiDNQen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:34:43 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C1729B
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:03:29 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id e10so4214743qka.6
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=njJ39hXFVyYFaNpbgdYVxy+jJnmwF0W+GazXpoirucs=;
        b=ViEMDjKh6Z/RKKY+ZNb7BIOVoyiLXGMa5ox0G6pht1JkB3YKpx9gvos0yTLMdW70GC
         y3VMDD0QR76WgYPJ4mtHCte3zHS4cNSHlSMkb6srGpPQNSyYPxi3AXsCCJOJI6BzzpqJ
         vqu28aPCNIlag+PI/amI4nKjHHqDFpwK0GyLY5iRDdrreXYFewWGN/d70MhTxXqHejDL
         4cwSiNj8GhLSdXD8CKY8nF6uUaL90FhA/rmmoTRATkP15U8347mACXIqLyicEj48jZv7
         U34lmi+0KFLd4u+PbybtQk/u73/q4aMYtfCtGLR6wggtanO5EfD7Zf07jsPytl6h6TwU
         +/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=njJ39hXFVyYFaNpbgdYVxy+jJnmwF0W+GazXpoirucs=;
        b=VH+MisXBesU0FdR/s1LmDHdIrQimzoVOtDqxe3n3mCG1VaQl9s2YJsg83ootSKI4Ue
         rx03waoEaLanAXQ7mmCupWs/M+cIw3L1p+UN67MiqqeCsVf1ANjuIOw6k5qPLFfyinID
         0dhPesK9Yjk9/hHWyryw9Nqq1wne100Ak7db1Bi3eesAG0UYIvlHUzeFPbefs7EmWjbf
         aXAuLNsQ8eWVT2M/WYbgznwS9z2rMEabWiTRcjmrH15SxonidIaBSu4F99+SfyJSGY/a
         OeCtTtK72rC5Q7aD7azD+o/II+RblumgdxnwSOBMBGiYHovy1dhiv3TIxHMY/Pg9xeVS
         34WA==
X-Gm-Message-State: AOAM5300N7NPCinE/U8F+nfs0JS3CuXUy/Yc+q+2AvcNDssnFVKvP3Jg
        vJZitTlOn8f9zOkS2Zmr8q1M/g==
X-Google-Smtp-Source: ABdhPJx8ZkN5CA8JJ7EMdz1Cg20pG+sbJEw4g76ltUEnDHXauIQ1XR4gHjIKczioSCS4maadlPRoRg==
X-Received: by 2002:a05:620a:9d3:b0:69c:1268:c249 with SMTP id y19-20020a05620a09d300b0069c1268c249mr2326095qky.40.1649952208554;
        Thu, 14 Apr 2022 09:03:28 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-25-174-95-97-66.dsl.bell.ca. [174.95.97.66])
        by smtp.googlemail.com with ESMTPSA id w10-20020a05620a424a00b00680c0c0312dsm1215716qko.30.2022.04.14.09.03.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 09:03:27 -0700 (PDT)
Message-ID: <05a27957-ffab-093e-1448-3d32ce2e8cfb@mojatatu.com>
Date:   Thu, 14 Apr 2022 12:03:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net 2/2] net/sched: cls_u32: fix possible leak in
 u32_init_knode()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220413173542.533060-1-eric.dumazet@gmail.com>
 <20220413173542.533060-3-eric.dumazet@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20220413173542.533060-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-04-13 13:35, Eric Dumazet wrote:
> From: Eric Dumazet<edumazet@google.com>
> 
> While investigating a related syzbot report,
> I found that whenever call to tcf_exts_init()
> from u32_init_knode() is failing, we end up
> with an elevated refcount on ht->refcnt
> 
> To avoid that, only increase the refcount after
> all possible errors have been evaluated.
> 
> Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
> Signed-off-by: Eric Dumazet<edumazet@google.com>
> Cc: Jamal Hadi Salim<jhs@mojatatu.com>
> Cc: Cong Wang<xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko<jiri@resnulli.us>


Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>


cheers,
jamal
