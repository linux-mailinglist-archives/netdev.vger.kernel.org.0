Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B13E698113
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBOQkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBOQkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:40:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E0A213C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676479173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IOpW2pToLbb19g+Edc0IdmB1Z2NNyNsORJ71Ae1vdjY=;
        b=e9PCMThkiVJXMwhaveJrdIqvHHRfppUlcaUqpYi1/rpwoMr2LcdPHTNl7xjLbnh7Wd45fZ
        Ao0fdDdTdKqFgG1aZmia62XyoxYbe6HeH9iEUG67QRQ8iEtR3+jgz1mdUn83ZtwMb8JubT
        +GoiHFM58GxfvI3JHZbb3bdWDORiT2I=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-169-Qn_br6gXMbijJ5UxUbx7OA-1; Wed, 15 Feb 2023 11:39:32 -0500
X-MC-Unique: Qn_br6gXMbijJ5UxUbx7OA-1
Received: by mail-pf1-f197.google.com with SMTP id cj18-20020a056a00299200b005a8e8833e93so2300719pfb.12
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:39:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IOpW2pToLbb19g+Edc0IdmB1Z2NNyNsORJ71Ae1vdjY=;
        b=3HSIJ0omZEfX3OvOKA0atCMd+fA3jtW82QS9DvRQAMcSg5r1lvFWhUX8qYkAa7x0Zq
         j7Sa5sM+kcs5aLLifGCg5VR4Lv95wZQg62Tef1ELMQfie+lICtF1jhq22j7jzAKd2hyI
         Ig2bqkjMgiGhlidoxCQkKLwdSpQ+9pFioDtwIteWWBLZ/OxUJZ3S0zW5l7UBHjNEDLSB
         cHvTr0OJhtVZiGEcl/vNq4whHBWqnmksvhXmqzK78PbKemwz/FsGcxawst25Y3GJ2DGy
         tYPff8pAsqC4vkDgSk+jigfuywZqTrF7viCenxeTjug0zgZWyRieUI+G23LMG6Qovr8a
         jXSg==
X-Gm-Message-State: AO0yUKXZWUQsnZwxJEeWiJgHEcHhzyhwoMSyRwHAS5VKn8AnWlrET2k9
        wjp9QF2TGmL4Dj5dBdayCNFCX2ETAAJfRXsYagQqFPEWnkhc/UK0Y2RSWm6wHUHMGm/ZxjfP3H1
        bk5c7SJqrmuVuYchw
X-Received: by 2002:a05:6a20:1ea3:b0:bc:9f82:93a6 with SMTP id dl35-20020a056a201ea300b000bc9f8293a6mr2083049pzb.7.1676479171505;
        Wed, 15 Feb 2023 08:39:31 -0800 (PST)
X-Google-Smtp-Source: AK7set87s3/OopGxbp+dxPJ30N0ZplbtCCAZgPj4qhzlnsoRAO6gzntErNlz9dx5Af/9I/IecVNhkQ==
X-Received: by 2002:a05:6a20:1ea3:b0:bc:9f82:93a6 with SMTP id dl35-20020a056a201ea300b000bc9f8293a6mr2083031pzb.7.1676479171146;
        Wed, 15 Feb 2023 08:39:31 -0800 (PST)
Received: from kernel-devel ([240d:1a:c0d:9f00:ca6:1aff:fead:cef4])
        by smtp.gmail.com with ESMTPSA id n15-20020aa78a4f000000b005a8a5be96b2sm6325557pfa.104.2023.02.15.08.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 08:39:30 -0800 (PST)
Date:   Thu, 16 Feb 2023 01:39:26 +0900
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
Message-ID: <Y+0Kvspkx4n2tWJQ@kernel-devel>
References: <20230212162623.2301597-1-syoshida@redhat.com>
 <Y+pPXOqfrYkXPg1K@debian>
 <Y+u7hGIAxhvyDG/2@kernel-devel>
 <Y+vATfTKLogXw+Ki@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+vATfTKLogXw+Ki@debian>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guillaume,

On Tue, Feb 14, 2023 at 06:09:33PM +0100, Guillaume Nault wrote:
> On Wed, Feb 15, 2023 at 01:49:08AM +0900, Shigeru Yoshida wrote:
> > Just one more thing.  I created this patch based on the mainline linux
> > tree, but networking subsystem has own tree, net.  Is it preferable to
> > create a patch based on net tree for networking patches?
> 
> Yes. Networking fixes should be based on the "net" tree:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git

Thanks.  I'll use the "net" tree for v3 patch.

> For more details about posting patches to netdev, you can check
> Documentation/process/maintainer-netdev.rst
> 
> Or the online version:
> https://kernel.org/doc/html/latest/process/maintainer-netdev.html

Got it.  I'll check that.

Anyway, I'll make v3 patch based on your feedback.

Thanks,
Shigeru

> 
> > Thanks,
> > Shigeru
> > 
> > > 
> > 
> 

