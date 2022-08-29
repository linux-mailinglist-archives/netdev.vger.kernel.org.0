Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37FB5A4ED8
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 16:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiH2OKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 10:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiH2OKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 10:10:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F2B4F6B6;
        Mon, 29 Aug 2022 07:10:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TDulTu027736;
        Mon, 29 Aug 2022 14:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l/tBgtJyJCZLT12iTT1EGC0oCGlKMDMft4Y/dpweAzs=;
 b=dDFVQLk6MUXotBNjy3y+M4KOGKgiA3MUMJ+C/SZVEadG4jp/PCQU03jzcZlZEAiCXREz
 d8A1Q08x2Nq9GWJdtPu5R8wdYsyExWXaGLWA3WB2NZZYF0DG8bf4LGKKf4vjURL/Bq0r
 xUWiS5yxU/PBxL1lABdRLcHXwJ678FS5WFaAvYncOv50jfsTJHeouS4QyMeV992CIYhi
 uWpGhKAeM6LZ+8e4dIDXkX+ap8JLm4f6PxyoUNa8HOEYk2w9EJcvJAAMi58kXzgZBL20
 C0o09ds0IVg7gNwKC3NOfWlhIIMDVMC/vP6HocgJDAXwtcc8Xa1DzYaxIELE+vyjJBn6 JQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b59ueqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 14:10:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TD18v2019404;
        Mon, 29 Aug 2022 14:10:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2muy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 14:10:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5Vx1d3vsbFUQ6Ae8ZRxaGburl89e0VGGFFtDs0w7zqsAXICCxc7T5S6ME2CB0IUCZ+b3L3zxE36LV+B2cBdL7aAGYC1nUc6BFAWSBra9qbsw14oW1mNlBSN7pu/46MPZ38iZWhGw/ACRXDFiDh+kMV8XKZIDzaJja4f3uNC8dm5RGysusrWezYiT9xjrw6F3bDzizbK8O10fJvbOj25Af6W8uRaThCPfcY4fF/7defUUS2Yo6PGjDaNCzS1PVDkA/+roe1sUBsQlBcGKGZmovfH7IizF+alULVGigk53fqr3cNV1l9VuXpVuTXDDqtiQZTybqCLVI/imV50uEWk4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/tBgtJyJCZLT12iTT1EGC0oCGlKMDMft4Y/dpweAzs=;
 b=Yw/l4DssJmuGjnW802pwHafCNqW9zmdiLnLGXg8xo8oZbALeU68bFZb49ui6LHtN8ry6rm1+pBNC5mDHU0ukp7cYM8WKgdM3n8tOLGhdEgUyTGZuJZpUfyRwOFP/y50kWzh7FTYwakNyICqTFozDU8SfFuHZdXCQRKwvS/xG3cPH+oyVLQv+UIcGml7wbWDn+K+A3c4i0eQzHker7X/sZjjW/8sAz7jGjb99V15EjnLXl0RNZNSz0npDBPeEBalhvRQdTz4xyxoYXReOtlIoEQ28RpdBMdD4EXna+hYJUmzlz5s8WHcJe34YLQn/lkXztRasfSIRhc4Cj4wgUjNwQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/tBgtJyJCZLT12iTT1EGC0oCGlKMDMft4Y/dpweAzs=;
 b=nhf+ppKnYINmgVMNPI1dj8u7oksJvfHwYWChI8d/aVkTkGxQTs9u6L4K7AgII1IX8XD6F9EDkpYVkg7aAqFu1/BkliaOrSs4715P0aoGwhzUsEGfKoFChujMrfjXZmUc7MOgUopG+TH+i6EGraU5G9jyWOJnhyqciPJuipyqLLI=
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by PH7PR10MB5699.namprd10.prod.outlook.com (2603:10b6:510:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Mon, 29 Aug
 2022 14:10:13 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::d0c6:fa96:addf:6112]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::d0c6:fa96:addf:6112%9]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 14:10:13 +0000
