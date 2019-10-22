Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88F5EE0237
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 12:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbfJVKht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 06:37:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46445 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388327AbfJVKht (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 06:37:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id n15so6667581wrw.13;
        Tue, 22 Oct 2019 03:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G9L4o2fClACAWWCNYsMy4DkWIxVH39P4nMmUu/kqsjM=;
        b=l5Ps+imA913Yd2xTluwoQZv3So/ZE86l5oMm0JbXAvfSHnjgo7+UZUo0u7cV56O3Df
         mmQ2a8Pl0KzFyutA9BrkioQWWZTVY2zgqP8rqmsrvB/UVGH/TW98zOLQSJy+V07ECI5K
         YgXCavMlHTR60F1zJ5ObfJT2UUlJcJExmLcgGbEVnS3OosUuw6dTmSZZfckHSqV9JlSj
         LlcpbfHWIOyb6iC1bFYELchtgkVem8GaI36Zy0FP3yJ9gZQ9meH61ZuJTuhkhq8PRYwh
         DCzRs6cgQEmIXfSeZdNIW2ulfY7Uda1RxRze4Uet7XGezWU4ojZHqbCnaHiSLmyeT4Df
         7m4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G9L4o2fClACAWWCNYsMy4DkWIxVH39P4nMmUu/kqsjM=;
        b=gjYlIdxEtdS0r7saZY0cr0Q79bPqDnfKa3dnVQzmpL28KD4Aa2DxJgm+Kg46fEMLkf
         xY58bhszHgG3wpA1Fx+hdQX1DMOtivWAcOBojp8h0TGBu5SHWtVZGcD+AscsFNvbM7Mr
         c/OxPrExmMAmmXm7kJJOgj9osATBs2Dk0rDl7Vgz8Fu51IN2vWqoQth4WZWNRBlwXx05
         FU22LNucIHT2EQaxcoCWCSKpNOjN5mqr5WfEqVwzYlTUCleUF3dB4xd+YzonwZq9sAu8
         7Xq7OEdjJfbnjiS+mrDyXQF/lFQNrD/Eb2dz27FgFexmex37YN8pDDM/mQQC7OW/Bwre
         sGhg==
X-Gm-Message-State: APjAAAVfdYvKjfDq6vFH/a5tEMIwSTUFaz05oNVYOUWLayObanRjMSFI
        pxiWRaNXK6WbYBjEL4eBu/A=
X-Google-Smtp-Source: APXvYqxgt1ARic3a/z4PysM/Vs6tdxOzM7KUqsI484qeJr/DF00XLTrK5eupKukTZCAH1TXLqtxE7w==
X-Received: by 2002:adf:ea50:: with SMTP id j16mr2743215wrn.295.1571740666041;
        Tue, 22 Oct 2019 03:37:46 -0700 (PDT)
Received: from jimi (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id g69sm5111253wme.31.2019.10.22.03.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 03:37:45 -0700 (PDT)
Date:   Tue, 22 Oct 2019 13:37:39 +0300
From:   Eyal Birger <eyal.birger@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
Message-ID: <20191022133739.0f255bbe@jimi>
In-Reply-To: <CAM_iQpW-y=Xo08AqYaGUWB8G7zdTimk8zXdHcsqYQir5AyPJJw@mail.gmail.com>
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
        <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
        <e2bd3004-9f4b-f3ce-1214-2140f0b7cc61@linux.alibaba.com>
        <20191016151307.40f63896@jimi>
        <e16cfafe-059c-3106-835e-d32b7bb5ba61@linux.alibaba.com>
        <20191019002502.0519ea9b@jimi>
        <CAM_iQpW-y=Xo08AqYaGUWB8G7zdTimk8zXdHcsqYQir5AyPJJw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 21 Oct 2019 13:50:13 -0700
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> On Fri, Oct 18, 2019 at 2:25 PM Eyal Birger <eyal.birger@gmail.com>
> wrote:
> >
> > Hi,
> >
> > On Fri, 18 Oct 2019 00:33:53 +0800
> > Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:
> >
> > > On 2019/10/16 8:13 =E4=B8=8B=E5=8D=88, Eyal Birger wrote:
> > > > Hi,
> > > >
> > > > On Wed, 16 Oct 2019 01:22:01 +0800
> > > > Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:
> > > >
> > > >> On 2019/10/15 1:57 =E4=B8=8A=E5=8D=88, Cong Wang wrote:
> > > >>> On Sat, Oct 12, 2019 at 12:16 AM Zhiyuan Hou
> > > >>> <zhiyuan2048@linux.alibaba.com> wrote:
> > > >>>> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> > > >>>> index 9ce073a05414..6108a64c0cd5 100644
> > > >>>> --- a/net/sched/act_mirred.c
> > > >>>> +++ b/net/sched/act_mirred.c
> > > >>>> @@ -18,6 +18,7 @@
> > > >>>>    #include <linux/gfp.h>
> > > >>>>    #include <linux/if_arp.h>
> > > >>>>    #include <net/net_namespace.h>
> > > >>>> +#include <net/dst.h>
> > > >>>>    #include <net/netlink.h>
> > > >>>>    #include <net/pkt_sched.h>
> > > >>>>    #include <net/pkt_cls.h>
> > > >>>> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff
> > > >>>> *skb, const struct tc_action *a,
> > > >>>>
> > > >>>>           if (!want_ingress)
> > > >>>>                   err =3D dev_queue_xmit(skb2);
> > > >>>> -       else
> > > >>>> +       else {
> > > >>>> +               skb_dst_drop(skb2);
> > > >>>>                   err =3D netif_receive_skb(skb2);
> > > >>>> +       }
> > > >>> Good catch!
> > > > Indeed! Thanks for fixing this!
> > > >
> > > >>> I don't want to be picky, but it seems this is only needed
> > > >>> when redirecting from egress to ingress, right? That is,
> > > >>> ingress to ingress, or ingress to egress is okay? If not,
> > > >>> please fix all the cases while you are on it?
> > > >> Sure. But I think this patch is also needed when redirecting
> > > >> from ingress to ingress. Because we cannot assure that a skb
> > > >> has null dst in ingress redirection path. For example, if
> > > >> redirecting a skb from loopback's ingress to other device's
> > > >> ingress, the skb will take a dst.
> > > >>
> > > >> As commit logs point out, skb with valid dst cannot be made
> > > >> routing decision in following process. original dst may cause
> > > >> skb loss or other unexpected behavior.
> > > > On the other hand, removing the dst on ingress-to-ingress
> > > > redirection may remove LWT information on incoming packets,
> > > > which may be undesired.
> > > Sorry, I do not understand why lwt information is needed on
> > > ingress-to-ingress redirection. lwt is used on output path, isn't
> > > it? Can you please give more information?
> >
> > On rx path tunnelled packets parameters received on a collect_md
> > tunnel device are kept in a metadata dst. See ip_tunnel_rcv()
> > 'tun_dst' parameter.
> >
> > The rx metadata dst can be matched by a number of mechanisms like
> > routing rules, eBPF, OVS, and netfilter.
>=20
> Should this meta information be kept when redirecting? The dest device
> may be a non-tunnel device, so I don't know if it is still useful when
> for non-tunnel devices.

I think that on ingress-to-ingress redirect it would make sense to keep the
metadata.

The dest device does not have to be a tunnel device AFAICT in order to use
tunnel info as skb_tunnel_info() does not observe skb->dev.

I don't see why going through mirred redirect should prevent the admin from
matching the packet based on LWT metadata - a packet may arrive on a collec=
t_md
tunnel device, be ingress-redirected to different devices based on different
criteria, then routed based also on the tunnel parameters.

Eyal.
