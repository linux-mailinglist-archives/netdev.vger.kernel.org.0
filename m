Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED6478005
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 23:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234400AbhLPWct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 17:32:49 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:62062 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhLPWcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 17:32:48 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BGLE431009316;
        Thu, 16 Dec 2021 22:32:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yi1rll4qZQQ2+09aCNDau/5zoWvCpHJo7UPBcTC+Bnc=;
 b=eIRxRkua29kDCAc+hRHmP2rbLj6WTrBwTIl8PpVWMvJP8qKDix3aOByJULU64TgTE9lA
 W8ixLPQS5A04w0JAUbDCON0rjJXvjzH2hE4ihq+iun65Ae4UJLd6RS7cp5iYcyTl5Z/m
 a2Y4pd3DOIZcBwMLW+tGf3frgByNVNr/v9MeSMHXbVHrrNTnswV/9QpvnwKhRcSq34NO
 XSGrTqyPHc9OuY8NQpCwB6zQTqEGmnhzJY9hRWnGTSekCHRA2WjCZ4zZ5Zx8F3rRdiTS
 CsyVccsNiDQ1b73bBmp4ROqRrdPXh0eV3K2qtMLpKyKHQNbZNWIkn0pGrS73azYyVmcn aw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cyknp48fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 22:32:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BGMQT7R145228;
        Thu, 16 Dec 2021 22:32:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 3cyjuajnbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Dec 2021 22:32:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDLGWQN/1garDrjJvXN48ic84HsukX+wmIuWUCAPD3UjWYd4Jgm6boaU2otiD6l8KH43uV+MWaS0h7C2swZlxJ91qv+YXBkmzlScs7q6xO0Qy8wUVQMm+JA2Is4ymA0Oe+SS91bPd28Rfp6Q2fNfVj3wcGdYGZ6zY5MfEaSghMWqa87rTDtyZ/YewHtpjSo+T9t8TggtEugS5jfgiN4ShZ/5vQlskxfn4z7kgrI1xLS7YWbUSDV4h7cLRvqRiYyd4jCB4uWfK3j45P27Dd9yu+H0khFFfUuIrF8sZPZ8FjC2XACPHjYuHHZh48d5dmOn/bxO2gU46qOQ5lUERlWyJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yi1rll4qZQQ2+09aCNDau/5zoWvCpHJo7UPBcTC+Bnc=;
 b=myjorHSDk5J9mYvPBJNGBnPOeyBo2zcES7n2N2wrhl9A1yYEDBjOMpXRY/n7hOJTJIyGZTDTuaT4toM7u6xluoLB9+4gTdAqCCxtH7QDJC3ycyMJok5CDMhv1VeQh+Xu1Zyyy/D7L7kdU6SbdxvCOWSK/1IJwQFRcdvCmVx9kkgB/Iydt2txQIfKI8E0eLl+S8YovvfBt1pZ/ksNuUML7vJreQr5U2efSCG2tFSkMbDfrhKo/Rnm/ZPOLe4hrPGdy2PsfdiQFiiU7nhdqKxeBXf5GEGZVpBauCKs4zyO89/DkT/7kuLt2PUZGRggrJW4ClvWRuWGElDt7N8ma1pteQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yi1rll4qZQQ2+09aCNDau/5zoWvCpHJo7UPBcTC+Bnc=;
 b=PmBHT0OjoWp3mXLqLsOCoXuSITt/VHuEvUZVUND4olxJ3UaeF9yK27W/WpiRs0inq9jWqNDJC1G09BXQx3QhCVXPZFJdso4DG3rl7+unv9DLetDqsX4cJ7qL5Gs+A2wuZAk3TyRwSEZ8PnWTFEQGyEOjuelIFn79df8JX2fYDy4=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4799.namprd10.prod.outlook.com (2603:10b6:a03:2ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Thu, 16 Dec
 2021 22:32:40 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 22:32:40 +0000
Message-ID: <a6ad8613-2d66-259e-55a3-42799c89dfe3@oracle.com>
Date:   Thu, 16 Dec 2021 14:32:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
 <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
 <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
 <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com>
 <20211215162917-mutt-send-email-mst@kernel.org>
 <71d2a69c-94a7-76b5-2971-570026760bf0@oracle.com>
 <CACGkMEsoMpSLX=YZmsgRQVs7+9dwon7FCDK+VOL6Nx2FYK=_pA@mail.gmail.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CACGkMEsoMpSLX=YZmsgRQVs7+9dwon7FCDK+VOL6Nx2FYK=_pA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0016.namprd11.prod.outlook.com
 (2603:10b6:806:d3::21) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 127233b1-a5bf-439d-e647-08d9c0e3f829
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4799:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4799969E94C5C3E68640BBADB1779@SJ0PR10MB4799.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCuFB8Rj8vjhcAamgj5jbSymfK6yfcDrIntwMIV5bpXMX30sV1Bba9GAJ5OiLEaP38OdAq17zLqgBtxZmX+YlVic4C/IusLDMyiAI/hcbqGY9gKaHgm7EzSE54clf6Fw5NQ28oxZSX5l6K3wEgV3w6C2l2zYgdIY69GzBxBj5q3kKd/DKl7joEv7lhV/DsoI1MLlJhZBM5x1HY+8bfC9s/jb5b6Z+6bywv7bOFIkCaRbqhmSkX6fXEJxyW2j5t2yLZ1q6iNRsQO3oL6CjyQkLQJHw8CvPWsjP3ixn09FmoypiSMVu8z8UEeLYeX3qqBBdwFz07LSNnBwi8KBuBlJ2VIqiAGynCtbQBNWo9KyTb53PJIPeaxc9WEc+G+sMkgPnvJceuOv3+w2sCxcCIYhblRKseww6FwJH24u1efv690WJVrwYDXso7kdNMPKoX+Uvw8vl2uCxYCeCqC4RsP+DiXJKbSW6n8mKa8GC8MCXvEMPZyau05t+SBJ2imsS26QcTKNpJrEOZ1BaSVo8hXjg7pecvvKcdz3fm+otbjvdBm9XeEFARGq2BjvRHwPr3UR6ynN7XKfF5kwDoy7ED6ZyDUURvoWJoU9B2Xo6IIEGDbiUpz7ugxpyqYkMh9vnyKvcRgkEWAWZgC3njq1uTkYE/yH0gtB/QP7YuCnsET40Jbk2aYBuci5J0Zz2nV0BqOMQJyP/dKTacPQgbxuc0HoGovcFN3Y7GuqFlFYrqAvOBbaG3BwfKb4h0QA5hDtcwuTrxqkAodiCb6uQSaK0EruGyuSI9Az26DepWTIvQxffMwD18y+wAWFYRpFXI+wdIvh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66556008)(966005)(6506007)(83380400001)(38100700002)(8676002)(508600001)(31696002)(6666004)(86362001)(36756003)(4326008)(2906002)(66476007)(316002)(26005)(6916009)(54906003)(31686004)(36916002)(6486002)(6512007)(186003)(53546011)(8936002)(66946007)(5660300002)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGc5ZnpBVVZOZVBHSFVyVS9kWlB4Yitpb3RWNjhQTkkxemtxdG1JeGRPSzdJ?=
 =?utf-8?B?TlBYdWZhVXZUWEZZQjhaWlNWQjJxazRTOVZuTDVvcHdLTGpoZDc3cTBNeGR5?=
 =?utf-8?B?ZzVaVlZlN29HdE9Qc2ZpMnVlUG1FU3dDcVdiTk1lU09SdWRFbWdoYzUzL1Ji?=
 =?utf-8?B?Zk4zUGtXZWRGQzRCSURxbUo2dDhOZmcranFFSlJ0VFA4a0lFU21FQit1Yzdr?=
 =?utf-8?B?LzN0dW1sZnJDamlrVkRCZkhEcU9EWmpyWE9YMGIyTjBlUjNZR2pQNEErUFNT?=
 =?utf-8?B?anRNRDFEek5MRHhOa2l3aEFJdVlDaEp1VEtQdGZuVnpCNUlnREZwWHYzbzAx?=
 =?utf-8?B?THUwOGFScnB2YVJsYk5ROXBCSVlhQzFrYm1DdWt1Q0hPYzk1aVFTbXR1SkVX?=
 =?utf-8?B?RVR0SC9ybFJCZVYzMk42YVVtc1g0SHhtVWs5UmdQZUdNMTFCUTVpSXpPV2pz?=
 =?utf-8?B?Ymw3Z1NPd2JYNllCSU5LZHJKWld1MnBmdHNiR0ZFREdWaTJ3SjhDVFhPcWJm?=
 =?utf-8?B?M0VwVkhsQXQ5Q0ZDT0wweU5MR1VjaEQvMzF0S05Xbk1CWXp5ek53SnNmczlh?=
 =?utf-8?B?WFlSSmFTLzhHM2prUjZrL1BHMUJUeWc3RkR3V1J3cXZUUVl6ZEpuelNDZGNN?=
 =?utf-8?B?MmJ5RDMza1lLUU1YN01odXdWUGczcEpGaEhKR2VrWnVmSVBTU1hjSy9ScDU4?=
 =?utf-8?B?TE5BdmZjOGc2MDNHMUM5UEtFT25xYndvNHpwbHI1UDJPcTY2bUlZQktoRXVL?=
 =?utf-8?B?dU9wU0tLcC9hcm9NK2lMVGduRWxScHZsUllMcFl0VjdCVDI1ZWpIVnpzSXlX?=
 =?utf-8?B?c0xYZjltcnFvOTJvOW42NlVnZWNiS1ZnakRYeXFtaHJlTjN0R1JudDdJNTBn?=
 =?utf-8?B?ZXE0MG1qMkhPMm4rM0tseVl4bHhmSmI4RkNrT0VkVUYwbC8xK2tCRlJ3ZEYw?=
 =?utf-8?B?T2UwUzBUTjNGN0Z0TG1JdEhlb21Dd0V1ODk2MnM4Y0NFTXQ3M0pOSjhHUVhR?=
 =?utf-8?B?S0ZQMWEvcXZobWJXMWJyTXVrRHpvTEdvaFI1ZFZpSFJkNGV6R1FUN2cxNjM2?=
 =?utf-8?B?SDFDVnhJWkFiRXFnS0owZWV6L3ViT0dJQ0wzZFJLWWYvRDluQWk2VjBOalJr?=
 =?utf-8?B?Zi9qKzgwdm1OYjdSUjVFNy9Xd2NJNjdUZFdnS2lyUE9NaC9JeTNkbDVFQjdt?=
 =?utf-8?B?SWpDaW1tVzB2T3RxUVJNNGFIQWdCK2F5bzJncTQ1T2xXZndKRVN1S09mZ3ZR?=
 =?utf-8?B?VDQzd2l2L3RPM29MMnlYL2xTMGdkRVlGdm8yQ01nbjZiWC94RGVDd1FjRVFE?=
 =?utf-8?B?RkpFLzF3MmtOM2pPNCtSYWxlSG1TVlF3SCtjZ2xBWGFZSjRRUUp4cU4xMXUw?=
 =?utf-8?B?R2MvVjg4cHlJWm9NVElPclFibm9jY3hpRTJzVGI1MlZZRTVwSW5hL0pyeFp6?=
 =?utf-8?B?RitJSllVaTBGREgvZ2VDbHdVbmZQNkwvTi9RMnozS1FtNDZMK2JHdWNrdW1Q?=
 =?utf-8?B?WUhZbFpWVjRLSk9rdDhEeDlJZWpmaVA1RlFuVFN0RzUwclhPRDloOHEzOUU0?=
 =?utf-8?B?UzRRYWN3eGhvTGE5Zmw2Z001Y0k1enFJTjFVWlkzUVhXY2czaTloSzhiT3J1?=
 =?utf-8?B?bHZ2NnRKVGpGclJXVFdqZEszYlNDaEhjWnhuTnN5OXcxTmI5RUNRSXpjSlR0?=
 =?utf-8?B?QUNiNS9NajcwRm5Oa1B1YmJFYXIrMzdWNnl3eVlLbUhRUzNxdDJBU1dFMFZh?=
 =?utf-8?B?L3J6OWdHbmJmWUV5YkJCbUc5Ri9sbmIzUnJ1QldWQzBrY1FCazQyVWo2SzFF?=
 =?utf-8?B?UDlwQTV6dUludEZJekIxRFdua1Rjd2MxenFiNVFXVVVMc213OUFuc1ptNm1H?=
 =?utf-8?B?VVlhRERWNkZpakJtclhwNXhtbzBsRytOSzlnelpEMklFbDRiZU9oRWpVb1BC?=
 =?utf-8?B?N3VOTnVBK1VvalNHWTFpMGtpenBsRUVDYzZIYVEzTlptU3dsNStRdUFaSWRC?=
 =?utf-8?B?ZUVaV0grTmQrWlR2dkFtY2ZEVkxadW9wUUxCMWdvakNEY0dWQW5VSXpqTm1h?=
 =?utf-8?B?QzgyRGRlUjY0NWNaSHVKMi9PU0FwYVVITmtHWkNyeTNmandRalA5cllYSlZP?=
 =?utf-8?B?a3QwOG5hbGJlOUwzbDlmSEFQQ2pZcUxsU0RXa25Kczh5U3VORHVrbytTdUxa?=
 =?utf-8?Q?I5U8fuW+I++Wd7BGZdm3Jrc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 127233b1-a5bf-439d-e647-08d9c0e3f829
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 22:32:40.4334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ksv5vCqdqbNFbLmc/YlPXNTubTDVIZ3OVOdsFmhLROUjhUTZNotj2Qdo/Tm5QkHRmjxJuHe8cxF2cNg2Ew4QoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4799
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10200 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112160117
X-Proofpoint-ORIG-GUID: O_q3iTYe4a2su5DMHgtsxxE2BWm6J1af
X-Proofpoint-GUID: O_q3iTYe4a2su5DMHgtsxxE2BWm6J1af
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2021 6:53 PM, Jason Wang wrote:
> On Thu, Dec 16, 2021 at 10:02 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>> On 12/15/2021 1:33 PM, Michael S. Tsirkin wrote:
>>> On Wed, Dec 15, 2021 at 12:52:20PM -0800, Si-Wei Liu wrote:
>>>> On 12/14/2021 6:06 PM, Jason Wang wrote:
>>>>> On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>>>>> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
>>>>>>> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
>>>>>>>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
>>>>>>>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
>>>>>>>>>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
>>>>>>>>>> it ended up with. I have the following questions,
>>>>>>>>>>
>>>>>>>>>> 1. legacy guest support: from the past conversations it doesn't seem the
>>>>>>>>>> support will be completely dropped from the table, is my understanding
>>>>>>>>>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
>>>>>>>>>> which is backed by the spec at
>>>>>>>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
>>>>>>>>>> if there's request/need to support wilder legacy virtio versions earlier
>>>>>>>>>> beyond.
>>>>>>>>> I personally feel it's less work to add in kernel than try to
>>>>>>>>> work around it in userspace. Jason feels differently.
>>>>>>>>> Maybe post the patches and this will prove to Jason it's not
>>>>>>>>> too terrible?
>>>>>>>> I suppose if the vdpa vendor does support 0.95 in the datapath and ring
>>>>>>>> layout level and is limited to x86 only, there should be easy way out.
>>>>>>> Note a subtle difference: what matters is that guest, not host is x86.
>>>>>>> Matters for emulators which might reorder memory accesses.
>>>>>>> I guess this enforcement belongs in QEMU then?
>>>>>> Right, I mean to get started, the initial guest driver support and the
>>>>>> corresponding QEMU support for transitional vdpa backend can be limited
>>>>>> to x86 guest/host only. Since the config space is emulated in QEMU, I
>>>>>> suppose it's not hard to enforce in QEMU.
>>>>> It's more than just config space, most devices have headers before the buffer.
>>>> The ordering in datapath (data VQs) would have to rely on vendor's support.
>>>> Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w vendor nowadays
>>>> can/should well support the case when ORDER_PLATFORM is not acked by the
>>>> driver (actually this feature is filtered out by the QEMU vhost-vdpa driver
>>>> today), even with v1.0 spec conforming and modern only vDPA device. The
>>>> control VQ is implemented in software in the kernel, which can be easily
>>>> accommodated/fixed when needed.
>>>>
>>>>>> QEMU can drive GET_LEGACY,
>>>>>> GET_ENDIAN et al ioctls in advance to get the capability from the
>>>>>> individual vendor driver. For that, we need another negotiation protocol
>>>>>> similar to vhost_user's protocol_features between the vdpa kernel and
>>>>>> QEMU, way before the guest driver is ever probed and its feature
>>>>>> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
>>>>>> from the device, but we can assume weak ordering for legacy at this
>>>>>> point (x86 only)?
>>>>> I'm lost here, we have get_features() so:
>>>> I assume here you refer to get_device_features() that Eli just changed the
>>>> name.
>>>>> 1) VERSION_1 means the device uses LE if provided, otherwise natvie
>>>>> 2) ORDER_PLATFORM means device requires platform ordering
>>>>>
>>>>> Any reason for having a new API for this?
>>>> Are you going to enforce all vDPA hardware vendors to support the
>>>> transitional model for legacy guest?
> Do we really have other choices?
>
> I suspect the legacy device is never implemented by any vendor:
>
> 1) no virtio way to detect host endian
This is even true for transitional device that is conforming to the 
spec, right? The transport specific way to detect host endian is still 
being discussed and the spec revision is not finalized yet so far as I 
see. Why this suddenly becomes a requirement/blocker for h/w vendors to 
implement the transitional model? Even if the spec is out, this is 
pretty new and I suspect not all vendor would follow right away. I hope 
the software framework can be tolerant with h/w vendors not supporting 
host endianess (BE specifically) or not detecting it if they would like 
to support a transitional device for legacy.

