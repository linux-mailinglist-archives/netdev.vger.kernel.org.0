Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7B26672EF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 14:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbjALNJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 08:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjALNJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 08:09:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A224FD53
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673528938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nCRS/MpkyPeaVrlVLdkBcx6JcO4jj78Pqfq4rjjeatI=;
        b=dSP+GfkcK+FNkoMF7B0v8fqIVbBug4pISHwTK4HMHzDYVFW865TaazM5pBpmOhduo1ju0x
        sPqrhWC+4cWmoiyCr27a+JSND5sb9bPveZPj5z8cMLXdMNXpEwqGal7LFG/26anDh/HKj9
        zbmkqYjvevh5Owku1SG3AW0ecewdyGc=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-197-ZLWBJtzZNkSjpQMae58-PQ-1; Thu, 12 Jan 2023 08:08:57 -0500
X-MC-Unique: ZLWBJtzZNkSjpQMae58-PQ-1
Received: by mail-yb1-f197.google.com with SMTP id i17-20020a25bc11000000b007b59a5b74aaso19067493ybh.7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:08:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nCRS/MpkyPeaVrlVLdkBcx6JcO4jj78Pqfq4rjjeatI=;
        b=hTaHH8DMK0s4jFgtuMcxwczZ4YGArvaVLDWyn1dtGznQv+Mi3PrcZFlyYKkS2NJmcH
         x4JLXxRyHgv6Gc5u6KtHHMeuH4P4VV3eG4pbX5aYVJUosCUIy7R5kOm2H2QERebC77MD
         1cMrDazY+hZdO581rtZZXsfu6uLwoSJkJ3NkXxlhpNayvfmgGpY462Dzi3wpmPSd+qcV
         uCDBWQ+mBiCSx8EFNYKt5qVp8F1jBo7OqOAgxakJ9Xb2pdzJcPkoaNKew5onut5eWc9e
         woo/1D2SsBfuc3encJIp4SAEJoFozwmedxaOZzoiJj0a6M+eCieF/4xq/big2MdagnI2
         Aohw==
X-Gm-Message-State: AFqh2krBKh/rv/6ltDbx7CEH5XCWgKocnEPg4qRM1eOaj/wDsrTlya9X
        L9Qb3VvmA3+ZKwRaE/1pr5eMY353AsC5pTsgcmuxOMZ4ZxUU66uNQYh8BqEsJDRE2o8PHL8YXm0
        c1jekjMmEW1PB4+YM
X-Received: by 2002:a05:7500:16cc:b0:f0:4692:cc0 with SMTP id ce12-20020a05750016cc00b000f046920cc0mr1298086gab.28.1673528937048;
        Thu, 12 Jan 2023 05:08:57 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtVkkADuVZjTJe4BA/F7Hbb10OyHI3PlW0oPb18BdiV3GHvC5tzK1mPBMMc0FP3iW/BXGLyqQ==
X-Received: by 2002:a05:7500:16cc:b0:f0:4692:cc0 with SMTP id ce12-20020a05750016cc00b000f046920cc0mr1298060gab.28.1673528936660;
        Thu, 12 Jan 2023 05:08:56 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-183.dyn.eolo.it. [146.241.113.183])
        by smtp.gmail.com with ESMTPSA id j9-20020a05620a288900b006f9f714cb6asm10549640qkp.50.2023.01.12.05.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 05:08:56 -0800 (PST)
Message-ID: <bd39d0ffec879ccff7bff79f9ff16a727a3f8301.camel@redhat.com>
Subject: Re: [PATCH net-next] r8152: add vendor/device ID pair for Microsoft
 Devkit
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Thu, 12 Jan 2023 14:08:53 +0100
In-Reply-To: <20230112115659.27fb453d@donnerap.cambridge.arm.com>
References: <20230111133228.190801-1-andre.przywara@arm.com>
         <20230111213143.71f2ad7e@kernel.org>
         <20230112105137.7b09e70b@donnerap.cambridge.arm.com>
         <4c48269962dafbb641d5b0c38ec5b7bf951f3b4d.camel@redhat.com>
         <20230112115659.27fb453d@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-12 at 11:56 +0000, Andre Przywara wrote:
> On Thu, 12 Jan 2023 12:39:01 +0100
> Paolo Abeni <pabeni@redhat.com> wrote:
> 
> Hi,
> 
> > On Thu, 2023-01-12 at 10:51 +0000, Andre Przywara wrote:
> > > On Wed, 11 Jan 2023 21:31:43 -0800 Jakub Kicinski <kuba@kernel.org> wrote:  
> > > > Hm, we have a patch in net-next which reformats the entries:
> > > > ec51fbd1b8a2bca2948dede99c14ec63dc57ff6b
> > > > 
> > > > Would you like this ID to be also added in stable? We could just 
> > > > apply it to net, and deal with the conflict locally. But if you 
> > > > don't care about older kernels then better if you rebase.  
> > > 
> > > Stable would be nice, but only to v6.1. I think I don't care
> > > about older kernels.
> > > So what about if I resend this one here, based on top of the reformat
> > > patch, with a:
> > > Cc: <stable@vger.kernel.org> # 6.1.x
> > > line in there, and then reply to the email that the automatic backport
> > > failed, with a tailored patch for v6.1?
> > > Alternatively I can send an explicit stable backport email once this one
> > > is merged.  
> > 
> > Note that we can merge this kind of changes via the -net tree. No
> > repost will be needed. We can merge it as is on -net and you can follow
> > the option 2 from the stable kernel rules doc, with no repost nor
> > additional mangling for stable will be needed.
> > 
> > If you are ok with the above let me know.
> 
> That sounds good to me, but that will then trigger a merge conflict when
> net-next (with the reformat patch) is merged? I guess it's easy enough to
> solve, but that would be extra work on your side. If you are fine with
> that, it's OK for me.

Fine by us (well, probably poor Jakub will end-up handling the
conflict, but AFAIK he is ok with this specific case).

I'll merge the patch on net.

Cheers,

Paolo

