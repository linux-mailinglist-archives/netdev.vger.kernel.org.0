Return-Path: <netdev+bounces-6829-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8866F7185AC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B33DE1C20E52
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 15:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2142D16431;
	Wed, 31 May 2023 15:07:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C8C16425
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 15:07:32 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E3EE77;
	Wed, 31 May 2023 08:07:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERLGE021949;
	Wed, 31 May 2023 15:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ssNix6DvkmPaDZ+NTNZCsUaU5c82FpBS1cqUjNTRhi4=;
 b=h32qw4N5Oh5YAFOXCcomDnk5K/OMWcGtlKToFy9zzjxjzncnPsdh5bBve28kczMQ8TmC
 K29omtvXKOR2Hkgt/eDP3JAiCZ1adC7Tb4u4PiwOI7E7/H7Eh0GCGgDKWenrqcKCUxh1
 npzIyXQzSNUaJJiRjfxy8dW6OiM2PVU3eWptMH1D4Jst2YYao7HiQnPfw+ethI37Ps7e
 uCwA4mjI3JGkGt9r1P0QIs4nu9zVrnzbB1LFASSoGHcHGUgMw0aJ1N1TQwF53qYODKxy
 HoX8PZ3kzl1/s535m6mcRrD97yRvJ+douESR8GBobB8ZDhDCEDapMRolZ7DIXS6EzI3z 6w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjp4rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 15:06:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VEAuC8003622;
	Wed, 31 May 2023 15:06:19 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ydampm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 15:06:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ajVYW659VCw/ATLrNs1LjR3aPc3GpLauJFRlF2KmzkQHGA9TYbH63LCsC6XF9rwwyJMejHH+aWnhPdXI3RSnzkLFvuy4Vc8zNlcJw82VX1M31zI9VNe84wxAzeLhQLz7mHPmRDYmTTun3rByJXvSY9C4d4tabBPk+RQKWYocOvWthYgwQsey5/o0CZC8cycs01G4T6RPrth2iSxKGMyZWzUj6bdtmCfAXzSkE2ROAPdq5+Jxai1eNshqTKHacxbOHXuXKfKIIqOYh1+HsDARqCitjei4P4GrrWFVL4fQ6w/fE5MkeZhPtNk7EXIH+saWjv2W4ZsSLZoCdvXuuylleQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssNix6DvkmPaDZ+NTNZCsUaU5c82FpBS1cqUjNTRhi4=;
 b=MWS5cCtixD3kI4M4bhvaG5Qs8Qab3XasM+F4aPyiD1Pm4LPns/tT6VzQWHUAMcfIvHFezOC24tOaDPWiwXBuEPZsHJald/GmyAk33AEr9s7TAUOEhVrb+son332tEPwalfmu3RuCKvSsyz29Hy5Mo2a4829jB5+XdmmK3bRXznl15J42kctTzAPpNnSc3d7HxHyNoDQcdK/Cz/w/fyzsRPx6pbbll+ugZonnlxh+cCgvzrQyiTy95/FTWPSIk81WwFMPhxLSaBidpcG3TzxnA+RKJy1OShtv8jA012umWI6FQ3MpNoz9VCOqvEo5Po0Tu+yFpiMzmU7Af6yh4UsnoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssNix6DvkmPaDZ+NTNZCsUaU5c82FpBS1cqUjNTRhi4=;
 b=sWfzGLc4jARoYX0fsY4osmM7hW7xGFEUyNYeE5hOhCanvmqigKPH5mly4oyZ0bMydbTN4VIz4UNAbp/dg3ycieGE8vzhj6XM6UrDn/SJ3P5DD5YSIaBQUlCTH/VWENZ5YWoJTpdqlKz8hQ6E7StRthSlGYPw60PtO2mjm8MEbf4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB6530.namprd10.prod.outlook.com (2603:10b6:510:201::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Wed, 31 May
 2023 15:06:15 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 15:06:15 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Saeed
 Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Peter Zijlstra
	<peterz@infradead.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgIADNpOAgAEJHQCAAG8SAIAAIggAgAEbjoCAAAZgAA==
Date: Wed, 31 May 2023 15:06:15 +0000
Message-ID: <48B0BC74-5F5C-4212-BC5A-552356E9FFB1@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
 <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com> <87o7m1iov9.ffs@tglx>
 <C34181E7-A515-4BD1-8C38-CB8BCF2D987D@oracle.com> <87ttvsftoc.ffs@tglx>
In-Reply-To: <87ttvsftoc.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB6530:EE_
x-ms-office365-filtering-correlation-id: a0bb901c-da97-4922-84c3-08db61e894a9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 WxL0hZDtiUumav+VRR1DJEEN0hkDesiX7L32OEU30nNo0GWn4+f+a4CyekYd0wOveAhqAhwwxleO20nWmyrb6kwmjak+eb4+pv5BLn9wND/ZoQjz6VXn5K/i4RB0O0ySRISO1XebLvNilqu+aojkoF/Gu+oODI8RAZM6AlY9l2k9HmZimC02LC8af2838ScHrr6g4xj628QOwmOtHJ1K+U45wgE6iNwGDFQWSrxdmcQQd8JK2Zwd9uPzm9CPuOkiiHg7zdZ87tOsUrazaoksBMfLLmKJzQH9dnbRgomhY77588RwGfB+eiEtu4xuuXcuLSXeGeXsfa8VZt1p2r2r26DIK28mmZUBCgDdurWQtEsenWI9n84GSTg9YWap0JrOUJCFoun9oFnjj3J30Aso7msppvBmXQ1C7QdZxjGKxRhilT/Rzl5YYOCSvVt3aTQhz0zQt8Z/8Syk+euWIPToMeqhijn3rkiohnqSudaSx/gybySKpZ2HA+zoj8xJ100sjYKe0/U2QlVYjS01zjujPNAZVj9l1q6pfODbEnLpe77pyodA+5Qptijy1AxT8LriP3qVQBjbWCJSRuTCKy9OyyJheDprk9+w9WpRZYu/Kx82zr9pFseEcoXqdnPFiO/Nj30cnfv7SrWhoVHG69L31g==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199021)(41300700001)(38070700005)(86362001)(6486002)(4326008)(6916009)(71200400001)(316002)(33656002)(76116006)(66446008)(66476007)(36756003)(91956017)(64756008)(66556008)(66946007)(2616005)(5660300002)(2906002)(186003)(6512007)(53546011)(6506007)(26005)(83380400001)(38100700002)(54906003)(478600001)(8936002)(122000001)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?yNsh6k1266980cfgA0DnNxwBStVfbhfHt4lNXaAh8XJjO8Rj/fAmQsNHOhiQ?=
 =?us-ascii?Q?k6j+9YTeeLREu20sY/1lTT8jYEoluGTfvIDcrAmWbn8VSf0IlmzN3+73fo2t?=
 =?us-ascii?Q?EhytwPtWp45x+6Jzq/rQhnbMKpPiMW/n9lPFHDvrj1vPn2xrP9PLDkP8aZbK?=
 =?us-ascii?Q?hva5tZPSAgMDBTJngMDQGUyIukXtXamFN4baP6vZCGdWTjCktarv7W3m9pYM?=
 =?us-ascii?Q?YnPpeqd7qQnFi2g6s8LAZ9f2f6Y+GF1DoQoAqtLitBJ8TPrJotalzP7g2DdJ?=
 =?us-ascii?Q?St7TuObEb62dkWfczKzhF7aIOsGZzubobyRnejLRaDZASzC6rATpO+XdesLh?=
 =?us-ascii?Q?a5LmY6M5DmE9jUnbVKp74rv42IcH+l5Np2vds5EHSa8SySDugm3eP/3TEhnj?=
 =?us-ascii?Q?Qefa6RDd643IqpMxMQAiynkaxXzqI2EMpQxd7fjE+gtH1laudLp4QJRZbe8f?=
 =?us-ascii?Q?5aNuSvsv9lyAxDN4S7urR2fbtIT7fPvc87vFwEYl90t6hufBj/t1BVMC4Q+4?=
 =?us-ascii?Q?exb/8mvxGgFU6wDpP38AqhIdDnMihp0jToEjml35t4EylTumu1wOeahIpl9D?=
 =?us-ascii?Q?fpvM+g/A3030hOw8v1L2LSxyHC8vDbAM61lvazzCD9IojC2YYqSVUbbKA3V1?=
 =?us-ascii?Q?mafM+hp3HYTvXrEOsLjrE/WwFL2k1Fmd/s8FR2xeyGKqLeARc+kPjNFG7siw?=
 =?us-ascii?Q?PAROIE9zmIzo6iX7ZUSZSbA3euu71Vj9QMHyWOUF6jIbM1rV9CLWuwJo53sg?=
 =?us-ascii?Q?MLoJgct84RImEeuPfKioSz0phpLZKJod0Jz1sGXESONfO39vjaFbfnFAjwdH?=
 =?us-ascii?Q?DRJh9DFR3slEytwdX6bTf9MsljMZvYm6NhQ2fyD/hLVg/xfcLV3rR9A+1jSw?=
 =?us-ascii?Q?qWGXmW/uiXd2AexO0lcp9M5EzIzjGD/tDanhXGewWkT/57btzSmFmb9ep5y/?=
 =?us-ascii?Q?O9ufWQxuk2l8bMf6Wf6R0YAzvmOzbdQP0BaLNbuNzKfn9e3sli0ZlDK8EVT7?=
 =?us-ascii?Q?TsX9clU+kzNQAhAEkNC0WmcpYU6egXDJCgaGq2FYCMqXMCDhXK8gwjESP4pS?=
 =?us-ascii?Q?Pe4x/ctsf3cl8LwPyJSQKLWZYMOZriDJStKrykdXnScEbOfOi0tTapXokeKx?=
 =?us-ascii?Q?XOTrObQufF5TbwmG8TAD8/C01jcDpnh1l3E3lKS4iXL5AaA8LqVNcbprFeNa?=
 =?us-ascii?Q?2gLPgcbvNeD+DAgUiZLmp0JrkoLrqANP/8wBkTialxefTnOKrFwbQeyXt1bO?=
 =?us-ascii?Q?8LRQ6O1QriuAUbf0iS8gRcJxYL9VGL/B+TIgZY1wBQkuz5jQkJ98Se8r6iFN?=
 =?us-ascii?Q?6tbZ0g2sAyr6Di2v39aDemQysZJKdRusZBaWmYph32oR0X4iGHzPPpW/OKPG?=
 =?us-ascii?Q?bEO8WlY2CTBLVE2mLIxuQh6IfR6+ouYpTAMXSYlymBlzc/wGzUaTLML2JA5F?=
 =?us-ascii?Q?hniNMxtJ938X22CBtPagErOvILeByoQeu9E7XktG4P1JTR+rEdu4e1Zxn00T?=
 =?us-ascii?Q?JIDZ+A2vsu6vdWdTxS13KrBcZfYnF27WFudN2DTMivyR87XKs/zICAknOueW?=
 =?us-ascii?Q?zqO12qM/KrYIRMYmDnvFwU5ojKpccv94RtY7ghD+aE3l4M2cYGi7vup5u8Lb?=
 =?us-ascii?Q?0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1ED76A1AEB1D174BAB6E01FC5C52D227@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6a596yQhFFvyvPTPYU0CG0qeFDltlq9/AIIASFPckiRXRRaszKCoTD/3EItYGmmLbKUA4qMn42hBCUfqrAIb6wXCcnKAWa1LQhGYmxkT+bRy/2K7/lJPhU1hsm4jVgTEihWLz7NDxSe5mn1yKb+Lc0dh72k/Q9VPLUhqZPeFBMYqrEYn8TWWSKs5J+HHQ7C7vU/ZtXR1qg78gHJS4XyVHh5v9my0PjkVUgpC+GQwTEgCxLtXQ7SgMhVrz7Up2e2ArUx4ztpNhTZ1HhfLBv8BOIGZKvFJiqeGKmu3vbO3m90BeNGW+5KMRa0o+dED65iml1WOPQq0ulzW/9MQm6178WGm7qFVmSmIOvsaRPrnR9Rjj2u+DEZ0l3utxpGIrErwnZMzZu5diEjoq0c+c35BoocGHpFbnKNxiw4dpPA174PsOn+ImOd/KS73wgzE7l1Rq0HlRgNu2EqhvOPWD4cTF1GMfSVeLVI0TknAFb5VMxaUB4hN2A9SPjewQ/YR8xbAcwgtqa6WjkKPCcJ7Fl4PIrzCU0eBrRe74YA17hbmi5wRVPQKBDLhwFwXySrS91Nu6yF6SisRHerkmTBnn+WlrU/MNatthdl4F7HDkE6VJNok48xUAJ1U+vNtOQWhM17aH4LvMq00Xly98kG7m/aKlU1cR+cWAPl93dwMTNmzsSsw4hlOwVino/O1WYbb12tX7BD8KQQTFveBjCsijxTb0k7cNC2zt1ROO19tuYP7Dk4vR+YHSXjN/kpeO2FL9vwsMZniY4U3/QbCuohGkQaxmQR3yI1rO/R4Mf3Hy1fYw1CR5VjqlCKw9Q3IXotfun4NJZ+zf7SP7GeJjTYUleqvVJROvTgXi6w9xMMw0KF8nMfX7/sBjZ9qBMsslJRZTIwpvvYlFcKSTyP6TR/QaNO5ag==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bb901c-da97-4922-84c3-08db61e894a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:06:15.7205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GAm1/xk299tRb2TByG8FVKN1rD/07MuMLnlejCklbGUINMAwKeFxOs+UxyC5hhX2VCvd3rEvPq75I+s4F33kNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310128