Message-ID: <bda042e0-8054-41f3-5df6-c39ad424cde2@oracle.com>
Date:   Mon, 29 Aug 2022 09:10:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH nf] netfilter: ebtables: reject blobs that don't provide
 all entry points
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller@googlegroups.com,
        george.kennedy@oracle.com, vegard.nossum@oracle.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
 <20220820173555.131326-1-fw@strlen.de>
 <93eca5ab-46ee-241a-b01c-a6131b28ba29@oracle.com>
 <20220829140320.GB27814@breakpoint.cc>
From:   john.p.donnelly@oracle.com
In-Reply-To: <20220829140320.GB27814@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:a03:114::24) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ac7ea77-88db-4ca7-ea09-08da89c8310a
X-MS-TrafficTypeDiagnostic: PH7PR10MB5699:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMlUB2cNBVdzqIpt1R075giVv2Wq7/PNtHW9ytRiU07xJD7raLMvJkB1JWmrS7TW9Revp1fBgVNaTD/jqaY8cOsFwfjiMJe9cz9kxKQNyYKNcCv0NgDeYIMPhVptmDBlJvOirUJT+fFbV4QfFfG55QxWynJRfjMw+Y9xumECnWmTtLRuR8FXfwBFuT6zYe/js/2WTuNjrKFa86VHUnuw15D2wO77B5e+I0RH/S11twP2zie+0geS1lH1Kred01EQe49q+VlNP9q6Y2bjFTpCzXpLQNrP9HhJlkbKQrxzmM9OXRcVrRvsV6QrCeovSN8RhPmTPeJaPPudYgP7Rof7lej7WC53IpolqKbvV35YxTRW3WPfksH1O4kZXESx9i/FzcDOlP4oap5j8Wmd8xKao/WwKuuGecPcbTLJt1NKxWhJU3QfVlbRQe1xHZrwhF2q8txByqGynMJMWGdByb3Q9Y/lQZAOEMmTYwf+j+rhLvJtwQRYZkBrUp/yaKzVEN2J4nrcWfgXVI4wXOYeJBfj26JKUf8pQRjTZzSRvwuMNUVYaFGT/vg3C5jRxV2hc0PpIqV5QWGvvyRSiOMmvDBRV7w48mfLUkZZW81PndLioBq0h8ONuPkCPgvLhQcI6DkeFdwsS1apx210hvv7O/DsKa6EjPqAtBejwso+SezNSSoYwFFVCDwtJ9hTJT2244yENi8XMlpsznUQsvhxGTLZxnPYtoP+OZMQPsKQ3kaR3uVmc1LgcfKOLYPQ/Dqu+GIJ45D2zkEgD9x4N5Ck+SwHaSf+9UUwP4xCOv3MTAyYoCE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(366004)(136003)(376002)(396003)(6916009)(2616005)(31686004)(316002)(36756003)(38100700002)(186003)(86362001)(31696002)(66476007)(2906002)(53546011)(66946007)(8676002)(4326008)(66556008)(6486002)(966005)(107886003)(478600001)(9686003)(6506007)(6512007)(41300700001)(26005)(8936002)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3pkanNaaHN0VzlNUDF1ZGtDZytlcVpOcGxmVG1ob2kydHNrR2ZIMFo1bkly?=
 =?utf-8?B?eURNM1B4ZDE3L2NpWnFTbDhkUjh6ak0zUjJySG92QjV1TzhwajJhR3ArU0Nm?=
 =?utf-8?B?NWNaNTY3dS9TWmZMSFJOUGlpT3BhK0dzYWZnbmFuSTNwT1FJV2w5UE5TSmI4?=
 =?utf-8?B?cFNkLzhNZW5HdlFlbXdnYlM5MC9YN01RZXJ5NXd1dGc2VTQvYjR3eEdOTlBB?=
 =?utf-8?B?UG5PRFd0L013M1VVa3ZBY3FSSkZ3OXpEREFCY3JzeW41TVZQVzdLUTI5bnlW?=
 =?utf-8?B?NzlrUk5NWFBnb2hmTW0xSHJqSXFGRmtFMnJoN0RtRTZTRlJKZ2dDRVo2ai95?=
 =?utf-8?B?RWtENkJHblRtK1RzQVR1VzNYMEhqVWwwRkRoMXRFeGgwUGxzOUpJQzQ2SDF4?=
 =?utf-8?B?Wktuc0JCT0NyNjgxRnVYWDBVaG42b3VHR0JYMmtwcytkR29ucTlRM1NDdHN3?=
 =?utf-8?B?UW9GYy91UFRnQ1VNRVFJVHNFc0tUbFNoWEc4VFYxM0VCT1JvOGZlUXFNeXJi?=
 =?utf-8?B?ZlFVMkdUNllQV2xqZG1hRENGWTJIR2huL3JJRFdaMUUzT0ZyYnVHdU9iU0lM?=
 =?utf-8?B?Y21DOFRwL1h2RWd1d0crREs4VFBZUW1NdGJlbk0yNEVsSkVBMUl0bUhTUWp2?=
 =?utf-8?B?T3VRLzV4SmN2MTR0WWtObEM3UVVDT2xnSEFFckpjSlpJTHhqN2tRdGltY2o0?=
 =?utf-8?B?bFAzTWZudisxYkEyQVBhdDlzajNPanJ5TUpySEtoczcxdG92eXJ2dUtZRkFl?=
 =?utf-8?B?NFVScnJTcTdXbU9mOHBqaXlVcU9GKzVBckwwUVBxT1ZvQmpaODQzaitDT1RS?=
 =?utf-8?B?SmNNVXRiUldEQzRSNFJWSjhacmdHZ0d3UzF2c0JUaE9ZeForR3doZEM4bjhv?=
 =?utf-8?B?NGdsVVY4M1lNaktRc2IwMFBWUndSb2FuSnBsZVdmUlRJaVhFdUZaMDlHM3Br?=
 =?utf-8?B?QnkxcG5ydlBReHlJNUxFSDh6dW9zSlBLR0VsZ3B2b0RPTjIyR21aQzdwSyto?=
 =?utf-8?B?aDJ1dXNkTmFGZ1JEN21jVVJ3OXZMalVyUjZ3Ly9LdmZ0UnhIT2NjTEk5RVM2?=
 =?utf-8?B?WnRkeGZOZzMzNjNGWXdtNDR5Vkt2ZSttMzhsQ3VLV0xQMG0rUE1MSEo2Y3Nq?=
 =?utf-8?B?ektNUmxOc05KcytXNlliMkNEbFVjQlEzNjlESXdoZG0wZk8yRkJqOG56Zy9B?=
 =?utf-8?B?dVFDYXZLOUdvQmszWGlYYjZIQjRBYjhyRkprMllIQmZESGtyK1ZSdlFNa3c0?=
 =?utf-8?B?UzJBWXVUTWVQM0ttZy9qU3FrbTJVckM1M210dzZaNVJnOGlIOW8yMnZIZktU?=
 =?utf-8?B?N0ZFYXpqMmxDTUJjbDhzamIxc0poQ2NhN0tlUjZva3dMRHUyWS9vTE91ZWQr?=
 =?utf-8?B?M2Q1c24yeHAySUp3RHN0ZE9lNWpQeHg1bVJGTHhvQlBxL2dBaFhzM05yczVB?=
 =?utf-8?B?MG4rMU8ybEViRStUS0ZOb2tUWGl5WUNWU01POHhyRkMxNWZzRk10cmE5c28x?=
 =?utf-8?B?ZW5LL0JKVEJ6S01LdVFTcTdrWG9iczFwV1RYa0Y3dHlyQWRCUUkzL29OYjRt?=
 =?utf-8?B?NUpnUWJtQktGb1RONndiZWZlYVNNOUFWb1pXMFhmV1BKZ0s3LytieGZUY2JL?=
 =?utf-8?B?eUtNclA4eC9nak5aS1BpMzkwZjhaT2M3YmpEbUxwNHVIOGM3cXBNSGUyMkZT?=
 =?utf-8?B?aDh2UjZpTmtxWTJqSEI3c25Ob0Y2NkFOY1haeGRvM3BZc01lU2dhZ1lIVE96?=
 =?utf-8?B?U1FpbFhUOGpzSjhGWDF6dmlBeUh0VkJQMGNMdVRhK2NHWkR6c09wZU1SRUlK?=
 =?utf-8?B?ekt4TzNWMDdPUUVyNGVSTmIzaW1qaGt4TWNzOGNQOWZDZzNRUjZ6TUVkTDZ3?=
 =?utf-8?B?K01sWDcyc0JkZDA1K25VSHBQUUxNR0JvRzZDTXRqSlRCREk3UEVGbjJsekw2?=
 =?utf-8?B?azZtSnZNNWJSOWtIRUJEbXFUdjgzcmk4czdpSTdQbHdUd3J3QTFPQjRscWVq?=
 =?utf-8?B?YjJNNlVvczNwcmRIODRjdlp0RWNUNUVWSTkrNDFNcEo4eHc3OWdLUmllVUc5?=
 =?utf-8?B?WWVvd0F1cUFzaXFwdW1LZm50MGJnVFUrRnNrVHlTN3o1Z2ZtUHBNclRyemJL?=
 =?utf-8?B?dFpGSDBLYStCQklFL1g4MzM1dHE4RGUxSnVDcVNRblhxdEFwV3VsOFVYemxj?=
 =?utf-8?B?cHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ac7ea77-88db-4ca7-ea09-08da89c8310a
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 14:10:13.7172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LUVIZOrjOqFQWvKq9OYr4g0F5RTpxTH0Yllg/bIgx7lLYYI7XVsxyISN+psR0bDbRgFUlXLTxbbpXiaFoS1/r8SEVtVeBNif6kRE/WX/2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5699
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290065
X-Proofpoint-ORIG-GUID: xFN1EZlbrFU_96ibnkeX0WHAarfRvwN8
X-Proofpoint-GUID: xFN1EZlbrFU_96ibnkeX0WHAarfRvwN8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/22 9:03 AM, Florian Westphal wrote:
> john.p.donnelly@oracle.com <john.p.donnelly@oracle.com> wrote:
>> On 8/20/22 12:35 PM, Florian Westphal wrote:
>>> For some reason ebtables reject blobs that provide entry points that are
>>> not supported by the table.
>>>
>>> What it should instead reject is the opposite, i.e. rulesets that
>>> DO NOT provide an entry point that is supported by the table.
>>>
>>> t->valid_hooks is the bitmask of hooks (input, forward ...) that will
>>> see packets.  So, providing an entry point that is not support is
>>> harmless (never called/used), but the reverse is NOT, this will cause
>>> crash because the ebtables traverser doesn't expect a NULL blob for
>>> a location its receiving packets for.
>>>
>>> Instead of fixing all the individual checks, do what iptables is doing and
>>> reject all blobs that doesn't provide the expected hooks.
>>>
>>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>>> Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>
>> Hi,
>>
>>   Could you please add the panic stack mentioned above  and syzkaller
>> reproducer ID to the commit text ?
> 
> I did not see a reproducer ID.  What ended up in the tree is this:
> 
> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7997eff82828304b780dc0a39707e1946d6f1ebf__;!!ACWV5N9M2RV99hQ!JxonjgQUi7Mbcd-ouxRwPgu8Jwl6ej2rO4pTvYMtteWexclV5-hciu9e5rgtkXoB7dyAdLCyZ4EQ9HQj$

Thank you !


