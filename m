Return-Path: <netdev+bounces-7661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D615A721046
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 15:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BA752819D6
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 13:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EBE5C8DE;
	Sat,  3 Jun 2023 13:53:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394F22904
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 13:53:57 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999959F;
	Sat,  3 Jun 2023 06:53:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3536beVW008294;
	Sat, 3 Jun 2023 13:53:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dR3W8mEoGMenOVoWhsBkkRQoN9bN3iwdvQT2uuZXDJY=;
 b=dWEF5cFoEsyIK4FLzNNVWiM5+TZ6iO0LnCOjfe1txy43sS+2yTPi8uWAjgqTKXnDB222
 9gr4SvSqQx+o9/OyJjet2yB9+xjN7qhrrgYxeIZZGQOZQRSwgjWW67QMdG3aaSj5/ywu
 tWNjIZWjWv2W0u8OU6+MLm8/Pz4g0T6Ae0WREnXtnStLee5nY7vmoyZips0E7V1uSCPZ
 7WPa7vsyXDSdhn5upy/WHG2SBElclvL/zIpASUbZvnRLdQoqxoDhThmFMCtixfVJF+go
 jv1W5M3HpMS/PC9uiSSWrHf6BLXdHTy3gQgHTknIRC7HWUCNXeWxXPijoiwjB2373PpT vA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qyx5eggrr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Jun 2023 13:53:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 353BPMYn035279;
	Sat, 3 Jun 2023 13:53:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qyuy7td2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Jun 2023 13:53:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RErWltaLl7HXSLMC4MWObfqooEjAWv4YIMkh1CUyZYtEf0V+++EBtlXBbOE47xtZhaeNVZKaZ4dIL8zJa+jTiYvq8jUMM1DqVRA+zEM0CIY+TBvCyTKD0CQGppfcBKfVlVQS5lg8azZBWy5PpMGJ96uPZvbgC+rp/rs0T6tJQnlb+ad+TkitpoW0LkU0ma9NuehuRMQI65Aj6jyAzi8y6NAcbD4+dnsuEB9nnZVB8dzxulo6TzsTu1UTDNFu2MBanAB9/WvFg9929uV0AXCYrB7BOvn0CXSpSu7C3Y7pyEyepD9bUYgr1nTrRkxQDSy0hNl2mPS5yXDZtKq2TD2rkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dR3W8mEoGMenOVoWhsBkkRQoN9bN3iwdvQT2uuZXDJY=;
 b=Wtis9G1Lr6njHkvvfiZgLwigd70u3Js5sVLRIpb7CgjzauESJ/sF2cPO/9LyCpBSkZCBoLeRxe4+RmxHNadCmt/xDJhodDB/tTOPo5nSJtCgqVdD8meP+RccJUB1qIIqwOIICTVmDBatBR/TXtTzgdxlq3IiRkKBs2TK+Mx8EjMAGW9EijxZcOdX7O9Fjlyhr/Gxkcp5TSHwNKeexpQtgiTBRujjEHNMqrDKEdOjMFXJLMVCjXUDlGGawDQdlm6BW+kmq41BN4kQaAL4UIUrRGdEJ7JTTdY5OW3tOQ/TNMYYYOV5b9HTX3RqzINTtUzi6h7UbisimHTiTwlocBf+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dR3W8mEoGMenOVoWhsBkkRQoN9bN3iwdvQT2uuZXDJY=;
 b=p03a2VZt97G6AwKipbox0M5D6sqkq7aMVIrnECyzr6XFzTGcZ6B8cFK0DRRaHJfGRykJ1pY+7jBt7INcTQKiCg2S3dd9Yh8ZQejHhWh+IF/AcJsXgGTDsFo/JZFNbTKTklARvfjznyVrLhibyYjcE3q1s4HV9NmB44O2Lt9ZpHo=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB7851.namprd10.prod.outlook.com (2603:10b6:510:30d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 13:53:26 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.030; Sat, 3 Jun 2023
 13:53:26 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Bernard Metzler <BMT@zurich.ibm.com>
CC: Tom Talpey <tom@talpey.com>, Chuck Lever <cel@kernel.org>,
        Jason Gunthorpe
	<jgg@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Topic: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Index: AQHZlYfl1VISa1yiqkOAQn9cpjE/2694FVwAgAAlcwCAAN8IAIAAAJcA
Date: Sat, 3 Jun 2023 13:53:26 +0000
Message-ID: <4D92D284-5031-4676-BFBE-A47B60255219@oracle.com>
References: 
 <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <783511ce-8950-c52c-2351-eef8841c67da@talpey.com>
 <F0D9A24E-CFC9-4100-89E5-A5BDF24D3621@oracle.com>
 <SA0PR15MB3919D432A5401D3E459A83B6994FA@SA0PR15MB3919.namprd15.prod.outlook.com>
In-Reply-To: 
 <SA0PR15MB3919D432A5401D3E459A83B6994FA@SA0PR15MB3919.namprd15.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB7851:EE_
x-ms-office365-filtering-correlation-id: 14853faf-4f65-4fda-7d7f-08db6439e7a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 phmkfXoFdkOPuIBSP3/0jlQrR94zod4mkZ7DP3KSy9vQYnTYbn5UtViTJ15U1I1/3JZDV1JNwixeIOQsz74v1vTsOQ227Pr1R6/GJqDWhgdM3YFRRswxYbhd0PY8olNLyBaSkWTHAzr9/mMp4H6hcFRtoxaAN/bVLEXUp+OQTx0ocRjolMtW/yLBGzmKT2trV1iA7og+SNyIEjNq+UxZXvhRa+p24WMTLUD5ACoqmPjiJ8hh+q8XmM9Q/yOBeo6sqfOOwC2IoNdY5XQpPWT2aRkDQTuvluaCAlTOglqBKnMgre7S49EKazPPhlAFQjgzueQ6bbkBICmd5NjRZXDwXAPbdVSGfeVjXcXHNcgJOdzo5mPazGORcN6uFIrwD7z5v48CdCiib2qIHQlHAGsly4mJhrBJrmOQdOARtyzbsvAhX5cl8rFvQ3UEoA+n0rJYuXtKnwGPgMRMa3OqDb8jx20yOnorIgxkYhBDyWq/RsP8T2xpHEV2wWlXHNyaRIEL556KIx1O0CZIykSkqgJ/KxgJsBuSNKf95O5wRLqd7b/QbKaa4GTU4SwJYZWXObQ/Cj9vjtsZZwAOuyOomxSE2frHQldq+aGOtu8OsdeHELNwxK3sGQ102UIHcxF4tFGMTjiP7JnpqGWhXw4IcM8oVg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(53546011)(2616005)(36756003)(6506007)(6512007)(26005)(186003)(91956017)(2906002)(4326008)(76116006)(66446008)(66946007)(64756008)(66476007)(6916009)(122000001)(66556008)(478600001)(54906003)(38070700005)(8936002)(8676002)(316002)(5660300002)(38100700002)(41300700001)(6486002)(33656002)(83380400001)(86362001)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?M1BWVXlzclF4QjhTV1hoVjQwVjM2WlpmUmMxaE5pYzY2cnY2M3B0N0YxU0F6?=
 =?utf-8?B?M1NtRlNnMHlUVlNQMnVORlMvMnZkQnhNRHRZb29QQlY2RUdJNm90T1d5Z0I5?=
 =?utf-8?B?YnVHbmtzYmdrb1FiMWlzV1FXVDNadE5lTVZjc1liYWVGdEQ0VUZ6QVlqcER1?=
 =?utf-8?B?a2tDMndsOFZTODFGWlA3QVpXOE9yczlETndGak9YaTl0YlQyeXJGbHp3R1U4?=
 =?utf-8?B?NHJkL2pndlpjWFVSZU4zTE9EK0RydUhEZ2t0cmFteDlrajhzTzc2MDZhZUJX?=
 =?utf-8?B?SFNrb0c3ekN3VGpIYzhUTGZWcE9NYTdqUnB6N2FlME5aZU9BUVFQZE1oSE8r?=
 =?utf-8?B?SElsMCtLUWg0UVYzTEprekVESkU3ZGJ2UFFxSWNSRWQ3dFNOTXNUeHpnYWVF?=
 =?utf-8?B?MFBBNEtiaGVqdFpqQVZnb2NodEZQRTJSQjcxOHRyNUVjQVd4K2tPa3NIL3dv?=
 =?utf-8?B?R3o5VzNaNEo3dWhWdDI2clIxTDY3N1lYTmFFVGNoVmNsb0lJQ3pOWGFCMzlX?=
 =?utf-8?B?UzZDMmFUNU1meWc3RlExSlpRanM1MTNYYUt0eG0xaHUyVjV0ci9aamNEV0VQ?=
 =?utf-8?B?WGxoajlSbHhYZndndFhSa2ZLaVNIZUMzbEFSSUJ1WTIvNmdrSnY0dmE0TFpa?=
 =?utf-8?B?RkNuWm1CbThIVlBKa0lsWDQ0RHdjZ0tBaGN5Uk9JMXd4T1JZSHpJTHNqMVVQ?=
 =?utf-8?B?RFUwdFVXWXdtOVRVYnJ6UHVDWmpDblVCdWtKZ1VJdGdZWmlHSEdNTkRGTUVS?=
 =?utf-8?B?cFRWL3VSdkxIb1R1SjVibUl1bndjL2dWTytoUlh5V2RVNEV0aWlBR1A5c0Rh?=
 =?utf-8?B?S1g2UU1BTHg4SW1sQlBVVHlEUU11RVJLWFJNNlFNY2g1RkpNbVphZW02bVhX?=
 =?utf-8?B?Uk1Za1VQUkVHWWYvaTZFdGFEM1VPa09IaS9QMzY4Zk9RNzRRZlpDVTQ3NGQ1?=
 =?utf-8?B?QkI5OGtCVnZYV3FSM3VDVkdBOTRZY1JUVWlLOFJjTmdZN1pTRWI1ZzlDT1E4?=
 =?utf-8?B?M3ZtenE2RDdGOEsvbUUvTFY1N0t2TzRLZDF2clZoRHhBT21STlVCSzNDMEh2?=
 =?utf-8?B?MzYzY2V1azhKMTB5N0JxUlkyaWlQenF6NzFIMW4rRDJJc29NbjlIWFExcGdi?=
 =?utf-8?B?Nnl3bXFBdlJEakViRGltMzFGaW5SOTNMT3IyQktOMkdMMmV0T3gwRHk5anlm?=
 =?utf-8?B?MitEUEMrOUpJTjRqSnoxdElTRkJabVVqK0k1VUVsMDZGOGJaOFB6OWJDVlVk?=
 =?utf-8?B?eHdrNy9KSkhVdGY0azJZWHVRdTg3SkcyWDc4NFJIU3U1MXZIalVFV1MxRmsr?=
 =?utf-8?B?U1NadEk4YmhHMjd1RS9FL1hYOHplWk5HMW40RmxMVlZCbHQrQ2p5OVh2K2pu?=
 =?utf-8?B?WTM4by85azJkSDVxOVY0WGRNdWkrR1NiZDVBN0drbit0VUxkVXdzOUJtT2hK?=
 =?utf-8?B?MVBHTlJaSWUvaDVxSEFoeDZlV0JLVEZ3RUdFZXpWZ3oxSHpZOXZEQ0FLbXVD?=
 =?utf-8?B?MGNwZmFET2ZTSDNuWHVvOUFyOWFOa2NWN3hiUmIxT0VMblZkc1FINWRyVDFV?=
 =?utf-8?B?Z0szVzQyNEpPYy9ERlJPNWk5YitHSTFuZGpueG1uVjIvVlVacUJyWDk3QTFQ?=
 =?utf-8?B?eS9uTG10ZUpiSTlRWFJjK2ZjaWcvWW50QXg5Q1dmdFU2NTBaODBqVkNuYWpn?=
 =?utf-8?B?MHJpalBQdFB2Z2Rjd2diaG9haTE4U1paMkJjajJ6b2k5dFB0Q2Y2ZHc2d0V4?=
 =?utf-8?B?K2JxK3pmNjRBS3Z6bU5STFF0ck83L1EzY3hsdlFVV2tMU0t2RTZIakMwS1BF?=
 =?utf-8?B?TGZHbkk3VzFkYm1XRHdwMmdhMFJESmlaZjdJU3E1dGxmQkdPKzZreVNzRlJQ?=
 =?utf-8?B?M3VtUkZXQnZFR2d5QkZKMVhUSlMvVzkvM0Y0Z2o4Y1FQdWdsT0E2TDExNkxN?=
 =?utf-8?B?SzVHdUlwSjE1cUgzQ2lsWkE4UnpHZzdtU25PSTQ2RURHVGQ2QmRmQmlEc3VU?=
 =?utf-8?B?M0RibnpOcko4SjZDczBkaHdBM3BrVHdyUEh3RFc0eWtCOURHRjV4RkxHbUEv?=
 =?utf-8?B?Rm1SV2FGZnBxby9OL3BIa1p0QUg1V2lmWWNNeUlQWkQyb05ZZ05oTU1TSWJo?=
 =?utf-8?B?QXQ0Qk5yU1VVUXo5bXpIMm1haDZHTEk5Wm1ueHBhY0hScTl3VURtelA5MXFO?=
 =?utf-8?B?akE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86792B4216DBA041A06001DBCEAD9421@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MRYGkhdX8lVKCzWnNr/OdFBE8wWLeMsUiBTSTnqphVWdKXMLmzkELtFfPIJFRK5nbz0qxYSjuWrJV9AzvXbewFP/jNSW4S/z2I/KQI5FXGcPDCqK6qu6xG/fI3TTZVSWtqDFZxZdXTad0/80+OHBuGr/gXufkwcXl3aR+FuZVYMWxV6zoE4/BwyrtEGVDmfmr8rgSJl7Ysy2nyyqSekzxy6hr3VWT8lYcJHvWVYlnVrWtlnTB+OvEmBvvnD6ANjRaVL4lF+HQJiv53/3CfTkefvTbo77A8OBa3nkY3uzR313vVL6OwN2CrpvRsSPYXK7wA5r5lvHAGou4hZfIJqWmesEMQuzMt4F4JZJcEd4YctNQtmp4Tkr5pMAyBgyTmscGf9jmo7dskj4mlGQMuTvRYfY1p5rRO2nEE7Jw/5jITJCASTA889zEUZDJSIbl3uYIP1tGFd02vS/g4r6oBQsBdJmORl9gYH9jBji7ljccVAjiMEzSwElh7unPnEEVM9gO8tAe8fOtpVZUlFwaPsFLuBvzFokKcmVac3y9Y+S4Y3T4N18ZaheRQf5yzIYaovVLdERVDPlHdGqhCj//x2MKjZeA4o23LIDNav2ervnn7uAHUJRzmdeDCT8gjoDkpqSqKGysmd3uoP3pLtn/CjSB2PeAPZ2Ftk4vFlgCjNejIsgNl8fNKCNZb3r3i8ke1Z1PZxvW/rEnooWZT4LtQR6ZLhtAJ4TMtMjFTSXH9XUS3SRaTyW3agHo9/Wh4EUTxPGmYg9t6rBVer1at4LnmHjxDoWkvC7oHnTuuv7tN9MyBVYPzdF9WA+sjNAYjx+sSWVyUaV6yq8dsPNuwy8skvTV3KAtAXED5ObMnbQPJi/msDpzZYuuaXJaporRLbC1YBZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14853faf-4f65-4fda-7d7f-08db6439e7a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 13:53:26.4709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NCOhVCcWcosMbPADTaLLpb77ryn2wbtrsp01yFe/rn5qGZEFu+E2uosJzls0utbbAHk5XcHzkafB68nBE5Qzvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7851
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306030127
X-Proofpoint-ORIG-GUID: FUUPqIlEUT1k4ioDIyy3EZtH0ia3EzBI
X-Proofpoint-GUID: FUUPqIlEUT1k4ioDIyy3EZtH0ia3EzBI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gT24gSnVuIDMsIDIwMjMsIGF0IDk6NTEgQU0sIEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1
cmljaC5pYm0uY29tPiB3cm90ZToNCj4gDQo+IA0KPiANCj4+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+PiBGcm9tOiBDaHVjayBMZXZlciBJSUkgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+
DQo+PiBTZW50OiBTYXR1cmRheSwgMyBKdW5lIDIwMjMgMDI6MzMNCj4+IFRvOiBUb20gVGFscGV5
IDx0b21AdGFscGV5LmNvbT4NCj4+IENjOiBDaHVjayBMZXZlciA8Y2VsQGtlcm5lbC5vcmc+OyBK
YXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPjsgbGludXgtDQo+PiByZG1hIDxsaW51eC1y
ZG1hQHZnZXIua2VybmVsLm9yZz47IEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1cmljaC5pYm0uY29t
PjsNCj4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4+IFN1YmplY3Q6IFtFWFRFUk5BTF0gUmU6
IFtQQVRDSCBSRkNdIFJETUEvY29yZTogSGFuZGxlIEFSUEhSRF9OT05FIGRldmljZXMNCj4+IA0K
Pj4gDQo+PiANCj4+PiBPbiBKdW4gMiwgMjAyMywgYXQgNjoxOCBQTSwgVG9tIFRhbHBleSA8dG9t
QHRhbHBleS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IE9uIDYvMi8yMDIzIDM6MjQgUE0sIENodWNr
IExldmVyIHdyb3RlOg0KPj4+PiBGcm9tOiBDaHVjayBMZXZlciA8Y2h1Y2subGV2ZXJAb3JhY2xl
LmNvbT4NCj4+Pj4gV2Ugd291bGQgbGlrZSB0byBlbmFibGUgdGhlIHVzZSBvZiBzaXcgb24gdG9w
IG9mIGEgVlBOIHRoYXQgaXMNCj4+Pj4gY29uc3RydWN0ZWQgYW5kIG1hbmFnZWQgdmlhIGEgdHVu
IGRldmljZS4gVGhhdCBoYXNuJ3Qgd29ya2VkIHVwDQo+Pj4+IHVudGlsIG5vdyBiZWNhdXNlIEFS
UEhSRF9OT05FIGRldmljZXMgKHN1Y2ggYXMgdHVuIGRldmljZXMpIGhhdmUNCj4+Pj4gbm8gR0lE
IGZvciB0aGUgUkRNQS9jb3JlIHRvIGxvb2sgdXAuDQo+Pj4+IEJ1dCBpdCB0dXJucyBvdXQgdGhh
dCB0aGUgZWdyZXNzIGRldmljZSBoYXMgYWxyZWFkeSBiZWVuIHBpY2tlZCBmb3INCj4+Pj4gdXMu
IGFkZHJfaGFuZGxlcigpIGp1c3QgaGFzIHRvIGRvIHRoZSByaWdodCB0aGluZyB3aXRoIGl0Lg0K
Pj4+PiBTdWdnZXN0ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+Pj4+
IFNpZ25lZC1vZmYtYnk6IENodWNrIExldmVyIDxjaHVjay5sZXZlckBvcmFjbGUuY29tPg0KPj4+
PiAtLS0NCj4+Pj4gZHJpdmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMgfCAgICA0ICsrKysNCj4+
Pj4gMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQ0KPj4+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9pbmZpbmliYW5kL2NvcmUvY21hLmMNCj4+IGIvZHJpdmVycy9pbmZpbmliYW5kL2NvcmUv
Y21hLmMNCj4+Pj4gaW5kZXggNTZlNTY4ZmNkMzJiLi4zMzUxZGM1YWZhMTcgMTAwNjQ0DQo+Pj4+
IC0tLSBhL2RyaXZlcnMvaW5maW5pYmFuZC9jb3JlL2NtYS5jDQo+Pj4+ICsrKyBiL2RyaXZlcnMv
aW5maW5pYmFuZC9jb3JlL2NtYS5jDQo+Pj4+IEBAIC03MDQsMTEgKzcwNCwxNSBAQCBjbWFfdmFs
aWRhdGVfcG9ydChzdHJ1Y3QgaWJfZGV2aWNlICpkZXZpY2UsIHUzMg0KPj4gcG9ydCwNCj4+Pj4g
IG5kZXYgPSBkZXZfZ2V0X2J5X2luZGV4KGRldl9hZGRyLT5uZXQsIGJvdW5kX2lmX2luZGV4KTsN
Cj4+Pj4gIGlmICghbmRldikNCj4+Pj4gIHJldHVybiBFUlJfUFRSKC1FTk9ERVYpOw0KPj4+PiAr
IH0gZWxzZSBpZiAoZGV2X3R5cGUgPT0gQVJQSFJEX05PTkUpIHsNCj4+Pj4gKyBzZ2lkX2F0dHIg
PSByZG1hX2dldF9naWRfYXR0cihkZXZpY2UsIHBvcnQsIDApOw0KPj4+PiArIGdvdG8gb3V0Ow0K
Pj4+PiAgfSBlbHNlIHsNCj4+Pj4gIGdpZF90eXBlID0gSUJfR0lEX1RZUEVfSUI7DQo+Pj4+ICB9
DQo+Pj4+ICAgIHNnaWRfYXR0ciA9IHJkbWFfZmluZF9naWRfYnlfcG9ydChkZXZpY2UsIGdpZCwg
Z2lkX3R5cGUsIHBvcnQsDQo+PiBuZGV2KTsNCj4+Pj4gK291dDoNCj4+Pj4gIGRldl9wdXQobmRl
dik7DQo+Pj4+ICByZXR1cm4gc2dpZF9hdHRyOw0KPj4+PiB9DQo+Pj4gDQo+Pj4gSSBsaWtlIGl0
LCBidXQgZG9lc24ndCB0aGlzIHRlc3QgaW4gc2l3X21haW4uYyBhbHNvIG5lZWQgdG8gY2hhbmdl
Pw0KPj4+IA0KPj4+IHN0YXRpYyBzdHJ1Y3Qgc2l3X2RldmljZSAqc2l3X2RldmljZV9jcmVhdGUo
c3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldikNCj4+PiB7DQo+Pj4gLi4uDQo+Pj4gLS0+IGlmIChu
ZXRkZXYtPnR5cGUgIT0gQVJQSFJEX0xPT1BCQUNLICYmIG5ldGRldi0+dHlwZSAhPSBBUlBIUkRf
Tk9ORSkgew0KPj4+IGFkZHJjb25mX2FkZHJfZXVpNDgoKHVuc2lnbmVkIGNoYXIgKikmYmFzZV9k
ZXYtPm5vZGVfZ3VpZCwNCj4+PiAgIG5ldGRldi0+ZGV2X2FkZHIpOw0KPj4+IH0gZWxzZSB7DQo+
Pj4gLyoNCj4+PiAqIFRoaXMgZGV2aWNlIGRvZXMgbm90IGhhdmUgYSBIVyBhZGRyZXNzLA0KPj4+
ICogYnV0IGNvbm5lY3Rpb24gbWFuZ2FnZW1lbnQgbGliIGV4cGVjdHMgZ2lkICE9IDANCj4+PiAq
Lw0KPj4+IHNpemVfdCBsZW4gPSBtaW5fdChzaXplX3QsIHN0cmxlbihiYXNlX2Rldi0+bmFtZSks
IDYpOw0KPj4+IGNoYXIgYWRkcls2XSA9IHsgfTsNCj4+PiANCj4+PiBtZW1jcHkoYWRkciwgYmFz
ZV9kZXYtPm5hbWUsIGxlbik7DQo+Pj4gYWRkcmNvbmZfYWRkcl9ldWk0OCgodW5zaWduZWQgY2hh
ciAqKSZiYXNlX2Rldi0+bm9kZV9ndWlkLA0KPj4+ICAgYWRkcik7DQo+Pj4gfQ0KPj4gDQo+PiBJ
J20gbm90IHN1cmUgdGhhdCBjb2RlIGRvZXMgYW55dGhpbmcuIFRoZSBiYXNlX2RldidzIG5hbWUg
ZmllbGQNCj4+IGlzIGFjdHVhbGx5IG5vdCBpbml0aWFsaXplZCBhdCB0aGF0IHBvaW50LCBzbyBu
b3RoaW5nIGlzIGNvcGllZA0KPj4gaGVyZS4NCj4+IA0KPiBPaCBpbiB0aGF0IGNhc2UgaXTigJlz
IGFuIGlzc3VlIGhlcmUuDQoNCkkgaGF2ZSBhIHBhdGNoIHRoYXQgZmFicmljYXRlcyBhIHByb3Bl
ciBHSUQgaGVyZSB0aGF0IEkgY2FuDQpwb3N0IHNlcGFyYXRlbHkuDQoNCg0KPj4gSWYgeW91J3Jl
IGFza2luZyB3aGV0aGVyIHNpdyBuZWVkcyB0byBidWlsZCBhIG5vbi16ZXJvIEdJRCB0bw0KPj4g
bWFrZSB0aGUgcG9zdGVkIHBhdGNoIHdvcmssIG1vcmUgdGVzdGluZyBpcyBuZWVkZWQ7IGJ1dCBJ
IGRvbid0DQo+PiBiZWxpZXZlIHRoZSBHSUQgaGFzIGFueSByZWxldmFuY2UgLS0gdGhlIGVncmVz
cyBpYl9kZXZpY2UgaXMNCj4+IHNlbGVjdGVkIGJhc2VkIGVudGlyZWx5IG9uIHRoZSBzb3VyY2Ug
SVAgYWRkcmVzcyBpbiB0aGlzIGNhc2UuDQo+PiANCj4gDQo+IFRoZSB3aG9sZSBHSUQgYmFzZWQg
YWRkcmVzcyByZXNvbHV0aW9uIEkgdGhpbmsgaXMgYW4NCj4gYXJ0ZWZhY3Qgb2YgSUIvUm9DRSBh
ZGRyZXNzIGhhbmRsaW5nLiBpV2FycCBpcyBzdXBwb3NlZCB0bw0KPiBydW4gb24gVENQIHN0cmVh
bXMsIHdoaWNoIGVuZHBvaW50cyBhcmUgd2VsbCBkZWZpbmVkIGJ5IEwzDQo+IGFkZHJlc3Nlcy4g
SVAgcm91dGluZyBzaGFsbCBkZWZpbmUgdGhlIG91dGdvaW5nIGludGVyZmFjZS4uLg0KPiBzaXcg
dHJpZXMgdG8gcGxheSB3ZWxsIGFuZCBpbnZlbnRzIEdJRHMgdG8gc2F0aXNmeQ0KPiB0aGUgUkRN
QSBjb3JlIGNvbmNlcHRzLiBCdXQgYSBHSUQgaXMgbm90IHBhcnQgb2YgdGhlIGlXYXJwDQo+IGNv
bmNlcHQuIEkgYW0gbm90IHN1cmUgZm9yICdyZWFsJyBIVyBpV2FycCBkZXZpY2VzLCBidXQgdG8N
Cj4gbWUgaXQgbG9va3MgbGlrZSB0aGUgaXdjbSBjb2RlIGNvdWxkIGJlIGRvbmUgbW9yZQ0KPiBp
bmRlcGVuZGVudGx5LCBpZiBubyBhcHBsaWNhdGlvbiBleHBlY3RzIHZhbGlkIEdJRHMuDQoNCg0K
LS0NCkNodWNrIExldmVyDQoNCg0K

