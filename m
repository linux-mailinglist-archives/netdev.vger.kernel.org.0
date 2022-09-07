Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A148E5B1019
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 00:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiIGW6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 18:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiIGW6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 18:58:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34E4BFC6A
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:58:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287LIxNg010203;
        Wed, 7 Sep 2022 22:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bGg02X05tKeKofhcs7p0UNK8BfTf8p5l4hF0n8OtswI=;
 b=mlak9ivlCzuXe414XnoNcbmhyhHIxtkDAia4xV0MZ0g0W7Bi+gAEXVYm2SSlcwutp7ZN
 e3BkhrtzS0pYFWP8d031GmQ7kRuDXfnC8Q8jnHdsYYNfD6N9XK8bfWl/j/QYrIou5NhW
 o6EnEewoNjN7GV/J5gvTlXPrU/NgWwDjak45TPRzrY0MnNfo/lVx7ncQlU1wrSHV38An
 ETT2uHNEKvxSYqqkUenFpVOkNSiHzQLp6aNMmsvFk4pqbt6vgtIjVFgw4Z+MxNFi/cNH
 ROZTRp4YZj7+i7c9DX2DzjPgDYHJoH9r97wzUDSZQpMhpRCeTM//mR0Ppy3sHC2tKkgD Nw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbxhst8rd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 22:57:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 287Lw3YW033527;
        Wed, 7 Sep 2022 22:57:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwcayvsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 22:57:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQcBx8ALWPm6/SoSuJrNzKBKGiHJcKCyEgjT4mbGUcs4shK8G0Q/IMG6tXp4eVzehddeGS/J4tGYLGAfWdmjEowqEdcNwgYdx7Jm4LhECyFQDJ4uNFO0WQNLutaRyt+fVeYR3/6YuD36rBvF5Y0NMJiU6D5x/hjQokuaiWYtyazEopqFX3SFf4dHRiltA8UiLFr3VspET04LzbxbDMpbYndGTY8JtMaIrBovtYMFnZuVRpvGbHDZ5C+X/L0L5jBOsotL2xrF5QqULRHzaAeOSmgHtGt2pLQwI+8PRQC4RnsZFFlZvV96I+c/91pHsYjNINV0NnsZwU0M44XZvuVrnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGg02X05tKeKofhcs7p0UNK8BfTf8p5l4hF0n8OtswI=;
 b=cqFNH4BdFNuTxwEzvJneDLzAUF8dkTWs7mLoJo0ACLd6+K+jN7eDCd4YiSLO/f/SCWzK+Xmaw4ks9jM3DwgBSPQk++IzI63F5HijSsEd3abu3/bj6Wlsn18YKI/9c2xZ7jlM7F4j8Dnbgf+Cgn+euUy6A9kCuIRLAcyhsUte4WFQ+96pSqxVkihQ5VTNby34Hj/HhkWCoBrpubSUI+crlZTRI4lREons47Ium4OeVTQdMO/47f+CxfOmb/9YkxEp7vsyj+E3DyFIi/CWTU+4H2daN9Y1hhG6Nf0T5l6+FNZ7JDGg/QhOiqiKiFp775poUc7/wiLbAiNSCwBjjn5RiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGg02X05tKeKofhcs7p0UNK8BfTf8p5l4hF0n8OtswI=;
 b=elNsEmkE/gr6KWtsI7Ei+mtvRpclmvfsrgw8xTvC97Y/ptOPP8YHB1HzfhwRiFoNvwC4hgojzqxZTFoZRjoYRPIVIwjvTVqiVb1iF/9eI7znoViC3dNWFRqMjXmq9h89BaE+9ykxw1dRZsEVh7SkBZOG/D4OAuedHVdspWBbMUo=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SA2PR10MB4652.namprd10.prod.outlook.com (2603:10b6:806:110::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 22:57:41 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 22:57:41 +0000
Message-ID: <010b795e-7f90-0ea6-e4d6-88a706c160a6@oracle.com>
Date:   Wed, 7 Sep 2022 15:57:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [virtio-dev] RE: [PATCH v5 2/2] virtio-net: use mtu size as
 buffer length for big packets
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907153425-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54815E541D435DDC9339CA02DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <8d80bb05-2d01-9046-6642-3f74b59cc830@oracle.com>
 <PH0PR12MB548125D85533125828CE8454DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH0PR12MB548125D85533125828CE8454DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0052.namprd04.prod.outlook.com
 (2603:10b6:806:120::27) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a72e807-f2ef-42ac-ff39-08da91245de5
X-MS-TrafficTypeDiagnostic: SA2PR10MB4652:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dx1LAzYiVLh/LCfpsyb5KJscsIG2+mW1Yz1L64FcUzWXL3IKudxtJYMDMZlJw1JMXH6m2XUSDRJwz87AU5Bq2b3meZQdvHREupa8rnyiCw5hyk5/MPVTBlY5C1GhNAo9HABtjAmYt7EA71WCHHYG7xw51by97ypHEQFwAN4KVm+zpbtA6Jsz0zHFoPQojWNaqFNBvJtlU4D5/eYvkPyDN3Ti1gLI1xvqv8kYSa9RektIqw1Uy1gNFDd9Us0ljxCPVzQtCvgoh//1Nnc+DGjBKQPNHkQaps6r3NiFET4b8ZSlbBojVbDQWKBvqLFdhHbCB+FIKOFamGWOlLbSrBaAwvylfaEXTFIuWS+DlUWJOrP9VVyKQtf/GVZqXwx8q9W1hDPvQkHioMH2VBVo1juX06GNTb89GCNIzLDRS43iwNwsDEQvLPz9rpeM9lySa+B5IivuK1D87wT2fLpBd2J+HK7D3dYFSe4Q8qcCsRABRrWqgwHwsE37c5lvAsJInPx3y8VF/Pp7sUmus8JbG0P1VTymcNpw5ClNdVkrRfVDuEBzxao7EhhwmoplxA5FD8aw2Ga9Q9oYayeW+UQZncBPYkm7JaeVghtwVr5gKAGEe/Az1lBAIAVYLBO3ZA8+JBnwCLiszNQbxw5upYAFDtJ0qUgl/FfQ0qTteDbIzcylI5s60aBVDQd8a86a6DskaLlw18wK4P/fEDqLDgwDxSNGQc6i+cbeo87ugH9KPmdnLF755FcB+TgZh/AGgnfu4yuoTII19sQcRewCVr2Vj0Zx5VCaE6cAtzZwaaJD7LlqQpI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(376002)(346002)(396003)(366004)(6506007)(53546011)(36916002)(2616005)(6512007)(26005)(6486002)(31696002)(6666004)(478600001)(41300700001)(186003)(83380400001)(38100700002)(316002)(8936002)(66946007)(66556008)(66476007)(8676002)(4326008)(36756003)(86362001)(110136005)(7416002)(5660300002)(54906003)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWNIdUZyek1GQ3pYaytHUXI0VEQ0aUZVV241MzdFbkdXZ3cvWThVY3RmYjNT?=
 =?utf-8?B?L20rYUZnVlJrSUZjcFlhcmR2V2dkcUF0SVFDYm1Tcm92TW1OVEJGVFNyRDd5?=
 =?utf-8?B?R2hIOTRTdE1hTFlEbmsweEk4ekFlcGlhZ3UxNkxiL2g4QnhIamNhS3htZmpk?=
 =?utf-8?B?VUx0TDNzSFB1VGRrNUxmWHdFbWJxeDZXbE84aWVGWGtDbkNIRHB3dEVvV0VM?=
 =?utf-8?B?Q3ZBU3AxSmtQaUJ3aGUxVXlpeEpZMzBiYXlzbURaMzhPQVFMTW94YUNldmd5?=
 =?utf-8?B?WkZ4MURaaVA3Sk9yckV5bityZ2xjNENzVUNxNW1LNHBhMk9TWnhvdU81QlZE?=
 =?utf-8?B?RDRaY3NCRXZaYzk5MVAvNlBYSHV2VldMWUZiUzBmejJadUZYU2dPUXR6THUr?=
 =?utf-8?B?dDJZYlpNM2N6bjZ1cGhwejR3dmNBcVg0RzRqRTZoSzFWU1hqSVAvR2diVnc0?=
 =?utf-8?B?VytLZVl1VXM2WjQybnhrOFpHbW91ZTl4U09hSGlQRVc1V1lUUmJtSUl0UEY1?=
 =?utf-8?B?akNsaFc1MllJMHVOVm1DbllrbUVyL3VoK29OWlZkOXcwRVJhN0VoaWl3eHk2?=
 =?utf-8?B?NGc3bG1xbVg4WTlNVHJsMUZLWGppVXZITHFuR2FNUTNicGxiNzZubXluQTNK?=
 =?utf-8?B?Yk96bVM5bENTVjNhZWtNQ1kvMXpCQVFYdEx4aTdyVVhXbGUzRy94UUNlT2dI?=
 =?utf-8?B?QTUva1hoUC9UbTQydUFLM1p5VnhoZFpIakQwR1c5TndvVGNTZ2wwamhERUNR?=
 =?utf-8?B?ODdhNGJDSGRHcURpQXlEd3JCTFVBV1h1RkpzYlhmeWtFYk9Lc2s1ZDhaNWJM?=
 =?utf-8?B?YkEyZEh1TlYvQlRHVGFnbFg4czJmZ0FWZlZvUEswaEF4YnpEZkN1My9GcUJE?=
 =?utf-8?B?QnZwR2p1RlJYb29rOGpMNjNjSFNHak5zR0dzNkl6d2U1M1I3UDl6QUhlMTRv?=
 =?utf-8?B?WjVVYTBuam5kZytvdEQ2akdHcGVrR2praVJ4dFlMNjFoOGVRZ2JWVU9HczFr?=
 =?utf-8?B?eHZHUnYxY2dRK0pXampsb1NUVVB4eW5xZk1oMjB3MDJTQjJCaXQ0SDJjenNm?=
 =?utf-8?B?V1VLaGExSWFSR1EvSU5TVU9yc09WaHJmbm5JYzFVTVFoWk9OYkZsRjNwa0pE?=
 =?utf-8?B?NkFzem9WNWlVZklkNUIreDFTeW9aK0hGclVQREI4QmhNcDVZai9DWmptY0VG?=
 =?utf-8?B?RnJubTNRc2dOdnhNQnN0UURLWjdWREtDQXdxelZhRjh0SmtwNDdYZjBRRlJt?=
 =?utf-8?B?bGJ4blhuK01YNVZ6K3pVemtWYU1wREw4ZGV4d3JYNFdlYXkyVWhtMXhTR1Y2?=
 =?utf-8?B?WjJQQmRvWjZBbThPbUNOMUNRdlBYOUFRdWpZSmdGekJaMXZxdnVQN2Q4Mzhk?=
 =?utf-8?B?NFA3N3RqS0RoUTF4UGZKV2E5dXlJbTAxcU9Na3FHQzdDNEdnZjlubndUd0JL?=
 =?utf-8?B?OVhncjFwdGh1WlU3bjY5QzlaQVBUSmpBcmVkK08zaHZmcE1aMjFqQWROTFI3?=
 =?utf-8?B?a20rSjJFcWNvbDUvaXQwNmJDQUdXK0ZmUFRSSlVseHpZejlnZ0Q0LzlYZE9U?=
 =?utf-8?B?aGsyN3V3WllpU3ZpcVJYRFNMWnNmTG9ZTnFSdXFodXBva2MvZHY2L09qRWRJ?=
 =?utf-8?B?cEZaSzlia0dVRnpIZW5zUHNEVTVPQzF6N2htSnhhc1JQMFpwV0tYeTJFd0lm?=
 =?utf-8?B?am5pWjRLYk5qWURob1Q4dEJaRGNrSkw4K0p4WjZ3SE5Qa1F1bEQrWVpWajFi?=
 =?utf-8?B?Y2J5N21VSHl3OWVNUUcyNld2YWlkRWg4MWlreWtaV0s1Q3dNYVErOFl2bGJG?=
 =?utf-8?B?cUpCODlCaFp2YlRjcEZKcW1vRnBYY2pNYWlZdWJERUVnUStRK24vSk9PVXdY?=
 =?utf-8?B?V1BTYlM4dzlDbE5vYm56Qlc1QUZKdWZGeGJrZ0RCSTBGY2R2dnBuK3BFbXZJ?=
 =?utf-8?B?T05MRjVkTFd1VlNJOE8wYjBTcXNJanFzWCtRVnBiNW5ZOTBTYTNyWW8vWjNp?=
 =?utf-8?B?Qkd3QzduNXRCOWtGb3JHMk52MFRaUjdMdDhTY3k2NUJ0alpLcEQrbzBobnp1?=
 =?utf-8?B?YnVNMTV3SjBOTlRFVCt1V29QUHVZSmFBR08wSE9JNzhwVGphZkZEZUtjUHha?=
 =?utf-8?Q?Ju6dZp8reVaxOQ2J3RJ+X8PMx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a72e807-f2ef-42ac-ff39-08da91245de5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 22:57:40.8894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkSVvfRgakHlhvOh7UYxzEAhPJXt7tFX2AfzemoU9Rial3cVfVHsJxuOwnP3zr+0Pwvi+8YtyvuruvfeaLQkBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070084
X-Proofpoint-GUID: IvTa4TTuNKtH-H3H7h6tYv3xPk28v3bR
X-Proofpoint-ORIG-GUID: IvTa4TTuNKtH-H3H7h6tYv3xPk28v3bR
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2022 3:11 PM, Parav Pandit wrote:
>> From: Si-Wei Liu <si-wei.liu@oracle.com>
>> Sent: Wednesday, September 7, 2022 5:40 PM
>>
>>
>> On 9/7/2022 12:51 PM, Parav Pandit wrote:
>>>> And I'd like commit log to include results of perf testing
>>>> - with indirect feature on
>>> Which device do you suggest using for this test?
>>>
>> You may use software vhost-net backend with and without fix to compare.
>> Since this driver fix effectively lowers down the buffer size for the
>> indirect=on case as well,
> Do you have sample example for this?

ip link add link ens300f1 name macvtap1 address $mac type macvtap mode 
bridge
ifindex1=`cat /sys/class/net/macvtap1/ifindex`

qemu-system-x86_64 \
   ...
   -netdev type=tap,id=hnet1,vhost=on,fd=25,vhostfd=27 \
   -device 
virtio-net-pci,netdev=hnet1,id=vnet1,mac=$mac,host_mtu=9000,mrg_rxbuf=off,guest_tso4=off,guest_tso6=off,guest_ecn=off,guest_ufo=off,indirect_desc=on 
\
   25<>/dev/tap${ifindex1} 27<>/dev/vhost-net

indirect_desc=on is not actually required as it's on by default if not 
specified.

-Siwei
