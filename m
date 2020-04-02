Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F423719BFD5
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 13:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388022AbgDBLGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 07:06:09 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:32149
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387963AbgDBLGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 07:06:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNUpwr8NiDqZTqNe73l2Rqtsx27S4MxEgk7nFfYve9zLGHyfv1lU41IwT+Vy6OHuWmulCyPgPisnllGoYmJvtsYZSF3V7yyz+YfNxG0+ZLQIeDhxLoctaa0Z9vEMGBIrwqiobZeSZQa8H65MJgLirQWRJUTQwwD6alfG1d2dCI7h9GdiJ/UVbe4yVD35d2ISKUUfkQHKf0LU5d4cQk98iwtdkdCiJ8d5DcOogq8wKyP6Tt0VEdBasNV4ejsChn8s6Uhn0IEza10M2bm/NgHfcUbU7Za5SpawpyBLZU3YWvvXb0qBijzlDcMliTGMlmP4UEJgq3UPjI0QVXztQgdZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNo7GPEqH6wEDTjMBHVrZvR8d+dDqlI3DV9oEtdBozo=;
 b=D0/31Oj0kVlvq0GDJjUPS3UMdS7w6lI67HQHPekUduZdQDpnnsWhBacP6HdJRp5MJO8xR0UaRY+zxXNQLJSMUWq1iaAlre2r77dkHhF//jpyRiZROG3tZwzQcOasbr/iAfezv/VbSYtmWPZ6EuArzA774Z3IFUYqemsGH70nb0Rru7Rn985iox1zu49pPYh/lYaBVJ1Y3ROtwH68vPA3WO4V66hlRVvbIS+laaBr+b++JAUGJlfz3fEKNUE9kFprqbOOU1+lxrjIod7JX2QGtyDU6N+kIvu8ykfTEeq1OGCnqwPo+3JTBFphV5Msux4clqxRvfgegxx9R75uN3A7BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNo7GPEqH6wEDTjMBHVrZvR8d+dDqlI3DV9oEtdBozo=;
 b=j8m0qDqoScWcfdbLDVWNSP5n83SQH8742zzVCtoZ2pqygCmSBDGL7r57vzYExfmVfKXZ4cQFTRr2lJE20o8uRZRkPoB31scjtDunnuSfbraQEPjcMpgiSUB5hF2tJ/AHnL4keFYumkXjQvOfniuNiptmeJysm2nTxa9ziXjsEOI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4666.eurprd05.prod.outlook.com (20.176.168.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Thu, 2 Apr 2020 11:06:05 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 11:06:05 +0000
References: <cover.1585331173.git.petrm@mellanox.com> <628ade92d458e62f9471911d3cf8f3b193212eaa.1585331173.git.petrm@mellanox.com> <20200327175123.1930e099@hermes.lan> <87eetafdki.fsf@mellanox.com> <0686d67a-84e8-dfab-7200-c67105420bcb@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 1/3] tc: p_ip6: Support pedit of IPv6 dsfield
In-reply-to: <0686d67a-84e8-dfab-7200-c67105420bcb@gmail.com>
Date:   Thu, 02 Apr 2020 13:06:02 +0200
Message-ID: <87wo6ydu5h.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 11:06:04 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bbb28bf3-22c7-4641-5613-08d7d6f5d634
X-MS-TrafficTypeDiagnostic: HE1PR05MB4666:
X-Microsoft-Antispam-PRVS: <HE1PR05MB4666C914EBBBBD2E91674337DBC60@HE1PR05MB4666.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(86362001)(316002)(6916009)(186003)(5660300002)(66946007)(26005)(16526019)(2616005)(956004)(6496006)(36756003)(478600001)(2906002)(8676002)(81156014)(6486002)(81166006)(66476007)(53546011)(66556008)(4326008)(8936002)(52116002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g39NvOMWl5nX6amsfgEixQHMWOIymu3IGsMkD+cnqgyqzueNDk84VGU8JjWQ82tU7m4m32nWOzylwxZklxImM7vWJG9PV0otMZ1OqEC8jW/TlWX6WThiAaBorlJaqb1lbmPNx1isDjnY8lOIm9LPA9OEnAeIHzCywej5MKpojvN0q9NLuKZiuM44EebMPwRl2oWMKnAwJnPbm1d+KJZzTsWS65I3msTay+o1Fq0TcDV0aUbkYk4cRMYS8nYfEGeJD8Jki1qyjM8pVzUUsJ6V0r1mNnWvWMDesXpv1pjIKIn5zzgiH2pGY2XonFDxVkoSYQaiQvrm/Bva/lyScU7eq3mM4IaNI6mS6dKOE+hEIpMu3z8mO826MKNYMyGO0El2EBbvsnUqxpun8Ys16vV/ifoOkA54LTYuIioMGIQvFHeaGPfwuRNuPxhbs+OtXEu/
X-MS-Exchange-AntiSpam-MessageData: oqBuEH+EX4bA6YlA9khtbQUn/FyZtm62ftpoUR+ovsMIIusNrieVaNy/S5O+KG65/p/zzEpWOAHosnreveMBqBlrSj0lOupkAqM1uB1/Y74XjA//zd1KYZPRhOnE1AEftnt6eRRxfLQ3NRvb48R8uQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb28bf3-22c7-4641-5613-08d7d6f5d634
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 11:06:04.7768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AwdF/AFU3vFCSfiNAA6sqNOozBfocwX/gNP6+eU4UvkOjOe53uXyJSYqQkNpel2Nd9QOBBFs8YhEKXRxLSwXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 3/30/20 2:32 AM, Petr Machata wrote:
>> 
>> Stephen Hemminger <stephen@networkplumber.org> writes:
>> 
>>>> diff --git a/tc/p_ip6.c b/tc/p_ip6.c
>>>> index 7cc7997b..b6fe81f5 100644
>>>> --- a/tc/p_ip6.c
>>>> +++ b/tc/p_ip6.c
>>>> @@ -56,6 +56,22 @@ parse_ip6(int *argc_p, char ***argv_p,
>>>>  		res = parse_cmd(&argc, &argv, 4, TU32, 0x0007ffff, sel, tkey);
>>>>  		goto done;
>>>>  	}
>>>> +	if (strcmp(*argv, "traffic_class") == 0 ||
>>>> +	    strcmp(*argv, "tos") == 0 ||
>>>> +	    strcmp(*argv, "dsfield") == 0) {
>>>> +		NEXT_ARG();
>>>> +		tkey->off = 1;
>>>> +		res = parse_cmd(&argc, &argv, 1, TU32, RU8, sel, tkey);
>>>> +
>>>> +		/* Shift the field by 4 bits on success. */
>>>> +		if (!res) {
>>>> +			int nkeys = sel->sel.nkeys;
>>>> +			struct tc_pedit_key *key = &sel->sel.keys[nkeys - 1];
>>>> +			key->mask = htonl(ntohl(key->mask) << 4 | 0xf);
>>>> +			key->val = htonl(ntohl(key->val) << 4);
>>>> +		}
>>>> +		goto done;
>>>> +	}
>>> Why in the middle of the list?
>> 
>> Because that's the order IPv4 code does them.
>
> neither parse function uses matches() so the order should not matter.

It was purely a consistency thing. So you both seem to imply I should
move it to the end, so I'll do that in v2.

>> 
>>> Why three aliases for the same value?
>>> Since this is new code choose one and make it match what IPv6 standard
>>> calls that field.
>> 
>> TOS because flower also calls it TOS, even if it's the IPv6 field.
>> dsfield, because the IPv4 pedit also accepts this. I'm fine with just
>> accepting traffic_class though.
>> 
>
> that's probably the right thing to do since this is ipv6 related

All right, I'll send v2 with this fix.
