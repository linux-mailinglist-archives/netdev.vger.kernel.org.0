Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD59664324
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234592AbjAJOVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238400AbjAJOVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:21:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5F965AD2;
        Tue, 10 Jan 2023 06:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673360480; x=1704896480;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a8iAzIGa+knRayYfk63Y1+FiebZ21Tk7l4iXW5Vqm9E=;
  b=uiDf2Q9QgTOnbAPj/XGtdTJe0K/nNMVi8Oxm+3PaG4+zG7ZznSpBPVRx
   A4EBYFsHfcw/3P7RkXDVqO3YLJv9Czf5gjIduC8vB2agL8gp/Cu+d5n25
   QCkPrMSuTOkkK/teCvDGkRKTP/QJMs5GbMniVVnuhF27m4shPX1AyKW2/
   B+gi0CihqUh639FL7Cf1cjHxIoeFXjMPh4mqM+q+RFQzmzlhcZ1hNNNt4
   uF3jt4XuWgq24oc13TN+ELSWnHme72+Y+fzhrTvDUJSsZocQ3eM0pUQng
   I0W9Rv3XWU0biVSuG82PAStqbfLsUvbEuzCmsw+9JD0yigY1+aUzB4q9u
   A==;
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="207149181"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2023 07:21:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 07:21:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 07:21:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJCJWz0OaoD5Ye0pzbe4QSVEelWDyUkoMD47wdMebsLR/3OD9r1seZl28W7+clisVTXo8Hvk8UnpBhGnkwCKQ9A8i5pqzhr89WcU3JLqWKLmMB5CGXXp47s5KcQuxMWQvCQU7OvgNN5nkHmCOjw61GccCEDVYerAmWXjNO5zeBGrWVIAiHf11P2b4TVgZJ8iy02i91YAaEaV3svssP7iHed8Erk0K2LNzBh1IVmNXbF2U9vRHiV3kcGRuU8tVxPPfjO0hcKqSQVkwpDc3S06lGU5ySIIbSzNpCL4HJ6czyUTwccdfxE2rpme6fMIu7I3/N+i699cAcBmBpokvE8zqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a8iAzIGa+knRayYfk63Y1+FiebZ21Tk7l4iXW5Vqm9E=;
 b=fTrUsxUPVopxZ+ktw5MoPiJcYyf3epOxGPKLypYohDlWQ7IJ4gxHW+76m0PaG2jOmM/4pYyeq9DCAI5AG/B0t8o+tc9RpiE9LQQ7egvLwaZPzI+ddViN1AqGFfIMCNsH1W4Aj/IMtQfxwCktfSDbpzDuvDzRDUk2V7OcmfqH9zbXSZaHhsLSIdEitDidO0ieK4U1TsEKNOtee64w9LRQQv2gMi3elGN2oMPMEeZARwL1Zo3Gb6ZvVbUFyirD2r65H4N1zvmgZ5oKk1uqBmxx9fdLg45035iNi9Nk4nFXAgwdkkSaAZJd4kuDZrcapSXJJznhSzBh5YIPFXryIkOeBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a8iAzIGa+knRayYfk63Y1+FiebZ21Tk7l4iXW5Vqm9E=;
 b=bl+X+3Mb+TL4x98PcPPiIyjglaiCToAK19r/3u/PzmgWusgiMWqSDXCi1HA2oBHS2shdZkOlbf35nlLojfgd7qUEhAEKP8LriGzHqdqo0Pi0meLEGg9lbb59sEzMHiVi/5PEAfktwMKHA+I6pv/7WxCEg3vxpuoQTLZmoYanisI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BL3PR11MB6338.namprd11.prod.outlook.com (2603:10b6:208:3b2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 14:21:18 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 14:21:18 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>, <yoshihiro.shimoda.uh@renesas.com>,
        <linux@armlinux.org.uk>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/4] net: phylink: Set host_interfaces for a
 non-sfp PHY
