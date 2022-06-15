Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423A754C39D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbiFOIgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiFOIgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:36:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9DB2228C;
        Wed, 15 Jun 2022 01:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655282209; x=1686818209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q9UzKDrrCvc/AjbauW0KbLd/M/30LI7psbii3nyc+g8=;
  b=x8ShvuHDw/0bVYRVdgNJR0/3hW4Nfn6+mDVOeSiUIo61Fb1/yLjF7wXu
   3P4RZveF16T/GgUrs9DoIZL1Zp26tAsoiADsX6lEonrOMwxI5Khz0oKFN
   yhLrcUtOXxbhMLod797WeF0Idsozvh8kwQSO++YU+SfbWfItTs/zZbyz4
   7qyG994fSCistxo8zDv8W2hnfpX3p2N9ei/jj1XaE4gXKRxFI+4Y5AwtE
   l3+svdUBNKbwuUp3zMzE781yspIlB3uY+7zChygKNySpaswrz7cWX0NC5
   VXPTFzg4z2cbzrnoGyIr/LpmTU1uoveRiDQFm2tU554dH/0gZVOtF/D3x
   A==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="160399828"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2022 01:36:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Jun 2022 01:36:44 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Wed, 15 Jun 2022 01:36:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMNrhR1UMgvzhhKHauob5OCrzam5FFcTwrV2kgX33767snGfJ9L8+9jdXPMynodUkqhIcHhgIZP0Sa2WtyyyKr6FYuzKAgz6RvM2lCzdFAysDHGssggElX2PruRfnGa+4aEGdz1vcQsdOdo6EyVw1UgK9keZq2X0rQ3XKaYoFbVU9+Pf8tW8S0vlkZ/mgDp/l2UJR18diQLePzj+iI+R7v1mQ4Q0hUoUDHs88tmAvBBup3ZK1bggitkWmBx/9lUynwYcdq9Pd3PPPskxViHIHNu565URTgj0aogfXqhyyx8mlZXMy/bZrBYeWO8ZKHakDflgW4qt/WtCe3xGBz2weA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q9UzKDrrCvc/AjbauW0KbLd/M/30LI7psbii3nyc+g8=;
 b=l92ix8qtisZ4pNg/5kWYId3yGN31XutkPV2cV3AaDIzGIMbH38pphGO6GgvLhKAxd2I1lJ9w0OVA1RNILFUrhRyR4/DQtV7eG70kWv/h4EesX/ZhtRh57LrpYupPmfEDZ2N9VCIyHYSzPADqgb0HdJlDMf3l0BydE9U03GaJoApivcLekz5TnH4DV9++FWJrMBOvtbZGgLZ9vvbAaIXMYvrW2CozRJwnBvQzAOdERefql3DEKrKBigNT8TDiV2iQT+yT8nsnpbVGOfhWnONmBWo2fyDkDbylnL7hnJ/8/btIFTIpPMeKYQbBdSRyKgIlnVwqVSW572pgesIz9PhHSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q9UzKDrrCvc/AjbauW0KbLd/M/30LI7psbii3nyc+g8=;
 b=qNjjl6PeiZjS3NbIIe5ju94X/GFCTcDPicI/Zw6zrjZo1GtxPliPkaxmVDQ41B2rYHXPiZtnkKPbgPOo7AErW49i6rryBlvSo7KbptDk5BltmxLhRPdgQtcrnyn6/Zbu+zCId8kRExmZL1VgOiGFqnoisfCgIKOoXljQSe2pLYs=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 BYAPR11MB2711.namprd11.prod.outlook.com (2603:10b6:a02:c2::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.16; Wed, 15 Jun 2022 08:36:38 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5332.020; Wed, 15 Jun 2022
 08:36:38 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 10/15] net: dsa: microchip: move the
 setup, get_phy_flags & mtu to ksz_common
Thread-Topic: [RFC Patch net-next v2 10/15] net: dsa: microchip: move the
 setup, get_phy_flags & mtu to ksz_common
