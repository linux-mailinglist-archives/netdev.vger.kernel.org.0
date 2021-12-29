Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE48480F28
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238476AbhL2DEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238473AbhL2DEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 22:04:22 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C13FC061574;
        Tue, 28 Dec 2021 19:04:22 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 8so17369344pgc.10;
        Tue, 28 Dec 2021 19:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kffRfZQBjo2QkXFfN5SOfmmmbXUemEpgFK4p11pRDTI=;
        b=GARzfUis3dPI13CgyGSEfRPvR2ApU4KHBIN4bJX5BmeNc2kZDj9IP6NJ81JVkE2i9D
         888bKc1C4GYWhX88GfaTSPuXUUu/rZiNa1+cx0tEU5xAi3Wk90adCfZEg5wfosPwiviH
         x3Kty8QBzrwDgAVfv+yzS3/2rMYHp/NY6QZ6gNITE0OR5z8I0QVrbNpnyy/LlmBVx1lE
         EVhqTlZ/+ai5GCUbksGYVciROHY590KiXHNk/Er8HTrS+3ULSNb3SxaTnGNM5OD0gOjf
         0jEW82LOfM80YQ3EbuMRhL/WgzaPNCiNfIoFcA5d+emJ8DzTzUq/N9swcvv27NfsWQwL
         3JNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kffRfZQBjo2QkXFfN5SOfmmmbXUemEpgFK4p11pRDTI=;
        b=YIfHvIL4dMViMZakKRt6uy9ReMpqiTerOjgKHlgJEiuN4QDlgPwaVB6aWlrfAdB1Gx
         mziemN/JobV1GFVGlTzsPIRAIBYPzQb6SjklPxzApXDFbuFih9lsvzpiFVA2HtPzDo7k
         h/a7U6DDSH0RNGuk41fL5wezuZR5DoLGaSvgQhUA1YyOLGig1mCsNOc6Egc1I2ylIB/I
         MgkV6OUioSyiGWTK+0dre58WQkik/zTsTb4X+msTomTh5mhDwU1XXQ7ZoR2w9Q29gY5S
         aYjluLDjXDyoyBAAv3mxH4Uy+Ih4w1PfjhyjPdmedOn0dCV4HQt8UsziNdelBlaQj92P
         UodA==
X-Gm-Message-State: AOAM533nyCjFju9o4MhyN/fe3D2heSJI4YmV3KgKVZAa3Zr9K9PFsgmL
        YsMI+RdtM30yG4rPJleMijaNSJ/INmaTffF8Mp4=
X-Google-Smtp-Source: ABdhPJxm7fEaeBCSNwiE3Jh9Swb/Omo0n8RRTRkpDgCorS1FaIiHAQD7sru+aIVUFlLjNhcGX4I6HGF4JWRXAHZg8hs=
X-Received: by 2002:a63:8f06:: with SMTP id n6mr21909673pgd.95.1640747061672;
 Tue, 28 Dec 2021 19:04:21 -0800 (PST)
MIME-Version: 1.0
References: <20211220155250.2746-1-ciara.loftus@intel.com> <CAJ8uoz2-jZTqT_XkP6T2c0VAzC=QcENr2dJrE5ZivUx8Ak_6ZA@mail.gmail.com>
 <PH0PR11MB479171AF2D4CE0B118B47A208E7C9@PH0PR11MB4791.namprd11.prod.outlook.com>
 <CAJ8uoz3HYUO_NK+GCHtDWiczp-pDqpk6V+f5X5KkAJqN70nAnQ@mail.gmail.com> <20211221122149.72160edc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211221122149.72160edc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 28 Dec 2021 19:04:10 -0800
Message-ID: <CAADnVQJFu+yvWu9D=mzJ45sF8ncGhfFFUg43Edg_Qzown3pRsg@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: Initialise xskb free_list_node
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Loftus, Ciara" <ciara.loftus@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 12:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Dec 2021 10:00:13 +0100 Magnus Karlsson wrote:
> > On Tue, Dec 21, 2021 at 9:32 AM Loftus, Ciara <ciara.loftus@intel.com> wrote:
> > > > Thank you for this fix Ciara! Though I do think the Fixes tag should
> > > > be the one above: 199d983bc015 ("xsk: Fix crash on double free in
> > > > buffer pool"). Before that commit, there was no test for an empty list
> > > > in the xp_free path. The entry was unconditionally put on the list and
> > > > "initialized" in that way, so that code will work without this patch.
> > > > What do you think?
> > >
> > > Agree - that makes sense.
> > > Can the fixes tag be updated when pulled into the tree with:
> > > Fixes: 199d983bc015 ("xsk: Fix crash on double free in buffer pool")
> >
> > On the other hand, this was a fix for 2b43470add8c ("xsk: Introduce
> > AF_XDP buffer allocation API"), the original tag you have in your
> > patch. What should the Fixes tag point to in this case? Need some
> > advice please.
>
> My $0.02 would be that if all relevant commits form a chain of fixes
> it doesn't matter much which one you put in the tag. To me your
> suggestion of going with 199d983bc015 makes most sense since from a
> cursory look the direct issue doesn't really exist without that commit.
>
> Plus we probably don't want 199d983bc015 to be backported until we
> apply this fix, so it'd be good if "Fixes: 199d983bc015" appeared in
> linux-next.
>
> You can always put multiple Fixes tags on the commit, if you're unsure.

It sounds that the fix should get into net and linus tree asap?
In such a case mabe take it into net directly?
