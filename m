Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F96593515
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 20:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239096AbiHOSTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiHOSS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:18:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873C61928F;
        Mon, 15 Aug 2022 11:16:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FHmemO011210;
        Mon, 15 Aug 2022 18:15:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ulAQtodvz99jMno1lcC+C8D29WngG9kDN9/byfhj5k4=;
 b=y+BudmQdM5FcMIiBQit+fWc0Sa9wQoCXI9QqdU7k12vL2xb9BdQiASgkmaUJWNWbSJLj
 kNqg9QWBvGCUqG0LneBv0pDfkCVpcgWh+WFpPMxdclFaP+YImoB0zRi8P0G7Vtux0xxV
 uBecCdWJ4WfgMXJ0jEetkXgjZzgEJwa6PmlkhCayigA56USJvzOSRA/GVz++FqPD8zey
 OE8WQaeQ9lXCBbulxoXQHkGxuxOFmbp6FBtzEmIjek66BeV5UNBKLXc09Se6FVgtlUPR
 bhLGQl7M6uG3JnYwzCnTaazLjklLppJmGbtOO17qTKwJc1yg+ZeeMS1xSLgHwWk300/e 6w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx4gt3n7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 18:15:58 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27FFtqfG002894;
        Mon, 15 Aug 2022 18:15:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2d84n17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 18:15:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZutE3u5vcAEWTmwtgxwF/f0AbarOgPb2M6p4qP5+Tm77h0rRtQFF4o1609YwF6IurUHh0CRlHFk9HGIVM38nCFjH8mJnWIRv2Qm2DWkwT/K40KqOJj641wUItwjwFPCBAaDt/GsoHgBXsoCyHoc+ntlSxYrOD1vQXuoyO2frzvpWGNPNdEWE8gXgPlPxFWAgE1WrTO4Sq1GaIZ+BkTH7xokQfrigLbUMF5nN/enSdYeh6biupcwZVK4sGDWbKo+j+zLb7RHtNOG4l+9AcjbgAqdPro9Z+3MpE5rm17h6OLMJledwm6ViYgGduT4C5yKfYa+r9yxQlxMz5zjYuy7zag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulAQtodvz99jMno1lcC+C8D29WngG9kDN9/byfhj5k4=;
 b=dUn/CAykGMp5Z3i+8vUay76O32F8nSIk9Pocwb8c6V8rhFoeK39Gb/3WKI8+uf+sJgHicq1uS8ngfBD59ZZM8xLmkTX4dUCf1cFG9lh3zaoPaHta/ETafNLFOKUpPHUx/JRJ8QMWMdXgx7uTwBbvMY1t6w4dTcexWFtrEOp1XjgD0Iwsm122Fyuziby8Yy1qu9jHfAqxvTUQ2HyV5zY5U6gba6aF7WXNk7RjI/ren9bhJODFpYwf46JUnsVvK0CKJuhVV4Au4Q5ao9WLKX62A85vfZUTVnRhHZx7jQ88oK/5gwmnY388Hg90M1MG49toNSBZwYRe4JmGvSW8HY1Oaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulAQtodvz99jMno1lcC+C8D29WngG9kDN9/byfhj5k4=;
 b=JGauENBucnC7SCLYLDSKiegoiaQL7iHCgCXs67CwD72l6svhWHY+XxAGaOGa1UgiEQXTjwK6mx2kLAKbDy2gaKJ/7VT0irxGUlJvUTNjLcq0goHli8L5CGHjmpmkzt/JZw5J+VmTqPjqLvQStcmtJE4DDm3yfwFvUqgLtx+d/1c=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by CY4PR10MB1653.namprd10.prod.outlook.com (2603:10b6:910:11::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Mon, 15 Aug
 2022 18:15:54 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5525.010; Mon, 15 Aug 2022
 18:15:54 +0000
Message-ID: <15a9ba60-f6f5-f73a-8923-0d0513ea7d62@oracle.com>
Date:   Mon, 15 Aug 2022 11:15:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Zhu Lingshan <lingshan.zhu@intel.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-2-lingshan.zhu@intel.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220815092638.504528-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0035.namprd06.prod.outlook.com
 (2603:10b6:5:120::48) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22fb6818-7f3e-4b68-7bff-08da7eea3143
X-MS-TrafficTypeDiagnostic: CY4PR10MB1653:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jbcUwnCySD60uvw3z3FEpnzraze6zppSv6VYxh4+uhKNW2rbCY/My7pK4p5KueEeyBkkypcwu0Nx/6nZ/sIGAKSkZWEICZlxgte968UeIrBieP+h0zA2UeN4fgUNgoR1RFWzAZhjc/P5dNgzSnYABcWYazQDZzDESIf7Kn5mZGBwgex2sitKbm2ZMHqMh3MxrgfDg1uMcQZ3oiLJKdUlkHg5LoDQ9PdCRgkf6MTGDgSsj37aBkzXxu6GYqgsfYlXI73sJ8kpK0WrSc1AH6CE2ijl0XUptDsQG30rRBPgR8DhEFMy2sMJKiHbefz7gTNntlblOsVwKi8wrwuj5UghdxxMA1fiKQqP4vygqhpE33I5JKUE4+yPG+Btnz7GqReSDtVOez5IHi1vZvgex1BaIO1Q2hYvpAMrabXf+yb6eQKBlS3QcRflr3JpZXmq0Jj9r3Q+cAz7qXD61U2HMa+wsHwjiUw572ygrm/S3dq9nL4cFoh6Yhgfc2X71XUauJkYV1aCPr45gxOVN0z7dQRJZJpnvwt+ku3s7D+cFE+D1GRl5qL5DOVURdzkBsk4Di7Yi0XJZ3ijvMJbVlwfUM2dKBFZIlI0S+ZKRY9KkaL5BkWFILkCWB7dXbnWCeXR6npelkgGWniPY555qmNyapSdnnuRNugs20uKjF73FI4t7QIyDQ7BMAULqnqqKJ+lPc2c0p0tO7hapdWAub5kj4fM/J58PC/lwSHs941C+Vl4BO9d9pLBnfw6yO+9nT25JITMFxjCtvc2KKJXX2t6BKiPxbgMtsPni3U9dh2HFVuo1ZZXUwYf/D/VSMEEZQOvf8MKwbzeD9hEq+sT61QguHIGTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(366004)(136003)(346002)(5660300002)(2906002)(86362001)(31696002)(38100700002)(53546011)(6512007)(41300700001)(36916002)(26005)(478600001)(6486002)(6506007)(4326008)(66476007)(6666004)(66556008)(83380400001)(8936002)(66946007)(316002)(2616005)(36756003)(186003)(31686004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlpnN2R2M2xwUkl2cno4ZVVXVTM2NzJDL0VVZ2xYaUVpbkhzMVY0RkNvb1RI?=
 =?utf-8?B?TWJ4T2p2eGwwRnNrZGlXc3Q0M3hCVUxzQ1VpL29UVW4yZ3diMUR6UktpZVZ4?=
 =?utf-8?B?ZE1SVC82MHhNKzB5dHE0MXNUWUlTQ2h4YlJCU0lDd01nVEd6d0hONkJtdENG?=
 =?utf-8?B?YTNiZ2JrTlRtUCtBaEVaMThyaFRVNDFFS1pvVXM0ZTBsK2l1aHRsc3NIM1hi?=
 =?utf-8?B?VmpvWGZLemxoZFc2bkRBbGlja3pKQ3VxemlhbGVYMlQ0cWxUUFR3bUlLckZw?=
 =?utf-8?B?SmYydFp6OFYwTTR1a044VnJEZDZYQXFDMWlJTGsySW55WXM1ZklZYkJPcWU2?=
 =?utf-8?B?RHdXV2RJTlNSb29aUXRkQThlcGNCeU8wMkdEVG05SHE3V1pHQ1U2TUVCUXhO?=
 =?utf-8?B?YUh4Rnl2Y0JXQ3JybnhNUlcybnBtb0llSGJROVJJbWtFWDBKeFNJSVI4WU1v?=
 =?utf-8?B?c3I1TVN2SnVIVG00K0JoNU9MUXI2ejN4b0Y0MmhhTnJDclR0RjVYbzZ4WlB4?=
 =?utf-8?B?ZGE5QkZqRnBxMDFhbVBQUzEzY3RzOWJLZE1haHhOQllRVEd3dDdxT21qenJ6?=
 =?utf-8?B?Z1U5WFRBcVQ3L1ZWRFdUTU5ZNDB0YVZlbG5wNmMyRUFibUYyeTFmV1doOXU2?=
 =?utf-8?B?dGxVMm9iR1F2WWxDNloyQUxGcGNkcnF1YXpOcW5BemFMdVp3MkROTEh4d215?=
 =?utf-8?B?TEpNZi8zRHl3d3VjcC8rYzFoNTBmVWxza3hwbTkzYTFzL0ptU0VRM29CRmJF?=
 =?utf-8?B?VE8xMEdYamk1SjRTRzA0UTJIa2MxTkVQeml1QWtqNUJ6SUpVZGRuYTJRSWZR?=
 =?utf-8?B?YnVheTYzWEltMXBlTk9wK1V6SS9wWC9kL3RQTTArMGpJd21vR0VkSWtNVVlx?=
 =?utf-8?B?ZHRPQTF1RW1zTFpsbmhvV0RLTitkS3FiYkRwWFZXQTBTbWM4cTVURXFOc3Vi?=
 =?utf-8?B?UlZOVWgrTzZhNXc3Lyt1ZEViSXd4QnE4Mm1MTlc1YnRqRzFQSlVZV2x3NzVJ?=
 =?utf-8?B?MitEN2F2bHFZZEZQbU5pU2xsNGtKYVlpRGs3R01wd0VxVXV6T1pEWFFST1Jw?=
 =?utf-8?B?NlB1MUhNamgvdGdsSzN6K2xZUUhwTjJRVDhsRUlYWEcyZXdBTjNRcVE2VEpZ?=
 =?utf-8?B?V2Njbi9WTnJicGJyRFlsQWRsZ2ZwRHlnMnZPU2tBUmxHaWJTOTV0d0F4WSsz?=
 =?utf-8?B?Zkp2Q0JpWUppR3FMSkVibGd6OXpVa2tpS2FXVStUQThkMTFSdVI5ZHlFWDlo?=
 =?utf-8?B?b1ZWOGloT2xjOXU3dlRSVXVVNVZyQStTREo5bWRqdkFqTmxZNTQ3NGhIOXBt?=
 =?utf-8?B?RFdHNTgvZllnR0dENTRzOHJzVnp3V3JyTlQ3ajlvMzMzS2FHSklUZExmeXB3?=
 =?utf-8?B?ZzU3VXNZUVdpOWVsQXdZOVlJTzJIUTMwZVVVSlV6c054UFJ3RWlDQUlkdUNn?=
 =?utf-8?B?UGlOUHV4MkRqVlpBd003b25NNFZxLzkreGpwaHcwRU85N1VWUUswaHJLZ1U5?=
 =?utf-8?B?V0FreElzRWpUWjN1R1R5RHFTOTh3WFpkRUZPMVhJWUphUkhBZkhoOTREQkNR?=
 =?utf-8?B?RTJwaEhUc0xXa3FkU1dNeS9rUFVIbWpLRDF5Y0FFQm5QRWJLQ3puUkl3dU9J?=
 =?utf-8?B?TkJtTnowT3N2Q0tYZ2Z5SXFhTHJCaGlqdTROd1NCSTdJaS9jaEh2UjIyRHhy?=
 =?utf-8?B?RmRyd3AvRTNISDYyNWNRZElhaVVyaEJqV0VXVUplNExTYmFwVTgzRDdMTnFz?=
 =?utf-8?B?QUcrT0UyQlJzQUsvakFoZkg3bDJZUjRidjYxLzRMMHVvN1EzMkZuTFM3OG1F?=
 =?utf-8?B?S1ZqQTd2dE8rTDFqU24ydzMxTmFTQ1FpbHhWeGZURWFzREh5UDI5RmhKMGh1?=
 =?utf-8?B?RitpanpLMGthSlNkeCsrbDd3eERaSTRsOG1weGVLcHBZeTdhdHdKRVZsWmgz?=
 =?utf-8?B?bXdsRVlhQ3JSQzZZRjRzVUJhMzVhdXZYMGxqREZOT2RjSUIzdThBNURTNmRk?=
 =?utf-8?B?SWZ1VjZMcFo2Z1JpS2ZieWk4dVpPN3ZFOEhFTzFnM0lia3dnQ2EvQmZZdWMx?=
 =?utf-8?B?K1h0UDRLNEZCc2c2TnNHaUdRY25PRmJBd2Q5RlFzWmFEZXBodmFNWXdUdkNp?=
 =?utf-8?Q?9lQ5nwYdNUHNrZAsleHINTXOj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TTBpUS95dFVkODAvbXFZRHByY2NyVlhCUS91QlZzWU9wS3lIeG1rM2JrZHRp?=
 =?utf-8?B?YzEvVzRMNTZCWnFMUTZiN2NPUUx4VDJHaVlrLzB4aksxTFBGTGxoWU1jR0R3?=
 =?utf-8?B?UFp4UEh0K1dhSEV5bGFWZ2FYaUJtaEpEd0NNaC9zeU9KN2EzSFlnTnVCam02?=
 =?utf-8?B?MFZyTnAzUDU3b3BhbTJmcjNxSDdwYjNkWVpwbFBGTm9qemhtRm5GRnZqNy93?=
 =?utf-8?B?UlM1Q3NnamhEWEE1dUVYNFVJZW8vTTRQWEc0YmhiSFlMbkF1KzJwK0N0aWZ3?=
 =?utf-8?B?QkFzeEVrWS9ZL0FFdUk3eFhJVmtJN2xxMk5mZi8za0tVTTdPaUV5VDBtSWh6?=
 =?utf-8?B?Wk9raTNOWGRCM1k0cXRWV0YvdEJGVnpnelFEVy91NGZPQ2ZlY3Y2c0JRMG9C?=
 =?utf-8?B?WW0wb3k1emZsclJ6WUFrem4wU3pqTFpqNnZ1SzMwNllPTjQ5Qk5FdFFrZnVQ?=
 =?utf-8?B?QjFVMUQwaVYvV2JTSHZqKy9rc3ZucG85UTE1UTl3d3cwUHFMdVVaQUZIa1BE?=
 =?utf-8?B?dDRDRHV6cnVTMEFtT3VFR2dOWFpZWGVISjdlYVVnMzBTSDF3QS9sYnRVY0ds?=
 =?utf-8?B?ZERkUW01ZCtOckZBdUQydXUvN3B5b21ubmJLVk8yamVmanYwTXdMUHMrY2Zi?=
 =?utf-8?B?VFQ3T0Y4M0kvUzZneWg4TnZFQXlLWXlFdXFtV3c5bVRuRzBQcktEUmZ1Q3Yv?=
 =?utf-8?B?Y3JZQi8vM05UVEx4WjFZazc4d1hYTlJrTVF4cUNXbjNOMnAvMDVtTkNLZkxz?=
 =?utf-8?B?MFRrM0UrTWVnTHdsNitPUVdsK1hJbk5UOEpPRWJ6dlRDMGJUNCtiZmtyeVg0?=
 =?utf-8?B?ek45QTI1anIyRGtBc0VLeHp6Sm1ISHpqd1lPdEdpc3EzN0pqWTQ2Z3YxVHZM?=
 =?utf-8?B?cEtlS3FYelNCaXVYTlBHenJWa0V5UDZEQjZ0SWgxTUhva3VMelpTaUtkc3Ri?=
 =?utf-8?B?dEhRNGxJL0FRbWtqZUJOaVhFVnZXRXlFLzE0R1M5Wi94cTZWRXdzSzJTMWts?=
 =?utf-8?B?d1VvMVNQLzBRZnJDRnVvVnd5OWNwSG5TQmcrMEFIQXY4cEZUa1ZlcFZWY1Fk?=
 =?utf-8?B?Z2h4TWYwYXY2NGVIUm13M1UzVGtTRC9mSVRQcHZCa0xJdG5KV3JidERHcXA1?=
 =?utf-8?B?ZTJSS2l0Q000a3JNeHRoaWhCRk1ybUtYVUJmQ3N4V21yRVFwYW5uY2liYzNE?=
 =?utf-8?B?UFlycDBTYzE0ZkxjM3gxUk5ONUJSRHNXcy9xZ0E4UzNtUng3WGFER3lzaHhQ?=
 =?utf-8?B?K2RYNzJOdkZQK1hEODA3ZFdKVHhUY2pMaUszL01QTTAyaEgxSVUyYnQ4TEow?=
 =?utf-8?B?KzJFNGNnTzRZSzFXMjQwanB1WGwwdDdXQS9yVmpBTXpIZWphOTJvNjRNeHd4?=
 =?utf-8?B?Q1JINUJyN2xZQytXZENCN2t3MWoyN0pzQUY3Q1RsMDVlUkxYWjFNRThzOHRq?=
 =?utf-8?B?Y29IMFNuQVpIa0hmOUhZbGtxd1RzcGh4bTdtMVRUY0lTUi9vQW1sMnZPQ216?=
 =?utf-8?B?T09IeHdtR1FveUR5RGtQa05OMU5zakY1dkFaQTFhSHFGeGVHK2FoN0NlN2JE?=
 =?utf-8?Q?sSlnmhUO1bzbd5+2P0A6ZR6HPTdDZTEQvCf1bJtay04kn3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fb6818-7f3e-4b68-7bff-08da7eea3143
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 18:15:54.2487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/clZak3HuWJ1JAgi9i/8lGBl/5noyLz3SY9z7ja/s52krcuP98OiE+kVY2Zeh2pi+yFAFmKNlugtFjdPv4o3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1653
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208150069
X-Proofpoint-GUID: oRT3wMUTEnerCqY1bPXlYqB4AWpUmx6J
X-Proofpoint-ORIG-GUID: oRT3wMUTEnerCqY1bPXlYqB4AWpUmx6J
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2022 2:26 AM, Zhu Lingshan wrote:
> This commit adds a new vDPA netlink attribution
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
> features of vDPA devices through this new attr.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/vdpa.c       | 17 +++++++++++++----
>   include/uapi/linux/vdpa.h |  3 +++
>   2 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index c06c02704461..efb55a06e961 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -491,6 +491,8 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>   		err = -EMSGSIZE;
>   		goto msg_err;
>   	}
> +
> +	/* report features of a vDPA management device through VDPA_ATTR_DEV_SUPPORTED_FEATURES */
>   	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>   			      mdev->supported_features, VDPA_ATTR_PAD)) {
>   		err = -EMSGSIZE;
> @@ -815,7 +817,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>   {
>   	struct virtio_net_config config = {};
> -	u64 features;
> +	u64 features_device, features_driver;
>   	u16 val_u16;
>   
>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> @@ -832,12 +834,19 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>   		return -EMSGSIZE;
>   
> -	features = vdev->config->get_driver_features(vdev);
> -	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> +	features_driver = vdev->config->get_driver_features(vdev);
> +	if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> +			      VDPA_ATTR_PAD))
> +		return -EMSGSIZE;
> +
> +	features_device = vdev->config->get_device_features(vdev);
> +
> +	/* report features of a vDPA device through VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES */
> +	if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>   			      VDPA_ATTR_PAD))
>   		return -EMSGSIZE;
>   
> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>   }
>   
>   static int
> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
> index 25c55cab3d7c..d171b92ef522 100644
> --- a/include/uapi/linux/vdpa.h
> +++ b/include/uapi/linux/vdpa.h
> @@ -46,7 +46,10 @@ enum vdpa_attr {
>   
>   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>   	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
> +	/* features of a vDPA management device */
>   	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
> +	/* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
> +	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
Append to the end, please. Otherwise it breaks userspace ABI.

-Siwei

>   
>   	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>   	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */

