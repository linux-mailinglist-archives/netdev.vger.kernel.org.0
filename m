Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1AA4ADE83
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383472AbiBHQoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232725AbiBHQoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:44:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3091C061576;
        Tue,  8 Feb 2022 08:44:03 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218EHNcQ026741;
        Tue, 8 Feb 2022 16:42:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Iz/B7y2WF54ZNHbEORWqPxMcrX1bsIGFBYPAitr/Vr4=;
 b=BaaqlBQpf4vF7dhvtVjkTk/1HVQw5BfT4JWof/u6hg4VgPssrdYeqpCAyFqOu6IcKzJQ
 3hikjPVy89P8YdfuayW9eyd5t0Vdc1ES1/K6pELg6GYtAds7SNH3H1xMJYraC6xISBKN
 9WlJ2/XfotAZTtwVlZViOCAViPjG9G7bIUVJ92zAUcUzhUufDamZQMISOOmkGIS1lKpw
 qaZkOruB2toiiTo7C6AjUAjtpMCeI0D+3qVyok6eHcmwRvQ7LH+Mo9B9uRCqP0Zcjrq6
 57ech3XxCx0uulPhEVSoJhnWsc+PLgzhgxv48XRa2Eb1dUkPUsVKgZ3JdFU0cJumDyVE oQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28hu2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 16:42:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218GW62H099370;
        Tue, 8 Feb 2022 16:42:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3030.oracle.com with ESMTP id 3e1ec0n4b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 16:42:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j58c7IatNGvigBCpP6/FCZWONl9p7Xl66O1KD4nNW0OCy+9URe0uIc9sZSObtwBs2VVDEv3xeMlBkK9BEMcdx0XWuav4RVvyH6/cmx2xNt0gN7ygykgfITWDcQjw4smcU+4SJ69V67EZrUIPHEAgPjeYRqzo4czd04TRrFXs9e3EDG/cOxZNgkof8XJmXvIfQ7V7dRMbyifDTQwgTh2V92JVd+T/yk32CuEhNYTI/g0zAzS+/rWwnYlLVdjilYlYT4A2rdvdNJ5036LWURHz3mugoUvIn8IT1P//idi1sBWkUjqZGb4S0o16SejFYAmYLkph1XPEdYdQ2bJDcYbr8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iz/B7y2WF54ZNHbEORWqPxMcrX1bsIGFBYPAitr/Vr4=;
 b=irTzrvtAxsq4vq9B+KAbCQqLSHukl/lq0gdHROly40CcOBeJfLuI4Zsd9yhpeqIvnt+wfcat/ZVlkBm4yoBi+K98QZB8hRcgJPpxDXoWWDjyEc767Za9O+s5cH7nUEtlCeEZozZD59iPyhfxFyGlDGYLzcWwCU1aShQAUJb84yrsdyJrx+dophW6PXFQcyyQuKKTALRXaXDQnPiMQzu96FA4DDbQ0RDQ6eyjwKGVX6xpcdDNRwDuwoLPldNisXoob6L9YnnTCOfmv6wKNMlqeQuTQD8UAba9UpvMGvOeGgEQ0FLNQOmD+odqO3r8jW5PUky2fsSl9FHC0fDmk1GrlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iz/B7y2WF54ZNHbEORWqPxMcrX1bsIGFBYPAitr/Vr4=;
 b=efh1Wst/zbd1TEFwWAUWDKb/iIAsb6+L0HQL9akgrhT61ahmUhlFk296HeWn7KlslWdZxfYSCZ6ggVB/6hUtOz33+TC6+OZFCrYRxRZlSujIndAJ1d0bYx9PFBO6lDxJaptVe9z9dFH/4Zo2kzzJKmWg7s3pzSuw3H65osWtPgE=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BY5PR10MB3954.namprd10.prod.outlook.com (2603:10b6:a03:1ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 16:42:46 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 16:42:46 +0000
Subject: Re: [PATCH 1/2] net: tap: track dropped skb via kfree_skb_reason()
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Joao Martins <joao.m.martins@oracle.com>, joe.jin@oracle.com,
        David Ahern <dsahern@gmail.com>
References: <20220208035510.1200-1-dongli.zhang@oracle.com>
 <20220208035510.1200-2-dongli.zhang@oracle.com>
 <CANn89i++X+QBtm=L19PBbGLUJb8ZiTib4AABL_WL+cUfgwVfOA@mail.gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <a0223152-38bd-6efa-99c8-699a21ca04cd@oracle.com>
Date:   Tue, 8 Feb 2022 08:42:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <CANn89i++X+QBtm=L19PBbGLUJb8ZiTib4AABL_WL+cUfgwVfOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0141.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::26) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2152c19-dad6-462d-67bc-08d9eb2208f8
X-MS-TrafficTypeDiagnostic: BY5PR10MB3954:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB39540C096082DD97CEAA55CEF02D9@BY5PR10MB3954.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3SQvA4KSbmLvlP/VKI7ujUZcwt7OmMEV5mucPDgVvGNjtQDWG+Rb29CBRJg/Irfnwr49GXMoTMPhCc7k54rZ52N80ea9MsItuYsDRVmD9Q56Ogn6CauU+v/qLALZpXxKjpFPsNDBjM9ZhGRyTfrvyEFDTEjJsJRIoJ5J4/VFi96cGiQNjUGSIgPiwLiyOp+362eL/rQat6vhpodRp33dx5c5yoJWJmKdHOiY1zZQBqeGfLn8wS6EgpZvP8kz1/mnFkR1fKZLpEcMpf3KexwVNLiDZJ768ZSVylSyUkSGbO0SGjfVSmgQFgtT3D52aASaIzkFI9gVl9QcbMeEcuQLwbGd4XL8NwRf8FkszR3DK/JN8u+i6kO/1/s76fWZsYV1FZ1ODVkjzO2y/kj+6Gz+qieZ56hitK/fcOMa2Tt+uryQOdR5v14/JccnCuXyGGN7Ri5W5ohXJ9378gBoUSGcnSXVTBEbNVxGEcl4SmgA2BqeFmK6+mLTKzYpS5IRZcmBdtmjtQMMPspOlfSrNPtif3uOpMI4ad48IUgKKr2VGoJ6rwEK251tD96/rQeoXgU8LWbufFodCRXBwtMPtYr165kxQ/M9ZXME8RQ112dPOc3S20uLEsQCDm3cHiknLH0iQMgS3dIzXNIx+esSvrwsxJLafbybGq3vM/YGjOX6ehQ00bgtB0FTXb/tnC/dXN7U653x4QDIRLBSROfREchSF9gfCXfMdLjcaeWIMtLp94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(54906003)(6916009)(8676002)(36756003)(508600001)(38100700002)(6486002)(6506007)(2906002)(31696002)(53546011)(66946007)(83380400001)(31686004)(66556008)(4326008)(8936002)(5660300002)(2616005)(86362001)(66476007)(186003)(7416002)(6512007)(6666004)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUhzUmhrN1U2Rk9jcStNaGh1VzhaLzc2R3JlZlJEMXQ5Z1VmSW84STdyb0FU?=
 =?utf-8?B?MWh0a05pRVdBeVpHQVQ5SmUxeGFQbXpzV1RxaEs4MVVKSlZQRDdTREluRFJs?=
 =?utf-8?B?YThHWXFZU3B0SW01U2FLMjRtaVMxb211VUdVVGlOL1hycUZ1cUx2RFYrcmcy?=
 =?utf-8?B?REkrK011d1hzdVhYZTFaS2NrcjJaRndtUm5zL0NEWUp5dDVUMWI4aGdyWEJ6?=
 =?utf-8?B?YzQ3RGc4UjFiUEd2MHR0OVh0bk5rd1NhSW5UWnBOb0phZklKc0FNdElEUlVu?=
 =?utf-8?B?Yk56cmZaZGMwSjdiYlhxUUJLUWJuSHAxaDNqTXU4Sk9tYkdLZmFLeVBOM1RN?=
 =?utf-8?B?R1dMRDcyMXBqbVBvaEkwWElIVXhIQWtNTjdDa2tsWU1QaVQ2RklrTXZHTUR1?=
 =?utf-8?B?YUZkaTlPSjBzYXFLenVuOEo3TmNJeXZKdkR1K1ZNZGZZMTdmcVFqMUhqNW81?=
 =?utf-8?B?UW14TUZydTRZUlRjZ3JHRWZOVkNSbkJZMFIyc1Z6bHVtVUIwemdRdW94Z3pN?=
 =?utf-8?B?d0ZKYmI0ZUlBK0lyY2xqREtpSlM2L0lpbU1kc2dFVm9pRkF1ai9KYzN5dE5U?=
 =?utf-8?B?K05YRHp0Uk9YS3ZPSGZ3bUNYRlFRSE1GZXExYWo3MXJId3JBUFhSK01DT2hH?=
 =?utf-8?B?U1VJV25GVUUya2xNSGtyQlhtMEpuVnBDWk5XT3FacEttZ2JKaXc0OWVlMFRX?=
 =?utf-8?B?OXJPdExzRDF2aWNGazBaRHNtSmUvbWdMMHZaWTJwSUtvOHdwRVNQeTl0RkNn?=
 =?utf-8?B?a3hWQjZybkxmWTdFUVQ3Ymx6eHQ1VjN2L3BObHVkQXJkOGpQMko2S045R05G?=
 =?utf-8?B?TFloQ1R4dXZlKzVuU003SzdyeUROeldwZTZlbWlldkJtTzRMTVhuaDIzbFN4?=
 =?utf-8?B?R0xOUGhuMkg0dlpaOUQ0eEUreVJjVXF2YTdrdnUyS0hSMlprdWZtTzg0Vzdk?=
 =?utf-8?B?MDNaQ3hlSE1kTmkvRkR4Rjk0WlVlbDRJeEI3MjlscWtHcStERTVKMnZqQzd4?=
 =?utf-8?B?S1U2SU5HVGNsWk1zdTZ4QTdzQ0VrU3pZekcvZUtRdTRSU0Y4RVhnS00vdURJ?=
 =?utf-8?B?VG9qTTUrSm14VVprYzYyZTZjVVB5dXR3T1U2ZzdFemVOMURTNnQ2a3lJZEFh?=
 =?utf-8?B?YVB4TE5zdVNMLzVOZTdhd3lveWtIZ3ZUOTV3ZVVNOVVzeHdvNUhObjFhSGRB?=
 =?utf-8?B?NEk3SEJvTU5abWRwMXR1QXBTNkNBVm1RUktUeHBUK0MxYXNOU3l2SFNnOUpy?=
 =?utf-8?B?TkdzeVNzdXF6L0dVZXNQbUZqV200dHlkU1NTUlc3ZWhYNFI0ektGdU1WRDdE?=
 =?utf-8?B?ZTcvLzVZVmtNaW9hYzV2OXZHTmpRMytkYzI2N2pqeTRYY00zS09FOXFKMm1G?=
 =?utf-8?B?ZC9oWWIwRHNpMnM4VGFPYnRFUyt3YmowOElIbjRJTUdHMlRiRFIxSnE1TjNV?=
 =?utf-8?B?Q0JJYTUyT3JuNVIyK084WTNXVWQ4b2tCaGZoaHMxM0N5RFRFaXEzSHIxNk16?=
 =?utf-8?B?dHV2QnBRTE4xYmVmNGR6T3lGVGNzZ1RqUzVBMGZ5eFZCakVsSjVoWHNyUmdr?=
 =?utf-8?B?NGJWTlhid29oa1JhZkRZbThnTzBPa1FFYVJzaDc2Y1A4QnpvK0F3VHhkek9z?=
 =?utf-8?B?UVZJN2VSQjYvbm5LY2pRU3lIQWFiYk03N3M0cWRTd2p2RytBSkViYlRMakRS?=
 =?utf-8?B?OVMwald0bmFXOE1PS3daYTZhd25jRG1aQ3UvVDFKdk5NSEFrVUc5dU5NdHFs?=
 =?utf-8?B?Q2M3aFVZSkplTVBTQSt0NmhOcTRWZDNNVUFrS2M3TTZ2VkpyUHkwWjRXdVh6?=
 =?utf-8?B?S3Y3ZTNYbmQrZWhCUnhNa1lNUnI3eGE4TWdma1lNREUzbHA3Y0twR1JLNXha?=
 =?utf-8?B?dkMyMkxtTzRsd2k3WldtVUNzb2JsRmxWUi9VOTNpbnplNEhZNFhqenErRWZ5?=
 =?utf-8?B?bzJLd2Q2RTQ4elY2MUh5bkFJcVZKRkNrOWdzL3oyVGpZUUpQbk9BOHRTWm1y?=
 =?utf-8?B?ZStOdGhlZWwyTVB1VHRUM2RzakVDUUdjSnJnN1dqRDlYazA1bjBqR3lUS1Fs?=
 =?utf-8?B?UFI2enUzTHZSMG82LzhWUHpPRkIyMGxQb09OQTZLd0cvV2pseTJqWmJuMW5S?=
 =?utf-8?B?ZDN3TnNuL0t0OEVzYnhaZFBFM0tJWjluT1JycHhuc0Y0WkVHRHJmR1RpQUpZ?=
 =?utf-8?Q?jc6/T39U/4x7QkctDKwhYexpTMG4iZrSyEYutrn9B6Iw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2152c19-dad6-462d-67bc-08d9eb2208f8
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 16:42:46.3579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAWNxz2+u6sVZ3cgfHzOkpkHbAICVZhuCeVne/H6tSiKyPdq/T8BKNEfEy3G/xHZ/d3bFzZkkHa7ugD/DkRJog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3954
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080101
X-Proofpoint-ORIG-GUID: UGxLxhIy_utP4gqnexookcKOhGA3goz2
X-Proofpoint-GUID: UGxLxhIy_utP4gqnexookcKOhGA3goz2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 2/7/22 8:32 PM, Eric Dumazet wrote:
> On Mon, Feb 7, 2022 at 7:55 PM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
>> the interface to forward the skb from TAP to vhost-net/virtio-net.
>>
>> However, there are many "goto drop" in the TAP driver. Therefore, the
>> kfree_skb_reason() is involved at each "goto drop" to help userspace
>> ftrace/ebpf to track the reason for the loss of packets
>>
>> Cc: Joao Martins <joao.m.martins@oracle.com>
>> Cc: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>>  drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
>>  include/linux/skbuff.h     |  5 +++++
>>  include/trace/events/skb.h |  5 +++++
>>  3 files changed, 32 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
>> index 8e3a28ba6b28..232572289e63 100644
>> --- a/drivers/net/tap.c
>> +++ b/drivers/net/tap.c
>> @@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>         struct tap_dev *tap;
>>         struct tap_queue *q;
>>         netdev_features_t features = TAP_FEATURES;
>> +       int drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
>>
>>         tap = tap_dev_get_rcu(dev);
>>         if (!tap)
>> @@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
>>                 struct sk_buff *segs = __skb_gso_segment(skb, features, false);
>>                 struct sk_buff *next;
>>
>> -               if (IS_ERR(segs))
>> +               if (IS_ERR(segs)) {
>> +                       drop_reason = SKB_DROP_REASON_SKB_GSO_SEGMENT;
>>                         goto drop;
>> +               }
>>
>>                 if (!segs) {
>> -                       if (ptr_ring_produce(&q->ring, skb))
>> +                       if (ptr_ring_produce(&q->ring, skb)) {
>> +                               drop_reason = SKB_DROP_REASON_PTR_FULL;
> 
> PTR_FULL is strange .... How about FULL_RING, or FULL_QUEUE ?
> 

I will use FULL_RING.

Thank you very much!

Dongli Zhang
