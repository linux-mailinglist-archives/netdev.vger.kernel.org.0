Return-Path: <netdev+bounces-3097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38829705701
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:23:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC817280C23
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D75BE2910D;
	Tue, 16 May 2023 19:23:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CDF187E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:23:41 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8969F4C3C;
	Tue, 16 May 2023 12:23:39 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GG4eAJ013831;
	Tue, 16 May 2023 19:23:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=LapAl5lRGO8xj6yAAA3SrqGlTIZRxrZKPv2JkcrMml4=;
 b=ZfFJvYcydSpv3l61kxl58Cux8i7DF9kS26BR06xVCjVOQRval54V/Feg3iiuHQRCnpeN
 aHX6QPpR36lBLiCZ5+kkB7mAAsIHJfG/VmB607OVCQowD3f8gnCmbj2q0f/mgcSy6nWe
 yU/Cy6+IKfcrAp2oX3jcQ7ydCiPQQhhnnQnGh+2/XcftUYsZSZU3/7WRAA5lvQXwUqbP
 xhmZqstTbP5yKrpESl1DpvJF2+qbC08ZdD0qqWcevlb0nhYkdV+Ej1LiL86bPmQRDNln
 W+JP8NvP8CbOdlcEGm6xom7/y5DsN+Rz0HhbhxajmCnO9KjHTbdlKjm71fjQFs0Ku3hk QA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2eb3ja4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 19:23:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GIdZ17023863;
	Tue, 16 May 2023 19:23:34 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10as0es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 May 2023 19:23:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kk1Y1I9u2TJ3elNs6mFzJS2itOLf4WQG8AVRCU0u2o0TzSvAAqjNpTLEKbEasRdc4hSG/IsMY8jRYDrW3WwaoNIjyLTy6If1dIJJ/AgcffrA4ZwEznKjiykK2wjH1vmMM741hY1NhBL/mZkb7bTiavQFtbRFPBG+U1fSn0mHj58P9a86y/77rxsEJvm/mVjtVhGwN6S2N1vtVrfGyFMu6QQC0Hi+gHAK9uHEpCe98+B3R+fs6WbXpT/zaY+Yawp279v4jKbKROulCBMq+Q0iIsP9IBvIQBWfzxHr4Twm8FHBxnqBcQJ0Tk0IE/uGpkyVAW+W/hud2h+lk5P4NDXGkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LapAl5lRGO8xj6yAAA3SrqGlTIZRxrZKPv2JkcrMml4=;
 b=DvReblkIFbrzzXVpioj7qBYqARDFFQKQzVCv8IlnDU82xt3fJabuaaiaInwZ9pMQbebsrL1bxLqAkDl9tRXBUnnuU0Ps1SMcoh1nKx6r9/jhY37xaZ37PASblkuaIzILO2njRIsUTHXPRVOkcA7wvc36ypx+IicW0UYoeOyu0r2UvYPpT9zUKDKoYQhqNvbn7WdVbPpnnKcYYLywzTB5zq8UPKmN7B6mCwtai3JphL/w9uKga5DFtITBunaa5oZ45WDauuIqRAzrXMdLpEVgPOcEjncbiNkJGmsbzTJj9q2brDjH0033lQj3KPYYfp6TcU8bUc24Vx/fDYhg3zbZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LapAl5lRGO8xj6yAAA3SrqGlTIZRxrZKPv2JkcrMml4=;
 b=URiXWppK3XVaTfAIUUeSDJzjYWNHyhLFerz/NzAiOJuZ3BCC8ybl7omG8LTAHDVDhVF44VSo2W4o3+Bpj5oRxkoYJuNEzn1D2sFjE4eL7hDsvShmosoAynYrg4jsasTCayfDpzEenvCRVleUIWcZiNie88O7t6zepTOg7Hb3Hmc=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB4576.namprd10.prod.outlook.com (2603:10b6:a03:2ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 19:23:09 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6387.034; Tue, 16 May 2023
 19:23:08 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Leon Romanovsky <leon@kernel.org>, Eli Cohen <elic@nvidia.com>
CC: Saeed Mahameed <saeedm@nvidia.com>,
        linux-rdma
	<linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgBLhqQA=
Date: Tue, 16 May 2023 19:23:08 +0000
Message-ID: <DBFBD6F9-FAC3-4C04-A9C5-4E126BC96090@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
In-Reply-To: <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB4576:EE_
x-ms-office365-filtering-correlation-id: 1da7157f-6707-4709-ce39-08db5642fb66
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 smZQmAcblEwxNkBZ1FKAA7hvBmjyRWXvO16X71m/QJQc4U8KMptRXA1oDuUTA8RRRNuV+y+avvkvcnPsDSecO0X2I8dC8B7TAC5vUxaS1jhd4CzG7DZSBKVheNJDLQzPw7aBPwSMRCU2Kwmj2G459tEp+mPEDZbCSvDYQwb+BbKl6CxyOT1Ep16hBULjVYLu9pCvcE/e+L4f4J2e7/X++hE3zl9Rcm4xqU9ayBxa+mKn/zwzpDFogOUtsaMLOc8dKr/hHgcPIOXT7Zx9+/6hIHe2K7NrpARjZRelOuk3nhj8o6soBo8bM0OLzR6R+4nHygwg/GyMgLiBbUtWSASn3XEBYYv/dVcEtLyAgSRG0XziNWR/NGHuZ3dYIeHZdKzOGIH1C7YWyTohjg+5c7p2d7XnyqY9++8N0iftIHiI61aXnsJUoczX+LH65jqPZNp14CYVomYSfesYg6hRJbVmilLBWHxOsK20yQLcio/TS5aEQfAPE/bxYZ5jABSCFjE6Gj8OmR6PihwpOHKxFgc3zqqdnlrFwfFsAwwBteKgqh/bpJqRyi0v9MO0OHzHWgYLG6yGPbo0QUJL8EZlNIU3Ol7w73kWi5ybz6n00YQYSqpED18aNrLAPKItCin6GZnfsgqRRbhZglsVRP86yTCJiw==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(346002)(376002)(136003)(451199021)(26005)(83380400001)(2906002)(33656002)(2616005)(6506007)(186003)(36756003)(110136005)(91956017)(38100700002)(53546011)(38070700005)(6512007)(86362001)(5660300002)(6486002)(71200400001)(8676002)(66556008)(66476007)(66446008)(64756008)(45080400002)(4326008)(478600001)(66946007)(76116006)(41300700001)(54906003)(8936002)(122000001)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?JYCUFKMGjVUR7aiIYb4RSnPnbJQZ/ITTouJ9uXO4Lmu8aiDWeuBjNJWR3YhD?=
 =?us-ascii?Q?1vfSC1T3aIthDDPMMg8LfnWZx85dHQVCqM+UbmdMWp/A+nhTF/vX7kciMIDd?=
 =?us-ascii?Q?OMgPd9DefHJKgb3XKzVl3tvjMDP34wqIEiyI3E8OOVOX+c0bck5bEgVW8L4F?=
 =?us-ascii?Q?h7rB5l7qiW20CybGgx/jm/WkbusEAypo0Ei5+vEp26bMle9AqxiCVTxAC05X?=
 =?us-ascii?Q?hRIfWpP3QpG9bK42a2nAI2RM5fpNCVK0FZ/OrZ60y1IMNsQ37rmgH7JqyKUX?=
 =?us-ascii?Q?0wycrAagmRme5okeJANv03gwof0fRknRaiQhmrfYT490oaTB6ileYpK1tDKM?=
 =?us-ascii?Q?KnSZkd6qzwJs/XuNOMNE/ahDajZkstkKw0qoxgQKadX+zUqBydfJLgeD1YFd?=
 =?us-ascii?Q?lLxzeZnD+ChHHAlXI2Jxm6hnw3Aglm4onpilp7xbox94eIwaMRqK3UYqJAKf?=
 =?us-ascii?Q?L2YZV3kgKLKz21zo2hgEeR4z2xmeXY5kOhFakr7zAWx1zhuotjcVzM8RQkuQ?=
 =?us-ascii?Q?eGvpJlc7pateYKzdyvGfixjA6gZldyK6IsL+7PUHAmx/BhBO8epSLqebvDXG?=
 =?us-ascii?Q?eV6mA4gstQ0pzl5/39cZ1Yjqy28eItC7mfaBhxlKUHLJkf66XeeOZFo4ziKP?=
 =?us-ascii?Q?/aLd2Ww5Msn74PFeTROclwOcXbPBjHJFYaM6R5Rl5EGw9YqExHeuZVOq9f04?=
 =?us-ascii?Q?zXOQsdmCa32KdyG0A891K7r/oW/YmjHSCTQav7rNeu0dWEEG6tjNJl1Xkv/8?=
 =?us-ascii?Q?pkTAClXy6or5d4SxzC4KA6JYQnhSWSg6pNnpRjFCbJVbPrdfmbDu8DGczYFM?=
 =?us-ascii?Q?wCIFgZZRO6IK0UGySTZdvukFuJoqC4qO1Ei+k2IrgvH+OcyVkWejQvW4HOUR?=
 =?us-ascii?Q?eFUYb2zLRPtN6BWalsV4W1T7JBDjsF7QOOqve900CWQmKaSt3d6GzShb81I5?=
 =?us-ascii?Q?vsm7Q9iNcTn+KzfTeLEC8gG6kVXGr0UstNUoYyN34nZTjfZ3v3s63xqsm0qg?=
 =?us-ascii?Q?APlrLI2NB/yGFPTOrRu7JqtyVjtLa4Rou2UJvOliioZ0T3jo99NIe5FAjBay?=
 =?us-ascii?Q?6Wxl3SZm4FKrM5fpqDz5ruGsT3O/A3/bFEWgWGwdztTwVq+XOWOt7tC+neCS?=
 =?us-ascii?Q?g3M98gfMo2YbjYDzwdWnZWms9Jgnc98ZDNhU3ySI41avbVNqUSXxdHQZFV1U?=
 =?us-ascii?Q?G+UTRd23vQ+wi4WsTV7W/jJpnBhedu4e2JMyX+Buczpp0WnrbaSWLsjN5WZ2?=
 =?us-ascii?Q?k3vyWvbHOl9ucYqv+KBSB2MpbAjqUeb0EFlBUz5CBlc5mwbmopJife/9Al0t?=
 =?us-ascii?Q?F1Md9vhbSHLPG5RnjimDr0/JcSFiXao/je4XSvyv9OSKC5Ux2VHS3t5ybwcu?=
 =?us-ascii?Q?zBcYe5oHNGDcaKj5VjUDnpOCyhBjRc92r15IEkdNX7+AyhEmEe/pW4a12uRF?=
 =?us-ascii?Q?7lp9Y8/tu5nynQBi/cKv70vrkXTbrNnNfFFFdjzmNW9jzkFbWihECoZKUN4E?=
 =?us-ascii?Q?+iWsyM0d/Z04Vr5RFZBqXoq9sUTbueLV0NVy6IaIu5cIECkadBM4c6KUBM+7?=
 =?us-ascii?Q?v3cj8iw7gb63pt4vfAW/8MhuGRDUU3w+qXGX/Mt37PSIbmW7iCgdyindVf+b?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <543DDF921DE30E4B83C3B9969D45D869@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MHhx1K/3NKkRFfgDtRaW+U5hhs305iGMGFyn8TkSB+k7qEq8Pn/fTt2fpRfi763E0lsWWVzJlu3I5/zO5jwjIhQJ1R7I0Y/Fj1KoDzdxr8UMTCKKEmuZZVM1Hs/gkdJCnZJMMxKm2gDMNqt456QCSLhKNY8cisrlzpCKyksMjwEvEKtx1+4su/KyPrLwhfUAkvKGxtbqh6YGXxmKba//Y8mILpbgDUgEUaGAw6tIkaPaKTFLexhmUOqI9PwKWjIX8djMOCxNf8nCQFBt02DJvE80HpcuTaBLIGpprxc3t+3t7p3ElC5OTfGUuy9AiOjyencvVRYzyLJZOYDRtIHgfVtS0GijnE1n53D88a2mzpglfESlXhA0Ixhfw+AoFRxI/fWMIbqXixUj0hp48lVxDunPzJWIFdVkeOxn3P8UXsIZteBoQ4IieN/CCeIF6XCeQ/VfVfGJh4dsoqa/2Tr2mfqRbVGTR+e2XUKCdvC/3A8kCABMQ3IIH8xaKlwGB2mHZJU29V0y1gjJnUTcJBfxf8I0He/UPD7Uu6YUACdQq/Wuukw0NmhoIz7sqo57pH51PlfLbc22L1XsxLJtuWY9zrTlEB2GLp4RchO+yOKwzRXfq/gEXChk/MDYlv2foTCcTn+WCxvbfvJtqY7ww2wYDX/WGLQx9sOArxAU88LrZ05wwoKy6yl6Ka1+o/ix5Ys8IEdkNTeYudreLHaAbHExhqgbOBorO5rcWfIzCr4gMvaAgWe5SU2rMLoTI3gBebfpe/7i/vMci+L3bjVvFqxq9Xyo62WxwmuT8rA9PVh/+GLWuXblDORQcRB9xOd8j4NC
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da7157f-6707-4709-ce39-08db5642fb66
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 19:23:08.8616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fZMX0PiF5U4bhLLGK8kITorTQt0DvSAM2Mn+FDdF6IJHSNwjTeqMu/a8jylc2LnhxwuP6ryrTPFnAI79j6Hu8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_11,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305160163
X-Proofpoint-GUID: T4c6NFC4Nm1eQaqBEGT7c9ljgAjObxWm
X-Proofpoint-ORIG-GUID: T4c6NFC4Nm1eQaqBEGT7c9ljgAjObxWm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 4, 2023, at 3:02 PM, Chuck Lever III <chuck.lever@oracle.com> wrot=
e:
>=20
>=20
>=20
>> On May 4, 2023, at 3:29 AM, Leon Romanovsky <leon@kernel.org> wrote:
>>=20
>> On Wed, May 03, 2023 at 02:02:33PM +0000, Chuck Lever III wrote:
>>>=20
>>>=20
>>>> On May 3, 2023, at 2:34 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>>=20
>>>> Hi Chuck,
>>>>=20
>>>> Just verifying, could you make sure your server and card firmware are =
up to date?
>>>=20
>>> Device firmware updated to 16.35.2000; no change.
>>>=20
>>> System firmware is dated September 2016. I'll see if I can get
>>> something more recent installed.
>>=20
>> We are trying to reproduce this issue internally.
>=20
> More information. I captured the serial console during boot.
> Here are the last messages:
>=20
> [    9.837087] mlx5_core 0000:02:00.0: firmware version: 16.35.2000
> [    9.843126] mlx5_core 0000:02:00.0: 126.016 Gb/s available PCIe bandwi=
dth (8.0 GT/s PCIe x16 link)
> [   10.311515] mlx5_core 0000:02:00.0: Rate limit: 127 rates are supporte=
d, range: 0Mbps to 97656Mbps
> [   10.321948] mlx5_core 0000:02:00.0: E-Switch: Total vports 2, per vpor=
t: max uc(128) max mc(2048)
> [   10.344324] mlx5_core 0000:02:00.0: mlx5_pcie_event:301:(pid 88): PCIe=
 slot advertised sufficient power (27W).
> [   10.354339] BUG: unable to handle page fault for address: ffffffff8ff0=
ade0
> [   10.361206] #PF: supervisor read access in kernel mode
> [   10.366335] #PF: error_code(0x0000) - not-present page
> [   10.371467] PGD 81ec39067 P4D 81ec39067 PUD 81ec3a063 PMD 114b07063 PT=
E 800ffff7e10f5062
> [   10.379544] Oops: 0000 [#1] PREEMPT SMP PTI
> [   10.383721] CPU: 0 PID: 117 Comm: kworker/0:6 Not tainted 6.3.0-13028-=
g7222f123c983 #1
> [   10.391625] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0b 06/=
12/2017
> [   10.398750] Workqueue: events work_for_cpu_fn
> [   10.403108] RIP: 0010:__bitmap_or+0x10/0x26
> [   10.407286] Code: 85 c0 0f 95 c0 c3 cc cc cc cc 90 90 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 89 c9 31 c0 48 83 c1 3f 48 c1 e9 06 39 c8 73 11 <=
4c> 8b 04 c6 4c 0b 04 c2 4c 89 04 c7 48 ff c0 eb eb c3 cc cc cc cc
> [   10.426024] RSP: 0000:ffffb45a0078f7b0 EFLAGS: 00010097
> [   10.431240] RAX: 0000000000000000 RBX: ffffffff8ff0adc0 RCX: 000000000=
0000004
> [   10.438365] RDX: ffff9156801967d0 RSI: ffffffff8ff0ade0 RDI: ffff91568=
01967b0
> [   10.445489] RBP: ffffb45a0078f7e8 R08: 0000000000000030 R09: 000000000=
0000000
> [   10.452613] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
00000ec
> [   10.459737] R13: ffffffff8ff0ade0 R14: 0000000000000001 R15: 000000000=
0000020
> [   10.466862] FS:  0000000000000000(0000) GS:ffff9165bfc00000(0000) knlG=
S:0000000000000000
> [   10.474936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   10.480674] CR2: ffffffff8ff0ade0 CR3: 00000001011ae003 CR4: 000000000=
03706f0
> [   10.487800] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [   10.494922] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [   10.502046] Call Trace:
> [   10.504493]  <TASK>
> [   10.506589]  ? matrix_alloc_area.constprop.0+0x43/0x9a
> [   10.511729]  ? prepare_namespace+0x84/0x174
> [   10.515914]  irq_matrix_reserve_managed+0x56/0x10c
> [   10.520699]  x86_vector_alloc_irqs+0x1d2/0x31e
> [   10.525146]  irq_domain_alloc_irqs_hierarchy+0x39/0x3f
> [   10.530284]  irq_domain_alloc_irqs_parent+0x1a/0x2a
> [   10.535155]  intel_irq_remapping_alloc+0x59/0x5e9
> [   10.539859]  ? kmem_cache_debug_flags+0x11/0x26
> [   10.544383]  ? __radix_tree_lookup+0x39/0xb9
> [   10.548649]  irq_domain_alloc_irqs_hierarchy+0x39/0x3f
> [   10.553779]  irq_domain_alloc_irqs_parent+0x1a/0x2a
> [   10.558650]  msi_domain_alloc+0x8c/0x120
> [ rqs_hierarchy+0x39/0x3f
> [   10.567697]  irq_domain_alloc_irqs_locked+0x11d/0x286
> [   10.572741]  __irq_domain_alloc_irqs+0x72/0x93
> [   10.577179]  __msi_domain_alloc_irqs+0x193/0x3f1
> [   10.581789]  ? __xa_alloc+0xcf/0xe2
> [   10.585273]  msi_domain_alloc_irq_at+0xa8/0xfe
> [   10.589711]  pci_msix_alloc_irq_at+0x47/0x5c
> [   10.593987]  mlx5_irq_alloc+0x99/0x319 [mlx5_core]
> [   10.598881]  ? xa_load+0x5e/0x68
> [   10.602112]  irq_pool_request_vector+0x60/0x7d [mlx5_core]
> [   10.607668]  mlx5_irq_request+0x26/0x98 [mlx5_core]
> [   10.612617]  mlx5_irqs_request_vectors+0x52/0x82 [mlx5_core]
> [   10.618345]  mlx5_eq_table_create+0x613/0x8d3 [mlx5_core]
> [   10.623806]  ? kmalloc_trace+0x46/0x57
> [   10.627549]  mlx5_load+0xb1/0x33e [mlx5_core]
> [   10.631971]  mlx5_init_one+0x497/0x514 [mlx5_core]
> [   10.636824]  probe_one+0x2fa/0x3f6 [mlx5_core]
> [   10.641330]  local_pci_probe+0x47/0x8b
> [   10.645073]  work_for_cpu_fn+0x1a/0x25
> [   10.648817]  process_one_work+0x1e0/0x2e0
> [   10.652822]  process_scheduled_works+0x2c/0x37
> [   10.657258]  worker_thread+0x1e2/0x25e
> [   10.661003]  ? __pfx_worker_thread+0x10/0x10
> [   10.665267]  kthread+0x10d/0x115
> [   10.668501]  ? __pfx_kthread+0x10/0x10
> [   10.672244]  ret_from_fork+0x2c/0x50
> [   10.675824]  </TASK>
> [   10.678007] Modules linked in: mlx5_core(+) ast drm_kms_helper crct10d=
if_pclmul crc32_pclmul drm_shmem_helper crc32c_intel drm ghash_clmulni_inte=
l sha512_ssse3 igb dca i2c_algo_bit mlxfw pci_hyperv_intf pkcs8_key_parser
> [   10.697447] CR2: ffffffff8ff0ade0
> [   10.700758] ---[ end trace 0000000000000000 ]---
> [   10.707706] pstore: backend (erst) writing error (-28)
> [   10.712838] RIP: 0010:__bitmap_or+0x10/0x26
> [   10.717014] Code: 85 c0 0f 95 c0 c3 cc cc cc cc 90 90 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 89 c9 31 c0 48 83 c1 3f 48 c1 e9 06 39 c8 73 11 <=
4c> 8b 04 c6 4c 0b 04 c2 4c 89 04 c7 48 ff c0 eb eb c3 cc cc cc cc
> [   10.735752] RSP: 0000:ffffb45a0078f7b0 EFLAGS: 00010097
> [   10.740969] RAX: 0000000000000000 RBX: ffffffff8ff0adc0 RCX: 000000000=
0000004
> [   10.748093] RDX: ffff9156801967d0 RSI: ffffffff8ff0ade0 RDI: ffff91568=
01967b0
> [   10.755218] RBP: ffffb45a0078f7e8 R08: 0000000000000030 R09: 000000000=
0000000
> [   10.762341] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
00000ec
> [   10.769467] R13: ffffffff8ff0ade0 R14: 0000000000000001 R15: 000000000=
0000020
> [   10.776590] FS:  0000000000000000(0000) GS:ffff9165bfc00000(0000) knlG=
S:0000000000000000
> [   10.784666] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   10.790405] CR2: ffffffff8ff0ade0 CR3: 00000001011ae003 CR4: 000000000=
03706f0
> [   10.797529] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [   10.804651] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [   10.811775] note: kworker/0:6[117] exited with irqs disabled
> [   10.817444] note: kworker/0:6[117] exited with preempt_count 1
>=20
> HTH
>=20
> --
> Chuck Lever

Following up.

Jason shamed me into replacing a working CX-3Pro in one of
my lab systems with a CX-5 VPI, and the same problem occurs.
Removing the CX-5 from the system alleviates the problem.

Supermicro SYS-6028R-T/X10DRi, v6.4-rc2


--
Chuck Lever



