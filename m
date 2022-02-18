Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE8D4BBF6B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 19:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbiBRSXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 13:23:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239201AbiBRSXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 13:23:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED9F49240;
        Fri, 18 Feb 2022 10:23:25 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IFx6ax007040;
        Fri, 18 Feb 2022 18:23:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4DxgsHLLzdGDa13oRsybtc2Q7zd8lB1ZETMNI6tG2Lg=;
 b=0Y93beMIWVYFjkjhCgLsuTZhjdiB47LP8JWj06xI36bH+/wYo5gWPOYTb+bCeyC/QLyB
 yHYxs6X/Zhgf5Sl7lW90NDo0W1sBpTooBmCoP1QNkFAGpWO32FvFYjxqnTXcWVK/xLNY
 ENgG1+Pm1QegzQVHmRjLdVfRq4+LLknm3GRXw8kqjr9bl0nUgSQ8ayLlzDgVwG+Sg9zE
 W1xFZySMw81y57P0+8NMQl+sYy8IT1VtLrV/N0uyk/bB/KXIATRcbsUra0GAFADZkw2c
 BvQmpu1PWa7ix1gasmtwrgOnBaQMLBsraQgG/8emvxTZY7LCvus0o0QKnwqlyfJJtLXH Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8nr9ahp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 18:23:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21IILMM0168210;
        Fri, 18 Feb 2022 18:23:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3030.oracle.com with ESMTP id 3e8nm1d5a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 18:23:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzhERag3iqmYXJZW+W9sPfGxTfKZBSfbI86Z0n/y8QouJMnmZt+nYMUAd2E+YMze967F3OH6Kxmmfo0o+d8gAc27zL2V0Cgh+qgaed81XMeDKp0h9vPGV9T3HEtWeYFz8qpjOzOVvOaC5PdEFMVx5g47w3k7aGIuQ10KJlaTKYNmmoOQJCS68/o4vHFOV2Vkn/qRjcTKmuYWBfoFBAoLY3QdKffwTTTae9gvspxa3Iv5CJBe44GyqBzMUGhL18H8a57qM308I7lAsJCfZwmsXkmYwNql1DQFf3ZL6Y8W1TZ+r7QZqUhC0iptF1nSzypAqsheEGik1KYOBKnEoDx8tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DxgsHLLzdGDa13oRsybtc2Q7zd8lB1ZETMNI6tG2Lg=;
 b=CRdS4aJU+9e8wrOQqyStmYj7okB8CMBQAVCQNNKBbRrseJtoBysTY1ezZNxlHPnBqYb5OK6fYduBOH8IWrwFu7tghHH/CT9Zatd2IFAtkNBV4ppKNA9ifzyuUY9Z3XssVEjTukUXzF2U5m7CmZVNj92W3hlFiX3633bjHGrWzlpq1xRWtWrjovtm2DQn5KFxsh3ONzdguD30ioZ3V5cZavYAezblVnCJXVlXnuPJfYES1Ndxi3SZyv0jqUL7UpOSwjuPZgd1ntcPjLLzh134S7o8okId+fYlpJQ6+ZLkkDeEIEJvwwoXw5j9dlR9atG9DaprzgbBvrVGNxtxj9Gchg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DxgsHLLzdGDa13oRsybtc2Q7zd8lB1ZETMNI6tG2Lg=;
 b=WyA8pCcFAukku19WowntH1RvFKgStqUjA61DvUQ1U6EWkSlcRRAwuGSORhWclbitqIS3tuKtA4Ct/baLSNAVP8cY17+iafwKICAdreNhYbXiTWIQW2qyTnQIsChyIneEXjBAEUCsvfVB8UXF9LyT7gH2VG8sQWu5iQDeb9ZGvsY=
Received: from CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
 by SJ0PR10MB4814.namprd10.prod.outlook.com (2603:10b6:a03:2d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 18:23:13 +0000
Received: from CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::6d8a:c366:d696:1f86]) by CY4PR10MB1463.namprd10.prod.outlook.com
 ([fe80::6d8a:c366:d696:1f86%10]) with mapi id 15.20.4995.016; Fri, 18 Feb
 2022 18:23:13 +0000
