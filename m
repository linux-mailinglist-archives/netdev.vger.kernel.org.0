Return-Path: <netdev+bounces-2433-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BB93701EF1
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DD22281089
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 18:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50E96FC0;
	Sun, 14 May 2023 18:30:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF60ABA24
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 18:30:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCFD3593;
	Sun, 14 May 2023 11:30:10 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34EAn4i5026484;
	Sun, 14 May 2023 18:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=rlgIQsa6fk4e+Gw5Ey9aKB9t2B8uYzQyxz5SS1kwJYs=;
 b=i3nIkJXQx0ANbvXciOsJM4nKKb6AHQjEKxiDdfGOZcWu62o5GRAjboc/NdCz/K3kbJij
 KQvm4ECS1uTIkPes9tztWIjRzbigih2VyAOXAtW3iA5Tj3DdQzVWQXvc4Lnr5r2hG4NV
 w+Pz934p94Eo4cOqDwiD96JlddSky1VGPxL2a000UuMEK81sR4jeTCMEVpAmGAsj5SML
 9TpBWgBdP+vkptBKXWEE07PFlsOFDybu885YZrqDvyjcEAGHvMXHpSgsXT3gLuDpM8ZV
 XMMsUxxzihEHoES1tJduBwSmCQ3kwjGHkfMij2gKq8lcSgDWmvaHY9Da+vS8uWKYnF+u 6Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2eawj7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 14 May 2023 18:29:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34EE9x3O036693;
	Sun, 14 May 2023 18:29:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj1082uwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 14 May 2023 18:29:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjarHTb3WWuPX2uNf7mEDnBq/TTTaK9lioBvTZf4DKn5y5T+TdS22NItgOvOSQRUTiZmXT3tLGIn8U52bIaR3Dt+TwjO+mA6p4EJ5oeypwnBRm7BVwEAJu99vIthKUSiuwKb6zwWmMw6/JUJ3eZBpkWch03QtUOTnWAnvraeweQkBaSipxfFqnShdeM+b9akXWKERV/iYOz2Vhyr289sifBkWXWLTotV1H1gIA8fCUNJU6gLgJpKxHU5DwnqlRSlgxKt1ww75Md50A8Q3YdDwCf1ifREsbu5zoIgFJkPWiwTxB4mABqRuVDqgezFsOpqYX5PFV0+2rkbq05glYxJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rlgIQsa6fk4e+Gw5Ey9aKB9t2B8uYzQyxz5SS1kwJYs=;
 b=aKUNh7OV7KyfGyyWhROUD+jSVafuNigxTIW0bM4Cvb0bGztk7CgTXQdL3T8AFMz3oRGJU1s/Rx3P1HftfnJBZ12uyXn6VnkiIlDQvT294RdOzOMh7i6nppyYz8clqsXWwDzLGprgjVSAcyLLEpHQf1X3xdnfX5/6usmuTENCkx2ahi1+N5aVWFPhPNzg2AC9VkmlAs6rQcUlljxeNGlcnnI+JKBNoor54R/0g9iZ49LIxxBqVIZHyzeyVuIRI4YK3mFyKGl4QRFjB66/Yva/Th41jfIBcId/WWyHOZMhohPIaWWitZiNVDqKK7QWxgYR4gYso6ecQ2MmHg4B6aIT4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlgIQsa6fk4e+Gw5Ey9aKB9t2B8uYzQyxz5SS1kwJYs=;
 b=CQVZP1Xvmm83cfSS1pT3EIAkTDfj+nIukfiuCDF1PRx4YSQKpAdGBfCqco2kHCW/+L9PiOs8kzO2KAeGMpSd8D1Zo9RsG4B11BhjjdXuQFUmXgkjQ2cGlL9DdS4T7VvAj2KJ+ZFit1NYqcZpNdYoBc9/eHHCNHunLwz4MyEcsDs=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB7692.namprd10.prod.outlook.com (2603:10b6:a03:51a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.29; Sun, 14 May
 2023 18:29:47 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6387.030; Sun, 14 May 2023
 18:29:46 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Ding Hui <dinghui@sangfor.com.cn>
CC: "jlayton@kernel.org" <jlayton@kernel.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Topic: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Index: AQHZgMQOKc4fcioBR0q2bzqWePFl4a9O7x4AgACpTgCACoocgA==
Date: Sun, 14 May 2023 18:29:46 +0000
Message-ID: <53664FF4-A917-46FE-AEA7-45F31CE1CD88@oracle.com>
References: <20230507091131.23540-1-dinghui@sangfor.com.cn>
 <EED05302-8BC6-4593-B798-BFC476FA190E@oracle.com>
 <19f9a9bb-7164-dca0-1aff-da4a46b0ee74@sangfor.com.cn>
In-Reply-To: <19f9a9bb-7164-dca0-1aff-da4a46b0ee74@sangfor.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB7692:EE_
x-ms-office365-filtering-correlation-id: a521be4c-0ce5-4195-4ddb-08db54a931f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 FGMxtu6ZoNeyYvneI2aw0h6BFDlteovTirmASs8mqeStPFTb4jTZjeTTLwkkWrjtfVC0Cdo3khGa6012Gbvo9HLjQtOAK8dmY/sz6faeCJS7En9loWGi12TzwLv8LajVT7wSo/wVupsY9IQsRoCgESrV5OAsuFoDHtDlEbdp3RyhhmuctBVhZcZBWnynZ5za68YYofwb7tHR7bTEB3KPzwJmz1PWdizjhcPasNPjK7mMJcZhmsXrXVDq9CozPg66Xqw/krUtNiHAXrv0xUQOzBhKoGllI44a1VFQtu6FuhzmepHE9TD2drngvpzaZfXC2B9/NTBLM+LZrejdLCeen0xyV6kUUDwOuaOJ1P80nXCeE7qvs5BdzCsONMxU6vFEu3sdDmlXsJJVeQNw4v5vmLCs06bdgi3ylfIBNtLXpRDwC+VQEicMqOQa08Ne+XaFTGSmXwivUnpuAqKjVK5RrYnEHZMwlYASViTmbmyCVMN7qcDgPSvS5ZVMn/gJFhnxBK9OoA+xo3g6ny0uZCTOl+0w/9hpm/zvtaaOO/hqX1QRXfWGZpK8EX07im5RVmFZ3T0eogPOJoUMAVcvJ0VdXpbUxYO2A+sUuIbegPRwxJrwLBQS76hbYnyYg7TpsyAPMEee0wrLZpZqSK3HhPkDOg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199021)(316002)(36756003)(64756008)(6916009)(2906002)(4326008)(7416002)(66476007)(5660300002)(8676002)(8936002)(41300700001)(76116006)(66556008)(66446008)(91956017)(66946007)(86362001)(71200400001)(54906003)(478600001)(33656002)(186003)(53546011)(6512007)(26005)(83380400001)(6486002)(2616005)(6506007)(38070700005)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?ttRv9gAyFzcTfrq+64bvUWgH39De1o+Ed095h+iAdKQnP/zrcV/XN9OHZIRi?=
 =?us-ascii?Q?TBpq4v7K5ROnNxEHyloLaCZC8S2SebZkCWqKou8uwv6DRgQNM9zjA52ZE2Oz?=
 =?us-ascii?Q?egi77eMHuIpquA+JBzSCuINfDDfYeDJ97PB/1ZjtlyTW+258wWUilLKPy63A?=
 =?us-ascii?Q?5oY+yxPytGd2QxAuNDT4XWLnsfraj38bZalLyh/kuxs9XqYL9muXxzrwDuxX?=
 =?us-ascii?Q?doK99iNPa09nWB0sUNE7xVzJ84X9laS2HxdCIgL92xaTUV19FykTXeFqoWGu?=
 =?us-ascii?Q?ilxDcOMveXxxYWrQ6OKubk7JjPnLNlMF5CwPncQBCo14qlZG1tiODj44mRmg?=
 =?us-ascii?Q?F8+ZpkudP8YHXfMF0r1n5QOkhOau4Jj5QhHC7lxwVrlQGazRklXcEOSQq5ni?=
 =?us-ascii?Q?vvQToHR6GY2gyk4nTUMVfPGllU9qf9p+g+J9goG60stM2SJVW+UxUWvZXgZ7?=
 =?us-ascii?Q?rIaKdXy9nJ6JYyS/o8aKxq0Jr4tNYDm5sNmDlGxQUb/HTSYZqPyNFZXXwda5?=
 =?us-ascii?Q?Wx/xzCum/yNQtnY/zR23H5vtid/tmise2ZoTlRhAsm/gfFmTmKTKquPZlwbO?=
 =?us-ascii?Q?2nIO8S7Q4FBT7gxlAQz3M2/Wht4feDkYJHs1iSdPIJT8Ad47ySzNNP+5l6yy?=
 =?us-ascii?Q?OIKkzKWodtyDzZF3d/fbeYQpzfseCBhvHritv2NxIK+GUALV3LHAHopIwY2d?=
 =?us-ascii?Q?IZSnjDzB/SJsTKav/MhTBdZ7QWMflMLhdAHzV2NGaBNx9/Y1WMlF+4bw+PpF?=
 =?us-ascii?Q?z3t0l9+6o9inXnWxOb5k42nKQMJMhizQvVMkfAOlse0sw8rE3p4qBzN3PIH2?=
 =?us-ascii?Q?WRe1eafiHjTKskOKVoBtSCAQsE+Jv1lsDP6vsDgBmbNj8yMR+LvdG+N8x285?=
 =?us-ascii?Q?XEVMAOG2l4jXdR6Rt4f+2+9bt+4OZUPqDQ12k3QEUxzZdPeLwQszJvGz03YT?=
 =?us-ascii?Q?oh0cR9VkE3+LdO+xr5j14TkYbkwrMMxfBRaNaL7lI+F95SV+omEtt2obmOKs?=
 =?us-ascii?Q?sEi9X4udZ84hDILazV0SHlJckFSEIuKdlqHYLSRbGObPj9NDqIzP6oYj4m80?=
 =?us-ascii?Q?HZ0LtBwoFmLQsclFp+S/AzIlcvIDfgdftLPwzMv8Mv/Jj6U49yAXB/K7d8Vm?=
 =?us-ascii?Q?WIrD+mCniep1kvYi9udcrbW6nhiHnLNoxRmiCbsFvWWAkfiwXC02N2XBsF6R?=
 =?us-ascii?Q?TVW5w2jW7gjyE1mlkd4nrwurquApQC1IwzWE0JAdFtPIh8FNkUo7x9UJEWE7?=
 =?us-ascii?Q?C+POZGHsq9yY7ueg+bp2nLw0BdUddjCqBHQFFmElAj0RGBzUYfmK31c5ITtL?=
 =?us-ascii?Q?RmaN40/IBr10Dm5uZgMvcuvgS3G1/AiFiYf6jXvcq8VV9JcKROwgOW3W6Wbt?=
 =?us-ascii?Q?HgbiCgxLhG7DkvCeXlVL/aRrnfKY0NDXuHgIqOFb7AvLfXkAvgNp0GAz28Dv?=
 =?us-ascii?Q?IXNoFdO+YL6cXxZp6DgypLfDKdcb3raXT+YAf8XJAg8c+aIugEtCUtCvE0ZF?=
 =?us-ascii?Q?P80tMeMd2zJfMrHHaMwUhSszMLp0WFtG8QwoOpHe17FbYhh+uEQ+xTZYTMFF?=
 =?us-ascii?Q?hFmxZhCosjsNxzG/9BpPh8fmB9XbK9s/5CJtxqHV5floetTLFR1AmeNYHmPY?=
 =?us-ascii?Q?4w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <566BC7F8F0930F4CB755EEF35DD230B7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?TeROo5TuqbgJ//9xF0gm3XBHY9WE/6IXJr4k1mGc/1dGoPPhBrS0DIvKn+eh?=
 =?us-ascii?Q?KqCvhFFqK7m40EiOqWF9eOWHkU9Mp7eSlMkOIesfWndjfH1kPyO26FgfuEOB?=
 =?us-ascii?Q?1Q+04lzN3xMh2DY9hA86iZmCXNooU7jj2KfxohAABXr0Mrv5HedADBFH5qt5?=
 =?us-ascii?Q?XIw6qyzKXUvtDAj6mED7veJoJj6oEsYvhHXWx1wJXSLqp/kgDqXKijzdikzC?=
 =?us-ascii?Q?4wLvEGe2GO7N9CqZ+FksVnFvPRPlRpX5S7qXGkl0WZD2Dq70nDZzjcZhgrsz?=
 =?us-ascii?Q?sDg0k4D+nbiyh8EW1LcXpZZpxfjxdiQ112ZTCyE/NJax2JcrbA9aL3oAfNBC?=
 =?us-ascii?Q?ZzXu8u8RxWyLAIUjEn5Y2l9nF5fuFCB6ZrirQwNFhqEKScClfKLo1ksCLfQN?=
 =?us-ascii?Q?txxl8tueVenQFM8ivsmwZTQwWrxiIXCZsPSFSIUVjmrLL9bLb9jWDTeRnbcS?=
 =?us-ascii?Q?W+WPp59u2+/x/pKI1gRDWF4cZGIaxTpCSR/bOYLUMtWIK6HfGWbOnSqXhRS1?=
 =?us-ascii?Q?l1vL6crrrQsBMrCYMQEmus5HyKoiH5XbePsn3B5svujegn3r+cDF59Hb2C5l?=
 =?us-ascii?Q?vd1tLvtQOfK3vz8Q7G7owvIuGjUL9oH1bO+OjwMb98VJqIaXFbrqkkFNhAbV?=
 =?us-ascii?Q?10vuw++0M6KcvmfTMBXGNUl6rLDDf18FxLYnXAmApJ4f4t8VBrIIhVBAt4jp?=
 =?us-ascii?Q?29Z1s8NbUs/ewa95N5wrT2fhuTqiw7pDsqCvz230o3c1PFip7A8bnodsw1b/?=
 =?us-ascii?Q?umRfwIye2ewrhNfoSl8RAadLFewiCsIwKuiJWsqV3CEdcQ6WBdXAIQzetFel?=
 =?us-ascii?Q?7EIUFNhaPls8N29Efm0NH675fPl3qn8n3PVxHkGpOysPOjbAG0y6SfQ+O/qm?=
 =?us-ascii?Q?UITnlhNg/NYN/A4AdVlTwSiJAv4NX6vqz9if2x/AW4CaqIjgGvBdBOCfWtOh?=
 =?us-ascii?Q?QMLmlQ2kgrHN8nMi+x2EDw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a521be4c-0ce5-4195-4ddb-08db54a931f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2023 18:29:46.6662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g7Ne9g0lSfVLF9irYgKEFP5AslqfCeyFIKSTukLwZOhsX5AsV4rWgIeZbHsHpS8N9NxkUT3ZrCx7K/OmgjECcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB7692
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-14_14,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305140171
X-Proofpoint-GUID: DlouYZ-GrDJwcHjiZ3FktAX8fufU1lEr
X-Proofpoint-ORIG-GUID: DlouYZ-GrDJwcHjiZ3FktAX8fufU1lEr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

