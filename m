Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBD56653FE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 06:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjAKFtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 00:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjAKFt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 00:49:29 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13FE6331;
        Tue, 10 Jan 2023 21:49:26 -0800 (PST)
X-UUID: b2372f0c917311ed945fc101203acc17-20230111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=43vxydyA90OwGLtNSOMfju96YsCwPz5dX97MogcRRtY=;
        b=BhAgAV5IYzVYvJJxJ8A6sv+foanIh7bs2K+UFr9VAnaJzFWxr3+GzdRMntfQR9pu2jleKoDo28Mqd7TwcoEHAbkAi6kV0nLwrOXTVjnFvS+dfsc4omrLVNMHnyPMI8410DRzPlC2qm8UbASJBy4fc7I4dDmVd4PPkgDXUFPB4fo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.17,REQID:7013c2e4-a912-4abe-81e2-36125f632d8b,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.17,REQID:7013c2e4-a912-4abe-81e2-36125f632d8b,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:543e81c,CLOUDID:21a379f5-ff42-4fb0-b929-626456a83c14,B
        ulkID:2301111349227CL70PNJ,BulkQuantity:0,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0
X-CID-APTURL: Status:success,Category:nil,Trust:0,Unknown:0,Malicious:0
X-CID-BVR: 0,NGT
X-UUID: b2372f0c917311ed945fc101203acc17-20230111
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 724050372; Wed, 11 Jan 2023 13:49:21 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 11 Jan 2023 13:49:20 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 11 Jan 2023 13:49:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfcYLPMfKVNWaPutUqh1q993p8S8b5ULjv496rowyHGRA+SThqC6Zxz23ML069abYK2B982+sz87hxy8rxzCxqf2RvugBrGUQnbRZHQzbWo3oBGehmCvywajRPs3nxdARda9HqEyEJqNjigZamqI0W9rXbHjPki2ZjE7zM4tfZLCn04skC8zl9fd3ZiE2mtPrdXccF07Pig8ZADkZVwSkAZjwcqu1uDkSNSZD0webwD1XKxRkN0/dQytgYGZCaW43CO36enevVpRe+DfshZUCItGuQxCWX1Twm7IP3vFctrj9QNgTUva4+m0szj18rsBnzjFlci6UrvQnFyiYlhldQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43vxydyA90OwGLtNSOMfju96YsCwPz5dX97MogcRRtY=;
 b=Ajbfmedey8d7hOXc3YYIwXAsoj+TJSlBxApSmLGjLhv1r8IPAQAiiEvQHlP8HXcI0etHY9t+2+FJZiKTku/F+2AaGZBT9NQB3IXyAL0YiR0zDOALhuZHFzKUT1sesArkY5dlMunwAsaddkckwg4g8mlOirZcZTmXmYtG5CMDX0WCCgfzDo6cLdGOh7arCSlnXjhzIVY66R7wCVVyVW80fM6eDZqPjPN5UrybygGbhHXLYlwwGxiqK202RUI/F4J5cBflsb6vZTLnv3n3poURjnxfVkOYdZqRq/ObpsSFx7js+z4zuPDD2TsRGGit5PTIxHvZ96ReKXwn0TpBe95BNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43vxydyA90OwGLtNSOMfju96YsCwPz5dX97MogcRRtY=;
 b=jFW0DvnaOMek5gdhmabxjOteOmKQq0pgwuqOqpK4+vRZt0rHD0Rz0JEDTbl9WShxSQqrKMOoyXM0zx8a5jaGYP7FqbQ1/nJqA4YxYrmmF+Tn8q7oXeKvtSDba8P8+z/2zP6x8BfE43TpOZDe0Z+b95nE87X3EJmok4HdKA1s/Us=
