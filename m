Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1E139EC6E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFHC6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhFHC6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:58:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407A7C061574;
        Mon,  7 Jun 2021 19:56:51 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t3so22780507edc.7;
        Mon, 07 Jun 2021 19:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UEnzAiZukL+aXV+T6AA0wBe65UG5nyqALOrpT9n86U0=;
        b=BAcdRbecgSWL288sNA4G3r/zWnO2TdJ3wC5gK8kiGEBa73FTEhAjFKMc+XkK8xYlYm
         erLB0CZTSbZpnQSd3spxKFK1v5f6wRfdgBUGPDGs+MJeGndmu7M2lCkHNw/XkWQXVKGl
         E+h2YpZvFH3FdUGfyMfYgRJOZlse2YJUa2PCK0R5IngWryYufGnN09QHaI6hbqd+gYoD
         7t+re8fcrdT2JILTN5cjd+vY6QabknxWT8upJURPcRa2kkpkp3K4B1qiWQ0kAnDe74Is
         /AoiRItFdeThWRmijhD/GLuT8w5U2JbMb/WAgSc122sbdCDiV1/+fJe1u9dxGv9xn+6Y
         fdlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UEnzAiZukL+aXV+T6AA0wBe65UG5nyqALOrpT9n86U0=;
        b=H1ny5oxDaNcZ/CXmfvhINcltwSjWrkn304FSbMiTDAqitW3cWNc8gtC7aUtFI992Ky
         ZFCwrINNT/2L1L29YlmBSryUytcgGsBV+b9BVVAoFYH996XVK4AcnkM+mae53v5HXfNA
         vSCTfLAQ36Cdstr6qk9kApE3zsf0Z5EwZQ849qPGrIeRi7tepCM4G51yYawx4mfA7prJ
         fi0oToUkmeQvLOZVaDNiWtwynzWRwLLS9g8/w/HnY+qZwhvpRX/WrQQhyW97A6draaQf
         XbjiY7CFlGKVT9xCuEZ8d0cUgg4WGIEBbIGZ3WpQMrFOo7Oinj6GpUHRzsmMN1CBCMs9
         gMiA==
X-Gm-Message-State: AOAM530V0eyGpLtTu76fxWdHd1f6/l54NOsAY8W8r5O3Uo5ZCtNjjTbt
        dBqqkrQoFHm0yCVfzX9Gc3/Pnt5toqVDZ2EfScs=
X-Google-Smtp-Source: ABdhPJyeR7tDzCb/XkuxLTgxes+Kb/lkuwwGYSPgxrWrxPVvtcKSEnmduuQXEG4iBouApoXoLEyytJEMalzvBML+tPM=
X-Received: by 2002:a05:6402:3082:: with SMTP id de2mr10891650edb.214.1623121009694;
 Mon, 07 Jun 2021 19:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210608015158.3848878-1-sunnanyong@huawei.com>
 <CAHC9VhTqDjN1VwakrYZznaMVTyqkEKcYLo=bPtHsOXugS_mexQ@mail.gmail.com> <CAD-N9QXFbO_FVBTHN6k+ZPw7GF6bKp+f4wK_LfMQLRsdML=XcA@mail.gmail.com>