> 2) bypass IOMMU with translated requests
> 3) PIO port
>
> Yes we have enp_vdpa, but it's more like a "transitional device" for
> legacy only guests.
>
>> meaning guest not acknowledging
>>>> VERSION_1 would use the legacy interfaces captured in the spec section 7.4
>>>> (regarding ring layout, native endianness, message framing, vq alignment of
>>>> 4096, 32bit feature, no features_ok bit in status, IO port interface i.e.
>>>> all the things) instead?
> Note that we only care about the datapath, control path is mediated anyhow.
>
> So feature_ok and IO port isn't an issue. The rest looks like a must
> for the hardware.
H/W vendors can opt out not implementing transitional interfaces at all 
which limits itself a modern only device. Set endianess detection (via 
transport specific means) aside, for vendors that wishes to support 
transitional device with legacy interface, is it a hard stop to drop 
supporting BE host if everything else is there? The spec today doesn't 
define virtio specific means to detect host memory ordering or device 
memory coherency, will it yet become a stopper another day for h/w 
vendor to support more platforms?

>
>> Noted we don't yet have a set_device_features()
>>>> that allows the vdpa device to tell whether it is operating in transitional
>>>> or modern-only mode.
> So the device feature should be provisioned via the netlink protocol.
Such netlink interface will only be used to limit feature exposure, 
right? i.e. you can limit a transitional supporting vendor driver to 
offering modern-only interface, but you never want to make a modern-only 
vendor driver to support transitional (I'm not sure if it's a good idea 
to support all the translation in software, esp. for datapath).
> And what we want is not "set_device_feature()" but
> "set_device_mandatory_feautre()", then the parent can choose to fail
> the negotiation when VERSION_1 is not negotiated.
This assumes the transport specific detection of BE host is in place, 
right? I am not clear who initiates the set_device_mandatory_feautre() 
call, QEMU during guest feature negotiation, or admin user setting it 
ahead via netlink?

