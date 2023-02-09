Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAAC68FC70
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 02:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjBIBKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 20:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjBIBKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 20:10:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8A89ED6
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 17:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675904962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1Hffel/6V7o/XciYWoLhy+dARCpC2kvG3tRq+Y4UdE0=;
        b=Mxqykh63T5HstJ+a6XmtGbO1HqbAfg1CWWrQZ2Q0En0z3qUTbUFzU8FUKNCDVLAGtIlaag
        qv5tdnsncgbA7STY3j3m+U6Qopdu7wSBxnTFqC1lBj9j8CMlekFPt/xWgCV5JYIXWECigW
        lvjNHbzf+iDzfCVF/z1cC+MqVNujAak=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-38-QgSO7uGyPYi-h_oRCQGAJA-1; Wed, 08 Feb 2023 20:09:21 -0500
X-MC-Unique: QgSO7uGyPYi-h_oRCQGAJA-1
Received: by mail-ua1-f72.google.com with SMTP id q48-20020a9f3873000000b00654ed50c29fso262387uad.9
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 17:09:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1Hffel/6V7o/XciYWoLhy+dARCpC2kvG3tRq+Y4UdE0=;
        b=ir3uVNYSQay999Pyss5r++6sw6Y8VANMhx0sVbETWSl13MV+q+Sg8I9m9orndF3L1R
         bYacx4JlqNkObmPpO5R91rV8/9p6MFaEaDwR8cNV1HImVmacjteOZ+EbIlCyCEnjgDN+
         pHXRnB+vT2cLtDqdOibeS5rMtes0ILMyNTWYh/09SVfvY8uYe7WR26wlvwETPjrJ2/ZB
         XGhWgfN3yDEtODmcJ/HM3Au2SqooUn87WZwhbS8Q3s6NLSzW6ZKaxu2PN6M0KrZ6ac9m
         ggEOC3+vdDCqt1No2LU1Q7JAcvFT7V0Po3bxylYNtzVHO8Pgap04umOmIet29/rV+Qze
         /GsQ==
X-Gm-Message-State: AO0yUKVF5ZHT2E6DAeZOoQ+3Dra4vWxEl0Zq/23A7NB3/fejX9NXCWaw
        EQWB9KmJaOBijka0U+vv0HRWp/JGc1mvg+douyVGOFDnGnoJmH7yxW8fsHSq/vadKKWtYrA5TUm
        +zfIwvbHJslUiXLjMO96vFodxqEnCXTyg
X-Received: by 2002:a05:6102:6c8:b0:3f9:fb55:f178 with SMTP id m8-20020a05610206c800b003f9fb55f178mr2083308vsg.42.1675904960593;
        Wed, 08 Feb 2023 17:09:20 -0800 (PST)
X-Google-Smtp-Source: AK7set/5GgHrzIeCwUediQY5nndKmGmo5+lH4MXj5Z5KEDG5LwUmtqBj40LSgf9VFBbthMoIp6fM3ow0IS/WWoJpndc=
X-Received: by 2002:a05:6102:6c8:b0:3f9:fb55:f178 with SMTP id
 m8-20020a05610206c800b003f9fb55f178mr2083298vsg.42.1675904960144; Wed, 08 Feb
 2023 17:09:20 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Feb 2023 17:09:19 -0800
From:   Marcelo Leitner <mleitner@redhat.com>
References: <20230205154934.22040-1-paulb@nvidia.com> <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
 <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com> <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
 <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com>
 <a2f19534-9752-845c-9b8a-3aa75b5f3706@nvidia.com> <CALnP8ZbQtyRx-s9GWvTVyBVU3SoGTDA9r9u+eEj39ZVq8LotHA@mail.gmail.com>
 <363f85d5-73bf-0b8e-dd60-5fc234d1d177@ovn.org>
