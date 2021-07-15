Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F983CAFBA
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 01:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhGOXpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 19:45:25 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:10415
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229783AbhGOXpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 19:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DUfBhe5kmccoCPuJsLRKkVLl/4zIZRANaoTszALgFU=;
 b=gPbJQXUTOkNeZ1V6ZVEWe0cHUndKx4dpBxqR7Jq7d9ghLocQN2XwAxGdpGKe3hkhiUgCGthI9nDl9OSbmSRd5kTnhSSHRRQMyLvq+eFj1qPLBd4ia2f7L7mIiYoXQJYpbnvbIhChOEu0YE3N8+iJQl/DQ1NQ1jJZGGIPQvPWXxY=
Received: from AS8PR04CA0005.eurprd04.prod.outlook.com (2603:10a6:20b:310::10)
 by DBBPR08MB4378.eurprd08.prod.outlook.com (2603:10a6:10:c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.24; Thu, 15 Jul
 2021 23:42:28 +0000
Received: from AM5EUR03FT052.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:310:cafe::a6) by AS8PR04CA0005.outlook.office365.com
 (2603:10a6:20b:310::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Thu, 15 Jul 2021 23:42:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT052.mail.protection.outlook.com (10.152.17.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21 via Frontend Transport; Thu, 15 Jul 2021 23:42:28 +0000
Received: ("Tessian outbound 809237f40a36:v99"); Thu, 15 Jul 2021 23:42:28 +0000
X-CR-MTA-TID: 64aa7808
Received: from c41293bac246.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 62F9A022-8729-4B65-8230-9BA7B1A4CA1D.1;
        Thu, 15 Jul 2021 23:42:21 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c41293bac246.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 15 Jul 2021 23:42:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYlZAAwtZzl/AIqyiLol0wVhCu0zzLIEWO5D5hC45LAlzD5trZofEE4k4sdwo4bpeo2hT5nMU1QIDWIJGtXl9IDrdgJrvWfOCNoI4SNeiD3jgcIJZiP4r0TTSkuhxihcnrqiiUVS/pa8AdfZ02gUyMZoWvlCKwnNluC3agbe7bvzV5oZkr1ict3zHrNKZZctE49eZJWTwnErL+5iINuspix12eiF3vlJDmU+NLOo/dI2l3/roHy96qZmpGDkcGxGyJSzK2tk0NRmp3RsXWWJfuXAgsm0yxqlOq14caFGoW01zbfQhqebPZlfk17/acsFi9cH/oiXT+INDFkYfyswgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DUfBhe5kmccoCPuJsLRKkVLl/4zIZRANaoTszALgFU=;
 b=KL16folH4Pv1yAInlVuXrPfQJwJ7XxVaTlLTc5qrlaDoS/bUuUoHufrAskX7t7HZnHAOjWgFX5wXJwrgx5j+lVsRjx9jfpkfs/K2gNF9WXldWsBxYacB9qJL4KGnggA3KNixe5Qk1qTBkQF/rdp4KpozoW3HGi6YiTat4bzFEp4Xw0X3reLc99eIcGJJ7syZGCTIRST7sZ8xbd4VOQ2osU+km9rIg/q/KtkyjySoXTAOagiakcl4RGlJ+gd3/PWlwXdMQrvC9lwVgUAaxVvYktj68YAQ0yKNdiX69CZ1DO1tqDU3KlLm18kIuhWqJ9mCmr549uljnYA0AGbJBsxT0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DUfBhe5kmccoCPuJsLRKkVLl/4zIZRANaoTszALgFU=;
 b=gPbJQXUTOkNeZ1V6ZVEWe0cHUndKx4dpBxqR7Jq7d9ghLocQN2XwAxGdpGKe3hkhiUgCGthI9nDl9OSbmSRd5kTnhSSHRRQMyLvq+eFj1qPLBd4ia2f7L7mIiYoXQJYpbnvbIhChOEu0YE3N8+iJQl/DQ1NQ1jJZGGIPQvPWXxY=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB4881.eurprd08.prod.outlook.com (2603:10a6:20b:c8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.26; Thu, 15 Jul
 2021 23:42:19 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1%5]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 23:42:19 +0000
From:   Justin He <Justin.He@arm.com>
To:     "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>
CC:     "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>
Subject: RE: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Topic: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Index: AQHXeVClyEXp90xYxUyzsooHikRZAqtEcpkAgABAN8A=
Date:   Thu, 15 Jul 2021 23:42:19 +0000
Message-ID: <AM6PR08MB437697F8EFDD9C2BC33E9836F7129@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210715080822.14575-1-justin.he@arm.com>
 <162637860846.25047.7819900930468592075.git-patchwork-notify@kernel.org>
In-Reply-To: <162637860846.25047.7819900930468592075.git-patchwork-notify@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: C1DEAE53E15295499B254D77D6FEE6F9.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 9b4885f5-4ebd-4791-e0f3-08d947ea34ca
x-ms-traffictypediagnostic: AM6PR08MB4881:|DBBPR08MB4378:
X-Microsoft-Antispam-PRVS: <DBBPR08MB437847DDF886D7C5AF55C981F7129@DBBPR08MB4378.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: gmCoMeYa1wX4rEgkwOxBHpsLNeZkLC+l6KXZDjEwnlK5cRGjezt+i6c27nX4l/Yw9b43MmAKFRlcMDlos+CYqIykWuvZZuhkPuBYZeJVI7kO0UhXJ1oE9SMMms+QVBSTLkOeyrOO/jGnMVgp4Zi94zCWeAN2smiDsO/gQxmrW3eIc70NY63QgfGjIz41IuEYWMZbi2dRLLuYc1gdMLBnpAaxqFKdZYBLGlc0pzXoMS83vgXIFOL/dn9AH7TFLl3oiMUr3UmrQltX9h64EMFBQkGl7iqX+Bfpiix+fS44LDi1EtR2HxA1EPwBlUuanek3whA+qyo+DTLGd3ItxviKA+CRw5zRuSBIu/AJfnXmZSZ9QxMzcdrTqy3a5LsPp80l8f1wGvccTt/Q1Txl5TcDVSHlssJhC90vTqy/Qkw6wpPmhlRqMmzzA+sTrB1xDLMoRIanOg9AA3NwiKsqz93LGw30Y70lTHR3RbdnMJh/ZBVXERT5s5kkJ7SiwxOuQhmN9rI/gsFhULtR8Q3mL3Xs6DcGmc+eZgcKAc7gIVE/lXPXpW983nDVpd7+ZfL48NTuKJMW5fpi/PfBzlINiqQFB9rhXDWaEZTjqn9Gke/db05c5TFLg2wb8q+zK7hNOQxt+iciXhGv7xQlTgl6kz4piV23rQqjvI/ig3avk2zwkrWuk3qpgZN1n1VG/I5aLBp7Qk5hHebQG3VKi+1YMI66ysLCkSzoAhqnfyAhCh2iXgdnzHmY2fj1gdhVYPzkOI3/0cCIJQFNuJtIRKnfuOFiOTpmp/d5rJda3wqwfpMatU8=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(136003)(396003)(346002)(376002)(33656002)(64756008)(5660300002)(76116006)(71200400001)(6506007)(8676002)(55016002)(52536014)(66446008)(122000001)(83380400001)(66476007)(316002)(66946007)(66556008)(53546011)(7696005)(9686003)(4326008)(8936002)(186003)(26005)(966005)(478600001)(54906003)(38100700002)(86362001)(2906002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWVMYmllSHE4ZXkxUnhXUzdWMTFUVmRlOGhzV1BWa3ZCb0pJa2FYMlN3Nm93?=
 =?utf-8?B?b1RiSG1Kd3FoZUY5ejNzaXhpYkZEL3o0TC9VSDdwZ1lERk1FQ2lwNWhzYTJX?=
 =?utf-8?B?ZzJKT3VraTFuNkFOQXp1V3dGenBRdFBaODAvTGNFUVhkNGErcGlSeHlLMmxC?=
 =?utf-8?B?VXRvc1daM2piMi9kbzRiajVpVlRqdFhBdTRZdlN0SXZaQTdIMHRLUG91ZGRL?=
 =?utf-8?B?MU1iQWI5UFQ1bmpwbFZIaGoranRabGZ3YkJwSWN6V2xXdFZOcmc5ZkQ4bDZO?=
 =?utf-8?B?TFhNbW5icUhiejNjdjBaKzhaQVYwZHhwdHBLQVVkRnRFRnJHbkVUYzYyZXhu?=
 =?utf-8?B?dWpSWXR6OVdtVFNKL1lqZ2dJYlFaYTkrMFQzdWJjTTFhMjY1REVYa1o4Y0Ra?=
 =?utf-8?B?OHFhTm1NNjVDVHQ2V1lnN3FKbDV6QWJET3BEMGlZMjFWRG9yOXdFY0NIWmZ1?=
 =?utf-8?B?aVdjdVpFWWNvaHQyaHkvN2VvOFB2aTVKVGJFNUdZVllsT2ZYOGhxUGczNHds?=
 =?utf-8?B?aXNteDE0d2NEMmY4U1VrdDlyRDBGVUg2WXpEeGptOVF6YVZTd0gwUFVvY0Ex?=
 =?utf-8?B?NkxLZ3VBaDlKUFB3NERoSExNd3JkcVRmSy8wQlVHVHhIeFlKYkpZOU1IQUZO?=
 =?utf-8?B?YVlrL05MSFBjU05TMVJJOWh1UzBkdTgyUE5XM014WVlFdktsMlNQK0xNQS9V?=
 =?utf-8?B?d1phOG1mUkV1SnZ3Q0dQV2pSenpvZTNjM3pkWHErUWVqYy9KdTlmSHBMLzFq?=
 =?utf-8?B?aUZSWUZ3am83OUFmVHppNW1acVNOWjd5ajgyT2ZPbkhMdVhEeEQvY2Uvd2t4?=
 =?utf-8?B?cXZ4THF1clZtTGR6c2o1aUlpMXJ5Qk52VFZIdGxyQ09acytneml4WktUbDJy?=
 =?utf-8?B?cDVHN1ZpcjJJNzZLSFB3M0hYSDJ6RmNlTmFwYXg0VzMySmJsY0IrTnJkd2hz?=
 =?utf-8?B?bDc5S2ZDY2JhOFN1ZWRIVGJRdTFYSkZENVlYcnhyYlAvT3hBcDU1dHF3REZR?=
 =?utf-8?B?djR2OVpSWjF6M0xaSXIvN2V2WUxOT3I3ZG9mT2Jva2J1d0w4ZTV2SU5OYjFF?=
 =?utf-8?B?UTNoNkhjK3hTRnd3WTFTeE5BNmxBcDJVLzhHWm8xRHpqUXA5NUdxSHhHZlR1?=
 =?utf-8?B?STRlQmo1cHk5YnJhZ09ZeHJnWEE2UU9pdjltemdGVmF5R2pXYlhmRHN5VmQy?=
 =?utf-8?B?YXo2RGlJNkVxaks2WFV3Uzc5aW1PajRaeDM4My9KWENNYVpCcDdEWHNuUlJY?=
 =?utf-8?B?Mm5pdGxNT2Q2cCt4eTdOd01FQUVaaU5HSFJZNm91UEZicStaOEN6NG13U21a?=
 =?utf-8?B?UnU3Q0p4SlMrdUVUdkVCZTNTQ3B1R1JVSEF2Z3UrazR4NDRDY1UxbXVTSWVB?=
 =?utf-8?B?VEsydlVYYWVoVXg2blVwQ0s3QjVZcHJLakNaNDVNQmYxcytSMk5yYjd5VUg5?=
 =?utf-8?B?UDd2K2xLWUhncEZPYXd0TkdlRVVEKzMvUXE0RmpXbjBEY3pJcFF6ZjMrOVNM?=
 =?utf-8?B?K3NiSXhNNDU5V2xrejVONjBDUkZ4d25namlmZFhxUDRSVWxuTVljeW5EZTZh?=
 =?utf-8?B?Z0ZDZDFaN3RRODN1V0k0NUk5R0o0eU05YmNSVjFiZy9uUldYMHU2WlgxN2s1?=
 =?utf-8?B?N2E1N21JMFpZYWVFWTRIVUVHazJaRDh6UjRSODY2VEpGMzR4TVBsZWJWWmVB?=
 =?utf-8?B?aFFCN0RoNHlDZDhsbmRVU2dpcDQ2TE5XdjBjdk1OTmhFUGZGSFowM0pWdStD?=
 =?utf-8?Q?e8erUfDQnd1OtYjaRhGVF8ibAqZhdMR5L4bJrXG?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4881
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 55da23ab-5ffa-48c9-5845-08d947ea2fc1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v77VywGnwNDwTydvigwhCpEyCkC1coqKENZgwfo605K0jJPoWRAj/h8CslP2w8Kx0tAq5CIGnlWe+3+/93D+lgXFCllStCZ76NOyhZxtRtM/e5kCLjz2k/3bpKG5a06EP605/zc3m+AriDgbzF6xG3vTTtPOOR11Cqajqg/LRRIq69x5MSCEJspvuWK9ASuuq6+hj0VXRAQbEeCAXSQVhWB1N8Ig2ocw3txBL3CW6qCtRA54PSZnFkskjRNSE7IUmpTOSlPA2dBbUVNYSzePzbG8AraAWe4ZRas9491ESim67dDWpB/0iPdrfeqgSUmWLC3TPl7JyukPKd+Z10BIsmPKxHDA5ZHCMNKRvRxwigu7QxgOMuuiYrc5FMVzVf4pEU3DT5+jtgCNTE65FGuRa+Rfo1XMDiRFYqli+53SoCTgzbD7a3eRtpBU2Zzykesy4RYCUQhfPq1gRUic5KK/Tfu1PObV0bgbxeSQjEwZ87O8nXAw/Vbhfoy9LsoeFD8BDKLBhvpF5k5LTcUmVoo7C4wDYIMQvAOxd3msAg/SLgdj4livSB6Vgtrs4w21VOtpgE8ylLAXc/+sR2iks1O9NQswbUPjqETR4hVl4GUoedKu2doJo50kRwAXZVV7Bap4GFI6Aob5P48kT/NN6MRxLzK8MO0pHokU0AkAmZVNx2Fg7eX7iEjAMPZIn1O2hkTa1VB11SmapeWdHydySQwPVrYfXuYYoG/uYnYEqPh53Xo0kIJvczVBsyGkPVfHYCZLPfSdtdmTQOyHM9N8CEaH08KvCDySAmBT3JGWig02qrA=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(396003)(376002)(36840700001)(46966006)(316002)(186003)(450100002)(82310400003)(53546011)(4326008)(8936002)(2906002)(86362001)(5660300002)(33656002)(9686003)(6862004)(70586007)(83380400001)(336012)(52536014)(55016002)(478600001)(356005)(7696005)(8676002)(26005)(36860700001)(966005)(6506007)(70206006)(47076005)(54906003)(81166007)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 23:42:28.2326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4885f5-4ebd-4791-e0f3-08d947ea34ca
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT052.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4378
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogcGF0Y2h3b3JrLWJvdCtu
ZXRkZXZicGZAa2VybmVsLm9yZyA8cGF0Y2h3b3JrLQ0KPiBib3QrbmV0ZGV2YnBmQGtlcm5lbC5v
cmc+DQo+IFNlbnQ6IEZyaWRheSwgSnVseSAxNiwgMjAyMSAzOjUwIEFNDQo+IFRvOiBKdXN0aW4g
SGUgPEp1c3Rpbi5IZUBhcm0uY29tPg0KPiBDYzogYWVsaW9yQG1hcnZlbGwuY29tOyBHUi1ldmVy
ZXN0LWxpbnV4LWwyQG1hcnZlbGwuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtl
cm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBuZCA8bmRAYXJtLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gcWVkOiBm
aXggcG9zc2libGUgdW5wYWlyZWQgc3Bpbl97dW59bG9ja19iaCBpbg0KPiBfcWVkX21jcF9jbWRf
YW5kX3VuaW9uKCkNCj4gDQo+IEhlbGxvOg0KPiANCj4gVGhpcyBwYXRjaCB3YXMgYXBwbGllZCB0
byBuZXRkZXYvbmV0LmdpdCAocmVmcy9oZWFkcy9tYXN0ZXIpOg0KPiANCj4gT24gVGh1LCAxNSBK
dWwgMjAyMSAxNjowODoyMSArMDgwMCB5b3Ugd3JvdGU6DQo+ID4gTGlhamlhbiByZXBvcnRlZCBh
IGJ1Z19vbiBoaXQgb24gYSBUaHVuZGVyWDIgYXJtNjQgc2VydmVyIHdpdGggRmFzdExpblENCj4g
PiBRTDQxMDAwIGV0aGVybmV0IGNvbnRyb2xsZXI6DQo+ID4gIEJVRzogc2NoZWR1bGluZyB3aGls
ZSBhdG9taWM6IGt3b3JrZXIvMDo0LzUzMS8weDAwMDAwMjAwDQo+ID4gICBbcWVkX3Byb2JlOjQ4
OCgpXWh3IHByZXBhcmUgZmFpbGVkDQo+ID4gICBrZXJuZWwgQlVHIGF0IG1tL3ZtYWxsb2MuYzoy
MzU1IQ0KPiA+ICAgSW50ZXJuYWwgZXJyb3I6IE9vcHMgLSBCVUc6IDAgWyMxXSBTTVANCj4gPiAg
IENQVTogMCBQSUQ6IDUzMSBDb21tOiBrd29ya2VyLzA6NCBUYWludGVkOiBHIFcgNS40LjAtNzct
Z2VuZXJpYyAjODYtDQo+IFVidW50dQ0KPiA+ICAgcHN0YXRlOiAwMDQwMDAwOSAobnpjdiBkYWlm
ICtQQU4gLVVBTykNCj4gPiAgQ2FsbCB0cmFjZToNCj4gPiAgIHZ1bm1hcCsweDRjLzB4NTANCj4g
PiAgIGlvdW5tYXArMHg0OC8weDU4DQo+ID4gICBxZWRfZnJlZV9wY2krMHg2MC8weDgwIFtxZWRd
DQo+ID4gICBxZWRfcHJvYmUrMHgzNWMvMHg2ODggW3FlZF0NCj4gPiAgIF9fcWVkZV9wcm9iZSsw
eDg4LzB4NWM4IFtxZWRlXQ0KPiA+ICAgcWVkZV9wcm9iZSsweDYwLzB4ZTAgW3FlZGVdDQo+ID4g
ICBsb2NhbF9wY2lfcHJvYmUrMHg0OC8weGEwDQo+ID4gICB3b3JrX2Zvcl9jcHVfZm4rMHgyNC8w
eDM4DQo+ID4gICBwcm9jZXNzX29uZV93b3JrKzB4MWQwLzB4NDY4DQo+ID4gICB3b3JrZXJfdGhy
ZWFkKzB4MjM4LzB4NGUwDQo+ID4gICBrdGhyZWFkKzB4ZjAvMHgxMTgNCj4gPiAgIHJldF9mcm9t
X2ZvcmsrMHgxMC8weDE4DQo+ID4NCj4gPiBbLi4uXQ0KPiANCj4gSGVyZSBpcyB0aGUgc3VtbWFy
eSB3aXRoIGxpbmtzOg0KPiAgIC0gcWVkOiBmaXggcG9zc2libGUgdW5wYWlyZWQgc3Bpbl97dW59
bG9ja19iaCBpbiBfcWVkX21jcF9jbWRfYW5kX3VuaW9uKCkNCj4gICAgIGh0dHBzOi8vZ2l0Lmtl
cm5lbC5vcmcvbmV0ZGV2L25ldC9jLzYyMDZiNzk4MWEzNg0KPiANCj4gWW91IGFyZSBhd2Vzb21l
LCB0aGFuayB5b3UhDQoNClRoYW5rcy4NCklmIHBvc3NpYmxlLCBwbGVhc2UgYWxzbyBDYzogc3Rh
YmxlQGtlcm5lbC5vcmcgYmVjYXVzZSB0aGUgYnVnIHNlZW1lZCB0bw0KYmUgdGhlcmUgZm9yIGEg
bG9uZyB0aW1lLg0KDQoNCi0tDQpDaGVlcnMsDQpKdXN0aW4gKEppYSBIZSkNCg0KDQo=
