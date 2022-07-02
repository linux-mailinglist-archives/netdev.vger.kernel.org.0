Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735215640D8
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 16:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiGBOuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 10:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiGBOup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 10:50:45 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF87DBC0B;
        Sat,  2 Jul 2022 07:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656773441; x=1688309441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xGaEss6DeaQDTeGHuNyRcMQyMwadcPhzgnPEpaGSAfg=;
  b=tLR/OT8fCLjd4D3fHRGWyox6R7GiWAQpG75XHDQHGhaUSRA1vRL23QnS
   qs7kvud18CZkkB7aYQDAmqsCPp5IxNTbSk+yuohRwlWgzfhBSm59YPsZJ
   v4+bDQ1VvtN8H9uyslRi97I9kp2iPHSJjPDslCaqfJeLFBNFe5cvge2y0
   7Ygt2QswKvt5aImune8fXMN+7jxKKTpxIHQSc4ry0nnaqKIDSybsj3qbt
   aFqc6qU2pJpHpVEuYS7guLqLVVT/wCmDHOCVssgG0ZK+L9EzcsS8bSjcD
   nnWqq0sc4OK6Gwu3wcCTHDyaQ8Fj1wN7x6pGJ4u/xiy8qN8XG/g13MHfy
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,240,1650956400"; 
   d="scan'208";a="170799568"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2022 07:50:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 2 Jul 2022 07:50:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Sat, 2 Jul 2022 07:50:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQPxuCdProGbXCJ5NeTVVtNgSvlZFFcy3jOWMsNQMugAgCAJahX+hHRptU0+P3Fd8GKB8strV9dyS03sP8RHuk8nWDDd0Pd5Y1F9jo6KFx+aGdB2qPLLhqcsA1HF+giZzKwT3SSifFTxLeL54QE4KK3at+36HXPFLKNNZkRi+U/Cadr0bap/mewTe8X5av87cD+PZvHbtP4mVCni+6Jkg8h30qvD+70xXDqwBAF6irZ/g9MneCzE0gwD0wxRm62yzf0tZ6TyopC9dlN0Fwl7NfyMgeV5TmuUWChE6YHIlaPz+0xvxj1u3y8xf/+/mp/Be2fEbIzxf0BkTi8+aAPwyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xGaEss6DeaQDTeGHuNyRcMQyMwadcPhzgnPEpaGSAfg=;
 b=WDpHeDti1Uu0uXUePlcDmOF4tuhNgmGZ5wE2RzLWzKI6d0zQistVYWg0CO3MgKdSLrQkNjsLevX/TTSQzwSNQvv6PT+Y+QWshnYLDbD14dj50lZ8Q7PJSUJA6iXIVjg15JJh9TxAzDerc6KRGKUyfQ74ZjzB+LcMLT7sc8u6ztjo+hGdNKH9N3xxHDwwQeiOgu4aTrdDrwi/ew5LRUGFa79WiheppZO3zdb6U5mUjxqfbxSu7ZVNJnC8LGibf1n5tdPffBL0YQ3iq9P72Fnq1P1O6WqHCOLiFQTtqaCUt5d3Hjfmm23j1/pPwIvsZG/kKF4lnKrN9hfSWdXG+cThlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xGaEss6DeaQDTeGHuNyRcMQyMwadcPhzgnPEpaGSAfg=;
 b=PNJUwQGZZcr+tWVj2Pe+FpOvxDfCKoG/kIYvUrSQPaKSrXuu2mgeY4R99XS1BFp9e+ThZ+UImlWjtU6pYRW+EwVxN0/+Kpc+c8ol8vCtqeCRw6cHRfgo8k6bddc9/fAmSk17US3knMAd4C1CNowGyTGmERt6ZuHzjddDLOohiGo=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by DM8PR11MB5575.namprd11.prod.outlook.com (2603:10b6:8:38::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Sat, 2 Jul
 2022 14:50:35 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5395.018; Sat, 2 Jul 2022
 14:50:35 +0000
From:   <Conor.Dooley@microchip.com>
To:     <mturquette@baylibre.com>, <sboyd@kernel.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <palmer@dabbelt.com>,
        <Nicolas.Ferre@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <p.zabel@pengutronix.de>, <Daire.McNamara@microchip.com>
CC:     <paul.walmsley@sifive.com>, <aou@eecs.berkeley.edu>,
        <linux-clk@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v1 13/14] clk: microchip: mpfs: convert cfg_clk to
 clk_divider