[ Removing the stale address for Bruce from the Cc, as he no longer
  works at Red Hat. ]


> On May 7, 2023, at 9:32 PM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>=20
> On 2023/5/7 23:26, Chuck Lever III wrote:
>>> On May 7, 2023, at 5:11 AM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>>>=20
>>> After the listener svc_sock freed, and before invoking svc_tcp_accept()
>>> for the established child sock, there is a window that the newsock
>>> retaining a freed listener svc_sock in sk_user_data which cloning from
>>> parent. In the race windows if data is received on the newsock, we will
>>> observe use-after-free report in svc_tcp_listen_data_ready().
>> My thought is that not calling sk_odata() for the newsock
>> could potentially result in missing a data_ready event,
>> resulting in a hung client on that socket.
>=20
> I checked the vmcore, found that sk_odata points to sock_def_readable(),
> and the sk_wq of newsock is NULL, which be assigned by sk_clone_lock()
> unconditionally.
>=20
> Calling sk_odata() for the newsock maybe do not wake up any sleepers.
>=20
>> IMO the preferred approach is to ensure that svsk is always
>> safe to dereference in tcp_listen_data_ready. I haven't yet
>> thought carefully about how to do that.
>=20
> Agree, but I don't have a good way for now.
>=20
>>> Reproduce by two tasks:
>>>=20
>>> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
>>> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done

