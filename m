Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F1835743F
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348515AbhDGS1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:27:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:34220 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355261AbhDGS1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:27:00 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137IF7CE170597;
        Wed, 7 Apr 2021 18:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/hoIFYh/5kVl41qR5ZFg8uTVEl+gGZf6CPpgrRunziw=;
 b=Q+rC/H0e+snUTGHDt9BjbF1RhcN/MylVuATPbxm1It6sVZsMabF9oxjsVpo1bHcQ8y2T
 vyChjvXcRWLyRIVI9qWtbHP9J1wRv1zEAlRBmTkwc4CNwM+YNiX0Uv2q2J0dSHI1MxI+
 Po4TcKcnyyxtw187cRR1wXaFdvG7SsMKifxzMVRcuNd7A17TjvKhihI/dg0ss/qmn8Xy
 0x4158fFgZjCODBSJHwCAp5ackqftcjUfOZHUXdWsdi7jxdMFdNcr0AFqkFNX/slmZuq
 U9THthQARaJlHD74aCmHMn7X8zmoBB2FpJdPI0AopveWJjnooku39fRcMGQ8xMmerv56 VQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37rvaw3hu1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 18:26:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 137IQ75a039036;
        Wed, 7 Apr 2021 18:26:44 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3030.oracle.com with ESMTP id 37rvbfc777-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Apr 2021 18:26:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuYiaa9Spea5wfachtD3lzwJ9a8nqwQiwao8qVGogu683fc89kS2YmtU8nnWhYii97LIqAq3anoHzpKRZI0SMnm7KtVcFZ2oWO8ZqxkuE1+23CnRiNnSop6pxa7R0EnktRxDpDdV0urg/b+Y/ST7LPBOndNlqE7vssIWPfKgXpM1YEZ/a+sP1gy+hsQ2OYbmSqUsAtlXeF5EeG+d3xdxqs6IeN5idlYdTYiwCzu16ZBsRWCKWogT+9jwUUsuMuft5B1jM86OjE5VmE1ht7puhs6bU6q1XmC8Xm5VXnjao/2KJpIIDB5Fa+Fhf8OReciCpUcWltTp404rlvj6Y0KOMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hoIFYh/5kVl41qR5ZFg8uTVEl+gGZf6CPpgrRunziw=;
 b=nXAIF4lZuwFwQwllWjg8CXcb94LLQup9ovumhBrGRhd7F7G4q3Zj0ruFHtHPFKUWdeCSLXEtPOssbHGy+YYzm7Y4tMVYvhQj1MgJhp/BsuTd24/6wHkLKneDBWmgwbVgQswetnBuDfI+k7qxsj4vc8xfDTsF81xukIuYnnxZs1i0MhSwT2RrmqSQirZ8iskSmJvVl1b9nB+i/YyTmSvhDlQvus9tQ/fGRPjYF1nch8psZNF++xlAa035HVi835GbLhh4eI2BKYOfR21Ki8a3L5H0i2dAzYo0VSiULf6oWxqLwgW6tePiPxcQvdZ5yt03Dh8wmoB/REH16Xo2LQwupw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hoIFYh/5kVl41qR5ZFg8uTVEl+gGZf6CPpgrRunziw=;
 b=s62aeWmZ1yaD4xfzUmSUrMSx2W1IAmLgQfCqMz2h39IzjdL3XObHvTu1/5o7NJHbPP7sv9Ij9jKTLIB5Ss3n/XYa23K5M9HOYgTvYVmEhSBszp5NCTP0Owc8aK/TtOnCC+5zgCAYx+39p39FYptslvXRH8Y+0+SAnoDUIPx+kKw=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BY5PR10MB4161.namprd10.prod.outlook.com (2603:10b6:a03:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Wed, 7 Apr
 2021 18:26:42 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782%5]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 18:26:42 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Aditya Pakki <pakki001@umn.edu>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Thread-Topic: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Thread-Index: AQHXK9uOg9SlFRiZTUOkxXjE4FDO2A==
