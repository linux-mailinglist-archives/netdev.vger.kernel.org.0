Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36D9278D20
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgIYPsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:48:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728333AbgIYPsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:48:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PFc8uU031529;
        Fri, 25 Sep 2020 08:47:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RhZqBbMYTdkKzLRypjmSOxN5JNNqpeqXxA0gnUmB/WY=;
 b=S0/HRI6SbSfslUFUS/4L/Djp9rKsrV2r+yXceINNiJW/+AJqwNj0DuLWMUA76j6Y7+cr
 yiXHtQoLqHao7NxyYVr8Ey3ryggaTaJoM9c01a/X7Cr0emccTGwolsyKCxDff3/Nq6Fy
 R402ntGZt+bachflrEWwrEH6jOKTwh8QWFE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp68c02-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 08:47:40 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 08:47:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmyV9ir/v6pYwpyUqGKfqa8/Pqz2CnraXk3wLvU/J1f68MK6tGhccCexQhB+cAPzTTOSreYr94fnVXQbEFST4Z+yVFiIpkMG3pQx9+fFDYdtr8ULFVPkge/Bolq9rKgnFe3+wmkn8mcShoxYzgOFuOrzmpiraA0urbaKknNbm2w/zS14Oz+R3SxCgovF4m5NMfbeC0G6BTSgn4rbPFacBsyXpVJDg+eZO6LdcSj2K/J2SZmncXSYouF50fZzq3IcvxheEo/uy5xzXWv2AGEgfSCVySGlUbhY709lep4XQNm9GbbXYB4orfbs7oUqGzzMOnShoKlfKQ9Ced4CqGEGtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhZqBbMYTdkKzLRypjmSOxN5JNNqpeqXxA0gnUmB/WY=;
 b=E+lNq3m4IlvIOYIN/69ks8DLAye9FduYX1XJkrbsFzHSO+fS9SMkts0DwgK/2BV5682a5Y9BJ2QhHywC6kwsFmDrVXjBRWqM7df1g+N6Ze1mcCqHZbpVSMbID/64D4jRTrbEMacSN5MeEagUwi68zopBilJKCigfMEU+pY0RUhv3FzYR0CpcPWgmzp8tkqy8hg3IOHVz8uINak9CvZiE1XAymG9a3swBt8bxwXmDGrT7MvreJ/1j00tudxvECjFqKOKTAJARmJ0EtN5ashpsVwnMlIki5QWheSIpBtay+i3RZAdLT31p2MM+qULzyDBChR+PUojba7FECnGu1ik6ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhZqBbMYTdkKzLRypjmSOxN5JNNqpeqXxA0gnUmB/WY=;
 b=hNDh/dN/4YSHMmjzUmBXGZk8GwZp3gF/Im1cpB7TgfwR9ASPpF17iyCEVkfPXbQxHfv9TQhm+NWToWl6C+h/Sw4KoHDXecwYI2ARDOuCv5JqzGhgspIQlzoQaPdZH/l2CiOwmJ1oNyMKxFET6TSafTMW8PKTeO19cQPmSukFtcM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MWHPR15MB1566.namprd15.prod.outlook.com (2603:10b6:300:bc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 15:47:22 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::fc81:4df1:ba69:a0dd]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::fc81:4df1:ba69:a0dd%9]) with mapi id 15.20.3412.025; Fri, 25 Sep 2020
 15:47:22 +0000
Subject: Re: [PATCH v4 bpf-next 02/13] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
To:     Lorenz Bauer <lmb@cloudflare.com>, Martin KaFai Lau <kafai@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
References: <20200925000337.3853598-1-kafai@fb.com>
 <20200925000350.3855720-1-kafai@fb.com>
 <CACAyw98fk6Vp3H_evke+-azatkz7eoqQaqy+37mMshkQf1Ri4Q@mail.gmail.com>
 <20200925131820.f5yknxfzivjuy6j6@kafai-mbp>
 <CACAyw98EPhkRumV0xZR0J3HiVwVpE7iH1+aTWvrxpgKYndiVhw@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <d440f3f8-615c-5fc9-9703-283941ff33c6@fb.com>
