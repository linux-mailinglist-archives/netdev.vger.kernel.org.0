Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE31251D785
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 14:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391741AbiEFM11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 08:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243253AbiEFM1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 08:27:25 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2075.outbound.protection.outlook.com [40.107.20.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9D527B07;
        Fri,  6 May 2022 05:23:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEmzQ8uCdhSqBhoUsRqIz/iAD/l68aqPfjmsEb7WuWC46FLFyf/EK8zZTw4KjNLbY3/oGkMSueO75pIHPIqlqNJ+ArPpGEvxHCrsmDSwaVYLvl7EFuiXwRXGQKiUJSXlioc+swpt3BKpH0tLLzeMQRsdejF3QftGzMDT7yyvw1AU2wESbnjzv2vOkyp7qn1M6FpvRNGsfsEXes93fYxjB1MCICVLQAX+uN04iTa/55CbsBdoVS6TebuZYOiZ6r+lNFvN2KHqtmqF+405HMD5LnpbQ8G2N68EulHr6b2kPb6bXZEbMUrOrBKj5EkzzbUDQ8N82Lp869a+54AzOlxP/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0zpjHim3puDy57DOK7lJchiWTtd7/H/lHTpHjBBykg=;
 b=EE8n4WplVk56cj0opYUgIOrkSogpumY6Uqa+EWFVrre845pP5i0G3RPMUNvrZ0pph3smsOvl9Kd1mvfRlG2MPzaGFnHFg8SDGDoMzwX0M/P6EuPcFB6fC+Re8gD6q1MmulmUhFW4KzXWx3JFxNLSCLurYI9N3CfPuZdoMcPNq/6lNEZ+n9gR2JucQ2Nn6klWFVX5Uc6Hq64f/yMF/j41oSCzCAMEVGx72XHSABDnLm9yeFsCZ+R96P3jSXGJvNahnkOSnFTHy1GctCutYCsFE69UKj7cRjCGmz5GxzC9K3ic+yvqxCxfr9LUNyfkcx+INtjhCPzw29fQ5qh3jhAdQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0zpjHim3puDy57DOK7lJchiWTtd7/H/lHTpHjBBykg=;
 b=gt7jF5NwyL2EN/untVCfyVgJXV0gl+ZHvI1G99pSznLnc98AT8WHOZPdb87MYoSlj0gzGLY26RjjRyWeWegX2zYP29UmWyogD8t0Abww8V2Of6SE0/KGeDLqqCod1ZeYWPgVzhiPCO/ivUsqTDbcoBO/jZOSVcZ3ybtgLP3DZIg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2926.eurprd04.prod.outlook.com (2603:10a6:800:b0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.18; Fri, 6 May
 2022 12:23:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5227.018; Fri, 6 May 2022
 12:23:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: Re: [RFC, net-next] net: qos: introduce a frer action to implement
 802.1CB
Thread-Topic: [RFC, net-next] net: qos: introduce a frer action to implement
 802.1CB
Thread-Index: AQHXtFznyGH2JvuT50mNvd/a5fV2Ja0TF8IAgAAHuQA=
Date:   Fri, 6 May 2022 12:23:35 +0000
Message-ID: <20220506122334.i7eqt2ngbfwqlrwn@skbuf>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <df67ceaa-4240-d084-7ba1-d703f0c38f33@ericsson.com>
In-Reply-To: <df67ceaa-4240-d084-7ba1-d703f0c38f33@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60415b9a-0968-470c-fe8b-08da2f5b3dbf
x-ms-traffictypediagnostic: VI1PR0402MB2926:EE_
x-microsoft-antispam-prvs: <VI1PR0402MB29262260120E902BCD50F8B4E0C59@VI1PR0402MB2926.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z91VWvbjyrtvFtsKXM3jNAnjwDdSw7vrvOrHAEAYdi90i5S9M6/Oq9f5fwXBCeysjEy7QLAsT39+qRV/0KataoFV4gklKXKMkOizOzKF5fnzau4vhnQAn43dEWBXNJ9pQNrlOcBmfsrLkYEiI3YqeAhHv7R7irWnEkXZMQcc8CxZxoP2gHx+f25Ja4iF2xyNOQLvMk5qQTMgtUPnNmK4HgDpxhd52/+PQyljn0bEQTYdjQvY0GvQMz719v85OGF/eR85Q/BPrmPHE66W1ASV00EnPFdXNLBySXJFHXLsHaqgagCjtZZRNKpHrNagQh+pR1W0Ry+Ou/ARM9bTwVy1QJhgJScKeAN+iBZXryFm7VXzcch3Lzz5HYpKLEjC2TLA7+3jvT8FiydbvxhpmR8ccegF6vhruEAEcHgos8+me47aFxjj5UJYwSCxwEzUs/OEQ0eeuqXSqLThj0mzGNeO/AAoSUVcPah/gidJJypTUBJPzri8fRcZHThKnZEeeLWf57qM8rJg1kTbQ9+mwFkdyg4ix9GBCdo4+IL4ggVOn5L38q1DZbB1DzQSKfGL5jzeu3hkjv+NSU/5RmX93Mnk67B0gr1/6daI+lFtioCaXuQCgjsLLv4if4fpJSrYSiGNoNV5vwgVJIlC5V9RLC8SXzISl5v5UQJJZTccLSfz/5FhMzLPag0mpnzJ2V32CBiAqmMXVPNERNCYlCnhCsZdK6iVpv/NchgoT29XTHAINEZEDYMlLY+2nbHufcgscvdk0KZL+k0L5yJpd66ZwwetADxxY9ebmAIa9CJOt0my6IY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(76116006)(4326008)(66556008)(64756008)(66446008)(66476007)(8676002)(91956017)(5660300002)(66946007)(2906002)(33716001)(38070700005)(54906003)(6916009)(38100700002)(316002)(122000001)(6506007)(83380400001)(7416002)(508600001)(186003)(71200400001)(6486002)(8936002)(44832011)(26005)(9686003)(86362001)(6512007)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CMxxxknFAE4Rl48pt3njgbvtBkY74YWZbERHnfl78dGHcyaAU15RsagEDoA7?=
 =?us-ascii?Q?u6PL4duOdh7u1UtvzLLERZzZQ8gO9WFlO/kPkaFB/YYf/0opUkLFC0Smp4ca?=
 =?us-ascii?Q?xZF6047UfbV4sZrSlK8z0ZSfWFsEwSKOz5l5fzTSHQDIjlMor3bKpTNQ2qug?=
 =?us-ascii?Q?l9IHa/9rZ2OieCO7e4dZJHffLo5sKRDY89PTdq5umoNMbEliU5H2eoc/33WA?=
 =?us-ascii?Q?l3h8i+O6TasCYp1IF6LGw/nuY1ecchgNWSpahOaSWuOO+WVO3KeIMFTYiFE1?=
 =?us-ascii?Q?BerZ3heqS7m70g0GIiUwGuLQW/dV1jwwUQPnTXrndrQoMRjcbXHNjIPWeW2v?=
 =?us-ascii?Q?GkqoTH5VGpLISJ8IKraCcrRKp8juoZvqq8gr1JsvG2oZN4X6wZsIdvXgV1mF?=
 =?us-ascii?Q?OObCBwhKX+5o4nQVRSCRRzpzJl3CrDwZgBupl3mKjwOeVNwBm2xXOtsnv0sS?=
 =?us-ascii?Q?7Hu6wV4CQIi5XkMy0zzSQUoo4u9iupVDwHb5k8Exsm9EAfxtbmJ4LrSw4ku/?=
 =?us-ascii?Q?6vvtH3s2+ZlpwyQ6/YzDzoXX/YWLD+bkss5Vs4spZBMQnqQ3yu+JWo7k8HCu?=
 =?us-ascii?Q?E2BDxyVnr7FdA2xvhU+edGCdB6IFBQbDoLC1DYq4jg/gMDsDt9ifLKKGeQCK?=
 =?us-ascii?Q?mkkHkSpU3Evn6aMoqQwEJHIhOk6qm+FtTJ1KoxEbQF6bI9D6qTFA65EuMLOu?=
 =?us-ascii?Q?9ofxmtzG9M39sURGu1G1OVKSJ/fDYskQpZWrfWyM/wWRNfym0O29UubJPnq5?=
 =?us-ascii?Q?U5MjxA34SFviR/+IEFXUUAuDMWxceV1JmboiU99eL4bBc2LbY7jtAUB1povy?=
 =?us-ascii?Q?PMfH79sioH2GD6/sYFfrArvoO3iuPZdO0peugTUfHvQyED0lv6Mkev8RhEHX?=
 =?us-ascii?Q?RC7zIkMXfqzuhK/GCMOtz4R1CmBMLTtYuJ84alM0XTdX4RrdsB1LEPF96XkZ?=
 =?us-ascii?Q?ck9FTsn8snIEizmTKYTM5x6RTyE7M6ZVEAMVRDQkUk3B/jFb8p6YUvs1SDq0?=
 =?us-ascii?Q?qhiUwM47e6WfrdZKu1iy3wDs7C00oZOUbELLvdIyLmYrkCwfUt54fW+GcA7n?=
 =?us-ascii?Q?v2/CEFtVi4a3t1OpnsXReJ5wUXYXLZJuAtpsnpBKuTduDA6OXnq/OSBfR4Xl?=
 =?us-ascii?Q?UvEZkaplxmo3VTmXZ+ru9TPvLxCAEbw8CMFz0GfsaaJtxyR6oVKKNrnMDIob?=
 =?us-ascii?Q?K5wcGfZW61Rr6OCUHbq2Xj78g3+6rYiGvvh4sQ0/JmCCLnLcvpUxpU3oBZWb?=
 =?us-ascii?Q?wQ5eOKND3KqAwERuwmtfa/2hbVRb/KtK/sJGzq25seTw/I1NXRT7DjttK1X5?=
 =?us-ascii?Q?Ch2ix/0d1xfzm0HuxPJ/APO+6GJe7pnr5SvuvczLFgJNDF6fslyUdMbhNc4/?=
 =?us-ascii?Q?LZJaX0rmEqcJ8m2NzuGcSg7uUUGLM7piPTOb8PlFdYqHjFfb3/6s1jWYBSFA?=
 =?us-ascii?Q?PaFCssG1CwX1XgoJvb6B7QG3ESlOfzJTRXYjpPyz/QMKvKmcbNEI+63rp9xW?=
 =?us-ascii?Q?d6cmW+Z/WdsEEyEP7fGfSrZDV6V4eEZqEWKDVidblc+xYGdQIvg986Ht83Z5?=
 =?us-ascii?Q?9JIOdwrZ2U5dNTs5qGqdIyOYOpIHMkpM8RBR1l3kzo7wfA6YcPLRSu4MAgpe?=
 =?us-ascii?Q?CUzKezWLWPh7GWBBMix04PbzuJSrOxSozxQhB6zvPigh0QeLVOBlpCLwcx93?=
 =?us-ascii?Q?KwSfT/T6MCABjpzk12m6adO+v0kPM7ThaSDL2uA6W6lf/9nmbr0+GvkkMnaM?=
 =?us-ascii?Q?dTC6qiE4q5uahouQ9i5UQqjxnnFjKUY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B69E6B15CB656B478A6DB09B2CA54853@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60415b9a-0968-470c-fe8b-08da2f5b3dbf
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 12:23:35.0712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mtp4VPlDE52YeJgc+xMtpNCxiEt8aJ+1imv6B48S29wak82Horx8yzjTSbL2I55diBeIrxLskUDvARjaJQiCmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2926
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

(I adjusted the CC list)

On Fri, May 06, 2022 at 11:55:56AM +0000, Ferenc Fejes wrote:
> On 2021. 09. 28. 13:44, Xiaoliang Yang wrote:
> > This patch introduce a frer action to implement frame replication and
> > elimination for reliability, which is defined in IEEE P802.1CB.
>
> HiXiaoliang!
>
> thanks for your efforts to introduce afreraction to implement frame
> replication and elimination for reliability, which is defined in IEEE
> P802.1CB-2017. I would like to relay a small comment from our team,
> regarding to the FRER, not particularly to the code.
>
> Support of RTAG format is very straightforward.
>
> Since 2017, several maintenance items were opened regarding IEEE
> P802.1CB-2017 to fix some errors in the standard. Discussions results
> will be published soon e.g., in IEEE P802.1CBdb
> (https://1.ieee802.org/tsn/802-1cbdb/).
>
> One of the maintenance items impacts the vector recovery algorithm itself=
.
>
> Details on the problem and the solution are here:
>
> -https://www.802-1.org/items/370
>
> -https://www.ieee802.org/1/files/public/docs2020/maint-varga-257-FRER-rec=
overy-window-0320-v01.pdf
> <https://www.ieee802.org/1/files/public/docs2020/maint-varga-257-FRER-rec=
overy-window-0320-v01.pdf>
>
> It is a small but important fix. There is an incorrect reference to the
> size of the recovery window, when a received packet is checked to be
> out-of-range or not. Without this fix the vector recovery algorithm do
> not work properly in some scenarios.
>
> Please consider to update your patch to reflect the maintenance efforts
> of IEEE to correct .1CB-2017 related issues.
>
> > There are two modes for frer action: generate and push the tag, recover
> > and pop the tag. frer tag has three types: RTAG, HSR, and PRP. This
> > patch only supports RTAG now.
> >
> > User can push the tag on egress port of the talker device, recover and
> > pop the tag on ingress port of the listener device. When it's a relay
> > system, push the tag on ingress port, or set individual recover on
> > ingress port. Set the sequence recover on egress port.
> >
> > Use action "mirred" to do split function, and use "vlan-modify" to do
> > active stream identification function on relay system.
> >
> All of our research in the topic based on a in-house userspace FRER
> implementation but we are looking forward to test your work in the future=
.
>
> Thanks,
>
> Ferenc

Glad to see someone familiar with 802.1CB. I have a few questions and
concerns if you don't mind.

I think we are seeing a bit of a stall on the topic of FRER modeling in
the Linux networking stack, in no small part due to the fact that we are
working with pre-standard hardware.

The limitation with Xiaoliang's proposal here (to model FRER stream
replication and recovery as a tc action) is that I don't think it works
well for traffic termination - it only covers properly the use case of a
switch. More precisely, there isn't a single convergent termination
point for either locally originating traffic, or locally received
traffic (i.e. you, as user, don't know on which interface of several
available to open a socket).

In our hardware, this limitation isn't really visible because of the way
in which the Ethernet switch is connected inside the NXP LS1028A.
It is something like this:

  +---------------------------------------+
  |                                       |
  |           +------+ +------+           |
  |           | eno2 | | eno3 |           |
  |           +------+ +------+           |
  |              |         |              |
  |           +------+ +------+           |
  |           | swp4 | | swp5 |           |
  |           +------+ +------+           |
  |  +------+ +------+ +------+ +------+  |
  |  | swp0 | | swp1 | | swp2 | | swp3 |  |
  +--+------+-+------+-+------+-+------+--+

In the above picture, the switch ports swp0-swp3 have eno3 as a DSA
master (connected to the internal swp5, a CPU port). The other internal
port, swp5, is configured as a DSA user port, so it has a net device.
Analogously, while eno3 is a DSA master and receives DSA-tagged traffic
(so it is useless for direct IP termination), eno2 receives DSA untagged
traffic and is therefore an IP termination endpoint into a switched
network.

What we do in this case is put tc-frer rules for stream replication and
recovery on swp4 itself, and we use eno2 as the convergence point for
locally terminated streams.

However, naturally, a hardware design that does not look like this can't
terminate traffic like this.

My idea was that it might be better if FRER was its own virtual network
interface (like a bridge), with multiple slave interfaces. The FRER net
device could keep its own database of streams and actions (completely
outside of tc) which would be managed similar to "bridge fdb add ...".
This way, the frer0 netdevice would be the local termination endpoint,
logically speaking.

What I don't know for sure is if a FRER netdevice is supposed to forward
frames which aren't in its list of streams (and if so, by which rules).
Because if a FRER netdevice is supposed to behave like a regular bridge
for non-streams, the implication is that the FRER logic should then be
integrated into the Linux bridge.

Also, this new FRER software model complicates the offloading on NXP
LS1028A, but let's leave that aside, since it shouldn't really be the
decisive factor on what should the software model look like.

Do you have any comments on this topic?=
