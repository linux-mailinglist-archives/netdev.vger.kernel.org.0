Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B611DD129
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 23:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440440AbfJRVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 17:25:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37243 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbfJRVZN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 17:25:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so7373663wmc.2;
        Fri, 18 Oct 2019 14:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yZfAzIb/Kba55Aw+sHVK09/x4YWKV6syg8pmtZMsJ50=;
        b=iWYh2Nd0eM/HeqF1v6SwZNakMYD+XJJS0R7WEABGsIvTS0U12VMb4Hk3oKkMK5BqB9
         oNRweWnwMGVcURXallNaXSuhdW284JnhCX3GtezlOZCnlaJcZlxdmBHtuM1AywT8B64G
         ncMAmpyBemJRtB945SHX4Nd09pVpLJB1QroQvqfdzRduyXPLk7+woTUBFctpALyGfR1z
         qH5jTQGvwSPOP3Rxq+gNcFjM+z9N7veA5jqu/oG6cq1ZuboLCw8nz3QvsM5Q2YFRZE+R
         buUB1MFfEtNjaJ3sPBn3VprE5bUwWtJzT2nsCN5F4zrkaOvuSsYxpqzwcOsft93+NVtH
         OBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yZfAzIb/Kba55Aw+sHVK09/x4YWKV6syg8pmtZMsJ50=;
        b=Cv4253a9aiYLzmsH5kGQ7LQCrSquORduTavKPOflolwLu+m3fg0HseQarO/H20FwRy
         8O6QeHtrgL7oRFFZKu60OQrKXAB37vhLfaI44WSAxhkIGM+Q+zDja7goDERXpetRjSit
         HKRdnaY2ebxNV2dcXnEhc0pt+CC+U1y3x3TWCLyno7wWVn97rs3ZJtoV+u05rLgryo1e
         6JfqJPHHXFPZrc9jqNH98XaI0VRsoGzZ8HWwXVEzPaE6wWYGyM6vILyORruzgHF0I7nV
         RjbMLUgkcPnwV/4U0yzqa2uyfT5NrDralvgM6jadPw7k+6COCiq075muZ84VKfTB5lTt
         SlZA==
X-Gm-Message-State: APjAAAVoZ0I7NBnKkT8p1rNOSOSIcyMgfBESDyrXXW8gskcmnfxR745e
        s72Zw7J4Bw1Tw35M3usG9Uo=
X-Google-Smtp-Source: APXvYqxCdRItkxuKaHa8vVnC37xc2LT62VfKDXi9PnR0prcxbx8kyqmTXYuS4mI4Jr57p8oZmKa0cg==
X-Received: by 2002:a05:600c:29a:: with SMTP id 26mr9887170wmk.127.1571433909253;
        Fri, 18 Oct 2019 14:25:09 -0700 (PDT)
Received: from jimi ([77.138.210.146])
        by smtp.gmail.com with ESMTPSA id r2sm6461653wrm.3.2019.10.18.14.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 14:25:08 -0700 (PDT)
Date:   Sat, 19 Oct 2019 00:25:02 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, shmulik.ladkani@gmail.com
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
Message-ID: <20191019002502.0519ea9b@jimi>
In-Reply-To: <e16cfafe-059c-3106-835e-d32b7bb5ba61@linux.alibaba.com>
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
        <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
        <e2bd3004-9f4b-f3ce-1214-2140f0b7cc61@linux.alibaba.com>
        <20191016151307.40f63896@jimi>
        <e16cfafe-059c-3106-835e-d32b7bb5ba61@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, 18 Oct 2019 00:33:53 +0800
Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:

> On 2019/10/16 8:13 =E4=B8=8B=E5=8D=88, Eyal Birger wrote:
> > Hi,
> >
> > On Wed, 16 Oct 2019 01:22:01 +0800
> > Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:
> > =20
> >> On 2019/10/15 1:57 =E4=B8=8A=E5=8D=88, Cong Wang wrote: =20
> >>> On Sat, Oct 12, 2019 at 12:16 AM Zhiyuan Hou
> >>> <zhiyuan2048@linux.alibaba.com> wrote: =20
> >>>> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> >>>> index 9ce073a05414..6108a64c0cd5 100644
> >>>> --- a/net/sched/act_mirred.c
> >>>> +++ b/net/sched/act_mirred.c
> >>>> @@ -18,6 +18,7 @@
> >>>>    #include <linux/gfp.h>
> >>>>    #include <linux/if_arp.h>
> >>>>    #include <net/net_namespace.h>
> >>>> +#include <net/dst.h>
> >>>>    #include <net/netlink.h>
> >>>>    #include <net/pkt_sched.h>
> >>>>    #include <net/pkt_cls.h>
> >>>> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff
> >>>> *skb, const struct tc_action *a,
> >>>>
> >>>>           if (!want_ingress)
> >>>>                   err =3D dev_queue_xmit(skb2);
> >>>> -       else
> >>>> +       else {
> >>>> +               skb_dst_drop(skb2);
> >>>>                   err =3D netif_receive_skb(skb2);
> >>>> +       } =20
> >>> Good catch! =20
> > Indeed! Thanks for fixing this!
> > =20
> >>> I don't want to be picky, but it seems this is only needed
> >>> when redirecting from egress to ingress, right? That is,
> >>> ingress to ingress, or ingress to egress is okay? If not,
> >>> please fix all the cases while you are on it? =20
> >> Sure. But I think this patch is also needed when redirecting from
> >> ingress to ingress. Because we cannot assure that a skb has null
> >> dst in ingress redirection path. For example, if redirecting a skb
> >> from loopback's ingress to other device's ingress, the skb will
> >> take a dst.
> >>
> >> As commit logs point out, skb with valid dst cannot be made routing
> >> decision in following process. original dst may cause skb loss or
> >> other unexpected behavior. =20
> > On the other hand, removing the dst on ingress-to-ingress
> > redirection may remove LWT information on incoming packets, which
> > may be undesired. =20
> Sorry, I do not understand why lwt information is needed on
> ingress-to-ingress redirection. lwt is used on output path, isn't it?
> Can you please give more information?

On rx path tunnelled packets parameters received on a collect_md tunnel dev=
ice
are kept in a metadata dst. See ip_tunnel_rcv() 'tun_dst' parameter.

The rx metadata dst can be matched by a number of mechanisms like routing
rules, eBPF, OVS, and netfilter.

Eyal.
