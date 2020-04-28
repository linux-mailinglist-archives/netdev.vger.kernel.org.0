Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB271BBCCC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 13:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgD1LsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 07:48:01 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:40135
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726285AbgD1LsB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 07:48:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kc/6eLlgBlfj1OduwCci9KDvyPFC4KE33BCZ0O8Ru+IC3cywySKPhyZTdl2C2KzGWBQGr8SbR6FJPf9iIsCEDC0rIAHhLKiDS2d59Fx1u8pZwGxg356Cb8kwqlzpOdPNAmipxs6CkpgAwCjn8oZvupwQ/3bBdEO45ZEIeP1HsMCqf0ZWbdtiY10dAMMYdNDbd44FLVxaHJYXcm8u1UA62j67feIJbNTbw9JiITzOafuaQGAQGXaL74uInqlpIqSmSh1QdXcKF4dx135djJaEuKhljCZgG1yFzM9oQSJSJOBVd96QBKLPSvmMKuzl0UhFcntBmjc5D7ryXg2atetB0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+a5WBnJHBIHOGAHvE4mk1V2QjtLUjEzNkr6zTmB5K+c=;
 b=DIZcfepSEuRoFO7XkHuSoTmvdkVet9WS1dWjSQDvfgXS9ad54a3jgyVVlEfTm9/19uvbBH1zx5DkVeNGnrUzqdk2caCFVBSZMjHYcIFJX1JywvLbfrq621Tq8NYZyMs10LEdYhB7kPAAslA0QxXNDJdIzEZlOzDE4UcBN+5yrjgnUKCGR7MrIZz6Sf5B8Yye5LbgRNZsEpI822A85Z3AzA8VNr/ViWLgUmOlLzINE2Zm+kEVRpqoysSH3E0zgslQR3djp/GgBvzQdan0xcNCmctNWtT3vjEEe+3Etk107jEwtZUcADNlhXQR5yKqyKCCeHSjXStm/KzBMQsOKCpbsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+a5WBnJHBIHOGAHvE4mk1V2QjtLUjEzNkr6zTmB5K+c=;
 b=oUi5n4crhdgSKFKlMVYGpqrvWTsNTtIQz9zlmVpwdWgAdwWjbuawmyOb+KCbyjmAGwNOpEDjNKmYGfHmVCeRCCKqq0ZvsxMZLBB9FDe/rNJD7JwnvDRLsatlC9P1FxpgGyBqNwdkAOpvm+KEX1GfVueF9XmwHgoLTcgy8CupS54=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3468.eurprd05.prod.outlook.com (2603:10a6:7:32::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Tue, 28 Apr 2020 11:47:53 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 11:47:53 +0000
References: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com> <20200422130245.53026ff7@hermes.lan> <87imhq4j6b.fsf@mellanox.com> <cdb5f51b-a8aa-7deb-1085-4fab7e01d64f@gmail.com> <20200427160938.2cdce301@hermes.lan> <87368o3qhq.fsf@mellanox.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: pedit: Support JSON dumping
In-reply-to: <87368o3qhq.fsf@mellanox.com>
Date:   Tue, 28 Apr 2020 13:47:51 +0200
Message-ID: <87y2qf3k7s.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0020.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::30) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR10CA0020.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 11:47:52 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e5cdf1a-6eff-424d-adf6-08d7eb69fc36
X-MS-TrafficTypeDiagnostic: HE1PR05MB3468:
X-Microsoft-Antispam-PRVS: <HE1PR05MB346814E42203C08584FE5787DBAC0@HE1PR05MB3468.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(81156014)(36756003)(4326008)(53546011)(8676002)(86362001)(186003)(6486002)(16526019)(6496006)(2906002)(956004)(66476007)(5660300002)(66946007)(6916009)(52116002)(478600001)(316002)(66556008)(8936002)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uNfmDpQ+YkH4KeQpbfN+LLoBdmDl5Bs2+m0eIYqvZis8I3l1E4hySaBM3WsEoMbZnkkEa8RgozL9gtkkwkQFYDNDZxq/w3HumNQ4eDuHN6M2j+JitjMOn2ln51i6lugHfKZlVBkwXNGXnquuQ/k4NLxTL2+uqLDCW6LDwxZQ2c47Tt711c/oBzGNsHcS+gZaexJ56qW8RH1Q/NPa6kU6lfaeU8xSwcWgrNOYdE6JEwqaebeglBaCp5fXYRfK9jXW49qx6DaQKBQkhb0EXxnThX01+O1JKiwHs6dW/aNzIzGKdW63hSQObluAJo4xHAw4IRS3R0EfZ9NRtACw+AkuaP/9ivDpAk2MrlVOkmwv+KpZPBiuBKvJWMOaYRHD5kwnP7d6v+F3tl78b1umWQQeXdnLLEhYPBeAkIA12VtQrhX/H9YLMnJur/XxvT8nijjN
X-MS-Exchange-AntiSpam-MessageData: f/cl7dcVb5WyA/85RLsHJu5npi3YibFP+GN9JfqBHGePC/vGX/M4hd/fYkYWu4yrougJ89a4sULoSNGZkkZkvAYGTnZSPic5tIsilUxe65e5zOZ32jGGziHHR9AmKz3/sygLFamkUDIDTUJakwUg1DSId0qrd/MfeSBFAsbknfJmbbrbYzXGbuzZjym9GjNjUPB+xLuuOP/2olGJ38baf1DXlt6X6go16DXaXxtCOI8f31QJ10AyRC/TXOOIci24mOP9cozO3MuQ/zPzznPacm5ESrAa6YF8ys+2jS/oMEwhafoEfLc9cn+vm/wNWMCxnS/C+LysBY68diBd459OHPFp3h0FQ33NJpFa94N5INxAChQHGYFTRncXBkVAfqxwaOe4ROFDNM9Rf3LjoY+mgKFkGc/tg3dqdpYUwtNDeqrrQ+MdH6i0YtzKOpqZrDLI0bzjSohx1IeGZYs5n/x8xnPHol4lBTBJmYYIM0btJFFKMjT65YykD44mTN5aRi5Vs/JV0/+U/l0l/M4RGnziqZB0IPDaVUhBIcO8vyXvGZbB4KyY4p/+2T860lfjeG2vweCMousTOWlVjlY9AzKnbHurx85aXazPcy0FPPrssASC08IwhjTeA0ushy1azahHnoZYe8lO1B2gRI0X2VRpbG/KbSmW8Qha7erIF3dqa1wnIpN4iJg6y88RKZ5phjyVrd59sEhnGl6WXvxWME5LKFjIEzmXBn8dXB06rWJycmcYtAztsr4PGWBlYQpUkVGClRhTep3gfC+uVI8SiSI3P7JoWTUT/H3sUjXk9OIgoYFi2NPiVHhxIzl4zistqd5F
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5cdf1a-6eff-424d-adf6-08d7eb69fc36
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 11:47:53.3298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yexA4KW4WYikB26eMDuZEpRmuzNPfE6OXYMbJ2u7vA7KLTo3TjNQBqTnqYVW81DtmQR0p5EwOsCHyGYYEq9Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3468
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@mellanox.com> writes:

> Stephen Hemminger <stephen@networkplumber.org> writes:
>
>> On Sun, 26 Apr 2020 12:23:04 -0600
>> David Ahern <dsahern@gmail.com> wrote:
>>
>>> On 4/23/20 3:59 AM, Petr Machata wrote:
>>> >
>>> > Stephen Hemminger <stephen@networkplumber.org> writes:
>>> >
>>> >> On Wed, 22 Apr 2020 20:06:15 +0300
>>> >> Petr Machata <petrm@mellanox.com> wrote:
>>> >>
>>> >>> +			print_string(PRINT_FP, NULL, ": %s",
>>> >>> +				     cmd ? "add" : "val");
>>> >>> +			print_string(PRINT_JSON, "cmd", NULL,
>>> >>> +				     cmd ? "add" : "set");
>>> >>
>>> >> Having different outputs for JSON and file here. Is that necessary?
>>> >> JSON output is new, and could just mirror existing usage.
>>> >
>>> > This code outputs this bit:
>>> >
>>> >             {
>>> >               "htype": "udp",
>>> >               "offset": 0,
>>> >               "cmd": "set",   <----
>>> >               "val": "3039",
>>> >               "mask": "ffff0000"
>>> >             },
>>> >
>>> > There are currently two commands, set and add. The words used to
>>> > configure these actions are set and add as well. The way these commands
>>> > are dumped should be the same, too. The only reason why "set" is
>>> > reported as "val" in file is that set used to be the implied action.
>>> >
>>> > JSON doesn't have to be backward compatible, so it should present the
>>> > expected words.
>>> >
>>>
>>> Stephen: do you agree?
>>
>> Sure that is fine, maybe a comment would help?
>
> Something like this?
>
>                         /* In FP, report the "set" command as "val" to keep
>                          * backward compatibility.
>                          */
> 			print_string(PRINT_FP, NULL, ": %s",
> 				     cmd ? "add" : "val");
> 			print_string(PRINT_JSON, "cmd", NULL,
> 				     cmd ? "add" : "set");

I just sent it as a v2 of the patch, we can discuss there.
