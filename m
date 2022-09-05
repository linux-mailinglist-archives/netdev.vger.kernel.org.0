Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAF45ACE7A
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 11:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbiIEJAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 05:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238024AbiIEJAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 05:00:23 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60045.outbound.protection.outlook.com [40.107.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BC4205F9;
        Mon,  5 Sep 2022 02:00:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPdL9GkpIeL1TvjnGIN4tWQoFCxiyZ3+dh55noNumpUXTQdE4XJlm9j5ZZYeEfxhDcjkVvglaIPXQ/3k4Snk2Ut+K9jxVs54np5VD77QfyNBsanD0zMPn0wGthQjUMZebmDz9ihnso8dtqYBfcVavCVaWrn18LPUig6iXAWaGDoH+He9y60VLpU5oNSZmNcMUtoSHMYvj9QJ4yjaZSyB3DRa/33bq/KPVHaD8Sy/xqFhjZF/HfJqBUveo/hZ5pFgheR7m8rcHenQqXwndA3fjH8rKNatvsjC/nTlshBswLYJ2kUaAh2yKkr/HqqpuOoCQCv2Nr5rdvp0qg2xO0FmFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UZIjIwJuTH7w4KSQZKGlA85lKpbyGz3FuYFb0/H7rD0=;
 b=W4WgIeCXDBdtSSygxjmsp/BvN3kr923w+XLYhA5h/hFuuzHlTGwIAEqiCT6n4yqJHiEtFsJUNVTZVoD/OCQ1JcpEx5df2CdQOdd35ynj73ApszkyakRT38VgoC/nR3pv3mCkKi45iP90HWbhBbKlCvc2geomjgkMjTOoikHPLF7YbK8b98ECeDBQVXfh3y72WK73pM6jVF2meCt+sl7rNJF6UHOQDQTQJa4Q+t4CqH8xTkWICQ6zjnvUgmJ0KvRJ9jMlg2vV7Y8wy9Bn7DFrjzP69XvgZLgGSwi1KpljIFfDAzb4keuINBcsPjXdlZJAXiIf6O1eO0lAtDDB6CXWow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UZIjIwJuTH7w4KSQZKGlA85lKpbyGz3FuYFb0/H7rD0=;
 b=g71a+D2QBPnqPhXIdbVfhFDEweodu9KlUyvbdJ9Vcf8yq/+v0T7VZ3uUVzYabfpMfnwwJgig+RxmGnBbtjyvlszUW/I5Klgqd5fH24CMJ22T1wxqRcH8XUsIwmsGG2h9elbj6Gxb4shF3KWtmHpfYpfEElA2yIOCXV159fMqg6c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7470.eurprd04.prod.outlook.com (2603:10a6:800:1a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 5 Sep
 2022 09:00:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Mon, 5 Sep 2022
 09:00:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/3] net: dsa: felix: allow small tc-taprio windows to
 send at least some packets
Thread-Topic: [PATCH net 1/3] net: dsa: felix: allow small tc-taprio windows
 to send at least some packets
Thread-Index: AQHYvxb2JnEUpt7Y8UKoLu9LT6DSNq3QdFsAgAAZSQA=
Date:   Mon, 5 Sep 2022 09:00:16 +0000
Message-ID: <20220905090014.w557vqbhb5oefupi@skbuf>
References: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
 <20220902215702.3895073-2-vladimir.oltean@nxp.com>
 <3fc12b67842d87a2fb8a5941c899c529@walle.cc>
In-Reply-To: <3fc12b67842d87a2fb8a5941c899c529@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a58afb9e-1820-4dd7-eba0-08da8f1d0d06
x-ms-traffictypediagnostic: VE1PR04MB7470:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V0TVw6SPPJoaylsJLUg9mqMu2BU30StTdulVPAY3AXcvi2yMsL7TYo0g7oB6RnRPAk383bqfTuapDZXbwnIU7Uac+v6+VDcggZWsOL5zRquvPDqxfL6OM+j4zf8Gb2QtVtXtO61yrmCftAclwfrVM81Iyfs+B3vfoqVxZLmzXcDHrXYrgxPk0ETLz67H6PQ6HDAM8B2FO8nhbPR0tBkyh0PPGAU49Vc3oVKfJngRd23WnJH7E3+mHgsFHJIqDyjEiRUamFDeC3dP3JCmJWgdV5e9DM/d/5Vkkf7rY95wS9r6k+aAfFlAKf80pv+vTPQiI6gs1FuTH6C51eXBk9fnQbrP88JNdNTyrbLRpWzRFmsRvmTkCcXum8K3uWosw9Z4N+ZUY3Np7wSvxMreRoyHgBTCvm4R0PADTa0XCrdC7mPWJMRbkTdcE2pAKchDJVZ8qLg8WM/jzhIDCeQECt0/k1O2duDh9P2BRBjphqL0LOSNhqdfY5WpU7q0WdYQJ8x6J1owi5E09sUoHelO6InW3mKPVu+8QtByloi2CKmxzSIBGb5AQfMp3/Rmkcpkhfd2Ip65i+Oit3BjzpM1eEonVXIzJSti/8rhCUMAV7Z9f5JP44hwA0LYBGpdOhJl3/2crDeOlCJJmfXkGI5bspDNSPfBcJYSG8iJGfpYmN1BpUc2kYL1Q3/BsR5VBJBK+YnSKhYiPDTIgMppyQZ0H2Y5MbBgT0YdHaYfVd25GpKpa6AbtP4a/qBDLB5RemPEB5VgvCNqHLBi7BeSmwAayTG4GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(39860400002)(396003)(346002)(366004)(376002)(136003)(6512007)(5660300002)(41300700001)(9686003)(8936002)(33716001)(2906002)(122000001)(26005)(6486002)(478600001)(38100700002)(44832011)(7416002)(66556008)(66946007)(76116006)(66446008)(66476007)(86362001)(64756008)(91956017)(6506007)(8676002)(4326008)(38070700005)(1076003)(54906003)(6916009)(186003)(71200400001)(316002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tQPjIyd0O66wctHNz9eLwELF8AsLCY0hKl5wLGhCe0luhog0VL+W9RvHjKFn?=
 =?us-ascii?Q?VRvD90sw22KZDROZJmIjxBWUo8rLUK25TxIAJPQV3pDB8QpLG7v08Ootp/cW?=
 =?us-ascii?Q?1nLK+ABXl/gWRID/vvtT9saDZndlK4Orj+RtVa8GaLnUEMNyp/s/9bdeZdkW?=
 =?us-ascii?Q?dXGOaWaZOLa6gWUQIwoMTYMWcT8GS261/BdfnSkYhhROUpASqGmkBC7HGE+S?=
 =?us-ascii?Q?cEF6RH1yXT5HiiI1l/ny8MP1Gp1whUOr92alKO2mfYon/g3X/Xx0+gVO0i99?=
 =?us-ascii?Q?NCh+p0tqoKwfnX+y6mhOyG6aYXHFTV5KHPma60twwii7H9kuJQHJRwUs8VAM?=
 =?us-ascii?Q?kRmd8kEOyd6MdJlp+ymydeYDmGTg14Hcf5HN98V0zJmcXfnTIhpaQvsJJKum?=
 =?us-ascii?Q?7Cl/o4HvcWrOJwZQibL29HcA0pT93TTGmGTsrObZnRRtM9j3SUv3sjVI6U50?=
 =?us-ascii?Q?NLH/0XG0lSzNzd975QjfK/T3HQxuGopzE4CvGzh5NjLjm+3dJPTEPEPQNKvH?=
 =?us-ascii?Q?UhBBJvP0oDsj0I97dasSTBgZwMcmJDiM7Eat48/Q8eFT8ud+kRCvvFq38iPR?=
 =?us-ascii?Q?/c25hkDtgzBzarFAkpIkh7N+Sxh8wOKqhDHR80ngsWr0i+YpsmLcPRfi8Y0/?=
 =?us-ascii?Q?f6gij7ryNvTi6YptTiC4r+a/y2PG+FOJ3TbsyWX+75VGBmW+2qcxrr8qgKdb?=
 =?us-ascii?Q?hK8UJQeXuwSMK5uqU5rmBHX+dpwM0dU5PanEAdoihiu2L+GZIfZNKGnD0NJL?=
 =?us-ascii?Q?sx8WHgksVvCxVCecNBJl5ACJ2qPPCqcJ/3tnt9fZoYCXbtGaA7bUn+9ctFxt?=
 =?us-ascii?Q?/5YukPpRBuQkdz+D1n1dJEbK5VbpDstz/d8HvuuTa5ED2ik67fV8gulwi9IH?=
 =?us-ascii?Q?57wZ1wmpVc4rxe72d/VvQxifbxgNXt9ba64ZBi6sCuWwx5lOYdHZSX6RSqnw?=
 =?us-ascii?Q?vrWQHJE9j0CT/ORFviTQ9bsnO99BdljnqBRAwAmDzaZCeRUBVeceKL8EaJ/M?=
 =?us-ascii?Q?gyuWB4/evyhXMKWMPWNgBJxEn+KRKFS2XZ7Py4L/tRpyOv/DOf83NNwdyzZW?=
 =?us-ascii?Q?0eNkKeykwbJFO4t7xEaDshQ0vsCTG+WPGHnVLxxEEX6xGqGVYf69IcI2P1/H?=
 =?us-ascii?Q?bbN/DylmF9WF7h7xvJVV+/bL2xhVz+ukf3pmqkT8x8Kn77e+QYCDTMiqwhRT?=
 =?us-ascii?Q?IWJ4ToTKTajgjkgNnde4n8quPvqivAsdhf8ECYmnrY4qe4uJZd5W/r0EQDFp?=
 =?us-ascii?Q?CcJmhHhKBqN5iu7+bLNypQR0MlcrBSM2UHqteekjQGKyhYJb9T5pvI77l4k5?=
 =?us-ascii?Q?2UVK1LXiAFm3X6lkPnmhtToBHFCbyyoADhM0W2eontDMZbGdz7LBARh/XU+h?=
 =?us-ascii?Q?6LCecI4cMn56xeQt7H06wRzRSmIMyNByliyUR+Dbo6RipFTv2+wCCHoRh05X?=
 =?us-ascii?Q?9evQAlfwxY6o0UjKISnVCsdUDLVB+7XAymCH1AQF2A2b+4bBmxv6A1zu2o+s?=
 =?us-ascii?Q?0+GWQqyYL1fWfgHLU8/X3b2RG5PutbtmjVASLD7y7b7VXbSyW04FSzUkAUp2?=
 =?us-ascii?Q?YIYls7/hSMhAQc+HiopQQWIARLDexxZqTdH5g8+JhWQAwLIsEPGxRu5rFW1W?=
 =?us-ascii?Q?Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1CC8230AA77D174F84F7BBC6101271D6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a58afb9e-1820-4dd7-eba0-08da8f1d0d06
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2022 09:00:16.1571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b/1Q4gfYgNJGl+qgq9f71dsbT5E8vP7I9hfwawalLZDf5w91PP0vN28JoSOVbU2EcznNpjjO5lKHrtCUM9ldpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7470
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 09:29:44AM +0200, Michael Walle wrote:
> > 1 (before vsc9959_tas_guard_bands_update): QSYS_PORT_MAX_SDU defaults t=
o
> >   1518, and at gigabit this introduces a static guard band (independent
> >   of packet sizes) of 12144 ns. But this is larger than the time window
> >   itself, of 10000 ns. So, the queue system never considers a frame wit=
h
> >   TC 7 as eligible for transmission, since the gate practically never
> >   opens, and these frames are forever stuck in the TX queues and hang
> >   the port.
>=20
> IIRC we deliberately ignored that problem back then, because we couldn't
> set the maxsdu.

I don't remember exactly why that is. It seems stupid to ignore a
condition that leads to the port hanging. I think part of the problem
was that I didn't have a test setup at the time the guard band patches
were proposed.

> > The solution is to modify vsc9959_tas_guard_bands_update() to take into
> > account that the static per-tc guard bands consume time out of our time
> > window too, not just packet transmission. The unknown which needs to be
> > determined is the max admissible frame size. Both the useful bit time
> > and the guard band size will depend on this unknown variable, so
> > dividing the available 10000 ns into 2 halves sounds like the ideal
> > strategy. In this case, we will program QSYS_QMAXSDU_CFG_7 with a
> > maximum frame length (and guard band size) of 605 octets (this includes
> > FCS but not IPG and preamble/SFD). With this value, everything of L2
> > size 601 (sans FCS) and higher is considered as oversized, and the guar=
d
> > band is low enough (605 + HSCH_MISC.FRM_ADJ, at 1Gbps =3D> 5000 ns) in
> > order to not disturb the scheduling of any frame smaller than L2 size
> > 601.
>=20
> So one drawback with this is that you limit the maxsdu to match a
> frame half of the gate open time, right?

Yes.

> The switch just schedule the *start* event of the frame. So even if
> the guard band takes 99% of the gate open time, it should be able
> to send a frame regardless of it's length during the first 1% of
> the period (and it doesn't limit the maxsdu by half). IIRC the guard
> band is exactly for that, that is that you don't know the frame
> length and you can still schedule the frame. I know of switches
> which don't use a guard band but know the exact length and the
> closing time of the queue and deduce by that if the frame can
> still be queued.
>=20
> Actually, I'd expect it to work after your vsc9959_tas_guard_bands_update=
.
> Hmm.
>=20
> To quote from you above:
> > min_gate_len[7] (10000 ns) - the guard band determined by
> > QSYS_QMAXSDU_CFG_7 (1230 octets * 8 ns per octet =3D=3D 9840 ns) is sma=
ller
> > than their transmit time.
>=20
> Are you sure this is the case? There should be 160ns time to
> schedule the start of the frame. Maybe the 160ns is just too
> small.

Yes, I'm absolutely sure that any packet gets dropped on egress with a
10 us window, and I can see from my explanation why that is not obvious.
The reason is because the guard band for tc 7 is not only determined by
QSYS_QMAXSDU_CFG_7, but also by adding the L1 overhead configured
through HSCH_MISC.FRM_ADJ (default 20 decimal).

So from the remaining 160 ns, we also lose 20 * 8 =3D 160 ns to the L1
overhead, and that's why the switch doesn't schedule anything.

In fact now I finally understand the private message that Xiaoliang sent
to me, where he said that he can make things work by making HSCH_MISC.FRM_A=
DJ
smaller than the default of 20. I initially didn't understand why you'd
want to do that.

The problem with HSCH_MISC.FRM_ADJ is that it's global to the switch,
and it's also used for some other shaper computations, so altering it is
not such a great idea.

But you (and Xiaoliang) do raise a valid point that the switch doesn't
need a full window size of open gate to schedule a full window size
worth of packet. So cutting the available window size in half is a bit
drastic. I'll think a bit more whether there is any smarter adjustment I
can do to ensure that any window, after trimming the extended static
guard band, still has 32 ns (IIRC, that's the minimum required) of time.
That should still ensure we don't have overruns. If you have any idea,
shoot.=
