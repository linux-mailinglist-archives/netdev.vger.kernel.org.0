Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E5349EC6F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiA0UZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:25:29 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11882 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231384AbiA0UZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:25:28 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20RICtW4029295;
        Thu, 27 Jan 2022 20:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zpoaJ/evKO6Vx/BiLITr7Fh8y4IwOnemZKidpl3jo4g=;
 b=sw8WzYbKsp5vz+KhfAt42kgiDgdBErzphD0mVOptVgBAtY889L8ZodD1ObkCG3Ilo+KB
 0ltkK+FdjZsoykJ9d+XZI/NBIyINNFuFBjMRakYBcppBhyw4XCTPhwRC5nJgKUfeW/+F
 WOx7YCF0knSaV5RYs5oCL1QIJfHlkoqoLK2gQyzJwz9/D86vWVkWPnz0y4tlgxu13O/w
 ePgwfccuF11UYqpAl23BeSFylGW8235SMglXNUlKasCdlVhWe+QQHI8Z6RUJiwXDIciq
 0brQbYE1sZilqM99Fx7zKbTAM4FTYinopGGr7NubTAHnN08Ms8ikumdwn486pD8A+o4C ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3duvqus9yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 20:25:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20RKGsFg090422;
        Thu, 27 Jan 2022 20:25:21 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3dtaxb67y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 20:25:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9ap66Y7wW3efBkCfQnh9IE3RnVXIQe4zzJ1gemNEvH58EtWyOU+AWTAJkpF7ILXA/10j1CJwDU8SrMtkMHNH0x69vqC3MQyW1RcjoncxoT/+dW4zzVlrYlOWUqzDnICcYIHcHQMzcy8ZTm0/qLhUE5gLdV9JOrj9lQQlhZSp7l0s3XYBGG+Hi6rfIZzfZ8SPUlyIar69+s0bKCbUz/+RJvyhv/piTJXzX6LExwW2Hs3W61VN8qVgMkLVOawR1s/H/BxCPRDqn7LM4onNoSivcU9WJH0aJaJrHq/TJKNihQJj2n505VpwQeBe4cQxNHljWMH+JnJSbnlEMUKTBuIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zpoaJ/evKO6Vx/BiLITr7Fh8y4IwOnemZKidpl3jo4g=;
 b=NJOdYgI6k5SOaC1IhKRiWuUq9A/TihFiz/CLApUleLjhbxpyU/2pQ0feTpnA9De77ejrKH1hoyh7uyzDfJXh72vHrxpGeywfqKYiXtNhlijgQwX477MVyP9GNYWcsWanh/yHOs/l3wxU2NJoFNaclEUgZIizXIh5vlPz+RRI+8bu3mJv9HFJVC6EnxzjF8siA9A7cwarfNkNVLVpoRe5lFQveGZ3EBdIsW1imFX828VyYTuO3AUMFxSQfz1ouAqFh//jADG+2cKYCtXBYF9J7UcHMUVEz2MwMJZvMaWWSXzE+ggFU1uPywhU2fGvAhDlvbs+EcbJfCWyJPJCuaD9vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpoaJ/evKO6Vx/BiLITr7Fh8y4IwOnemZKidpl3jo4g=;
 b=oDDBxE0zBNLRf4ePKOd8IJ9Onocq6usFMOoMuOjFxfy1eAkB86qZCEwpk/JxCWFSgCGAcFReGNEJi715GFXPMNm2cLcr8uG7VYmbJQ5G/5lkL6IE7S+vqghSvVdBfWaY51YcWURKeHHl55SnqQ93/IcF95/gE7xme7NrBYU+N/w=
