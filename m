Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D1F5B163C
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiIHIFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiIHIFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:05:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5B55070A
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 01:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662624319; x=1694160319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p2AnMyMg3s42ZXeVMPs+mG8G3fG+z8UmidXk5QM6MPw=;
  b=OkZBrQaiSsqBKh92KpmuM92IrFndFBWtJCd42KHf0pCphSesK+gUM/ea
   KnV69IWioS/+hxEx42KcWWF3O2zPhjCGmyVqnae6S+2HTRE3y480jDueQ
   vATcF9EpPSw+h/ob/CUOaGxf3nns2mQlH1qx4R5HvCc9qId/zMMEzT+pJ
   Yf9cPJhod1SEcStpRD2wvTeQKec65ktopMlNTThUPptvKJuQfp5FkXy9R
   tHWkGeJQIbSrGxAWLMN9EbysimdMaL6ruykUpU/PJLr7oLrShLnubqc+p
   5Z2QHsgm9sjK+gjyoiLk+sqkj45wIyqmqBZ3dTIgBxfZTJ1VP6ZaZ+aGk
   w==;
X-IronPort-AV: E=Sophos;i="5.93,299,1654585200"; 
   d="scan'208";a="179530033"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2022 01:05:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Sep 2022 01:05:17 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 8 Sep 2022 01:05:17 -0700
Date:   Thu, 8 Sep 2022 10:03:58 +0200
From:   Allan Nielsen - M31684 <Allan.Nielsen@microchip.com>
To:     Daniel Machon - M70577 <Daniel.Machon@microchip.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Message-ID: <20220908080358.islaqh4irglbyp4s@lx-anielsen>
References: <YwXXqB64QLDuKObh@DEN-LT-70577>
 <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577>
 <87k06xjplj.fsf@nvidia.com>
 <20220824175453.0bc82031@kernel.org>
 <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
 <20220902133218.bgfd2uaelvn6dsfa@skbuf>
 <Yxh3ZOvfESYT36UN@DEN-LT-70577>
 <20220907172613.mufgnw3k5rt745ir@skbuf>
 <Yxj5smlnHEMn0sq2@DEN-LT-70577>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <Yxj5smlnHEMn0sq2@DEN-LT-70577>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir, Daniel,

On 07.09.2022 19:57, Daniel Machon - M70577 wrote:
>> On Wed, Sep 07, 2022 at 10:41:10AM +0000, Daniel.Machon@microchip.com wrote:
>> > > Regarding the topic at hand, and the apparent lack of PCP-based
>> > > prioritization in the software data path. VLAN devices have an
>> > > ingress-qos-map and an egress-qos-map. How would prioritization done via
>> > > dcbnl interact with those (who would take precedence)?
>> >
>> > Hi Vladimir,
>> >
>> > They shouldn't interact (at least this is my understanding).
>> >
>> > The ingress and egress maps are for vlan interfaces, and dcb operates
>> > on physical interfaces (dcbx too). You cannot use dcbnl to do
>> > prioritization for vlan interfaces.
>> >
>> > Anyway, I think much of the stuff in DCB is for hw offload only, incl. the
>> > topic at hand. Is the APP table even consulted by the sw stack at all - I
>> > dont think so (apart from drivers).
>>
>> Not directly, but at least ocelot (or in fact felix) does set
>> skb->priority based on the QoS class from the Extraction Frame Header.
>> So the stack does end up consulting and meaningfully using something
>> that was set based on the dcbnl APP table.
>>
>> In this sense, for ocelot, there is a real overlap between skb->priority
>> being initially set based on ocelot_xfh_get_qos_class(), and later being
>> overwritten based on the QoS maps of a VLAN interface.
I do not think this is an overlap.

The mappings Daniel is proposing will cause the QoS class from the
extraction header to be mapped (actually they are mapped today, the
mapping is just a 1:1). If the frame is extracted by the CPU, the
classified QoS class will (and shall) be used to set the skb->priority.

As long as the frame is considered to belong to the physical interface,
this is correct.

If this frame then at a later point is being processed by a VLAN
interface, then the mapping will be updated in the context if the VLAN
interface.

>Right, so VLAN QoS maps currently takes precedence, if somebody would choose
>to add a tagged vlan interface on-top of a physical interface with existing
>PCP prioritization - is this a real problem, or just a question of configuration?
It is not like VLAN QoS maps takes precedence. The mapping is just
updated if the frame goes through a (SW) VLAN interface.

>> The problem with the ingress-qos-map and egress-qos-map from 802.1Q that
>> I see is that they allow for per-VID prioritization, which is way more
>> fine grained than what we need. This, plus the fact that bridge VLANs
>> don't have this setting, only termination (8021q) VLANs do. How about an
>> ingress-qos-map and an egress-qos-map per port rather than per VID,
>> potentially even a bridge_slave netlink attribute, offloadable through
>> switchdev? We could make the bridge input fast path alter skb->priority
>> for the VLAN-tagged code paths, and this could give us superior
>> semantics compared to putting this non-standardized knob in the hardware
>> only dcbnl.
>
>This is a valid alternative solution to dcbnl, although this seems to be a
>much more complex solution, to something that is easily solved in dcbnl,
>and actually is in-line with what dcbnl already does. On-top of this, the
>notion of 'trust' has also been raised by this topic. It makes a lot of sense
>to me to add APP selector trust and trust order to dcbnl.
I agree that this mapping could be done by allowing to set the
ingress-qos-map/egress-qos-map maps on physical interfaces (and to
handle the trust aspect, we would have to introduce a anoter flag which
does not make sense on VLAN interfaces, but only on physical
interfaces).

Still I think it is better to do it in the dcb-app (and skip the
sw-fallback) for the following reasons:
- This mapping is important to supprot meaning use-cases with PFC
   (Priority Flow Control) Buffer handling and in furture maybe
   FramePreemption. These are all features which cannot be done in a
   meaningfull way in SW. Therefore the SW-path will not bennefit from
   this (but rahter will be be slowed down by supporting more features).
- This is closely related to others features found DCB, and as a user I
   just think it make sense to collect related features in the same
   tool and man-page.

>This is the solution that I have been implementing lately, and is ready
>for posting very soon.
Given that this is mostly implemented in accordance with the initial
discussion with Petr, I think we should see it and evaluate it. If we
think it is better to move the ingress-qos-map/egress-qos-map then we
need to try out that.

/Allan
