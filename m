Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1091328448
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 17:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbhCAQdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 11:33:01 -0500
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:58020
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231694AbhCAQ1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 11:27:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Th2V4wh2MkdLxFI5o3vIyhMBdDfZ3Nvea4YzC3Mdh0PQw0zTAp3U/qtT+LK11jueMIPvusakOVFuzYTCpFNVkELQlILuSU8ProocczHUG1GMOtnXTPH/ceAnB+VHfFFeQLB1U6BOqj9QBGBkkt64kS891T1QLaQDUCp7UAFu/zdM6PlvsqlzJV/E2zA8IL3rs7eLkKVA22P0D5EYfUw74Y4ycAWI8toaMvdZwjlo3u4AEN/wso0xUFICfpT1PyccaMnLCDMGl++PSPCZfcdpZxZQMCWGlXWHs9vdw2NtePjo0vOifxEHbqnCryrKnlEoOCh5+hBt4phHPZuhy7UCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nzPdsaqB2s57pOe6S8O+9wf9mMZ5euZgZR2x4fZ5Mw=;
 b=GUhodMvuWqhbGvdUxHyH4K0Rvf/7vivNOlD9XwZUQvDL6I99kvuIqEMt5WCAiEFmY4cY0Dt4lAphAAilEud5l6RAbKwgGYWUnZYeihpD4e7PQ9hTAQZoJ2rc+J16eWYQsLvWp1GlOZeLOPWgEtmPfeqq5+eNdHmYdZC4Pgqjxa0ffvG9A+0u5ZyWOTvrgraeQ/yZTSp8PczHsWndo8AgY/1bChZPIrSYz7PPe85VdHf85uI7EGMXBJQje0o2W0zfhI3U2wbzjbiqhueqh+yWKtN2z4tuGILF22WbyMsEyofvSD56eWj7KjD3hu50wZ3h/Ve7f9IFGFYWxqo4uHp0oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ipetronik.com; dmarc=pass action=none
 header.from=ipetronik.com; dkim=pass header.d=ipetronik.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ipetronik.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nzPdsaqB2s57pOe6S8O+9wf9mMZ5euZgZR2x4fZ5Mw=;
 b=muW8Kb9FDkPw2mUUIp4JCH5Ahp8GTPyjqIo/0L5xZmWuvUO5+UsSKveDNxY2eIGefE6jppdfyBLEcnMdIwhr3vWsbknkFeT0nF+0zMGRni68+jdN2aHCA2ICy4wYv1TTyMETd33aYrLe3kxeyxjtJ+UbqJtluw3k4rzq5Lkgh7V1BErVCq5OMzvRv8U/JNwqX+hyySHtkOHwZcGuX74eILZMHo9bF6X5ci1IjnDhXLNsu4Z5010hDtp/VH2aSMZbSe2tN8YUQq9jMYufSHTmrfCv26I1XFNVxAJsZ9aoD51st13fLhyU5avtTMtKCXUK4kPqEm8pTE9u6a3KW3OBVA==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=ipetronik.com;
Received: from AM0P193MB0531.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:16d::10)
 by AM8P193MB1267.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:364::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 16:26:54 +0000