MIME-Version: 1.0
In-Reply-To: <363f85d5-73bf-0b8e-dd60-5fc234d1d177@ovn.org>
Date:   Wed, 8 Feb 2023 17:09:19 -0800
Message-ID: <CALnP8ZaXQAC8SDcRh3ZW4oTpgfhSnNYfqJ941pH3BByENmaQzw@mail.gmail.com>
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss
 to tc action
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 01:09:21AM +0100, Ilya Maximets wrote:
> On 2/8/23 19:01, Marcelo Leitner wrote:
> > On Wed, Feb 08, 2023 at 10:41:39AM +0200, Paul Blakey wrote:
> >>
> >>
> >> On 07/02/2023 07:03, Marcelo Leitner wrote:
> >>> On Tue, Feb 07, 2023 at 01:20:55AM +0100, Ilya Maximets wrote:
> >>>> On 2/6/23 18:14, Paul Blakey wrote:
> >>>>>
> >>>>>
> >>>>> On 06/02/2023 14:34, Ilya Maximets wrote:
> >>>>>> On 2/5/23 16:49, Paul Blakey wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> This series adds support for hardware miss to instruct tc to cont=
inue execution
> >>>>>>> in a specific tc action instance on a filter's action list. The m=
lx5 driver patch
> >>>>>>> (besides the refactors) shows its usage instead of using just cha=
in restore.
> >>>>>>>
> >>>>>>> Currently a filter's action list must be executed all together or
> >>>>>>> not at all as driver are only able to tell tc to continue executi=
ng from a
> >>>>>>> specific tc chain, and not a specific filter/action.
> >>>>>>>
> >>>>>>> This is troublesome with regards to action CT, where new connecti=
ons should
> >>>>>>> be sent to software (via tc chain restore), and established conne=
ctions can
> >>>>>>> be handled in hardware.
> >>>>>>>
> >>>>>>> Checking for new connections is done when executing the ct action=
 in hardware