I haven't been able to reproduce a crash with this snippet. But
I've done some archaeology to understand the problem better.

I found that svc_tcp_listen_data_ready is actually invoked /three/
times: once for the listener socket, and /twice/ for the child.
The big comment, which pre-dates the git era, appears to be
somewhat stale; or perhaps it's the specifics of this particular
test that triggers the third call.

I reviewed several other tcp_listen_data_ready callbacks. They
generally do not do anything at all with non-listener sockets,
suggesting that approach would likely be safe for NFSD.

Prior to commit 939bb7ef901b ("[PATCH] Code cleanups in calbacks
in svcsock"), this data_ready callback was a complete no-op for
non-listener sockets as well. That commit is described as only
a clean-up, but it indeed changes the logic.

I also note that most other data_ready callbacks take the
sk_callback_lock, and svc_tcp_listen_data_ready does not. Not
clear to me whether svc_tcp_listen_data_ready should be taking
that lock too.

The upshot is that I think it would be reasonable to simply do
nothing in svc_tcp_listen_data_ready() if state !=3D TCP_LISTEN.


>>> KASAN report:
>>>=20
>>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>  BUG: KASAN: slab-use-after-free in svc_tcp_listen_data_ready+0x1cf/0x1=
f0 [sunrpc]
>>>  Read of size 8 at addr ffff888139d96228 by task nc/102553
>>>  CPU: 7 PID: 102553 Comm: nc Not tainted 6.3.0+ #18
>>>  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Refe=
rence Platform, BIOS 6.00 11/12/2020
>>>  Call Trace:
>>>   <IRQ>
>>>   dump_stack_lvl+0x33/0x50
>>>   print_address_description.constprop.0+0x27/0x310
>>>   print_report+0x3e/0x70
>>>   kasan_report+0xae/0xe0
>>>   svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
>>>   tcp_data_queue+0x9f4/0x20e0
>>>   tcp_rcv_established+0x666/0x1f60
>>>   tcp_v4_do_rcv+0x51c/0x850
>>>   tcp_v4_rcv+0x23fc/0x2e80
>>>   ip_protocol_deliver_rcu+0x62/0x300
>>>   ip_local_deliver_finish+0x267/0x350
>>>   ip_local_deliver+0x18b/0x2d0
>>>   ip_rcv+0x2fb/0x370
>>>   __netif_receive_skb_one_core+0x166/0x1b0
>>>   process_backlog+0x24c/0x5e0
>>>   __napi_poll+0xa2/0x500
>>>   net_rx_action+0x854/0xc90
>>>   __do_softirq+0x1bb/0x5de
>>>   do_softirq+0xcb/0x100
>>>   </IRQ>
>>>   <TASK>
>>>   ...
>>>   </TASK>
>>>=20
>>>  Allocated by task 102371:
>>>   kasan_save_stack+0x1e/0x40
>>>   kasan_set_track+0x21/0x30
>>>   __kasan_kmalloc+0x7b/0x90
>>>   svc_setup_socket+0x52/0x4f0 [sunrpc]
>>>   svc_addsock+0x20d/0x400 [sunrpc]
>>>   __write_ports_addfd+0x209/0x390 [nfsd]
>>>   write_ports+0x239/0x2c0 [nfsd]
>>>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>>>   vfs_write+0x1c3/0xae0
>>>   ksys_write+0xed/0x1c0
>>>   do_syscall_64+0x38/0x90
>>>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>>=20
>>>  Freed by task 102551:
>>>   kasan_save_stack+0x1e/0x40
>>>   kasan_set_track+0x21/0x30
>>>   kasan_save_free_info+0x2a/0x50
>>>   __kasan_slab_free+0x106/0x190
>>>   __kmem_cache_free+0x133/0x270
>>>   svc_xprt_free+0x1e2/0x350 [sunrpc]
>>>   svc_xprt_destroy_all+0x25a/0x440 [sunrpc]
>>>   nfsd_put+0x125/0x240 [nfsd]
>>>   nfsd_svc+0x2cb/0x3c0 [nfsd]
>>>   write_threads+0x1ac/0x2a0 [nfsd]
>>>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>>>   vfs_write+0x1c3/0xae0
>>>   ksys_write+0xed/0x1c0
>>>   do_syscall_64+0x38/0x90
>>>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>>=20
>>> In this RFC patch, I try to fix the UAF by skipping dereferencing
>>> svsk for all child socket in svc_tcp_listen_data_ready(), it is
>>> easy to backport for stable.
>>>=20
>>> However I'm not sure if there are other potential risks in the race
>>> window, so I thought another fix which depends on SK_USER_DATA_NOCOPY
>>> introduced in commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data
>>> pointer on clone if tagged").
>>>=20
>>> Saving svsk into sk_user_data with SK_USER_DATA_NOCOPY tag in
>>> svc_setup_socket() like this:
>>>=20
>>>  __rcu_assign_sk_user_data_with_flags(inet, svsk, SK_USER_DATA_NOCOPY);
>>>=20
>>> Obtaining svsk in callbacks like this:
>>>=20
>>>  struct svc_sock *svsk =3D rcu_dereference_sk_user_data(sk);
>>>=20
>>> This will avoid copying sk_user_data for sunrpc svc_sock in
>>> sk_clone_lock(), so the sk_user_data of child sock before accepted
>>> will be NULL.
>>>=20
>>> Appreciate any comment and suggestion, thanks.
>>>=20
>>> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead=
 of open coding")
>>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>>> ---
>>> net/sunrpc/svcsock.c | 23 +++++++++++------------
>>> 1 file changed, 11 insertions(+), 12 deletions(-)
>>>=20
>>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>>> index a51c9b989d58..9aca6e1e78e4 100644
>>> --- a/net/sunrpc/svcsock.c
>>> +++ b/net/sunrpc/svcsock.c
>>> @@ -825,12 +825,6 @@ static void svc_tcp_listen_data_ready(struct sock =
*sk)
>>>=20
>>> trace_sk_data_ready(sk);
>>>=20
>>> - if (svsk) {
>>> - /* Refer to svc_setup_socket() for details. */
>>> - rmb();
>>> - svsk->sk_odata(sk);
>>> - }
>>> -
>>> /*
>>> * This callback may called twice when a new connection
>>> * is established as a child socket inherits everything
>>> @@ -839,13 +833,18 @@ static void svc_tcp_listen_data_ready(struct sock=
 *sk)
>>> *    when one of child sockets become ESTABLISHED.
>>> * 2) data_ready method of the child socket may be called
>>> *    when it receives data before the socket is accepted.
>>> - * In case of 2, we should ignore it silently.
>>> + * In case of 2, we should ignore it silently and DO NOT
>>> + * dereference svsk.
>>> */
>>> - if (sk->sk_state =3D=3D TCP_LISTEN) {
>>> - if (svsk) {
>>> - set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
>>> - svc_xprt_enqueue(&svsk->sk_xprt);
>>> - }
>>> + if (sk->sk_state !=3D TCP_LISTEN)
>>> + return;
>>> +
>>> + if (svsk) {
>>> + /* Refer to svc_setup_socket() for details. */
>>> + rmb();
>>> + svsk->sk_odata(sk);
>>> + set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
>>> + svc_xprt_enqueue(&svsk->sk_xprt);
>>> }
>>> }
>>>=20
>>> --=20
>>> 2.17.1
>>>=20
>> --
>> Chuck Lever
>=20
> --=20
> Thanks,
> - Ding Hui
>=20

--
Chuck Lever