Date:   Fri, 25 Sep 2020 08:47:20 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CACAyw98EPhkRumV0xZR0J3HiVwVpE7iH1+aTWvrxpgKYndiVhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:2128]
X-ClientProxiedBy: MWHPR12CA0038.namprd12.prod.outlook.com
 (2603:10b6:301:2::24) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:2128) by MWHPR12CA0038.namprd12.prod.outlook.com (2603:10b6:301:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Fri, 25 Sep 2020 15:47:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef8faa08-dc85-409e-00a5-08d8616a4af1
X-MS-TrafficTypeDiagnostic: MWHPR15MB1566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR15MB1566787EB700B46AA022D24AD7360@MWHPR15MB1566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x87OHg7gCJTptfoOldE302EbILL4SlVmx4DFZyay+1a/PhtIIGqLB63flthikhxH1Avn9nrytG/fuVpZiC5oMHmHO/9sCJdyDog3728wdiikkO/lZtJ8yIyt98cy4P9X8/V2nJCd7VI9FuOisy7FBhwWaltlNHrMXn5WJB4IVy4G8XDvk1Z0rPp5eCqesjEUcMmQc+RolmgiBNW4kiJ0OGWuMX7UiHJ4C45lMjrU/CY83DSVfMpdhHh7bTeJIKbH+ny+84/Z6l/MxDnJTjY1nwkINlHhQ5leTnV5WDrBCcpS2mrFe4RJZjvKHU2J3vdYcZztWAxDA2BlmysbpyMU8gAobZfSlo0T7uG2loR20Jj8xhvAZKC0Rw4zs8LGJc5e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(396003)(366004)(8676002)(4326008)(52116002)(4744005)(54906003)(31686004)(110136005)(478600001)(6636002)(66556008)(316002)(31696002)(186003)(53546011)(66476007)(6486002)(36756003)(86362001)(2906002)(16526019)(8936002)(5660300002)(66946007)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: urNlhtj0FpH2CZkpMU1HsbptXakod9WB2PGEEvE5InthvblVBNdhML2ww4vvBDTXZJwLOfbT1g/i98SJzwuomTQEV7CKkchWfo71bIt28P0DSy7RVrPxmL8/AIvMG9g82ZumIri2zOqJAfhjZfBpjdJkhMm0lIQfZQ9ZMw5BJLHG06jVq+PrUQRzB1Gkyk4KFc9e7yU98dSjul2aCRocaQ5YqQ+yiwhhHTpmpGBuF5+yer/yWQ1YSKpW9jRgA44eU+AQRN/7p/ni9UzWnRovpvDr5hH7bXO+4FcCqt382s2ElmKAtzYtJBC6GFMNp/66XNfb9Efu/d9fxUsF6fBU9cXp/fwvfIugZqxoRNh/ZbCWQ1/871T5Nmhn6UqGcBbouvjZXe38idGHs2/YUoLwub8HU0A6Lglun/F6pVu4NtJpiL8TXE0cpHdOCLVuTfkEjGNRSZsu5ESv5wz0BW6A+p4Zhsiy6KKvKCh4cRHJGXPxBDWA45LrXGqw+bfz0GmQAj0Iw2Y1iVvQwjwwMKenSohEO/1tC3QY647xXzMiB36nSuf03tYGtfAnrvdRlNzJnU0U8zY/Q4bo78hxTfeUci6TOIpCPx6EIQxjNdIPJpHGDEk5gqMLKNU90/iWVvLuYhg6o3NW5/o60Td+uVGpjZpm+fti7iAowLdzIXdyPDmNTLse+1LeA1AcLgrDV8vT
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8faa08-dc85-409e-00a5-08d8616a4af1
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 15:47:22.6732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8/FiwUH/EuNE41uf31nBehqGU4mq2ciHQiGpf2M5cEFYkzf/ROkoSz8LEBHU2HO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_14:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=897 clxscore=1011 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/25/20 6:50 AM, Lorenz Bauer wrote:
>>>> -       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++)
>>>> +       for (i = 0; i < ARRAY_SIZE(fn->arg_type); i++) {
>>>>                  if (fn->arg_type[i] == ARG_PTR_TO_BTF_ID && !fn->arg_btf_id[i])
>>>>                          return false;
>>>>
>>>> +               if (fn->arg_type[i] != ARG_PTR_TO_BTF_ID && fn->arg_btf_id[i])
>>>> +                       return false;
>>>> +       }
>>>> +
>>> This is a hold over from the previous patchset?
>> hmm... what do you mean?
> Sorry, I misread the patch!

Folks, please trim your replies.
You could have quoted just few lines above instead of most of the patch.
Scrolling takes time for those of us who used tbird, mutt, etc.