> >>>>>>> (by checking the packet's tuple against known established tuples)=
.
> >>>>>>> But if there is a packet modification (pedit) action before actio=
n CT and the
> >>>>>>> checked tuple is a new connection, hardware will need to revert t=
he previous
> >>>>>>> packet modifications before sending it back to software so it can
> >>>>>>> re-match the same tc filter in software and re-execute its CT act=
ion.
> >>>>>>>
> >>>>>>> The following is an example configuration of stateless nat
> >>>>>>> on mlx5 driver that isn't supported before this patchet:
> >>>>>>>
> >>>>>>>  =C2=A0 #Setup corrosponding mlx5 VFs in namespaces
> >>>>>>>  =C2=A0 $ ip netns add ns0
> >>>>>>>  =C2=A0 $ ip netns add ns1
> >>>>>>>  =C2=A0 $ ip link set dev enp8s0f0v0 netns ns0
> >>>>>>>  =C2=A0 $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
> >>>>>>>  =C2=A0 $ ip link set dev enp8s0f0v1 netns ns1
> >>>>>>>  =C2=A0 $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
> >>>>>>>
> >>>>>>>  =C2=A0 #Setup tc arp and ct rules on mxl5 VF representors
> >>>>>>>  =C2=A0 $ tc qdisc add dev enp8s0f0_0 ingress
> >>>>>>>  =C2=A0 $ tc qdisc add dev enp8s0f0_1 ingress
> >>>>>>>  =C2=A0 $ ifconfig enp8s0f0_0 up
> >>>>>>>  =C2=A0 $ ifconfig enp8s0f0_1 up
> >>>>>>>
> >>>>>>>  =C2=A0 #Original side
> >>>>>>>  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip f=
lower \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state -trk ip_proto tcp dst_port 888=
8 \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action pedit ex munge tcp d=
port set 5001 pipe \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action csum ip tcp pipe \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct pipe \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action goto chain 1
> >>>>>>>  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip f=
lower \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state +trk+est \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redire=
ct dev enp8s0f0_1
> >>>>>>>  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip f=
lower \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state +trk+new \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct commit pipe \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redire=
ct dev enp8s0f0_1
> >>>>>>>  =C2=A0 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp =
flower \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redire=
ct dev enp8s0f0_1
> >>>>>>>
> >>>>>>>  =C2=A0 #Reply side
> >>>>>>>  =C2=A0 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp =
flower \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redire=
ct dev enp8s0f0_0
> >>>>>>>  =C2=A0 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip f=
lower \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0 ct_state -trk ip_proto tcp \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action ct pipe \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action pedit ex munge tcp s=
port set 8888 pipe \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action csum ip tcp pipe \
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 action mirred egress redire=
ct dev enp8s0f0_0
> >>>>>>>
> >>>>>>>  =C2=A0 #Run traffic
> >>>>>>>  =C2=A0 $ ip netns exec ns1 iperf -s -p 5001&
> >>>>>>>  =C2=A0 $ sleep 2 #wait for iperf to fully open
> >>>>>>>  =C2=A0 $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
> >>>>>>>
> >>>>>>>  =C2=A0 #dump tc filter stats on enp8s0f0_0 chain 0 rule and see =
hardware packets:
> >>>>>>>  =C2=A0 $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto =
ip | grep "hardware.*pkt"
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware 9=
310116832 bytes 6149672 pkt
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware 9=
310116832 bytes 6149672 pkt
> >>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Sent hardware 9=
310116832 bytes 6149672 pkt
> >>>>>>>
> >>>>>>> A new connection executing the first filter in hardware will firs=
t rewrite
> >>>>>>> the dst port to the new port, and then the ct action is executed,
> >>>>>>> because this is a new connection, hardware will need to be send t=
his back
> >>>>>>> to software, on chain 0, to execute the first filter again in sof=
tware.
> >>>>>>> The dst port needs to be reverted otherwise it won't re-match the=
 old
> >>>>>>> dst port in the first filter. Because of that, currently mlx5 dri=
ver will
> >>>>>>> reject offloading the above action ct rule.
> >>>>>>>
> >>>>>>> This series adds supports partial offload of a filter's action li=
st,
> >>>>>>> and letting tc software continue processing in the specific actio=
n instance
> >>>>>>> where hardware left off (in the above case after the "action pedi=
t ex munge tcp
> >>>>>>> dport... of the first rule") allowing support for scenarios such =
as the above.
> >>>>>>
> >>>>>>
> >>>>>> Hi, Paul.=C2=A0 Not sure if this was discussed before, but don't w=
e also need
> >>>>>> a new TCA_CLS_FLAGS_IN_HW_PARTIAL flag or something like this?
> >>>>>>
> >>>>>> Currently the in_hw/not_in_hw flags are reported per filter, i.e. =
these
> >>>>>> flags are not per-action.=C2=A0 This may cause confusion among use=
rs, if flows
> >>>>>> are reported as in_hw, while they are actually partially or even m=
ostly
> >>>>>> processed in SW.
> >>>>>>
> >>>>>> What do you think?
> >>>>>>
> >>>>>> Best regards, Ilya Maximets.
> >>>>>
> >>>>> I think its a good idea, and I'm fine with proposing something like=
 this in a
> >>>>> different series, as this isn't a new problem from this series and =
existed before
> >>>>> it, at least with CT rules.
> >>>>
> >>>> Hmm, I didn't realize the issue already exists.
> >>>
> >>> Maintainers: please give me up to Friday to review this patchset.
> >>>
> >>> Disclaimer: I had missed this patchset, and I didn't even read it yet=
.
> >>>
> >>> I don't follow. Can someone please rephase the issue please?
> >>> AFAICT, it is not that the NIC is offloading half of the action list
> >>> and never executing a part of it. Instead, for established connection=
s
> >>> the rule will work fully offloaded. While for misses in the CT action=
,
> >>> it will simply trigger a miss, like it already does today.
> >>
> >> You got it right, and like you said it was like this before so its not
> >> strictly related by this series and could be in a different patchset. =
And I
> >> thought that (extra) flag would mean that it can miss, compared to oth=
er
> >> rules/actions combination that will never miss because they
> >> don't need sw support.
> >
> > This is different from what I understood from Ilya's comment. Maybe I
> > got his comment wrong, but I have the impression that he meant it in
> > the sense of having some actions offloaded and some not.
> > Which I thinkit is not the goal here.
>
> I don't really know the code around this patch set well enough, so my
> thoughts might be a bit irrelevant.  But after reading the cover letter
> and commit messages in this patch set I imagined that if we have some
> kind of miss on the N-th action in a list in HW, we could go to software
> tc, find that action and continue execution from it.  In this case some
> actions are executed in HW and some are in SW.

Precisely. :)

>
> From the user's perspective, if such tc filter reports an 'in_hw' flag,
> that would be a bit misleading, IMO.

I may be tainted or perhaps even biased here, but I don't see how it
can be misleading. Since we came up with skip_hw/sw I think it is
expected that packets can be handled in both datapaths. The flag is
just saying that hw has this flow. (btw, in_sw is simplified, as sw
always accepts the flow if skip_sw is not used)

>
> If that is not what is happening here, then please ignore my comments,
> as I'm not sure what this code is about then. :)
>
> >
> > But anyway, flows can have some packets matching in sw while also
> > being in hw. That's expected. For example, in more complex flow sets,
> > if a packet hit a flow with ct action and triggered a miss, all
> > subsequent flows will handle this packet in sw. Or if we have queued
> > packets in rx ring already and ovs just updated the datapath, these
> > will match in tc sw instead of going to upcall. The latter will have
> > only a few hits, yes, but the former will be increasing over time.
> > I'm not sure how a new flag, which is probably more informative than
> > an actual state indication, would help here.
>
> These cases are related to just one or a very few packets, so for them
> it's generally fine to report 'in_hw', I think.  The vast majority of
> traffic will be handled in HW.
>
> My thoughts were about a case where we have a lot of traffic handled
> partially in HW and in SW.  Let's say we have N actions and HW doesn't
> support action M.  In this case, driver may offload actions [0, M - 1]
> inserting some kind of forced "HW miss" at the end, so actions [M, N]
> can be executed in TC software.

Right. Please lets consider this other scenario then. Consider that we
have these flows:
chain 0,ip,match ip X actions=3Dct,goto chain 1
chain 1,proto_Y_specific_match actions=3Dct(nat),goto chain 2
chain 2 actions=3Doutput:3

The idea here is that on chain 1, the HW doesn't support that particular
match on proto Y. That flow will never be in_hw, and that's okay. But
the flow on chain 2, though, will be tagged as in_hw, and for packets
following these specific sequence, they will get handled in sw on
chain 2.

But if we have another flow there:
chain 1,proto tcp actions=3Dct(nat),set_ttl,goto chain 2
which is supported by the hw, such packets would be handled by hw in
chain 2.

The flow on chain 2 has no idea on what was done before it. It can't
be tagged with _PARTIAL as the actions in there are not expected to
trigger misses, yet, with this flow set, it is expected to handle
packets in both datapaths, despite being 'in_hw'.

I guess what I'm trying so say is that it is not because a flow is
tagged with in_hw that sw processing is unexpected straight away.

Hopefully this makes sense?

>
> But now I'm not sure if that is possible with the current implementation.

AFAICT you got all right. It is me that had misunderstood you. :)

>
> >
> >>
> >>>
> >>>>
> >>>>>
> >>>>> So how about I'll propose it in a different series and we continue =
with this first?
> >>>
> >>> So I'm not sure either on what's the idea here.
> >>>
> >>> Thanks,
> >>> Marcelo
> >>>
> >>>>
> >>>> Sounds fine to me.  Thanks!
> >>>>
> >>>> Best regards, Ilya Maximets.
> >>>>
> >>>
> >>
> >
>