Date:   Wed, 7 Apr 2021 18:26:41 +0000
Message-ID: <211FD3E3-54AF-41A4-91BF-EEB01680A1CC@oracle.com>
References: <20210407000913.2207831-1-pakki001@umn.edu>
In-Reply-To: <20210407000913.2207831-1-pakki001@umn.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: umn.edu; dkim=none (message not signed)
 header.d=none;umn.edu; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [138.3.200.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bbe841d8-093e-4de3-c2e5-08d8f9f2b112
x-ms-traffictypediagnostic: BY5PR10MB4161:
x-microsoft-antispam-prvs: <BY5PR10MB41618FD741AA0A298F9E19D293759@BY5PR10MB4161.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bLt6xz9/utLmZOOPKjlLNTA8MRrtTK2uoBo3kv03woQA8gGMdPIWl32ImcZJc/Biy9UqgjkPFfc37F/5DPlvfhq39cCPotiupFZ3DrIP/jvjlvecMUZKVSrqQny9h8Yw+93CPbKSPkZcfobulh1GQq9ShAuCVKv3VCW8PpyItwUnw91Ee7wxzQDGSqOj41trw3DWiPEctoLL3mJqJ/5+9qGgxbp3wpbgYE5Z61acBya9NK+ImZcv364qTXb52NKdjnEQuwEQNNp5JJxTm4142oTV09jWqfnjE9vCuaUtiMzHc/Z3hFJ6XVSryp6m09FQq4htoYXBP7zz24Psgi/5psJx2Jy7Y6r6VdzV8WuXbmKKJrMBvJbdqToZVUSoZlk93u1CRQpoStGf8LlsSVdZjNLR2YO42DIm+UfTc73trdwx0KgtSJT2z0YRtXNsJIUiJV2YsxeZw8ki2FY46bi4BtfjGJLn6jcXMzN9YUC7RHwKM4XSVfshSG337wriwWC1kqNHJiAPcIBVkBJU8kCEoVZ/5YnOzvn6lE7MgfeJ619FlSPxxY1IRjWXfLLW/p0fK+3w6Ox94ATqqd8cjExCa87RcrjITHefl/9IVN3/bSoViWqE/cBMIi0mxtGaj2+JTwT8eFdKHUb3wnt9Z9DxXaHzwqOnvYeUu1+KAp37cgX/UHmGZOMXkhinvWoM7FiP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(39860400002)(136003)(33656002)(66476007)(66946007)(478600001)(6916009)(76116006)(66556008)(6506007)(44832011)(4326008)(54906003)(53546011)(66446008)(6486002)(8676002)(316002)(4744005)(64756008)(5660300002)(86362001)(8936002)(38100700001)(2906002)(71200400001)(186003)(6512007)(36756003)(2616005)(26005)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Jf36L8ALqAGpcFKWWiKIgqN5aaiC5e8cLIPU2JBmhVM74qDzB28mWauf7aCc?=
 =?us-ascii?Q?6lpVKCmMb3HIUYEJB70Eh6UjxwHmBiYj57sKehFjVjKXQ6ULxgANu+Q8mZ2e?=
 =?us-ascii?Q?okvKXIIZtdP7I/i4jDZlEZRAxF0gSXi6UVUJDNywefPedR1+EGJ/0Ii/6mJv?=
 =?us-ascii?Q?s3V/1BdPXCp7WrIbEbGqGrYSzbi7LaFhZxMjagcFkgG7tlSeewxERL3TYNgK?=
 =?us-ascii?Q?1APBAMiHvK+p1/4+i9IGYDZ50jMOAxL/bSowl9WD2nbEXis1yDgsb+O4E91F?=
 =?us-ascii?Q?rNcUwGwsAtP660OXtB2JC9NdZ0a5UveTV+L46+6SawbQQZrd9o6sfAPG3ERH?=
 =?us-ascii?Q?ThFG9RttxjlYIruhXQ5N8yyDE5eRcwBlR0JgaElQR9YkXtOaF/Cne2UcV5RK?=
 =?us-ascii?Q?l3YV7WK+P5/Hz2s4UI9i6Ds7lrrb6a3PMARy646G023xEwndIR1nCMgRvL3s?=
 =?us-ascii?Q?H8YQjsUxsP0LWOsD5q6ruwy/rfLSNo4SmD8Igg7+NqyVBOIkuASMX7HzaJHp?=
 =?us-ascii?Q?rPuAr024FfDR8SPOZdEF1fn74bpNaqmsDcBisqZoIcKUMw/SHzvGFUhI09si?=
 =?us-ascii?Q?FTcpYYUMIccVxdOoUxtC91QwdU8RIKWnJJ0HY5xNQWM8ZJtYT2uu4Yrtg1zj?=
 =?us-ascii?Q?jqvVg/wzXLWCKB1xmbadUyKGGpI7Hucm+hQrHrQuRfUR3A7ZrjEeLcIohKQS?=
 =?us-ascii?Q?Zrq8lXDDS/UHhi6zMa8nCJmWq+tLOncIybNh3LLbQ57ytKufBvYpNjiCOnTr?=
 =?us-ascii?Q?dGndGNAHl04G+JmXuOVNFmFp7t0Ie0AE30/hChObcbxhdv1VItmWza42FeSl?=
 =?us-ascii?Q?igi0mPgqpwNZxRgHTa62lQNDxm9P32daxbG+HLicBxtO4NsmD93s5qPtz3Fn?=
 =?us-ascii?Q?jZupIrkWxr4GOn9KTv1VT8sMzSNpgUjgQM9E9fyIrF15jBSz671YtR3jFdsW?=
 =?us-ascii?Q?ZZRO/3yZZkrwoi8Gae4ZIvcc5tQ1l5OrNZhswU1ffE3K3aczbHrDtfymanvk?=
 =?us-ascii?Q?ZpgVOQSVN9fojleOeBiQ0IDdOm7sQu0gqtJpBQ8IV+MK6KTXFQ+oqOvggCws?=
 =?us-ascii?Q?3ZEU1T75JkxlgC4Id0uzRdEX8T7hyk2tdOBN4pLw68JThwvRUmYrCQkuixcp?=
 =?us-ascii?Q?PInix3iMplf0wIofxx5Vq7TaZGtRKfhfGXrSpgVf3mi9ukNvz2YLKHaH33an?=
 =?us-ascii?Q?MKao96zvDoRH5M2wJe//vjR/G+pfiVs3WP16CVzqFhS7Ma2mLxFrKvadVB6z?=
 =?us-ascii?Q?WTP03G/mbMWCXiSvh9tusMRujcLuobIskngZL6YfNYbRV2faX3D8W74ad6vd?=
 =?us-ascii?Q?gxwVeWfDloVoXfD7ZQI2qguk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1512169AD23F3246B52536486293A717@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbe841d8-093e-4de3-c2e5-08d8f9f2b112
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 18:26:42.0034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EBvfAamoxu5/LJn/1kS2q/YhO6bSas78wVnjWTXOru6DHK/wwiFnh+i8su12JZKxClUDi/3SbCzHBSO6aWyw7wv9VtsezeaPPNqbR2X1eY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4161
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=994
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104070127
X-Proofpoint-ORIG-GUID: yCVItoOvyK4cDCsQSXGobs12D9Gvrt5t
X-Proofpoint-GUID: yCVItoOvyK4cDCsQSXGobs12D9Gvrt5t
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9947 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104070126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Apr 6, 2021, at 5:09 PM, Aditya Pakki <pakki001@umn.edu> wrote:
>=20
> In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> is freed and later under spinlock, causing potential use-after-free.
> Set the free pointer to NULL to avoid undefined behavior.
>=20
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
> net/rds/message.c | 1 +
> net/rds/send.c    | 2 +-
> 2 files changed, 2 insertions(+), 1 deletion(-)

Looks fine by me. Thanks.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

