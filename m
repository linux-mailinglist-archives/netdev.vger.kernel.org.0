Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3C5BD7C3
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 01:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiISXCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 19:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiISXCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 19:02:18 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6284243E4E
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 16:02:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLgQl5RHUzOrwxcLIWUhesuE229p/RrWCSm/kQTPGGimBRBUFa5x5UIn+oWGtCQaHf/B7aRcUfah/cKiE8T2Wyp9M+4S5QIhIHo+Y6KbhroAf7knOlb4bI9fTawwahsulwFi7cTEh/jdw8hopVGWgk786+2W7y0l64tz609B7L21gCVqaT6rz0lzgAg1wK7s4y/7PZkSaqVCeS6Q9fHtwGpZT00hl9xAB9HT0sRbB6K/kFmyqtpz/aWrn7ArK08JxavStfwYsLXeAA42wTy0ZR0rrN0CFaS23lze5OO3qtUSMkl6H8gF0RYFu9t4ytZoNKVeIqUME+Nslbzx08pucg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ikfsn3NMO/ymVB1UOU2VBWbwQ4bMbr9lGuDSscUeRlo=;
 b=AkFaBWu/wXEtM69IsUQtAxCMV6AQFNtElKkx92wYSZM54atITgrnj8fPDiXqVN2MuYFvwrCPKLxpRFWZ740tKkHleWHajDrtjkAI4UrwQZhxv8/jttRPTqu7CH3ltbxC0jJ6SDovhU2APjpT8Oziw2i/+bstK4Ysja/IVik5WB13+NFV7tqelnu+inOzHXBWQBGn43dyqqDiOGrGAyl+8CaNG48ZhiFgMYRDjCpt7JMCqeCPKhQgxv2tlws8AYYVgBQIj4PTH/2I9sIsxNv2eNARhLFBhX40Xq86COkoDrQew5lgg33ZePzX37HiOkDB05tT/9El+/pRhN6VLlNf5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ikfsn3NMO/ymVB1UOU2VBWbwQ4bMbr9lGuDSscUeRlo=;
 b=poctnTS7JZJY4B03BnVRJEzSew6aOLIfl7lrDPbAf/dKNq40w3bGsLVU2itUB4dlC7OyBYBRRius6qG8aDeNqy67qEJSnuDJCr2AFVs5RQ94BugKuVRxSvGlcgVw8PgtGqgiY9Op4vVQuKHpjIXe0PQNeHOwzVS+CaLHy+Vi2Mg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7390.eurprd04.prod.outlook.com (2603:10a6:800:1aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Mon, 19 Sep
 2022 23:02:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Mon, 19 Sep 2022
 23:02:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "mattias.forsblad@gmail.com" <mattias.forsblad@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [PATCH rfc v0 4/9] net: dsa: qca8k: dsa_inband_request: More
 normal return values
Thread-Topic: [PATCH rfc v0 4/9] net: dsa: qca8k: dsa_inband_request: More
 normal return values
Thread-Index: AQHYzHXUsyedrDPnEEqlmyAuzhGWP63nXsmA
Date:   Mon, 19 Sep 2022 23:02:14 +0000
Message-ID: <20220919230213.yize724zrpiaipgu@skbuf>
References: <20220919110847.744712-3-mattias.forsblad@gmail.com>
 <20220919221853.4095491-1-andrew@lunn.ch>
 <20220919221853.4095491-5-andrew@lunn.ch>
In-Reply-To: <20220919221853.4095491-5-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|VE1PR04MB7390:EE_
x-ms-office365-filtering-correlation-id: a4df9504-6f1a-4827-2f98-08da9a92fe19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HLtRvlAchGFez2w1NEc8i6dPieRZDsREozoBTxXoXjJ+JK1yCNEttdezO8aHyJLOxCsAc0iGvfSl1zU2DN5ePkSmYMb3U77hlcrqDUnvlLmHWRgUHFOhNPHVM3LVexTwol394pMESz99cTmtSaQOpHZoNG25awy/7g43YT1s1CzUBi8HhHXzWFBLalnkgpCuboewWSvTkQjk9dGG+fUQh2IpH4G+tQCJLwWJzTUnh4Hkfqm2xF5PfByMakYc5z6bTouufthrdSrzF71bCmecOI7TB8SI3zCST6chlqzfuoiV6gaMCYs0FTZBX9g+qeUR2cXaXiQRfA4zRpDppwzhBm/GpTtD6WpVDkP4S8VBJw3XtqNdeOVRS6Xqw1oFIcu+V23ev7Wq6gNNvxtqtlf/896I8m920em5Yru39n2ztYUBdy9C0fo/tQDN+yhMUas9Zjo31KAO471h9fpfk/BjEdPiPjYqTjhG4fmwfnv94i/aLK1PpvUQKksBskT8EBy0PPi59Ws/KBXFgQU+xImi56VGN+jeDyZZCFNx+fN5unIlsuOTXDiWAMqjua2Wc0XBEyHjzow60LUCCydz8HJH2o3uEe+prLRFO54GDmfBtU+0gbFRkRjtxTm5yA8hTZ0v3dleFwTj7Zp/UAJjymgoHZi+Vs2JNWxsWqZreI1jnSEbhU1+twrNHxOfbwnnY5klHrJ12CYL63fVU5zBmUTKNeH8X5r9UqPaQtzyIXSrOpRsW573YqZkCNNk3Z3UX3TOfSpCzxlBfHYGCgh0BYDrsTUXTVHIpKcQJH/G6RwMZJs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199015)(66476007)(76116006)(5660300002)(66446008)(66946007)(66556008)(8676002)(4326008)(64756008)(54906003)(91956017)(86362001)(6916009)(316002)(8936002)(122000001)(38100700002)(83380400001)(41300700001)(6486002)(6506007)(71200400001)(478600001)(186003)(1076003)(9686003)(26005)(6512007)(38070700005)(33716001)(4744005)(2906002)(44832011)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xEOSDCy0xCrIRf9mh10JpflsSy+Bs0qfKfdM5tlfqUJ4/K6UMi3i+YyMUjfW?=
 =?us-ascii?Q?sRu6lLyAtihsN501PfsEgWeVBzbUNJze5n+lhptIbnr9HUf0yaePyuu7krbg?=
 =?us-ascii?Q?+/PkZk//jUC3ODcYMTNK+XOS59ux68Xp1iKgvrZpDsfmVxEyhnv3lYdT4nss?=
 =?us-ascii?Q?ni1VidlPiV9ibXSEmozgOzzqgN9svImPmgd/PRfe4dszjMXH7FyHOFyJmI44?=
 =?us-ascii?Q?lv46cyPH+IU9JguuBiKVju4DYiXnsuhoS5/fM10u3Cl5gCU2oeTgoP5KSINV?=
 =?us-ascii?Q?W6aaH37Kxun+dhwgK4DUOlDjn9A5vgmlqHxABl73DgPVey/w6/G3BCBDUOTe?=
 =?us-ascii?Q?qWiAnwQaELBG6y0BjNNV9fJ2kR8MaDzS2xH0/w2xr8bLd/y6sUmEJt2yn1xY?=
 =?us-ascii?Q?HSGsBYFZOCxQSfVyvY1Lm1jS9TACHre2XHsLw0RG5SP6LqQoHbzzFy+bECj1?=
 =?us-ascii?Q?W3YtD025l+exQaKgHVejL8YK1TiT/mQWNDWyUtfqcvdIC8dCpt2WoNGQ4wAj?=
 =?us-ascii?Q?Ga9HMpz9gCSpfDSe5F3sUSGRDvx1hZ9HilQURhzaUXb/0AiL3pIckA3cd6xm?=
 =?us-ascii?Q?4zXqt+nM6M93Xel28RxOzuSbJj1uOtc7j8PR+OJnIAYyUyuXO5Xka/nEoukd?=
 =?us-ascii?Q?vUVcJ8/qOmJ0FiXJ69P2Y7xCyjcOgNCJoeZXNSJ26t6iyj+oBjMwPtunATT9?=
 =?us-ascii?Q?ax/5XY7zu1/LbxKB14dwikEzwOgYG3UzlGBsITsxsnwYRSIeWrwSrFgN8s0S?=
 =?us-ascii?Q?bYfumMlmDkU8UZMZWY8J5n5YkL7lbgTirg2zTM1E0G3tWL1nfY6gvpScdRQA?=
 =?us-ascii?Q?teVklp5ipN5s+4LVFfdKzq2SHQKdlTPj1eg13UChoVFQoM9l2zcogCEl8Tx5?=
 =?us-ascii?Q?nY2w3NJdhKzTKIItRg2DucyeHpbDTmlMfZ1aB3P0gFVp1BkKQCFQPHqlmTfb?=
 =?us-ascii?Q?smyVyBwffVPpA+5kp+lR3xaOf1O5Amcy2i+q6n9mYs1Vgod8Qkxsw3KUI3Gw?=
 =?us-ascii?Q?c5Stej59LgnI94Iem8X3tN3LNyaEk1j/iFYGeUEA98WvUuYdRhDoI6iAeNfn?=
 =?us-ascii?Q?SFW1xcQuKQCz+CniDptK2TQK7HXfA3w9XgudjgGP7FOonhdNT/bOW3x6+DoY?=
 =?us-ascii?Q?KHgecCqPXmXxC5rgeu1EnGFYPuh6M7ZZfhHMCw62tT7G3A1D0RhXNXuyg3DJ?=
 =?us-ascii?Q?Ye88gw8rtxUHIYpdYJ7g4SSqITawvTXmnGxK8vbFyD1DQucWs7Eh3pbJqll0?=
 =?us-ascii?Q?zJRU5D5FOy7z4/IFO7rEikveiPBziMUvHye+IC6WpZckrMkPoA8cGtSPfCM9?=
 =?us-ascii?Q?ZHzAy9af8W1ES8e51nzmInRGI1/6Avf65rTWEuKrKinIF1IZrtQX47VuZ7ok?=
 =?us-ascii?Q?vEWgndsvkXKdxh0CvfL/gcnIuey33y540ZIlTBwVxmcg6LRt83r/P2EQ4igj?=
 =?us-ascii?Q?kxQjGRflxh5iILlPXOY8j01L5X/Pzctneu1cXoFRAx1qqj8IfeQIQGHeyz30?=
 =?us-ascii?Q?aoCmf/rlI8un/oHGO4tON0IWUQcFuWE/kRLEZZidcZZLRPRuq8XXDsvIGWZ1?=
 =?us-ascii?Q?I6Ct7awOzSTtCQUDoS64Y6fu8kAemiVujJ1KIYtTrclNax/vyxKY9+2jj/ac?=
 =?us-ascii?Q?iQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <334BEAEE19EDA44BAD0B63F8C3F5651F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4df9504-6f1a-4827-2f98-08da9a92fe19
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2022 23:02:14.5156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hgKIsREuhY5Mx6dal1gsWntX9in7HdY4UiJi6kMznVX07CeDOrMxCRNAnbclYXLJY5ZCL9oHep5LfCSxElUMCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7390
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 12:18:48AM +0200, Andrew Lunn wrote:
> wait_for_completion_timeout() has unusual return values.  It can
> return negative error conditions. If it times out, it returns 0, and
> on success it returns the number of remaining jiffies for the timeout.

The one that also returns negative errors is wait_for_completion_interrupti=
ble()
(and its variants).  In my experience the interruptible version is also
a huge foot gun, since user space can kill the process waiting for the
RMU response, and the RMU response can still come afterwards, while no
one is waiting for it.  The noninterruptible wait that we use here
really returns an unsigned long, so no negatives.=
