Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3042E4E6F52
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 09:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350320AbiCYIPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 04:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346416AbiCYIO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 04:14:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEA43CFF3
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 01:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648196003; x=1679732003;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mIbL1YpcKLxk3q0VQxjL2Shbi80WYhHFp+gbOQvg4jg=;
  b=f3cwGwuLoYhOi01784hkh9pGWt1GmO49EvjtMDvm5ICi0fUk4vGx1n8U
   dUUiaDl7HkkQD6ba8gNfSQe9NaDPFNtQDPIXSajS6zDJ2psiXyNh7qIZM
   dNAOsOYJDahXUFYb4aseiCdU0+2pmytDHzk2muVvrzXMJZ9K3pbwxF/S8
   Y/fVdvh1yAwx50QzgrGEbz2hFOTiNFOHEwejKQCcNgOf7RDagzhc40FtF
   vVgDbwiRDVKXMcOXuaGPwi7l8kuiAR5bim8s9w0TVJTJLdfABI99rP39t
   pZNFI+JuI/4FE2VyBSWNRlWdHKfqHP0eHEWomsbmToiCWtKV7ZrZzWshL
   g==;
X-IronPort-AV: E=Sophos;i="5.90,209,1643698800"; 
   d="scan'208";a="153240951"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2022 01:13:20 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Mar 2022 01:13:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Fri, 25 Mar 2022 01:13:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQG+eJVcezyDOriRAychzAShy6Mi6qM0S1BTqbEFlw2oV/vORsQStSaMiwmsLtv2FF073K/c/KeIv33eR5IxLZuXOY8lc1yV/ASy9SdE+dxjC4RzM6e01Mn9V2agyV10e/pzt2XH/mibfc3bG2q2JE+X3MVXK9YNNirQ9y0HjThzv40Vycs0X5tj5EhHpe1E9IpQQ0aiNHUxapVTSKDdCzlvvFU3bVShDljcz3szQzslsums3hR7wIi8D78ZiMcmY9SYDUrxw+AuvaQGWg5vEoAkfzD2IpC1iseUmU88Ir9G+wTxyG6zJUkmZ0VdLDcRrt42EUWnT+DFaI3inm2nKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mIbL1YpcKLxk3q0VQxjL2Shbi80WYhHFp+gbOQvg4jg=;
 b=kvOLN0qIcDRZG3IEpc8YqyhGaUUp+95YSsQPza9CFSqwUPfhBqtXy40W3PT/u+YX55XaeMMG2yPk0elxZir7z5xh02G3TEvAe9mVbmIwt+9SSsc9hZTnBHSjfATRUa8hQpIN0F5xBqDiwqehY5+9UGli/KD5tJoktCdCu9XrkSp46O0wS54+ZA6r850KUiY9o8xny1V1sh8rGX4ShJNJt6mhK+40YCpiKsP/Fzc/UibsxHP7FgQrl2gCcoQcYUJFhWeWTY/DDr7C8DxrOakIzPFf12ZD5F20bWmpzDrSaWh0rGL9rwKeq8Eb3SqS3SyL3WcJaPDUsagWatx/p0hhyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mIbL1YpcKLxk3q0VQxjL2Shbi80WYhHFp+gbOQvg4jg=;
 b=HKQ5V4rw4ebfg4p33NjH1kU/tXxLE08NVBTrJsN8XzcRSGNqexofH7MNka4kiOdjjc1Gb/gSBZCwZPYvv8chys95g8FQuRazI9dTR2qS6rxJyX2MO7KxrQjQysjTuxBBSLQJOVp/MhNPMpbg0HBBOfuzguvt3p8VsUG9itfG/KM=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by DM5PR11MB1292.namprd11.prod.outlook.com (2603:10b6:3:7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Fri, 25 Mar 2022 08:13:09 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 08:13:09 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <robert.hancock@calian.com>, <kuba@kernel.org>,
        <tomas.melin@vaisala.com>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] net: macb: restart tx after tx used bit read
