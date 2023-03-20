Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC95C6C0C67
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 09:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjCTIoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 04:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjCTIon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 04:44:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B7E6199;
        Mon, 20 Mar 2023 01:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679301878; x=1710837878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wKTdpaobdojiW5TqEa9dMMfB7JrXjbOTF1KBl+DNpco=;
  b=XlZROtAc49NOHCHwNormAnRiI8iY3tdjzmuB9dVlIKT6bMzCUwsXOngr
   hK9JInGDijz0EjOssERV5cJ68Qf9IxxeVg8ailKiwT3xG+n44utmV0hYH
   reknGLbpyijb0Lk8MP44z1PYl5qHQqJPPo/RVgbwyrAhshQiuHqqPWRSE
   2Px9qC0IQoiXjy1B7JWvRD2nrhFWeKydMUWDpwwoZ6uj+QAPgKXFuh/bG
   Y2l/bv/ubhTmeY0RnV9e+ezkO0I28rNZLod3rR/mrDhxKwbjnMm53u1Mq
   ZaA/7X7ZOkxDuElb96F5jrjSdqnDLFSrpzos+Iw3ROZ9mLos0/+v/p02E
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,274,1673938800"; 
   d="scan'208";a="205478554"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Mar 2023 01:44:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 01:44:36 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 20 Mar 2023 01:44:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmYnbE8tJYd8S/VeGZ4BQ7PP1RXleBGHLqFQMJA+7aBlD5xRJclec1vnAiOQeBYSuuiN8M6Q3EcC+N0MGvUJANUfx1NUPYwvGR/LTyQw+qgaQhbS5T4pSHnrKInBRZUTraKeGIAB3zRkGEH4sDA7I3KGIKORQFqULmU863hnGzTs2xGLEE75LSNqBmdnTcEUXsMFqmXctjQip1MRB66teFxJmzkzcpQnYjxd3pbZsPix61VkHoR+cxYFWlk/CAIwACnSgkkDP5i8sSt8LPuCnFXTyt5F6evJHMx8PObcZlvk35/hP34PRgOGJuozzNurKoWiPXF8mflMzIrQWqv+Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKTdpaobdojiW5TqEa9dMMfB7JrXjbOTF1KBl+DNpco=;
 b=km8nGdtxQ74/D8WhCkvqboWERepSzkMfBeEdciRqjtOORjEd+L5rCS8oOAlAp9t8YYdrbze4wOMdNpdna5pUfLeAMAwppm8MJrNHQKQea00r614ka5Rjw6zqRedlYnG5hSkNHPdLRHvHndtbXqEi4okvwkntVzRjrwHAacptZ3742gCQUHdK3LAJjHqO7cBV8PTAsXXUS5KtI/aQhaPXzzkdz5UwQpvSp4l2fN64wqmfonyFawjrytWlasTZMxUmHTSW2s3mGF2uqn+nmY5U06rVI7DE540ifkY1fqpkUph6Z7h4TWkzJPHa+2rdG7XcAWkRnJFwMrExECWlms6XoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKTdpaobdojiW5TqEa9dMMfB7JrXjbOTF1KBl+DNpco=;
 b=NL60r4/c6iMIg92altDJKPStmRjxdIQtlE1r6GARiUpk+aiufSsN3+s0z/5o2bJ4dPjNX8TeNcikM8u37jLB4l2pODBUiyWMEN7BuIL18xk2MIuGAtRdyfCiuV+vfHgpSquafUV7O9/Llqqx6jlcwzi5jnYwmJsF36WWT+6w62E=
Received: from DM4PR11MB5358.namprd11.prod.outlook.com (2603:10b6:5:395::7) by
 CO6PR11MB5586.namprd11.prod.outlook.com (2603:10b6:5:35d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Mon, 20 Mar 2023 08:44:34 +0000
Received: from DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9]) by DM4PR11MB5358.namprd11.prod.outlook.com
 ([fe80::6c5d:5b92:1599:ce9%4]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 08:44:34 +0000
From:   <Steen.Hegelund@microchip.com>
To:     <robh@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <afaerber@suse.de>,
        <mani@kernel.org>, <wens@csie.org>, <jernej.skrabec@gmail.com>,
        <samuel@sholland.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <rafal@milecki.pl>, <bcm-kernel-feedback-list@broadcom.com>,
        <f.fainelli@gmail.com>, <appana.durga.rao@xilinx.com>,
        <naga.sureshkumar.relli@xilinx.com>, <wg@grandegger.com>,
        <mkl@pengutronix.de>, <michal.simek@xilinx.com>, <andrew@lunn.ch>,
        <olteanv@gmail.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <tobias@waldekranz.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <Daniel.Machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <heiko@sntech.de>,
        <mcoquelin.stm32@gmail.com>, <alexandre.torgue@foss.st.com>,
        <matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-actions@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-sunxi@lists.linux.dev>,
        <linux-aspeed@lists.ozlabs.org>, <linux-can@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH] dt-bindings: net: Drop unneeded quotes
