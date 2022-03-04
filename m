Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A088E4CD89A
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 17:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbiCDQIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 11:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiCDQIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 11:08:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B455E14C;
        Fri,  4 Mar 2022 08:07:42 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224Bs97E032089;
        Fri, 4 Mar 2022 08:07:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=s64K5vt/OGe0DiEGvksjfU3/NxMbARsQ9JwvHLZerts=;
 b=Icw9nA2mEGOdrx9YfRhXiCkN5p2hCfYZrlVIyTqc6Ii++CeKii722dUA+6VAFjl8GNF6
 +jk1YrCacDPzBr28bmXW2Q4v1StcMVEkondBvndcYyY9JO3dZE5fibBLAynsu6HumJKJ
 L9+5rpjrue8koenlaN6Y9qw+5YM2/R8gQI4= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ek4hpp0et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 08:07:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iqgok8+Lpnojj7ZsG8tm///OURWVa6irdPL+4+OZOaVydo+WlNONbB/HXx8+9//X5/xLGPdZMZqI0W2ctr663RImrZsHyZJT2bE/TAiseZNUFc4eg/mNjdQseoQz3I4SjSOSXVaCp5AAV6rfMGVn+5NVCZ6pvEIfQBs5fJw8MsWmx00ncOE/r9vMiilxWt6wPHk7+ek/y2vbu3lAhYKbqBUwpZtqOxha3R6XOVtVHSPHbtybtt+FP95KEx0BkioQSagzp6RUJhcNtk5h8tKolDuYJPB8+8mxdIPGrsXUEh92HBWuXaHD51yOmo6YSi/TQkbnT19tTiogdi3FQpJdcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s64K5vt/OGe0DiEGvksjfU3/NxMbARsQ9JwvHLZerts=;
 b=XXznOcWr59A3zNCTWvypvaVtzwg/uBN9bfEQMDFjTe0Zr1pKYRW7dViwSj9kR7Vw3agymtMTWleEb/nBR6jvwCQSLFLcTWV3YSUP8fozfwpDzS6C8XDCR4XlcrwLeFDjIoIzvIulluiDtbsW9qsjWkECDt09UDDc8b0JRPVHWTV2BCJ9B8n7SqtFOoi0wIW93jS+vz5M9aFWwSw6lax334RFAJsQLh3xFdfkN6T7mNju7KucRR6kIXuy8fX0TOAd+CotajUqReooUVHl5+xrYsDbM+dlc10QwC3/8QtFeNm45wPgkuvCKWxTPkQpfjy4En9Q4MtHUqogMH+50YFvlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1554.namprd15.prod.outlook.com (2603:10b6:404:c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 16:07:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::91dd:facd:e7a5:a8d1%3]) with mapi id 15.20.5017.029; Fri, 4 Mar 2022
 16:07:25 +0000
