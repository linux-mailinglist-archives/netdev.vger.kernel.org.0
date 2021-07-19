Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30E3CD59F
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbhGSMgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 08:36:24 -0400
Received: from mail-eopbgr150055.outbound.protection.outlook.com ([40.107.15.55]:60252
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236936AbhGSMgX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 08:36:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSq5FtG1yPT9jAYtie+UETtfK+rikiHYHwRnj+fs6gU=;
 b=yUK+I85ISmRvhP7e/HrFutIjX17yZcuxN/E5wo3iANBbxS2KMQdkWqSINi6/QYl9RUHdVPiWlll/2vDbGpOQPb2LlZQif/jhj8Z+nXjwk/6Y4mBR+rvnO3lhkkiode2cs425LfeNFBVogMFmrp2U2pRwFVg7NGsq9LzMty1pu5A=
Received: from AM7PR02CA0019.eurprd02.prod.outlook.com (2603:10a6:20b:100::29)
 by AM6PR08MB2999.eurprd08.prod.outlook.com (2603:10a6:209:44::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Mon, 19 Jul
 2021 13:17:00 +0000
Received: from AM5EUR03FT055.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:100:cafe::cb) by AM7PR02CA0019.outlook.office365.com
 (2603:10a6:20b:100::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Mon, 19 Jul 2021 13:17:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT055.mail.protection.outlook.com (10.152.17.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 13:17:00 +0000
Received: ("Tessian outbound b81a99a0393d:v99"); Mon, 19 Jul 2021 13:17:00 +0000
X-CR-MTA-TID: 64aa7808
Received: from 2094e3658183.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id F02734F1-0146-4332-84EA-DBAAC277DF2E.1;
        Mon, 19 Jul 2021 13:16:54 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2094e3658183.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 19 Jul 2021 13:16:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCeY9Z2TWZJmmF6HdeHF/eamfhJzTeCucm+B5TZOlX9eWZiAsfkbX+D25rbBjzze6SBriRSrIMm7ktHPCp4Yg5KXS2SDkMZ37whpXXzjdFK+cVhhVaCaRBMF8GsDS6qdYIbuo+32efAvv4VYRKfFMkEY6xOTuyIgCBWWErr5FDxRLM85pS2SmRNPAZg70dpvgBPU7H7rQ6NCCP2QQd5LfxUUyXEJwbJHv70ms41eeptTXQwvjIeyYI+FkUyvLE8ce+gE6PXj91x6d8WmrpG6Qyzpna+zx0Eyvm9bHBYjK8/NHzAszSRiPE7Ewc1SPewUpwKFT94Fkt6tfVDc/Nytjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSq5FtG1yPT9jAYtie+UETtfK+rikiHYHwRnj+fs6gU=;
 b=Tak45nPd5pvLkuum1m841sTGyH6H2GkgoPqbtfEKG97QJOkQ/YZR+J7glAng+T94mgTXnboCzycrwlGuyoqQ1s/i3oHaiXk+on4oqJwaYwp5RZR90AO61b/3RALmiWL8TA2GZct2kxkQ0Lewv9qyabhwRQ7ZJbeUy/IDtm9snC7K4VpiTV8lKZ48ynzY6SFy+qrkZ7Rhe2DDKX3GPL1Kat8GpVBvx7JDnTvjp40beZ9ge3OGJAKzSQCyyclokboIRfHuwhZyn1MlWL575X6MuImd5n/WzzYkgdzvyDjkqcZURGNqfWEYc3KVdDdTA28r87ptFOtFBvqqY7E3KgNWIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LSq5FtG1yPT9jAYtie+UETtfK+rikiHYHwRnj+fs6gU=;
 b=yUK+I85ISmRvhP7e/HrFutIjX17yZcuxN/E5wo3iANBbxS2KMQdkWqSINi6/QYl9RUHdVPiWlll/2vDbGpOQPb2LlZQif/jhj8Z+nXjwk/6Y4mBR+rvnO3lhkkiode2cs425LfeNFBVogMFmrp2U2pRwFVg7NGsq9LzMty1pu5A=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB3415.eurprd08.prod.outlook.com (2603:10a6:20b:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.25; Mon, 19 Jul
 2021 13:16:53 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1%5]) with mapi id 15.20.4331.031; Mon, 19 Jul 2021
 13:16:53 +0000
From:   Justin He <Justin.He@arm.com>
To:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
CC:     Ariel Elior <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>, Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: RE: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Topic: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Index: AQHXeVClyEXp90xYxUyzsooHikRZAqtKIQeAgAApWfA=
Date:   Mon, 19 Jul 2021 13:16:53 +0000
Message-ID: <AM6PR08MB4376894A46B47B024F50FBB3F7E19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210715080822.14575-1-justin.he@arm.com>
 <CAJ2QiJLWgxw0X8rkMhKgAGgiFS5xhrhMF5Dct_J791Kt-ys7QQ@mail.gmail.com>
In-Reply-To: <CAJ2QiJLWgxw0X8rkMhKgAGgiFS5xhrhMF5Dct_J791Kt-ys7QQ@mail.gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 46A74FB07130384391D03849DEB6FE15.0
x-checkrecipientchecked: true
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 440f7464-d4bb-435d-9f1b-08d94ab77e61
x-ms-traffictypediagnostic: AM6PR08MB3415:|AM6PR08MB2999:
X-Microsoft-Antispam-PRVS: <AM6PR08MB29996BE3AB70B4B06DA7F8E0F7E19@AM6PR08MB2999.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: XsIzcTkogZIDgjQB+WoOziFlJpO7wD9DLfqJck7NorEHhAQESIIVH/8mPmSo0VNgajSYHrk4nmvcw9RTpcFoLuW0PrhiBdSu+ILPjEC3KAY5tyhhxmkLbk4Kr7TNdnkQUftXvQzJLVS0dAcRNasIzK6Hht8LL5oYKIbhJUcJ42FmZx6wzpzkk+su8Yq9spAezUGn0FXdGvhuFKBqFQFhXttGkNZDzng00r1afhqQ23t+KHhLk867pG8rDbVwo+ykTT9JN3Qv4Zpix7LkkfdOQlbiDVbj4mECyKn7H7V8uHH5zT5CoP9cAq50zcvFADIocaiB1O25yh3V/Qq2Dro1SAd+7/1UWC15pAYiyv9LDusrTFdGd30Rt3aA4+7cFio7epB/XJwB9DJYgD5CQNdn2IHY/8wfhl40wj6Rc0IDqDU3FOLTkCqLjC/SPxB2QNyZiL0QbZruTgxpTDFI9f0zu78IlOq2IIrqwNqPaWEJI+1567t6r1VLvHen4gYlkG2jVUYSDbtJnMPQbrxEQfcRQPLGqxW85s2aLjKMSV0FksIPI49PZtGqB4aOblDq991UY/ZqtwuYbxyLrY+TYVqiIaJRYAUW2W10ylMhIuPnZXvfzoEYDaTVb1Do+QcZCO3P2zQEF51zwnJZhjUm9YK0qga491V5Sb4Hn88ad3WaTNbm3DF/gLyV3WdMoX3UFzCp3Bt/1TDgSARYLx4uoV12/A==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(8936002)(8676002)(5660300002)(6916009)(55016002)(33656002)(52536014)(83380400001)(38100700002)(9686003)(2906002)(122000001)(26005)(54906003)(86362001)(186003)(53546011)(66446008)(64756008)(66556008)(66476007)(4326008)(316002)(71200400001)(66946007)(478600001)(76116006)(7696005)(6506007)(7416002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUhoekNpRVVVSmFNUlhPclYwNWIyS2VsVzBJOEVQZUE4c0o4SXZKYXMyUTB1?=
 =?utf-8?B?b01mR0ZGUXlHZjhGeGZYSCtUNEk5MGIxNkNhbUtacFZwVkNNMGp5cDdIUko1?=
 =?utf-8?B?VDllMWJHeEhHQnBabElEbTJZY3MyODJFeExrQW9reG5EYkNEQmNpNzd5Skdu?=
 =?utf-8?B?dUpQY1ZMVmYyMEtyWjdZUWdnUEhIREpWcFVIV041R2VWR0tQUEpNMThwbFRo?=
 =?utf-8?B?YUF3TC9Xdm40V2s0cTY0aTh1Q01lbFVrMGxLVjJ2QnJGZGVRRHJSQjF3dGpu?=
 =?utf-8?B?Q3ZvdlN4U1BwM3ozRDNac2lXdHN6NUlPOUNuTHRESTZDSitUY0oyUjQ3eGtB?=
 =?utf-8?B?Z0lMaExhMjhtbGpBbi8xK2J6Y05vRXd0MDlRN0dwKzRjUDRPZXdsV21sUkow?=
 =?utf-8?B?bmwvaXJBUFpGZHFQd3VrbFMrU1RhbXpzTUZmMHcxWExTRWZQejRPOFhJendw?=
 =?utf-8?B?ejlRVm5mWStrdXMyMFdVRVF1TndrV3VVUGwrRDhRT0dib3dIV044d0xVd1M2?=
 =?utf-8?B?Sy9GM3FZVXhKTjIrRnR1Vms0Z3EvR2R3NExwd2F4NFFGVnZPK3pETUx3WDNi?=
 =?utf-8?B?MTJid1ZCRzdoOWFZOUd3MDhFRFhoT3lRVDVBU256enVreURYcTRNc2l3UHd5?=
 =?utf-8?B?VWNVZ2FMUmUwTE1vM3ZwZnF3b3I1azR5SnI1V1lVWVBCajMxSmtvQ21pdXo3?=
 =?utf-8?B?S21wN3BHRHhzZ2xQdWU5NXBidlZIRmVYc2pvZVFOYUNRMEZnTlE4Z2RGZ0d2?=
 =?utf-8?B?SmhRb0NDandaSVQ2bkdWdGxqTnlYSkQ1akE4bmdESUxHMi9LNjNXVUJOc254?=
 =?utf-8?B?R3prRlVqcFRDVjZKVXh1MGcvdzNkR2V5QURNUndIQzVMNVYrbzRzUU42Nmtr?=
 =?utf-8?B?VWJ0UFVMaHNUUWJTakVqSXZZR05Fb21WM2dYTGl2RndQQTNEZ3AwTUN1QzFz?=
 =?utf-8?B?WmE3OE9JMGxVOTFUM0x1NXUwVGpIWk5UVGF3VmR5UEx4dFpsQVVrUzI4b2VJ?=
 =?utf-8?B?WTEvQ2hJNzZVQmhpblRLOVBVWU5rYXhHQ25UZXZKamJyRFR2aWZZM1NLYlRD?=
 =?utf-8?B?WTRaTEtQUDV2am5xUWNpWUcwREZpbGlRazg5N2VBeElYZXZaNTg4MGFFaUJH?=
 =?utf-8?B?SXk2UWRQK3Q3czFlWk5XaUQ3WDd3b3lSQm95WXR5Yml1RjZUKzFOYkN6QzVw?=
 =?utf-8?B?V1NQUzNNK2pHenp2KzBIN3dNdGNNUWQ1RGRqdFVoalpMT0VCZUxOcFEyV21w?=
 =?utf-8?B?N0V2ems2bUJKQzk4QVI0NVVFMEJqN0psTDV4VUtYUTBoL05GWnY5VmtxVkNs?=
 =?utf-8?B?Qm1jOU9neHo5VzJsVmVDbzRNOWxBcUgrMm9ZRFExOHZTNjNuYmwrVjMvNSsy?=
 =?utf-8?B?WnBhVlhnUFNJUDUrOFFveGJleUVWWi8zRU1IUmNaMFRBbDZZSkQwNWxEUlhE?=
 =?utf-8?B?YkRvWkNoMG5aMmJWVlRKa2w3dVN6SVNBWERKSFltaEZoeHhRR1FyQ3NBS3kr?=
 =?utf-8?B?RnkwaE5MczBOaEJkZGlSUXZQdVlUcWRTL0NFL1ZNc2txNGxlb2kxbVZWNnIw?=
 =?utf-8?B?bEN4L1ZacHdTWTFaUDJZdWZPYjNzbWFlQTIvUW9lTCt2OVoxaS9yZHUzM1dj?=
 =?utf-8?B?M1JnVEY3Nm1PYmRxWWxienlnYUtTZWdDaWpCNDhjZHVjdmZ4ZWhyMnZVU3Az?=
 =?utf-8?B?SzVGcjd4eDBQd3VFVTZmbkRhY0tpcVNBL1JjR3I5STRtakZzQ0RtM2NNTDNy?=
 =?utf-8?Q?9Rc3voBzSRcwiXtq7WqaQluUTq0E514rHXiGGt0?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3415
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT055.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 6ca3e7cc-a220-4718-c483-08d94ab779e1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QusbM/uvRae7kcrlzTXlquHs/2AQRyFoZOfoeC5F3STciwA/inpxiAN7i+GTvBG6pE+LiwcDBdkg+KhQnW6TKu3vgg6qR0tKgFcAgXcnpOkbfUu4cU3AkylSi/9C8dxNioepTcOHRDpnMLw0Ebq7LTwyEl4huZ8OyQz9cmPsWfHkXierhJmGr4VDZGzz1jO7ThwCavX2FYypW8h+rCK3SxHhZWbWmuNDHFQTvg4sPBMYPcgg4n6drRPjqOJ4JNEt+aiCY7RER6zcXGgym70UKqxRltjk6HIv2t425Uq1ar57BovBaq3rChMrIkYwTB0hdhXsuJ1EcrD+lOGmEmYC2XRklFmeLkmUX+6jLKChzkJhgxDqiEtmzZFKwLEweezVYyb+yqZYBvlEOYyNEYe0ZN8GyW78I3c2gzDaplSwFT7Uq96OASnVCd6HLfrsVXQl4nGhntFvPz0y6QNx5sazv22gyXQKpBQCChTnJPSW3MlTdji0JdwHpAgle7yBjAEGQ48IADL1SDmUSVwZER8zYUCfnpQU2Ga4JOQFCA9jOvCNfmzMnW5jc3g/E9cfXIQTou39/UnFt31793dAeFWNt3IG00BkhSmuco9W6CkemR7+erE6fFtAgDPoZjrtHsSEmPaeXnWRkRCpbsziigcgJ+/LE7A+upI5aDMfimH/M5P7WlqK7GTaALGC26c3m4SKEFQV7dqGf3OrS7cjZjDq2Q==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(36840700001)(46966006)(7696005)(47076005)(82740400003)(356005)(186003)(2906002)(82310400003)(86362001)(8676002)(8936002)(316002)(83380400001)(36860700001)(54906003)(52536014)(33656002)(55016002)(5660300002)(336012)(53546011)(70586007)(70206006)(26005)(478600001)(6862004)(450100002)(4326008)(6506007)(9686003)(107886003)(81166007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 13:17:00.8603
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 440f7464-d4bb-435d-9f1b-08d94ab77e61
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT055.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB2999
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUHJhYmhha2FyDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUHJh
Ymhha2FyIEt1c2h3YWhhIDxwcmFiaGFrYXIucGtpbkBnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgSnVseSAxOSwgMjAyMSA2OjM2IFBNDQo+IFRvOiBKdXN0aW4gSGUgPEp1c3Rpbi5IZUBhcm0u
Y29tPg0KPiBDYzogQXJpZWwgRWxpb3IgPGFlbGlvckBtYXJ2ZWxsLmNvbT47IEdSLWV2ZXJlc3Qt
bGludXgtbDJAbWFydmVsbC5jb207DQo+IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+Ow0KPiBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBMaW51eCBLZXJuZWwgTWFpbGluZyBMaXN0IDxsaW51eC0NCj4ga2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IG5kIDxuZEBhcm0uY29tPjsgU2hhaSBNYWxpbiA8bWFsaW4xMDI0QGdt
YWlsLmNvbT47DQo+IFNoYWkgTWFsaW4gPHNtYWxpbkBtYXJ2ZWxsLmNvbT47IFByYWJoYWthciBL
dXNod2FoYSA8cGt1c2h3YWhhQG1hcnZlbGwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBx
ZWQ6IGZpeCBwb3NzaWJsZSB1bnBhaXJlZCBzcGluX3t1bn1sb2NrX2JoIGluDQo+IF9xZWRfbWNw
X2NtZF9hbmRfdW5pb24oKQ0KPiANCj4gSGkgSmlhLA0KPiANCj4gT24gVGh1LCBKdWwgMTUsIDIw
MjEgYXQgMjoyOCBQTSBKaWEgSGUgPGp1c3Rpbi5oZUBhcm0uY29tPiB3cm90ZToNCj4gPg0KPiA+
IExpYWppYW4gcmVwb3J0ZWQgYSBidWdfb24gaGl0IG9uIGEgVGh1bmRlclgyIGFybTY0IHNlcnZl
ciB3aXRoIEZhc3RMaW5RDQo+ID4gUUw0MTAwMCBldGhlcm5ldCBjb250cm9sbGVyOg0KPiA+ICBC
VUc6IHNjaGVkdWxpbmcgd2hpbGUgYXRvbWljOiBrd29ya2VyLzA6NC81MzEvMHgwMDAwMDIwMA0K
PiA+ICAgW3FlZF9wcm9iZTo0ODgoKV1odyBwcmVwYXJlIGZhaWxlZA0KPiA+ICAga2VybmVsIEJV
RyBhdCBtbS92bWFsbG9jLmM6MjM1NSENCj4gPiAgIEludGVybmFsIGVycm9yOiBPb3BzIC0gQlVH
OiAwIFsjMV0gU01QDQo+ID4gICBDUFU6IDAgUElEOiA1MzEgQ29tbToga3dvcmtlci8wOjQgVGFp
bnRlZDogRyBXIDUuNC4wLTc3LWdlbmVyaWMgIzg2LQ0KPiBVYnVudHUNCj4gPiAgIHBzdGF0ZTog
MDA0MDAwMDkgKG56Y3YgZGFpZiArUEFOIC1VQU8pDQo+ID4gIENhbGwgdHJhY2U6DQo+ID4gICB2
dW5tYXArMHg0Yy8weDUwDQo+ID4gICBpb3VubWFwKzB4NDgvMHg1OA0KPiA+ICAgcWVkX2ZyZWVf
cGNpKzB4NjAvMHg4MCBbcWVkXQ0KPiA+ICAgcWVkX3Byb2JlKzB4MzVjLzB4Njg4IFtxZWRdDQo+
ID4gICBfX3FlZGVfcHJvYmUrMHg4OC8weDVjOCBbcWVkZV0NCj4gPiAgIHFlZGVfcHJvYmUrMHg2
MC8weGUwIFtxZWRlXQ0KPiA+ICAgbG9jYWxfcGNpX3Byb2JlKzB4NDgvMHhhMA0KPiA+ICAgd29y
a19mb3JfY3B1X2ZuKzB4MjQvMHgzOA0KPiA+ICAgcHJvY2Vzc19vbmVfd29yaysweDFkMC8weDQ2
OA0KPiA+ICAgd29ya2VyX3RocmVhZCsweDIzOC8weDRlMA0KPiA+ICAga3RocmVhZCsweGYwLzB4
MTE4DQo+ID4gICByZXRfZnJvbV9mb3JrKzB4MTAvMHgxOA0KPiA+DQo+ID4gSW4gdGhpcyBjYXNl
LCBxZWRfaHdfcHJlcGFyZSgpIHJldHVybnMgZXJyb3IgZHVlIHRvIGh3L2Z3IGVycm9yLCBidXQg
aW4NCj4gPiB0aGVvcnkgd29yayBxdWV1ZSBzaG91bGQgYmUgaW4gcHJvY2VzcyBjb250ZXh0IGlu
c3RlYWQgb2YgaW50ZXJydXB0Lg0KPiA+DQo+ID4gVGhlIHJvb3QgY2F1c2UgbWlnaHQgYmUgdGhl
IHVucGFpcmVkIHNwaW5fe3VufWxvY2tfYmgoKSBpbg0KPiA+IF9xZWRfbWNwX2NtZF9hbmRfdW5p
b24oKSwgd2hpY2ggY2F1c2VzIGJvdHRvbiBoYWxmIGlzIGRpc2FibGVkDQo+IGluY29ycmVjdGx5
Lg0KPiA+DQo+ID4gUmVwb3J0ZWQtYnk6IExpamlhbiBaaGFuZyA8TGlqaWFuLlpoYW5nQGFybS5j
b20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmlhIEhlIDxqdXN0aW4uaGVAYXJtLmNvbT4NCj4gPiAt
LS0NCj4gDQo+IFRoaXMgcGF0Y2ggaXMgYWRkaW5nIGFkZGl0aW9uYWwgc3Bpbl97dW59bG9ja19i
aCgpLg0KPiBDYW4geW91IHBsZWFzZSBlbmxpZ2h0ZW4gYWJvdXQgdGhlIGV4YWN0IGZsb3cgY2F1
c2luZyB0aGlzIHVucGFpcmVkDQo+IHNwaW5fe3VufWxvY2tfYmguDQo+IA0KRm9yIGluc3RhbmNl
Og0KX3FlZF9tY3BfY21kX2FuZF91bmlvbigpDQogIEluIHdoaWxlIGxvb3ANCiAgICBzcGluX2xv
Y2tfYmgoKQ0KICAgIHFlZF9tY3BfaGFzX3BlbmRpbmdfY21kKCkgKGFzc3VtZSBmYWxzZSksIHdp
bGwgYnJlYWsgdGhlIGxvb3ANCiAgaWYgKGNudCA+PSBtYXhfcmV0cmllcykgew0KLi4uDQogICAg
cmV0dXJuIC1FQUdBSU47IDwtLSBoZXJlIHJldHVybnMgLUVBR0FJTiB3aXRob3V0IGludm9raW5n
IGJoIHVubG9jayANCiAgfQ0KDQo+IEFsc28sDQo+IGFzIHBlciBkZXNjcmlwdGlvbiwgbG9va3Mg
bGlrZSB5b3UgYXJlIG5vdCBzdXJlIGFjdHVhbCB0aGUgcm9vdC1jYXVzZS4NCj4gZG9lcyB0aGlz
IHBhdGNoIHJlYWxseSBzb2x2ZWQgdGhlIHByb2JsZW0/DQoNCkkgZG9uJ3QgaGF2ZSB0aGF0IFRo
dW5kZXJYMiB0byB2ZXJpZnkgdGhlIHBhdGNoLg0KQnV0IEkgc2VhcmNoZWQgYWxsIHRoZSBzcGlu
X2xvY2svdW5sb2NrX2JoIGFuZCBzcGluX2xvY2tfaXJxc2F2ZS9pcnFyZXN0b3JlDQp1bmRlciBk
cml2ZXIvLi4uL3Fsb2dpYywgdGhpcyBpcyB0aGUgb25seSBwcm9ibGVtYXRpYyBwb2ludCBJIGNv
dWxkIGZpZ3VyZQ0Kb3V0LiBBbmQgdGhpcyBtaWdodCBiZSBwb3NzaWJsZSBjb2RlIHBhdGggb2Yg
cWVkX3Byb2JlKCkuDQoNCi0tDQpDaGVlcnMsDQpKdXN0aW4gKEppYSBIZSkNCg0KDQo=
