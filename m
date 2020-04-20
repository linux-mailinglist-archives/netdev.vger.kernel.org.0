Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44C21AFF2E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 02:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgDTA2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 20:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbgDTA2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 20:28:38 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E309C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:28:38 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id v7so8960404qkc.0
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 17:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ezZ6tFWB49lzTRQRn3N7MqmRhN1b2YxlsHDMzoQKG5o=;
        b=irapZj3yde9wRAoUzAf+8FbhOtLsdeB54I4ItgeY3ydCkaOH2hDR7PN2abdl5gpbbZ
         MxGlqjJ7duZWDQyz/bxtM/HtFmD80VRYHa0RQG3T8kSTZttFCTp/eCSp89kCv1wGuiNG
         NSJKfzyvBZ0sdKdf894s7idy+g1ZPaqkXh6mElmN+Qp+xav/6Lq3oiW7IR0wj6wQm7NB
         GVV1wysJrXUZ3HzqatXY+p0qoc949cHS3d4KnKoDRHjq4gk5WH7a2Qa4kOVRDadi29Fu
         DU33WfYx7fvxYkrZusF7Bwrlv1cwpb000xtJNUWt64piXhso3OPyYWx8vk0ahKwoKVN8
         DRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ezZ6tFWB49lzTRQRn3N7MqmRhN1b2YxlsHDMzoQKG5o=;
        b=caLxKszX1Hd4uPGo6g18UTQ/8GquOM4Jf9nfBxLLtziHU/qIKMOf58xsS4uHTBz/2g
         BR3bZeEMiXZ1KD4Oc5S5jCYRHjvagVkg0Gj5kgVO3PJv73lbCQPq3JqZ0JTNocSc0BEo
         KSwSjynglsJCtrvomNpTqMgWZz4oFYdBQtYIpy0zKwIttesm1MQ489/6H1/EwSvPGpsJ
         U9ooDjimuct8DbHlMbM0FkB2NUk1GUm76YKIurN0hTICGDuCpxF11djDb1esEW0bv/t3
         LOEXz/K8WRMTZZ14eqr2wvFzhn6K2hP2IRY7vxqUmfoEJWjrt2ZSVJ1s6WxrgxBEJvqy
         j/BA==
X-Gm-Message-State: AGi0PuaxgNZH2HKQff9dsWEbLJRf0l5WaULytX0eVWabqq+9ve9ytP9K
        uFJuRGxMGmW5b+4sTUChk/ULQsJAAI0fuipwBzE=
X-Google-Smtp-Source: APiQypJLjaC+m9D+TI0OcD6Ph0gFRcZ0H+2yKTE0n0fzLaGqe8xwewvUNy5uvykkJp3AGwAUG3pSYzlOBb1NQuHC1ZU=
X-Received: by 2002:a37:6585:: with SMTP id z127mr13536714qkb.203.1587342517638;
 Sun, 19 Apr 2020 17:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-3-git-send-email-xiangxia.m.yue@gmail.com> <CAOrHB_D1OQujNyw9StmHRknDQZywHB02z8berxm+aPUNgQhYnA@mail.gmail.com>
In-Reply-To: <CAOrHB_D1OQujNyw9StmHRknDQZywHB02z8berxm+aPUNgQhYnA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 20 Apr 2020 08:28:01 +0800
Message-ID: <CAMDZJNUFHi1Gfw0rZ1hK3s0Ux29E3QxQe7M0=-BdWCW30O10Sg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/5] net: openvswitch: set max limitation to meters
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 1:31 AM Pravin Shelar <pravin.ovn@gmail.com> wrote:
>
> On Sat, Apr 18, 2020 at 10:25 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Don't allow user to create meter unlimitedly,
> > which may cause to consume a large amount of kernel memory.
> > The 200,000 meters may be fine in general case.
> >
> > Cc: Pravin B Shelar <pshelar@ovn.org>
> > Cc: Andy Zhou <azhou@ovn.org>
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  net/openvswitch/meter.c | 21 +++++++++++++++------
> >  net/openvswitch/meter.h |  1 +
> >  2 files changed, 16 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > index 494a0014ecd8..1b6776f9c109 100644
> > --- a/net/openvswitch/meter.c
> > +++ b/net/openvswitch/meter.c
> > @@ -137,6 +137,7 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> >  {
> >         struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> >         u32 hash = meter_hash(ti, meter->id);
> > +       int err;
> >
> >         /*
> >          * In generally, slot selected should be empty, because
> > @@ -148,16 +149,24 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> >         dp_meter_instance_insert(ti, meter);
> >
> >         /* That function is thread-safe. */
> > -       if (++tbl->count >= ti->n_meters)
> > -               if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
> > -                       goto expand_err;
> > +       tbl->count++;
> > +       if (tbl->count > DP_METER_NUM_MAX) {
> > +               err = -EFBIG;
> > +               goto attach_err;
> > +       }
> > +
> > +       if (tbl->count >= ti->n_meters &&
> > +           dp_meter_instance_realloc(tbl, ti->n_meters * 2)) {
> > +               err = -ENOMEM;
> > +               goto attach_err;
> > +       }
> >
> >         return 0;
> >
> > -expand_err:
> > +attach_err:
> >         dp_meter_instance_remove(ti, meter);
> >         tbl->count--;
> > -       return -ENOMEM;
> > +       return err;
> >  }
> >
> >  static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> > @@ -264,7 +273,7 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
> >         if (IS_ERR(reply))
> >                 return PTR_ERR(reply);
> >
> > -       if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, U32_MAX) ||
> > +       if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, DP_METER_NUM_MAX) ||
> >             nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
> >                 goto nla_put_failure;
> >
> > diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
> > index d91940383bbe..cdfc6b9dbd42 100644
> > --- a/net/openvswitch/meter.h
> > +++ b/net/openvswitch/meter.h
> > @@ -19,6 +19,7 @@ struct datapath;
> >
> >  #define DP_MAX_BANDS           1
> >  #define DP_METER_ARRAY_SIZE_MIN        (1ULL << 10)
> > +#define DP_METER_NUM_MAX       (200000ULL)
> >
> Lets make it configurable and default could 200k to allow
> customization on different memory configurations.
Great, set different limit depend on current system memory size like tcp ?
>
> >  struct dp_meter_band {
> >         u32 type;
> > --
> > 2.23.0
> >



-- 
Best regards, Tonghao
