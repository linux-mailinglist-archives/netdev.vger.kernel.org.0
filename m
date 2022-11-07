Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709C561FBF6
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiKGRv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiKGRvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:51:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506092409F;
        Mon,  7 Nov 2022 09:51:52 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7HNihl005784;
        Mon, 7 Nov 2022 17:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8h2YxXVtqDdpsHmpG6Ik6Oph0SBnmjTgxQtsGstZ1Os=;
 b=BlPTqIUqqOJNfliP0CFM7pZL4Vy3Rsz1RSB2ukRjl/bGlhRcd6XCOmUo3918k+MJFic5
 Ag48x3fCF8wC7r1dFAdziZWdwjHvNFfq4r6B3VUouCxe7g9qmHRaXORBU/+PHEX9RaHN
 8YkzXSX0vVOCZ8p9VXQ1+l+4RarU6yOX/g18MbXdkKmKhQC6G08b/wRfLYsCUFYIY3hk
 WYss2JjpoyCTuPiUZglgtWEtXxx1QGyTP7GnEV5puQmhBsDTiPe2z9yojzy0tslWjxJ1
 aynYmNYQSP62r6BapoYTe/mEj5hAyPmVerxSAPqaHmVMPB2gN9Tc3FY7YjkD12e0i7pR DQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw4puj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 17:51:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7GVZf3025613;
        Mon, 7 Nov 2022 17:51:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqf354h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 17:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbFNZPBMrZuQtKQmm6LV4lo7KpRJr1kA8GJSJ7dao5E5sava2/UgwInuFYJfKgAcK4FCmLfw+pDyqkez0jbIs34gPK+Vb0caAqmsxcvtxzic9ReBzF/ZOHEAlykMAdjM7Vxowcj85pelERGgoUeVM8e1+cpMw2ArwYMyFiSMQfRf73fnqngn9WLDvSdUbuGNBoqbj0mRnE+A5LRKrKH/vLr/v7psseYbhEWKSEnIzAFwO5lssUc/YgaKsaMFi0/bp2XGUfldqF2S4CJ7F/JxNYlVNUBI8GYYYwQSqF3sgNSt22TQuhyVhqUKUWxPHyYdga4S4fc5Fvn25LNa3Bm2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8h2YxXVtqDdpsHmpG6Ik6Oph0SBnmjTgxQtsGstZ1Os=;
 b=npsgzo4Y09V+UzcmqisUJUMTmu+eeX2m1cgTXvYobPBpQ7py8cdvUpBFjRPyQ0mSGbPM/qFuAwCPGIsSi8DKTHphXsQjVx2ldWGGE1XnRw0siE0cEB/AH11b4IxdR8Bt5kVmjdL4/SWn8u+wH7atuc92BBhkYpbtFNez7KwOOzzzuvrQjz+hfa8p9NasweTt4n1VW7GwVzxJ9/ddd2/FDitsl+C9t1QDN3yET1A3bGzGvLPeANjaWusf9IQ9xviG2N3I0mZ9Ggf/aRTHGl4SbwR8mnHHMU2asbN75E8nFmIxOoD0xBvYL+Z8eOrQbnA38Cn/LCUBCZhx3GC8TCRjoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8h2YxXVtqDdpsHmpG6Ik6Oph0SBnmjTgxQtsGstZ1Os=;
 b=MziOw52frgZ+o2DQXNSTwFjdLEzIrONSBtDy5vdEfxkW1WRJSyQWFpSGJrPZaY2RFdy6S8Pd2m/7VnpYq1gyrzohtXQxb2v+lm1K0Lbik2/CZ3dnUPls5bsYNJVWU9Y9cFYJBFvrZr5208rfzvwyUzAFDJwFMREA0R2MoPrKrHc=