Received: from DS7PR10MB4864.namprd10.prod.outlook.com (2603:10b6:5:3a2::5) by
 DS7PR10MB4830.namprd10.prod.outlook.com (2603:10b6:5:3ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.15; Thu, 27 Jan 2022 20:25:19 +0000
Received: from DS7PR10MB4864.namprd10.prod.outlook.com
 ([fe80::16d:ecf0:1ab6:7401]) by DS7PR10MB4864.namprd10.prod.outlook.com
 ([fe80::16d:ecf0:1ab6:7401%2]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 20:25:18 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/3] SUNRPC: add netns refcount tracker to struct
 svc_xprt
Thread-Topic: [PATCH net-next 1/3] SUNRPC: add netns refcount tracker to
 struct svc_xprt
Thread-Index: AQHYE7nWPUHtg5LEfkOxNDN5EdlVIax3UIqA
Date:   Thu, 27 Jan 2022 20:25:18 +0000
Message-ID: <534A0F41-2823-4E29-85E7-D1E8406047F9@oracle.com>
References: <20220127200937.2157402-1-eric.dumazet@gmail.com>
 <20220127200937.2157402-2-eric.dumazet@gmail.com>
In-Reply-To: <20220127200937.2157402-2-eric.dumazet@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77c7e4c9-06e1-4387-494a-08d9e1d322de
x-ms-traffictypediagnostic: DS7PR10MB4830:EE_
x-microsoft-antispam-prvs: <DS7PR10MB48308F8153EE2D74A024F49893219@DS7PR10MB4830.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 18wXfNQdQl/PQ3lUmDTnkqeiqL/EXDNLG4R9lzZEicC6LzlQ3b4Kq3Wl25OFIHlAVRvuU7CJfmsQy9hvTGhk7IPJbx1NYNpIZTF8L0MNbg/zay7XEnxe2i8kFGlFxgKslJt07nePqeWsMcvdi+HLGz8AIoynIBiKHAlrEKDTcGzCKUCp6KUGJZTTaJexD5sLW8lUDw3BHGMmFaGXhCrsiPdhcdfp1GkJkqdwpPmZ3IDPExJbeTl/Gg+UiL6v0m3HOmjzUTfcq96DLWi7YlDQfIfUeyUjavZ9ZvnbBQBHR/1qSJJRX3lgrwyrpV/31my2qXTX7VEWNX0yyghT0oyz4cLD/Zu/DlyWJZ6pTVJXMXl9KXKG54NYOT7L1BZ/Cde5v7yr/YOk2152LJk2O+NIffewzhly+bKLTWxZ99YZuJOkO0RhY8qvb6yKZ7Zfr/ZU+jI/d7dA5dA7O1ZSUOxDL8oEKgeHwCTvYG0GOmmcK/2xSaPS9ytEbkS0sbRfTEzSRp3/uGnUCTy+3kMYh+QNJ+HXcGVRgxsTX7ja8Nejt1K0LdDILYx72asPS5xg+queuAvssceNdV2Qzryc2vzj1FoDqGa2p+yNvb65zNFnwfIcKxzmXfacSo80xfsebk7/q2xAz35D5cL01In5Hzo3CY/6xUJY1zAarn/jkEgX84AE/R+QmdR68HWlp3I9N4dH49LxUvVeF4CFB8n/Ifn8mQVwP+3DcvSoX9KbrxspxUkqQMABdSbYvti8U75oRRoU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4864.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(186003)(36756003)(122000001)(26005)(53546011)(6506007)(38070700005)(71200400001)(2906002)(2616005)(33656002)(66446008)(316002)(91956017)(8936002)(64756008)(66556008)(66946007)(4326008)(54906003)(66476007)(508600001)(6486002)(8676002)(6916009)(6512007)(5660300002)(83380400001)(86362001)(76116006)(45980500001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TNa7IHlOhiM9PAV++5lPxIeixPaHRHCml+ADPcqG6RCcH0Bl0OMUbcSp0r/b?=
 =?us-ascii?Q?I3dY8tWguS2ocWvmNUsdm2AhLa2veug1US5GJecA3CK+bhJfsk5YWFEJg4BO?=
 =?us-ascii?Q?MDjOguLEMWtjc1OuahbY5ih+lJpf2nuH+Q7Hfc/T5xOAaNRi4cNenG//0hjW?=
 =?us-ascii?Q?9bgDcVgQk71ryTwwuvf9d74ev0ZLHOSq1BX9MFTh4p46E819HR9H0eJqsjHa?=
 =?us-ascii?Q?PVLdxYl1/9bpFTPciu1DXC3hoTX9lqE8ag89uDYP/4Mt4aJ1b84IhIqyawke?=
 =?us-ascii?Q?J43CsgvLCs430+2+w7lR/3X/Cl0LKBXxSKpMkEFcdSRP3/G9DP3oCE7pLtyM?=
 =?us-ascii?Q?vvFwqTYu4lzrJPEny4UFaQ25wE0P/c8HC6r4Km+qfgfjNHwtrwhvOl7DV+tS?=
 =?us-ascii?Q?MdfAfCJ4CaM0+WOYfWRl3m2howNdA5edwvMyUw8o0P9M45k7Kgqwikp8ue3W?=
 =?us-ascii?Q?vHgyK9l5FwtSBm7hFnuvVBL5i9krG4YktQP/rYkE9sWE9oJWiB6Z6XEbqssA?=
 =?us-ascii?Q?Ur/CZSjkx1VYZyj4dRIN/5MwJ1GLuJD45lhLiX61nzHU1/uZBZwyWAwvKE+A?=
 =?us-ascii?Q?zra4yCpc9R/joIKx0iqvUVsVMOkRQTE11dH38KJ3s/QOqRkTKutMmwUYFivj?=
 =?us-ascii?Q?ABq6/VWXDRbPRx558LL4AJmoJtIodwkxA9skA8crI7uVUZAGid20HKW6IMaX?=
 =?us-ascii?Q?uZwItb6WKNV+GsGGYqgXCU6OkJIKO1rdRJhfFkVNf1Wg6JUHSP5Y7++PMzNl?=
 =?us-ascii?Q?NSlts/h1jG0UckSMaNHiTvcC5QmBV6lrB81LZiV/9WJq11BXy83PEk+BtQju?=
 =?us-ascii?Q?CPcMO8IlyVgeiC7RCdzrtSZD4Ulj44rntxFRISwNcFvQ2/wsMpaeyOGzZXRJ?=
 =?us-ascii?Q?0Q9412rKjQ4o0qqlC12Kxr2Av0/1ySh7h0Ozn68AeRizC1HKoUlO8xOqyntP?=
 =?us-ascii?Q?b+kOLT2eidTmcN5APNgW8Sq3k64HSFTbfy537g6d606gFH77uAnrkFiVLN5p?=
 =?us-ascii?Q?Fm/rhuhiGwPgG+rrLAEr1C8BHibTL3y/u9vWrDIz5dZYU6i8PEt8Gwyk8vfe?=
 =?us-ascii?Q?p9rzV8Qo+PW2u7zmq7165X+iW50nxJx6B/2zhRdCQdYXHOqcm7bbdO3uTWtd?=
 =?us-ascii?Q?5XCH9gjmaryAR2qNFyUvLB7I1vSo7Q0LSnvVBZmNFxAxADHu+Bc7qAzBVpBF?=
 =?us-ascii?Q?d6oRWdeSn2TOiFOo44nbczKHFrwoUgTipsYGYWrB24OeUgiE2eOkHlqb76/k?=
 =?us-ascii?Q?Ub940iteNmqk9KAnMj9eW33MLbHojXEw755nRWkjcZ2tbrlfsSw6zDR3hkXK?=
 =?us-ascii?Q?8ld0rJGfiy6Vg/7ZlLrS0AGjnGrWjqnh2WFjDyc3WnCvB/b34Xpvpd0LQFBc?=
 =?us-ascii?Q?/p7jeFFwqsFX21nVqimMuBjs0h06spD/aYkoBCmOSjJW4aFy5cIDwC9I9/6b?=
 =?us-ascii?Q?s7C1zsK0BDAT5wBO9YRXh6cq/Dgv2agxnHZIycOS6mFPVTvosHY+1OkBg3Xq?=
 =?us-ascii?Q?T3qAr1FhI3jikoeyHb35aqAwNSAvGBByGL1G0M2g0v1MjXN3+0XiJQDEgBsG?=
 =?us-ascii?Q?xCLbb4HN1ExbAvOjw0rCbf3As8X6kLdwJn0Ng6lnJEMbPULsE0Hi13LTydDQ?=
 =?us-ascii?Q?BsAkfS7MZFbiF5uKjKv/UBM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4383CA64565F7459D8F64DF62F87A45@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4864.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77c7e4c9-06e1-4387-494a-08d9e1d322de
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 20:25:18.8040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7CNyLplTy5LS9w3+I6TPOIPft0k0YXUWDJRz1FGt68cOr1moWXj73V7D5wVo25Y4h4ib3poCliF5XVsKmk5jQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4830
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10240 signatures=669575
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270117
X-Proofpoint-GUID: E3eQBQsMmod31idxO4QSIGXd6VhTfc9K
X-Proofpoint-ORIG-GUID: E3eQBQsMmod31idxO4QSIGXd6VhTfc9K
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 27, 2022, at 3:09 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>=20
> From: Eric Dumazet <edumazet@google.com>
>=20
> struct svc_xprt holds a long lived reference to a netns,
> it is worth tracking it.
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>

I haven't followed the requirements for the extended tracking,
but I have no objection to this change.

Acked-by: Chuck Lever <chuck.lever@oracle.com>


> ---
> include/linux/sunrpc/svc_xprt.h | 1 +
> net/sunrpc/svc_xprt.c           | 4 ++--
> 2 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_x=
prt.h
> index 571f605bc91ef8fa190e7fd5504efb76ec3fa89e..382af90320acc3a7b3817bf66=
f65fbb15447ae7d 100644
> --- a/include/linux/sunrpc/svc_xprt.h
> +++ b/include/linux/sunrpc/svc_xprt.h
> @@ -88,6 +88,7 @@ struct svc_xprt {
> 	struct list_head	xpt_users;	/* callbacks on free */
>=20
> 	struct net		*xpt_net;
> +	netns_tracker		ns_tracker;
> 	const struct cred	*xpt_cred;
> 	struct rpc_xprt		*xpt_bc_xprt;	/* NFSv4.1 backchannel */
> 	struct rpc_xprt_switch	*xpt_bc_xps;	/* NFSv4.1 backchannel */
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index b21ad79941474685597c9c7c07b862ef7e98ad74..db878e833b672864551bc9ef8=
84a3cd6ca6c2603 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -162,7 +162,7 @@ static void svc_xprt_free(struct kref *kref)
> 	if (test_bit(XPT_CACHE_AUTH, &xprt->xpt_flags))
> 		svcauth_unix_info_release(xprt);
> 	put_cred(xprt->xpt_cred);
> -	put_net(xprt->xpt_net);
> +	put_net_track(xprt->xpt_net, &xprt->ns_tracker);
> 	/* See comment on corresponding get in xs_setup_bc_tcp(): */
> 	if (xprt->xpt_bc_xprt)
> 		xprt_put(xprt->xpt_bc_xprt);
> @@ -198,7 +198,7 @@ void svc_xprt_init(struct net *net, struct svc_xprt_c=
lass *xcl,
> 	mutex_init(&xprt->xpt_mutex);
> 	spin_lock_init(&xprt->xpt_lock);
> 	set_bit(XPT_BUSY, &xprt->xpt_flags);
> -	xprt->xpt_net =3D get_net(net);
> +	xprt->xpt_net =3D get_net_track(net, &xprt->ns_tracker, GFP_ATOMIC);
> 	strcpy(xprt->xpt_remotebuf, "uninitialized");
> }
> EXPORT_SYMBOL_GPL(svc_xprt_init);
> --=20
> 2.35.0.rc0.227.g00780c9af4-goog
>=20

--
Chuck Lever



