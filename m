Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BDA68972E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjBCKnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCKno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:43:44 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900C9B443;
        Fri,  3 Feb 2023 02:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675421022; x=1706957022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m22x+TfwzcHJymOMPM3SDzSr5Z7OnggXM+QF+nNVnrA=;
  b=E/TogB1BsBP1XsWueCzU5YYivR95J2uCyfVsYfr8LttOEzICQ20f74Vd
   8cFbjLjxEqPSzF/B7p4+lnY9fj4C4+jmjfNveA41EzfpjOwZwQR+izDDe
   dOL/HMCXPj74z+B8qUm40LTo/oKABHcscX8zAWRn3pKsjqByb4znKtWHZ
   Kcx3M/VUnghM6RtjqxaAbWJTOnIUZ+OlYlzy2sUBXw1HzivKIk2W0Nt//
   gR6MjEzdXgDRm3A2LW7Xk5GnMpn8mGvXh/iYl1hJScYB6FXoTAepOE8W6
   rK9+xgEheaUkYYdNw96SOKlTwHHkkJgQsTZnR/XU0LeneKIXiH/QMfEym
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,270,1669100400"; 
   d="scan'208";a="210462710"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2023 03:43:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 03:43:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 03:43:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9pJ0PFjkbHMvOmTJ/xWz/SWjJ3Moh07n2obFBkWIB1JlQdku2V+okQJ6ulca6IyHjPezka6IyfvihrYrFs5YO0Sp1vYHv39S/wxudOfFRcmr97L3JaWymJ0w1zLLlVowGTrjKkeIaE1ez6MjYTR0XlL7DPKZ2FFYCia0+PT459n3t3GOxMTwS9N4mq92M+2sp7XoofXr2J8IgOlnJsci510YR/xvU2CpvDMkVAdCKacCauCt+i3zFGIYQwoovJa8xVGgwcVkjlwCcNuAX06Re/4wizGQmeJUXr2isUXyVr9BuzpxvgdXeFAgHDjoLI5ALdf3U/kpXSeZgTNDm+Agg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m22x+TfwzcHJymOMPM3SDzSr5Z7OnggXM+QF+nNVnrA=;
 b=QN+dQ2Yj0ZV9CPXJosm9zcuO0yYihSrdDfrdC5WCjajheut2232vQ63iNBA2t21Rg2hVF6e/0E7GspVTcI+OOJ5B8Vt+DWHGqt9mVQP8zqRqAH5EFqnSpl7cIDM/UqzxdNw/WFakoyE0DmVihDwUWTMAykxQ+i+fbeFqvmP6KQ8GtFCs06Ho8gQyB88NoL2cvoLyG+yiDMN9FBQAurYbxxqd1xHbki1Q+XqJJGm5MLp41m9kfQ6d5DH71jSjJoPwOUZNQN4/ZU0SzpL4/QQZSsjWCdDCItwx4qS3iySgloc7uzpsNPgNwg2CED360QAG9DPVgYZJeu154p5BbN/ABA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m22x+TfwzcHJymOMPM3SDzSr5Z7OnggXM+QF+nNVnrA=;
 b=qoKNgP3aa7zs0XBLz72/MT4sxExUsRdcsP5ecVtc+NyVjGBcRLxmB/VzmFkXmoJTlFdhMefnRYc6eJQCxz5GtEue6vC/1pe6xJilgBwMzFxfM5yyMjQUa3GU9RqAQ/EVxu9b2YvIBZ+QoRKnKPAoRn4+AJ56yI4C2Px6mXRnUr8=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by PH7PR11MB7596.namprd11.prod.outlook.com (2603:10b6:510:27e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 10:43:40 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::8ac6:8219:4489:7891%4]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 10:43:40 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <andrew@lunn.ch>
CC:     <olteanv@gmail.com>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <pabeni@redhat.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next 04/11] net: dsa: microchip: lan937x: update
 port number for LAN9373
Thread-Topic: [RFC PATCH net-next 04/11] net: dsa: microchip: lan937x: update
 port number for LAN9373
Thread-Index: AQHZNwYaVDQEHWGrWE+HhYvdx0RH7q67xWwAgAFFmYA=
Date:   Fri, 3 Feb 2023 10:43:40 +0000
Message-ID: <e4344f16e1c0a87b533ad9d87c2306dc53214308.camel@microchip.com>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
         <20230202125930.271740-5-rakesh.sankaranarayanan@microchip.com>
         <Y9vUflgHqpk44oYl@lunn.ch>
