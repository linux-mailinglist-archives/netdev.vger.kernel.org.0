Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF64139EC16
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFHCdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhFHCdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:33:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7A4C061574;
        Mon,  7 Jun 2021 19:31:14 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id my49so13260413ejc.7;
        Mon, 07 Jun 2021 19:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l7xUTKanPRGXpfqLrdmjlT+AMandQ6o+RGBfYX1FatU=;
        b=AErY6ZKn37TATLFP8O01VjT2RJZBMtL6Ap99J7Ehl3G2WRcL5OUkTSSznp2gOeSToO
         zEoLIuPyvO5+ymD59tTa3IgLkTYaDHrKydjdsT+zRA2dtV3av4pD+5QewSsX/VRPLgQV
         mOC6goSZOEqioVPTPFvnFgXfydLS7O/hhAtCkapqRSnikEzL6mzdYpqW5/vnHVL2lpTb
         DHLnY4AaDxzp1XGRRVVNdp2Vrff8tPhgje8+wsiBWkal5QBJg7/MIq53T5rZYkOtArvk
         EAz+mKXyKipjjhaYJulQ7umGboqYJvGsloeoHJlKVdmEoR6wnyqpYJudWkmzfMN3DDhW
         1DaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l7xUTKanPRGXpfqLrdmjlT+AMandQ6o+RGBfYX1FatU=;
        b=WLC96liW7aggAYgsId7bY4JiJNIgqtDBsXEhQUnhQyCd/ilGrayJ8eZ6uQ6dxlPpv5
         d6YWQVTnCgdIKvN7MD+KqeKgWomLfCAa5onflcWv3utRBQrZLvxPToOMHoD5+LhRHVdI
         zdmN34TjbH3qfldm9DaOntgPJG6CCFjPEZ/goQQeeXjG1Z3FQp6Iy37iFhU74/u+mpoK
         LweEJ9BxIYMZVS86KGSvjWIdo3oDvw8GLP9+jS+s9BEcVW/bYRt6jeLOf6dpvYBMrys2
         ZQaTnk7X1kbYeRbjh/n044UnQs5XAy6WU80KBPUqAKGtfCJ7eZw9DKKI525Y8kxTQ/xY
         xUrQ==
X-Gm-Message-State: AOAM532SeOWjaiAIFWLy4B7o4WfRW9Z/y2B4WzQt/MPJp7Yd3pcbR6di
        3VAbu1qsOSNQa/ljk05zNqp4J8lvxIptRJ3XUGY=
X-Google-Smtp-Source: ABdhPJx/s3q9UaBPoByPhWjMqnK7/I/SFPzj33oeY1EOhWlbC3a0EWtRMrGWZRDhZWt0GXTqF9p9ZTlO08g6C1cacfw=
X-Received: by 2002:a17:906:35ca:: with SMTP id p10mr20280723ejb.535.1623119472903;
 Mon, 07 Jun 2021 19:31:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210608015158.3848878-1-sunnanyong@huawei.com> <CAHC9VhTqDjN1VwakrYZznaMVTyqkEKcYLo=bPtHsOXugS_mexQ@mail.gmail.com>
In-Reply-To: <CAHC9VhTqDjN1VwakrYZznaMVTyqkEKcYLo=bPtHsOXugS_mexQ@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 8 Jun 2021 10:30:46 +0800
Message-ID: <CAD-N9QXFbO_FVBTHN6k+ZPw7GF6bKp+f4wK_LfMQLRsdML=XcA@mail.gmail.com>
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

