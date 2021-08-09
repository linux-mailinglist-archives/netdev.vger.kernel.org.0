Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846A83E4F63
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbhHIWj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:39:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37998 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234667AbhHIWjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 18:39:25 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179MXYl2002772;
        Mon, 9 Aug 2021 22:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/CQLf0byCwfWfIOhzxJExSyRMDH1gXRSCLAztnXOiH0=;
 b=OosESy4kEQ0GcgJ5Bx4Nv/rY3hwMSncERLOjHvMRx3LpGBYtrM4K/FH48Y8hEczwCGDf
 W0gkLY7JKHXYMDM7KLFavIBmHVUGF77SOs7L3A4oq1JApO6gIvCQP9xYx5MLadUvB0zQ
 RsIpMJzCiYyV4MvgsJs6IpftObtd9YdyO3Hdzet3uhSF8m0H9z8GuhTp1+/BvqRXfeu3
 Oym26Q2j2KRwwFBcSo584RCvFExetOQaVfdNQsJTuNgfoDTByY6ZYZew2umIgmibUgjt
 wS1J6jb/ThWwjC0Ga+OW7BBlTmgW6DGOWQjZSnJomNozRnZZ3FDyOGkjzVyjl3UcGgY/ lA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/CQLf0byCwfWfIOhzxJExSyRMDH1gXRSCLAztnXOiH0=;
 b=VvS/zuEhis8Xt4HJ3+xZ5VYWR1YkHXJOc4reRw87kwWaRZFDxdEBdfZwpmvFwK1OqSLF
 xJrNxdkYAa4hGOwnpY0RxQOqYwQ+croGiB04Ndnqopn14GvnzyAcBrr1OhIrCzJ1+U+v
 992NnoeR/BYTuXJs+Lwg6IckWjnvIHGsI2ljNFv+aLSyiCJ/Znz193ELf5CyZvOYy25J
 n93LBpDVsW8hKdmdEPgr6MaxtkFzs1f7oW8VnnOigcOdUPHccU6AQIsMggaqpffZfIen
 ZyWM4OIlH9ueB5L0b3+pgGDp5pndN6lwGqITvFyan5K2lyllqckHKGfi0DVO/2YO25MI Ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aav18jfya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 22:38:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179MaLuL183702;
        Mon, 9 Aug 2021 22:38:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3020.oracle.com with ESMTP id 3a9vv3pbvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 22:38:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHj6w4VFGt1DhiUUxzzx9zWgxZOHpCiA1E01IA9+MncLIgvUHqGw4oarOFlrNqMIcdFaVENpnRTHK1SS2ChsX1eDV6hxH91xv4+PBVn3cRFh7wh3u7wObPkmet/rJCn+27TENNBAvXTS51uJ7SjufpHhoNtYOvEbifZohpqZdpKy1iF7HJYkVFKkzVgdV3FObMSdcajRbTVh+3WZQGO+mMdzek27RJJ0GulOV7+dpro7K6r/W6YnAitY4MyCteglJOR8VubvN+ON0bUx2k1vvGTOY4AbWbWC6WUHIaYTdX08/k/4lwKsu3Y4Y7FkY47u+5iwt7NF90qxrxCQv64BHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CQLf0byCwfWfIOhzxJExSyRMDH1gXRSCLAztnXOiH0=;
 b=MSgPmTA9KRBCFmEnJvhUn08+NhM0P68ddoeUBNLpX8iN43gPN5RWZlhs2mzEbHhMjY9s+pukf6ymuwY8NF2s1WQEJRonjwm7ya7LIk+BbjA8o7dxlEK8l2FougoabOj++neX8TcjZFu6hresFrgYsgF4+9wIh5ROQFphtqFsWvd1xfn5+DKw5psJoDOwC8oEmSxcmCBT7ZHIOuiFFzH8GZwTbUDehoHFtbhHot4b88MaCMxWpCyHWvFWL7Obn/tZtlxY+CBnJH/3aiXy/MrNUastMeTJhJKrzg/hs7Zx0TYwvVw9otA3vJ6Nzimw6jVVSd/IyDT/UvR/qSYQk1a9QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CQLf0byCwfWfIOhzxJExSyRMDH1gXRSCLAztnXOiH0=;
 b=VMUz5OUKl4MDnZZgZL0R+jfV4WQcP893YTLJFyq0mkbFtlUE+tK9U5V/LwjVrowJ9HdO4q1alFPO9SwKvnkBhIFcnkIB3Q1w1D42+l+AkOsDsHFBO9XHr/4RDehs7j8/VHhp5TGEGcJWyFB8qGWwtFaUUR7CGDGqm3jlvU5FztU=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3269.namprd10.prod.outlook.com (2603:10b6:a03:155::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 22:38:32 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 22:38:32 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <YRGKWP7/n7+st7Ko@zeniv-ca.linux.org.uk>
 <YRGNIduUvw/kCLIU@zeniv-ca.linux.org.uk>
 <c1ec22f6-ed3b-fe70-2c7e-38a534f01d2b@oracle.com>
 <YRGg/yTXTAL/1whP@zeniv-ca.linux.org.uk>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <bc2dfe6e-a8b0-dd1f-fc83-77f41fca60f5@oracle.com>
Date:   Mon, 9 Aug 2021 15:38:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YRGg/yTXTAL/1whP@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::21) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SJ0PR03CA0016.namprd03.prod.outlook.com (2603:10b6:a03:33a::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Mon, 9 Aug 2021 22:38:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67836af4-8285-41ed-4612-08d95b866ab7
X-MS-TrafficTypeDiagnostic: BYAPR10MB3269:
X-Microsoft-Antispam-PRVS: <BYAPR10MB326955D8BE1C8218D73BCF7DEFF69@BYAPR10MB3269.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:146;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRSG20EGEFUY31l+q5BNqSGxNG1OM4DBwTASV+kbRrKEy+Bgox+ABSgDgsxVa8Yc2EXz/2ebvjjVLgz+lQyBeWDz5SpJBUYbMgJjFtn/HvSmQ3dK648dwSHSqRvzSLATb9GQdEbVJjROp0mULHcnUNvIJ5htGZsr8qEze9Vnmu1Ld82lW1kjW6rts4zGaP3pfJDDyNw73dmTG7YqN2A3QpvXstYONeJcSpVe59fK71cnfSt39rYQKeTl4t54oFkB7uvEUsPX01XWbm0lF64Cu5dOCmyn3y+dKPaft3o/SgncsA6sF+kdXXAAjYdJQjNtcz/HQLmLlVQAZ4/9R2kRqge7m3KnkXj7zsHZ0iCOFf0JOiSeVaeGTaIChSEFLTrYxBCywXHPgsR2TZ9x7crsfpSw+fYYvXICbrA3j5ZiBtGiR7x/DdMPs6rvstG2NcoS5yfpruLPOoXiALdh9zSWe9My1ZiRuuJllSMFQUWG5rg1bOpafO3nbMvZjBNbmzHEfKRyXNYv8VvVL5ctOZck4QIK3jvhNM3qX+J1t1VCKtPDokRLeX18JI+u6FmcX6pZqs0eDB42NFhglrXkUrLmcZLkoc3Ldhm4nepp6ajIPXeCwa1hNAWBNifYk+OklOC1dHFDulzgXcO7Yln/X5sjJ9v0llRa8Ywf+3JIse5uKRIhXI/vJKJDkEBv+s49SwIpl1JZuquyF5L2zaIpPwEhzppDotZKMIYzW+srysvvCbnz66z6M2gGY8qH9eot4pfp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(7416002)(478600001)(53546011)(31696002)(5660300002)(8676002)(6916009)(66946007)(2906002)(2616005)(83380400001)(66476007)(66556008)(4326008)(31686004)(316002)(8936002)(86362001)(54906003)(186003)(38100700002)(6486002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFUxbU5XQWJVNlg0MXVCVStMcDkwMWU3TnJGZUQrcENhZmVyenNXdWtGa251?=
 =?utf-8?B?cUNmaUgzQnVoNjF0ejVYUllTdUs1eGpaK3NqNGcvdWJLOTY1WmNLTkg5aFFX?=
 =?utf-8?B?NzV3Tm1OOVZMZTQwUU9JOHVoUWs0RFE0Vkw4N1lUaGp2cFhxZjB3NDNWUVdD?=
 =?utf-8?B?RnNzUnMrT0gxc2RMUElxVTMra0x3bHVaV2VWR29sNzRBcmxaYzBFYm5SWkJv?=
 =?utf-8?B?R3VRT1NESFZEaGp5eWp0M3FmeGRzbTlRdWVlSHZnTTE0ZXd2dGdneWd0cnVP?=
 =?utf-8?B?aU5LWk9QcjNwL01VNVRrRUphMEYxZ0lpZ095Vjd5ejlQbVVWWHlsTExaSGdn?=
 =?utf-8?B?VEJHVFlZWFVwcDFmMFdiaXE0dEtIR3BwRkdRbVk2R2N2Tnc3TSthL1pZR0Fh?=
 =?utf-8?B?VkUxaEozRm8wUnExcmlhblU3RVBDZVdpZnBOZmliWEFvNWFCWG1SQ25RZkF5?=
 =?utf-8?B?Z1RtSDJSbEJGRFFrdGNHeEpma0h4cDNRWCsxUFcrUDMxdXBVNm9naEwrbU5S?=
 =?utf-8?B?ekJwRVhPelNiaXgwUUNUbldhSEhyTndnTy9ibklFWUN3NkZHbjBwUjhVRzNq?=
 =?utf-8?B?VXd6Y2x1U2pjRTJLKzIzUU5TWHR5MktSS3YzQ212TXVzUENQTGdEdkMzR3lZ?=
 =?utf-8?B?UG1pUDE1WkNsQ1lvR0F5blN5Vk1zK3d3MDJBSGlCTFJtQ015emRWSzVEOC94?=
 =?utf-8?B?RWd4Mmp3MXBCSHdOUFdYNml4Vm5vSmpoL0lhdzVwdzlJRlliVVdjcEVuK2Y0?=
 =?utf-8?B?eDVKRUFDampiUE9iZnd5RUdYUGdydVhtSmUxWTdaelJyT3ZHblZWZGpWTkxz?=
 =?utf-8?B?MmIwOHA1MVE1QzNLSlZMTGFVWTZIM2JocXVmeWZEZ2pPSU40bXNwdDd2d1h6?=
 =?utf-8?B?dWlCTXc1bXliVVljNG1LOUQvb1RoQVVBZW82Nk5KVGFFRW1xUzFJV3lvcjB4?=
 =?utf-8?B?ZTR2dk9VUm5YYTMxTzVYUHcxWEttcEY5YWJBbUtKdGs5cFJOUWIwUSt2b0ky?=
 =?utf-8?B?cHJPV1BLQ1ZPQVVGM0FUWnZndUxmczBmM205VEU1N20yUG9WS2JFQkhWb0Rp?=
 =?utf-8?B?dWw4RkV3VHNZMHh3Z0NORDhIcHRBbTNkSUZySXZxR2t2Y3JzNmxlZFVvTUR5?=
 =?utf-8?B?RDQ1QTNzRFAvNTB0SVN6WEgvRGtZSTUwWml3Mm9KbHc5VGI0WTBsSytvdUZZ?=
 =?utf-8?B?eEdZdWRwSHNyRU1qdW53Rlcwb3BOc0VNYVZpQnFTQkR6amhHS1VaTjA5bjlE?=
 =?utf-8?B?QTdQY3RXT1RnTXA5dy83Y01GYWYrcURrVnNESllUcWM3SkdLZC9OU21CUmlH?=
 =?utf-8?B?Z24vNWhOYjRDelhMT3Q4UDl4WFZGSjNHbUdzRlMxR2oyOE9od1pKOTM5SzFN?=
 =?utf-8?B?OEFGU2gzdHRkRWZlb0JhRnlKSnVCcXBEQVlEcFJLUGpPNityVDJYOThSb0pL?=
 =?utf-8?B?aDMzNFZMKy8xa0c2bnowM2VyUFZwdjdBa0JjU0RQeHgrWlJDb0Rnajk5NlJQ?=
 =?utf-8?B?RmpCUHJoL21pUjFJd0tGT0VmWm9LZERsMVNOaVBud0FZb1IyVlhZN0o0RitP?=
 =?utf-8?B?WHlhSHQ4bGlyKzJzQ09zdUthQzduVmJXS0tva29sWWpvZFNIOHM0akxkQ3Z0?=
 =?utf-8?B?YVN4ZHV0TkhSUit3dDlMY1I1UmJqN3lZb3JXQTJweTJod1FiY2ZBcEx2ZkZE?=
 =?utf-8?B?MVBGdkp1UWpJVUVwa05UWU5HRHA4QVY0MEFjL3pYbEJVWFhoTW5vY0RjRSsy?=
 =?utf-8?B?czdJKzRTSzRiVnlXRzY0ZTZHeXU0dERWVWlTUUVJMHpQalZ1QklyM2JCemRk?=
 =?utf-8?Q?XWdbFT0WGEWi9h9r+cy0Jpr+KtsnTUnyag3Tc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67836af4-8285-41ed-4612-08d95b866ab7
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 22:38:32.5330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TtcsVkq3q0J4SVVfALuukHAqWpQhpvK47uKempXBZ0/zkvRU0+5NWYZChR/R5MNeUg7nJw5vVuraHFBNkJUTTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3269
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090159
X-Proofpoint-ORIG-GUID: m4XFGSSE5GcxlKD6ORgVufA9l2quTTaa
X-Proofpoint-GUID: m4XFGSSE5GcxlKD6ORgVufA9l2quTTaa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/9/21 2:41 PM, Al Viro wrote:
> On Mon, Aug 09, 2021 at 01:37:08PM -0700, Shoaib Rao wrote:
>
>>> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>>> +               mutex_lock(&u->iolock);
>>> +               unix_state_lock(sk);
>>> +
>>> +               err = unix_stream_recv_urg(state);
>>> +
>>> +               unix_state_unlock(sk);
>>> +               mutex_unlock(&u->iolock);
>>> +#endif
>>>
>>> is 100% broken, since you *are* attempting to copy data to userland between
>>> spin_lock(&unix_sk(s)->lock) and spin_unlock(&unix_sk(s)->lock).
>> Yes, but why are we calling it unix_state_lock() why not
>> unix_state_spinlock() ?
> We'd never bothered with such naming conventions; keep in mind that
> locking rules can and do change from time to time, and encoding the
> nature of locking primitive into the name would result in tons of
> noise.
Rules/Order and Semantics can change, but naming IMHO helps out a lot. 
There are certain OS's where spinlocks only spin for a bit after that 
they block. However, they still are called spinlocks.
>
>> I have tons of experience doing kernel coding and you can never ever cover
>> everything, that is why I wanted to root cause the issue instead of just
>> turning off the check.
>>
>> Imagine you or Eric make a mistake and break the kernel, how would you guys
>> feel if I were to write a similar email?
> Moderately embarrassed, at a guess, but what would that have to do with
> somebody pointing the bug out?  Bonehead mistakes happen, they are embarrassing
> no matter who catches them - trust me, it's no less unpleasant when you end
> up being one who finds your own bug months after it went into the tree.  Been
> there, done that...
>
> Since you asked, as far as my reactions normally go:
> 	* I made a mistake that ended up screwing people over => can be
> hideously embarrassing, no matter what.  No cause for that in your case,
> AFAICS - it hadn't even gone into mainline yet.
> 	* I made a dumb mistake that got caught (again, doesn't matter
> by whom) => unpleasant; shit happens (does it ever), but that's not
> a tragedy.  Ought to look for the ways to catch the same kind of mistakes
> and see if I have stepped into the same problem anywhere else - often
> enough the blind spots strike more than once.  If the method of catching
> the same kind of crap ends up being something like 'grep for <pattern>,
> manually check the instances to weed out the false positive'... might
> be worth running over the tree; often enough the blind spots are shared.
> Would be partially applicable in your case ("if using an unfamiliar locking
> helper, check what it does"), but not easily greppable.
> 	* I kept looking at bug report, missing the relevant indicators
> despite the increasingly direct references to those by other people =>
> mildly embarrassing (possibly more than mildly, if that persists for long).
> Ought to get some coffee, wake up properly (if applicable, that is) and make
> notes for myself re what to watch out for.  Partially applicable here;
> I'm no telepath, but at a guess you missed the list of locks in the report
> _and_ missed repeated references to some spinlock being involved.
> Since the call chain had not (AFAICS) been missed, the question
> "which spinlock do they keep blathering about?" wouldn't have been hard.
> Might be useful to make note of, for the next time you have to deal with
> such reports.
> 	* Somebody starts asking whether I bloody understand something
> trivial => figure out what does that have to do with the situation at
> hand, reply with the description of what I'd missed (again, quite possibly
> the answer will be "enough coffee") and move on to figuring out how to
> fix the damn bug.  Not exactly applicable here - the closest I can see
> is Eric's question regarding the difference between mutex and spinlock.
> In similar situation I'd go with something along the lines of "Sorry,
> hadn't spotted the spinlock in question"; your reply had been a bit
> more combative than that, but that's a matter of taste.  None of my
> postings would fit into that class, AFAICS...
> 	* Somebody explains (in painful details) what's wrong with the
> code => more or less the same as above, only with less temptation (for
> me) to get defensive.  Reactions vary - some folks find it more offensive
> than the previous one, but essentially it's the same thing.
>
> 	The above describes my reactions, in case it's not obvious -
> I'm not saying that everyone should react the same way, but you've
> asked how would I (or Eric) react in such-and-such case.  And I can't
> speak for Eric, obviously...

Al,

I really appreciate the time you have taken to write the email. I agree 
with what you have stated 99%. My displeasure is with the fact that when 
I asked what conditions trigger this error (not familiar with the 
checker), no one replied. As I said in the emails, I did suspect the 
locks but did not have time to look at the definition, your email 
arrived as I was looking at the definition. It would have been better 
and polite to say, are you sure you are not holding a spinlock? Would 
that not solve the issue? Why do we have to always assume that the other 
person is not knowledgeable and inferior to us.

Is there any documentation that lists possible reasons when the checker 
points to an error?

Thanks again for the email.

Regards,

Shoaib


