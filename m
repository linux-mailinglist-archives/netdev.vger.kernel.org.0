Return-Path: <netdev+bounces-7432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E0B7203F1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 607DB1C20F8B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0BBC19914;
	Fri,  2 Jun 2023 14:03:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95BD17748
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:03:43 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751E913D;
	Fri,  2 Jun 2023 07:03:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352CQFlm028608;
	Fri, 2 Jun 2023 14:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=xY1hRQfXH3z3tY51KGZ9JFhkmgsHe+TqUlkvt1J24FM=;
 b=ppfYvjdHERTPIBUFcqR2gbhK9wuJ9gozGw3JjGhFnNpo6jHzvW1I9EQSsH5N/7joTm38
 CxeBevZWzDSQ3Zg8lKjvD/molML58OuUyQMGJ8sWk5fB/NO58Hv21YCQmfiurgA/L2Vw
 FE9Co2WZpEXwCtsKPlItVvdKDIQIOw9k1xcL2xaTpOvTPBTKujQSauOQyAZsu57i1GV/
 3Qo8AYvTCxgO18MlBGYHFsNSD6w76wj93V1/vgmHu2p35lvtSZ2OZzEjnMVDwK38yj/j
 zP/vsxaCAUV4Atn8YkpYOJu841wgwx1jWjrRqkae1BDvp2aXOXbwj8wPBrXFkHhaS09f mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjku2v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jun 2023 14:03:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 352CMGOt031848;
	Fri, 2 Jun 2023 14:03:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8qd62r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jun 2023 14:03:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNJEI5qyOPo540BPotvHd8Zz+UA8B87fPDVGjkjUSl0mh4hNlfqyBXQioKkjCEGs5q6Lx2u+8dlLYkM4Ysh4eeoCWNmuTd6wsLx+HAdfAKiWw0CectpPDENH/cxTCl3Gqf3M/50h5tHfXNKeWG4B2TK/GvQEL5x7V2SYXt/wPX2mTRLHlK3nCNGmG3mStqTOpAsM4hiM7Kufoyu6FLUbGf+ugP4XyKakIKp4KbzCEbF9QkO38CIAS4/yKV5f0Ar+Y8U0T5BPfU9o48HKFgFL7OcCF8Uc6LfaKY/6NUNKFcTkN6ezXvEVmELL5CWgZPY6L6kgg53W4BxVeqPg+k3Xuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xY1hRQfXH3z3tY51KGZ9JFhkmgsHe+TqUlkvt1J24FM=;
 b=VHOClzCgYugUDErZsvQDrsezrU1BEk9IwI/uyTL0eGupVatfpNQCvMVkVPX6NXujEndoc49lr5JStLnbgNPW0+IyodvuhFwbd1kTZhBs8NLclJBKrro5KVuh1lI+kwUIGBz4NsUa3JbrG7v/ScsGBpl97A3gyj4LTXIfb+fu4OOOwHoWo2Kg+zzoNfVGnw9rzKDIuE6eBMBpgaE+VQDcsDetv71A8d+axq48xpbTNQZOaCiGycMWbBlsLwpf3rSb3N/D2a+bhkG0rsTqU0VrUizdSXln71LNlhtQ6lriK0LYJElV5CYi3KPNC34BGr670xxXmEvBCFmXOnY2niNN5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xY1hRQfXH3z3tY51KGZ9JFhkmgsHe+TqUlkvt1J24FM=;
 b=BhPeiL9PhEBAkmyrQI11Wu1HlMTtSEkQnIgo+l52hhLZ61RRL3WpqMmU7C2AbHi4ea3KkaIQY/0MF3E8aO8BnUSU1rL7Y0/LSRGQgne+2mayqKmjC6Dfzyr+AJPWXutVj1MnYCbuddRRDVNyBG14qAUtSwPIVRGj6oVt7SqNwgI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6208.namprd10.prod.outlook.com (2603:10b6:8:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.26; Fri, 2 Jun
 2023 14:03:23 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Fri, 2 Jun 2023
 14:03:23 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
CC: "elic@nvidia.com" <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9QVtoAgCcyyQCAACq0AIAABMuAgAACGIA=
Date: Fri, 2 Jun 2023 14:03:23 +0000
Message-ID: <97198A71-5B08-404A-BEDF-7F5B0A9E5A23@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <bf2594bb-94e0-5c89-88ad-935dee2ac95c@leemhuis.info>
 <5b235e0f-cd4c-a453-d648-5a4e9080ac19@leemhuis.info>
 <AAFDF38A-E59A-4D6A-8EC2-113861C8B5DB@oracle.com>
 <bb2df75d-05be-3f7b-693a-84be195dc2f1@leemhuis.info>
In-Reply-To: <bb2df75d-05be-3f7b-693a-84be195dc2f1@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DM4PR10MB6208:EE_
x-ms-office365-filtering-correlation-id: d609c693-99f2-44dd-e592-08db6372213c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 n44I/NxupkpWfwifMI4Mc75GvJAh7g8NILnCX72q3X98bseZE4GduF36H+AQDJf3x1dy7vvm2AXR2auOI6G7u1+HZGlajIK11ZuHyobof+yWcfklKYVAkFlkewUraccCFc0Nmb2lLlrRRz4Tkwi7DEjIJM+ODspVv5RrXcYli/5Fe6OcbwhX0vNZl/rr8SP6GUUQS9XQdMYUche+8W10DdnUgbd2R+9+B24UYDmSqhfArU7bQLg1Oqm68qQ2XHeOPdBe8i96bSr9oTmb001G3bHEoUQf2O75A8lrie635HLJ8fnxEYldeVmDCjyUsZEsSBclHmufbL6MAozJrDq6hDL4VR9+1j25x+VG0WbkahLn4Wsq9YBIv21RHCp1NEW2du+kHMsqPCfCOGG1kFRXH5TcM0K6nTBMSOXOiNcGu2x8PMi6sxGGDP8OW7KYv4UaWBFdxi1nFwz44WXigi3z9iPkWADEiKG3xUycFCW7O3cMf/igobIVfa68jqqa/qYZ4dSEDWGuN5Jl/Oj5eb7zUzOz5E/sg7eUQf75fQ0+3pULIV0JiSWMYOcP4nERRdjPABDpc9a0gdBfNOkaUYCfIRCH4UfmcZZ+syBUekpgjgt8lBNQ5oWj8QMnYIj3yRTvBMlKwM8sWW/2kr2CxUmQ7g==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199021)(66946007)(83380400001)(8936002)(4326008)(122000001)(36756003)(41300700001)(38100700002)(38070700005)(316002)(6486002)(6506007)(53546011)(26005)(6512007)(71200400001)(966005)(66446008)(66556008)(64756008)(76116006)(91956017)(66476007)(110136005)(2906002)(33656002)(8676002)(5660300002)(2616005)(478600001)(86362001)(186003)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?cVl1Vk5JbHhjRmJ0OWdkalZQcDB2eGgrd0VVMkJUTmhXS0NLN09SRVZNWm8w?=
 =?utf-8?B?MWhzODMzM1dNRE4yUHh1YXNSaDIrSFVZQlVKMHBwRmtyU2hPZEJLN2ZGUy9t?=
 =?utf-8?B?RWJlZ245Y3NSTmwrR3R3cVlzbVRqeDN6Nmh3eDV2elA2SEYxTDNzaWNUa3BO?=
 =?utf-8?B?am5lcEdhcVBLRW5sZkJxSEhGNHZhVTdiZWhUK2cxVHpubWlMdGpVdlRmaVg0?=
 =?utf-8?B?ZVdqWjJ3SXg3OXJCb3dwaWMyZ1VtWDBYOXJUbXhRRnZFQXdGN3RObnBCOENm?=
 =?utf-8?B?aHhyZUpHRE9YdFZ5ZHlkVDZGTzZ0NWZWTHpoTTNOam95TS9IR2s2cGZ1ZkNm?=
 =?utf-8?B?bVVEbHM0WTFTNXEzT2dXeTB0VGttQmJNMXRrS0s4MVpvQmlvYzhDQklWdVB0?=
 =?utf-8?B?VmF2RTJScFVza0FTOTRzR3g5UUY3S0VQVWg2UU5MVmo4Z0hDdVM3eTM2SThB?=
 =?utf-8?B?b2dmNjUvR21BU1pJcHpTTnM0L0hsbjFvSzkxbjVrdnFFOTQ5N3pab1k0aEN0?=
 =?utf-8?B?MlBjKzVoV010VHBOTklqZUpKcDN0bTRkUFpscXBYaWphUDVuWDBYK0NpRVRy?=
 =?utf-8?B?enZyQXBzWTJ1VWNBeEZoM2EyRDJnaVNzTGJUSTYxTkM3U0QwR3BLVEZLTElq?=
 =?utf-8?B?enRFeEM3dWZ5dTZ5VUozNzU0eW5NTXRSb3RUcEtNdUxjZUR2T2xQbEZkZnRi?=
 =?utf-8?B?dmdaMS9aL05kSnZYZG1FSndxMmVJWHVXb2FtUHFNT25OUlRpcmFMYUxpREVE?=
 =?utf-8?B?UTNSNXZZNnoyZlNJeVh2TVdrUEl0N3k1ZVVyeGlqRit3UTRkSnRDY2xZQ1Vp?=
 =?utf-8?B?UTI5a1FBVC82RHYzaVQrRzRZTGFSdG1zYlZtMnphaXdnNldHL242TUxTY212?=
 =?utf-8?B?WTFiWFpkdkppd0ZaVHFqOG9ET0V2S1dKSkg2MlJNaTA0bWt1VXpJcXpUSzlt?=
 =?utf-8?B?L0Z1dHhHQUZxaFZocGJMQXdoYkJCcTl5WlZiWUIwUFdpc1gybnZQcGRKR2sv?=
 =?utf-8?B?cGJTd2J4MkVRLzJMUndkVy9VMGJOTHArNXlZT0dDdlF5aE50Sm9zcEJsODV5?=
 =?utf-8?B?NEwzUzF2TnY4Zi9rUGsyVjlQVi9xUmgyUlBwb3J5eUFsUXRNb0E0Y3pUdmll?=
 =?utf-8?B?U09jU2lLSmR3aXhQZGlTWC9SK0ZmOHprTzVBUWhQcGI1VkU5WGVhK1c2Q0tH?=
 =?utf-8?B?K1VkL3VhTGwwaHdVdlZ2K2JPQTJIOU1kMG9MSzN5bGlIRXMzakl6OWtSMGdt?=
 =?utf-8?B?UWRNZTM3NitHK3d4OXd6MkZvSExEQVMydnFsNWRTNVR6bFB5OTQveGNBczdn?=
 =?utf-8?B?Z2phMlFnampURXdGN3ppcy9zYmxFdDNLL2Y1SGE4RFNzclZKN3cwZndyY2Vo?=
 =?utf-8?B?K2YyZm02aDZDQUZ0ME00R3BNUk4wWW0xRHJycklFOGdyV1ZHcmppUk9aUS9w?=
 =?utf-8?B?MDlsYUZyaFR3WmpQYWpZN0NZdThxRmRGK3RvQ0pDMTU3WjRJdlNJZG9XS1VG?=
 =?utf-8?B?TVROa1ZxNzd5Vi9Tc0tlWUM3UUZMZTFJblpBbVBmc09lWWpHVDBvMzczZFRK?=
 =?utf-8?B?alZxVFdzSktFWGQzSU5IUlV6Z3hrZldIRHdhaERPSnFhV0xUUHNKZXFHcGJu?=
 =?utf-8?B?RzJpRktxMDN6UFZJT0dMMVFRNFdIcUlYRGp4aWtRWmV0LzZoQlcrQk1pVENZ?=
 =?utf-8?B?eDJJenV6YUFuelVUdkpPS0daS3c3T2hpOTlibERvVTdaNE1obHhMSWRPaVd6?=
 =?utf-8?B?cWdEVHh1a1RxOEprWGNOY0VQaU5RbGxiUWxqVEZWRHhvL2JUdml1K001M1Jj?=
 =?utf-8?B?V1RQK2tLYlk2WlRENHJZNkwyMFdHVXZOVE0xR2xDVHdMSzhMZWxsR0lFcGRF?=
 =?utf-8?B?M3h5ektoaEpoOUxDemhYdEgvVXQ3QUFlb3dMUHg1VmJXcVRpVlhOTWJSTVJx?=
 =?utf-8?B?dVJ6cXVZZHlRSjUwSzF3UWFWNTNXbVV6UDZLWko5SDZhQ29zeVpWaW9TYVBX?=
 =?utf-8?B?YVpiWG9ZN1ZtdG0zcUs4OEdQN2R0NHNVUnJxaDhZT1VZWm9sTzVja2ZJZXE5?=
 =?utf-8?B?NFpLM1BydGdHNUZpWmN1M1R0OGh4VUxvQnVSSVhRK3czQlM1S3R4YjcyUWtv?=
 =?utf-8?B?L3d0NXl0eXBrM2VOWkIrSDhMQ25Na0d6bTh6WDJJL2xpQ2JRVlpBWVBNTmJx?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <902BDF37D0AD1A40A1B0739F7B5D5CC8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	p+PFGgVgxwaMO6BBsI+857n/GyR+jXK8qCz1wW55IAxftQVEr/xdIsP+D0SK9UmGXhyOQVzS9+IBEhJNL9DfMmtoMj75h5AZMpDYiaOL8Ft2eMQ6fXn2pFzV6nbzZrQ+et/rMA+85KWYtPSW9J7/7Pq9yZ75pDNKV5R23Qoxx/tJKoRIqRqrL7cObMyfvqcpqpvDMtfphDs4z9gA6NKSj26rpf2huV+hJEqhebu8Oq4ESTif7nvW/9H8IrTexZHZ1iUsI1i45iJVreIGEZgYi1iSK03E+yr1tCVByggne5k4VBhPZovCgwTZy/Bsnuz2PFg0Ewyro+3CCR7rVjZhV7DzA0p7ymrTxGtrVFKamyOn2r4S4cO5zo8IPttgtTkB1B/AQioZtgpuZsOdAaur8tcvbUUsAFArGCrnJ57+jPS9gA/fYcMa2+hMAZHQcHlKWW/VRGVcFLvpL1J6VwGttOrzDiP4KfunqQ6OM04zfC5ybqlKufzCtAX2ofzXCYu1wFbBo3B2ZVdaS/beK4HaYBcYqu7X03dJkGySbyM/SJv4APaswqWSF1HC7u20SNuteuehih3DznhUfPUddoHCx8R21jvzIdHbGvmrMm+/wu7mTJdpVOW+Aq4Q509lKtrjsjVnYPgXuuG/yIZ+EX79ZmzQr9Op2rERXgISgb5K3DKrz6DTEb7/rI1cuk0BJezN3bOQv1pMu6eFG/p6gBpMJlURSIJJHaNTxRmg7o91iatV3c5tsFtPu1YKOieD24MNYMf+6lj6Jy9j6HtgQpjohF8iyoIhnFJUcA4fIQ4FIVoKQjvvrIqOuS1CwaatVAH+437Rhvj3dLBJpCouurgo0myUepS+s3o/OatJS2J92po=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d609c693-99f2-44dd-e592-08db6372213c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 14:03:23.7965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e0Q1B5GRIVDy/TcF+eMZG4di/GM+2Dz1Wyi8zlxsW++fCCebWeJyKN2Bi5fCtCWkjIhvltKTIpOK9WhRhreIGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_10,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=398
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306020106
X-Proofpoint-ORIG-GUID: qwk30m7ic2GUHEy3UOaakBz4DKqE3nBe
X-Proofpoint-GUID: qwk30m7ic2GUHEy3UOaakBz4DKqE3nBe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gT24gSnVuIDIsIDIwMjMsIGF0IDk6NTUgQU0sIExpbnV4IHJlZ3Jlc3Npb24gdHJhY2tp
bmcgKFRob3JzdGVuIExlZW1odWlzKSA8cmVncmVzc2lvbnNAbGVlbWh1aXMuaW5mbz4gd3JvdGU6
DQo+IA0KPiBPbiAwMi4wNi4yMyAxNTozOCwgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPj4gDQo+
Pj4gT24gSnVuIDIsIDIwMjMsIGF0IDc6MDUgQU0sIExpbnV4IHJlZ3Jlc3Npb24gdHJhY2tpbmcg
I3VwZGF0ZSAoVGhvcnN0ZW4gTGVlbWh1aXMpIDxyZWdyZXNzaW9uc0BsZWVtaHVpcy5pbmZvPiB3
cm90ZToNCj4+PiANCj4+PiBbVExEUjogVGhpcyBtYWlsIGluIHByaW1hcmlseSByZWxldmFudCBm
b3IgTGludXggcmVncmVzc2lvbiB0cmFja2luZy4gQQ0KPj4+IGNoYW5nZSBvciBmaXggcmVsYXRl
ZCB0byB0aGUgcmVncmVzc2lvbiBkaXNjdXNzZWQgaW4gdGhpcyB0aHJlYWQgd2FzDQo+Pj4gcG9z
dGVkIG9yIGFwcGxpZWQsIGJ1dCBpdCBkaWQgbm90IHVzZSBhIExpbms6IHRhZyB0byBwb2ludCB0
byB0aGUNCj4+PiByZXBvcnQsIGFzIExpbnVzIGFuZCB0aGUgZG9jdW1lbnRhdGlvbiBjYWxsIGZv
ci4NCj4+IA0KPj4gTGludXMgcmVjZW50bHkgc3RhdGVkIGhlIGRpZCBub3QgbGlrZSBMaW5rOiB0
YWdzIHBvaW50aW5nIHRvIGFuDQo+PiBlbWFpbCB0aHJlYWQgb24gbG9yZS4NCj4gDQo+IEFmYWlr
IGhlIHN0cm9uZ2x5IGRpc2xpa2VzIHRoZW0gd2hlbiBhIExpbms6IHRhZyBqdXN0IHBvaW50cyB0
byB0aGUNCj4gc3VibWlzc2lvbiBvZiB0aGUgcGF0Y2ggYmVpbmcgYXBwbGllZDsgYXQgdGhlIHNh
bWUgdGltZSBoZSAqcmVhbGx5DQo+IHdhbnRzKiB0aG9zZSBsaW5rcyBpZiB0aGV5IHRlbGwgdGhl
IGJhY2tzdG9yeSBob3cgYSBmaXggY2FtZSBpbnRvIGJlaW5nLA0KPiB3aGljaCBkZWZpbml0ZWx5
IGluY2x1ZGVzIHRoZSByZXBvcnQgYWJvdXQgdGhlIGlzc3VlIGJlaW5nIGZpeGVkIChzaWRlDQo+
IG5vdGU6IHdpdGhvdXQgdGhvc2UgbGlua3MgcmVncmVzc2lvbiB0cmFja2luZyBiZWNvbWVzIHNv
IGhhcmQgdGhhdCBpdCdzDQo+IGJhc2ljYWxseSBubyBmZWFzaWJsZSkuDQoNCkkgY2VydGFpbmx5
IGFwcHJlY2lhdGUgaGF2aW5nIHRoYXQgaW5mb3JtYXRpb24gYXZhaWxhYmxlLg0KSSBtdXN0IGhh
dmUgbWlzdW5kZXJzdG9vZCBMaW51cycgY29tbWVudC4NCg0KDQo+IElmIG15IGtub3dsZWRnZSBp
cyBub3QgdXAgdG8gZGF0ZSwgcGxlYXNlIGlmIHlvdSBoYXZlIGEgbWludXRlIGRvIG1lIGENCj4g
ZmF2b3IgYW5kIHBvaW50IG1lIHRvIExpbnVzIHN0YXRlbWVudCB5b3VyIHJlZmVyIHRvLg0KPiAN
Cj4+IEFsc28sIGNoZWNrcGF0Y2gucGwgaXMgbm93IGNvbXBsYWluaW5nIGFib3V0IENsb3Nlczog
dGFncyBpbnN0ZWFkDQo+PiBvZiBMaW5rOiB0YWdzLiBBIGJ1ZyB3YXMgbmV2ZXIgb3BlbmVkIGZv
ciB0aGlzIGlzc3VlLg0KPiANCj4gVGhhdCB3YXMgYSBjaGFuZ2UgYnkgc29tZWJvZHkgZWxzZSwg
YnV0IEZXSVcsIGp1c3QgdXNlIENsb3NlczogKGluc3RlYWQNCj4gb2YgTGluazopIHdpdGggYSBs
aW5rIHRvIHRoZSByZXBvcnQgb24gbG9yZSwgdGhhdCB0YWcgaXMgbm90IHJlc2VydmVkDQo+IGZv
ciBidWdzLg0KPiANCj4gL21lIHdpbGwgZ28gYW5kIHVwZGF0ZSBoaXMgYm9pbGVycGxhdGUgdGV4
dCB1c2VkIGFib3ZlDQoNClRoZSBzcGVjaWZpYyBjb21wbGFpbnQgaXMgYWJvdXQgdGhlIG9yZGVy
aW5nIG9mIFJlcG9ydGVkLWJ5Og0KYW5kIExpbms6IG9yIENsb3NlczogdGFncy4NCg0KU2FlZWQs
IGlmIGl0IGlzIHN0aWxsIHBvc3NpYmxlLCB5b3UgY2FuIGFkZDoNCg0KQ2xvc2VzOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9uZXRkZXYvYmIyZGY3NWQtMDViZS0zZjdiLTY5M2EtODRiZTE5NWRj
MmYxQGxlZW1odWlzLmluZm8vVC8jbTQ5Yjg4OTQxYzhkYzViZTQyZmE5NjBmODRlY2RhNjgwZGRi
MWE3NzgNCg0KVG8gbXkgcGF0Y2guDQoNCg0KPj4gSSBkaWQgY2hlY2sgdGhlIHJlZ3pib3QgZG9j
cyBvbiBob3cgdG8gbWFyayB0aGlzIGlzc3VlIGNsb3NlZCwNCj4+IGJ1dCBkaWRuJ3QgZmluZCBh
IHJlYWR5IGFuc3dlci4gVGhhbmsgeW91IGZvciBmb2xsb3dpbmcgdXAuDQo+IA0KPiB5dywgYnV0
IG5vIHdvcnJpZXMsIHRoYXQncyB3aGF0IEknbSBoZXJlIGZvci4gOi1EDQo+IA0KPiBDaWFvLCBU
aG9yc3Rlbg0KPiANCj4+PiBUaGluZ3MgaGFwcGVuLCBubw0KPj4+IHdvcnJpZXMgLS0gYnV0IG5v
dyB0aGUgcmVncmVzc2lvbiB0cmFja2luZyBib3QgbmVlZHMgdG8gYmUgdG9sZCBtYW51YWxseQ0K
Pj4+IGFib3V0IHRoZSBmaXguIFNlZSBsaW5rIGluIGZvb3RlciBpZiB0aGVzZSBtYWlscyBhbm5v
eSB5b3UuXQ0KPj4+IA0KPj4+IE9uIDA4LjA1LjIzIDE0OjI5LCBMaW51eCByZWdyZXNzaW9uIHRy
YWNraW5nICNhZGRpbmcgKFRob3JzdGVuIExlZW1odWlzKQ0KPj4+IHdyb3RlOg0KPj4+PiBPbiAw
My4wNS4yMyAwMzowMywgQ2h1Y2sgTGV2ZXIgSUlJIHdyb3RlOg0KPj4+Pj4gDQo+Pj4+PiBJIGhh
dmUgYSBTdXBlcm1pY3JvIFgxMFNSQS1GL1gxMFNSQS1GIHdpdGggYSBDb25uZWN0WMKuLTUgRU4g
bmV0d29yaw0KPj4+Pj4gaW50ZXJmYWNlIGNhcmQsIDEwMEdiRSBzaW5nbGUtcG9ydCBRU0ZQMjgs
IFBDSWUzLjAgeDE2LCB0YWxsIGJyYWNrZXQ7DQo+Pj4+PiBNQ1g1MTVBLUNDQVQNCj4+Pj4+IA0K
Pj4+Pj4gV2hlbiBib290aW5nIGEgdjYuMysga2VybmVsLCB0aGUgYm9vdCBwcm9jZXNzIHN0b3Bz
IGNvbGQgYWZ0ZXIgYQ0KPj4+Pj4gZmV3IHNlY29uZHMuIFRoZSBsYXN0IG1lc3NhZ2Ugb24gdGhl
IGNvbnNvbGUgaXMgdGhlIE1MWDUgZHJpdmVyDQo+Pj4+PiBub3RlIGFib3V0ICJQQ0llIHNsb3Qg
YWR2ZXJ0aXNlZCBzdWZmaWNpZW50IHBvd2VyICgyN1cpIi4NCj4+Pj4+IA0KPj4+Pj4gYmlzZWN0
IHJlcG9ydHMgdGhhdCBiYmFjNzBjNzQxODMgKCJuZXQvbWx4NTogVXNlIG5ld2VyIGFmZmluaXR5
DQo+Pj4+PiBkZXNjcmlwdG9yIikgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQuDQo+Pj4+PiANCj4+
Pj4+IEkndmUgdHJvbGxlZCBsb3JlIGEgY291cGxlIG9mIHRpbWVzIGFuZCBoYXZlbid0IGZvdW5k
IGFueSBkaXNjdXNzaW9uDQo+Pj4+PiBvZiB0aGlzIGlzc3VlLg0KPj4+PiANCj4+Pj4gI3JlZ3pi
b3QgXmludHJvZHVjZWQgYmJhYzcwYzc0MTgzDQo+Pj4+ICNyZWd6Ym90IHRpdGxlIHN5c3RlbSBo
YW5nIG9uIHN0YXJ0LXVwIChpcnEgb3IgbWx4NSBwcm9ibGVtPykNCj4+Pj4gI3JlZ3pib3QgaWdu
b3JlLWFjdGl2aXR5DQo+Pj4gDQo+Pj4gI3JlZ3pib3QgZml4OiAzNjg1OTE5OTVkMDEwZTYNCj4+
PiAjcmVnemJvdCBpZ25vcmUtYWN0aXZpdHkNCj4+PiANCj4+PiBDaWFvLCBUaG9yc3RlbiAod2Vh
cmluZyBoaXMgJ3RoZSBMaW51eCBrZXJuZWwncyByZWdyZXNzaW9uIHRyYWNrZXInIGhhdCkNCj4+
PiAtLQ0KPj4+IEV2ZXJ5dGhpbmcgeW91IHdhbm5hIGtub3cgYWJvdXQgTGludXgga2VybmVsIHJl
Z3Jlc3Npb24gdHJhY2tpbmc6DQo+Pj4gaHR0cHM6Ly9saW51eC1yZWd0cmFja2luZy5sZWVtaHVp
cy5pbmZvL2Fib3V0LyN0bGRyDQo+Pj4gVGhhdCBwYWdlIGFsc28gZXhwbGFpbnMgd2hhdCB0byBk
byBpZiBtYWlscyBsaWtlIHRoaXMgYW5ub3kgeW91Lg0KPj4gDQo+PiAtLQ0KPj4gQ2h1Y2sgTGV2
ZXINCj4+IA0KPj4gDQoNCi0tDQpDaHVjayBMZXZlcg0KDQoNCg==

