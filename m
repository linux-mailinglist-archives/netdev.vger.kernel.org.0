Return-Path: <netdev+bounces-6863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4B18718755
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84F16281520
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A41051801F;
	Wed, 31 May 2023 16:28:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E504174C6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:28:18 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B388798;
	Wed, 31 May 2023 09:28:16 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERXxD009437;
	Wed, 31 May 2023 16:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=N0oBKmF9mOIDzsHwBT2RTnpAXzj9dv9wuk/KR4n1jIs=;
 b=3BSLjPI1X/zcxmqReeft8w1+Lei2b27W+Am2qfV93YfcoaZjtVPnvF705chk0ixJoRi/
 LVynMmC/Yu9UP2iFiSrHjg/cqBpE4CltmKbS1OncdBJxyVonGnbhpUIWFed4zq1New1s
 W06Pv8y3CgN57DYmmVsd09ASwrBc3pvkhq4VAmxHAbxoO7RTP8675SD7uVxFi/BIuvFU
 /kE0zkfLJX/K8G+8TKK3DCkv78wausP8gxEZRBND9ZUiTZUOkk0FLbTLHiFr0SqEILIu
 2/XLxvVN6j96vwhNLLANOtQaHW3PKRihKlXTPTEao7CR21/1sWils5MpGP9MIvme83Lj qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjkpbh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 16:27:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VFXfvP026076;
	Wed, 31 May 2023 16:27:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8accr6v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 16:27:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B840DYv8anILjXmwWKHPklFc1Aqn+/u2KgDWdqur5mhAofTtlXea7zS0r8ato/bX2Mo/aDt+5QuQXf22EVgCPi90d6BmZL6ZHmSXVqobMBnFTqrw+NbN/BgkIX5kH40m7NVDymDFVoZdhlcD3/+tDT4HCrcAnod4iarHmpofKgtw+3zpxgpkiZHjp0xe9wXCehUTTbHwnIGPQBfPY8Jo+6SywWQZRtuKUgRs3kUBQzf4J8lTZJN9kIouOBVggTZdgSW+Bk5xI/ocyNRMYjgCXwZTOaHX8xpQw0taT8agoJT9cm7ZGOv5Rh5lCav1esXRWpaGzUmPzPKiwJ1GWpVtZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0oBKmF9mOIDzsHwBT2RTnpAXzj9dv9wuk/KR4n1jIs=;
 b=UuSc0ByI5VS3gs4Q6BGc8AIHASjw5mKFIfsRGJraOuZ6ZbiTpwtA2kQvL20wqbKNNqiKQh5G40OPTIxrknwFaxhKL/TdpsALM1G0yaX00iUxMuvvU149eaut/MxL7qwDeAFrRtNuPrpFzI3RXhhqBuGnnU/TlnkFq6dwJwb5D4dOofydRWEpwj7ND61Uc8NbONbMz9TYDfaw2uRoU8xbulChPnBp2UCfdwNtYJaXspL44Owwf5YzSMTh/DHUz2DynmaYAIpPgFv65QD3qYFTz+wVYIxgriCfWoqav1mEKg3lhlh1fYRHZUK59GKinaWANvYPnzSkCiP7vG7mTN5gDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N0oBKmF9mOIDzsHwBT2RTnpAXzj9dv9wuk/KR4n1jIs=;
 b=aG5JDXB+eE1ToITrOtGXszTBvvQie2/1JGAyKLCLHyKTG5jlQ5XVkqXy1D+s7x/mzybkVUf5Qzb7KKYevwIYmGiDsTvINFNQc3Mz3wzvH/THaQGERr0D8qzvb45Imp4fLuzwMAXrSLlywUTrcFCtFHEidVfoPR5OtVrWZ7XUftk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS7PR10MB5008.namprd10.prod.outlook.com (2603:10b6:5:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 16:27:14 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:27:13 +0000
Message-ID: <bbe697b6-dd9e-5a8d-21c5-315ab59f0456@oracle.com>
Date: Wed, 31 May 2023 11:27:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
From: Mike Christie <michael.christie@oracle.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
 <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
 <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
 <CAGxU2F5oTLY_weLixRKMQVqmjpDG_09yL6tS2rF8mwJ7K+xP0Q@mail.gmail.com>
 <43f67549-fe4d-e3ca-fbb0-33bea6e2b534@oracle.com>
Content-Language: en-US
In-Reply-To: <43f67549-fe4d-e3ca-fbb0-33bea6e2b534@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:5:335::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS7PR10MB5008:EE_
X-MS-Office365-Filtering-Correlation-Id: 2112764b-fd59-45df-40ea-08db61f3e442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	gR1119R3H0mprnlkdSL6T1sZy5N46JmoVoWg3PwO3en3a44vcfJk91OCbCsUCzKGviUTTNGGBzn7Wuhkcv/UBZEqgg6cKZroLjoxfAOamw3bDv9gWB2IoKgr8sBbuugqiTY/VYerWWLIo269mWhGiBElsK34SOcmT1cUEiHFu52f2sCJ0lRWUDFOhM+FXGgwJWQKhz1MDUA80fENtdw8MF/umCjeaxreDE7K32onWdNCR7bb0wFezoW1tM7Weo8XU1XEVBR3guxJbpNoScwX6O+OjbZ0IlIKyI31pa/VKsHUaj1Mi3/b1hDnO8M8lRkxJIVx9W9TfGLPNiQfHiE0AooEte+L241E3Mxj95/40ZUdjQM+t3o3yuMl1fIGqxwefT2vn/W0JFYInkKYYhGtyvvwRcFJp2Cno23tFwHPsu/kzqV9vlYu5SCiea0s7d6w3BD0aQtdoiAt9W1wySUakfQXIcOHAxhJ+UUk4VdiaLoReiWksGvnm1tVVTmxvo1Xw3oJbgSn3cB8Isasf6Rt4yKpxQCnGbRJGaXrvtJuOpaKJQOWACynTr3SLw7OUgyIzZB8yE4qrCYB6ePd0FfGYwEaoyH4JTS5+WlBEZ2KvbjoUl9mXXsR+aw/ag0S+Km+7DA2Tr4bo34cNw2MuEkyhg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199021)(26005)(83380400001)(38100700002)(41300700001)(6486002)(186003)(53546011)(6512007)(31686004)(6506007)(2616005)(54906003)(478600001)(6916009)(66946007)(66476007)(66556008)(4326008)(316002)(86362001)(5660300002)(8936002)(8676002)(7416002)(31696002)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MUE5QkJlL3dFWGlmdjhWSEdwUlpreW9HWFZaM2hWNXlGRlEwb2xJbnpCZ0g3?=
 =?utf-8?B?SVNiV3VPbnhtSysyaHljMlpDTThwMC9IVkF2eDZhbnZDdThGMDI5SkFkNDFR?=
 =?utf-8?B?UXVkMkpvcEVUc05ESTR4dHJGdW5abjY2TjYvWXZHak1yK1VqYTJnU2dvUUdk?=
 =?utf-8?B?Y1kwa3B6N2VqRGhya2ppN3ZUbGdDR0xlbSt6Z3c5RTdnSFN6VGV0WlZRaU5F?=
 =?utf-8?B?eFVTRG14NkNsUTFCRElFTllHdTFxUVJrVnhkd2k1V2lxZWliNmlGSUoyMXhN?=
 =?utf-8?B?Vk5vY2J4bStZRG8wUk1SbnllaWp4bEZ4dkZxOG9ES2FxVFZremdEMGtHVUs5?=
 =?utf-8?B?cm1WcUtuVzNGS01qUis5eE9RdkIwV3N0bGNNTnJzazVsUGZGOCtRakV3VEJD?=
 =?utf-8?B?ZmN2QXdTSHk3ODEvcHRVaGpQS2FHdENxRHNHQ08xMDc1Wnl0UHdKN2dETXpq?=
 =?utf-8?B?QW9HL1VtbzhtN1JOQ0Q3NlhvRlU4ZC9YLzVCMXBhNTBwOE5sTVU5NWc5dGtK?=
 =?utf-8?B?dkhSOGZpcG50NXJhVE8zM0ZUQS9EbUkrU1JKUTlEVG5UMmxwM0VyaWg2bzdp?=
 =?utf-8?B?NzVkYnJFRFpMSzlVQVRRbVFqMDUyQWp2amE0SStLWmM1WVRkOFIxazcwemtJ?=
 =?utf-8?B?MDBqQ3o0djE1UnFqUThabUVaeUlIYkVyTEFxNW02U1ZQTzlFT2txM0lOcysv?=
 =?utf-8?B?TUdMUkg3OFNSdzR1ODlBaktyUlkrcS85cWNTaXpTc0FMVWt4UTA1RDYzS2dF?=
 =?utf-8?B?UlNUQjFuYzFCd1pxWC9EdTRxVVpuR1JaTENteTVjRkNXUkcza0doTXhLcU9N?=
 =?utf-8?B?ZUF6bmZXNWgyMFlrSFVXWS9vcHVBdHFXRFoxbEpMcWpNZVhzdStZTjR6Ylg1?=
 =?utf-8?B?eUM5QWRpQkJtck1vdXF4NFRiVEVLNEYwb2VkM0FpZjI0c0ZIdTNsTk94TEVM?=
 =?utf-8?B?TjdaNFJxSVY1cnRyd3ZuM3VpNDJxMGRvTHdDclIwU3Q5Umo4NS9COC9EVHVP?=
 =?utf-8?B?WEkrak5RWldUazczSytuQldDU3hZTnRuUFVIcVhiUmNZcnJLQWlzSVVneXdB?=
 =?utf-8?B?YlI4VTZVa2hpRFdrdGhleEczYjgwVWliQlpuYTM4WTZJTytuK2ZMUlBRK1dE?=
 =?utf-8?B?VWxodSs1UC9TYVRra3ZmNmtkc201Um8xcGJQY0RIUkxiU0JJTTFLTHgxMzVJ?=
 =?utf-8?B?VzVkS1M5dFkxbktxQnk5cU1Tb29mUUszQzU3SnhBVE9Kd1hiZXoyVkRUUlZJ?=
 =?utf-8?B?NUdnMmYyKzlXRnRvb1k5U1FSUjErenUvcEN1K0s4aGdxbERzNWVvQUZoaS9M?=
 =?utf-8?B?eSt4aFJhUnllOUgxUFpQZFdjQTA1cVNRZTRNajFVS24wMVhmSVJaSDgzNmNO?=
 =?utf-8?B?MzV2M2dhOXBhbWVjYXpFRHB4TktLZjJyN2NQazMzUnNRaUVmWmd4eUUzWkJM?=
 =?utf-8?B?aE5OTWdSR0NWeXlxZTNzWXl3MmZNYnNQMFZNWlA3TEhqSGtBeUZRQnNPN3VW?=
 =?utf-8?B?Q3BEb0JRcGF1cXlxVUtpc051MkVwNjRlQXdWZmNEa1JsUHdFWUpHejZ1MFYv?=
 =?utf-8?B?U2Q3cUh6YnZaaTNieDVlY0MyUFFWN2src2w2M3Q0SExLOXRvaWxCU0tIOFVG?=
 =?utf-8?B?ak1QU1ZIWXJyMDhBK29Nd3ZXbUVUOGxCNjFXRUtYNzVqamxUMjA1cnhrVG1o?=
 =?utf-8?B?M3JBRk5LUnZxOHdjNDV4QkNISDZMVnZSY2ZIbTB0S21Galg5UHFGQ0l4K3l0?=
 =?utf-8?B?VENDSmNaWWdkQlZhdm9xSTl3UmlhZm54OCt2d2lzSzFkb292WnE0bFBQWmNx?=
 =?utf-8?B?TjZOeVVvb0xuUzlJaEszTndZNzZCd2RoRVd5MjNXQ21oc0pLVkV6ZWlmM0p5?=
 =?utf-8?B?SzZSaWkzVTdlWEJ3eTRBTHM4YnNlbTViRnd4MlRwNXNqeWtPVnhvc3hURlAx?=
 =?utf-8?B?dTljcUhWNkRjOVVvRkRjZnBwSk5lV254Ym01RExreVVxRWNiUFo1YWZBSkM3?=
 =?utf-8?B?d1E1cVFvSVM5MWVkbEQzaVJRbFFsOVVtblkvRE1acHRNRjJyaUU1ZUxRZmhl?=
 =?utf-8?B?OS9ackNObHRRSHJmRWJTTUtRdGRYR1gzZnZ0ZmtwYUtlbTI3VXhIcGNCVnk4?=
 =?utf-8?B?Qm9iQmNXNDZjWWNPaVRYeUtqY0ZORExjZ09zdklFZXgwYVhTajFITlFyWXJK?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?NDdobHc4ckZqcHdEWFdxSHFiR1NQMFhsa05GY2VFRzFTREk2cytYMTVaZXZ1?=
 =?utf-8?B?VDI2elpFb25QUm5sU0lJMkJLK1RlUklWajR2bWFSMTJ3dTRFL0JQK0hTaXFi?=
 =?utf-8?B?MzZhV1dxTmVRVWxDWVVYTlZwUThoaUQrTEVMWk1GM3hwVmZQL2ZHS3dRZW5B?=
 =?utf-8?B?SnVwNXlYVUN3YTRzdHU4M1gwWXIvRnVMRzM4T29ya1dSdmFPcEZjQnhJcUla?=
 =?utf-8?B?ZFRabmh1WnEwWlp0emNoT1IvYWdkSk05NFJNd0tpam5HWHhKbU5Gait0cHFs?=
 =?utf-8?B?cHZzdnVvdTVabHRneTR4N0s1b3p2a3FRalk1RGhtL0huSUMrSmtqL1ZJU3lM?=
 =?utf-8?B?KzJqbHE2ZGNJbzdXY2lQREZmcVhGa01YVkplYkJMR3NhL205TVNYWDhsVHJv?=
 =?utf-8?B?alZNeStadDJ0ZlBCVWROTnR6S1ZYWTIxaG5kY0VxMEExWndkNXVLeGc1a2Nj?=
 =?utf-8?B?QUxMSUVKSHV1RVltRy9OVm5yRVRQOWF4Ym9nUHhGcE91OHdZUDdrS1NCcllS?=
 =?utf-8?B?SExueXBxWUtvS2w2QVZpVUpaeU9NZm10NWpyRlJKSXZzZnFuOEkrcUVFQjI4?=
 =?utf-8?B?NWVHemxFQW9JdFF4NGFJUVpQOVN0V0FBMEVSSVFjNHljNFd3ZkJIMmVUMkhz?=
 =?utf-8?B?Rlh3RXFjQk8vTGYrRGdTSko0WEV6a2FRTXdFVS9KYnR5NHhCZDlSUmU0dEpZ?=
 =?utf-8?B?S1FkZitpNkExQTU4bWU4Y1VhR1lqd3M0aUdldTJmbndZSnVSM1p3NVJja2RH?=
 =?utf-8?B?T3JERHFvRHpKMVU2VERlVnZBVk9NQnhjaDZWcDUxakZNV2trZEVnZVljOGI1?=
 =?utf-8?B?WXVWcjhNZVViTFJDdzkrbUxuZ1NJKzU2T2N1SENNNTdRL2dkY1gxRWtwQ1RQ?=
 =?utf-8?B?MlltYkN3VWdXWUp3V0dQL3N1alkxK0s1M0lCR01jejZZRGdwQk0zcml2QnFi?=
 =?utf-8?B?S1ZVQi80allaazhwN05lQnEyVWJsTTZiUDhGSnI4VWJKU0RaaWhkOUV1VFFa?=
 =?utf-8?B?ZlJaZGJFRjVwQnE1OXdtQXg1REloZjhSWTMwSXlKYjhFWGxVd3lFKy9IY3Ex?=
 =?utf-8?B?WWNQSWMwN1dkY3F1MFNwMkJpSUhVMGE2MzhKQ1I3eHVYOS9IM3RTaDdkUlNJ?=
 =?utf-8?B?T2FPc3RSTStwSHpLeCtNei9jZ0VVbjlDdXpRZE5pQWpzRVVSN3Vnb3hmWXlR?=
 =?utf-8?B?ckZYYmQvbjJhbUhaamlJK0tMMXJqN3lhV0EvdnhsQmlHRE45RTRGWVg4ZVk0?=
 =?utf-8?B?a0JmVlEzMGhwVUNsK2pSSjhVWG1ZUmNaNUNQdFRPTGwxYUpNS0VHNkNneFZB?=
 =?utf-8?Q?YS6F3GTDaGSis=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2112764b-fd59-45df-40ea-08db61f3e442
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:27:13.8844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srN9aOIFf2Y9ZBUmJf0uUZtXh08ZHFqAn4fNgMDEaKzNwfbizZ/3N3iRsGvlHxSL0Ur3jmaiv7s8VwYUDxKq7TdDCSVRqOC1bncFl3cTguc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_11,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310140
X-Proofpoint-ORIG-GUID: FWnCyAIaiNzu2Eszgb8D0ZWOkTvVyZyB
X-Proofpoint-GUID: FWnCyAIaiNzu2Eszgb8D0ZWOkTvVyZyB
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/31/23 10:15 AM, Mike Christie wrote:
>>> rcu would work for your case and for what Jason had requested.
>> Yeah, so you already have some patches?
>>
>> Do you want to send it to solve this problem?
>>
> Yeah, I'll break them out and send them later today when I can retest
> rebased patches.
> 