Received: from PS2PR03MB3877.apcprd03.prod.outlook.com (2603:1096:300:39::13)
 by KL1PR03MB7221.apcprd03.prod.outlook.com (2603:1096:820:cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 05:49:18 +0000
Received: from PS2PR03MB3877.apcprd03.prod.outlook.com
 ([fe80::6937:eb54:1588:eb56]) by PS2PR03MB3877.apcprd03.prod.outlook.com
 ([fe80::6937:eb54:1588:eb56%6]) with mapi id 15.20.6002.012; Wed, 11 Jan 2023
 05:49:17 +0000
From:   =?utf-8?B?QmlhbyBIdWFuZyAo6buE5b2qKQ==?= <Biao.Huang@mediatek.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        =?utf-8?B?TWFjcGF1bCBMaW4gKOael+aZuuaWjCk=?= 
        <Macpaul.Lin@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v8 0/2] arm64: dts: mt8195: Add Ethernet controller
Thread-Topic: [PATCH v8 0/2] arm64: dts: mt8195: Add Ethernet controller
Thread-Index: AQHZIKIP86nJW3vHYE+C6tjef7gOOq6Q1eGAgAfpvAA=
Date:   Wed, 11 Jan 2023 05:49:17 +0000
Message-ID: <0b78c57e53ffafd14c16eaef6e779956bc638ac2.camel@mediatek.com>
References: <20230105010712.10116-1-biao.huang@mediatek.com>
         <20230105205853.7d86342b@kernel.org>
