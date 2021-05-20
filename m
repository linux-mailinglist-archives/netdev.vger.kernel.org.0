Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4222838B5C2
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 20:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhETSIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 14:08:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64368 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231648AbhETSIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 14:08:44 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14KI3XFU027486;
        Thu, 20 May 2021 11:07:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vVasmu8Zrv0IYprjPQzoYTN7vZVe4nNCwX5TpZXtn34=;
 b=j/RUcZttluAcsZ/YuVcG8bIOMtE3zawXp4WL6x2uxYaYhgK3+TXYevqmKK9b8vgLzRV6
 Zmkmi5KpRX4GJG/hJIcHjLRT6NCOsZAp/I/PSyQM8GBzHfdjLwMRZcIGqrMts2qJNJQS
 UZ5avSC86221MxmYO73DtZpesgDlnPraLiM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38ndsw4xbm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 11:07:09 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 11:07:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7U12qvUwDo/bFhdM8iDQhpOEWDCOdL+IXo7bHdfqbZ8zQ9yRQq8fspS9G7y7+0zMRi2+DGRj5ndQv8mD9Gh1LOkHW1zv9qkxGvZqs6dAqTKKC5ppiOB+Z8GUgtwvUdXnwFhgQgxLU1ZRM2kFUJcCIVe/NRa+n+hiL5dVofWkaraZcbCikClK9PMAv4CYU+Q4ei/J/rNib46W/PPj3BgUnXKGk2nQmmmHHQkXyAHXnK5FhnBBokA28DbAEp/9lzz9F4dCzgiQ6XPQUCoqBA8hf9cP7KMkWEKUv+mea8Va9/y5RbOvPENHuC0xHZIMVwZNmr1tT1AI7e9khWJSuySJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVasmu8Zrv0IYprjPQzoYTN7vZVe4nNCwX5TpZXtn34=;
 b=Xc9NygbK3NYm4sxiMaYfF5h5Yp9FUBp43KepCP7fHjMQi/+EQfVdF9fBEMP+NfZ8lDLMbF8upmQGUUEbPNyTZAiR2aUN3f4qcfA74la6ayV4jN7HTxzRw3OIQOI3fXaEDQoSn7z/fXPZ/uYhHrwikAxtOjxRyM//qcx32507xo4HG4Mn+YiUrkfphp4QPsSxlasQwjopbcC+0UxNHnzKwopN3qe1Oagm6cNp/Z2dB7Fz2roqTLEmvNxK1cMEEcPCBXPPUs4FDm+URs9G3SZaJdYd12z/QfLwtQMiLXtvM5vUh3JF07sDkG3H7ljpRd43cbmm9IoHU+et+l2HIPMVSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4710.namprd15.prod.outlook.com (2603:10b6:a03:37b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Thu, 20 May
 2021 18:07:07 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::38d3:cc71:bca8:dd2a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 18:07:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
CC:     "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        "Yonghong Song" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next 09/11] bpfilter: Add struct table
Thread-Topic: [PATCH bpf-next 09/11] bpfilter: Add struct table
Thread-Index: AQHXS2+LXvXxXPN2KUCWbFtZ62Zc9KrsrwSA
Date:   Thu, 20 May 2021 18:07:07 +0000
Message-ID: <AAFF4E35-AD81-49C1-A1D1-250FF18AD126@fb.com>
References: <20210517225308.720677-1-me@ubique.spb.ru>
 <20210517225308.720677-10-me@ubique.spb.ru>
In-Reply-To: <20210517225308.720677-10-me@ubique.spb.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: ubique.spb.ru; dkim=none (message not signed)
 header.d=none;ubique.spb.ru; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a3706b2-9f30-49f4-23a0-08d91bba14f9
