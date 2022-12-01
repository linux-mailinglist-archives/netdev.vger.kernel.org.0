Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5BE63EA21
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 08:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLAHIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 02:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLAHIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 02:08:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA04143AEC;
        Wed, 30 Nov 2022 23:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669878529; x=1701414529;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TYIQ8+Ok97/DUfN4beH4dEcvjXBt3hqIX6pzKmegYfU=;
  b=Grlr3W068N9s+v4ek/KEhIpOMzLEwCZwRjITCIIj/GocCSGvoGvmoQTX
   KXCL9uBQdIx8LeiNuA5CH3rAJia7Bx157ahWWDJ4i7s0WEEkguRP360jE
   OuzmikRJRWdp5Y+CxzsEgAtAfeKWZDe0FZp9ps6LLkHghwtc1fLfgM3ks
   GMojBb+pz9KuPlGSw9qf/5HYQ0CF01W/B8loT+Nke27Up6urCntrZRigD
   UtL6hzr12g6zPNrtAVMqptEuJiF673BQiT81nduULvyg0QTQVT7wbR+Ot
   HXobP5qxk1vlJ1kYSWe8jwAQ0cBuhZPCJ1WN+6aJ8Bh20C4keO7okaCSU
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="191252259"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Dec 2022 00:08:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 1 Dec 2022 00:08:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 1 Dec 2022 00:08:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrzqLygnlm5WzLuYAR4QQnnXNpollsFpENtg7eaNCVViI74/kWmLuLhXKCWo0hjTK9gT66qWlYfsM78FRC0irhYjMRSwlHXpNJdaSB6Jt/QOZ1pYc0ovaQet4ulRy6StA5AUS5DdZ/m/tz5rvWhWCBvMhVd3OoMMz2FaC7+PyFAYz5+PHyC2MR/MGzvpAVRtzJ0MfRZmjIPJGPdVmBEFxBA6hBNM5VonjIMPgl/yimRxYvw2JJoNgqRmBpH8Hwl3e2b4zrCZEuRrWcVz9+ntRKdXUtUyJMlHLCQGYi+6FzHVIiILDuICMu70rlmB1BgE1Ze4drkW9KEDqOCRZuzdsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TYIQ8+Ok97/DUfN4beH4dEcvjXBt3hqIX6pzKmegYfU=;
 b=he0eHXw1AAwXhBcNMzyV7l9VzgRE4gnu99d5Xd2pJ/WhlZOcbCJB83MbzqbRViG4GPUZ+WCvtJxtpA+ROPXYXeQyIdhHD/vs73KMX+ROVQXkouXhBD34ABs9l1ah87yP7pQ3wuw1/2B2M6HSVJP+j/ywupqWre5vMFJH94JUep/Iy5KdZgzyD/bNfseolv1DW6pD9KLjHSsprnHEzTdFvXIlNKY1RcEUiNbr66VGvs7J14+HRVzZQlrcOpEhWWbZfwIPrCCKAdrSot2GmZnd6/iSy1yVUHNn2tsOvNgvgd/zutdG6GD4tgeTQBhojx5YCqCW45DMHV7pabnZk8jrow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TYIQ8+Ok97/DUfN4beH4dEcvjXBt3hqIX6pzKmegYfU=;
 b=tj+Ohl7al5cVOGJyhDh8DMtxjd3ge3Oz/ZciVpiez+q4E0/8oMtOzvCgXpUfrH74nUyK+Eye7zowGrtwcWqkVUcm2G/AKtHHWbo/fH3PbyIvtSiIJygeUGjMduxU03709tTkl0ajSFSt8Hb2dVhlxHosxlm/ib/0jJUj5wy7QYE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by CH3PR11MB7298.namprd11.prod.outlook.com (2603:10b6:610:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 07:08:45 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::97f3:ca9:1e8f:b1e1%5]) with mapi id 15.20.5880.008; Thu, 1 Dec 2022
 07:08:45 +0000
