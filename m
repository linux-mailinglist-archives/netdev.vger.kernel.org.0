Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2935D1B18B8
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgDTVpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgDTVpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:45:05 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F6BC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:45:05 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id g184so7145580vsc.0
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WJvtHUsmM2XGggvrbH5EnGO2H1pl2qAHhvmlK+GkpEk=;
        b=mhrchzWJ7WgZfkpo5wATbkNPOgglFWt6gWhkX3hFRoIbYAiQ97NZZWHpmJbKLU3CK6
         sAHxckqysT2k1NplhRu7Pd92usV9XQ5PmnZI0LwR6CRtAqf87eNkI+gWdMb9kWFh+Ywi
         S6qQs6a3+czJHwBJg6W7bUpwAf+X3TOmxgqWWi+hQpKxOGTmK6HYs3Gs0Aj1VIrB88Hr
         geLbwKbdtlOT7rJU0/ItiQ1zJUxaNgTszeQL4nRgdmQ7iY3fKPVTHRg5Ijq5G8zeFlK9
         EBAVrL0vNaz9Jm78imIo5ZhbVt14HQxBwS9zcTfIWzStK1yQIqRtcGM8UY/o6quIlUPt
         avfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WJvtHUsmM2XGggvrbH5EnGO2H1pl2qAHhvmlK+GkpEk=;
        b=AVQXaqQ94K99i8hMnGKabKPpUNe9VtEnWXIdCwIojajzmpCq9UVZhAa8raHSZYaYmp
         7o9LX0eJLutu+zWEmz8pGPaJqAf+XqkVNjdt6ZO+RHLIZ+tyxt6vVTsNzH/ujPcotLpu
         GAUZeEB6rKm0F0Wx0IkzVNPXfKF9CbwrdhX/Seih3ohxh5j/44WtTfGoldiqD79iW8Z2
         Se3SckD3+v8DYPM7ZRSOOx3LIBBpysjdNJ6jUG5DqB17ylgGnhaB4BWyPSfmm8OkE72O
         PbbMutNR1YhcGf9C5UF3pEvYW4Oc6SiWz72Z0MFm5nh+asXjyd7ABoSEPL/pfMbKP88/
         OotQ==
X-Gm-Message-State: AGi0PuZJtnKFjKhCzDBL/ajkA5MURHjeu6WzVndM/vj3flCGfggXO4Jr
        DaIIwXwMUzTGeVOgU3SdeboQpPKEM1zVggB9B4TIAA==
X-Google-Smtp-Source: APiQypIj4LxqENy060CztLRyF25agmMlsmX9zJRHd2WkTdwA3AkRY4T+FK/3vpSFj4mheEXVfy3A1E9nPPmdIYkqT+o=
X-Received: by 2002:a05:6102:2d3:: with SMTP id h19mr10811378vsh.58.1587419104551;
 Mon, 20 Apr 2020 14:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <1584969039-74113-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1587032223-49460-3-git-send-email-xiangxia.m.yue@gmail.com>
 <CAOrHB_D1OQujNyw9StmHRknDQZywHB02z8berxm+aPUNgQhYnA@mail.gmail.com> <CAMDZJNUFHi1Gfw0rZ1hK3s0Ux29E3QxQe7M0=-BdWCW30O10Sg@mail.gmail.com>
In-Reply-To: <CAMDZJNUFHi1Gfw0rZ1hK3s0Ux29E3QxQe7M0=-BdWCW30O10Sg@mail.gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Mon, 20 Apr 2020 14:44:53 -0700
Message-ID: <CAOrHB_DAhbh3BROCgzAkCuMYE-f2gNEWfWGR5mfpRZWJDa8QHg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/5] net: openvswitch: set max limitation to meters
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Andy Zhou <azhou@ovn.org>, Ben Pfaff <blp@ovn.org>,
        William Tu <u9012063@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 5:28 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Mon, Apr 20, 2020 at 1:31 AM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> >
> > On Sat, Apr 18, 2020 at 10:25 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Don't allow user to create meter unlimitedly,
> > > which may cause to consume a large amount of kernel memory.
> > > The 200,000 meters may be fine in general case.
> > >
> > > Cc: Pravin B Shelar <pshelar@ovn.org>
> > > Cc: Andy Zhou <azhou@ovn.org>
> > > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > ---
> > >  net/openvswitch/meter.c | 21 +++++++++++++++------
> > >  net/openvswitch/meter.h |  1 +
> > >  2 files changed, 16 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> > > index 494a0014ecd8..1b6776f9c109 100644
> > > --- a/net/openvswitch/meter.c
> > > +++ b/net/openvswitch/meter.c
> > > @@ -137,6 +137,7 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> > >  {
> > >         struct dp_meter_instance *ti = rcu_dereference_ovsl(tbl->ti);
> > >         u32 hash = meter_hash(ti, meter->id);
> > > +       int err;
> > >
> > >         /*
> > >          * In generally, slot selected should be empty, because
> > > @@ -148,16 +149,24 @@ static int attach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> > >         dp_meter_instance_insert(ti, meter);
> > >
> > >         /* That function is thread-safe. */
> > > -       if (++tbl->count >= ti->n_meters)
> > > -               if (dp_meter_instance_realloc(tbl, ti->n_meters * 2))
> > > -                       goto expand_err;
> > > +       tbl->count++;
> > > +       if (tbl->count > DP_METER_NUM_MAX) {
> > > +               err = -EFBIG;
> > > +               goto attach_err;
> > > +       }
> > > +
> > > +       if (tbl->count >= ti->n_meters &&
> > > +           dp_meter_instance_realloc(tbl, ti->n_meters * 2)) {
> > > +               err = -ENOMEM;
> > > +               goto attach_err;
> > > +       }
> > >
> > >         return 0;
> > >
> > > -expand_err:
> > > +attach_err:
> > >         dp_meter_instance_remove(ti, meter);
> > >         tbl->count--;
> > > -       return -ENOMEM;
> > > +       return err;
> > >  }
> > >
> > >  static void detach_meter(struct dp_meter_table *tbl, struct dp_meter *meter)
> > > @@ -264,7 +273,7 @@ static int ovs_meter_cmd_features(struct sk_buff *skb, struct genl_info *info)
> > >         if (IS_ERR(reply))
> > >                 return PTR_ERR(reply);
> > >
> > > -       if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, U32_MAX) ||
> > > +       if (nla_put_u32(reply, OVS_METER_ATTR_MAX_METERS, DP_METER_NUM_MAX) ||
> > >             nla_put_u32(reply, OVS_METER_ATTR_MAX_BANDS, DP_MAX_BANDS))
> > >                 goto nla_put_failure;
> > >
> > > diff --git a/net/openvswitch/meter.h b/net/openvswitch/meter.h
> > > index d91940383bbe..cdfc6b9dbd42 100644
> > > --- a/net/openvswitch/meter.h
> > > +++ b/net/openvswitch/meter.h
> > > @@ -19,6 +19,7 @@ struct datapath;
> > >
> > >  #define DP_MAX_BANDS           1
> > >  #define DP_METER_ARRAY_SIZE_MIN        (1ULL << 10)
> > > +#define DP_METER_NUM_MAX       (200000ULL)
> > >
> > Lets make it configurable and default could 200k to allow
> > customization on different memory configurations.
> Great, set different limit depend on current system memory size like tcp ?

Yes. that could be useful.
