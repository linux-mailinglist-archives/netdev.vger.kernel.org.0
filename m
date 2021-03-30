Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C40E34E513
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231638AbhC3KF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:05:59 -0400
Received: from mail-eopbgr60083.outbound.protection.outlook.com ([40.107.6.83]:9220
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231370AbhC3KFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 06:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2kGT4lNrvI8snknQ/1mTPJRVPkFMvvTSV+r8kmW5NE=;
 b=8JVwYQT6F2YraEAoOqjeBvOXaQoDeOOap59YCzddPKIoOfRdJnAu1a6RbYtOXbb6csxdCumwXEN2hcfyRDXoGZQqzcOfzJyDM0u08y/5uRMB2C3RlUwuD4Y4J5gnouPz5opkZt1KFhadyURIsStxkUJY9j6pwS9gxvEwylVqS1k=
Received: from AS8PR04CA0195.eurprd04.prod.outlook.com (2603:10a6:20b:2f3::20)
 by DB9PR08MB6491.eurprd08.prod.outlook.com (2603:10a6:10:23f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 10:05:35 +0000
Received: from AM5EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:2f3:cafe::39) by AS8PR04CA0195.outlook.office365.com
 (2603:10a6:20b:2f3::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend
 Transport; Tue, 30 Mar 2021 10:05:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT011.mail.protection.outlook.com (10.152.16.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.25 via Frontend Transport; Tue, 30 Mar 2021 10:05:35 +0000
Received: ("Tessian outbound 1b6dfb84c254:v89"); Tue, 30 Mar 2021 10:05:35 +0000
X-CR-MTA-TID: 64aa7808
Received: from 3310389db6f6.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 328168ED-9265-4DE1-BCDB-A3DC4AF0D1CC.1;
        Tue, 30 Mar 2021 10:05:24 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 3310389db6f6.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 30 Mar 2021 10:05:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdiIz82mTTr6SOw198dkgkqk8k0A+31dIw+MswwcCVjqT9kCcoY5LP3OM2a9VCb27ihVroAaJ0sgC4ensjk+Ee5TRGIUBWjBUZwXclQytp4KsxpJnsJek2J/YJm61mvPX0tBCIctUO7cUwJThXLpz9nJoF8ORwtBJmfL0nyxncLhAPGryUDdgg6F6ASB+PQT+NHPwmqInDU7WvUvb9Hjjn7w83vE9/JIhHE+tW4QYb9xSFbJvXe+L9wnhpWCI/bnLqMR5HQ/eD//08Mj13/P4ZMFsGfJtyo3suH+GONCYyTa5XIRbLgDni+4ihqQku0SxGBNcfclE2aze0ubrTyJwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2kGT4lNrvI8snknQ/1mTPJRVPkFMvvTSV+r8kmW5NE=;
 b=H0NuvaIMtuDuZkbdJk5wlS0NDgd1wB9ke0LidoTxl6Pf4uXSpLytPbLBmMi57RmGbxE/j7ERjMDOexHbRU6oBJCMMtaBoK79Fdyh5kDI0aWCYofGFUCBNKatx6fa7W5eVsgKvGIcMzXFI+WQhWArxsv00KHAPn2LMgsViDdoS358B0TlGUlZxyJuUN7ELlWn7VDLlo4oHM1Vl8yeZZWCOWl362CbM3UB8oQQQN40rYdCXc1f0eoj0toO1pi1n7r8gQf9mED8E+CYebAOogSNRqU4jcpdaK7AEj4kdljQydz9LMIcmRkNu7vFEU5dfNon78mB01nbKB2YEngdI5bBqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2kGT4lNrvI8snknQ/1mTPJRVPkFMvvTSV+r8kmW5NE=;
 b=8JVwYQT6F2YraEAoOqjeBvOXaQoDeOOap59YCzddPKIoOfRdJnAu1a6RbYtOXbb6csxdCumwXEN2hcfyRDXoGZQqzcOfzJyDM0u08y/5uRMB2C3RlUwuD4Y4J5gnouPz5opkZt1KFhadyURIsStxkUJY9j6pwS9gxvEwylVqS1k=
Received: from AM5PR0801MB2082.eurprd08.prod.outlook.com (2603:10a6:203:4b::8)
 by AM5PR0801MB1890.eurprd08.prod.outlook.com (2603:10a6:203:50::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 10:05:22 +0000
Received: from AM5PR0801MB2082.eurprd08.prod.outlook.com
 ([fe80::d1cf:ab3c:b570:fecd]) by AM5PR0801MB2082.eurprd08.prod.outlook.com
 ([fe80::d1cf:ab3c:b570:fecd%6]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 10:05:22 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Justin He <Justin.He@arm.com>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: RE: [PATCH v18 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Topic: [PATCH v18 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Index: AQHW/iAeZDUirA6w+ESkcbI2x50VbqqcmonQ
Date:   Tue, 30 Mar 2021 10:05:22 +0000
Message-ID: <AM5PR0801MB20820473E5882F4AD344C96AF47D9@AM5PR0801MB2082.eurprd08.prod.outlook.com>
References: <20210208134029.3269384-1-maz@kernel.org>
 <20210208134029.3269384-8-maz@kernel.org>
In-Reply-To: <20210208134029.3269384-8-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 40AF036CE8D8054B8476DD6B7956A9F5.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3265e474-6c89-4fa0-c5bd-08d8f3635cd0
x-ms-traffictypediagnostic: AM5PR0801MB1890:|DB9PR08MB6491:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB9PR08MB649119EBF8BE7E51F2D7CD79F47D9@DB9PR08MB6491.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Eh2Q/Ni1KUh5GTpBfJPO3gNHcBdjw7R5qWa+Wrfa33X0M4ogw0HhuEeYfBNbX74v6d/Vjbm18LWoYyTqZGKRtAbWUVrcGn36AewN2fvdUJszr6FEILLYho+CM2AeKARpMpQn5NKRNvlrAa5pF4HiAJlPJ8X//aDZYuIon0J98axDc+v45WRRQWOrasbNsSnf4mPYVKgnLpEjjJ/FFOg3exoOLIteU9C8CTxlJc1TZk8LVRhEi0PRRcRkeST1SyeeQ9eyjAxw9mdjGPB22K5aFFzB+x8l5Be2IpwnMQ6uTn3MZ+6w1VhdHzu8vg6cgcrwWCK1BHWSCLOgezT7YejT53Knt6dFICeD9I97x5ldr485Uo/7dIVDWqsffjMQhKXTJ4/2JbSGdGOEEkGGFTNQfZHH3GKB0y44ExGRykCMNk7F0xi3UDV27KkAIuTsa2/FmTBA2XruCp1HSGIu7I0gkKPUgrk3f8YhyGuL0mEY9rtVb0f86M9zLu9PXIZBYjK9PgY2fMkWaQlNzvRXZgokhjSImCXpyT8hza7GE2+BaXq3OqL7WpbV3N10d7VkGR4/efXBfqu+DFHolsG0k4453zQA4erGZF3p+d49qnaBXfJnyUyxpGdKQtJVpFkDyML6Ry5mHQJ3MAe02sNLkKbFP9lQrKfIYQKSbpA3fauE16j5e9rXiQoqzJrzcA00x8f30KOMBXONROnBSa0k6meKeRqeRXlnAPeE3hrx+78Mwn0sBYyJdRVVWMxMxeIzsxpC
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR0801MB2082.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39850400004)(8676002)(9686003)(33656002)(86362001)(6636002)(5660300002)(4326008)(921005)(53546011)(26005)(38100700001)(186003)(55016002)(2906002)(110136005)(64756008)(83380400001)(66476007)(71200400001)(76116006)(66946007)(54906003)(66446008)(66556008)(7416002)(478600001)(7696005)(316002)(8936002)(52536014)(966005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?tr+zD8zB33rkI95R7KEbvFBjXJe864DV/w8xPfd8Px7jeW1qPvXGa3LtgPZt?=
 =?us-ascii?Q?PAVzIkHLx3RMpccSHxUpAX8xXtzdRYT5+j+vA7MaX3yPmDK+X1vjRY65glpV?=
 =?us-ascii?Q?XEmROC1PJuaTVRfqRdJCt9zJG6xWaxphSMHXZyct4zCs0WCDlaYLP2rh2sHA?=
 =?us-ascii?Q?LqsiixOckDDxnHA7G3UjmOb00bEVTAYpcAW9PJi4wIMlTEpEElK2fsF+gj2f?=
 =?us-ascii?Q?Dele+hhuJCI0uTpyhnt9FasHuCSRvOUv0woJi2V5zmY0nV3Uj1u6OO+Mtf9e?=
 =?us-ascii?Q?EvKIrp4lpnBgrD7IESPjfVS3lzaAd05hS660c3y7xUa+VpVCucwP/C+HSoaE?=
 =?us-ascii?Q?e6pRdQ6UsPjB/tdzu9bM7JHvvapY/HVrt57SzgrvHum4rTVDZITJGJPfx9Ss?=
 =?us-ascii?Q?FBT5Nno8H24lQTxLFigeVHOA/TkCmcA/VXdXNTso0+hCvNraW1tDa/vzY/Om?=
 =?us-ascii?Q?mIaPd65K9DryEGjimNqUMNRcXK+/RUZZY7pV1mm+0fnFBtPB7rTvGDRrT0ht?=
 =?us-ascii?Q?2Te73xyu5dEbWpg2VwecpLybYHNUye9jI5ndhRPVbOzE0wZaaZO68AWjOUdM?=
 =?us-ascii?Q?fDzW2nYPo2NUQSVNX6H8RcepXwzmRqQYPGyanGqH+jWQewcfN25g7NTknG6x?=
 =?us-ascii?Q?caeHHOAbIf4rymSmqwDckZNqiPkM64mP4CaPlViYx3uTu6ijXEu4VO8NwA9i?=
 =?us-ascii?Q?NNol7zGkR0oM10Ox7uHFQXxr2AfSNn+SzI8LllS6vsSKMoHhq5zda9NWbFLy?=
 =?us-ascii?Q?UzleQ+I9AGcBGu8q082Yz0tCzmED3ENQShdwcV5ldjP/6H7O9vmkeDWGXhlT?=
 =?us-ascii?Q?5wocdjSThHMxAl7EH6MiHOVf28OhVcZ5JnPK1y+ciiz+nf9EPgd7KgoAMakC?=
 =?us-ascii?Q?vQ/Gs9q8u/V35Puqvn9Gt3ABKvHwg+ZTNH1PF7g0wtoICJDT1Ytlo8vA4tYH?=
 =?us-ascii?Q?AWyMC3+4MC8zQtkSJmW5kvF++S+cuBQtSlzvGm1K85k6n4C5lhx4j2UzqV+4?=
 =?us-ascii?Q?DytYvAU6BoXCTMneqbaqlOhqQDpk1eajkDO5tR0E/8McBPMK/3f7VMm5p0c4?=
 =?us-ascii?Q?7KxIFJLksDvYV5zI6RyZYDmn2KRuswiYLcZwuynkkVqVdDdTqonx2A0+movl?=
 =?us-ascii?Q?0IKESgkoB+QF27nIZp8pdBEgsd34ktiJyQmfz8Jed6uZGPzx5hUcq4icIUJg?=
 =?us-ascii?Q?Zp+TZ7Tm61togMTCM3vndyvFQUFLQ73aJZqY4DGmeFJxW3YTNNCjdf+MxK2g?=
 =?us-ascii?Q?u9JhZqVT+KsQPly60pkMgXxJWTTy47+Z/i1y7HRaMy3BhFUoLCshtLRgLgLC?=
 =?us-ascii?Q?moKYwxWmamTvNgIsUAyE75gg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1890
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 76842fdd-76eb-40ad-ee45-08d8f3635523
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i+2JKny83VbbbVBSWuEHP4jWYLj5acShyLG//AaHLSWs2q7sXhj6u+xnb0l1Bnm/s2iSShlzCul0IzdSuiFOMCQ+g2VWMaJVVMcOM+ifQbN2XzUbgqklHfw9fPO53hKYD0Ym5OD1VyTOVO+WZSdzmjzu3txU/rpHJiIFclW1Az2TItkflUqhqBKh8XTM6sY4Z4KW3NPNZThe/DFhj5uWeN6i/bzBHOc3Am7Zzsyd/RSw4qN5CTzRiGjZ76xny2qxyBkIOBc30h3r1lJ6aTnYrY7VK+aTG3dE/ImJsaBKHU3sdy72F3Z7NUX1zOkxCp/CLztz8PQFm7cCqTVqbAgXivtRLnep8P9adUgHH+cvoMoJr9zWGoKRpBbRTZKnOFc2lrRTg1DDoNvrCj7SC4pKhuFcNal3SqpwkNhqyJUA5Gnl02pk4Qd7yF1GX/Q25Hy2B05WCZ8SS1I6WYkREjkCpzn92ESbiXK94cla7IJ2949HA/32iKLzUuHLmfSOI9rU0+a0iY8FZV9M10xV10qi4u/X9eORaFapUOJNDDEQbpdp36GBlg3x6FbP17Rj1vKK5sY6oGw8uHWkhiEUGKCdz2EUehcFZVVMwGCDnuG3q2DYSvgw1Zhqjaw7z7LQNC5qVZuNc4LfEqmDVWoTIRkXQKJTwUpdLfL8FM873bMWVvMtlk3ryj3aUds6Nw5kOrUAPK6i16wtwPkrlQn/2bW/etk4acgOtQ5tHWJCZkANwNhccoynVvlRzLusedwV1Xtf
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39850400004)(376002)(346002)(396003)(136003)(46966006)(36840700001)(356005)(110136005)(82310400003)(81166007)(2906002)(6506007)(316002)(53546011)(70586007)(6636002)(33656002)(54906003)(186003)(9686003)(55016002)(83380400001)(4326008)(8676002)(5660300002)(7696005)(8936002)(47076005)(36860700001)(86362001)(921005)(52536014)(26005)(450100002)(82740400003)(966005)(478600001)(70206006)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 10:05:35.6293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3265e474-6c89-4fa0-c5bd-08d8f3635cd0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6491
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping ...

-----Original Message-----
From: Marc Zyngier <maz@kernel.org>=20
Sent: Monday, February 8, 2021 9:40 PM
To: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org; tglx=
@linutronix.de; pbonzini@redhat.com; seanjc@google.com; richardcochran@gmai=
l.com; Mark Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose=
 <Suzuki.Poulose@arm.com>; Andre Przywara <Andre.Przywara@arm.com>; Steven =
Price <Steven.Price@arm.com>; Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>=
; Sudeep Holla <Sudeep.Holla@arm.com>
Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; kvm=
arm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper <Steve.Capper@=
arm.com>; Justin He <Justin.He@arm.com>; Jianyong Wu <Jianyong.Wu@arm.com>;=
 kernel-team@android.com; Mark Rutland <Mark.Rutland@arm.com>
Subject: [PATCH v18 7/7] ptp: arm/arm64: Enable ptp_kvm for arm/arm64

From: Jianyong Wu <jianyong.wu@arm.com>

Currently, there is no mechanism to keep time sync between guest and host i=
n arm/arm64 virtualization environment. Time in guest will drift compared w=
ith host after boot up as they may both use third party time sources to cor=
rect their time respectively. The time deviation will be in order of millis=
econds. But in some scenarios,like in cloud environment, we ask for higher =
time precision.

kvm ptp clock, which chooses the host clock source as a reference clock to =
sync time between guest and host, has been adopted by x86 which takes the t=
ime sync order from milliseconds to nanoseconds.

This patch enables kvm ptp clock for arm/arm64 and improves clock sync prec=
ision significantly.

Test result comparisons between with kvm ptp clock and without it in arm/ar=
m64 are as follows. This test derived from the result of command 'chronyc s=
ources'. we should take more care of the last sample column which shows the=
 offset between the local clock and the source at the last measurement.

no kvm ptp in guest:
MS Name/IP address   Stratum Poll Reach LastRx Last sample
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   21ms
^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   21ms

in host:
MS Name/IP address   Stratum Poll Reach LastRx Last sample
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   18ms
^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   18ms
^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   18ms
^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   17ms
^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   17ms

The dns1.synet.edu.cn is the network reference clock for guest and
120.25.115.20 is the network reference clock for host. we can't get the clo=
ck error between guest and host directly, but a roughly estimated value wil=
l be in order of hundreds of us to ms.

with kvm ptp in guest:
chrony has been disabled in host to remove the disturb by network clock.

MS Name/IP address         Stratum Poll Reach LastRx Last sample
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
* PHC0                    0   3   377     8     -7ns[   +1ns] +/-    3ns
* PHC0                    0   3   377     8     +1ns[  +16ns] +/-    3ns
* PHC0                    0   3   377     6     -4ns[   -0ns] +/-    6ns
* PHC0                    0   3   377     6     -8ns[  -12ns] +/-    5ns
* PHC0                    0   3   377     5     +2ns[   +4ns] +/-    4ns
* PHC0                    0   3   377    13     +2ns[   +4ns] +/-    4ns
* PHC0                    0   3   377    12     -4ns[   -6ns] +/-    4ns
* PHC0                    0   3   377    11     -8ns[  -11ns] +/-    6ns
* PHC0                    0   3   377    10    -14ns[  -20ns] +/-    4ns
* PHC0                    0   3   377     8     +4ns[   +5ns] +/-    4ns

The PHC0 is the ptp clock which choose the host clock as its source clock. =
So we can see that the clock difference between host and guest is in order =
of ns.

Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201209060932.212364-8-jianyong.wu@arm.com
---
 drivers/clocksource/arm_arch_timer.c | 34 ++++++++++++++++++++++++++++
 drivers/ptp/Kconfig                  |  2 +-
 drivers/ptp/Makefile                 |  1 +
 drivers/ptp/ptp_kvm_arm.c            | 28 +++++++++++++++++++++++
 4 files changed, 64 insertions(+), 1 deletion(-)  create mode 100644 drive=
rs/ptp/ptp_kvm_arm.c

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm=
_arch_timer.c
index 8f12e223703f..e0f167e5e792 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -25,6 +25,8 @@
 #include <linux/sched/clock.h>
 #include <linux/sched_clock.h>
 #include <linux/acpi.h>
+#include <linux/arm-smccc.h>
+#include <linux/ptp_kvm.h>
=20
 #include <asm/arch_timer.h>
 #include <asm/virt.h>
@@ -1659,3 +1661,35 @@ static int __init arch_timer_acpi_init(struct acpi_t=
able_header *table)  }  TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_=
timer_acpi_init);  #endif
+
+int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
+				 struct clocksource **cs)
+{
+	struct arm_smccc_res hvc_res;
+	u32 ptp_counter;
+	ktime_t ktime;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARM_SMCCC_DISCOVERY))
+		return -EOPNOTSUPP;
+
+	if (arch_timer_uses_ppi =3D=3D ARCH_TIMER_VIRT_PPI)
+		ptp_counter =3D KVM_PTP_VIRT_COUNTER;
+	else
+		ptp_counter =3D KVM_PTP_PHYS_COUNTER;
+
+	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID,
+			     ptp_counter, &hvc_res);
+
+	if ((int)(hvc_res.a0) < 0)
+		return -EOPNOTSUPP;
+
+	ktime =3D (u64)hvc_res.a0 << 32 | hvc_res.a1;
+	*ts =3D ktime_to_timespec64(ktime);
+	if (cycle)
+		*cycle =3D (u64)hvc_res.a2 << 32 | hvc_res.a3;
+	if (cs)
+		*cs =3D &clocksource_counter;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index f2edef0df40f..=
8c20e524e9ad 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -108,7 +108,7 @@ config PTP_1588_CLOCK_PCH  config PTP_1588_CLOCK_KVM
 	tristate "KVM virtual PTP clock"
 	depends on PTP_1588_CLOCK
-	depends on KVM_GUEST && X86
+	depends on (KVM_GUEST && X86) || (HAVE_ARM_SMCCC_DISCOVERY &&=20
+ARM_ARCH_TIMER)
 	default y
 	help
 	  This driver adds support for using kvm infrastructure as a PTP diff --g=
it a/drivers/ptp/Makefile b/drivers/ptp/Makefile index d11eeb5811d1..8673d1=
743faa 100644
--- a/drivers/ptp/Makefile
+++ b/drivers/ptp/Makefile
@@ -5,6 +5,7 @@
=20
 ptp-y					:=3D ptp_clock.o ptp_chardev.o ptp_sysfs.o
 ptp_kvm-$(CONFIG_X86)			:=3D ptp_kvm_x86.o ptp_kvm_common.o
+ptp_kvm-$(CONFIG_HAVE_ARM_SMCCC)	:=3D ptp_kvm_arm.o ptp_kvm_common.o
 obj-$(CONFIG_PTP_1588_CLOCK)		+=3D ptp.o
 obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+=3D ptp_dte.o
 obj-$(CONFIG_PTP_1588_CLOCK_INES)	+=3D ptp_ines.o
diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c new file=
 mode 100644 index 000000000000..b7d28c8dfb84
--- /dev/null
+++ b/drivers/ptp/ptp_kvm_arm.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Virtual PTP 1588 clock for use with KVM guests
+ *  Copyright (C) 2019 ARM Ltd.
+ *  All Rights Reserved
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/ptp_kvm.h>
+
+#include <asm/arch_timer.h>
+#include <asm/hypervisor.h>
+
+int kvm_arch_ptp_init(void)
+{
+	int ret;
+
+	ret =3D kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_PTP);
+	if (ret <=3D 0)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+int kvm_arch_ptp_get_clock(struct timespec64 *ts) {
+	return kvm_arch_ptp_get_crosststamp(NULL, ts, NULL); }
--
2.29.2