Thread-Index: AQHYdBI9Ml5q7d2ksk2XOie/Umo0s61OpaWAgAGYSgA=
Date:   Wed, 15 Jun 2022 08:36:37 +0000
Message-ID: <ac6b135a49a662aee2a3a78f5a560341e738fd63.camel@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
         <20220530104257.21485-11-arun.ramadoss@microchip.com>
         <20220614081523.wseqxqw576nyzerh@skbuf>
In-Reply-To: <20220614081523.wseqxqw576nyzerh@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5d2ef58-b76d-4277-569a-08da4eaa29f1
x-ms-traffictypediagnostic: BYAPR11MB2711:EE_
x-microsoft-antispam-prvs: <BYAPR11MB27115C2B36793A3367F246B9EFAD9@BYAPR11MB2711.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8uLA15GolDR7ApE/nrWYpcwgaWEy3vNx5Zh9LlmBERYh3ooVsDSV9SmJxEEfWWXqr94aOYEm5xze8nTpsEF6NpC5RV0Ly5wlgtXRraWqrh6GJteO+KLZWSQB55Dfb273YxRAQrxdwNWId0vyLzaTojVzcaPJpaesI0kJGXj0ycQeVLxKwuAAGKqpiZmN3JyQo/8hWzGElVM1t3QnEirj8skyk94c7XEvapzLWNGqJx5Dqmfg86v82Z29mBMXaQOSnFoxsd/RWJDnD+JXmagTGKO3+8MfCv/wz8sZ2Y/E3MrlWdenlQQJQxVk383XGM/3MYIQ2RLxRWtDjFrp0U0HVEPl0yiQ6Ci3oD6qWXr3yYKof3vQyasdKdTSzKNMQG97shpqs7XVsnlcRQzrM71nljxZkmnq//iBiyCJN4hxMkQm9ysqoX0OwMPUO6FD3BsJ0ciOawbUrK8gWfhzYwnBhUEoPXMEHCHsQSHDdvtINSNu1oZBGlLGuVborviJsVptnMWPCrfvayGhevOurvoXnPPn174wrs1qStHMed4nIUh8gdjMs/Yyr1kG7MYOUOo10DnEfmYX+rdLRQZdN31ASV1u/3MOtY1gOR4cTQFbMJNjx56/TypHKIS25FLMl2qgQhzRNA2No/taID711zNs6tEvLbjA3GHrP+8uylGISCNZAFbK6oJ5gHZPyP8qerQGD8bphHtYdxEhFpzTCRNKlf4YGalrs+M0JQb9s5Fv54=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(26005)(2616005)(54906003)(6512007)(6916009)(2906002)(4326008)(38070700005)(86362001)(6506007)(66446008)(316002)(8676002)(91956017)(64756008)(38100700002)(76116006)(66946007)(66556008)(66476007)(8936002)(6486002)(7416002)(71200400001)(186003)(83380400001)(508600001)(122000001)(5660300002)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V01LSStoNkpvOVJVeWhJUGRpeHpUQU5lUTBvb0ZVRCtEam02Vk1NZ2RobEtJ?=
 =?utf-8?B?RG5Bbko5SGloQUVLZGNiNHpiaTNLcEwreC95OWdNM0lTYjBMTnArQW1Wdm1V?=
 =?utf-8?B?aHExL1BtWWxDalBPT3JPT1ZwM09ESk5JS2N0bFFBcDV4d1k3dFkrSkJQRVRC?=
 =?utf-8?B?OXRSK1pkOEdsRWhGRklJODJMaGh4TldCcUxUVk9HakFURGZRNnBDMDVwazgy?=
 =?utf-8?B?TklRM2l0S3MzMURUOGNweCtyeWFteXM0dEY3UUs1RXNMa1ZTamlLT2Q3bEo3?=
 =?utf-8?B?KzBGeGYvS3JmKzVaQU5ESWlia3pKVGM4elpnbVNhTnhQcnV2UzhFSlFpSkNM?=
 =?utf-8?B?c244QUp0TFZZMEZPbEwzYkt2ZllYa0R3QTBBWDBkTTloMFMrTkJTT0VNS3pY?=
 =?utf-8?B?UGRZT0dsT25XKytBMFp4a3BNNmJLdkZCbnJHdmxkeDA4Vi9hQ1VJT1FnTzAw?=
 =?utf-8?B?NGxkSHlIM0ZrODFIQkhMUnFQd090dFhUYUVFMXVkcXJPQW51VE1ZYjNXQnVj?=
 =?utf-8?B?TE0xT1FCYmZQQ28zMkQ5M2VRb0NYZ0xYNU56YmhoQytvcDRrRzhDSExMU0hv?=
 =?utf-8?B?S0NlWnJHbVBXZ0JQWkRWdzBNQiszQnR0L09ob3lUREdHOXVneU5LOHJ2TlRY?=
 =?utf-8?B?M2tJWVQxVkRNaFhWS0RnclZRbmhueWs3MDJpS3h1ZmVFNVJ0SzdGVVJsWUVS?=
 =?utf-8?B?cS8rek9XOG1FUGdVVDI1Q2RkTkh5RWwrTHZJOTFldEhySmRSNS9JOFlXbmFQ?=
 =?utf-8?B?YTdRNkdvaWY0emxJekprVkM1V2crbDVlbTVnMVRycXgwRkVJUXpoSDhqcUVw?=
 =?utf-8?B?SlRUMHdhTlhvNXl0WFhiaDBTQmVLNzdQamZrQlBRZlFibWY5dHdFaVJ6cnRj?=
 =?utf-8?B?M0RQU1gxMHlWUVZOMDBpTUVyVGswRkd6QUt4Rjd2blk5bnFJQWdKVjR0UEtl?=
 =?utf-8?B?WCtQeEJVV1p3bkwrRkNVSkZ6QzkrQThDM2l0ZFo4d25vanZLeGprR2E1bm9U?=
 =?utf-8?B?QjdRaVhSY25xWlZSTlJyTm96WHNlWGFYK0NjR05VRkJUMGVNZHlsWVI2dVhK?=
 =?utf-8?B?aWJGUzZNNTFObStIeS9tOFF2N0lkUktNS245V1dwLzZmYkNkRE5FY2M4ODB1?=
 =?utf-8?B?bGZHazlZMjU5T2cyZjlqdzVSYmVZMU9KS3ltT3lIeXJKTDVzM0FVUlFBL2Vm?=
 =?utf-8?B?Rm9TRjhoekh4b0hJVnFKUS95MzZhdWpyY25BK1A4WkN3TzAyQ3lZcmxsTHF0?=
 =?utf-8?B?ZkxxMCs0L3FBWWI5TzFJNjhacCtyOGl1NmpRRzZHQWJ0MmtpWE9kbW1SYmhB?=
 =?utf-8?B?R0hpcXdWQ1dQK01qUnlPN3ptMzhTLzU4WWRxZWtFQ2V4U1RaUjdEYTFSdEdp?=
 =?utf-8?B?Vzk2UlkwaHZURGFYV0xZL3QzRkVWRjRGTHV3c3FyM052Ujd5eGxMMGlWNXVp?=
 =?utf-8?B?K0hEMDhST3BZUTZyLzRaZVhkcURZSlVkMXZaQ05FNUExYmd0S3kvdytGY0xv?=
 =?utf-8?B?MWE4cGNCQ3o1UnViU25Ka0N5MEl3RWhzT3FvaDhneUVRQWExWlh6a3VrQ2M2?=
 =?utf-8?B?ZGdwUEkxaXNTanFFZWt2RmpwUUNWdWM0azdkQkFCQm9DblpGYWQrN3JNdjA5?=
 =?utf-8?B?Yy9nYlpqc1h2WnFMSDZhelduTVhDd1ZQTTZoeWVxcTVITWlTZTd2ZnFoSm9z?=
 =?utf-8?B?MVBXaEh0YlhjUm5STndZTlJFejRTV0Q0alYvOG1TazRuNWtUdElwWXdzK0tH?=
 =?utf-8?B?Nmg1WmYzUW1PNmJDTXNHclZXcnZVa01ybWpoL0NuR29rZG9zbGx5L0xRSEFK?=
 =?utf-8?B?NHJ0a0ZMMjM5UTBzdDNQL0lob3FhUkRUdmxuWE90THJCMzJXZDQ4MUNCQ0R6?=
 =?utf-8?B?RDdtdWttT3FablRjM1NKYkUyWlhZQW5pc254SjJndCswVGJMc1dUNHdZekZ5?=
 =?utf-8?B?Smsyb2FYRmludlRMTzlTQm1zVDRNaVg0ZFNzWDd5Um85ckRidHpTUWh0alJ2?=
 =?utf-8?B?V2l6UjZzakh4UWJBeXFlU3RGNlFseVgyby81NERaVThaa1ZjbkFpZVZwUXNr?=
 =?utf-8?B?TWdQem9KMHkzMDF5aUw1RmMvQ1ZERFZCRWZDVGZPcUxvdXExRnVoeW5pQ2hI?=
 =?utf-8?B?SktsRGVJem1WMklUV01HNHZLVDd5QU81N2xwejdFVVRBdWxyYnptMy9rWnpR?=
 =?utf-8?B?bUNuR3FiMElDU0JpSEFBa2I2cndHeTUzbmpjVUlzdU1MWUxFWGZUODcxQnZV?=
 =?utf-8?B?M1JJNUFjT0Vyd3BHaCtNUzdDYTg5Qndsd1ROYnpNWHAwd0t2ZkdtZDExcUJY?=
 =?utf-8?B?bGR5YmxvK1pNM0I3QWxiY1NWaWpjdytpZUZFT2M3WStCWTVVSVgwWG5id3k5?=
 =?utf-8?Q?zee+oRgnjvJS6xIjxm6HM0Fe77yQrl1ysonjP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F21BF22A9405B408308C81C4F1D58B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d2ef58-b76d-4277-569a-08da4eaa29f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 08:36:38.0810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pI7x850LMSEzvbMX2pzSVq8+qvDrLq5lx3CKFA5Yoxpzj9xuMH8sYVUQIixR99aE+BdGFkPwex7zyuhVax/K6j1AXUB/dEnAT75zdDedTxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2711
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA2LTE0IGF0IDExOjE1ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBN
YXkgMzAsIDIwMjIgYXQgMDQ6MTI6NTJQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBUaGlzIHBhdGNoIGFzc2lnbnMgdGhlIC5zZXR1cCwgZ2V0X3BoeV9mbGFncyAmIG10dSAgaG9v
ayBvZiBrc3o4Nzk1DQo+ID4gYW5kDQo+ID4ga3N6OTQ3NyBpbiBkc2Ffc3dpdGNoX29wcyB0byBr
c3pfY29tbW9uLiBBbmQgdGhlIGluZGl2aWR1YWwNCj4gPiBzd2l0Y2hlcw0KPiA+IHNldHVwIGlt
cGxlbWVudGF0aW9ucyBhcmUgY2FsbGVkIGJhc2VkIG9uIHRoZSBrc3pfZGV2X29wcy4gIEZvcg0K
PiA+IGdldF9waHlfZmxhZ3MgaG9va3MsY2hlY2tzIHdoZXRoZXIgdGhlIGNoaXAgaXMga3N6ODg2
My9rc3M4NzkzIHRoZW4NCj4gPiBpdA0KPiA+IHJldHVybnMgZXJyb3IgZm9yIHBvcnQxLg0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFydW4gUmFtYWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9j
aGlwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1
LmMgICAgfCAxNyArKy0tLS0tLS0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5
NDc3LmMgICAgfCAxNCArKysrLS0tLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tz
el9jb21tb24uYyB8IDUwDQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmggfCAgNyArKysrDQo+ID4gIDQgZmls
ZXMgY2hhbmdlZCwgNjggaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pDQo+ID4gDQo+ID4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ID4gYi9k
cml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiA+IGluZGV4IDUyOGRlNDgxYjMx
OS4uMTA1OGI2ODgzY2FhIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6ODc5NS5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1
LmMNCj4gPiBAQCAtODk4LDE4ICs4OTgsNiBAQCBzdGF0aWMgdm9pZCBrc3o4X3dfcGh5KHN0cnVj
dCBrc3pfZGV2aWNlICpkZXYsDQo+ID4gdTE2IHBoeSwgdTE2IHJlZywgdTE2IHZhbCkNCj4gPiAg
ICAgICB9DQo+ID4gIH0NCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3o5NDc3LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3
Ny5jDQo+ID4gaW5kZXggZDcwZTBjMzJiMzA5Li5kNzQ3NGQ5ZDQzODQgMTAwNjQ0DQo+ID4gLS0t
IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmMNCj4gPiArKysgYi9kcml2ZXJz
L25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzcuYw0KPiA+IEBAIC00Nyw5ICs0Nyw4IEBAIHN0YXRp
YyB2b2lkIGtzejk0NzdfcG9ydF9jZmczMihzdHJ1Y3Qga3N6X2RldmljZQ0KPiA+ICpkZXYsIGlu
dCBwb3J0LCBpbnQgb2Zmc2V0LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICBiaXRzLCBz
ZXQgPyBiaXRzIDogMCk7DQo+ID4gIH0NCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNy
b2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gaW5kZXggOGY3OWZmMWFjNjQ4Li4xOWY4ZTQ5MmQzYWEg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMN
Cj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+IEBA
IC0xNiw2ICsxNiw3IEBADQo+ID4gICNpbmNsdWRlIDxsaW51eC9pZl9icmlkZ2UuaD4NCj4gPiAg
I2luY2x1ZGUgPGxpbnV4L29mX2RldmljZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvb2ZfbmV0
Lmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9taWNyZWxfcGh5Lmg+DQo+ID4gICNpbmNsdWRlIDxu
ZXQvZHNhLmg+DQo+ID4gICNpbmNsdWRlIDxuZXQvc3dpdGNoZGV2Lmg+DQo+ID4gDQo+ID4gQEAg
LTU5Myw2ICs1OTQsMTQgQEAgc3RhdGljIHZvaWQga3N6X3VwZGF0ZV9wb3J0X21lbWJlcihzdHJ1
Y3QNCj4gPiBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0KQ0KPiA+ICAgICAgIGRldi0+ZGV2X29w
cy0+Y2ZnX3BvcnRfbWVtYmVyKGRldiwgcG9ydCwgcG9ydF9tZW1iZXIgfA0KPiA+IGNwdV9wb3J0
KTsNCj4gPiAgfQ0KPiA+IA0KPiA+ICtpbnQga3N6X3NldHVwKHN0cnVjdCBkc2Ffc3dpdGNoICpk
cykNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBrc3pfZGV2aWNlICpkZXYgPSBkcy0+cHJpdjsN
Cj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIGRldi0+ZGV2X29wcy0+c2V0dXAoZHMpOw0KPiA+ICt9
DQo+ID4gK0VYUE9SVF9TWU1CT0xfR1BMKGtzel9zZXR1cCk7DQo+IA0KPiBJIHNlZSB0aGVzZSBj
aGFuZ2VzIGFzIGJlaW5nIG9mIHF1ZXN0aW9uYWJsZSB2YWx1ZSBpZiB5b3UgZG8gbm90IHBsYW4N
Cj4gdG8NCj4gYWN0dWFsbHkgc2hhcmUgc29tZSBjb2RlIGJldHdlZW4gLT5zZXR1cCBpbXBsZW1l
bnRhdGlvbnMuIFdoYXQgd291bGQNCj4gYmUNCj4gZGVzaXJhYmxlIGlzIGlmIGtzel9jb21tb24u
YyBkZWNpZGVzIHdoYXQgdG8gZG8sIGFuZCBrc3o4Nzk1LmMgLw0KPiBrc3o5NDc3LmMgb25seSBv
ZmZlciB0aGUgaW1wbGVtZW50YXRpb25zIGZvciBmaW5lLWdyYWluZWQgZGV2X29wcy4NCj4gQ3Vy
cmVudGx5IHRoZXJlIGlzIGNvZGUgdGhhdCBjYW4gYmUgcmV1c2VkIGJldHdlZW4gdGhlIHNldHVw
DQo+IGZ1bmN0aW9ucw0KPiBvZiB0aGUgMiBkcml2ZXJzLCBidXQgYWxzbyB0aGVyZSBpcyBzb21l
IGRpdmVyZ2VuY2UgaW4gY29uZmlndXJhdGlvbg0KPiB3aGljaCBkb2Vzbid0IGhhdmUgaXRzIHBs
YWNlICgxMCUgcmF0ZSBsaW1pdCBmb3IgYnJvYWRjYXN0IHN0b3JtDQo+IHByb3RlY3Rpb24gaW4g
a3N6ODc5NT8pLiBUaGUgZ29hbCBzaG91bGQgYmUgZm9yIGluZGl2aWR1YWwgc3dpdGNoDQo+IGRy
aXZlcnMgdG8gbm90IGFwcGx5IGNvbmZpZ3VyYXRpb24gYmVoaW5kIHRoZSBjdXJ0YWlucyBhcyBt
dWNoIGFzDQo+IHBvc3NpYmxlLg0KDQpPay4gSSB3aWxsIHRyeSB0byBtb3ZlIGNvbW1vbiBjb25m
aWd1cmF0aW9uIGJldHdlZW4gdGhlIHN3aXRjaGVzIHRvDQprc3otPnNldHVwIGFuZCBoYXZlIGxl
c3MgY29uZmlndXJhdGlvbiBpbiB0aGUgaW5kaXZpZHVhbCBzd2l0Y2ggc2V0dXAuDQoNCj4gDQo+
ID4gKw0KPiA+ICBzdGF0aWMgdm9pZCBwb3J0X3JfY250KHN0cnVjdCBrc3pfZGV2aWNlICpkZXYs
IGludCBwb3J0KQ0KPiA+ICB7DQo+ID4gICAgICAgc3RydWN0IGtzel9wb3J0X21pYiAqbWliID0g
JmRldi0+cG9ydHNbcG9ydF0ubWliOw0KPiA+IEBAIC02OTIsNiArNzAxLDIzIEBAIGludCBrc3pf
cGh5X3dyaXRlMTYoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQNCj4gPiBhZGRyLCBpbnQgcmVn
LCB1MTYgdmFsKQ0KPiA+ICB9DQo+ID4gIEVYUE9SVF9TWU1CT0xfR1BMKGtzel9waHlfd3JpdGUx
Nik7DQo+ID4gDQo+ID4gK3UzMiBrc3pfZ2V0X3BoeV9mbGFncyhzdHJ1Y3QgZHNhX3N3aXRjaCAq
ZHMsIGludCBwb3J0KQ0KPiA+ICt7DQo+ID4gKyAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9
IGRzLT5wcml2Ow0KPiA+ICsNCj4gPiArICAgICBpZiAoZGV2LT5jaGlwX2lkID09IEtTWjg4MzBf
Q0hJUF9JRCkgew0KPiA+ICsgICAgICAgICAgICAgLyogU2lsaWNvbiBFcnJhdGEgU2hlZXQgKERT
ODAwMDA4MzBBKToNCj4gPiArICAgICAgICAgICAgICAqIFBvcnQgMSBkb2VzIG5vdCB3b3JrIHdp
dGggTGlua01EIENhYmxlLVRlc3RpbmcuDQo+ID4gKyAgICAgICAgICAgICAgKiBQb3J0IDEgZG9l
cyBub3QgcmVzcG9uZCB0byByZWNlaXZlZCBQQVVTRSBjb250cm9sDQo+ID4gZnJhbWVzLg0KPiA+
ICsgICAgICAgICAgICAgICovDQo+ID4gKyAgICAgICAgICAgICBpZiAoIXBvcnQpDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgIHJldHVybiBNSUNSRUxfS1NaOF9QMV9FUlJBVEE7DQo+ID4gKyAg
ICAgfQ0KPiA+ICsNCj4gPiArICAgICByZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lN
Qk9MX0dQTChrc3pfZ2V0X3BoeV9mbGFncyk7DQo+ID4gDQo+ID4gLS0NCj4gPiAyLjM2LjENCj4g
PiANCj4gDQo+IA0K
