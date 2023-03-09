Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1856B1AB1
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 06:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCIF0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 00:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCIF02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 00:26:28 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78BBD1AE9;
        Wed,  8 Mar 2023 21:26:25 -0800 (PST)
X-UUID: ec53cefebe3a11ed945fc101203acc17-20230309
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=J7+E7GrqhHwsLilX9LKS+fhRnFQ+m7HxfsG3KeyrkrM=;
        b=kF49tX8zbZo0wPPGch9w0P0uEteeRcqfoUPGca+RPW6hriOrCpJwxxBBCDZ7FNwpEaXUoF0M62sC3rzgGLZNSxUyUIdv+DGxubGWQnnIDuo95KG8BXQXnYr0BM1e3jY1AqIF334BgaR3yokq1efwLAZDT8fZgMm6XJms4mOknQo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:b642aedd-92c6-4bff-814f-c67c58469403,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.20,REQID:b642aedd-92c6-4bff-814f-c67c58469403,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:25b5999,CLOUDID:04abafb2-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:230309132621XET9GU59,BulkQuantity:0,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,O
        SA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: ec53cefebe3a11ed945fc101203acc17-20230309
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 816051289; Thu, 09 Mar 2023 13:26:20 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 9 Mar 2023 13:26:18 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 9 Mar 2023 13:26:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbctx0cgv0hYO0vSF8zWX/uYuYIw9g1D/mS9ODOOlkfAowGGEBz5PhEjszfCi20huYEXpaWj9Ug3N/mAXOT7EcPSepPLFs9xyMWLUnOO/Wi+m+oRSfsPW52aWotwBxh3HqUDOLRi9fpqse/srvVIPU5JfT9n+VhBYdyM9/oVY1xyAVHv1ZNR9u6YALUIcMh+ColCFFIkXLevTHwn/EfLSBd5SZ7g6ybNDWUMEiVzYAuvcDyEn5x5L+qbuXWyVKwnoAiFONYKeVW5e4DM8nlE4Z4Qv3XN6vwk0tkVP2WkWddsvg+0Qom5bBBW9lkDgSS3hjsQ2OWAR5JJDVjIvx+9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7+E7GrqhHwsLilX9LKS+fhRnFQ+m7HxfsG3KeyrkrM=;
 b=HQVaJRVgPl60FlFXljQqp7NyM8Jjlb/eW1jqKvQO1svTWjPNHu8FKEHCrZkYTU6KWTHl6cDd4VOR+NzFkO3bA62mMbsWGM/tJDf7Pkl/0K9k/OJqQ1ymS2xwl0SvW/wPSJb3iXYN/VmV2jUUrI9MBfSpQ0xKe52LQhL1QaA3yAyCFqlI9+Sb2ljrDAceQRQpxLyv8Eqr21j1I7vVTICv5X0POAK6yVtrBSTzIr5ZIiqhK5EO5G6ZNiteCL+e+fkzWAwRiwbWZU2bBQFEETVGxjc3aWo6Ymluaxc7T+2/wf3CMxw8avscaorNUt5k2ge42dyikN9yxi/lvjCciUiQtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7+E7GrqhHwsLilX9LKS+fhRnFQ+m7HxfsG3KeyrkrM=;
 b=lOGrWMaZUVSCpoEY0Hvy2NLc0cMspkAix9wvrBaZQeyiqF95FjIz3THA/UuFgi7iLys6M4wzeV/8t1n6lzJdBssq8hXprPCfRH7PTdJNdpkGUWn7JkfkEeTzJ05IxCUMhVuAFDIK7i+2Npcwuu0DQ4dIWoJ1eNGD4BfcaQGOhYM=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by TY0PR03MB6388.apcprd03.prod.outlook.com (2603:1096:400:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 05:26:15 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 05:26:15 +0000
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 11/19] clk: mediatek: Add MT8188 vdecsys clock support
Thread-Topic: [PATCH v5 11/19] clk: mediatek: Add MT8188 vdecsys clock support
Thread-Index: AQHZLAR2TKx4bgSvuEGu+SW4on0fcq685voAgDVQUIA=
Date:   Thu, 9 Mar 2023 05:26:15 +0000
Message-ID: <f11a414d229b7783aba2ce5aa36bed3f6604e712.camel@mediatek.com>
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
         <20230119124848.26364-12-Garmin.Chang@mediatek.com>
         <CAGXv+5HtzbrA5dpzXSoSXMFooHXoeX7iwJA9A1HJKQ09qm+Umw@mail.gmail.com>