From:   <Divya.Koppera@microchip.com>
To:     <Horatiu.Vultur@microchip.com>
CC:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <richardcochran@gmail.com>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: RE: [PATCH v3 net-next] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Thread-Topic: [PATCH v3 net-next] net: phy: micrel: Fix warn: passing zero to
 PTR_ERR
Thread-Index: AQHZA9vMfIOknsl+c0CMlgSj9+c6TK5XjnsAgAEOBdA=
Date:   Thu, 1 Dec 2022 07:08:45 +0000
Message-ID: <CO1PR11MB4771030026F8460B5A92DC35E2149@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20221129101653.6921-1-Divya.Koppera@microchip.com>
 <20221130145034.rmput7zdhwevo2p7@soft-dev3-1>
In-Reply-To: <20221130145034.rmput7zdhwevo2p7@soft-dev3-1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4771:EE_|CH3PR11MB7298:EE_
x-ms-office365-filtering-correlation-id: 51208fda-9f86-43bc-d2f3-08dad36ae308
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dn2CY/aSfIAi4epFV9yhgyRvwo/Ri+obhH9Cj87ilrD7g//kI6+RcuVBz1ma/4GrrgQAHp7rQaedrmR4n3/llHTHaByeQGit/ZBhyjP2x81l4/MDkSBPxbEmLsFHhmTLH4DTwKHI2IOCjf1ofWVAN+gY4iIZAb8vmihp65UWB6Va4UuwlzZCUym24Xob7kDBV5g6KYVmpXoMOt2eVH0ZoUe49BlLkuixoMj5lbTEECsLlancFApjrB4AYQG0jQ9NXb+E+r9dr2yGto1CRgejgPNVi55fai/pySUUQ80OfcRbqZbCCogq8scy1E8jWR0uX6sZgnruYv26F3y4H9krshLM7JFWjoQ+/Z7EHnJ8a4heg4Xjp6ONa72hUSfiXxyc5gJOEvKsQPMTVjzN0Ckqbi8Ly9aRmFpHK91Djvtb7han2C+bFZV69GEx09Dp31gMGEZ9oU/A4yUolLwcasDT/0h+TeEH8syiNakFeeiEyP+LoK9GmOe0P2lfby5SaRSC6L+40JIemEaYxKAxxVqIM7+bn5bp2rJGcjQKutsvxlz3EDv5AK38OtHKr0IT9WO8AfuqCpj3t1zEJNs3WdqQPoOS7j4/NxK8LgEY6znfBosWMvx9/LKq9J84pV3PXFAMSEVKoUibHghyqt2j+1BUPY28X7lD1IHtNiSBIOjrjwcSsw8rYmGCSIr3/L7lRGMXrkCw7U93gLjUwbZpqoZ59Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199015)(6506007)(52536014)(33656002)(55016003)(38070700005)(86362001)(9686003)(64756008)(107886003)(7696005)(478600001)(76116006)(66946007)(53546011)(26005)(6862004)(8676002)(71200400001)(6636002)(4326008)(66476007)(316002)(122000001)(38100700002)(83380400001)(54906003)(7416002)(2906002)(66446008)(5660300002)(186003)(66556008)(41300700001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTdCcjFCM3gzMTl0Q0tXOWhGd1JkNlBlVXAwc1pRcERyZTBSMzFDem1KRU5V?=
 =?utf-8?B?elUyVEJxRTdlMmdOZmNOaWt2V0t4aGJVdGpsUGc5cGxuUEZ1VW1RRnhwRTNp?=
 =?utf-8?B?ZDdXeFRFWkRtRk5sdDYzMHl1R05rejZZUVBOYnV5TmcvNkVDaDNGUVpuZStL?=
 =?utf-8?B?bTA4SW5NL2ZlcThZOWFxNGFDd2JaWThKcFpUUi9vTEhpRnNQUHErVVpsUmZ3?=
 =?utf-8?B?M29nQUIyanZmQkF5YkxZQW1iTnFXKzY3WU9BbVZhbksyeDhkeEdzenk4K3U3?=
 =?utf-8?B?bEpYQm5MNk93eG9UbmR0dVRrc3JWVTVCVDZrQlYvS1hxRUp2c25xNlZBWStO?=
 =?utf-8?B?L2dNd2FyaU4rZ3p0bGZXMnVvUnQvbjBkaUpuMlNSdmhpZDI1S2l2UGxmY3Vp?=
 =?utf-8?B?OFQvWUtRUkNpYWdMTmI4Wmo3VFFQOUlURWZ3OW9Hem92ckJwSDdkWHA4OG1B?=
 =?utf-8?B?Q3dpZjZ2eDlEM1dIL2srczhCYWxZaDZEYWhvcmVBU20wVExDL1I2cjNGQjUy?=
 =?utf-8?B?ZmJ3RTNUSUR5SWFOV1dkRllhb2FtRS9PMVp3QWh3b0RaWm1TbnpHdGs1Y0RD?=
 =?utf-8?B?ZVdqaUtEVWVGekM1TWduK1M2S3k5dVB1V3BuOVBzY1g0R2RBTTV0dmJDOE8z?=
 =?utf-8?B?R3ZmQ3BNQWg0NWx5VzBwaklpeUhOcURPZTFhelpxTVRWWUh3WXhoaXdxbDVS?=
 =?utf-8?B?bkdWVVVVTy9rb01VRGVYblMycUwyYmxQWEZsc3FiK2tCbUtGalg4dHQ1Uk1O?=
 =?utf-8?B?ekVCSmV3bXMvYTd4bDR0VWNiZmhhajkxV0U2THFTaytkMXhsYSttNDFST0pK?=
 =?utf-8?B?RmFJQ09wQy8wKzBJZzVvZk5wRWZDVHJadFZLb3lSMFQxeUdtZHgwb0VQdUxS?=
 =?utf-8?B?N1gzV0Q3MWhXaDJKZGlITS8yeFFiNVJCS0k3bmR0V1VjdDBYbnlBdDBlM0dq?=
 =?utf-8?B?TmFvd05QelFjNU5ZeTlLbFl6aENGMHNhdGJZdmdhR0k0S2VyV0szY2VsY0Mw?=
 =?utf-8?B?bGFjcC9OaGhvaWJabHBUNGlhYjJ6ZkhJc3ZESTBqUHpvVWtVQVFaY3M0aTg2?=
 =?utf-8?B?dHUyUkhkcitMeHdxb3kwb05YdkJCMDlncDVCYVpNT3NWTm5odEJpeDhkcUZF?=
 =?utf-8?B?RjFFejAvRTVOUm1FWEpCMVFOa0ZnUjNqUUF6N3ZwY0N3c0hoYUsxQXlGd1c0?=
 =?utf-8?B?RTRaVEtpcXZGSFBvUXNrUERyczdsVGR2WXZVMHIrYlpCSnFMM29yVDZ4SXVt?=
 =?utf-8?B?elZ6UG1pMnhvbGNqVkxSNXJLU2lHSkQxV0ZRem9xdDQya0VIQ3RsTDRyaytF?=
 =?utf-8?B?TUxCSzNidnJMMXRObHI1d1hIbk5FRmFCM2pMcGRaanhCa3hEMEkycG8zcjFj?=
 =?utf-8?B?bXZ1NzRhUU84NmI1NTV4M05MaDNCcWtXSHhyRnA1OUt1cDZPYTVxTUJLNWZI?=
 =?utf-8?B?clM4K3F6K3lJRStVOE5UMW5rdmV3L1JKVmJPY00vRGJEdDFZcHFWNFhFbEtV?=
 =?utf-8?B?TWt2QzgreCthejNuKzVLbEhhMEVYTTlHU28xbHBvMEtOMlJrbmErUERUNmt1?=
 =?utf-8?B?TmxtSUVZRzFJQ2VBSTlxOHhmQzVQNHFuWW54TTI2dlJOeXZML05pNldGMitR?=
 =?utf-8?B?NXhja2Vmb0hoeGt2T2dwU3MxV0hNMDF0VDRnYzNDQVErNWgvYjdFblN6K3Vt?=
 =?utf-8?B?Q0lGdnJzbWdqakpubnRxMVV3TUhjN3l3dlZ3SkRYZEV4bnlndFFQN3g3TDd3?=
 =?utf-8?B?QVVGOG9TdTA5RnplajMxZ1BTdHNsS1lBdFprdW1LQlNHY0ZMc0I4QndYTmNK?=
 =?utf-8?B?Y0ZiNUs0SDFhbENuT2g3RVRUbDBQTGNzL05SZzRHR3gzYlc4eUdXNkdKSzdk?=
 =?utf-8?B?OVI3U0tORlh0cWgreHRHWEM4WjRSQVlYWWlmRlh5bjFDTTVZZXRvZGkyVm1p?=
 =?utf-8?B?WkJ6RHVGeTZEZmhva2p1N2U2Rm8wZHNLUnVSVUlXY2tlTkhxUVdMYTVrZ3ZR?=
 =?utf-8?B?S3JORWs5NE5NSHBSZmxUOFpUd3ZOdGh3VnNJSzlObDF5bXpHNHBPUWcxQkdR?=
 =?utf-8?B?eFpGM2NkZGNQVGk5bHE4NEs3SlVEZVZWUlVwWXgyVUd4ZDJNRlJRbFRTZXE2?=
 =?utf-8?B?a1pJZmhESkNMNGk4Vkx6blUrcUpZSEdwK3dTUXA5NUtBb1lBRHJyQWpxa3B0?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51208fda-9f86-43bc-d2f3-08dad36ae308
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 07:08:45.4878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ne7keAdA6WLuHK+oGxo4kICC0jd3woomx5xC55jX0ZvZW+507pAPyo33RTYvwu3+R6NRH/uzRsWOkAztKgQGalYMvB/v/zS+XB+34VZxBws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7298
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSG9yYXRpdSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIb3Jh
dGl1IFZ1bHR1ciA8aG9yYXRpdS52dWx0dXJAbWljcm9jaGlwLmNvbT4NCj4gU2VudDogV2VkbmVz
ZGF5LCBOb3ZlbWJlciAzMCwgMjAyMiA4OjIxIFBNDQo+IFRvOiBEaXZ5YSBLb3BwZXJhIC0gSTMw
NDgxIDxEaXZ5YS5Lb3BwZXJhQG1pY3JvY2hpcC5jb20+DQo+IENjOiBhbmRyZXdAbHVubi5jaDsg
aGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9yZy51azsNCj4gZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJl
bmlAcmVkaGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2
Z2VyLmtlcm5lbC5vcmc7IHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbTsgVU5HTGludXhEcml2ZXIN
Cj4gPFVOR0xpbnV4RHJpdmVyQG1pY3JvY2hpcC5jb20+OyBNYWRodXJpIFNyaXBhZGEgLSBJMzQ4
NzgNCj4gPE1hZGh1cmkuU3JpcGFkYUBtaWNyb2NoaXAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIHYzIG5ldC1uZXh0XSBuZXQ6IHBoeTogbWljcmVsOiBGaXggd2FybjogcGFzc2luZyB6ZXJv
IHRvDQo+IFBUUl9FUlINCj4gDQo+IFRoZSAxMS8yOS8yMDIyIDE1OjQ2LCBEaXZ5YSBLb3BwZXJh
IHdyb3RlOg0KPiANCj4gSGkgRGl2eWEsDQo+IA0KPiA+IEhhbmRsZSB0aGUgTlVMTCBwb2ludGVy
IGNhc2UNCj4gPg0KPiA+IEZpeGVzIE5ldyBzbWF0Y2ggd2FybmluZ3M6DQo+ID4gZHJpdmVycy9u
ZXQvcGh5L21pY3JlbC5jOjI2MTMgbGFuODgxNF9wdHBfcHJvYmVfb25jZSgpIHdhcm46IHBhc3Np
bmcNCj4gemVybyB0byAnUFRSX0VSUicNCj4gPg0KPiA+IEZpeGVzIE9sZCBzbWF0Y2ggd2Fybmlu
Z3M6DQo+ID4gZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jOjE3NTAga3N6ODg2eF9jYWJsZV90ZXN0
X2dldF9zdGF0dXMoKSBlcnJvcjoNCj4gPiB1bmluaXRpYWxpemVkIHN5bWJvbCAncmV0Jy4NCj4g
DQo+IFNob3VsZG4ndCB5b3Ugc3BsaXQgdGhpcyBwYXRjaCBpbiAyIGRpZmZlcmVudCBwYXRjaGVz
LCBhcyB5b3UgZml4IDIgaXNzdWVzLg0KDQpJIGdvdCB0aGVzZSB3YXJuaW5ncyBpbiBzaW5nbGUg
bWFpbCwgc28gdGhvdWdodCBvZiBmaXhpbmcgaXQgaW4gb25lIHBhdGNoLiBBbHNvLCBvbmUgcGF0
Y2ggaGFzIHNpbmdsZSBsaW5lIGNoYW5nZSBzbyBkaWQgdGhpcyB3YXkuDQpZZWFoLCBzcGxpdHRp
bmcgc2Vuc2UgZ29vZCwgd2lsbCBkbyBpbiBuZXh0IHJldmlzaW9uLg0KDQo+IEFsc28gYW55IHJl
YXNvbiB3aHkgeW91IHRhcmdldCBuZXQtbmV4dCBhbmQgbm90IG5ldD8gQmVjYXVzZSBJIGNhbiBz
ZWUgdGhlDQo+IGJsYW1lZCBwYXRjaGVzIG9uIG5ldCBicmFuY2guDQo+IA0KDQpJbml0aWFsbHkg
SSB0YXJnZXRlZCBmb3IgbmV0LW5leHQgYW5kIGluIHNlY29uZCByZXZpc2lvbiBJIG1vdmVkIHRv
IG5ldCBhcyBpdCBpcyBmaXguIEJ1dCBJIGdvdCBhIGNvbW1lbnQgYXMgYmVsb3cuIFNvIGFnYWlu
LCB0YXJnZXRlZCB0byBuZXQtbmV4dC4NCg0KIg0KPiB2MSAtPiB2MjoNCj4gLSBIYW5kbGVkIE5V
TEwgcG9pbnRlciBjYXNlDQo+IC0gQ2hhbmdlZCBzdWJqZWN0IGxpbmUgd2l0aCBuZXQtbmV4dCB0
byBuZXQNCg0KVGhpcyBpcyBub3QgYSBnZW51aW5lIGJ1ZyBmaXgsIGFuZCBzbyBpdCBzaG91bGQg
dGFyZ2V0IG5leHQtbmV4dC4iDQoNCg0KPiA+DQo+ID4gdmltICsvUFRSX0VSUiArMjYxMyBkcml2
ZXJzL25ldC9waHkvbWljcmVsLmMNCj4gPiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3Qg
PGxrcEBpbnRlbC5jb20+DQo+ID4gUmVwb3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJw
ZW50ZXJAb3JhY2xlLmNvbT4NCj4gPiBGaXhlczogZWNlMTk1MDI4MzRkICgibmV0OiBwaHk6IG1p
Y3JlbDogMTU4OCBzdXBwb3J0IGZvciBMQU44ODE0IHBoeSIpDQo+ID4gRml4ZXM6IDIxYjY4OGRh
YmVjYiAoIm5ldDogcGh5OiBtaWNyZWw6IENhYmxlIERpYWcgZmVhdHVyZSBmb3IgbGFuODgxNA0K
PiA+IHBoeSIpDQo+ID4gU2lnbmVkLW9mZi1ieTogRGl2eWEgS29wcGVyYSA8RGl2eWEuS29wcGVy
YUBtaWNyb2NoaXAuY29tPg0KPiA+IC0tLQ0KPiA+IHYyIC0+IHYzOg0KPiA+IC0gQ2hhbmdlZCBz
dWJqZWN0IGxpbmUgZnJvbSBuZXQgdG8gbmV0LW5leHQNCj4gPiAtIFJlbW92ZWQgY29uZmlnIGNo
ZWNrIGZvciBwdHAgYW5kIGNsb2NrIGNvbmZpZ3VyYXRpb24NCj4gPiAgIGluc3RlYWQgYWRkZWQg
bnVsbCBjaGVjayBmb3IgcHRwX2Nsb2NrDQo+ID4gLSBGaXhlZCBvbmUgbW9yZSB3YXJuaW5nIHJl
bGF0ZWQgdG8gaW5pdGlhbGlzYXRvbi4NCj4gPg0KPiA+IHYxIC0+IHYyOg0KPiA+IC0gSGFuZGxl
ZCBOVUxMIHBvaW50ZXIgY2FzZQ0KPiA+IC0gQ2hhbmdlZCBzdWJqZWN0IGxpbmUgd2l0aCBuZXQt
bmV4dCB0byBuZXQNCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvcGh5L21pY3JlbC5jIHwgMTgg
KysrKysrKysrKy0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCsp
LCA4IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9t
aWNyZWwuYyBiL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYyBpbmRleA0KPiA+IDI2Y2UwYzVkZWZj
ZC4uMzcwM2UyZmFmYmQ0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwu
Yw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9taWNyZWwuYw0KPiA+IEBAIC0yMDg4LDcgKzIw
ODgsOCBAQCBzdGF0aWMgaW50IGtzejg4NnhfY2FibGVfdGVzdF9nZXRfc3RhdHVzKHN0cnVjdA0K
PiBwaHlfZGV2aWNlICpwaHlkZXYsDQo+ID4gIAljb25zdCBzdHJ1Y3Qga3N6cGh5X3R5cGUgKnR5
cGUgPSBwaHlkZXYtPmRydi0+ZHJpdmVyX2RhdGE7DQo+ID4gIAl1bnNpZ25lZCBsb25nIHBhaXJf
bWFzayA9IHR5cGUtPnBhaXJfbWFzazsNCj4gPiAgCWludCByZXRyaWVzID0gMjA7DQo+ID4gLQlp
bnQgcGFpciwgcmV0Ow0KPiA+ICsJaW50IHJldCA9IDA7DQo+ID4gKwlpbnQgcGFpcjsNCj4gPg0K
PiA+ICAJKmZpbmlzaGVkID0gZmFsc2U7DQo+ID4NCj4gPiBAQCAtMjk3MCwxMiArMjk3MSwxMyBA
QCBzdGF0aWMgaW50IGxhbjg4MTRfY29uZmlnX2ludHIoc3RydWN0DQo+ID4gcGh5X2RldmljZSAq
cGh5ZGV2KQ0KPiA+DQo+ID4gIHN0YXRpYyB2b2lkIGxhbjg4MTRfcHRwX2luaXQoc3RydWN0IHBo
eV9kZXZpY2UgKnBoeWRldikgIHsNCj4gPiArCXN0cnVjdCBsYW44ODE0X3NoYXJlZF9wcml2ICpz
aGFyZWRfcHJpdiA9IHBoeWRldi0+c2hhcmVkLT5wcml2Ow0KPiA+ICAJc3RydWN0IGtzenBoeV9w
cml2ICpwcml2ID0gcGh5ZGV2LT5wcml2Ow0KPiA+ICAJc3RydWN0IGtzenBoeV9wdHBfcHJpdiAq
cHRwX3ByaXYgPSAmcHJpdi0+cHRwX3ByaXY7DQo+ID4gIAl1MzIgdGVtcDsNCj4gPg0KPiA+IC0J
aWYgKCFJU19FTkFCTEVEKENPTkZJR19QVFBfMTU4OF9DTE9DSykgfHwNCj4gPiAtCSAgICAhSVNf
RU5BQkxFRChDT05GSUdfTkVUV09SS19QSFlfVElNRVNUQU1QSU5HKSkNCj4gPiArCS8qIENoZWNr
IGlmIFBIQyBzdXBwb3J0IGlzIG1pc3NpbmcgYXQgdGhlIGNvbmZpZ3VyYXRpb24gbGV2ZWwgKi8N
Cj4gPiArCWlmICghc2hhcmVkX3ByaXYtPnB0cF9jbG9jaykNCj4gPiAgCQlyZXR1cm47DQo+ID4N
Cj4gPiAgCWxhbnBoeV93cml0ZV9wYWdlX3JlZyhwaHlkZXYsIDUsIFRTVV9IQVJEX1JFU0VULA0K
PiBUU1VfSEFSRF9SRVNFVF8pOw0KPiA+IEBAIC0zMDE2LDEwICszMDE4LDYgQEAgc3RhdGljIGlu
dCBsYW44ODE0X3B0cF9wcm9iZV9vbmNlKHN0cnVjdA0KPiA+IHBoeV9kZXZpY2UgKnBoeWRldikg
IHsNCj4gPiAgCXN0cnVjdCBsYW44ODE0X3NoYXJlZF9wcml2ICpzaGFyZWQgPSBwaHlkZXYtPnNo
YXJlZC0+cHJpdjsNCj4gPg0KPiA+IC0JaWYgKCFJU19FTkFCTEVEKENPTkZJR19QVFBfMTU4OF9D
TE9DSykgfHwNCj4gPiAtCSAgICAhSVNfRU5BQkxFRChDT05GSUdfTkVUV09SS19QSFlfVElNRVNU
QU1QSU5HKSkNCj4gPiAtCQlyZXR1cm4gMDsNCj4gPiAtDQo+ID4gIAkvKiBJbml0aWFsaXNlIHNo
YXJlZCBsb2NrIGZvciBjbG9jayovDQo+ID4gIAltdXRleF9pbml0KCZzaGFyZWQtPnNoYXJlZF9s
b2NrKTsNCj4gPg0KPiA+IEBAIC0zMDM5LDEyICszMDM3LDE2IEBAIHN0YXRpYyBpbnQgbGFuODgx
NF9wdHBfcHJvYmVfb25jZShzdHJ1Y3QNCj4gPiBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ID4NCj4g
PiAgCXNoYXJlZC0+cHRwX2Nsb2NrID0gcHRwX2Nsb2NrX3JlZ2lzdGVyKCZzaGFyZWQtPnB0cF9j
bG9ja19pbmZvLA0KPiA+ICAJCQkJCSAgICAgICAmcGh5ZGV2LT5tZGlvLmRldik7DQo+ID4gLQlp
ZiAoSVNfRVJSX09SX05VTEwoc2hhcmVkLT5wdHBfY2xvY2spKSB7DQo+ID4gKwlpZiAoSVNfRVJS
KHNoYXJlZC0+cHRwX2Nsb2NrKSkgew0KPiA+ICAJCXBoeWRldl9lcnIocGh5ZGV2LCAicHRwX2Ns
b2NrX3JlZ2lzdGVyIGZhaWxlZCAlbHVcbiIsDQo+ID4gIAkJCSAgIFBUUl9FUlIoc2hhcmVkLT5w
dHBfY2xvY2spKTsNCj4gPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAgCX0NCj4gPg0KPiA+ICsJ
LyogQ2hlY2sgaWYgUEhDIHN1cHBvcnQgaXMgbWlzc2luZyBhdCB0aGUgY29uZmlndXJhdGlvbiBs
ZXZlbCAqLw0KPiA+ICsJaWYgKCFzaGFyZWQtPnB0cF9jbG9jaykNCj4gPiArCQlyZXR1cm4gMDsN
Cj4gPiArDQo+ID4gIAlwaHlkZXZfZGJnKHBoeWRldiwgInN1Y2Nlc3NmdWxseSByZWdpc3RlcmVk
IHB0cCBjbG9ja1xuIik7DQo+ID4NCj4gPiAgCXNoYXJlZC0+cGh5ZGV2ID0gcGh5ZGV2Ow0KPiA+
IC0tDQo+ID4gMi4xNy4xDQo+ID4NCj4gDQo+IC0tDQo+IC9Ib3JhdGl1DQovRGl2eWENCg==
