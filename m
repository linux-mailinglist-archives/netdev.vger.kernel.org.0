Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B163527FDF6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 13:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732084AbgJALAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 07:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731913AbgJALAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 07:00:30 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1933EC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 04:00:30 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id q8so6020509lfb.6
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 04:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bANsSudtrN/wLxhx8uakTNFPyaA7Z1UPY8U0hitx0Rc=;
        b=REwNVPMQypxo3lYRbj7Fb9S0QFVQLJ85MVShrX1nmtLrK7Rw61gNkq9cu4AtZOpi/6
         +TyUBlDydydufwM4MlLQwoxF8+/YXu/R59GS22WcVAo5mqo8sUV46ECVLRjAF4ad+K7w
         vHHUoD+RvQvNtfYzSi2PigXlqX/G7Dsl9LRnyFBYpxFAKBunuASXuFXEMQlN9nNP/XfC
         kwchD7J10bHo3FQPxJecUe2qRJeMEImK6jdIdp+p2W6yDOlbjt4h0ltElYpiHEAHE2p+
         onCYJ1LYPnX2UuCOpFuONVq3jBhfBFlU9IM4jQSZw1eOm0OAXk7zU1HXBFImEgF5pExh
         7J2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bANsSudtrN/wLxhx8uakTNFPyaA7Z1UPY8U0hitx0Rc=;
        b=rBZ2sIm0IkYYv19znYEf4V7lVil9kjzNLnrmy6IXAuVT9qBUJE+0/4lWpL+5wZcl7/
         YiPHAYjtBYgLoUd2mtYB6l9zZ/lIKabLgrQjrsp/EGzyHkIaxILxHBp5+5pCFq+Pi2Vo
         fRtAwJx9wqM1UAxpQ0DgW6mhl23x00aqJ+4c6FY3f7I1+vee80oVqAayzqCicpk/e6Rc
         SMJ/0yGuR9eUxOxUe4yFHhgIo+Fh1Ah4ISUXDBOBbnMKtqfzvPAf3JiJr+WiqIr0245U
         teJ7b2sC4VEF1TqEbk3A9Q/r+6RS8fW4bm1QKFaUVTtz1H5uGB2qaqeMLUV5iDkyTB3P
         n9mg==
X-Gm-Message-State: AOAM5338CCbgQANUGdVaX0v6yhgI50SIiQRpmjoz1kNqB7ZoAFkhS50o
        wsZsBIGVGKRAHvwC/wVAW1TShTNalqF1s5qFWz30K54j7gI=
X-Google-Smtp-Source: ABdhPJzl35QEAD5WODevGNX666ByNHtuXyDk/wNSGXpFrrpBbUkGRIc69Os5TCV+iqJYKT3m57Rk34lEkqXEKIEm00I=
X-Received: by 2002:a19:7507:: with SMTP id y7mr2255840lfe.507.1601550028357;
 Thu, 01 Oct 2020 04:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600770261.git.sd@queasysnail.net> <879af1e3232451feee4a306c1e757bef188b0ee4.1600770261.git.sd@queasysnail.net>
In-Reply-To: <879af1e3232451feee4a306c1e757bef188b0ee4.1600770261.git.sd@queasysnail.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 1 Oct 2020 20:00:16 +0900
Message-ID: <CAMArcTXskxWf-1RfquQp61+r08v--AAZC8FEY0PyZh10Jcv6Rw@mail.gmail.com>
Subject: Re: [PATCH net 09/12] net: link_watch: fix operstate when the link
 has the same index as the device
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Oct 2020 at 17:09, Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> When we create a macvlan device on top of a bond, the macvlan device
> should always start with IF_OPER_LOWERLAYERDOWN if the bond is
> down. Currently, this doesn't happen if the macvlan device gets the
> same ifindex as the bond, which can happen because different
> namespaces assign the ifindex independently:
>
>     ip netns add main
>     ip netns add peer
>     ip -net main link add type bond # idx 9
>     ip -net main link add link bond0 netns peer type macvlan # idx 10
>     ip -net main link add link bond0 type macvlan # idx 9
>
>     ip -net main link show type macvlan # M-DOWN since bond0 is DOWN
>       10: macvlan0@bond0: <BROADCAST,MULTICAST,M-DOWN> ...
>
>     ip -net peer link show type macvlan # should also be M-DOWN
>        9: macvlan0@if9: <BROADCAST,MULTICAST> ...
>

Hi Sabrina!

I think this patch will fix another bug.

Test commands:
    ip link add dummy0 up type dummy
    while :
    do
        ip link add vlan1 up link dummy0 type vlan id 10
        for i in {2..7}
        do
            let p=$i-1
            ip link add vlan$i up link vlan$p type vlan id 10
        done
        modprobe -rv 8021q
    done

