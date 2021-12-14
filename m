Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E916E4749D2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhLNRjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:39:39 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:5058 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236657AbhLNRji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 12:39:38 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BEGYB2I024960;
        Tue, 14 Dec 2021 17:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=LPEV437/J59RSntZNHuUWLr7CITQnV5ZU5cENAcPTtI=;
 b=yQgOfrCqT8ZF81/fAisA+toMr7W+w7dCa2N6e2/QqCGHoXq+r/z9oprofZHGF7UeeIK3
 K0t7DYwaQB72C9WPpP9ffdzQgOdic3rBpnHlyDQXpY82nhuYPnhBkIDmfdiiWMqDUzmv
 CbaMIChwoysZEgblBBeBltiAbP8JBQT34s2lim1ZxFFO5RC4knbqCCOOx8XMY/jjfbu4
 GwpvTz04jpS7fi+r6De0Y0k4PzJDFHb81IjPo2A0L9kduCD6dX3RuySCln8JaUJtZ95z
 qiAyaU0l9mxz6MeF2X0ibO2B+qZcmIa0YHNZ10x+yPtCvf18m3Z2+M/ZCwmS1EKkhhXJ fA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx3ukch4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 17:39:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BEHZMnr075496;
        Tue, 14 Dec 2021 17:39:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3cvneqc1a0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 17:39:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SSDm4fQA8IKuYrGfMAfBBvsoU6F+W0Pr46Sou0A/i/Yn6sYqgxf95OYIFOBa+TzRm4LVprqUpduXAtu95/PMNEtFFMx2LHJIi7aKr2YVww8Zb3x+VT9pl+dczfA9e8bIwIV14zKAtHH4R54YZ124euxr/9NNN8IPGOlrWY2UpvdQgogYnvn+pl5sv5fbW5Mz/c9wR1k+tj3M/0Su/bH9vjfglShGKhqHXKcorbq1rswVdT0oHRso2IWOAYxzRoDrrTQxNAUUJt6naopcijhGsU5RJVrwE3l59+Z3tmuhCjZZ0CM/AiwjZA3msb5Fq/GzCTdui0izAxXPc183uuXtvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LPEV437/J59RSntZNHuUWLr7CITQnV5ZU5cENAcPTtI=;
 b=GJ5PtAnidvx3k3SGl4Gkgh5+ll+gCjH9mA59gcYG9d6JwxH8mc6rWN6NhwQ/aPaaGR99Vli2tBt6ioEHl2rfdvKZqptCutQsNjfKZJl2yfTQBlbbToHmfIba+HlsV2/dV9tp4+lxGeTkM/ER/izjMWeMcVbdT2opOI9He0yXDXjyXcryRYqeUSosMpQJFVX66yNosQHXgmZZGLM7yNrce6Fl3pCAagW6RxVL217BHTT4ev0jFJ23LeXWQerumZMrWtxDfhX+qwDcGQW11niUvkyBxh8AfymHcy3IMjKGbPqsu28KuobB69BFR0XlTtO2yCljBU9794hq7qpCpgMr/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LPEV437/J59RSntZNHuUWLr7CITQnV5ZU5cENAcPTtI=;
 b=Jp6NLFIPIrZBcYcE54DmS9H0aZDR+4WvbE1FhOHNJuxLOyDCao00eNaVK8RkKrYZINV7fuo4Z9xLRrZ96NOLN7KPhZTDXAuX4b/vhP4kLQnv3VOgQTXqqtBtd6LvaW7NsktRgK7wBbbx6kF4NnXsFqIEpei/+V/vzQBx0PZCUDM=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BYAPR10MB2712.namprd10.prod.outlook.com (2603:10b6:a02:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 17:39:29 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::4d1a:c742:9add:800b]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::4d1a:c742:9add:800b%5]) with mapi id 15.20.4801.014; Tue, 14 Dec 2021
 17:39:29 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Hangyu Hua <hbh25y@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] rds: memory leak in __rds_conn_create()
