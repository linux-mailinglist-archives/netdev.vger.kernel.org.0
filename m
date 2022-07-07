Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377EB569998
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiGGE5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234837AbiGGE5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:57:03 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215B131208;
        Wed,  6 Jul 2022 21:57:02 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2674lavi028566;
        Wed, 6 Jul 2022 21:56:47 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h56wt49k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 21:56:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLcOWZmN8Cw9ISLgVPN0/LCNjQqQN7HPaVtKa2O8MU9DuZoX2qV2ZxfFaUPlVsXmWrlq7PwLN3PxADnOr1rHdhkGrAxz5pKl0p+gK0nHJ/u88jUNft5vCAEZOT5NO1MrtZ4MzeJY0m+q4d0Sb8Rbmi1R6shM40TkXuOIXmJpOu5rNAOO4RlvuWN+zKIX31kVX1NbcKcdPgTs2xXggk2xpFsqqZS+wAtQR+aG/N2FB1jLtEN1ZWWylHCmfHN3qsjV1tuPu+mEZQ9YHlI9gRjFon1XcosWc3Dnrkryz9/KM9pvm+h+VBr6UgZFFlYb3eD8vEMgbh9FQ7DeMJdZQzLV/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dz1SyBSXTPnV0R/bXzulYzMAvAY6nEf5D3Vndh9SThk=;
 b=eDbgf5eSqr9lgxRq76gvaFVnYLCM7+TvLA0BKnedHxCRuxdVrf5/NbTLo0drdCyaI9IsOZ7VRa1V8wxptDVUek8H60cjhzcwStteFFI3zwi6GeSzTCb932YXTkg3dU4ZuMXE+OvjxF81/t/rgjRzryb06JqDpkZF4+pu9tFIl8eSdDrKpoKt49rImE9FKCO6oCy92vxLz3R5hGl8OaSQTKlJKLqiM0Fr34g17+SH7RtcP6bLreNwIdWLHXO5yCoCV2fnNwRFBr2G4IycBDe9w5q1dixjOeie+nowh9mHNPKD6pk7lK+92RFAx4lKYk1cICqJGEyG2pVsGdi4OFDsSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dz1SyBSXTPnV0R/bXzulYzMAvAY6nEf5D3Vndh9SThk=;
 b=Qs98m7bI5F+yIlXV9WUr13vOfHxSKDOGetyqkN6vGRoiTISiO25IVaEyZSBP0jHuvbKVlqv4M6JtWggw9Kq+7ign7fBoaVwzK4z/8HGT+cSVbqczyZUaAA0p2JSJKuZX/j9Nx4pMswCZ1HowkvAhA6cu4bAwfb1rErU8RnpW6C0=
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 (2603:10b6:301:68::33) by DM6PR18MB3018.namprd18.prod.outlook.com
 (2603:10b6:5:185::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.22; Thu, 7 Jul
 2022 04:56:44 +0000
Received: from MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::25:41d7:9bd1:6237]) by MWHPR1801MB1918.namprd18.prod.outlook.com
 ([fe80::25:41d7:9bd1:6237%6]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 04:56:44 +0000
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: RE: [EXT] linux-next: build failure after merge of the net-next tree
Thread-Topic: [EXT] linux-next: build failure after merge of the net-next tree
Thread-Index: AQHYkaGe4dvSjaVKvEi9nQu4UimIMa1yV1qw
Date:   Thu, 7 Jul 2022 04:56:44 +0000
Message-ID: <MWHPR1801MB19186E4EB125181807ECDB5CD3839@MWHPR1801MB1918.namprd18.prod.outlook.com>
References: <20220707110015.3549e789@canb.auug.org.au>
In-Reply-To: <20220707110015.3549e789@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3aa48940-8141-4577-c89a-08da5fd516f6
x-ms-traffictypediagnostic: DM6PR18MB3018:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Blt4B8d6Dj7MSQP81o9YxKag7diPQqS8aZNQqvn/5qancxtKh7VUXhuWF29VMF5hItLJxgy7HdJoKq2mz/NbBQbimzBGjHejjpZAl7m1NQH+uQUsAqlumi7xrTYo7Rags7PVincm3FsPloGbNCFlbqrp5agV81OBs9zdOTyc37Z42StKhUy4Hzk1ekIxX4Pn2kiCtNlTdNQUOUNNGn1C+YyH6WPRtl9Q7aNIvYZ5eqrdc99jhfNjELwomCu79C+NaIRl74p0p/+EcqRLakq8eF4nBYbB0XudYodl7igCWVoeVAQ8XAw6zAZF457z45RVRX+p1n18m2Gze7nQNDbMJwA77j1RvXNJcQo5xBRCjEjOBumB5+Ia0egRGZCJGZFNa0tlYdGQbDiQ2/lWr8EkzuqKv+wiWSdHJimbI8Dg9nWxXNqda++5ujhcTW+w4r2XPmVtfixVWqR1IP9AnxMcmi1ikAR8Aos+ImkdKib0zNS4GhQYqQTDF5kmcCVrn+eScwL/HuMAuanyZBATzQKYxhubSpY7XmBYDFryrUo4+jN92o3ycpmS2vdN/TLzFYTSzxxEl3SM2bUXRL2v+eqQil2AmgYlO7t4UISFhAOnXJnIqr+Q2/yo8VkMDvJgJ4WRopZphBZK4kGt/xd9HDpRW7VTsJMlpUZWO5tlInbKnhlRMBxDPL3h6ViKy+ToiUwoEKuTMgH0Vl0aVbgTtCfs+/uylZReE6uI6HyW4nNffwq/31/uFyZrU8uuQGot1T0Ru1Tm1GW3uuuGGEHWFf58bcWec7LH8HPAPMG4EgPeXPBr8un9lYCeadf2YLZSlcZB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1801MB1918.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(52536014)(7696005)(6506007)(8676002)(66946007)(66476007)(64756008)(76116006)(186003)(5660300002)(38100700002)(9686003)(55016003)(86362001)(66446008)(66556008)(4326008)(26005)(53546011)(38070700005)(478600001)(8936002)(122000001)(2906002)(71200400001)(41300700001)(316002)(83380400001)(54906003)(110136005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IMNyAIb+y9ZWciZt1QNFdqc2lRwCc5OqoUc0XjH8Dpz9uqDMxML00JR7jriO?=
 =?us-ascii?Q?fHpwzm/qzJXFKHtUwfd0L1E5RJTwLwcxlQ82RtEHD6XVJ69i7uXHtKSzlkwe?=
 =?us-ascii?Q?V0nzeEImK6P4zx1J/V4g9PKvXTYwhDmoeyeSHJ20SDdTviuqYgl/yGWHUP35?=
 =?us-ascii?Q?BDnJyRmv/uWPrZpO3bOQemWyQVCJOkNp44ZQuygzSkuj2rgjAg5bNJTlqxcP?=
 =?us-ascii?Q?dNn87dgmzIJez2YeRYBSKPMRKZxrZudCKsvtKZrTIivw1+aNYYbjPDvqxiXF?=
 =?us-ascii?Q?V/tXxygIdmhlExIZP0Dah+yFBVIJA8DT14zhl7regOD5jB5LX2Mu7OIM5zn0?=
 =?us-ascii?Q?3/jmzXIB+ZU4DHTyUzaieGOR+6+O0yoUk8w2kX9ai86WDTxfjOXkoY2MR9se?=
 =?us-ascii?Q?0NjBzjzJOHZ3SdisDitcxd/GIvvN28SQ41+/CXNkF7q2/tLcIpqbnhaR9ODv?=
 =?us-ascii?Q?pqutsCfuE2W0NpkdTOGyDU5ukYuVWc5E6nmT4rnglSQytHOBejyWzGxCYlG2?=
 =?us-ascii?Q?VYx9i55eYmr8ALBSg1esLwN/Ea9zhRZqssHMsOb7XvMM/GbU3Wfa3T8rQ8Zf?=
 =?us-ascii?Q?TyeMGlwyWhk6xDDUpCtLlgGpaeaA9Oe7DT2PGucqftbAZOOPiCEBdtzfbpWk?=
 =?us-ascii?Q?sW8JuBSCA3k9dFEFQ+dYq0OapGmH17ML17bA3whsBZRTA1DpnBExSssfchBl?=
 =?us-ascii?Q?BWw4YihMVKdz8f1ILkxt4KNb/9qwM4jmUTjy7hNG1F00pGTkM+NpdGi+jtLv?=
 =?us-ascii?Q?TrWdhfVdAoHmRsbgupJFaQXp/APfhe2PrHUftgN6+DJ2sBPb7qEDhnIfKe3o?=
 =?us-ascii?Q?FCOdwO5ecnZs3fNgXELrL9yXZwf1T2XzErKPqXBHL1uj1UggsRlRbYvQvksy?=
 =?us-ascii?Q?UE/+YOZeKgTtW9/BLAYIRDVJDQxNqKhD8cI5vsSd6M6M+zOfEGVwS6bTTI3y?=
 =?us-ascii?Q?4FZ5O7IA5dW1UwDKuvY4qqVWk4XAOu/uNFZh9tldmeuVzruylogoS3ouPSU8?=
 =?us-ascii?Q?w06SmUduSfWpPQ2l4DnzV4nYp4UliyUJIpKTlPP9TAtLICNZ0YEEBqctaZxK?=
 =?us-ascii?Q?OKV1KGRt8idphPOZ3PlQUTXVMrwkXlcBsnkc/mBEAzc88OHRLqkalgg1ZkQa?=
 =?us-ascii?Q?vaHYDGor3k8y2vD+HDMMdLGZ8SwBreJQqmcdFD3P7W8PR3tIbFjo6f6h9Z1i?=
 =?us-ascii?Q?7L8TIfcEANjPmHjKSk+WsqRTzAv1ibxqjWOwSGVgxJQ4vI9QCX+Ghm+BtMPK?=
 =?us-ascii?Q?9mIFbDvEw6t/4c54smGzVOp0Qvm5mK8qsv+5xwWKNcyJpaRSfkb2+GoVNnwR?=
 =?us-ascii?Q?DhNZs1lEIkd5wZ5D/n9ItHpUFFrJ1umDJ0ePC7qo+cNhFjTi1sRXrMEmNtOt?=
 =?us-ascii?Q?/BvY+iA0LyYgNiSzF0x2+Oj6O9+4WedUp+k94WaJMCznjAbDN3MnJ9YwI1m8?=
 =?us-ascii?Q?OFnPYV6uIImx+wCf8wLw8e/oncT5/8nD9DTJbfKqmCpbq/Ae2xe2Gwlt+NXY?=
 =?us-ascii?Q?/LQfPvAnm/fNiNNjJgF5bM23AqyW/HVbtHQ7jlxR7NAlyUsqom5H0thJnA8N?=
 =?us-ascii?Q?hdsy/wuq0Q1ZUNW85G5RehwMH357eJNoWgkTs97J?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1801MB1918.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa48940-8141-4577-c89a-08da5fd516f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 04:56:44.3978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgcinvb9LRHt750uONI20aIB97QDeA50IvpDWfZfqkTKExSzsK9eR4WvaNfjhWxOedNAWT3UVWPMPmmzxUrlSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3018
X-Proofpoint-ORIG-GUID: ZojLg8r0rfucqKBRWHDO5TCJ8MkVv9J7
X-Proofpoint-GUID: ZojLg8r0rfucqKBRWHDO5TCJ8MkVv9J7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_02,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-----Original Message-----
From: Stephen Rothwell <sfr@canb.auug.org.au>=20
Sent: Thursday, July 7, 2022 6:30 AM
To: David Miller <davem@davemloft.net>; Networking <netdev@vger.kernel.org>
Cc: Ratheesh Kannoth <rkannoth@marvell.com>; Linux Kernel Mailing List <lin=
ux-kernel@vger.kernel.org>; Linux Next Mailing List <linux-next@vger.kernel=
.org>
Subject: [EXT] linux-next: build failure after merge of the net-next tree

External Email

----------------------------------------------------------------------
>Hi all,

>After merging the net-next tree, today's linux-next build (x86_64
>allmodconfig) failed like this:

>In file included from drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs=
.c:14:
>drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:15120:28: error: '=
npc_mkex_default' defined but not used [-Werror=3Dunused-variable]
>15120 | static struct npc_mcam_kex npc_mkex_default =3D {
 >     |                            ^~~~~~~~~~~~~~~~
>drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:15000:30: error: '=
npc_lt_defaults' defined but not used [-Werror=3Dunused-variable]
>15000 | static struct npc_lt_def_cfg npc_lt_defaults =3D {
      |                              ^~~~~~~~~~~~~~~
>drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:14901:31: error: '=
npc_kpu_profiles' defined but not used [-Werror=3Dunused-variable]
>14901 | static struct npc_kpu_profile npc_kpu_profiles[] =3D {
      |                               ^~~~~~~~~~~~~~~~
>drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h:483:38: error: 'ik=
pu_action_entries' defined but not used [-Werror=3Dunused-variable]
 > 483 | static struct npc_kpu_profile_action ikpu_action_entries[] =3D {
  >    |                                      ^~~~~~~~~~~~~~~~~~~
>cc1: all warnings being treated as errors

>Caused by commit

  >c6238bc0614d ("octeontx2-af: Drop rules for NPC MCAM")

>I do wonder why static structs are declared in a header file ...

>I have used the net-next tree from next-20220706 for today.

I have fixed compilation errors and reposted V2 patch set.  Apologies for t=
he trouble.=20

--=20
Cheers,
Stephen Rothwell