Message-ID: <9e940637-1381-f51c-afef-9c78d463ace1@fb.com>
Date:   Fri, 4 Mar 2022 08:07:21 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH bpf-next v2] bpf: Replace strncpy() with strscpy()
Content-Language: en-US
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com
References: <e1e060a0-898f-1969-abec-ca01c2eb2049@fb.com>
 <20220304070408.233658-1-ytcoode@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220304070408.233658-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: MWHPR02CA0023.namprd02.prod.outlook.com
 (2603:10b6:300:4b::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bd16590-c1c9-4762-b7f1-08d9fdf912cf
X-MS-TrafficTypeDiagnostic: BN6PR15MB1554:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB15547DFCADC3D9FD27B3BFF1D3059@BN6PR15MB1554.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sx8UxeWO8pcZd33Y4Bk7h7SBQ7f+LRIHwj3jT8j7ltPVG/t4Wh3YD1tlKxubaEFPkCok2KBgVJoeAzlhWZnqnbs7TqS8Ckd+yzTVUXVzAU9Z2IyZCLsA/Xa7omNsagrjh5LwQ+sAlGA9fKG0ID82Nt5uT3AhqR8kHdX9M9DqStQRelOgrEzMGE0QlGlgQxqnviwGk+ZgHQmsU/mzNFXSNzwCddOmmNg0delq1u55i5H6+fWaCnjKAZcggeKWOo9pTsMVFtacoU4KptfQgibtPT3ShqmpOFqvhiTLs84QPkBWFNIBpaaw0uzxfjmY9pdUbFFQtvA9DuWISSoFOv98XA22kzRde7AQNBZDdtY5JJfxyF2/pOrpBfhcqJaWAR3LSDx46+rQVXhSlVvrF8eRbTLG1FP/lsQDjgbahCvg0ezLntvTKhRMOqdUYx7nBhJB1TxC5dCKWBQ5uI+ZXA+YMqTH2ZYVFHNheR2gZvEhgWhpSq4eNn7hBVvUO7ULPluzvHNzqgkOLc0YdyoCyKQNNLs5q77n45n/CNtqUI9PYxNURe3a95kFcj2TaBHEvjfBtGZmAzz1SJd5vhhWzmYc8hSg+whIxh3Th7gWDixARQ76QKrDEHqLkrsaqRF4FcZJE+HgoSaM6VZRuM1VrWc+cPTuqrG9jki/20jXsqVPLFB9JirjrJ7ICLmizu6CMqPoSOmx2o3ljzOp2ZWWtVplvW1l/+efYak0tjJ84xvRTETSsZgeSBw5Am/j9GTQbWJ7zIc5fsu3QN6RT2/Ux2h0btyZS78L4kTsewEuNgMFomtgCz8YfUou+lsN46+/ktgP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(2616005)(5660300002)(31696002)(86362001)(2906002)(4326008)(8676002)(6916009)(316002)(66946007)(66476007)(6666004)(6512007)(6506007)(53546011)(52116002)(4744005)(36756003)(8936002)(38100700002)(6486002)(966005)(508600001)(31686004)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U09PSXZONVk3dTdxQi9PYXZuaUN5TVlXaklTcno0QnMyamlTb1RvYXl6U0NH?=
 =?utf-8?B?MThLK1RyNGtmSnZJYlZuRkVHMmIxNi83clVGL21tQ0ZRd1hJcG1Ob3ZUaDEz?=
 =?utf-8?B?bXBWRmtlWW1vNlIrVG9aUnArQU9GelNzd0JxOFNpR21iOG1rSFpKOVBBOXds?=
 =?utf-8?B?QngrTWNjWGxQZ0cxRlBWVEFXMWxsM3QrOTFBeXVmQjNxUzQvalplZzRJckhO?=
 =?utf-8?B?OWdCbTNvY1dPMTFEZUppaUo3aUlCaklKcnprM2NadlUzNHVNdEZDdlEzN3Uy?=
 =?utf-8?B?d2FieDNxVUx2NW9sVThRV3BIK2NPTDVleUtJL0t4RXdEU2oxeGlTeVRxUVh4?=
 =?utf-8?B?SGxpblh3eG83Sy9uNVZaRXBrM3NGYm02UTVUVHdXQkkwd2ZNamNZS05lc2FS?=
 =?utf-8?B?cGxEMjYzWE9PZGUvQUkvaC9Ed3VOWDNITXBvL2ZDbEwvczhpMEhkbW9tTzRS?=
 =?utf-8?B?azIzV2hzOE9BaVZzVkxiR1ZqNXdPK1hrcXl6NVB4TjZ0OThDbytkN3UzTGdp?=
 =?utf-8?B?cDJwWlVlZkxpd1UrM3pDSWNQWE92WVZMa0hKZENEVVZjV1VQRCtGYlh5S3Jp?=
 =?utf-8?B?U2ZrcWRxUjduNVlUckJLdDNGTjdlaFVLL1lWY29tZFNqQ25veTVTVGI5dXhi?=
 =?utf-8?B?K094djd1Szd5Z3R6SndyME5UZ0w3N0NTZ0hCdUNxcFZ4ZTk4TnlNeFRYcHRM?=
 =?utf-8?B?NHNtRUdSMEJJbDNLMlY1K0lhdXRZemhUTStWeFpWQnJMNUcvSFZBeDhaV2c2?=
 =?utf-8?B?WVlUcldDdXJBMFlxeG1wTXptL2t2RFA3U3NvUGZTSDZienFVSG9ad1diTkRG?=
 =?utf-8?B?Q3pNNzY1T3BtdkxQMmd1Q1ZOTXdEckdTU1JKUzNlQjd1dm1ZQXJMSm9YZW16?=
 =?utf-8?B?NXVzd1JuRWhFR0tVQjRnZWtlVWNHZU1YY2Z6Sk53RG9BbEFMTldRZHhtd1Rt?=
 =?utf-8?B?cnBCNldCSnVzY1NCOFh3MUVaa2J1VjZ4eEhMb096TzluZkp6VHEzWmI4bVJ1?=
 =?utf-8?B?MWxRb0lacTBHbU4vcW53bktDdG40V2M1WEtKS3g2RUViQXNlaDY5ejNLLzg1?=
 =?utf-8?B?WUVxekN0Z3h1Y3BVZUZyREpKWkZtM2VhaWJOUCszMlNycHRBWisxckRzTWFH?=
 =?utf-8?B?VzdnRFpaeC9tY0NocU55dGVNYUhxTExKbUx1bkFSb2pSMU5SeDZDTWRDN2lE?=
 =?utf-8?B?VnRCaEduaFdTb2tqQTBzN0dQbFd3Yys4RndGa2diZXJSVk1XQkVIVEE4TURK?=
 =?utf-8?B?elV3N2Fubm5DV05UaTJsSnp3SVpiOFVqaURGTVV1ellZQWdSZjdjNUVBcWhX?=
 =?utf-8?B?aDUrWGo3clJrSFpKU2dFY0NWcWt6MXdZYkYxcHdKZjB4VG10UThsVEhWUkpL?=
 =?utf-8?B?SXdhQzRPTWlXTVd5bklZV1BGQkZNdUxuK1l4N1p2RS9kZCtzekt1eTE4YXNk?=
 =?utf-8?B?b0pKTk9tRTEzTlZLQ0NRVThhTnJBVFZDRWZnZDE5eFhBempiL2QyVzdWOVdS?=
 =?utf-8?B?Zlp0Q2NlSFlWV2h4MjJlVi9QYmhaTDRPcTU2TjRxemNpTjgzMWRFZ2xxWHd4?=
 =?utf-8?B?R085cnNEUWtneDR4OHlyVHI0YWlHWUdRQjZSU053OWEvVkt6ZlJWd1NiRWR6?=
 =?utf-8?B?NWdEOGxKc3YvV1dFQ1B1VkhEQm1HNldWM3hTSjVidXBUTHJvd0RlNWdWL2xR?=
 =?utf-8?B?bnNKOGUvWnYvK2daYkNSdU5BTHBhRW9weU1ORWo3QVRjNGk3UHI5dmZTeUhN?=
 =?utf-8?B?WXVXQWtzd0ZsOEp3dTlCWFV2eHlXdE1LZmZ1Rmt2dXRmd004L3lTQWtOd3d3?=
 =?utf-8?B?d3FGbERxTldpeUd4YktjLzY2eGNHMTI2dW9LZmlTQ21jVHA5em1JS0ZEYVpo?=
 =?utf-8?B?MmJlNStwZGxUa01WSkZaWWlzamtCQk1nZFRIOEN5aW0zbmFiSU9kUE9uZnJY?=
 =?utf-8?B?OXR6TnBMdncxVi9sb05KLzRNM1FGaSs5amZVWmVOUCtsd0tNVVRQSUhTTmFQ?=
 =?utf-8?B?ZVhjZ1BzNW1IL29MZmpqNXlmM2JtbkY3b3BHcmlUUWFjSDQ3aW5nbVBodjJN?=
 =?utf-8?B?enpYY3B2aVk1SUgwNjZLMWJwcVV2dGtGRjFtZUJ6RFJKNzNna1Q5WGdncUZ3?=
 =?utf-8?Q?t3BEer7oiNo1U3MKlY9DTmSaI?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd16590-c1c9-4762-b7f1-08d9fdf912cf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 16:07:25.5641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N6d4JdHP3F11BP8uKzd/rDL4tTFWjI6iFVUCPLuziN8frNpct1FY38BsLHoDidUR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1554
X-Proofpoint-ORIG-GUID: IsHM_Krlf66cr5594AuAmNRF2dFTgpvM
X-Proofpoint-GUID: IsHM_Krlf66cr5594AuAmNRF2dFTgpvM
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_07,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=507
 spamscore=0 phishscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 clxscore=1015 mlxscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040083
X-FB-Internal: deliver
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/3/22 11:04 PM, Yuntao Wang wrote:
> Using strncpy() on NUL-terminated strings is considered deprecated[1].
> Moreover, if the length of 'task->comm' is less than the destination buffer
> size, strncpy() will NUL-pad the destination buffer, which is a needless
> performance penalty.
> 
> Replacing strncpy() with strscpy() fixes all these issues.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
