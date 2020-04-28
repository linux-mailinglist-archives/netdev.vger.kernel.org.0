Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA72C1BB9E2
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgD1JcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:32:24 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:13573
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726951AbgD1JcX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 05:32:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTPNzeu0kkH0dg7+dRe9QTczE3SoiKVuli4aExR2p/QnjqYG/v6MI/cxxIGmzMCBrLeYLuYhj3UeiQKqrfYo3zyqIB96fm+ROWGCPniK9wboWOUcbSYUnMmUyZNA4czarlZKIwfsPguLsAlWo3iY67IOyI+SYJ2Py2rvFgkHdFRC71kBq9AyTNRZBlARx1sHMMijyiUg/8hrkh8+sKVpX1IZznJpgwRATZFkrWux8dJAJoybSmOcaB3yXVnn+SeH01k2mwnE+q9By5tUOYoTjaBtHuJ9i+ssvlE8RriZ//FeGQt3robn4jEgN60VBMqrxJAsUs61T0+zOlpy3uLzgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZjoDOQ0EShNyHHQJtlVmEHIcf6V1xeJBdlc0N9rhaw=;
 b=V2YqTkN8i0Q3Gpx2DqAkYqawcHU6foFy6EGzn3gc4pg2BBPrikWY/W/vfqKFv8NnmOGym7HkJYjRBFbRCuatAfFe/sJ4Wxs04Mew4PMACVte/IyCqasQK3dZCs4TBnxfdyZA0QLIFQVIg01J8ALm4xgWCxay0+5hh/s+zJ7RyeC1UVnyNC6hSnBrLCX10DPscc/nPEY7k+zH4cIaJruyVodonlNOu5UbRRcfscfVR0RHji8E7X78CRRT50XLupfip70uMhmIw8Aa7z2Sip7/uN2zDugZYXrZV9Dyd+ovV4E4qwD3h5AIQeNgt4BiWgd5bW1a0Ypu1Cqk422GKYo4vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZjoDOQ0EShNyHHQJtlVmEHIcf6V1xeJBdlc0N9rhaw=;
 b=heksccZR3DduXzeLMQdvmdpJAun6xaKAzgdxPt7mFgqFvTiCFPxCDFva/p8XIGm0OM8iBDOsfsty6IBKDK57nudhuJ4hpfRM4A6ZRwc/9TTjjXD0Prhtu2Bhq3Zc+X5dhB/Kp140iYrj2AUbuHEeVJYju7q5xHdcxDREgmldHm4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 AM6SPR01MB0055.eurprd05.prod.outlook.com (2603:10a6:20b:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 09:32:19 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 09:32:19 +0000
References: <19073d9bc5a2977a5a366caf5e06b392e4b63e54.1587575157.git.petrm@mellanox.com> <20200422130245.53026ff7@hermes.lan> <87imhq4j6b.fsf@mellanox.com> <cdb5f51b-a8aa-7deb-1085-4fab7e01d64f@gmail.com> <20200427160938.2cdce301@hermes.lan>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] tc: pedit: Support JSON dumping
In-reply-to: <20200427160938.2cdce301@hermes.lan>
Date:   Tue, 28 Apr 2020 11:32:17 +0200
Message-ID: <87368o3qhq.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0050.eurprd05.prod.outlook.com
 (2603:10a6:200:68::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM4PR0501CA0050.eurprd05.prod.outlook.com (2603:10a6:200:68::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 09:32:19 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 45ff52f3-4922-4081-925c-08d7eb570c19
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0055:
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0055510DDFF425BB9782DB02DBAC0@AM6SPR01MB0055.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(6486002)(5660300002)(478600001)(66476007)(86362001)(2906002)(66946007)(316002)(6916009)(66556008)(2616005)(53546011)(16526019)(26005)(8936002)(186003)(81156014)(8676002)(956004)(6496006)(52116002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzpeIlbXstnjo4miiF6lFzxdmhKUX6KEuRx2WgnQlp0cA4suK//pF50MyBFGsYuzhAyaKClWdTaeLxskWDK2at7l6E8FfB5grNOZfGh6e0EfW6AB31y5toYR3YKzL9OtRBjj+cucFoG8S4mRJj8ltbi5hMfKxhPi+ZXJH/qFlLpet7C39sJV35sIT7L+TVAQ7m2vjPduzI4iLPd6P2P7uxM1ciwlkBmemrLA2OlAJti17W5OwszvT8XX5xmlH3mjI8xmRccAylEyXUTXDak5HNgGm2SpGXyXPAGhuz0a9xLI4khO6QdZ6Bs3V63OJh8pmZxDbVE29TUvzSEbLl6isl7Sp9GsfQ7wT1o46vSCt60tT075M1hbUDNFgp1o+UkWI1k52CC9FCBfLAfjkFBs3iePowOwrTOaxm9GTHbsVgtot6ZfO6PUySCWlywZLwuh
X-MS-Exchange-AntiSpam-MessageData: 8BlAP6NKSQq6noG2HO4W0V6CO9Sp//R/2R8Xu/Hz8TrKpfnoyakzqN65J5CCPRyVHFTq8xWKAEsUdKHPbPRVVj1CNJcjmOROKMoUls20s0Iv10y2GfeElZktAY81roiR2h8OysQCzFF3O4AGyFCbPIkN/B0usiN7Wl2xyEA9vCQcvYwm0tipBq4GNb1IyIuCdxt1nWyGuYBq7eqKrT+oqjdZqUZdyz1lz4Bde6VY3YsOpqgCtB7wz2GmDiBr94KcZtQrBCljq5iHbvjnxC9vz9N9cg2FvBoGNxe8I5/xtTEClQtE69b7Eei6EktwFQ0Fm4L6tBOaiALzZOQZvxNVCnyO7B9oGbSAw+fO/ydo8QyxVB4lNFFCdn4xnywm1smKlSEU+XPu78pJmLUiBcROknD7UuFaank4lQ0DhjWGqdQ7c32bWyJFf8KcbyQx7NDrwkGUgQ1fuPZY+/donRW0AVQCALD4f+alDl02jdyA0zHOeDoHRSRztvfbXujy3vvK31psX6TziQfUXxvZT1pDlAPbYlwD7yG3mjr8dgU5gw1DSgaYjPJkicbvGOUZ19IBmvn3disRVTnV6di3fwTlIqSZgOEbwPbyl1oG8p+POjboegRBQSB+znwYH6jVtRwRbu3HHIwev/MRi/uU4hk2+OfgMfGkFCKBXCDIRpXCKITL2t0tSB6C0C7VY18Q3zKxUC3e38Lwm2ru/rptnKZrTfdrVrJ2Dfc2FjTT0Foj1aJfBWfIv2c40gJPvT3qLNYsmBS39/Q9k4CzHN1BRiy0AOn7c3PVPY0pZN6bIvLhnAUi+NXR27yQZQko580LgX7U
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ff52f3-4922-4081-925c-08d7eb570c19
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 09:32:19.6357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxwKryguO5DeSFbjDvNV40FfbcIiugx9lA1LRme7kKJyRzS7NKFRTsCcc+S2Jspg0dKMjknmlvgizEpLeFa6nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Sun, 26 Apr 2020 12:23:04 -0600
> David Ahern <dsahern@gmail.com> wrote:
>
>> On 4/23/20 3:59 AM, Petr Machata wrote:
>> >
>> > Stephen Hemminger <stephen@networkplumber.org> writes:
>> >
>> >> On Wed, 22 Apr 2020 20:06:15 +0300
>> >> Petr Machata <petrm@mellanox.com> wrote:
>> >>
>> >>> +			print_string(PRINT_FP, NULL, ": %s",
>> >>> +				     cmd ? "add" : "val");
>> >>> +			print_string(PRINT_JSON, "cmd", NULL,
>> >>> +				     cmd ? "add" : "set");
>> >>
>> >> Having different outputs for JSON and file here. Is that necessary?
>> >> JSON output is new, and could just mirror existing usage.
>> >
>> > This code outputs this bit:
>> >
>> >             {
>> >               "htype": "udp",
>> >               "offset": 0,
>> >               "cmd": "set",   <----
>> >               "val": "3039",
>> >               "mask": "ffff0000"
>> >             },
>> >
>> > There are currently two commands, set and add. The words used to
>> > configure these actions are set and add as well. The way these commands
>> > are dumped should be the same, too. The only reason why "set" is
>> > reported as "val" in file is that set used to be the implied action.
>> >
>> > JSON doesn't have to be backward compatible, so it should present the
>> > expected words.
>> >
>>
>> Stephen: do you agree?
>
> Sure that is fine, maybe a comment would help?

Something like this?

                        /* In FP, report the "set" command as "val" to keep
                         * backward compatibility.
                         */
			print_string(PRINT_FP, NULL, ": %s",
				     cmd ? "add" : "val");
			print_string(PRINT_JSON, "cmd", NULL,
				     cmd ? "add" : "set");
