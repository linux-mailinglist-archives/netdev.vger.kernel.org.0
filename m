Return-Path: <netdev+bounces-5931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E39F2713667
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 22:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B9121C20A85
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 20:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A66C14A91;
	Sat, 27 May 2023 20:16:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6398E7E
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 20:16:46 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A3FC9;
	Sat, 27 May 2023 13:16:42 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34RJxQdv002843;
	Sat, 27 May 2023 20:16:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Vb6Fg/u8jov/bzfqzjih2hQPLMyyDpvDApORuAa6UUY=;
 b=eTBzNpKA1VghOfQLyspA/nEujy74Buqx8JK1I1LvE1ugEek2h5cbAFJG7tHFmPQVHRRx
 eeapFKgyNBIb6pHZhbQ5a5ye0vly/Z3Hed96/CIllA5zsZkIcNHZsRMnqwasbY1sinA0
 XjUMb23u2OrCITOEW2WRMlGS8YQvt6ELQNJWp7sUeuSonV4XCxIi3w6AdgRo5u7jgkoV
 KVAF0qNp2iTGBQK3DbRk4MRzdiljd35GLUAuFKOOcuc3tEMihJbHq6bMJzUcTin7VMJ/
 mvhUlybDjJ7tQ+U3zw47ewRcrw5D+Cxhnizc5T5H4hYuriCG8uNJc26YBmbi3p99CXDm sA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qurgdg08n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 May 2023 20:16:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34RHfLsC029985;
	Sat, 27 May 2023 20:16:17 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a20ve5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 27 May 2023 20:16:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnkNlp6I62gKg+4nlaCLlgtW5MkT4wi0h485Q3Q4YS9+f2GI7R9nsIDKJMVlcmhK6QNeaSXfWmKZzxDh0TV53Ck1rXJFIWK+6OslTRhCNHHpMLnEfFeq/Dzwy3gk2/Mo2mElXYboBw6w9vnggqA+P18phviEqYMwXmOVRidwbKKoEB9YKbu0jaL6fnKGP7SMOIDXheAGQjKhtxEfhc3Gms/BVxvxz/5u2mZLSvbQSAylQFPsNkLV6Leml0mzk3TwFdmN5NdPR9ZEH3zo1VO5hTZXtJd3lMDVv3ibWbB+H0yu0aauiRVViVMNqruRousrikaMTbzJ5sXy45RTjXzgGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vb6Fg/u8jov/bzfqzjih2hQPLMyyDpvDApORuAa6UUY=;
 b=Qw9Qy2Z/Gm/O+mSNgeIU47sUJwStDEsdliDQ8Xxa9qC1IVE6OgzicvmTDR1/PNGfFvJ4Yp6kWKH/ux6cf+woW8+x2zV1MBlMe+9cTaLqmFKt32yXWE4pHd6lIPN8nHfb/PWkBImsVOHeniIPh6XsPrnzB7308CryQUJqYuyxEi5h/5LNTUGgtQha/KP45lP56voSMYZjNZoSwySPW8JENZQFgfj6Vi3m4UfOZmAgIwkuuNclp5iPwORL3tcc/PiBgocnLiUMgJ9u3gZQCfDXeFrNXJV1PR5K+Kao9BEZAYBnEA5AJ5aNYxKRvJPo+dfU6Pmqr+YVuDyXhKydlKELuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vb6Fg/u8jov/bzfqzjih2hQPLMyyDpvDApORuAa6UUY=;
 b=V1IZL3WNHlA5plEi4hJ1zfEVJ88WuONWRR6S9E44Q8m8R/kPkOU8/vBT+6fDWzns2hJAR3W0eKZpgd3bSNvEvUfVkPRY2pXMeBFKp/3sL2wwyTFev0S5pOIKHRv61pmeYrXGEuYLctcun4VUN737fz/I6oJo7C0inweyvclt+ig=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by BLAPR10MB5331.namprd10.prod.outlook.com (2603:10b6:208:334::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Sat, 27 May
 2023 20:16:15 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::15c:75c7:a36f:ab3f]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::15c:75c7:a36f:ab3f%3]) with mapi id 15.20.6433.020; Sat, 27 May 2023
 20:16:14 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Eli Cohen <elic@nvidia.com>, "tglx@linutronix.de" <tglx@linutronix.de>