Received: from BYAPR10MB2997.namprd10.prod.outlook.com (2603:10b6:a03:90::16)
 by PH7PR10MB7009.namprd10.prod.outlook.com (2603:10b6:510:270::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 17:51:38 +0000
Received: from BYAPR10MB2997.namprd10.prod.outlook.com
 ([fe80::fee8:36cd:5e78:f1a1]) by BYAPR10MB2997.namprd10.prod.outlook.com
 ([fe80::fee8:36cd:5e78:f1a1%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 17:51:38 +0000
Message-ID: <50c82e0d-15a9-7b71-0bb1-85d87b4985c1@oracle.com>
Date:   Mon, 7 Nov 2022 09:51:36 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [External] : Re: [PATCH 1/1] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, manjunath.b.patil@oracle.com,
        rama.nichanamatlu@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
References: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
 <Y0UYml07lb1I38MQ@unreal> <5bab650a-3c0b-cfd2-d6a7-2e39c8474514@oracle.com>
 <Y1p4OEIWNObQCDoG@unreal> <fdb9f874-1998-5270-4360-61c74c34294d@oracle.com>
 <Y2f21JKWkQg8KtyK@unreal>
From:   Rohit Nair <rohit.sajan.kumar@oracle.com>
In-Reply-To: <Y2f21JKWkQg8KtyK@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::7) To BYAPR10MB2997.namprd10.prod.outlook.com
 (2603:10b6:a03:90::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2997:EE_|PH7PR10MB7009:EE_
X-MS-Office365-Filtering-Correlation-Id: 626be8e1-cd34-4008-20aa-08dac0e8b819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xd7Wr7n0ykRSTV0/Gx7rRv3qjAFcg99uTOocEvE5Vh6HjPXC7GnsJ2d9eWeL4S9XCh+1hE3oZ8orO8YYVUJYAh3Z6kPV9YkXncW4eUhGs6fh/yyVvdfqynHZM43iN/4+2t0wR6EZ5jU+2FtnagszAFJrGqC5owNgboELkgS8iZf3dmtN4+8HDyNl/w1yz6qEtuki9pdMF+5/rJF3aexLFQMWyVHpufVR9XTKIkuW9WMq2ysdwT4M1Br3cIsvrKnu+7NyANSeo5a7Z1liip80RE4w4nzOWjwWUAeSJspFmPQLUgT4NTVGiq/1IogxgZvWIy+rGyDtt50i0JcYGfjkjWTVZY+v65NX0xMutT03xsZzD1G3dEBs+S4QULB0wq0JdPuDSdDC43ZPWYDbWA0+gZdRHtouvHD6VNe+obacmDl682CU0hFd7BxuZpEwn9OcPz8eV6jGTpAqbQuAzR+7mcEPIlqvVP44DE++4JyrJO/O34S5OH9sp7hvy6gaIdSnSV2UM774UqBOG3T466annjjdiyiiWWQLzwU95Jh5kSHCAJpupZFYQwVBz7uf+mVtpPPLm+4Wgoob0jkeDTbC7PaJlutbEZkSt7SmPaAoLPmU5x0R2zyxmbOv4wK51hCGLEThqiJK5YbAp7yD1HAigH+FdYfbrcXLFY4PjatGediSvYag1c1oUvq/vMARCBfMCwAhmbhxcKR/YMPDd7dU6VHLDSlZhyIegeKlLfIjcy6gw+O508/Mr5j35BlN2LaNcQKgmVHbZiszOLlNSnmFWlURs5yyqwdj8Fo169YGaaE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2997.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199015)(41300700001)(31686004)(4326008)(8676002)(8936002)(5660300002)(7416002)(6916009)(6512007)(316002)(6506007)(478600001)(53546011)(38100700002)(36756003)(186003)(2906002)(2616005)(6486002)(66556008)(66476007)(66946007)(86362001)(83380400001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmF6TnYvUWYva1YwNHZaaUlIVWFNdkdad254a2xVakdhdjJCREdXYnMzODFZ?=
 =?utf-8?B?dXRTRnNibnl5aHVSKzRsYjI1ZjN4QXJvZGwvMnF1TTNnUGQxRDlCOTFOVDlr?=
 =?utf-8?B?ZE5xME42aHVRR2JVMU51OVpLTUJPYjBzVi93bHZIeDZnQjFnTzFGakNxNDdJ?=
 =?utf-8?B?TmdLN0hyV0JiY3lmbHJLM3FkbUpiRXpRSGNiNUlienR4TFNtcXl2NjVLZXUx?=
 =?utf-8?B?SXpJV25OUmc2N2c3V2dxbTBQU0VzYkZpWXlMd2ZxZFBqcjlOMHR4aVdZRm5V?=
 =?utf-8?B?RENyTTdwalhvc1JaTzIzRWV1aFVldVdRV0h4YXR2dVpTTHZ6Sk5HWFJRWTRM?=
 =?utf-8?B?V3Y5K0ZNYWRkNkV0d3JwWWQ0dXJCcU9VVHNZb1dCS21INTdmVjQ3NW1rSTZO?=
 =?utf-8?B?NDBRanZPeVBlVHZYaXVROGJoSlBaamd3OWdJNmd2YXQ3M1lXYWVobFI4aGpB?=
 =?utf-8?B?ZnRIeXFQdWRHYUFkNXR6eWZ5K1dxV1hmR0x1dWI0b2VHdW5BS0VTUndhU1Fq?=
 =?utf-8?B?VW5wdGIybUZRbDdUQ0RjdFRjK3FoOUVNMmpaZzVkRWNCUC8rcGRTajhSWFg3?=
 =?utf-8?B?Mk5MRlQ2N0RlbWs4MlJBcWxPbEc5RElCZ3dWQ01uWjdxeVp5bFRXZkMrTXRp?=
 =?utf-8?B?WmpWTGY2M01wdTlHZ3YzeERxOXVFaFd3eDg4WkRxd0Izci9QT2VnZjZzSW12?=
 =?utf-8?B?T25rTWVjRHpYTmN5TTQwQmVEemdZZC9wOWJDVGVSekVsREhCZy9iUjNlMkN2?=
 =?utf-8?B?ZE5ySjI4dVl4MTI4VCtjMWVCRW5iZWRsQkhjeGJjUm85b0lBSWNhcFNyQjJM?=
 =?utf-8?B?bU52Q0ltc1BWeTExQmZXYTc1QUdoMTl3MUw0cXJWYkhLN3Z2TXNBZlM0Ymwv?=
 =?utf-8?B?QWYrcnMxbC9tMTkyWlFaVGFQYnBiTFBsMGMyNnpKTGlXdVdacWduRzJ2ZG8w?=
 =?utf-8?B?WkNQTkRVUGlVd1h6c25NVEd1VjQrMGFmcjQwd1Bua0J2MERiQTJ2TGJvNnJT?=
 =?utf-8?B?RDJqR1hwVTZlR3AzdW1OTm5Cdm0vYW5NR011cmRRSjd4eEtWM1c1VmQ5amI5?=
 =?utf-8?B?WE5wSXFhb3VlMVFlQVBCL0MwZTlUYURNOVgvUFp3WXNlL3VjRTdPTGN2WVc3?=
 =?utf-8?B?SlpzemFrTzBsbk5KREd2ZUU4VDNlaVB2UXVJa0wxSU1ncWtqbXhsbDYxSWlu?=
 =?utf-8?B?d0oyaUMrWnQxZlJpYVdMdHB2MEJzWlFWN1pHVWxuaE9IYldRMC9qeUZ2eWRM?=
 =?utf-8?B?ZzdRVStGRVJKMTRrM0Fkc2U1N2liZWgyTVN0cm9mRERBSUVlV1MyNkZLVWNk?=
 =?utf-8?B?RW5SSkxOb0tVWTZrdS9SQ2FtejNpMjBFaGUrUTROWW0zSUwrM0RJaWgyekhF?=
 =?utf-8?B?aU1OVG5yWGw1M2JHSkFrRHZsTjY3YlhoaDNZOE9pODVhdm9RWXNRSHZpa1pG?=
 =?utf-8?B?ZlpHUFhGNHFRazMyZnozVW5rRURBWWNOTndwSmtoRmdTN0szZlFvRC8yL3dq?=
 =?utf-8?B?ZnVNR3RsZi8raEVFUis3QmV2N1hieHFBMWlGc2JBWHJqUlI2UEJLd3IvYzhn?=
 =?utf-8?B?MUs2c3JNVjQveUhjQTdUODNzM00wV1lhZEtqUTFEcU5Wb2trOGdUQlJlYis0?=
 =?utf-8?B?WG42ZWg4STVEaENOc1N0cnFqWEhRaGRSMkJwM1FGQVR2UkJDSGs3UzVDODFw?=
 =?utf-8?B?MS9wRmhUQnZBdU1BeVBBWXF5WFliNjU2ZmtGYlJ4RFROY2E3Z3BPcjFINGpQ?=
 =?utf-8?B?VnNaaDhrVGxCS0xoam9WeXc3TTh5R3V5cXl2WkVHTk9GeEZXdW1WYkN2VVNv?=
 =?utf-8?B?bDZRMHJ2YUQ2V0FOZzJFQjB2dXd1ZUZxdXFXdDNXWXlhM2ZnTmZBU0JTYU5l?=
 =?utf-8?B?OHNTVDV1aGE1Mm83U3BsK1ZzaGRpL3A3QmNRczUxenZ2NW8xdDJ5aE5ob2VJ?=
 =?utf-8?B?M29IUjh1eitIc3lnNVgxZE1HQ2xzZFFFYzUzcmh3VndSK2FvRkdZUXlUa2lQ?=
 =?utf-8?B?QUFDSTZmdW5QVUZLTGFyMkkvV2FjUys4WUFIVVRwc0tPZ1FCaW4xQWwxeU56?=
 =?utf-8?B?eWd4d1p5cGdjdVpMa3NWVkJ6WGp1RDNkTVRIUk8rQTZYTjBBcXNqazhrMjEw?=
 =?utf-8?B?WHdNZUlmYnkyaElab3Zac3RSSzY3S0FSQWpSRFBPYkprVzc3TGNzakZ3MFV6?=
 =?utf-8?Q?AwJshtAB60FTrs36PCCC2MnliwdkofpqizWkmJhL5JRP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 626be8e1-cd34-4008-20aa-08dac0e8b819
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2997.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 17:51:38.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k53faWj1EabWDoGjuYZoiYRMurrD5JzUxUaGa+im6qDrZHas92Y5Ka/WfbXo4g83W67eJK5wc9aA6Mez87M6kp+UZTD+ZV4QucWGWwon/K8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070142
X-Proofpoint-GUID: 1Bs4Mx31PjtMS7awwgTQmXLMnz3ARsjM
X-Proofpoint-ORIG-GUID: 1Bs4Mx31PjtMS7awwgTQmXLMnz3ARsjM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/22 10:03 AM, Leon Romanovsky wrote:
>>
>> rds-stress exercises the codepath we are modifying here. rds-stress didn't
>> show much of performance degrade when we ran internally. We also requested
>> our DB team for performance regression testing and this change passed their
>> test suite. This motivated us to submit this to upstream.
>>
>> If there is any other test that is better suited for this change, I am
>> willing to test it. Please let me know if you have something in mind. We can
>> revisit this patch after such a test may be.
>>
>> I agree that, this was a rare debug scenario, but it took lot more than
>> needed to narrow down[engaged vendor on live sessions]. We are adding this
>> in the hope to finding the cause at the earliest or at least point us which
>> direction to look at. We also requested the vendor[mlx] to include some
>> diagnostics[HW counter], which can help us narrow it faster next time. This
>> is our attempt to add kernel side of diagnostics.
> 
> The thing is that "vendor" failed to explain internally if this debug
> code is useful. Like I said, extremely rare debug code shouldn't be part
> of main data path.
> 
> Thanks
>

I understand.
Thank you for taking the time to review this patch.


Best,
Rohit.
