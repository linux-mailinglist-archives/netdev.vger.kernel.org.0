Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9463C65F25D
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbjAERPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235535AbjAERPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:15:04 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF83D703D3
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:09:13 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-15027746720so28522109fac.13
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 09:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Swe7L4/LzuU45yCDYBGjzzDB0ltxjWnOJePJjru7Yj8=;
        b=IrzTU1fZdkreVyY/21K5hYnW4B+q2jofbbAR30XokRSqk4C2Cj5Meno1iEKVvdn/OV
         wlwhj/s9MPYGX0XT8OA8EotC98OZXJFywIpXWpfn3aX7/OXV5IswrKf9AlrUG4z8+o37
         Dvu8huO/iB00ybedYdqqIE1+YnmLFOvUHePRhyS+DOVDjOmxbP1Cg+vbqwbJU8Jej2K2
         6bfXMfpaGGZRMUfA3//LJiE0UFD8ULNXARKoD9ALH5WcfLHj1vgzbnwKdQ3Sgt8xn4BJ
         THVVdVO0+cMccjDAH3OWQItayRO0l/REhOcDzjJe+5atC4G3r3d0qpIDkOS+wMuTwizN
         zX6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Swe7L4/LzuU45yCDYBGjzzDB0ltxjWnOJePJjru7Yj8=;
        b=gGiAOS/bVDCKJ33K7ktoY2qC2Bu2BhKyCAN/lhViPcjAHPfVfUbpxUIYM6cLojOC9L
         0lCCMRGy+XsE3ivcj0SgOzEI2+40u+sw2k4K+mvh6PuH+0u/KkGQ0ym8C3sSZZwFt8y8
         9D1y72kPFUDucgAui3ZhhGkww8FGG/2jdRisZDyjljuukfxhES+c4kxeOFvlTjwlUJ+z
         YqzS7WQWOtqYDvn3Rk0TbWD/x/sgmL8WqCcMWpvAJKkJNTucN7JrP56YDBXzhuv6Wiwq
         NvZR8rStxAfjrzjb3uuuOX81J5UQ8Zd8udkkRrE8XKPndYSRABbs1pd0YpBXirOKu5DO
         b91w==
X-Gm-Message-State: AFqh2kpH8e1yme6A8kcyVsnci6NAxhhi94wayntcoTNyDUkWVA4J47Cv
        ykFQQPL5cLWfvgBqTKEaGmU=
X-Google-Smtp-Source: AMrXdXtrnArW4vrI/y8OkBvnKjXCNRrayte+K/n8hNEBmzZ+kKDJtVE5emyTYDD7KwXEOnYzr2zRJw==
X-Received: by 2002:a05:6871:4316:b0:144:4bf1:a6f3 with SMTP id lu22-20020a056871431600b001444bf1a6f3mr22018910oab.8.1672938502122;
        Thu, 05 Jan 2023 09:08:22 -0800 (PST)
Received: from t14s.localdomain ([45.160.111.192])
        by smtp.gmail.com with ESMTPSA id a11-20020a056870b14b00b0013d6d924995sm17146233oal.19.2023.01.05.09.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 09:08:21 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 1CC144AAF91; Thu,  5 Jan 2023 14:08:12 -0300 (-03)
Date:   Thu, 5 Jan 2023 14:08:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        jiri@resnulli.us, pabeni@redhat.com, wizhao@redhat.com,
        xiyou.wangcong@gmail.com, lucien.xin@gmail.com
Subject: Re: [RFC net-next 2/2] act_mirred: use the backlog for nested calls
 to mirred ingress
Message-ID: <20230105170812.zeq6fd2t2iwwr3fj@t14s.localdomain>
References: <ae44a3c9e42476d3a0f6edd87873fbea70b520bf.1671560567.git.dcaratti@redhat.com>
 <840dbfccffa9411a5e0f804885cbb7df66a22e78.1671560567.git.dcaratti@redhat.com>
 <CAM0EoMnJeb3QsfxgsggEMjTACdu0hq6mb3O+uGOfVzG2RZ-hkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoMnJeb3QsfxgsggEMjTACdu0hq6mb3O+uGOfVzG2RZ-hkw@mail.gmail.com>
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

On Mon, Dec 26, 2022 at 11:03:34AM -0500, Jamal Hadi Salim wrote:
> Davide,

He's on PTO, so please let me try to answer it here.

> So this would fix the false positive you are seeing i believe;
> however, will it fix a real loop?
> In particular I am not sure if the next packet grabbed from the
> backlog will end up in the
> same CPU.

This series is not changing, functionally speaking, any about that.
As explained on the first patch, this "loop protection" already
doesn't work when RFS or skb timestamps are used. The idea on that
protection was different from the beginning already - to actually
protect from stack growth, and not packet loop. So the first patch
here amends the wording on it to something closer to reality.

Makes sense?

Cheers,
Marcelo

