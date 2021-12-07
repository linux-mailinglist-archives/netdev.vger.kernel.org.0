Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E106946BD83
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhLGO0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:26:31 -0500
Received: from mail-eopbgr70133.outbound.protection.outlook.com ([40.107.7.133]:52099
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233131AbhLGO0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 09:26:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNTQCO6yjCZuE364w2QxfJIdu24cr9wANcctPN6HHXCvnr/Cd2y6V0FhytHTPF83gD26uKtFnmtAAi6DHoBHSaXCncqDuSbq9o9ndekF3zn6l+v5zMRDMDd+ipS5/4ki7Ha3+0u3o4zjZ+uJ46Zyja+QAklf0DbuyDpjk9F7TfJM+MZqBwqGnWyI5x0kIjqrANGTHbTPLVy5lDDpuxvnScfHYy5yabkzrr2RHoFvzGyUjl6YeWVKH/zQ96CINHkvFt00Yy8pZmqzT3xN5HDjRx6umYCIVR8ituGR8xKDNkyufV8Bk1OW25r/Njp8PO3aPAI8SZbOSFWVvfEq9XPmOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmejRdTTMiqFCcbHxcwvuBDjLNLs7D5atNxzQxIWjRE=;
 b=WUG85MH+7JuBGKeMAUQG7T0XlX4eZQh/zVc7w93snT8uc8OMf08OhUyTIqXfIYsoC8m5oiNSdMrvDsiBe7IM8AsNvV3QIES4JyQClrF0J/2WuyOmgiu65XASO2z336pRq9MogM9g6hXt18vXFUxWhGZ3KIt7StD5+4anSs51XRi1ALy3KgJTURx+FuYk2CJbNm0Q3DTsrfmcvK2cWLN52IBR5fk362gg+2XfLTNkQbwX0B/cACZbbpKp2arABzxj5Pt7ntS9qcN32aC9cRjgMj3+nupw2S0T3dAz4S2FEWnbMc1KyFTg6CX97eVw09eYemFSPe08mjaGfoulopacAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmejRdTTMiqFCcbHxcwvuBDjLNLs7D5atNxzQxIWjRE=;
 b=lTV8x5zGnQ0UlSAMKoaXvmPNh3GjPrUYOtMUDyOGIaXJEOnZWJ6B2DBri+sfKkxE0yEaB0OB68AxD4HHklUAGyDOXE9C+qE1HY8b4jyubuqbl/HIOcPbYjfYQ3d56waQ4nmJWaTHznFnQzE2Oz+yzHysDBw3WTM5cipjPvtUxvZ/7nZ17pmBug6J84fLRdUK2x8HyPGdwNCk6G/m1Jd5YKwEC1HfOOCpD4RXY6aELIEoOLcbr59qkm3ssVwvn/IglLtomeMBECzt02+amHlg1PA2lQEZglFo/bkMLqJaTFM+FXqNrT1lW0lW6Jal2ZSwDXXWd7nVujiysJMex+UiRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DBAPR06MB7061.eurprd06.prod.outlook.com (2603:10a6:10:1a2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Tue, 7 Dec
 2021 14:22:57 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 14:22:57 +0000
Message-ID: <58038771-c612-93c5-697d-987e7fbf90b0@eho.link>
Date:   Tue, 7 Dec 2021 15:22:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 net 1/1] net: mvpp2: fix XDP rx queues registering
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, Louis Amas <louis.amas@eho.link>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211206172220.602024-1-louis.amas@eho.link>
 <20211206125513.5e835155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cfd7a6c3-dee9-e0ba-e332-46dc656ba531@eho.link>
 <Ya6PYeb4+Je+wXfD@shell.armlinux.org.uk>
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
In-Reply-To: <Ya6PYeb4+Je+wXfD@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MR2P264CA0100.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::16) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from [IPV6:2a10:d780:2:103:2537:3b31:6d3e:58e] (2a10:d780:2:103:2537:3b31:6d3e:58e) by MR2P264CA0100.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 14:22:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7164814-2342-4604-7020-08d9b98d10d2
X-MS-TrafficTypeDiagnostic: DBAPR06MB7061:EE_
X-Microsoft-Antispam-PRVS: <DBAPR06MB706192341CD50D95C26F7310FA6E9@DBAPR06MB7061.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5Gp1rhAIuxBOuWFUeez0HOQ0Hq3HZzyYZH8FRtNJLQfErvkd7ZyT6QYrtnck5RYpDME3MiHvuAXLgB9QmJBgT3bysPvqNDTvRZ2kNDKqKgOh9NlCkFXjRboh1ETVQPX04WoSyPrZ51j++gkkn7BqIPQD9iJsiWgdUKAOuknJUbPkG+VMYwkayvfLvDPoHDDdw8EF+1EF0hveSqZMLbuKmE59nUvfrUambDDquZwPT0h5UKB805p8USdZPh8QRpVaASTt7UL/7ko3Mq6GmZocUykEa9iLIeBpErT3UiT6SoBP5gqrYEPirsawTwusH9IcvrHmrUXGCjCbRn6NvezCHBDdWD3HUWU0+o8190x9LRYS+EpDJ9IB1L98jw2DjI2rb1Az+b21s1VpQ8riN5T+4mVT8QH6ssYzYk3fyWN+oX65A5MnqamZkQ2S8+V142nhEI0AqpVHVS1Yc24jGq/lpwM0+dHdhTOVfgmnPCdj4cWHDT7hIuvtLjZ8gvJRrIls9Qmh426Txmv6Ycl4JRrudGhGKwoyC+sskdnlD0aC9j/8KBj2B6CnooUXQJY+pEawCUv/klJKnUgM0X0aO34sjWGf08xD68lYo0ZWoF5xLddFhMs6vXVmZ3wAqhZe8DX98eMHzUJD1FwganaAJk2p7hiXwnkqwafPrwuPVl5o1iKYafEaUX+9a7ThRVsvfMFq02ghkWZHhKT5whbUMEUTcIvfgUCyl5NjRA8lpfzI2r3S51W3JNnuIzaREXgpt8+De9g8nzfLnK4lG/vlAU7wVu98Hrgfg8/q34uf9jYobtzSRlGUI3rK1rpKytgR3Qy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(346002)(136003)(376002)(366004)(44832011)(31686004)(52116002)(5660300002)(31696002)(7416002)(6486002)(36756003)(83380400001)(53546011)(38100700002)(66476007)(54906003)(508600001)(316002)(2616005)(186003)(6916009)(966005)(8936002)(8676002)(4326008)(86362001)(2906002)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzYzbmh3bVZpYlNTT05vNTh6bXNvOW0vWGZGR25tMDZ0U1o1Q1V0bHlGU29B?=
 =?utf-8?B?WXBoU1JUSlhtZUIzRjNwVU9YZU9zQ3NCc1M4cDBEMnVTMEgrekVLYnR0aFBP?=
 =?utf-8?B?VlBxZmVucTQrNUZtbmd1UFVSNWxxdTZUUnZzNnlYUFpkdDNiSlpYTVVuMldZ?=
 =?utf-8?B?VlhsNUE2OXNRZ1crSnBJQ2pCTnd1R2JmRmI5WDlFb0pTZDNSSEsxTXVGVkIr?=
 =?utf-8?B?MXVQR0FKTDc2enV1d2pGY04yeEVscjVHeU10OWdFcWVtbjRXZlg0VEpTWFc5?=
 =?utf-8?B?ZjFpOWltQld3TU56Qk94OExINkloNnVSYVNHd2ppZFdwM3FDNktNWUZhbCti?=
 =?utf-8?B?SndqVm5EdXRER0pZcDZnYnVGbjhsU2l2YzNNVTlDM2prZWpTTWhIejZJM01n?=
 =?utf-8?B?cm4xTVJxaVFCeTJtRmJTUW0zdnpZMGVwV0h5cGxnc0JkS2VZdDFGQkNKTkFC?=
 =?utf-8?B?dGs1YkJidStnQlNVdm9zUnVhejgvM1Vmc0ZaaWpsZkpXS3dsTFdsMlowcWhC?=
 =?utf-8?B?bFNaMkRwZTdsSGJKUVNxNzZrdm1RZGpWbW9lRkorWWx2UVRXbE1tZXpKa0hV?=
 =?utf-8?B?azRFVTl0cCtjbUNpS2pSZnIvLzBzRW1YQXZQejhxa1g2c09zMjhSeUJOMHJN?=
 =?utf-8?B?c2tTeTI3L0xoVkljOVdzRldNK2RZQWFWVmZBSlVVVFYreFRyV1MxOFhtMW0w?=
 =?utf-8?B?TW94MHFrMmdCWXdNMFQvR2ZSRi81OW5qVzd4a2lYL21kbGphWktEYnJ6SlRq?=
 =?utf-8?B?UkZEbWJZOFJNNnU4OWZOeFpJRXc1MVh4Um9SaXEveDMxSSsrWVdLbjhkNmM4?=
 =?utf-8?B?TEowU2VXejZpVmNwMlQ0VWJnaVFqZTFRZFJoVlFHUFA5OFdKVldQTUpndW1C?=
 =?utf-8?B?UnhBL2Njbm9jZk56dTBoUUFlaEhXZ1VIRnRRQlFyU3VKSHhlNk1DaVVYTWhY?=
 =?utf-8?B?VGhsMUtrN09HMmx3Z09RckJPYWExRXFKZkFYeHFzK3p3YWpraUc2N2d1N09Z?=
 =?utf-8?B?dFUxaFl5c0tCSmNxVjdUR2c3QXZGT0hhNXNDbmZiTHIwdmdLKzRwZ3pmUzVP?=
 =?utf-8?B?VlVzNGZOTnpSc1NxZmppWmpKSXhqZ3JITVF0Q3BDcXBHL1gvWlo5U055T25T?=
 =?utf-8?B?TUxhMXdveGI2bHdCK3RrRGFPNjhramhMNXVKUjkvZnZtNFZzeENYNFI2TW9P?=
 =?utf-8?B?dDZLazVQdFl0Ym0rY29iQmovSXM4VGNpNlpYQkd1aklZbjVxSVVESDNqVXM3?=
 =?utf-8?B?VGpUNUt6TVNsTTRFWUd5SVVRNVR4Q0xnR3l2bDlsT0MwY0tlZVdEa0RJZ1dl?=
 =?utf-8?B?WnJkZ1dEV3J5S2ZUTlhXZ25jZWlzWVltRnpqMkxPeVdvTjZVNnJlNGJRRWdH?=
 =?utf-8?B?UnVldm1HWlhOZmpXZUlaSVZtODI3T29kWWpUQnBoTkd1YXkxNWFVQ1g4Zkhh?=
 =?utf-8?B?RkNyNm5HaUZMTWhpWWRaMkNpNFhqVGk1RUpVUFkwTEEwS0p0dm8vbVAyeUZ1?=
 =?utf-8?B?bzNQSWlURnUwYjdUN2FkRk0yamt4V3JyRmRRbG5CQ3ZmVWorN0JHOFJaWUhM?=
 =?utf-8?B?RkY4Y2t5Zzd2VEVUNjB6K3BOUDJVTGNyb241K0FYSUdMc3E0S1FHYng1K01C?=
 =?utf-8?B?cE8ybU5OMmZqbXdSUW1zWlJQZElDUFpqM0gvYXllTXdVaGtOb1dTZ1ZYRnB3?=
 =?utf-8?B?TTVZeWtsTGxpS0F2RFVqVk9pNElYMS9XMWI4cDlteTFZeW0vOXE0bFl0Ukl3?=
 =?utf-8?B?Y1R6cTFoKy96cG42aTZXYzhMMDFmOUZ1N093THBZak1vTkRsQWthRGtMZlBq?=
 =?utf-8?B?ODg3dVNGZXFZMllnSXFRaWVpSG9yeVFNaDJnMHRlc2dQdWxlcFhQQWdHSk55?=
 =?utf-8?B?MFZzbnNwcXJkeHJNNFMyczZSUHFXdTZJS0FrNENXVTBOdm1IN3dkU3F0bnll?=
 =?utf-8?B?UGVjcTJmTU9mMkdhbXdEN1cxbC9VOVZ2K0g4d0ZIaWZ0WUc0MDhxSFp0QnRQ?=
 =?utf-8?B?V2MrTEV1bFRNQ3JmRE0xUkZRUTI4eVFmSGpGYzk1RTFnZzR2RlNhUjJvdGdr?=
 =?utf-8?B?a1lyTXN0eEprRC9HRHVZdTNrVXdDSzNidUtaVE4zZThDd3krK2dHVm9qQmRq?=
 =?utf-8?B?NnZlR3NSUDNCRmFmVXBDSW00VmdhR3E2T3hJWlNoeFFVbS80UHAxMGthQUtq?=
 =?utf-8?B?WTBmYjhaNmFRaHM5L2VTYmgwcFFIUmlLVGx5RFhYTGt1Ump6dWRVQ1k4QTlr?=
 =?utf-8?B?SFFDeE5pVGV2dkE4TWhHdklvWENlYkRwSXczWkRRSlBZZTdRRWNjdFpod2RY?=
 =?utf-8?B?bTg4TjZ3NXFidFBieERLRVRuVHA5azZiaGpabGN3RjhSVEQ0N1d0Zz09?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: e7164814-2342-4604-7020-08d9b98d10d2
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 14:22:57.5789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: odjWip642pAwxRNgV7sS6u5JrSPhXdU4EgWsZseh9hp0bzeD8fP3RyYDfVOIzszs05B7efRrxxdLtt+M9Mtiq3qG/5+0dNHUWPRGtwG+UQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR06MB7061
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 06/12/2021 23:32, Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 11:14:38PM +0100, Emmanuel Deloget wrote:
>> Hello,
>>
>> On 06/12/2021 21:55, Jakub Kicinski wrote:
>>> On Mon,  6 Dec 2021 18:22:19 +0100 Louis Amas wrote:
>>>> The registration of XDP queue information is incorrect because the
>>>> RX queue id we use is invalid. When port->id == 0 it appears to works
>>>> as expected yet it's no longer the case when port->id != 0.
>>>>
>>>> The problem arised while using a recent kernel version on the
>>>> MACCHIATOBin. This board has several ports:
>>>>    * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
>>>>    * eth2 is a 1Gbps interface with port->id != 0.
>>>
>>> Still doesn't apply to net/master [1]. Which tree is it based on?
>>> Perhaps you are sending this for the BPF tree? [2] Hm, doesn't apply
>>> there either...
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
>>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/
>>
>> Strange...
>>
>> AFAIK the commit was added on top of net/master (as cloned at approximately
>> 17:30 CET). I'll check with Louis tomorrow morning. We may have messed-up
>> something.
> 
> The reason it doesn't apply is because something is butchering the
> whitespace. Whatever it is, it thinks it knows better than you do,
> and is converting the tabs in the patch to a series of space
> characters. Your email also appears to be using quoted-printable
> encoding.
> 
> It looks like you're using git-send-email - and that should be fine.
> It also looks like you're sending through a MS Exchange server...
> My suspicion would be that the MS Exchange server is re-encoding
> to quoted-printable and is butchering the white space, but that's
> just a guess. I've no idea what you can do about that.


Thanks for you help on this issue. It appears that a configuration hook 
that was applied on our instance was doing extensive modification of the 
mail in order to add a banner at the end of the message. We removed it 
in order to save whitespaces from a gruesome mutilation so it should be 
ok now.

Louis is sending v4 of the patch as we speak.

Best regards,

-- Emmanuel Deloget
