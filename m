Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4AB5F00E3
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 00:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiI2WqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 18:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiI2Wpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 18:45:32 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F070AA1D71
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:44:19 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id o7so1801764qkj.10
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=C8DTd2XhXBNZr294MgnTSdwSZ5YY3MfsdGTuFVgv+kI=;
        b=e9dKVvc0osew5bBdyDEQo1sEwpgI/YDAwDNQpmHgwEDmdPGv83nyM8BdK34Ourcono
         Z0xsyYYY4VwJcXlzAwgI8E0TcNTBkL9xfuUFvejR2hLiOy72U/44unRE0a5WnWBVk9mX
         VQht2bO6oc3lQ/wh8k+V7/zREQgmOQHmK5JrH2PmfQXj8R3wv+uSaigJmnKsbfxF/1rV
         de2hPUPHVFiBqILMdezt3d09LSpu83bfrzwE403Ay1HJ1tprTI90MWWyK5SXIr7HeBRV
         r+Q4c0mp1hJfj5iGPtB92SyKuyWv4u0DFGKcamNOa+5WCTpETZlVbS66kHM/1bc/1mG4
         2t/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=C8DTd2XhXBNZr294MgnTSdwSZ5YY3MfsdGTuFVgv+kI=;
        b=gGladXZMCUCbPvofmwGaCuijr9y3heHaXeXnT9sx/PNjGMR+AEMd+dfMCOks4WFTmh
         pD9ySBP5wst6Cn8wRswQiBxscdgLU/lFgraCWkFFc1vaEMaYCffrHUFatoS/P3OoZ/FE
         q0yC8Nf97KYTl6h7B6VAZc0YGX+O8n+0AbtKT2BBvTK3LTHXQ33S7NwJJ4eAnoxeFUdT
         rn9rB6Z7v4ZpVMxLkj+4ZCg48MsqUC+nn2gz8uHiAiuU9MwNj+KTNtrW3CgY2mkvgggk
         G54AhVwDYT4jzYqO7jd8HKCW9X0wX3ZQT3bY4b/5RNU48NjKHadrKPfXnoRPi0M0u6eU
         ZGEQ==
X-Gm-Message-State: ACrzQf3IaWouBSyDL6PzD1MaaxiedfW+kPrCUnK074Pr4FjNZ5bQSIbZ
        KPRoFR0u7hf92rJymNxGNnGP/A==
X-Google-Smtp-Source: AMsMyM6VJOyIz8dOkvahjOryfEaqRLhxojgMv+zbUJavpUSClpFuNSd88Ov6gTWf2XhVvLMF706/OA==
X-Received: by 2002:a05:620a:1aa8:b0:6ce:3dd7:7b46 with SMTP id bl40-20020a05620a1aa800b006ce3dd77b46mr4032945qkb.575.1664491458980;
        Thu, 29 Sep 2022 15:44:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id x22-20020a05620a259600b006cf9084f7d0sm765631qko.4.2022.09.29.15.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1oe2GP-0040cX-Ko;
        Thu, 29 Sep 2022 19:44:17 -0300
Date:   Thu, 29 Sep 2022 19:44:17 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Rohit Sajan Kumar <rohit.sajan.kumar@oracle.com>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Srinivas Eeda <srinivas.eeda@oracle.com>
Subject: Re: [PATCH] IB/mlx5: Add a signature check to received EQEs and CQEs
Message-ID: <YzYfwXtLceoEw0qo@ziepe.ca>
References: <1663974295-2910-1-git-send-email-rohit.sajan.kumar@oracle.com>
 <BYAPR10MB29977D4DCA235EE5F91EFF29DC579@BYAPR10MB2997.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR10MB29977D4DCA235EE5F91EFF29DC579@BYAPR10MB2997.namprd10.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 04:25:32PM +0000, Rohit Sajan Kumar wrote:
>    Hey,
> 
>    Pinging everyone as a gentle reminder to review the patch sent upstream
>    last week.

It is not in patchworks or the mailing list, you will have to resend
it.

Jason
