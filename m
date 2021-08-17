Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFB43EF27E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 21:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhHQTJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 15:09:58 -0400
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:3937
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229821AbhHQTJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 15:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y+T1uYXU5QbBNhbzYR4B0DxFOjFmg/v8B6LWN0WI7k=;
 b=oco8TjwgHsAIw68dMs5fO/CZ7un7DDBqXytBZ72nlsHnb502CxevSpnAtmJVOGkbtXr0VJJ2v8vPx/bNdSZ1m5+uZHchVkvQSOAm6YcHWsnlyi0F1a67NfmZhaMkVT20maYvLJPT8zPmtDDWEzoMxP3W0Qj9YxUh1u3aKwZcmgM=
Received: from DB8PR06CA0018.eurprd06.prod.outlook.com (2603:10a6:10:100::31)
 by AM0PR08MB3204.eurprd08.prod.outlook.com (2603:10a6:208:5d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Tue, 17 Aug
 2021 19:09:04 +0000
Received: from DB5EUR03FT053.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:100:cafe::96) by DB8PR06CA0018.outlook.office365.com
 (2603:10a6:10:100::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Tue, 17 Aug 2021 19:09:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT053.mail.protection.outlook.com (10.152.21.119) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 19:09:04 +0000
Received: ("Tessian outbound 8b41f5fb4e9e:v103"); Tue, 17 Aug 2021 19:09:04 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ee4756271902b4e5
X-CR-MTA-TID: 64aa7808
Received: from 71da10f66893.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4549CF06-CF40-4832-AFEB-88864D2F2B19.1;
        Tue, 17 Aug 2021 19:08:57 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 71da10f66893.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 17 Aug 2021 19:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJ0ztJtz9R0prjsBMe92LYLsJZtKtgz8EpFYoATkjpauYaPBXfqEGYcfsEtTELhzaUCiPOms4ad9ekXlIpaahFiY8tA1S3URF4OBjj0cTALLxunZtBmDF3VbCbAnvnRFtruwQbF6EaAfQ+xFL3nBZogAT+/GKAaZ6zXOk6fTeag39NjVBR9GENByhiWPsJtWItA4N/hJANlwgcAwcYKOld7S52MRU70z4FVTEfQCBFrABqVsNkpkoIwf9jra9meSua6FXBJ5DM4aCiJp+GdzSV8JWXX0tZ2Emb1m15t7C5JOzuBVZkmKtlShWxt60U94mI2u/yyGjupMWJXeI0ONlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y+T1uYXU5QbBNhbzYR4B0DxFOjFmg/v8B6LWN0WI7k=;
 b=kPckAYKdCcB5vLzDGqVolJWCEkE8ozqBONmNYodAaxrAQn16FiKhbxNsBCRJy989WZUy934zSKvjn/5baeJdS6SPEhG67p2otFeapM5Q+dQLydc1WrjoXKAdnRbwDLwUULADmi1N8RqCWAgXBuSXmjH79+UU7bhroPb0vfXIU1YQ1O6wFxI3vAuZe6WuarhTMz2Axx7QrtCkGFOS1frajMoNn2gkNkfoOMLFZEH9Td0vJT+saoi3a+q9nElYQCKF+21z6x6vsByy8hKSW6pAoI77cxxop/KJTThONWaKTL/CcDWMjdzzzqqcCfJnWND80iQzwzLJbyaXmqUlrYWnRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y+T1uYXU5QbBNhbzYR4B0DxFOjFmg/v8B6LWN0WI7k=;
 b=oco8TjwgHsAIw68dMs5fO/CZ7un7DDBqXytBZ72nlsHnb502CxevSpnAtmJVOGkbtXr0VJJ2v8vPx/bNdSZ1m5+uZHchVkvQSOAm6YcHWsnlyi0F1a67NfmZhaMkVT20maYvLJPT8zPmtDDWEzoMxP3W0Qj9YxUh1u3aKwZcmgM=
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com (2603:10a6:10:2ae::5)
 by DB8PR08MB4154.eurprd08.prod.outlook.com (2603:10a6:10:b1::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Tue, 17 Aug
 2021 19:08:52 +0000
Received: from DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::8cfd:d08:dc3b:8a38]) by DB9PR08MB6809.eurprd08.prod.outlook.com
 ([fe80::8cfd:d08:dc3b:8a38%4]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 19:08:52 +0000
Subject: Re: [syzbot] KASAN: use-after-free Write in null_skcipher_crypt
To:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot <syzbot+d2c5e6980bfc84513464@syzkaller.appspotmail.com>,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, ioana.ciornei@nxp.com,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, dkadashev@gmail.com
References: <000000000000c910c305c9c4962e@google.com>
 <7f4eed54-4e40-2e85-eaaa-95b1864c6649@gmail.com>
From:   Grant Likely <grant.likely@arm.com>
Message-ID: <bed2a960-f561-e48f-5676-c662ec5a5555@arm.com>
Date:   Tue, 17 Aug 2021 20:08:49 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
In-Reply-To: <7f4eed54-4e40-2e85-eaaa-95b1864c6649@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::13) To DB9PR08MB6809.eurprd08.prod.outlook.com
 (2603:10a6:10:2ae::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.16.128] (84.66.8.245) by LO2P265CA0145.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Tue, 17 Aug 2021 19:08:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f67acc16-dff7-426a-059d-08d961b27af0
