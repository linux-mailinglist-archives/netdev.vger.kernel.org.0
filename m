Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C97B59D175
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 08:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbiHWGs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 02:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240307AbiHWGs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 02:48:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79C0E031;
        Mon, 22 Aug 2022 23:48:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3b3LnUSXa+FZ935aG5s1QmOpNJcs052R8qmdbX5up4jrAGGDThMOtu3mx/L5k89IaxWBFtgb9xSshbAj+KthQVLMy5b7Lr2m7TimyB8siYGUgqA2d87em82P5/R0nXrphjlLGIWgBjh5HBacfby2PjpfSPQk7vJakc3P/9cZYGr/ieqhfpngUtg3HHXViWEU0ePAlaUrr2bm1nGnP+qCHL1cvjWJJ0Bq0Tt09cZ7uDINWzR5GZwGW+5pO7ZrUs/Zam9Zgn/ENhYVGN8Lgf+Tm9+kN5PaO9yx/Sw4xmI+wgBRR0GCRQzwaCYL4E/ZDQCwlsuTvfiqQPwXg970VNXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lib8bisyBHrWO6pAcEhBi4DsSbSF2hoDcjmaxglAXEM=;
 b=GbeFhs/GUlTNfbwoIMrjELewD6KCgLRfwkfKrmz9P7djpkPtYIG407o3s/b6w8v6yB/mzuXkqQpkd0l4+QNNcxg8Ik09rK1DDGPWVvgXyQ2Ay3mGeKrB/7uPaxqaOOPjBOPayAsdbrOVzfrjIeYXyv8HYVxLpnF9lrMNpmLlhdEiVPrjDIfeb7tQ8MkwYvSrbLdJuRApYePQV2gqVpQcXH2dhBVp3FQqVNPkl3Avl+xHckM+KtyUF57utX9BdpVyQCsFbeIkn0KuzhKRdTD0okCEAS146fXNlVQILXeHEfUpM1Lz834C+tALHJX4CaM4K7/G69RBZcJsSqAwn6ebww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lib8bisyBHrWO6pAcEhBi4DsSbSF2hoDcjmaxglAXEM=;
 b=ui0dcW18C1lOskPdXIAhazeez8bvY/QYLk9w1PeWKjocqkO8+OLDryFslkmjUpN1QS3lSoTntHWY7mT3rEcdE2SxOL9oZoVuaf1BGCuXZRugir2oztAqV8tc31kR1H3+uA8fYfvBC0J8QTMVOZacEGF1p5jELW5mfJgw5U1om6gSW+kgbpPRNvQhOF+IP2W68o/vlg24ByOKOsvToGwJcaygiw67yyA6SdSbeZHuwfUL2tiVORpncESuaxzRgpfU6Rwl7HoJACd70ICLF0JgHsKQdHAX9ys1pMoPAu14qymYffcSjWY3GJ5vm4iMEedwuQH+uvcY1p7PTei7ONxGbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by BL0PR12MB4609.namprd12.prod.outlook.com (2603:10b6:208:8d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 06:48:24 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 06:48:23 +0000
Date:   Tue, 23 Aug 2022 09:48:17 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@kapio-technology.com
Cc:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YwR4MQ2xOMlvKocw@shredder>
References: <5a4cfc6246f621d006af69d4d1f61ed1@kapio-technology.com>
 <YvkM7UJ0SX+jkts2@shredder>
 <34dd1318a878494e7ab595f8727c7d7d@kapio-technology.com>
 <YwHZ1J9DZW00aJDU@shredder>
 <ce4266571b2b47ae8d56bd1f790cb82a@kapio-technology.com>
 <YwMW4iGccDu6jpaZ@shredder>
 <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2822d6dd66a1239ff8b7bfd06019008@kapio-technology.com>
X-ClientProxiedBy: VI1PR04CA0065.eurprd04.prod.outlook.com
 (2603:10a6:802:2::36) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1990fa58-d901-4ad5-b15e-08da84d3797a
X-MS-TrafficTypeDiagnostic: BL0PR12MB4609:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/V38e+RlkIgeknU8i1OuQhGHQzP8hktCzoIBM5Z0R+q8O8XbtxuMA/lFYJ4UNkr8iWHnKpE7K6s9cKoZWAB7l1fMcJMQUvsjc4V573x1kXorTA3H+c2KRUvU7v/ModFmt4BvmfGXfCR568XtOUmxzWTPzXHJhrd3aevCAc8xnxd7ZGlnrYgPazusnBMhWiCkxZl3kWW7zZrFxOjDFXi8MK9Z07okcdp6opOLRI7b93VKV9JsOaS1SOd/KHYY4kd9B4QxdEoIei03ZXe0GFYrGYjuRWrXr6jmg3ZYz2e2UjYjthjn8Z+Ba8yuOoApM8toUE/gfLzx6QvT3Fwfu0bsGuqKLdb+qY83JlZ46T1EEpmV97K6D4vUebUTcRdrHiHMyegFWlnAaw0nTNd5NI33L3UATSp06gTvpwuUxJ6t3W7ZegzA7pKvJE9M4smYRBclDT+2AmwrQRGXeifQ8iIfmKulIV55bpDc/PSrS6wgnGpfpB5Mh/zarE7wlTocf6U4i4bLMjqCb+pjLcgOP1bq90j8CAy1WylS6pqUYggI9I7vjCkFNzwz7kH1tv8FBS+lDhkUAQYv8ZiAVynKm9taigVkYBc3kgeXMlaMpNINfMOjStej59UHuPAxn192ajPU42Z9LRVOaJU0D6cQcIJu/ww4TWJGw0nzzauq/YMTV9vwqZKgR6vSfiQNvMeacp6gFEVaecy3sg09fZhWWNMAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(86362001)(38100700002)(316002)(6916009)(54906003)(8936002)(2906002)(7416002)(5660300002)(66476007)(66946007)(8676002)(4326008)(66556008)(83380400001)(186003)(478600001)(6486002)(53546011)(9686003)(6512007)(6506007)(41300700001)(6666004)(33716001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AVLSS0nmPVcOuXatzv4in5Kb9yg8X0b0Pi5hKejPnePhKaViH+LeS92+Ay18?=
 =?us-ascii?Q?753PyIok78nK7j+mm/E/s2WG//8MzRbIT14QOyTl0HX/Mhv3ZjP21lXlQh8F?=
 =?us-ascii?Q?8bXK6z+eIPG0yRGjGMul7rQIdFrmUdHfUFDm3/hIfXy6/5aEPYxDo8RJKbz5?=
 =?us-ascii?Q?eyJt8KRci7mpfRJWHcHPpOoZsNp/WopYsjJr3mmXQgnLdRd59n3x4IoxOgqf?=
 =?us-ascii?Q?MfXkhIrQMQ4ORVbO/5pYJxyID5eRv+giq2BYMhsI1I6RnaXm6JMoHV8fdZd/?=
 =?us-ascii?Q?m11zWxWHm3jpYx7r8RnTr34lnRjM7egBvQTw/EMQsG8Br16EYmhiKrJm/cJ3?=
 =?us-ascii?Q?Y4QVUNT3RdPKLPUDcVNjTb7P7PI6l9fr8TtHobfFUoSO91HNZ5y3yJHAY4AJ?=
 =?us-ascii?Q?LP9qyvXsqWmk6zOclP0MVtwfb6PD+aH9SHr2okemtZA99hdQb0u/vYsJwT2U?=
 =?us-ascii?Q?2BP1680bys3BW0mouOpMpMMyJ3ZRNlNa6/hSlTxlGAok/6AgF3Ti8GJRA5d7?=
 =?us-ascii?Q?3yAwuEycrLY0un4SPw/ns5VnwI89Bhd7xCDTT/A/cMHhrc25hEt8nmjZtEPB?=
 =?us-ascii?Q?mh4kZByMURRfuJX5y4jsQOfIGLGH/ZcVwXYa4zkeunRzIWQ1vlRwvmkbKpfq?=
 =?us-ascii?Q?EqH9xYtpqv1uwmF2EOtcbJ5iiAH0319VVgyilRY++CiXjmHU+OBP9MsPhdyl?=
 =?us-ascii?Q?hT0PYINBR/zorUqn9XweePqN2L1u3csdOuWYgcgcsmMepdTrlypbYUReUXCk?=
 =?us-ascii?Q?eQe047QuIF1Gw7lWhcBjDm7mTOR4MxtK7h4u0FuP2dxKAHHtqchEVaxT1jwB?=
 =?us-ascii?Q?FO6vqqgT2DldQvcMUX3k18w5cqt4NgP+z5teWlFKOS0kFNPc8VUwicEqMRo2?=
 =?us-ascii?Q?qvIxqN2UAG9V5yncCFlCslj4IvG5S36WI8POoEVTV9thS2UMninUGQF7gkb5?=
 =?us-ascii?Q?HfFyNvPmdjpGMsnJNE8vCkG1x8Punt7+VcJqsAtkJbG5y1DLOf6xlDxb1/qa?=
 =?us-ascii?Q?UnH5jolfgxKcYkaldZkVH/92M6I5IdNG9NNdYMtTwimjNIlQ8GEBllSitYdN?=
 =?us-ascii?Q?qgueUp/zrD+Trs1/RITHRF/Eg53TS81BaXquJKk6xcOdq/VDupUYmmA4SMh1?=
 =?us-ascii?Q?H3o/Q65G/+nNoQQjkTj2VUu+PtJCIBE9AQqxCj4QqadmhTZLXdlB9C6hvDr0?=
 =?us-ascii?Q?TxLx5a5ONfRJpCl3BRsg24blXX+ijp/YoTj6rzjtGTrEL4uRtZn7W1bSKurx?=
 =?us-ascii?Q?GipEBNNQqXXd9crePrxAMgW4c6cKX2mF5sg0TAUtX4aiRTJEcqwMNdveTIWZ?=
 =?us-ascii?Q?LSDX1NnLXSE8QX+J8YNHlRBKuhJaZinEHpQ9I4QRuN+J9zGRh1m+5QWiMkyp?=
 =?us-ascii?Q?ecfri5C6ea9ShmpjierMgA94b+MIm6zgWncyYe0493jrudWh/uxBtWW+9s8M?=
 =?us-ascii?Q?Kcr7mRp/VtkV9krzHy0RZ8LKnNVwF9j0JJrQfC/+NeKzHtN5K3jIvCINYx89?=
 =?us-ascii?Q?H1xfSpPFt1MSYWnySqQ3IVtzasFD+tNA4uJKjLQJLs6L+qPZ1fJdDKUr9Tov?=
 =?us-ascii?Q?keuVGErh7UfXQqVKe4Ic2XS2Hszb0roeL2MSM+GG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1990fa58-d901-4ad5-b15e-08da84d3797a
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 06:48:23.8802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iu0t9qxIW9++gLibiyStO5K6Pw0wYuYipnS0KPs79rfjL5GTnBIS0EhWMGnDaqwToG9kg1nWuUFHoVN3pl+r2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4609
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 09:49:28AM +0200, netdev@kapio-technology.com wrote:
> On 2022-08-22 07:40, Ido Schimmel wrote:
> > On Sun, Aug 21, 2022 at 03:43:04PM +0200, netdev@kapio-technology.com
> > wrote:
> > 
> > I personally think that the mv88e6xxx semantics are very weird (e.g., no
> > roaming, traffic blackhole) and I don't want them to determine how the
> > feature works in the pure software bridge or other hardware
> > implementations. On the other hand, I understand your constraints and I
> > don't want to create a situation where user space is unable to
> > understand how the data path works from the bridge FDB dump with
> > mv88e6xxx.
> > 
> > My suggestion is to have mv88e6xxx report the "locked" entry to the
> > bridge driver with additional flags that describe its behavior in terms
> > of roaming, ageing and forwarding.
> > 
> > In terms of roaming, since in mv88e6xxx the entry can't roam you should
> > report the entry with the "sticky" flag.
> 
> As I am not familiar with roaming in this context, I need to know how the SW
> bridge should behave in this case.

I think I wasn't clear enough. The idea is to make the bridge compatible
with mv88e6xxx in a way that is discoverable by user space by having
mv88e6xxx add the locked entry with flags that describe the hardware
behavior. Therefore, it's not a matter of "how the SW bridge should
behave", but having it behave in a way that matches the offloaded data
path.

From what I was able to understand from you, the "locked" entry cannot
roam at all in mv88e6xxx, which can be described by the "sticky" flag.

> In this I am assuming that roaming is regarding unauthorized entries.

Yes, talking about "locked" entries that are notified by mv88e6xxx to
the bridge.

> In this case, is the roaming only between locked ports or does the
> roaming include that the entry can move to a unlocked port, resulting
> in the locked flag getting removed?

Any two ports. If the "locked" entry in mv88e6xxx cannot move once
installed, then the "sticky" flag accurately describes it.

> 
> > In terms of ageing, since
> > mv88e6xxx is the one doing the ageing and not the bridge driver, report
> > the entry with the "extern_learn" flag.
> 
> Just for the record, I see that entries coming from the driver to the bridge
> will always have the "extern learn" flag set as can be seen from the
> SWITCHDEV_FDB_ADD_TO_BRIDGE events handling in br_switchdev_event() in br.c,
> which I think is the correct behavior.

Yes.

> 
> > In terms of forwarding, in
> > mv88e6xxx the entry discards all matching packets. We can introduce a
> > new FDB flag that instructs the entry to silently discard all matching
> > packets. Like we have with blackhole routes and nexthops.
> 
> Any suggestions to the name of this flag?

I'm not good at naming, but "blackhole" is at least consistent with what
we already have for routes and nexthop objects.

> 
> > 
> > I believe that the above suggestion allows you to fully describe how
> > these entries work in mv88e6xxx while keeping the bridge driver in sync
> > with complete visibility towards user space.
> > 
> > It also frees the pure software implementation from the constraints of
> > mv88e6xxx, allowing "locked" entries to behave like any other
> > dynamically learned entries modulo the fact that they cannot "unlock" a
> > locked port.
> > 
> > Yes, it does mean that user space will get a bit different behavior with
> > mv88e6xxx compared to a pure software solution, but a) It's only the
> > corner cases that act a bit differently. As a whole, the feature works
> > largely the same. b) User space has complete visibility to understand
> > the behavior of the offloaded data path.
> > 
> 
> > > 
> > > I will change it in iproute2 to:
> > > bridge link set dev DEV mab on|off
> > 
> > And s/BR_PORT_MACAUTH/BR_PORT_MAB/ ?
> 
> Sure, I will do that. :-)

Thanks
