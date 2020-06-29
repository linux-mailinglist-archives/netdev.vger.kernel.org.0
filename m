Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063E820D643
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732001AbgF2TSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731871AbgF2TRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:17:42 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on0615.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe02::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F42C02A562
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 06:21:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EosfwKbwtH1nWunHSi9nHCOSwJ0sLeUJt3aT2ThGxR4AbJlJkDmq9i1on4JjIGKsVWEal5SgNwvdc7t7Om4YYVX0k3GtOoMazLn6CYMY0zwWJdBwSHTA2Vht3lU3YHmkimFd11S0r50FF9qTDKkBbOad7Ayy06AJFR/7yXzZP2aSsroZ34S20enX1fieP1IgWB1mx0c5IkjWAkGrsIWAobLj7LcUYyhn8KsKvD7NrEt6BYbEne/mu917wj7ZzjiWiNm7+Kawdp7GGgpPT53SjjY2P4ampEOL8g6o+1W8rB6liJgI0hPRYZH5rTzS38Y4X4t4VET71Fy9WQZDQbIyDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAly9vEit9mClAVmA1E0bci2X0tmWoi0FURyjicYZzw=;
 b=X/L3rQQef4S6n6obh8cSIL4YLj+fsHzdj7/C4zRpEOack7USBcdEywglYaczY4PVR/xgeK6kcCvkwtbsPfgh7NYu+RLOFP7KSXtZEUy5OLVfhVT9RiCM5+VBR5VXYPCI04nqPEABFzxPkfHIom0mj2Gz/SpQvhjlUhyA66Q9rsp/j+dqG/7L0FVM0rUI3yGMQtGtgTiQ/EI+zHfuZT+cIxpX6jv+0qfx1p4jiXGZH5pBZv7pYXj7gEPwEToEkVuYFprd660Ac6SdVsjPzdKH/WRIsmvuuI17JAxlo+k0RQMTai2hwrf7SFiyapOfKppcYUV7ilwRJFI/IGpWyDFX7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAly9vEit9mClAVmA1E0bci2X0tmWoi0FURyjicYZzw=;
 b=Eb2bZoSOwku3IXw7T59iNpdRoQjcTGk0YU4fCj/dylHwHeI7Naq+o5KIncnXctAf2af1dsZWbYY74gxaf0tngHBPKhgOVsDuI44vEokV6/KflMF/+/dB1eqbwRzs92gi5D2A5eJaYzhpLP8XpwJIA3Yy26q10oniOUcHfOZxvJ4=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2412.eurprd05.prod.outlook.com (2603:10a6:3:6d::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Mon, 29 Jun 2020 13:21:07 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 13:21:06 +0000
References: <cover.1593209494.git.petrm@mellanox.com> <20200626155617.7f6a4c4c@hermes.lan>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Eric Dumazet" <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next v1 0/5] TC: Introduce qevents
In-reply-to: <20200626155617.7f6a4c4c@hermes.lan>
Date:   Mon, 29 Jun 2020 15:21:04 +0200
Message-ID: <87imfaj9dr.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::28) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR10CA0111.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Mon, 29 Jun 2020 13:21:06 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da4e7f83-b5cb-4993-c338-08d81c2f47cb
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2412:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB24122B76E24AC0D76400151BDB6E0@HE1PR0501MB2412.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47u+qpauZNW4/IoGmhMbvYFF0hkBzBBERgX/gRan2QY8lKNzsBR9DSZ+la/uFSlo8zG9P/yUErzl8IGRltnVqFFNxBgY8XdfaDiXCS4SYFN8udvEaG4Wd1aQjHVyqi2Z/QJFX2kZ9gcXHeDJu+xArlYDXorfz3M5/KCBQ6qEeq3oHK5xAWOuK5Wje7SrAwgnzmKg6DT6SSs7FaqjHevo9ZfTGZ5JbaalYeiEvdlQslC6PyNMnpBv8FFWtyEYVaTbwZwmAPYBTRSa8XExr0qjPLWfy1LlVpy53LKlvOFBum8I7bdSvrZIAIx8GxxFzFZkl+45TFAaT7unf/jhxw6GUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(39860400002)(396003)(376002)(478600001)(66946007)(52116002)(6496006)(66476007)(6486002)(4326008)(66556008)(2906002)(956004)(2616005)(5660300002)(8676002)(86362001)(8936002)(16526019)(186003)(26005)(54906003)(6916009)(83380400001)(36756003)(316002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IbqkFO+c1GGtQnUU0GU1wNJlgdhjWOJLYzOjD44o+Se8spM7q/EVTqUcozkdHV/pEiQ7Q4JSDbgW6EzjE4D52nP+vzHxmdrOWEGtWMpdUb5UmUFX6pa0dGIdWr5ri/3vQTOMnxcK2Xi1HRdZGDtKWvGPJXv2mAKLDpsUVVGOiElBktHYTWE7jSjcRRwOMRLh3hoO6T5psVSe/d1K4WNV3eXor2+HJsmoCfVtpLNdUXQL+cXpO070kf1L8pFJRZ6OCf2kHUbNbhHvGpjZ1kz6/6x3U0uT4nvAuf5tRet4s10+LdRe+zmxajs88VPvG9+gRP/s8K9ukJVDdEiGisf8HC6VAy5na4jbBvvroZe4mfCZmRiNaAOcFpSlT+J2LtcSgLhwUmbn0NbTjxK5gDtmvut5CJz3cJ4NVKSykL/d8dgjCcndVybGnO+rJPUobyU9puvFv9p/KNfDBM2TwX4d97wO0A19Vc9o7G9nbWgHx8zzjb/Ujh4DNDempESpv5nu
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da4e7f83-b5cb-4993-c338-08d81c2f47cb
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 13:21:06.7891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tchoynYmV/Jk0XBadDecvkbVbWcAewWAg1FKSv7U37cAzFrc4sL1QvOrNAaS0RQI6Wxz/6ueuXoP9x6r6PN+aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Sat, 27 Jun 2020 01:45:24 +0300
> Petr Machata <petrm@mellanox.com> wrote:
>
>> The Spectrum hardware allows execution of one of several actions as a
>> result of queue management decisions: tail-dropping, early-dropping,
>> marking a packet, or passing a configured latency threshold or buffer
>> size. Such packets can be mirrored, trapped, or sampled.
>>
>> Modeling the action to be taken as simply a TC action is very attractive,
>> but it is not obvious where to put these actions. At least with ECN marking
>> one could imagine a tree of qdiscs and classifiers that effectively
>> accomplishes this task, albeit in an impractically complex manner. But
>> there is just no way to match on dropped-ness of a packet, let alone
>> dropped-ness due to a particular reason.
>
> Would a BPF based hook be more flexible and reuse more existing
> infrastructure?

This does reuse the existing infrastructure though: filters, actions,
shared blocks, qdiscs invoking blocks, none of that is new.

And BPF can still be invoked though classifier and / or action bpf. It
looks like you get the best of both worlds here: something symbolic for
those of us that use the filter infrastructure, and a well-defined hook
for those of us who like the BPF approach.
