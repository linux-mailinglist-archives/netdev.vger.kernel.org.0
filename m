Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3006453CB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 07:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLGGAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 01:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLGGAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 01:00:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F385512619;
        Tue,  6 Dec 2022 22:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670392842; x=1701928842;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JkQVr2/rnBwoBBaRFlCE3P6igtjrgjaehdjq7hHMz4k=;
  b=rbZT6qN5ap6y/RYWCGJTHL+iqaAyADBdR95ZuwB+MwvdIIvSwY+iecF6
   8jeRLWFFXGPye+ahwFu0j2qMTPB3vbRLOjAsvUgd4JQxKUwTGM/skW6CP
   MI0cnaC7oG9BtLKiXnHztSRmkwmZ8z0XsZnnKej+Fp1Gm74sWicCNyQo4
   Yb3QQxUI24UZxRmG+zDacyuR6dIcWgO80367avjUihXRV2m/g8c/Z5Z+N
   qGrw/E2A+vLM9ieOqTVYGT4PzbQsthK2fY+cWWWfCleyYBGyfhbI1IEad
   961Fve6kZ7WFy7T3WHgKui8UGp68XjTnC7NVzGUPVrpwDCA3D+ReBNfbi
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="192020473"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 23:00:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 23:00:30 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 23:00:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/280G1IRn3ZseyVqUY5a6I3SkvB53aCHtvOwqUFRkvRzLN7QfgkMjBf9ptb1Dt9bRuD+fpw9wdegc+nKx0jPf4HqfQCp5OdXkdv63SIbeb4qK69cMX9bpiqhTUlL36Q6ALN5dFglFWSgAOICtLYbzRFQzxwGNV19SwUGMXTHMODp3ltJ4SHFf2J7raWeF26DdOUlT1IgwLR9yV02gBzw8cwxUvoOMnH4zbifOltmnRZAWWhOspEpT4Sg6u/GQ36tS+HYRXWuyBKGp49u8b4r2dsUpSPf85BqwAB43T/1FpeZNlU9j/joCTcDOWTjSFM1u6MqoTTI33kEREMiUPHQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkQVr2/rnBwoBBaRFlCE3P6igtjrgjaehdjq7hHMz4k=;
 b=RPBTCC5RjxxesPp0Czl10Ipsm6q2y42IgsF8QScH4HwokOVDdOHQ7Yv/QjvGrlBDSC9JQjPhA/0EzT+pyMJvrAZnRtBImtaJRa9AlMfd3cyw15cnTA747lCZOxDMpscXNu1RboMasOiYmNj6+Hw18NZyo1KDdcD03xtRUfJu9k3GjEnzDY68lZ6wI5iJ/opNvTNVhipWEGT0GZAhHUrgWJvlk/bl9aVe06aGuDbyUPUpw+d8lurFy21rVGnMJDjMS/+4gdoCa2i+2vgUjO/UwyQsNxEUrHvdEHljQTFCqqaNb5EeCtORwpgILzzRqk2KavSe+fiWKjsYGGMvednJ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkQVr2/rnBwoBBaRFlCE3P6igtjrgjaehdjq7hHMz4k=;
 b=afLuMheZgCTi8tNBPXZT7oLyLePCdsufIN7HD8hMbN1EFzJMSOLrP7X6MSUV8XAOIGeSF4jG8OPo1LwDYTRy/KfGA+D/5zHSKne+DulBpTT/DzDpKH0iXnr+lPaUq44XOGkoDbeMVnc+rR7ixV/B70mne1FFkrBL+rdQbBipUUs=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY8PR11MB7268.namprd11.prod.outlook.com (2603:10b6:930:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Wed, 7 Dec 2022 06:00:27 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 06:00:27 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <ceggers@arri.de>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net-next v2 07/13] net: dsa: microchip: ptp: add packet
 reception timestamping
Thread-Topic: [Patch net-next v2 07/13] net: dsa: microchip: ptp: add packet
 reception timestamping
