Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D4C36950B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 16:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241174AbhDWOsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 10:48:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbhDWOsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 10:48:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13NEjEWu039654;
        Fri, 23 Apr 2021 14:47:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OrbdPwNVu2NMqQgWL9JXXveMmsrST45k7l8Acz3HGs4=;
 b=rjvsn3+03/7PuUBh6buKaUJJjVgjhg/kKhfkUR2xzXrzUrfhHcm2Sbo8TElQ3z4/qgh0
 h9rWBJkKrrEx9HEX4Pd/fojOPGRZbzs4rLRXL4O4JS1HWiwmBKgELR0uXyUsVKKKDDNv
 xCwGRp5XQBaGyDytfmEuyXw57BxjzqOQkQzYXmSeLybUYgH3lanI1cFv44lQUCRMZeld
 vYmP+y/hZ4HmtNfuineWyKCVlcDdfWarVdO9PdDkER/Ye0C1DwxR6KMq829Zohmpxtlg
 AjwNa2NWH53GAbFvrnbKKIyC/rfonx1zz831fzzwujUZFexCzUj/XTOnYl9ZgkgBbjgo gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38022y81fp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 14:47:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13NEVXhw116698;
        Fri, 23 Apr 2021 14:47:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 383cbffc0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 14:47:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FY6ALk/R0oFU3ABKSYNYvMi4l+yIJsquMKthyQBGk1+nFj6lWd00ozkDCT6OivSTFCgcnaM8Kc/jSDYOtArPFKbxK2LaXRbCBN9EeOE0NupUnwph2nAlN6zURL8QxT5MFK2WCc5nbn9Ga2D/fpM58LDOCktKeOCpJCu7FLiYSl3Zrjb7s28+NM/sULRJ1VBEKq1DJubnJ4krrQ6mj7ABTeNt/0/LO7Q+faG0P62TGvF2vJLjs6D5a6pg9xSRPlBsULVuzzqv6uYqirFs1yyNQleEd7F+qGN2y8XMN+S5mbehri1d2Kh0UMF9+JzaIY+L3uw2YYEiYwdbPvnXk8Ad2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrbdPwNVu2NMqQgWL9JXXveMmsrST45k7l8Acz3HGs4=;
 b=HgtLvrRdjVZ61MYoUesyxRMwdXrxq4GoCxL7SEKA51jBBfdNdo82XLtVpsPt6SVOxfczw01jMHDBJ1zqSMdNpuBviQ+QLJ65sun7BirUzm8DPBS/y/wrvdatiYG3FnfFCON5MAYfpU+mywMxL/DML4i1QAwCq9Tkby0T5MUTzXOr+a9WmEEdSDMTVU+qqWzX+3ucf0IQHj53qMOPAUSzU2MDcAScE407C0iAtao6Obs/oey6QJR3uGIYQLED/BdH7bxXqzxCls687kG4MzzTnW7uTL83ThUTtt0yi+7Sg2USH/d2kXGrlc8U/wr/UJvu+jhx/b2hpw4c84259mAfBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OrbdPwNVu2NMqQgWL9JXXveMmsrST45k7l8Acz3HGs4=;
 b=ZYecWg13j3tlmtWHj8GN0cjCFirow8d8GQuIfA8dXepnhJrOrZO6EVTkM9/aiGWAx2lyj8mSEikCzlQLUy5FbWUYIa7XpVDKZvT8aMkXPEey9J1cZ+LLwT7jNwOFlSiW9VD1B9VnjVSnVgJR4E2X1h69TwdbsemPojwswI52KTg=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 14:47:36 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.4065.022; Fri, 23 Apr 2021
 14:47:36 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     wangyunjian <wangyunjian@huawei.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux-Net <netdev@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        "dingxiaoxiong@huawei.com" <dingxiaoxiong@huawei.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH net] SUNRPC: Fix null pointer dereference in
 svc_rqst_free()
Thread-Topic: [PATCH net] SUNRPC: Fix null pointer dereference in
 svc_rqst_free()
