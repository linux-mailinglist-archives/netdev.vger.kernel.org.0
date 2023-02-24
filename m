Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20456A1E53
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjBXPQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBXPQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:16:35 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00473E0AC
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:16:08 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-536c02c9dfbso281895057b3.11
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 07:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iZGYZYsc1e4Af5BJsbMi00xtVdBZVS7jpl0K9DlJm08=;
        b=u896Odlx4bC3cFYDF24r2BXhbpkiT3tTC6/SK1VxKf8qtIVqLFDEzBW1Z7xr/tGEe8
         2b0ziIbnGvQnJ5SNaVejfbw6Q7TJcmU90InyF2LuYQ2ZINWMJh+1w+qL4iFW0O68GxrX
         prK7EQev035emjZlOYw6pRXXafwOHLE1rGP+7Dzbpc5IxGLFStNIhPYUJjLBpwHJXCrY
         qBOkO/EhNgfPx3bpVNfwDGsyxjNMEkUVwB3OFz9XVpoE9SQaTBQLRFYHMMHS7L6GyIOZ
         4M6nrtxhqY21cQP6zpvIX3ar6cuqeFrByhTpyVskSsME04O8/ard/o8AX0by8Y8jDcL1
         2bcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iZGYZYsc1e4Af5BJsbMi00xtVdBZVS7jpl0K9DlJm08=;
        b=Ovj1xohfuN5iZT20VO82Ufd45/hSwfGSD+lqfA8H5KrqplUhpgyhyUhJVWELdUSm0i
         nSWwfaFseTzdd6Z5j6BB7ZCzk1jyvwu5UpkDR6Oa6JjbTayssfHBp+8NiM0HA/Sfeh0q
         EjgDAr84hdnH8WAvR0zGGb6WLguoDG0Tpj/Zd5IUbPVLye22ddH8xwnmIGL+XQEEgPc5
         fqlGKl4LBHi2b3IH2odvqWbHvSWdF2x5VZYXljb6IaAzyxekjgPFdhU4wviSS65D8Hnv
         z7TBeS7OPULQWLcDnXrGh4cjUOqDyOS0/Tj/cmrVlVAPJOkc3cpEqMwt39uL6igWZq24
         wYCw==
X-Gm-Message-State: AO0yUKV2yQFIPj4oqZoMBghBwLLdSHaCi9FwY9IUezShSSJoj5eKa906
        M/S4JVSj+7Acq5sZCV5C9cf53L70iavK3IIo/xixqg==
X-Google-Smtp-Source: AK7set9Rm99bJ+D4X45Jf/hL4QmsBRDT+pgUR5udlAhrE02KYo7S2QHATwTwb1kBZfsGhLJ/JkBM3nm8rgigf3vjhPc=
X-Received: by 2002:a81:ad0f:0:b0:52e:cea7:f6e0 with SMTP id
 l15-20020a81ad0f000000b0052ecea7f6e0mr4705226ywh.7.1677251761894; Fri, 24 Feb
 2023 07:16:01 -0800 (PST)
MIME-Version: 1.0
References: <20230224015234.1626025-1-kuba@kernel.org> <20230223175708.51e593f0@kernel.org>
 <0ae995dd47329e1422cb0e99b7960615c58d37fe.camel@sipsolutions.net>
In-Reply-To: <0ae995dd47329e1422cb0e99b7960615c58d37fe.camel@sipsolutions.net>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 24 Feb 2023 10:15:50 -0500
Message-ID: <CAM0EoMnfDhAXsZKY7UqwCxgeXGH1Q-pQdqSycMHw+MSRZSABVA@mail.gmail.com>
Subject: Re: [PATCH iproute2] genl: print caps for all families
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, stephen@networkplumber.org,
        dsahern@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 3:33 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2023-02-23 at 17:57 -0800, Jakub Kicinski wrote:
