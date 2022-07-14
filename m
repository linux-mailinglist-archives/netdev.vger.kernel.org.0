Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923DA574B0C
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbiGNKqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238459AbiGNKqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:46:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29E053D16
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657795578; x=1689331578;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EuH53wVtjA8btxOCGXocuJaDDNQUOdLeqTcp7wlv7jg=;
  b=tXZcJEiF31tT2gipmIiuyasXyCd84EKcSgvOPf7/Spe7W92PWzmwTC9w
   aNtr8j9Wyd0mgejnX5NgOwl2mA1bMGae9B6M8qT6ac4epy9/CQFAzh+F7
   WUqY0elREqc4w6lyAoBXU+M5V+ADa0n3v2RmfTV9Tjm71++q1NziMAaiT
   /NNnERqURvUSXu1YKSN3IH4ACRCz69mJjmDRmnH4E5h6auTY5YYsoCMyh
   58FTuMCkb5nryBrff4XtwpGSqWMjNSdztjZ1+YQ5sHNVKnICPZ+1+4mtU
   OngXFawdmcvQ7kLbG8uoYDdgog5BQ2Qz/T7jrEL3f3+UJkiUZyQgqWU1a
   w==;
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="104439672"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2022 03:46:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 14 Jul 2022 03:46:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Thu, 14 Jul 2022 03:46:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeJcjZPDNeJisXpO9zcMOjTUqtMeU4BzLTiTb3ySTtoUrVjckoz691gvwjWHe87O7Wd3zh8hHQG6GXQp19W0p8qxVOLgVS/SIFLcPtDZX+UhpI84qxXx2CNWpbuKSEDLpplj/a5XwFVzVWUbriYDDUBmgc+2Au9nEpuY5SlxkSCSOGsz+Msl4GMWRL8XLx/lX+sB1dhqtKq2FPk09idL34brL6GRGeLLqpa4MHpJPe83d/kSHfb0/FZwGVMUKSO2qFvpGeUjTEydBpposLdYVuclm2Mf0N4OjZ86Qp8f8E0qvTBZXGLaUYNHAccl+O6aYgvIdt6thMGrQw7aQkCkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EuH53wVtjA8btxOCGXocuJaDDNQUOdLeqTcp7wlv7jg=;
 b=QKj5hhawqByCeysVxxjmJ7WsKJKsA+auRytMPq39HAzXJZwA43/+0P9JZ+vpXzsvbfBJafVhw9RXJhh+LrKvjJGh5/Hzjf+cAaxcqCQYCOSXS2GEdYqidJDdy5sdpWW4EcIODN16KjouVfHiCLg6FL4LN2QKm+qkRGkfeloJkOWgAlU462ZGvDOQnIxRquTB2p2mRrAsL8ZrcEQRSiGnWEWPJrySp4SmznjcY/6ktTZOFL4xvfBdWX4SRIAWLqjofFEkCtMB4YoOt/7ntdZGB1AiVx9IK9wol9Gvzfh7939/ofAW0s8zHb0Jaj/wj+RVz3vR0iOx05YKaT5Xvw4Gxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EuH53wVtjA8btxOCGXocuJaDDNQUOdLeqTcp7wlv7jg=;
 b=K08pqQeM5GKR2S9NMnQUvmeLZBcM1/gMt00PxZUdw89/aV2m3pqmVfdGKNok1YEfVrnYZZjyKZLapsNuIGooBmJOJIi+yQDZmdNcU8VAR7T/81zAWkfSBQEC3T2Yoq04VqUrvZrrN/FZ05Ml9FwzqthSKqnomUejV8M6xojutm4=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SJ1PR11MB6108.namprd11.prod.outlook.com (2603:10b6:a03:489::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 10:46:02 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 10:46:02 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <martin.blumenstingl@googlemail.com>, <vladimir.oltean@nxp.com>
CC:     <claudiu.manoil@nxp.com>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <petrm@nvidia.com>,
        <idosch@nvidia.com>, <linux@rempel-privat.de>,
        <f.fainelli@gmail.com>, <hauke@hauke-m.de>,
        <xiaoliang.yang_1@nxp.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJVA+iLppAy/uE2cW1NrBQONVa1xiwcAgAADhICAADWVAIABvUGAgADAlICAACQggIAArH6AgAiqEgA=
Date:   Thu, 14 Jul 2022 10:46:02 +0000
Message-ID: <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
         <20220705173114.2004386-4-vladimir.oltean@nxp.com>
         <CAFBinCC6qzJamGp=kNbvd8VBbMY2aqSj_uCEOLiUTdbnwxouxg@mail.gmail.com>
         <20220706164552.odxhoyupwbmgvtv3@skbuf>
         <CAFBinCBnYD59W3C+u_B6Y2GtLY1yS17711HAf049mstMF9_5eg@mail.gmail.com>
         <20220707223116.xc2ua4sznjhe6yqz@skbuf>
         <CAFBinCB74dYJOni8-vZ+hNH6Q6E4rmr5EHR_o5KQSGogJzBhFA@mail.gmail.com>
         <20220708120950.54ga22nvy3ge5lio@skbuf>
         <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
In-Reply-To: <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1f2a140-eb53-4a30-5bb2-08da65860ba0
x-ms-traffictypediagnostic: SJ1PR11MB6108:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UuDS/nV1QcW7rQ86u+ajOaHYG2EBKQzpULnJAnpTk3Cnoo65TVCRD0giELgISEGkAfX4ttpYzqw/gUYNwhFqho6kbd3sgdHaQNzp125yM82wfg/5Qv+ekAnOzHAjlxm/1AsXZPwkEEy3ANEuLgYjn3CB8sZk+hKxCqaUyVQtFwpHAt+uMREZLWxb7JD0mHbB62OcZsF7HtYb3M8ryUAgJIXD3wfkoxOBJ3RV87kbjqz6mCWpqBpKIKlSMN6H5cr0KyOPe+9/Nos5ijsRXo2HwlJ11uuQ4vdNj9Ny4JVJE0Y5/JgB83cwebzsTpq559oVCFBS1VWTkPL13nK52T9xzZfwIOPBlJQ22ZfB+c0vQ3jTywZGFzD8+ik73YOS2MBkihr8fzOKppYqPIwVNOSd0bqEoTUv4wKwfS6yI/8w3/GjWO23DvlaWXEtsTVLXzpe4dDayn0JMo1dzKP2dNG/u+DagNWiF6ImEXm1HfcaCm4WMAsB/3nmTn8b1h+84WiqFS25ZtOe01PYD8V9/dbgJO4f50/Qz44heiNrLLOroMMRIRCPeRgWgh2Y6iBiux0xYPUcmNSUAWjTUrduaAtVLrViHKFdrRhdkVMGtdHc7MaeBldNHh1ySvgexqWvAYoadnp9WwUOX2F//r4uQSQcnP87RW46maaJx72VIzHyazPYLHfKy6cYsoy5GAPlZtaPG6GHqA7sEAv7LFtnTgAPlc6VEVyKdT1I4Oc9tW8RgxwQe4h7rBRzuBfu03ZMMTMo+UHcOrr5GtFO3hO9aIEstFfHHPWAecrrGml7b+s0KnQlmkHUXVl4g/zqeJPehMZMPcyyfIZdKphHTYj3ePEPzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(346002)(39860400002)(366004)(5660300002)(71200400001)(7416002)(478600001)(8936002)(8676002)(66556008)(76116006)(66476007)(41300700001)(91956017)(66946007)(6506007)(6512007)(6486002)(2906002)(26005)(66446008)(86362001)(4326008)(122000001)(64756008)(53546011)(54906003)(38100700002)(316002)(2616005)(110136005)(83380400001)(36756003)(38070700005)(186003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzIzdzY5NXg4TkhleVM5cHloRnVFUmoxUHJKci9TdWNXcy8vcGMxcnpacDJX?=
 =?utf-8?B?OGZOTzdmaVYyOHdhYmNhNGpFalpnVXVpdGptdXR5QlNhYkZiZjR5aTV0Ukpw?=
 =?utf-8?B?QnY4NUNPZXpSemxsQWZYaGswcEl5azVyU2E5Q3lseVZoSnd0azR0Sm5wWUJa?=
 =?utf-8?B?VVBhak92c1FFVitnVnZ1K0lBQTVQQmtnMTkzUmJzVzBUVzluR0pDbXFvYTZy?=
 =?utf-8?B?NXRBWjVGT3NaTlNGaWQ5YURKR1JYTXoyU1RFbUFZNTdpT2grRDQrNlNJRFFs?=
 =?utf-8?B?SUEyUWpqb1MrMWppSDUxOUFZaHd0Vk4weTVITHFIYXJCTmU3VnBGL3hNZkRr?=
 =?utf-8?B?V1krdVVMZXViQjZWVWtUQ2VsS3UwbTZHRVpab0xFNnR1a3FQM0tMMXprUTl1?=
 =?utf-8?B?bUJBaXFZcGltZ0lnRkdNbUpyYWVZVzZ6dGhyU0hSNTRnbnJmdzFKOFVzVjgw?=
 =?utf-8?B?eExiNUZQU0pDNVZ2VmxhRDB2TFdCaG0wdGNUZ01jZUN4VGoxdHMvTWJoK1Vq?=
 =?utf-8?B?WDhoZlJUeDR3ZzZNSUllcFdNcVlkelpxYXVsYlVNNS90Y0ZaYkN0REN1RHdt?=
 =?utf-8?B?Tlc0QWcrYWlNTnd2eGRWdUxsVytBbDFTeVlvMG9QM0h3eXZ0WnNhZTdXVWY3?=
 =?utf-8?B?ZW5zZElFMjVtdm1JaU9vRjlVMTg3Vnk3Vy9zT2IybnEyTmk5K0FaVTdrMkNp?=
 =?utf-8?B?bldpU3JlVkROWVU3OThDck1jOWtla2tjd3BCazUvc2lkYzB6UExYVjRTWGpZ?=
 =?utf-8?B?UVlUeVdVNXJjc0hGNHZ2dHhMODdTNlFYWWFRcnhBTjJvMWtHOHlZK0VjYXdF?=
 =?utf-8?B?VUI3MTFaY0R1djNFVFlqajBPSHorTXFBOXArWERESjJkRXpZMEN4RG9NN25n?=
 =?utf-8?B?dWtFREZjS1pPNzFlODRaSk05T1c4a09Ldm8rV0JyeEtpMjFFcWcxeTkvdFZE?=
 =?utf-8?B?d1Z5aDhJNytYTW90TDdoSWdDaEhOUjRBeCtEeHlwSXVxOStvZE5DR0ZoeTNy?=
 =?utf-8?B?TDBtNzJnTCtLRDJNc3hNK3RKN1ZiOTg3YStnUnpSVDcrSTJHUTJmZDd6WU5a?=
 =?utf-8?B?RWFrdTNCWFg5UU5pODVmaXBkWEZrRmZtMU9Od0N1UW1EQlp3TE5vbGVFdW9p?=
 =?utf-8?B?ZXhEQnA1end2TTArWUk2MDBHQ1BudVlOTFloMi92V0FZRGUzbWVMaTE4NFdz?=
 =?utf-8?B?MXZNNXlOalN4bG9jQWtERnNOZE0rSCtmV3NBTUgzdnhjdVZJMFFrRDVpSEsz?=
 =?utf-8?B?TFJaZUEyMC9QWHF2ZGI4RmZlUUdDWGYrOUorZStTcGYyaGFndXY4RWMrb3Zs?=
 =?utf-8?B?eE5VTUZoR09CeGNBNy9sdVVGRTJXV0N3T3k2dVNmVFc4TDcyNTMxUnorL0ZC?=
 =?utf-8?B?aFV3UGx2MGdHdmt0cXJ4ZU5JN2pnUlVPdkYvN25QdXRETWVNdWlqK0hSY1hw?=
 =?utf-8?B?Z2R0YldWTmJZaEpvcUJWTGtXU1VvUHIrMjRPTFJ6cXJtdXh0Tlg1Vk5NU3ZX?=
 =?utf-8?B?UDJyOW1qVlc1MmdaUHpDd1dFSkJjaGZkdkR4cGNTOTgwY0NWTWFYNkgzQWps?=
 =?utf-8?B?b280TzV4dklyT2lQUEVTT083Mm5lQkRnRVdoSXhTb3I5SFEzQXJWSFpPQTI4?=
 =?utf-8?B?a1hFU2h0L253UytGM25YYjBzYlpybXN2RUxXbWtaVCtXMDNwRGhlTFAzVEtP?=
 =?utf-8?B?T3B3bWhwRVFQYmdLUTRnL1VaYURYcEg1aEtxVjk4UEkzSlF1bVJVYnhaVnJi?=
 =?utf-8?B?R1AwcmdwUDBqc3g3My9YcGtNWXBIbTN2YTJCV3RvM2FjV3lRUWZ6WldGdERk?=
 =?utf-8?B?c0ZSckN4OHo4R2hYWTdwMzVQak1wMmFLNFZ3RWN5VXZudUpUUmVkVXdrN2lX?=
 =?utf-8?B?Z1BuNmZZaXFubGFCbXo2eWhhZlQxUkg3TjlZcitTNmxBaENwL3oyV0hYZmFU?=
 =?utf-8?B?UTlaZmhpaFcxUE9jNGJnTWJzVnpNSS95VGVWUEFVVGU2UTNhRU1MNHNlQXlz?=
 =?utf-8?B?VkUwSXdzSVFITTNjL0N1ODZjY054cU1tS1Z4cjV4UVB3Y0lyMm9Fc1V5cHJJ?=
 =?utf-8?B?dzdVYmVzd2hZTDl3MEpwbFA0OXdzdzhUODVVTFpkVWpuZi9Vc1FvaTFic0Jt?=
 =?utf-8?B?NkRiMlN0YU9iMjN6eGVUbXNEMHlGWm8xa2s4ZzZseE1KMS9sRW02S2Z0T0sx?=
 =?utf-8?Q?Hiep0TfOFzpjSznwKIvqU5s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FEDDF2DF8493446839A9CF84CFE3437@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f2a140-eb53-4a30-5bb2-08da65860ba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 10:46:02.1115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4hnECrmNp01ZEXkl9toHKlu6hx8noV0sNzgNCsZx2sszDRzDhDYJM9ohL/Y12vlc189ib/DmWZF+I1lRwwPRyj6jXtNzVvtoKUTkM1Kl/SQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6108
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpXZSBjb3VsZG4ndCBhYmxlIHRvIHNldHVwIHRoZSBzZWxmdGVzdHMgYW5k
IGZhaWxlZCBkdXJpbmcgaW5zdGFsbGF0aW9uDQpvZiBwYWNrYWdlcy4gSW4gdGhlIG1lYW4gdGlt
ZSwgV2UgdHJpZWQgdGhlIGZvbGxvd2luZyB0aGluZ3MNCg0KU2V0dXAgLSBIb3N0MSAtLT4gbGFu
MSAtLT4gbGFuMiAtLT4gSG9zdDIuIFBhY2tldCB0cmFuc21pdHRlZCBmcm9tDQpIb3N0MSBhbmQg
cmVjZWl2ZWQgYnkgSG9zdDIuDQoNClNjZW5hcmlvLTE6IFZsYW4gYXdhcmUgc3lzdGVtIGFuZCBi
b3RoIGxhbjEgJiBsYW4yIGFyZSBpbiBzYW1lIHZpZA0KaXAgbGluayBzZXQgZGV2IGJyMCB0eXBl
IGJyaWRnZSB2bGFuX2ZpbHRlcmluZyAxDQpicmlkZ2UgdmxhbiBhZGQgZGV2IGxhbjIgdmlkIDEw
IHB2aWQgdW50YWdnZWQNCmJyaWRnZSB2bGFuIGFkZCBkZXYgbGFuMSB2aWQgMTAgcHZpZCB1bnRh
Z2dlZA0KDQpQYWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRoIHZpZCAxMCBpcyByZWNl
aXZlZCBieSB0aGUgSG9zdDIuDQpQYWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRoIHZp
ZCA1IGlzIG5vdCByZWNlaXZlZCBieSB0aGUgSG9zdDIuDQoNClNjZW5hcmlvLTI6IFZsYW4gdW5h
d2FyZSBzeXN0ZW0gDQppcCBsaW5rIHNldCBkZXYgYnIwIHR5cGUgYnJpZGdlIHZsYW5fZmlsdGVy
aW5nIDANCg0KTm93LCBpcnJlc3BlY3RpdmUgb2YgdGhlIHZpZCwgdGhlIHBhY2tldHMgYXJlIHJl
Y2VpdmVkIGJ5IEhvc3QyDQpQYWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0MSB3aXRoIHZpZCAx
MCBpcyByZWNlaXZlZCBieSB0aGUgSG9zdDIuDQpQYWNrZXQgdHJhbnNtaXR0ZWQgZnJvbSBIb3N0
MSB3aXRoIHZpZCA1IGlzICByZWNlaXZlZCBieSB0aGUgSG9zdDIuDQoNCldoZXRoZXIgdGhlIGFi
b3ZlIGFwcHJvYWNoIGlzIGNvcnJlY3Qgb3IgZG8gd2UgbmVlZCB0byB0ZXN0IGFueXRoaW5nDQpm
dXJ0aGVyLg0KDQpUaGFua3MNCkFydW4gDQpPbiBTYXQsIDIwMjItMDctMDkgYXQgMDA6MjcgKzAy
MDAsIE1hcnRpbiBCbHVtZW5zdGluZ2wgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNv
bnRlbnQgaXMgc2FmZQ0KPiANCj4gSGkgVmxhZGltaXIsDQo+IA0KPiBPbiBGcmksIEp1bCA4LCAy
MDIyIGF0IDI6MDkgUE0gVmxhZGltaXIgT2x0ZWFuIDwNCj4gdmxhZGltaXIub2x0ZWFuQG54cC5j
b20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIEZyaSwgSnVsIDA4LCAyMDIyIGF0IDEyOjAwOjMzUE0g
KzAyMDAsIE1hcnRpbiBCbHVtZW5zdGluZ2wNCj4gPiB3cm90ZToNCj4gPiA+IFRoYXQgbWFkZSBt
ZSBsb29rIGF0IGFub3RoZXIgc2VsZnRlc3QgYW5kIGluZGVlZDogbW9zdCBvZiB0aGUNCj4gPiA+
IGxvY2FsX3Rlcm1pbmF0aW9uLnNoIHRlc3RzIGFyZSBwYXNzaW5nIChhbGJlaXQgYWZ0ZXIgaGF2
aW5nIHRvDQo+ID4gPiBtYWtlDQo+ID4gPiBzb21lIGNoYW5nZXMgdG8gdGhlIHNlbGZ0ZXN0IHNj
cmlwdHMsIEknbGwgcHJvdmlkZSBwYXRjaGVzIGZvcg0KPiA+ID4gdGhlc2UNCj4gPiA+IHNvb24p
DQo+ID4gPiANCj4gPiA+IE5vbmUgKHplcm8pIG9mIHRoZSB0ZXN0cyBmcm9tIGJyaWRnZV92bGFu
X3VuYXdhcmUuc2ggYW5kIG9ubHkgYQ0KPiA+ID4gc2luZ2xlDQo+ID4gPiB0ZXN0IGZyb20gYnJp
ZGdlX3ZsYW5fYXdhcmUuc2ggKCJFeHRlcm5hbGx5IGxlYXJuZWQgRkRCIGVudHJ5IC0NCj4gPiA+
IGFnZWluZw0KPiA+ID4gJiByb2FtaW5nIikgYXJlIHBhc3NpbmcgZm9yIG1lIG9uIEdTV0lQLg0K
PiA+ID4gQWxzbyBtb3N0IG9mIHRoZSBldGh0b29sLnNoIHRlc3RzIGFyZSBmYWlsaW5nIChwaW5n
IGFsd2F5cw0KPiA+ID4gcmVwb3J0cw0KPiA+ID4gIkRlc3RpbmF0aW9uIEhvc3QgVW5yZWFjaGFi
bGUiKS4NCj4gPiANCj4gPiBJIGRvbid0IHJlY2FsbCBoYXZpbmcgcnVuIGV0aHRvb2wuc2gsIHNv
IEkgZG9uJ3Qga25vdyB3aGF0J3MgdGhlDQo+ID4gc3RhdHVzDQo+ID4gdGhlcmUuDQo+IA0KPiBP
Sywgbm8gd29ycmllcyB0aGVyZQ0KPiANCj4gPiA+IEkgZ3Vlc3MgbW9zdCAob3IgYXQgbGVhc3Qg
bW9yZSkgb2YgdGhlc2UgYXJlIHN1cHBvc2VkIHRvIHBhc3M/IERvDQo+ID4gPiB5b3UNCj4gPiA+
IHdhbnQgbWUgdG8gb3BlbiBhbm90aGVyIHRocmVhZCBmb3IgdGhpcyBvciBpcyBpdCBmaW5lIHRv
IHJlcGx5DQo+ID4gPiBoZXJlPw0KPiA+IA0KPiA+IFNvIHllcywgdGhlIGludGVudGlvbiBpcyBm
b3IgdGhlIHNlbGZ0ZXN0cyB0byBwYXNzLCBidXQgSSB3b3VsZG4ndA0KPiA+IGJlDQo+ID4gc3Vy
cHJpc2VkIGlmIHRoZXkgZG9uJ3QuIFRoZXkgZGlkbid0IHdoZW4gSSBzdGFydGVkIHRoaXMgZWZm
b3J0IGZvcg0KPiA+IHRoZQ0KPiA+IG9jZWxvdC9mZWxpeCBEU0EgZHJpdmVyIGVpdGhlciwgaXQn
cyBtb3N0IGxpa2VseSB0aGF0IGluZGl2aWR1YWwNCj4gPiBkcml2ZXJzDQo+ID4gd2lsbCBuZWVk
IGNoYW5nZXMsIHRoYXQncyBraW5kIG9mIHRoZSB3aG9sZSBwb2ludCBvZiBoYXZpbmcNCj4gPiBz
ZWxmdGVzdHMsDQo+ID4gdG8gaGF2ZSBpbXBsZW1lbnRhdGlvbnMgdGhhdCBhcmUgdW5pZm9ybSBp
biB0ZXJtcyBvZiBiZWhhdmlvci4NCj4gPiBGb3IgdGhlIG9jZWxvdCBkcml2ZXIsIHRoZSB0ZXN0
cyBzeW1saW5rZWQgaW4gdGhlIERTQSBmb2xkZXIgZG8NCj4gPiBwYXNzDQo+ID4gKHdpdGggdGhl
IGV4Y2VwdGlvbiBvZiB0aGUgbG9ja2VkIHBvcnQgdGVzdCwgd2hpY2ggaXNuJ3QNCj4gPiBpbXBs
ZW1lbnRlZCwNCj4gPiBhbmQgdGhlIGJyaWRnZSBsb2NhbF90ZXJtaW5hdGlvbi5zaCB0ZXN0cywg
YnV0IHRoYXQncyBhIGJyaWRnZQ0KPiA+IHByb2JsZW0NCj4gPiBhbmQgbm90IGEgZHJpdmVyIHBy
b2JsZW0pLiBJIHNob3VsZCBoYXZlIGEgcmVtb3RlIHNldHVwIGFuZCBJDQo+ID4gc2hvdWxkIGJl
DQo+ID4gYWJsZSB0byByZXBlYXQgc29tZSB0ZXN0cyBpZiBuZWNlc3NhcnkuDQo+ID4gDQo+ID4g
SSB0aGluayBpdCB3b3VsZCBiZSBhIGdvb2QgaWRlYSB0byBjcmVhdGUgYSBuZXcgZW1haWwgdGhy
ZWFkIHdpdGgNCj4gPiB0aGUNCj4gPiByZWxldmFudCBEU0EgbWFpbnRhaW5lcnMgZm9yIHNlbGZ0
ZXN0IHN0YXR1cyBvbiBHU1dJUC4gWW91J2xsIG5lZWQNCj4gPiB0bw0KPiA+IGdhdGhlciBzb21l
IGluZm9ybWF0aW9uIG9uIHdoYXQgZXhhY3RseSBmYWlscyB3aGVuIHRoaW5ncyBmYWlsLg0KPiA+
IFRoZSB3YXkgSSBwcmVmZXIgdG8gZG8gdGhpcyBpcyB0byBydW4gdGhlIHRlc3QgaXRzZWxmIHdp
dGggImJhc2ggLXgNCj4gPiAuL2JyaWRnZV92bGFuX3VuYXdhcmUuc2ggc3dwMCBzd3AxIHN3cDIg
c3dwMyIsIGFuYWx5emUgYSBiaXQgd2hlcmUNCj4gPiB0aGluZ3MgZ2V0IHN0dWNrLCB0aGVuIGVk
aXQgdGhlIHNjcmlwdCwgcHV0IGEgImJhc2giIGNvbW1hbmQgYWZ0ZXINCj4gPiB0aGUNCj4gPiBm
YWlsaW5nIHBvcnRpb24sIGFuZCBydW4gdGhlIHNlbGZ0ZXN0IGFnYWluOyB0aGlzIGdpdmVzIG1l
IGENCj4gPiBzdWJzaGVsbA0KPiA+IHdpdGggYWxsIHRoZSBWUkZzIGNvbmZpZ3VyZWQgZnJvbSB3
aGljaCBJIGhhdmUgbW9yZSBjb250cm9sIGFuZCBjYW4NCj4gPiByZS1ydW4gdGhlIGNvbW1hbmRz
IHRoYXQganVzdCBmYWlsZWQgKEkgY29weSB0aGVtIGZyb20gcmlnaHQgYWJvdmUsDQo+ID4gdGhl
eSdyZSB2aXNpYmxlIHdoZW4gcnVuIHdpdGggYmFzaCAteCkuIFRoZW4gSSB0cnkgdG8gbWFudWFs
bHkNCj4gPiBjaGVjaw0KPiA+IGNvdW50ZXJzLCB0Y3BkdW1wLCB0aGluZ3MgbGlrZSB0aGF0Lg0K
PiANCj4gSSBhbHJlYWR5IGZvdW5kICJiYXNoIC14IiBhbmQgdXNlZCBhIHNpbWlsYXIgdHJpY2sg
KGxhdW5jaGluZyB0Y3BkdW1wDQo+IGJlZm9yZSB0aGUgZmFpbGluZyBwb3J0aW9uKS4gQnV0IGl0
J3MgZ29vZCB0byBoYXZlIGl0IHdyaXR0ZW4gZG93biENCj4gVGhhbmtzIGEgbG90IGFnYWluIGZv
ciBhbGwgeW91ciBkZXRhaWxlZCBleHBsYW5hdGlvbnMgYW5kIHRoZSB0aW1lDQo+IHlvdSd2ZSB0
YWtlbiB0byBoZWxwIG1lIG91dCENCj4gSSdsbCBzdGFydCBhIG5ldyB0aHJlYWQgb24gdGhpcyBp
biB0aGUgbmV4dCBmZXcgZGF5cy4NCj4gDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IE1hcnRpbg0K