Received: from AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 ([fe80::c432:16ea:4773:6310]) by AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 ([fe80::c432:16ea:4773:6310%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 16:26:54 +0000
Date:   Mon, 1 Mar 2021 17:26:53 +0100
From:   Markus =?utf-8?Q?Bl=C3=B6chl?= <Markus.Bloechl@ipetronik.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net 5/6] net: enetc: don't disable VLAN filtering in
 IFF_PROMISC mode
Message-ID: <20210301162653.xwfi7qoxdegi66x5@ipetronik.com>
References: <20210225121835.3864036-1-olteanv@gmail.com>
 <20210225121835.3864036-6-olteanv@gmail.com>
 <20210226152836.31a0b1bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210226234244.w7xw7qnpo3skdseb@skbuf>
 <20210226154922.5956512b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210227001651.geuv4pt2bxkzuz5d@skbuf>
 <7bb61f7190bebadb9b6281cb02fa103d@walle.cc>
 <20210228224804.2zpenxrkh5vv45ph@skbuf>
 <bfb5a084bfb17f9fdd0ea05ba519441b@walle.cc>
 <20210301150852.ejyouycigwu6o5ht@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301150852.ejyouycigwu6o5ht@skbuf>
X-Originating-IP: [2a02:810d:4bc0:2054:228:f8ff:feed:2952]
X-ClientProxiedBy: AM8P189CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::21) To AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:16d::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ipetronik.com (2a02:810d:4bc0:2054:228:f8ff:feed:2952) by AM8P189CA0016.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Mon, 1 Mar 2021 16:26:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c73f5c15-304b-404b-9113-08d8dcced3a4
X-MS-TrafficTypeDiagnostic: AM8P193MB1267:
X-MS-Exchange-MinimumUrlDomainAge: kernel.org#8760
X-Microsoft-Antispam-PRVS: <AM8P193MB1267BAFC45D5A91F096C1FF8929A9@AM8P193MB1267.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5mf/P+bNYvCzkaAPhY2an6CP2nnVEHc9tI9eWxgq/ibALQimPYS/+BE63rP7ivFDOO0gDHHwsQDUe3UczwDiPyRTNXg+xG0hTZzvxcIG1i3rrIwJByku+pSy8YnJTlHDcG+oypt/MAxky95ROyIoFsQ1/qdhuuN/+eFq7qm1yeCCUAvSk0avuEO4auLyS1swMQ4xSsNvrijprLo4aa8YxCjbpu0QqV0WnGVOQqXP7Kv49DRThlfOBONx28aZUW6LN7Z7565Ke5jgbjdnJvrW7JkPlxmpHf6vbYs0JzYpIwFBKYlPoMt1nDnS7Ymi5YRWKRUPT0fIkLKPQEp1tPvtgOnmEHZcSM3pxH0HbJMxjVVrM3oA74Ob39StbFVceLfIxVVBEQIKP2j75ZJu1867AS0I2IlquN81iurjTYg6ooqtIdqNhFrW9dodPANm4Hk+O3J2kK86prfxlCvZ/omJlAdmO0PeZqr4aLjRDqq33RRx/hNM6H5/W/5vEYjebM/CqbNyiKEjjmcFiqEcEbKKoICe4DXG/aC5gITq+/D74Fh/StLVsnQ9bz005XxthxTbxsfZn7O3ocC5eFTqXAM05nCwH/rWSJALOnBs8An5a40=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P193MB0531.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39840400004)(346002)(376002)(396003)(366004)(136003)(86362001)(36756003)(316002)(4326008)(8676002)(2906002)(55016002)(5660300002)(66574015)(966005)(16526019)(66556008)(2616005)(66476007)(6916009)(478600001)(66946007)(7696005)(8886007)(54906003)(186003)(52116002)(1076003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ErFG4yC/Iz1cdR9RVSVrzsDlAqMNCk/ztTSHEFm+lySwU4Wa5iSHDR9YX/Va?=
 =?us-ascii?Q?prEMRmvB61eXkXG1uEY8h+8ZLrCl2qp8w7mjtuOvk2wC5Tcs3ATaowusWxpQ?=
 =?us-ascii?Q?yf+9VBHPZNWT811aziqwglYIIyOMPakQzYQ9AH476D7dEpgEXnYFgPDZPL0D?=
 =?us-ascii?Q?jx8NNIMsBsaAXx93BZCbY2d8VisqDY1YJ3DRRcJ1vSWfXUslmATKKoQrVLWY?=
 =?us-ascii?Q?XQoq0UwFQuErL7fl31blsu2M0H7CqQqBc0Z7BI/C3CZ2BkvYYx5cBtMQdk3m?=
 =?us-ascii?Q?LbH3gUV09ORrQ5geZhpD7gmK98iqEp5CCZjuaRuSGiy0Ow9db6DDQ7cqcxLa?=
 =?us-ascii?Q?oEdTq0l8MR3A9j0Fs4Bble3rAA+ouI3RKXPouXh9Rnb1vPndb/0wKGOss2Xq?=
 =?us-ascii?Q?7rY3dBkawO6PsrcMQQoToEq+FEGXGzkQvyKzVKoADLP7Y/ail7Jf1Zk0ntSm?=
 =?us-ascii?Q?1MG0r42fZqwawK7QuNjfP/C07JDOYkY88XnqLfMhNWD7pMGvFcS3OO6Q8J4S?=
 =?us-ascii?Q?14ekMztmnHAg1gBAheMFum5CAm6S7zi29vvjXc1VS/ZKbVRLDLWBoolHwkRL?=
 =?us-ascii?Q?Ge6x/kQ/Mg3JuYDYRy231D3k3JoVd1WvqIepOvqv5/59+lScxQQyMhwUVS4/?=
 =?us-ascii?Q?sHh4E7OFhabP30mLMMx/CcmDxh8QFFx1suhn71E6kM3rjlspcp708YT3c5I0?=
 =?us-ascii?Q?hy45nVDS0oRHd8eapFsLpqRIuJ5Gy7AjcTiIp1xdGc4++joAI/CBKa0Gwio1?=
 =?us-ascii?Q?3SibcIQ/ByW1Rf8lKe9v/VnP4EEhS23PRLJ8fgkpzPtY38cpmu+T+um1mQpG?=
 =?us-ascii?Q?sm18rziglmV6AAIws+EQBIJ+URSKb+qLYPQVyokW8oDMMZRGlYQErmvxveQY?=
 =?us-ascii?Q?KT3Y5Ds6n/lZ903Enj5TIOgbZioDhu2cqj398vOjcLXVYzZToA8DWcsRuzk8?=
 =?us-ascii?Q?rF7Sj+VGBVIMdcoSMN6T8JzOW5PR0e7GA39XuIgM5syhzT7zGxOrfTPUGKSI?=
 =?us-ascii?Q?pu3jj1xLek1Cod0T+fLvqLMg4jGBMLiH90lOOZrH+nILEJW/f5Q2jV5pquaE?=
 =?us-ascii?Q?Ze2E74Yk985GGpbaNgzkn+EnsXDFcOw07lUiThvR99on/eI3ys+GDYL/7z9H?=
 =?us-ascii?Q?VO/a2m7QrRryHmpFfOOpGXV9JviIjeAZs+WuXC+bQqhUVQFI+IQi+Ue+uS9v?=
 =?us-ascii?Q?nhaRmc2r0p+1xF+g96p7FIHht3tRukT+5x2Sr3N7FQTPtC+JXgIQYeOXykJm?=
 =?us-ascii?Q?+PA9TBhngn/d7MyrPJT5+f7ylg1YyGIBDBHAM0Xz7GqI+9ri+PBQD1fSgzIH?=
 =?us-ascii?Q?0CUm6ieV0rf4pCRgUEEnXq+pLd+DlF5lrbRiigXoKDbr0oP820KRDPJJW6hm?=
 =?us-ascii?Q?kI1wkuA3oLa2WIj6oxx+gch5IKCV?=
X-OriginatorOrg: ipetronik.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c73f5c15-304b-404b-9113-08d8dcced3a4
X-MS-Exchange-CrossTenant-AuthSource: AM0P193MB0531.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2021 16:26:54.7545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 982fe058-7d80-4936-bdfa-9bed4f9ae127
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lgwai9aRY5LnD4lBFndOweqRCy2jJxWQWM7QWJ7wjwIMbyNhTQtIOGe8eMI7GqXfqueA+4pE68CAfpxX0hNj6uEwT8I91YipRGkA8u3x3LA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P193MB1267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 05:08:52PM +0200, Vladimir Oltean wrote:
> On Mon, Mar 01, 2021 at 03:36:15PM +0100, Michael Walle wrote:
> > Ok, I see, so your proposed behavior is backed by the standards. But
> > OTOH there was a summary by Markus of the behavior of other drivers:
> > https://lore.kernel.org/netdev/20201119153751.ix73o5h4n6dgv4az@ipetronik.com/
> > And a conclusion by Jakub:
> > https://lore.kernel.org/netdev/20201112164457.6af0fbaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/#t
> > And a propsed core change to disable vlan filtering with promisc mode.
> > Do I understand you correctly, that this shouldn't be done either?
> >
> > Don't get me wrong, I don't vote against or in favor of this patch.
> > I just want to understand the behavior.
> 
> So you can involuntarily ignore a standard, or you can ignore it
> deliberately. I can't force anyone to not ignore it in the latter case,
> but indeed, now that I tried to look it up, I personally don't think
> that promiscuity should disable VLAN filtering unless somebody comes up
> with a good reason for which Linux should basically disregard IEEE 802.3.
> In particular, Jakub seems to have been convinced in that thread by no
> other argument except that other drivers ignore the standards too, which
> I'm not sure is a convincing enough argument.

Admittedly, I am still not entirely convinced myself.
I don't know why the other drivers do what they do, why they do it and
whether that's correct.

That is one of the reasons (next to quite a few issues I had with patching
net/core) why I ungracefully abandoned the mentioned thread for now
( sorry and shame on me :-/ ).

The main problem here could also just be that almost everybody _thinks_
that promiscuity means receiving all frames and no one is aware of the
standards definition.
In fact, I can't blame them, as the standard is hard to come by and not
enjoyable to read, imho. And all secondary documentation I could find
on the internet explain promiscuous mode as a "mode of operation" in which
"the card accepts every Ethernet packet sent on the network" or similar.
Even libpcap, which I consider the reference on network sniffing, thinks
that "Promiscuous mode [...] sniffs all traffic on the wire."

Thus I still think that this issue is also fixable by proper
documentation of promiscuity.
At least the meaning and guarantees of IFF_PROMISC in this kernel should
be clearly defined - in one way or the other - such that users with
different expectations can be directed there and drivers with different
behavior can be fixed with that definition as justification.

> 
> In my opinion, the fact that some drivers disable VLAN filtering should
> be treated like a marginal condition, similar to how, when you set the
> MTU on an interface to N octets, it might happen that it accepts packets
> larger than N octets, but it isn't guaranteed.
> 
> > I haven't had time to actually test this, but what if you do:
> >  - don't load the 8021q module (or don't enable kernel support)
> >  - enable promisc
> >  (1)
> >  - load 8021q module
> >  (2)
> >  - add a vlan interface
> >  (3)
> >  - add another vlan interface
> >  (4)
> >
> > What frames would you actually receive on the base interface
> > in (1), (2), (3), (4) and what is the user expectation?
> > I'd say its the same every time. (IIRC there is already some
> > discrepancy due to the VLAN filter hardware offloading)
> 
> The default value is:
> ethtool -k eno0 | grep rx-vlan-filter
> rx-vlan-filter: off
> 
> so we receive all VLAN-tagged packets by default in enetc, unless VLAN
> filtering is turned on.
> 
> > > I chose option 2 because it was way simpler and was just as correct.
> >
> > Fair, but it will also put additional burden to the user to also
> > disable the vlan filtering, right?. Otherwise it would just work. And
> > it will waste CPU cycles for unwanted frames.
> > Although your new patch version contains a new "(yet)" ;)
> 
> True, nobody said it's optimal, but you can't make progress if you
> always try to do things optimally the first time (but at least you
> should do something that's not wrong).
> Adding the dev_uc_add, dev_mc_add and vlan_vid_add calls to
> net/sched/cls_flower.c doesn't seem an impossible task (especially since
> all of them are refcounted, it should be pretty simple to avoid strange
> interactions with other layers such as 8021q), but nonetheless, it just
> wasn't (and still isn't) high enough on my list of priorities.