Splat looks like:
[   65.259829][  T656] BUG: unable to handle page fault for address:
ffffa13971571100
[   65.261719][  T656] #PF: supervisor read access in kernel mode
[   65.263213][  T656] #PF: error_code(0x0000) - not-present page
[   65.264685][  T656] PGD 14801067 P4D 14801067 PUD 14805067 PMD
13ff7b067 PTE 800ffffecea8e060
[   65.266851][  T656] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC PTI
[   65.268278][  T656] CPU: 5 PID: 656 Comm: modprobe Not tainted
5.9.0-rc6+ #745
[   65.270099][  T656] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.10.2-1ubuntu1 04/01/2014
[   65.272532][  T656] RIP: 0010:vlan_dev_get_iflink+0xc/0x20 [8021q]
[   65.274106][  T656] Code: 00 ff ff ff ff 48 89 46 04 31 c0 c3 66 90
0f 1f 44 00 00 f3 c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b
87 f0 0c 00 00 <8b> 80 00 01 00 00 c3 0f 1f 00 66 2e 0f 1f 84 00 00 00
00 00 0f 1f
[   65.278942][  T656] RSP: 0018:ffffa139690e7e10 EFLAGS: 00010282
[   65.280455][  T656] RAX: ffffa13971571000 RBX: ffffa13972281000
RCX: 0000000000000006
[   65.282434][  T656] RDX: 0000000000000000 RSI: 0000000000000000
RDI: ffffa13972281000
[   65.284404][  T656] RBP: 0000000000000008 R08: 0000000000000001
R09: 0000000000000001
[   65.286381][  T656] R10: 0000000076c2727a R11: 00000000ffe5333b
R12: 00000000fffc68b0
[   65.288363][  T656] R13: 0000000000000000 R14: ffffa139690e7e40
R15: dead000000000100
[   65.290338][  T656] FS:  00007fce35d80540(0000)
GS:ffffa1397aa00000(0000) knlGS:0000000000000000
[   65.292546][  T656] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   65.294187][  T656] CR2: ffffa13971571100 CR3: 0000000128e76004
CR4: 00000000003706e0
[   65.296167][  T656] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[   65.298183][  T656] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[   65.300160][  T656] Call Trace:
[   65.300979][  T656]  rfc2863_policy+0x7f/0xa0
[   65.302107][  T656]  linkwatch_do_dev+0x13/0x50
[   65.303279][  T656]  netdev_run_todo+0x156/0x350
[   65.304461][  T656]  ? __rtnl_link_unregister+0x93/0xd0
[   65.305801][  T656]  rtnl_link_unregister+0xdc/0x100
[   65.307077][  T656]  ? do_wait_intr_irq+0xb0/0xb0
[   65.308285][  T656]  vlan_cleanup_module+0xc/0x33 [8021q]
[   65.309654][  T656]  __x64_sys_delete_module+0x13f/0x210
[ ... ]

When module is deleted, interfaces of its module are deleted automatically.
Each interface will be deleted in order and linkwatch event of
each interface will be called in order too.
linkwatch event internally calls rfc2863_policy() and it internally calls
->ndo_get_iflink().
->ndo_get_iflink() dereferences lower interface pointer but at this
moment, the lower interface could be already deleted.
So, it could dereference the freed memory so that kernel panic could
occur.

Interface graph:
    vlan3
      |
    vlan2
      |
    vlan1
      |
    dummy0

When the 8021q module is being removed,
1. flush vlan1's linkwatch event(dereferences dummy0)
2. delete vlan1
3. flush vlan2's linkwatch event(dereference vlan1)
At this point, vlan1 was already deleted so ->ndo_get_iflink()
will dereference the freed memory.

But this patch removes dev_get_iflink() from default_operstate().
So, this panic will not happen.
I tested it, it works well!
So, please add the below tags.
Reported-by: syzbot+95eec132c4bd9b1d8430@syzkaller.appspotmail.com
Reported-by: syzbot+d702fd2351989927037c@syzkaller.appspotmail.com
Fixes: a54acb3a6f85 ("dev: introduce dev_get_iflink()")

Taehee Yoo

> Fixes: d8a5ec672768 ("[NET]: netlink support for moving devices between network namespaces.")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  net/core/link_watch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
> index 75431ca9300f..6932ad51aa4a 100644
> --- a/net/core/link_watch.c
> +++ b/net/core/link_watch.c
> @@ -38,7 +38,7 @@ static unsigned char default_operstate(const struct net_device *dev)
>                 return IF_OPER_TESTING;
>
>         if (!netif_carrier_ok(dev))
> -               return (dev->ifindex != dev_get_iflink(dev) ?
> +               return (dev->netdev_ops && dev->netdev_ops->ndo_get_iflink ?
>                         IF_OPER_LOWERLAYERDOWN : IF_OPER_DOWN);
>
>         if (netif_dormant(dev))
> --
> 2.28.0
>