X-MS-TrafficTypeDiagnostic: DB8PR08MB4154:|AM0PR08MB3204:
X-Microsoft-Antispam-PRVS: <AM0PR08MB320498969496A8BD37382FD495FE9@AM0PR08MB3204.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: wT31sSVLRHAKkC5RTJmZhFUdTJfkErbq9MPIuMKTKW+A8QC26qar8CTVDxTGGfylhDcSAyy0ehQzT050G9kNKgB1TEIVSx0bWboSfH2HF9yxqMfqzfmK9eoHicuFGfamMRcTX9aiNTw7hBLj6E7sbbW+Y9UYhhsYsAXsxyK1HSSt1270vHvzwFM7CwI/ILwz/lYki4DcO42pAS744zG5Lq8zQdCyroRfNJUn5oS0vf25IEhkQbl3lmR/Gu9EHQdEA6JSCbO+9EbLKyBsRzRZspq+UbH1PTDZxz4bdRhGKip6s86EBUfj6yvViYUQ0wRMwteu9CYwmaOHUfrXh+6DSnxXEB4R7s7haOYzJjgh/sQqpHnPfRyfatgcWJSyVvj8DgsabDn4KlzQcD2eubltuz8KPAsNC1LpSN1gWjkFvCJPy8ltMqzkz5s0F9qtVMg1EVI+5xXUXKFWaJ/1XyJ69twfM0lK24QYs8WVLHZPvw2l6H+PdxoEDLjAj4Lsm6xRzAV0ovOtw+wJBZAtRUYXqQkPXaDCTBE9oA3vRZxfoNhB7tQle57tFsLhn8qka2TDZxdybTMJEh1I5GNnXgKSX6OCymvxgCHKaZ48DyIX4Q6R4CpVxo1P0BzfQlBuwhbccGRKk7qnQtrKF/VhTW5u6sNJI7c0qV+Ecn9vKS+bnxL1DZl25irC06JCubVUXW0GF8dilAqqJPZxUjC3u+615hBiyzx0PGXvW3ugfLJ9i3VTjtiRzEJ7ngirApqdnvDB6SQ9y/H7jiijha1ZgAJb+h5BLs91JSxer1DH5gMJ/cYC70DyI/EZ73AFgDP2VkI26gmycZz7RWASSjg+qiNl4N/u6dSDBT5EiqigC0SS7qFFbd7qXhxdzyyVHiNf9fKLtI8LmvHJhdotwKnQ/ocOdA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR08MB6809.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(921005)(16576012)(316002)(31696002)(110136005)(66476007)(66556008)(6486002)(7416002)(26005)(966005)(44832011)(5660300002)(8936002)(956004)(38100700002)(38350700002)(2616005)(53546011)(66946007)(36756003)(508600001)(8676002)(186003)(2906002)(31686004)(83380400001)(86362001)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmx5K2sxaCs1VDNEc0lFMHVVcTJsZ0duY1FFSnc2aExBUkRaMGxLaEs0eFpW?=
 =?utf-8?B?ellSeCs5YzBPeFpYNHhsbjk4NUg3cVU5M2p2SGpiWFk3YmNabFFiUG00M2dV?=
 =?utf-8?B?RDFrR2VBUnBXUUFLZk5zTm5hWDlDM09vMGU4akpBb01xM2NiSVZEYXBjelZz?=
 =?utf-8?B?NGJldHAxVGZhLzhlM2dUL3pVYXEwYlFyK25JOW1DbmFxUHhnSWEyS1pKM2Zq?=
 =?utf-8?B?U1ArVWlGTHByZXhzTzBlZ0VJMUZ1alJaR3YwbG51Qlh3ZE5QVGtORk9DUytv?=
 =?utf-8?B?YU9iY0Y5bmpwNmh3YnVTYnRuL0ZJZktWWG9PbkpaRmtFUGJNUEx3T1U0RmFZ?=
 =?utf-8?B?ajY1UzVOSERBM0FuaXZ4S3hyY1IySFZOckhkYzBEMUVnVmR5bTluVWpWaVdo?=
 =?utf-8?B?dUZUdkRqejd4cTRwaXlWQTVEZFlNcDlxSytkQjJ1SmhIRnUrcEJJayt4NExz?=
 =?utf-8?B?ejczelBjZXVkQnpZOFU1SWpqQ2U1a05jNWtaVzFseHlMOUt0VmdwR0EyVExX?=
 =?utf-8?B?Y0V5MTBmNnRmYVQvNDQ0ZjZDNjlPNk16ZW0yVjFnU0xlV2RROEtOeXU2dGlh?=
 =?utf-8?B?TnhjckxSbmdUNEI2dDBQM0lLNkp3cVNIb2ZOTElxQUVEekxhMDRacUNOa0d5?=
 =?utf-8?B?ajhZdnR2L0JoclUrRDVjdUd0V3RjYk5FTURPQStwZjVkN2ZUellRb1E0RlNx?=
 =?utf-8?B?bHoyTmhoNlkvNUJ3UjZaY2hOVVdrSjJsNEZBdE5EdVMzTGtFR3ZlSWpURnJF?=
 =?utf-8?B?cFVsMStrQWU5TjNvNERhNmhOSHJTWVlQZXErTXZjSDFNMExHM1ZlLzhxTWhB?=
 =?utf-8?B?TDVrd0V4eUFPakIwZGp6Y2dkcDMxZ2dFbno0SzhYRzNZak5IMUYyMWkzdmxR?=
 =?utf-8?B?TnEybnZuMFFMOWE1TUR5MWV4MmJxdTZGbW1taTd2VloxVG40KzlnYTV3aVIy?=
 =?utf-8?B?R1Q5SWhhVFpmV21hQUczclgxbzJMaTQ5M25la0xKZ09ZRHpacTdlc1FhS2dE?=
 =?utf-8?B?R3dMRjZHeHN0d2tLQnZVUmtBQXE1SGdZRk4vQ3NGMGNwVkhtNTE4Q3I0bGg2?=
 =?utf-8?B?YVYreTJ5a1B4S1hWOXFSMW13dzRmcHlCallONUpkQUFBVit0OUJpYkNlUWNn?=
 =?utf-8?B?M3hGdjZCN1pHSDZWTGpCRHRmcElXalpFelRNK04wSEUyckhWa0dCYVpCQ2Zh?=
 =?utf-8?B?SEswanFxaFlrVWNSRE93c3JZQTlrbENnN09CNkNtVTZPZ3Q0YjlqS1NJM0RK?=
 =?utf-8?B?SkttRFl2dEM0OGVISC9XOVovNkd6OUlzYSsrbng3cGkwcVNQZ1pGQk1yMU12?=
 =?utf-8?B?WkxFSWdIREo3eGhtaXV2c21DcW9SQnBQRFJDT2VtK2dESkE0NmVSbitzeFpV?=
 =?utf-8?B?Um1yeUlBb045OGJmRGtrMmRybUZsVzVDN0JyV0R2a2o0bTBNL0h2TTgrT0JS?=
 =?utf-8?B?SjRxSE83NlZwMWVoYUdXbzFzdkZLQ0FTbE1kbGRMS1VqVW9KM29KZFdoaUpa?=
 =?utf-8?B?eFpFSGJHSkpLVDVlZzBSWWkyQUpmTHZ5UnA0VkhOVXRMeWpvUlFkYzFZTlg4?=
 =?utf-8?B?ME81cTVsZGdMQ0pSbzM4Yi9DbFk5L0k2bzJ5cnZubjhBWmRhRzZ6RGRCNDNJ?=
 =?utf-8?B?RlM4QnY4UW03U0NnRWx4ZlBvaWFIVTJmZUlPVVFTU1U0L2JGR1MzZkw4VC9K?=
 =?utf-8?B?M0NCUVRzL1U0bTU0UDZrZXpnSE1zVTE1NENjZmVWTklzRTFramVLMHBhOUdZ?=
 =?utf-8?Q?sCdmq50alrth+8wi7GZrcpmYx8vy2q66wYy7PfR?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4154
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 49c414aa-134d-4208-7127-08d961b2737d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rudyejO3IXmTEVD6GCu2uZvr/oSJdwon6LckaDSjlahBIRXlNg68DVdlt9VfBg8adev9T7KN1HNzrSIH1wVt0GU24COIEH3R9b+eB74h3i8nGBOo/at1e4YgAzedz8nCEEwLJbuQYKE2B0i1mcvId45SWTgVphQbPh8ihL0ctyt/0DVozWeqi1S5XWOZAB00DD8/zHIu7s9qpp5iK0Slo7z0fc1UH6WqTtljz1uZbakVYA9hpvYCOxXfX3OiobsAi25aGqc4nBALqTtta+SDvOyfYowZKpZSktNwcYk0/y5H17nFb2kaYF1CEgbFG7Vof4gGmvHNw9IyeUPJBaI53pwklHdSbi/s75Rr1II2RWLy8+U80S1bjlwNhIYNl6A1wCUCrmvBTWK4Puc1vZydPJgi/A4td4T8LOYALj7R/s3NOFEfGnQaNJMAuH4mA2PGVS4keUIxqCKWb1/F8faNGdLEyeb7CAnOF2wNfSxfygsN5IvfptYlxWRL5Qjt/WPxvcLlL+Ev3Sb70dNDb9qqp+CNjf1u/UZGP44fWsS5zEMDWCC+rx9H5REYhMat/1TxcGbwbtkYH0EmC8mK22wrJPgXJRRRdZCC+7nt+SzZQzUIhz1sUN7ZVaBmbFBeafiZh1KXcVauvnNvq87bx9J/0TMMiZvWEvwqeLRiS0FqdLHXVSqWoyHhy3Qcrrfzux+t9SXhFBgy5vg55lz7lxYhq/3XOS2Jxnrk92GyFIiZ0yBvcfTaZQVMGaDRyI9YpEHWD5tpIdQWA5apbKax5TaqZIG3tQMVtzfZDBocJIheUgQkcXKjQfOoRsjzjy0iQvz2JuEWNAwqHIklQHM6VOtH6DNqcMF/Dwk9ziKdEfzY8s8=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(346002)(396003)(46966006)(36840700001)(82310400003)(478600001)(2616005)(31686004)(356005)(47076005)(8936002)(450100002)(956004)(8676002)(966005)(336012)(6486002)(44832011)(921005)(81166007)(16576012)(26005)(83380400001)(316002)(110136005)(186003)(53546011)(5660300002)(36756003)(36860700001)(82740400003)(2906002)(70586007)(31696002)(86362001)(70206006)(99710200001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 19:09:04.4099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f67acc16-dff7-426a-059d-08d961b27af0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3204
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/08/2021 20:04, Pavel Skripkin wrote:
> On 8/17/21 8:24 PM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    a9a507013a6f Merge tag
>> 'ieee802154-for-davem-2021-08-12' o..
>> git tree:       net
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16647ca13000=
00
>> kernel config:
>> https://syzkaller.appspot.com/x/.config?x=3D343fd21f6f4da2d6
>> dashboard link:
>> https://syzkaller.appspot.com/bug?extid=3Dd2c5e6980bfc84513464
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU
>> Binutils for Debian) 2.35.1
>> syz repro:
>> https://syzkaller.appspot.com/x/repro.syz?x=3D14989fe9300000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12b1a7793000=
00
>>
>> The issue was bisected to:
>>
>> commit 8d2cb3ad31181f050af4d46d6854cf332d1207a9
>> Author: Calvin Johnson <calvin.johnson@oss.nxp.com>
>> Date:   Fri Jun 11 10:53:55 2021 +0000
>>
>>      of: mdio: Refactor of_mdiobus_register_phy()
>>
>> bisection log:
>> https://syzkaller.appspot.com/x/bisect.txt?x=3D106b97d6300000
>> final oops:
>> https://syzkaller.appspot.com/x/report.txt?x=3D126b97d6300000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D146b97d63000=
00
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the
>> commit:
>> Reported-by: syzbot+d2c5e6980bfc84513464@syzkaller.appspotmail.com
>> Fixes: 8d2cb3ad3118 ("of: mdio: Refactor of_mdiobus_register_phy()")
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: use-after-free in memcpy
>> include/linux/fortify-string.h:191 [inline]
>> BUG: KASAN: use-after-free in null_skcipher_crypt+0xa8/0x120
>> crypto/crypto_null.c:85
>> Write of size 4096 at addr ffff88801c040000 by task syz-executor554/8455
>>
>> CPU: 0 PID: 8455 Comm: syz-executor554 Not tainted
>> 5.14.0-rc4-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine,
>> BIOS Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>   print_address_description.constprop.0.cold+0x6c/0x309
>> mm/kasan/report.c:233
>>   __kasan_report mm/kasan/report.c:419 [inline]
>>   kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
>>   check_region_inline mm/kasan/generic.c:183 [inline]
>>   kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
>>   memcpy+0x39/0x60 mm/kasan/shadow.c:66
>>   memcpy include/linux/fortify-string.h:191 [inline]
>>   null_skcipher_crypt+0xa8/0x120 crypto/crypto_null.c:85
>>   crypto_skcipher_encrypt+0xaa/0xf0 crypto/skcipher.c:630
>>   crypto_authenc_encrypt+0x3b4/0x510 crypto/authenc.c:222
>>   crypto_aead_encrypt+0xaa/0xf0 crypto/aead.c:94
>>   esp6_output_tail+0x777/0x1a90 net/ipv6/esp6.c:659
>>   esp6_output+0x4af/0x8a0 net/ipv6/esp6.c:735
>>   xfrm_output_one net/xfrm/xfrm_output.c:552 [inline]
>>   xfrm_output_resume+0x2997/0x5ae0 net/xfrm/xfrm_output.c:587
>>   xfrm_output2 net/xfrm/xfrm_output.c:614 [inline]
>>   xfrm_output+0x2e7/0xff0 net/xfrm/xfrm_output.c:744
>>   __xfrm6_output+0x4c3/0x1260 net/ipv6/xfrm6_output.c:87
>>   NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>>   xfrm6_output+0x117/0x550 net/ipv6/xfrm6_output.c:92
>>   dst_output include/net/dst.h:448 [inline]
>>   ip6_local_out+0xaf/0x1a0 net/ipv6/output_core.c:161
>>   ip6_send_skb+0xb7/0x340 net/ipv6/ip6_output.c:1935
>>   ip6_push_pending_frames+0xdd/0x100 net/ipv6/ip6_output.c:1955
>>   rawv6_push_pending_frames net/ipv6/raw.c:613 [inline]
>>   rawv6_sendmsg+0x2a87/0x3990 net/ipv6/raw.c:956
>>   inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
>>   sock_sendmsg_nosec net/socket.c:703 [inline]
>>   sock_sendmsg+0xcf/0x120 net/socket.c:723
>>   ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
>>   ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
>>   __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x43f4b9
>> Code: 1d 01 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48
>> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
>> 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffc1e9cfff8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f4b9
>> RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000004
>> RBP: 0000000000000005 R08: 6c616b7a79732f2e R09: 6c616b7a79732f2e
>> R10: 00000000000000e8 R11: 0000000000000246 R12: 00000000004034b0
>> R13: 0000000000000000 R14: 00000000004ad018 R15: 0000000000400488
>>
>> Allocated by task 1:
>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>   kasan_set_track mm/kasan/common.c:46 [inline]
>>   set_alloc_info mm/kasan/common.c:434 [inline]
>>   __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:467
>>   kasan_slab_alloc include/linux/kasan.h:254 [inline]
>>   slab_post_alloc_hook mm/slab.h:519 [inline]
>>   slab_alloc_node mm/slub.c:2956 [inline]
>>   slab_alloc mm/slub.c:2964 [inline]
>>   kmem_cache_alloc+0x285/0x4a0 mm/slub.c:2969
>>   getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
>>   getname_flags fs/namei.c:2747 [inline]
>>   user_path_at_empty+0xa1/0x100 fs/namei.c:2747
>>   user_path_at include/linux/namei.h:57 [inline]
>>   vfs_statx+0x142/0x390 fs/stat.c:203
>>   vfs_fstatat fs/stat.c:225 [inline]
>>   vfs_lstat include/linux/fs.h:3386 [inline]
>>   __do_sys_newlstat+0x91/0x110 fs/stat.c:380
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Freed by task 1:
>>   kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>>   kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>>   kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
>>   ____kasan_slab_free mm/kasan/common.c:366 [inline]
>>   ____kasan_slab_free mm/kasan/common.c:328 [inline]
>>   __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
>>   kasan_slab_free include/linux/kasan.h:230 [inline]
>>   slab_free_hook mm/slub.c:1625 [inline]
>>   slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1650
>>   slab_free mm/slub.c:3210 [inline]
>>   kmem_cache_free+0x8a/0x5b0 mm/slub.c:3226
>>   putname+0xe1/0x120 fs/namei.c:259
>
> (*)
>
>>   filename_lookup+0x3df/0x5b0 fs/namei.c:2477
>>   user_path_at include/linux/namei.h:57 [inline]
>>   vfs_statx+0x142/0x390 fs/stat.c:203
>>   vfs_fstatat fs/stat.c:225 [inline]
>>   vfs_lstat include/linux/fs.h:3386 [inline]
>>   __do_sys_newlstat+0x91/0x110 fs/stat.c:380
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>
> +CC Dmitry
>
>
>
> I think, it was caused by 9d96ea38873f ("namei: change
> filename_parentat() calling conventions").
>
> Now what looks strange to me
>
> Upstream version:
>
> static struct filename *filename_parentat(...)
> {
> ...
>      retval =3D path_parentat(&nd, flags | LOOKUP_RCU, parent);
> ...
>      if (likely(!retval)) {
>          *last =3D nd.last;
>          *type =3D nd.last_type;
>          audit_inode(name, parent->dentry, AUDIT_INODE_PARENT);
>      } else {
>          putname(name);  <-- putting name if retval if not-zero
>          name =3D ERR_PTR(retval);
>      }
>
> }
>
>
> Linux-next version:
>
> static int __filename_parentat(...)
> {
>
>      retval =3D path_parentat(&nd, flags | LOOKUP_RCU, parent);
> ...
>      if (likely(!retval)) {
>          *last =3D nd.last;
>          *type =3D nd.last_type;
>          audit_inode(name, parent->dentry, AUDIT_INODE_PARENT);
>      }
>      restore_nameidata();
>      return retval;
> }
>
> static int filename_parentat(...)
> {
>      int retval =3D __filename_parentat(...);
>
>      putname(name);   <-- always putting the name
>      return retval;
> }
>
> And bug report says, that name was freed by this put (*)
>
> I guess, we should do smth like:
>
> if (retval)
>      putname(name);
>
> I didn't dig into details, because Dmitry's patch series was really
> huge, so it's just for thoughts ;)

Yup, that looks like the correct fix to me.

g.

>
>
>
>
> With regards,
> Pavel Skripkin

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