CC: Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgA==
Date: Sat, 27 May 2023 20:16:14 +0000
Message-ID: <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
In-Reply-To: 
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|BLAPR10MB5331:EE_
x-ms-office365-filtering-correlation-id: f66b1a76-0640-4fdd-01fb-08db5eef38d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 jeVNFufUayriB2b0OIj7SvCUD7KFEXneO8zyo0UP0RySfTgBokOelhuAPCIS9ZfA9TrhnkANiy5UJ630zzDOD7gWrxaDuemNPL9tU98hQswupD62RIq7PAiQptKh9Oon5Id53TQ5rIH8VW+F+ZmBfBQ28iLuoOIqRCJGQQoUjr8z67jXsoqrmwI1bwwUQfJUDZslb1Kl3obzKZ2O20+9E7ozwabS3ROdW2iBAt5d0RlsWPMn6iHhwfM7RqF+cnK8pBuc9JgeHXEfUJ/IqOCY5ohmlww0iwioRf30wlzbqD0aiER0gjMCyzSMfpA7+kSTdMN5Z2kwiCLLsINoP1P63UPpmtgnmvacAb8ixMKfI7Pr9LvE0BmtVn7gM74cR3o+aRye2YJIqF86MQQKmNKjQC6j2QLkrHvOkN9B2LH7kfp9o0u29MIeJ5EAzn+fsAlRQDGgryJwmEAy4Zu5hbgNoVivwf9Kg4Gdc7X2hbWxMaeST89lozfpBPmxybOG9gAGWkZ0TooPHDKTyT3+CCdtOONpUdNqszApI8MeqW1rdqEGxjwXA36qSO/4qrozvcJsGwMV2v3nSo4z50bk7n4cPWeOc9W/LVO4MD3Pwm14UqRuI9kYjS/Rb6snLmZdMgOKgWjlkEgXXDgwvACnyUk8+g==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199021)(26005)(38100700002)(41300700001)(6486002)(83380400001)(186003)(53546011)(6512007)(6506007)(2616005)(478600001)(71200400001)(45080400002)(110136005)(54906003)(64756008)(66446008)(66476007)(66946007)(76116006)(66556008)(122000001)(4326008)(316002)(91956017)(5660300002)(8676002)(8936002)(30864003)(38070700005)(86362001)(2906002)(33656002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?S+XiszF2vLNKciILIly8czfFxDdHzTYZcokdhsxcPFScedhh1y3Nq/M4S0Ez?=
 =?us-ascii?Q?ieQ0C1CsLk3+lDFFUKI2A2Di0Q6/okgwOtQBgs6k3Ic/gvCmxm3szRXkvzw+?=
 =?us-ascii?Q?sqCfFp9BQF76JVaMYIQOnp0BCJcJnVU4FKXx7eVi6sW47RWZxodHoFO93fiw?=
 =?us-ascii?Q?Lou6V/67VGO4/KpYLka0zNN5CBcAx6+fJmC4bugpX6oOa92HQBKf95/frLXX?=
 =?us-ascii?Q?9JE4FlfRdyEPvtu3atpF/hnkDc3wRKvASwiKdVW4P16JS1G30F5RdBxWCqLY?=
 =?us-ascii?Q?c1/ZS4rbqOYmfcfKkdI5sBhlho+I4Ety1PM82Yk7497Eq+tB0aiaYfR9lDw5?=
 =?us-ascii?Q?L/MxqNHhPB8enrV0QQdxnCDBKIBZKiLER5qJX4KUak2zff0LaV6bE27hiy20?=
 =?us-ascii?Q?IxKBPhvO0aBjHFEyxA5VZIlLQaP0as9EtcTNoucFgreTfqTvLHWCwyOvDODR?=
 =?us-ascii?Q?eZrxrI6snn3pLjpaVQfoCpdRjZK9QJi3pKzFY1zux8hJ8w2L29cvQseE29cU?=
 =?us-ascii?Q?aBDtk28Z1VGgSv9gNrVUmqjxEPr4U7HG82AgPippR1DpXl/68AaS1LD/R5iy?=
 =?us-ascii?Q?3IJStHJB4iyBUC9pbjtHIpaiw6FHLrlMD9Zj9YTlXs0ItzX+lgTNgMK9Bs4O?=
 =?us-ascii?Q?Y5GqlF8rhfYPeYSLl+aP0t/VcaxZmiH/K6Ercccakz08DrgUbttB2cxlWtyb?=
 =?us-ascii?Q?jcuoFW2FC3zB/nTNFE3ZhmRbSXC1JIozSgkX4gTp031tIsRGWFLCDGbPPUUA?=
 =?us-ascii?Q?/SdQaEIqvMK60IQsVaSjkOgbHyh6I7NyFqLfLDl1WdXLiw1ludJXsakrYQEH?=
 =?us-ascii?Q?WgQcuskSIU1d2LebgV3XHOtmKZbsEjkjBKTSFwhK9Db14JibzuB8ApQ7y/xG?=
 =?us-ascii?Q?z5zOrJVbJDHDzvD3UTycR5xrUyBgSwOUgnCoeBz36RjoU4xQ2ralon7hGCVb?=
 =?us-ascii?Q?486sbRuSQ331fjQrPjUUYW0NjBgCysSlr0pW8DxZ5CUjtKyYi0OiDqFTWwLO?=
 =?us-ascii?Q?4QjfGE6BvYtjST3SBgsiCdgGkL0dtupHJe1+1ysScNMK1xFqTafSfOuKyPJA?=
 =?us-ascii?Q?yrUYAuhIUngnPZEKmJKO569GnJ3PcHWONiq+6a5Q3VD9DBieL4x3gs5BNbza?=
 =?us-ascii?Q?sSkOeCK9AtsxZtHn2aZvQ19FwtPoJVLyNfteULdILoSBJ6GPXZFf0YRbNK4H?=
 =?us-ascii?Q?Tb9BfAbGExT0pfgrrG9UNEBqsDXlzCHBHBcRJql4hiZsEgl9Ka89sYrk5Zo+?=
 =?us-ascii?Q?3aM0VmHzw5Z1yA2ANnocK1wH7BY9Aattu5Q87Ad5tHG/V3vB5461hsLcGhCO?=
 =?us-ascii?Q?lYtdoq8babIXOq4vE0Hj8wvuYLKmJv7M+4jiOc7oM56oHyaNKYRYfqNrhpom?=
 =?us-ascii?Q?IAwt+BhLYIN7W+ky57Qjuk9KZOSks1rx2KH4qdxAKlzGKMTARmQ+dBcUIhFh?=
 =?us-ascii?Q?mrpGqDHVn0/SEKKn/D0Old1fPrE+4gv7vAJWb39mp1mxzMbXISz/KdMewdGs?=
 =?us-ascii?Q?rXKS3RfO+IjJup8IMPR6KY3CIBgFsHAknhGbOBcxjr5kSaMN1SYT9F27EjJT?=
 =?us-ascii?Q?yCt6g+THoIdhIbNdZndyBjjaKGLRS4du6K100pHZ17FLfgl0O+zEwrwb+379?=
 =?us-ascii?Q?7g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2FF7742C03D6FE438C385650DB40D259@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	41UmWLa8pxTLkEdm+t5ae36Pu+vYqpZz9O5plJl6q0m58vIdqU1ChfGqGcTujygx1h5wNCEoTEIiI3Y4ftkQ4/jUu24nSDZbFrAEF3RHOFM8KkXfeP9BHIgbeKFl4l8BFOylckkI2Yb34EXEDTqOYFct1hnA99tSvyCyrkJOae9btPTntLTDb41Wug0QZGyTlhVDod7dGsAEy05ZJsyaZaraCu9XOp1Q60DptiO+GWDna6zkfn+iRsJ7YU+0amNQMOe9UyG9aggxuvLD0C2Y58aGqj31C+xaAnMaj5nrc4l5EuK6RzD7nLrJkh8HSeXwbqEvhjKlnRyTHfNxe6CzkMaV5d4BpFrk656wnZcp1+5cjy/8goWj7cnziy9uB37FvlLtJhb/bu+slgsOKAudTxkPUHH+OFKtJz58hQ9bKafALaPAUzRQH0SiRkK97WQtGmqthYlDMPMfYWCoUw3qZ1i2YbfJPjCxTDfmMcaMLdu+U2W/1ker7FHXsB/kEMDvEVVBTuGKIESigVT0lrCqKoVtIS+ZvESCD/FrS7hIqro01Lw3uecVkb3n62SAj2X8A9o7Dvdyt58cetXX9zZ7NC1lSXgEmR8F7nEW+9bfTVdITqodB16Uu7UhkdsdNlB1rmntcdFdRnH+WDBZJEB9bv2MF52/DA4a00jz00lbZqVk3gKlkPsSjO0xekvU/dJLBHiM+AFN/yeeO9K9cTC8Od2oHP++DdXmK9bpLfe3IoCGN0Gj4H49Rfxigp5XHAi0nF7XCN57ziukrbBn9I3Al+4QzucjEw8O3ravo/uQ3e0LelXQDfqbfAk37SnSi+x8Psg4U+Sbe2sKv5pt+liaclba7vURyOqQJLKF6bNXs3c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f66b1a76-0640-4fdd-01fb-08db5eef38d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2023 20:16:14.6936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CupcK01fMuldOmX85OvPYBnanoIy11glaemuluGDF/Yqb8FhHbB5MRdYKeOheI1CAxFm9UsiXWozFIdjeXI9Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5331
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-27_14,2023-05-25_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305270177
X-Proofpoint-ORIG-GUID: 8bsLzCZ6A0MD1XEa7JpgPvZ3HR0IdEbW
X-Proofpoint-GUID: 8bsLzCZ6A0MD1XEa7JpgPvZ3HR0IdEbW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 7, 2023, at 1:31 AM, Eli Cohen <elic@nvidia.com> wrote:
>=20
> Hi Thomas,
>=20
> Do you have insights what could cause this?

Following up. I am not able to reproduce this problem with KASAN
enabled, so I sprinkled a few pr_info() call sites in
kernel/irq/matrix.c.

I can boot the system with mlx5_core deny-listed. I log in, remove
mlx5_core from the deny list, and then "modprobe mlx5_core" to
reproduce the issue while the system is running.

May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: firmw=
are version: 16.35.2000
May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: 126.0=
16 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=3Dffff9a=
3718e56180 i=3D0 af_desc=3Dffffb6c88493fc90
May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefcf0f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefcf0f60 end=3D236
May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: Port =
module event: module 0, Cable plugged
May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=3Dffff9a=
3718e56180 i=3D1 af_desc=3Dffffb6c88493fc60
May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: mlx5_=
pcie_event:301:(pid 10): PCIe slot advertised sufficient power (27W).
May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efcf0f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efcf0f60 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efd30f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efd30f60 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc30f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc30f60 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc70f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc70f60 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd30f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd30f60 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd70f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd70f60 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scratch=
_map=3Dffff9a33801990b0 cm->managed_map=3Dffffffffb9ef3f80 m->system_map=3D=
ffff9a33801990d0 end=3D236
May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle page fa=
ult for address: ffffffffb9ef3f80

###

The fault address is the cm->managed_map for one of the CPUs.

###

May 27 15:47:47 manet.1015granger.net kernel: #PF: supervisor read access i=
n kernel mode
May 27 15:47:47 manet.1015granger.net kernel: #PF: error_code(0x0000) - not=
-present page
May 27 15:47:47 manet.1015granger.net kernel: PGD 54ec19067 P4D 54ec19067 P=
UD 54ec1a063 PMD 482b83063 PTE 800ffffab110c062
May 27 15:47:47 manet.1015granger.net kernel: Oops: 0000 [#1] PREEMPT SMP P=
TI
May 27 15:47:47 manet.1015granger.net kernel: CPU: 6 PID: 364 Comm: kworker=
/6:3 Tainted: G S                 6.4.0-rc3-00014-g7d5f9d35c255 #2 fde923d8=
33042649d4022091376d234db2fe0900
May 27 15:47:47 manet.1015granger.net kernel: Hardware name: Supermicro SYS=
-6028R-T/X10DRi, BIOS 1.1a 10/16/2015
May 27 15:47:47 manet.1015granger.net kernel: Workqueue: events work_for_cp=
u_fn
May 27 15:47:47 manet.1015granger.net kernel: RIP: 0010:__bitmap_or+0x11/0x=
30
May 27 15:47:47 manet.1015granger.net kernel: Code: c6 48 85 f6 0f 95 c0 c3=
 31 f6 eb cf 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 89 c9 49 89 f8 48 83 c1=
 3f 48 c1 e9 06 74 17 31 c0 <48> 8b 3c c6 48 0b 3c c2 49 89 3c c0 48 83 c0 =
01 48 39 c1 75 eb c3
May 27 15:47:47 manet.1015granger.net kernel: RSP: 0018:ffffb6c88493f798 EF=
LAGS: 00010046
May 27 15:47:47 manet.1015granger.net kernel: RAX: 0000000000000000 RBX: ff=
ff9a33801990b0 RCX: 0000000000000004
May 27 15:47:47 manet.1015granger.net kernel: RDX: ffff9a33801990d0 RSI: ff=
ffffffb9ef3f80 RDI: ffff9a33801990b0
May 27 15:47:47 manet.1015granger.net kernel: RBP: ffffb6c88493f7d8 R08: ff=
ff9a33801990b0 R09: ffffb6c88493f628
May 27 15:47:47 manet.1015granger.net kernel: R10: 0000000000000003 R11: ff=
ffffffb9d30748 R12: ffffffffb9ef3f60
May 27 15:47:47 manet.1015granger.net kernel: R13: 00000000000000ec R14: 00=
00000000000020 R15: ffffffffb9ef3f80
May 27 15:47:47 manet.1015granger.net kernel: FS:  0000000000000000(0000) G=
S:ffff9a3aefc00000(0000) knlGS:0000000000000000
May 27 15:47:47 manet.1015granger.net kernel: CS:  0010 DS: 0000 ES: 0000 C=
R0: 0000000080050033
May 27 15:47:47 manet.1015granger.net kernel: CR2: ffffffffb9ef3f80 CR3: 00=
0000054ec16005 CR4: 00000000001706e0
May 27 15:47:47 manet.1015granger.net kernel: Call Trace:
May 27 15:47:47 manet.1015granger.net kernel:  <TASK>
May 27 15:47:47 manet.1015granger.net kernel:  ? matrix_alloc_area.constpro=
p.0+0x66/0xe0
May 27 15:47:47 manet.1015granger.net kernel:  ? unpack_to_rootfs+0x178/0x3=
80
May 27 15:47:47 manet.1015granger.net kernel:  irq_matrix_reserve_managed+0=
x55/0x170
May 27 15:47:47 manet.1015granger.net kernel:  x86_vector_alloc_irqs.part.0=
+0x2bb/0x3a0
May 27 15:47:47 manet.1015granger.net kernel:  x86_vector_alloc_irqs+0x23/0=
x40
May 27 15:47:47 manet.1015granger.net kernel:  irq_domain_alloc_irqs_parent=
+0x24/0x50
May 27 15:47:47 manet.1015granger.net kernel:  intel_irq_remapping_alloc+0x=
59/0x650
May 27 15:47:47 manet.1015granger.net kernel:  irq_domain_alloc_irqs_parent=
+0x24/0x50
May 27 15:47:47 manet.1015granger.net kernel:  msi_domain_alloc+0x74/0x130
May 27 15:47:47 manet.1015granger.net kernel:  irq_domain_alloc_irqs_hierar=
chy+0x18/0x40
May 27 15:47:47 manet.1015granger.net kernel:  irq_domain_alloc_irqs_locked=
+0xce/0x370
May 27 15:47:47 manet.1015granger.net kernel:  __irq_domain_alloc_irqs+0x57=
/0xa0
May 27 15:47:47 manet.1015granger.net kernel:  __msi_domain_alloc_irqs+0x1c=
a/0x3f0
May 27 15:47:47 manet.1015granger.net kernel:  msi_domain_alloc_irq_at+0xef=
/0x140
May 27 15:47:47 manet.1015granger.net kernel:  ? vprintk+0x4b/0x60
May 27 15:47:47 manet.1015granger.net kernel:  pci_msix_alloc_irq_at+0x5c/0=
x70
May 27 15:47:47 manet.1015granger.net kernel:  mlx5_irq_alloc+0x22f/0x3d0 [=
mlx5_core 11229579f576884e9585dbff83cf9d4f8d975d71]

[ snip ]


>> -----Original Message-----
>> From: Chuck Lever III <chuck.lever@oracle.com>
>> Sent: Thursday, 4 May 2023 22:03
>> To: Leon Romanovsky <leon@kernel.org>; Eli Cohen <elic@nvidia.com>
>> Cc: Saeed Mahameed <saeedm@nvidia.com>; linux-rdma <linux-
>> rdma@vger.kernel.org>; open list:NETWORKING [GENERAL]
>> <netdev@vger.kernel.org>
>> Subject: Re: system hang on start-up (mlx5?)
>>=20
>>=20
>>=20
>>> On May 4, 2023, at 3:29 AM, Leon Romanovsky <leon@kernel.org> wrote:
>>>=20
>>> On Wed, May 03, 2023 at 02:02:33PM +0000, Chuck Lever III wrote:
>>>>=20
>>>>=20
>>>>> On May 3, 2023, at 2:34 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>>>=20
>>>>> Hi Chuck,
>>>>>=20
>>>>> Just verifying, could you make sure your server and card firmware are=
 up
>> to date?
>>>>=20
>>>> Device firmware updated to 16.35.2000; no change.
>>>>=20
>>>> System firmware is dated September 2016. I'll see if I can get
>>>> something more recent installed.
>>>=20
>>> We are trying to reproduce this issue internally.
>>=20
>> More information. I captured the serial console during boot.
>> Here are the last messages:
>>=20
>> [    9.837087] mlx5_core 0000:02:00.0: firmware version: 16.35.2000
>> [    9.843126] mlx5_core 0000:02:00.0: 126.016 Gb/s available PCIe
>> bandwidth (8.0 GT/s PCIe x16 link)
>> [   10.311515] mlx5_core 0000:02:00.0: Rate limit: 127 rates are support=
ed,
>> range: 0Mbps to 97656Mbps
>> [   10.321948] mlx5_core 0000:02:00.0: E-Switch: Total vports 2, per vpo=
rt:
>> max uc(128) max mc(2048)
>> [   10.344324] mlx5_core 0000:02:00.0: mlx5_pcie_event:301:(pid 88): PCI=
e
>> slot advertised sufficient power (27W).
>> [   10.354339] BUG: unable to handle page fault for address: ffffffff8ff=
0ade0
>> [   10.361206] #PF: supervisor read access in kernel mode
>> [   10.366335] #PF: error_code(0x0000) - not-present page
>> [   10.371467] PGD 81ec39067 P4D 81ec39067 PUD 81ec3a063 PMD
>> 114b07063 PTE 800ffff7e10f5062
>> [   10.379544] Oops: 0000 [#1] PREEMPT SMP PTI
>> [   10.383721] CPU: 0 PID: 117 Comm: kworker/0:6 Not tainted 6.3.0-13028=
-
>> g7222f123c983 #1
>> [   10.391625] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0b
>> 06/12/2017
>> [   10.398750] Workqueue: events work_for_cpu_fn
>> [   10.403108] RIP: 0010:__bitmap_or+0x10/0x26
>> [   10.407286] Code: 85 c0 0f 95 c0 c3 cc cc cc cc 90 90 90 90 90 90 90 =
90 90
>> 90 90 90 90 90 90 90 89 c9 31 c0 48 83 c1 3f 48 c1 e9 06 39 c8 73 11 <4c=
>
>> 8b 04 c6 4c 0b 04 c2 4c 89 04 c7 48 ff c0 eb eb c3 cc cc cc cc
>> [   10.426024] RSP: 0000:ffffb45a0078f7b0 EFLAGS: 00010097
>> [   10.431240] RAX: 0000000000000000 RBX: ffffffff8ff0adc0 RCX:
>> 0000000000000004
>> [   10.438365] RDX: ffff9156801967d0 RSI: ffffffff8ff0ade0 RDI:
>> ffff9156801967b0
>> [   10.445489] RBP: ffffb45a0078f7e8 R08: 0000000000000030 R09:
>> 0000000000000000
>> [   10.452613] R10: 0000000000000000 R11: 0000000000000000 R12:
>> 00000000000000ec
>> [   10.459737] R13: ffffffff8ff0ade0 R14: 0000000000000001 R15:
>> 0000000000000020
>> [   10.466862] FS:  0000000000000000(0000) GS:ffff9165bfc00000(0000)
>> knlGS:0000000000000000
>> [   10.474936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   10.480674] CR2: ffffffff8ff0ade0 CR3: 00000001011ae003 CR4:
>> 00000000003706f0
>> [   10.487800] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [   10.494922] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>> 0000000000000400
>> [   10.502046] Call Trace:
>> [   10.504493]  <TASK>
>> [   10.506589]  ? matrix_alloc_area.constprop.0+0x43/0x9a
>> [   10.511729]  ? prepare_namespace+0x84/0x174
>> [   10.515914]  irq_matrix_reserve_managed+0x56/0x10c
>> [   10.520699]  x86_vector_alloc_irqs+0x1d2/0x31e
>> [   10.525146]  irq_domain_alloc_irqs_hierarchy+0x39/0x3f
>> [   10.530284]  irq_domain_alloc_irqs_parent+0x1a/0x2a
>> [   10.535155]  intel_irq_remapping_alloc+0x59/0x5e9
>> [   10.539859]  ? kmem_cache_debug_flags+0x11/0x26
>> [   10.544383]  ? __radix_tree_lookup+0x39/0xb9
>> [   10.548649]  irq_domain_alloc_irqs_hierarchy+0x39/0x3f
>> [   10.553779]  irq_domain_alloc_irqs_parent+0x1a/0x2a
>> [   10.558650]  msi_domain_alloc+0x8c/0x120
>> [ rqs_hierarchy+0x39/0x3f
>> [   10.567697]  irq_domain_alloc_irqs_locked+0x11d/0x286
>> [   10.572741]  __irq_domain_alloc_irqs+0x72/0x93
>> [   10.577179]  __msi_domain_alloc_irqs+0x193/0x3f1
>> [   10.581789]  ? __xa_alloc+0xcf/0xe2
>> [   10.585273]  msi_domain_alloc_irq_at+0xa8/0xfe
>> [   10.589711]  pci_msix_alloc_irq_at+0x47/0x5c
>> [   10.593987]  mlx5_irq_alloc+0x99/0x319 [mlx5_core]
>> [   10.598881]  ? xa_load+0x5e/0x68
>> [   10.602112]  irq_pool_request_vector+0x60/0x7d [mlx5_core]
>> [   10.607668]  mlx5_irq_request+0x26/0x98 [mlx5_core]
>> [   10.612617]  mlx5_irqs_request_vectors+0x52/0x82 [mlx5_core]
>> [   10.618345]  mlx5_eq_table_create+0x613/0x8d3 [mlx5_core]
>> [   10.623806]  ? kmalloc_trace+0x46/0x57
>> [   10.627549]  mlx5_load+0xb1/0x33e [mlx5_core]
>> [   10.631971]  mlx5_init_one+0x497/0x514 [mlx5_core]
>> [   10.636824]  probe_one+0x2fa/0x3f6 [mlx5_core]
>> [   10.641330]  local_pci_probe+0x47/0x8b
>> [   10.645073]  work_for_cpu_fn+0x1a/0x25
>> [   10.648817]  process_one_work+0x1e0/0x2e0
>> [   10.652822]  process_scheduled_works+0x2c/0x37
>> [   10.657258]  worker_thread+0x1e2/0x25e
>> [   10.661003]  ? __pfx_worker_thread+0x10/0x10
>> [   10.665267]  kthread+0x10d/0x115
>> [   10.668501]  ? __pfx_kthread+0x10/0x10
>> [   10.672244]  ret_from_fork+0x2c/0x50
>> [   10.675824]  </TASK>
>> [   10.678007] Modules linked in: mlx5_core(+) ast drm_kms_helper
>> crct10dif_pclmul crc32_pclmul drm_shmem_helper crc32c_intel drm
>> ghash_clmulni_intel sha512_ssse3 igb dca i2c_algo_bit mlxfw pci_hyperv_i=
ntf
>> pkcs8_key_parser
>> [   10.697447] CR2: ffffffff8ff0ade0
>> [   10.700758] ---[ end trace 0000000000000000 ]---
>> [   10.707706] pstore: backend (erst) writing error (-28)
>> [   10.712838] RIP: 0010:__bitmap_or+0x10/0x26
>> [   10.717014] Code: 85 c0 0f 95 c0 c3 cc cc cc cc 90 90 90 90 90 90 90 =
90 90
>> 90 90 90 90 90 90 90 89 c9 31 c0 48 83 c1 3f 48 c1 e9 06 39 c8 73 11 <4c=
>
>> 8b 04 c6 4c 0b 04 c2 4c 89 04 c7 48 ff c0 eb eb c3 cc cc cc cc
>> [   10.735752] RSP: 0000:ffffb45a0078f7b0 EFLAGS: 00010097
>> [   10.740969] RAX: 0000000000000000 RBX: ffffffff8ff0adc0 RCX:
>> 0000000000000004
>> [   10.748093] RDX: ffff9156801967d0 RSI: ffffffff8ff0ade0 RDI:
>> ffff9156801967b0
>> [   10.755218] RBP: ffffb45a0078f7e8 R08: 0000000000000030 R09:
>> 0000000000000000
>> [   10.762341] R10: 0000000000000000 R11: 0000000000000000 R12:
>> 00000000000000ec
>> [   10.769467] R13: ffffffff8ff0ade0 R14: 0000000000000001 R15:
>> 0000000000000020
>> [   10.776590] FS:  0000000000000000(0000) GS:ffff9165bfc00000(0000)
>> knlGS:0000000000000000
>> [   10.784666] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   10.790405] CR2: ffffffff8ff0ade0 CR3: 00000001011ae003 CR4:
>> 00000000003706f0
>> [   10.797529] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [   10.804651] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>> 0000000000000400
>> [   10.811775] note: kworker/0:6[117] exited with irqs disabled
>> [   10.817444] note: kworker/0:6[117] exited with preempt_count 1
>>=20
>> HTH
>>=20
>> --
>> Chuck Lever
>>=20
>=20

--
Chuck Lever