In-Reply-To: <20230105205853.7d86342b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PS2PR03MB3877:EE_|KL1PR03MB7221:EE_
x-ms-office365-filtering-correlation-id: c28dbae5-ac8a-42bd-ce18-08daf397943c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gXzZF13KP2eJCnnIorjxTb61KE2bejt19rn0FOQKm+t1iqdlybzBy6SlOcKm9bdJBhYNQPw9DHLdm62ER/R8diHz13pDO4q+1j0VAVT2AqdKvgjg2+a3X3bBw4/694ZW65uaabpD9SLqRNsj6YqeOnGmD8dViAuClGo/6cadztJhJXJaiHjnhpSg+Zl3wHkuS6pHGimEFR5uKKFz7RkiT+Vn3J5tV1WoAHbc6T9tPZa5aFV/zp76L9ZFWKMd4/InirksszyzzUI1Uj6OOOlGB1KbgpFvOe47EseydqmIdxjE1QNScLnc4dauLWd2ksRQkc6yvbQwIyOaBu9PxJhDqyPRHgbHwukRn4mUEOdIQb2pHgkdAG+aEZZAg561O77hbfGyShByH7VXWrWdSErANuKTS/qRctk3K/MbQtgbs42XgYNP8bS5t6EoyGdNMNF8OBpEftbYFbOqzPab7SUrJdWXo4Nlm9u5UkDPpe/iUFNOF9cq17+1SxTXrgvmZ4r2F+qonCoIaSB92pE/OGgnOny6XvnWSxFq1uMCskPPglvv6TjwKcgoNnmB2xSSpyXxmEIkhvtLUlpCT2koX1Xx7YXuzZUI7DsE9UFjBDkx3KcqWDHlDGHIu/mCohOfnSEpI1INq2dyv1Qqlt3y4/AulC8Wq7zKdO7C49CY2qrgRUk4V1reiTz45hI7auAP61rGbwwkcJGsFJKqPrGVkgWRIlC6LUMBogFCNPBqoOv+Ox0F6jmouORFlIAKWGvlCc/6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PS2PR03MB3877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(83380400001)(122000001)(4744005)(2906002)(41300700001)(8936002)(7416002)(5660300002)(186003)(478600001)(38100700002)(8676002)(6506007)(6486002)(2616005)(66476007)(6512007)(4326008)(316002)(64756008)(26005)(66446008)(71200400001)(54906003)(66946007)(91956017)(110136005)(66556008)(76116006)(38070700005)(86362001)(36756003)(85182001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGYyakxPREZVZVFrRWxCTWxvcVltWng3RUlSYzFqYy9UeFhJcndaOFMyRFov?=
 =?utf-8?B?b0YvbERMSHptODNwNUVmcGRVZGJ5VFZ0YjNTc296WUhuNUNNcG5qbUdlTnlq?=
 =?utf-8?B?VFdNZVowSnFOOC9UVWc5RlNWdXJmODNucG5vMk81VDVlRVNWK0ZIdGlkRy8x?=
 =?utf-8?B?Vkk3YkJIM1Y2YkU4S3hwaTFXN1VJUHFnaVVDTTJaWVRBRHkyOEY2MDAxRERW?=
 =?utf-8?B?bHY4TlVFNUY0bXUxRzBFelZEalg5ektRcytKbW51dk51dGQ4dFBYNzRYZTVE?=
 =?utf-8?B?bXlMZkgrd29MOE9rQVF1L2M0aHcva2pWN1ZKMGtUaGw4bzNYbVhPVExLd1Bn?=
 =?utf-8?B?VWVxcmhXWG5Sb3ZZZVl3cTNMUUwzdXoxZGtuQ3ZHL0NqWkVoVHA0SUp0VDcz?=
 =?utf-8?B?b3R1bTJKUGNtOWJUQkN2WDU1cExxVXZLbXRJdmhUYzR3bVoyZVFQQW9LVEFS?=
 =?utf-8?B?WGl0SlgvRWliMHdjbHZwYnJnM0VFVFI3SVE5cTJZMTV6M21WUjlwSWg4SDBR?=
 =?utf-8?B?OEZsUFFwRk5Bc205R2xZaktuMk9FUi9UVStNOE5TUjk0cmYzMjJnQlpOOERB?=
 =?utf-8?B?R0YwZXN1TDRPcnFLQktGV1U0bVNJcXphb2FBM1puRk5GQXFqMndyK0VFcFM2?=
 =?utf-8?B?NDIyMGpaZGVKUjZ3SXRTKzJtU1dESHJxa21wWGVHMlg1T0swZVlvNEd0VXEw?=
 =?utf-8?B?dElXYzJidlVzY0xqQkNSck9tWHE1MzdhekxWME50ckRDeWhhVXRFc2QvZi9s?=
 =?utf-8?B?QWMxUlowLzlLQW1ORmUyRkZCaUp5RWJWb0IxSlRyUEhoZ3BBL1lpZUxZYUo4?=
 =?utf-8?B?eTl0aTB3Nk8yY01IWDFOZTZuMzhnZ1RuSmJUZUQzR0sxNXB0VjZVOUVSWXln?=
 =?utf-8?B?R0hRbVdNUWc1SlphbENZanF1ZG1UdEowWWE1ZGt3czIxMG1vNmpQQk5mN09q?=
 =?utf-8?B?L1c0NHVPTytNbmRETTJFaEZjOC9OYmRucHlLbWIrTE55QUs5Tkd0K2hUaDJG?=
 =?utf-8?B?dXdBenhCZkhKNDdwUGZDeFI2MFl0NlRrbkZaQlRvc0RPR01uY21jWi9CSEox?=
 =?utf-8?B?WWliRm14OTY1dEE2czEwSXU0ZXVuTHhKbmdxcXF5WkxJTER5bndKbkdGanEz?=
 =?utf-8?B?bWdpMVZIMGtvYzFhR3NuMWhVd3pzaFl4aHI1MS9YR2lhT2ZnZEo4RnNmNlNq?=
 =?utf-8?B?MjZzdHNqZlJ6dzN1azc4QmN5WEJDZW56eUtWNmJmSzZYcWFvRGJUeWtiVkI5?=
 =?utf-8?B?SVpzbGZxRlovZUczamFpWGREUEw0WTVIeHZmb1l0azlyNzQwb2FiMWp0QWhr?=
 =?utf-8?B?QmpnWm1HQUx0eHhLOTZTV3Nob0VoMkdoZVNPN25PeGxUQVpGdW43V0I2NWdl?=
 =?utf-8?B?UnhYZ2d4bE1ETW45YWRLM2MwV1VwVWxjcmFLVWcyTWgxUTZwTVkzM1ZqZTNn?=
 =?utf-8?B?d2ErVGZTc2FRTXRzSUNVNGtZUlV1dytpWW1wL1F5VHloUDNIUW9QZFI1SStQ?=
 =?utf-8?B?SEhuU1VDVFRocFJtUitUY1ljR0NQOHpvMzdtMnVCU3NWVTNXSXdIaGZteDZO?=
 =?utf-8?B?RVZsMVB6bWJSTHJyMDZrOUJMdWJHblVzS0N4cGtzUGtSTmU3Uk5RTzM3RDVv?=
 =?utf-8?B?WHNROGZ6N2p4aDhwcXFNSUd4SW1VM3JvejNqREIwVzQ1L1llV0ptUmdFWjJE?=
 =?utf-8?B?a08xWnp4K25BOTcrUkVORmdJYmdRV043N1hVbVRBdkpFMjdGdkwzYW9TQUxO?=
 =?utf-8?B?UWZsRGovcmdId2wwanduNUp4MCtMb08zRXZyYW9FdE9NWE1vUUZ4TGdFMmFX?=
 =?utf-8?B?Lys0WEs1YURzcmUrVHQ5ZjFVTmMvS2E2dlFmZ1pYQUZJZmlFRjNFR3hhcWF4?=
 =?utf-8?B?aDlkSHlWbGZrZEpTOWNRQ1BwVXRkTFFVYW5xZU5WNzQvTTQ1SEZ5bUlNN3JR?=
 =?utf-8?B?THAxMG9RQ0RjR0tFbVVISzYwN0E0cm5zN0JvcGpOSkdPcXFqTFpaNnluR1Jk?=
 =?utf-8?B?MGMxRS9CVkRNWkpwRnVGYnFlcGhEemZ1NVdUdEE2QWFOdzYzdHRQNVBOTytn?=
 =?utf-8?B?a1BpeTlnVTBjZmtLTEZDRHZQUUJTUlFMQ1RSTlBPcFQ5M3U4OTlIbkg1RVhH?=
 =?utf-8?B?QmlyUm0rMDY1WXJ3bGtqeVNnS0pnc3piVG1FYmRYanFqR1VuUjRnYm93UTlz?=
 =?utf-8?B?VlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3B5FDDDFE177D45B20110E0BBC08B35@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PS2PR03MB3877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28dbae5-ac8a-42bd-ce18-08daf397943c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 05:49:17.8345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RNWd6pTGdIvXJ4VcvnDTvhDYrpHVbUEisuEpmELrnpk5JpI9vIb5wHhW/DnKoZUpCF20nsaQNwEqKW4VPjq24w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7221
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIzLTAxLTA1IGF0IDIwOjU4IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA1IEphbiAyMDIzIDA5OjA3OjEwICswODAwIEJpYW8gSHVhbmcgd3JvdGU6DQo+
ID4gQ2hhbmdlcyBpbiB2ODoNCj4gPiAxLiBhZGQgcmV2aWV3ZWQtYnkgYXMgQW5kcmV3J3MgY29t
bWVudHMuDQo+IA0KPiBZb3UgZG9uJ3QgaGF2ZSB0byByZXBvc3QganVzdCB0byBpbmNsdWRlIHJl
dmlldy9hY2sgdGFncy4NCj4gVGhleSBhcmUgYXV0b21hdGljYWxseSBnYXRoZXJlZCBieSBvdXIg
cGF0Y2ggYXBwbGljYXRpb24gdG9vbGluZw0KPiB3aGVuIHdlIGFwcGx5IHBhdGNoZXMgdG8gdGhl
IHRyZWUuDQpPSywgdGhhbmtzIGZvciB5b3VyIGtpbmRseSByZW1pbmRlcn4NCj4gDQo+IEkgd2ls
bCB0YWtlIHBhdGNoIDEgdG8gdGhlIG5ldHdvcmtpbmcgdHJlZSwgSSBfdGhpbmtfIHBhdGNoIDIg
aXMNCj4gc3VwcG9zZWQgdG8gZ28gdmlhIE1hdHRoaWFzPw0KT0ssIEBNYXR0aGlhcywgcGxlYXNl
IGtpbmRseSByZXZpZXcgcGF0Y2ggMiAoZHRzIHBhdGNoKS4NCg0KQmVzdCBSZWdhcmRzIQ0KQmlh
bw0K
