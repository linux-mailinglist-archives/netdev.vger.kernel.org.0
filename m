Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC63CF6D4
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 11:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbhGTItG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:49:06 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:50663
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235504AbhGTIsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 04:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPmEfRvaVRDA87Yei7zI2Ki+zk63via0xQL36rlZaL8=;
 b=yToCcJl9k9C6Ltsbl1y4uc7bbJf+3f7oA1b1pAZS6jAAjXJolRCB46iK41prwUaL/aO1Mv12/Hjr8Q9kVd4rT5+s9/atbZId5QXFS4TMYStDgTZdEYhr5Ti8BXZI4C4+1K3wujKExjL/u6PrdAdowqPVWkB+KzuhfKpqrqzc2qg=
Received: from DB8PR06CA0019.eurprd06.prod.outlook.com (2603:10a6:10:100::32)
 by AS8PR08MB6678.eurprd08.prod.outlook.com (2603:10a6:20b:398::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Tue, 20 Jul
 2021 09:28:49 +0000
Received: from DB5EUR03FT006.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:100:cafe::52) by DB8PR06CA0019.outlook.office365.com
 (2603:10a6:10:100::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 09:28:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT006.mail.protection.outlook.com (10.152.20.106) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 09:28:49 +0000
Received: ("Tessian outbound 57330d0f8f60:v99"); Tue, 20 Jul 2021 09:28:49 +0000
X-CR-MTA-TID: 64aa7808
Received: from 0850b6bc121e.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 4B58EE73-5373-425F-8278-D584179D406E.1;
        Tue, 20 Jul 2021 09:28:43 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0850b6bc121e.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 20 Jul 2021 09:28:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8qRHjaoGZ0/Nze6apnF+x6OSbMrcPtBJvL7Qn6CtRZFn5vU6XWvLCgk5cBVRRYGNqGD2Qw4DvrSBrFTDLZIRtOffUaw7jjZrNA2P9J3LushY5x3GJ32HIdHWNatd3r9yoJ6MHkLWbtJ5L4fJ7DNZIf9+Uzd7CxlyMuFPYWl4zr2k7sdQf7JlBBUXVMGhpJxbeGOMZKdWPPxMYTjvuJuSQyd5yj/3evtUa9cMagmGGAU/xkPQcWnCDJ9skNeJW7N1Un7D/PwJnfpBPtZGoGu9nhUXVh05Fw3RqBR4egzQM1BR7WlSpi8dUved46RQQ4up36RdPEIFd8qI7bEs28uNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPmEfRvaVRDA87Yei7zI2Ki+zk63via0xQL36rlZaL8=;
 b=evsWvn5+A0jpKJByQELTzkxdEO2T2ORq0hND0WH/TYwoobpr8wFfokDdM3tWNE5TmBx/Os+evn2qkCmXkpbi46iwTL9VhKlFipRmBcy9ouFFuKUruYjY2Y+gVePbrwcnk7pJs7bv7gFSijb9eIRQ156H6hs0be33gRbO6IcfiARZYqz9Vp+j22mQVNiICKeYug6sMJckcP7eyDdg3TfDo8z9iuSnY5ulRn1CnLBZcEYgWidyRs6nH9hQZjB9iyxYINInXpDGeiEahtU0mIV5DBHlbO3XKTxPNLkAxzoi2OdM+mrrZE4QEcpL8ZKDby2dkTfP3dfJMQBOiOd9ub/f4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YPmEfRvaVRDA87Yei7zI2Ki+zk63via0xQL36rlZaL8=;
 b=yToCcJl9k9C6Ltsbl1y4uc7bbJf+3f7oA1b1pAZS6jAAjXJolRCB46iK41prwUaL/aO1Mv12/Hjr8Q9kVd4rT5+s9/atbZId5QXFS4TMYStDgTZdEYhr5Ti8BXZI4C4+1K3wujKExjL/u6PrdAdowqPVWkB+KzuhfKpqrqzc2qg=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB3752.eurprd08.prod.outlook.com (2603:10a6:20b:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 09:28:35 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1%5]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 09:28:34 +0000
From:   Justin He <Justin.He@arm.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>, Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>, nd <nd@arm.com>
Subject: RE: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Topic: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Index: AQHXeVClyEXp90xYxUyzsooHikRZAqtKIQeAgAApWfCAAB3xAIAAutzQgAB3FwCAAAYdIA==
Date:   Tue, 20 Jul 2021 09:28:34 +0000
Message-ID: <AM6PR08MB43767F0DA3616FC513F289C2F7E29@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210715080822.14575-1-justin.he@arm.com>
        <CAJ2QiJLWgxw0X8rkMhKgAGgiFS5xhrhMF5Dct_J791Kt-ys7QQ@mail.gmail.com>
        <AM6PR08MB4376894A46B47B024F50FBB3F7E19@AM6PR08MB4376.eurprd08.prod.outlook.com>
        <CAJ2QiJJ8=jkbRVscnXM2m_n2RX2pNdJG4iA3tYiNGDYefb-hjA@mail.gmail.com>
        <AM6PR08MB4376CD003BF58F85E0121F39F7E29@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <20210720110556.24cf7f8e@cakuba>
In-Reply-To: <20210720110556.24cf7f8e@cakuba>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: F1805B97DFA246458C4F8D16F1B176D1.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 63cca61b-c6a6-4647-031a-08d94b60c806
x-ms-traffictypediagnostic: AM6PR08MB3752:|AS8PR08MB6678:
X-Microsoft-Antispam-PRVS: <AS8PR08MB66788FA8F338706213123BD8F7E29@AS8PR08MB6678.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: b2egcGMcHkbYrog8jhiMDn8JNFAp004M7CtmZJ9E5Ax0+xSUapBk0kxTI1QOX8dX05SF+7xGLtqwOlC3X8mD8c7mKFSEr9lVZJffwm3UR0Dd0ic6AZ43zfeFjlWSH41/toWOlNm0g46E+A0tkiPE1Se5GQd/UHI0LqERpIfjUh+u2hdzFGNoLnjC4+NgzRe9Gcix3Hf7VL2zxrASXjFyMcNkLK9OLfKYQv4cqVAXSUJHTyvA+MlWkS98u7icW9HzidbqI3RGDaAhAZkXExSSkMSBmHW5XbxlGVmby0HoBZ8ZzyTGLbfB76O+Q0CEHWin8FTWen9AoY04+YEAIKUfJAKTeVjwqUcorkTihsnXYgQoko9zzoBnrpO4BPTgleCTbd8IOuF8AE5zZyBLS5dz1vYLdOxIzuxpYSdlv9HWPbPx4Py7LU9kimhGK7NrHbQ63eDnO5QLJvZUdvMvYOBOcG0gFb3twUxLID+P+LDPlzr3M81iLs2XfkFnDPxsrz1I+CPtoZ5aVOELpnAEAjzid2ZeYhmj7eJwT3HKPCSyBW9w3yDZbRt0Yh2aszLscuANyV2H7Hk1S1MaaOfo45sx44i0IRDdMHobJJ7U8qPIPk0qpy4+jbIDGpT30q1IHbSnvfrCDJ0X6EgphsOESUCMUaQea6gsVPyB8nTBykrw32TMb39Luny6gB8JExnTMsuCyin2GN0ZdmWlW8bLMHZ8Ig==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(346002)(366004)(396003)(71200400001)(186003)(8936002)(83380400001)(33656002)(8676002)(76116006)(66476007)(66946007)(26005)(6506007)(6916009)(66556008)(53546011)(4326008)(86362001)(66446008)(9686003)(55016002)(64756008)(5660300002)(52536014)(7696005)(478600001)(54906003)(316002)(7416002)(122000001)(2906002)(38100700002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?U0tlRUFRRjQyb2MzMDFvYUNZQUdSb2QyalYrMHNweUVieS8vUE55SDB2SW50?=
 =?gb2312?B?MDk1V3d5akMwQnBnWVZGdHRWN1VzNk5DUjlMejliY095QUIzcnQwTGJROXBi?=
 =?gb2312?B?dVJVR2Fqek80OUxZV0NvOFl5dDdnZWthQUlwMDBGMWU4VWRVbVFlV0pCQnYr?=
 =?gb2312?B?RlZJMi9hV3g4YlZBTTB6YXU1KzZtcnJRNFRiU0VCdlRlbEVMRzJtblVEVktJ?=
 =?gb2312?B?OGlFN2Jlb1Q0N2VsaE55VnF6eEtncTh1YlVBdmNUQ1pCQ1orMVhpOVVSWG1F?=
 =?gb2312?B?YkkvUmJ4NGE0bU13d2pWdXZWU09QWXZwOGtTcXQvOHJmQm9lUlJXNDlpR3hi?=
 =?gb2312?B?TjVxWnQzS29US1lKVHpKM0psRTZJeGNYUWUvcEZIdnBld3plcEZFVGNrVzFx?=
 =?gb2312?B?eFltU0lYZDRsWEd0b2ltMW9EL2FKa0xDTTVIRkRwQy9XTysyR25Zd1lJSkIz?=
 =?gb2312?B?WUxpMTlHOUhQTlE1WTNwWFoxdGg3QjZSNDNFWHdJSlMrek5iRzJwcUtoWTNz?=
 =?gb2312?B?OGYrTG9LcHI4V1Axc2UwWWIxL3JYQW1LSnFvaXB6NDhpd29MM01mWGxKWjhC?=
 =?gb2312?B?bGpKV0VkeVoxTlgyVEpHNGNrRVlzV1JXVWI3a0Zub1FmUnc5QzVYYWE0dlhS?=
 =?gb2312?B?ZDJ3RnNjN1pjNjN5U0Flc2dSazl3QVFvZmhBQmExSCtXSUpVcDZNdEdWL0lt?=
 =?gb2312?B?OWlweWNKYU9SdE4zK1EzMHl4WTJ6bjBSZEYvUVdobElPNE1uWlp0aUEvNlU5?=
 =?gb2312?B?N2dvVFhBSjZDTjQ4djFkWURFekQ0eDliSytZMzFySW5rZENoRkJ2N0d0VEw2?=
 =?gb2312?B?YzZwbkNUb3p2WThkK0ViSHYxUlhHWnZxRWFWSWpKd0RHL2FLd2NCTkFpelV3?=
 =?gb2312?B?bFg1QmVva3ovQmhVSzJ2NjI4eVFneDlicks4ZDBtREZuQUJvQzlNdlY4MzAv?=
 =?gb2312?B?eitRUUVESndoTzdOQjcxZkxDYWhOYVdINFdxQ3dnb3Q2VmZ4RCtnbkZZYzd2?=
 =?gb2312?B?UWFEQnlvWFp4dnVQUE5WUTd1QUgrQUg1S2NCbVZtd0ZLeDMyaXNlUXZxNHFj?=
 =?gb2312?B?OVNPQnB0bE01SjdyTFF0VkYzVFJydnhxQUJOUmI5OTArNGpqeVFqTFNwNW5u?=
 =?gb2312?B?VzVySTBuS0paZEp0WHcwUzliRDd4L2dMeUk4ZFZNZGI1SUtBNllwbXRWTko5?=
 =?gb2312?B?SENFODg5c0lnUC90YkZSYnJkZ1JGK0lwaWhzQjNnYUR6aSs3c0xrMHVCckVh?=
 =?gb2312?B?T1FBLzUrcXY5dXFVMmlEVG1ZS1pla3NVaFk1a05tclBjT3VhOWZwdzVTMjB4?=
 =?gb2312?B?d2pWSTNxLzdTcUZ3K0pqenFDR0VmcStTYjlsek1CWjBDQm1Ub0hLcm13UjRz?=
 =?gb2312?B?Y3FZNHBBVTZ2MkFiMnNWZ294RXdJZUE3S2VHdmVLamZZN1NjQjlyMXN1dDBI?=
 =?gb2312?B?bmNVazhyOHJjNm92NEZyQTlyanova1phWENuTWI4emtUOHBMUG1mVEIzc21C?=
 =?gb2312?B?VWZyZTUzbXNJOFJFUHVia05nM1YraEpyUnhxZjROOUZJQjFnRGI3TUFkdVMr?=
 =?gb2312?B?NlFrN0RIUWo4bG5WWWdpVUFnZmpRaGRtSG1wd0xqbDFRMVoxVk9LWkdhRTF4?=
 =?gb2312?B?eHh5TXVPVlVzVW5aTXAzcDE5K2tEcVZ2bUZscXdNTEJVem96cWVnTjdUZkxx?=
 =?gb2312?B?RVBqNjljSUdFaFZrbEUvZXRRWXdUajc0bUNQZVg5WUVBbU4rYTR4UUl3ajdo?=
 =?gb2312?Q?I15M0qHSp3a/v8zZcIHaAHTJ49Iy6vlp5VNxUdp?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3752
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT006.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9c8e0c15-0c40-44f5-16ee-08d94b60bf46
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tf7ADfUt67Onri7l8qNrnuhX372j5khp7aJn/f0iOZwGGmsvuvhKy45bGj6hT71Fk/oOi38nWZsHM65P/ktVixIwG0G/B6PrxyB63fKBoAF6cfDDrSChbnUj4cl/v7Ckc/w+AXbEvyxc28FSuUXo9f/Evxw9j9uNG+fh1ZMF6OLZk3y5KPGXfqKrngXGsYV10BsSxkpP01dtXO5q0CkhBPdKYLbLdki9m271rfBD//ZnalWbRaEwQ2YsQBLsUfclWQXP5oNVB1tcLsDtg00eT+vyeCz7z0cg7leLRz1g0fkz2IzUiguEh7NzH0RWgMErDpq8BMDXraARuLRVucv7CO8k99I7DK7B0E2AhYmTUMLXL5NfciBZD7e1n1odhbZcHNKP+3lE4NaNCuIqBSkx4tU2NN728HE/Z3zG9o0v2ERByGEriAamR/NodF213FGl7642d8UmRBpkG7LH1ijkQT0RLqjFT0n8xgDNFJWPUE18+Cbst+ylOmG5C+i12fSADICNarJ20wpxMTaXdKH/cC83YJa8/TMUDvXHozK8ijGpCw9t1j2gYm7xiAPlRBt5Dq4cOVLD4X+9A1ZcoZLrPL/RhSLQLqGJt+GlyGjoeZtyRB+/UMZvtrryHnqTjnfMUwJl0K9L3QkiEUEN/cZbRO6uBmZJI/mQEnkv4PYhGQKt92XSJUUMP5FU74EeOJ6F6vqjFAwU7rd6mVS1Puy3kA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39850400004)(136003)(376002)(346002)(396003)(36840700001)(46966006)(83380400001)(47076005)(70206006)(52536014)(356005)(6506007)(86362001)(53546011)(9686003)(82740400003)(316002)(70586007)(54906003)(8936002)(81166007)(450100002)(2906002)(8676002)(186003)(82310400003)(6862004)(36860700001)(4326008)(26005)(33656002)(7696005)(5660300002)(336012)(55016002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 09:28:49.4316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63cca61b-c6a6-4647-031a-08d94b60c806
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT006.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6678
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogVHVlc2RheSwgSnVseSAyMCwgMjAyMSA1OjA2IFBN
DQo+IFRvOiBKdXN0aW4gSGUgPEp1c3Rpbi5IZUBhcm0uY29tPg0KPiBDYzogUHJhYmhha2FyIEt1
c2h3YWhhIDxwcmFiaGFrYXIucGtpbkBnbWFpbC5jb20+OyBEYXZpZCBTLiBNaWxsZXINCj4gPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+OyBBcmllbCBFbGlvciA8YWVsaW9yQG1hcnZlbGwuY29tPjsgR1It
ZXZlcmVzdC1saW51eC0NCj4gbDJAbWFydmVsbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IExpbnV4IEtlcm5lbCBNYWlsaW5nIExpc3QgPGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwu
b3JnPjsgbmQgPG5kQGFybS5jb20+OyBTaGFpIE1hbGluIDxtYWxpbjEwMjRAZ21haWwuY29tPjsN
Cj4gU2hhaSBNYWxpbiA8c21hbGluQG1hcnZlbGwuY29tPjsgUHJhYmhha2FyIEt1c2h3YWhhIDxw
a3VzaHdhaGFAbWFydmVsbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHFlZDogZml4IHBv
c3NpYmxlIHVucGFpcmVkIHNwaW5fe3VufWxvY2tfYmggaW4NCj4gX3FlZF9tY3BfY21kX2FuZF91
bmlvbigpDQo+IA0KPiBPbiBUdWUsIDIwIEp1bCAyMDIxIDAyOjAyOjI2ICswMDAwLCBKdXN0aW4g
SGUgd3JvdGU6DQo+ID4gPiA+IEZvciBpbnN0YW5jZToNCj4gPiA+ID4gX3FlZF9tY3BfY21kX2Fu
ZF91bmlvbigpDQo+ID4gPiA+ICAgSW4gd2hpbGUgbG9vcA0KPiA+ID4gPiAgICAgc3Bpbl9sb2Nr
X2JoKCkNCj4gPiA+ID4gICAgIHFlZF9tY3BfaGFzX3BlbmRpbmdfY21kKCkgKGFzc3VtZSBmYWxz
ZSksIHdpbGwgYnJlYWsgdGhlIGxvb3ANCj4gPiA+DQo+ID4gPiBJIGFncmVlIHRpbGwgaGVyZS4N
Cj4gPiA+DQo+ID4gPiA+ICAgaWYgKGNudCA+PSBtYXhfcmV0cmllcykgew0KPiA+ID4gPiAuLi4N
Cj4gPiA+ID4gICAgIHJldHVybiAtRUFHQUlOOyA8LS0gaGVyZSByZXR1cm5zIC1FQUdBSU4gd2l0
aG91dCBpbnZva2luZyBiaA0KPiB1bmxvY2sNCj4gPiA+ID4gICB9DQo+ID4gPiA+DQo+ID4gPg0K
PiA+ID4gQmVjYXVzZSBvZiBicmVhaywgY250IGhhcyBub3QgYmVlbiBpbmNyZWFzZWQuDQo+ID4g
PiAgICAtIGNudCBpcyBzdGlsbCBsZXNzIHRoYW4gbWF4X3JldHJpZXMuDQo+ID4gPiAgIC0gaWYg
KGNudCA+PSBtYXhfcmV0cmllcykgd2lsbCBub3QgYmUgKnRydWUqLCBsZWFkaW5nIHRvDQo+IHNw
aW5fdW5sb2NrX2JoKCkuDQo+ID4gPiBIZW5jZSBwYWlyaW5nIGNvbXBsZXRlZC4NCj4gPg0KPiA+
IFNvcnJ5LCBpbmRlZWQuIExldCBtZSBjaGVjayBvdGhlciBwb3NzaWJpbGl0aWVzLg0KPiA+IEBE
YXZpZCBTLiBNaWxsZXIgU29ycnkgZm9yIHRoZSBpbmNvbnZlbmllbmNlLCBjb3VsZCB5b3UgcGxl
YXNlIHJldmVydCBpdA0KPiA+IGluIG5ldGRldiB0cmVlPw0KPiANCj4gUGxlYXNlIHN1Ym1pdCBh
IHJldmVydCBwYXRjaCB3aXRoIHRoZSBjb25jbHVzaW9ucyBmcm9tIHRoZSBkaXNjdXNzaW9uDQo+
IGluY2x1ZGVkIGluIHRoZSBjb21taXQgbWVzc2FnZS4NCk9rYXmjrHdpbGwgZG8gdGhhdA0KVGhh
bmtzIGZvciB0aGUgcmVtaW5kZXINCg0KLS0NCkNoZWVycywNCkp1c3RpbiAoSmlhIEhlKQ0KDQoN
Cg==