Thread-Topic: [PATCH net-next v2 1/4] net: phylink: Set host_interfaces for a
 non-sfp PHY
Thread-Index: AQHZJP1huDxZDGneoEm0V6N1AuZu7a6Xs5+A
Date:   Tue, 10 Jan 2023 14:21:18 +0000
Message-ID: <c03cf325b9ab5d0bbf38508336ad0aba6dfbf81b.camel@microchip.com>
References: <20230110050206.116110-1-yoshihiro.shimoda.uh@renesas.com>
         <20230110050206.116110-2-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230110050206.116110-2-yoshihiro.shimoda.uh@renesas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|BL3PR11MB6338:EE_
x-ms-office365-filtering-correlation-id: c5a289d9-6965-42a5-0909-08daf315f07d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eLsfH52GA1vkXhD1cZSXedIY57mznWi0YePGC2jBkjXmt26cD9Z4UosjpPlx8Zr9cghUGPOzlYuNI3UZawGrnURCNFwIsWY3VwCH8N9cKfKPCKX+6VZC2LJW64BDWORsUx6aTBv1q8c85mD1CvCGQBF3elmvnYtMBc2mhaqXdiAgridzuMIROMNMPFuiIozmSRHotiW/6BtjjaaPXveygo5dA0P2E0/wqy8Fno6drgrO+GE7p77gt5UZuuR3fnhSHvtoyHCOXK2pjbRNbuT/GR7JbFlngYDQct1pgG7pa+Q+h59GGAsXVJRZAmtsVVGHSL2OLfPNZfBT5nC/Bq6/ISwQCBza44607D42kwpUbfdMJOn2ODi/UBlxgYhgRN7u23rD22BOdGMA6u74iO5qYzvCgYdN+irAvxio6Krqn1s8buR21ZuK9scpSpEYwdAsswHw2GZ00nBCAfsyyQJDPDHKIWAw63/P2LPz4HjU/Jc4zdXXOdIQQysgSikXmZmi/+9UL+VNPJP50eWNVvO9JCZNJZY5X1qbnGO5FBeKk+EHwRsomZaphd6BIGNqkTV6tJbLiOGew9KDG1S2avb3Ggm8bMdrHsqQ/GTUAsEbyzsns/knzFYrIsZ4/HWdCBWf3gva/ksjoO2jhGuQyIenbhqKIlehEEcLhEwlyhm+7MO1689VV+vB0REMHXtpL490OGaYPGi0Wnv1uozSFt09OAnaDcPxf4AzMKqbiGLj5f4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(6506007)(38100700002)(122000001)(2906002)(478600001)(6486002)(2616005)(7416002)(6512007)(186003)(71200400001)(5660300002)(316002)(83380400001)(38070700005)(8936002)(36756003)(86362001)(41300700001)(64756008)(8676002)(110136005)(54906003)(4326008)(66946007)(76116006)(91956017)(66446008)(66556008)(66476007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bElONUtGb3RTYXg3MEo4MVJSVkFpM0twTG1IdjB0SHZ6N2xMdkRMNnlmbFBw?=
 =?utf-8?B?RDBTbmtWZXdxZmxmTEx1d0JSZUxScFozU2ZpeFhPMWZXcG5MelVOMm5OZTJF?=
 =?utf-8?B?UXkvdWphOURiY3BKTEpoZVlPQUV3VnRxeGg3d3lXY1ZsVXBmUTJlZ21wcGZM?=
 =?utf-8?B?ZU9JUGJzVDMxeWtvQlpTVlF2U2g0UHFmV2RKYkNBbVArcmJJd1ppczVPaTJI?=
 =?utf-8?B?S0tabDhlbk5hQnFCV0FmQ3dQQWFXcDNvQThGdDczNnRaNUozbVlsczlZS05Q?=
 =?utf-8?B?SDYwRHMwNHdmTW1OMGQyNlc2NVN5MmNwYmtKSURQQ1BxMElBR0QrcGhIcEp2?=
 =?utf-8?B?Zk9razZzZWZ6L2VaQzFkeWhXT2RIalJLdmthSEw0d1JvZW9jVEduLzE0ckpE?=
 =?utf-8?B?VUo0ODIycHIxWUVkajc5UHFIMFNzMWZKM1l1ZUxsU3lVTU1vTHU5Y2hEZXRl?=
 =?utf-8?B?d2VkWDdZSXAvT1BYTFRBaEhaYzlVUFRIQ05DdXE4emhYWHpubk1wQUpCWGIv?=
 =?utf-8?B?WTViemEzbm9mRWhnZFpPTzc1dlhKZEJrRFo2Unc5T1JwOE5hKzBoL25yRFZF?=
 =?utf-8?B?QjhPM0lrbTR2VFYrUS9Ta3J4WEdzQTM4SjBzL09TSmFOaTNOeWZxcTVmcXZl?=
 =?utf-8?B?QnVobmZ4Y3lCcEFPWFhaZitWNGhDV0Q4VXE3dVBFTXA0d2lzSDI1OGVQRXdv?=
 =?utf-8?B?VUp6cWJoNjh0TjFlK280MmdUQmRQOUczVGlQNThpWHhZeDIxc2ZQSlU2TU1G?=
 =?utf-8?B?WS9YdDdBSW9PamtqZUNBN3NkNm1TOVQ3amZUZlhlckpXQXVVcVo2ekp1QWg5?=
 =?utf-8?B?ckZzcUp5UUhsQ1BVTk0zM0UyV0R0OFdvRkFzbU1jQlFOR3R0cy9OS3ozcExB?=
 =?utf-8?B?OEhHNkl0TSs1V1ZBL1hHTEVTWEtMMUJvMUJxK2d6RENFUlo2YUR2bkNMUFZn?=
 =?utf-8?B?R2JZYUNMQmU2bFdldCtvYnZMYTZUa2ZNck5IaDZBRXptc0NPWDlKa2d1Nlo2?=
 =?utf-8?B?MVBsZGRLUnRVMFBQRnZ5YjJ5NFo0NmtWWmdUZVQ2N2QxTzFCL1ppT002Uyt5?=
 =?utf-8?B?SnArdGFacGpoRlVJQkgxVGhUQmkvb0dkU0tRTzRrc1dXUUNHT1puK2NHWG1U?=
 =?utf-8?B?Sk1BUSttQndma2puWVFXRTdrUUtSQ1BBN04vb2x2NmptVW1QUTQydUZla1BP?=
 =?utf-8?B?bWx5M0k4Y2sxWmFLcGxkZ1R2c21EVTB0a1hkbmxFYkZxT0doeWNQSE0xV1A5?=
 =?utf-8?B?T3haL3hEbS9LK0t2WnU5Ym82aGdrS2h3TXkycTA4a1BEMW00TjBtK3Q3Sldl?=
 =?utf-8?B?Wlhocmxzakh3R05JdW0yQVdvdzk0Q2FtdzVXbmNtWXFoNHZMWXFrVzdwVkJk?=
 =?utf-8?B?dVJYTTdVMW43SXB5Nlc2MmovMDRNeEppN2Zmb3R3enhFbHZKU1hjc0t3NnJI?=
 =?utf-8?B?bkZYQUNZQ2wrVml4V0FyME5Jby93bEt3M3Q4R2N2RHZWdEVlZyt4a3JIcWZu?=
 =?utf-8?B?c1ZjdW5FZVBVUGw2RlM5SlBlWkEzbVN4Q3hoMUE0Tmp0MlVKdXI5TDlhWldp?=
 =?utf-8?B?eTAyS2RSNDcrazhoYmVUU0hvSTlya29iT09UemdhdHFmbW5QWVVPTElzRUlL?=
 =?utf-8?B?T0dZTEhMdGk2S2d3cHFNVFhmUzRBcUJlVytHajVkUUEyWVNyZWNsak1jTG1s?=
 =?utf-8?B?Z3MyTnhsNzFCOGlZb0RYWlZhNndWVThPRXJZSUNvZEYxVisxUyt4TllSR2Rq?=
 =?utf-8?B?Vlh6MXgzSFlNTFZVVmpoeVpPWVBNc0VuS3JyUXNtWi9EMXh1b0JXT3V3K2x2?=
 =?utf-8?B?Uy9wd282VFFNckplUzRtdzN2Q3Z4U0ZCSHBiTlI1Zm9ranNma2YwaU41STZG?=
 =?utf-8?B?RlhoT3NBY1d4UVU0ZHRaREYxRHNxcHJFa2dyMTlVaWtpaUh3emo1RlZiaVVD?=
 =?utf-8?B?RUNLcWpHeS9BVjRqWTRSenVsc25HNnF6dHAxdHlPRVhGLzczMnBuVEliaWMz?=
 =?utf-8?B?TXk4YnRFRXd0RVp4SkRjdFVhTHhKSHVIUmlmNVN3QVpkam5rZU44YmJtZUFV?=
 =?utf-8?B?UUNFRW9sclVwWTE5Sk5PSDRnaFc5SmdjUGJlbHNreno3NEJOemk4aUhhZG9V?=
 =?utf-8?B?MnZ2Vzl4b3l3S2NZelY4SU1vN0xvR0dJcDBJZmhSNGJhVVRQTW51Z2hQd2tl?=
 =?utf-8?B?WXFWM2ZLWStoZXUzVmRVUmlIZlRVU1ArditZK0lYMTloZWQ5RHdvczVnQjlS?=
 =?utf-8?Q?rGPC4dQqoJIym89hx34B2XzceFLuzjs6UVKdzhz23U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35575824209D1D48A83B3CF9A746E995@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a289d9-6965-42a5-0909-08daf315f07d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 14:21:18.0779
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UovtIeLE+RqkEKKg5Ee4cgOxgfl1ZZfpM32FO39H9a3AMquVaNGxX5JyE6VVTwNF4RutnGsJdoJBHOOLVeNNGvRqEkPG7X3BcAfvD9KGssE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6338
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWW9zaGloaXJvLA0KT24gVHVlLCAyMDIzLTAxLTEwIGF0IDE0OjAyICswOTAwLCBZb3NoaWhp
cm8gU2hpbW9kYSB3cm90ZToNCj4gSWYgYSBuZXcgZmxhZyAob3ZyX2hvc3RfaW50ZXJmYWNlcykg
aW4gdGhlIHBoeWxpbmtfY29uZmlnIGlzIHNldCwNCj4gb3ZlcndyaXRlIHRoZSBob3N0X2ludGVy
ZmFjZXMgaW4gdGhlIHBoeV9kZXZpY2UgYnkgbGlua19pbnRlcmZhY2UuDQo+IA0KPiBOb3RlIHRo
YXQgYW4gZXRoZXJuZXQgUEhZIGRyaXZlciBsaWtlIG1hcnZlbGwxMGcgd2lsbCBjaGVjaw0KPiBQ
SFlfSU5URVJGQUNFX01PREVfU0dNSUkgaW4gdGhlIGhvc3RfaW50ZXJmYWNlcyB3aHRoZXIgdGhl
IGhvc3QNCj4gY29udHJvbGxlciBzdXBwb3J0cyBhIHJhdGUgbWF0Y2hpbmcgaW50ZXJmYWNlIG1v
ZGUgb3Igbm90LiBTbywgc2V0DQo+IFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSB0byB0aGUgaG9z
dF9pbnRlcmZhY2VzIGlmIGl0IGlzIHNldCBpbg0KPiB0aGUgc3VwcG9ydGVkX2ludGVyZmFjZXMu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBZb3NoaWhpcm8gU2hpbW9kYSA8eW9zaGloaXJvLnNoaW1v
ZGEudWhAcmVuZXNhcy5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvcGh5L3BoeWxpbmsuYyB8
IDkgKysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L3BoeWxpbmsuaCAgIHwgMyArKysNCj4gIDIg
ZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3BoeS9waHlsaW5rLmMgYi9kcml2ZXJzL25ldC9waHkvcGh5bGluay5jDQo+IGluZGV4
IDA5Y2M2NWMwZGE5My4uMGQ4NjNlNTU5OTRlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9w
aHkvcGh5bGluay5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9waHlsaW5rLmMNCj4gQEAgLTE4
MDksNiArMTgwOSwxNSBAQCBpbnQgcGh5bGlua19md25vZGVfcGh5X2Nvbm5lY3Qoc3RydWN0IHBo
eWxpbmsNCj4gKnBsLA0KPiAgCQlwbC0+bGlua19pbnRlcmZhY2UgPSBwaHlfZGV2LT5pbnRlcmZh
Y2U7DQo+ICAJCXBsLT5saW5rX2NvbmZpZy5pbnRlcmZhY2UgPSBwbC0+bGlua19pbnRlcmZhY2U7
DQo+ICAJfQ0KPiArCWlmIChwbC0+Y29uZmlnLT5vdnJfaG9zdF9pbnRlcmZhY2VzKSB7DQo+ICsJ
CV9fc2V0X2JpdChwbC0+bGlua19pbnRlcmZhY2UsIHBoeV9kZXYtDQo+ID5ob3N0X2ludGVyZmFj
ZXMpOw0KDQpCbGFuayBsaW5lIGJlZm9yZSBjb21tZW50IHdpbGwgaW5jcmVhc2UgdGhlIHJlYWRh
YmlsaXR5Lg0KDQo+ICsJCS8qIEFuIGV0aGVybmV0IFBIWSBkcml2ZXIgd2lsbCBjaGVjaw0KPiBQ
SFlfSU5URVJGQUNFX01PREVfU0dNSUkNCj4gKwkJICogaW4gdGhlIGhvc3RfaW50ZXJmYWNlcyB3
aGV0aGVyIHRoZSBob3N0IGNvbnRyb2xsZXINCj4gc3VwcG9ydHMNCj4gKwkJICogYSByYXRlIG1h
dGNoaW5nIGludGVyZmFjZSBtb2RlIG9yIG5vdC4NCj4gKwkJICovDQoNCkNvbW1pdCBtZXNzYWdl
IGRlc2NyaXB0aW9uIGFuZCB0aGlzIGNvbW1lbnQgYXJlIHNhbWUuIGZvbGxvd2luZyBjb2RlDQpz
bmlwcGV0IGltcGxpZXMgaXQgdGVzdCB0aGUgU0dNSUkgaW4gc3VwcG9ydGVkIGludGVyZmFjZXMg
YW5kIHNldCBpdCBpbg0KcGh5X2Rldi4NCg0KPiArCQlpZiAodGVzdF9iaXQoUEhZX0lOVEVSRkFD
RV9NT0RFX1NHTUlJLCBwbC0+Y29uZmlnLQ0KPiA+c3VwcG9ydGVkX2ludGVyZmFjZXMpKQ0KPiAr
CQkJX19zZXRfYml0KFBIWV9JTlRFUkZBQ0VfTU9ERV9TR01JSSwgcGh5X2Rldi0NCj4gPmhvc3Rf
aW50ZXJmYWNlcyk7DQo+ICsJfQ0KPiAgDQo+ICAJcmV0ID0gcGh5X2F0dGFjaF9kaXJlY3QocGwt
Pm5ldGRldiwgcGh5X2RldiwgZmxhZ3MsDQo+ICAJCQkJcGwtPmxpbmtfaW50ZXJmYWNlKTsNCj4g
DQo=