x-ms-traffictypediagnostic: SJ0PR15MB4710:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4710DC6FEDDCF8E12CF28AA7B32A9@SJ0PR15MB4710.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 42yinPvJo6hTPaCR+XIhGuoXg3/l/Cv7pa/UlhQs9dm+Q2oFT2E7krYKDmbDIiGXd00mAakwZYGoqEFbUzaE/AUK8vYlrDBL92ZWSDCavhgMc73KZtLNPkpRL44khYMAed5/FjJo5Z8F+/1lEpKcEp6yyV6adHBQIVaWRnJb2uSoQrnLUfSYaAqbiEdAfTm12WjxDHTO8vu1FJl62pKC5RTU7w9Bxbx1xS4uESN4N3EFbTIXpV2I6qGMlg0Km2gI3p5malHCWHaQ1wmQxsrqaz001Wa728ayC5C5NGI5X7GzmqWaQtfYHYU9noUFURGAltTKzD7YGJ/3MGDSFwjP38Lah2xcwQMUGCmYZeJaAYM45uOrO3YrwosASzCAt+zsyPv5+5Uvd5BO3tuWYK8CN05w6yzn/HqKrSYIdMySC0H83siLs2ul+HZKUixmlqSfqikW3fi1OlwbI9daAVeD3I7IF8ALkzig3if0gyHztneKmUzk2pnsXiklK5UTq3FdPoeWkSU3vy3swZLaJebQhc5Yn8JrrWhp54ghYupRFAViqopU14pckhQKT7gX9ND2bVuTM9nM4Hk1J+28RFHAHaWyHkz9tpSPj0fHZdCQF/yTOWIKIljcg06JBDk6DLmyCq/Rb0T30b+YmVlPH5q/0UY3E0HOXPY/RVAgKWiRSwI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(33656002)(54906003)(2906002)(316002)(38100700002)(53546011)(6506007)(122000001)(66946007)(6916009)(6512007)(76116006)(91956017)(66446008)(66556008)(66476007)(2616005)(64756008)(71200400001)(186003)(4326008)(8676002)(5660300002)(36756003)(478600001)(8936002)(6486002)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UcdHJ2xDREYoMS/TkDQVFYzqLfriHq/4Dj/9N2nQoTT66/Bn2r0jlNLP7QOY?=
 =?us-ascii?Q?JKRkAn3wSioMJySkaQ1mpsc734y4jFGRrMjxr6JTUTa1v4cbYeSk0iSsyBpZ?=
 =?us-ascii?Q?nSy5J8pcNfQfhY1GtE0rEp/IFVr+LEVMlD+wjG262xW64TSrgYdBohEXkl2L?=
 =?us-ascii?Q?Rlt5QG17W5uK60owSexTih716rOurw9RyyOyTmEbtehnvkAQDnSTR+ebXfrR?=
 =?us-ascii?Q?Lr9QMuMRWEnYVP/a1H25U+b8Y5QHwlydda9fKuaZuvRseWf+g0VBXbWM6sBq?=
 =?us-ascii?Q?bwLQwy7sh0JUKLCfDOb96cR9myAANrmumQpbc2PP+0QalP5ddelF98Daq9ix?=
 =?us-ascii?Q?Dcfpb38m7gqGf6mcjJZHkGtKpaDP2gwSD1DKYf2kCLYPMwFcq7aLk6akBFb6?=
 =?us-ascii?Q?54Ktxp5J5FIA3YSOf2dIQeGjMUd+rW4UbhLWakrMuIw1fppBOkYVhQ9ziNXg?=
 =?us-ascii?Q?7IRTag9v4iGs/qAWRnIzoQf/dDlehyahwJz7XAJu5zBhlFihQwfAtaHCxfJb?=
 =?us-ascii?Q?YrRtzzLDU9fewyGD4E/wByheu2w6XUlQtLJO++II+CWtfb9mjFjIwqpG4YYf?=
 =?us-ascii?Q?z1eFJkvTbbpJioKMbbCL2c+zG5d0memQgJ0XrqBjG/6QQF5zPqvIyrM8ByFN?=
 =?us-ascii?Q?H++2dVYQuG67qLLmlFLMeDrzwGeWLKg1EH8AwGur2DjDu81meCIjHNeWmcki?=
 =?us-ascii?Q?y/YyNbQK4vHsJ7XWD+2EJQM/J1n0wmhDVhB+GAVS5myWiJERTYgnrFORWO1h?=
 =?us-ascii?Q?aetTQxaf6ytBH29yAhVbhX2N0xqET8lzt83u9CTYer+L5FXXGuOwuQ/7UZIy?=
 =?us-ascii?Q?ada5S1Y2oNLsg9tVSJzLCq6YolesD551YFvcv6TSD481XVBXnEUogFda4ryg?=
 =?us-ascii?Q?cq+3S+owHPnHQkmFukC1Qn0+B+MMf6Lrkpli0hlLNkFEnKp1Wq7Nz0w7cZqE?=
 =?us-ascii?Q?fA0X9hgLNsFzy0WL/5Ol+G2jk/7BmT+C8/X8PgOAWSKe52WEg/n0gtZI3jRK?=
 =?us-ascii?Q?KCSCAD3ch6ibsJAcv84yxxENUIAggunmBrEzxhye3sOZFoJjiW66B7dmJkm/?=
 =?us-ascii?Q?KQBlBA6D80BLQWXMcGCT6nZd0vf2eADlNmx4j+Ua0f9QT+ZZ95Kqcze4wLyt?=
 =?us-ascii?Q?TT8OLqqcBDZAvt0z6tiZSzf0Foa5+01XOwISdWspFvrqD6SGnVEb7wU8WXRn?=
 =?us-ascii?Q?e62n6ZgQHmFX0DqLhsVdv0pi3yb1lNWACUxpl/cprj6Ou45/NOnQDrA5x9jJ?=
 =?us-ascii?Q?cDfcTYeB2oxNm9b9OdFMcj2Zk8MupZUwEs9OfUQtkhFPA11mSnMbiNrCLVtc?=
 =?us-ascii?Q?5+tCbxVLyT8zFFYu4WYY011v5ZbDotyExWVCoxb9rOl1G6GWY6ltEfY/szgz?=
 =?us-ascii?Q?XCJOSCA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0329887E5A50041A473A2A75D7368D1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a3706b2-9f30-49f4-23a0-08d91bba14f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2021 18:07:07.7785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lCXlbR5w55EyFbgF8833NX4GMpxN+duxL1RnFBlx9HjB5sYypNmEpyvOSjK5/x9avc+ReiAegOvI+VzSQqxCbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4710
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: n5bUL1DinOm3oK0Wdko8ZtWcAl9_UACl
X-Proofpoint-GUID: n5bUL1DinOm3oK0Wdko8ZtWcAl9_UACl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_05:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 17, 2021, at 3:53 PM, Dmitrii Banshchikov <me@ubique.spb.ru> wrote=
:
>=20
> A table keeps iptables' blob and an array of struct rule for this blob.
> The array of rules provides more convenient way to interact with blob's
> entries.
>=20
> All tables are stored in table_ops_map map which is used for lookups.
> Also all tables are linked into a list that is used for freeing them.
>=20
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>

[...]


> diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
> index c62c1ba4781c..2d9e3fafb0f8 100644
> --- a/net/bpfilter/context.h
> +++ b/net/bpfilter/context.h
> @@ -10,12 +10,15 @@
>=20
> #include "match-ops-map.h"
> #include "target-ops-map.h"
> +#include "table-map.h"
>=20
> struct context {
> 	FILE *log_file;
> 	int log_level;
> 	struct match_ops_map match_ops_map;
> 	struct target_ops_map target_ops_map;
> +	struct table_map table_map;
> +	struct list_head table_list;

How about we add table_list to struct table_map (and maybe rename it)?
I suspect that will make the code a little cleaner.=20

Thanks,
Song

[...]


