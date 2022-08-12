Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8655D591631
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 22:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiHLURC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 16:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiHLURA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 16:17:00 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2058.outbound.protection.outlook.com [40.107.20.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EC48284B
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 13:16:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZ9kZ59/Or8EhEcj6tzZyRt5l9k5D6GnGClAOGBiDiGtKmEvJu95n2FeXi2Hi9/x4HpIn1X22/YqIfkTRxyrq/d79AifsdbJ0wNgrht3v3sDzPgeGe1DVJ9InMRSZyWWhDT587ndJLtvzog2mvULUB8X6pGaF2NhbtK5GPAqj0S1J8t/8QpmUhb0IwIgvbTN00si7rCOgfUNS9zdyTQK7XDRsRGtOwlBeld8xTk92YHWH0wq3sRExVZiVQv2PdGl/LxEd+ybBeQo4mYUdRdkzeBXWVE1wVwFHX184+KNkU4fIYBickb1WiCtgKcMPjC4m5TYID+Rn1qRwYLw+BsVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sTc9PdBqGmmN0WfK9xTrCyDRYv7/2T7NwJW2tjGpug=;
 b=fBEPt9Pw82pK1KmSS1eGKOivOz9aLIep1Nx9NvYEA8qwkwUpwIQaJ8tBzAGxZgTkcTNtGvxXuQc7Has84Svsw2jAEmEOXaYIcFdxE5GKJRME7PeeVk3qkhe8l/ilF6dDe45W0gFvjIOQOMmZgY7TMacsgaw+UD57iZ3bj//iPH5FnnbPJEu/pii2r9DBl05Y+BigFdm2LYT3gDb7Fbtf4Fh+AHESQGT6UuseanOBsGB3vfuN8hrd8d97RpWkEvbBYgnRN8xShP2ak5/BhYqYKCK5HVc7rKRj7xXvE1iSC0UgxLnq56Q4c87VhAnCHUvWqH1PiPhn7HnXUkh6ayh7/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sTc9PdBqGmmN0WfK9xTrCyDRYv7/2T7NwJW2tjGpug=;
 b=IqzfhjFhmZUamfGBAQgWAzaSeTpVV7BxwaH0nqin2o+MG1/6/yMyxrZDR1lZHO18ihgnRgHOHqHwZpe+/BVNtXtpepztP8JEMOTMhF0iwOWU+/MpGhD2QxiDUMt7oYdRctZBDJVmOSjIOyvWK9Zrova11aayNA1w5P0jBJLRPAs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7346.eurprd04.prod.outlook.com (2603:10a6:20b:1d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 12 Aug
 2022 20:16:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Fri, 12 Aug 2022
 20:16:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <ferenc.fejes@ericsson.com>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfA==
Date:   Fri, 12 Aug 2022 20:16:54 +0000
Message-ID: <20220812201654.qx7e37otu32pxnbk@skbuf>
References: <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
 <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
In-Reply-To: <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b2c3973-ce01-413d-737f-08da7c9f99f6
x-ms-traffictypediagnostic: AM8PR04MB7346:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EeuYNgrwkV3SNkNndYmzdCb8RvnDj0sUr/dtvD0oKQPFwkeKPRUzz3VgPn5hpHnulB1BPwOWacxgoVKItYN+BVJtrUJ7tZYle62NyQCRTESWNgY0yEtNfZ6AEpXOtXI7R+T6AlK6d4oTCnCko6chmjEHunzu5ZHitLYq0ca4Aj6l0uhOG8khA1a4KknAO+8I5tqM0icASJwuEdYNeTxq6E2T5woUemFuMicJjTQ0hTTwRgcHQOJjLy8sqC3nRO1PVbb7dfhwzaNcmgXSyxAkrXOjvyXbvcslxnfbNCjzOF0IdcU7GrtlNp5hM1k69CYw5fLdYDo4Z4kfY+CKDKhf5ENCgMgq8N0JSpyxeRbxjfAbvK+09DkIHP5Oo1kE8MLfRtBPY4lA0ZRWB5Zc7Ma6/6TWPou1Ym4xz9m4eGXQgEcZ+Ao9FQJ73l+RoRI2xkGwvnT0wle0iKTD/3CqN83XXdQKdLPvTXCRVY4FQgqQZX3smhjBL9nWBCDsP6vYK2lub79L8q3tlxVSSopneiZuSD+2ATh76sPyYs13nMmC7HGRUNdJn9aC/iRq38NiFk25XZex6dkEC8FUxcRuvXtXBbRviHPk6j/LNnabPB2tDNi9Z8CE2R64eIJcYpz513COKPNybDKEOvSoWeOeult2G3ZANYAVeoPdDvBL7TTSF/N+mBdzTPY09ADH/Ahc6b3Je7D7BaBaa7nJr2ympMXnnvK6AzSKK2QjeBmWHUNbniP+IHp87QiN1pRf9an4CJa612jdgP4Lo99Ee+z7sdNe95ELJKoUka7jZkIa+8dzrGM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(66446008)(66556008)(8676002)(76116006)(91956017)(64756008)(41300700001)(6916009)(4326008)(66946007)(2906002)(33716001)(316002)(54906003)(186003)(1076003)(122000001)(26005)(6512007)(66476007)(38100700002)(9686003)(86362001)(38070700005)(71200400001)(478600001)(6506007)(5660300002)(8936002)(6486002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3+wGsLLEEdEQ1hlj9TG1U7ZYTWtpiA5SJJpR7UJoazl0HbKc6QTBcjaL8lIT?=
 =?us-ascii?Q?vXoq4YKR8UDwGE+Bzfefv5p/YPbh2oz7BHHdXGJFzhBETh2fMb4Qkq29yJ9i?=
 =?us-ascii?Q?+06CXwzrEZFACE9Hvli24+91NGYw3tf4EUl17MQXeK6nfMbplPp72/azq+Ec?=
 =?us-ascii?Q?eFH560FV6/0b3p+GxJ3pil0MWzwZU5eDqyoTtWFJiF22LaCTKZiW0fG99zXH?=
 =?us-ascii?Q?eF7TPgJoXFyWPNQAVz2GM1owApiP+k9Ay1nCn+SR264mm2XYXm4MNDwOGIbw?=
 =?us-ascii?Q?0DPPq0Hb1Lz6zaUfigXrM4bvivAIuZkfatQ2YVRGlUIW401kTXFGjUmI+UIV?=
 =?us-ascii?Q?9Wd7wI0vTwDVfjD3SBv7Ez5zwk2pSxgu8kqWtPyxfj/LxEcOcXFcGu5bbT25?=
 =?us-ascii?Q?Ry8eH/+AbAysrb8tSEzzWzmNNS6dwoAhkTSFfDPZ3eXTodV7yCshQtrOpvHi?=
 =?us-ascii?Q?jCusjko0npAS19xVB+xgUyJBE+4XOJAVMse/nbL4/X9ERI0J1ZKfWDfRONLK?=
 =?us-ascii?Q?lpQ1sGmDsf79D7EvF8ojPD9fmskVY4nXWmC9xLMn1nXjdi3dcvOJ1RdIWyjf?=
 =?us-ascii?Q?8XRB1Df9n6tkqLUyikH/urJOzpaO32J3F34Z7InSr/wDdOeyMJZPwD3Baqcj?=
 =?us-ascii?Q?J5BnnsJhEys4xhn0XvSIkQ6irz3rBdNOU9nizWRI5lV6G3GVzbZKqGJtrTUa?=
 =?us-ascii?Q?4iowi1VvTHumU2KYtGZS92jXE8gsXVKHS2DRKUwkDEnuRthDqiUkZ1ci7tEJ?=
 =?us-ascii?Q?F9eNBEDltGCnlxuWqEwRpsGAY5NQgBX1n5Scxq9agVoHYEhoO/zBdMQpgaYo?=
 =?us-ascii?Q?rUHHcLKo7YWuTqIhng4mZeXzlj9usFU20JX+dQ32phCTyICk9u0oJg8tTAky?=
 =?us-ascii?Q?ISC8diDFdjha/OwRbF/QgQncbWNEQ7Sd+okK4CCSfAKp5TEW4c0EEhlqCHGw?=
 =?us-ascii?Q?GhWpue1DT+mmCGcp++e0+ZXVz+ii7NF6FkpnjQvoMDSsbxxNi4FI6tudTn9e?=
 =?us-ascii?Q?DGm2TlVbqLipI2xGS9nqbwd+9EK5aS/7useGRrCLaHne4lv/EJmeIkeZe98H?=
 =?us-ascii?Q?ZfxpllOVQmb7s4swsy+JeQLCoP/zUh4NFvURyVjRBS50D9rPXDWT6MlvHfWG?=
 =?us-ascii?Q?wtL5tl38x+yYY5G4svvLcPw1jJVwdhPk41qmCQ3PQqsuUuSF0mXstQidit+t?=
 =?us-ascii?Q?khKwEWgDpLkXTNSAXLpGG1I3lO/12cPU0OtkwPOsQrYTQm1bAH6trTtCaoaH?=
 =?us-ascii?Q?Xn5LZ/m85eR0zoMOu65aPFFtpYidtL0EyMRTN8RfgUHBy/LTqyxsTsvK/SDU?=
 =?us-ascii?Q?UIk/GlTRptK8xsNPeDVzu+msc2E+mB43bzfLL35B1t00eEsTdAa++LtSJrcP?=
 =?us-ascii?Q?fVL5qa+lQ56E81Eaa6SmbOWA5rYyD0sfZn/20wTooUnG7TJ7iFU2rmT1lxgD?=
 =?us-ascii?Q?k8lb+zviCEpfu1mwjz5xjk05ByyD00z8UFnKeh0X+gg8AdKSVolsofBxwhH+?=
 =?us-ascii?Q?YLKdnTS+B7CJnpZVvLKNQMmI8uMN7iutSc/534pGACHZwtcVOtqcXxPVW5XO?=
 =?us-ascii?Q?1A9FwdTXgz6+Zi1DVcDA8QPYew5xC09LD/rY7aI1mG2XPqwLdNfq67BxH8pd?=
 =?us-ascii?Q?IQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D9D1DD5F519FF64BAF33D5712D765690@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2c3973-ce01-413d-737f-08da7c9f99f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2022 20:16:55.0587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AGf2z+xrCCchPT3mr1NHVfZwLO2oj6koIgVl8q9xy4fOstMbHjf8SXAxXi9BW6yhvXnCNtAVYSkInWP+9xTgiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7346
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

On Fri, Aug 12, 2022 at 02:13:52PM +0000, Ferenc Fejes wrote:
> Ethtool after the measurement:
> ethtool -S enp3s0 | grep hwtstamp
>      tx_hwtstamp_timeouts: 1
>      tx_hwtstamp_skipped: 419
>      rx_hwtstamp_cleared: 0
>=20
> Which is inline with what the isochron see.
>=20
> But thats only happens if I forcingly put the affinity of the sender
> different CPU core than the ptp worker of the igc. If those running on
> the same core I doesnt lost any HW timestam even for 10 million
> packets. Worth to mention actually I see many lost timestamp which
> confused me a little bit but those are lost because of the small
> MSG_ERRQUEUE. When I increased that from few kbytes to 20 mbytes I got
> every timestamp successfully.

I have zero knowledge of Intel hardware. That being said, I've looked at
the driver for about 5 minutes, and the design seems to be that where
the timestamp is not available in band from the TX completion NAPI as
part of BD ring metadata, but rather, a TX timestamp complete is raised,
and this results in igc_tsync_interrupt() being called. However there
are 2 paths in the driver which call this, one is igc_msix_other() and
the other is igc_intr_msi() - this latter one is also the interrupt that
triggers the napi_schedule(). It would be interesting to see exactly
which MSI-X interrupt is the one that triggers igc_tsync_interrupt().

It's also interesting to understand what you mean precisely by affinity
of isochron. It has a main thread (used for PTP monitoring and for TX
timestamps) and a pthread for the sending process. The main thread's
affinity is controlled via taskset; the sender thread via --cpu-mask.
Is it the *sender* thread the one who makes the TX timestamps be
available quicker to user space, rather than the main thread, who
actually dequeues them from the error queue? If so, it might be because
the TX packets will trigger the TX completion interrupt, and this will
accelerate the processing of the TX timestamps. I'm unclear what happens
when the sender thread runs on a different CPU core than the TX
timestamp thread.

Your need to increase the SO_RCVBUF is also interesting. Keep in mind
that isochron at that scheduling priority and policy is a CPU hog, and
that igc_tsync_interrupt() calls schedule_work() - which uses the system
workqueue that runs at a very low priority (this begs the question, how
do you know how to match the CPU on which isochron runs with the CPU of
the system workqueue?). So isochron, high priority, competes for CPU
time with igc_ptp_tx_work(), low priority. One produces data, one
consumes it; queues are bound to get full at some point.
On the other hand, other drivers use the ptp_aux_kworker() that the PTP
core creates specifically for this purpose. It is a dedicated kthread
whose scheduling policy and priority can be adjusted using chrt. I think
it would be interesting to see how things behave when you replace
schedule_work() with ptp_schedule_worker().=