In-Reply-To: <CAD-N9QXFbO_FVBTHN6k+ZPw7GF6bKp+f4wK_LfMQLRsdML=XcA@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 8 Jun 2021 10:56:23 +0800
Message-ID: <CAD-N9QU+nq1AxpBqodZWisT4x=BTjW_S45Yq=ZaaDp1cOi72iA@mail.gmail.com>
Subject: Re: [PATCH] net: ipv4: fix memory leak in netlbl_cipsov4_add_std
To:     Paul Moore <paul@paul-moore.com>
Cc:     Nanyong Sun <sunnanyong@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 10:30 AM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> On Tue, Jun 8, 2021 at 9:57 AM Paul Moore <paul@paul-moore.com> wrote:
> >
> > On Mon, Jun 7, 2021 at 9:19 PM Nanyong Sun <sunnanyong@huawei.com> wrote:
> > >
> > > Reported by syzkaller:
> > > BUG: memory leak
> > > unreferenced object 0xffff888105df7000 (size 64):
> > > comm "syz-executor842", pid 360, jiffies 4294824824 (age 22.546s)
> > > hex dump (first 32 bytes):
> > > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> > > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> > > backtrace:
> > > [<00000000e67ed558>] kmalloc include/linux/slab.h:590 [inline]
> > > [<00000000e67ed558>] kzalloc include/linux/slab.h:720 [inline]
> > > [<00000000e67ed558>] netlbl_cipsov4_add_std net/netlabel/netlabel_cipso_v4.c:145 [inline]
> > > [<00000000e67ed558>] netlbl_cipsov4_add+0x390/0x2340 net/netlabel/netlabel_cipso_v4.c:416
> > > [<0000000006040154>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320 net/netlink/genetlink.c:739
> > > [<00000000204d7a1c>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
> > > [<00000000204d7a1c>] genl_rcv_msg+0x2bf/0x4f0 net/netlink/genetlink.c:800
> > > [<00000000c0d6a995>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
> > > [<00000000d78b9d2c>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
> > > [<000000009733081b>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> > > [<000000009733081b>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
> > > [<00000000d5fd43b8>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
> > > [<000000000a2d1e40>] sock_sendmsg_nosec net/socket.c:654 [inline]
> > > [<000000000a2d1e40>] sock_sendmsg+0x139/0x170 net/socket.c:674
> > > [<00000000321d1969>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
> > > [<00000000964e16bc>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
> > > [<000000001615e288>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
> > > [<000000004ee8b6a5>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
> > > [<00000000171c7cee>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> > >
> > > The memory of doi_def->map.std pointing is allocated in
> > > netlbl_cipsov4_add_std, but no place has freed it. It should be
> > > freed in cipso_v4_doi_free which frees the cipso DOI resource.
> > >
> > > Fixes: 96cb8e3313c7a ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
> > > Reported-by: Hulk Robot <hulkci@huawei.com>
> > > Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> > > ---
> > >  net/ipv4/cipso_ipv4.c | 1 +
> > >  1 file changed, 1 insertion(+)
> >
> > Nice catch, thanks for fixing this.
> >
> > Acked-by: Paul Moore <paul@paul-moore.com>
> >
> > > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > > index d6e3a92841e3..099259fc826a 100644
> > > --- a/net/ipv4/cipso_ipv4.c
> > > +++ b/net/ipv4/cipso_ipv4.c
> > > @@ -471,6 +471,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
> > >                 kfree(doi_def->map.std->lvl.local);
> > >                 kfree(doi_def->map.std->cat.cipso);
> > >                 kfree(doi_def->map.std->cat.local);
> > > +               kfree(doi_def->map.std);
> > >                 break;
> > >         }
> > >         kfree(doi_def);
>
> Hi kernel developers,
>
> I doubt this patch may cause invalid free in other functions where
> map.std is not allocated or initialized, such as
> netlbl_cipsov4_add_local, netlbl_cipsov4_add_pass.
>
> Take netlbl_cipsov4_add_pass as an example, any failure after the
> doi_def allocation failure will go to cipso_v4_doi_free, and free
> doi_def->map.std.

Sorry for the false alarm.

The new added kfree(doi_def->map.std) is under the condition - case
CIPSO_V4_MAP_TRANS. So there will be not invalid free. Sorry about
this.

>
> static int netlbl_cipsov4_add_pass(struct genl_info *info,
>   struct netlbl_audit *audit_info)
> {
> int ret_val;
> struct cipso_v4_doi *doi_def = NULL;
>
> if (!info->attrs[NLBL_CIPSOV4_A_TAGLST])
> return -EINVAL;
>
> doi_def = kmalloc(sizeof(*doi_def), GFP_KERNEL);
> if (doi_def == NULL)
> return -ENOMEM;
> doi_def->type = CIPSO_V4_MAP_PASS;
>
> ret_val = netlbl_cipsov4_add_common(info, doi_def);
> if (ret_val != 0)
> goto add_pass_failure;
>
> ret_val = cipso_v4_doi_add(doi_def, audit_info);
> if (ret_val != 0)
> goto add_pass_failure;
> return 0;
>
> add_pass_failure:
> cipso_v4_doi_free(doi_def);
> return ret_val;
> }
>
> [1] https://elixir.bootlin.com/linux/latest/source/net/netlabel/netlabel_cipso_v4.c#L326
>
> > > --
> > > 2.18.0.huawei.25
> >
> > --
> > paul moore
> > www.paul-moore.com
