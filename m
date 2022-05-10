Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188DB5211C5
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiEJKMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiEJKMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:12:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC71F185C85;
        Tue, 10 May 2022 03:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1652177322; x=1683713322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MzKBK4A4lFaxgOvQK7ZDUOOmOgZofJq9zVualSchYAA=;
  b=BjK/FGuccFcpQ56vCswXr4l1BQr6ZrYkKwZXJcJ/T0OXALxlZuEiYYdi
   aTu9jXdlvYGgUjOpH3cgvMAMjawjehH8oGzYg1vt5hBsbE8GKMJOdV4MZ
   yHSTFO0kG0ttw2ZWCJMCDv/rXrsMb6B6APaSXpVeyrfc7r2+7onMjXDeO
   fRNfgoJjtU4DyNU9AdQDbtmDwTC0Uvp5xQJPsDDaLfXn2MByTmghFJAVS
   HYldNFOtNIPU7W/lQv9Uk3K8lNhGCAGFQIQMZEB1spnb8afiTPUl2KZHC
   Nrnh/ocZQM0tu4G7Fq1Yo1Uovzzim5G+ZauY1FLB9AbLyeai8F5XpHuUh
   A==;
X-IronPort-AV: E=Sophos;i="5.91,214,1647327600"; 
   d="scan'208";a="162997338"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 May 2022 03:08:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 10 May 2022 03:08:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 10 May 2022 03:08:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oqrn2OWm065fVX693wjQ4dDbVJluQCH+GHx2E0udzW9DipshgucPHMLHvXZktnvIuU6eGEE6LPYuKAmqUVCP0qVxo+Ao67M/7NRnDKFOeL27f1wsPZEcDqvBpKT52CmNMMf446kvJkIX0GFWp0G+uVyEOAeTrHt7oswWASO9JOciiBeh27h0VBliXqhiDQnm0xU6QM8Am6rah9iunX6OEJE0bZyUmrcv/f5G4JjCb5Lzhq07ZnHdUu0Bm6c3xliizQ56ViULaCH+QALOZySbLNpdPIgHxtp9ue6+giGee8X+UQo5BdJnktKNuUQdJ5OTwjv49ZzyLldoqyV94bQ4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzKBK4A4lFaxgOvQK7ZDUOOmOgZofJq9zVualSchYAA=;
 b=DLv1oMpA5v2FrFhBWKYB//3ke4+BGQqJUuRVrexuMMjHCX2XpcoV+mWTz9luJhQ/2dO8vOJtTfonr9/eQHcx056UfjPuUyohH0LWDqOa/vtcrmYi70pUhHvIyVg59YDKWhTR828FUD0f/wJrAoy2iHmxz4ra3PLhiyRc1Ezz1jdlYIGQjeB6MKBNdiHhdNCp8T7e/V+XnUSWttPpLNk9CZnFwDbU7ylAkDNhpB6lxf+eFX9TqqkgUPdIv1NAbduBjrAyajQMozVnIKiAkAWSk42Sat9A5n/0gLN3tOdyhvnPgHXn7Bm8yAYnauSNUIu2aOf5Brdf19UVGN35Fpj6uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzKBK4A4lFaxgOvQK7ZDUOOmOgZofJq9zVualSchYAA=;
 b=Mto40X4KeCngBQ0SE2GqHNg6lK87OJYrUVtpxH7lOGjZZLpIJRhG4wS3f9erztKDOMemqvEqVoyOh+e7dokpKxHL9WgcPL37n4UEtKkbQyCiuhzYDj0GQrXY35WpOGr8LWxPA7YOuBQvnQ3dVV+YQaS+OUkhFoAWl4yGsgtF12A=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by CY4PR11MB0040.namprd11.prod.outlook.com (2603:10b6:910:7a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 10:08:36 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::e906:3e8d:4741:c0f0]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::e906:3e8d:4741:c0f0%6]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 10:08:36 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <dumazet@google.com>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH] net: macb: Disable macb pad and fcs for fragmented
 packets
Thread-Topic: [PATCH] net: macb: Disable macb pad and fcs for fragmented
 packets