Thread-Index: AQHXOCUpcR6pJ5Q1Yk2ECkU3sxPVUKrCLueA
Date:   Fri, 23 Apr 2021 14:47:35 +0000
Message-ID: <29D47981-00B6-43DF-A5A0-917D4AF87BE7@oracle.com>
References: <1619170978-15192-1-git-send-email-wangyunjian@huawei.com>
In-Reply-To: <1619170978-15192-1-git-send-email-wangyunjian@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea0c9cfa-d802-42f0-fd6c-08d90666bc00
x-ms-traffictypediagnostic: SJ0PR10MB4591:
x-microsoft-antispam-prvs: <SJ0PR10MB45917F13033DF2CD9A6ACDE793459@SJ0PR10MB4591.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yIgb8KNY1ewjbrWLo1KEs6Mke+pyARayFtQbxUVp026mm1yZFMTXg8mNMNxS5ilE6F1XYRXx/77V7lEoyRP8vwXSwmjlgPzoMIYW5aMQT0Wgwjf+/nXtD2uWkwo4GVnRL1/hWrjl2KByvSsylt9V5AA9W7+kUeGi2LS+rynu7tEWyPY0H8t43kTZENNuoidnN+aBr3YEtLuTp1Ux6hHdHvQu0cz8SwvuWAa9URYD6o5hcWm7VfE6tKEvTPTulTcxHcgkYBl3cxHEc1Qy/gHwjh1ErtTh8+6nwzko3iEgyawNbF2huBmN4ljO3ODjxjDbAq2EJsFIdUPJNW1vxYZz+Ef4y5NP6nNeOa7iKLx7RjlFYYRl8mk47hfNTMx2d3ZPve8BxxeJjCB/QaGYG9LWdBzXo5HkUEZVc6QS569RWrHx0K5z20J03KjRSIsiEbFKUSp833e9TSFBgICc0cfC/bYVi+7jKbylPK+VFV/o+90rCKXll6j9Fk8KvuD9nSKrEQaPY59TX95CgqYDYyv+Q8gP5rGULGn9qnTV+l5vmqiUwbEBrMl9jBtQNRrUJTxrYvlTBSigeJyI4fQSYlTQkZfOdlMuBpQZ1Tvva4KueqRzOOdqgXFHFo5kKG3fPFtTq23axqeCtEjT0EO5egbLXpMQd8bOo/0FxyLDkH9VSD8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(36756003)(186003)(122000001)(86362001)(26005)(71200400001)(6506007)(6486002)(53546011)(6512007)(38100700002)(6916009)(2906002)(83380400001)(76116006)(8936002)(64756008)(66446008)(66476007)(66556008)(8676002)(33656002)(66946007)(91956017)(2616005)(5660300002)(54906003)(478600001)(4326008)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gfSM/1xtfBYRZKsmKz911mNqDwHTY5aCZFCwr3so0/37mFh5K4n3Ohtjr4AP?=
 =?us-ascii?Q?8dYE6OH8Z/fB385tiCVwwTanPhlwlsO/qa5Hs0EO+5/1Bl3SK+g5Z1zcIK6z?=
 =?us-ascii?Q?218YMaI0koXH5auG5u9xNfWUvI8iJiJ28yKkqcSEG+zbkT5r9oz/gv80iyit?=
 =?us-ascii?Q?W3AGwAwTw3hRbO4nl68Uxun6OfNPiWjNqt1OBSxx6xVM2CKsCQPhkDc3chfb?=
 =?us-ascii?Q?PrNRNJlaTwTJjzhJ0zFaQlj+Mazp1sqhtIMtmtcGEOwHnabvvUZjf7Aiku3h?=
 =?us-ascii?Q?wkBDu9Tx4wNPzOmfskSQoyD3JSqCrr/vXBL5AvxaH8N11ddGm8EEF1/A1sw3?=
 =?us-ascii?Q?u1P7pqUYf5hjUiAT4Cq6f24SmDIVSPYLMZQRSAuWM9+CKXp09Dh9ndeC/FVs?=
 =?us-ascii?Q?qXsrLmAQR3kulO4QsYvQj04PlO7dc1PVrqRtw8ZoLNF+ayrCAbRLuafJAGEm?=
 =?us-ascii?Q?+D0Hd5bKbe1M9mKD+xkb5yJ6ckv/v/4GWQ56XoYv/eoZTzDQdTzibBQUFo5c?=
 =?us-ascii?Q?4DYv9AEbLsPu/yRMYxu5qqiCJGDPa4NrW+aMJ/ib/G1ngZW4eQG5lr4r8nXk?=
 =?us-ascii?Q?QH1p40wCBJ30HOM+PPre0NkXwEd9mkrUNamIIVfBNNHiIde6/miTfNbZF0vM?=
 =?us-ascii?Q?1wLhgk24Pli3RNJQ7maDxglRH9JIDQ46DzdLKLhPsbrMcI4f/yv5aq03zzLP?=
 =?us-ascii?Q?RXyfmSCkwQvng8wwWJS6uD6utKT+fPhEB5eaz5q0cbqBLysJaMV8tp+9S1c6?=
 =?us-ascii?Q?tNrHE8boaBX/zS9+jnFFhmEau9LJO699lLX5RvhlewZmKt/mIU8JCiLHcMEz?=
 =?us-ascii?Q?mxfAC5aPXAl5nJJhchGly/rLVkIUZPMTvmOBo+5/QVyMqppGpP2oeBM/N2oX?=
 =?us-ascii?Q?5X0WBXw0dhAcX/tk0TXifrp+0TqE9Q39aDVg/trWE4MIG41FpIo3rHJN5pIz?=
 =?us-ascii?Q?Pd+ap2zG4sBWBnFHkPQIx8/sBhhELMl8W/u7U+LQy3yMhm5B+tjC6XusVCXg?=
 =?us-ascii?Q?EFWm7bO3GAhiHC05pT8aFbyufCxC4CJhW5V8iFGqeqfT/NRVU0Abx0J0aWVo?=
 =?us-ascii?Q?m4U2+wTSSfFiMgAPWB5RCI+EE/P/OkrqD9pcR3TFGjNot0sc4O2aHk/dgfbo?=
 =?us-ascii?Q?Jiw9TBuJqht0X5HfRBvYFDvCBeWCf3KVGowcAPCL7eB8D6whap9fmwrE5uM9?=
 =?us-ascii?Q?Qc/mKWPszoc7VYi2yS6TH7wefJnChJp7YMsa1aX2AFvS+b7qSMRx8pcl4C/M?=
 =?us-ascii?Q?47Gb/jpnEQ4Bf/K2GJCvBBMo2FAvEckSXpS5D5G4tuQBNKKCvBAy+alSiMIX?=
 =?us-ascii?Q?SyjPR93BUHxQEdrzWHiKgwDT?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5ADEA9D27B81B4C8948ECCEE5B029E9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0c9cfa-d802-42f0-fd6c-08d90666bc00
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 14:47:35.9023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZH5vgI60WG4tU0nnYyeCx30Lil8Z+msqhUwd/tf7hETDYWVPaYYLuzej2SsAZbWNeeDSqLoN+9PAwwBxEHA+Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230095
X-Proofpoint-ORIG-GUID: bYl7Amke6kg7BG67tG71IcI4nDpYlycu
X-Proofpoint-GUID: bYl7Amke6kg7BG67tG71IcI4nDpYlycu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9963 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ adding Cc: linux-nfs@vger.kernel.org ]

> On Apr 23, 2021, at 5:42 AM, wangyunjian <wangyunjian@huawei.com> wrote:
>=20
> From: Yunjian Wang <wangyunjian@huawei.com>
>=20
> When alloc_pages_node() returns null in svc_rqst_alloc(), the
> null rq_scratch_page pointer will be dereferenced when calling
> put_page() in svc_rqst_free(). Fix it by adding a null check.
>=20
> Addresses-Coverity: ("Dereference after null check")
> Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on th=
e server-side")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Thanks for the fix. I've pushed it to the for-next branch at

git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git


> ---
> net/sunrpc/svc.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index d76dc9d95d16..0de918cb3d90 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -846,7 +846,8 @@ void
> svc_rqst_free(struct svc_rqst *rqstp)
> {
> 	svc_release_buffer(rqstp);
> -	put_page(rqstp->rq_scratch_page);
> +	if (rqstp->rq_scratch_page)
> +		put_page(rqstp->rq_scratch_page);
> 	kfree(rqstp->rq_resp);
> 	kfree(rqstp->rq_argp);
> 	kfree(rqstp->rq_auth_data);
> --=20
> 2.23.0
>=20

--
Chuck Lever



