Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5AA93EF099
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhHQRH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:07:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44574 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229700AbhHQRH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:07:56 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HH2l6a024901;
        Tue, 17 Aug 2021 17:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qjZ9ys+JPRFV04GL9odmd6AXaf6kwCL+y4XOZN8uX10=;
 b=U2or/9J5tlluwqhxSX7WfrA7rPOxaOml6eP1u20exrWAwUuqrrizsuz6GtIWFoMl4dvh
 Bg3QbmEhT0ZTdgkwLkvJXRTuZxMLQduURGKREwPYERizhaIlpGkp0LUaA+mFiLxo+MR0
 Y2c9suVI59BUUuXdv0HnhBYOVyX+3NlOHxmdirrEfZJlT0IAXogbfwGC1kSuPJ9d5tnY
 gSZFAvt7Uk7ScbJzVt/IxA05pZDj8PtSDZ9CGNo+wF6X5fi7ShztU6M8/oYSfXlxoXJS
 OkUptSJvLAtF3phywOtrDchif1wBRA71PGHmn+ntz7bLdie/eKb3GpEk1UX5Sc4JB/ha +w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qjZ9ys+JPRFV04GL9odmd6AXaf6kwCL+y4XOZN8uX10=;
 b=I1KgiXBPloYlW8yR0ywHzStH+7CdfSfnbjNiR//SAE1dzsLzMjLWhi5GJ8HhaO35EE68
 sTnIxVq8M9ncL2rNtPYiLiBc2Fovc/4wR3SvG3jwxnLUm1x6n92nh9x7p/gBvd1nMnh7
 +ZCBsTrl7gKH0OkHd1S+4m3PaxBajci2471F5rhLfWJWbLbs5rHVAGcR8eNgd+zw0Txr
 2lt4w2HBqpfo+F5khMDknUj+Tpt+7lL/5wgr/slvx9Ci4q97Ynbg1pkRZRgTldus6Xke
 N5RB++Yjjgg81uCYTBNn7EP7LiOBL/3K2MSk+GFT8k/IMP9LLJFzxTR47pIAGgScXRo2 VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3agdnf0qb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 17:07:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17HH6mAt048303;
        Tue, 17 Aug 2021 17:07:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3ae5n7x0q8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 17:07:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBMaqslzHM0LGfN6w/HYTIzlLKZwG+c7Klbxx+wrhWUowme+Ne671Ok4VR+nXztqyx2vqjtzvVg7U4g5Ka5uoMVUR6Dtp1YBiWmKKXqkU2MIM13xLF4BjZZWlKnri8IDDj1qFPce5tkPMqWwJgTZwpEg48Yi9gIq0tzZnkDLoVVnP6t+DL0rrnvFB28BQkswfHkB8JEtwy7P3mgbb1+mhludgWHc7be2oWbP1t4tqltX3ntzlrX5ofoSBu046QrM5SOdh7jM1ItHKX25UoYcNsyS6iVT5kujdz7dlj9RZ83bZW4MKu0L09hOuzIQivq02vAwDXhgFv1FPN/GMV63xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjZ9ys+JPRFV04GL9odmd6AXaf6kwCL+y4XOZN8uX10=;
 b=Q5FIDiFw4ny9KSR6L4aPf/wu9rJjitu5eAqUyCQfscba+bIBJBOeH3ZCwaYLNMqh6ujIc6KqlVGtRWTBzWfbtfj9hYgNxuG7v67ltRPTL8GLXwG3riSQ4BzE+59aCnVYQpa6AKvCVsPmbyv1Y1v3Gr03mciZ5kw0C2wC21bChFfUyAWgJ46REwbsipOK/dr+vf9gwwD2rcVQB35TxBnr1AaMDJ0aKOkpJXm4axDSMypDyzYz74SyhIX0gSji38kxAQRv/xeJMgXKQSk+Rz5jIM/1NDttl0cwfKshQYSmdMifeaip4IX3Dz+dvpDjekLWsGNTO3AgoY5fzpmV9F1tsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjZ9ys+JPRFV04GL9odmd6AXaf6kwCL+y4XOZN8uX10=;
 b=WdO8xDIN94YVCstnthJDHJ2wfXwndDLEK5PoNbbfuAS158UA2viFodv7owQz2PyaZteuznYkn2AupTJSIUDb7v/8JzjBsDLnI23ua4uPd5NyotCMBB227BuqP50SRnc+B0evDu7cjdXHkOjoZyJitXjPpTw8KF/nFuRDheAsu/U=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BYAPR10MB3032.namprd10.prod.outlook.com (2603:10b6:a03:82::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Tue, 17 Aug
 2021 17:07:19 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::5d51:1350:5264:c4aa]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::5d51:1350:5264:c4aa%5]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 17:07:19 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Gerd Rausch <gerd.rausch@oracle.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>