In-Reply-To: <Y9vUflgHqpk44oYl@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|PH7PR11MB7596:EE_
x-ms-office365-filtering-correlation-id: e242453b-939f-4707-4f70-08db05d38365
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dXUzpgjHm6mzTwDlQz1pL5vWavQayRcVl1YvGRMY1DXzOtaZ9cbkBfGa+4N830u7JUy3+tFC0cCwuv8WuYZ3pFjxa0zpOq5IMCvPhzqdODGVjphZYtbp10Hebkbcx0R8lHK0FUzgiTdtayXPffDDocG+O399SPrFXNqygKZNtRVpOxn2Xn6aLS45XzmA6wNZRqUQUrhrJG4zxwcaUjXNT02HEW6U4Kpmp0jWweYaipVOj+BM/A+lwsizMBmowmTWzRvSSN0cAG+Q+gechHyqGTA3BJgVRv4eNXU1BSeYmdxOezsd+kDgqugDeYXenmz9HtHZavELqMt0Ci2lm/WtPyHAb3XDtZYsrYCrtfFrV9Fhrd4GHGkRofeus+/Sd5v3f7kFufAfl/3NdRc/bWuROszkLtYSgOyqm4Kd0EG4Wepn/PHKhzR7zsSZLb5KSnKZAWDFOsVilvsQaqzUtiE0d2uGHiCd+h+AdWCLuJuS/vJpBOfxX9bBlNE42Ts5Mm+9eEpZNdJEBg/nhnAQQOb3eqC54aIhXISYGsCAkShUq5sOrlOwEKliFriZTLflwVReK/eLrpNmZJuOvg2iNWZopi55Mz8rnoo5/PtTJmL5mJVC2FwD1F5dZZBfbA4hyEdh2CRxm7onSB2cemOJlom5dKg2BT+VuhLh86w0bHCXOh3yg//Gc3WhsmcJE8Ld2Qm+gh1Y02DKvMyr/Ah0EIUYKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199018)(38070700005)(4744005)(2616005)(83380400001)(122000001)(38100700002)(76116006)(8676002)(66946007)(91956017)(6916009)(66476007)(8936002)(64756008)(66556008)(41300700001)(7416002)(5660300002)(15650500001)(86362001)(2906002)(66446008)(4326008)(71200400001)(478600001)(6486002)(6506007)(54906003)(316002)(186003)(26005)(36756003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1IwaGdnT1Z6QlV1V1JwRXpoWFF3NmlkMHdtT0FhenFsN3pCeG1TS0RGV3k4?=
 =?utf-8?B?dDdGK25reVcxVncvSmRUajRlVGtOZFRsZmJNQ2JrWDFWZXQ0bnJsNnM0dDRj?=
 =?utf-8?B?S29qUUxwL1BqSGRtT3hJaGVpLzZreXErUEN5ZjBkdDV2UU5wTTVweVQ3citk?=
 =?utf-8?B?S3ErTlFNNHVLSUhEY0c5MjlnKzI0aGE5VjZ3dHNkcTdTOGRCN0VjclBoYlc0?=
 =?utf-8?B?VE1RL2FSUHNUTVVHdFZtUkRzc2kzaWl5eis0d0J1SWRKcGJqQVlPQnJNd2VU?=
 =?utf-8?B?U2duc0EvdDh4Z0NUZHNWWnJvQ0kvMXdYaTBGS25paGliaFpWbEU4Z2NkZERC?=
 =?utf-8?B?VVJ2dTdDenIrcHNRYU9aemxKL3RXb0N2K0g5ZHZtM2xmbXhCQWhURXJnU1ZR?=
 =?utf-8?B?M002QzB0cFR1MmhIZFgrc2tTVEp5Q1Y4RXNJZlAwNVdVOEZTU2t0RkdUR0Fq?=
 =?utf-8?B?TVlwRy9pTUU0djdFYm1YRko3aG9VakV3YUlDWDJMTUNFYVFjeldqSDR4VlVH?=
 =?utf-8?B?S1Z1eldRK0hiQ1p2UDRvYlBucVpDcEd1YmU4N3VJMjF0S0trMXd1bXIrSE52?=
 =?utf-8?B?RVJLUlQ4K2MveCtQY3RoS0NFQUg1Tk85ZjJjRUlxbWhtUzZ3aHdjVDFMOWFP?=
 =?utf-8?B?RVNIT3hFR0RpYWozNEdXQTdqMDJRR0NnT3I3VG5LbWFWYTAwV3JzSzdFc1Zx?=
 =?utf-8?B?TkIxNjVNalN2MkwyVm1PN2NmcEJGTG1tNm1USjFLUUdYTzhTRXg5bG5NcjUv?=
 =?utf-8?B?Sy9Fb3YxMllYdUVaeHIvVnZ6dzNFT1dpUFZJL0ZRNXVPSHVCbGQwVmp4K20y?=
 =?utf-8?B?cHoxUlROSlNUcW11a1gvd2lnSVRMcDl0a2RJZkgzNmNncGRCZlo3V2ZJQTQ2?=
 =?utf-8?B?NFg4UjJ0ZldGS2dBNWV6Y3ZKY0hRNHRocXRsUW0zcnQyeTF1VEZmVnU2dHhn?=
 =?utf-8?B?alJodjN1Q0Y1cEFXVWlYSmNzaFhhOXlpR2RrMXNlNDRNdHdtVzFjYlNOUmJh?=
 =?utf-8?B?ZXRiVnVDN2xzVXhYS1dTMHNEWCtHNVRkQmdwZldrTS8zbVdoZ1lHanYwNUpC?=
 =?utf-8?B?VUZOVTNGaVdHbU5DaWhZL3pDSGx3OExoL0JKUXRhMlBnelFxWWkrK0ZlVXpl?=
 =?utf-8?B?ZkFVbXU0eFhyMjg1NVZRelNxT08rdWVhSE1MYk1vOG9sQWFBSXVjem5Xdk9I?=
 =?utf-8?B?Ullvc0gzbWROaG1CYmZPWVhXTVVreHJxNHZURnBIWnJaYUdXL1VMWjZCU1Qv?=
 =?utf-8?B?T0RER2h1ZERFTytrZStYZXJkVis5MmZuQ1Q1cVpWZk90MzY0S1ltMTFKdGdI?=
 =?utf-8?B?SWswTmowTktKek9QM2daY0trRE9nc2dma2pZRVhSejVEYlZxS2czNXBTSmhv?=
 =?utf-8?B?dlJvWnQvQ0YxUjhram5uZ0hacjk4SWZydHAyVm9GZjhLcW83aG1ybitPN3R5?=
 =?utf-8?B?WEtyVHF2N0pzb1dQTldLQlJFVnFsQzdDSGlQcmE3Y3hkVGxRUkQ0ZmdIOFdG?=
 =?utf-8?B?TjdpallmTE1WVDhsaW9melpCWGV4QVF1UlA1cncydTUySXBQS2tEdmVIZWln?=
 =?utf-8?B?cUpnZjBhWHQyT0xQaWpMNWVZWktkc0t4UHk2YnR1R3Q4dGpFdHdTaW1MaFhS?=
 =?utf-8?B?LzNDOVhyNFo4RUVjeHp0b1R2VG9PTDhIZWJyN2lTYmJrdUpFZDJGcFJGeWo0?=
 =?utf-8?B?OEpDaWw4SUJFWWgwQWpVZ3V1RDFUNkx1cmhZV2tDd1ZIQk9IMW9GdHBxUXpG?=
 =?utf-8?B?dFJNZDY5dEZTUWdoVFlKV3FYR0IyWDVyYWxEMXM2YzJ1aWd1YStxb2RzZU1P?=
 =?utf-8?B?S0FseDdzclRlODhnbXFtSlNRNmVKbUNOMlVMSWZabzFobEdCbGFDUFdUMGp5?=
 =?utf-8?B?S2dKSG1ZeCtGTHBnUHpVcERRa2xMSTYwVkFIZG5hSzVWeCtYb3FGSXRhWUVS?=
 =?utf-8?B?bldMTHJCMklrY2I4M2t4eEtwSWp1aEFjUmxrdnNLQmFrQXlOWW5YSmJpZHVu?=
 =?utf-8?B?ZUF6ajVoZnliSnV5SkFnZzRPR2Z2bWlBWSs5Sjlkckk5V2p1VEtSYjl3d1lC?=
 =?utf-8?B?VDd1MHpGSDVOZnhnSjd4eG11NUtHQnR3ZkZCdm5mWis5MHc1NUhibFhrS09T?=
 =?utf-8?B?eC9NZ1RFTkdJSjlVVHNiZFdHVXVPcUhIa1ZOWldGRUQ4cE82OVptWXNGY20z?=
 =?utf-8?Q?U5BGx53cHfRDb6OI0mBbaAuQvnZXXwAn3+wuuSYVYfPT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60560B1616249C4FBE2EB3571E3075E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e242453b-939f-4707-4f70-08db05d38365
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 10:43:40.3281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KiGoBCxiYlqkY+c5DSFQaSyM3KOPAAW2CsFRROGbZRhdCPsfXUqqJV4wwmEYFWhv8MpDdYoTeXMtGdCVayXMJVsclZK/mN14pGMLh08slT8si5i8npjV1eg/sO8b8khQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7596
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBUaHUsIDIwMjMtMDItMDIgYXQgMTY6MTkgKzAxMDAsIEFuZHJldyBM
dW5uIHdyb3RlOg0KPiA+IExBTjkzNzMgaGF2ZSB0b3RhbCA4IHBoeXNpY2FsIHBvcnRzLiBVcGRh
dGUgcG9ydF9jbnQgbWVtYmVyIGluDQo+ID4ga3N6X2NoaXBfZGF0YSBzdHJ1Y3R1cmUuDQo+IA0K
PiBUaGlzIHNlZW1zIG1vcmUgbGlrZSBhIGZpeC4gU2hvdWxkIGl0IGJlIGFwcGxpZWQgdG8gbmV0
LCBub3QgbmV0LQ0KPiBuZXh0LA0KPiBhbmQgaGF2ZSBGaXhlczogdGFnPw0KPiANCj4gwqDCoMKg
IEFuZHJldw0KDQpZZXMsIEkgd2lsbCB1cGRhdGUgYW5kIHNlbmQgaXQgYXMgc2VwYXJhdGUgbmV0
IHBhdGNoIHdpdGggZml4ZXMgdGFnLg0KDQpSYWtlc2ggUy4NCg==