Thread-Index: AQHYZFXph3hgirVZe06TbcckLqxFLw==
Date:   Tue, 10 May 2022 10:08:36 +0000
Message-ID: <76220763-de79-c93b-2691-9dab8fb3529e@microchip.com>
References: <20220509121513.30549-1-harini.katakam@xilinx.com>
In-Reply-To: <20220509121513.30549-1-harini.katakam@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4af568f9-cf8c-450c-7539-08da326d0c37
x-ms-traffictypediagnostic: CY4PR11MB0040:EE_
x-microsoft-antispam-prvs: <CY4PR11MB004000D3C650DF53A0C5798987C99@CY4PR11MB0040.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5VAKSNwg+OQF8IO4jRNgJQVOuQY+3ZVzzZJFOzQ4CcJChyLNT9+6LG1dR9FZQ3gzjh9+09i/nmiqD4R+2JfOP5Wlm0ReFZmh59Aeqewo+gh9ALmiXvXrGzCUDeYv+M7NhI15BMA+s97Gsp6ndiL69hoHok5Yw/aOBnU6YVzdUOaP6Q8NnV4NLqW7meJX6ZtqIOJByNHhgTt+Sfk8P0uS6wQIBUisUNXfc8DXiK1KEoNXBBO2qxTfJpyifPr/yaMl9NYtzudI11cj771ng+2hLWfQQDtxNNbLofDZB+Yx/xGHMu9bLuJoPsD6IQVm5fAieCia8A35mnwR3XrEINWTVP9I0TbzJkzajxiPM8HKlkOsCFtYC+5Wz9Ja4HpAgsBMGeaVQustTw2S6kVmW/voZzZLUkjb16usmygyXHmywyONaFOxq1m6oJuD3trJYZXYc52s+/47bjkkJBhlPB9o4f/0mnu1WKJzsVjGZFNtegjIyCvsw41m23JCPEB/t7P3U8bDIsnxDGEI5GonckSBt/HE6SoC39Q8iDm+dcI90krefHllxY4vDYLGRMYzprE8KOoBAzo0l3sC0g1344bwL83YR/aPBa7hAlazqkG0hJjroAF7CKcOBOHTmn+LtCIAzndLXKbA7LjaQrYj9tRgVWXI14rWLgDRmDdBlTYh86R/18NUBE4CUXIa9RRs96PWDwSHeIAEDYTt23phADZtyzZEqLIyujHGDOl4jGAtDDcUJR11tky/4Uy34SorA7WoUeB4RGtcsLs3qj+ovwuS2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(91956017)(36756003)(71200400001)(8936002)(53546011)(8676002)(110136005)(64756008)(4326008)(31686004)(508600001)(66556008)(66946007)(66446008)(76116006)(2906002)(66476007)(54906003)(83380400001)(38100700002)(316002)(2616005)(6506007)(186003)(86362001)(31696002)(122000001)(38070700005)(5660300002)(7416002)(6486002)(26005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWV1SktjSzJLTHMyZTU0WUxxK3g4N2FkMFdSaGNmMlZicTI2d0xTS3YwZjhG?=
 =?utf-8?B?MndPM3NYeUhMN3dYV1FtK0tVbzY5T05wNHIzSWxPNlBwV2x5UTdlZmJtOG5y?=
 =?utf-8?B?R3FqSWRXVE9JTGNmbUpvdmtNS0kwK0xqSUcwSWU3aW40Qk1WMTluTU1TVmRR?=
 =?utf-8?B?VDA3L3JaeldRNHJVbmx3SGhzdSt4a2o2NnZVSDB0TjFVNy93ZTEvUXZzajVy?=
 =?utf-8?B?MUY4SVJSSWhoUVVNV1RqY09YaTA2d3d2QjE5R3oxYVRHL0NUQnYxLzBwUytT?=
 =?utf-8?B?SUNMUVNselVielM3dXU0a1lacHhMYWJuLzFobzJIQkM5bEpnQ2RaZG9jVUpG?=
 =?utf-8?B?T1BSSFJRUXpERGVzeWVDcGtMRCtXRy80SHJibXp2Wm9CU0oyVExpRzE2RGY5?=
 =?utf-8?B?N2FYMlhYR1R5Y1pxcVdWcHhkM0hiOXlsVUgyT3VZWDlRWE0rdDJDbmJMejlW?=
 =?utf-8?B?bE1qalIrQW1ZQzNaMDFFanVKcGpTNmNLQU5YRk9wTVA5UnRXYmlYb09nakdV?=
 =?utf-8?B?WmYyUFB4VTFRazdsNThQbTVsS0NBZmFyaXlwdG1zeTROUUtHY2N0V2pJelBE?=
 =?utf-8?B?TVRLMExTYlQ3Qk1zUm1CWWJCcW85RWhPZFJkTVRDM3oyc2ZTNE96ZHVxenh2?=
 =?utf-8?B?ZE9IWld0YUVhbHZidTlMbjQwRHRscmxzWkUvNWFma3k1dURQVFdCL0k5UkIx?=
 =?utf-8?B?SmQzUlprMTJiVWwvb0p0TnVlU1hKLzNER0F6T2hSZndNQzhKc1BhZm5seDN6?=
 =?utf-8?B?ZWdpUE1IbUxzUi9JTGU2R0o4elRLTVViS1c3cllyZ0p2eE41U1NxMU03V0Ez?=
 =?utf-8?B?R2J4TWVzZEZHOC9NOVliQ2VtcGhMRExkSGp3Y0lMUXRuY2JWMEE2THhEeEhC?=
 =?utf-8?B?Rkp3SjZVeWVFLzdsVGMrNWN0THcrc3dld01xOFFMVGxjWloyR2R5a09hTU1v?=
 =?utf-8?B?UzRDSW9pcHZSZnRsdnhTRmRZZSt2SjZGSVZENWxKU2lsdmFIM0docWMycjl5?=
 =?utf-8?B?ZG1CZVJZYk41UDUzMDZiVHRZTE9KM1lXQk1oa2JtWGhNQWxmSnZacklpU0ph?=
 =?utf-8?B?cEpxNDQxYVNxZXlyNjk0TkUrNENYTzl3K3hiYXBhT0NaaWF0SU9vK2kyWHFY?=
 =?utf-8?B?ODVGS0JHazBmTVFxT1BGdXU0aGtPMk5YQTFNT3VvRmRncXZOMXUzUVhnTkNQ?=
 =?utf-8?B?ZVhyWFhtbjF6a2ZjQmhZcms2Z2xlLzdTS1VWREVVQ1BMd3BZVmZvM3JhdXBU?=
 =?utf-8?B?YmMvL2hwdldUTVlFTUpvQTlHREowMzJNaU5ZYWovS3BlaU1tU1JzcFFuUG1U?=
 =?utf-8?B?NWFxVWpIaVh3YmVxWWwzMGY3d0U5QWUvSVpiNTVOb0xvSkt5WElEa20zbkN2?=
 =?utf-8?B?QkRsZDRmaDFDYnF3eFN5NGpFQ04wWmhrTDBnU253WVZhdktwbGI1OE41Z2x4?=
 =?utf-8?B?WWhmdjBuRVBvNDNDSWJJdFRpN1NMWVNpeFhmZkZsSWpGYVVCRTc1OWNDUk53?=
 =?utf-8?B?YzJlWUlhV1B0akJoWUwyUG9PVllibFdSYThMdkhsWklWS0FRWjYxQ21nb2hN?=
 =?utf-8?B?UVBZTVVNRXUraEdkaHdYWGNhTyt5V3c2ZC9UdVQrd3VCbkxxNGJyWHhFYkc2?=
 =?utf-8?B?M2xoQytQZHJuRThxN1MxMjd1d05zMG9HQ0Q1ZFRWb012SVMveEVNS2ZnT1Qy?=
 =?utf-8?B?amUxemZNWmN3YloxbHZyU0FjeEU4dFVqT1o4RUt5ZGl2NURlMHVjVk04SzlH?=
 =?utf-8?B?dDlSY0oxeVFIQmZMdGdpQTJGeEViRjg1cFJ4YTVENkFPZVFRa2xFcmRnQ0lj?=
 =?utf-8?B?NlRZWUFzcUE1bFdpNUdMVUdVV215TzVEM1J0UjhLSk0xWXBpeEZsK1NLQkNa?=
 =?utf-8?B?OGF2YTlZeWVLMHY4UnVGUUZQS2d5aEpJaG9VSHlmTkVVdWtuNFo1M0RBbmlw?=
 =?utf-8?B?NU5IUnVIU3BHanpDMEY5emlZWVpXNGpIMFNwSzFHRlpEMkNoaWJscnc5SnJv?=
 =?utf-8?B?emVlU21xd2h2akoxSjNxOFJEdnhscHRXL2lWT1BxNHZHUFNnS1MwT3NCWU15?=
 =?utf-8?B?RFQ0Z2FjSER3T0l6MFRqaGVSenBoMEVLZXRUVmNQcjZaZmlJRlZBZ0RIVy94?=
 =?utf-8?B?SDhnWVhaeUxIb3RSMlIreWI0ODVTUGo0Ykpvek0yNEtHSk96Y3ZKTnFRbUpH?=
 =?utf-8?B?V08yRkhiYk9RVHpsTnl0QzhZd0Vtc25FV3hqOHIyclBTOVpQNWVMVmlhV1Vt?=
 =?utf-8?B?RXlxZ283K2dBWmR3ZnVNWVQyL0pLWUlrMFpjMnpIakFLZGIveFhTSzdSUDJV?=
 =?utf-8?B?TTlpaGxyTTJnT1RyWWI0VWVvRmZwYVE5Ry9IR1VpQk9aTUs3ZXlhV204UEVk?=
 =?utf-8?Q?GQrAnM2YpZnPdXo0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <775F02920694234583E6D0B0B195238F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af568f9-cf8c-450c-7539-08da326d0c37
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 10:08:36.3819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /w03CxlycWQ1/FIq/IA+hFcKYSx6YlqOQMhJiJE+xtI/qRvqbZEAZFrxmWLBVJlbkSLUfX/uvuo2WvPLD2ZPTtbmX/X4OFyDBQGOYKk1mDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0040
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDkuMDUuMjAyMiAxNToxNSwgSGFyaW5pIEthdGFrYW0gd3JvdGU6DQo+IEVYVEVSTkFMIEVN
QUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtu
b3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gZGF0YV9sZW4gaW4gc2tidWZmIHJlcHJlc2Vu
dHMgYnl0ZXMgcmVzaWRlbnQgaW4gZnJhZ21lbnQgbGlzdHMgb3INCj4gdW5tYXBwZWQgcGFnZSBi
dWZmZXJzLiBGb3Igc3VjaCBwYWNrZXRzLCB3aGVuIGRhdGFfbGVuIGlzIG5vbi16ZXJvLA0KPiBz
a2JfcHV0IGNhbm5vdCBiZSB1c2VkIC0gdGhpcyB3aWxsIHRocm93IGEga2VybmVsIGJ1Zy4gSGVu
Y2UgZG8gbm90DQo+IHVzZSBtYWNiX3BhZF9hbmRfZmNzIGZvciBzdWNoIGZyYWdtZW50cy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEhhcmluaSBLYXRha2FtIDxoYXJpbmkua2F0YWthbUB4aWxpbngu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBNaWNoYWwgU2ltZWsgPG1pY2hhbC5zaW1la0B4aWxpbngu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0u
cGFuZGV5QHhpbGlueC5jb20+DQoNClJldmlld2VkLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRp
dS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDcgKysrKystLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
Y2FkZW5jZS9tYWNiX21haW4uYw0KPiBpbmRleCA2NDM0ZTc0YzA0ZjEuLjBiMDMzMDVhZDZhMCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0K
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBAIC0x
OTk1LDcgKzE5OTUsOCBAQCBzdGF0aWMgdW5zaWduZWQgaW50IG1hY2JfdHhfbWFwKHN0cnVjdCBt
YWNiICpicCwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgY3RybCB8PSBNQUNCX0JGKFRYX0xT
TywgbHNvX2N0cmwpOw0KPiAgICAgICAgICAgICAgICAgICAgICAgICBjdHJsIHw9IE1BQ0JfQkYo
VFhfVENQX1NFUV9TUkMsIHNlcV9jdHJsKTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYg
KChicC0+ZGV2LT5mZWF0dXJlcyAmIE5FVElGX0ZfSFdfQ1NVTSkgJiYNCj4gLSAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHNrYi0+aXBfc3VtbWVkICE9IENIRUNLU1VNX1BBUlRJQUwgJiYgIWxz
b19jdHJsKQ0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgc2tiLT5pcF9zdW1tZWQgIT0g
Q0hFQ0tTVU1fUEFSVElBTCAmJiAhbHNvX2N0cmwgJiYNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgIChza2ItPmRhdGFfbGVuID09IDApKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGN0cmwgfD0gTUFDQl9CSVQoVFhfTk9DUkMpOw0KPiAgICAgICAgICAgICAgICAgfSBl
bHNlDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIC8qIE9ubHkgc2V0IE1TUy9NRlMgb24gcGF5
bG9hZCBkZXNjcmlwdG9ycw0KPiBAQCAtMjA5MSw5ICsyMDkyLDExIEBAIHN0YXRpYyBpbnQgbWFj
Yl9wYWRfYW5kX2ZjcyhzdHJ1Y3Qgc2tfYnVmZiAqKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKm5k
ZXYpDQo+ICAgICAgICAgc3RydWN0IHNrX2J1ZmYgKm5za2I7DQo+ICAgICAgICAgdTMyIGZjczsN
Cj4gDQo+ICsgICAgICAgLyogTm90IGF2YWlsYWJsZSBmb3IgR1NPIGFuZCBmcmFnbWVudHMgKi8N
Cj4gICAgICAgICBpZiAoIShuZGV2LT5mZWF0dXJlcyAmIE5FVElGX0ZfSFdfQ1NVTSkgfHwNCj4g
ICAgICAgICAgICAgISgoKnNrYiktPmlwX3N1bW1lZCAhPSBDSEVDS1NVTV9QQVJUSUFMKSB8fA0K
PiAtICAgICAgICAgICBza2Jfc2hpbmZvKCpza2IpLT5nc29fc2l6ZSkgLyogTm90IGF2YWlsYWJs
ZSBmb3IgR1NPICovDQo+ICsgICAgICAgICAgIHNrYl9zaGluZm8oKnNrYiktPmdzb19zaXplIHx8
DQo+ICsgICAgICAgICAgICgoKnNrYiktPmRhdGFfbGVuID4gMCkpDQo+ICAgICAgICAgICAgICAg
ICByZXR1cm4gMDsNCj4gDQo+ICAgICAgICAgaWYgKHBhZGxlbiA8PSAwKSB7DQo+IC0tDQo+IDIu
MTcuMQ0KPiANCg0K
