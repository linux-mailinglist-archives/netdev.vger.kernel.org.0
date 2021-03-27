Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9C34B56F
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 09:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhC0ITc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 04:19:32 -0400
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:65528
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230299AbhC0ITa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 04:19:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epMsIB3mhdYDVN0eyjo+Dol/kN2S+s7AaU3bANZlWs4=;
 b=nN0ZDOLqDQmCJ8/R3PO3qNtBFY1f+mbkfZKNaElgrEkP4/eaTp66gDTQ3eS8K89Z9p3F7GM3B4A4Kqi5bluFzWwT91UQp5zspJmVsA2XLCRpQdwBmwYDxo+1nCrt1DmqBXNBw9kmuX7BhZHByVI1ZhGtzR56LRrS37bsX1SenEc=
Received: from DU2PR04CA0245.eurprd04.prod.outlook.com (2603:10a6:10:28e::10)
 by DBBPR08MB4489.eurprd08.prod.outlook.com (2603:10a6:10:cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Sat, 27 Mar
 2021 08:19:25 +0000
Received: from DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:28e:cafe::4f) by DU2PR04CA0245.outlook.office365.com
 (2603:10a6:10:28e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend
 Transport; Sat, 27 Mar 2021 08:19:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT047.mail.protection.outlook.com (10.152.21.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.25 via Frontend Transport; Sat, 27 Mar 2021 08:19:25 +0000
Received: ("Tessian outbound 24fdfdedd45c:v89"); Sat, 27 Mar 2021 08:19:25 +0000
X-CR-MTA-TID: 64aa7808
Received: from 11ec88019eaa.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8320289B-422B-4F97-BF30-4FB53A6F3368.1;
        Sat, 27 Mar 2021 08:19:19 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 11ec88019eaa.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sat, 27 Mar 2021 08:19:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyQYb94CMA8Z/Q4TNiHOq5pl8wFxb+hm8sQGbIeI65OrMSosUxNvJYye5IXwUsJX0N9N0j+w7LEbDO1OyUx704so544WRnPmtIx5V3WzKjGu8jtWU70GL7nuTo5Pkwau5SEs6kMVXu9szy0uyzsg0C7DX37Vm6N1nbK4wQCjhUYR2BHdTBMC7xu8kT23qJWhuD9TR2xfHMSw/ZUDKUl5OhrHA0nixkBtLl0RMeKqi2t1XVfSPDsJOCBeztpuJl2GvxN7Hi93Yi0sKUFEQmPsjX1VHZ49bZnC9b4F97s3gELuO2zDZp4AOgRFqa8X7FU+1ZWxOZl6Hy9WR9s+NjnE9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epMsIB3mhdYDVN0eyjo+Dol/kN2S+s7AaU3bANZlWs4=;
 b=lciRsCRZU1xyjogjjnP+wwAftp0hAFBu9eq5wW6dnOUhlSR1QYxrMz4wQ+uFi+Yozhrx0YcKMK0GZ4Qhxw8UUVLl1vtL+roT4cfw8sMjt0MTu65i04iQLWln7WJvlrSNS4QI4q9cp6VlEsjzVAEH57SH/NOy1PSys1tNesDGbtqLCoFpUG8gkd+sIT0SdJ6DKBoR1uHy6GiwHA5QHTi9lLpSmnkqiQLY5bWg96x7FnMrTQX7fzbKKalkoa3j6uTUasaj7yltQ4ddtXMFcaOQyvkFHJAK0psa8kJJ7FEe3UT9XKcgn9vJm3Mp4UamEFEYgfKKJe9XMYSeI1LRLj5T3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epMsIB3mhdYDVN0eyjo+Dol/kN2S+s7AaU3bANZlWs4=;
 b=nN0ZDOLqDQmCJ8/R3PO3qNtBFY1f+mbkfZKNaElgrEkP4/eaTp66gDTQ3eS8K89Z9p3F7GM3B4A4Kqi5bluFzWwT91UQp5zspJmVsA2XLCRpQdwBmwYDxo+1nCrt1DmqBXNBw9kmuX7BhZHByVI1ZhGtzR56LRrS37bsX1SenEc=
Received: from AM6PR08MB3589.eurprd08.prod.outlook.com (2603:10a6:20b:46::17)
 by AM7PR08MB5366.eurprd08.prod.outlook.com (2603:10a6:20b:10b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Sat, 27 Mar
 2021 08:19:16 +0000
Received: from AM6PR08MB3589.eurprd08.prod.outlook.com
 ([fe80::fcfd:cd05:f39b:6da0]) by AM6PR08MB3589.eurprd08.prod.outlook.com
 ([fe80::fcfd:cd05:f39b:6da0%5]) with mapi id 15.20.3977.024; Sat, 27 Mar 2021
 08:19:15 +0000
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrey Ignatov <rdna@fb.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Kees Cook <keescook@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Mahesh Bandewar <maheshb@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "iecedge@gmail.com" <iecedge@gmail.com>, nd <nd@arm.com>
Subject: RE: [PATCH bpf-next] bpf: trace jit code when enable
 BPF_JIT_ALWAYS_ON
Thread-Topic: [PATCH bpf-next] bpf: trace jit code when enable
 BPF_JIT_ALWAYS_ON
Thread-Index: AQHXIj1H2RSTEzaIrEyYaRJ4yUwh0qqWUwCAgAEo1FA=
Importance: low
X-Priority: 5
Date:   Sat, 27 Mar 2021 08:19:14 +0000
Message-ID: <AM6PR08MB3589CCA99AEF14F9B610A70E98609@AM6PR08MB3589.eurprd08.prod.outlook.com>
References: <20210326124030.1138964-1-Jianlin.Lv@arm.com>
 <CAADnVQ+W79=L=jb0hcOa4E067_PnWbnWHdxqyw-9+Nz9wKkOCA@mail.gmail.com>
In-Reply-To: <CAADnVQ+W79=L=jb0hcOa4E067_PnWbnWHdxqyw-9+Nz9wKkOCA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 065974182F115349A858723E93DF00C7.0
x-checkrecipientchecked: true
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db7a30c2-7968-4d0d-ba63-08d8f0f908d2
x-ms-traffictypediagnostic: AM7PR08MB5366:|DBBPR08MB4489:
X-Microsoft-Antispam-PRVS: <DBBPR08MB448980CC38F7FFBBA31C6C1D98609@DBBPR08MB4489.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6790;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 9qLmeebD3mfEpftMCQHa5WTbfj8AWYiYoLyn8DP+YRLiykykQ97GP6f9Bz4XZ4yJJ/JluAxmsetbtYFXOJWZYo876VbuvgyeLuC/Pg+A2Ww7dbji3whJkSPftOjR36/iwhhCI4Jg4YAuuNKLn1Yf2LC+8mtgSRWX3/J2dfAvI2QpAKT+8k4bMfeUUzQyXJWueisBU7S1C7SUqqOulmsptXTn7Avwo5TVh2TdDzZkQZEbVpC5JxGpgOiHeOU5WQM0hJ1Gd5EysRr8V+VCAd02AS8twY8mwZOg7FQwrx4U/t3JtOIFF8qv2n42D2dbA3PO2Lz4hQ7zLocqvTj9ZMWkC/9Cdm2yKHGmP9yO7dP78S4zixPOSHp8Go2EEZi+gFmwvTYcaoNiyfRsgfWgb0WZrYncg4IMIhJX9wzkXgSvsOp2hJRnzCO2gjj7TLNbqQQTJPNLWHeNphEIdX/Od9+eGaH66SdI5e1LpuGCYD9ZjbU+Zvy3wUm//han3ACmaxwwdEJ3Nh++KU5pw2YY0pzk/0sriSrM9z/foPTMeg8ioVZS5sLAnxnU2Z7Wb9sMZtRbf4sK+FML92FTxNB3ida2numI1elWKkpM5/u44cgGOxCPqZMbm9Vz+M0fHTOyGIUCJupn+Hg++SnKQbYM+Kohf9qCPazOaP+F5MsB2xZWo+Q=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3589.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(6916009)(66946007)(6506007)(7416002)(66556008)(66476007)(52536014)(66446008)(55016002)(2906002)(64756008)(8936002)(9686003)(53546011)(76116006)(186003)(8676002)(478600001)(38100700001)(33656002)(4326008)(5660300002)(7696005)(71200400001)(54906003)(83380400001)(86362001)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cnQ0RTlnU1gwNU9DbmxrRjJ3OXRXdkNWU2JDbjJWR09ZSmp5KzV3YTUxUHpt?=
 =?utf-8?B?SkhSVXRpdS92VEtDaEhrbmI0dGJuY3U0dVhRTWViNHpkQTlTWFZteEVad0dN?=
 =?utf-8?B?cnd0bVBmeGFHQkY2TExPcHlUQ0Z6SkJjT0hKYjhLOWhtejNlMDRON1RNT1kz?=
 =?utf-8?B?eUJUak1ZQVg0bHpvRkJNMlBIVUwwR0VjMVNCOGpJMTdXcGpOUVRmQURiOE0v?=
 =?utf-8?B?SzcrdkpxTHBKc0xqbUtIa3NxMGdYNHR6M2d4ekNSWlJRekxCZEZqd25abm5G?=
 =?utf-8?B?aXR6VyttMUVrVURtOFZReUFGUzNjSVMybnJ4YlovQVBTcnpyakVJb2lYZ0pZ?=
 =?utf-8?B?bFJnbXdGWG44aWdxNUhGb1l5STVqL2FoakFEV3lDSTVUU2ExVTM1a0JwZFpX?=
 =?utf-8?B?OWl5ZDRzTUFDak1iNEROSjk3WE9YSm5nTmxHMEdtQlg1emJtVTd1S3lkek9F?=
 =?utf-8?B?eXhDZzd0Und4YWdmZVlha1Q5MjVYcE9obENoUzNjcXl0S3ZkTThwTHg4MkJI?=
 =?utf-8?B?UEl5eTFoNkxrR0FYMU1idWxtRU5UOVhZb3lvaGlyWVRxNTFwY1NIQmhMdEdl?=
 =?utf-8?B?UFpORFFaUVlieU5lb0ZxamRIMnRkeVpRR1VzQXRPM1dHOFJzdHZkZ0lTUytE?=
 =?utf-8?B?M0YyMkZJdHcvMkRvMjRvR05jb1VRR0dHLytYYVRHMEVvSnRMY3kxTWVVMEg4?=
 =?utf-8?B?bmVnejRhZGw4cnMvUmlUMFRHTTNhMVV2KzVmSlRXR2JrVkloVHMyTFRBa2FX?=
 =?utf-8?B?UVYxZlFhWUpCR0ljMUxYYUxNTUpWOHFkZmQ5THgxbW1UMmkvMlBqU1VjSDVR?=
 =?utf-8?B?ejVBSXYvVkprVVZ5V0R1MDNicDUreEVydDJnYnVjaTEzTGtvR1pBMHJoVEo2?=
 =?utf-8?B?MHBOTVdDM09PNmVDVEZjMGNtRnpJVW1IUTdoT01XaFpwbGdmdGErZHdjS3Br?=
 =?utf-8?B?dW5LcVhCVC9QZDlDRUZvdEh1NzVzQ1BsSm53UDhEbm5iWmg2d0ZUbE4rdEJm?=
 =?utf-8?B?V2RZYk0vSzgzK2FPYVVKbmxtRnVvbFVtaXdHYmd0YXhTU2ROVUVibytoZ1F2?=
 =?utf-8?B?dW1NeERLbHFHRzNON1pZaVRZaHIvT2ZoQjZ3bDVkQjVNV3gzMzdZU2tXUjVv?=
 =?utf-8?B?ejhDOFlQR0VUZjEwWUpPS1JrZWJvT1drWDB3L3FLOG5kZFdwbzdrNzltcndJ?=
 =?utf-8?B?MkFyVE9GL1NSendHSzJFcFJNM1V4Y3h6ZXdoMEh5UmFaRFBYMzlWYll0Ylg5?=
 =?utf-8?B?Nk83WWl6QkovaGwyYVlLMmpvbDhDUFZYMkgzZFQwRTh0L01ZYlB4Zkk1YW9p?=
 =?utf-8?B?UVgrZ3htQW15R3ROUXhGUENabUFsVG1JMHhXRnFRa1VWQWk2THppaG9Eaktp?=
 =?utf-8?B?S1Q2bmtLbU9iOE12cllmTjNXOXVCekZzb2F2Z2h6ei9xbXFQSmhFOThkdG94?=
 =?utf-8?B?bDJkUXBxaHErWVdBU1YvN1lUV3dJVzArRzgvNWdaL3Myc3JmbzlMb0ZHak1s?=
 =?utf-8?B?MkkwOS9RaVhlbU1PWTdIWFY0SFp5TEVVL2U3UWQ4Z21qU3U1eHBtVk1yUHZI?=
 =?utf-8?B?eDhMa29iaG1XRkkzcHJMdUxIL3YvMnlydHkxK2RrREpHM3ZVbmJEejZGc0Nv?=
 =?utf-8?B?a0ExaTVFMEl3Y1oxV3EvdFViZzh1c3dpc3FZU2RqU0ZzWC80bHQ4a21oZ016?=
 =?utf-8?B?UzJNeUNMSDFqa293b2wxNngrbE9aZ3IrV1A1QjBsUmpGVWZud21pam5EOWda?=
 =?utf-8?Q?JV6kJTKudRoI1LJpoFXx2lPiJsvBGZlU6mNRyV8?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5366
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: cf21e022-7431-42cf-b44c-08d8f0f902ad
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q/ro0IkGHSvtjn9wdWGSqH+m7CGOoXkMvaMe639pLbQgs6CkSa9j9Tnxib/MyfzQygFwhhJBFhlU/z0GAaSUtKoa06SnAtS2zydG9QJB6cDPiXFbWmKuytCt65F3giDwPwv/akKHmz2InNWK6GxPn4GembHX60qaqccA7hA+IBi2DziknzfzvOGODm5DzMN464lxA8cUgBozPqbC/WWXs0G0XH61Yjnpe/oCezp9LaeS8TEFcQu1prhxnJrYuvNx1GhXE9QWZTEbVn41FSltjEfTKsi+0Jx/sFC/1Nli0jKd8ZhQtmtX+Ue6Rm9/1I/ZxBSJBDFvzjdWeuyu5sn5OTH732yr9NvBgNB1qF5Nk4Lo3JAFc3oXIRJi/v9N5BgLwpkXPVXXGImA2XUJQcIWgWqrAtveQokVaNj1xcKg+J9QWi+DZ4x0Uunpnf9JWiaGgNCoNwaJyvoi4oGN2T8aqp/ZDhE4ByKQO/Q1Ksdk4ysq5GeeBLx8AMcAkvL0IoQmBOsecCMsitw2VoYE/645ONhyA/Q8yRz8y/8oNc+bBtqt9tFkfAbxo+4hs0cQ3HXLV/wGsk/sgrQ1gGgQ6T/QWQTu9d6x0qkTdsL+CAdL/PmRtUH3RzU+smw5LRVx/yg7h4MXg4KwegfngIUXbCSW7pvn+dOaKi5wswv4Ov37tt0=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(36840700001)(46966006)(2906002)(86362001)(316002)(53546011)(6506007)(81166007)(70206006)(82740400003)(7696005)(82310400003)(54906003)(356005)(478600001)(26005)(70586007)(47076005)(33656002)(8936002)(36860700001)(55016002)(52536014)(186003)(6862004)(9686003)(83380400001)(450100002)(4326008)(5660300002)(336012)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2021 08:19:25.8356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db7a30c2-7968-4d0d-ba63-08d8f0f908d2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4489
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGVpIFN0YXJvdm9p
dG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPg0KPiBTZW50OiBGcmlkYXksIE1hcmNo
IDI2LCAyMDIxIDEwOjI1IFBNDQo+IFRvOiBKaWFubGluIEx2IDxKaWFubGluLkx2QGFybS5jb20+
DQo+IENjOiBicGYgPGJwZkB2Z2VyLmtlcm5lbC5vcmc+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgQWxl
eGVpIFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz47DQo+IERhbmllbCBCb3JrbWFubiA8ZGFu
aWVsQGlvZ2VhcmJveC5uZXQ+OyBBbmRyaWkgTmFrcnlpa28NCj4gPGFuZHJpaUBrZXJuZWwub3Jn
PjsgTWFydGluIEthRmFpIExhdSA8a2FmYWlAZmIuY29tPjsgU29uZyBMaXUNCj4gPHNvbmdsaXVi
cmF2aW5nQGZiLmNvbT47IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+OyBKb2huIEZhc3RhYmVu
ZA0KPiA8am9obi5mYXN0YWJlbmRAZ21haWwuY29tPjsgS1AgU2luZ2ggPGtwc2luZ2hAa2VybmVs
Lm9yZz47IEFsZXhhbmRlcg0KPiBWaXJvIDx2aXJvQHplbml2LmxpbnV4Lm9yZy51az47IEFuZHJl
eSBJZ25hdG92IDxyZG5hQGZiLmNvbT47IERtaXRyeQ0KPiBWeXVrb3YgPGR2eXVrb3ZAZ29vZ2xl
LmNvbT47IE5pY29sYXMgRGljaHRlbA0KPiA8bmljb2xhcy5kaWNodGVsQDZ3aW5kLmNvbT47IEtl
ZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPjsNCj4gTWFzYWhpcm8gWWFtYWRhIDxtYXNh
aGlyb3lAa2VybmVsLm9yZz47IE1haGVzaCBCYW5kZXdhcg0KPiA8bWFoZXNoYkBnb29nbGUuY29t
PjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IE5ldHdvcmsNCj4gRGV2ZWxv
cG1lbnQgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBpZWNlZGdlQGdtYWlsLmNvbTsgbmQNCj4g
PG5kQGFybS5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggYnBmLW5leHRdIGJwZjogdHJhY2Ug
aml0IGNvZGUgd2hlbiBlbmFibGUNCj4gQlBGX0pJVF9BTFdBWVNfT04NCj4NCj4gT24gRnJpLCBN
YXIgMjYsIDIwMjEgYXQgNTo0MCBBTSBKaWFubGluIEx2IDxKaWFubGluLkx2QGFybS5jb20+IHdy
b3RlOg0KPiA+DQo+ID4gV2hlbiBDT05GSUdfQlBGX0pJVF9BTFdBWVNfT04gaXMgZW5hYmxlZCwg
dGhlIHZhbHVlIG9mDQo+IGJwZl9qaXRfZW5hYmxlDQo+ID4gaW4gL3Byb2Mvc3lzIGlzIGxpbWl0
ZWQgdG8gU1lTQ1RMX09ORS4gVGhpcyBpcyBub3QgY29udmVuaWVudCBmb3IgZGVidWdnaW5nLg0K
PiA+IFRoaXMgcGF0Y2ggbW9kaWZpZXMgdGhlIHZhbHVlIG9mIGV4dHJhMiAobWF4KSB0byAyIHRo
YXQgc3VwcG9ydA0KPiA+IGRldmVsb3BlcnMgdG8gZW1pdCB0cmFjZXMgb24ga2VybmVsIGxvZy4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEppYW5saW4gTHYgPEppYW5saW4uTHZAYXJtLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgbmV0L2NvcmUvc3lzY3RsX25ldF9jb3JlLmMgfCAyICstDQo+ID4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlm
ZiAtLWdpdCBhL25ldC9jb3JlL3N5c2N0bF9uZXRfY29yZS5jIGIvbmV0L2NvcmUvc3lzY3RsX25l
dF9jb3JlLmMNCj4gPiBpbmRleCBkODRjOGExYjI4MGUuLmFhMTY4ODNhYzQ0NSAxMDA2NDQNCj4g
PiAtLS0gYS9uZXQvY29yZS9zeXNjdGxfbmV0X2NvcmUuYw0KPiA+ICsrKyBiL25ldC9jb3JlL3N5
c2N0bF9uZXRfY29yZS5jDQo+ID4gQEAgLTM4Niw3ICszODYsNyBAQCBzdGF0aWMgc3RydWN0IGN0
bF90YWJsZSBuZXRfY29yZV90YWJsZVtdID0gew0KPiA+ICAgICAgICAgICAgICAgICAucHJvY19o
YW5kbGVyICAgPSBwcm9jX2RvaW50dmVjX21pbm1heF9icGZfZW5hYmxlLA0KPiA+ICAjIGlmZGVm
IENPTkZJR19CUEZfSklUX0FMV0FZU19PTg0KPiA+ICAgICAgICAgICAgICAgICAuZXh0cmExICAg
ICAgICAgPSBTWVNDVExfT05FLA0KPiA+IC0gICAgICAgICAgICAgICAuZXh0cmEyICAgICAgICAg
PSBTWVNDVExfT05FLA0KPiA+ICsgICAgICAgICAgICAgICAuZXh0cmEyICAgICAgICAgPSAmdHdv
LA0KPg0KPiAiYnBmdG9vbCBwcm9nIGR1bXAgaml0ZWQiIGlzIG11Y2ggYmV0dGVyIHdheSB0byBl
eGFtaW5lIEpJVGVkIGR1bXBzLg0KPiBJJ2QgcmF0aGVyIHJlbW92ZSBicGZfaml0X2VuYWJsZT0y
IGFsdG9nZXRoZXIuDQoNCkluIG15IGNhc2UsIEkgaW50cm9kdWNlZCBhIGJ1ZyB3aGVuIEkgbWFk
ZSBzb21lIGFkanVzdG1lbnRzIHRvIHRoZSBhcm02NA0Kaml0IG1hY3JvIEE2NF9NT1YoKSwgd2hp
Y2ggY2F1c2VkIHRoZSBTUCByZWdpc3RlciB0byBiZSByZXBsYWNlZCBieSB0aGUNClhaUiByZWdp
c3RlciB3aGVuIGJ1aWxkaW5nIHByb2xvZ3VlLCBhbmQgdGhlIHdyb25nIHZhbHVlIHdhcyBzdG9y
ZWQgaW4gZnAsDQp3aGljaCB0cmlnZ2VyZWQgYSBjcmFzaC4NCg0KVGVzdCBjYXNlOg0KbW9kcHJv
YmUgdGVzdF9icGYgdGVzdF9uYW1lPSJTUElMTF9GSUxMIg0KDQpqaXRlZCBjb2RlOg0KICAgMDog
ICBzdHAgICAgIHgyOSwgeDMwLCBbc3AsICMtMTZdIQ0KICAgICAgICBmZCA3YiBiZiBhOQ0KICAg
NDogICBtb3YgICAgIHgyOSwgeHpyLy9FcnIsIHNob3VsZCBiZSAnbW92ICB4MjksIHNwJw0KICAg
ICAgICBmZCAwMyAxZiBhYQ0KICAgODogICBzdHAgICAgIHgxOSwgeDIwLCBbc3AsICMtMTZdIQ0K
ICAgICAgICBmMyA1MyBiZiBhOQ0KICAgYzogICBzdHAgICAgIHgyMSwgeDIyLCBbc3AsICMtMTZd
IQ0KICAgICAgICBmNSA1YiBiZiBhOQ0KICAxMDogICBzdHAgICAgIHgyNSwgeDI2LCBbc3AsICMt
MTZdIQ0KICAgICAgICBmOSA2YiBiZiBhOQ0KICAxNDogICBtb3YgICAgIHgyNSwgeHpyLy9FcnIs
ICBzaG91bGQgYmUgJ21vdiB4MjUsIHNwJw0KICAgICAgICBmOSAwMyAxZiBhYQ0KLi4uDQogIDNj
OiAgIG1vdiAgICAgeDEwLCAjMHhmZmZmZmZmZmZmZmZmZmY4ICAgICAgICAvLyAjLTgNCiAgICAg
ICAgZWEgMDAgODAgOTINCiAgNDA6ICAgc3RyICAgICB3NywgW3gyNSwgeDEwXS8vIENyYXNoDQog
ICAgICAgIDI3IDZiIDJhIGI4DQoNClRoaXMgYnVnIGlzIGxpa2VseSB0byBjYXVzZSB0aGUgaW5z
dHJ1Y3Rpb24gdG8gYWNjZXNzIHRoZSBCUEYgc3RhY2sgaW4NCmppdGVkIHByb2cgdG8gdHJpZ2dl
ciBhIGNyYXNoLg0KSSB0cmllZCB0byB1c2UgYnBmdG9vbCB0byBkZWJ1ZywgYnV0IGJwZnRvb2wg
Y3Jhc2hlZCB3aGVuIEkgZXhlY3V0ZWQgdGhlDQoiYnBmdG9vbCBwcm9nIHNob3ciIGNvbW1hbmQu
DQpUaGUgc3lzbG9nIHNob3duIHRoYXQgYnBmdG9vbCBpcyBsb2FkaW5nIGFuZCBydW5uaW5nIHNv
bWUgYnBmIHByb2cuDQpiZWNhdXNlIG9mIHRoZSBidWcgaW4gdGhlIEpJVCBjb21waWxlciwgdGhl
IGJwZnRvb2wgZXhlY3V0aW9uIGZhaWxlZC4NCg0KYnBmX2ppdF9kaXNhc20gc2F2ZWQgbWUsIGl0
IGhlbHBlZCBtZSBkdW1wIHRoZSBqaXRlZCBpbWFnZToNCg0KZWNobyAyPiAvcHJvYy9zeXMvbmV0
L2NvcmUvYnBmX2ppdF9lbmFibGUNCm1vZHByb2JlIHRlc3RfYnBmIHRlc3RfbmFtZT0iU1BJTExf
RklMTCINCi4vYnBmX2ppdF9kaXNhc20gLW8NCg0KU28ga2VlcGluZyBicGZfaml0X2VuYWJsZT0y
IGlzIHN0aWxsIHZlcnkgbWVhbmluZ2Z1bCBmb3IgZGV2ZWxvcGVycyB3aG8NCnRyeSB0byBtb2Rp
ZnkgdGhlIEpJVCBjb21waWxlci4NCg0KSmlhbmxpbg0KDQoNCg0KSU1QT1JUQU5UIE5PVElDRTog
VGhlIGNvbnRlbnRzIG9mIHRoaXMgZW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBhcmUgY29uZmlk
ZW50aWFsIGFuZCBtYXkgYWxzbyBiZSBwcml2aWxlZ2VkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50
ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgaW1tZWRpYXRlbHkgYW5k
IGRvIG5vdCBkaXNjbG9zZSB0aGUgY29udGVudHMgdG8gYW55IG90aGVyIHBlcnNvbiwgdXNlIGl0
IGZvciBhbnkgcHVycG9zZSwgb3Igc3RvcmUgb3IgY29weSB0aGUgaW5mb3JtYXRpb24gaW4gYW55
IG1lZGl1bS4gVGhhbmsgeW91Lg0K
