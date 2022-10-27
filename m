Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F4E610628
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 01:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbiJ0XKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 19:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbiJ0XKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 19:10:44 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2084.outbound.protection.outlook.com [40.107.249.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232449525C
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 16:10:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpJq0037LxGoE0pfloHfRY3GwPA8JqeWaNPpYqKmmPcIp4aqHvS3LyDoxKgkuqow9zThOHY5gFtBxVXzlfvqVm+KO5HIhPI+PMDCjFIJftcW3E1sLA8OBCoR4/jrmmmrHuvkG5ML/rRov3rqxb/oTWmi0wCwFpEJdui/xnMpfLHAsbrYODOB45iI3HIhN+iqECQwvL26GMIPl7uJ3DFHjXLCS4geT2PzZ8/oB+bqN4firOclf2gtrzgAI957g12cpoggGMLbphNirmfj4kbD1CgT+egO6OvXl6134DSBiCwng6IWRg7xB+JoWTVu/QM1D9Iq6OCe8jqakOjpszYMVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWFBNHpT2qQXc8VQnJEAR0whMZj/zv/xpg/mB+BlLAQ=;
 b=kzvZ5oAEAscYtQaPzl5qxZ/UozlXYpBUp8Am3TqT6K6S6N+ulCM77YTfAZA4+qrp8zPUEu77iQieOXtAZdmkOCw7cgNVBrIeFUN7FIDlmprH+YQkdUqZJ0Tl9cjOWnutvUoGenvFNeqKfOJsEFk9NsJcXc9CDKtobHFN4HwxCZlJlbxHXc/0gGR0dvduaoLajGd3Hpkh8o+6cB67gLj/99qMAKPeGj9I9gLj2lTOoSZcux65q1IU3DFeORZEhFjl8wnijav55HNTbdGLDnWeLaonjc/962L4DG9b12vCuyTzzTSBE2Zg3xtBtu7uvAgqZRpQRmK7/in3GR9M3A0NOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWFBNHpT2qQXc8VQnJEAR0whMZj/zv/xpg/mB+BlLAQ=;
 b=dMQWoYBakaWrCap4ZWtUGAh7CBlUTGqDeLQBNOOXeCbasTht1MIm4pTkf2rfy77HQ0yOY04IvTWxiSKW50ZPpQrhhd9luSRUx06BK495MKqVDv227yfLMxPTYqPO2tg179LuGWuTsKqcVH+OEmZNFpG81L6wIGQDi2OU2ANDIQ8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7559.eurprd04.prod.outlook.com (2603:10a6:20b:295::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 27 Oct
 2022 23:10:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 23:10:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>,
        "roopa@nvidia.com" <roopa@nvidia.com>,
        "razor@blackwall.org" <razor@blackwall.org>,
        "netdev@kapio-technology.com" <netdev@kapio-technology.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: Re: [RFC PATCH net-next 03/16] bridge: switchdev: Let device drivers
 determine FDB offload indication
Thread-Topic: [RFC PATCH net-next 03/16] bridge: switchdev: Let device drivers
 determine FDB offload indication
Thread-Index: AQHY6Fi28sjP26J2fkGNTwB3ANTNHK4i4faA
Date:   Thu, 27 Oct 2022 23:10:41 +0000
Message-ID: <20221027231039.2rqn7yeomk5nsx76@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-4-idosch@nvidia.com>
In-Reply-To: <20221025100024.1287157-4-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|AS8PR04MB7559:EE_
x-ms-office365-filtering-correlation-id: 806e8aa8-fbac-45df-f883-08dab8707850
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RJW1It1PLkLUFBlcxpVhgsur8DrF6ganYzWzLXGGejGmFxsWLMEjMCXtx6xqc+cTuHd3OY1KlfQxu07Q2vSGnaBbiRRGegztGlOfBwR486QeejJZZHmvPQuCjhnyQgXvz5foxNnC8/aKUqMo341ijwzXPWAXW1s9EzmyW9SpHTUve9S52UOS/arcSIgAZHoU8PawZVao8y6caFyFvvmhZrQaTSzXLiGlvWDA4qn6ZnP5Vmd24n4huwdLa19l4xcd1Ik63fvrPqOacXoTAOyX5PBr8AAKnQOTpOfrfatKgsBgvjymLbqYofWzIqEoHvl6ijVO/mqlHBagIjSz4Mhxclqd9wlrUTxB2bu2dFQTSSO6glsEr5NtpDRVLC41Esuibb27mW9jSMC6ynjPc3g+L933caEPVjxkjFA6Z+51xN9+F+Dfivhv59//pZ1UShqGDDpEdkVkFpKMJaW2Bn2CE4ewqmj+SO42mXr7FT7eDSMdn1isWuvr6Em7HRKDcgPE7XzCMdZxHXq9V7i1mkCrsoFPH1/rwSqhcesKkBknF2XJdyHUQ5iX4VfGLi0seEO99OXUEi7mNq5gUrUjmlBjjdRh6j09+58dOKIUQEpI6hsh3auGicDlj3ttoVl82CMA8YYksj5Rht6uIoYILEBmsvhJaE8j50SjmEy+GyUIrYy0Uy6qbIbFBylSerXOuLcg/9o8nhITHDtfXC6ueg7+1p82WxvRbbUiGDZs017S+1AmEENHxeCY3n+0BQCyqaQjc6lSS3FOqSbb7jxGy0L0og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199015)(86362001)(8936002)(83380400001)(186003)(1076003)(5660300002)(7416002)(8676002)(91956017)(64756008)(2906002)(66556008)(66476007)(66446008)(66946007)(76116006)(4326008)(26005)(9686003)(41300700001)(6512007)(6506007)(38070700005)(33716001)(478600001)(6486002)(71200400001)(122000001)(6916009)(316002)(38100700002)(54906003)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2EB4Zii6IA70RWf1CicDjrMTeOQk6BobhURnul+nJ8NoQEl2fcNr2frh8bMH?=
 =?us-ascii?Q?WYopc8GM6/jzxAc0CEtIBnuurA8N3xTPE9dm1H6D4ItQOrfvMrGES8ZJOP/0?=
 =?us-ascii?Q?JKtEgvMGZThaXNtGpOc0xnOmh93F78hq1JjW1ZkNx2nrzPvAWpgWN02F0sfZ?=
 =?us-ascii?Q?FcnuURJHVYJXSfep0Ezp1xsl5ZmpNLuHEgRdnUdSHnERcAYtB+CQXN95zFLp?=
 =?us-ascii?Q?Ksnu5pBJp7HX3fCKcmf5gfpSMaP0m58CbIXaeWq6EG/DAVm1VKePERGWmDSJ?=
 =?us-ascii?Q?bOf2Jl7uORgzy3CLFSK5bx9ZFuKHVDMG0m5f1f3HGjCF9NWNITL3TE28xaus?=
 =?us-ascii?Q?IFWp296TGBqTB0mW7IjwFP/43+LrtNHd69Z7NSPOeuP0ylJk7ScE6OWmB4jq?=
 =?us-ascii?Q?IXxyfK5Mz87alJswbvimHILp/pAkx5NKltF8ONzFJP9xBSxMvNy/g5ZquhOF?=
 =?us-ascii?Q?7Y2C+gGp1U4Ez5XMPX/JMo97Th0oU6YZp/p7z+k3894r2HKZi/ugghwmzPnt?=
 =?us-ascii?Q?GcmiBGzR71NJc7rmrN35w7cfFIviYDbfHzElIUrnAfYEoamxb+xuIKlgeybJ?=
 =?us-ascii?Q?KNi1wR85qw3Ovqk9pHkJiGzPiYqGimd5AznjrdOBDJhZWwIudUAPJNmES6Kl?=
 =?us-ascii?Q?Z3HZuG4XojyqC1kEmS5M3ZHF4GkAUkgueuszdztg31CaZfQy0zmHuXQ+5HrB?=
 =?us-ascii?Q?oHgU+lGHXm34GJpWv4QuIHjNwMby/ebfCkjQpBtBJYPUp+uG1Vm/VPbw9zt7?=
 =?us-ascii?Q?OfQqLp3z5FBKwixndQxK3bS7jocO1Amt19vm+suhbc1T5QgOIfcuvaS6ZRtW?=
 =?us-ascii?Q?OJgcPvD8co1kvhTfqQ/5y/NuvpFpgDPsmhmeaSMH/udcXPqohN5SJdKL6DVq?=
 =?us-ascii?Q?hLI6b8TQS7PmC8aXw8LUexSWouy/9tNcn7c+uQQqJNyGCc6M/8gPYe/PfGbU?=
 =?us-ascii?Q?AfjL16t2LrjpwORDmtlX0bwbIblVU3jZTZ4jcvmaa/EYw+oj485Eo3ANJn2S?=
 =?us-ascii?Q?hlYafDfuDW2YerP5W0wFuOT+ZdgNQqmtOufHxwCOAoalJkxGE1zfi8FJkQTn?=
 =?us-ascii?Q?PxnAMUJHILptdMVVRU/Cr68d6qDe687QsgMj3yVMstEduXYFML4ZakiiamPa?=
 =?us-ascii?Q?ykJrNygsvuG/45PZQcxoh6C+lmwzs4oQoaJxo+iCoSlYbhY85iLYcWkTMXv6?=
 =?us-ascii?Q?GeVEcxDLPdzbG00oXvErruA45myRzSYJzvPcJUI5rb6tKfdcjXkggdvgSp1K?=
 =?us-ascii?Q?pJy0E8b4e2W1f/5SODJcmYsBPNR/TPLPoHUjJDWoM7jTMDlKU3GEiZjkzSCk?=
 =?us-ascii?Q?P/8bMTwQUBxOmy4muLbfxfXhs8rBfRYpSRhF9bTScY0rNpl4T08EJ1EZbtl6?=
 =?us-ascii?Q?K8G5vRfcNc4/JgbA3OnYmsh3+vO/Gqpg4gfqduh2RBUmL67UcQ0TvU0xvsVE?=
 =?us-ascii?Q?oCrGLafM7T9LfHsA9lNTM/JiTtpdk/COlpwzyPqddRZqtUzqsW32eFPcUZMg?=
 =?us-ascii?Q?XGgEO3H2k+QClv50gd1e2Q7byAxoNqsnFFSfjD18sdG6f0Nzw38cENilAsMA?=
 =?us-ascii?Q?Egs4eKjfuUpB1Hb2MKBoOx/lUyIiSpjjb174Lmcqcw+8rk2CvfInOpfatgTE?=
 =?us-ascii?Q?Wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <98560FD608283B42BE81799036EE147B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 806e8aa8-fbac-45df-f883-08dab8707850
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 23:10:42.0298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtMVBN/UcdjBkidPEKfkIrC3B3lIbXDwckf3NvWLiJgqpQa+9DiFAorEYoopVnjYvx7HO/E1v7WHe6Q7NYhM4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7559
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 01:00:11PM +0300, Ido Schimmel wrote:
> Currently, FDB entries that are notified to the bridge via
> 'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded. With MAB
> enabled, this will no longer be universally true. Device drivers will
> report locked FDB entries to the bridge to let it know that the
> corresponding hosts required authorization, but it does not mean that
> these entries are necessarily programmed in the underlying hardware.
>=20
> Solve this by determining the offload indication based of the
> 'offloaded' bit in the FDB notification.
>=20
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>=20
> Notes:
>     Needs auditing to see which device drivers are not setting this bit.
>=20
>  net/bridge/br.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index 96e91d69a9a8..145999b8c355 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -172,7 +172,7 @@ static int br_switchdev_event(struct notifier_block *=
unused,
>  			break;
>  		}
>  		br_fdb_offloaded_set(br, p, fdb_info->addr,
> -				     fdb_info->vid, true);
> +				     fdb_info->vid, fdb_info->offloaded);

ofdpa_port_fdb_learn_work() doesn't set info->offloaded on
SWITCHDEV_FDB_ADD_TO_BRIDGE, the rest do.

>  		break;
>  	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
>  		fdb_info =3D ptr;
> --=20
> 2.37.3
>=