Thread-Topic: [PATCH net] rds: memory leak in __rds_conn_create()
Thread-Index: AQHX8RGLrqo/nlvnAU2xcbmPLjHpsw==
Date:   Tue, 14 Dec 2021 17:39:29 +0000
Message-ID: <017A6000-BEAA-4684-9A3B-BE7FC40E1DB1@oracle.com>
References: <20211214104659.51765-1-hbh25y@gmail.com>
In-Reply-To: <20211214104659.51765-1-hbh25y@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e870c76-87ec-4d7d-d5b9-08d9bf28ae80
x-ms-traffictypediagnostic: BYAPR10MB2712:EE_
x-microsoft-antispam-prvs: <BYAPR10MB2712CC3B88DCB17DECB063C593759@BYAPR10MB2712.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:478;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gys8qRBkJRi7+4x9Y3+ZEos7cM9A17uu32mH79X4HM8zEapBL8hfdiW4bRsNrbievh+81BnGdxsCTcVLOdA1G+VwxXvVn6hEVu3TdzHCksHgMsUMXyk3qPvB+8hB0ggsjyrXm91WcpgBj0NVzPmdb6TjgovFBHdMUg2PhdmDIAAKFNZZR8RsZu/U/YSs6b5P/+j4kMb2/yguNzl0RfL7EhAdwF6MlFECVkcFzB77eNCEoFgja5XKkzOTr07/r5aRbKsHdg4JyPzmlY7U80ASAKjRTVQOwFlxKwA6npg9XU1wsVDRi5IORgz6WgtwcwoRdDECNu8QcSHrIf4bp6MkNTjIUdmPeE3s6FNUOxsWEcZiCh99Qa+AklBDmRgcTerg6n3pelGA4mWz44IH8QKsklZaLWAuRvJHS806tkbSpHxuluaPhXgGzELZdWw2teCUV3SsQp+06TytPpbp9ajIoF+Qybt76xwgWj6w05+GRA2Ou/GfyiFGuMx6g1rM5XnEwoVOU5DZqtvCD681S8tw9tmPHB4CuHWO8DIT+lVjILEXD6jTr5JBwZl6bqmwhvwZgNc9Bjog7PEqRVXhivfB2AeZHZKkEjzI9ACubjJiFI9h1c5zDHLiZ2ii5TZcBUIRvhLDpUTDBbVAwIx941x5WcvhDAZcYtMezMPQwALBThptQevCpQ98LsnGHYPpBaICciCTavnZDdANq0YeP2CVM95AzYunSO5iQFLMjjYnQorNce7IBswO3Lx+d+eVo06f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(91956017)(76116006)(86362001)(6512007)(38100700002)(6916009)(44832011)(2906002)(53546011)(4326008)(36756003)(26005)(186003)(54906003)(6506007)(66446008)(38070700005)(316002)(64756008)(2616005)(122000001)(66556008)(66476007)(6486002)(33656002)(508600001)(8936002)(5660300002)(4744005)(71200400001)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8rDy3pfIBdnC4hh0Y54GT9NQXNBHRFf9snkLsWinqpyH+VLxePQv+12PyrWz?=
 =?us-ascii?Q?N7dhL/iErrlkr0YvSjznZ8y/4qXhvNVJC3pfdenpnnN0pzDMZuIiHvj89K2j?=
 =?us-ascii?Q?zfJA2n2nTUu4Sy45FaN6SdfdMWDFql/SfgAv4kj7b4pFhHweOlMg3LwPdCCC?=
 =?us-ascii?Q?tPH2XyNDVSbhk2tNfN6ff8uBDBcmsKJti/qp5P1fcEI9FccuPTtFp4l7QDdy?=
 =?us-ascii?Q?OtlVNwOkMUtyYNzBmb5lVJcL5aep5FdFRWsgG5RRuTGaA6lnDoIuljwZPh8l?=
 =?us-ascii?Q?n7iIZCTre44goR9N/5jE8nZMyADqQc5u5ZRkP1Wf/jhzRlViz8FlLbc19nsW?=
 =?us-ascii?Q?ON7LZmDZxo89rt7cr9m+/EZMf5r3y5FxBmEIbqsSbESkUrzwQcHLEj5sWt72?=
 =?us-ascii?Q?hEuWGFL/ffvtAs3SKR9YJOU+LYtDeDRNcMbg6f7ExjKy152Rv07Czs+A/vPF?=
 =?us-ascii?Q?I9I9sbcmn3HS1WcZmC1vHP3r/WBGLKE2rpdVN5h2fZ+f5cLsfmPsk0T6uiiW?=
 =?us-ascii?Q?eEb9T5og0wwelUbaU+Xw3BEbbAQfTuaseRROFrAIpwzcJHsNWn3DNm9cIQnc?=
 =?us-ascii?Q?TjTXTkaVULTmHm8WHEnc27KZ7vvenRYkApkJfZDa8WeokwWhQRMtzc8325LM?=
 =?us-ascii?Q?iGlXXWPMS3ZHDJ/DaVuehz3iq+qnIbpE5bGIvwTqs2sepHXDPhxdrqx3iQ3u?=
 =?us-ascii?Q?4uMbsdtQ0Y2NMNLcOzxPOcIPbmWgrjLiXsTnEa+hJQUYbLYD4BRWoAQlAKe7?=
 =?us-ascii?Q?f+4Sb81yfS/gC4897ehDl4u0zw62hbkYDj2n0Nms8wc99gGGPvFMq+ydrb2N?=
 =?us-ascii?Q?lIer0A8DjYnYJsNuz/cXVGDI905Kq1KUF62/AMVxQNw3s5L56CbaUMQo+z2B?=
 =?us-ascii?Q?kQxTrhqOx16AjriLEnER8BoWmXtrAJaJfubUiPyKhAMKF5EivGvrWnRXgPpr?=
 =?us-ascii?Q?IkwINBj7lN4zaQ1M5MTjVPPLM3/416hUyn5VLwH788zAmheGaqAm1Bkg+1HI?=
 =?us-ascii?Q?QSGa86VUK+/lQIiJht3cWglJGKxLapKKT6hlTCtMo71IAJk+X/1Zm+7dS6a3?=
 =?us-ascii?Q?MnPhda9bB+wXz0wENu8fkRadOJ88CrmjyvG3Lt2+AUK2aYkSs6W2RnqECr1A?=
 =?us-ascii?Q?uxiOGbPfMUxYFdxVcrcMyMSMEVbA0M4FDXwHEekAvaldqI5ht6j8V+Vx/ECA?=
 =?us-ascii?Q?SJ3jSTLXV1Rg9XMMTU3vLeqg+5ALiQp4OQVbu4s+VLEkP1d1Qu6YYRVni+1q?=
 =?us-ascii?Q?vtn6x1vmyWEn3JWMs+vs5zfHBtBNmNlml9yYd6QvqLqGSjKDihKcgBo7NOLh?=
 =?us-ascii?Q?027kLnJGoGGEJtON4MZqgmfwn12q2QybpYlDKaZ93dyNBnj0cmEDk550dKPu?=
 =?us-ascii?Q?ubjRaUqZCKULUJba9dCFhdPkW8VWXcai8Q5Rr8ujtValQDS4vqWKWUOXNlHp?=
 =?us-ascii?Q?P90S9reRWKX21ns9KqxqOAl3ahsD2NlOy7CtL4V15UWP0KabvvIOLQZCg4rw?=
 =?us-ascii?Q?rcKfwRJs5vIw6cFS0AdBIUooYN7+THOYqW62mfKv69q2O6e70k+ZXbHFQAIZ?=
 =?us-ascii?Q?+mjDmjV+SDdw/m8pJwDuKJFYNSF8wE2kb1NwEiLrhX38lViwjQuG0Y2Vxlhf?=
 =?us-ascii?Q?i0kBdk6IcJGFrskbnpwtCwaYTIutzLroBQVu0QAOWI9tzNV7QrQ7Izer/zAa?=
 =?us-ascii?Q?8/4BHNFgIAXyNxxzM9RzrWNm/Us=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DF7AB20FE8934F42B404D7D6A3B99E08@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e870c76-87ec-4d7d-d5b9-08d9bf28ae80
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 17:39:29.5505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /XWuGuG0hNd4TKcRShUx/FfmUOvf4WCNnh9MmOnbNqa/n7kgL3eZOdN9eFuTBBCnnBD0eRW+xR4PCL9wnRz15QxS6anOCdqVcUmP/vZLTk4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2712
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10198 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140096
X-Proofpoint-GUID: J-PotTFzge70GfyWXKD2vLeVZIy5Z9YX
X-Proofpoint-ORIG-GUID: J-PotTFzge70GfyWXKD2vLeVZIy5Z9YX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 14, 2021, at 2:46 AM, Hangyu Hua <hbh25y@gmail.com> wrote:
>=20
> __rds_conn_create() did not release conn->c_path when loop_trans !=3D 0 a=
nd
> trans->t_prefer_loopback !=3D 0 and is_outgoing =3D=3D 0.
>=20
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> net/rds/connection.c | 1 +
> 1 file changed, 1 insertion(+)

Looks good to me. Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