Message-ID: <a5fca5da-c139-b9bb-1929-d7621c06163d@oracle.com>
Date:   Fri, 18 Feb 2022 12:23:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] WARNING in vhost_dev_cleanup (2)
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>,
        kvm <kvm@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <0000000000006f656005d82d24e2@google.com>
 <CACGkMEsyWBBmx3g613tr97nidHd3-avMyO=WRxS8RpcEk7j2=A@mail.gmail.com>
 <20220217023550-mutt-send-email-mst@kernel.org>
 <CACGkMEtuL_4eRYYWd4aQj6rG=cJDQjjr86DWpid3o_N-6xvTWQ@mail.gmail.com>
 <20220217024359-mutt-send-email-mst@kernel.org>
 <CAGxU2F7CjNu5Wxg3k1hQF8A8uRt-wKLjMW6TMjb+UVCF+MHZbw@mail.gmail.com>
 <0b2a5c63-024b-b7a5-e4d1-aa12390bdd38@oracle.com>
In-Reply-To: <0b2a5c63-024b-b7a5-e4d1-aa12390bdd38@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0088.namprd06.prod.outlook.com (2603:10b6:3:4::26)
 To CY4PR10MB1463.namprd10.prod.outlook.com (2603:10b6:903:2b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a03cfb2-1ddb-4b96-d4f9-08d9f30bb96e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4814:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4814F4C9E09B5FEC644C6A8DF1379@SJ0PR10MB4814.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uBLYELwr4VBwZddTby1f1f2rvH+3BtvWvPZIZ74nXbm6SR5ZY7LWmDW7wgfPLX9x6guRfu+/TpD/vl7yTM01t4Up1xhPRHmmbdcZ+Hwou75h+r3iIFOqESTVp8/jxuBDeD8SB06VEbgQ2XWy7GjfIsJOVkSRvYdUyOLFu8YYhTMS7DIjpBMsX5EN4jRcJ9HtaQh92RKih3EOKtVzxWDRouMGRhwaZrhi8Hs0+j3DIXVWYT9okpLgRX9xXLBBLcrOxPlIH0p1eVjJ6Kl3+11SUZy3QqJtLTChldPvSxGG3BDGGHaOO0gv3a4YGHPQL6n9DmxjscoKFLr4KmEK5Wbz4UzppS+TkqSGRpM5OmwdfgOXMYgHD+J4VT1bSCF+Vtg+QMbDiUq7X0aQnp+f1rZB6oW8R4LG5fpzOUH3JCQLD2uKtSeZAKWGcI2mhz86ua6f+VVDajH/wqmNc7eh8VE6GRgvdEoIm4YnDFPbWTI3haqkVFNFlUQgXjZY7B47OUd2G83S/93MkaG5JzRE+xv6nifwRtSPWPm6rBzF/k9GT2mkrGtMp2Bro/3wgT9OKTfnFc1yhd9jRYaLyKl8kwGScCB+XEVbnQr7NE6yf6LOp0DYN+f4n9UyQMDwTSFXPZbHSs4UTV9iD6KnAH2zQE6bLJvlowON6K4Lge1H6m/Gjk2YlGb/RTCMUbThAcs09K1XDI/bI3Bo/JtgpFMteZ1LNvcglwrfz+TMryFbSqd2nr44ubFZTh0u7QGQr58+9TyWvY1dzl+KpTFpAkvZZvX/F194OtflSTHioyHZleUO2I8dYWgWBor1BRHGp66kjZwp/Gp1lksz3hFdiPWrk8DCyQ53+dxP7xSCkKaGhcKWy8JVgVzNyzQltw7irSlfYuhABZQ24bcK3ee7aH5AB8Y4VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1463.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(186003)(31696002)(6512007)(86362001)(66556008)(4326008)(66946007)(8676002)(2616005)(6486002)(83380400001)(54906003)(966005)(66476007)(110136005)(316002)(8936002)(508600001)(5660300002)(31686004)(2906002)(45080400002)(53546011)(38100700002)(6506007)(36756003)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUFGaHFkNXdYTkp5WDJ6bmJHbElRTS9HOGNMQkZkaTZmZjcrODhrUFpRTG14?=
 =?utf-8?B?bUU3aS9nMTZ3Y2ppM1ZnOHUzbUlla091ckJQVDdGNHN1dEoyRkJPbTlTSmlx?=
 =?utf-8?B?dS9Kb1doRUVSdUlBNDFLNVQ5dlFNMmg5c3ZGMzdTdnk2WER3bkh4ZHNKdktT?=
 =?utf-8?B?S0xEdGlEYzRsOGp1QTVKdnpJdDBtTG5qU0lRM3BQN0hqenowTnlubktQd2hu?=
 =?utf-8?B?TDBkWlNuSnNHamdyN0NnNXY1djc5VTFSR1M4Tmd6MHU0TXF2UUZ5MVBNMWEz?=
 =?utf-8?B?MUh5NHU3ZUt4aGdyZk8zVmpTOUtna25ZT2xFdVlwOGpBcFhpQ3NHb3VBK0dy?=
 =?utf-8?B?bEFUWndsQWpnOXhMTk52OGd3eWd3T3FQanIyWDZYUWxlTHhIVFBMVTkvQ1VT?=
 =?utf-8?B?Ykt5UkZUYzhwa2liaWR1Tk0zblZIMFZ5eHVTdGxJcTBQSG8reEhaZ3BpN0VL?=
 =?utf-8?B?bHkvc3lSQTZseFJVaFI4YTVsdmVQOE1tSitxVXhYUEU0VGluUnFTeEdDd0xP?=
 =?utf-8?B?TlM2ZjhwZEZpTGZVWjJuK3RacXNSUi9lYWJlUlJXaUd5OU95aWtVZ29MTDd0?=
 =?utf-8?B?bWpUOVJCblVLMmllSHBlMEpWSC9EM1dVWGNRRk9NOHhkSEtmUlg0cVZUT2o5?=
 =?utf-8?B?a3gzamM3S0NkaTJDVjdubVZ0bnFpU2Y3OFFjbmQ2c0grdjlWaEN0bGJyZ0RD?=
 =?utf-8?B?cFFwbnJ4amRZYis3V2pqTnNqUitvWFFTbHZmeUovTUhMZXRvbzlNc295bXBh?=
 =?utf-8?B?VlNqeXg0WjBUSmUxQ0tHOVg4SXJWTFpnQU00ZHpFNUpuRmhuSWlXS0F5eVpU?=
 =?utf-8?B?d0RUaVFLV2hGTlFCNHJRUU5jMzJJdnpZYS9SL3luV2NyTFhvMVdqMk9yamhj?=
 =?utf-8?B?WHh3RlNVdHd6T3dkbXlta1ZxaFBZNGJKb0FFT0dwYzlxRTk1RFJJa2Z0aFMz?=
 =?utf-8?B?dHlFR3lpOERqLzNQT0UxeUlwSnBPWkNYTnBMeHVYSzRTR0RWLzlUa2RNbGVZ?=
 =?utf-8?B?OHZjZlltM2RKbWtlMDZXaTFUcEhyd2phWm92RGpCaGxBaEdWU2dINm9XMTNs?=
 =?utf-8?B?U2dKK2xwQmdDbVE1NEJ5TnQ1WTI3cFM2dVRKVVJ1Mi96akFad2d6RUp5RkVH?=
 =?utf-8?B?ZW9Sd2p1bUJaV0l6OUdPbHV0ekFDL05RaDBjbWNWbTEwVEpQTnN6a2ZmN1JM?=
 =?utf-8?B?bWhLa1NoOHJpL3E3OENYak9XMmdyeHY2eVR0dzRQUnNRM0xrSG84aWhXOGxp?=
 =?utf-8?B?V055ZVR3RmJxUTU1empFSUpYYnIzL2lRUHNxQ3ZWME1oYnV6cG5SWGtDYlRr?=
 =?utf-8?B?L2txVzZLb25UeWtnOXVRRm91enE2c21EYzVlMVg1dStVMXdFQTRLWXRKcGtP?=
 =?utf-8?B?elF2VmRTM24xRS9iMlZCUzk5NVlrK2tiRjU5U2cwZjYwQUQ2RDdKd1lmSFMx?=
 =?utf-8?B?aDZaMTl3WWxnWWpTY2hMbXpIZGNYNmR2STlrekdtNUtXTEtLRlIxTGNLRUtz?=
 =?utf-8?B?bzREbzQ2dHM0akJzTHZVQjEvTHVZYlI5SzBndXN3SVNVMVZJOUVXLzdVeHFi?=
 =?utf-8?B?RXQ5QUJXTXREOVRyVEk5dzgweTB3NjNvYUM3ZHNTU0lHaCtxUUF4SDlXQWhO?=
 =?utf-8?B?LzMrVkkvV2RSUHN0SmI3cFVMVGUyZFRwR0drZU85TDgyVVRyOS92ci9Gdm8r?=
 =?utf-8?B?ZE9jTHFHc1ozYU93bmdzMkhiQitLM2JKTU1tZVlWWnhLeUFTM1RLbTJwVmVK?=
 =?utf-8?B?dDYvZnJ4SDZQeE84TFhoeHFqNHlxS3JQdE0wMmh2T3VKUzI4TnNrdzdzQTVL?=
 =?utf-8?B?MEhQOFZ6QStpZ0JzY2ZoZ1NkeVpMNzh6NGxxQ3p0MVhsV0JjckVLbFFscGhK?=
 =?utf-8?B?eGFkU1JFS3pEUlJMWWQ0QTZUVkRnemVDd0xvQjVhTnZBcVVJdmFCNTlZWmZJ?=
 =?utf-8?B?U3BDOU1Qdks1a0VFYXNwWWhHSlZhZTlmaTNKSjZxMDd3VHpjR0F5dWNnOE9V?=
 =?utf-8?B?UGg2L1l5QkRRQ2tROE9xYkY3OEQzNGwwZVdIeFN1cXFETTFtOEtvdEpFZXhx?=
 =?utf-8?B?SHZtLy9jV0JqbCtEdVhIRS9ZNWg4TFA1bzUxSWU4L1RLL2xoSTNpMFR2RmhX?=
 =?utf-8?B?aExKckZKQWl1U3U5WkFvMlhvNXFNK0t0RGw3bzF6cld5N0ZUblBpaE1OYmVp?=
 =?utf-8?B?SnVUdlZ6eWxhUDVyb1ByV3d4eCtxVVh6SG1FS2ZyNW9USWxHZ1h0SUZTMVJs?=
 =?utf-8?B?ajlzNjZEKzFjOFNZWFNvQTFrRGF3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a03cfb2-1ddb-4b96-d4f9-08d9f30bb96e
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1463.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 18:23:13.2124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxZ3O53iX0QTJJkl6E1TVE/M6nqCAAuKUq63vY+cOiYUFc7dKd6TdpMAc4e9Zl60wbj7Ns2Hwjqxu+H/Oo6jawgaK5quUVVnzas3Nhys5AI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4814
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10262 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202180113
X-Proofpoint-GUID: fqtxnaiKaDEWPC-9zAiYaPZxfHCaFRE1
X-Proofpoint-ORIG-GUID: fqtxnaiKaDEWPC-9zAiYaPZxfHCaFRE1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/22 11:53 AM, Mike Christie wrote:
> On 2/17/22 3:48 AM, Stefano Garzarella wrote:
>>
>> On Thu, Feb 17, 2022 at 8:50 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>
>>> On Thu, Feb 17, 2022 at 03:39:48PM +0800, Jason Wang wrote:
>>>> On Thu, Feb 17, 2022 at 3:36 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>
>>>>> On Thu, Feb 17, 2022 at 03:34:13PM +0800, Jason Wang wrote:
>>>>>> On Thu, Feb 17, 2022 at 10:01 AM syzbot
>>>>>> <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com> wrote:
>>>>>>>
>>>>>>> Hello,
>>>>>>>
>>>>>>> syzbot found the following issue on:
>>>>>>>
>>>>>>> HEAD commit:    c5d9ae265b10 Merge tag 'for-linus' of git://git.kernel.org..
>>>>>>> git tree:       upstream
>>>>>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=132e687c700000__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9YisMihn$ 
>>>>>>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9RjOhplp$ 
>>>>>>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=1e3ea63db39f2b4440e0__;!!ACWV5N9M2RV99hQ!fLqQTyosTBm7FK50IVmo0ozZhsvUEPFCivEHFDGU3GjlAHDWl07UdOa-t9uf9bBf5tv0$ 
>>>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>>>>>
>>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>>
>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>>>>>>>
>>>>>>> WARNING: CPU: 1 PID: 10828 at drivers/vhost/vhost.c:715 vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
>>>>>>> Modules linked in:
>>>>>>> CPU: 0 PID: 10828 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00051-gc5d9ae265b10 #0
>>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>>>> RIP: 0010:vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
>>>>>>
>>>>>> Probably a hint that we are missing a flush.
>>>>>>
>>>>>> Looking at vhost_vsock_stop() that is called by vhost_vsock_dev_release():
>>>>>>
>>>>>> static int vhost_vsock_stop(struct vhost_vsock *vsock)
>>>>>> {
>>>>>> size_t i;
>>>>>>         int ret;
>>>>>>
>>>>>>         mutex_lock(&vsock->dev.mutex);
>>>>>>
>>>>>>         ret = vhost_dev_check_owner(&vsock->dev);
>>>>>>         if (ret)
>>>>>>                 goto err;
>>>>>>
>>>>>> Where it could fail so the device is not actually stopped.
>>>>>>
>>>>>> I wonder if this is something related.
>>>>>>
>>>>>> Thanks
>>>>>
>>>>>
>>>>> But then if that is not the owner then no work should be running, right?
>>>>
>>>> Could it be a buggy user space that passes the fd to another process
>>>> and changes the owner just before the mutex_lock() above?
>>>>
>>>> Thanks
>>>
>>> Maybe, but can you be a bit more explicit? what is the set of
>>> conditions you see that can lead to this?
>>
>> I think the issue could be in the vhost_vsock_stop() as Jason mentioned, 
>> but not related to fd passing, but related to the do_exit() function.
>>
>> Looking the stack trace, we are in exit_task_work(), that is called 
>> after exit_mm(), so the vhost_dev_check_owner() can fail because 
>> current->mm should be NULL at that point.
>>
>> It seems the fput work is queued by fput_many() in a worker queue, and 
>> in some cases (maybe a lot of files opened?) the work is still queued 
>> when we enter in do_exit().
> It normally happens if userspace doesn't do a close() when the VM

Just one clarification. I meant to say it "always" happens when userspace
doesn't do a close.

It doesn't have anything to do with lots of files or something like that.
We are actually running the vhost device's release function from
do_exit->task_work_run and so all those __fputs are done from something
like qemu's context (current == that process).

We are *not* hitting the case:

do_exit->exit_files->put_files_struct->filp_close->fput->fput_many

and then in there hitting the schedule_delayed_work path. For that
the last __fput would be done from a workqueue thread and so the current
pointer would point to a completely different thread.



> is shutdown and instead let's the kernel's reaper code cleanup. The qemu
> vhost-scsi code doesn't do a close() during shutdown and so this is our
> normal code path. It also happens when something like qemu is not
> gracefully shutdown like during a crash.
> 
> So fire up qemu, start IO, then crash it or kill 9 it while IO is still
> running and you can hit it.
> 
>>
>> That said, I don't know if we can simply remove that check in 
>> vhost_vsock_stop(), or check if current->mm is NULL, to understand if 
>> the process is exiting.
>>
> 
> Should the caller do the vhost_dev_check_owner or tell vhost_vsock_stop
> when to check?
> 
> - vhost_vsock_dev_ioctl always wants to check for ownership right?
> 
> - For vhost_vsock_dev_release ownership doesn't matter because we
> always want to clean up or it doesn't hurt too much.
> 
> For the case where we just do open then close and no ioctls then
> running vhost_vq_set_backend in vhost_vsock_stop is just a minor
> hit of extra work. If we've done ioctls, but are now in
> vhost_vsock_dev_release then we know for the graceful and ungraceful
> case that nothing is going to be accessing this device in the future
> and it's getting completely freed so we must completely clean it up.
> 
> 
> 
> 
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

