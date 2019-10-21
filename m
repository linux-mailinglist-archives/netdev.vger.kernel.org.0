Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4710DDF705
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbfJUUu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:50:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35886 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbfJUUuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:50:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id 23so8529752pgk.3;
        Mon, 21 Oct 2019 13:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6iAk5MDCFpJbqBCPdQ4j/TZZ0opaOqLSGbfv8Ew9ypQ=;
        b=IKzJgQDKfy4GjkgeuRNsJSl5hNaeVpYrDO2SYzytWEepQnbGV6rsI5toxxKjRh5PMT
         6VI9ggnj/ScLYKy6pOj7UsMmsdyJqUDfk65cVGHoFsYcuPw6FL+lxDfj0ZkvgapU/D47
         D79vRQ5zcNJAF/MOc4OND3w18GIJc3O37Sr1/OJt357GrJjnHeBMOcCN+Ik2NUux7gR8
         1QlO/NddImG5mVXTR+eOteBu6fwHOU0+/McGVLMWGoUUsVJMJsmYNPHIBUakmLxzgIvO
         69t5m/ClfZQBckYX9nQxZP7Tt5ouOSXJB99FatQBfjZRPULLarNvz5dVghQNJ3YzGPMr
         6Afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6iAk5MDCFpJbqBCPdQ4j/TZZ0opaOqLSGbfv8Ew9ypQ=;
        b=j1z0lRJ5yrHyEKNr1HXFVqgy6CtN4WZ20YqnrQH963mOe8FRe4Kw++UsWZMrucJ/j3
         3imPSfJqiseK7wLFhbCLMJ85Htq85J7YC5gcq80PT20sxF1TNkNjrHVS6Zi6JEivrfB+
         33BGG0/zn+Nw6wYiQuH2/rlbnsyhDUrY6BnK+jDBGJ5bzcWKBPbSaYp45sX6bA4mJSZb
         C/SrjSypPHWkrmSUJTskon6SkXN+tzVquqchVHQfNxjn0+0GmWefmi57HQyATJx7KT4H
         CSn7AZnrZw1WF5qJbWuQIm8JAmYDDgT9LNRgbHADt/HlBMvzd36+VXkRLNGn8jVPKAM6
         yjBA==
X-Gm-Message-State: APjAAAXO6UoF1YIrH2C3KAq/lWfjMphXo1pP5zaH0DafGxdOWx/fGBMv
        M4tbakVLEBJQUJTNQNpZzkq4O5L/+a5ofXRUBeI=
X-Google-Smtp-Source: APXvYqwR5Li3X+63Jbdq8RTCNIFmXKFocUABThMsrd3+729Wa1Lg00Ac4jqQtaDsNFZgSF7SHKLTezOqLfVNWc4y1V0=
X-Received: by 2002:a17:90a:c48:: with SMTP id u8mr109443pje.16.1571691024729;
 Mon, 21 Oct 2019 13:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
 <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
 <e2bd3004-9f4b-f3ce-1214-2140f0b7cc61@linux.alibaba.com> <20191016151307.40f63896@jimi>
 <e16cfafe-059c-3106-835e-d32b7bb5ba61@linux.alibaba.com> <20191019002502.0519ea9b@jimi>
In-Reply-To: <20191019002502.0519ea9b@jimi>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 21 Oct 2019 13:50:13 -0700
Message-ID: <CAM_iQpW-y=Xo08AqYaGUWB8G7zdTimk8zXdHcsqYQir5AyPJJw@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 2:25 PM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> Hi,
>
> On Fri, 18 Oct 2019 00:33:53 +0800
> Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:
>
> > On 2019/10/16 8:13 =E4=B8=8B=E5=8D=88, Eyal Birger wrote:
> > > Hi,
> > >
> > > On Wed, 16 Oct 2019 01:22:01 +0800
> > > Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:
> > >
> > >> On 2019/10/15 1:57 =E4=B8=8A=E5=8D=88, Cong Wang wrote:
> > >>> On Sat, Oct 12, 2019 at 12:16 AM Zhiyuan Hou
> > >>> <zhiyuan2048@linux.alibaba.com> wrote:
> > >>>> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> > >>>> index 9ce073a05414..6108a64c0cd5 100644
> > >>>> --- a/net/sched/act_mirred.c
> > >>>> +++ b/net/sched/act_mirred.c
> > >>>> @@ -18,6 +18,7 @@
> > >>>>    #include <linux/gfp.h>
> > >>>>    #include <linux/if_arp.h>
> > >>>>    #include <net/net_namespace.h>
> > >>>> +#include <net/dst.h>
> > >>>>    #include <net/netlink.h>
> > >>>>    #include <net/pkt_sched.h>
> > >>>>    #include <net/pkt_cls.h>
> > >>>> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff
> > >>>> *skb, const struct tc_action *a,
> > >>>>
> > >>>>           if (!want_ingress)
> > >>>>                   err =3D dev_queue_xmit(skb2);
> > >>>> -       else
> > >>>> +       else {
> > >>>> +               skb_dst_drop(skb2);
> > >>>>                   err =3D netif_receive_skb(skb2);
> > >>>> +       }
> > >>> Good catch!
> > > Indeed! Thanks for fixing this!
> > >
> > >>> I don't want to be picky, but it seems this is only needed
> > >>> when redirecting from egress to ingress, right? That is,
> > >>> ingress to ingress, or ingress to egress is okay? If not,
> > >>> please fix all the cases while you are on it?
> > >> Sure. But I think this patch is also needed when redirecting from
> > >> ingress to ingress. Because we cannot assure that a skb has null
> > >> dst in ingress redirection path. For example, if redirecting a skb
> > >> from loopback's ingress to other device's ingress, the skb will
> > >> take a dst.
> > >>
> > >> As commit logs point out, skb with valid dst cannot be made routing
> > >> decision in following process. original dst may cause skb loss or
> > >> other unexpected behavior.
> > > On the other hand, removing the dst on ingress-to-ingress
> > > redirection may remove LWT information on incoming packets, which
> > > may be undesired.
> > Sorry, I do not understand why lwt information is needed on
> > ingress-to-ingress redirection. lwt is used on output path, isn't it?
> > Can you please give more information?
>
> On rx path tunnelled packets parameters received on a collect_md tunnel d=
evice
> are kept in a metadata dst. See ip_tunnel_rcv() 'tun_dst' parameter.
>
> The rx metadata dst can be matched by a number of mechanisms like routing
> rules, eBPF, OVS, and netfilter.

Should this meta information be kept when redirecting? The dest device
may be a non-tunnel device, so I don't know if it is still useful when
for non-tunnel devices.

Thanks.
