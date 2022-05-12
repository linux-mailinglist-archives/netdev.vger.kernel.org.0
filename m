Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8E5246D5
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 09:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350942AbiELHXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 03:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350867AbiELHWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 03:22:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5903F69723
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652340172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kseTB5nEdb0NBMdde4rHbkMWqkdFBH/zYnlVhau93BU=;
        b=ahcR3uv0SqRmdd2vBNlXfaR9kqK01uZx66qaMDyhaB5ZGI6tHEdrFCy+hbeZV6LGE3n8Y7
        nClHpV8yQZEvCwz+p9h5RqdvIJBGDwDfVTOzu9P7ocQLwD0GC76PXnlkY3Qlt/F+hincwv
        G8JBDkoexmki9XaJ4w6+VTYfYdGoKfg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-c6E2U9rGPlyKtEwMXXXieg-1; Thu, 12 May 2022 03:22:51 -0400
X-MC-Unique: c6E2U9rGPlyKtEwMXXXieg-1
Received: by mail-wm1-f70.google.com with SMTP id v191-20020a1cacc8000000b0038ce818d2efso1292190wme.1
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:22:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=kseTB5nEdb0NBMdde4rHbkMWqkdFBH/zYnlVhau93BU=;
        b=LN6fiIFRfNqLhYVAHn+/WEcNmU/9KWpDDHGxMDUbdfOGMSSF2xLaJitQxvX//NK9Nq
         l3X49Dp3lNFzrpqu0UXmwMmjjH+uKrBN/gL/nMiGK664V+mOxNT37ruQ/YjTCkpyLChS
         qcPY7SJ9kAgF49Gu8SfzITKGp4x7IdBqPvAhwxpaa+vtg+GENsoPWxascseie5d/xblv
         zlQ25dQG5DhQAI9C+anL7OSrfYzv7GdoukQEhXgWtQyq15n3kd8FpHTQb/UZ23y0WriM
         H5SzoaoV/LXDAdcRVl7iSi6nQdGKQHwtvZEApPuIWMg2tf5h8CRNeWyoNLdjskYOipct
         rLAA==
X-Gm-Message-State: AOAM530/4NYm+ZigCuDHlugBr7ga1RDPk7/v5h+ULdJmi0c53Vc7Nd+l
        4ust19nvbEpGRFDQDEmvhLqe3+8FLlGXbZIfioeayKUhAQI6jt+mAqeaTi0tbxwU5cIhvU1NCTB
        LTU0SqeqVV94teoCK
X-Received: by 2002:a05:600c:5008:b0:394:533c:54a1 with SMTP id n8-20020a05600c500800b00394533c54a1mr8661637wmr.15.1652340169935;
        Thu, 12 May 2022 00:22:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfDIyJS163A7troAixDhGyY3D0Z1myKH8iDS+VN/nsVAAT0KBLGPCXQS7L9r7bFwizbHtLgA==
X-Received: by 2002:a05:600c:5008:b0:394:533c:54a1 with SMTP id n8-20020a05600c500800b00394533c54a1mr8661622wmr.15.1652340169675;
        Thu, 12 May 2022 00:22:49 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id r5-20020adfdc85000000b0020c5253d8d2sm3279125wrj.30.2022.05.12.00.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 00:22:49 -0700 (PDT)
Message-ID: <dd7641f326b63211c3a749341e905cca90c9e124.camel@redhat.com>
Subject: Re: [PATCH v2]  drivers: net: vmxnet3: fix possible NULL pointer
 dereference in vmxnet3_rq_cleanup()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Zixuan Fu <r33s3n6@gmail.com>, doshir@vmware.com,
        pv-drivers@vmware.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
Date:   Thu, 12 May 2022 09:22:48 +0200
In-Reply-To: <20220510131727.929547-1-r33s3n6@gmail.com>
References: <20220510131727.929547-1-r33s3n6@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-10 at 21:17 +0800, Zixuan Fu wrote:
> In vmxnet3_rq_create(), when dma_alloc_coherent() fails, 
> vmxnet3_rq_destroy() is called. It sets rq->rx_ring[i].base to NULL. Then
> vmxnet3_rq_create() returns an error to its callers mxnet3_rq_create_all()
> -> vmxnet3_change_mtu(). Then vmxnet3_change_mtu() calls 
> vmxnet3_force_close() -> dev_close() in error handling code. And the driver
> calls vmxnet3_close() -> vmxnet3_quiesce_dev() -> vmxnet3_rq_cleanup_all()
> -> vmxnet3_rq_cleanup(). In vmxnet3_rq_cleanup(), 
> rq->rx_ring[ring_idx].base is accessed, but this variable is NULL, causing
> a NULL pointer dereference.
> 
> To fix this possible bug, an if statement is added to check whether 
> rq->rx_ring[0].base is NULL in vmxnet3_rq_cleanup() and exit early if so.
> 
> The error log in our fault-injection testing is shown as follows:
> 
> [   65.220135] BUG: kernel NULL pointer dereference, address: 0000000000000008
> ...
> [   65.222633] RIP: 0010:vmxnet3_rq_cleanup_all+0x396/0x4e0 [vmxnet3]
> ...
> [   65.227977] Call Trace:
> ...
> [   65.228262]  vmxnet3_quiesce_dev+0x80f/0x8a0 [vmxnet3]
> [   65.228580]  vmxnet3_close+0x2c4/0x3f0 [vmxnet3]
> [   65.228866]  __dev_close_many+0x288/0x350
> [   65.229607]  dev_close_many+0xa4/0x480
> [   65.231124]  dev_close+0x138/0x230
> [   65.231933]  vmxnet3_force_close+0x1f0/0x240 [vmxnet3]
> [   65.232248]  vmxnet3_change_mtu+0x75d/0x920 [vmxnet3]
> ...
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>

Same remarks here, please provide a new version with a suitable fixes
tag, thanks!

Paolo

