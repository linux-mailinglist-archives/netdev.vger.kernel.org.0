Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1855006C4
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 09:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbiDNHR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 03:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiDNHR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 03:17:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16DA527B0D
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649920533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=79kwX/RNU1YRXLJoHZACrxSzp6IRarRrMnUl7UIT+nc=;
        b=T3YNoF7XHhwx2CTctXv5ikcJ3bXPujVwCsa7PW3J1eSbBxE0JQaUzk3uxP2U0ar9KSAcel
        vwAgqlIFR86ej11PseqeyRmCL2Zphc7mZU/yEfeIuGXFyYVCkSYrp5cvGGpqZsbVI8EUnn
        3Gz2+XJJmUbBpkIEK2EAT3vJ75qWno0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-bKU5EKujMyeBhJEaGu98hw-1; Thu, 14 Apr 2022 03:15:31 -0400
X-MC-Unique: bKU5EKujMyeBhJEaGu98hw-1
Received: by mail-wm1-f69.google.com with SMTP id h18-20020a05600c351200b0038e82e6321bso2003369wmq.5
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=79kwX/RNU1YRXLJoHZACrxSzp6IRarRrMnUl7UIT+nc=;
        b=DhFb4L0ulraDqv/L827fVyB4pY5FsCZPdHQ7U3nfc7+AJ+8GRnkvUGIHTH0v26VmGF
         pR4jetVky7wP/YJiehA6N3hGczkGPIv+5xRNVGXcqkZf9AdL7rMZW69cq+yO2w5x8qf3
         ifvxlO2X5wEPMX/e/z0nHfZbWo2CtTjqIt40AlWd5BhVSckO1AUa9IQz+ETLQ6QePrR3
         g77pwY0vDyN94urpXXGKjO0JfNsK3G7+F23sEmIrctZ6aaJz2ZhmkbrrlI0m6NUNOe44
         iHt1hbhLpbbbmQSd1BZcjlJi973DrT5uT4yjMXrfBwrrHwQHEGG1I3N6FEQq4aOYNBaT
         c1ZA==
X-Gm-Message-State: AOAM530J47xu5ujMmxm3/PVP0vIc/QGyKLI0oTDQYmOVFm6KpZiKvdAF
        EUIoZTHmbEnnzYGMmXRLfTtsx6RUlyXsqvrTbDSXEVH8NY5lHBu3mGEcf5L3N3eyMYCb08cwtfj
        AiiBkFAODHqJplv+M
X-Received: by 2002:a1c:f604:0:b0:38c:8ffd:dbb6 with SMTP id w4-20020a1cf604000000b0038c8ffddbb6mr2231557wmc.43.1649920530757;
        Thu, 14 Apr 2022 00:15:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCPTdyrfTscflJP3w/3vmjoolU6cKkX1iKfSQEVtiea+ko2V17NzcNLnJcgoaTRavULDlNRA==
X-Received: by 2002:a1c:f604:0:b0:38c:8ffd:dbb6 with SMTP id w4-20020a1cf604000000b0038c8ffddbb6mr2231544wmc.43.1649920530547;
        Thu, 14 Apr 2022 00:15:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c154900b0038cb98076d6sm1208781wmg.10.2022.04.14.00.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 00:15:30 -0700 (PDT)
Message-ID: <53a984cb43cdeaa20a7f5416e970b28813b72779.camel@redhat.com>
Subject: Re: [PATCH] net: bcmgenet: Revert "Use stronger register
 read/writes to assure ordering"
From:   Paolo Abeni <pabeni@redhat.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pbrobinson@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Date:   Thu, 14 Apr 2022 09:15:29 +0200
In-Reply-To: <3f4972d1-ace1-0260-16e6-84fd0f475273@gmail.com>
References: <20220412210420.1129430-1-jeremy.linton@arm.com>
         <3f4972d1-ace1-0260-16e6-84fd0f475273@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-04-13 at 10:00 -0700, Florian Fainelli wrote:
> 
> On 4/12/2022 2:04 PM, Jeremy Linton wrote:
> > It turns out after digging deeper into this bug, that it was being
> > triggered by GCC12 failing to call the bcmgenet_enable_dma()
> > routine. Given that a gcc12 fix has been merged [1] and the genet
> > driver now works properly when built with gcc12, this commit should
> > be reverted.
> > 
> > [1]
> > https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105160
> > https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=aabb9a261ef060cf24fd626713f1d7d9df81aa57
> > 
> > Fixes: 8d3ea3d402db ("net: bcmgenet: "Use stronger register read/writes to assure ordering")

For the records, there is a small typo in the above tag, I'll fix it
while applying the patch. No need to repost it.

Cheers,

Paolo