Thread-Index: AQHZCVNycE/DHP/GtU+Et1WEm+Sbba5g0OQAgAEe2oA=
Date:   Wed, 7 Dec 2022 06:00:27 +0000
Message-ID: <148ee662f8def0e63b81d9164d2fd7c0f7029cf7.camel@microchip.com>
References: <20221206091428.28285-1-arun.ramadoss@microchip.com>
         <20221206091428.28285-8-arun.ramadoss@microchip.com>
         <20221206125344.rwheovbxdoad2duv@skbuf>
In-Reply-To: <20221206125344.rwheovbxdoad2duv@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|CY8PR11MB7268:EE_
x-ms-office365-filtering-correlation-id: 5bbd6dbc-00a4-4717-6282-08dad818570e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ka7V8lMhnDoK3knsWaROELRqSF6LcoCLIGfB490wt9rUXaxzhYDohsyRoSst2V9joTWKP4x5UYSE/yXPwqHLKXXpninAoVC0TyHhk+IY6xHmUtIiMCjY0Tg+7ClAIfSElPfUsKt/zxgvXpdDTW0KJTvlchoFkZKZM02AcStykVXtiPm66KsNRo09vSy7/d2utvSp3T31ryK0hVY0FV4SyVo4C/OypLTAPGSwpjDjhXtFYNSQV+NcCG7xmsiyZ53LcTvOABN7f/7TAkrvEfDtBwtjUYcY6RKzN4ehNRjf4dcbvg0xSmq8G1QnehFMPB19zNXlcjGHwAYAgUMmiI7dPCEMPRzyQX9s6759p8yzebjnJ+Y1u5DTNEpzLtdGlVFmNbOZsbCNdfWnYCtUuntbrx5c+euoXG21YET9S+HlKFAQTp1FQq/xNZzezBXByFPpidHXqzaTyoOltBv0hcL6HiXT2u12/HU3AtXQKpY+c9DdOy2Kz+9Hzf2pTRrdWWLbNT+Ww949O9fBi35odWrw1MgQ2uDUg/HlRSuloXKine7mW8X43n1AquRHcyl3JToSpYiYHDHHznK613iLtoAEWNU2onAA/RWB/LR0KwtrvgtbecDtypsf5Wn2Tz90VrAfxL0FXpUWAOMdrSKf5mFQg7htHyxXmfODjhqx45Ivg3orKWviLFn46fMFmtjD6KbNdMyH80n5xbhwdpuRcyX6Tt5rSvl3pbzTCx25Zy3IBCc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199015)(122000001)(83380400001)(6486002)(86362001)(8936002)(5660300002)(91956017)(2906002)(38070700005)(7416002)(4326008)(41300700001)(186003)(26005)(6506007)(64756008)(478600001)(6512007)(66946007)(2616005)(66556008)(6916009)(76116006)(66446008)(54906003)(66476007)(316002)(8676002)(38100700002)(71200400001)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1FxcHlRSUNvVS9nM29VN3FtQjRYZXB1MVpqN0xIckpyMzBYYlR5VUVXVWtq?=
 =?utf-8?B?clZLOTJEcTVjOTZpTVdFSE96SVlVODZJU0RDZllHWXRCQlVtbXN2U3NCbzJY?=
 =?utf-8?B?bE5aUVdOV29mQkRVeWV1MkZBOWdTTGxXWmxLWFBLNDFoWU9tbWxpSy9qU1VV?=
 =?utf-8?B?RTVPVG14RU9YOGNydm5CODVQMjN2NXFwZDNLeHVMeS9ZaVVGMklZdUJWcUU3?=
 =?utf-8?B?ZlRrVnhTR2l6NExKMHpCT2c1OVBUS3pPS0pwa1RLNFFGTEdKVTRRSUpoem5L?=
 =?utf-8?B?QlVkOXlzOVljZ2xMSmNoTjNncnBYSmh1dCsvVTZwUUVZcTI1ei9MWkVUZUR0?=
 =?utf-8?B?YmxwNm1KblBFaEZGL1g3NDFrZ29EcC9Fd1Jla1pKNEJ5NUNPeGJ4YXh6SU94?=
 =?utf-8?B?ejVxL1JDRnFMZVdIU2dmVmZkU2dFK2ZxbFg1ekJVLzBrdHJhZEtPcEQ0YTdZ?=
 =?utf-8?B?QTlWeHliUVlCdnM3cFFsNVFRQmh4OTY3cklTTUtTbTEzTGhlcGxyVUxQdjd1?=
 =?utf-8?B?YXBJSkFaS2VZRUo3aVhrQUw1Q1dKaVBPTzByZXFGVTREMmVtV3pVWVByNmxP?=
 =?utf-8?B?Wi8wV1JPb1hlOVY2NWpHZExVWXRwRFZnS21OdGptQ1V3aU9sazJwTitVZm9Y?=
 =?utf-8?B?dDNhT2ExdGdyYXZJaHpyTE95bVQvMzRKcGhRbWxrMEhUYVZjN0J0R2gxRjQr?=
 =?utf-8?B?QythaFpzeldNQm5KTzVwWEMwbnRITUZOSmpjclhnVnp6TjNRSm5iOTlXUU1x?=
 =?utf-8?B?d2ZOL1hQV1N2TndQRGl0Q3pLSDFHelZLUUpJSWpjbXk0VEQySDBURklkcFhN?=
 =?utf-8?B?SlFyM0tDWkFFOVZEZ29oTGVBbnp6OEpubE9tVWxDaGFvM04wQ1VrQXBsRGVH?=
 =?utf-8?B?WC9lWUV4Mi9rNGRSdE0wZE55NllocHBRMVprY1pEdmhYcEZ6VnBYemQ2emFq?=
 =?utf-8?B?aXgzVTRVYWhEVjk1RlR2eWVNTUlSaDNDcE5qV2dSVU9HMkJuM3R6dCsvNW9p?=
 =?utf-8?B?MUVQSzRsVC9rdW1kdWRraUFCTVpwZ1dyVm91V284eTFVeitQTS9WU3dTMFE1?=
 =?utf-8?B?YXhDNjJlK3Fib1M2RFRaYlpFaUFwQXJnck5SSS9aUk9NdzhpUVBIVUdYczFq?=
 =?utf-8?B?SVRXbER5Nmwxc0M1cHBUVFFzTWhBOHFQcENzODlQemFIaDVhSEdFaUZNMGhx?=
 =?utf-8?B?cy9oQXRtSnhDMW15WnV0V2RzQUQxajEveDV6emswWDVrMFNvK0ZqUktmaDUv?=
 =?utf-8?B?TUFSQTM2S0Y0WFZGelFObEdOSHJqeEgrNmdxaUdRNE16c2V0TktGZnc3MUUx?=
 =?utf-8?B?dS9pOHg2OStnd0E0UUZXOXRpVWVGemI5U0pRem5OZjBXSWVlWWNHZnNuQVNk?=
 =?utf-8?B?c3p6S0drNGhoenluS2JxbytFdmpyYUp0dytXclorL1kvVk5lNGFZRUI1dVVS?=
 =?utf-8?B?NkJhTlRUbVpQcmIvYWJtZGpmY2Q5c003WmhScHhFSnhVNjQ0eFJQQlFCaVZh?=
 =?utf-8?B?OFVMY3BHdXhQM3IvSVhtT3dac09YZ1EySXc3MXJ2WUxST0YyU0oxVk5pczBB?=
 =?utf-8?B?SW9MMEx2NllpL1B5UDBVaU5mUXFHMUIwWm1vb3dyMGx6Z1lVWjFVekVJeGZV?=
 =?utf-8?B?ZUxyV1V6S3ZteU0rdE9lTzZKdTRCdlh6UEswY3NyZWdDZ1JjRnptNTRiQnJC?=
 =?utf-8?B?WEp5aTlCb2dPeUU1RDZrVXV2TzBKV0hNREdZWW41QzljTms4SXo4Mmc5TTJr?=
 =?utf-8?B?dGdrSE93UWorbGJtR1hRazQ3YVEzRFFnNDliMFpVSk5QOHExVGdYTC9IdVB6?=
 =?utf-8?B?Y0xHT3Nsa0loaFVpcEYrNTNsVGhOL3pmeGp1ZG54bURvT2thNURGVnFDcTZx?=
 =?utf-8?B?aTBMaFlEU3hpV2pWeVFyTVFtOTBiV2puZEg0Rzl2MkhtUmprbm9xV3VJNDhF?=
 =?utf-8?B?M3hSTlo0WTUzV0d3UnJhQWF2UitOb1NBT1lQMnRkdW10QmE5MlRmcUxJenE2?=
 =?utf-8?B?UjU2Qis1MFZESWdnQkIvRmxTdkdCbHpZK0FPMEpHczY4ZDgvdk5QTndOZ1Ni?=
 =?utf-8?B?dmVLc20yaHRyZzRlTXkxU1BhSXVibUZJSjRXWiswcWVadm5QMEdGVDVPUXdI?=
 =?utf-8?B?WHlOMDZ1QVRPTDFEUXFPdUxHcGovWXVwUVIzS2psdG5TM0RlYURxbnE2cmRl?=
 =?utf-8?Q?727x32BKIsh9mK+dM5S+2Yo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C60B816B188BE0439A8FF878A776578E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bbd6dbc-00a4-4717-6282-08dad818570e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 06:00:27.7253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p48xxTILQridKh4xg9LGRIw0jbHTCPkAvRewWixk4cENln4HM2eHMwxKbRq0Y5pwZO2JQ5vxXk2eFI7odP7OT5iasW0uyWCytWE+eycfj3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7268
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSByZXZpZXcgY29tbWVudC4NCk9uIFR1ZSwgMjAy
Mi0xMi0wNiBhdCAxNDo1MyArMDIwMCwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIFR1ZSwgRGVjIDA2LCAyMDIy
IGF0IDAyOjQ0OjIyUE0gKzA1MzAsIEFydW4gUmFtYWRvc3Mgd3JvdGU6DQo+ID4gK3N0YXRpYyB2
b2lkIGtzel9yY3ZfdGltZXN0YW1wKHN0cnVjdCBza19idWZmICpza2IsIHU4ICp0YWcsDQo+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsIHVuc2ln
bmVkIGludA0KPiA+IHBvcnQpDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1Y3Qgc2tiX3NoYXJlZF9o
d3RzdGFtcHMgKmh3dHN0YW1wcyA9IHNrYl9od3RzdGFtcHMoc2tiKTsNCj4gPiArICAgICBzdHJ1
Y3QgZHNhX3N3aXRjaCAqZHMgPSBkZXYtPmRzYV9wdHItPmRzOw0KPiA+ICsgICAgIHU4ICp0c3Rh
bXBfcmF3ID0gdGFnIC0gS1NaX1BUUF9UQUdfTEVOOw0KPiA+ICsgICAgIHN0cnVjdCBrc3pfdGFn
Z2VyX2RhdGEgKnRhZ2dlcl9kYXRhOw0KPiA+ICsgICAgIHN0cnVjdCBwdHBfaGVhZGVyICpwdHBf
aGRyOw0KPiA+ICsgICAgIHVuc2lnbmVkIGludCBwdHBfdHlwZTsNCj4gPiArICAgICB1OCBwdHBf
bXNnX3R5cGU7DQo+ID4gKyAgICAga3RpbWVfdCB0c3RhbXA7DQo+ID4gKyAgICAgczY0IGNvcnJl
Y3Rpb247DQo+ID4gKw0KPiA+ICsgICAgIHRhZ2dlcl9kYXRhID0ga3N6X3RhZ2dlcl9kYXRhKGRz
KTsNCj4gPiArICAgICBpZiAoIXRhZ2dlcl9kYXRhLT5tZXRhX3RzdGFtcF9oYW5kbGVyKQ0KPiA+
ICsgICAgICAgICAgICAgcmV0dXJuOw0KPiANCj4gVGhlIG1ldGFfdHN0YW1wX2hhbmRsZXIgZG9l
c24ndCBzZWVtIHRvIGJlIG5lZWRlZC4NCj4gDQo+IEp1c3Qgc2F2ZSB0aGUgcGFydGlhbCB0aW1l
c3RhbXAgaW4gS1NaX1NLQl9DQigpLCBhbmQgcmVjb25zdHJ1Y3QgdGhhdA0KPiB0aW1lc3RhbXAg
d2l0aCB0aGUgZnVsbCBQVFAgdGltZSBpbiB0aGUgZHMtPm9wcy0+cG9ydF9yeHRzdGFtcCgpDQo+
IG1ldGhvZC4NCj4gDQo+IEJpZ2dlc3QgYWR2YW50YWdlIGlzIHRoYXQgcHRwX2NsYXNzaWZ5X3Jh
dygpIHdvbid0IGJlIGNhbGxlZCB0d2ljZSBpbg0KPiB0aGUgUlggcGF0aCBmb3IgdGhlIHNhbWUg
cGFja2V0LCBhcyB3aWxsIGN1cnJlbnRseSBoYXBwZW4gd2l0aCB5b3VyDQo+IGNvZGUuDQo+IA0K
DQpJIGxvb2tlZCBpbnRvIHRoZSBzamExMTA1IGFuZCBoZWxsY3JlZWsgcnh0c3RhbXAoKSBpbXBs
ZW1lbnRhdGlvbi4NCkhlcmUsIFNLQiBpcyBxdWV1ZWQgaW4gcnh0c3RhbXAoKSBhbmQgcHRwX3Nj
aGVkdWxlX3dvcmtlciBpcyBzdGFydGVkLg0KSW4gdGhlIHdvcmsgcXVldWUsIHNrYiBpcyBkZXF1
ZXVlZCBhbmQgY3VycmVudCBwdHAgaGFyZHdhcmUgY2xvY2sgaXMNCnJlYWQuIFVzaW5nIHRoZSBw
YXJ0aWFsIHRpbWUgc3RhbXAgYW5kIHBoYyBjbG9jaywgYWJzb2x1dGUgdGltZSBzdGFtcA0KaXMg
Y2FsY3VsYXRlZCBhbmQgcG9zdGVkLg0KSW4gdGhpcyBLU1ogaW1wbGVtZW50YXRpb24sIHB0cF9z
Y2hlZHVsZV93b3JrZXIgaXMgdXNlZCBmb3IgbWFpbnRhaW5pbmcNCnRoZSBwdHAgc29mdHdhcmUg
Y2xvY2sgd2hpY2ggcmVhZCB2YWx1ZSBmcm9tIGhhcmR3YXJlIGNsb2NrIGV2ZXJ5DQpzZWNvbmQg
Zm9yIGZhc3RlciBhY2Nlc3Mgb2YgY2xvY2sgdmFsdWUuDQoNCkJhc2VkIG9uIHRoZSBhYm92ZSBv
YnNlcnZhdGlvbiwgSSBoYXZlIGRvdWJ0IG9uIGhvdyB0byBpbXBsZW1lbnQuIEJlbG93DQphcmUg
dGhlIGFsZ29yaXRobS4gS2luZGx5IHN1Z2dlc3Qgd2hpY2ggb25lIHRvIHByb2NlZWQuDQoxLiBS
ZW1vdmUgdGhlIGV4aXN0aW5nIHB0cCBzb2Z0d2FyZSBjbG9jayBtYWlucHVsYXRpb24gdXNpbmcN
CnB0cF9zY2hlZHVsZV93b3JrZXIuIEluc3RlYWQgaW4gdGhlIHB0cF9zY2hlZHVsZV93b3JrZXIs
IGRlcXVldWUgdGhlDQpza2IgYW5kIHRpbWVzdGFtcCB0aGUgcnggcGFja2V0cyBieSBkaXJlY3Rs
eSByZWFkaW5nIGZyb20gdGhlIHB0cA0KaGFyZHdhcmUgY2xvY2suDQoyLiBLZWVwIHRoZSBleGlz
dGluZyBpbXBsZW1lbnRhdGlvbiwgYWRkIHRoZSByeHRzdGFtcCgpIHdoZXJlIGl0IHdpbGwNCm5v
dCBxdWV1ZSBza2IgaW5zdGVhZCBqdXN0IHByb2Nlc3MgdGhlIHRpbWVzdGFtcGluZyB3aXRoIHVz
aW5nIHNvZnR3YXJlDQpjbG9jayBhbmQgS1NaX1NLQl9DQigpLT50c3RhbXAuDQoNCg0KVGhhbmtz
DQpBcnVuIA0K