> > On Thu, 23 Feb 2023 17:52:34 -0800 Jakub Kicinski wrote:
> > > Back in 2006 kernel commit 334c29a64507 ("[GENETLINK]: Move
> > > command capabilities to flags.") removed some attributes and
> > > moved the capabilities to flags. Corresponding iproute2
> > > commit 26328fc3933f ("Add controller support for new features
> > > exposed") added the ability to print those caps.
> > >
> > > Printing is gated on version of the family, but we're checking
> > > the version of each individual family rather than the control
> > > family. The format of attributes in the control family
> > > is dictated by the version of the control family alone.
> > >
> > > Families can't use flags for random things, anyway,
> > > because kernel core has a fixed interpretation.
> > >
> > > Thanks to this change caps will be shown for all families
> > > (assuming kernel newer than 2.6.19), not just those which
> > > by coincidence have their local version >= 2.
> > >
> > > For instance devlink, before:
> > >
> > >   $ genl ctrl get name devlink
> > >   Name: devlink
> > >     ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> > >     commands supported:
> > >             #1:  ID-0x1
> > >             #2:  ID-0x5
> > >             #3:  ID-0x6
> > >             ...
> > >
> > > after:
> > >
> > >   $ genl ctrl get name devlink
> > >   Name: devlink
> > >     ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> > >     commands supported:
> > >             #1:  ID-0x1
> > >             Capabilities (0xe):
> > >               can doit; can dumpit; has policy
> > >
> > >             #2:  ID-0x5
> > >             Capabilities (0xe):
> > >               can doit; can dumpit; has policy
> > >
> > >             #3:  ID-0x6
> > >             Capabilities (0xb):
> > >               requires admin permission; can doit; has policy
> > >
> > > Leave ctrl_v as 0 if we fail to read the version. Old code used 1
> > > as the default, but 0 or 1 - does not matter, checks are for >= 2.
> > >
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > > Not really sure if this is a fix or not..
> >
> > Adding Johannes, that's probably everyone who ever used this
> > command on CC? ;)
>
> Hehe. I'm not even sure I use(d) that part of it frequently ;-)
>
> > > --- a/genl/ctrl.c
> > > +++ b/genl/ctrl.c
> > > @@ -21,6 +21,8 @@
> > >  #define GENL_MAX_FAM_OPS   256
> > >  #define GENL_MAX_FAM_GRPS  256
> > >
> > > +static unsigned int ctrl_v;
>
> You know I looked at this on my phone this morning and missed the fact
> that it's iproute2, and was wondering what you're doing with a global
> variable in the kernel ;-)
>
> There's this code also:
>
> > static int print_ctrl_cmds(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
> > ...
> > static int print_ctrl_grp(FILE *fp, struct rtattr *arg, __u32 ctrl_ver)
>
> and it feels a bit pointless to pass a now global ctrl_v to the function
> arguments?
>
> > > @@ -264,6 +313,9 @@ static int ctrl_list(int cmd, int argc, char **argv)
> > >             exit(1);
> > >     }
> > >
> > > +   if (!ctrl_v)
> > > +           ctrl_load_ctrl_version(&rth);
>
> You call this here, but what about this:
>
> > struct genl_util ctrl_genl_util = {
> >         .name = "ctrl",
> >         .parse_genlopt = parse_ctrl,
> >         .print_genlopt = print_ctrl2,
> > };
>
> where print_ctrl2 and hence all the above will be called with a now zero
> ctrl_v, whereas before it would've been - at least in some cases? -
> initialized by ctrl_list() itself?
>
>
> Oh. I see now. The issue was which version we use - the family version
> vs. the controller version. How did I miss that until here ...
>
> Still it seems it should be always initialized in print_ctrl rather than
> in ctrl_list, to capture the case of print_ctrl2? Or maybe in there, but
> that's called inside ctrl_list(), so maybe have parse_ctrl() already
> initialize it, rather than ctrl_list()?

Actually, there is a small gotcha with using a global in the patch -
events (genl ctrl monitor).
If it works, it will be expensive to load the controller for every event.

cheers,
jamal
> johannes
