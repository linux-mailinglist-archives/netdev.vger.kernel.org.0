Return-Path: <netdev+bounces-6811-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93968718490
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4943B2815A6
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51EC315495;
	Wed, 31 May 2023 14:17:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4861429C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:17:17 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8307C11F;
	Wed, 31 May 2023 07:16:47 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VDNsRD019271;
	Wed, 31 May 2023 14:15:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=l0SOsP7K7homdbYZwda6a7hJ6yFdvZojaLyCDlOEi7A=;
 b=1JcWQaPaaUUN5iROf1smN1Z5zzCpXmzT5JVhmYQGkQRizrVlw9bD1C2dLWoGcVHVvJXf
 2rZl+Xfy6UW4cX0W4MJ4yzKSbeU6d9+va+zqqR+WeGTlesT2E/jTVyRdbq00GpNeMgvu
 Z8rbSjfuArMJX4S9/ajckwHOv7ECd+O5z+vF73HPA7kQR5IiNOSNV9gO/efjdQUZ2d6C
 B0O18FrGG4Te3XlfFoGcz0z20LUHvsDS9vmmb5cCRfPD1uNNZKkaMuyJpRXbh6+EUT59
 +vGJt1D6q73YTcs9ewSEk29eaGEfXQDi3fq1S2NlmfbD05J+biNYDFaAVWBQk1V55YS+ 9w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhj4wxxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 14:15:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VDaTqJ019713;
	Wed, 31 May 2023 14:15:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a5v6q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 14:15:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PmaDYBbQmQ3j9YGXPBFGbUaIR9G6TOg1tdDpg2WKbKjebk+7xpj7WiXFFY0zc6vvqHxXhSgdz++qOvIasyfUKa6L25UCx3ugmz3MIITWUMKdtj5ZA7YCCI8NJZPR1+ZE5EveIXVbL+PNkf9KSg2ydwCiXNWa+23cuXwNBkYzyekmcl7wQZpwTBQ46K2qDG0UT3+bWsiKiSeHjuxGWGXgsXIcd2gVqHbgSaHcbAPVqhpWv2OYwYgI/s+dfKov5Eue+XIdg0hUmxLjB7YQJTNMJa/4Qf+G/eLzQe9q9YhoHWLNwkNrd5mNUrikxLuP/T+sh/1u2NnYpsystnW83LGyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0SOsP7K7homdbYZwda6a7hJ6yFdvZojaLyCDlOEi7A=;
 b=WlpUhXbnWGJn0UgFhpxo9FxwnPlrhtoMFu3LB0EfezsYWq6uG204OQYxnFySHf0sbyf0UJbt0ghrzW1w4hKp6ooUMUqcuBZdxDporbH9owmcjyNkjVqcwHoA6geu0nzT3KUTEnfcskpcvuiLbPkLCqJ1pA04f5xiSw3rKsO3NqnSaEzY6FNsakQasfEadW/0BhkJ7Po60MkergdjywYbGbfh5APGa9IeVst+nO7Q0gvrDKzjOKT/XIfi6+5DjRpHZnwJ7p06LzmstvSFxxJccDwBJ/usTB+5T0QFqnsqoVRqrcTRo57hgTpaROIpU/JsJzicIRoHkesheXVAqDu/0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0SOsP7K7homdbYZwda6a7hJ6yFdvZojaLyCDlOEi7A=;
 b=Z5Pfda96VTv3c2uyrUZtkBajOkyIQYHopfRpYtDlgbmku9+SffhNlgtgxqGMQLbfKYpaRubAqmrWyJBrWVugIE7P+TnD2c3vgyCl6Mpmq0XONx8IuLGIq66qjK7o4pI2OoPYu9pzQ1pyfxk2HWtPMsJDL/tvK8QjrbifMhpV1iw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BL3PR10MB6092.namprd10.prod.outlook.com (2603:10b6:208:3b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Wed, 31 May
 2023 14:15:28 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 14:15:28 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Shay Drory <shayd@nvidia.com>, Eli Cohen <elic@nvidia.com>
CC: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgIADNpOAgAEJHQCAAAVBAIAABeaAgAAAiQCAAAD1gIAAFLGAgAGDgYA=
Date: Wed, 31 May 2023 14:15:28 +0000
Message-ID: <B9761A06-C76C-4088-A748-77867C9FF3CD@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
 <FD9A2C0A-1E3A-4D5B-9529-49F140771AAE@oracle.com>
 <DM8PR12MB54005117BF33730B4845DCD4AB4B9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <86B0E564-52C0-457E-A101-1BC4D6E22AC2@oracle.com>
 <DM8PR12MB540087BADA2458C51645E206AB4B9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <9d793d9f-0fca-2b0d-2a2e-abd527ffa8d4@nvidia.com>
In-Reply-To: <9d793d9f-0fca-2b0d-2a2e-abd527ffa8d4@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BL3PR10MB6092:EE_
x-ms-office365-filtering-correlation-id: a56c7c0c-fe9e-40bc-efe3-08db61e17c36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Cd74q+PmcRKm+hSSc2f8ywDBr1xA+92VosPBYMQo/0lZonRwa6EQqOqcSNpE0titAPulRGy+plxmmsD9kUYx2SVMwsWk8SCvX/dUlvFO09Dgz7DUMNJgSLZpuy88tLRIFGIpb0voKRv0HKyc9tIdmuTdIr2wGlLSrjR/UuYWQc5Ae/X1HJDO0m1f7A+ij9bDbG4NfL0x9yhBmI6mhUMvmFc1PhRILo1DmPl5JjdGR5WoXBD9Ywldpwc4q0EkwECMUAUPunFaB3tjZq+kMF1q3JyhDqq40ntTI3N9Bob4lreM/bWQHdKEOmY403wzSxwkdM0t2DZybbz3kbpaM3ExsYqPg7dQc9fti7BHM460lPFc196n040+yFRrW25aJ/DCYzYPiKsGz62UuHve8dBUUt+hvfLoGVQ5FyIl2niGpXTAEnqD+EnuwNBFFpYzyWYkRtS5pQgpqSzN/6pnjlXmhKufmYOqbwxXo9ynMz9liod/YH24341PlSYm9O5PlG1912I+9sVmKshQrMThSLdilHvD0wLMJYJ6bxMM+7WrdqPtOBxWUBcD73dYZ7q/tuKur0BzIYE/faqKjvzbRil1rcIwO9gpTlpi8qzPTjUghVgBaKX6yY3jyWiOzADP+GadG09ECO7NqoAJAWfMvZyxLA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199021)(110136005)(54906003)(186003)(86362001)(83380400001)(478600001)(2616005)(38070700005)(2906002)(53546011)(66556008)(36756003)(66476007)(66446008)(26005)(6506007)(6512007)(122000001)(33656002)(76116006)(66946007)(38100700002)(316002)(91956017)(71200400001)(4326008)(41300700001)(64756008)(8676002)(6486002)(8936002)(5660300002)(966005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?rGEX6tB3IZEUI0SUowrqs51CwYKyKsiJGjibl2IqQqLA9kVq4YcyJIXlH266?=
 =?us-ascii?Q?wCC+0rXAM4m9IMVFbjuCKn0lR5JgJeLZkf055SnSxoKHazdKo2U+WU6mb4A1?=
 =?us-ascii?Q?AxevEGzRO8SFsLRrMsG5IMw7fA69oXYVuYpy7cwIUHL2PbDpXLSk8JXFvaPo?=
 =?us-ascii?Q?f425bph7buVfnS5452duS/9PFk2KCselZ3VxpkPz5fTIsZJ4DRncVLMEUSZ4?=
 =?us-ascii?Q?oW7Zgpk8ZtkC/16EhSDOk1yZBDeXkMvRxZoV+j/Y5mFgfEBHsZAvW8Ync9pk?=
 =?us-ascii?Q?6Dx8JewaF0cKqlA/s0XWs/BIYyeGNb9tOkhSrSzOiAUEQIqK/KolRKRC0SDg?=
 =?us-ascii?Q?nbkvO40rvPWLsHQE6oXvLmOLyHpApRR8+A+wyHikEnf1zixlUhp5mv0WHpGo?=
 =?us-ascii?Q?a80FTytwhMhJMLrD5Y4EOx2PAlFr+RUSEnpYkUWhLw9ntJ+h258KTayAfBgp?=
 =?us-ascii?Q?RaCV09E3qCE18X3O795E18nPaJ38Iv2qu8einWLkhJY0F1n5/MfAeOACtcvV?=
 =?us-ascii?Q?zCcYWquafFzOF6Giy9tAjnMtn+mbPDIk/42BJPI98s3+WXvYzJU9UT4/jqlk?=
 =?us-ascii?Q?IgCZrvDvFma2l4axhLDjvrUMybxVjlaIWYh1+t16H+M+jp7GIX//KVQW4R4j?=
 =?us-ascii?Q?xL9SMiWqOE29WgN09Y+ETSSNfgpeWw5gc3qJsr9IONjV/462c2DbLG3lkjmR?=
 =?us-ascii?Q?TI7CaFk9w6RKYriBwPo+quPPyKARaoahNCqvZVNXX4Lno0jfHsB95lzV+jYn?=
 =?us-ascii?Q?RTZiJTiPAE6QpGymVHvD16YHHnAmMlJmKWTraBKZOzXcVh6TvLOFxAJL2jBm?=
 =?us-ascii?Q?B5Wm7Xq9b69fi1yga1WjM6aXseWvShQUf0m+hHv/w+u9S8d8sGO0FvhDc4EU?=
 =?us-ascii?Q?pkPiy3gCpei8gLlSRfbDif5HIJPtlRDahu1xLjnLuolorbsHciE5ya2sQGU/?=
 =?us-ascii?Q?l874MSEzmkrjDpzsOUB9i8ZW7ylkhW/bUoW4HHtH8C7cBvsyEv3lMXYMH5+J?=
 =?us-ascii?Q?sc/+osTYcAgYYGT8GLs8ra8IEUrsAZWVSA1x7wU0Dr9REPzwCIJLiOJCe2zc?=
 =?us-ascii?Q?WjsrLdzTXLBI7oGWyfhCAFrQTr1CBefW/Ts23l0n9BELRgz1ikSpltdTSUAw?=
 =?us-ascii?Q?kB9DJoV6ckWrJELJzwsoOTDevRt2EOIWlqpcfGA9SZ7wMC6BPrpZ4Cx9rthf?=
 =?us-ascii?Q?250i7oCZcIc8CMne25VD5/0r52e1YY1fsbVuqapIiPIZmOZ/Kxej5Y5VHMg8?=
 =?us-ascii?Q?HzelhTdlkb3uZo6eIhkp5sPgaTWzzDnmCnX6T2EquosamGRDGrUQTGntRPgX?=
 =?us-ascii?Q?tXVODWuN9zl92tVrltipap/2y74O6qQHAyDcY8FCqgSj509DEs64pwYkZvU0?=
 =?us-ascii?Q?oRAtrTzGVeEPQwbK0pejJNT8zMiB/IkuBhkbi5D9Mtm3EItGhHVzoObNEsPh?=
 =?us-ascii?Q?P1eqvXEkzMx2KAwXqpNGJRRSj+2klY59ojGI/S9CAp4+5DtYFssxja7sZNdA?=
 =?us-ascii?Q?HX5806Fz4wzyA0Y4R1yHlL01TB2OQcFqZEk4gtoNb4DS9Ut2GGWk0R6dUMRw?=
 =?us-ascii?Q?Qt+OxxoLFuwoS8gQFEl7sqBIg9XGddY9Ve7OLUooNhyFSqA//9KOEhYd4Obe?=
 =?us-ascii?Q?nA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1A0329904087794D8237F0191B4C81F9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7R3+c7jGA+9assXG8WEg7k36wmUrLKgHxHIEkykTpPSFXpC/x/QurJz3wsuxph7Nw+Fhnf2psIsrF6QLM1FG5jp10z4xS/6jaTDK2C/r1zQ8cW1vKQrM4BvFjL9lwpYVjg6oYOpez8XdIRyvkM1o3CrLxouaGt7BvwR+Pl8Xja7g8+Y4THr6lv3k5qxHQZuVW8po5ySmkREWpOyfhbu1GyBJUC5Qo2fTDhAgI5EPhA2isc723F/pNa9TkwumUksZW/CXiDVLJ52j3uKiJynzvNNT//K6gUR38rZzoC+EsU/xF7QRox6BBRa06rG5zYn15zhKdgDzj7543XcrWFKMsbyoSgpGORtGgyGiEbAn4oQARlBMvxRXNi8Bvj+iAV95yoj1jRTjNwaav/TEoeh+Xn6XeNoFve82R1HCpm6/ckIafFJxrl6C5AfjWJBYDuYp/jpQn7BK193320VPbYhoLiMo6x0oyUnFHFW9MA/KT+z5a11ItfqnRYgf4W6RqWjpCm2c+yz+iEoMU5q/g6bjiMbqhPCOLmRrkb7J0lU+Lv2KIBGUtmne/xeIMm2lFthyg3v1jljbObFreXwqS9cx9+FQZt+CAa6Vfya42O5rYvGQ54WmYQChx5XGK1dZyGmnYTLoQGKs5rbgCukossKqqEYROcxI8AoR99MwnW02z8jxEX6BALz4m7C4lMVqhSWXjtEhGrkAraqggQlARhmzUEZ+xXfBuEEgeJ1OjtLyBgd3SsJHs/HWGSBT+H99WBxlpos/EpKudgyUfsL7AXxxvhnPuZ1o6H7k5uKXnaViKijwd/Dxyp5aakLbBdOG2EuWvEctYP4S6ZBaD2YG0hy7oSFH1dK3H46+0IEO2zc1Cw0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a56c7c0c-fe9e-40bc-efe3-08db61e17c36
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 14:15:28.2472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5wd7N1y4nSY3oLEyqGpc3v5n4X6y8FEea/ZhGD+CQA9UaSfI7/GQKA2AtQaCVuzbwqyrJUFqID2cFIr5FdxrOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6092
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_09,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310122
X-Proofpoint-GUID: 8gsXmg2ftz25EKYx22rr02iXKJ1ZUbyx
X-Proofpoint-ORIG-GUID: 8gsXmg2ftz25EKYx22rr02iXKJ1ZUbyx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 30, 2023, at 11:08 AM, Shay Drory <shayd@nvidia.com> wrote:
>=20
>=20
> On 30/05/2023 16:54, Eli Cohen wrote:
>>> -----Original Message-----
>>> From: Chuck Lever III <chuck.lever@oracle.com>
>>> Sent: Tuesday, 30 May 2023 16:51
>>> To: Eli Cohen <elic@nvidia.com>
>>> Cc: Shay Drory <shayd@nvidia.com>; Leon Romanovsky <leon@kernel.org>;
>>> Saeed Mahameed <saeedm@nvidia.com>; linux-rdma <linux-
>>> rdma@vger.kernel.org>; open list:NETWORKING [GENERAL]
>>> <netdev@vger.kernel.org>; Thomas Gleixner <tglx@linutronix.de>
>>> Subject: Re: system hang on start-up (mlx5?)
>>>=20
>>>=20
>>>=20
>>>> On May 30, 2023, at 9:48 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>>=20
>>>>> From: Chuck Lever III <chuck.lever@oracle.com>
>>>>> Sent: Tuesday, 30 May 2023 16:28
>>>>> To: Eli Cohen <elic@nvidia.com>
>>>>> Cc: Leon Romanovsky <leon@kernel.org>; Saeed Mahameed
>>>>> <saeedm@nvidia.com>; linux-rdma <linux-rdma@vger.kernel.org>; open
>>>>> list:NETWORKING [GENERAL] <netdev@vger.kernel.org>; Thomas Gleixner
>>>>> <tglx@linutronix.de>
>>>>> Subject: Re: system hang on start-up (mlx5?)
>>>>>=20
>>>>>=20
>>>>>=20
>>>>>> On May 30, 2023, at 9:09 AM, Chuck Lever III <chuck.lever@oracle.com=
>
>>>>> wrote:
>>>>>>> On May 29, 2023, at 5:20 PM, Thomas Gleixner <tglx@linutronix.de>
>>>>> wrote:
>>>>>>> On Sat, May 27 2023 at 20:16, Chuck Lever, III wrote:
>>>>>>>>> On May 7, 2023, at 1:31 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>>>>>> I can boot the system with mlx5_core deny-listed. I log in, remove
>>>>>>>> mlx5_core from the deny list, and then "modprobe mlx5_core" to
>>>>>>>> reproduce the issue while the system is running.
>>>>>>>>=20
>>>>>>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core
>>> 0000:81:00.0:
>>>>> firmware version: 16.35.2000
>>>>>>>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core
>>> 0000:81:00.0:
>>>>> 126.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
>>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc:
>>>>> pool=3Dffff9a3718e56180 i=3D0 af_desc=3Dffffb6c88493fc90
>>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefcf0f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefcf0f60 end=
=3D236
>>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core
>>> 0000:81:00.0:
>>>>> Port module event: module 0, Cable plugged
>>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc:
>>>>> pool=3Dffff9a3718e56180 i=3D1 af_desc=3Dffffb6c88493fc60
>>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core
>>> 0000:81:00.0:
>>>>> mlx5_pcie_event:301:(pid 10): PCIe slot advertised sufficient power (=
27W).
>>>>>>>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efcf0f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efcf0f60 end=
=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efd30f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efd30f60
>>> end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc30f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc30f60
>>> end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc70f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc70f60
>>> end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd30f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd30f60
>>> end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd70f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd70f60
>>> end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m=
-
>>>>>> scratch_map=3Dffff9a33801990b0 cm->managed_map=3Dffffffffb9ef3f80 m-
>>>>>> system_map=3Dffff9a33801990d0 end=3D236
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handl=
e
>>>>> page fault for address: ffffffffb9ef3f80
>>>>>>>> ###
>>>>>>>>=20
>>>>>>>> The fault address is the cm->managed_map for one of the CPUs.
>>>>>>> That does not make any sense at all. The irq matrix is initialized =
via:
>>>>>>>=20
>>>>>>> irq_alloc_matrix()
>>>>>>> m =3D kzalloc(sizeof(matric);
>>>>>>> m->maps =3D alloc_percpu(*m->maps);
>>>>>>>=20
>>>>>>> So how is any per CPU map which got allocated there supposed to be
>>>>>>> invalid (not mapped):
>>>>>>>=20
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handl=
e
>>>>> page fault for address: ffffffffb9ef3f80
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: #PF: supervisor read
>>>>> access in kernel mode
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: #PF:
>>> error_code(0x0000)
>>>>> - not-present page
>>>>>>>> May 27 15:47:47 manet.1015granger.net kernel: PGD 54ec19067 P4D
>>>>> 54ec19067 PUD 54ec1a063 PMD 482b83063 PTE 800ffffab110c062
>>>>>>> But if you look at the address: 0xffffffffb9ef3f80
>>>>>>>=20
>>>>>>> That one is bogus:
>>>>>>>=20
>>>>>>>   managed_map=3Dffff9a36efcf0f80
>>>>>>>   managed_map=3Dffff9a36efd30f80
>>>>>>>   managed_map=3Dffff9a3aefc30f80
>>>>>>>   managed_map=3Dffff9a3aefc70f80
>>>>>>>   managed_map=3Dffff9a3aefd30f80
>>>>>>>   managed_map=3Dffff9a3aefd70f80
>>>>>>>   managed_map=3Dffffffffb9ef3f80
>>>>>>>=20
>>>>>>> Can you spot the fail?
>>>>>>>=20
>>>>>>> The first six are in the direct map and the last one is in module m=
ap,
>>>>>>> which makes no sense at all.
>>>>>> Indeed. The reason for that is that the affinity mask has bits
>>>>>> set for CPU IDs that are not present on my system.
>>>>>>=20
>>>>>> After bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
>>>>>> that mask is set up like this:
>>>>>>=20
>>>>>> struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
>>>>>> {
>>>>>>       struct mlx5_irq_pool *pool =3D ctrl_irq_pool_get(dev);
>>>>>> -       cpumask_var_t req_mask;
>>>>>> +       struct irq_affinity_desc af_desc;
>>>>>>       struct mlx5_irq *irq;
>>>>>> -       if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
>>>>>> -               return ERR_PTR(-ENOMEM);
>>>>>> -       cpumask_copy(req_mask, cpu_online_mask);
>>>>>> +       cpumask_copy(&af_desc.mask, cpu_online_mask);
>>>>>> +       af_desc.is_managed =3D false;
>>>>> By the way, why is "is_managed" set to false?
>>>>>=20
>>>>> This particular system is a NUMA system, and I'd like to be
>>>>> able to set IRQ affinity for the card. Since is_managed is
>>>>> set to false, writing to the /proc/irq files fails with EIO.
>>>>>=20
>>>> This is a control irq and is used for issuing configuration commands.
>>>>=20
>>>> This commit:
>>>> commit c410abbbacb9b378365ba17a30df08b4b9eec64f
>>>> Author: Dou Liyang <douliyangs@gmail.com>
>>>> Date:   Tue Dec 4 23:51:21 2018 +0800
>>>>=20
>>>>    genirq/affinity: Add is_managed to struct irq_affinity_desc
>>>>=20
>>>> explains why it should not be managed.
>>> Understood, but what about the other IRQs? I can't set any
>>> of them. All writes to the proc files result in EIO.
>>>=20
>> I think @Shay Drory has a fix for that should go upstream.
>> Shay was it sent?
>=20
> The fix was send and merged.
>=20
> https://lore.kernel.org/all/20230523054242.21596-15-saeed@kernel.org/

Fwiw, I'm now on v6.4-rc4, and setting IRQ affinity works as expected.
Sorry for the noise and thanks for the fix.


>>>>>> Which normally works as you would expect. But for some historical
>>>>>> reason, I have CONFIG_NR_CPUS=3D32 on my system, and the
>>>>>> cpumask_copy() misbehaves.
>>>>>>=20
>>>>>> If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
>>>>>> copy, this crash goes away. But mlx5_core crashes during a later
>>>>>> part of its init, in cpu_rmap_update(). cpu_rmap_update() does
>>>>>> exactly the same thing (for_each_cpu() on an affinity mask created
>>>>>> by copying), and crashes in a very similar fashion.
>>>>>>=20
>>>>>> If I set CONFIG_NR_CPUS to a larger value, like 512, the problem
>>>>>> vanishes entirely, and "modprobe mlx5_core" works as expected.
>>>>>>=20
>>>>>> Thus I think the problem is with cpumask_copy() or for_each_cpu()
>>>>>> when NR_CPUS is a small value (the default is 8192).
>>>>>>=20
>>>>>>=20
>>>>>>> Can you please apply the debug patch below and provide the output?
>>>>>>>=20
>>>>>>> Thanks,
>>>>>>>=20
>>>>>>>      tglx
>>>>>>> ---
>>>>>>> --- a/kernel/irq/matrix.c
>>>>>>> +++ b/kernel/irq/matrix.c
>>>>>>> @@ -51,6 +51,7 @@ struct irq_matrix {
>>>>>>> unsigned int alloc_end)
>>>>>>> {
>>>>>>> struct irq_matrix *m;
>>>>>>> + unsigned int cpu;
>>>>>>>=20
>>>>>>> if (matrix_bits > IRQ_MATRIX_BITS)
>>>>>>> return NULL;
>>>>>>> @@ -68,6 +69,8 @@ struct irq_matrix {
>>>>>>> kfree(m);
>>>>>>> return NULL;
>>>>>>> }
>>>>>>> + for_each_possible_cpu(cpu)
>>>>>>> + pr_info("ALLOC: CPU%03u: %016lx\n", cpu, (unsigned
>>>>> long)per_cpu_ptr(m->maps, cpu));
>>>>>>> return m;
>>>>>>> }
>>>>>>>=20
>>>>>>> @@ -215,6 +218,8 @@ int irq_matrix_reserve_managed(struct ir
>>>>>>> struct cpumap *cm =3D per_cpu_ptr(m->maps, cpu);
>>>>>>> unsigned int bit;
>>>>>>>=20
>>>>>>> + pr_info("RESERVE MANAGED: CPU%03u: %016lx\n", cpu, (unsigned
>>>>> long)cm);
>>>>>>> +
>>>>>>> bit =3D matrix_alloc_area(m, cm, 1, true);
>>>>>>> if (bit >=3D m->alloc_end)
>>>>>>> goto cleanup;
>>>>>> --
>>>>>> Chuck Lever
>>>>>=20
>>>>> --
>>>>> Chuck Lever
>>>=20
>>> --
>>> Chuck Lever


--
Chuck Lever



