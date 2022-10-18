Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B464B6028A7
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 11:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiJRJrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 05:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiJRJrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 05:47:02 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2067.outbound.protection.outlook.com [40.107.20.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97778B03F8;
        Tue, 18 Oct 2022 02:46:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4OvtVFyP7qTr7lFjLoHCzvfF9CgYfPC21hG69aon1m2g45P7wNd3GLN1zzDB1hkN4y5PXVMAmyGycMpu7Qf/OcHt9EPDAv7NSTmZuUqOJltjWJPMUbUWQnPKvdnM0KTagjydPelVGLkPPZz3oAE1NbtVGfS9c1R6G3N5pryAqdL0Uwr0ujkaj0RLEKbEGUjdePDoTAzP0bAwYhMM3k4TMbj77ZeedPLxXV4ucWeTWhR/2Axf1Z+sqE/yGcSRK4Ro98gGSdGDk+AJAvwuJ73B1ZD3wo4A/yhR1zePlNnl9zakAT1EK7eT3H4UP47550hKFoEsN37KjIxSonXEBKtZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1TEMMH4XlBKivPZfldGPyHRZtAUL83A087GUxgS0e4=;
 b=oYTSPHVfBeFHO28jQrT9RnlBMr9XJ4D4Reqe+qsN/aCLeG/4THvzzQaU0FDihn2gGEHGz8Ak4AK3/+21CVtJoPCtwBHdB3sRMeVtvYuUmN0Vd1t8fjOvM3KMv4tIGF9lkf7e0zsr5k387bNc5IYtr9i1IqrSnA49vIA/hWOR36zHlsLkkSR6+NogGphevmMr5R2q7jgIGNCDSWCougkZ0uaXB4yPtGzdp25hWI1AKxnZqhAwrOxKwkDdnT/8vj9ptNctD0UHUwmiM08lsMk1e5S87J16m78gcLeQWd8N1XVtclEsfT8KPHBCdurdp8yaKwMD+8IIx05Jkz5Xe0ayHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1TEMMH4XlBKivPZfldGPyHRZtAUL83A087GUxgS0e4=;
 b=YM4kbuisRuwpKttp3koE0Iu1WmEfzEGmvYImTatWUUNxtMl06Sv/R4IIo3psIyIbFYry432fX+/2x8NFXmS7g5crjp+Xk/v8dotfkAD2VEtHFW+N7dsJckNr2HGumdXeXIlpiFaAc7kFC8yQ2ShZFkbIFadkXL34rcKiyfEzjAc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6916.eurprd04.prod.outlook.com (2603:10a6:208:185::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 09:46:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5723.032; Tue, 18 Oct 2022
 09:46:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Pavel Machek <pavel@denx.de>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Topic: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and
 taprio_change are protected by rtnl_mutex
Thread-Index: AQHY3C2kHrdjzthEi0WraLEdXdCgp64T9AOAgAAAvIA=
Date:   Tue, 18 Oct 2022 09:46:54 +0000
Message-ID: <20221018094653.nt4sh67m2mjkcnkv@skbuf>
References: <20221009222129.1218277-1-sashal@kernel.org>
 <20221009222129.1218277-22-sashal@kernel.org>
 <20221018094415.GF1264@duo.ucw.cz>
In-Reply-To: <20221018094415.GF1264@duo.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AM0PR04MB6916:EE_
x-ms-office365-filtering-correlation-id: 94549622-e962-4645-d334-08dab0edb0b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qsuBIfB+NclIVkoHhRXylpYA1tW/yMfVvMR0GWqRuhKRUodi278p6SFbDxPrZCUCFfCBk+qNR5eZXCTbeKXZPZC6PFq/9mI+FffFonAHKn6hqX2aRCCMK8ZdPf16gOgdDtmjpzqElIKYKkFOZx2kTciHZsZMSBzwN5nB4ETanHufBplj0MeTttYi3vQM362tzCl/JjTy5irUUeFOBk11HEecdvRGLcKfOOEG8xYPSAAJDJvrZEmLIt5HNXCCO5mxnJ4dhyRrto5eaqcw7sAsgMcaCuBxxBvC3tcMUO8RnOF68THxvD7Hc1jNDbxCsEWzpD3A3ug5fh6BtQpnrIT+iUezWN6WMC8ArJs1jGy+AkQhQzGDi1J/WzIgXsA/Jw3Ma0Zaz1Q8UEShc7exTRyI2ygLEnmyJOEIDjNW1lePYtopPHggfmOG89CkTBg98/MchL6ClFkRMsVgNoSwGuNt+Y3HrplIv5wKbGI6n/XiJG6A/SU9r0Exoe6qbrT+OEDo+9wTSCugGyXWfSTSG1cAXI0/7FlktnPn7JcYjiVS9Owjij3qmCFruGMMvS7XUn+jW4tKA2Qrbw+QZlK6LQExsJJP1yTU5MXAwTgLhKHXB9B10CrKoy0oBl1hcyOAHvqAPBFmpanpSTIT5+00s6r1wnYEUycKcWNqT6o23ixVDh95mNULEImGqaSltkPU5Wr/u+mKQXSZJ6T/Wgjnv66eELbvkHNRqrp5mH+VC4Wvkvm+42zcE1C5XOv0GtgFAuEe6Ap1ibpq3MSVeZblUbgTZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199015)(71200400001)(54906003)(1076003)(6486002)(186003)(83380400001)(38070700005)(86362001)(38100700002)(5660300002)(4744005)(7416002)(122000001)(2906002)(44832011)(8676002)(64756008)(41300700001)(9686003)(478600001)(8936002)(6506007)(33716001)(316002)(4326008)(66556008)(66446008)(76116006)(66946007)(6512007)(91956017)(66476007)(26005)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xt/8fV1KFaUNSem3PCiOagFFxumBPN4UmJpO2HX4AtS5bYyR6iWNHOKiG33q?=
 =?us-ascii?Q?QP9INbzqT9pdLab09kphpFpm4bTXO/L25uuzb8+C+gejocml1RVTVrsVkCWY?=
 =?us-ascii?Q?DZaJEr5iV2YpzfKkFst5fGPctZnqYuVWKyDdQ1S+ZjZE10LXI+GKSelf9nkp?=
 =?us-ascii?Q?zGz5TEJygMr0s5GmjF4Ud2b6tBeXsmJqLPc65e21/z2cS1nNCJ/PAFBH4548?=
 =?us-ascii?Q?lD50xJActUUgL2STt6xF1cca+90DbvbvW8S/v3xT13FecL67qPhZk8wvSdlb?=
 =?us-ascii?Q?yWmTDaeeqOhFGZ8REgT1cqiMb3OkHWoVL6wALwePrnjCfr2I0GeLQfgG8jJs?=
 =?us-ascii?Q?FyNZaWGvNfsQfgS/Is+OkCXDG0GFtxTKAdW9BJraQTLr9MQ0kY29CP1eFXY4?=
 =?us-ascii?Q?HV4SSjabXLbt23mmg+PmLkTpmgfMoy30Lwe10/dqihjFHopUX8/W0W2q8aJw?=
 =?us-ascii?Q?TzoWx4oMu+o6fXgj5OoW1iC+xsc9VqPI2VCl+tqsDxP2j/K786wp5VuY58Uy?=
 =?us-ascii?Q?VLWrJPW0ZCxSM95A8E1dszYC9NyXYh27iiUiVZoSQrkDnX4tLV/LzFcTuq2/?=
 =?us-ascii?Q?frpCUaWsb5KuWWB/a0kHTWBR11KclZM2296JolvXXPa3QqcmT9Uj/GRf35qR?=
 =?us-ascii?Q?K/qmS09FJZ5YN6bw7PhJouDJ2xpu9tjXxaw7+yVVuHNrplhrONZ4wrLeQRfx?=
 =?us-ascii?Q?Lw4p7gS+NvyQ9gx8MY++eSfkts1N1zi6pl8LPEd90XGJP8pbw8rhm8lxRgxP?=
 =?us-ascii?Q?p0xhCG8K9QQfX9p9F5oIY7zUGubBxgxni1V57kPTxVcbdFAjdMmeGG5zxCmp?=
 =?us-ascii?Q?DjY2rSxHU9RjF6Eb4HVAkwGUsojbDSB2gbg0yWFRLCBxqTIGp3LeRE1UcW8A?=
 =?us-ascii?Q?q9RZrC+uUVuE1F+IEoXNLJCxEAkjJzNUWT2om19JPYZ0L/AESKkdr9GrajVe?=
 =?us-ascii?Q?0UeJRqaBGUOROi4e+aAIed7NP5PfeRKiGx2dMOzIjl0sdE98ok09vbhuWvQ5?=
 =?us-ascii?Q?EwS4K3NcjEYpBicq7faTxPVS9LL1IChTaAbFoMa/ff8wvjM+RIGTPA/Xr6lA?=
 =?us-ascii?Q?uMvm01nn6KRYWen1IxXDZbzix07Id7ntimcUobhv0WXJBBafmjkEIUPrpAB/?=
 =?us-ascii?Q?tDTPE5Vd1zmHTL6dR/5hNKerfojMDcWJySc3UptXP6v4KwAqYPPv8ywGoOny?=
 =?us-ascii?Q?CrsZSqh+Gc6PKLSAPzzMq78eiqcZDU28AGDlAf8Wm99R+BUwfeFcmxmhbAdO?=
 =?us-ascii?Q?MjUcyxcRF7W4PeO4nYFWQFsaHjgruFQyQqNPEpm75eh/M+9rypFdlfJFuAau?=
 =?us-ascii?Q?JDhNmF/idbjtqY07k5Aukr7XFq6/GvQdIUYE+UIweNHy3frdiUOpRxavJVoT?=
 =?us-ascii?Q?0pQn+JTH+2I3afYMelGfJZeIyZYjbZvahBCsyKjQPccudWcYOVQx5YqvgEDA?=
 =?us-ascii?Q?/oz2Jv4s9cuaC+QwWs5GnqSz+JQxprfOPaGIqxEKBiQ8sP0l42SqYNCQzloq?=
 =?us-ascii?Q?ioBxk4yOxjcOnxyG7MvDVI1OCNypcN6xA2LMUGSxHSo54uIJx9HFd4lsfdsJ?=
 =?us-ascii?Q?LTISHqUgxpwteJ43h7j+bXCux7SHGKuaEVAyE2SIW8FOqKSQ6YCF5K04+XKh?=
 =?us-ascii?Q?/A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2707CCD9336C741BAF7B59BB64698B1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94549622-e962-4645-d334-08dab0edb0b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 09:46:54.4190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0R9lZBYG7iBIPk9kyV3vzicP6w91pBqi3jRFwSdic6dnvq2MhgljwUX4y2PsYxQgUWppAifzwOgEaI32Up/Q5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6916
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 11:44:15AM +0200, Pavel Machek wrote:
> Hi!
>=20
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > [ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]
> >=20
> > Since the writer-side lock is taken here, we do not need to open an RCU
> > read-side critical section, instead we can use rtnl_dereference() to
> > tell lockdep we are serialized with concurrent writes.
>=20
> This is cleanup, not a bugfix. We should not have it in 5.10.

Agreed, looks like I missed this one when replying to Sasha for all the oth=
ers.=
