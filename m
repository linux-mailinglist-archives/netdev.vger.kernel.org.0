Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881C264A116
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbiLLNey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232575AbiLLNes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:34:48 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D3913E85;
        Mon, 12 Dec 2022 05:34:47 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BC98Pha023616;
        Mon, 12 Dec 2022 13:34:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5ifaIFIka2nvv3cppIFrlb/ZAiBTG5vn8GpAyEuCzrU=;
 b=ZbvgXeAqe2Dxp+2hPnfTJQWwi8oUrUc36bD9COKc1hj6oyQL4PvB0fTwbFDQjj0QZS7s
 aQZzpdVSehzzcU5t6lk8K86u4xZB2p+LzVNO8FRRbuqdsMC0M5tpddBmKz2AWlz8/eTM
 ljroUKlI6naGMNzVgl+SNvZzT92O54HrzdXkiI5jFAbQSIZEuzcMXqz96vsJ08PLGhio
 OkcttvCdiLqAp2BzRwpaCqenlhoOuXc4e2b4bd+hrfHSjZzxF2Z0pkJgXqX6+5IOj1RY
 kq8L8454jADJz0Rz+Otl/ON1V43juc2gcfezvkbfCyo/XM9byogGyCFncxgoZTsAk6+P nQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcj092pq3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:34:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BCBvlsF034858;
        Mon, 12 Dec 2022 13:34:37 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj41njb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Dec 2022 13:34:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGiBNr50z4kWF0d6NZkL6c9In9YN2NhFTh4VZAtCslKUbw+zc8EnZ97IuqAdHXbcuGJkABF+c6HdreYXXvfYufT1MCbO+vi0hNZi+XquDiPeBs8BMRKWqatnMM2poXwWq01EeDdTOHoUk2t2byXyal4gjKzt2afuS7eiBN2+PsS19GRW3waoywGgy0YJly+m6K4OATHgO3dA86Zm2n6s+UaO8lF0x+ViywlIVTi86INUCtDFwf121jR3k37BB59mYd8vCzxs47TewPFceXHroFpmKZtFihsb0e/bAgcFHihBQoOfdJc6o5xe9uXFYyifwN44H4FcPUvX/RjR3iPwYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ifaIFIka2nvv3cppIFrlb/ZAiBTG5vn8GpAyEuCzrU=;
 b=ZuaFYCTd99mcYFScNVI8WWpOlVgJFTumen/bcAlohvI4U/5aIWRkP5lVk8g017w6eulWNrbUyIJKKdWlRkF7P7wnzp9cceOlEQNNcmDenaT7A2LnLO1Jjgj6UnHgY19rTmFYV8JkP+m9l7JI+NgJj/imk+IidN+THfaYIh/oWlWFLRiDtxLUux0vOmu9owE553zO4iiQvy6QshrVEcpqyr6PjZYjP9IwhtbwTVgfXuO7VNbTAmaaoes/1C+s7FVrLgw3iaqWeB80s7wZCWEmCCooOOohU3wYwzFr3qvp9OHpASBHIbm7XakrDwgKDvDp4qd02Tn/IRsQhi9tsi434Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ifaIFIka2nvv3cppIFrlb/ZAiBTG5vn8GpAyEuCzrU=;
 b=pYARSGA5uuUzJUCtcprszZak3WE3GcTGvDE97MVvI4tdZ7pF3UGcTFA/ktpsY233AxIgn4xroh/I3iGaAWP1Y6dzgZQghYxS/EyWFAS1wwXE0sUsj9sQDSlszjBR+sdw2lPY1bINZuJV9EuFi/xXTlhPd0LB6TqgH1WmApEGEpU=
