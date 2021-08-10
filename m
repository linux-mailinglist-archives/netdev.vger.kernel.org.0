Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386043E80E6
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbhHJRx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:53:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51510 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233214AbhHJRvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 13:51:23 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17AHg3mR007895;
        Tue, 10 Aug 2021 17:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eN2BQawkt9QNtAxQiZ79iRjmP2eTOqXfaUA7hUwDJEA=;
 b=udAdIoz1TrhI/DLmsBi7qPTw8P3keFfWwaZt8T3c7itDv15TDCT6etooVcGvODFhOK17
 Br1tZxmSiJ4ztlGnH0yP5/3WL5MNCSwWrJDToHTr6HSsoaIpvWgzmCPLlfb06l0/fn85
 REvPk8u3CNRtA2wwg29zD5Rvmp7jLOh8ncr7/KYOEvLNk0EEXnYmVKuWPFlEqYj1TP4n
 GGcWT+C45+tKrO2L/TRaQ0wPeYy5O8dw++NFW+smx1TB3n1lkFI0xGL+PfWZNoFXISgo
 cYqDmAu/DqfzbG/xC/AafnddFvzFeBfRHhHhFV0hW3EctvQw5QPtqFBmCNPGUK5LfPCo dw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eN2BQawkt9QNtAxQiZ79iRjmP2eTOqXfaUA7hUwDJEA=;
 b=XozoLAVIaeOqbS0zsUV5O1XdeK1MyxFtyXlEpy/Yza3eGNkl55MpgeWly29F/29B1L5L
 Hx2beGi14acDQZzNBaonCw0GSO20pfdms08cgz2hSjvfG7+1DbWXWj/ff7Ys3eQOVZOp
 Cy8mfazdI4D+PC5UTiegAlndXqlZ2BmXHAFvgTNPUhjF7fxr7MYbJeOAmoXDEv7xy4z2
 RW5a6pilxJ8qoQlksARF9jq+/Rf6UM+0kitiqxPIWadbOt/AQHMazQj0O9Ek+lf0gp+W
 MrqhTF6sKhNOPWsEz65bwDz4IxROfkDEJg4l898HO27QiuJYasZM3Iff7TCh775l+TgX Xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fvhwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 17:50:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17AHoTQA165548;
        Tue, 10 Aug 2021 17:50:34 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3030.oracle.com with ESMTP id 3abx3u8d5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 17:50:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGFEmKxks6HpeueyZFgpcDUiH1Gvi9x2jau/Dp0dP5ZeLnMiWVPsBA+D1m1O5pRqwg92a/WslGnk2VQs17yaRftBnJhT8ltsZrSdF5BtEZifpovVBiv/bKQmHFSnxAwLhoeR5vYExtBnBeHdLqsfbmhFX36q+yq153f0HUyPi8LMOuUWDMpAkyfU/fvjYo1jLGgHB1y0YfrpLGAMqCjETa+X3O1hiiywU72pDPAcjPXdup/HdQU4QhVdGbEyQ7NJES0/i2VRQcp+7xBzaZqjrGh5Vgu2meEho2I0SL3gtl9VYcMO36prwkWPmp9I1HdOJph7rqthazueMeo/aNEfaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eN2BQawkt9QNtAxQiZ79iRjmP2eTOqXfaUA7hUwDJEA=;
 b=VS+iEWSbb8AoP3pvT2YG/23f9XLoVC3lF9eg1wTCtLWps1kcnXShvo2WiJq7XFo+ash5+gp1DwYn1ydzs3Sa40KRimI+WFtBo2BdYwYO1nI4PRT/xMZGCjRjxBYcNVdfh32dGmE/fkh/joTpWcS65Ta7W0Olpf9w9AHwdZ3BNHSAx909zQWyU4O4lAbaP4jIn/wo6FTHKSR/k4FV4UnsvvgH6Hxk1Z9YABM/rIHDK2hmM/rYNESsUugScLrEvBES4GrnjEniaoOq0gfagMLyGafWpmEwJaR2rCYZhnGkYXkZnCyV/G9DvYQumauPEya1GTYj2vnlb9520tOqdk3r0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eN2BQawkt9QNtAxQiZ79iRjmP2eTOqXfaUA7hUwDJEA=;
 b=oS0Aj9yO/NV0L4oyCsi84sl4HBa8fDjkPQQ08E/cw7QOvdNA0j/YotnqmMmYLtrhluzS0HJ4bRiHCLb376az5DDqbxc+ggTH2HUFsNTDIB2bOc3l9aF0sRLhs4GG4QE0JX/Rf40/vt33jP1O5qgdvCZfgDcTgpYtaQV8Fcx5ecM=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB2710.namprd10.prod.outlook.com (2603:10b6:a02:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 17:50:31 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 17:50:31 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        jamorris@linux.microsoft.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Yonghong Song <yhs@fb.com>
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <CANn89iKcSvJ5U37q1Jz2gVYxVS=_ydNmDuTRZuAW=YvB+jGChg@mail.gmail.com>
 <CANn89iKqv4Ca8A1DmQsjvOqKvgay3-5j9gKPJKwRkwtUkmETYg@mail.gmail.com>
 <ca6a188a-6ce4-782b-9700-9ae4ac03f83e@oracle.com>
 <66417ce5-a0f0-9012-6c2e-7c8f1b161cff@gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <583beba4-2595-5f4c-49a8-f8d999f0ebe7@oracle.com>
Date:   Tue, 10 Aug 2021 10:50:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <66417ce5-a0f0-9012-6c2e-7c8f1b161cff@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: BYAPR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:a03:100::15) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.7] (73.170.87.114) by BYAPR08CA0002.namprd08.prod.outlook.com (2603:10b6:a03:100::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Tue, 10 Aug 2021 17:50:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73f2a6a9-e083-49d3-10ac-08d95c2758c8
X-MS-TrafficTypeDiagnostic: BYAPR10MB2710:
X-Microsoft-Antispam-PRVS: <BYAPR10MB27107546AC2B2904D05B262DEFF79@BYAPR10MB2710.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FMlGVoTw2+rmHu7fz7DlVLjumNsBdsz+S8XK8cBjpITtJFPVneSdcy1DrcCS6fCJWdMLNgh+jLmHP14nYLFHuGJruS5fG86JYV+1B0RD/1obbKNqA3lAs+hHLN9TkJiN39NSXK21BUYAc+B+/F48Cm1ZL9xoV7zvvvzTL2gtbjnpsAZj68581FoCStSqDhMkX6/Job41FjqdjAjc4aY/GUb8FHIm81RwgnUKkO0f0w/4ErGNaykVXGykK9f6sfdaYTv+vXNF0zl6l/rFexoewDwK5uDG2pb4fYfMC0+kZ1hRKucu9Hn7EldU6msrEsVaRJjX7hefNg7sgHiFe7aEHxNCRBD0EpGmvKc8PBqlgYryML7fwjgptBWSphbOK59pvaH7eQGeRNXn6A8Lxj0SMVWgXRYQKOsOUANfvZy+2W/LYBkQIm3Yyau+e+Ut+Fv3Ws/LqchvCeql2q3g1XAP16uqHBUyaUJCmmJnhcQo3xMykW1T2kqXzT1vrCKDM8Q2zhQTbzjzb9HdWxNk+cMT2/RapyrLkDLsf32aPEJ3fru5Y6izPs0Vf/QP9iC+b139Xh21oaokOKhnFUiMzIMLC1vkzWiItMg828LO/VyphmriJ4lcDOBkXKJ3mS0ITvF/ab35czEZaUmn/9VgyDM46hKaFMW9k2K7SKGE03t0F/Pm+D8fn0koXanNXaDTLqqfYOjPirlgvDrydD0SmBqPKaHXIjDZtX/LEv9qM5DlIM4huVg5caY921QTgpAROwEu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(346002)(39860400002)(396003)(376002)(4326008)(8676002)(2906002)(86362001)(110136005)(54906003)(316002)(16576012)(6486002)(478600001)(26005)(7416002)(5660300002)(66946007)(53546011)(83380400001)(956004)(8936002)(31696002)(2616005)(4744005)(66476007)(66556008)(38100700002)(31686004)(186003)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2xuUnRnZnVjVVFBVGFTMW9tbjRFcnBoMEtpamdXdnNVU1hIQjk0NkpUbGNw?=
 =?utf-8?B?YnFveU01Q3F1Sjd2TEhJTzI5V0taMDhWR1FuVFdKcE93d2dNVm81Zmk0Ympr?=
 =?utf-8?B?R3g3UG82LzRacC91UlFlaEpMc2MrMWx5TWt4bzY5cnQzY1F6QTRsRmRCOWFx?=
 =?utf-8?B?RXJ3WVJRWHVab0FOY0RBOEdxVlMrVHRybE1Gb0szcmhEMTREdk1lVnVmVTM3?=
 =?utf-8?B?Ny8rNk9RSzI4K1RteXZpUjB1Q3Jlc3Yzd3hTR3dicGpFZ3hwdlNGS1RYNUtC?=
 =?utf-8?B?WVFDMis4L2ZuTFErbE13UzkzWDN4VVphRnNDbS9peDVwN1ZZVnhKRzYwTE5J?=
 =?utf-8?B?ZGU4RFI1MnQ0K05HYnMzRnhndFdsQ3JpZlloQXdsMmJZVmtuNUY4bnRrcXMy?=
 =?utf-8?B?aTN5Ym9JV2s3MTRHaEdHdTJEZkhNYU1sY3A4MVJ5Y2FlM3VTaDdaa1JlajNS?=
 =?utf-8?B?aEYzT0ZQeVBXS0JqT2p2NmM4QXJVZERmMDRDcmt6STBtaFcxYWYybUJSK005?=
 =?utf-8?B?ZHNSMHlYcG5nbFAzQ3YyTzZtcTg2M3lldnhjN2VlTG9mOUpNWnRRTGIrL0Vu?=
 =?utf-8?B?NVUwbHdVTUZUOW43R1lEL3dOc2xET2c1WlBDbE5RRXBWUGtyT3BSa1RHRVYr?=
 =?utf-8?B?ZDNYQ1JBK0J0dXBsV29qbUsvcXZqVWQ5MVRicG1vYnJHOG15YzMvU2VWOFJV?=
 =?utf-8?B?MWR2OGtkQjVZQXRHVGJqZVdoejNEczVuTktLV3JmWnFoYW1mSUZZcjZaVEh5?=
 =?utf-8?B?WDQ4U0JFUmNRQnZTQnp3Tkw3YkZIb2I2djNmVWhUZ1QxVHc3a082ZVhXaWpq?=
 =?utf-8?B?YUlwQkE4TmR4N3pUZUNPeWlJMHlDcDYzVzk0ZmMrMERISUQzOFV2c3pkcHM5?=
 =?utf-8?B?TmozMEMzTGVlYzNhcWhicldDZThhSkRWck5OWW9vSmlZK21kb2crL05HU2R2?=
 =?utf-8?B?SzQ5ai9VL05CSFNPbnFMelZPVCtDODNZTUhiZUthQkhVay9mRzN0ak0wTzBa?=
 =?utf-8?B?Tm4xRnNONzlOM2pOLytuQ2ZtWW5EelZmZ2dHYWhrckZBS0dMNDlHNHlpTGJp?=
 =?utf-8?B?NFV5TzBZYllJajkyb0J5QnkyU01weUpETDNDZXNaUHZBLzhxTit4aUhscjh4?=
 =?utf-8?B?bXhuNGJFVDNwbHRvQjR4ZHY4allnZEw0ZTlaVFF5U01ndVZWRElYdGk2Mitp?=
 =?utf-8?B?S3RCV1FYM2xxd2RwVlVNbkNJaWxCL3VncUpqdUsxcjgxZ3U4UlJVeUdRZng5?=
 =?utf-8?B?WXBqVGxUczJKdmw3WWs0eUpKREF2T2tMdkV0eUo2SkNLRCtFbDJ1RTBXbXRj?=
 =?utf-8?B?TlJOdmhsRXhKWXlrcEJnMWhOVzdzamFwWkJ3Q1hPRkJsQTVPZlFDMXNtbVFq?=
 =?utf-8?B?MFB0WFAzeVFDdjZjQUNEVFhJOW1EQWwxVzNKT2FJUEt3U0FseU12VThYM21v?=
 =?utf-8?B?ZzNWblY1Rm1KK0V0THRUYUNqZERjOHp2cXdhd0JNRFN4S2FCdEhpRk8wUGpE?=
 =?utf-8?B?VXVoSmcyWUpGbDVxanptbEdTSjVwakpFQUNUYk9TUkVRSFpFck0rYTJ3ZS8r?=
 =?utf-8?B?M1pON3MvYWVGRzBOcGlnczVNdUNGbFVlZDNuYjlHZEozaXpyYUxEcnF3MTE5?=
 =?utf-8?B?SHdPc2V0V1RlTko3UmxjZ0V3THErR2lmNFYwenlwcjBBeEVCTVJUa09zT3Zl?=
 =?utf-8?B?NGJlc3l0bzd0SE5WZlNKYTFJOHVSU3cwbThKRVVuWGNjTm5Pb21Nd0wzd0RV?=
 =?utf-8?Q?7bd7gwv/rw64aF5agxDPfhCITl/zoOs3z+8K/3s?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f2a6a9-e083-49d3-10ac-08d95c2758c8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 17:50:31.3926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QMLtKrPKmIL1ykkQGajeuTphvCnptZNqyXIalM08Z8MpO584CJWqzWWFfJlmGuGHDiay0wtGQyRcsnnowbS4Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2710
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10072 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100117
X-Proofpoint-ORIG-GUID: 33pQ869YOUqEcK-ANgr5q1rD0Ia3lU23
X-Proofpoint-GUID: 33pQ869YOUqEcK-ANgr5q1rD0Ia3lU23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/10/21 2:19 AM, Eric Dumazet wrote:
>
> On 8/9/21 10:31 PM, Shoaib Rao wrote:
>> On 8/9/21 1:09 PM, Eric Dumazet wrote:
>>> I am guessing that even your test would trigger the warning,
>>> if you make sure to include CONFIG_DEBUG_ATOMIC_SLEEP=y in your kernel build.
>> Eric,
>>
>> Thanks for the pointer, have you ever over looked at something when coding?
>>
> I _think_ I was trying to help, not shaming you in any way.
How did the previous email help? I did not get any reply when I asked 
what could be the cause.
>
> My question about spinlock/mutex was not sarcastic, you authored
> 6 official linux patches, there is no evidence for linux kernel expertise.

That is no measure of someones understanding. There are other OS's as 
well. I have worked on Solaris and other *unix* OS's for over 20+ years. 
This was an oversight on my part and I apologize, but instead of 
questioning my expertise it would have been helpful to say what might 
have caused it.

Shoaib