Thread-Topic: [PATCH v3] net: macb: restart tx after tx used bit read
Thread-Index: AQHYQCApBjHF4X2S0kCb++xYqGSYXA==
Date:   Fri, 25 Mar 2022 08:13:08 +0000
Message-ID: <14152644-c44f-a011-7f26-331868831e4f@microchip.com>
References: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com>
 <20220323080820.137579-1-tomas.melin@vaisala.com>
 <20220323084324.37001694@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
In-Reply-To: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf8ab6b3-0a34-43f1-fdc5-08da0e374c34
x-ms-traffictypediagnostic: DM5PR11MB1292:EE_
x-microsoft-antispam-prvs: <DM5PR11MB1292F1362DFED028F02FCA49871A9@DM5PR11MB1292.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oGo67G52HHzuOkv3uazohtLqtk5KaxCnQFj0tQDHdGDjtyL6GRyyvSCOLTsxp3iSjGkLZzrNbjpD/CBEoihocXQ72APi2FCYj+pj1YRvhfY9BwkcrNVLSi3T8WN9IHr2EoubULzvfbtLh5nV62v4tG2RPP5CQKoMYWRruLvBtyp5aHB+5fvQjZFKis9AFRxrn/LvtL8rtVyqSzUQqhQVUVEjJ181xeEZmjNrICTAXXsQW7WjqcZuf0eG19VdKu06IeXSyUGHMdDpR16jiFsX5GiO4xHvQuH5jw9J+OTakadoGDFcy72Wf7jxXmDXkq6c15XQ//tFzAzVFm4f4n5RWtjHrxCXPZZ/06B6jjDVqUQeideJ6FUtIQiN1dOHyOkqaBgC3/GcsTFbvG6zuc34VZjQthozktIDzBnzhuhMJ9VZZl5Roi30SyDMpbXSH1c7pjYWTOjpjCJPRSWOowdCHEOaAISlfXlHYyeS8DThDZYFd+YB1SccFLBqXCEUymBxa3GT2MnMyZnoBbcz0XGO6IBwrmLxGvT5oJy7ch5sLv6D1svSj/ks9pYGXtwLdBj/RpBsbkNhSlJILH27/aDDa6kuvOhlwktwFXVBGaJpTOqlQ0ZvJ+u4JW/dVlUL+nCMtvO4Yk+vQXDVU6gg+GgHS7SEE3uGY+558sdaOTn44RO8yZTUv49FJhEhzMJ7blMLMIhxKkoZJPw0YtxRnSO/fhsQFNAlbSvnJvIiMwX+DSRthGxtwRitO+//AoUPEPhBqb6dOYU1yz6NXMqTeeiwHu6gwQhd0EpLY1NDM3y9jUFQFxg4sPepdyQl+mG5Yuc4/PaHVrz3+pTpB+PnxoIDSdlwAdS2dmlNNdMB6Whs9gWoctK/Xa+zFEB6bQ6NzOTolV5149ymK8Y5Vl+PxQSrkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(122000001)(8936002)(38100700002)(86362001)(2906002)(110136005)(76116006)(66946007)(66446008)(66476007)(66556008)(36756003)(71200400001)(91956017)(64756008)(26005)(2616005)(31696002)(8676002)(508600001)(186003)(316002)(54906003)(53546011)(5660300002)(15974865002)(4326008)(6486002)(6506007)(6512007)(38070700005)(31686004)(43740500002)(45980500001)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmRnSmN1THAwQUdDMUxwa1dVOFhDMG5pN3lsR2xmbFNoK2hJY3BpaXJHKzBp?=
 =?utf-8?B?VXdqSEtnNTdOSU5OMTR4T21nL0lEYlh4cTQ1NlZmcHpwZ2tsY2ZaM0N2djRy?=
 =?utf-8?B?Y3VEbm9DR2JPVHgybzR4TEh0T3U1c1QxcHB5WnlOMnBKQ3VMZklLaU5IRkox?=
 =?utf-8?B?ZkxZVFFLYWpVd09uK3p5Y3czVWFkMmxZVHJCV1Y5bGJRRXh2ckdWL0kvZDhC?=
 =?utf-8?B?ayt6Wk96azFWMHNpY3FTTno0d1d0K3kyRlY0TmZwZkpEMHJzVEE5aDNQT3Y0?=
 =?utf-8?B?MS9uZzk2YXM1Y1hPdS9tdmhpc1hEa2hXMzBjT01RU2lQRUJkcEd0WlB2cFN2?=
 =?utf-8?B?ZFBFV1MrMXNHbU0xdUY2alVhVzhmcXlsVHdTVFFNTzlFYlhqS0pNRllPMzdJ?=
 =?utf-8?B?bkd6aDVFMWV1TVJqbFBUZDQ3Y2k4RWc4bm9qRHVVaEszb1hkOG9FSnRQQy9j?=
 =?utf-8?B?NUtDY1hZUGU2T0MzdGxTOGcwdmE1T2Z2QTdnQVlyeVVZcFd6cWlhQTRlMmx2?=
 =?utf-8?B?Mk5TeFN3NDhzMVpCVWJQNmdjTCtaT2hJdHhkRVlmQWttRGp2WDNFbCtrY00y?=
 =?utf-8?B?N2NwUWtBYkpRU3FvTGtZanZ2VEZ1T3ZpeE1TdTVPemk1YWFEK1hlekpaUlFh?=
 =?utf-8?B?Z0MrTmFmZ09HV3c1MzFzeW03WEQzbXg4RmJFNHZkOThSczNBakZnd0M4OTFi?=
 =?utf-8?B?dlRGTnN4Wm8veVh5WC95L2I1MDRjaVZVU2lUcVFxeml4Q1BTcHJqRUJweXM2?=
 =?utf-8?B?RWJRTkJraVNvQVR0VEhSdmExQjBDZDZJelpFYjN2ZjE1Wk5oRnczV2RwOTRR?=
 =?utf-8?B?eTdzK1VQc0JHNC9YakdMU3VkeWxLYjRVeURiN2FrOXBBb29Kc01Qd0JBcThx?=
 =?utf-8?B?YWlJVVdPUSs5cEx3R0NtczRld0d1QUd1MkZTbnh1OU0rcDRpS2RZM1FxN0Nt?=
 =?utf-8?B?cWFWNVJoM3hRSGdmOENEeU4rbkJoc2hPeWRQTmE3L1VTTjY1SUNxc0NkOENk?=
 =?utf-8?B?QWVnaUh0ODc5akVnYks3cDhrdGQyVTlHSjlHTkh2U04rbGhXd2U5VmorQ0V0?=
 =?utf-8?B?eWhRRVJQaU9VWXVCU25jMUtkbkZEcFBkQnlENGV2L2VDZnF1YlVxZVdjMnNy?=
 =?utf-8?B?aVlKcTFvMTIwK2FWL2VMS2RLc3dxOGV4NXVYYjJod2xjSXI3N1FINzFlUm1o?=
 =?utf-8?B?anN2TC96dVNyS3NaMFNMalhDMmJzeEZoWUFra1ZUM3dXU0VpeW90bTRkZEpR?=
 =?utf-8?B?R0JqL0tnL1FiNjBnTXZ3NDJIdmJKVUpJcXY2ZzZkUHRBRWtZU011c1o5TGIy?=
 =?utf-8?B?WnU1QkgzclVPejkwdmNMbkNYYlFkN0d3M08xTDdkbXlmNUtUK0hlTVVVVXRv?=
 =?utf-8?B?aEZvR1E5NklpZTh3K3hIWlNWY2dqZ2hYRlRBOVFRMXZlQ1JHbVVnNjBWYWpn?=
 =?utf-8?B?ZVJpTkpiL1R6dDJqZ0duYXpKa3NEMDBsdWtoY0MzRVo0bDM1djlKZmh1WW13?=
 =?utf-8?B?MnZQM0pqRGdSc2twRWtRRlZMN245eFhLd3RFbktSc0xid29CNWQ0VCtrVGdq?=
 =?utf-8?B?UWRMME9BUHgzUHBNb0RYZS96MzArbkdQR3BWYzVKbmxaRktqN0d1Slc4eTh3?=
 =?utf-8?B?cFR0emhndVdwbXBWeU53aHNESTdzTzJKNndHU0xZOGNKREtpL0Z6c24wYklR?=
 =?utf-8?B?OWk1Mm5raExlcU9KTERKZjdJelF2Z1kzWVh3c1RUZWJKSi96dkZLNUczbEJQ?=
 =?utf-8?B?cUdXZ1pPczlrSU8wNmdmYnc3MUFlVEMrVjh0VkFWKzJrdUhpVGQyRTA1bUR5?=
 =?utf-8?B?VmEzNFR2Qkw4R0d2RFkxdGMzdlYyMldjaVFtcC81a0Z4SW1xNEc1VFovNHla?=
 =?utf-8?B?NXI0cWMrd0dQSzFDYi9oTmFvT3NtNUJjN1NoWnhhQXM5YVF0ZE1kamVoMEJO?=
 =?utf-8?B?ZzdLeHM1VVRvNkMrd2RBb29jdVlCVmhhMTk5dGlEZlExZUk4SHhsRUxRM093?=
 =?utf-8?B?cGt0bE45dzVBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AF7A5303D88894E8F570A2C88F0A975@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8ab6b3-0a34-43f1-fdc5-08da0e374c34
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 08:13:08.8847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MIl8drwgpvTwI5F2OhbRa/676gae50G9nJxZz0F42SkTlIbrYwIUT1wj3iIPgYxGvbGOCbwGbQ4baWoegk+19TQ/9GuiWpkOiBScxJGjdX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1292
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCk9uIDIzLjAzLjIwMjIgMTg6NDIsIFJvYmVydCBIYW5jb2NrIHdyb3RlOg0KPiBFWFRF
Uk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNz
IHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIFdlZCwgMjAyMi0wMy0yMyBh
dCAwODo0MyAtMDcwMCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+PiBPbiBXZWQsIDIzIE1hciAy
MDIyIDEwOjA4OjIwICswMjAwIFRvbWFzIE1lbGluIHdyb3RlOg0KPj4+PiBGcm9tOiA8Q2xhdWRp
dS5CZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4+Pj4gVG86IDxOaWNvbGFzLkZlcnJlQG1pY3JvY2hp
cC5jb20+LCA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4+Pj4gQ2M6IDxuZXRkZXZAdmdlci5rZXJu
ZWwub3JnPiwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+LA0KPj4+PiAgIDxDbGF1ZGl1
LkJlem5lYUBtaWNyb2NoaXAuY29tPg0KPj4+PiBTdWJqZWN0OiBbUEFUQ0ggdjNdIG5ldDogbWFj
YjogcmVzdGFydCB0eCBhZnRlciB0eCB1c2VkIGJpdCByZWFkDQo+Pj4+IERhdGU6IE1vbiwgMTcg
RGVjIDIwMTggMTA6MDI6NDIgKzAwMDAgICAgIFt0aHJlYWQgb3ZlcnZpZXddDQo+Pj4+IE1lc3Nh
Z2UtSUQ6IDwNCj4+Pj4gMTU0NTA0MDkzNy02NTgzLTEtZ2l0LXNlbmQtZW1haWwtY2xhdWRpdS5i
ZXpuZWFAbWljcm9jaGlwLmNvbT4gKHJhdykNCj4+Pj4NCj4+Pj4gRnJvbTogQ2xhdWRpdSBCZXpu
ZWEgPGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQo+Pj4+DQo+Pj4+IE9uIHNvbWUgcGxh
dGZvcm1zIChjdXJyZW50bHkgZGV0ZWN0ZWQgb25seSBvbiBTQU1BNUQ0KSBUWCBtaWdodCBzdHVj
aw0KPj4+PiBldmVuIHRoZSBwYWNoZXRzIGFyZSBzdGlsbCBwcmVzZW50IGluIERNQSBtZW1vcmll
cyBhbmQgVFggc3RhcnQgd2FzDQo+Pj4+IGlzc3VlZCBmb3IgdGhlbS4gVGhpcyBoYXBwZW5zIGR1
ZSB0byByYWNlIGNvbmRpdGlvbiBiZXR3ZWVuIE1BQ0IgZHJpdmVyDQo+Pj4+IHVwZGF0aW5nIG5l
eHQgVFggYnVmZmVyIGRlc2NyaXB0b3IgdG8gYmUgdXNlZCBhbmQgSVAgcmVhZGluZyB0aGUgc2Ft
ZQ0KPj4+PiBkZXNjcmlwdG9yLiBJbiBzdWNoIGEgY2FzZSwgdGhlICJUWCBVU0VEIEJJVCBSRUFE
IiBpbnRlcnJ1cHQgaXMgYXNzZXJ0ZWQuDQo+Pj4+IEdFTS9NQUNCIHVzZXIgZ3VpZGUgc3BlY2lm
aWVzIHRoYXQgaWYgYSAiVFggVVNFRCBCSVQgUkVBRCIgaW50ZXJydXB0DQo+Pj4+IGlzIGFzc2Vy
dGVkIFRYIG11c3QgYmUgcmVzdGFydGVkLiBSZXN0YXJ0IFRYIGlmIHVzZWQgYml0IGlzIHJlYWQg
YW5kDQo+Pj4+IHBhY2tldHMgYXJlIHByZXNlbnQgaW4gc29mdHdhcmUgVFggcXVldWUuIFBhY2tl
dHMgYXJlIHJlbW92ZWQgZnJvbQ0KPj4+PiBzb2Z0d2FyZQ0KPj4+PiBUWCBxdWV1ZSBpZiBUWCB3
YXMgc3VjY2Vzc2Z1bCBmb3IgdGhlbSAoc2VlIG1hY2JfdHhfaW50ZXJydXB0KCkpLg0KPj4+Pg0K
Pj4+PiBTaWduZWQtb2ZmLWJ5OiBDbGF1ZGl1IEJlem5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9j
aGlwLmNvbT4NCj4+Pg0KPj4+IE9uIFhpbGlueCBaeW5xIHRoZSBhYm92ZSBjaGFuZ2UgY2FuIGNh
dXNlIGluZmluaXRlIGludGVycnVwdCBsb29wIGxlYWRpbmcNCj4+PiB0byBDUFUgc3RhbGwuIFNl
ZW1zIHRpbWluZy9sb2FkIG5lZWRzIHRvIGJlIGFwcHJvcHJpYXRlIGZvciB0aGlzIHRvIGhhcHBl
biwNCj4+PiBhbmQgY3VycmVudGx5DQo+Pj4gd2l0aCAxRyBldGhlcm5ldCB0aGlzIGNhbiBiZSB0
cmlnZ2VyZWQgbm9ybWFsbHkgd2l0aGluIG1pbnV0ZXMgd2hlbiBydW5uaW5nDQo+Pj4gc3RyZXNz
IHRlc3RzDQo+Pj4gb24gdGhlIG5ldHdvcmsgaW50ZXJmYWNlLg0KPj4+DQo+Pj4gVGhlIGV2ZW50
cyBsZWFkaW5nIHVwIHRvIHRoZSBpbnRlcnJ1cHQgbG9vcGluZyBhcmUgc2ltaWxhciBhcyB0aGUg
aXNzdWUNCj4+PiBkZXNjcmliZWQgaW4gdGhlDQo+Pj4gY29tbWl0IG1lc3NhZ2UuIEhvd2V2ZXIg
aW4gb3VyIGNhc2UsIHJlc3RhcnRpbmcgVFggZG9lcyBub3QgaGVscCBhdCBhbGwuDQo+Pj4gSW5z
dGVhZA0KPj4+IHRoZSBjb250cm9sbGVyIGlzIHN0dWNrIG9uIHRoZSBxdWV1ZSBlbmQgZGVzY3Jp
cHRvciBnZW5lcmF0aW5nIGVuZGxlc3MNCj4+PiBUWF9VU0VEDQo+Pj4gaW50ZXJydXB0cywgbmV2
ZXIgYnJlYWtpbmcgb3V0IG9mIGludGVycnVwdCByb3V0aW5lLg0KPj4+DQo+Pj4gQW55IGNoYW5j
ZSB5b3UgcmVtZW1iZXIgbW9yZSBkZXRhaWxzIGFib3V0IGluIHdoaWNoIHNpdHVhdGlvbiByZXN0
YXJ0aW5nIFRYDQo+Pj4gaGVscGVkIGZvcg0KPj4+IHlvdXIgdXNlIGNhc2U/IHdhcyB0eF9xYmFy
IGF0IHRoZSBlbmQgb2YgZnJhbWUgb3Igc3RvcHBlZCBpbiBtaWRkbGUgb2YNCj4+PiBmcmFtZT8N
Cg0KSSBsb29rIHRob3VnaCBteSBlbWFpbHMgZm9yIHRoaXMgcGFydGljdWxhciBpc3N1ZSwgZGlk
bid0IGZpbmQgYWxsIHRoYXQgSQ0KbmVlZCB3aXRoIHJlZ2FyZHMgdG8gdGhlIGlzc3VlIHRoYXQg
bGVhZHMgdG8gdGhpcyBmaXgsIGJ1dCB3aGF0IGNhbiBJIHRlbGwNCmZyb20gbXkgbWluZCBhbmQg
c29tZSBlbWFpbHMgc3RpbGwgaW4gbXkgaW5ib3ggaXMgdGhhdCB0aGlzIGlzc3VlIGhhZCBiZWVu
DQpyZXByb2R1Y2VkIGF0IHRoYXQgdGltZSBvbmx5IHdpdGggYSBwYXJ0aWN1bGFyIHdlIHNlcnZl
ciBydW5uaW5nIG9uIFNBTUE1RDQNCmFuZCBhdCBzb21lIHBvaW50IGEgcGFja2V0IHN0b3BwZWQg
YmVpbmcgdHJhbnNtaXR0ZWQgYWx0aG91Z2ggVFhfU1RBUlQgaGFkDQpiZWVuIGlzc3VlZCBmb3Ig
aXQuIEluIHRoYXQgY2FzZSB0aGUgY29udHJvbGxlciBmaXJlZCBUWCBVc2VkIGJpdCByZWFkDQpp
bnRlcnJ1cHQuDQoNClRoZSBHRU0gZGF0YXNoZWV0IHNwZWNpZmllcyB0aGlzICJUcmFuc21pdCBp
cyBoYWx0ZWQgd2hlbiBhIGJ1ZmZlcg0KZGVzY3JpcHRvciB3aXRoIGl0cyB1c2VkIGJpdCBzZXQg
aXMgcmVhZCwgYSB0cmFuc21pdCBlcnJvciBvY2N1cnMsIG9yIGJ5DQp3cml0aW5nIHRvIHRoZSB0
cmFuc21pdCBoYWx0IGJpdCBvZiB0aGUgbmV0d29yayBjb250cm9sIHJlZ2lzdGVyIg0KDQpBbHNv
LCBhdCB0aGF0IHBvaW50IGhhZCBhIHN1cHBvcnQgY2FzZSBvcGVuIG9uIENhZGVuY2UgYW5kIHRo
ZXkgY29uZmlybQ0KdGhhdCBoYXZpbmcgVFggcmVzdGFydGVkIGlzIHRoZSBnb29kIHdheS4NCg0K
QXQgdGhlIHRpbWUgb2YgaW52ZXN0aWdhdGluZyB0aGUgaXNzdWUgSSBvbmx5IGZvdW5kIGl0IHJl
cHJvZHVjaWJsZSBvbmx5IG9uDQpvbmUgU29DIChTQU1BNUQ0KSBvdXQgb2YgNCAoU0FNQTVEMiwg
U0FNQTVEMyBhbmQgb25lIEFSTTkyNiBiYXNlZCBTb0MpLiBBbGwNCnRoZXNlIGFyZSBwcm9iYWJs
eSBsZXNzIGZhc3RlciB0aGFuIFp5bnFNUC4NCg0KVGhvdWdoIHRoaXMgSVAgaXMgdG9kYXkgcHJl
c2VudCBhbHNvIG9uIFNBTUE3RzUgd2hvJ3MgQ1BVIGNhbiBydW4gQDFHSHogYW5kDQpNQUMgSVAg
YmVpbmcgY2xvY2tlZCBAMjAwTUh6LiBFdmVuIGluIHRoaXMgbGFzdCBzZXR1cCBJIGhhdmVuJ3Qg
c2F3IHRoZQ0KYmVoYXZpb3Igd2l0aCB1c2VkIGJpdCByZWFkIGJlaW5nIGZpcmVkIHRvbyBvZnRl
bi4NCg0KQnkgYW55IGNoYW5jZSBvbiB5b3VyIHNldHVwIGRvIHlvdSBoYXZlIHNtYWxsIHBhY2tl
dHMgaW5zZXJ0ZWQgaW4gTUFDQg0KcXVldWVzIGF0IGhpZ2ggcmF0ZT8NCg0KPj4NCj4+IFdoaWNo
IGtlcm5lbCB2ZXJzaW9uIGFyZSB5b3UgdXNpbmc/IFJvYmVydCBoYXMgYmVlbiB3b3JraW5nIG9u
IG1hY2IgKw0KPj4gWnlucSByZWNlbnRseSwgYWRkaW5nIGhpbSB0byBDQy4NCj4gDQo+IFdlIGhh
dmUgYmVlbiB3b3JraW5nIHdpdGggWnlucU1QIGFuZCBoYXZlbid0IHNlZW4gc3VjaCBpc3NlcyBp
biB0aGUgcGFzdCwgYnV0DQo+IEknbSBub3Qgc3VyZSB3ZSd2ZSB0cmllZCB0aGUgc2FtZSB0eXBl
IG9mIHN0cmVzcyB0ZXN0IG9uIHRob3NlIGludGVyZmFjZXMuIElmDQo+IGJ5IFp5bnEsIFRvbWFz
IG1lYW5zIHRoZSBaeW5xLTcwMDAgc2VyaWVzLCB0aGF0IG1pZ2h0IGJlIGEgZGlmZmVyZW50DQo+
IHZlcnNpb24vcmV2aXNpb24gb2YgdGhlIElQIGNvcmUgdGhhbiB3ZSBoYXZlIGFzIHdlbGwuDQo+
IA0KPiBJIGhhdmVuJ3QgbG9va2VkIGF0IHRoZSBUWCByaW5nIGRlc2NyaXB0b3IgYW5kIHJlZ2lz
dGVyIHNldHVwIG9uIHRoaXMgY29yZSBpbg0KPiB0aGF0IG11Y2ggZGV0YWlsLCBidXQgdGhlIGZh
Y3QgdGhlIGNvbnRyb2xsZXIgZ2V0cyBpbnRvIHRoaXMgIlRYIHVzZWQgYml0IHJlYWQiDQo+IHN0
YXRlIGluIHRoZSBmaXJzdCBwbGFjZSBzZWVtcyB1bnVzdWFsLiBJJ20gd29uZGVyaW5nIGlmIHNv
bWV0aGluZyBpcyBiZWluZw0KPiBkb25lIGluIHRoZSB3cm9uZyBvcmRlciBvciBpZiB3ZSBhcmUg
bWlzc2luZyBhIG1lbW9yeSBiYXJyaWVyIGV0Yz8NCg0KVGhhdCBtaWdodCBwb3NzaWJsZSBlc3Bl
Y2lhbGx5IG9uIGRlc2NyaXB0b3JzIHVwZGF0ZSBwYXRoLg0KDQo+IA0KPiAtLQ0KPiBSb2JlcnQg
SGFuY29jaw0KPiBTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNo
bm9sb2dpZXMNCj4gd3d3LmNhbGlhbi5jb20NCg0K
