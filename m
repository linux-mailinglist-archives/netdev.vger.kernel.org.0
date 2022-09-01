Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625415A92AC
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbiIAJEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234541AbiIAJDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:03:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB6677571;
        Thu,  1 Sep 2022 02:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662022978; x=1693558978;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=b0aWKTnIdLvw/XNXLk6tb7tCfeGka2Z80JCCrJhLCOE=;
  b=NM3xLR2kGWmZCj8rHSkHffEmf0TGDK0ZG0aQS6908jH/OmOPR6lG+0DT
   BKlyxjRvMvl9TxMS+c8jcaROfidjK4Jlcc499tm84S2IB80ZRkpKkwnEi
   1wpygJugrikiobjneKnmQsbFbFtPlO57pACmbl5eZpCqLpT0itqDQAdod
   4Z5gzHO6nrJqhhKNr/VmfRS4fRWLhtQQLDL/uqXRhq0aBwpPfz+Fwm9+k
   cdu5Ll1NEfXQgTPu+WbY/pnAbFy9ZKBVhr6Pnx4EsSmU4+OwFIVvhkW99
   YO0a837T750zYucMVJNCYjWPsl+vddIUHlpXsNveWZAZ3E1XTTTMVgFfm
   A==;
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="111713921"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Sep 2022 02:02:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Sep 2022 02:02:56 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Thu, 1 Sep 2022 02:02:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9HOPRjVqxr1dcA4EbGgMNX0Yw9SnUecarhwMt7OI3yMILl4FiQYSwj5gQ/THBghZE4qLKMMwGu9UX3QJP7wwAmKyuRpMd6UoOr9H+KykgdZK5Hps2EV5Bof1VPTVyFCXJWxP12UhP/bgTpHyMDcg2JJ53fpjEcM8xBsn+XE3Q3OxhsG1edcaT/pgkcH9KGO/g2vFyH1kXOQbgHx8lf8Y8TvwWucFWbjKiZrfpSFHZ9nOnmvDRRFMaikaztqZXTx3zYOIjSL7j4CJUi/0Mbrgz7UjNE3qrjxmh211qie4wQvU1LkTWN74nPVSMRp9LYR0DUqYhAyiHTGLKvUFJLILQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0aWKTnIdLvw/XNXLk6tb7tCfeGka2Z80JCCrJhLCOE=;
 b=dW5xcitFf6M00RTc6bgRjPRSKNQqq4i0MKcHw/YQTa240oK+BacwrWbmRwUNfrS8D60+F8mHMSr0rp1JJUsy5F4wfilLhu4hrOEawig+LQDH1X4a8Q0TpLpqJm8WgjppV8HVzA+tDT04jJmgJKl+CZLZ3F46VSvgmAyiYZEDDMhpQFXomccH/RufnrTZwCBWxaJlPKCzQiegQ08Ju117q66BW7Po6CEnpPwGqXCOyFRL5XtRgiD6WngrPUpOCP/yy6F5Ebf1PHVP/Z+QgsOZnLkNj4shtmTfOKumdsgSe6a05cBt0ugWuj3Ki0vefeBGzWgCYFu+oIO3OuE/daRGiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0aWKTnIdLvw/XNXLk6tb7tCfeGka2Z80JCCrJhLCOE=;
 b=tP4mA2yynLqP0thnC17V7Mosl9HCnSSX0a1dLgrKyDd7t/NZLCxPbyfiAeMEhFVHOT4gdm6QYiewSgc9kvb2XudbMAxlsWk8aM9Uu/kFUEyb5DTyneF1NuWaZVwkvqTc+Y4cg6guC9xX2nlFFCvux4Gids8fIHVbklWAyd3jGEw=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM5PR11MB0025.namprd11.prod.outlook.com (2603:10b6:4:63::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Thu, 1 Sep 2022 09:02:51 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::e828:494f:9b09:6bb5]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::e828:494f:9b09:6bb5%7]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 09:02:51 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>
CC:     <olteanv@gmail.com>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v3 3/3] net: dsa: microchip: lan937x: add
 interrupt support for port phy link