> 
> cheers,
> jamal
> 
> On Tue, Dec 20, 2022 at 1:25 PM Davide Caratti <dcaratti@redhat.com> wrote:
> >
> > William reports kernel soft-lockups on some OVS topologies when TC mirred
> > egress->ingress action is hit by local TCP traffic [1].
> > The same can also be reproduced with SCTP (thanks Xin for verifying), when
> > client and server reach themselves through mirred egress to ingress, and
> > one of the two peers sends a "heartbeat" packet (from within a timer).
> >
> > Enqueueing to backlog proved to fix this soft lockup; however, as Cong
> > noticed [2], we should preserve - when possible - the current mirred
> > behavior that counts as "overlimits" any eventual packet drop subsequent to
> > the mirred forwarding action [3]. A compromise solution might use the
> > backlog only when tcf_mirred_act() has a nest level greater than one:
> > change tcf_mirred_forward() accordingly.
> >
> > Also, add a kselftest that can reproduce the lockup and verifies TC mirred
> > ability to account for further packet drops after TC mirred egress->ingress
> > (when the nest level is 1).
> >
> >  [1] https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
> >  [2] https://lore.kernel.org/netdev/Y0w%2FWWY60gqrtGLp@pop-os.localdomain/
> >  [3] such behavior is not guaranteed: for example, if RPS or skb RX
> >      timestamping is enabled on the mirred target device, the kernel
> >      can defer receiving the skb and return NET_RX_SUCCESS inside
> >      tcf_mirred_forward().
> >
> > Reported-by: William Zhao <wizhao@redhat.com>
> > CC: Xin Long <lucien.xin@gmail.com>
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> > ---
> >  net/sched/act_mirred.c                        |  7 +++
> >  .../selftests/net/forwarding/tc_actions.sh    | 49 ++++++++++++++++++-
> >  2 files changed, 55 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> > index c8abb5136491..8037ec9b1d31 100644
> > --- a/net/sched/act_mirred.c
> > +++ b/net/sched/act_mirred.c
> > @@ -206,12 +206,19 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
> >         return err;
> >  }
> >
> > +static bool is_mirred_nested(void)
> > +{
> > +       return unlikely(__this_cpu_read(mirred_nest_level) > 1);
> > +}
> > +
> >  static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
> >  {
> >         int err;
> >
> >         if (!want_ingress)
> >                 err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
> > +       else if (is_mirred_nested())
> > +               err = netif_rx(skb);
> >         else
> >                 err = netif_receive_skb(skb);
> >
> > diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
> > index 1e0a62f638fe..919c0dd9fe4b 100755
> > --- a/tools/testing/selftests/net/forwarding/tc_actions.sh
> > +++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
> > @@ -3,7 +3,8 @@
> >
> >  ALL_TESTS="gact_drop_and_ok_test mirred_egress_redirect_test \
> >         mirred_egress_mirror_test matchall_mirred_egress_mirror_test \
> > -       gact_trap_test mirred_egress_to_ingress_test"
> > +       gact_trap_test mirred_egress_to_ingress_test \
> > +       mirred_egress_to_ingress_tcp_test"
> >  NUM_NETIFS=4
> >  source tc_common.sh
> >  source lib.sh
> > @@ -198,6 +199,52 @@ mirred_egress_to_ingress_test()
> >         log_test "mirred_egress_to_ingress ($tcflags)"
> >  }
> >
> > +mirred_egress_to_ingress_tcp_test()
> > +{
> > +       local tmpfile=$(mktemp) tmpfile1=$(mktemp)
> > +
> > +       RET=0
> > +       dd conv=sparse status=none if=/dev/zero bs=1M count=2 of=$tmpfile
> > +       tc filter add dev $h1 protocol ip pref 100 handle 100 egress flower \
> > +               $tcflags ip_proto tcp src_ip 192.0.2.1 dst_ip 192.0.2.2 \
> > +                       action ct commit nat src addr 192.0.2.2 pipe \
> > +                       action ct clear pipe \
> > +                       action ct commit nat dst addr 192.0.2.1 pipe \
> > +                       action ct clear pipe \
> > +                       action skbedit ptype host pipe \
> > +                       action mirred ingress redirect dev $h1
> > +       tc filter add dev $h1 protocol ip pref 101 handle 101 egress flower \
> > +               $tcflags ip_proto icmp \
> > +                       action mirred ingress redirect dev $h1
> > +       tc filter add dev $h1 protocol ip pref 102 handle 102 ingress flower \
> > +               ip_proto icmp \
> > +                       action drop
> > +
> > +       ip vrf exec v$h1 nc --recv-only -w10 -l -p 12345 -o $tmpfile1  &
> > +       local rpid=$!
> > +       ip vrf exec v$h1 nc -w1 --send-only 192.0.2.2 12345 <$tmpfile
> > +       wait -n $rpid
> > +       cmp -s $tmpfile $tmpfile1
> > +       check_err $? "server output check failed"
> > +
> > +       $MZ $h1 -c 10 -p 64 -a $h1mac -b $h1mac -A 192.0.2.1 -B 192.0.2.1 \
> > +               -t icmp "ping,id=42,seq=5" -q
> > +       tc_check_packets "dev $h1 egress" 101 10
> > +       check_err $? "didn't mirred redirect ICMP"
> > +       tc_check_packets "dev $h1 ingress" 102 10
> > +       check_err $? "didn't drop mirred ICMP"
> > +       local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
> > +       test ${overlimits} = 10
> > +       check_err $? "wrong overlimits, expected 10 got ${overlimits}"
> > +
> > +       tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
> > +       tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
> > +       tc filter del dev $h1 ingress protocol ip pref 102 handle 102 flower
> > +
> > +       rm -f $tmpfile $tmpfile1
> > +       log_test "mirred_egress_to_ingress_tcp ($tcflags)"
> > +}
> > +
> >  setup_prepare()
> >  {
> >         h1=${NETIFS[p1]}
> > --
> > 2.38.1
> >
> 