Received: from PH0PR10MB5895.namprd10.prod.outlook.com (2603:10b6:510:14c::22)
 by IA1PR10MB7165.namprd10.prod.outlook.com (2603:10b6:208:3fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 13:34:33 +0000
Received: from PH0PR10MB5895.namprd10.prod.outlook.com
 ([fe80::90c7:3590:b852:80f8]) by PH0PR10MB5895.namprd10.prod.outlook.com
 ([fe80::90c7:3590:b852:80f8%9]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 13:34:32 +0000
Message-ID: <69b9fe66-969c-e477-e1b6-6191e2146824@oracle.com>
Date:   Mon, 12 Dec 2022 08:34:08 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] net: check for dev pointer being NULL in
 dev_hard_header() to avoid GPF
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pavan Chebbi <pavan.chebbi@broadcom.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        harshit.m.mogalapalli@oracle.com
References: <1669817512-4560-1-git-send-email-george.kennedy@oracle.com>
 <CALs4sv2ZfT1SAYY0oOYhrBBCjsG_th5g=QtSsbKJnPbW8faQ+w@mail.gmail.com>
 <CANn89iL9obgd==tdp9DgdxXk78UvzF6D4J1OeihB1kx9_U4oZw@mail.gmail.com>
 <99adf483-ae89-8010-4689-fd50a77ff023@oracle.com>
 <CANn89iL18gPus7YWMMX_UFg9PSxAv0SkWTjLYCPhncOCEKrWuQ@mail.gmail.com>
 <ae736328-56de-7985-8a9a-0279a123544f@oracle.com>
 <CANn89iKsGrTw31_yQ8DqdFeDYG0OABUKuWd5i9t+HbwAS7ZbsQ@mail.gmail.com>
From:   George Kennedy <george.kennedy@oracle.com>
In-Reply-To: <CANn89iKsGrTw31_yQ8DqdFeDYG0OABUKuWd5i9t+HbwAS7ZbsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:8:2a::16) To PH0PR10MB5895.namprd10.prod.outlook.com
 (2603:10b6:510:14c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5895:EE_|IA1PR10MB7165:EE_
X-MS-Office365-Filtering-Correlation-Id: 42b91bf6-a7c3-4c2b-112e-08dadc459a27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0C/eQXFv0bw+Vi4AY0UexxEf/ZZfc39lQsdUSawEpr5GkqgPO2TzG2VFCb554404md9lKkAHs0rT66nsx0Xk1MZd1q7xSZ+tqtV59YyZ7kSikEEEj7bJm94oCgssd5Fkqxh+5BztRbM28uGFjo5tHv7faX2FnpLilXdo+r0XiMHFQdHXSbCyXV0oSy6bunYDBMUnb2vazoi1MiT+WaCa96n9U0AIngBd651ZUaiXF9B5zRcvE7Nb6v5z4cymFZzMqJhW1YPMVNRdZmFKymQ4OWZ4Mk8LCHUmO1xIuufeOgtHRxP314t4BzAGQdydNDVGcye8+1p3DPJjiRys7TrN+mnnlCeVO3F1mtjejZzTQRc/jfqQsURymsISgZkVHxqEIhLxDXO8bPwHAGhu4WGQf0qWFLTKg54IsuOy6dxiW8rzxvfjURDJDA0PKzaQ+edutjvfBoSfrTInWZW6aDIAiBaYjEbHNF+NbNLeVlY68sH2nD3akOuQbRYDiWgutdS6xdD+Bjl5MjNT/76cTLEQ+1WWG4CKd+6Y9D9CEwZjSNetYQMJBS1XYNQa2n/Nt4gE0L+Zb53SQdzcffB/WaRn7vI/t4Qzv03LmnXcYQNkpqHuZ/mmcZHtbOhkMtcz2J/0Jdw2LG63T5wybQVzscm5DV4HisHMsyXrkwDXqIZgBqJkR2FPHUuqKDBiOrVI+kCuJQwQMr+lcgv/szeAaX87cDPtZa9a70mjBsYjV5m+AYc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5895.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199015)(36756003)(66946007)(4001150100001)(2906002)(31696002)(44832011)(2616005)(86362001)(6916009)(83380400001)(45080400002)(6666004)(186003)(6486002)(6512007)(26005)(107886003)(53546011)(6506007)(478600001)(38100700002)(41300700001)(8936002)(5660300002)(66476007)(8676002)(316002)(4326008)(66556008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzY1SVBaUmM2aWlxeEw5TGVoODhFb0lUYmpSbFpPdCszY3FPUW1wOGp1M0Jw?=
 =?utf-8?B?NjVwOW1pSmRJVDJhMnYzZ1hsK0g4T1FmT1Mwd3hsYVNJWk9jT1ByZ2dxSDdP?=
 =?utf-8?B?ZTQwcGlZWlVNSGlYbXk3NEFyc2x6TGZKVVo4OFo4MlVjZW5KckZhQWk2TitY?=
 =?utf-8?B?NTMwRS9INGJ3ck50V2VBTUlCQ1hhRmtaVVloMGxUSEZaODhidERBVWp2dzRZ?=
 =?utf-8?B?dGJ6djVldXpaNzc1YzVTaXNKbTN4VldsM0JZWW04T2tmSmhJc2hDWlIvQVZn?=
 =?utf-8?B?K1habVFHODlvdXZjanpyeXZrT2F4dytXNndybHhxeGdHTis2MXFaZFd3cnc0?=
 =?utf-8?B?UkJDS2tSY1FYcTBBakJwZXdRVElPT1JNVWhsRzFCYURiTmlPNUZ6V3lZMHJ2?=
 =?utf-8?B?TU5zNTNFM2Jlbzd1emFONWRFOWE1REN2Tkp5NG9DTEFLWDM5V3dIcnk2RTN3?=
 =?utf-8?B?bnpnT2lIY25tWmxYUFVkWmNXZE0zNjlabFhvaVZmczhia1NhV2JoN0F4Ymo3?=
 =?utf-8?B?YWZjRXZPYzBBcURQWlJaRmJFSitMcDRYU3pBWVBCa1FZa0pGTm41VlQ1OWRO?=
 =?utf-8?B?UFhoUk5BdjFqcWo5TzRSS3NHRVBXQXFEK3FSc0JlcC9FdVV1anpvWWhjSHNC?=
 =?utf-8?B?Q2wrZEdiaDVrbWcwUWxqRkF1aktMS2d2ZUFJSjhXZEtOUlZCM1p6WmQ1R1lU?=
 =?utf-8?B?Z0c1UWx6TnRCczcwU0ViL09wQkd6cTJ2Q0FEdmZ3TmUvYjZUdnIybnJrbDFK?=
 =?utf-8?B?YVJkb3d6MFY5VkpFNm9BWWtOVkEvQitHWXJtRVlwcEkxczA1K29IYWlaS1pT?=
 =?utf-8?B?TEJiTHp3bmdPRFpjQTYwT0FpYnJuRW1IYmtQYmNlSmk2dVFJWDkyckg0UkdU?=
 =?utf-8?B?RHVRdzdkTzB6T3hMN3puVFRzL3ZBR2xDZWlVQjEzemY0dWtEZ0R5citnZlNh?=
 =?utf-8?B?L0E4dTI0MzI3N2J6M3pldFNaZmpvZW4xVmN5NnZ6dVZKWVlUcVpkU21qcTE2?=
 =?utf-8?B?bzlNeWQvZ09KYzFRQWhxTUU1ODZFckd6b281MG96Rk9LY3k5cGFJOTJoZ0RM?=
 =?utf-8?B?SzZ1V3cvWjVmZTNheE8xbHh1M3FIeUxPZk0xRm5YakdYS211M29uTmNSS2xv?=
 =?utf-8?B?c3ZhVlQycmJKOXpCQ0tLRUEwQmt3cC85bmdJVXVUclN0TnNPdlY0TDZXR2ti?=
 =?utf-8?B?UlZQVjBzK0Vjcnd3UjlMMlFGVkVxVlFwQlNVSGNRcGdCbk5xZEhUU1FUcjBS?=
 =?utf-8?B?Z0dRQmhqNWloTnhpQUQ1L1gwZ1ZuYVFsa09rVkxQd2Y5YVdUTkF3WjdsYks5?=
 =?utf-8?B?MkY0NUg2Vk1pSmdMVHY3SHkrMXI2R1U1c2laOU1oV21jWEZvc1NrZnJOcUVP?=
 =?utf-8?B?SjZwd0ErVlVRaUJxVTFTZ3l3ekgycnlqSjVVams1Z1dvb24xVlhyQlNLWmVj?=
 =?utf-8?B?NzJ0NnJ4WlRoMW5oQkNlOXVydmovaHdhL2hVRnlwNjgrSGpDTlMrb21tcHNE?=
 =?utf-8?B?aGJSZmNPTU9xNTZjWGR3UDFqblc5eXdBbzZ3OW1iU1RadHMxbHBNMVBucTcy?=
 =?utf-8?B?MFVmT2JOcFJTRHZkSmEyYXp2YkpicXpybXE3dUFsM1hwMWlHVTRFdTQyZzZG?=
 =?utf-8?B?OTY0cHh4N3JNcFhnUStRS2ZzcHo0SjF6YUl0UDBCc2didWdpV3BIaHZ3V1p6?=
 =?utf-8?B?UXVGa1doYWw5dmQ0VnkrdE9LQlViRHdtUnZTNWlyUjA5YUJJdzc1VGJHU01j?=
 =?utf-8?B?MzE2ek5UelRldFZEbTJNWDhsSmlTazlUNG5SS0pxU3JIRHZaRmlhMDJpSDNW?=
 =?utf-8?B?aENWeFJHcWh2VUxNcFJudVdONmpMTU5EcWdDek10WGlyQlZmd1ZVRGhVTGVE?=
 =?utf-8?B?L3B4ZjV4eUpDakVsRXJZdkdOcDVWdEp5a1lFQUlBRHplTlVXZmRtTjNRaGl6?=
 =?utf-8?B?LzQyY1NvVkkyeFFlTDQ1R2gwZGRvSXRKdHA2YUdwU0ZzdzJNSTJjQWpCUGQv?=
 =?utf-8?B?alEvck9ibzRZRG9CYmQyTk82bWFobG45LzZIZmV0SFROT2RxK2VyMDNxbHIw?=
 =?utf-8?B?YUUzU1JrWHBaUXFiNnNKU2VPaXlRK3RROUJGV3VrZzN0RURIVUY0WmxtOFRp?=
 =?utf-8?B?a2xNQTdFU29TQmR6WHovUVhJOGNJTGJ1WENUeUVZdXU2WXhVcTdVL2VyaGNG?=
 =?utf-8?B?ekE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b91bf6-a7c3-4c2b-112e-08dadc459a27
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5895.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 13:34:32.5209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5IhU9Nr/rsl4P9YUSjyWNvoaIX/kWSONZkqhT8mvrrFY1cLOsbvhItQeF5xnC1/vs72e9/6Q6Htdx7p4Kh50/SG/hoIDNGysILSxY9lwCI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7165
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-12_02,2022-12-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212120125
X-Proofpoint-ORIG-GUID: NICXiKc-0s01pqloYghQhIjEfzlh27Y-
X-Proofpoint-GUID: NICXiKc-0s01pqloYghQhIjEfzlh27Y-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 12/5/2022 10:21 PM, Eric Dumazet wrote:
> On Tue, Dec 6, 2022 at 2:11 AM George Kennedy <george.kennedy@oracle.com> wrote:
>> Hi Eric,
>>
>> More info...
>>
>> On 12/1/2022 11:11 PM, Eric Dumazet wrote:
>>> On Thu, Dec 1, 2022 at 9:44 PM George Kennedy <george.kennedy@oracle.com> wrote:
>>>>
>>>> On 12/1/2022 2:25 PM, Eric Dumazet wrote:
>>>>> On Thu, Dec 1, 2022 at 2:16 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
>>>>>> On Wed, Nov 30, 2022 at 7:43 PM George Kennedy
>>>>>> <george.kennedy@oracle.com> wrote:
>>>>>>> The dev pointer can be NULL in dev_hard_header(). Add check for dev being
>>>>>>> NULL in dev_hard_header() to avoid GPF.
>>>>>>>
>>>>>>> general protection fault, probably for non-canonical address
>>>>>>>        0xdffffc0000000046: 0000 [#1] PREEMPT SMP KASAN NOPTI
>>>>>>> KASAN: null-ptr-deref in range [0x0000000000000230-0x0000000000000237]
>>>>>>> CPU: 1 PID: 45 Comm: kworker/1:1 Not tainted 6.1.0-rc7+ #2
>>>>>>> Hardware name: Red Hat KVM, BIOS 1.15.0-2.module+el8.6.0+20659+3dcf7c70
>>>>>>> Workqueue: mld mld_ifc_work
>>>>>>> RIP: 0010:macvlan_hard_header (./include/linux/netdevice.h:3057
>>>>>>>        (discriminator 4) drivers/net/macvlan.c:594 (discriminator 4))
>>>>>>> RSP: 0018:ffff888103d377d0 EFLAGS: 00010212
>>>>>>> RAX: dffffc0000000000 RBX: ffff88801cf1a000 RCX: 0000000000000000
>>>>>>> RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000230
>>>>>>> RBP: ffff88801e8ef328 R08: 0000000000000000 R09: 0000000000000060
>>>>>>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88801f0497c0
>>>>>>> R13: 0000000000000000 R14: ffff888045187c98 R15: 0000000000000060
>>>>>>> FS:  0000000000000000(0000) GS:ffff888106c80000(0000)
>>>>>>>        knlGS:0000000000000000
>>>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>> CR2: 00007fbf3f1c1840 CR3: 0000000014e36000 CR4: 00000000000006e0
>>>>>>> Call Trace:
>>>>>>>     <TASK>
>>>>>>> neigh_connected_output (./include/linux/netdevice.h:3060
>>>>>>>        net/core/neighbour.c:1595)
>>>>>>> ip6_finish_output2 (./include/net/neighbour.h:546
>>>>>>>        net/ipv6/ip6_output.c:134)
>>>>>>> ip6_finish_output (net/ipv6/ip6_output.c:195 net/ipv6/ip6_output.c:206)
>>>>>>> ip6_output (./include/linux/netfilter.h:291 net/ipv6/ip6_output.c:227)
>>>>>>> NF_HOOK.constprop.0 (./include/net/dst.h:445
>>>>>>>        ./include/linux/netfilter.h:302)
>>>>>>> mld_sendpack (net/ipv6/mcast.c:1824)
>>>>>>> mld_send_cr (net/ipv6/mcast.c:2122)
>>>>>>> mld_ifc_work (net/ipv6/mcast.c:2655)
>>>>>>> process_one_work (kernel/workqueue.c:2294)
>>>>>>> worker_thread (./include/linux/list.h:292 kernel/workqueue.c:2437)
>>>>>>> kthread (kernel/kthread.c:376)
>>>>>>> ret_from_fork (arch/x86/entry/entry_64.S:312)
>>>>>>>     </TASK>
>>>>>>> Modules linked in:
>>>>>>> Dumping ftrace buffer:
>>>>>>>       (ftrace buffer empty)
>>>>>>> ---[ end trace 0000000000000000 ]---
>>>>>>>
>>>>>>> Fixes: 0c4e85813d0a ("[NET]: Wrap netdevice hardware header creation.")
>>>>>>> Reported-by: syzkaller <syzkaller@googlegroups.com>
>>>>>>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
>>>>>>> ---
>>>>>>>     include/linux/netdevice.h | 2 +-
>>>>>>>     1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>>>>> index eddf8ee270e7..9b25a6301fa5 100644
>>>>>>> --- a/include/linux/netdevice.h
>>>>>>> +++ b/include/linux/netdevice.h
>>>>>>> @@ -3054,7 +3054,7 @@ static inline int dev_hard_header(struct sk_buff *skb, struct net_device *dev,
>>>>>>>                                      const void *daddr, const void *saddr,
>>>>>>>                                      unsigned int len)
>>>>>>>     {
>>>>>>> -       if (!dev->header_ops || !dev->header_ops->create)
>>>>>>> +       if (!dev || !dev->header_ops || !dev->header_ops->create)
>>>>> Do  you have a repro ?
>>>> See syzkaller repros attached.
>>>>
>>>>> This patch will not prevent a crash later I think.
>>>> The repro ran overnight without failure with the patch applied.
>>> Yes, but the patch is hiding a potential bug that might show up with
>>> other 'repros'
>> The repro fails when these devices are configured (seem like small mtu):
>>
>> 20: vxcan0@vxcan1: <NOARP,UP,LOWER_UP> mtu 72 qdisc noqueue state UP group default qlen 1000
>>       link/can
>>       inet 172.20.20.38/24 scope global vxcan0
>>          valid_lft forever preferred_lft forever
>> 21: vxcan1@vxcan0: <NOARP,UP,LOWER_UP> mtu 72 qdisc noqueue state UP group default qlen 1000
>>       link/can
>>       inet 172.20.20.39/24 scope global vxcan1
>>          valid_lft forever preferred_lft forever
>>
>>
>> # diff ../config.fail .config
>> 3325c3325
>> < CONFIG_CAN_VXCAN=y
>> ---
>>> # CONFIG_CAN_VXCAN is not set
>> Thanks,
>> George
> Small MTU has caused numerous issues in the past.
>
> I am pretty sure we miss some READ_ONCE(dev->mtu) and other safety checks.

I have not been able to find the root-cause of the "vxcan" related GPF 
yet. What I do know is that for the GPF to occur:
1) CONFIG_CAN_VXCAN=y must be set
2) if CONFIG_CAN_VXCAN=y is set, the GPF will not occur if "vxcan" is 
commented out of the C reproducer

C reproducer with "vxcan" commented out (GPF will not occur):

# diff -C 3 repro_macvlan1.c repro_macvlan1_no_vsxcan.c
*** repro_macvlan1.c    2022-12-06 01:03:47.557094544 +0000
--- repro_macvlan1_no_vsxcan.c    2022-12-12 13:15:05.293719169 +0000
***************
*** 884,890 ****
         {"vcan", "vcan0"},           {"bond", "bond0"},
         {"team", "team0"},           {"dummy", "dummy0"},
         {"nlmon", "nlmon0"},         {"caif", "caif0"},
!       {"batadv", "batadv0"},       {"vxcan", "vxcan1"},
         {"netdevsim", netdevsim},    {"veth", 0},
         {"xfrm", "xfrm0"},           {"wireguard", "wg0"},
         {"wireguard", "wg1"},        {"wireguard", "wg2"},
--- 884,893 ----
         {"vcan", "vcan0"},           {"bond", "bond0"},
         {"team", "team0"},           {"dummy", "dummy0"},
         {"nlmon", "nlmon0"},         {"caif", "caif0"},
!       {"batadv", "batadv0"},
! #ifdef VXCAN
!       {"vxcan", "vxcan1"},
! #endif
         {"netdevsim", netdevsim},    {"veth", 0},
         {"xfrm", "xfrm0"},           {"wireguard", "wg0"},
         {"wireguard", "wg1"},        {"wireguard", "wg2"},
***************
*** 923,930 ****
--- 926,935 ----
         {"hsr0", 0},
         {"dummy0", ETH_ALEN},
         {"nlmon0", 0},
+ #ifdef VXCAN
         {"vxcan0", 0, true},
         {"vxcan1", 0, true},
+ #endif
         {"caif0", ETH_ALEN},
         {"batadv0", ETH_ALEN},
         {netdevsim, ETH_ALEN},

I think for now until the vxcan related GPF root-cause is found, the 
"dev NULL check" patch should go in. The "dev NULL check" patch is on 
same line as 2 other NULL checks.

Could you try the original C reproducer with kernel with 
CONFIG_CAN_VXCAN=y set to see if you have any insights as to the GPF 
root-cause?

Thank you,
George


