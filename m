Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878944C54C0
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 09:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiBZIyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 03:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiBZIyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 03:54:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DAF1D86DC;
        Sat, 26 Feb 2022 00:53:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21Q4nCGX029567;
        Sat, 26 Feb 2022 08:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DbQF20PtOuB54svgP9ge0FcQmG5QotEDhxb7kD4er0Q=;
 b=biV6sZ4MdnOjMfy05VKg7mBoLtcMsUdJgRLZ3/ryv45phSO9hYBh2nwiLnsd+QyTKcNr
 6ydL24alzUNxKkv+5wRu913Na+YJwzLdyJ284FxVRZGBaSSqkamNLlWiYu7m/ORs71Kk
 9xuG0MdXwjylRn+8HW3AKQ+7Uxv47T8dB+H8NurTc7HF6+nEdwxXXShqBjDSHImsImuC
 0wSSs2HF1DEUngKYlwq8nHr3dIvWjkwErPlpCEkzRMoJJI7X9+oHwHmCtu1OzTCmba+q
 yflhkSyS2Nkmhe53luSXuKjWwYDwCr7X78lhqnbEPv4SJqY/5Y+PQpGlLmvevCSkpwBz Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3efbtt8c4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:52:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21Q8j7TU146244;
        Sat, 26 Feb 2022 08:52:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by userp3020.oracle.com with ESMTP id 3efdngkk3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Feb 2022 08:52:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htYiDNUsHRAQ6mbWQtr7U6udrpqAGz7VConav/8G0rJiZX6gf7AzNBY2Mqe9MvpN4pSakhxeaDBum97DJiMcVDXltE5+YfwRWJENYkg4xEKm0CvnSrAdO9psGq9GAu8nxikn3Hn/qsljbmv0fvBBQlBA+Jw018eIKVGq8QXuZMt7MzSnPwUo/SNmFRxCtQ870nmAfAoo4hq34TAiQFJ48CEne9v3gwvwj2Onfmhy/ppinZorFOCdsdGs9q6OOFNRe+W7AtnVngfK9BRTvePRZOLbwT5FEr7Xcdk6pYbuNNx2yEtQBTLiul8stro76m+zLiT0wH0MKJowtTyzQYu47w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbQF20PtOuB54svgP9ge0FcQmG5QotEDhxb7kD4er0Q=;
 b=KzsyyWuh5z0JONEvUEQkZvhtsmSgFPBs3lAzoQk/f2dMyeDfVKdcZDQv7+dd6o3TsqxJTVQ6in4NmIorvjmfLKosUThqVfAmbFIwTDdQb4uzEQaY6NgjoV9eGgYPUYEEZO4q3j4C6Pi+XGtt2uMzzNXw7yp1Qs5bM8RmCI3gNcJwFyZmffHp8whERivUmXHyhmLKiRJTB7nPW9iKfxTXSdfqqpdHq8sCI001S/eRrOe2fQv1wI+b0iBzHJ0TRmhjLsbvztAlKll6y3pqt79RCHRASJ54SWLVmpD8G+78uu+PlHkFJ80WwKdVbzRsH6JTnPKvuVsv6WmTJZpCvy+r4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbQF20PtOuB54svgP9ge0FcQmG5QotEDhxb7kD4er0Q=;
 b=IeQBU8goPWglBrJcadWgrCblC5faqWW3eC6KpuMcyp2KvtAY0pE9yf5gX1JdJmA0nOpcRJQEX24qZzxPoLbwXOmzUDkSkOo9O06/er3kYQx7YwuDtWCuDYlClGJZaLho7Gltft+3DbuS5gIYSx8pQHFO0cVMitfKbYtMgGGM65o=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY4PR10MB1768.namprd10.prod.outlook.com (2603:10b6:910:c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Sat, 26 Feb
 2022 08:52:28 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5017.025; Sat, 26 Feb 2022
 08:52:28 +0000
Subject: Re: [PATCH net-next v3 2/4] net: tap: track dropped skb via
 kfree_skb_reason()
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-3-dongli.zhang@oracle.com>
 <cac945fa-ec67-4bbf-8893-323adf0836d8@gmail.com>
 <235632dd-ca7c-0a08-3313-1c9603807d93@oracle.com>
Message-ID: <8f93148e-2c9d-3c31-38b1-6d1ae2f0d434@oracle.com>
Date:   Sat, 26 Feb 2022 00:52:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <235632dd-ca7c-0a08-3313-1c9603807d93@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::32) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0081e3f-129b-491f-ab58-08d9f9055150
X-MS-TrafficTypeDiagnostic: CY4PR10MB1768:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1768B1D82F3F7DC5E81213FBF03F9@CY4PR10MB1768.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A1EX2k681MUyoQgmizocAhIcoJPMiBs/daCTJtqIxBWy6ulT6JEI578BO37EhPSPx43Fjo7eLpEb0G40ioDrBcA9ELzzN5TS5ukVSJyJ9bAKWY0HJbH209Gm7CtZzLiGHQlrhjNZQWixwS2IS0PNZaXLJmOvFF2J1tEG7MmXxTRl7JEhxDc+Y5C74USz2vwGeoP1SkwTxbOUg30EmVGXYuf3uYXo1OUCJ1SSXIR2j9JcLAbe1d7ff5tgeRx2YEMl9Ru0XktpgIf8CUEC80IElVaC2gdvT/C6e8UbjvTUf1ah7jqOFxwbQIIEwCyQllGGSnW+sCoxjC8uUo3TMKawEHPHg5B7tNiTh7sO7QOEWTFSMyLLhYrGKhIo+NzUKwnxT8X0rr6rQgxuuHERlNm2SIf69bqmHSSpUoeom37VnxajSR1bEnJXg9xRMAAYs3D+HAyHSpxBnTmv40g94Z4+em+l1Iqep+0ev+5LxiXWFPYKHEDBjJzFOE7A/6wLHct/ge4H+ZZkJCk8s4lg/OlXhtcxF+50PXN+gM8qlfc69WFLcpUlWyJztABtbpDGWHjMlMbNPMVbavZQ9s01PstbkUYZe3ilZDYm54TCeaYemo9E1UBtP9Ds3neGJGQG4i0kCuOiQJcOZk3MPWDBhASX3cyJ1F/vDcnAzealNb76kbF5vV284W1qErvt83+C4qcf2R/90RmOkAcB2zXowZUqgryPyLBYdLvWrUbbVwUQDWTjJ6FHKrcoMXMsFjFovnNL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(6512007)(53546011)(6666004)(6506007)(186003)(5660300002)(86362001)(8936002)(44832011)(31696002)(7416002)(2616005)(2906002)(8676002)(66476007)(66556008)(83380400001)(66946007)(38100700002)(4326008)(6486002)(508600001)(31686004)(36756003)(87944003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0U4YmlkTy9oSFVaZ0dyUXEvRVJxU3RGY1lsMFN4WUhiSGFXQThhUnRRK0RJ?=
 =?utf-8?B?NWdTbzNiWU9DaTBFd2tEMEJNRFIyNnh3MEIyMU56cDlwMmNPTno0emxFemMy?=
 =?utf-8?B?dmF2eng3S1BmUDRmK01lTFMydk0wUXVPQXU4SDhrdDdxOXdMTnhCdyszMy9Q?=
 =?utf-8?B?cU43Qi9BeUpxS0RsUGlld3NMdkl2ZmE4OEdEbFU2UHJsdHE5azB2cTlzOEwx?=
 =?utf-8?B?YWJsV2xLSTJuSG1taXN3ZmNUekVyUXN0L1plbGdYT25HL2lHZFY4L3FLbDAv?=
 =?utf-8?B?RFVkWHpZaW1tVWtYQ2pwNjRKWEYrRHpMQ0lWTldaR2VCWC9ZNTEvWHZKWkxz?=
 =?utf-8?B?TWp4NU56a3FXMG4zbExFQ2pZaTlHWUFqT1hUZ1M5VGhkYWx0dE5pZ041QWRv?=
 =?utf-8?B?T1ZUc05Mc1ZncC9vTG1WSUhhRXRHTWxpOTlmNVdSeWpSeStBZDZ1NHhLNEtS?=
 =?utf-8?B?THV6YmFrYXlERkx0Z2hMOEpEL2tNNEhIUG1jTkNxMVdCTGVzOU1jQjByM2dy?=
 =?utf-8?B?RGZLVnN6eGNaUDdwVGhaWTVtVU95UE5HQmdEb2d6dzI0cCtkeGxKMzUrazNV?=
 =?utf-8?B?RWR3cENQOFZSOGQ0ajgwR1lZTldBR2h6THFJc2pQaEEya1dYNmVOMUhYYXJ5?=
 =?utf-8?B?OHZmaU0zQWRwSFhVd2dKT0hGdXRPWkVTcGFsREwxZmxaVjYvTXBZNW5LTHZ5?=
 =?utf-8?B?Mnc5U0xlYWJwU1dtYStpMjZ0alNOTEdmYUgrbVE5NXNKd1o5RXRyUE1idCs3?=
 =?utf-8?B?NzFyVVBFMVpwNXJpcGk4c2VRdEg4M3BKUVI1ZTJKUFNYTW5tajB6OVB6bVpt?=
 =?utf-8?B?ZDlvSHZ3MVVKcWpOcXNBMTh5MFdlRHkyaks4Z0RNaFQxZDRPbWRtUVdRVUJ3?=
 =?utf-8?B?THFBQSs5dWJISDZjZ3dFMm5zSGpudnJ5bmhacUNFbmlMMU1FOHF3VGhOWFZC?=
 =?utf-8?B?NjViOS8wSERPMkRzSE9qRUs1bDJPTzZtcG4yZzAwUHlmRzR4OEZ1UTc0ajdQ?=
 =?utf-8?B?UkczU2swZFlTaG5sa1RjTTVjV0orQS90VXJIcFlSWGhBbVBZMWxWSDcxdzlI?=
 =?utf-8?B?TjRKRnNtQ1hzNlVkRE9PeWxyUFJQMVlzN1RwOGNkQVdDU0JxR0xqaXNXaEdT?=
 =?utf-8?B?Zko2TUFmR2d6VXh5aU9tMHRyMDlDWENod0NsREIwckdyK1o3c2tNTGdzbSsr?=
 =?utf-8?B?TXEyY3JubExUMTB6aHdWMFp2TFd5Rm94bVd3ZWp5WGxaQnV6Z3U1V3oyTlky?=
 =?utf-8?B?UWlRYnVORXJMc2pITmtiZ09FaUdFekJUbWF5bjRCempudENMWTl3SDR3V1g5?=
 =?utf-8?B?eTJUbjhBMXBUeUlIdXEyamtkSEdnMDVHTk56MDNwZUJPRkk4ZXhRSnh6V3E3?=
 =?utf-8?B?SU5RYVBWb1BkZzZOdVBNbzRnTVNITnh5UEpnZjVsQVhIS3FoU1dQZHZDSFB2?=
 =?utf-8?B?Q0RINkZuNkorWnRjbUVMQTB1N1gvdURNRTFSTWhuY1I1aGFjUXR6a2hNQ3dR?=
 =?utf-8?B?S1F1WXZsY1paSHRuamxYT29NTUhLakhUNjYybkFDQi9yZTFCRDBLY0djNDZy?=
 =?utf-8?B?RW80eEpzYVkzbUhYRElIUFAzdkRHVjhZRmFnVXRoNkk3MTJYU0NleVZ4RkQw?=
 =?utf-8?B?elhJMHZhSmlKNE51ZGpwSjdaSGFxTGU5UHE4S3FVc3dRTTdaZzRIbTduQWd1?=
 =?utf-8?B?UnF3aVpsNVB6Qzd2N1ArVUhDK0hlamRUdVd3RlZVSTBQK2hBRW9jSHArYlVW?=
 =?utf-8?B?WDlqNjlNeEdWSHd1STVmSHZDeGhZZWN5QXFOZ0hydXUwZTJOaVlrQUR4NWt4?=
 =?utf-8?B?ek9IbE93dWFMODFnU2hneDAxbzVkTWNEeDFxNHl2MlpMdDNzdEgxYko1T3JK?=
 =?utf-8?B?VktqMGJwaC9SUXNPT2VpdSsxWkEzTjFnQ0x0cng3SFVVci9qNkRJdHJlSUZK?=
 =?utf-8?B?ZXY4U0N6Tm9wSE5KbHlSdno1MlVrMWsya3VNaStBOTUyeFdid0IxUVpwQk1D?=
 =?utf-8?B?dy9sc0tiQUw5ODdaNWdMK1pQYlN6aUNEWnVaaEFpeWF6aFZ4bGZRdXlVYUJu?=
 =?utf-8?B?RXROaU53a3hmd2pCc043cWFTV3Ric0Z3eUpsajJSeENlc2pCdjZZMm1wZVJ4?=
 =?utf-8?B?L1VYUllYWmJvWHNQbExwSzFtVXpqM3hQSzlYRkZqR3pkVmVhei9UNnNGckl4?=
 =?utf-8?Q?RnKkZQWcGTdyFtRhjub+iCG64UH87OV1uPKRXnR3Ajkh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0081e3f-129b-491f-ab58-08d9f9055150
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2022 08:52:28.6060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9a4i5AFNXIPa1WChbB1pFzPytJGk3cKkoedYI9l1aBw/YDppEelYxxAdrGusg6+tCFVWGzc9wzDkcW/gTUiDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1768
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10269 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202260060
X-Proofpoint-GUID: TaYKiZipStF2uePPHvesQsdQWx3h01v6
X-Proofpoint-ORIG-GUID: TaYKiZipStF2uePPHvesQsdQWx3h01v6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/22 8:31 PM, Dongli Zhang wrote:
> Hi David,
> 
> On 2/21/22 7:24 PM, David Ahern wrote:
>> On 2/20/22 10:34 PM, Dongli Zhang wrote:
>>> The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
>>> the interface to forward the skb from TAP to vhost-net/virtio-net.
>>>
>>> However, there are many "goto drop" in the TAP driver. Therefore, the
>>> kfree_skb_reason() is involved at each "goto drop" to help userspace
>>> ftrace/ebpf to track the reason for the loss of packets.
>>>
>>> The below reasons are introduced:
>>>
>>> - SKB_DROP_REASON_SKB_CSUM
>>> - SKB_DROP_REASON_SKB_COPY_DATA
>>> - SKB_DROP_REASON_SKB_GSO_SEG
>>> - SKB_DROP_REASON_DEV_HDR
>>> - SKB_DROP_REASON_FULL_RING
>>>
>>> Cc: Joao Martins <joao.m.martins@oracle.com>
>>> Cc: Joe Jin <joe.jin@oracle.com>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>> Changed since v1:
>>>   - revise the reason name
>>> Changed since v2:
>>>   - declare drop_reason as type "enum skb_drop_reason"
>>>   - handle the drop in skb_list_walk_safe() case
>>>
>>>  drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
>>>  include/linux/skbuff.h     |  9 +++++++++
>>>  include/trace/events/skb.h |  5 +++++
>>>  3 files changed, 39 insertions(+), 10 deletions(-)
>>>
>>
>> couple of places where the new reason should be in reverse xmas order;
>> logic wise:
>>
>> Reviewed-by: David Ahern <dsahern@kernel.org>
>>
> 
> I will re-order the reasons in the same patch and re-send with your Reviewed-by
> in the next version.
> 

I have sent out v4 and I finally decide to not re-order reasons for this patch
as this may makes trouble for backport.

I will not follow the reverse xmas order here, as all existing variables are not
declared in reverse xmas order.

Thank you very much!

Dongli Zhang
