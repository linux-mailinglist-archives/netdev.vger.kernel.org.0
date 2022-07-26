Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3A65813C2
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233735AbiGZNEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 09:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiGZNEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 09:04:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0E5015FF7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658840678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ng3ARwb4GnfMbmjqa/1DrhGDO96AEC/0FfJ3u66wyT4=;
        b=VjAn08eYUGoe6sM3SUVyKni2GCJlr5pz/DSDgAbSlfr9mA504/p181EZtAnclLYn8ceDO2
        C0RBUw7+r5WV0Tn8u5s9sbjMxFaPKhfr2IpdYkYT0Ee0jCD3egc324Yn4ivZ3F1YAcyAEl
        gQXIbde+OG2Www9boWYqB+DzyGDBHkw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-f0imbdOuN1GT70qXfQ2aoA-1; Tue, 26 Jul 2022 09:04:37 -0400
X-MC-Unique: f0imbdOuN1GT70qXfQ2aoA-1
Received: by mail-qv1-f69.google.com with SMTP id od8-20020a0562142f0800b004744dccb0caso3341930qvb.16
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 06:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ng3ARwb4GnfMbmjqa/1DrhGDO96AEC/0FfJ3u66wyT4=;
        b=fnSgNmolg0YtWiZ05404W0Q3z37MQRkb8OqfdrhaErS78KXtdmXFBxHjHSJKAlhU01
         bAQtMgWy4JfZ7lniR/nwsr4I8hbVPYVJiQqv90lrUDMOCPHB9pFs9irV6qQcquWhlo7d
         UmUZQkPeGDI8SXZdsZk7+x1+EsJaMcn+LLerwgPwJy6c0c7/u9q+kWibGpsY/OdD8SaC
         F8ipM4qTJ/Kfz0Ye5pdwkgmwMDrfJ95hrqt3Bp/rAIcMj6OCZEfFuN1iAMZ1cDFS5lhr
         MHXfI8K7YOTrXowOLcEvVAMwbwVNmWkVv/KPGjdftRBQpYf6kkO341dYgBb0IPn+q/Sj
         iTLw==
X-Gm-Message-State: AJIora9OXOKk5NaHDjJfOeetU+IbptR56+f/PKK6YQOL7BTQYBptiRVh
        oSRUajJTQPGO1y4gYZ/BFTPwrc75NglFnvjpbNTkbd3OPsPtTMFyAmPHmYoMWpLwDAWL6tKb02/
        qdtFYKWZDHgWo96Qc
X-Received: by 2002:a05:620a:1907:b0:6a6:2fac:462f with SMTP id bj7-20020a05620a190700b006a62fac462fmr12150477qkb.213.1658840676698;
        Tue, 26 Jul 2022 06:04:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tTrP1uKsJWFKd90WkpGe9ZZ9/mYpIYrTiq4unT5TQ1aRVZKHElDJkoR1OYPQf1E2hWMo1xrQ==
X-Received: by 2002:a05:620a:1907:b0:6a6:2fac:462f with SMTP id bj7-20020a05620a190700b006a62fac462fmr12150408qkb.213.1658840676012;
        Tue, 26 Jul 2022 06:04:36 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id d21-20020ac85ad5000000b0031ea1ad6c5asm9637660qtd.75.2022.07.26.06.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 06:04:35 -0700 (PDT)
Message-ID: <9fe0a59f83eaf63659cfd33600945f0886698c77.camel@redhat.com>
Subject: Re: [net PATCH 1/2] octeontx2-pf: cn10k: Fix egress ratelimit
 configuration
From:   Paolo Abeni <pabeni@redhat.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, sgoutham@marvell.com, netdev@vger.kernel.org
Date:   Tue, 26 Jul 2022 15:04:32 +0200
In-Reply-To: <1658650874-16459-2-git-send-email-sbhatta@marvell.com>
References: <1658650874-16459-1-git-send-email-sbhatta@marvell.com>
         <1658650874-16459-2-git-send-email-sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-07-24 at 13:51 +0530, Subbaraya Sundeep wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
> 
> NIX_AF_TLXX_PIR/CIR register format has changed from OcteonTx2
> to CN10K. CN10K supports larger burst size. Fix burst exponent
> and burst mantissa configuration for CN10K.
> 
> Also fixed 'maxrate' from u32 to u64 since 'police.rate_bytes_ps'
> passed by stack is also u64.
> 
> Fixes: e638a83f167e ("octeontx2-pf: TC_MATCHALL egress ratelimiting offload")
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>

I wrongly applied this series to net-next due to PEBKAC here. I'm going
to rever it and apply to net.

I'm sorry for the confusion,

Paolo