X-Proofpoint-ORIG-GUID: gITHtjtPdYqLi5CehjM3PNbYVlafcf49
X-Proofpoint-GUID: gITHtjtPdYqLi5CehjM3PNbYVlafcf49
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 31, 2023, at 10:43 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> On Tue, May 30 2023 at 21:48, Chuck Lever III wrote:
>>> On May 30, 2023, at 3:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote=
:
>>> Can you please add after the cpumask_copy() in that mlx5 code:
>>>=20
>>>   pr_info("ONLINEBITS: %016lx\n", cpu_online_mask->bits[0]);
>>>   pr_info("MASKBITS:   %016lx\n", af_desc.mask.bits[0]);
>>=20
>> Both are 0000 0000 0000 0fff, as expected on a system
>> where 12 CPUs are present.
>=20
> So the non-initialized mask on stack has the online bits correctly
> copied and bits 12-63 are cleared, which is what cpumask_copy()
> achieves by copying longs and not bits.
>=20
>> [   71.273798][ T1185] irq_matrix_reserve_managed: MASKBITS: ffffb1a7468=
6bcd8
>=20
> How can that end up with a completely different content here?
>=20
> As I said before that's clearly a direct map address.
>=20
> So the call chain is:
>=20
> mlx5_irq_alloc(af_desc)
>  pci_msix_alloc_irq_at(af_desc)
>    msi_domain_alloc_irq_at(af_desc)
>      __msi_domain_alloc_irqs(af_desc)
> 1)      msidesc->affinity =3D kmemdup(af_desc);
>        __irq_domain_alloc_irqs()
>          __irq_domain_alloc_irqs(aff=3Dmsidesc->affinity)
>            irq_domain_alloc_irqs_locked(aff)
>              irq_domain_alloc_irqs_locked(aff)
>                irq_domain_alloc_descs(aff)
>                  alloc_desc(mask=3D&aff->mask)
>                    desc_smp_init(mask)
> 2)                    cpumask_copy(desc->irq_common_data.affinity, mask);
>                irq_domain_alloc_irqs_hierarchy()
>                  msi_domain_alloc()
>                    intel_irq_remapping_alloc()
>                      x86_vector_alloc_irqs()

