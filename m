Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13C03507A9
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 21:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbhCaTya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 15:54:30 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52524 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhCaTy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 15:54:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VJj8Z2127949;
        Wed, 31 Mar 2021 19:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PGIS4vP5BB9k6N2oYAPO3ufUTHvcpTMs0w4wLEQ1OS4=;
 b=L8OziY71TluRwlFspQ4t++QjcxlpSbwp9OSkX5jbYKq2i7KMLsROSdAsKCaLkQwOZ7m+
 OvY1yLULDDKp+3aMkBoZPc9JIreHKnL1nj1EAge/HvBSA6D41EGDfsoalykbqo4d4vKS
 8b+xMnM/gqpZU2fyjgZGd4BJ+lp3b1kTUIT3Xj6Ry07tWicAs1inqdN2FFa5l1Hi4s3n
 jybRpu0zHcWpC3IWirKj6ASK7dCHGNmeobIgW6ru1kGXFWettboOMvugitlbAgcaSQim
 4xh4Er7CsiHdt9/21/kf2kbCLI1TPa7CHshvylbi8ZmSv9RFWUciDuhSzFHkybec3ovT wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37mad9ufsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 19:54:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12VJphY7128938;
        Wed, 31 Mar 2021 19:54:20 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by aserp3030.oracle.com with ESMTP id 37mabptt7s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Mar 2021 19:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJdrgFaVS7eehPxb6lB5prQjX7ugp0HbPPUZ78LypNbyCxfYwODe8xBrh1g8kLMH/rSLT7Wd9qJdV3f8mMJwxveS34h2/NKcJwLGPetmq6Ty+1uu++0cZ9LDrOXSz1pn3U+9wZ94+MpERm02IzJvqP+5FijLXVGJQXWiov/zLr1V9Yja3VcAd+TAoA5Uv/HZULhskDpjoYL3qOuA2OZkGraqqfgJW+N/Zmdp3YxUlGQnpLXKoe42l8CH9nStfG5WNNjLmDabBqAp/VsSGHlCrtTkWDRRISp9ow9Kt3/sPRfiuVD/wtgBEVDjmo5PLIN+9S7nOCDa3nZFZ+ManSuddQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGIS4vP5BB9k6N2oYAPO3ufUTHvcpTMs0w4wLEQ1OS4=;
 b=Nm7Ainu47oswJeud9vIPqzDs0/MNEzvAb1Wp/YMnXOlr8CdDV/PypPvW/C8VCQ48EkwfKXiy6HujBo0elVxyS326RsvvCkv86jAPbfgJL+4OqysgjWsUFWHfpQVerK0qrRuONH6aZpCLnwwz4Q7y0A7BXpAL9fzdgcrawKosS2F5cPR3l1/M/+6zcfO+DoHPEYNt+y91+AuKhuO/MB85cMGjknEbF12L3x1w8S2k/7Y/zJPXb8nyD4cHQlzlWi3yq+OyZ39hMF0zGaoJTohWGy2xMVrTNfXXToulK4jAwY6dGahv6iOQ2WWv1VwKBHF6hoTUWD09o0xKklSShp5fIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGIS4vP5BB9k6N2oYAPO3ufUTHvcpTMs0w4wLEQ1OS4=;
 b=rCs/JnUPS1r5C2DnMELyr46v33LbJx4DW4Cgbc9Tx7V7SjEib4PMgRvkhync7TrCXYIQde7q2mjC29aON2JjvxTOFHVc/EDhd0dBPGpR2s+b6/0QYrQ7XTNOlSc1tz2oO+SQFutKuLrLzBpSa5xBcG4w9P4YASw0GYTt/0XiJWI=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 31 Mar
 2021 19:54:17 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::9ceb:27f9:6598:8782%5]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 19:54:17 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Haakon Bugge <haakon.bugge@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Topic: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Index: AQHXJl2/BwuMcDru7EWjNiXXpoc6NqqegUe3
