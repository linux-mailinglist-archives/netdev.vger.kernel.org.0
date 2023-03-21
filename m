Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94B06C388C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjCURqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCURqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:46:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A649C4C2D;
        Tue, 21 Mar 2023 10:46:16 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LGn2TK010202;
        Tue, 21 Mar 2023 17:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fEo44Q3U65rCYG6DoRUXWRerqFFBRTI7mR1OnnSmFkk=;
 b=t1OaGDtDoHDTD+2R3xXynwnRO65zer0WqaditEIvgA/t/IIPxz3f5obQb5YrDbM8uQsH
 o3Yb68kuxLL874JiwUNSDpJM8VJbxl/o6q/coGObIcNb3jXFkyT7V+DEKDALTOClyl+z
 jPVBUtvURg8WAozhvrra+gMbYBMuHx77WiZwjGH4MqYRYcl+LtN3qtzh+TIX8dtbn3vg
 QH7pGfS3mpnNDYSIYUIHgGyYb99FU/Xb2daoooXrA2gDWfaQoY9Zr0nrye5B28I6TBmZ
 DGUNyv3Hs2dPCH0124J8JvPQiI/se04dveaRZNWq+2I5s+5tXYBnjNFwA0jJA90923EY sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5bcf2yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 17:46:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32LGIpkB038669;
        Tue, 21 Mar 2023 17:46:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3rdkm40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 17:46:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHMOnMqStTV5abn2KZyyDsWydTfK6mX821Haco3UWnrqZVLF2uSxlZ+HhbugKo3ANW6L06NdCjbZXd0FdKouSuZEJ8nnHymODEZLx4wjR4HgcD6eOiMapbTIWv/atQFfLpACT+h26dpk7X8MoZgRe/o74r97jD3MXBtXz3zQl8HZ8/7BVVpsE5ntAeGPJJBJuRbPIgHNB/l9d3moBo/SByRFNCilQWU/rmdnG4LyduUV51wi0sq0isckaVF8Wu/8NpjBy1CtSTK+RsLFrJAp+8x0ve4Vnx8sn9fJOyYRJziJjtGz5Kt+O3vCpNYVAda48AkrnCn3CP5X6UHy9JW6aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEo44Q3U65rCYG6DoRUXWRerqFFBRTI7mR1OnnSmFkk=;
 b=XJTTQqqbET7305bbt/A4z5cdebG9LHBKlWNWCrChDS4xI5W7WeNstESZ5Me9/Iqy2WRpNcSCEYAv17CCT9Jo2/pGeTV1QmNA3I4pElJ5HseEIBw7eEJE9lR9GdxBqGRCpvsM4rE5ZGxDJJo2HE46si+UlN8r2bxA7E4gzTuxC9s4TuWWmm7x4cV/OYHqLdkq5RmKPp0BVveYyQHXGxSSN9cGMDqrBnjqaEcUUQGZh7wnXR5/9iJuPMN0C2e5mTn9fY/umj6b3PPCr0FIcgnrvvgEXsRK/GqUu/Hg1fBeltBzV0ze0H/IX6bJsFk3v4jp5wsNlQv515YvQtQZx60Egg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEo44Q3U65rCYG6DoRUXWRerqFFBRTI7mR1OnnSmFkk=;
 b=KaW5WiqiDhcffVKFL6JPBi2u38xUo1+Ax79mJfPYIyJHbBHhCODazIDYfLfsXJXcnpF+XIUeKxLrHT0rVTw01xXjSIYYqLQazUaslm32EvEqEMmmcRd5u+B3qYWmu1V+aobNFmtLPZfWIC1zph7VPPoyy1bv1ozCkLGPHwU4kU0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB7065.namprd10.prod.outlook.com (2603:10b6:8:143::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 17:46:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 17:46:05 +0000
Message-ID: <2d976892-9914-5de0-62e0-c75f1c148259@oracle.com>
Date:   Tue, 21 Mar 2023 12:46:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [syzbot] [kernel?] general protection fault in vhost_task_start
Content-Language: en-US
To:     syzbot <syzbot+6b27b2d2aba1c80cc13b@syzkaller.appspotmail.com>,
        brauner@kernel.org, jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
References: <0000000000005a60a305f76c07dc@google.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <0000000000005a60a305f76c07dc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0116.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ad4db3e-423d-49c5-3088-08db2a34252e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n86IlMf0OsHSziMmjeYhsVJC0fisi1sEI2fHIziypHG1M7IRUntcI9mvpv9ZA67cH4F2W4DN6EkTYKjqjfOXdtKUrfDYWVfNdqxNEWl/lj6r3VT9enYKAxzuQwDpNfW7a2Xjh6oj4zWl3ETdBuJTo8ygUEdt0Dj1N3NRp5+dUKXSb8pgVaOgoHXfDTcxqVuEsyuA3P/GsfiGmpD8I7s/hLcpZ0cV7+J2ZenjKHzC6S5XTlH9P0zWD32YnOjj3RaEyPCejhTgP/CS9pTZhXqU7F01eT8pCPJNCvEMo1lI11OA13dcJfjUxH/zALBzSZmLIc9oMC0FxSsRwCFovi0nl/yZmM0o9cpcjRdZbZbxptfOZP2NZQMRUA2vVgvU8/SUaDwRIWxuSFkKLPSaKxxHNoeGolN+T7bc5NG/XiK9avqh7uQaUaxxZO0v4MgRwfHTwEJrabCTrtilMCUNpFQw2AazcKLFarIL6FwkYKGE9hn5Ys7kJ57FJoWCmOoWTAt3ytknO3IIlGEpfsrn/yamCDFS7P30VvIcYMJQjRdgjCJhnb4Yd6qYUJ9ypwGghIju0UoRLAL/NzItFRjiL13sG153Y5XlIaAl6lBQPj2Nis2JnN5mSBfWS6lsLeFMcIMBBkLhQ6JiMgLLzrvH+DmmzjNs2dU+gXiDVODTNx61f14IhT7dbrgVmdsPvTSsGy9tjpdX+Q5sxpxDuOlVkn0L4lo78oC06x/fSiZ8zCWKwp0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(136003)(376002)(346002)(366004)(451199018)(83380400001)(2616005)(86362001)(38100700002)(66556008)(31696002)(8676002)(36756003)(41300700001)(8936002)(66476007)(2906002)(66946007)(186003)(53546011)(5660300002)(6512007)(316002)(478600001)(26005)(6486002)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qkx3QXhWU2pHSmk0M244dzYwamhEelkwSTFpUlg3eVdwT1RxMTc5cUdvK3hu?=
 =?utf-8?B?Qld4eFpOdnV1SjRpTDRNQzYrSnlNSzhFUXB6T1crdDM2ajdCNXlwdDZsNFg0?=
 =?utf-8?B?Rkk3SmRvNnpQc3p0MmRlQzBJVDBGbFE2azZyU3h0ekRQdHliMktxV1c3VWxZ?=
 =?utf-8?B?b2VKVzBqUjRzNW1lT2QxMkdnV2RvM3pEdW1ja255bGthZmI0dWovdG9Ya2xL?=
 =?utf-8?B?L29jZ2Q5Q3FndFZURmVvNUNaS1ZGY2Npc0wzaU9hM3BSSFpRYlpxQW1WUW1a?=
 =?utf-8?B?Z0xWSWhjZjRTNU1RSE9Qc0E4R3VIS1JWMmpFM3FiWHRNZjRXSGxWT3VhYmw2?=
 =?utf-8?B?bkJSaFNDb1hkN0NxWVlZUWJGZU16ZG5rOVA1QzYrZTRZamZxU0MvR0duSWF2?=
 =?utf-8?B?OHNmTTN3YVF6QnRxa0NkcWJSK2VRbWdtOXdWNTkxQXV6WkZta1Q1T1Y2NTFl?=
 =?utf-8?B?MGIwKzVFTEp4Q1p3N2F3N2ZaVUNlS2RYek1FeGxraFVjVmRyT3hNWG54ZDE3?=
 =?utf-8?B?U21UVzJ6NjFSbjdTdFFTa0sxZTN1ZjRBNzRqUEg1R1U0TjFmaDc2WHgyMWFy?=
 =?utf-8?B?MlZoNzhxSlRFZHpnM0V5M3ZwVUJ6RHdZUUEreHcwZ2ZaVVNJL1Jva09yNmpt?=
 =?utf-8?B?Qm1ZNHlhUm5mR2NFeEkyQm1RRGtkSXU2NGNpeFF0dy9pTlNmc3FiTEZUTzB1?=
 =?utf-8?B?WTdraDRlSXlZWFNtOE9Hdk9VNDJ4TzQ4ZEliZ1hHeEx0K25KRndhdSs1bGIr?=
 =?utf-8?B?Z3EwQ1JEQmpyam9zZmpMMG10K3BRVCtLUlpNSlJvUmVGdjFVeEdCVDNQYUtk?=
 =?utf-8?B?NmcycERPaHFTY2Z2VjNLVWdVVzEzNmpCZy8vNXNERGJFREpLNEhBU0xHdkRE?=
 =?utf-8?B?RitPb1ludDFaSzlxN0JkRzlsb1BJWGg2OUtpWmQ1WWJWRzFveE1BTTZRRTVZ?=
 =?utf-8?B?MVQ0MytsUWJacXJocU0ydEE4d2hVOXFaUm91dlZyMDBJbmtNQUZ1dFNkSXlR?=
 =?utf-8?B?OVcrRE5ZNE41aUtURlVZc3EwYlhOaG5ycHM0NUJFdzVpR096dTF0SXNXQ083?=
 =?utf-8?B?TzQ3SXduOVhLSWNia2hUL0dHNzZmZlhrblNZbnBINXF2bWVWcjhPeVNKdzBw?=
 =?utf-8?B?R1pSZmFwbkRGR3BSaFdQa1JyN0ZhZ3lLc0V2YnVMZUtyQjNUaHBzM3NTakwv?=
 =?utf-8?B?YkZ2L29CeTlNTW5oT1lOS2hjRTVCRHFXSDJMVFhRQ2hRMFNZKzAxcytoUDB4?=
 =?utf-8?B?aHlFVjVBS1FObDlEL2g2TmcvNUFYZGpORjNnV3hlemFqWG5xMHBUNHMxOXVM?=
 =?utf-8?B?R0Z2SlRnR05Nb2pxYjVLN292NUYyKzlrVHdCT0xFMVArQS9LUXFsT3hpc1pL?=
 =?utf-8?B?NFZuSTJQVHlDb3B1M09rR1FwVWxRd214eXp6OFhFd1pyeG5VOXVEcjU5amV4?=
 =?utf-8?B?cFpSUCtPNkVoRjRPUS9sOTYvYUVra0lENjh2WEdhMTI4bFRRQysvdEJlQ1h3?=
 =?utf-8?B?bzJaS1o1NUd1c3ZBQ1dKV0ppc3hXY2VXb285SUxraTR3Y1RkcG1LSVZvWndv?=
 =?utf-8?B?WCtiNm9vTytsWVhaVm1pZGtpc05OQUljTERpdjAzL0M5bko3aWlzVWZLV000?=
 =?utf-8?B?c2JJMDZISkFyQkxqOEhka2U0aW1tZERkMTZXTnhSdW5jZy9wVytLbzFxT0hC?=
 =?utf-8?B?dlhoZE5DZ2ExQUkwYzI3Yk5JM0c5QTFMT1VxQ2R3VXhvMjZXUTdscnZ3bVFu?=
 =?utf-8?B?OFBCOXVtS2RFWnluSHArM3NrZDVJdkRwSEF2RGdUaXpVWlhVOHB4M1gybmVH?=
 =?utf-8?B?RVlWUmNlSGxaSXFCMGdkZXBQbXFQM3JHRXJkc3FSaElTUzZBZUZZK3BoN0Uz?=
 =?utf-8?B?MkNNNHNseGIyeDBMNHV0bmRuQUhnVEhObWNIZEoxNGcva09GWHlVazMxcE9T?=
 =?utf-8?B?RUgxNEwvenNxalU1Z0l2bHo1VG5neExBczBRRmV5MUdDeDZnNEROYXAxUWlF?=
 =?utf-8?B?Z0JQVERnazluVmZxVG5UM2x4RGRtTHlrSW55RWFoVkhFMTVIdVdTZjh1YStt?=
 =?utf-8?B?akNLanloKzZxbW11MzI5cmdrR3pucEhPRU9rNTBRU3o4TWxBVXUvNjU2QmtY?=
 =?utf-8?B?N01sbnI0ZDREcERiOFN1cDg2UVplTlRMbjhHMEhXL29XMXRKNWpFejlkMkxq?=
 =?utf-8?B?b2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?R0ZidkQ0V055czRjMHlMR1gvUjd0Q2ZySjlwRyt2RlA0MXhVNXhlMGIwbGNl?=
 =?utf-8?B?dFFlTE55Rm5hMXdYYzdsYVA1OHBxUzJ5bGlWcVJ3NFJ1bjVqYXZmZFVETEkr?=
 =?utf-8?B?RzdUellqU0hOaFJqRm02QXZKOFord2VFTkRVSExqdFNCQVk1M0lPNi9BL1FQ?=
 =?utf-8?B?L1VOMWRCUXNaS0s3RmVxRzZnN0dpcnNGRmorSThmNDRFVjFRUlRUeERMcnlN?=
 =?utf-8?B?VFZqdExSeVhuNElXeDV2d1BoaEJjVDNRdFY5QmpjRlY4bDN0NTY0M25LUGJs?=
 =?utf-8?B?MkVzT3VUNjRxOTc4VW80eHlmNHlHLzFjRTdDYWJTcXArNWJLWDJ4Q0xyQzRk?=
 =?utf-8?B?Uy9aQllFeWxqU3g1Y3RkWno1TjZKODhNVDNMOEF1bWZ0dDNKNUh6bFpIOE5S?=
 =?utf-8?B?SGk1bSs0WTR0V2VxM1dSSDlOSERwWXhwYmFHdlNpNkF2bE5JbUNkREZuL2lj?=
 =?utf-8?B?UUEzRlRML2NpeW93dHBJcnExNkdYdHFyM1BlZFV5WEM5dU12OG9OaXJsSmlX?=
 =?utf-8?B?ejZCV0NjdkN5UTlVOUtoU1dKZDhGSCtvU0t0R25rd0QzVnZYOWZQWVFnYi9k?=
 =?utf-8?B?VUdacGZncjVLamZTKytqUWhidEhteW5YNjhkWWhXYjNsa2hUaFZGZXU4NFlT?=
 =?utf-8?B?NXFMcjlsT2IyMEd2MVpXbzFYZW9La0JQVlRLU1psR2lURi83MTR1eW4zb2VN?=
 =?utf-8?B?MkVUMEN5S3UrY1RkdG4rNk1XaGhVOVJibmhCaW82Q2RKYTUxMmdCak43T3NS?=
 =?utf-8?B?bjhYbi8xdm5yYVh1emN0dURWSS9OSVBiSXFFeGJiSkVsNFIxRXZJMTI1OVZV?=
 =?utf-8?B?cGRveVlha09RanVLcXFxcXY5S3l5UVRENzhSc1hZTWgrTFIvcmNyUUtOdG5t?=
 =?utf-8?B?Q3g1VDRQbk5taEtBSSs2UDEvMUhDZi9uaE5MelhwcHpnb0diTjQrZkVXQ2NO?=
 =?utf-8?B?eXIrOWlmb0svWm5Bc3UrbHE5WEtOZ2FZRVZldHFpNEFyeC90aWJkckZ3Uk82?=
 =?utf-8?B?R2JvVU93L0VJWk9jRFNlQmYvL1J3N1AwcG9FdFpRaW96UTZ2WkpYZmZuTWUz?=
 =?utf-8?B?VXlpejYycmJHbnZzQll6bm5FeXRUS0JGZkVoSjhyZ1RkRVQzMEppQk4waEhQ?=
 =?utf-8?B?MzcwZlF4V211SnlUNkxZYkk3djQzOE42UENEQUNRSlZDUFZjUmEreVVUQ25N?=
 =?utf-8?B?UFpxdVR5ZjZWU2Qwa3d2U2poTzZjWWx3ZkpxUTBoZ2l6ZHV3Y00wUXRVWVk5?=
 =?utf-8?B?RisvcDExUDdNWkZMS1dwYlJQbnJ4WHJ3Ylh6aml5WGkzZ0R1SE9BNTdueEpD?=
 =?utf-8?Q?ANGL5Oc2uyWOU0YHN4YFT2UzWzFN8YQXlL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad4db3e-423d-49c5-3088-08db2a34252e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 17:46:05.5225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFxEYq0DyGnQJncUgqokCI7EE39L4wO7MfTxlW+JZy8E1hywdS7AUaLdY8M+ySn4fsaEdUeV9wAT2YpNNWE4BEcIaOSzZVGMKbDrcWne6vA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7065
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210140
X-Proofpoint-ORIG-GUID: v3IxDMIzbBvd4McceXA5jUo1Zh73v9sm
X-Proofpoint-GUID: v3IxDMIzbBvd4McceXA5jUo1Zh73v9sm
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/23 12:03 PM, syzbot wrote:
> RIP: 0010:vhost_task_start+0x22/0x40 kernel/vhost_task.c:115
> Code: 00 00 00 00 00 0f 1f 00 f3 0f 1e fa 53 48 89 fb e8 c3 67 2c 00 48 8d 7b 70 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 0a 48 8b 7b 70 5b e9 fe bd 02 00 e8 79 ec 7e 00 eb
> RSP: 0018:ffffc90003a9fc38 EFLAGS: 00010207
> RAX: dffffc0000000000 RBX: fffffffffffffff4 RCX: 0000000000000000
> RDX: 000000000000000c RSI: ffffffff81564c8d RDI: 0000000000000064
> RBP: ffff88802b21dd40 R08: 0000000000000100 R09: ffffffff8c917cf3
> R10: 00000000fffffff4 R11: 0000000000000000 R12: fffffffffffffff4
> R13: ffff888075d000b0 R14: ffff888075d00000 R15: ffff888075d00008
> FS:  0000555556247300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffe3d8e5ff8 CR3: 00000000215d4000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  vhost_worker_create drivers/vhost/vhost.c:580 [inline]

The return value from vhost_task_create is incorrect if the kzalloc fails.

Christian, here is a fix for what's in your tree. Do you want me to submit
a follow up patch like this or a replacement patch for:

commit 77feab3c4156 ("vhost_task: Allow vhost layer to use copy_process")

with the fix rolled into it?



From 0677ad6d77722f301ca35e8e0f8fd0cbd5ed8484 Mon Sep 17 00:00:00 2001
From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 21 Mar 2023 12:39:39 -0500
Subject: [PATCH] vhost_task: Fix vhost_task_create return value

vhost_task_create is supposed to return the vhost_task or NULL on
failure. This fixes it to return the correct value when the allocation
of the struct fails.
---
 kernel/vhost_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 4b8aff160640..b7cbd66f889e 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -88,7 +88,7 @@ struct vhost_task *vhost_task_create(int (*fn)(void *), void *arg,
 
 	vtsk = kzalloc(sizeof(*vtsk), GFP_KERNEL);
 	if (!vtsk)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	init_completion(&vtsk->exited);
 	vtsk->data = arg;
 	vtsk->fn = fn;