Thread-Topic: [PATCH] dt-bindings: net: Drop unneeded quotes
Thread-Index: AQHZWSlQb1R7VXlBZk6nh+Ian9A42K8DXhCA
Date:   Mon, 20 Mar 2023 08:44:34 +0000
Message-ID: <CRB2TYK6Y8AF.1EPG0KQWUMUDD@den-dk-m31857>
References: <20230317233605.3967621-1-robh@kernel.org>
In-Reply-To: <20230317233605.3967621-1-robh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: aerc 0.14.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5358:EE_|CO6PR11MB5586:EE_
x-ms-office365-filtering-correlation-id: a4b46f5e-bf79-4726-3a3c-08db291f5485
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WZbOKO3bSoX3aXoHkk7nZ6Z7SFtzEnz05PINbab2mZRXaaD2uv9q/POTUi+MBoxNkJq2+Y65kI+oKxFKL4rl0Z5pqxJfqUORRjGIsuICnp9eH8TjgQ0/d/WE/d8A5hoERE4f6+FKvN2180KJHFQi4opbY0Ix2K2FAQlKbik1VjLS3JR2HogY4Pyb5YuoNKwNS6xXZUWGgTNlBeKvbZZgx2U51+mwVaLNZatUVCJwcZW0xam97wwkmRuQ3h0fcq/YfrtwL6xZc5Yr8LVRD+sDRNXxJX8A1zGu6pHZMbhD1HtSOKF4/imi1nh5mB6d1KzxHEGfYgxDMHg6l71rs04mZHMLwakl+36Pr3JVAjDy/1ktUm/RxN67rWDTgtyAwSOER0FS6T0G7Etj7yl3ICtF7gbXMHX9muu8AQUMyRtciToAropm2JoUW3BnNGAiJ1ovm2jdqafYqL8BOYPa+WsACRiQGWXbc2LrbDCQhmI5Ie9sCyvPQ0npVUapLDbk8Q48iM5akFO3xXv8pwoKivE0F6GohSmgR7AbdXQvikyxrNfK3spCLdIUF+GyTeVS+cRdlMRXCViXojhNER/6IerlbJqsg/grQg/mmD+Vm4v26ygNVITXbD2YSOif4RC+IGJC3Tq/pZttaWX5TlhpoLsmw0TBkGgNPDY37juG4zJvebMiyeemNSX0Hi1/IYq+3RVZgFYA2peSBN/qG33R6OvggLyBXcrX4BcK2TJ5eO+Lozo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5358.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199018)(83380400001)(38100700002)(38070700005)(86362001)(921005)(122000001)(2906002)(8676002)(4326008)(64756008)(41300700001)(66446008)(66946007)(66476007)(66556008)(91956017)(8936002)(76116006)(5660300002)(6512007)(186003)(26005)(6506007)(9686003)(33656002)(478600001)(110136005)(316002)(54906003)(6486002)(71200400001)(7416002)(7406005)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1VGZmpGbEFrMnp2VTJad0lPNjhxNkN1WnBraTBqK3pYYUd0allrQjR6emd0?=
 =?utf-8?B?cEpOSHdud3lzZWlqcTRacmJ2MldPQ1RCM3BNRnF5UkdUek1vcHNLQVFRcHEy?=
 =?utf-8?B?clh3T2ZnMDZiaFNpQVhrMXNsN0xCUG5WK1BrQmR0KzVzUnR6SHpnMlpSbGxu?=
 =?utf-8?B?c1Y0TVFMRENaeDVjS0R1OEtCN0pPQWhNMFNNRUpOYSs1UnY2Smc5blFZd0Zk?=
 =?utf-8?B?MmUzbVYxWWV6KzhDam9SeXpYaHNUZ0Iyay9xd2Z1UHNXN25XK0RtckNKcXBU?=
 =?utf-8?B?WFBaejhBL091dURYekU5L3prN250R3dDSmhoTUZoejAvMXNGN0VvSnNsTSs2?=
 =?utf-8?B?UkRpTTVtZXhYZjhqcEtYQWttenBrN2dwY1FRemZMeEdFc2Z0VE1sQkJDZWl5?=
 =?utf-8?B?K3J2clJDSER4Tko3dU83bGg4cjczbjZQTHVCWmhjcTdPTXNQcnFYencwalNN?=
 =?utf-8?B?MTZsT3ZvbnFEaUlRcGJidWlzWWFpK25veHNOM1p1RUtlWjhBK0E3NlhxUHph?=
 =?utf-8?B?aTBhbkNNVXY4T0Y2akduOWhNU1Z4MEx2NjJjS0VjcEJpdHI2VnYxQW8zM0FU?=
 =?utf-8?B?OU9BTU5oZWM5K0pkNXEzQjdIZ1RrRFdtdERsUFVVS0dZSmkyZnY5TElDTjZI?=
 =?utf-8?B?L0NzSG1HRWxxWkhqMVBDWFNwNEg5aVVJSmVTM0x5MUVpN295UnJpZXpMREVR?=
 =?utf-8?B?TlR0MW0rSndXa2JWSi9neWNIZHhjR2JwbkR2OHVDUkNjSGFYY01HTHhPZGQz?=
 =?utf-8?B?WGZMNVBEektTazM1TWJ5ZmNTYkliV3ZXamJGb3p2ZWtaWW14WVBjdUpsK1dn?=
 =?utf-8?B?bDlpbnc5TGYxVVVqWlNMeStjSlVBY3FMRWs3ZndnWDhKcnZWcUIvTk1tREN4?=
 =?utf-8?B?WVE3M0R3R1Rqa2ZvTkc1Q0dvWFcrUDFGK001dVVtbWNnZmtQUDRtOUpWVmRq?=
 =?utf-8?B?aVNDRHNLQXVWK0F1RU5BeEkrcGdZTjhESzc1bkNSbmFnc0hiNlQ5UFc1Sy9m?=
 =?utf-8?B?TitBdFRweXY2eXJ0WUNDSVpwZFY5NWxGY3EwWEZrWWNUUEM3ZE54QTVIbUhr?=
 =?utf-8?B?WFN4d0xGMGhOTkRVVTBVRDBWQkI0VWoxem9YUzVvRW0vUFZKYk4rRHNRVS9B?=
 =?utf-8?B?WU5TeUdJb0pUWStpYVhSQ1pjWGJZV3ZIeVI3ZnloZHhoK3E0VVBSTnFZS2kv?=
 =?utf-8?B?dGt6YXByQWNMempiTXpVWERBQ1BSY3pjdFUzWWVveTA5YjVta3cyZzBkQjlG?=
 =?utf-8?B?dEcyTXVtcmJqRUdvbmUyRmNjOUpoM0Fsa3B2cThvRWNGOCtZOGdNR3IzRW82?=
 =?utf-8?B?YmNHeTZWRU9HU3ozSk0wVm04NWkzd2l5LzE2cURyTjRiMGJhYnpQMGhXc1dJ?=
 =?utf-8?B?a3dRYk1mT3FOMEhWZVJyTnR0N21yQnBwa2ZBVUhkaWFFS1BuZ3oveVovSU40?=
 =?utf-8?B?ZHc0RmpXRzhGb2M0SHl0TnhHZm9xaklZdWxHTnFFbzZWc3UzWW1BWStHQmlE?=
 =?utf-8?B?U3VSWFU3Z3JyeEpyM2cyV2gwWHo5VklLcFQzTU1lMkZBU3lxckNZMWc2ZFEx?=
 =?utf-8?B?OHZKdE1SOStzK0hvZURtQ3V6Z2c0QVdwM21EdjFoSm1Pd1RrdWxrRVVyTmQ3?=
 =?utf-8?B?WDZWQXd3Q0xncWtNY0JCODNWd2hPWU5YWlRGT2h5c01DYkpVcEhZTC8rMng1?=
 =?utf-8?B?dS9zaElZSzRhaG5mSC82MWUwU3dhVnlzMkVzdDB1TkRVaVRxL2dXMFB0aS95?=
 =?utf-8?B?VTZ4RzkxN2pPeVJVaDk4QkZCNjR2TWw0dTYvOWduUTBOUnRROEt2dlpHVUFx?=
 =?utf-8?B?YlY1WFBOZTlxVk1kSHpqaUt4bVVEY0p2Y3NqbkFPYXkzSEthSXJTSmM3SkZ1?=
 =?utf-8?B?TG1Ebkd1YmlsSlBiOTQyc3RJRUNpRW1qZEpjMjd1aFk5STNpeG1BL2hSWXdr?=
 =?utf-8?B?RVVEZ25taDcwRzlXQUF3b1VCckJPdFREYldscTZrQlEyNlgzRTFaNk91aUZ1?=
 =?utf-8?B?YmNXRmlDcDBzUU50d2NHNldzZ2NHdE5VeUtwUTliMFY5dk5rZTc0ODRLVUZX?=
 =?utf-8?B?a01BV1E2dmYxZEN2RGV5UmNqRVlRWDVBUnUxYnpIeFAycEJpbXFLS2Z1cHp0?=
 =?utf-8?B?MkhxTTJYRlFGU2M5RjdtVmU5Ukx6Y2tTaWRxS05KM3hsNkxheEhHckZHRTRV?=
 =?utf-8?Q?UQJSCPkiE2Ol7MEz8TZknYc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D11A41927B824542B5F1C61B5BD8C30E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5358.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4b46f5e-bf79-4726-3a3c-08db291f5485
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 08:44:34.1487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EN/iqEtTPw9je/T67bCX5oP52blJQ7sGu2z9NHVckH6N9H9ydZ52vw5BaQbEWWJHOI67hZ5YhJiHt/lWjHRsfXmNyPSO4BYWDrJe4V8kkws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5586
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUm9iLA0KDQoNCk9uIFNhdCBNYXIgMTgsIDIwMjMgYXQgMTI6MzYgQU0gQ0VULCBSb2IgSGVy
cmluZyB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVu
IGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+DQo+IENs
ZWFudXAgYmluZGluZ3MgZHJvcHBpbmcgdW5uZWVkZWQgcXVvdGVzLiBPbmNlIGFsbCB0aGVzZSBh
cmUgZml4ZWQsDQo+IGNoZWNraW5nIGZvciB0aGlzIGNhbiBiZSBlbmFibGVkIGluIHlhbWxsaW50
Lg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBSb2IgSGVycmluZyA8cm9iaEBrZXJuZWwub3JnPg0KPiAt
LS0NCj4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9hY3Rpb25zLG93bC1lbWFjLnlhbWwg
IHwgIDIgKy0NCj4gIC4uLi9iaW5kaW5ncy9uZXQvYWxsd2lubmVyLHN1bjRpLWExMC1lbWFjLnlh
bWwgICAgIHwgIDIgKy0NCj4gIC4uLi9iaW5kaW5ncy9uZXQvYWxsd2lubmVyLHN1bjRpLWExMC1t
ZGlvLnlhbWwgICAgIHwgIDIgKy0NCj4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9hbHRy
LHRzZS55YW1sICAgICAgICAgIHwgIDIgKy0NCj4gIC4uLi9iaW5kaW5ncy9uZXQvYXNwZWVkLGFz
dDI2MDAtbWRpby55YW1sICAgICAgICAgIHwgIDIgKy0NCj4gIC4uLi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC9icmNtLGFtYWMueWFtbCAgICAgICAgIHwgIDIgKy0NCj4gIC4uLi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC9icmNtLHN5c3RlbXBvcnQueWFtbCAgIHwgIDIgKy0NCj4gIC4uLi9iaW5k
aW5ncy9uZXQvYnJvYWRjb20tYmx1ZXRvb3RoLnlhbWwgICAgICAgICAgIHwgIDIgKy0NCj4gIC4u
Li9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4veGlsaW54LGNhbi55YW1sICAgIHwgIDYgKysr
LS0tDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL2JyY20sc2YyLnlhbWwgICAg
ICB8ICAyICstDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL3FjYThrLnlhbWwg
ICAgICAgICB8ICAyICstDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZW5nbGVkZXIs
dHNuZXAueWFtbCAgICB8ICAyICstDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRo
ZXJuZXQtcGh5LnlhbWwgICAgICB8ICAyICstDQo+ICAuLi4vYmluZGluZ3MvbmV0L2ZzbCxxb3Jp
cS1tYy1kcG1hYy55YW1sICAgICAgICAgICB8ICAyICstDQo+ICAuLi4vYmluZGluZ3MvbmV0L2lu
dGVsLGl4cDR4eC1ldGhlcm5ldC55YW1sICAgICAgICB8ICA4ICsrKystLS0tDQo+ICAuLi4vZGV2
aWNldHJlZS9iaW5kaW5ncy9uZXQvaW50ZWwsaXhwNHh4LWhzcy55YW1sICB8IDE0ICsrKysrKyst
LS0tLS0tDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWFydmVsbCxtdnVzYi55YW1s
ICAgICB8ICAyICstDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWRpby1ncGlvLnlh
bWwgICAgICAgICB8ICAyICstDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvbWVkaWF0
ZWssbmV0LnlhbWwgICAgICB8ICAyICstDQo+ICAuLi4vYmluZGluZ3MvbmV0L21lZGlhdGVrLHN0
YXItZW1hYy55YW1sICAgICAgICAgICB8ICAyICstDQo+ICAuLi4vYmluZGluZ3MvbmV0L21pY3Jv
Y2hpcCxsYW45NjZ4LXN3aXRjaC55YW1sICAgICB8ICAyICstDQoNCkZvciBMQU45NjZ4IGFuZCBT
cGFyeDU6DQpSZXZpZXdlZC1ieTogU3RlZW4gSGVnZWx1bmQgPFN0ZWVuLkhlZ2VsdW5kQG1pY3Jv
Y2hpcC5jb20+DQoNCj4gIC4uLi9iaW5kaW5ncy9uZXQvbWljcm9jaGlwLHNwYXJ4NS1zd2l0Y2gu
eWFtbCAgICAgIHwgIDQgKystLQ0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21zY2Ms
bWlpbS55YW1sICAgICAgICAgfCAgMiArLQ0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L25mYy9tYXJ2ZWxsLG5jaS55YW1sICAgfCAgMiArLQ0KPiAgLi4uL2RldmljZXRyZWUvYmluZGlu
Z3MvbmV0L25mYy9ueHAscG41MzIueWFtbCAgICAgfCAgMiArLQ0KPiAgLi4uL2JpbmRpbmdzL25l
dC9wc2UtcGQvcG9kbC1wc2UtcmVndWxhdG9yLnlhbWwgICAgfCAgMiArLQ0KPiAgLi4uL2Rldmlj
ZXRyZWUvYmluZGluZ3MvbmV0L3Fjb20saXBxNDAxOS1tZGlvLnlhbWwgfCAgMiArLQ0KPiAgLi4u
L2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3Fjb20saXBxODA2NC1tZGlvLnlhbWwgfCAgMiArLQ0K
PiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3JvY2tjaGlwLGVtYWMueWFtbCAgICAgfCAg
MiArLQ0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3NucHMsZHdtYWMueWFtbCAgICAg
ICAgfCAgMiArLQ0KPiAgLi4uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3N0bTMyLWR3bWFjLnlh
bWwgICAgICAgfCAgNCArKy0tDQo+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvdGksY3Bz
dy1zd2l0Y2gueWFtbCAgICB8IDEwICsrKysrLS0tLS0NCj4gIC4uLi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC90aSxkYXZpbmNpLW1kaW8ueWFtbCAgIHwgIDIgKy0NCj4gIC4uLi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC90aSxkcDgzODIyLnlhbWwgICAgICAgIHwgIDIgKy0NCj4gIC4uLi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC90aSxkcDgzODY3LnlhbWwgICAgICAgIHwgIDIgKy0NCj4gIC4u
Li9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC90aSxkcDgzODY5LnlhbWwgICAgICAgIHwgIDIgKy0N
Cj4gIDM2IGZpbGVzIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKyksIDUzIGRlbGV0aW9ucygtKQ0K
DQpCUg0KU3RlZW4=
