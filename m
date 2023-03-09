Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0371A6B1AA5
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 06:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCIFPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 00:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjCIFPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 00:15:41 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43956A07A;
        Wed,  8 Mar 2023 21:15:34 -0800 (PST)
X-UUID: 67be8df6be3911eda06fc9ecc4dadd91-20230309
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=NDqS8d8JfUHEJmBvbTTL2LC9DrdQ1mCaVERzvejVSEQ=;
        b=WT6X9ZmSckLoxeNJJk1fZgA/c3cbZW/Zl7ljCYiYL5SvURdAe5vTHmXteDzkMhYwEoi0yFnr+CuuQg74lZcx8DxoQEj703+RJEZ20Dunf2ViN4pcZTAj5q5WhxekspNrSCu3PPHqbOJZ4LIrcF3Lf/iVIytcJ/wUqiAq+a2eGyQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:c18271e0-febe-4d80-8a05-f50c270f97e0,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:115dafb2-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: 67be8df6be3911eda06fc9ecc4dadd91-20230309
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 790794329; Thu, 09 Mar 2023 13:15:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 9 Mar 2023 13:15:26 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 9 Mar 2023 13:15:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsQZ1tR6+PFhyvv9PBfiLr9aXxtzgiwOqt9BbOKEC7DH2rovNZoC7/H/zIPDSTE5GFMqBRIkLdU3ny4qpApQp6eXE93qBMv69P/546VeMTHTawAzXEvRy9ILq+P830oorTIhAlyQyrJVXNEvGp9ybAf81kf4TxqOMQ/6Qs+z5/b9iv1SKvdVTcEstNB0gAU6dOG1f1kqJesCGEXL3fFX/cWgs5jyi1JYZ1O+YIau9jcCePAPLsEleTEuXrFkEPY9cXAeYSRaj/BRBKeLdBVWcGLS++H4p4ajQS0NNI8AL+k66dLpzSX2HUqygOTyvKaCAgDKRdNCW4T4ZXXHgU5N4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDqS8d8JfUHEJmBvbTTL2LC9DrdQ1mCaVERzvejVSEQ=;
 b=U9FmJIj+7LpRyddFqqH6f0ntgSJGyYckare8l9fNF8YvHL215L5TXgBr21VkzOtPq2gA6KhWkZOSbsc2Yij9OEHDZLNDmZGk49KSVDxaqgW6MkbGEqbB66zEyOYLT2u6bYTp7tz9jdt+tl3FtNVxZ0z0z/poREAYEjFxyJGZXZUdhUwBadpTk5rpcyuGIn07+eYDQ7cBafeP8BCOnhplObN7ml9FWjkagUIpf9RFn2HM+RDKo4BMfsh/jdRTLSTMnpU94q+J8+LjHJdlvqRWm2HoU0dCtlIAR6iCXGc2L+Am1HKe6uziijStZMYg+9KQs+JPFv2H7SpwzF18SwUxSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDqS8d8JfUHEJmBvbTTL2LC9DrdQ1mCaVERzvejVSEQ=;
 b=d0hn+9ROZ+EC8OD0SwP9sFNCgXalpK0gP9qQ4E3FYkDsRqp87MsoUPisNW73pB8mJ8SEuTsbQL3yJR3tE5zCrZfpT5iLhAfQajtCvrkMCdbJtUFPjZZiz6Sf/x5wGsDM73QLptPHU+Nk2QOGGKR+j3JkIYPybuHTzBB4aRu8M1Y=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by TY0PR03MB6403.apcprd03.prod.outlook.com (2603:1096:400:14f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 05:15:22 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 05:15:22 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "wenst@chromium.org" <wenst@chromium.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Project_Global_Chrome_Upstream_Group 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v5 12/19] clk: mediatek: Add MT8188 vdosys0 clock support
Thread-Topic: [PATCH v5 12/19] clk: mediatek: Add MT8188 vdosys0 clock support
Thread-Index: AQHZLAR2rWST28FWtkaz2oaSNryUuK6858SAgDVMfYA=
Date:   Thu, 9 Mar 2023 05:15:22 +0000
Message-ID: <1536ba0d58ef2494d4ae5a499b3a1a93bef9b654.camel@mediatek.com>
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
         <20230119124848.26364-13-Garmin.Chang@mediatek.com>
         <CAGXv+5Fysy4iCvHEXWtf5oXCHkaKezPqcrGd8QzhnaTrYdyecA@mail.gmail.com>
