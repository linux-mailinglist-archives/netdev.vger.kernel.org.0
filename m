Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECD82FAD15
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387587AbhARWI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:08:56 -0500
Received: from mail-eopbgr50109.outbound.protection.outlook.com ([40.107.5.109]:51438
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733204AbhARWIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 17:08:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkiG2oc3s6iEsA/3ojSpmfdMk4BJqmNodEVWzdb6o5IktNmbhSV9gHb4B2jyEJinQfsdJ9hSnLk4bLMVVXHiDX2tB93HQw+mVM2aLj34txcC/+lizYMvfTTFBOk+epIJm2MBvlub291oz9CjpFDwl9UNZjAzcRxpR+Hu066hRAQ3HfWrLxHkYeNzh+6bxFI2jpFax61XRad7qCU/5MGAFIZTbSJiUxEzZ/nNRr6bEne2QeRVtXSbBtkPB/LQoebHxQ92PFMeNH8NAaZglVbkvodSsBH0GgYDJrPWCCX1Nkc+YLjc4PKzhle5Br27SusioArgQG9XPY4bok7sa8mYkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmNQ1Wg94y+XGPj/oFKXRMhE59/3Q0nh5UkitPLt18Q=;
 b=IXRDmUH16LylaDihehBbLU0ezSR692gQnSWZ114W2HwvQStKDFP/IjyyOLSfqSKZBhF8eJz61e94PjDDfUY2ra8L4uZ9ogMvx/iwu96+4BxLbIT/QbRhU05Qa4ylvh9GgW70FEM9RAkCKmge9aORiaYCRCCLAlQFAOhhqHRbZ+cP1LAaob9zqrq7XluSvKfxFQWLwRQ4zqfeEa7mBm5MJxSEYAn7YTJ8zUM48pH91HKf01+jvBs3AyU6nd+FlVEyeKPiCNJEEAAP1QroJMefrNbmbJJ32n3HC2jqCUW1yt1SQwBBZPomYYX0s9vz4eFWUjENCIzQIBZjCaZctTiOSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmNQ1Wg94y+XGPj/oFKXRMhE59/3Q0nh5UkitPLt18Q=;
 b=Ur736pumSGEJTotNmFrPLDkfbtKAO4T9dJKlkF8/AywWoAz5bP8LON3rYLm3onBtTV1r5xMxrncQ/WldmhzFa4bBrcg11o/E+FpF+y1NEMUPrGBdaWmRLO/JCAgXyC99IrPlI+I8uFhDnBfhOErHs9NTEFqQbLqsu4bmmQiz7FY=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Mon, 18 Jan
 2021 22:07:49 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 22:07:49 +0000
Subject: Re: commit 4c7ea3c0791e (net: dsa: mv88e6xxx: disable SA learning for
 DSA and CPU ports)
To:     Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
References: <6106e3d5-31fc-388e-d4ac-c84ac0746a72@prevas.dk>
 <87h7nhlksr.fsf@waldekranz.com> <20210118211924.u2bl6ynmo5kdyyff@skbuf>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <5c5b243e-389d-cca8-cf3f-7e2833d24c29@prevas.dk>
Date:   Mon, 18 Jan 2021 23:07:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210118211924.u2bl6ynmo5kdyyff@skbuf>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR1001CA0024.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::37) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5PR1001CA0024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:2::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Mon, 18 Jan 2021 22:07:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30577ac0-6940-4d41-f778-08d8bbfd7e58
X-MS-TrafficTypeDiagnostic: AM0PR10MB3331:
X-Microsoft-Antispam-PRVS: <AM0PR10MB33310EB153596F983DD6D4E193A40@AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cxDYjR6LpTHAMyJ+yYxaW/cKM48WlTQoWOzU2CNxg8jyci7EChc/NRzahewBntiSZ2s2q1hKWMKULJMn+z2wjwk4o2H9hvVORaOS/h8hqLHb2pfk5AzAR5JXq5pz6FJP6OdD9viBgqTae/IdB0BgkBzmY0li5gT2w7ohtLwTXcGumeRDWfzFqu/8FvvsojDbVR+c9cvmAsiUk+C9Psz8E4qxODAjkKJAK9BExMengAPFTeTmGPIPEaDjC42bZI0mw+kd7H10TK0+cZwSg6U0kEBGXuBzT9nYywFkbx1daGdvEz6zjfjGt2f6LIPfEi0GfB3Yi9qIgC/k7Zh9XOu9SeDHQXLCqSkLBQ4/7jo0fiTI76VQrIIr4ylMm+UN+Q+eFEGRBmH5SEE88NfI80QqY3Ptc+v4PKJhZbgwu4hJOlv97aGd4CyzUSPuh9psDOwNURLgyJyMxfZm7FPNg0c+pvxxVP8Ax7lhaiiLdSUxvccIf5hVRwRMBqxELPakYKxJrZzf/pSYDZRMrjCQt5b7yWFgwESjUt0/eMtQH2ZaL5M9xwrP+rky0bO39JwhWdje3lti3KYor01vgDR+fze5c6NVucT+6lkqJOqIZiuDj8k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(346002)(366004)(376002)(2616005)(316002)(6486002)(16526019)(31696002)(26005)(186003)(956004)(478600001)(16576012)(8676002)(86362001)(2906002)(36756003)(5660300002)(44832011)(4326008)(66556008)(83380400001)(8976002)(8936002)(54906003)(110136005)(52116002)(66476007)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?9LQL+pfVRSPXfZBuVRSjJNZqdVTBoF8m9SFGRrpvgWBvjEhSF410RL1o?=
 =?Windows-1252?Q?qQiJrc5kQhP+3g4OuE7TNtKvW3mnXKMcSqPpGhpo/EAoaaqk88zGnQ1K?=
 =?Windows-1252?Q?lrJRXG3aR5HhZHfSyBSSNaSwLo1ly++qY1fHVSnmVTwfKe+9IhTnP7Qz?=
 =?Windows-1252?Q?ldM/4lYedy92Ntf27pJZ/fZ3bKjjGbe+Gy33o7MXfxvkM5wWUSri/qd7?=
 =?Windows-1252?Q?yBuYVChSh+8iKAEZ8tKqi8nlqYyup2EoRIMH3r+3xoHQSUYKVwrVDV5p?=
 =?Windows-1252?Q?sGLMcFOkPGMHjqLjlDokODuQ/zSq6z4lG0kZQy5XdotdyAtHyAkmQE11?=
 =?Windows-1252?Q?p/X4a7fgN9tzUm/gac+QVSytQBY7k6uGCEL7DsGDMDJHjuXgDy7F3IeX?=
 =?Windows-1252?Q?0KNfSB03yR2m5s+e9p7JTCPaLrxPPLy/017vuYCDRmNsvh1IktYJBx3F?=
 =?Windows-1252?Q?Zqi8TWeLFuHZfOrt2GwCyowebu/z+FsxxnQyQOy1yF5KfrzHqtYJaSVX?=
 =?Windows-1252?Q?PejRcXPlo23lpRErFAvWKm+Hr0BH2oKFaMB/Ob4ObGY9l4QxmwiYMmKw?=
 =?Windows-1252?Q?vbEVdmqfUQl5ymtm7KckvZ1I+xIXo+Uy2zWSqZa1iQPd4Slhu3M6Kdd+?=
 =?Windows-1252?Q?oXbHPjEnMuYYnRS3cJMC2RTOD+D0NuLBJaRC2icJ9Wj64VWWzQu5zf2+?=
 =?Windows-1252?Q?yaQEnb2PvF8icFzeMN3zKXHYmaVkiU/OF2ClRsddvI+8nByUVQEtyXxS?=
 =?Windows-1252?Q?a+abWqJsCWN92ha4FfG2wTDLDiIU4duKGJa3xCV7FLYcKweBYmCwE0dS?=
 =?Windows-1252?Q?vQTAnn2WVZB5/6FHtv3dMrMT356ngLrU8GPRtn6q31rKzuO1SgEd79qr?=
 =?Windows-1252?Q?C5BuzBrKMQOE07nbQNcXCzYCw92oc+tizg6339RGzKgUe1p/Va4GPIuc?=
 =?Windows-1252?Q?/V2gi900jsd99St79tWm3EgQhY+kyvZeeAvlgyWAGCY7ZVhRJRpb2cRG?=
 =?Windows-1252?Q?qoc0rxmxWIFhM2GhcLbbipmt8CzbPRb/7lRXH+k1UKkaMajRvvglqMfN?=
 =?Windows-1252?Q?Yke5w/HDKeIRjGD9?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 30577ac0-6940-4d41-f778-08d8bbfd7e58
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 22:07:49.5983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtPQ0XR0XFcXmgeKU6QH/PxjTiYfX9EFdbhWIVlpvbDRGLYBZC6afb043jfqazMsrEOWvbKdik7iG0iLUObVnzZCBEjVVkiAGH1a8DYQVmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2021 22.19, Vladimir Oltean wrote:
> On Sat, Jan 16, 2021 at 02:42:12AM +0100, Tobias Waldekranz wrote:
>>> What I'm _really_ trying to do is to get my mv88e6250 to participate in
>>> an MRP ring, which AFAICT will require that the master device's MAC gets
>>> added as a static entry in the ATU: Otherwise, when the ring goes from
>>> open to closed, I've seen the switch wrongly learn the node's own mac
>>> address as being in the direction of one of the normal ports, which
>>> obviously breaks all traffic. So if the topology is
>>>
>>>    M
>>>  /   \
>>> C1 *** C2
>>>
>>> with the link between C1 and C2 being broken, both M-C1 and M-C2 links
>>> are in forwarding (hence learning) state, so when the C1-C2 link gets
>>> reestablished, it will take at least one received test packet for M to
>>> decide to put one of the ports in blocking state - by which time the
>>> damage is done, and the ATU now has a broken entry for M's own mac address.
> 
> What hardware offload features do you need to use for MRP on mv88e6xxx?
> If none, then considering that Tobias's bridge series may stall, I think
> by far the easiest approach would be for DSA to detect that it can't
> offload the bridge+MRP configuration, and keep all ports as standalone.
> When in standalone mode, the ports don't offload any bridge flags, i.e.
> they don't do address learning, and the only forwarding destination
> allowed is the CPU. The only disadvantage is that this is software-based
> forwarding.

