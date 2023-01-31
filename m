Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A87682A8F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjAaKaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjAaKaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:30:23 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96442E809
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:30:22 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-50aa54cc7c0so169489057b3.8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bMYE5nBFnIBCuwr+qirkxRcAoLvJp4scnBns3hs5MyQ=;
        b=y/oCEDQ0oH8fvfxSo7Tv0APKLQ9pdvPS3vGkM8V1sl7nxnwg7Yrq9CdDZpXF0eqCCZ
         rdZPuCOiDv1jFPqEDGDPvRc9hnZcQk1GoAML210qhdt0SH9c51TEjcl/4aiuw8Jdq67e
         XxZnCJbe4awWHLvuL9XteIZ91vDTE+WM2RY1eoiHxU7gRNAC4Y+JolZ+K/4U33R21NRW
         YN1BEQPvy3wcDg6O8jnEBsDZvLCAxKe1Y9DUtgN4DDwZbAna7JaY+lFPBEPQlCIw2Xq/
         wMw78xso8Bexh764FFp6LKBuMRNq9oXXiVXbn91KMi9Dd5M/oJFI2OsKYvZqnbC2FMfM
         aiQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bMYE5nBFnIBCuwr+qirkxRcAoLvJp4scnBns3hs5MyQ=;
        b=vGc+pRUC8i5W7Zf3fdXRP0TRZ+WqX3hQh4gj5kLSWn5wcodC1gWaPz/ZakQdFdcAUU
         y7IPvwwCEbUC2wga0eM5ckmICg93UuM+H+6V5vfxAiKb7/O/AVRMD3inEQNLikKwyJ12
         ymiIRHsrkluxLepYB12tlSGUXNSYyF9jmzke4IiEwZpeHF/RyORsjvu+cDVYnT7zogsz
         TmJyID5X1QdIVlS7//CCOmgTu1yMGb0K8uq75pYZl8HYCPXVWI35ayfTcQfoFtWgMmEq
         Y0GQwIrQyImeWmdlgQ+MT94zrZfnkquBvOCjblXfc1qKX2GNUsjYYb2ZIrwuq3C/tprk
         0q3w==
X-Gm-Message-State: AO0yUKXgKHvITNFNpW/dMn1nSUE1cQliGSe48J7x2ziG0vweFkATkjds
        NZLX4WkKDFMruokwWx1JJEv8JR1FObRV8bTKcB0yVA==
X-Google-Smtp-Source: AK7set8ZcO/6OarCxAKAKf4CMceRq9UkexmuZWiEslufCO7lTohFrmk3dSv61zpccWsQ2CFv8dhAYU3Q0N1/pgH1cts=
X-Received: by 2002:a81:ab53:0:b0:506:3a16:693d with SMTP id
 d19-20020a81ab53000000b005063a16693dmr3623392ywk.360.1675161021928; Tue, 31
 Jan 2023 02:30:21 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <CAM0EoMnBXnWDQKu5e0z1_zE3yabb2pTnOdLHRVKsChRm+7wxmQ@mail.gmail.com>
 <CA+FuTScBO-h6iM47-NbYSDDt6LX7pUXD82_KANDcjp7Y=99jzg@mail.gmail.com>
 <63d6069f31bab_2c3eb20844@john.notmuch> <CAM0EoMmeYc7KxY=Sv=oynrvYMeb-GD001Zh4m5TMMVXYre=tXw@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
 <63d85b9191319_3d8642086a@john.notmuch> <CAM0EoMk8e4rR5tX5giC-ggu_h-y32hLN=ENZ=-A+XqjvnbCYpQ@mail.gmail.com>
 <20230130201224.435a4b5e@kernel.org> <CAM0EoMkR0+5YHwnrJ_TnW53MAfTC2Y9Wq0WFcEWTq3V=P0OzAg@mail.gmail.com>
In-Reply-To: <CAM0EoMkR0+5YHwnrJ_TnW53MAfTC2Y9Wq0WFcEWTq3V=P0OzAg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 31 Jan 2023 05:30:10 -0500
Message-ID: <CAM0EoMmPbdZD7ZNn2UWKQWnWTnAnnWhdSQtq05PvejAz0Jfx9w@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 5:27 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On Mon, Jan 30, 2023 at 11:12 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 30 Jan 2023 19:26:05 -0500 Jamal Hadi Salim wrote:
> > > > Didn't see this as it was top posted but, the answer is you don't program
> > > > hardware the ebpf when your underlying target is a MAT.
> > > >
> > > > Use devlink for the runtime programming as well, its there to program
> > > > hardware. This "Devlink is NOT for the runtime programming" is
> > > > just an artificate of the design here which I disagree with and it feels
> > > > like many other folks also disagree.
> > >
> > > We are going to need strong justification to use devlink for
> > > programming the binary interface to begin with
> >
> > We may disagree on direction, but we should agree status quo / reality.
> >
> > What John described is what we suggested to Intel to do (2+ years ago),
> > and what is already implemented upstream. Grep for DDP.
> >
>
> I went back and looked at the email threads - I hope i got the right
> one from 2020.
>
> Note, there are two paths in P4TC:
> DDP loading via devlink is equivalent to loading the P4 binary for the hardware.
> That is one of the 3 (and currently most popular) driver interfaces
> suggested. Some of that drew

Sorry didnt finish my thought here, wanted to say: The loading of the
P4 binary over devlink drew (to some people) suspicion it is going to
be used for loading kernel bypass.

cheers,
jamal

> Second is runtime which is via standard TC. John's proposal is
> equivalent to suggesting moving the flower interface Devlink. That is
> not the same as loading the config.
>
> > IIRC my opinion back then was that unless kernel has any use for
> > whatever the configuration exposes - we should stay out of it.
>
> It does for runtime and the tc infra already takes care of that. The
> cover letter says:
>
> "...one can be more explicit and specify "skip_sw" or "skip_hw" to either
> offload the entry (if a NIC or switch driver is capable) or make it purely run
> entirely in the kernel or in a cooperative mode between kernel and user space."
>
> cheers,
> jamal
