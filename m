Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A8B56B1D8
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237234AbiGHEs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237226AbiGHEs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:48:27 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46932B69;
        Thu,  7 Jul 2022 21:48:26 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2681sYHK030159;
        Thu, 7 Jul 2022 21:48:14 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h6bay8f0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:48:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8o0hHKB8+T51DcY7AfYUjVn3DILY2rYksiWrF1C85kLe5CQg9XV3WHGC8x2FfqTFz6AOu9Z48BN63ruby5TcGWiAKGFxOYJujWP6rVno0/DwbyY+traXgL1KFQD8+uiPkx5HSgdlkNF3TVROX/B0fRz6vzRiCWy75boO/h9wMwpBjKyp+2wdopDqFJ4mCFlZNxuXagS78pkN0nsguwFKDB4P1qc0qhlwnMbxj2vpFLCaCNJq96DGVV728MOj7ryW9TAmJgzFIFMZupiRkbzoYPfvZUY5chlWoYwYjb8P4kd0mrmTDNN4VM4Qq33x6eabEB6B5Qlb9ojVVBuQVa2Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsYAEp7NlvRL+zDzMrlN8Qf2blx6XrN13MMs/tSCfdE=;
 b=GQ6I7HgC66ygfeYu5pkEI88gsCkcocCRHZWlO1I0rRnAO5PSEtw8A5DPsjzouit9VSG+WQEc+VXdPbUmQn68lNSZuFZ2FZiGVgYbu+4Ex4mmX2jWbFUkx096RRmp9zYku2tVXXtEWrglQruD2btjXqiLdWLTvh7YOsku/EvNg55qWVhlrtP6kZW14WCaodm2nsbckmTXvdD6pnb1NQ3sw4MnoyRy1/nl0xtF27tuWUMVY7rjuYDiAYoc2mgfGcLvOfFv5LXV9+GwBMV+iqSPTdnbk4/yXUgBv/bVRX/QQ2odceUytKWVYQxvSPx/ez6910yRdq6p5KBThAc1t3wxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsYAEp7NlvRL+zDzMrlN8Qf2blx6XrN13MMs/tSCfdE=;
 b=XcVjj5Xs1X6HzS5DbDqU4QlrSAezhtrDZI8bxknKHYynBzHTsqW9usnEKM7OgA3Bw0jgz3jED6l3TLimX3aQKhVzJ08mjWIyldwXxvQT/2WedswQhU0vk3fcov9lenqhi4n/LNtsUpS3RsNjmeb6lG8xclBs/e9sHS9AzPVHiAY=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by BN6PR18MB1202.namprd18.prod.outlook.com
 (2603:10b6:404:e6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 04:48:12 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::b489:f25f:d89c:ff0a]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::b489:f25f:d89c:ff0a%7]) with mapi id 15.20.5417.020; Fri, 8 Jul 2022
 04:48:12 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [EXT] Re: [net-next PATCH V3 02/12] octeontx2-af: Exact match
 support
Thread-Topic: [EXT] Re: [net-next PATCH V3 02/12] octeontx2-af: Exact match
 support
Thread-Index: AQHYkdQSs/lZkTgqfEu+juq6npVyAK1zpoSAgABA1kA=
Date:   Fri, 8 Jul 2022 04:48:12 +0000
Message-ID: <MWHPR1801MB19186717B8C966ED8B5F9928D3829@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20220707073353.2752279-1-rkannoth@marvell.com>
        <20220707073353.2752279-3-rkannoth@marvell.com>
 <20220707175307.4e83ad48@kernel.org>