Date:   Wed, 31 Mar 2021 19:54:17 +0000
Message-ID: <BYAPR10MB3270D41D73EA9D9D4FCAF118937C9@BYAPR10MB3270.namprd10.prod.outlook.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
In-Reply-To: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [69.181.241.203]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 246ec8d6-ba76-4d73-30fe-08d8f47ec4de
x-ms-traffictypediagnostic: SJ0PR10MB4591:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR10MB4591F657F6B440A1E01F4352937C9@SJ0PR10MB4591.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3hYkA9if56tAl0DRVvXr5HO9x3e5spGMsznKw2HRt4Ck4feXGrIdLNSjANDp6FGXRbuX+Q4cTm/KToBlfqREL1U8bh77SxSgHt/TNXCXhBVFZ1EViyzf536AuliJeYcYkm5TRl5zmLkX2yx/8lBJWB7hVdtg3BqbP8JlaBpzLxbOCSa+629Pug7Wm0L4SwXqZLnGFP0Xjk+ySa2g/sXVV2F7cWLjXZI1ajLtvHng0YOqL/iQYYbM2QvjWgWwZsEaYz6SpC4Srf+ww42EdNhCCR87DQ5Xgq6Ghy3t0vf186mpl8qymAHP1g3YkOct8V9zNcTyLuMafAAwucW7JfTZijjzAzwBOHGHDSoLSGuvDds2OlsKsy+/2wV09L+dTt3DvBbUzOv+rjVQAqEtfiv5JL92qAoCMswzgiA5WIGU4p9xnHqdbIsBi/38dAeXEFJGXykKpHT9wcCp0GtRa/yFzIqAvOQAcRGxtPohCcHE4+yF/I+81Y4koGQCwUCOHVvw9Kx4QSQNvu9ao6oaOYb6HpL9JxQWiwfAD6LqAr9rvwomnxmNYmsqCcLYGX6HIDQQo5q1mi48QlldWQWW+NH8tmdNNaJut81MDxKAA/IjsMVmEUu7nSSICu144pPXSyhRI03I0OM5BnkPsYCJJPzygHyPlky7xKERiLaTwd7n7f8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39860400002)(376002)(346002)(110136005)(316002)(54906003)(66556008)(8676002)(2906002)(8936002)(5660300002)(558084003)(76116006)(66446008)(38100700001)(66946007)(64756008)(33656002)(9686003)(66476007)(26005)(186003)(71200400001)(55016002)(6506007)(52536014)(7696005)(44832011)(478600001)(86362001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?Mzsmnw7tsKdNdjSfbeW67xEibuGhT4waXcQtR2eawJDp+3HvEHraMULbtP?=
 =?iso-8859-1?Q?RJXYkAMbpH8gIZpqBd+DYmY7ns4rehvzMmC2xfslydojoHO6GEURRfaDHa?=
 =?iso-8859-1?Q?oGIewX5OWLuXayYLxg9Pl8CqH0hFHjiQvJvSuZnTxVQRtCGHZoRUtubQLH?=
 =?iso-8859-1?Q?6eCOwfr116Yzgz/d1ONbNnANQTDw4xE2/fV9ed+Mffnu1MXDLMKaPG6ZwA?=
 =?iso-8859-1?Q?FHE+rSShXmWliGPje/W5c3heLB7ZPRW8lfF/cSV+GwYGg4jV2SurT9q0q4?=
 =?iso-8859-1?Q?nXslEuarl6mawGJahNdTF+I5bz2Z1wIYQtuCj37A27yBRZTnqYaxQOFGDB?=
 =?iso-8859-1?Q?kPEB1YBtBn+Bp/1qZSY4U7UvCvj4Ed7J2jhKuckRoY37E3VD5c5VcUw1xx?=
 =?iso-8859-1?Q?Gfxx314qU+NxMITWiEMzx/bZ6ZtPHCbPZp+XFUUCZwnvMabvolvdVEuyDL?=
 =?iso-8859-1?Q?NrFmvCrrf9B38PxX1BXP1IwemNN+aiVh817lnjUVC4oC20oOzvj9BL1JUX?=
 =?iso-8859-1?Q?ot62g1PvxiQVTcptks+FWTDH3mNsL4n63r9Fq8XI8OJp0Y1mpUHISQG/3G?=
 =?iso-8859-1?Q?2307Oe/R8BnabQfyqAmb0n4RZqvmc7aBpsO81ruaWfyQ+vNAfFcmznmqdh?=
 =?iso-8859-1?Q?Y39jmSCumf5mBEpEib8xyJEwTnlDK1riDaCUw9ZSovfW/dpIxSUMCjyoPA?=
 =?iso-8859-1?Q?Man/eqa8XKApKv1yhNA1JU7grqaUl5jSGf/p+9NSLe6Hzvtvu3I/sipFKL?=
 =?iso-8859-1?Q?u2ZRc026zmEPq6lBgp4q+r+kDdQFc/S5VqKy5HOJUrTgqtyKyD28z7+y/4?=
 =?iso-8859-1?Q?/XVaeoKvtelyXIg1AZoAaUfstcw0MINNzUgYwZ26Z7yAI2J13EZTinN7U9?=
 =?iso-8859-1?Q?wiE0OledjltDMIvzH1DHqS3qXbYlA9v/YeWqPUyzex1+wStdoZxop2p08O?=
 =?iso-8859-1?Q?JLAOlzWZiuxWv9a6+Abdo6zd1yGvwnFEIzc/u5Io9gRPArSWUWWIjDxOP8?=
 =?iso-8859-1?Q?jwOi0zUA7Qn18bV6zPDzLZmBexjk9e/nbSHD8JIGXBYXt0l4dn77EMSkAl?=
 =?iso-8859-1?Q?jcYFCezHMWTumktUjGOYWI9JPpGIfkkf5INKy4wbCStnhCGmfqcm97A+pP?=
 =?iso-8859-1?Q?nLr/pLLMEvGA0PqMjRRlfgvspPu7ZKA8KHX6WEt8oURmcgqrdRTwgGtqHA?=
 =?iso-8859-1?Q?Ee0Oy2Godj5AXiGmY6RQXHYcPz6ZV3+GdbDd7yfzBfTgxVjJdcn9L7lrsW?=
 =?iso-8859-1?Q?G9FFlDCE4dnrHRz2dqwEBUY7x3xCK6K0rc+Y2h5riEj4R6D8A5MnSOXKg8?=
 =?iso-8859-1?Q?jsWITlD1MYTiNKUEB53BT0PFLLOGwl/XOGpoy7kcQRqqHoFnb0vxUMv8a9?=
 =?iso-8859-1?Q?KX2B8TYuoG?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 246ec8d6-ba76-4d73-30fe-08d8f47ec4de
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 19:54:17.8188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2eN40ZUVYj5nCzh6pHv41aSvz5ONjndwBBV6Ble8PZ2GMBqlS5iDZkjMCuhp1q2t8hYHIu0ocTX3KNAwDBmsrRHGDUExcIMeuGWo9EXr5vE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103310137
X-Proofpoint-ORIG-GUID: xTXUmZA0dTfcGZwIPcYmg9ZJIm87o5WG
X-Proofpoint-GUID: xTXUmZA0dTfcGZwIPcYmg9ZJIm87o5WG
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9940 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0 adultscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103300000
 definitions=main-2103310136
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]=0A=
=0A=
Thanks Haakon. Patchset looks fine by me.=0A=
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>=0A=