Subject: Re: [PATCH net 1/1] net/rds: dma_map_sg is entitled to merge entries
Thread-Topic: [PATCH net 1/1] net/rds: dma_map_sg is entitled to merge entries
Thread-Index: AQHXk4n6vvyaeDsKTk2p1N/6M9JyMKt37ZQA
Date:   Tue, 17 Aug 2021 17:07:19 +0000
Message-ID: <30038EA9-7220-4FBC-8601-50D226244722@oracle.com>
References: <60efc69f-1f35-529d-a7ef-da0549cad143@oracle.com>
In-Reply-To: <60efc69f-1f35-529d-a7ef-da0549cad143@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c873c1c4-2bbc-43c3-7165-08d961a178c8
x-ms-traffictypediagnostic: BYAPR10MB3032:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB30321BAC1729F8DB3F5891EC93FE9@BYAPR10MB3032.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:175;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sIyk2+Cc3yye55hkYIvdk+g+K1Ddgdcu5DtNTQ5D92CAeCsFD8kDaottL25pzbNyvYQyLB8XR+FIT/1olV1lK3E6mWdmkxZH/IYYenCgISEvF48KWWxDq/15mN4ZXU952EVu5N4sa2Wm2XDE+z31OKJFLt2AUlisNmUwP1QNaEO1DozgiDWwEfJh2++sraZdp48jGztn75jIZc+CL2dXc4PVN6G9a4HOI9k7t4pH0Lc6w3xc2b+HMPks3jHgK0qNpZSo6YHvjFl8vt04p+SU3+kduBQb8LeDMTw1xYnhe4XPmAWtc3VTiJcuKR18Tp8Nb6qasQ/sNGZCc0FoQ7RV/PLjRLTfRm+V2qaNDeVEKyCtlIOy2Lae5uRihjo48nyDlmVxKmpDnesojIIX+roIY/5o00Wof5w+fECsYSq8o/XszUiTjKdVK7poe1sZ4nAXvxKF1BqEDnSeHEMU/oJdUN2LBD7BX0CMgdx6kjPkIELCQflaCdnzKPJ5ilKioJMbO6ou8EBtw16ns2HD+cwm7Dp9GrBJTlu3DUOF0GPF6tTOtptV0iWtxc8FeNki4kfrhpLQ36Rr4XbehHO49oLj1hhGzeoiMcAIlU4vwuLyB6yZghqN6E5iKcqDsvZT6DlB19UoKYiydwjN5CTa1G0TlJ8DMf5lLLrIILJZVZusBb14/r1LKi69Z741in03o7XSKpufpQ+TbyZhrnobH7c05QBIZL7+F3SSF8cew0keJsvMKhz6hdzap6a68q1Tmtxs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(26005)(66556008)(86362001)(66446008)(8936002)(4744005)(66946007)(5660300002)(316002)(4326008)(37006003)(478600001)(186003)(53546011)(66476007)(64756008)(76116006)(2906002)(33656002)(54906003)(38070700005)(8676002)(6862004)(6506007)(83380400001)(6512007)(71200400001)(38100700002)(36756003)(44832011)(6636002)(2616005)(122000001)(107886003)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pswbh7zsYiTFcFz0D67JIda0pkejoeDbLShx6DfLyg5V+KnWgNxfsSnoAORA?=
 =?us-ascii?Q?7YLn7faI6zA58YiR6AChPBB/Q7rMyiIuiTc/Cbj7MU3Ze/35AfKHTP+D4rlS?=
 =?us-ascii?Q?VKYsjlPN93DDUWn1PfYO36yh5gYkj2p6IU0jSjwIPRVS3SShBp44C1zpPHOT?=
 =?us-ascii?Q?D3g7hPZzO3GP5fuH53X5FMhgZwMtRAVe+/y2F9uW4KAN+2plkLMqoD5+BqgK?=
 =?us-ascii?Q?CAwQ6Fsgm17dtLiEIdd0z5pThaE5KVzk1mNSPMIKRGgVyIJpcWpo4sGq2jGn?=
 =?us-ascii?Q?p7dFi3mOOwRFRw6nF/MnGCpr1bNTKP7Va4U6Nii+VWf6xGQ7crFPKaEZAMeQ?=
 =?us-ascii?Q?5PAxdfOkTS4OQLbgV+u81QgJrvYhkvg3KOdT7V8GPhb0o6z3GiohOTylk1uD?=
 =?us-ascii?Q?4WUtEK3iiEqfQ40OqwcvPTkJO8GIWlV+V8bO55ccDjD6FDntHK1bNkEKtCuv?=
 =?us-ascii?Q?QN5q0irWOb4RuVQe6RdAcy/lXHGAzgCp1yVI3e6gyHtj4Q3WOsfw70ug8eFA?=
 =?us-ascii?Q?6c+JrtivemnCpDvP6Cv19veLMttbUq6FRoDPgNdaJYaqbScxcWFs2TVhbYm/?=
 =?us-ascii?Q?cozCsXJvvU+57JzUuAubD3yd6/soeqXEeigJMwaAWfOqT4NYmYNLlh6USCCr?=
 =?us-ascii?Q?vIgj3som/9TR5OYRVjoCELiUDRaDcRrCtKmPHKPhUw2jtLAOneWl/FEncle4?=
 =?us-ascii?Q?/dkt58Ks8sM58/NEJQ5NTSaPVpZISSELO0Z/dTqoUUF7VaeaJO5qzexkeu8N?=
 =?us-ascii?Q?ryBqP6KiAJc+y+S4MTVVAibcuLNJeVuQmljO7fLauPPDHKxyEHnKIvfejuP/?=
 =?us-ascii?Q?vDbIrqovLnWSy3ALMOD8BNqde2j3fwgERNZfQQ5WK9LaTd1mAtg0eF6tkxLU?=
 =?us-ascii?Q?Fql8CpiGA3uAFyg6EzAwKzX/QzllkP2/KyHGLJ5omFKB1ogTJ0gsRhcwTAEU?=
 =?us-ascii?Q?aWYc++uw3ZgK2P7ZudpOTz6iovPuVTnKi3pA3yojIXPATH2BgPTbUWCElWl6?=
 =?us-ascii?Q?1oMbUUr4BH6ynTnwc/eICX7G+SaQISvTXqaLfA9zaPDs1Y0XNxOC3Pe7Z7Gh?=
 =?us-ascii?Q?qiPLBlKXaeBQwtSjDPXBfFYnUQyjdOmXRp42rD/Y6spAn9N/Es4uL0bulUoh?=
 =?us-ascii?Q?t71pt5oI2vERQ5928IvZA9Ppgc40fh8kdhIQMEcjxXkbkNqFR0uHWjXYpEcl?=
 =?us-ascii?Q?uB1d8WNknIgdgExjH9aZnVZQ3ch1OamzgbAwKRVBDRKmJArMNzCMqlpP9EsI?=
 =?us-ascii?Q?ymkrjWJ4GrJ3xqr7PlFBu8zj0UP/FAGqxCx/kiqAcW+jP7RQv6ANFDLEq/dn?=
 =?us-ascii?Q?3xncXPHhcva7aMT/lfnvZTUgwRpOWl0m8Gftcb7PAKpYeg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32F2E74157D5E3468121E6173C512D9E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c873c1c4-2bbc-43c3-7165-08d961a178c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 17:07:19.2387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VAbWYzvDd7L66r/2IKgtyBxw980dk0rsjlCVYjKRQZVWT5cjaMR3FfnF3XbbFcDK8eCKdnIblXeZwqvkm/XxYYAUG9TtQwwe+Z4mtKnkAc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3032
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170106
X-Proofpoint-GUID: Z0dXkGLbNUI7RHfRpK9ATWW9j2ujshD4
X-Proofpoint-ORIG-GUID: Z0dXkGLbNUI7RHfRpK9ATWW9j2ujshD4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 17, 2021, at 10:04 AM, Gerd Rausch <gerd.rausch@oracle.com> wrote:
>=20
> Function "dma_map_sg" is entitled to merge adjacent entries
> and return a value smaller than what was passed as "nents".
>=20
> Subsequently "ib_map_mr_sg" needs to work with this value ("sg_dma_len")
> rather than the original "nents" parameter ("sg_len").
>=20
> This old RDS bug was exposed and reliably causes kernel panics
> (using RDMA operations "rds-stress -D") on x86_64 starting with:
> commit c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu=
 ops")
>=20
> Simply put: Linux 5.11 and later.
>=20
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
> net/rds/ib_frmr.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

Looks good to me Gerd. Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>=
