Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169D15FF7E9
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 03:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJOBl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 21:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJOBlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 21:41:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545A592CDA;
        Fri, 14 Oct 2022 18:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E622C61CEE;
        Sat, 15 Oct 2022 01:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538A8C4347C;
        Sat, 15 Oct 2022 01:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665798082;
        bh=wKhQf1jqlDwn101ASuQdn4i1qM4vzK+c1GxsBmywSQE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G7EP7ym7Xq40DSKKFk1FnlCqWb0kWyOonZjQwcrLxsSebr0hWQlSrXTiJIlc4rLiY
         wtLZQXubG00pUCZxw/3VdZsZF20feD8oOMmcVrgTnfZRY2A1CXb4Kp81Qo533K1xfE
         ZVWIt/TZU2VivgMENujtqrGWLfngOyA4BBzpRkk5apvtI+9619fDtu/iH+1qWwDVWT
         FxoIdFOQ4Ugot94sKDQdOToiEBSRWqBXkC1Yr/RVxtre3O3qJ4wNjIBmyU9tIfWqfs
         eb4AFh7oZdXwpminI3b60Vk3hV+Ez1Tl2w+w30/nCZ5avaQHhBpJ4de2yqfPZapBv2
         LqYUQMkbtKL3A==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-132af5e5543so7820511fac.8;
        Fri, 14 Oct 2022 18:41:22 -0700 (PDT)
X-Gm-Message-State: ACrzQf39f/0K61B4XZR+eU0LZrfTOKEKVJ0PZg9hVwjLrmnLxPNopFoR
        qSc2OkJ8eiltTyftFLyar6dYrka+E6RRC4D6cS0=
X-Google-Smtp-Source: AMsMyM4X/8fOrngND6837Iu7qJtRPT17SJfoi8d7p/Zi7lOb6CQClanTVDO2W4a/68EOGJB1oXZitLhLUCHPN74oDB8=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr10179246oah.112.1665798081415; Fri, 14
 Oct 2022 18:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-2-guoren@kernel.org>
 <20221013203544.110a143c@kernel.org> <20221013203911.2705eccc@kernel.org>
 <Y0jowX4zIZMMVc0H@yury-laptop> <20221014090311.392e0546@kernel.org>
In-Reply-To: <20221014090311.392e0546@kernel.org>
From:   Guo Ren <guoren@kernel.org>
Date:   Sat, 15 Oct 2022 09:41:09 +0800
X-Gmail-Original-Message-ID: <CAJF2gTSQ++HkY8=vhgN7+sqETjvbxNTuKLb_wLU=U90mUmUHFg@mail.gmail.com>
Message-ID: <CAJF2gTSQ++HkY8=vhgN7+sqETjvbxNTuKLb_wLU=U90mUmUHFg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Yury Norov <yury.norov@gmail.com>,
        andriy.shevchenko@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rasmusvillemoes.dk,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 12:03 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 13 Oct 2022 21:42:41 -0700 Yury Norov wrote:
> > > Oh, it was reposted today:
> > >
> > > https://lore.kernel.org/all/20221013234349.1165689-2-yury.norov@gmail=
.com/
> > >
> > > But we need a revert of 854701ba4c as well to cover the issue back up
> > > for 6.1, AFAIU.
> >
> > The patch 854701ba4c is technically correct. I fixed most of warnings i=
n
> > advance, but nobody can foresee everything, right? I expected some nois=
e,
> > and now we have just a few things to fix.
>
> I got 6 warnings booting my machine after pulling back from Linus
> (which included your patches in net for the first time).
> And that's not including the XPS and the virtio warning.
Oh, that's a wide effect than we thought.

>
> > This is what for -rc releases exist, didn't they?
> >
> > I suggest to keep the patch, because this is the only way to make
> > cpumask_check()-related issues visible to people. If things will go as
> > they go now, I expect that -rc3 will be clean from cpumask_check()
> > warnings.
>
> This sounds too close to saying that "it's okay for -rc1 to be broken".
> Why were your changes not in linux-next for a month before the merge
> window? :(
>
> We will not be merging a refactoring series into net to silence an
> arguably over-eager warning. We need a minimal fix, Guo Ren's patches
> seem to miss the mark so I reckon the best use of everyone's time is
> to just drop the exposing patch and retry in -next =F0=9F=A4=B7



--=20
Best Regards
 Guo Ren
