Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716204C8E9E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbiCAPKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbiCAPKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:10:15 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F184160CCB
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:09:33 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id bg16-20020a05600c3c9000b00380f6f473b0so1434352wmb.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:09:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SLgwhPj+Eciro4vG6Y8vZraEdKRQYG6EQazsWzzC2tM=;
        b=l1COxuCXa0h4UJikmXU7PqYNWZ2wVK162IX4HxO+JcML/GTUYj2wOpE8Hd2Hv5Zt2B
         ORVWc/QcaK36gs2vfLI6x/8+C14OhAFGeBotfOYOq8cExFdZ5IiOkVeOE8swDeiVVSAx
         5sne4GwRZjM3bsJRoeGFU+hYFUllWa53rci8Mgv47Dj9SPvzNqImmc9n9Wvl5iZ47O1y
         2xhNXuEgdchMHQQiv0fAs2dcVwnDNimrdZPu7YtqToxLov1xt+x4/w8OZO1O6xKCrBT9
         mE4Cr+XdzHxFPUtjhcaujN8XTcY3FMbCFqiIlIjIDHulc5FY6y7iOD77pF9CUXJNs2NK
         S1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SLgwhPj+Eciro4vG6Y8vZraEdKRQYG6EQazsWzzC2tM=;
        b=YvnAaDke10XaL+Nde5/QGKo+0TK57YWNEHGrTqPZUTPoFJCzCbQ2INaGsr7kTMzdpk
         +taV66QpaxmUZFwdILkO3Oan8H5VkVNZZD+cLYKEXDolZU0lHVQH0PHin/y4WGgzJEAa
         HRWjUXI2+8Urjmc0t8cHR351cEdQ3Vc19pw9r3hWCNJlKt8lkAwdwrcxlvKTJJq80ygP
         kXj/wVvwVMUGf8C9sXacGvFcvS5oD9Nz2p3STPgRBgfykqUUlSqoj8QtDsJBcgs7U7uA
         jt8OM1Ul2tG9pImxzns7hYZVpffpOByKT7UPILaNyTSVJ5Q4uoAWaGGLgqQneT5IZ8JK
         Jkrg==
X-Gm-Message-State: AOAM532vOW98glDbDz6lurHyhWC3mtslaRjbEvN4dg5zNXQBANbvTl35
        RX3HFx6S9fpes7XIcO701mQk
X-Google-Smtp-Source: ABdhPJxb7BaX9vcO/81T2LlTTeeVBe9IUOFFchOh9Xlh0PU2sBHwaYqjoLLrLTh5KgzoGfsE0BCRUw==
X-Received: by 2002:a05:600c:1592:b0:381:21b4:d1d8 with SMTP id r18-20020a05600c159200b0038121b4d1d8mr17679174wmf.119.1646147372497;
        Tue, 01 Mar 2022 07:09:32 -0800 (PST)
Received: from Mem (2a01cb088160fc00891d7b76bd72bf13.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:891d:7b76:bd72:bf13])
        by smtp.gmail.com with ESMTPSA id o3-20020a1c7503000000b0038100e2a1adsm2659213wmc.47.2022.03.01.07.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 07:09:32 -0800 (PST)
Date:   Tue, 1 Mar 2022 16:09:30 +0100
From:   Paul Chaignon <paul@cilium.io>
To:     Eyal Birger <eyal.birger@gmail.com>, kailueke@linux.microsoft.com
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
Message-ID: <20220301150930.GA56710@Mem>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
 <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
 <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
 <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 04:34:52PM +0200, Eyal Birger wrote:
> Hi Kai,
> 
> On Tue, Mar 1, 2022 at 4:17 PM Kai Lüke <kailueke@linux.microsoft.com> wrote:
> >
> > Hi,
> > > Whereas 8dce43919566 ("xfrm: interface with if_id 0 should return error")
> > > involves xfrm interfaces which don't appear in the pull request.
> > >
> > > In which case, why should that commit be reverted?
> >
> > Correct me if I misunderstood this but reading the commit message it is
> > explicitly labeled as a behavior change for userspace:
> >
> >     With this commit:
> >      ip link add ipsec0  type xfrm dev lo  if_id 0
> >      Error: if_id must be non zero.
> >
> > Changing behavior this way is from my understanding a regression because
> > it breaks programs that happened to work before, even if they worked
> > incorrect (cf. https://lwn.net/Articles/726021/ "The current process for
> > Linux development says that kernel patches cannot break programs that
> > rely on the ABI. That means a program that runs on the 4.0 kernel should
> > be able to run on the 5.0 kernel, Levin said.").
> 
> Well to some extent, but the point was that xfrm interfaces with if_id=0
> were already broken, so returning an error to userspace in such case
> would be a better behavior.
> So I'm not sure this is a regression but it's not up to me to decide these
> things.

I agree with Eyal here.  As far as Cilium is concerned, this is not
causing any regression.  Only the second commit, 68ac0f3810e7 ("xfrm:
state and policy should fail if XFRMA_IF_ID 0") causes issues in a
previously-working setup in Cilium.  We don't use xfrm interfaces.

Paul