On Tue, Jun 8, 2021 at 9:57 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Mon, Jun 7, 2021 at 9:19 PM Nanyong Sun <sunnanyong@huawei.com> wrote:
> >
> > Reported by syzkaller:
> > BUG: memory leak
> > unreferenced object 0xffff888105df7000 (size 64):
> > comm "syz-executor842", pid 360, jiffies 4294824824 (age 22.546s)
> > hex dump (first 32 bytes):
> > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
> > backtrace:
> > [<00000000e67ed558>] kmalloc include/linux/slab.h:590 [inline]
> > [<00000000e67ed558>] kzalloc include/linux/slab.h:720 [inline]
> > [<00000000e67ed558>] netlbl_cipsov4_add_std net/netlabel/netlabel_cipso_v4.c:145 [inline]
> > [<00000000e67ed558>] netlbl_cipsov4_add+0x390/0x2340 net/netlabel/netlabel_cipso_v4.c:416
> > [<0000000006040154>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320 net/netlink/genetlink.c:739
> > [<00000000204d7a1c>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
> > [<00000000204d7a1c>] genl_rcv_msg+0x2bf/0x4f0 net/netlink/genetlink.c:800
> > [<00000000c0d6a995>] netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2504
> > [<00000000d78b9d2c>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
> > [<000000009733081b>] netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
> > [<000000009733081b>] netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1340
> > [<00000000d5fd43b8>] netlink_sendmsg+0x789/0xc70 net/netlink/af_netlink.c:1929
> > [<000000000a2d1e40>] sock_sendmsg_nosec net/socket.c:654 [inline]
> > [<000000000a2d1e40>] sock_sendmsg+0x139/0x170 net/socket.c:674
> > [<00000000321d1969>] ____sys_sendmsg+0x658/0x7d0 net/socket.c:2350
> > [<00000000964e16bc>] ___sys_sendmsg+0xf8/0x170 net/socket.c:2404
> > [<000000001615e288>] __sys_sendmsg+0xd3/0x190 net/socket.c:2433
> > [<000000004ee8b6a5>] do_syscall_64+0x37/0x90 arch/x86/entry/common.c:47
> > [<00000000171c7cee>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> >
> > The memory of doi_def->map.std pointing is allocated in
> > netlbl_cipsov4_add_std, but no place has freed it. It should be
> > freed in cipso_v4_doi_free which frees the cipso DOI resource.
> >
> > Fixes: 96cb8e3313c7a ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> > ---
> >  net/ipv4/cipso_ipv4.c | 1 +
> >  1 file changed, 1 insertion(+)
>
> Nice catch, thanks for fixing this.
>
> Acked-by: Paul Moore <paul@paul-moore.com>
>
> > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > index d6e3a92841e3..099259fc826a 100644
> > --- a/net/ipv4/cipso_ipv4.c
> > +++ b/net/ipv4/cipso_ipv4.c
> > @@ -471,6 +471,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi *doi_def)
> >                 kfree(doi_def->map.std->lvl.local);
> >                 kfree(doi_def->map.std->cat.cipso);
> >                 kfree(doi_def->map.std->cat.local);
> > +               kfree(doi_def->map.std);
> >                 break;
> >         }
> >         kfree(doi_def);

Hi kernel developers,

I doubt this patch may cause invalid free in other functions where
map.std is not allocated or initialized, such as
netlbl_cipsov4_add_local, netlbl_cipsov4_add_pass.

Take netlbl_cipsov4_add_pass as an example, any failure after the
doi_def allocation failure will go to cipso_v4_doi_free, and free
doi_def->map.std.

static int netlbl_cipsov4_add_pass(struct genl_info *info,
  struct netlbl_audit *audit_info)
{
int ret_val;
struct cipso_v4_doi *doi_def = NULL;

if (!info->attrs[NLBL_CIPSOV4_A_TAGLST])
return -EINVAL;

doi_def = kmalloc(sizeof(*doi_def), GFP_KERNEL);
if (doi_def == NULL)
return -ENOMEM;
doi_def->type = CIPSO_V4_MAP_PASS;

ret_val = netlbl_cipsov4_add_common(info, doi_def);
if (ret_val != 0)
goto add_pass_failure;

ret_val = cipso_v4_doi_add(doi_def, audit_info);
if (ret_val != 0)
goto add_pass_failure;
return 0;

add_pass_failure:
cipso_v4_doi_free(doi_def);
return ret_val;
}

[1] https://elixir.bootlin.com/linux/latest/source/net/netlabel/netlabel_cipso_v4.c#L326

> > --
> > 2.18.0.huawei.25
>
> --
> paul moore
> www.paul-moore.com
