Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420903EABE1
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 22:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbhHLUjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 16:39:21 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48166 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234725AbhHLUjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 16:39:12 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17CKa5Ur025104;
        Thu, 12 Aug 2021 20:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8dWmyw2pQP6cuDiXNeloD+gg+RsyiZLwqFPitFr6Zv8=;
 b=SjQuvDpcG/mvoHxFTRqgIqa8CO6kDKAKWNWJUcVA5Q2mPWBX8FppgJ7rbJFQnTCId8R8
 p4HUruMhjFOe35i33q3m7aIvyJd62GFVhQS+1Uw2+nIgDgvdr0CmbS+lasdaC9KSYllb
 XZnMNkkF0Fre5Gi3t9aEVauEJSS2A99OrO362wPus2NFNB/+pFMD/kulkmE+F1gp44en
 fWpc2b28RMjyTUX9gnuhm0HJUggwGfVLpjVhaoxbQ3fitz6b/vvk2pq7LCYwP5ytVSzt
 NsQsADxd2GJcZfRRc/0qUMbqi5Zov+hGW61i/3sUZPuzH4QR/EBZpAJX06iml9LC37Tf cw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8dWmyw2pQP6cuDiXNeloD+gg+RsyiZLwqFPitFr6Zv8=;
 b=DqPlqTNtkXqA+6uRxxPN4RNEVCAy5LdHyOGpV+OPqJ6NtEVP5d4xrPifWRnF4vQzoksq
 g89peZYLLwJf0L2PzP/v+J+SiOMxu1nZwU5rFL+OznfA80PWXtodCDrCTS7lJHoWyZAg
 i2KJKllG3QEWxaCKP/sWe5o7KEjtX0QIj5rQpTRjdNRh8J9Ji+KAmJIOa5sX9mAr9DGP
 apuAlRdpDvarBF2F42zDdsRIUlsh5bc6+0may8hvxnKaFMgn5GV9MgsI6145z5EKp06J
 zEhCiQ7CXdApkF7zaQJJDq7Dgt1O/x6DYCcIRmzMf7tkMQKJoUcuAVklAY+zF7aujbrY kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajhbaw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 20:38:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17CKaXtc041110;
        Thu, 12 Aug 2021 20:38:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 3accrcshne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Aug 2021 20:38:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqbA7QyNw7XdczRvY5xjPNVaZ5mNik4DlBnVhm0d9USIwJfMWFfhzVEZTvpL6nj2teFzt3PweEFNu+DdIR5E7R8shxTFs0zsY2l1mx7Z9HOkkQRm0DR8Pljs7OE1f96Jx6EbIhjniNqtCwPjCshnjtyoOUnVyv/Dak4VIzAD/cUgZ4YxxkZ1WX+hC+ScQSdWUHioX5zp2ZGKYQVw4NffAAwuzgHQfYuW8tKmGkJKN6/lujOGlvz/u5sMazxck4j3BHty/zsr8OqlWXOpcI2alA/EMIzhzC7ZhXHi1DYuuaALynbTqhPoNIdxS5gXKomMTdZOHn7Bl5Fo+iOn1EnGXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dWmyw2pQP6cuDiXNeloD+gg+RsyiZLwqFPitFr6Zv8=;
 b=VYOD8HxVcn6w7k1peCYgfUGhRrOfNA/EnI1jY11pCQgUFsDVN8zXOH9zGjnBTTgWgvyIxwFmg/51d1qEvazqYv1v7Kt65u2Zkq/N7cPjLoI4wJxRMAzsw+Gd9GqmSqtfHLDNnepKgx2ojJKVI4xhPVOotH7YIR4+ZEXF3KMSI/Rgcgy3KkFHnPQj0nfK2IPp7UTGQTKklzMwpSJPW2Gj30WLFLaffjIPA4sZs/rjUY3lfS4Uhb7i5NAShj8Xb4RYlogULtRgC1CjuaCR4QNJ1hhkypzDR9D7xh+W3PLu1O6k2nt0jKLUZp3fOUDWSIMg1jnZBGQ3B44HgFS7Xb2jHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8dWmyw2pQP6cuDiXNeloD+gg+RsyiZLwqFPitFr6Zv8=;
 b=Hx768Xh3dvXjXzhUcxDX+WMm59Z1AXUkrDJlDjkMfjLsyCYfokVCKIltl0rW/TbpJeC7GFJuDioJPBOV5ZPQmyEowCK9M33s24/xF3E9trCF/7LALzEgF0EL0xrhF2HMvqQhxENTx5a67EzJ1l6U3N6IZ0lIa/vzafMdkIAO4+E=
Authentication-Results: zeniv.linux.org.uk; dkim=none (message not signed)
 header.d=none;zeniv.linux.org.uk; dmarc=none action=none
 header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Thu, 12 Aug
 2021 20:38:40 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 20:38:40 +0000