In-Reply-To: <20220707175307.4e83ad48@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d1ea2eb-b273-4543-1b60-08da609d102a
x-ms-traffictypediagnostic: BN6PR18MB1202:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rxJpoq46SJWPmGF+4DPDSMYh9TU5qm/COL2eRp5qZuM0Uf+lX5a1NVjjgvx90stHLe+xgmTGPRhjd+oe7Sf83DQZfYy61s7yaAtVkhUHZ6IxmvRzeyTck1VLS+/lqHZ1I/+OY3Hoha5m2z93LoZS6IhbeiUIW6fVjag45T5gmpczreiPauqp3cpoENemOqg+ekpC78vjHvn8txzEpx5ztz1DvUhGYOCdObwp9LoL3Q1K4TzHEjb+SGfKIFO22wL90LXkYlk1rMg8/dPwJX38dUl6q3YuzymwxR7AHwF7aJod8yZHURKlEFpArl7jw+Hz/NekdAMgDbCd9ZwPyzsG7GSxGbFJomOxbUjyhuYxNsh/lUcjiK8zYKIaj28MrxUgi64/0c3kx/scWeNlKD9n5xqzDMfO7VPEBEr5obkojIykDx0nXRc4KZDCMnE8ALVaoMCJhULw5wG2UetVgvBTKDT1b80vB+816O+LCD6pXw3Cmp2tY56hg61tn6NLe+hP1cGHoGv2k/kLIJSzCQoh8s2abC96+2eVub0VqnIzOoyUajle/nakpV969f2cNIrT4gn9kJKpIcS2JFpoXTqHcpgxDguHMey9ib3KzwwIAK6eBEMOO4GTfRmOvrIhqeqzDVMCTZ6jwMtCLfSpqttbA6wRtDSaFD39QtcNnsc2BBZ0uop1QO1RGy5oBvRCZuIbrIbpUvky9PCq+EOKBP+56VShct2HzbIK1TKq9dzlxShGamQTHlQqa8tlCSBG0YJIk0hd2Vb/l0G1ofHwEOtek/yOtzvntrJHkiRogGi0nZ48s07OU+JNgmHbEXDSzZq4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(38100700002)(122000001)(83380400001)(66446008)(55016003)(186003)(64756008)(66556008)(8676002)(76116006)(66476007)(54906003)(66946007)(4326008)(316002)(71200400001)(6916009)(33656002)(26005)(5660300002)(52536014)(86362001)(2906002)(53546011)(478600001)(41300700001)(6506007)(7696005)(9686003)(8936002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xxKadWM3rWIoo1XgvwCbUADgpyRC4Qo1RwLKN1LR6jQqyULuGu3zAqrMj2qz?=
 =?us-ascii?Q?t7LUc19K0QLgDvs2WOs1YQJkPJfD8/1GUNyVyHthppAXp9VxZvHdXG28dA3C?=
 =?us-ascii?Q?ySsMFhd/dyXmSv4c0v64PxiugXojBern57BLiOOtj56Px1P3bujE01jEZ5Dh?=
 =?us-ascii?Q?eqdqhW/vx79r7ChMq2aRhezYL44mg0RqykSXnjKFcOueqOi9l7vtrIYqhrpl?=
 =?us-ascii?Q?7Yi47hwz3hLTlXXfPSvfwQuNs4wxf0w6Cg8GJgg8ZK7AbsbfnRc4HMZd22OM?=
 =?us-ascii?Q?A1UdTC8GNHVN26ueXQZA4IAORXN1YmUDEDucyZ8vw4GH6iUpn83o4sT0BjuN?=
 =?us-ascii?Q?MCvejvr6v/6vgCk9kXE8eT+h9SB2Q95/ymw3RRhRnW4iHKrHoOJ4FP4fuwWB?=
 =?us-ascii?Q?moaraedbJr9eOa3T/dLAQ/SJ3FoP23+5ciSNXHNmbr7BCbTOFDPlHwWHcFNf?=
 =?us-ascii?Q?c6x+vZty496rzEIsFJMAFOKyhqJrIHZ6K0oa9yABXs8sC9LhmDknyEONgzh+?=
 =?us-ascii?Q?0F8JkZTUfXWYmp0CTsWm20aMBot50zOo9Fefgw3X8iXtNkMm1x1u1dPeQ1dU?=
 =?us-ascii?Q?BZIhO2DJFosppTsLS3GyiN7/igrgpplzyw1iHllfIx+/kuTU+d7PqbGmtDgM?=
 =?us-ascii?Q?B6CxWAlS3B+LGEvwT5P8ljoeM8z0kJS5mEfhFVq7d5wRYst+stTkncTJbLJL?=
 =?us-ascii?Q?GqMRqidRzThs0QU91k/JjnlnBmOVgJ56Kf4DTtISlbtNM1aCiq9BvrQa+47w?=
 =?us-ascii?Q?eem0mgp9FnGTbbVJPKsvG/XXso/4lFSFGpFU/ibqnTFHWmArlgr+S6cRPSZe?=
 =?us-ascii?Q?TiRw2HhAKG4srpXv/WGuI8wf8mSGEWl1d/+Kx0AcJ9RNoPEpqSSkuiTPhkrg?=
 =?us-ascii?Q?gxR7HucHZ1ZQVHeuAyRK8j5Yd0mhF+ns6vf5F6vAkKikBtEB0XtwRQ0/8dPJ?=
 =?us-ascii?Q?4ypfHX8zuSjiTapiHwtyg8kUQetZiMSc1hEGFOZfMxRGXz0wJXuDm1WIxYOH?=
 =?us-ascii?Q?nvUJYHdDTdptHfHUJra5bTpm1yysqHse5LJiCsWM1NSUVQi5V2gdq4d3PV3Y?=
 =?us-ascii?Q?zOIMSkll0PxQMO1OS58HiUUvhNBADozji1SZON6U+Nd/dt6aOejc0+3WmDiR?=
 =?us-ascii?Q?a9PhmBnLNzm3DV0URetGlCjmyeT1JjTwvnP5MAFuNi2UCG9vTtd1nKQB0nUq?=
 =?us-ascii?Q?nXUlBxUaACH8ax2Z0Ce6fs+LxTvXLHPHJhBPe0G8QXZEbFN3i1S1WTAoMK8h?=
 =?us-ascii?Q?OGEq1dhjfuD/1XFJLGYZDa3pStuakenIilSUQPEUyn9Hur9B3kT8yL73q3zt?=
 =?us-ascii?Q?CLFboM5nuTxN/AEm6avA2e46XufB80s2515R5I4JvpCSMwUncuPc1RRVShgW?=
 =?us-ascii?Q?6M8Td0koVK4S7qiqo5dGd556HmuTWTFyp2JBNZ0ZA8fmpMccFxCRWMUmVZmx?=
 =?us-ascii?Q?SNwo2M+VmzBB3NtMvDmxBdJWlfNM1/60kuEmrOM8O4OcpNIjTYW4JQDckh6N?=
 =?us-ascii?Q?b9BWGhuc74RXBpocwnbBOmCS7nz6+MlSkSG0sPDMaM2/x3juyUt787jfeY2D?=
 =?us-ascii?Q?OTJBTiValvvEiz2c1Vcd3c/R4EkM4ytUTG4Kdtek?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1ea2eb-b273-4543-1b60-08da609d102a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 04:48:12.3360
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sOuqU/3y9d4xP8hnZN1nhiW5QosMdSyHALZdYSlztXs9ijGNf2euF5roUm7/EeRpqAkoQduXksnn69T03rDcpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1202
X-Proofpoint-GUID: eYcZf4tLMFHgrJJgiVIjkffdG5KPyUZp
X-Proofpoint-ORIG-GUID: eYcZf4tLMFHgrJJgiVIjkffdG5KPyUZp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_04,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Friday, July 8, 2022 6:23 AM
To: Ratheesh Kannoth <rkannoth@marvell.com>
Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri Gou=
tham <sgoutham@marvell.com>; davem@davemloft.net; edumazet@google.com; pabe=
ni@redhat.com
Subject: [EXT] Re: [net-next PATCH V3 02/12] octeontx2-af: Exact match supp=
ort

External Email

----------------------------------------------------------------------
On Thu, 7 Jul 2022 13:03:43 +0530 Ratheesh Kannoth wrote:
> CN10KB silicon has support for exact match table. This table can be=20
> used to match maimum 64 bit value of KPU parsed output.
> Hit/non hit in exact match table can be used as a KEX key to NPC mcam.
>=20
> This patch makes use of Exact match table to increase number of DMAC=20
> filters supported. NPC  mcam is no more need for each of these DMAC=20
> entries as will be populated in Exact match table.
>=20
> This patch implements following
>=20
> 1. Initialization of exact match table only for CN10KB.
> 2. Add/del/update interface function for exact match table.
>=20
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>

>Build with C=3D1 (i.e. with the sparse checker) we get:

>drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:558:21: warning: =
dubious: x & !y

>could you figure out which one it is and if it can be muted?

Fixed.  Posted new patch. Thanks a lot for pointing it out.

-Ratheesh =20