Which would be an unacceptable regression for my customer's use case. We
really need some ring redundancy protocol, while also having the switch
act as, well, a switch and do most forwarding in hardware. We used to
use ERPS with some gross out-of-tree patches to set up the switch as
required (much of the same stuff we're discussing here).

Then when MRP got added to the kernel, and apparently some switches with
hardware support for that are in the pipeline somewhere, we decided to
try to switch to that - newer revisions of the hardware might include an
MRP-capable switch, but the existing hardware with the marvell switches
would (with a kernel and userspace upgrade) be able to coexist with that
newer hardware.

I took it for granted that MRP had been tested with existing
switches/switchdev/DSA, but AFAICT (Horatiu, correct me if I'm wrong),
currently MRP only works with a software bridge and with some
out-of-tree driver for some not-yet-released hardware? I think I've
identified what is needed to make it work with mv88e6xxx (and likely
also other switchdev switches):

(1) the port state as set on the software bridge must be
offloaded/synchronized to the switch.

(2) the bridge's hardware address must be made a static entry in the
switch's database to avoid the switch accidentally learning a wrong port
for that when the ring becomes closed.

(3) the cpu must be made the only recipient of frames with an MRP
multicast DA, 01:15:e4:...

For (1), I think the only thing we need is to agree on where in the
stack we translate from MRP to STP, because the like-named states in the
two protocols really do behave exactly the same, AFAICT. So it can be
done all the way up in MRP, perhaps even by getting completely rid of
the distinction, or anywhere down the notifier stack, towards the actual
switch driver.

For (2), I still have to see how far Tobias' patches will get me, but at
least there's some reason independent of MRP to do that.

Rasmus