Thanks,
-Siwei

>   Qemu then knows for
> sure it talks to a transitional device or modern only device.
>
> Thanks
>
>> For software virtio, all support for the legacy part in
>>>> a transitional model has been built up there already, however, it's not easy
>>>> for vDPA vendors to implement all the requirements for an all-or-nothing
>>>> legacy guest support (big endian guest for example). To these vendors, the
>>>> legacy support within a transitional model is more of feature to them and
>>>> it's best to leave some flexibility for them to implement partial support
>>>> for legacy. That in turn calls out the need for a vhost-user protocol
>>>> feature like negotiation API that can prohibit those unsupported guest
>>>> setups to as early as backend_init before launching the VM.
>>> Right. Of note is the fact that it's a spec bug which I
>>> hope yet to fix, though due to existing guest code the
>>> fix won't be complete.
>> I thought at one point you pointed out to me that the spec does allow
>> config space read before claiming features_ok, and only config write
>> before features_ok is prohibited. I haven't read up the full thread of
>> Halil's VERSION_1 for transitional big endian device yet, but what is
>> the spec bug you hope to fix?
>>
>>> WRT ioctls, One thing we can do though is abuse set_features
>>> where it's called by QEMU early on with just the VERSION_1
>>> bit set, to distinguish between legacy and modern
>>> interface. This before config space accesses and FEATURES_OK.
>>>
>>> Halil has been working on this, pls take a look and maybe help him out.
>> Interesting thread, am reading now and see how I may leverage or help there.
>>
>>>>>>>> I
>>>>>>>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware level
>>>>>>>> 0.95 support, it seems all the ingredient had been there already dated back
>>>>>>>> to the DPDK days. The only major thing limiting is in the vDPA software that
>>>>>>>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFORM for
>>>>>>>> a few DMA setup ops, which is virtio 1.0 only.
>>>>>>>>
>>>>>>>>>> 2. suppose some form of legacy guest support needs to be there, how do we
>>>>>>>>>> deal with the bogus assumption below in vdpa_get_config() in the short term?
>>>>>>>>>> It looks one of the intuitive fix is to move the vdpa_set_features call out
>>>>>>>>>> of vdpa_get_config() to vdpa_set_config().
>>>>>>>>>>
>>>>>>>>>>              /*
>>>>>>>>>>               * Config accesses aren't supposed to trigger before features are
>>>>>>>>>> set.
>>>>>>>>>>               * If it does happen we assume a legacy guest.
>>>>>>>>>>               */
>>>>>>>>>>              if (!vdev->features_valid)
>>>>>>>>>>                      vdpa_set_features(vdev, 0);
>>>>>>>>>>              ops->get_config(vdev, offset, buf, len);
>>>>>>>>>>
>>>>>>>>>> I can post a patch to fix 2) if there's consensus already reached.
>>>>>>>>>>
>>>>>>>>>> Thanks,
>>>>>>>>>> -Siwei
>>>>>>>>> I'm not sure how important it is to change that.
>>>>>>>>> In any case it only affects transitional devices, right?
>>>>>>>>> Legacy only should not care ...
>>>>>>>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against the
>>>>>>>> modern one in a transitional device model rather than being legacy only.
>>>>>>>> That way a v0.95 and v1.0 supporting vdpa parent can support both types of
>>>>>>>> guests without having to reconfigure. Or are you suggesting limit to legacy
>>>>>>>> only at the time of vdpa creation would simplify the implementation a lot?
>>>>>>>>
>>>>>>>> Thanks,
>>>>>>>> -Siwei
>>>>>>> I don't know for sure. Take a look at the work Halil was doing
>>>>>>> to try and support transitional devices with BE guests.
>>>>>> Hmmm, we can have those endianness ioctls defined but the initial QEMU
>>>>>> implementation can be started to support x86 guest/host with little
>>>>>> endian and weak memory ordering first. The real trick is to detect
>>>>>> legacy guest - I am not sure if it's feasible to shift all the legacy
>>>>>> detection work to QEMU, or the kernel has to be part of the detection
>>>>>> (e.g. the kick before DRIVER_OK thing we have to duplicate the tracking
>>>>>> effort in QEMU) as well. Let me take a further look and get back.
>>>>> Michael may think differently but I think doing this in Qemu is much easier.
>>>> I think the key is whether we position emulating legacy interfaces in QEMU
>>>> doing translation on top of a v1.0 modern-only device in the kernel, or we
>>>> allow vdpa core (or you can say vhost-vdpa) and vendor driver to support a
>>>> transitional model in the kernel that is able to work for both v0.95 and
>>>> v1.0 drivers, with some slight aid from QEMU for
>>>> detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess for the
>>>> former we still rely on vendor for a performant data vqs implementation,
>>>> leaving the question to what it may end up eventually in the kernel is
>>>> effectively the latter).
>>>>
>>>> Thanks,
>>>> -Siwei
>>> My suggestion is post the kernel patches, and we can evaluate
>>> how much work they are.
>> Thanks for the feedback. I will take some read then get back, probably
>> after the winter break. Stay tuned.
>>
>> Thanks,
>> -Siwei
>>
>>>>> Thanks
>>>>>
>>>>>
>>>>>
>>>>>> Meanwhile, I'll check internally to see if a legacy only model would
>>>>>> work. Thanks.
>>>>>>
>>>>>> Thanks,
>>>>>> -Siwei
>>>>>>
>>>>>>
>>>>>>>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
>>>>>>>>>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>>>>>>>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>>>>>>>>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>>>>>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>>>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>>>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>>>>>>>>>>>> Well, although I think adding an ioctl is doable, may I
>>>>>>>>>>>>>>> know what the use
>>>>>>>>>>>>>>> case there will be for kernel to leverage such info
>>>>>>>>>>>>>>> directly? Is there a
>>>>>>>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>>>>>>>>>>>> differentiation (legacy v.s. modern) needed?
>>>>>>>>>>>>>> BTW a good API could be
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> we did it per vring but maybe that was a mistake ...
>>>>>>>>>>>>> Actually, I wonder whether it's good time to just not support
>>>>>>>>>>>>> legacy driver
>>>>>>>>>>>>> for vDPA. Consider:
>>>>>>>>>>>>>
>>>>>>>>>>>>> 1) It's definition is no-normative
>>>>>>>>>>>>> 2) A lot of budren of codes
>>>>>>>>>>>>>
>>>>>>>>>>>>> So qemu can still present the legacy device since the config
>>>>>>>>>>>>> space or other
>>>>>>>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
>>>>>>>>>>>>> accessed by
>>>>>>>>>>>>> guest directly. Qemu can do the endian conversion when necessary
>>>>>>>>>>>>> in this
>>>>>>>>>>>>> case?
>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks
>>>>>>>>>>>>>
>>>>>>>>>>>> Overall I would be fine with this approach but we need to avoid breaking
>>>>>>>>>>>> working userspace, qemu releases with vdpa support are out there and
>>>>>>>>>>>> seem to work for people. Any changes need to take that into account
>>>>>>>>>>>> and document compatibility concerns.
>>>>>>>>>>> Agree, let me check.
>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>        I note that any hardware
>>>>>>>>>>>> implementation is already broken for legacy except on platforms with
>>>>>>>>>>>> strong ordering which might be helpful in reducing the scope.
>>>>>>>>>>> Yes.
>>>>>>>>>>>
>>>>>>>>>>> Thanks
>>>>>>>>>>>
>>>>>>>>>>>