It is x86_vector_alloc_irqs() where the struct irq_data is
fabricated that ends up in irq_matrix_reserve_managed().


>                        reserve_managed_vector()
>                          mask =3D desc->irq_common_data.affinity;
>                          irq_matrix_reserve_managed(mask)
>=20
> So af_desc is kmemdup'ed at #1 and then the result is copied in #2.
>=20
> Anything else just hands pointers around. So where gets either af_desc
> or msidesc->affinity or desc->irq_common_data.affinity overwritten? Or
> one of the pointers mangled. I doubt that it's the latter as this is 99%
> generic code which would end up in random fails all over the place.
>=20
> This also ends up in the wrong place. That mlx code does:
>=20
>   af_desc.is_managed =3D false;
>=20
> but the allocation ends up allocating a managed vector.

That line was changed in 6.4-rc4 to address another bug,
and it avoids the crash by not calling into the misbehaving
code. It doesn't address the mlx5_core initialization issue
though, because as I said before, execution continues and
crashes in a similar scenario later on.

On my system, I've reverted that fix:

-       af_desc.is_managed =3D false;
+       af_desc.is_managed =3D 1;

so that we can continue debugging this crash.


> Can you please instrument this along the call chain so we can see where
> or at least when this gets corrupted? Please print the relevant pointer
> addresses too so we can see whether that's consistent or not.