In-Reply-To: <CAGXv+5Fysy4iCvHEXWtf5oXCHkaKezPqcrGd8QzhnaTrYdyecA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|TY0PR03MB6403:EE_
x-ms-office365-filtering-correlation-id: 8e947459-d32c-4907-548a-08db205d4885
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qwSO6SfenuJjnte+7Cnbwi4nNWsAtTBEk0v0h//VwHowJtF0u/QwmZjlTAp4mmlvYYgNMyagNCZrsHofqfFWUCbCEr5OaOfun+tGj/eq7Pah+JdihwMz/UMfFttOvXyggwjg1ikfhpo4rp2ADFZftDmKmaskaddMrqZThvX7pzaCTXd4T3RdV+Fe1hVXZfs3PEVpCZKcYjO3/CGpQ3JzgBb9wnSAlv6vMZYO8dSVKu20aYft4tFO6XJPtPdWXWdW9WzeFbHm1DGPXY1uSWaSLkcDxLLJH9PRruJFFog+bP2/B9YCZRgzKACnlrH1N2y0HgyHSL+yIU0sO3SI8nR10L8JFUEqSmz0huVJYXwT/ho9ephdM1cgU5gEo3t3UMKFqnsX8OnfQ7zAmdtRZGaDc5C9Bd8eTKiJNjLiKLLlj3eHTkE/fGJD+Wt74qc1Oq4BN0730gmkvO76DmvcGcQ2MZHLT2/uzlreUan4IKYz0zFbmw25WEXg46bSCcEsVMDJuUggontBlsrE3t2RqiTGce+iurMXTTmGbqyiIs+2ZlkCK1fajUpnXpIHC4vRevZp/Ya9dIXCee6j9CiWtOHRscwenYynq316WP5UPD0hQjtTbKPWxLpDo6vFailZmEE/6bWovasTVdBO19XfTXV/lvRNgqdavJMLUeQkiaTo5jEB32yR7X75H8DrnKG4O2aCh2NAYKN8S0JruxMf3fwlNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199018)(54906003)(38100700002)(86362001)(36756003)(85182001)(186003)(26005)(83380400001)(38070700005)(122000001)(6506007)(6512007)(53546011)(2616005)(316002)(5660300002)(7416002)(71200400001)(478600001)(6486002)(4326008)(6916009)(41300700001)(8936002)(76116006)(2906002)(8676002)(66946007)(66556008)(66446008)(64756008)(91956017)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGtlYTNodEx3VnFUYmtlNGFOd0o3YmhHb1dRN3Yvb2pZbERPQnhIcUowWUR2?=
 =?utf-8?B?R0o2Z0E2dkg4U21pRXVQSjQxZEI1dFFxRjd5emd6amJVSlo0N093dUZBQ3hN?=
 =?utf-8?B?d3ZiU0U4VEM5RktGb0lHeDJwZzgzbU4zTkZic25LMXdtUk9qWG9EallPZGhS?=
 =?utf-8?B?cVg2ZzJONFpUQ3hqUGppOHNrWXVNelNwamJFTWhWMUc5NDhLc1pRK2dxWFBP?=
 =?utf-8?B?TUtkZWFUc3VzbVNibFNJUUg1Y0FkdHYzZFAzdWl3QUFVVDd6TDA4bDlSaTJT?=
 =?utf-8?B?Q3JoMWd6cW43V0ZZaWhVdkhsVWhsMkJDdVphOW1UOWRWSS8wMW9TVG5tMVl4?=
 =?utf-8?B?bWllM2tJaWx1T3JqajVIdGFCS2lFK0VZVFJ1OWJlRm85L1VNSmNYbGdUazRG?=
 =?utf-8?B?SllBbUFiV1pTMm1NdU5ZbEFBVWQ1Z0tmNE9KQnJhUnh2M3NRYjI0NExOS2hK?=
 =?utf-8?B?MUtoOVBKbytLR09NZDVCMWpMTm5QK3orUk9MUnY1UThETmMyakdrU0tUby9B?=
 =?utf-8?B?SjJpcTYwb2xtMmVrakRQeGV5cnhiYTF2Z2xJNjFNMzV6VXdTcFRueDdrWGRG?=
 =?utf-8?B?VzJLSGJIRlhWckIzQk10ZjdaSEI4UmNhOFA3bDNCYytGMUMzNnlydHFWSVQ5?=
 =?utf-8?B?UmxxREI0S2JEenJiNDM1Y2tNeUczN3VXOUZyYytSZm5HYkpiK1k2UW8wR1Jx?=
 =?utf-8?B?MWowTzdKd2VVWVprNnA3Z3pHWTBJaTZ1SWhlWWNDQ29mN0hFbm5QNVNCSkNx?=
 =?utf-8?B?NkZ5c0ZMTk50NzI0L1ZBV2VrRWRtK2pvRTErY25ENWQvY2x3aGZhQm9WRmpQ?=
 =?utf-8?B?T2lRRXRFVG9nYzI3S1BmbjdCekJEdlRhNXJqYnhwNTZnaXNZVGxxbGt2OVhZ?=
 =?utf-8?B?MHYyc1JtdVJYZHFEMkYwMWVHcjFvenM0R3BJS1NlclZCVlQ5RnoyNjVlQmIx?=
 =?utf-8?B?NDhib2xCclBSdlR3RHRETldlQS8xVWlUZENpQVdFQm5DcytwTmQ4SUR2MWpD?=
 =?utf-8?B?RUMrK1RGYnQyTXFjZGtVeG1LcGdReUJXTk55ZDRqVzVxc3VLVjZoYmVCa1pw?=
 =?utf-8?B?dGhWUGo3eGZSbi9WNHc3SXBhVElYMmNML0U2Mit5K2NMMmtuNVgwWlBROE5C?=
 =?utf-8?B?bzE3WE9WV1QxWWREWUQvc3dDN2J1K2ZnVTJ4UjFjOSs1emlJKzN4NDNkK2lF?=
 =?utf-8?B?SGF1R1lhRjhrZHp4R2tXdC9GODdMd0p0YndvYVBDZk1jL1V1RXJERWk4VFln?=
 =?utf-8?B?ZURBWkRBZVBVbWZkQXhJcmE2dnVydHNkeHBOWUVWMG5GZ2xrdUptblkzSDNL?=
 =?utf-8?B?K0RneThJN0hiMnUyV09CNkRoSDVYYkJPY2xnZGxqeXFFam1Scm5pWlk2YmFR?=
 =?utf-8?B?TFB3Q1YvNGxoUDZBRlF2VjAvSVpWUVgyK25aYnVJeEUrb0tHRjBOMGIyRHpZ?=
 =?utf-8?B?WkpOendmTWVsQ3hLUnNDQ2JQd25RNWpJMTZqMFZxN2xGNGNhQmZrNjhuL0ZI?=
 =?utf-8?B?Z2tlMyt2aGtzRVFYbXBnNU10bXlBWC84dEZ3ck83K2xDWm1LaVczNVAxNGlm?=
 =?utf-8?B?a0hJTGdKV25wam9GcFFUb2JWZTBiczJjL0ViWlVlbFZjWCtoNVVFakxUcURS?=
 =?utf-8?B?anlLajgvUUFZMmQwcXc4aTFqNDM0SURXenhVUUxHQWhuRHBsbXJqMExYS0s4?=
 =?utf-8?B?MXhNRzMrZlgwYzZka01iakZPSVE5Nmh0SGtaL2lXcWhiSlZlNENiT1hzZE5U?=
 =?utf-8?B?VHZuTmRCVFE5c0Vtd3dZWXV2TUo4OEp6QjQvcU1RNE1Iamc1a3V2NzFZbll5?=
 =?utf-8?B?dmhER2JuY2tGRXpsQjRtSzVOK0F4UERnUmZ1c3NIQnIzYy9CMEhvVzU3UnZ5?=
 =?utf-8?B?TThxVzEyTGRvOTBqc215VFVOZlM0aGxraVVleTRMTnBHOUFaZGNSRzdRcVhV?=
 =?utf-8?B?c21HdTRzZEVYalhjRnQ1OHZsR2RVaFNHcmh0dHpjTXdjaG9ENmp5Z0ZPdHR3?=
 =?utf-8?B?NTdpTFowSEYxaklWWHFTS0t5YnQraG5OOWZ0MmtUZ2N3ZHNjVmVJLy9Wb1V5?=
 =?utf-8?B?b0lBL0poVFhoajBnWnRCUEcxN1l3aGRlMkFOSXNlWVc2RG1UWWFUandXRGZo?=
 =?utf-8?B?dkVkYmU5NXBUdlZ6WDZGeXlCV2JKTmxNakdMQXFOdDI5R01IWTYvQ0J0dmI0?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8C3313D86CACE943A1B904B1E30EFDD5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e947459-d32c-4907-548a-08db205d4885
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 05:15:22.3177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8fy5wjDl4nNQFlVbQi2BX3gqAyAZxrn3XAE0mEJafkayzqvR7JEhSVfvdF9ND7RYeRIpHOdRowYhAnK9Xj3zFz7r2AKS0D0t8uqD1fC8XmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6403
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDE1OjE5ICswODAwLCBDaGVuLVl1IFRzYWkgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDE5LCAyMDIzIGF0IDg6NTQgUE0gR2FybWluLkNoYW5nIDwNCj4gR2FybWlu
LkNoYW5nQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIE1UODE4OCB2ZG9zeXMw
IGNsb2NrIGNvbnRyb2xsZXIgd2hpY2ggcHJvdmlkZXMgY2xvY2sgZ2F0ZQ0KPiA+IGNvbnRyb2wg
aW4gdmlkZW8gc3lzdGVtLiBUaGlzIGlzIGludGVncmF0ZWQgd2l0aCBtdGstbW1zeXMNCj4gPiBk
cml2ZXIgd2hpY2ggd2lsbCBwb3B1bGF0ZSBkZXZpY2UgYnkgcGxhdGZvcm1fZGV2aWNlX3JlZ2lz
dGVyX2RhdGENCj4gPiB0byBzdGFydCB2ZG9zeXMgY2xvY2sgZHJpdmVyLg0KPiA+IA0KPiA+IFNp
Z25lZC1vZmYtYnk6IEdhcm1pbi5DaGFuZyA8R2FybWluLkNoYW5nQG1lZGlhdGVrLmNvbT4NCj4g
PiAtLS0NCj4gPiAgZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUgICAgICAgICAgfCAgIDMg
Ky0NCj4gPiAgZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10ODE4OC12ZG8wLmMgfCAxMzQNCj4g
PiArKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTM2IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZl
cnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtdmRvMC5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRl
ay9NYWtlZmlsZQ0KPiA+IGluZGV4IDdkMDllOWZjNjUzOC4uZGY3OGMwNzc3ZmVmIDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gKysrIGIvZHJpdmVy
cy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4gPiBAQCAtODYsNyArODYsOCBAQCBvYmotJChDT05G
SUdfQ09NTU9OX0NMS19NVDgxODYpICs9IGNsay1tdDgxODYtDQo+ID4gbWN1Lm8gY2xrLW10ODE4
Ni10b3Bja2dlbi5vIGNsay1tdA0KPiA+ICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxODgp
ICs9IGNsay1tdDgxODgtYXBtaXhlZHN5cy5vIGNsay0NCj4gPiBtdDgxODgtdG9wY2tnZW4ubyBc
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGstbXQ4MTg4LXBlcmlf
YW8ubyBjbGstbXQ4MTg4LQ0KPiA+IGluZnJhX2FvLm8gXA0KPiA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgY2xrLW10ODE4OC1jYW0ubyBjbGstbXQ4MTg4LQ0KPiA+IGNjdS5v
IGNsay1tdDgxODgtaW1nLm8gXA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgY2xrLW10ODE4OC1pcGUubyBjbGstbXQ4MTg4LQ0KPiA+IG1mZy5vIGNsay1tdDgxODgtdmRl
Yy5vDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGstbXQ4MTg4LWlw
ZS5vIGNsay1tdDgxODgtDQo+ID4gbWZnLm8gY2xrLW10ODE4OC12ZGVjLm8gXA0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xrLW10ODE4OC12ZG8wLm8NCj4gPiAgb2Jq
LSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyKSArPSBjbGstbXQ4MTkyLm8NCj4gPiAgb2JqLSQo
Q09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyX0FVRFNZUykgKz0gY2xrLW10ODE5Mi1hdWQubw0KPiA+
ICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJfQ0FNU1lTKSArPSBjbGstbXQ4MTkyLWNh
bS5vDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtdmRv
MC5jDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LXZkbzAuYw0KPiA+IG5l
dyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi4zMGRkNjQzNzRhY2UN
Cj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10
ODE4OC12ZG8wLmMNCj4gPiBAQCAtMCwwICsxLDEzNCBAQA0KPiA+ICsvLyBTUERYLUxpY2Vuc2Ut
SWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+ID4gKy8vDQo+ID4gKy8vIENvcHlyaWdodCAoYykg
MjAyMiBNZWRpYVRlayBJbmMuDQo+ID4gKy8vIEF1dGhvcjogR2FybWluIENoYW5nIDxnYXJtaW4u
Y2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+ICsNCj4gPiArI2luY2x1ZGUgPGxpbnV4L2Nsay1wcm92
aWRlci5oPg0KPiA+ICsjaW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+DQo+ID4gKyNp
bmNsdWRlIDxkdC1iaW5kaW5ncy9jbG9jay9tZWRpYXRlayxtdDgxODgtY2xrLmg+DQo+ID4gKw0K
PiA+ICsjaW5jbHVkZSAiY2xrLWdhdGUuaCINCj4gPiArI2luY2x1ZGUgImNsay1tdGsuaCINCj4g
PiArDQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2dhdGVfcmVncyB2ZG8wXzBfY2dfcmVn
cyA9IHsNCj4gPiArICAgICAgIC5zZXRfb2ZzID0gMHgxMDQsDQo+ID4gKyAgICAgICAuY2xyX29m
cyA9IDB4MTA4LA0KPiA+ICsgICAgICAgLnN0YV9vZnMgPSAweDEwMCwNCj4gPiArfTsNCj4gPiAr
DQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2dhdGVfcmVncyB2ZG8wXzFfY2dfcmVncyA9
IHsNCj4gPiArICAgICAgIC5zZXRfb2ZzID0gMHgxMTQsDQo+ID4gKyAgICAgICAuY2xyX29mcyA9
IDB4MTE4LA0KPiA+ICsgICAgICAgLnN0YV9vZnMgPSAweDExMCwNCj4gPiArfTsNCj4gPiArDQo+
ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2dhdGVfcmVncyB2ZG8wXzJfY2dfcmVncyA9IHsN
Cj4gPiArICAgICAgIC5zZXRfb2ZzID0gMHgxMjQsDQo+ID4gKyAgICAgICAuY2xyX29mcyA9IDB4
MTI4LA0KPiA+ICsgICAgICAgLnN0YV9vZnMgPSAweDEyMCwNCj4gPiArfTsNCj4gPiArDQo+ID4g
KyNkZWZpbmUgR0FURV9WRE8wXzAoX2lkLCBfbmFtZSwgX3BhcmVudCwNCj4gPiBfc2hpZnQpICAg
ICAgICAgICAgICAgICAgICAgICBcDQo+ID4gKyAgICAgICBHQVRFX01USyhfaWQsIF9uYW1lLCBf
cGFyZW50LCAmdmRvMF8wX2NnX3JlZ3MsIF9zaGlmdCwNCj4gPiAmbXRrX2Nsa19nYXRlX29wc19z
ZXRjbHIpDQo+ID4gKw0KPiA+ICsjZGVmaW5lIEdBVEVfVkRPMF8xKF9pZCwgX25hbWUsIF9wYXJl
bnQsDQo+ID4gX3NoaWZ0KSAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgICAgR0FU
RV9NVEsoX2lkLCBfbmFtZSwgX3BhcmVudCwgJnZkbzBfMV9jZ19yZWdzLCBfc2hpZnQsDQo+ID4g
Jm10a19jbGtfZ2F0ZV9vcHNfc2V0Y2xyKQ0KPiA+ICsNCj4gPiArI2RlZmluZSBHQVRFX1ZETzBf
MihfaWQsIF9uYW1lLCBfcGFyZW50LA0KPiA+IF9zaGlmdCkgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gPiArICAgICAgIEdBVEVfTVRLKF9pZCwgX25hbWUsIF9wYXJlbnQsICZ2ZG8wXzJfY2df
cmVncywgX3NoaWZ0LA0KPiA+ICZtdGtfY2xrX2dhdGVfb3BzX3NldGNscikNCj4gPiArDQo+ID4g
KyNkZWZpbmUgR0FURV9WRE8wXzJfRkxBR1MoX2lkLCBfbmFtZSwgX3BhcmVudCwgX3NoaWZ0LA0K
PiA+IF9mbGFncykgICAgICAgICBcDQo+ID4gKyAgICAgICBHQVRFX01US19GTEFHUyhfaWQsIF9u
YW1lLCBfcGFyZW50LCAmdmRvMF8yX2NnX3JlZ3MsDQo+ID4gX3NoaWZ0LCAgICBcDQo+ID4gKyAg
ICAgICAmbXRrX2Nsa19nYXRlX29wc19zZXRjbHIsIF9mbGFncykNCj4gPiArDQo+ID4gK3N0YXRp
YyBjb25zdCBzdHJ1Y3QgbXRrX2dhdGUgdmRvMF9jbGtzW10gPSB7DQo+ID4gKyAgICAgICAvKiBW
RE8wXzAgKi8NCj4gPiArICAgICAgIEdBVEVfVkRPMF8wKENMS19WRE8wX0RJU1BfT1ZMMCwgInZk
bzBfZGlzcF9vdmwwIiwNCj4gPiAidG9wX3ZwcCIsIDApLA0KPiA+ICsgICAgICAgR0FURV9WRE8w
XzAoQ0xLX1ZETzBfRkFLRV9FTkcwLCAidmRvMF9mYWtlX2VuZzAiLA0KPiA+ICJ0b3BfdnBwIiwg
MiksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX0NDT1JSMCwgInZkbzBf
ZGlzcF9jY29ycjAiLA0KPiA+ICJ0b3BfdnBwIiwgNCksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBf
MChDTEtfVkRPMF9ESVNQX01VVEVYMCwgInZkbzBfZGlzcF9tdXRleDAiLA0KPiA+ICJ0b3BfdnBw
IiwgNiksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX0dBTU1BMCwgInZk
bzBfZGlzcF9nYW1tYTAiLA0KPiA+ICJ0b3BfdnBwIiwgOCksDQo+ID4gKyAgICAgICBHQVRFX1ZE
TzBfMChDTEtfVkRPMF9ESVNQX0RJVEhFUjAsICJ2ZG8wX2Rpc3BfZGl0aGVyMCIsDQo+ID4gInRv
cF92cHAiLCAxMCksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX1dETUEw
LCAidmRvMF9kaXNwX3dkbWEwIiwNCj4gPiAidG9wX3ZwcCIsIDE3KSwNCj4gPiArICAgICAgIEdB
VEVfVkRPMF8wKENMS19WRE8wX0RJU1BfUkRNQTAsICJ2ZG8wX2Rpc3BfcmRtYTAiLA0KPiA+ICJ0
b3BfdnBwIiwgMTkpLA0KPiA+ICsgICAgICAgR0FURV9WRE8wXzAoQ0xLX1ZETzBfRFNJMCwgInZk
bzBfZHNpMCIsICJ0b3BfdnBwIiwgMjEpLA0KPiA+ICsgICAgICAgR0FURV9WRE8wXzAoQ0xLX1ZE
TzBfRFNJMSwgInZkbzBfZHNpMSIsICJ0b3BfdnBwIiwgMjIpLA0KPiA+ICsgICAgICAgR0FURV9W
RE8wXzAoQ0xLX1ZETzBfRFNDX1dSQVAwLCAidmRvMF9kc2Nfd3JhcDAiLA0KPiA+ICJ0b3BfdnBw
IiwgMjMpLA0KPiA+ICsgICAgICAgR0FURV9WRE8wXzAoQ0xLX1ZETzBfVlBQX01FUkdFMCwgInZk
bzBfdnBwX21lcmdlMCIsDQo+ID4gInRvcF92cHAiLCAyNCksDQo+ID4gKyAgICAgICBHQVRFX1ZE
TzBfMChDTEtfVkRPMF9EUF9JTlRGMCwgInZkbzBfZHBfaW50ZjAiLCAidG9wX3ZwcCIsDQo+ID4g
MjUpLA0KPiA+ICsgICAgICAgR0FURV9WRE8wXzAoQ0xLX1ZETzBfRElTUF9BQUwwLCAidmRvMF9k
aXNwX2FhbDAiLA0KPiA+ICJ0b3BfdnBwIiwgMjYpLA0KPiA+ICsgICAgICAgR0FURV9WRE8wXzAo
Q0xLX1ZETzBfSU5MSU5FUk9UMCwgInZkbzBfaW5saW5lcm90MCIsDQo+ID4gInRvcF92cHAiLCAy
NyksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9BUEJfQlVTLCAidmRvMF9hcGJf
YnVzIiwgInRvcF92cHAiLA0KPiA+IDI4KSwNCj4gPiArICAgICAgIEdBVEVfVkRPMF8wKENMS19W
RE8wX0RJU1BfQ09MT1IwLCAidmRvMF9kaXNwX2NvbG9yMCIsDQo+ID4gInRvcF92cHAiLCAyOSks
DQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9NRFBfV1JPVDAsICJ2ZG8wX21kcF93
cm90MCIsDQo+ID4gInRvcF92cHAiLCAzMCksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtf
VkRPMF9ESVNQX1JTWjAsICJ2ZG8wX2Rpc3BfcnN6MCIsDQo+ID4gInRvcF92cHAiLCAzMSksDQo+
ID4gKyAgICAgICAvKiBWRE8wXzEgKi8NCj4gPiArICAgICAgIEdBVEVfVkRPMF8xKENMS19WRE8w
X0RJU1BfUE9TVE1BU0swLCAidmRvMF9kaXNwX3Bvc3RtYXNrMCIsDQo+ID4gInRvcF92cHAiLCAw
KSwNCj4gPiArICAgICAgIEdBVEVfVkRPMF8xKENMS19WRE8wX0ZBS0VfRU5HMSwgInZkbzBfZmFr
ZV9lbmcxIiwNCj4gPiAidG9wX3ZwcCIsIDEpLA0KPiA+ICsgICAgICAgR0FURV9WRE8wXzEoQ0xL
X1ZETzBfRExfQVNZTkMyLCAidmRvMF9kbF9hc3luYzIiLA0KPiA+ICJ0b3BfdnBwIiwgNSksDQo+
ID4gKyAgICAgICBHQVRFX1ZETzBfMShDTEtfVkRPMF9ETF9SRUxBWTMsICJ2ZG8wX2RsX3JlbGF5
MyIsDQo+ID4gInRvcF92cHAiLCA2KSwNCj4gPiArICAgICAgIEdBVEVfVkRPMF8xKENMS19WRE8w
X0RMX1JFTEFZNCwgInZkbzBfZGxfcmVsYXk0IiwNCj4gPiAidG9wX3ZwcCIsIDcpLA0KPiA+ICsg
ICAgICAgR0FURV9WRE8wXzEoQ0xLX1ZETzBfU01JX0dBTFMsICJ2ZG8wX3NtaV9nYWxzIiwgInRv
cF92cHAiLA0KPiA+IDEwKSwNCj4gPiArICAgICAgIEdBVEVfVkRPMF8xKENMS19WRE8wX1NNSV9D
T01NT04sICJ2ZG8wX3NtaV9jb21tb24iLA0KPiA+ICJ0b3BfdnBwIiwgMTEpLA0KPiA+ICsgICAg
ICAgR0FURV9WRE8wXzEoQ0xLX1ZETzBfU01JX0VNSSwgInZkbzBfc21pX2VtaSIsICJ0b3BfdnBw
IiwNCj4gPiAxMiksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMShDTEtfVkRPMF9TTUlfSU9NTVUs
ICJ2ZG8wX3NtaV9pb21tdSIsDQo+ID4gInRvcF92cHAiLCAxMyksDQo+ID4gKyAgICAgICBHQVRF
X1ZETzBfMShDTEtfVkRPMF9TTUlfTEFSQiwgInZkbzBfc21pX2xhcmIiLCAidG9wX3ZwcCIsDQo+
ID4gMTQpLA0KPiA+ICsgICAgICAgR0FURV9WRE8wXzEoQ0xLX1ZETzBfU01JX1JTSSwgInZkbzBf
c21pX3JzaSIsICJ0b3BfdnBwIiwNCj4gPiAxNSksDQo+ID4gKyAgICAgICAvKiBWRE8wXzIgKi8N
Cj4gPiArICAgICAgIEdBVEVfVkRPMF8yKENMS19WRE8wX0RTSTBfRFNJLCAidmRvMF9kc2kwX2Rz
aSIsDQo+ID4gInRvcF9kc2lfb2NjIiwgMCksDQo+ID4gKyAgICAgICBHQVRFX1ZETzBfMihDTEtf
VkRPMF9EU0kxX0RTSSwgInZkbzBfZHNpMV9kc2kiLA0KPiA+ICJ0b3BfZHNpX29jYyIsIDgpLA0K
PiA+ICsgICAgICAgR0FURV9WRE8wXzJfRkxBR1MoQ0xLX1ZETzBfRFBfSU5URjBfRFBfSU5URiwN
Cj4gPiAidmRvMF9kcF9pbnRmMF9kcF9pbnRmIiwNCj4gPiArICAgICAgICAgICAgICAgInRvcF9l
ZHAiLCAxNiwgQ0xLX1NFVF9SQVRFX1BBUkVOVCksDQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdGF0
aWMgaW50IGNsa19tdDgxODhfdmRvMF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQ0KPiA+ICt7DQo+ID4gKyAgICAgICBzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmcGRldi0+ZGV2Ow0K
PiA+ICsgICAgICAgc3RydWN0IGRldmljZV9ub2RlICpub2RlID0gZGV2LT5wYXJlbnQtPm9mX25v
ZGU7DQo+ID4gKyAgICAgICBzdHJ1Y3QgY2xrX2h3X29uZWNlbGxfZGF0YSAqY2xrX2RhdGE7DQo+
ID4gKyAgICAgICBpbnQgcjsNCj4gPiArDQo+ID4gKyAgICAgICBjbGtfZGF0YSA9IG10a19hbGxv
Y19jbGtfZGF0YShDTEtfVkRPMF9OUl9DTEspOw0KPiA+ICsgICAgICAgaWYgKCFjbGtfZGF0YSkN
Cj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIC1FTk9NRU07DQo+ID4gKw0KPiA+ICsgICAgICAg
ciA9IG10a19jbGtfcmVnaXN0ZXJfZ2F0ZXMobm9kZSwgdmRvMF9jbGtzLA0KPiA+IEFSUkFZX1NJ
WkUodmRvMF9jbGtzKSwgY2xrX2RhdGEpOw0KPiANCj4gVGhpcyBBUEkgd2FzIGNoYW5nZWQuIFBs
ZWFzZSByZWJhc2Ugb250byB0aGUgbGF0ZXN0IC1uZXh0IGFuZCB1cGRhdGUuDQoNClRoYW5rIHlv
dSBmb3IgeW91ciBzdWdnZXN0aW9ucy4NCk9LIEkgd2lsbCBtb2RpZnkgaXQgaW4gdjYuDQo+IA0K
PiBBbmdlbG8gKENDLWVkKSBhbHNvIG1lbnRpb25lZCBhIG5ldyBzaW1wbGUgcHJvYmUgdmFyaWFu
dCBmb3Igbm9uLURUDQo+IGNsb2NrIGRyaXZlcnMgaXMgYmVpbmcgZGV2ZWxvcGVkLiBIZSBkaWRu
J3QgbWVudGlvbiBhIHRpbWVsaW5lDQo+IHRob3VnaC4NCg0KDQpXaGVuIHRoZSBuZXcgc2ltcGxl
IHByb2JlIHZhcmlhbnQgaXMgcmVhZHksIEkgd2lsbCByZWJhc2UgbGF0ZXN0LW5leHQNCmFuZCB1
cGRhdGUgaXQuDQoNCg==