Subject: Re: [PATCH] af_unix: fix holding spinlock in oob handling
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210811220652.567434-1-Rao.Shoaib@oracle.com>
 <CANn89i+utnHk-aoS=q2sLC8uLaMJDYsW=1O+c4fzODQd0P3stA@mail.gmail.com>
 <a807dd9c-4f8a-c205-8fa0-01effdd54553@oracle.com>
 <CANn89iKx9JW8atr96MJHpU34C7c3Wm72cbxkxUJQmoj=mX2UoQ@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <10b15115-b76f-d998-3206-f02f30e1f7f2@oracle.com>
Date:   Thu, 12 Aug 2021 13:38:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CANn89iKx9JW8atr96MJHpU34C7c3Wm72cbxkxUJQmoj=mX2UoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::33) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::485] (2606:b400:8301:1010::16aa) by SJ0PR03CA0058.namprd03.prod.outlook.com (2603:10b6:a03:33e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 20:38:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d836bc99-7c79-4e05-2694-08d95dd12b7a
X-MS-TrafficTypeDiagnostic: BY5PR10MB3828:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3828A54BB66E758F2394C6A5EFF99@BY5PR10MB3828.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sHVIedW8YHtalaEEGCx5lxUrP4T1AHtIjia6ReDKSqdrW+mfaaoPzhwxGf4vx2tiCNJy30SVQ8YqSVBU+2ee+DbReRCb0siWSjnGxt+YHmMMgR7FyhPeNH4cUkEiMc61VxOBO7vkCpXhKYGJmK6mLLDgJHVNoLmuDc4mzzpA/5p4phtx9/Eef/NUPYV0cJyilX7KNqgEWW98D9Pn2HWgz5zphNTA9EkCeSHiGclyAVcw7O4DOm3mzU5MPKcG2ySXr0ykwaZUkFoK6NdQwjeu5IdzixU1JFnc7iPPMjqc0/Jil+nJ7iQv4r2GC6FhV5nmFneaWcv+Ht77vSgzkJOxpJYow9/3Z77yLeoipJZ82vTzwh0lZb75P/cG0jRJpBuJ1/5c5GxVFlVaVrYuTirmcAW75z8Sx4QmPRkh/F+bLuMXLI6uMXaFv3GIM4RB37v1n/TkHHWOTUyPAU7rrqsgmymfwj+0KokpdK1ynaKJt/8kyXntxNdMJVNHGrGDhAUxCxSTHMsckIALSIBC+z68EkxspeBiaSQ0RCpBXciHN7++EV0DNJAH4JUL7OvS9C4bpvruezrICdXCu7HVOeMnSoH7i269Xc4CbFc8Rc33foy0HoRRmwIweonAmEOjTwgpvgEw+NUWFHVohr4d9GB0i6YxnM+EkpIoCrCl5yiqzSsp7J423b+8ittu002YKl9oCm7IWn2L6mW9qG6WbHnebr5urFgzoEVSKbGbEHdciQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(31696002)(36756003)(38100700002)(86362001)(8676002)(83380400001)(66476007)(31686004)(8936002)(66946007)(6486002)(316002)(66556008)(186003)(5660300002)(54906003)(53546011)(6916009)(2616005)(2906002)(478600001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFhjeFBQdW1vclVPSVBWUm1WVGZUanljZEFxZ3ZpZTVzeE1NWEZTc1M4QUtW?=
 =?utf-8?B?dUNBeWVuM1dRd3BtT1NRbzF2VDlsMFhaRXV6VkRWdE9GbGdpT05pU3FSRExi?=
 =?utf-8?B?ZXpnMGxLazFubktXMlRTcW9aaGFFN1Fmc2NoLys3SGNnTnZvU1ltUHRocE9k?=
 =?utf-8?B?bkJhR3BsRHhHSUhvZ0Z1WDZ2Q1ljdU01aXBDaG4zQzYxV2dWenNYbEFpQTFn?=
 =?utf-8?B?a0RFZVpXa3N3L1pUdWRySWFFUUVQa0t0UE5kbTFMcC9ucDlJVDZoRUNzYTky?=
 =?utf-8?B?aGt5UEdaOEV6a005Y0hhM1VVZHZxZzlBL1NQWXRmZmx0TUNEeXpwbkVsYzNw?=
 =?utf-8?B?U2d6dzN4dTBKS0dteEQrM3FBT2FjdW13MnZWNEZOQzZ5aTdlK2duWWh3UjFt?=
 =?utf-8?B?Y09XbjZFTlZzUXlNcHp3TWVtNTZQSVk5TEllV1ZLemh5T0FGdFB4K2dUZXBr?=
 =?utf-8?B?NHNqOGlQV2YrbkVwUmRPSXhXeTZFeis5THVNM2d0Z3BPVzZ1eE4zTHN3d0Za?=
 =?utf-8?B?SlIyUmRoblZMZ0FQSWltdkhkRUxHS25YMlg2TW1qSzVISEpLbWVWVzRTWlBu?=
 =?utf-8?B?V0FYSzB2dFNUU2dNcEhNNnhTYm1ONlZGdUNyVFQzWTlrb1dNcnJOZ1oveGlj?=
 =?utf-8?B?NExLVUFEdU1nc1BZUG1meFRtZ1E2djU1VmxaeHFHWXV3ZnRKcmV1ZU5Qem44?=
 =?utf-8?B?OWtVb1JROVI5cjR5Z3hIRHVkbkJhTXlXK1BFZCtFcmZ0UUUyMWZUQ3Zwbnll?=
 =?utf-8?B?QUdxdkFIVXlpQlppNFN6cnBFL1U2SXZCRTBnMTJKWGJCZHZjeXc4Ymhpa1B0?=
 =?utf-8?B?R0VoR3Z0ejRRbnNiUU9mOVV0eFQ1cnNqaDB5ejZjT3JWOWE3TlByTHVZazBu?=
 =?utf-8?B?NDBPbmhrcTRHUWhaMkpsWW5SVm02UmZtaVhGZURvRWlMSVZWK1E3ZG5ra0Rr?=
 =?utf-8?B?V2NnZUZ1VkQxNEFGTzhGdDl4ODhGK1FrL2QzMk1jdGxaTG9CWDZKUm1PNUkx?=
 =?utf-8?B?dXRXL0pDaDZQU0tieVQ2MUNaL2VNL3ZLU09GNGMyaVA3dUZabVhIcnd6TWow?=
 =?utf-8?B?UGtpdjE1WnBORStMNzdiN1FMdWgrUDVvMmVWb0FBc1FrT3V0eWFnMEhjVnNz?=
 =?utf-8?B?OVVVaU1tOHl4MDgybnkvUHRzQUpZc245QTl0eDl2OXVtRzlqUGxNZVlrYzNF?=
 =?utf-8?B?Mi9hZnlrMURxc256RGFFMXMvRGFXS3hzbGpqbWpidFRxcFkxNVdIUVhGQzBY?=
 =?utf-8?B?TUdaREdZLzRMeDRzaEpIUlFxcTljQXphcVNPZjNHM2pEcU5PS0RVeVdhZE9E?=
 =?utf-8?B?YWpUV3pKOHdyRUR1TlhIZERzaForNDVkc3d5ckJsK05tWVd2b29Na1cySWow?=
 =?utf-8?B?aEo5YVYwYmFHQnN2RDJaMHFnSmxYRzJ5d2pmZ1o3dUhhZEY1TkpRWVZiTXBM?=
 =?utf-8?B?R1VZb1hzTDRROUtYVXg3NVlUUmI4SS92SldmYk5XSzBVdHV5bW9URzlFUkIx?=
 =?utf-8?B?and2ODJ0S3NlSXhhdU5UUXV4cHcvaGJZK1J1dnc1QkkrRDViQTBnbmdyMHZr?=
 =?utf-8?B?S28wVWRoZnI2cFpZek80MGI1b1grQVc2S1hhdDViRTd1eWN2SGZieFlnU3Jr?=
 =?utf-8?B?V291ekN6S0FLT21Fdk9vM3dZb05LVjZzR0xRQWk3d05Nc1FlWVZtTjU3aysx?=
 =?utf-8?B?OVJDbEUvVGZlUEdyVHdQbmpRVkorNlNSZGhpZXlTL1BuYlBJaVg0dzFSekw4?=
 =?utf-8?B?b21vUFBaOWpyWktBN2c1VVdHQ0tnc2ltQmgxejZZNWlzT3piN1J0THppNHg5?=
 =?utf-8?Q?ob+W6hkrCaJP1Jj9JIDdKHInrFzssKubDB+k4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d836bc99-7c79-4e05-2694-08d95dd12b7a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 20:38:40.9216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/7pytUmMEbcwzlfvfD+/79YuHOc9VciPpylaJ2Uj2JojeHM1y20/CiUNotSA3nH1dvoL4i7xgGEkyFW1NKVZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3828
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120133
X-Proofpoint-ORIG-GUID: LCjjrBBQwEfZgM-ocUm0559Fj-d5J3yq
X-Proofpoint-GUID: LCjjrBBQwEfZgM-ocUm0559Fj-d5J3yq
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/12/21 1:33 PM, Eric Dumazet wrote:
> On Thu, Aug 12, 2021 at 7:37 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
>>
>> On 8/12/21 12:53 AM, Eric Dumazet wrote:
>>>           if (ousk->oob_skb)
>>> -               kfree_skb(ousk->oob_skb);
>>> +               consume_skb(ousk->oob_skb);
>> Should I be using consume_skb(), as the skb is not being consumed, the
>> ref count is decremented and if zero skb will be freed.
>>
> consume_skb() and kfree_skb() have the same ref count handling.
>
> The difference is that kfree_skb() is used by convention when a packet
> is dropped
>
> Admins can look closely at packet drops with drop_monitor, or :
>
> perf record -a -g -e skb:kfree_skb sleep 10
> perf report
>
> In your case, the oob_skb is not really dropped. It is replaced by
> another one, it is part of the normal operation.

Thanks a lot for the explanation. This was very helpful. In my case the 
skb may be dropped (oob was not read but the read has passed beyond oob, 
or could become part of normal data). Anyways, I will change it to use 
consume_skb().

Regards,

Shoaib