I will continue working on this today.


>> The lowest 16 bits of MASKBITS are bcd8, or in binary:
>>=20
>> ... 1011 1100 1101 1000
>>=20
>> Starting from the low-order side: bits 3, 4, 6, 7, 10, 11, and
>> 12, matching the CPU IDs from the loop. At bit 12, we fault,
>> since there is no CPU 12 on the system.
>=20
> Thats due to a dubious optimization from Linus:
>=20
> #if NR_CPUS <=3D BITS_PER_LONG
>  #define small_cpumask_bits ((unsigned int)NR_CPUS)
>  #define large_cpumask_bits ((unsigned int)NR_CPUS)
> #elif NR_CPUS <=3D 4*BITS_PER_LONG
>  #define small_cpumask_bits nr_cpu_ids
>=20
> small_cpumask_bits is not nr_cpu_ids(12), it's NR_CPUS(32) which is why
> the loop does not terminate. Bah!
>=20
> But that's just the symptom, not the root cause. That code is perfectly
> fine when all callers use the proper cpumask functions.

Agreed: we're crashing here because of the extra bits
in the affinity mask, but those bits should not be set
in the first place.

I wasn't sure if for_each_cpu() was supposed to iterate
into non-present CPUs -- and I guess the answer
is yes, it will iterate the full length of the mask.
The caller is responsible for ensuring the mask is valid.


--
Chuck Lever