In-Reply-To: <CAGXv+5HtzbrA5dpzXSoSXMFooHXoeX7iwJA9A1HJKQ09qm+Umw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|TY0PR03MB6388:EE_
x-ms-office365-filtering-correlation-id: 8de02c2f-49bc-4ae7-0687-08db205ecdb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eRYVNrDzVVfXYZm++Z+ybnWOPLdC0RwjiKtpE7mJRIPXHQjtrbS3GUdiLukZZxMtdrE88yga0zobuGpJfU8CZ+3pPYTTZI67oify0+w5RiwcpQkH9lWICjVdUISCR7dPMU4kSTUKQTnHZkW3/TpwQLK/Owxtu7LsCFpyLyMqr4zJXXvjf7VUkuFB7PTdO8F/V2/q6NC8zddG+CifHJmrqAUzEOQv4AAfMsf0CSaakDtLpboKdsn+yabtoIkhOZwEB1oyafheuXCL8R0p3VWiuXBnkxlTlh6lZhMwNAg6UIC6yMXIyFgYzrDybkVNT9qEJWDRGkrf+gv9CC4eUBpnkFqOrN5tSL3HLqHSqcVUTUWex/pVWb7yz77CSOFEbTWUJa63J5oSNJctQ2i61nuvHQE1Snr57V6PjJfACHS3mnZmPFVHEx9jTuwcTAYb+T6Dt1lJtzsQHFothSxKOO6xQmOeBQR9WjEcNsfwfB2g2uewklcz7H3WD39UAGh5SbQvgq9A9h+JD1ey/tE3HCVPgB9KEMjTvpc1c4YTV6oV139kGxYY+yWUSJq6z2ONqb6S5dv9pSwRwlAUx5U5MHpo4VmO33y7urD5JEJu9S2CkRdH37mAfCud450CPv9L1KbmlbutlnUj7T8GDAVTORssuQYThjaPh6+VHonkB2Bg2hOG2N5fLzzbOOcUWHE9e7yYDwgCl4PL5Dr+Bg6JqTffWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199018)(38070700005)(2906002)(7416002)(5660300002)(26005)(8936002)(36756003)(85182001)(66446008)(41300700001)(66556008)(66476007)(4326008)(66946007)(64756008)(76116006)(6916009)(316002)(91956017)(8676002)(86362001)(54906003)(71200400001)(478600001)(6486002)(38100700002)(122000001)(6506007)(6512007)(53546011)(186003)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cW9lcFlRYnR5T0wyTXRzN3oxclhhb1BqS3haREhCWmV2MkgvWFhEZXJpbmhM?=
 =?utf-8?B?RjJGaVpRNnI4UjBWcCtuN2tWUzNySnA3bExjU2ZXNlZxSTgxNU5uTE5Zb1Jv?=
 =?utf-8?B?bkI3N09wSHJsbHl1NFpKNjVEUy9pRzJHZDBDcnpoRFBhYW55YkxGam9WMUl5?=
 =?utf-8?B?L2Q3Nnh5di9URWtlb0FvQTNBUStFaElqVSs0bXlFY1NxcmFadWVOZnRPM3NF?=
 =?utf-8?B?blhlUmJMSUF2WTNITHkzY2luWXhnVzljL1RtOWk2ZE1xVXVrT2Q2ckoxWEZn?=
 =?utf-8?B?emorTW5jNGFBT21lRmpPcnZ0QkZ3R2pJZytzd09JR1ZqOUh4L3hkdjNsVXA0?=
 =?utf-8?B?dE9FUjFvTDhNUW1VaWtDTUExY0hRdjRoaTkvdHczRFkrSXp4MEE2NTN4REQw?=
 =?utf-8?B?RjBmeUVnQzA0Y2tCTDVLSnRWaElsdHBPaWtQa3Q1ZVpwL3VaemdRU3FvVVNK?=
 =?utf-8?B?Qy9haXlEOGFXSXA0RFNNSkhodHl5ZVRIM0JDWXFBbXUvYWpPNnZnM1c2STRM?=
 =?utf-8?B?QnVJOVlMc2xValp5bnBPbyt5emlsdmxOQ3ZxMWZGazYxa0EzSjd4ZS95TFBm?=
 =?utf-8?B?Nys0MVhOOG9kM1ZDemErYUZXeXJCYUs1WVg4OHRFOWM2QUxUOUM3dkI4Lzlj?=
 =?utf-8?B?TUM4b1E2VGJ4Zzk0ek44UUcyQ0Q3K0p2N1RxNnlmeTZPc3dTemVCMTgyOVRq?=
 =?utf-8?B?ZUxlK1ZRQjI4U2hGUmQ4djl0d1dEMGt6L0ZrckxCb2NneDdqZUpUK2NwT3pG?=
 =?utf-8?B?NDdTRjltbS9FYXU3b3RJb0o2cXRsbjJtNWx1RE84Y3oxMmZpeC9ieTUzRTha?=
 =?utf-8?B?ajlvVXdNU3Fqb0p5UVFBRWlNenBpbzBCNStHeFdWZmtzSzJSWkRLS2RUWGU3?=
 =?utf-8?B?dm9lRkxMYk5GRjVWR1A0cFUzaDFWK3FWQmVLU0hZK0hETDNGSEljM0hLUVM4?=
 =?utf-8?B?UG90bG15ZWdZQWthalBxZlBucDJOc3A3VUVDZ1N6Z0ZBQzBrcWhVN0hlUktl?=
 =?utf-8?B?MUNWYlB1eEhCMlgyZ0dXbnEzMVMxcnQrbUxOOVZkNmtJMHB2RVUrdFA4Sk1O?=
 =?utf-8?B?S3Evemo0anduVWZMbkJ3S2x1YzN3YmFaQTF3Snlkbm9odnVhMUN5QVVHMjFY?=
 =?utf-8?B?V25QNEFnNFJHOCswYmM2VTJXeFhOTkZEdGFXVlFGRDFjMEJaN0pXb3ZSNnJH?=
 =?utf-8?B?b2orR2dJaVBQUHZNaE4vaVkzSEU3WGtrcXpEUzRnekdKUFNPZnlrUkw3Smhu?=
 =?utf-8?B?YXdLakgxZk1YcDQwUTNhU010dkZKODcwRTRtYTRFalZleUdUMlYwWURpRUdD?=
 =?utf-8?B?U1ZBZm9FKzR6SkZ4RFZQUXk4RVREVVp1WjdXZDhNajhnbFVFTTRocUpBVC9k?=
 =?utf-8?B?Q3Rkd3NOTG40bGFHYlUzaG1zekY2OUExcUwyUk5mcit5d2JuQXVCQ1pvNGJR?=
 =?utf-8?B?VER6dkQyUjZmR0syTGxha0x0Nmw0RXBwVVdxMlMzS25oT3BqQVNOU1gvcmFK?=
 =?utf-8?B?SkdDNCtMSkhaeWFLemJZeG41RGZPN21BNnpkcWtFK05Ga1gxY2k2N1lHZkZI?=
 =?utf-8?B?UU9RUGhQVHY0a1NVakJ5aEJLbVpVMlBvRVc3SWpxRlN6QXViYkJSeXE1SGhE?=
 =?utf-8?B?Y0VnME50Y295NmJxZDZreE5vVWVBZU5YWnBvUnNWeENlVUxpbHZMS2lwcU1u?=
 =?utf-8?B?TlJZUlplK0hvdVRFdXBvMy9peWpqQ2RrZGtNQzNKSzBJcVZKQkJaaWhlcFRR?=
 =?utf-8?B?cFZScEhKSjg1bmJ2dGczNVVSTFV3anJaNnBlVUdzczN5WGJsaVQ5N3h3VDhZ?=
 =?utf-8?B?OGE5WmNNRzhsMG55TlE5VlZ1bDg1TDRFRG1aZmo5cS90TUdGcFFxemVUdlB3?=
 =?utf-8?B?M2NlRStvalJqL2w2eUNoc3JJUHVqYlFFdjU5eTZBUGQ5cmU3VVNmV2J3bWFO?=
 =?utf-8?B?cThhNlFOZWRKWFpHclFNejBQQlhGOUtDRktPbWV1VU5mQWRqUXFaNFF2VHMv?=
 =?utf-8?B?T3F5UE5iTDhINFhxODlSL1hvTWVkeWRuTHN4SlBQblUzS3cvQVAybENHMFQr?=
 =?utf-8?B?K0xyOFdiaUp1cEJNM0ZEUVMwRnNKNzUvT25yVEFiYmV4WnZmYmUrUk5NS1pC?=
 =?utf-8?B?R1FIU0E0bzkvRHpxdGZBK01lNnhrR25EU0s4S0VCUnFqc2dwUnZMTFI1NGRJ?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C10BA3CAC59C53449F24C32DB5D11440@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de02c2f-49bc-4ae7-0687-08db205ecdb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 05:26:15.2443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hJMGnW/bOzSP5xTec3IDyk1/6PLBopSH9SxLS40fiUzmNT/IiiBcRqNOH7Erm5mWwxjchln/C4EfIJ5nFgPN/HbJQeJkZ+SvyQw8AVLeHmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6388
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDE1OjE3ICswODAwLCBDaGVuLVl1IFRzYWkgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDE5LCAyMDIzIGF0IDg6NDkgUE0gR2FybWluLkNoYW5nIDwNCj4gR2FybWlu
LkNoYW5nQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIE1UODE4OCB2ZGVjIGNs
b2NrIGNvbnRyb2xsZXJzIHdoaWNoIHByb3ZpZGUgY2xvY2sgZ2F0ZQ0KPiA+IGNvbnRyb2wgZm9y
IHZpZGVvIGRlY29kZXIuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogR2FybWluLkNoYW5nIDxH
YXJtaW4uQ2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL2Nsay9tZWRp
YXRlay9NYWtlZmlsZSAgICAgICAgICB8ICAyICstDQo+ID4gIGRyaXZlcnMvY2xrL21lZGlhdGVr
L2Nsay1tdDgxODgtdmRlYy5jIHwgOTANCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKw0K
PiA+ICAyIGZpbGVzIGNoYW5nZWQsIDkxIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4g
PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtdmRl
Yy5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxl
DQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+IGluZGV4IGEwZmQ4N2E4
ODJiNS4uN2QwOWU5ZmM2NTM4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvY2xrL21lZGlhdGVr
L01ha2VmaWxlDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4gPiBA
QCAtODYsNyArODYsNyBAQCBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxODYpICs9IGNsay1t
dDgxODYtDQo+ID4gbWN1Lm8gY2xrLW10ODE4Ni10b3Bja2dlbi5vIGNsay1tdA0KPiA+ICBvYmot
JChDT05GSUdfQ09NTU9OX0NMS19NVDgxODgpICs9IGNsay1tdDgxODgtYXBtaXhlZHN5cy5vIGNs
ay0NCj4gPiBtdDgxODgtdG9wY2tnZW4ubyBcDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBjbGstbXQ4MTg4LXBlcmlfYW8ubyBjbGstbXQ4MTg4LQ0KPiA+IGluZnJhX2Fv
Lm8gXA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xrLW10ODE4OC1j
YW0ubyBjbGstbXQ4MTg4LQ0KPiA+IGNjdS5vIGNsay1tdDgxODgtaW1nLm8gXA0KPiA+IC0gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xrLW10ODE4OC1pcGUubyBjbGstbXQ4MTg4
LQ0KPiA+IG1mZy5vDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGst
bXQ4MTg4LWlwZS5vIGNsay1tdDgxODgtDQo+ID4gbWZnLm8gY2xrLW10ODE4OC12ZGVjLm8NCj4g
PiAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyKSArPSBjbGstbXQ4MTkyLm8NCj4gPiAg
b2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyX0FVRFNZUykgKz0gY2xrLW10ODE5Mi1hdWQu
bw0KPiA+ICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJfQ0FNU1lTKSArPSBjbGstbXQ4
MTkyLWNhbS5vDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgx
ODgtdmRlYy5jDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LXZkZWMuYw0K
PiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAwMDAwMDAwLi5lMDVhMjc5
NTcxMzYNCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsv
Y2xrLW10ODE4OC12ZGVjLmMNCj4gPiBAQCAtMCwwICsxLDkwIEBADQo+ID4gKy8vIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiArLy8NCj4gPiArLy8gQ29weXJpZ2h0
IChjKSAyMDIyIE1lZGlhVGVrIEluYy4NCj4gPiArLy8gQXV0aG9yOiBHYXJtaW4gQ2hhbmcgPGdh
cm1pbi5jaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvY2xr
LXByb3ZpZGVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCj4g
PiArI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1jbGsuaD4NCj4g
PiArDQo+ID4gKyNpbmNsdWRlICJjbGstZ2F0ZS5oIg0KPiA+ICsjaW5jbHVkZSAiY2xrLW10ay5o
Ig0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZV9yZWdzIHZkZTBfY2df
cmVncyA9IHsNCj4gDQo+IENvdWxkIHlvdSByZXBsYWNlIGFsbCBpbnN0YW5jZXMgb2YgInZkZSIg
KGJvdGggdXBwZXIgYW5kIGxvd2VyIGNhc2UpDQo+IHdpdGggInZkZWMiIHRvIGJlIGNvbnNpc3Rl
bnQgd2l0aCB1c2FnZXMgZWxzZXdoZXJlPw0KDQpUaGFuayB5b3UgZm9yIHlvdXIgc3VnZ2VzdGlv
bnMuDQpPSywgSSB3aWxsIG1vZGlmeSB0aGlzIHNlcmllcyBpbiB2Ni4NCj4gDQo+ID4gKyAgICAg
ICAuc2V0X29mcyA9IDB4MCwNCj4gPiArICAgICAgIC5jbHJfb2ZzID0gMHg0LA0KPiA+ICsgICAg
ICAgLnN0YV9vZnMgPSAweDAsDQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdGF0aWMgY29uc3Qgc3Ry
dWN0IG10a19nYXRlX3JlZ3MgdmRlMV9jZ19yZWdzID0gew0KPiA+ICsgICAgICAgLnNldF9vZnMg
PSAweDIwMCwNCj4gPiArICAgICAgIC5jbHJfb2ZzID0gMHgyMDQsDQo+ID4gKyAgICAgICAuc3Rh
X29mcyA9IDB4MjAwLA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBt
dGtfZ2F0ZV9yZWdzIHZkZTJfY2dfcmVncyA9IHsNCj4gPiArICAgICAgIC5zZXRfb2ZzID0gMHg4
LA0KPiA+ICsgICAgICAgLmNscl9vZnMgPSAweGMsDQo+ID4gKyAgICAgICAuc3RhX29mcyA9IDB4
OCwNCj4gPiArfTsNCj4gPiArDQo+ID4gKyNkZWZpbmUgR0FURV9WREUwKF9pZCwgX25hbWUsIF9w
YXJlbnQsIF9zaGlmdCkgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICAgIEdBVEVfTVRLKF9p
ZCwgX25hbWUsIF9wYXJlbnQsICZ2ZGUwX2NnX3JlZ3MsIF9zaGlmdCwNCj4gPiAmbXRrX2Nsa19n
YXRlX29wc19zZXRjbHJfaW52KQ0KPiA+ICsNCj4gPiArI2RlZmluZSBHQVRFX1ZERTEoX2lkLCBf
bmFtZSwgX3BhcmVudCwgX3NoaWZ0KSAgICAgICAgICAgICAgICAgXA0KPiA+ICsgICAgICAgR0FU
RV9NVEsoX2lkLCBfbmFtZSwgX3BhcmVudCwgJnZkZTFfY2dfcmVncywgX3NoaWZ0LA0KPiA+ICZt
dGtfY2xrX2dhdGVfb3BzX3NldGNscl9pbnYpDQo+ID4gKw0KPiA+ICsjZGVmaW5lIEdBVEVfVkRF
MihfaWQsIF9uYW1lLCBfcGFyZW50LCBfc2hpZnQpICAgICAgICAgICAgICAgICBcDQo+ID4gKyAg
ICAgICBHQVRFX01USyhfaWQsIF9uYW1lLCBfcGFyZW50LCAmdmRlMl9jZ19yZWdzLCBfc2hpZnQs
DQo+ID4gJm10a19jbGtfZ2F0ZV9vcHNfc2V0Y2xyX2ludikNCj4gPiArDQo+ID4gK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgbXRrX2dhdGUgdmRlMV9jbGtzW10gPSB7DQo+ID4gKyAgICAgICAvKiBWREUx
XzAgKi8NCj4gPiArICAgICAgIEdBVEVfVkRFMChDTEtfVkRFMV9TT0NfVkRFQywgInZkZTFfc29j
X3ZkZWMiLCAidG9wX3ZkZWMiLA0KPiA+IDApLA0KPiA+ICsgICAgICAgR0FURV9WREUwKENMS19W
REUxX1NPQ19WREVDX0FDVElWRSwgInZkZTFfc29jX3ZkZWNfYWN0aXZlIiwNCj4gPiAidG9wX3Zk
ZWMiLCA0KSwNCj4gPiArICAgICAgIEdBVEVfVkRFMChDTEtfVkRFMV9TT0NfVkRFQ19FTkcsICJ2
ZGUxX3NvY192ZGVjX2VuZyIsDQo+ID4gInRvcF92ZGVjIiwgOCksDQo+ID4gKyAgICAgICAvKiBW
REUxXzEgKi8NCj4gPiArICAgICAgIEdBVEVfVkRFMShDTEtfVkRFMV9TT0NfTEFULCAidmRlMV9z
b2NfbGF0IiwgInRvcF92ZGVjIiwgMCksDQo+ID4gKyAgICAgICBHQVRFX1ZERTEoQ0xLX1ZERTFf
U09DX0xBVF9BQ1RJVkUsICJ2ZGUxX3NvY19sYXRfYWN0aXZlIiwNCj4gPiAidG9wX3ZkZWMiLCA0
KSwNCj4gPiArICAgICAgIEdBVEVfVkRFMShDTEtfVkRFMV9TT0NfTEFUX0VORywgInZkZTFfc29j
X2xhdF9lbmciLA0KPiA+ICJ0b3BfdmRlYyIsIDgpLA0KPiA+ICsgICAgICAgLyogVkRFMTIgKi8N
Cj4gDQo+IEFkZCBhbiB1bmRlcnNjb3JlIGxpa2UgdGhlIGFib3ZlPw0KPiANCj4gQ2hlbll1DQpP
SywgSSB3aWxsIGFkZCB1bmRlcnNjb3JlIGluIHY2Lg0KPiANCj4gPiArICAgICAgIEdBVEVfVkRF
MihDTEtfVkRFMV9TT0NfTEFSQjEsICJ2ZGUxX3NvY19sYXJiMSIsICJ0b3BfdmRlYyIsDQo+ID4g
MCksDQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdGF0aWMgY29uc3Qgc3RydWN0IG10a19nYXRlIHZk
ZTJfY2xrc1tdID0gew0KPiA+ICsgICAgICAgLyogVkRFMl8wICovDQo+ID4gKyAgICAgICBHQVRF
X1ZERTAoQ0xLX1ZERTJfVkRFQywgInZkZTJfdmRlYyIsICJ0b3BfdmRlYyIsIDApLA0KPiA+ICsg
ICAgICAgR0FURV9WREUwKENMS19WREUyX1ZERUNfQUNUSVZFLCAidmRlMl92ZGVjX2FjdGl2ZSIs
DQo+ID4gInRvcF92ZGVjIiwgNCksDQo+ID4gKyAgICAgICBHQVRFX1ZERTAoQ0xLX1ZERTJfVkRF
Q19FTkcsICJ2ZGUyX3ZkZWNfZW5nIiwgInRvcF92ZGVjIiwNCj4gPiA4KSwNCj4gPiArICAgICAg
IC8qIFZERTJfMSAqLw0KPiA+ICsgICAgICAgR0FURV9WREUxKENMS19WREUyX0xBVCwgInZkZTJf
bGF0IiwgInRvcF92ZGVjIiwgMCksDQo+ID4gKyAgICAgICAvKiBWREUyXzIgKi8NCj4gPiArICAg
ICAgIEdBVEVfVkRFMihDTEtfVkRFMl9MQVJCMSwgInZkZTJfbGFyYjEiLCAidG9wX3ZkZWMiLCAw
KSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2Nsa19kZXNj
IHZkZTFfZGVzYyA9IHsNCj4gPiArICAgICAgIC5jbGtzID0gdmRlMV9jbGtzLA0KPiA+ICsgICAg
ICAgLm51bV9jbGtzID0gQVJSQVlfU0laRSh2ZGUxX2Nsa3MpLA0KPiA+ICt9Ow0KPiA+ICsNCj4g
PiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfY2xrX2Rlc2MgdmRlMl9kZXNjID0gew0KPiA+ICsg
ICAgICAgLmNsa3MgPSB2ZGUyX2Nsa3MsDQo+ID4gKyAgICAgICAubnVtX2Nsa3MgPSBBUlJBWV9T
SVpFKHZkZTJfY2xrcyksDQo+ID4gK307DQo+ID4gKw0KPiA+ICtzdGF0aWMgY29uc3Qgc3RydWN0
IG9mX2RldmljZV9pZCBvZl9tYXRjaF9jbGtfbXQ4MTg4X3ZkZVtdID0gew0KPiA+ICsgICAgICAg
eyAuY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDgxODgtdmRlY3N5cy1zb2MiLCAuZGF0YSA9DQo+
ID4gJnZkZTFfZGVzYyB9LA0KPiA+ICsgICAgICAgeyAuY29tcGF0aWJsZSA9ICJtZWRpYXRlayxt
dDgxODgtdmRlY3N5cyIsIC5kYXRhID0NCj4gPiAmdmRlMl9kZXNjIH0sDQo+ID4gKyAgICAgICB7
IC8qIHNlbnRpbmVsICovIH0NCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgcGxh
dGZvcm1fZHJpdmVyIGNsa19tdDgxODhfdmRlX2RydiA9IHsNCj4gPiArICAgICAgIC5wcm9iZSA9
IG10a19jbGtfc2ltcGxlX3Byb2JlLA0KPiA+ICsgICAgICAgLnJlbW92ZSA9IG10a19jbGtfc2lt
cGxlX3JlbW92ZSwNCj4gPiArICAgICAgIC5kcml2ZXIgPSB7DQo+ID4gKyAgICAgICAgICAgICAg
IC5uYW1lID0gImNsay1tdDgxODgtdmRlIiwNCj4gPiArICAgICAgICAgICAgICAgLm9mX21hdGNo
X3RhYmxlID0gb2ZfbWF0Y2hfY2xrX210ODE4OF92ZGUsDQo+ID4gKyAgICAgICB9LA0KPiA+ICt9
Ow0KPiA+ICsNCj4gPiArYnVpbHRpbl9wbGF0Zm9ybV9kcml2ZXIoY2xrX210ODE4OF92ZGVfZHJ2
KTsNCj4gPiArTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOw0KPiA+IC0tDQo+ID4gMi4xOC4wDQo+ID4g
DQo+ID4gDQo=