Just one question. Do you core vhost developers consider RCU more complex
or switching to READ_ONCE/WRITE_ONCE? I am asking because for this immediate
regression fix we could just switch to the latter like below to just fix
the crash if we think that is more simple.

I think RCU is just a little more complex/invasive because it will have the
extra synchronize_rcu calls.


diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index a92af08e7864..03fd47a22a73 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -235,7 +235,7 @@ void vhost_dev_flush(struct vhost_dev *dev)
 {
 	struct vhost_flush_struct flush;
 
-	if (dev->worker) {
+	if (READ_ONCE(dev->worker.vtsk)) {
 		init_completion(&flush.wait_event);
 		vhost_work_init(&flush.work, vhost_flush_work);
 
@@ -247,7 +247,9 @@ EXPORT_SYMBOL_GPL(vhost_dev_flush);
 
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
-	if (!dev->worker)
+	struct vhost_task *vtsk = READ_ONCE(dev->worker.vtsk);
+
+	if (!vtsk)
 		return;
 
 	if (!test_and_set_bit(VHOST_WORK_QUEUED, &work->flags)) {
@@ -255,8 +257,8 @@ void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 		 * sure it was not in the list.
 		 * test_and_set_bit() implies a memory barrier.
 		 */
-		llist_add(&work->node, &dev->worker->work_list);
-		wake_up_process(dev->worker->vtsk->task);
+		llist_add(&work->node, &dev->worker.work_list);
+		wake_up_process(vtsk->task);
 	}
 }
 EXPORT_SYMBOL_GPL(vhost_work_queue);
@@ -264,7 +266,7 @@ EXPORT_SYMBOL_GPL(vhost_work_queue);
 /* A lockless hint for busy polling code to exit the loop */
 bool vhost_has_work(struct vhost_dev *dev)
 {
-	return dev->worker && !llist_empty(&dev->worker->work_list);
+	return !llist_empty(&dev->worker.work_list);
 }
 EXPORT_SYMBOL_GPL(vhost_has_work);
 
@@ -468,7 +470,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->umem = NULL;
 	dev->iotlb = NULL;
 	dev->mm = NULL;
-	dev->worker = NULL;
+	memset(&dev->worker, 0, sizeof(dev->worker));
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
@@ -542,46 +544,38 @@ static void vhost_detach_mm(struct vhost_dev *dev)
 
 static void vhost_worker_free(struct vhost_dev *dev)
 {
-	struct vhost_worker *worker = dev->worker;
+	struct vhost_task *vtsk = READ_ONCE(dev->worker.vtsk);
 
-	if (!worker)
+	if (!vtsk)
 		return;
 
-	dev->worker = NULL;
-	WARN_ON(!llist_empty(&worker->work_list));
-	vhost_task_stop(worker->vtsk);
-	kfree(worker);
+	vhost_task_stop(vtsk);
+	WARN_ON(!llist_empty(&dev->worker.work_list));
+	WRITE_ONCE(dev->worker.vtsk, NULL);
 }
 
 static int vhost_worker_create(struct vhost_dev *dev)
 {
-	struct vhost_worker *worker;
 	struct vhost_task *vtsk;
 	char name[TASK_COMM_LEN];
 	int ret;
 
-	worker = kzalloc(sizeof(*worker), GFP_KERNEL_ACCOUNT);
-	if (!worker)
-		return -ENOMEM;
-
-	dev->worker = worker;
-	worker->kcov_handle = kcov_common_handle();
-	init_llist_head(&worker->work_list);
+	dev->worker.kcov_handle = kcov_common_handle();
+	init_llist_head(&dev->worker.work_list);
 	snprintf(name, sizeof(name), "vhost-%d", current->pid);
 
-	vtsk = vhost_task_create(vhost_worker, worker, name);
+	vtsk = vhost_task_create(vhost_worker, &dev->worker, name);
 	if (!vtsk) {
 		ret = -ENOMEM;
 		goto free_worker;
 	}
 
-	worker->vtsk = vtsk;
+	WRITE_ONCE(dev->worker.vtsk, vtsk);
 	vhost_task_start(vtsk);
 	return 0;
 
 free_worker:
-	kfree(worker);
-	dev->worker = NULL;
+	WRITE_ONCE(dev->worker.vtsk, NULL);
 	return ret;
 }
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 0308638cdeee..305ec8593d46 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -154,7 +154,7 @@ struct vhost_dev {
 	struct vhost_virtqueue **vqs;
 	int nvqs;
 	struct eventfd_ctx *log_ctx;
-	struct vhost_worker *worker;
+	struct vhost_worker worker;
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	spinlock_t iotlb_lock;


