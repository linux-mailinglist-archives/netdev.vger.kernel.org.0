Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC4F5D9082
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404985AbfJPMNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:13:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54290 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392915AbfJPMNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:13:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id p7so2656800wmp.4;
        Wed, 16 Oct 2019 05:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z5f0yIHlY12I4Q0pn5WdnGvacnYGRlqyDdoVhSRxe6w=;
        b=KXVD9nR2ME+vjiKCYNNlVGSIEL/PKns1EI1ssBfrfHxMZ717aw8ibU2cG4R4m6NSqN
         p3OmoJyT2lcjfH44LwfVR/VmCVbdH3GYLFw+V32nkyf8EcGxcvnqQpSRj0LQ3r10ocjB
         8y5GPTJalQIciPmxHp4zSqM5VCiZEYK6BEnUw90H5439Tjy6JrHed1S+Pms/1sS/iH52
         YCShR+vFhVmyMDOor5kVy3Tirlhg61IVASfyCzxIunRQdNrff4w8wb16pDV2veZUaH19
         6zb+Q6HaZjq0dcc+V+f+wTmgUTvAfV8xRNZu7TeFl8ElKDDGLLdLHb+gYvtA8b2MkZlg
         1UqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z5f0yIHlY12I4Q0pn5WdnGvacnYGRlqyDdoVhSRxe6w=;
        b=sxgLkyTOmXWL5jCRND3AAm1+LbjJWKtITXxbjgfQwArjECW7xLdbuYYWoIkRxo6vLZ
         ulMJq7lKNYjqK9YaUQUw4ZzNp40L6mNZV0zjFQRbxqmaLYmvyjYxzH0M33SCPONpi0H/
         DAtxXSTUx7nHmsjD5pZ+LOMTFKcms3JKGyc/V08b+QYFXDqmFGJBMWX2HJCPPWfheL5u
         mJJKvECfqG32lgS4QfZFYaUwPiJbOfAlXYQVznfDuem6r/SjDiaWbOl4n05iMOw34KhZ
         GM6DusNFunCP7EIT3dCp1RDXtW+8tS7dNWU15KjubJw4EKudcBJe8kuoTMLPh9r/eI7k
         Fxfg==
X-Gm-Message-State: APjAAAV/CBnDkP3jyhY4ZhKtPaBwUWgbnaCH2NHn0Tms6GSB+sOhfW59
        1OBKvv43RSsnXgOktOx6NEs=
X-Google-Smtp-Source: APXvYqyeVI+HFQYVT9eZ+9AlMthA0eXmjO4czOYpC+SavUTyCKX+/KdD9iVqXyFN9hlGr/yH4Fa32g==
X-Received: by 2002:a1c:9a03:: with SMTP id c3mr3230806wme.109.1571227994744;
        Wed, 16 Oct 2019 05:13:14 -0700 (PDT)
Received: from jimi (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id d193sm2995178wmd.0.2019.10.16.05.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 05:13:14 -0700 (PDT)
Date:   Wed, 16 Oct 2019 15:13:07 +0300
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
Message-ID: <20191016151307.40f63896@jimi>
In-Reply-To: <e2bd3004-9f4b-f3ce-1214-2140f0b7cc61@linux.alibaba.com>
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
        <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
        <e2bd3004-9f4b-f3ce-1214-2140f0b7cc61@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 16 Oct 2019 01:22:01 +0800
Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:

> On 2019/10/15 1:57 =E4=B8=8A=E5=8D=88, Cong Wang wrote:
> > On Sat, Oct 12, 2019 at 12:16 AM Zhiyuan Hou
> > <zhiyuan2048@linux.alibaba.com> wrote: =20
> >> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> >> index 9ce073a05414..6108a64c0cd5 100644
> >> --- a/net/sched/act_mirred.c
> >> +++ b/net/sched/act_mirred.c
> >> @@ -18,6 +18,7 @@
> >>   #include <linux/gfp.h>
> >>   #include <linux/if_arp.h>
> >>   #include <net/net_namespace.h>
> >> +#include <net/dst.h>
> >>   #include <net/netlink.h>
> >>   #include <net/pkt_sched.h>
> >>   #include <net/pkt_cls.h>
> >> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff
> >> *skb, const struct tc_action *a,
> >>
> >>          if (!want_ingress)
> >>                  err =3D dev_queue_xmit(skb2);
> >> -       else
> >> +       else {
> >> +               skb_dst_drop(skb2);
> >>                  err =3D netif_receive_skb(skb2);
> >> +       } =20

> > Good catch!

Indeed! Thanks for fixing this!

> >
> > I don't want to be picky, but it seems this is only needed
> > when redirecting from egress to ingress, right? That is,
> > ingress to ingress, or ingress to egress is okay? If not,
> > please fix all the cases while you are on it? =20
> Sure. But I think this patch is also needed when redirecting from
> ingress to ingress. Because we cannot assure that a skb has null dst
> in ingress redirection path. For example, if redirecting a skb from
> loopback's ingress to other device's ingress, the skb will take a
> dst.
>=20
> As commit logs point out, skb with valid dst cannot be made routing
> decision in following process. original dst may cause skb loss or
> other unexpected behavior.

On the other hand, removing the dst on ingress-to-ingress redirection
may remove LWT information on incoming packets, which may be undesired.

Eyal.