Thread-Topic: [RFC Patch net-next v3 3/3] net: dsa: microchip: lan937x: add
 interrupt support for port phy link
Thread-Index: AQHYvF7LrIdA+cmI5UCOkSyIPcREY63Hb0oAgALbMoA=
Date:   Thu, 1 Sep 2022 09:02:51 +0000
Message-ID: <bd7fcde507f47b22f9a4140bb26b91d9bb7e1662.camel@microchip.com>
References: <20220830105303.22067-1-arun.ramadoss@microchip.com>
         <20220830105303.22067-4-arun.ramadoss@microchip.com>
         <Yw4P3OJgtTtmgBHN@lunn.ch>
In-Reply-To: <Yw4P3OJgtTtmgBHN@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c70378c-fc14-4c04-2018-08da8bf8c019
x-ms-traffictypediagnostic: DM5PR11MB0025:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bt/OwpMBEAavAbWEVeJMm/iMpuFjPyQ4dfG6QaPLrcVpXbdxIiUeYdst5bLDMCZFrL9aULx9OR/fG5YQ3FFu0t4E5o7qDFverRjvyXK3wbKcJ2+A9aV2utNev1zVgCAup2Snswoq+KRhe6EQ9YLathD4OYTXFlOoJlJ97aGYIoiwThIp5NoIz74YXwKcTw1wy9FiQAPEHFi1GQ2P5szfCxojnZyu8AW+FXL6ZuybcR7KKLD376WuFPwuYZn5RUbr0Kgp+SsY17C4Glc9mxPfwQZ4MlmVA+m484B8RY/Mzl/xbM/6YT6kSmt31OM17ZvgrQqEim9t/yJmX3NKkned9oqASPYP64qA6F2fVjinB6DzNL2VC2M5F5HPBT9t+KNWQ2AIUf/UOJWex95fBGGv43ePzu+Oi+jNKAwoSfCSMUhQZt2KM/bQpyDQmFHwznQO/c64dJG+i6BAT1Tji9rTBSE5OmVauoNRCUQWk5lGEEjb1Txwc/YjIyuDmNMHpqDk8/fHzc0JBEjuYMpXNpENmmsHCzSdLAQ2hyXJzP0WWrbgeezVF0bXoAcWbphZqL0gi17lZvcR2xg2DvxR3w9tfqrLKEvThPNU367KcSsPhukQLb0g98iNK+TKsAyFB9gruIfDcl+4hq0nCsHgnkT1W7MrOfw9cR03fuYg1S6d+e2Lg6zPb9gZT/FkaH3zM6oEH0cZwP3QKJ6ZbD0mWezkZc7w8fL5fo/02NLBSTbn6CtMdusQ3FGAG5c7KRHMayCTZ+JOnalxR1Ws3tjAqTezs+LMlg1DQRkvueBCcYFIXJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(396003)(136003)(366004)(376002)(66556008)(2906002)(6486002)(66946007)(64756008)(66446008)(76116006)(91956017)(478600001)(316002)(66476007)(54906003)(6916009)(4326008)(8676002)(5660300002)(7416002)(8936002)(122000001)(38100700002)(36756003)(86362001)(38070700005)(2616005)(186003)(6506007)(6512007)(26005)(83380400001)(71200400001)(41300700001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rm1kSElPU3c3cXFUVVFxdUl0eTdCb3UxRnlxUW9vb1I4WUE2eEZydW5TMU9i?=
 =?utf-8?B?K1phbkpvK3E3NndsSlVvUENFVGtLdVh3U3h3aHoxTnhndFRpSlR2MGpmc2Rv?=
 =?utf-8?B?bFVFTktmMHpMWVVzTFZSSll0aXVqb3BqNmxBcVdkemY3MXdRL2taZEJOSVhN?=
 =?utf-8?B?eTBrd2E3ZVM0RjFNYUkyZ2tGUWUvaGJQdmJpV2ovTlFSM3dnRGF1NjVXTTc0?=
 =?utf-8?B?c1k0bE9YZUo4ODhuVmQxK2VHSW9qVjM5b2dibmFuQ1Zrb2k2dmVRVlpFRGV0?=
 =?utf-8?B?RElyK1hab2JJRTc1czIzOUdlTEkvTVBOOFRSRUErb1lzdUZnRmQxSDdLbGNr?=
 =?utf-8?B?eFNjamwzVldvWXRNeTR3UU1YZGNvbHV6bkVINWJVVnBaM3AwWkgycTVaaytx?=
 =?utf-8?B?UTBiMFc4dVB4d1doSEZnNVpuUlNkWlVXWXdWV1kvTWIwREFvOFVDSHB0ZklJ?=
 =?utf-8?B?TWxxSk53V0REWkJpSlcxMmJZZUdBT3ZUTGovU2ZaNFlTdVA5c2ZJcTVxOHha?=
 =?utf-8?B?c3RhY1ZWQlErUTc3Q21jMUxBQmRISWlTbnZzUU9IZHpObzRGSTR2RURncEJt?=
 =?utf-8?B?V3d3VElqSC9LditzS0hwaEtZVzdTMHFSOWtlMVFLLzZVWGJiOW9BY09xVGNJ?=
 =?utf-8?B?elZRdVI2dVZmOXhFVGRDYk5wVVpCUThHeWc3dXZLd3dPWFlvd2NlWWhmZEhW?=
 =?utf-8?B?SE1jbkY2ZHljcVVOSXk3clk5L1pUaG9nZDdNRFhob3d2UTBMZG5iTnE4K0Vv?=
 =?utf-8?B?SCs4MnkvNWRpS0xCejNONVhqanN6aFdjT1pWRFBOUUljUXc4SjFlc1J4ZlF6?=
 =?utf-8?B?YnNKZW8vTFNMVDFTblZCL2lGbDYxMHRsRnZDcE5JdVBoYjJBVDY5cVJhb0hO?=
 =?utf-8?B?ZERySTZ5L1pDQmkyMUhhTzQyYzcwQ25BUzNJa0wwZFBEUGEwQ1YyNW9SKzI4?=
 =?utf-8?B?VDVFNW1vUloxUnFFS09Fck1qQlBUdE1tc2tFVUtMYkJoZ3BzV1lvWjQ4ZTIv?=
 =?utf-8?B?Sk0rR1ozOHhaOUp5WW8yQlRNS1dKMmZqa3VrZHFXM2FKdndLcEtUYUFhYk9z?=
 =?utf-8?B?R2xKbVlxd2Mybyt4R1B3Vm9ISHV3M29EWDhiMVpaQVdPNnQ3a2UyZlU5VGhK?=
 =?utf-8?B?OGhmY2VBdm9FWEp2ZlNQQm5jNDZFTW5tdHRQU1craFJocjdaQWNGb25IR2o5?=
 =?utf-8?B?VGowRFp6L1VLNXpzTG1nRlYyOXcwZ0FkeUV5WXE2cG9DUWpBc3NqaHVjMnhL?=
 =?utf-8?B?RVk2ZlBFR0JMRHNCVEJjcXZyK2NlUWxVazIvR2pQVjRpWlZ3NFNBenEzemYw?=
 =?utf-8?B?SlRZTEtUK2FYbThKYTREWk0zdFBlbVpIUVlmRnRySUVuY2hnYnJjOTRPejl0?=
 =?utf-8?B?bnVVdERIRUhid2Y3ZkJlcms5emVJSGlzdCtrS2V6RzZkZnYzQStSbnp3TjZo?=
 =?utf-8?B?WmpiTUErYU0zS0lQcnZWRmUzeHp5a0lBb3I4QW5HcmJwdFBpRFR0aDQ1REpx?=
 =?utf-8?B?alJEekN4SjFqL2sxOU96K2NpTWE1WjR4aE9SN1hXVWdJZXRWQitVQnhkNU5D?=
 =?utf-8?B?MzhPNXpRRzhDRXU2S0FrSnhHNjRUZi9Qei85ZWFia1lYU2hwMkpoYnB1OWxl?=
 =?utf-8?B?QTJIVFgvSDhuSGxsTS9xbFdCRjdia1lKKzRCOU83Ry9SZ1RMeEFkWjN5NWRW?=
 =?utf-8?B?MkJzZ21FN291RFVvVmJNdG9wZko2OGREMzI3cnJ4S2RxaTdrMDdONjkzSGRI?=
 =?utf-8?B?SXp1Q3ZPZWhoZysxbDJMY0FmbG1vVy9yUThVSU43QUhSTjZFV3diY0FrVnUr?=
 =?utf-8?B?TFNzaVJGcGZIL09mck1QZjhwTUUvWWNmZnBNeURSMktza0lncHdVU1VHOHQz?=
 =?utf-8?B?Q2NtMUQ1R0luaUNtRzM3am01Nm9aeUhqeTFvYVJiVjJpS3FYZW9TZlBXRCt6?=
 =?utf-8?B?L1hkSGplSUl3ZHRSUGJ6N3I0YStZVWxEZnYvbE9ha0U2RTRJY3hBY0JZVnpN?=
 =?utf-8?B?a2RiSkNuc3Q2eUphR3E1UmtZdzBOV255WTVoRkhMbDRaWjdibW5BNGJWQjlT?=
 =?utf-8?B?dXNVMU9DVlpLNC9uOUYrY2M5QnNlS1dMSlNxUkxWWWxiM2hkenhwb2R0Tzgy?=
 =?utf-8?B?ZnFwaUVQY3RTQVNvYUpiazd3K21xWlN3blBERGRXRlVTYUVTbUtyQWZIQ25Y?=
 =?utf-8?Q?Bhm8cl89iU6/o8MPgLPHtd4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9921C53FD66FB46A3AE225422AE1E1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c70378c-fc14-4c04-2018-08da8bf8c019
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 09:02:51.7056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +zQsEVd++uFxU1YH4ZiIcRqTNQa1+fUvoiLORCrIKCz4GD/susiGw2TdU9P1etp2rb6/P373nBCEkEK1zcyq1xZvAHv7gTHwX3A8qZLADNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0025
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBUdWUsIDIwMjItMDgtMzAgYXQgMTU6MjUgKzAyMDAsIEFuZHJldyBMdW5uIHdyb3RlOg0K
PiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMg
dW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+ID4gQEAgLTg1LDYg
Kzk0LDcgQEAgc3RydWN0IGtzel9wb3J0IHsNCj4gPiAgICAgICB1MzIgcmdtaWlfdHhfdmFsOw0K
PiA+ICAgICAgIHUzMiByZ21paV9yeF92YWw7DQo+ID4gICAgICAgc3RydWN0IGtzel9kZXZpY2Ug
Kmtzel9kZXY7DQo+ID4gKyAgICAgc3RydWN0IGtzel9pcnEgaXJxOw0KPiANCj4gSGVyZSBpcnEg
aXMgb2YgdHlwZSBrc3pfaXJxLg0KPiANCj4gPiAgICAgICB1OCBudW07DQo+ID4gIH07DQo+ID4g
DQo+ID4gQEAgLTEwMyw2ICsxMTMsNyBAQCBzdHJ1Y3Qga3N6X2RldmljZSB7DQo+ID4gICAgICAg
c3RydWN0IHJlZ21hcCAqcmVnbWFwWzNdOw0KPiA+IA0KPiA+ICAgICAgIHZvaWQgKnByaXY7DQo+
ID4gKyAgICAgaW50IGlycTsNCj4gDQo+IEhlcmUgaXQgaXMgb2YgdHlwZSBpbnQuDQo+IA0KPiA+
IA0KPiA+ICAgICAgIHN0cnVjdCBncGlvX2Rlc2MgKnJlc2V0X2dwaW87ICAgLyogT3B0aW9uYWwg
cmVzZXQgR1BJTyAqLw0KPiA+IA0KPiA+IEBAIC0xMjQsNiArMTM1LDggQEAgc3RydWN0IGtzel9k
ZXZpY2Ugew0KPiA+ICAgICAgIHUxNiBtaXJyb3JfdHg7DQo+ID4gICAgICAgdTMyIGZlYXR1cmVz
OyAgICAgICAgICAgICAgICAgICAvKiBjaGlwIHNwZWNpZmljIGZlYXR1cmVzICovDQo+ID4gICAg
ICAgdTE2IHBvcnRfbWFzazsNCj4gPiArICAgICBzdHJ1Y3QgbXV0ZXggbG9ja19pcnE7ICAgICAg
ICAgIC8qIElSUSBBY2Nlc3MgKi8NCj4gPiArICAgICBzdHJ1Y3Qga3N6X2lycSBnaXJxOw0KPiAN
Cj4gQW5kIGhlcmUgeW91IGhhdmUgdGhlIHR5cGUga3N6X2lycSBjYWxsZWQgcWlycS4gVGhpcyBp
cyBnb2luZyB0byBiZQ0KPiBjb25mdXNpbmcuDQo+IA0KPiBJIHN1Z2dlc3QgeW91IG1ha2UgdGhl
IGZpcnN0IG9uZSBjYWxsZWQgcGlycSwgZm9yIHBvcnQsIGFuZCB0aGVuIHdlDQo+IGhhdmUgZ2ly
cSBmb3IgZ2xvYmFsLCBhbmQgaXJxIGlzIGp1c3QgYSBudW1iZXIuDQoNCk9rLiBJIHdpbGwgdXBk
YXRlIHZhcmlhYmxlIG5hbWVzIGFzIHBlciB0aGUgY29udGV4dCBpdCBpcyB1c2VkLg0KDQo+IA0K
PiA+ICBzdGF0aWMgaW50IGxhbjkzN3hfY2ZnKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIHUzMiBh
ZGRyLCB1OCBiaXRzLA0KPiA+IGJvb2wgc2V0KQ0KPiA+ICB7DQo+ID4gICAgICAgcmV0dXJuIHJl
Z21hcF91cGRhdGVfYml0cyhkZXYtPnJlZ21hcFswXSwgYWRkciwgYml0cywgc2V0ID8NCj4gPiBi
aXRzIDogMCk7DQo+ID4gQEAgLTE3MSw2ICsxNzUsNyBAQCBzdGF0aWMgaW50IGxhbjkzN3hfbWRp
b19yZWdpc3RlcihzdHJ1Y3QNCj4gPiBrc3pfZGV2aWNlICpkZXYpDQo+ID4gICAgICAgc3RydWN0
IGRldmljZV9ub2RlICptZGlvX25wOw0KPiA+ICAgICAgIHN0cnVjdCBtaWlfYnVzICpidXM7DQo+
ID4gICAgICAgaW50IHJldDsNCj4gPiArICAgICBpbnQgcDsNCj4gPiANCj4gPiAgICAgICBtZGlv
X25wID0gb2ZfZ2V0X2NoaWxkX2J5X25hbWUoZGV2LT5kZXYtPm9mX25vZGUsICJtZGlvIik7DQo+
ID4gICAgICAgaWYgKCFtZGlvX25wKSB7DQo+ID4gQEAgLTE5NCw2ICsxOTksMTYgQEAgc3RhdGlj
IGludCBsYW45Mzd4X21kaW9fcmVnaXN0ZXIoc3RydWN0DQo+ID4ga3N6X2RldmljZSAqZGV2KQ0K
PiA+IA0KPiA+ICAgICAgIGRzLT5zbGF2ZV9taWlfYnVzID0gYnVzOw0KPiA+IA0KPiA+ICsgICAg
IGZvciAocCA9IDA7IHAgPCBLU1pfTUFYX05VTV9QT1JUUzsgcCsrKSB7DQo+ID4gKyAgICAgICAg
ICAgICBpZiAoQklUKHApICYgZHMtPnBoeXNfbWlpX21hc2spIHsNCj4gPiArICAgICAgICAgICAg
ICAgICAgICAgdW5zaWduZWQgaW50IGlycTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgIGlycSA9IGlycV9maW5kX21hcHBpbmcoZGV2LQ0KPiA+ID5wb3J0c1twXS5pcnEuZG9tYWlu
LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBPUlRf
U1JDX1BIWV9JTlQpOw0KPiANCj4gVGhpcyBjb3VsZCByZXR1cm4gYW4gZXJyb3IgY29kZS4gWW91
IHJlYWxseSBzaG91bGQgY2hlY2sgZm9yIGl0LCB0aGUNCj4gaXJxIHN1YnN5c3RlbSBpcyBub3Qg
Z29pbmcgdG8gYmUgaGFwcHkgd2l0aCBhIG5lZ2F0aXZlIGlycSBudW1iZXIuDQoNCk9rLiBJIHdp
bGwgY2hlY2sgdGhlIHJldHVybiB2YWx1ZSBmb3IgaXJxX2ZpbmRfbWFwcGluZy4NCg0KPiANCj4g
PiArICAgICAgICAgICAgICAgICAgICAgZHMtPnNsYXZlX21paV9idXMtPmlycVtwXSA9IGlycTsN
Cj4gPiArICAgICAgICAgICAgIH0NCj4gPiArICAgICB9DQo+ID4gKw0KPiA+ICAgICAgIHJldCA9
IGRldm1fb2ZfbWRpb2J1c19yZWdpc3Rlcihkcy0+ZGV2LCBidXMsIG1kaW9fbnApOw0KPiA+ICAg
ICAgIGlmIChyZXQpIHsNCj4gPiAgICAgICAgICAgICAgIGRldl9lcnIoZHMtPmRldiwgInVuYWJs
ZSB0byByZWdpc3RlciBNRElPIGJ1cyAlc1xuIiwNCj4gDQo+IEkgZG9uJ3Qgc2VlIGFueXdoZXJl
IHlvdSBkZXN0cm95IHRoZSBtYXBwaW5ncyB5b3UgY3JlYXRlZCBhYm92ZSB3aGVuDQo+IHRoZSBN
RElPIGJ1cyBpcyB1bnJlZ2lzdGVyZWQuIFRoZSBlcXVpdmFsZW50IG9mDQo+IG12ODhlNnh4eF9n
Ml9pcnFfbWRpb19mcmVlKCkuDQoNCkkgbWlzc2VkIHRvIGRlc3Ryb3kgaXQuIEkgd2lsbCBhZGQu
DQoNCj4gDQo+IA0KPiA+ICtzdGF0aWMgaXJxcmV0dXJuX3QgbGFuOTM3eF9naXJxX3RocmVhZF9m
bihpbnQgaXJxLCB2b2lkICpkZXZfaWQpDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3Qga3N6X2Rl
dmljZSAqZGV2ID0gZGV2X2lkOw0KPiA+ICsgICAgIHVuc2lnbmVkIGludCBuaGFuZGxlZCA9IDA7
DQo+ID4gKyAgICAgdW5zaWduZWQgaW50IHN1Yl9pcnE7DQo+ID4gKyAgICAgdW5zaWduZWQgaW50
IG47DQo+ID4gKyAgICAgdTMyIGRhdGE7DQo+ID4gKyAgICAgaW50IHJldDsNCj4gPiArDQo+ID4g
KyAgICAgcmV0ID0ga3N6X3JlYWQzMihkZXYsIFJFR19TV19JTlRfU1RBVFVTX180LCAmZGF0YSk7
DQo+ID4gKyAgICAgaWYgKHJldCkNCj4gPiArICAgICAgICAgICAgIGdvdG8gb3V0Ow0KPiA+ICsN
Cj4gPiArICAgICBpZiAoZGF0YSAmIFBPUl9SRUFEWV9JTlQpIHsNCj4gPiArICAgICAgICAgICAg
IHJldCA9IGtzel93cml0ZTMyKGRldiwgUkVHX1NXX0lOVF9TVEFUVVNfXzQsDQo+ID4gUE9SX1JF
QURZX0lOVCk7DQo+ID4gKyAgICAgICAgICAgICBpZiAocmV0KQ0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICBnb3RvIG91dDsNCj4gPiArICAgICB9DQo+IA0KPiBXaGF0IGRvIHRoZXNlIHR3byBy
ZWFkL3dyaXRlcyBkbz8gSXQgc2VlbXMgbGlrZSB5b3UgYXJlIGRpc2NhcmRpbmcgYW4NCj4gaW50
ZXJydXB0Pw0KDQpUaGlzIGludGVycnVwdCBpbiBQb3dlciBvbiByZXNldCBpbnRlcnJ1cHQuIEl0
IGlzIGVuYWJsZWQgYnkgZGVmYXVsdCBpbg0KdGhlIGNoaXAuIEkgYW0gbm90IHBlcmZvcm1pbmcg
YW55IG9wZXJhdGlvbiBiYXNlZCBvbiBQT1IuIFNvIEkganVzdA0KY2xlYXJlZCB0aGUgaW50ZXJy
dXB0LiBEbyBJIG5lZWQgdG8gZGlzYWJsZSB0aGUgUE9SIGludGVycnVwdCBpbiB0aGUNCnNldHVw
IGZ1bmN0aW9uLCBzaW5jZSBubyBvcGVyYXRpb24gaXMgcGVyZm9ybWVkIGJhc2VkIG9uIGl0Pw0K
DQo+IA0KPiANCj4gPiArDQo+ID4gKyAgICAgLyogUmVhZCBnbG9iYWwgaW50ZXJydXB0IHN0YXR1
cyByZWdpc3RlciAqLw0KPiA+ICsgICAgIHJldCA9IGtzel9yZWFkMzIoZGV2LCBSRUdfU1dfUE9S
VF9JTlRfU1RBVFVTX180LCAmZGF0YSk7DQo+ID4gKyAgICAgaWYgKHJldCkNCj4gPiArICAgICAg
ICAgICAgIGdvdG8gb3V0Ow0KPiA+ICsNCj4gPiArICAgICBmb3IgKG4gPSAwOyBuIDwgZGV2LT5n
aXJxLm5pcnFzOyArK24pIHsNCj4gPiArICAgICAgICAgICAgIGlmIChkYXRhICYgKDEgPDwgbikp
IHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgc3ViX2lycSA9IGlycV9maW5kX21hcHBpbmco
ZGV2LT5naXJxLmRvbWFpbiwNCj4gPiBuKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgaGFu
ZGxlX25lc3RlZF9pcnEoc3ViX2lycSk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICsrbmhh
bmRsZWQ7DQo+ID4gKyAgICAgICAgICAgICB9DQo+ID4gKyAgICAgfQ0KPiA+ICtvdXQ6DQo+ID4g
KyAgICAgcmV0dXJuIChuaGFuZGxlZCA+IDAgPyBJUlFfSEFORExFRCA6IElSUV9OT05FKTsNCj4g
PiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlycXJldHVybl90IGxhbjkzN3hfcGlycV90aHJlYWRf
Zm4oaW50IGlycSwgdm9pZCAqZGV2X2lkKQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtzel9w
b3J0ICpwb3J0ID0gZGV2X2lkOw0KPiA+ICsgICAgIHVuc2lnbmVkIGludCBuaGFuZGxlZCA9IDA7
DQo+ID4gKyAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldjsNCj4gPiArICAgICB1bnNpZ25lZCBp
bnQgc3ViX2lycTsNCj4gPiArICAgICB1bnNpZ25lZCBpbnQgbjsNCj4gPiArICAgICB1OCBkYXRh
Ow0KPiA+ICsNCj4gPiArICAgICBkZXYgPSBwb3J0LT5rc3pfZGV2Ow0KPiA+ICsNCj4gPiArICAg
ICAvKiBSZWFkIGdsb2JhbCBpbnRlcnJ1cHQgc3RhdHVzIHJlZ2lzdGVyICovDQo+ID4gKyAgICAg
a3N6X3ByZWFkOChkZXYsIHBvcnQtPm51bSwgUkVHX1BPUlRfSU5UX1NUQVRVUywgJmRhdGEpOw0K
PiANCj4gSSB0aGluayBnbG9iYWwgaGVyZSBzaG91bGQgYmUgcG9ydD8NCg0KWWVzLiBDb3B5IHBh
c3RlIHByb2JsZW0uIEkgd2lsbCB1cGRhdGUgaXQuDQoNCj4gDQo+ID4gKw0KPiA+ICsgICAgIGZv
ciAobiA9IDA7IG4gPCBwb3J0LT5pcnEubmlycXM7ICsrbikgew0KPiA+ICsgICAgICAgICAgICAg
aWYgKGRhdGEgJiAoMSA8PCBuKSkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBzdWJfaXJx
ID0gaXJxX2ZpbmRfbWFwcGluZyhwb3J0LT5pcnEuZG9tYWluLA0KPiA+IG4pOw0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICBoYW5kbGVfbmVzdGVkX2lycShzdWJfaXJxKTsNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgKytuaGFuZGxlZDsNCj4gPiArICAgICAgICAgICAgIH0NCj4gPiArICAg
ICB9DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiAobmhhbmRsZWQgPiAwID8gSVJRX0hBTkRMRUQg
OiBJUlFfTk9ORSk7DQo+ID4gK30NCj4gPiArDQo+ID4gDQo+ID4gIHZvaWQgbGFuOTM3eF9zd2l0
Y2hfZXhpdChzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KQ0KPiA+ICB7DQo+ID4gKyAgICAgc3RydWN0
IGRzYV9wb3J0ICpkcDsNCj4gPiArDQo+ID4gICAgICAgbGFuOTM3eF9yZXNldF9zd2l0Y2goZGV2
KTsNCj4gPiArDQo+ID4gKyAgICAgaWYgKGRldi0+aXJxID4gMCkgew0KPiA+ICsgICAgICAgICAg
ICAgZHNhX3N3aXRjaF9mb3JfZWFjaF91c2VyX3BvcnQoZHAsIGRldi0+ZHMpIHsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgbGFuOTM3eF9waXJxX2ZyZWUoJmRldi0+cG9ydHNbZHAtPmluZGV4
XSwgZHAtDQo+ID4gPmluZGV4KTsNCj4gPiArICAgICAgICAgICAgIH0NCj4gPiArDQo+ID4gKyAg
ICAgICAgICAgICBsYW45Mzd4X2dpcnFfZnJlZShkZXYpOw0KPiANCj4gVGhpcyBpcyB3aGVyZSB5
b3VyIHByb2JsZW0gd2l0aCBleGl0IHZzIHJlc2V0IGlzIGNvbWluZyBmcm9tLiBZb3UNCj4gc2V0
dXAgYWxsIHRoZSBpbnRlcnJ1cHQgY29kZSBpbiBzZXR1cCgpLiBCdXQgY3VycmVudGx5IHRoZXJl
IGlzIG5vDQo+IGZ1bmN0aW9uIHdoaWNoIGlzIHRoZSBvcHBvc2l0ZSBvZiBzZXR1cCgpLiBHZW5l
cmFsbHksIGl0IGlzIGNhbGxlZA0KPiB0YWlyZG93bi4gQWRkIHN1Y2ggYSBmdW5jdGlvbi4NCg0K
WWVzIEkgd2FzIGxvb2tpbmcgZm9yIG9wcG9zaXRlIGZ1bmN0aW9uIGZvciBzZXR1cCgpLiBUaGFu
a3MgZm9yDQpzdWdnZXN0aW9uLCBJIHdpbGwgdXBkYXRlIHRoZSBjb2RlIGFjY29yZGluZ2x5IGFu
ZCByZW1vdmUgdGhlIHBhdGNoIDEvMw0KZnJvbSB0aGUgc2VyaWVzIHdoaWNoIHJlcGxhY2VzIHRo
ZSBleGl0IHdpdGggcmVzZXQuDQoNCj4gDQo+ICAgICAgICAgICBBbmRyZXcNCg==