Thread-Topic: [PATCH v1 13/14] clk: microchip: mpfs: convert cfg_clk to
 clk_divider
Thread-Index: AQHYjFiyIkQOJ8CbOkiGHeJXuBuJXa1rLXqA
Date:   Sat, 2 Jul 2022 14:50:35 +0000
Message-ID: <6dddf781-c912-e14f-9236-4a8e6ab45d3b@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
 <20220630080532.323731-14-conor.dooley@microchip.com>
In-Reply-To: <20220630080532.323731-14-conor.dooley@microchip.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e968e65b-42c7-4436-ea19-08da5c3a38b6
x-ms-traffictypediagnostic: DM8PR11MB5575:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gOYI3xr4i+3ltd9BcYb0imfse/59a1X/yBQV1unk8VS43fQkBYamBWGL5l7xPqnDMRcykGpFWZ3y0xLKPATsay77ySSzgGHUC1Dx4ClqDIv/2jw0FQj+ReoEE3j9VhDmFZXccgTxidcUmwXheDKOYghtcbegYJMQLC86rIR95+XaS9VF3X2VatDyuoUrDYafE2brkWgdO9pn8vjCTTBf4e5/QxClvjULDUmGGxqUwqbZVlsiCGx3rD7HWay9VmE4YX9W/KRJfVNH0L04GOJUYjzs/mFde/TLF/ZNllzcmimxJu8rtL/E0kHT6ubyyxCdEMONyZFEgz2KXGWhNBlRpQoMo0q/ClOjezckWdpWWvD4jIgoRyxGMoZANJB6hSFz9ihEZ1HWiRVmWad+ipcwlgXQ6iQQO4Fd8695HL5bo/qBq0jQtYADqAMrlK40MjJodJyuE+wznFxKZU+t8Knzc2RAEuZeXOJnfCagD8/SCjOQD0yK3GXIld2JsgXXOV5xLGLxDxSfF3m1fel07wNXUL7C/hYjMxQcRGaVJ+SZgdohNOfJSlblKFxEpyYev8dg688TbzQ+jwP1Tp8gQf+7HvXEUTdTc+JCsInHp7cgaWMByrff62z0Y8XgYYey7REMyKnytwHK8oIekwa3ILr+mLfV/h/XIcTwR5V+mr+6PNnZB3dfMIINucdjRV4jwj7tv8ne4kbWj4HF1MGXmu0obc5L6VVbCCZ9vfEMmfjR7rar0S3fwZ+2K7jK1ERububWG4HVWkCkJJuHnvfJ0LsNNsxwy885D+EnGV4RQGAiv29wMDUexGMgfv13MiWsslZ5JaQT5t/YPfkUO08Vriguv/iu9BnssPOHh/FQx89bp2mf34vb4sJdJcOdjY71ngZdu3zcbFoD23PCFUJcY/XGs7b/ys9nFxPddtIlqadNffM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(366004)(396003)(39860400002)(86362001)(31696002)(921005)(38070700005)(122000001)(38100700002)(8936002)(6486002)(966005)(478600001)(5660300002)(2906002)(41300700001)(7416002)(316002)(6636002)(54906003)(110136005)(71200400001)(4326008)(8676002)(91956017)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(186003)(83380400001)(26005)(6506007)(53546011)(2616005)(6512007)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkJVd0tDeDVRUGR2SUNSdVZnU2kraERLbFZVRHlIbFM5QjFXVGNQYkl0cGtX?=
 =?utf-8?B?YnFHdjNYTXcvSVBWbnU1STBRQ2RFeVE0TE0wQUFac0YxbHlOQlg1TE9wUmVF?=
 =?utf-8?B?TDkrMTZNamxUSjVsUmp6QmRzT1N6NUdDYStjeEdkMmpSVTJtVDUvOEJnTjYy?=
 =?utf-8?B?NXNjUEtYSExLejVzcldPUlhBMW01Y29xay80elVqM3VEeEdLUTExVE5RUFVQ?=
 =?utf-8?B?akhnZlhQVGFqU1hZT1RLYVEvaDY1VkhabVBPei84b2pqNndMaGZWU2xGajhS?=
 =?utf-8?B?ZjdxK0N5c3ZjdG1WWTBETjl0UmMxV0VqN3ZwRmMvUjg5ZWlSMXRZZ3ZOVndi?=
 =?utf-8?B?YVpUOGZ0VlZnbDA3dVdIMFR1eisrTldBWFdBbFRaTTgzWjF2LzVmeW5pSWE1?=
 =?utf-8?B?cDdrS1ZFWWY3SVYyQzFqRWdRZ1ZuQmF6NW1lNWtOK0VEQmJWa3RaODhJYTFE?=
 =?utf-8?B?dkNZalRPTS9STU0xYnJ2WEI1ZXVWN2JaTnRmZkRmVW53b3RTbHRTaU9qbXV2?=
 =?utf-8?B?ckxsWDlSeVJZd3c3Q3JNVXVZWTNCK3NaclNCVlRkZnBGT1lNZm5hL1UrRDVK?=
 =?utf-8?B?VUZuUW9yOWJIckJ6UnhxZWpoZ3U5L1JRNTl0M0dFUm1wbGp6ZUJObHVMQWF5?=
 =?utf-8?B?SmdOajNMSFM2aXdXcUJNeVYxMzNrNVl1bHUvUTBCK2g4NUJXbTBXeDdvbEE0?=
 =?utf-8?B?SGZqV2dRUnlZUTNBaUNITlZjT2FFYW10MHJ3UEJENzMxQXNBcDB0cURsZEUx?=
 =?utf-8?B?N2lMeU0vS1N3cThBWUZQK0NhWVkrVHJTb2FNK1hQZ3VBZkhnRUI5dEp0OFNr?=
 =?utf-8?B?K2pJZUhkMzVUTk8wckk4VmtBN25oM0ZoL0s3Ly9VeEhoN1piUklKOUN4Ujc5?=
 =?utf-8?B?aFhLZmMyRGJiZlZ5V0xBV1FuTzFsQUdyV1JVM09JVTF6V0JmZEVtMmgxWXVt?=
 =?utf-8?B?NWVWemdlK3lFTVQvZ3ZNR0pEYnRWS2JwYk5HUXpoRjlDZll5S0k2Y2RZb3oy?=
 =?utf-8?B?S0lxUDZBOUNyVnNiQ1k4anJiYlhCOEdpOHJhMFZlcFdTZXRzUlJqNUptWjdG?=
 =?utf-8?B?UFFyZWRzTFpHWEpWMVljUGN5MWVVenJNMkxMaWU4NGszSEs1OXlyaE9mczBS?=
 =?utf-8?B?dTArL3pSUlMwSUZnc3JhUDZGNFZVM3hKYWRoWkRVNVZCdDF0RmY0bnRFb1k2?=
 =?utf-8?B?S0Q2c09OUFladUtwWHpBc3ZMUEpSMkZZc21VSG92K0c0V2tHU3dybytFcVdN?=
 =?utf-8?B?NWhURFd0YkFRdTFMVWhaMGpQTEhObFRzb2NWZEtsUG9TT29uai9VLy9DVzdH?=
 =?utf-8?B?aXNBUmtOb0VNWDJBUFBvSENpMEpNZnczaExTYk5SOE5ablhpdVd5amdxTVhQ?=
 =?utf-8?B?OFdoSTFFUlN1Nm0rWk03eDloSkpKdHh1QU41SnczS1FtN29MSXVJME5kTzBK?=
 =?utf-8?B?YWg2dXl2OHVIMGh4OTdGWlFweC9Ca2drb1k1cHVyU2cxNUkxVUZESExRYkZY?=
 =?utf-8?B?alE3VFp6VDUxOSt5Wi9jV1FxN1NoZW10NUtxbzhjQUhybVNvdHpKbjJZM0Fp?=
 =?utf-8?B?aWRGUlk5WDlqQ05SYWJUakdLS2JSVjZtMkpZTitrL0FTRFJTaWJUT2xtak42?=
 =?utf-8?B?OEpoN0Z2TEtGM2oyRHlWMnlBUDd3SkRTWWVudFFiMkZrZHZMZXhOQlg0UFpO?=
 =?utf-8?B?T3YzcExkeXBLZzNsQ29kUHl2bXArczgrb1pYSFJvU1lhMFp3VHZ5MVNqL2dJ?=
 =?utf-8?B?WWpvOGk2Q0VWMHdMWVpEUjJMcHBRWFBuZHV0dmNpb2xGbGRUejZsRTRnUTYw?=
 =?utf-8?B?Z1Zpb3ZvbGpLcEpVcUZyV1NvTnJFMWFKSGcvN1VYTjVGTzlJY016RkxxbnA2?=
 =?utf-8?B?RkdoQlBCZ0tHVnBsN1k2akpGY3JSU2xRTWNIcDJjSXFwZzE5UW5lMkJiQlNY?=
 =?utf-8?B?TUcvYmgySTJmdjFxTVhkZ0ZJOUtYQVdrVDRibUdMUzlCN0M3VFFScDhSa1Yz?=
 =?utf-8?B?TWlJcDFNVkNOd0k4NThwV3hJZHpwUjdONDI0azhqQlFsNWdsSmorUlJzVVJY?=
 =?utf-8?B?eTZ5cXNLSk1JRmdVQkxpTTZwTGFCNjBaUXpQeGQwbXRZcllzNkJ0eU1LOTZx?=
 =?utf-8?Q?7drOBLvVE65YIN/oIrK3ZbABE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6CA14ECC4D7E284DB68939A1B0931230@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e968e65b-42c7-4436-ea19-08da5c3a38b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2022 14:50:35.5404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ERy9DQglP0SarNFl52dRtLF71Dbs97e9GvO05uC8m6OoD4254f5N3HeaHx63PKk8mdSXSjcBz4AdMmxQDBGnxI4dPm5OSp9e3hXifcs6T1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5575
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzAvMDYvMjAyMiAwOTowNSwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJ
TDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93
IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IFRoZSBjZmdfY2xrIHN0cnVjdCBpcyBub3cganVz
dCBhIHJlZGVmaW5pdGlvbiBvZiB0aGUgY2xrX2RpdmlkZXIgc3RydWN0DQo+IHdpdGggY3VzdG9t
IGltcGxlbnRhdGlvbnMgb2YgdGhlIG9wcywgdGhhdCBpbXBsZW1lbnQgYW4gZXh0cmEgbGV2ZWwg
b2YNCj4gcmVkaXJlY3Rpb24uIFJlbW92ZSB0aGUgY3VzdG9tIHN0cnVjdCBhbmQgcmVwbGFjZSBp
dCB3aXRoIGNsa19kaXZpZGVyLg0KDQpMb29rcyBsaWtlIEkgZm9yZ290IHRvIGFzc2lnbiB0aGUg
c3BpbmxvY2sgaW4gdGhpcyBhbmQgdGhlIHBlcmlwaF9jbGsNCnBhdGNoZXMuIEknbSByZXNwaW5u
aW5nIGFueXdheSB0byBmaXggUGhpbGlwcCdzIGNvbW1lbnRzIG9uIHRoZSByZXNldA0KY29udHJv
bGxlciAmIHRvIGRyb3AgdGhlIHR3byBuZXQtbmV4dCBwYXRjaGVzIHNvIEknbGwgZml4IHRoaXMg
dG9vLg0KVGhhbmtzLA0KQ29ub3IuDQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENvbm9yIERvb2xl
eSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9jbGsvbWlj
cm9jaGlwL2Nsay1tcGZzLmMgfCA3NSArKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgNjggZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWljcm9jaGlwL2Nsay1tcGZzLmMgYi9kcml2ZXJz
L2Nsay9taWNyb2NoaXAvY2xrLW1wZnMuYw0KPiBpbmRleCBlNThkMGJjNDY2OWEuLmM0ZDFjNDhk
NmQzZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9jbGsvbWljcm9jaGlwL2Nsay1tcGZzLmMNCj4g
KysrIGIvZHJpdmVycy9jbGsvbWljcm9jaGlwL2Nsay1tcGZzLmMNCj4gQEAgLTUxLDI0ICs1MSwx
MyBAQCBzdHJ1Y3QgbXBmc19tc3NwbGxfaHdfY2xvY2sgew0KPiANCj4gICNkZWZpbmUgdG9fbXBm
c19tc3NwbGxfY2xrKF9odykgY29udGFpbmVyX29mKF9odywgc3RydWN0IG1wZnNfbXNzcGxsX2h3
X2Nsb2NrLCBodykNCj4gDQo+IC1zdHJ1Y3QgbXBmc19jZmdfY2xvY2sgew0KPiAtICAgICAgIHZv
aWQgX19pb21lbSAqcmVnOw0KPiAtICAgICAgIGNvbnN0IHN0cnVjdCBjbGtfZGl2X3RhYmxlICp0
YWJsZTsNCj4gLSAgICAgICB1OCBzaGlmdDsNCj4gLSAgICAgICB1OCB3aWR0aDsNCj4gLSAgICAg
ICB1OCBmbGFnczsNCj4gLX07DQo+IC0NCj4gIHN0cnVjdCBtcGZzX2NmZ19od19jbG9jayB7DQo+
IC0gICAgICAgc3RydWN0IG1wZnNfY2ZnX2Nsb2NrIGNmZzsNCj4gLSAgICAgICBzdHJ1Y3QgY2xr
X2h3IGh3Ow0KPiArICAgICAgIHN0cnVjdCBjbGtfZGl2aWRlciBjZmc7DQo+ICAgICAgICAgc3Ry
dWN0IGNsa19pbml0X2RhdGEgaW5pdDsNCj4gICAgICAgICB1bnNpZ25lZCBpbnQgaWQ7DQo+ICAg
ICAgICAgdTMyIHJlZ19vZmZzZXQ7DQo+ICB9Ow0KPiANCj4gLSNkZWZpbmUgdG9fbXBmc19jZmdf
Y2xrKF9odykgY29udGFpbmVyX29mKF9odywgc3RydWN0IG1wZnNfY2ZnX2h3X2Nsb2NrLCBodykN
Cj4gLQ0KPiAgc3RydWN0IG1wZnNfcGVyaXBoX2Nsb2NrIHsNCj4gICAgICAgICB2b2lkIF9faW9t
ZW0gKnJlZzsNCj4gICAgICAgICB1OCBzaGlmdDsNCj4gQEAgLTIyOCw1NiArMjE3LDYgQEAgc3Rh
dGljIGludCBtcGZzX2Nsa19yZWdpc3Rlcl9tc3NwbGxzKHN0cnVjdCBkZXZpY2UgKmRldiwgc3Ry
dWN0IG1wZnNfbXNzcGxsX2h3X2MNCj4gICAqICJDRkciIGNsb2Nrcw0KPiAgICovDQo+IA0KPiAt
c3RhdGljIHVuc2lnbmVkIGxvbmcgbXBmc19jZmdfY2xrX3JlY2FsY19yYXRlKHN0cnVjdCBjbGtf
aHcgKmh3LCB1bnNpZ25lZCBsb25nIHByYXRlKQ0KPiAtew0KPiAtICAgICAgIHN0cnVjdCBtcGZz
X2NmZ19od19jbG9jayAqY2ZnX2h3ID0gdG9fbXBmc19jZmdfY2xrKGh3KTsNCj4gLSAgICAgICBz
dHJ1Y3QgbXBmc19jZmdfY2xvY2sgKmNmZyA9ICZjZmdfaHctPmNmZzsNCj4gLSAgICAgICB1MzIg
dmFsOw0KPiAtDQo+IC0gICAgICAgdmFsID0gcmVhZGxfcmVsYXhlZChjZmctPnJlZykgPj4gY2Zn
LT5zaGlmdDsNCj4gLSAgICAgICB2YWwgJj0gY2xrX2Rpdl9tYXNrKGNmZy0+d2lkdGgpOw0KPiAt
DQo+IC0gICAgICAgcmV0dXJuIGRpdmlkZXJfcmVjYWxjX3JhdGUoaHcsIHByYXRlLCB2YWwsIGNm
Zy0+dGFibGUsIGNmZy0+ZmxhZ3MsIGNmZy0+d2lkdGgpOw0KPiAtfQ0KPiAtDQo+IC1zdGF0aWMg
bG9uZyBtcGZzX2NmZ19jbGtfcm91bmRfcmF0ZShzdHJ1Y3QgY2xrX2h3ICpodywgdW5zaWduZWQg
bG9uZyByYXRlLCB1bnNpZ25lZCBsb25nICpwcmF0ZSkNCj4gLXsNCj4gLSAgICAgICBzdHJ1Y3Qg
bXBmc19jZmdfaHdfY2xvY2sgKmNmZ19odyA9IHRvX21wZnNfY2ZnX2Nsayhodyk7DQo+IC0gICAg
ICAgc3RydWN0IG1wZnNfY2ZnX2Nsb2NrICpjZmcgPSAmY2ZnX2h3LT5jZmc7DQo+IC0NCj4gLSAg
ICAgICByZXR1cm4gZGl2aWRlcl9yb3VuZF9yYXRlKGh3LCByYXRlLCBwcmF0ZSwgY2ZnLT50YWJs
ZSwgY2ZnLT53aWR0aCwgMCk7DQo+IC19DQo+IC0NCj4gLXN0YXRpYyBpbnQgbXBmc19jZmdfY2xr
X3NldF9yYXRlKHN0cnVjdCBjbGtfaHcgKmh3LCB1bnNpZ25lZCBsb25nIHJhdGUsIHVuc2lnbmVk
IGxvbmcgcHJhdGUpDQo+IC17DQo+IC0gICAgICAgc3RydWN0IG1wZnNfY2ZnX2h3X2Nsb2NrICpj
ZmdfaHcgPSB0b19tcGZzX2NmZ19jbGsoaHcpOw0KPiAtICAgICAgIHN0cnVjdCBtcGZzX2NmZ19j
bG9jayAqY2ZnID0gJmNmZ19ody0+Y2ZnOw0KPiAtICAgICAgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7
DQo+IC0gICAgICAgdTMyIHZhbDsNCj4gLSAgICAgICBpbnQgZGl2aWRlcl9zZXR0aW5nOw0KPiAt
DQo+IC0gICAgICAgZGl2aWRlcl9zZXR0aW5nID0gZGl2aWRlcl9nZXRfdmFsKHJhdGUsIHByYXRl
LCBjZmctPnRhYmxlLCBjZmctPndpZHRoLCAwKTsNCj4gLQ0KPiAtICAgICAgIGlmIChkaXZpZGVy
X3NldHRpbmcgPCAwKQ0KPiAtICAgICAgICAgICAgICAgcmV0dXJuIGRpdmlkZXJfc2V0dGluZzsN
Cj4gLQ0KPiAtICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZtcGZzX2Nsa19sb2NrLCBmbGFncyk7
DQo+IC0gICAgICAgdmFsID0gcmVhZGxfcmVsYXhlZChjZmctPnJlZyk7DQo+IC0gICAgICAgdmFs
ICY9IH4oY2xrX2Rpdl9tYXNrKGNmZy0+d2lkdGgpIDw8IGNmZ19ody0+Y2ZnLnNoaWZ0KTsNCj4g
LSAgICAgICB2YWwgfD0gZGl2aWRlcl9zZXR0aW5nIDw8IGNmZy0+c2hpZnQ7DQo+IC0gICAgICAg
d3JpdGVsX3JlbGF4ZWQodmFsLCBjZmctPnJlZyk7DQo+IC0NCj4gLSAgICAgICBzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZtcGZzX2Nsa19sb2NrLCBmbGFncyk7DQo+IC0NCj4gLSAgICAgICByZXR1
cm4gMDsNCj4gLX0NCj4gLQ0KPiAtc3RhdGljIGNvbnN0IHN0cnVjdCBjbGtfb3BzIG1wZnNfY2xr
X2NmZ19vcHMgPSB7DQo+IC0gICAgICAgLnJlY2FsY19yYXRlID0gbXBmc19jZmdfY2xrX3JlY2Fs
Y19yYXRlLA0KPiAtICAgICAgIC5yb3VuZF9yYXRlID0gbXBmc19jZmdfY2xrX3JvdW5kX3JhdGUs
DQo+IC0gICAgICAgLnNldF9yYXRlID0gbXBmc19jZmdfY2xrX3NldF9yYXRlLA0KPiAtfTsNCj4g
LQ0KPiAgI2RlZmluZSBDTEtfQ0ZHKF9pZCwgX25hbWUsIF9wYXJlbnQsIF9zaGlmdCwgX3dpZHRo
LCBfdGFibGUsIF9mbGFncywgX29mZnNldCkgeyAgICAgICAgICAgICAgICBcDQo+ICAgICAgICAg
LmlkID0gX2lkLCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBcDQo+ICAgICAgICAgLmNmZy5zaGlmdCA9IF9zaGlmdCwg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQo+IEBAIC0yODUsNyArMjI0LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBjbGtfb3BzIG1w
ZnNfY2xrX2NmZ19vcHMgPSB7DQo+ICAgICAgICAgLmNmZy50YWJsZSA9IF90YWJsZSwgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+
ICAgICAgICAgLnJlZ19vZmZzZXQgPSBfb2Zmc2V0LCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ICAgICAgICAgLmNmZy5mbGFncyA9
IF9mbGFncywgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBcDQo+IC0gICAgICAgLmh3LmluaXQgPSBDTEtfSFdfSU5JVChfbmFtZSwgX3Bh
cmVudCwgJm1wZnNfY2xrX2NmZ19vcHMsIDApLCAgICAgICAgICAgICAgICAgICBcDQo+ICsgICAg
ICAgLmNmZy5ody5pbml0ID0gQ0xLX0hXX0lOSVQoX25hbWUsIF9wYXJlbnQsICZjbGtfZGl2aWRl
cl9vcHMsIDApLCAgICAgICAgICAgICAgICBcDQo+ICB9DQo+IA0KPiAgc3RhdGljIHN0cnVjdCBt
cGZzX2NmZ19od19jbG9jayBtcGZzX2NmZ19jbGtzW10gPSB7DQo+IEBAIC0zMDIsOCArMjQxLDgg
QEAgc3RhdGljIHN0cnVjdCBtcGZzX2NmZ19od19jbG9jayBtcGZzX2NmZ19jbGtzW10gPSB7DQo+
ICAgICAgICAgICAgICAgICAuY2ZnLnRhYmxlID0gbXBmc19kaXZfcnRjcmVmX3RhYmxlLA0KPiAg
ICAgICAgICAgICAgICAgLnJlZ19vZmZzZXQgPSBSRUdfUlRDX0NMT0NLX0NSLA0KPiAgICAgICAg
ICAgICAgICAgLmNmZy5mbGFncyA9IENMS19ESVZJREVSX09ORV9CQVNFRCwNCj4gLSAgICAgICAg
ICAgICAgIC5ody5pbml0ID0NCj4gLSAgICAgICAgICAgICAgICAgICAgICAgQ0xLX0hXX0lOSVRf
UEFSRU5UU19EQVRBKCJjbGtfcnRjcmVmIiwgbXBmc19leHRfcmVmLCAmbXBmc19jbGtfY2ZnX29w
cywgMCksDQo+ICsgICAgICAgICAgICAgICAuY2ZnLmh3LmluaXQgPQ0KPiArICAgICAgICAgICAg
ICAgICAgICAgICBDTEtfSFdfSU5JVF9QQVJFTlRTX0RBVEEoImNsa19ydGNyZWYiLCBtcGZzX2V4
dF9yZWYsICZjbGtfZGl2aWRlcl9vcHMsIDApLA0KPiAgICAgICAgIH0NCj4gIH07DQo+IA0KPiBA
QCAtMzE3LDEzICsyNTYsMTMgQEAgc3RhdGljIGludCBtcGZzX2Nsa19yZWdpc3Rlcl9jZmdzKHN0
cnVjdCBkZXZpY2UgKmRldiwgc3RydWN0IG1wZnNfY2ZnX2h3X2Nsb2NrICoNCj4gICAgICAgICAg
ICAgICAgIHN0cnVjdCBtcGZzX2NmZ19od19jbG9jayAqY2ZnX2h3ID0gJmNmZ19od3NbaV07DQo+
IA0KPiAgICAgICAgICAgICAgICAgY2ZnX2h3LT5jZmcucmVnID0gZGF0YS0+YmFzZSArIGNmZ19o
dy0+cmVnX29mZnNldDsNCj4gLSAgICAgICAgICAgICAgIHJldCA9IGRldm1fY2xrX2h3X3JlZ2lz
dGVyKGRldiwgJmNmZ19ody0+aHcpOw0KPiArICAgICAgICAgICAgICAgcmV0ID0gZGV2bV9jbGtf
aHdfcmVnaXN0ZXIoZGV2LCAmY2ZnX2h3LT5jZmcuaHcpOw0KPiAgICAgICAgICAgICAgICAgaWYg
KHJldCkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIGRldl9lcnJfcHJvYmUoZGV2
LCByZXQsICJmYWlsZWQgdG8gcmVnaXN0ZXIgY2xvY2sgaWQ6ICVkXG4iLA0KPiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjZmdfaHctPmlkKTsNCj4gDQo+ICAg
ICAgICAgICAgICAgICBpZCA9IGNmZ19ody0+aWQ7DQo+IC0gICAgICAgICAgICAgICBkYXRhLT5o
d19kYXRhLmh3c1tpZF0gPSAmY2ZnX2h3LT5odzsNCj4gKyAgICAgICAgICAgICAgIGRhdGEtPmh3
X2RhdGEuaHdzW2lkXSA9ICZjZmdfaHctPmNmZy5odzsNCj4gICAgICAgICB9DQo+IA0KPiAgICAg
ICAgIHJldHVybiAwOw0KPiBAQCAtMzkzLDcgKzMzMiw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qg
Y2xrX29wcyBtcGZzX3BlcmlwaF9jbGtfb3BzID0gew0KPiAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgX2ZsYWdzKSwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IFwNCj4gIH0NCj4gDQo+IC0jZGVmaW5lIFBBUkVOVF9DTEsoUEFSRU5UKSAoJm1wZnNfY2ZnX2Ns
a3NbQ0xLXyMjUEFSRU5UXS5odykNCj4gKyNkZWZpbmUgUEFSRU5UX0NMSyhQQVJFTlQpICgmbXBm
c19jZmdfY2xrc1tDTEtfIyNQQVJFTlRdLmNmZy5odykNCj4gDQo+ICAvKg0KPiAgICogQ3JpdGlj
YWwgY2xvY2tzOg0KPiAtLQ0KPiAyLjM2LjENCj4gDQo+IA0KPiBfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBsaW51eC1yaXNjdiBtYWlsaW5nIGxpc3QN
Cj4gbGludXgtcmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlzdHMuaW5mcmFk
ZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LXJpc2N2DQoNCg==
