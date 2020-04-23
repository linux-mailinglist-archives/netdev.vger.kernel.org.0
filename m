Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA31B5644
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDWHm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:42:57 -0400
Received: from mail.buslov.dev ([199.247.26.29]:59899 "EHLO mail.buslov.dev"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgDWHm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 03:42:56 -0400
Received: from vlad-x1g6 (unknown [IPv6:2a01:d0:40b3:9801:fec2:781d:de90:e768])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 42D4E1F4ED;
        Thu, 23 Apr 2020 10:42:46 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1587627767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jnOu6eHr3UTCs1AWf7dlGZgMirm5uE+uxfSkhjv0lck=;
        b=q4B70oDj47loMFfdX10taixekMJ0nuNyT0AkeANzgxKIj6nPDQWPvPsXJgy3G271Wr2klE
        GgK7JKnyg+gWAfwJiwWyKzuFU1LVQspOzInhac0fmp+zTBUXo9W+uTdQRhfEtJPrVysCBK
        UBFHy7Fns0JIDbhuw6Vmm82py/cjrjjtbvv6NH3uiMWFpzxYZ4XxCb/5o9gpEtxRRur3RK
        ZzV9QfaOkTOS9Nn3DdW0eidEGpVpHzx3xFLU0lPdBHxr2Eas9exD/a3u7ASE+zPtFnoUOi
        jgvOolbJUYZZw7wzTYurG2yTcoK6rG2lZrdxjiddk7sOPi+fv4yrKHqTp0Popg==
References: <20200418011211.31725-5-Po.Liu@nxp.com> <20200422024852.23224-1-Po.Liu@nxp.com> <20200422024852.23224-2-Po.Liu@nxp.com> <877dy7bqo7.fsf@buslov.dev> <VE1PR04MB6496969AB18E17938671FA6092D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
User-agent: mu4e 1.4.1; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Po Liu <po.liu@nxp.com>
Cc:     Vlad Buslov <vlad@buslov.dev>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes\@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan\@broadcom.com" <michael.chan@broadcom.com>,
        "vishal\@chelsio.com" <vishal@chelsio.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "leon\@kernel.org" <leon@kernel.org>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "idosch\@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni\@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver\@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "moshe\@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2\@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes\@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control flow action
In-reply-to: <VE1PR04MB6496969AB18E17938671FA6092D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
Date:   Thu, 23 Apr 2020 10:43:01 +0300
Message-ID: <871roebqbe.fsf@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 23 Apr 2020 at 06:14, Po Liu <po.liu@nxp.com> wrote:
> Hi Vlad Buslov,
>
>> -----Original Message-----
>> From: Vlad Buslov <vlad@buslov.dev>
>> Sent: 2020=E5=B9=B44=E6=9C=8822=E6=97=A5 21:23
>> To: Po Liu <po.liu@nxp.com>
>> Cc: davem@davemloft.net; linux-kernel@vger.kernel.org;
>> netdev@vger.kernel.org; vinicius.gomes@intel.com; Claudiu Manoil
>> <claudiu.manoil@nxp.com>; Vladimir Oltean <vladimir.oltean@nxp.com>;
>> Alexandru Marginean <alexandru.marginean@nxp.com>;
>> michael.chan@broadcom.com; vishal@chelsio.com;
>> saeedm@mellanox.com; leon@kernel.org; jiri@mellanox.com;
>> idosch@mellanox.com; alexandre.belloni@bootlin.com;
>> UNGLinuxDriver@microchip.com; kuba@kernel.org; jhs@mojatatu.com;
>> xiyou.wangcong@gmail.com; simon.horman@netronome.com;
>> pablo@netfilter.org; moshe@mellanox.com; m-karicheri2@ti.com;
>> andre.guedes@linux.intel.com; stephen@networkplumber.org
>> Subject: [EXT] Re: [v3,net-next 1/4] net: qos: introduce a gate control =
flow
>> action
>>=20
>> Caution: EXT Email
>>=20
>> Hi Po,
>>=20
>> On Wed 22 Apr 2020 at 05:48, Po Liu <Po.Liu@nxp.com> wrote:
>> > Introduce a ingress frame gate control flow action.
>> > Tc gate action does the work like this:
>> > Assume there is a gate allow specified ingress frames can be passed at
>> > specific time slot, and be dropped at specific time slot. Tc filter
>> > chooses the ingress frames, and tc gate action would specify what slot
>> > does these frames can be passed to device and what time slot would be
>> > dropped.
>> > Tc gate action would provide an entry list to tell how much time gate
>> > keep open and how much time gate keep state close. Gate action also
>> > assign a start time to tell when the entry list start. Then driver
>> > would repeat the gate entry list cyclically.
>> > For the software simulation, gate action requires the user assign a
>> > time clock type.
>> >
>> > Below is the setting example in user space. Tc filter a stream source
>> > ip address is 192.168.0.20 and gate action own two time slots. One is
>> > last 200ms gate open let frame pass another is last 100ms gate close
>> > let frames dropped. When the frames have passed total frames over
>> > 8000000 bytes, frames will be dropped in one 200000000ns time slot.
>> >
>> >> tc qdisc add dev eth0 ingress
>> >
>> >> tc filter add dev eth0 parent ffff: protocol ip \
>> >          flower src_ip 192.168.0.20 \
>> >          action gate index 2 clockid CLOCK_TAI \
>> >          sched-entry open 200000000 -1 8000000 \
>> >          sched-entry close 100000000 -1 -1
>> >
>> >> tc chain del dev eth0 ingress chain 0
>> >
>> > "sched-entry" follow the name taprio style. Gate state is
>> > "open"/"close". Follow with period nanosecond. Then next item is
>> > internal priority value means which ingress queue should put. "-1"
>> > means wildcard. The last value optional specifies the maximum number
>> > of MSDU octets that are permitted to pass the gate during the
>> > specified time interval.
>> > Base-time is not set will be 0 as default, as result start time would
>> > be ((N + 1) * cycletime) which is the minimal of future time.
>> >
>> > Below example shows filtering a stream with destination mac address is
>> > 10:00:80:00:00:00 and ip type is ICMP, follow the action gate. The
>> > gate action would run with one close time slot which means always keep
>> close.
>> > The time cycle is total 200000000ns. The base-time would calculate by:
>> >
>> >  1357000000000 + (N + 1) * cycletime
>> >
>> > When the total value is the future time, it will be the start time.
>> > The cycletime here would be 200000000ns for this case.
>> >
>> >> tc filter add dev eth0 parent ffff:  protocol ip \
>> >          flower skip_hw ip_proto icmp dst_mac 10:00:80:00:00:00 \
>> >          action gate index 12 base-time 1357000000000 \
>> >          sched-entry close 200000000 -1 -1 \
>> >          clockid CLOCK_TAI
>> >
>> > Signed-off-by: Po Liu <Po.Liu@nxp.com>
>> > ---
>> >  include/net/tc_act/tc_gate.h        |  54 +++
>> >  include/uapi/linux/pkt_cls.h        |   1 +
>> >  include/uapi/linux/tc_act/tc_gate.h |  47 ++
>> >  net/sched/Kconfig                   |  13 +
>> >  net/sched/Makefile                  |   1 +
>> >  net/sched/act_gate.c                | 647 ++++++++++++++++++++++++++++
>> >  6 files changed, 763 insertions(+)
>> >  create mode 100644 include/net/tc_act/tc_gate.h  create mode 100644
>> > include/uapi/linux/tc_act/tc_gate.h
>> >  create mode 100644 net/sched/act_gate.c
>> >
>> > diff --git a/include/net/tc_act/tc_gate.h
>> > b/include/net/tc_act/tc_gate.h new file mode 100644 index
>> > 000000000000..b0ace55b2aaa
>> > --- /dev/null
>> > +++ b/include/net/tc_act/tc_gate.h
>> > @@ -0,0 +1,54 @@
>> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
>> > +/* Copyright 2020 NXP */
>> > +
>> > +#ifndef __NET_TC_GATE_H
>> > +#define __NET_TC_GATE_H
>> > +
>> > +#include <net/act_api.h>
>> > +#include <linux/tc_act/tc_gate.h>
>> > +
>> > +struct tcfg_gate_entry {
>> > +     int                     index;
>> > +     u8                      gate_state;
>> > +     u32                     interval;
>> > +     s32                     ipv;
>> > +     s32                     maxoctets;
>> > +     struct list_head        list;
>> > +};
>> > +
>> > +struct tcf_gate_params {
>> > +     s32                     tcfg_priority;
>> > +     u64                     tcfg_basetime;
>> > +     u64                     tcfg_cycletime;
>> > +     u64                     tcfg_cycletime_ext;
>> > +     u32                     tcfg_flags;
>> > +     s32                     tcfg_clockid;
>> > +     size_t                  num_entries;
>> > +     struct list_head        entries;
>> > +};
>> > +
>> > +#define GATE_ACT_GATE_OPEN   BIT(0)
>> > +#define GATE_ACT_PENDING     BIT(1)
>> > +struct gate_action {
>> > +     struct tcf_gate_params param;
>> > +     spinlock_t entry_lock;
>> > +     u8 current_gate_status;
>> > +     ktime_t current_close_time;
>> > +     u32 current_entry_octets;
>> > +     s32 current_max_octets;
>> > +     struct tcfg_gate_entry __rcu *next_entry;
>> > +     struct hrtimer hitimer;
>> > +     enum tk_offsets tk_offset;
>> > +     struct rcu_head rcu;
>> > +};
>> > +
>> > +struct tcf_gate {
>> > +     struct tc_action                common;
>> > +     struct gate_action __rcu        *actg;
>> > +};
>> > +#define to_gate(a) ((struct tcf_gate *)a)
>> > +
>> > +#define get_gate_param(act) ((struct tcf_gate_params *)act) #define
>> > +get_gate_action(p) ((struct gate_action *)p)
>> > +
>> > +#endif
>> > diff --git a/include/uapi/linux/pkt_cls.h
>> > b/include/uapi/linux/pkt_cls.h index 9f06d29cab70..fc672b232437
>> 100644
>> > --- a/include/uapi/linux/pkt_cls.h
>> > +++ b/include/uapi/linux/pkt_cls.h
>> > @@ -134,6 +134,7 @@ enum tca_id {
>> >       TCA_ID_CTINFO,
>> >       TCA_ID_MPLS,
>> >       TCA_ID_CT,
>> > +     TCA_ID_GATE,
>> >       /* other actions go here */
>> >       __TCA_ID_MAX =3D 255
>> >  };
>> > diff --git a/include/uapi/linux/tc_act/tc_gate.h
>> > b/include/uapi/linux/tc_act/tc_gate.h
>> > new file mode 100644
>> > index 000000000000..f214b3a6d44f
>> > --- /dev/null
>> > +++ b/include/uapi/linux/tc_act/tc_gate.h
>> > @@ -0,0 +1,47 @@
>> > +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
>> > +/* Copyright 2020 NXP */
>> > +
>> > +#ifndef __LINUX_TC_GATE_H
>> > +#define __LINUX_TC_GATE_H
>> > +
>> > +#include <linux/pkt_cls.h>
>> > +
>> > +struct tc_gate {
>> > +     tc_gen;
>> > +};
>> > +
>> > +enum {
>> > +     TCA_GATE_ENTRY_UNSPEC,
>> > +     TCA_GATE_ENTRY_INDEX,
>> > +     TCA_GATE_ENTRY_GATE,
>> > +     TCA_GATE_ENTRY_INTERVAL,
>> > +     TCA_GATE_ENTRY_IPV,
>> > +     TCA_GATE_ENTRY_MAX_OCTETS,
>> > +     __TCA_GATE_ENTRY_MAX,
>> > +};
>> > +#define TCA_GATE_ENTRY_MAX (__TCA_GATE_ENTRY_MAX - 1)
>> > +
>> > +enum {
>> > +     TCA_GATE_ONE_ENTRY_UNSPEC,
>> > +     TCA_GATE_ONE_ENTRY,
>> > +     __TCA_GATE_ONE_ENTRY_MAX,
>> > +};
>> > +#define TCA_GATE_ONE_ENTRY_MAX (__TCA_GATE_ONE_ENTRY_MAX
>> - 1)
>> > +
>> > +enum {
>> > +     TCA_GATE_UNSPEC,
>> > +     TCA_GATE_TM,
>> > +     TCA_GATE_PARMS,
>> > +     TCA_GATE_PAD,
>> > +     TCA_GATE_PRIORITY,
>> > +     TCA_GATE_ENTRY_LIST,
>> > +     TCA_GATE_BASE_TIME,
>> > +     TCA_GATE_CYCLE_TIME,
>> > +     TCA_GATE_CYCLE_TIME_EXT,
>> > +     TCA_GATE_FLAGS,
>> > +     TCA_GATE_CLOCKID,
>> > +     __TCA_GATE_MAX,
>> > +};
>> > +#define TCA_GATE_MAX (__TCA_GATE_MAX - 1)
>> > +
>> > +#endif
>> > diff --git a/net/sched/Kconfig b/net/sched/Kconfig index
>> > bfbefb7bff9d..1314549c7567 100644
>> > --- a/net/sched/Kconfig
>> > +++ b/net/sched/Kconfig
>> > @@ -981,6 +981,19 @@ config NET_ACT_CT
>> >         To compile this code as a module, choose M here: the
>> >         module will be called act_ct.
>> >
>> > +config NET_ACT_GATE
>> > +     tristate "Frame gate entry list control tc action"
>> > +     depends on NET_CLS_ACT
>> > +     help
>> > +       Say Y here to allow to control the ingress flow to be passed at
>> > +       specific time slot and be dropped at other specific time slot =
by
>> > +       the gate entry list. The manipulation will simulate the IEEE
>> > +       802.1Qci stream gate control behavior.
>> > +
>> > +       If unsure, say N.
>> > +       To compile this code as a module, choose M here: the
>> > +       module will be called act_gate.
>> > +
>> >  config NET_IFE_SKBMARK
>> >       tristate "Support to encoding decoding skb mark on IFE action"
>> >       depends on NET_ACT_IFE
>> > diff --git a/net/sched/Makefile b/net/sched/Makefile index
>> > 31c367a6cd09..66bbf9a98f9e 100644
>> > --- a/net/sched/Makefile
>> > +++ b/net/sched/Makefile
>> > @@ -30,6 +30,7 @@ obj-$(CONFIG_NET_IFE_SKBPRIO)       +=3D
>> act_meta_skbprio.o
>> >  obj-$(CONFIG_NET_IFE_SKBTCINDEX)     +=3D act_meta_skbtcindex.o
>> >  obj-$(CONFIG_NET_ACT_TUNNEL_KEY)+=3D act_tunnel_key.o
>> >  obj-$(CONFIG_NET_ACT_CT)     +=3D act_ct.o
>> > +obj-$(CONFIG_NET_ACT_GATE)   +=3D act_gate.o
>> >  obj-$(CONFIG_NET_SCH_FIFO)   +=3D sch_fifo.o
>> >  obj-$(CONFIG_NET_SCH_CBQ)    +=3D sch_cbq.o
>> >  obj-$(CONFIG_NET_SCH_HTB)    +=3D sch_htb.o
>> > diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c new file mode
>> > 100644 index 000000000000..e932f402b4f1
>> > --- /dev/null
>> > +++ b/net/sched/act_gate.c
>> > @@ -0,0 +1,647 @@
>> > +// SPDX-License-Identifier: GPL-2.0-or-later
>> > +/* Copyright 2020 NXP */
>> > +
>> > +#include <linux/module.h>
>> > +#include <linux/types.h>
>> > +#include <linux/kernel.h>
>> > +#include <linux/string.h>
>> > +#include <linux/errno.h>
>> > +#include <linux/skbuff.h>
>> > +#include <linux/rtnetlink.h>
>> > +#include <linux/init.h>
>> > +#include <linux/slab.h>
>> > +#include <net/act_api.h>
>> > +#include <net/netlink.h>
>> > +#include <net/pkt_cls.h>
>> > +#include <net/tc_act/tc_gate.h>
>> > +
>> > +static unsigned int gate_net_id;
>> > +static struct tc_action_ops act_gate_ops;
>> > +
>> > +static ktime_t gate_get_time(struct gate_action *gact) {
>> > +     ktime_t mono =3D ktime_get();
>> > +
>> > +     switch (gact->tk_offset) {
>> > +     case TK_OFFS_MAX:
>> > +             return mono;
>> > +     default:
>> > +             return ktime_mono_to_any(mono, gact->tk_offset);
>> > +     }
>> > +
>> > +     return KTIME_MAX;
>> > +}
>> > +
>> > +static int gate_get_start_time(struct gate_action *gact, ktime_t
>> > +*start) {
>> > +     struct tcf_gate_params *param =3D get_gate_param(gact);
>> > +     ktime_t now, base, cycle;
>> > +     u64 n;
>> > +
>> > +     base =3D ns_to_ktime(param->tcfg_basetime);
>> > +     now =3D gate_get_time(gact);
>> > +
>> > +     if (ktime_after(base, now)) {
>> > +             *start =3D base;
>> > +             return 0;
>> > +     }
>> > +
>> > +     cycle =3D param->tcfg_cycletime;
>> > +
>> > +     /* cycle time should not be zero */
>> > +     if (WARN_ON(!cycle))
>> > +             return -EFAULT;
>>=20
>> Looking at the init code it seems that this value can be set to 0 direct=
ly
>> from netlink packet without further validation, which would allow user to
>> trigger warning here.
>
> Yes,  will avoid at ahead point.
>
>>=20
>> > +
>> > +     n =3D div64_u64(ktime_sub_ns(now, base), cycle);
>> > +     *start =3D ktime_add_ns(base, (n + 1) * cycle);
>> > +     return 0;
>> > +}
>> > +
>> > +static void gate_start_timer(struct gate_action *gact, ktime_t start)
>> > +{
>> > +     ktime_t expires;
>> > +
>> > +     expires =3D hrtimer_get_expires(&gact->hitimer);
>> > +     if (expires =3D=3D 0)
>> > +             expires =3D KTIME_MAX;
>> > +
>> > +     start =3D min_t(ktime_t, start, expires);
>> > +
>> > +     hrtimer_start(&gact->hitimer, start, HRTIMER_MODE_ABS); }
>> > +
>> > +static enum hrtimer_restart gate_timer_func(struct hrtimer *timer) {
>> > +     struct gate_action *gact =3D container_of(timer, struct gate_act=
ion,
>> > +                                             hitimer);
>> > +     struct tcf_gate_params *p =3D get_gate_param(gact);
>> > +     struct tcfg_gate_entry *next;
>> > +     ktime_t close_time, now;
>> > +
>> > +     spin_lock(&gact->entry_lock);
>> > +
>> > +     next =3D rcu_dereference_protected(gact->next_entry,
>> > +
>> > + lockdep_is_held(&gact->entry_lock));
>> > +
>> > +     /* cycle start, clear pending bit, clear total octets */
>> > +     gact->current_gate_status =3D next->gate_state ?
>> GATE_ACT_GATE_OPEN : 0;
>> > +     gact->current_entry_octets =3D 0;
>> > +     gact->current_max_octets =3D next->maxoctets;
>> > +
>> > +     gact->current_close_time =3D ktime_add_ns(gact->current_close_ti=
me,
>> > +                                             next->interval);
>> > +
>> > +     close_time =3D gact->current_close_time;
>> > +
>> > +     if (list_is_last(&next->list, &p->entries))
>> > +             next =3D list_first_entry(&p->entries,
>> > +                                     struct tcfg_gate_entry, list);
>> > +     else
>> > +             next =3D list_next_entry(next, list);
>> > +
>> > +     now =3D gate_get_time(gact);
>> > +
>> > +     if (ktime_after(now, close_time)) {
>> > +             ktime_t cycle, base;
>> > +             u64 n;
>> > +
>> > +             cycle =3D p->tcfg_cycletime;
>> > +             base =3D ns_to_ktime(p->tcfg_basetime);
>> > +             n =3D div64_u64(ktime_sub_ns(now, base), cycle);
>> > +             close_time =3D ktime_add_ns(base, (n + 1) * cycle);
>> > +     }
>> > +
>> > +     rcu_assign_pointer(gact->next_entry, next);
>> > +     spin_unlock(&gact->entry_lock);
>>=20
>> I have couple of question about synchronization here:
>>=20
>> - Why do you need next_entry to be rcu pointer? It is only assigned here
>> with entry_lock protection and in init code before action is visible to
>> concurrent users. I don't see any unlocked rcu-protected readers here th=
at
>> could benefit from it.
>>=20
>> - Why create dedicated entry_lock instead of using already existing per-
>> action tcf_lock?
>
> Will try to use the tcf_lock for verification.
> The thoughts came from that the timer period arrived then check through t=
he list and then update next time would take much more time.  Action functi=
on would be busy when traffic. So use a separate lock here for=20=20
>
>>=20
>> > +
>> > +     hrtimer_set_expires(&gact->hitimer, close_time);
>> > +
>> > +     return HRTIMER_RESTART;
>> > +}
>> > +
>> > +static int tcf_gate_act(struct sk_buff *skb, const struct tc_action *=
a,
>> > +                     struct tcf_result *res) {
>> > +     struct tcf_gate *g =3D to_gate(a);
>> > +     struct gate_action *gact;
>> > +     int action;
>> > +
>> > +     tcf_lastuse_update(&g->tcf_tm);
>> > +     bstats_cpu_update(this_cpu_ptr(g->common.cpu_bstats), skb);
>> > +
>> > +     action =3D READ_ONCE(g->tcf_action);
>> > +     rcu_read_lock();
>>=20
>> Action fastpath is already rcu read lock protected, you don't need to
>> manually obtain it.
>
> Will be removed.
>
>>=20
>> > +     gact =3D rcu_dereference_bh(g->actg);
>> > +     if (unlikely(gact->current_gate_status & GATE_ACT_PENDING)) {
>>=20
>> Can't current_gate_status be concurrently modified by timer callback?
>> This function doesn't use entry_lock to synchronize with timer.
>
> Will try tcf_lock either.
>
>>=20
>> > +             rcu_read_unlock();
>> > +             return action;
>> > +     }
>> > +
>> > +     if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN))
>>=20
>> ...and here
>>=20
>> > +             goto drop;
>> > +
>> > +     if (gact->current_max_octets >=3D 0) {
>> > +             gact->current_entry_octets +=3D qdisc_pkt_len(skb);
>> > +             if (gact->current_entry_octets >
>> > + gact->current_max_octets) {
>>=20
>> here also.
>>=20
>> > +
>> > + qstats_overlimit_inc(this_cpu_ptr(g->common.cpu_qstats));
>>=20
>> Please use tcf_action_inc_overlimit_qstats() and other wrappers for stat=
s.
>> Otherwise it will crash if user passes TCA_ACT_FLAGS_NO_PERCPU_STATS
>> flag.
>
> The tcf_action_inc_overlimit_qstats() can't show limit counts in tc show =
command. Is there anything need to do?=20

What do you mean? Internally tcf_action_inc_overlimit_qstats() just
calls qstats_overlimit_inc, if cpu_qstats percpu counter is not NULL:


	if (likely(a->cpu_qstats)) {
		qstats_overlimit_inc(this_cpu_ptr(a->cpu_qstats));
		return;
	}

Is there a subtle bug somewhere in this function?

>
>>=20
>> > +                     goto drop;
>> > +             }
>> > +     }
>> > +     rcu_read_unlock();
>> > +
>> > +     return action;
>> > +drop:
>> > +     rcu_read_unlock();
>> > +     qstats_drop_inc(this_cpu_ptr(g->common.cpu_qstats));
>> > +     return TC_ACT_SHOT;
>> > +}
>> > +
>> > +static const struct nla_policy entry_policy[TCA_GATE_ENTRY_MAX + 1]
>> =3D {
>> > +     [TCA_GATE_ENTRY_INDEX]          =3D { .type =3D NLA_U32 },
>> > +     [TCA_GATE_ENTRY_GATE]           =3D { .type =3D NLA_FLAG },
>> > +     [TCA_GATE_ENTRY_INTERVAL]       =3D { .type =3D NLA_U32 },
>> > +     [TCA_GATE_ENTRY_IPV]            =3D { .type =3D NLA_S32 },
>> > +     [TCA_GATE_ENTRY_MAX_OCTETS]     =3D { .type =3D NLA_S32 },
>> > +};
>> > +
>> > +static const struct nla_policy gate_policy[TCA_GATE_MAX + 1] =3D {
>> > +     [TCA_GATE_PARMS]                =3D { .len =3D sizeof(struct tc_=
gate),
>> > +                                         .type =3D NLA_EXACT_LEN },
>> > +     [TCA_GATE_PRIORITY]             =3D { .type =3D NLA_S32 },
>> > +     [TCA_GATE_ENTRY_LIST]           =3D { .type =3D NLA_NESTED },
>> > +     [TCA_GATE_BASE_TIME]            =3D { .type =3D NLA_U64 },
>> > +     [TCA_GATE_CYCLE_TIME]           =3D { .type =3D NLA_U64 },
>> > +     [TCA_GATE_CYCLE_TIME_EXT]       =3D { .type =3D NLA_U64 },
>> > +     [TCA_GATE_FLAGS]                =3D { .type =3D NLA_U32 },
>> > +     [TCA_GATE_CLOCKID]              =3D { .type =3D NLA_S32 },
>> > +};
>> > +
>> > +static int fill_gate_entry(struct nlattr **tb, struct tcfg_gate_entry=
 *entry,
>> > +                        struct netlink_ext_ack *extack) {
>> > +     u32 interval =3D 0;
>> > +
>> > +     entry->gate_state =3D nla_get_flag(tb[TCA_GATE_ENTRY_GATE]);
>> > +
>> > +     if (tb[TCA_GATE_ENTRY_INTERVAL])
>> > +             interval =3D nla_get_u32(tb[TCA_GATE_ENTRY_INTERVAL]);
>> > +
>> > +     if (interval =3D=3D 0) {
>> > +             NL_SET_ERR_MSG(extack, "Invalid interval for schedule en=
try");
>> > +             return -EINVAL;
>> > +     }
>> > +
>> > +     entry->interval =3D interval;
>> > +
>> > +     if (tb[TCA_GATE_ENTRY_IPV])
>> > +             entry->ipv =3D nla_get_s32(tb[TCA_GATE_ENTRY_IPV]);
>> > +     else
>> > +             entry->ipv =3D -1;
>> > +
>> > +     if (tb[TCA_GATE_ENTRY_MAX_OCTETS])
>> > +             entry->maxoctets =3D
>> nla_get_s32(tb[TCA_GATE_ENTRY_MAX_OCTETS]);
>> > +     else
>> > +             entry->maxoctets =3D -1;
>> > +
>> > +     return 0;
>> > +}
>> > +
>> > +static int parse_gate_entry(struct nlattr *n, struct  tcfg_gate_entry
>> *entry,
>> > +                         int index, struct netlink_ext_ack *extack) {
>> > +     struct nlattr *tb[TCA_GATE_ENTRY_MAX + 1] =3D { };
>> > +     int err;
>>=20
>> > +     err =3D nla_parse_nested(tb, TCA_GATE_ENTRY_MAX, n, entry_policy,
>> extack);
>> > +     if (err < 0) {
>> > +             NL_SET_ERR_MSG(extack, "Could not parse nested entry");
>> > +             return -EINVAL;
>> > +     }
>> > +
>> > +     entry->index =3D index;
>> > +
>> > +     return fill_gate_entry(tb, entry, extack); }
>> > +
>> > +static int parse_gate_list(struct nlattr *list_attr,
>> > +                        struct tcf_gate_params *sched,
>> > +                        struct netlink_ext_ack *extack) {
>> > +     struct tcfg_gate_entry *entry, *e;
>> > +     struct nlattr *n;
>> > +     int err, rem;
>> > +     int i =3D 0;
>> > +
>> > +     if (!list_attr)
>> > +             return -EINVAL;
>> > +
>> > +     nla_for_each_nested(n, list_attr, rem) {
>> > +             if (nla_type(n) !=3D TCA_GATE_ONE_ENTRY) {
>> > +                     NL_SET_ERR_MSG(extack, "Attribute isn't type 'en=
try'");
>> > +                     continue;
>> > +             }
>> > +
>> > +             entry =3D kzalloc(sizeof(*entry), GFP_KERNEL);
>> > +             if (!entry) {
>> > +                     NL_SET_ERR_MSG(extack, "Not enough memory for en=
try");
>> > +                     err =3D -ENOMEM;
>> > +                     goto release_list;
>> > +             }
>> > +
>> > +             err =3D parse_gate_entry(n, entry, i, extack);
>> > +             if (err < 0) {
>> > +                     kfree(entry);
>> > +                     goto release_list;
>> > +             }
>> > +
>> > +             list_add_tail(&entry->list, &sched->entries);
>> > +             i++;
>> > +     }
>> > +
>> > +     sched->num_entries =3D i;
>> > +
>> > +     return i;
>> > +
>> > +release_list:
>> > +     list_for_each_entry_safe(entry, e, &sched->entries, list) {
>> > +             list_del(&entry->list);
>> > +             kfree(entry);
>> > +     }
>> > +
>> > +     return err;
>> > +}
>> > +
>> > +static int tcf_gate_init(struct net *net, struct nlattr *nla,
>> > +                      struct nlattr *est, struct tc_action **a,
>> > +                      int ovr, int bind, bool rtnl_held,
>> > +                      struct tcf_proto *tp, u32 flags,
>> > +                      struct netlink_ext_ack *extack) {
>> > +     struct tc_action_net *tn =3D net_generic(net, gate_net_id);
>> > +     enum tk_offsets tk_offset =3D TK_OFFS_TAI;
>> > +     struct nlattr *tb[TCA_GATE_MAX + 1];
>> > +     struct tcf_chain *goto_ch =3D NULL;
>> > +     struct tcfg_gate_entry *next;
>> > +     struct tcf_gate_params *p;
>> > +     struct gate_action *gact;
>> > +     s32 clockid =3D CLOCK_TAI;
>> > +     struct tc_gate *parm;
>> > +     struct tcf_gate *g;
>> > +     int ret =3D 0, err;
>> > +     u64 basetime =3D 0;
>> > +     u32 gflags =3D 0;
>> > +     s32 prio =3D -1;
>> > +     ktime_t start;
>> > +     u32 index;
>> > +
>> > +     if (!nla)
>> > +             return -EINVAL;
>> > +
>> > +     err =3D nla_parse_nested(tb, TCA_GATE_MAX, nla, gate_policy, ext=
ack);
>> > +     if (err < 0)
>> > +             return err;
>> > +
>> > +     if (!tb[TCA_GATE_PARMS])
>> > +             return -EINVAL;
>> > +     parm =3D nla_data(tb[TCA_GATE_PARMS]);
>> > +     index =3D parm->index;
>> > +     err =3D tcf_idr_check_alloc(tn, &index, a, bind);
>> > +     if (err < 0)
>> > +             return err;
>> > +
>> > +     if (err && bind)
>> > +             return 0;
>> > +
>> > +     if (!err) {
>> > +             ret =3D tcf_idr_create_from_flags(tn, index, est, a,
>> > +                                             &act_gate_ops, bind, fla=
gs);
>> > +             if (ret) {
>> > +                     tcf_idr_cleanup(tn, index);
>> > +                     return ret;
>> > +             }
>> > +
>> > +             ret =3D ACT_P_CREATED;
>> > +     } else if (!ovr) {
>> > +             tcf_idr_release(*a, bind);
>> > +             return -EEXIST;
>> > +     }
>> > +
>> > +     if (tb[TCA_GATE_PRIORITY])
>> > +             prio =3D nla_get_s32(tb[TCA_GATE_PRIORITY]);
>> > +
>> > +     if (tb[TCA_GATE_BASE_TIME])
>> > +             basetime =3D nla_get_u64(tb[TCA_GATE_BASE_TIME]);
>> > +
>> > +     if (tb[TCA_GATE_FLAGS])
>> > +             gflags =3D nla_get_u32(tb[TCA_GATE_FLAGS]);
>> > +
>> > +     if (tb[TCA_GATE_CLOCKID]) {
>> > +             clockid =3D nla_get_s32(tb[TCA_GATE_CLOCKID]);
>> > +             switch (clockid) {
>> > +             case CLOCK_REALTIME:
>> > +                     tk_offset =3D TK_OFFS_REAL;
>> > +                     break;
>> > +             case CLOCK_MONOTONIC:
>> > +                     tk_offset =3D TK_OFFS_MAX;
>> > +                     break;
>> > +             case CLOCK_BOOTTIME:
>> > +                     tk_offset =3D TK_OFFS_BOOT;
>> > +                     break;
>> > +             case CLOCK_TAI:
>> > +                     tk_offset =3D TK_OFFS_TAI;
>> > +                     break;
>> > +             default:
>> > +                     NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
>> > +                     goto release_idr;
>> > +             }
>> > +     }
>> > +
>> > +     err =3D tcf_action_check_ctrlact(parm->action, tp, &goto_ch, ext=
ack);
>> > +     if (err < 0)
>> > +             goto release_idr;
>> > +
>> > +     g =3D to_gate(*a);
>> > +
>> > +     gact =3D kzalloc(sizeof(*gact), GFP_KERNEL);
>> > +     if (!gact) {
>> > +             err =3D -ENOMEM;
>> > +             goto put_chain;
>> > +     }
>> > +
>> > +     p =3D get_gate_param(gact);
>> > +
>> > +     INIT_LIST_HEAD(&p->entries);
>> > +     if (tb[TCA_GATE_ENTRY_LIST]) {
>> > +             err =3D parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, exta=
ck);
>> > +             if (err < 0)
>> > +                     goto release_mem;
>> > +     }
>> > +
>> > +     if (tb[TCA_GATE_CYCLE_TIME]) {
>> > +             p->tcfg_cycletime =3D nla_get_u64(tb[TCA_GATE_CYCLE_TIME=
]);
>> > +     } else {
>> > +             struct tcfg_gate_entry *entry;
>> > +             ktime_t cycle =3D 0;
>> > +
>> > +             list_for_each_entry(entry, &p->entries, list)
>> > +                     cycle =3D ktime_add_ns(cycle, entry->interval);
>> > +             p->tcfg_cycletime =3D cycle;
>> > +     }
>> > +
>> > +     if (tb[TCA_GATE_CYCLE_TIME_EXT])
>> > +             p->tcfg_cycletime_ext =3D
>> > +                     nla_get_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
>> > +
>> > +     p->tcfg_priority =3D prio;
>> > +     p->tcfg_basetime =3D basetime;
>> > +     p->tcfg_clockid =3D clockid;
>> > +     p->tcfg_flags =3D gflags;
>> > +
>> > +     gact->tk_offset =3D tk_offset;
>> > +     spin_lock_init(&gact->entry_lock);
>> > +     hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS);
>> > +     gact->hitimer.function =3D gate_timer_func;
>> > +
>> > +     err =3D gate_get_start_time(gact, &start);
>> > +     if (err < 0) {
>> > +             NL_SET_ERR_MSG(extack,
>> > +                            "Internal error: failed get start time");
>> > +             goto release_mem;
>> > +     }
>> > +
>> > +     gact->current_close_time =3D start;
>> > +     gact->current_gate_status =3D GATE_ACT_GATE_OPEN |
>> > + GATE_ACT_PENDING;
>> > +
>> > +     next =3D list_first_entry(&p->entries, struct tcfg_gate_entry, l=
ist);
>> > +     rcu_assign_pointer(gact->next_entry, next);
>> > +
>> > +     gate_start_timer(gact, start);
>> > +
>> > +     spin_lock_bh(&g->tcf_lock);
>> > +     goto_ch =3D tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>> > +     gact =3D rcu_replace_pointer(g->actg, gact,
>> > +                                lockdep_is_held(&g->tcf_lock));
>> > +     spin_unlock_bh(&g->tcf_lock);
>> > +
>> > +     if (goto_ch)
>> > +             tcf_chain_put_by_act(goto_ch);
>> > +     if (gact)
>> > +             kfree_rcu(gact, rcu);
>>=20
>> This leaks entries. For example, tunnel key action implements
>> tunnel_key_release_params() helper that is used by both init and release
>> code. I guess that would be the best approach here as well.
>>=20
>
> Will refer the tunnel action. Thanks for pointing out.
>
>> > +
>> > +     if (ret =3D=3D ACT_P_CREATED)
>> > +             tcf_idr_insert(tn, *a);
>> > +     return ret;
>> > +
>> > +release_mem:
>> > +     kfree(gact);
>> > +put_chain:
>> > +     if (goto_ch)
>> > +             tcf_chain_put_by_act(goto_ch);
>> > +release_idr:
>> > +     tcf_idr_release(*a, bind);
>> > +     return err;
>> > +}
>> > +
>> > +static void tcf_gate_cleanup(struct tc_action *a) {
>> > +     struct tcf_gate *g =3D to_gate(a);
>> > +     struct tcfg_gate_entry *entry, *n;
>> > +     struct tcf_gate_params *p;
>> > +     struct gate_action *gact;
>> > +
>> > +     spin_lock_bh(&g->tcf_lock);
>> > +     gact =3D rcu_dereference_protected(g->actg,
>> > +                                      lockdep_is_held(&g->tcf_lock));
>> > +     hrtimer_cancel(&gact->hitimer);
>> > +
>> > +     p =3D get_gate_param(gact);
>> > +     list_for_each_entry_safe(entry, n, &p->entries, list) {
>> > +             list_del(&entry->list);
>> > +             kfree(entry);
>> > +     }
>> > +     spin_unlock_bh(&g->tcf_lock);
>> > +
>> > +     kfree_rcu(gact, rcu);
>> > +}
>> > +
>> > +static int dumping_entry(struct sk_buff *skb,
>> > +                      struct tcfg_gate_entry *entry) {
>> > +     struct nlattr *item;
>> > +
>> > +     item =3D nla_nest_start_noflag(skb, TCA_GATE_ONE_ENTRY);
>> > +     if (!item)
>> > +             return -ENOSPC;
>> > +
>> > +     if (nla_put_u32(skb, TCA_GATE_ENTRY_INDEX, entry->index))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (entry->gate_state && nla_put_flag(skb, TCA_GATE_ENTRY_GATE))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_u32(skb, TCA_GATE_ENTRY_INTERVAL, entry->interval))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_s32(skb, TCA_GATE_ENTRY_MAX_OCTETS, entry-
>> >maxoctets))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_s32(skb, TCA_GATE_ENTRY_IPV, entry->ipv))
>> > +             goto nla_put_failure;
>> > +
>> > +     return nla_nest_end(skb, item);
>> > +
>> > +nla_put_failure:
>> > +     nla_nest_cancel(skb, item);
>> > +     return -1;
>> > +}
>> > +
>> > +static int tcf_gate_dump(struct sk_buff *skb, struct tc_action *a,
>> > +                      int bind, int ref) {
>> > +     unsigned char *b =3D skb_tail_pointer(skb);
>> > +     struct tcf_gate *g =3D to_gate(a);
>> > +     struct tc_gate opt =3D {
>> > +             .index    =3D g->tcf_index,
>> > +             .refcnt   =3D refcount_read(&g->tcf_refcnt) - ref,
>> > +             .bindcnt  =3D atomic_read(&g->tcf_bindcnt) - bind,
>> > +     };
>> > +     struct tcfg_gate_entry *entry;
>> > +     struct gate_action *gact;
>> > +     struct tcf_gate_params *p;
>> > +     struct nlattr *entry_list;
>> > +     struct tcf_t t;
>> > +
>> > +     spin_lock_bh(&g->tcf_lock);
>> > +     opt.action =3D g->tcf_action;
>> > +     gact =3D rcu_dereference_protected(g->actg,
>> > +                                      lockdep_is_held(&g->tcf_lock));
>> > +
>> > +     p =3D get_gate_param(gact);
>> > +
>> > +     if (nla_put(skb, TCA_GATE_PARMS, sizeof(opt), &opt))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_u64_64bit(skb, TCA_GATE_BASE_TIME,
>> > +                           p->tcfg_basetime, TCA_GATE_PAD))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_u64_64bit(skb, TCA_GATE_CYCLE_TIME,
>> > +                           p->tcfg_cycletime, TCA_GATE_PAD))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_u64_64bit(skb, TCA_GATE_CYCLE_TIME_EXT,
>> > +                           p->tcfg_cycletime_ext, TCA_GATE_PAD))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_s32(skb, TCA_GATE_CLOCKID, p->tcfg_clockid))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_u32(skb, TCA_GATE_FLAGS, p->tcfg_flags))
>> > +             goto nla_put_failure;
>> > +
>> > +     if (nla_put_s32(skb, TCA_GATE_PRIORITY, p->tcfg_priority))
>> > +             goto nla_put_failure;
>> > +
>> > +     entry_list =3D nla_nest_start_noflag(skb, TCA_GATE_ENTRY_LIST);
>> > +     if (!entry_list)
>> > +             goto nla_put_failure;
>> > +
>> > +     list_for_each_entry(entry, &p->entries, list) {
>> > +             if (dumping_entry(skb, entry) < 0)
>> > +                     goto nla_put_failure;
>> > +     }
>> > +
>> > +     nla_nest_end(skb, entry_list);
>> > +
>> > +     tcf_tm_dump(&t, &g->tcf_tm);
>> > +     if (nla_put_64bit(skb, TCA_GATE_TM, sizeof(t), &t, TCA_GATE_PAD))
>> > +             goto nla_put_failure;
>> > +     spin_unlock_bh(&g->tcf_lock);
>> > +
>> > +     return skb->len;
>> > +
>> > +nla_put_failure:
>> > +     spin_unlock_bh(&g->tcf_lock);
>> > +     nlmsg_trim(skb, b);
>> > +     return -1;
>> > +}
>> > +
>> > +static int tcf_gate_walker(struct net *net, struct sk_buff *skb,
>> > +                        struct netlink_callback *cb, int type,
>> > +                        const struct tc_action_ops *ops,
>> > +                        struct netlink_ext_ack *extack) {
>> > +     struct tc_action_net *tn =3D net_generic(net, gate_net_id);
>> > +
>> > +     return tcf_generic_walker(tn, skb, cb, type, ops, extack); }
>> > +
>> > +static void tcf_gate_stats_update(struct tc_action *a, u64 bytes, u32
>> packets,
>> > +                               u64 lastuse, bool hw) {
>> > +     struct tcf_gate *g =3D to_gate(a);
>> > +     struct tcf_t *tm =3D &g->tcf_tm;
>> > +
>> > +     tcf_action_update_stats(a, bytes, packets, false, hw);
>> > +     tm->lastuse =3D max_t(u64, tm->lastuse, lastuse); }
>> > +
>> > +static int tcf_gate_search(struct net *net, struct tc_action **a, u32
>> > +index) {
>> > +     struct tc_action_net *tn =3D net_generic(net, gate_net_id);
>> > +
>> > +     return tcf_idr_search(tn, a, index); }
>> > +
>> > +static size_t tcf_gate_get_fill_size(const struct tc_action *act) {
>> > +     return nla_total_size(sizeof(struct tc_gate)); }
>> > +
>> > +static struct tc_action_ops act_gate_ops =3D {
>> > +     .kind           =3D       "gate",
>> > +     .id             =3D       TCA_ID_GATE,
>> > +     .owner          =3D       THIS_MODULE,
>> > +     .act            =3D       tcf_gate_act,
>> > +     .dump           =3D       tcf_gate_dump,
>> > +     .init           =3D       tcf_gate_init,
>> > +     .cleanup        =3D       tcf_gate_cleanup,
>> > +     .walk           =3D       tcf_gate_walker,
>> > +     .stats_update   =3D       tcf_gate_stats_update,
>> > +     .get_fill_size  =3D       tcf_gate_get_fill_size,
>> > +     .lookup         =3D       tcf_gate_search,
>> > +     .size           =3D       sizeof(struct gate_action),
>> > +};
>> > +
>> > +static __net_init int gate_init_net(struct net *net) {
>> > +     struct tc_action_net *tn =3D net_generic(net, gate_net_id);
>> > +
>> > +     return tc_action_net_init(net, tn, &act_gate_ops); }
>> > +
>> > +static void __net_exit gate_exit_net(struct list_head *net_list) {
>> > +     tc_action_net_exit(net_list, gate_net_id); }
>> > +
>> > +static struct pernet_operations gate_net_ops =3D {
>> > +     .init =3D gate_init_net,
>> > +     .exit_batch =3D gate_exit_net,
>> > +     .id   =3D &gate_net_id,
>> > +     .size =3D sizeof(struct tc_action_net), };
>> > +
>> > +static int __init gate_init_module(void) {
>> > +     return tcf_register_action(&act_gate_ops, &gate_net_ops); }
>> > +
>> > +static void __exit gate_cleanup_module(void) {
>> > +     tcf_unregister_action(&act_gate_ops, &gate_net_ops); }
>> > +
>> > +module_init(gate_init_module);
>> > +module_exit(gate_cleanup_module);
>> > +MODULE_LICENSE("GPL v2");
>
> Thanks a lot.
>
> Br,
> Po Liu

