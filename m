Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A55E51BD4F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355833AbiEEKgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355787AbiEEKgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:36:03 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E2341631;
        Thu,  5 May 2022 03:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651746741; x=1683282741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kUzdgPnziJL8Ralplwnx12Tmqc4369VuUP8hWmf9iVk=;
  b=uStmHICHAyYPDpTEOC4TADdrY5vkHc7P0JD+wSpIM9L+91tRS/SimB86
   A8j5Kkowzpz3B/cfe1WV2ygtdIlJu0bCcaR44TrgHueKdS2ubUHTedqjP
   DMYtfBhqqWuGorSMN3OfMNLaEwsuVneuSWHymRLdMccTikXUWtUVZuTVg
   Yp2zGbCedBaCBglV5vYNBUgHlOALuMFn0D2Dt1AB/tQFXiy6pIWHr1eEv
   iXjtJLApE0Rzjo8t0lOG45DUB2/nTQcUcVaVtvFiqk8e5cVvXp+qxRrHC
   A8DPdEuQ5IeMUE/S+RsboyqbBuwdmqjNAH2xy1aTpehUhBSsN7XHjU+rm
   w==;
X-IronPort-AV: E=Sophos;i="5.91,201,1647327600"; 
   d="scan'208";a="172067311"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 May 2022 03:32:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 5 May 2022 03:32:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 5 May 2022 03:32:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfkmgtRVRh+b6+IEjMz3iKVS88qez3HNpdzJdhjMyeB5xLkgpkb9a5jJg8S09vRzM9HRt2U2c8K9Oy0M2mEq6N/zCMVTWXXxcF0BKRUuTtk7i/w7fqKwKXipXysbW5gBvuAgKPis0ZVnkwTjTJToxC8ZDRcmmWfFHPId0fMLN2fiAKbUs7gIO5CbAJbaeMzh02MisLczBDk2UbTC52aBgdfdrz0f4ZRpfBk+p30yfVf4wLTKKmHQl8JCpPFTxt4OOgyOJHCYAEVMv3l4IVpLvmSQjQEPkxXhIiRwYv15IAUfqx6KHhN6pu54d75S/uoCbSTj0WzA9TUoEvY+OP5EbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUzdgPnziJL8Ralplwnx12Tmqc4369VuUP8hWmf9iVk=;
 b=U+KaztNLI65V3j5Hevn8hy/uH3Anwdu40ZkKFhTmZsQnbWwp4Uh8auoO0G0JuszM50ZbmFKaqNolotawybHvkd0miPqMc9WE5Zx6VMlBcEUCPH+2/X5CfoUXRrnibaaLe7gbpKBn0eFJ10c4oQdASVjiB0GUj+sSOBGkUJ2tEvrqVecQNlmBNPnnF3Sttckt7XiLeuMm/YrJnuOo+w5EucJ7DU66MRpaqubCLN9RX79ejR5aNr4A/IV+D2nCkXggmHm3BNNXYoeuzngBHp5zAJaPn8jefM38nMleLUa+zg0ymApPHCpNycayt4tj4mUZiPxo0CJ5C5hp7Gp71qI5Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUzdgPnziJL8Ralplwnx12Tmqc4369VuUP8hWmf9iVk=;
 b=sB/0lpr89Y1uuKgvaGKnYIifH78/w5cvSo/d2Mv8prLLxQMOyIYjR+eKf68kJIYnM0IIBd0WLE1YfLQ4rtLdkyKbQV3Vheef84IyGDMduINq5sgzhZGBWdeQzOVn1gJX0hmt5Qu4UqWZwtaEp11A63Q69ZgER/EN9+QDwVOgPCU=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM6PR11MB3756.namprd11.prod.outlook.com (2603:10b6:5:136::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Thu, 5 May 2022 10:32:17 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3113:cf18:bdbc:f551]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3113:cf18:bdbc:f551%3]) with mapi id 15.20.5186.021; Thu, 5 May 2022
 10:32:17 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <songliubraving@fb.com>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <robh+dt@kernel.org>, <andrew@lunn.ch>,
        <devicetree@vger.kernel.org>, <linux@armlinux.org.uk>,
        <andrii@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <john.fastabend@gmail.com>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <kpsingh@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <kafai@fb.com>, <yhs@fb.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <davem@davemloft.net>,
        <Woojung.Huh@microchip.com>
Subject: Re: [Patch net-next v13 07/13] net: dsa: microchip: add LAN937x SPI
 driver
Thread-Topic: [Patch net-next v13 07/13] net: dsa: microchip: add LAN937x SPI
 driver
Thread-Index: AQHYX8qQpunxrWXjPEmw+NPVBKeNiK0PJZAAgADxoAA=
Date:   Thu, 5 May 2022 10:32:17 +0000
Message-ID: <52e682a1bcd2aac1097f2b4f1948066fe5bb6924.camel@microchip.com>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
         <20220504151755.11737-8-arun.ramadoss@microchip.com>
         <20220504200726.pn7y73gt7wc2dpsg@skbuf>
In-Reply-To: <20220504200726.pn7y73gt7wc2dpsg@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fefa327-3a18-431b-7912-08da2e828737
x-ms-traffictypediagnostic: DM6PR11MB3756:EE_
x-microsoft-antispam-prvs: <DM6PR11MB3756584F71D9B32FC6381930EFC29@DM6PR11MB3756.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FzNRMQf39/IIOAkZNqIvhXzN8G0REqsAwJ2SkLa1avuPlKU4xlfbV1qGlliNKY4rx4KWfiH4IXZi4HN5jn0yR9zNfX5BI5k7YpX12m4XS37VDQzxupSUj1ABr+QyNQTDaMBgEtWD5bXfMCibcAzmbCX5iPeP9EitvAvExfCN9uydYqUCEastdTtpgYrrJqriYLFOTicKQGbaDEEEYC1ccFgE8eAITGY5COZgV+/WPMMteGsL5a+dwIVs/enBwrTrRY/Di8JPVIb7HUdxdZOgOakrucpt4mPHMstfwK1BflOSwRtQn5w4KM/yZh+mng0Mcjb2ik0SUmj0JBznt+VvsoBgS7K6fZeQbk2kkjAf5iqEvOvIWm6I3QanlD+nf69FW8WOlnEuLewdbXlenIrKcqdsnTBoZYY4oZkgiRy1S3wxLiqHQXs6bncREI9Md5kO30Yqs1V1AZiweguUS8IwgJpzhpwn5JjZ6cp+dzDqCX9I0R8BWsmxc9TxpzGBAmO1cFzzaO5y9pS+BuvMg7Yl/2x058xIGb0fDDzoWhyaMHjsvMDTU/VdtpsmEgTgqm5sOrSVORnf+5LUNSr4hFD2ISSIjOirVNtwqQBvRUi0F1rAqM+zZzUWu1kaD0ZGvcaieii1Iqq+4MIOKZSlD7AHpgaGJYFqY0jnH1hZigF+1FweAC0it7AMOIDFUGUTEqGRcTAShCBLqw7AcsdOpGaprLbFnadCZhLl1QfJ9o7vEVhXcJtTwZvCW8IAr5KTuiz9DfcDqKUXPyUXJtWKK2RHLYyTHtLnzFlSdicpzWQibvNZM4E74rZlobJE+K2JFQC5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(966005)(6486002)(71200400001)(26005)(6512007)(6506007)(6916009)(508600001)(86362001)(83380400001)(5660300002)(122000001)(2906002)(38070700005)(38100700002)(7416002)(107886003)(8936002)(66946007)(66556008)(66446008)(64756008)(76116006)(66476007)(91956017)(8676002)(2616005)(4326008)(36756003)(186003)(316002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c09nRmY1cDN0WEx0cXdJVGdZejJjOWNBNG9qS3FmdHlHWkJxY3dLK01ac2pM?=
 =?utf-8?B?ZXAvY0I4WnpqY3F4OFJRV0VxMFZKNUdkZVAyM2pJRkkzYkx6YzJLdTFmZEUz?=
 =?utf-8?B?NGZ0VmkvMzQ4Q0Q1b1FCbVRYUnBZK3N2YkJ2bk1WRVhVNy9iYjZWMnozZkVF?=
 =?utf-8?B?YzlNOUZuK1gvdFpnTEFsV281Y1k4d0l3cUVkMVN4WTZGbDdGU21yWndqdncw?=
 =?utf-8?B?MjlkcG9JOWpzMnBrNnJVeXhxSFhZaHhVNVVoSGlESEQ3MGxLRXUxdUtCOGsz?=
 =?utf-8?B?TEN4azJVZXhyWUh6K2s1bnY5QTQ3QmdXVFBHTDkrL3UwYTdvVDNNcjFuQlJo?=
 =?utf-8?B?Q2xUcVlmVVYvWHdoU3o1S2xZb0x4L0ZUbk4zblNqQzZrcnhaTWtWaldwekpp?=
 =?utf-8?B?d0ROMGhGTG9DQzhsaFgyMVNZd1VNUGxheGYyamM1bzhrK3lvWkN0dGVIeExo?=
 =?utf-8?B?RmNiWWxCa1YzS2hvcDhUc3Z4V3hreWVTejBhVjJsK0ZYb0dCbU5sSkwxVHVN?=
 =?utf-8?B?MG05Q0ZZdU40QU9ETkRkR3JKOGx3UVdOMDFacFlNVmdGcHpJWm5rUE9tNGdD?=
 =?utf-8?B?aVkxR0hWZkdQQ1NEMER5c2NuOTdWYWFmK0tDNXc4cnRjMkloa2VmMGkzZkxG?=
 =?utf-8?B?UFQydHozQnpudVhUcmNqTlBKTm05ZnkzYWhQRVF5U0lnTU9aOUE0YTUxN2o5?=
 =?utf-8?B?NnVGdDVKUnhtMHBESTdWLy81V1BheU9VL3oyTjJka3o1cE8yN25yby9qVEt4?=
 =?utf-8?B?dUJPSDdsWTNBSUNBY0xSeTZEZ1NFYXZMSjdyQ0ZZVWV2ZXpQUW9ncFlOUDdm?=
 =?utf-8?B?NEIvYmN6MGZNSHhUd2loNUJSU1ZQMGdsVHF2MXRvOXpSSXZuQmFXMDBzZUgw?=
 =?utf-8?B?WUtjRjFJSVltM1NCRUlmUnM4ZDFiSE0wTW9rQzUyWFVybGlEK1BxcjVkQXpR?=
 =?utf-8?B?aitCWFZOazRQZ2RwV09laUVqM216T2NSUFhRa3dRTWQ4ZlJHTHRlWCtTTEhX?=
 =?utf-8?B?eDFOdExWMndtQ2FOOFYvK0RTYm8vUGFXNngrcmV4bHhXL0Uxa0c0ZUZmNmJY?=
 =?utf-8?B?S0VsVjlPd3Y5N0JBdUZjRlV3ZUVFWENjd3lZVWlCNGhiQ1Y3dG5IYjdKS3RO?=
 =?utf-8?B?b3ZuRTB6czhXejRrcVBDanluSWR2enFIMS9YQ2Uwa1FOSDNndjg5czVQUklC?=
 =?utf-8?B?ZjFudjB6cVU4UTJMTXFrRG55ZlJaaTBVL3A4VExaSUFmUFlDK0RFV3p6RjBE?=
 =?utf-8?B?YnJYajUzcm1janlZVkhHdkhwYlo3M2NrTkNSQ2VjY1BsbFVTVUJlOXhEamZh?=
 =?utf-8?B?UnRuSE5aRlRqNVFwZjFaaUMzN1ArVnBSd2NteVhWV1BvUG1TRDdJd1BZSnFU?=
 =?utf-8?B?dm1kNGxEbUd0YXdQdjg5YjdOQUJzc1FydXdvaEs3WWY5VGdXQkF3RWtoQzlm?=
 =?utf-8?B?N1pwLzdHUkVIak04azRtSjI0V2V1bE5OQzZMQUpuczFWRWV5ak80NGNwdE13?=
 =?utf-8?B?cVdyN0hrUk1pc1BuM1o2NDVQWFBhY2pXOWRzNjhITk1YK0NhZVlnNjU3TVd1?=
 =?utf-8?B?V2hReHJ6RnorTlB4dXB0MDkrRDVJbXMvVEJVUHBxS2pIUXhFRnlKSGJnZmNX?=
 =?utf-8?B?SlF1Um9IMFZoYy9neGVBOUNoTERTTTlYTmprR3VNZnk5QTlUejQvREFFWXJj?=
 =?utf-8?B?b3gxREMyL1RFUDcwM0p4dnd2Mk9kTHZrZXlBRzVQRDZzYjVVRU9GalI0eVNW?=
 =?utf-8?B?WG0rdVY0WHBMR2ttNEJSQUh3NG9NWEJ1dHkxUTg2eXZsM1ZQdXZOUnNoRmpr?=
 =?utf-8?B?bzZuVUd1M2l0azZYbStpWmgyZ3RYMG1KQUhBYXFWMXM5UUpRWlNBRkZWZWxh?=
 =?utf-8?B?TGRGUWJvTk4wS0QzUVNNMGdkSmtjeGdUeFdhbTBCOTdDcXkyVEt2YlJITHB1?=
 =?utf-8?B?VDczMERycW9JTmsyM1VsMHAwcHlxQi82eDdWdlpwSDVNY0VxRzNSYjNsNHNJ?=
 =?utf-8?B?dHZIeGxKdGIrbG82K3lCdVQ0YkVSYk1PRzl0eUxaazZ4bW9tY1JHbUU5RGhJ?=
 =?utf-8?B?WVVtYzVnMEtrNUYwczRweWo4VDBLNzdUaXZOQVp0YzNVZDZ1dnA1cmtYSUcw?=
 =?utf-8?B?S0h1R09xN3ZzcmljOXVEVmt6Mm11Rzl2Q25qY2xBNUF5Q2xabWM1dkhmV1BU?=
 =?utf-8?B?K1hoNG8xRlZSbGZVcUVMNExpV0l0ZWRFd2hkRXBxYS9OVVE4bVAwdHRxZTAx?=
 =?utf-8?B?V1BuTGRjRW83bWZlV09MRnVVOUZTUmZCWWZLT1ZIQXRDZllJUktPa21VSWVm?=
 =?utf-8?B?UjFFN0xiNmEzMWdJSkI1cGN6UkoxK283bmR6cnNlSU1OKzR0Z0hEL2RXQmRB?=
 =?utf-8?Q?H41sDQd2BxdBRf193sTymEFNz1YxEW/KB+TsW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB9956E1CF959C42AFE36D582F0BDCFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fefa327-3a18-431b-7912-08da2e828737
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 10:32:17.5219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HNrR346WXbT+QhkzXDmRha63i7Ns3+JiFEYY+w1vxv673uZqgfpuByrr+OtKuOpnle6Y/HnCYT1xlKb/7wYMFt+Ui32ax/iV8Wfm0hVMkuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3756
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHRoZSBjb21tZW50Lg0KDQpPbiBXZWQsIDIwMjItMDUt
MDQgYXQgMjM6MDcgKzAzMDAsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gRVhURVJOQUwgRU1B
SUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4g
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBXZWQsIE1heSAwNCwgMjAyMiBhdCAw
ODo0Nzo0OVBNICswNTMwLCBBcnVuIFJhbWFkb3NzIHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggYWRk
IHRoZSBTUEkgZHJpdmVyIGZvciB0aGUgTEFOOTM3eCBzd2l0Y2hlcy4gSXQgdXNlcyB0aGUNCj4g
PiBsYW45Mzd4X21haW4uYyBhbmQgbGFuOTM3eF9kZXYuYyBmdW5jdGlvbnMuDQo+ID4gDQo+ID4g
U2lnbmVkLW9mZi1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAuY29t
Pg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL01ha2VmaWxlICAgICAg
fCAgIDEgKw0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaCAgfCAg
IDEgKw0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2xhbjkzN3hfZGV2LmMgfCAgIDcg
Kw0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2xhbjkzN3hfc3BpLmMgfCAyMzYNCj4g
PiArKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCAyNDUgaW5z
ZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9sYW45Mzd4X3NwaS5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Rz
YS9taWNyb2NoaXAvTWFrZWZpbGUNCj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvTWFr
ZWZpbGUNCj4gPiBpbmRleCBkMzJmZjM4ZGMyNDAuLjI4ZDhlYjYyYTc5NSAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL01ha2VmaWxlDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZHNhL21pY3JvY2hpcC9NYWtlZmlsZQ0KPiA+IEBAIC0xMCwzICsxMCw0IEBAIG9iai0k
KENPTkZJR19ORVRfRFNBX01JQ1JPQ0hJUF9LU1o4ODYzX1NNSSkgKz0NCj4gPiBrc3o4ODYzX3Nt
aS5vDQo+ID4gIG9iai0kKENPTkZJR19ORVRfRFNBX01JQ1JPQ0hJUF9MQU45MzdYKSAgICAgICAg
ICAgICAgKz0gbGFuOTM3eC5vDQo+ID4gIGxhbjkzN3gtb2JqcyA6PSBsYW45Mzd4X2Rldi5vDQo+
ID4gIGxhbjkzN3gtb2JqcyArPSBsYW45Mzd4X21haW4ubw0KPiA+ICtsYW45Mzd4LW9ianMgKz0g
bGFuOTM3eF9zcGkubw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2tzel9jb21tb24uaA0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9u
LmgNCj4gPiBpbmRleCA1NjcxZjU4MDk0OGQuLmZkOWUwNzA1ZDJkMiAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uaA0KPiA+ICsrKyBiL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oDQo+ID4gQEAgLTE1MSw2ICsxNTEsNyBA
QCB2b2lkIGtzel9zd2l0Y2hfcmVtb3ZlKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYpOw0KPiA+ICBp
bnQga3N6OF9zd2l0Y2hfcmVnaXN0ZXIoc3RydWN0IGtzel9kZXZpY2UgKmRldik7DQo+ID4gIGlu
dCBrc3o5NDc3X3N3aXRjaF9yZWdpc3RlcihzdHJ1Y3Qga3N6X2RldmljZSAqZGV2KTsNCj4gPiAg
aW50IGxhbjkzN3hfc3dpdGNoX3JlZ2lzdGVyKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYpOw0KPiA+
ICtpbnQgbGFuOTM3eF9jaGVja19kZXZpY2VfaWQoc3RydWN0IGtzel9kZXZpY2UgKmRldik7DQo+
ID4gDQo+ID4gIHZvaWQga3N6X3VwZGF0ZV9wb3J0X21lbWJlcihzdHJ1Y3Qga3N6X2RldmljZSAq
ZGV2LCBpbnQgcG9ydCk7DQo+ID4gIHZvaWQga3N6X2luaXRfbWliX3RpbWVyKHN0cnVjdCBrc3pf
ZGV2aWNlICpkZXYpOw0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2xhbjkzN3hfZGV2LmMNCj4gPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9k
ZXYuYw0KPiA+IGluZGV4IDNmMTc5N2NjMWQxNi4uZjQzMGE4NzExNzc1IDEwMDY0NA0KPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9kZXYuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9kZXYuYw0KPiA+IEBAIC0zODYsOCArMzg2
LDE1IEBAIHN0YXRpYyBpbnQgbGFuOTM3eF9tZGlvX3JlZ2lzdGVyKHN0cnVjdA0KPiA+IGtzel9k
ZXZpY2UgKmRldikNCj4gPiANCj4gPiAgc3RhdGljIGludCBsYW45Mzd4X3N3aXRjaF9pbml0KHN0
cnVjdCBrc3pfZGV2aWNlICpkZXYpDQo+ID4gIHsNCj4gPiArICAgICBpbnQgcmV0Ow0KPiA+ICsN
Cj4gPiAgICAgICBkZXYtPmRzLT5vcHMgPSAmbGFuOTM3eF9zd2l0Y2hfb3BzOw0KPiA+IA0KPiA+
ICsgICAgIC8qIENoZWNrIGRldmljZSB0cmVlICovDQo+ID4gKyAgICAgcmV0ID0gbGFuOTM3eF9j
aGVja19kZXZpY2VfaWQoZGV2KTsNCj4gPiArICAgICBpZiAocmV0IDwgMCkNCj4gPiArICAgICAg
ICAgICAgIHJldHVybiByZXQ7DQo+ID4gKw0KPiANCj4gQ2FuJ3QgdGhpcyBiZSBjYWxsZWQgZnJv
bSBsYW45Mzd4X3NwaV9wcm9iZSgpIGRpcmVjdGx5LCB3aHkgZG8geW91DQo+IG5lZWQNCj4gdG8g
Z28gdGhyb3VnaCBsYW45Mzd4X3N3aXRjaF9yZWdpc3RlcigpIGZpcnN0Pw0KDQpsYW45Mzd4X2No
ZWNrX2RldmljZV9pZCBmdW5jdGlvbiBjb21wYXJlcyB0aGUgZGV2LT5jaGlwX2lkIHdpdGggdGhl
DQpsYW45Mzd4X3N3aXRjaF9jaGlwIGFycmF5IGFuZCBwb3B1bGF0ZSB0aGUgc29tZSBvZiB0aGUg
cGFyYW1ldGVycyBvZg0Kc3RydWN0IGtzel9kZXYuIFRoZSBkZXYtPmNoaXBfaWQgaXMgcG9wdWxh
dGVkIHVzaW5nIHRoZSBkZXYtPmRldl9vcHMtDQo+ZGV0ZWN0IGluIHRoZSBrc3pfc3dpdGNoX3Jl
Z2lzdGVyIGZ1bmN0aW9uLiBJZiBsYW45Mzd4X2NoZWNrX2RldmljZV9pZA0KbmVlZHMgdG8gYmUg
Y2FsbGVkIGluIHNwaV9wcm9iZSwgdGhlbiBjaGlwX2lkIGhhcyB0byBiZSBpZGVudGlmaWVkIGFz
DQpwYXJ0IG9mIHNwaV9wcm9iZSBmdW5jdGlvbi4gU2luY2Uga3N6X3N3aXRjaF9yZWdpc3RlciBo
YW5kbGVzIHRoZQ0KaWRlbnRpZnlpbmcgdGhlIGNoaXBfaWQsIGNoZWNraW5nIHRoZSBkZXZpY2Vf
aWQgaXMgcGFydCBvZiBzd2l0Y2hfaW5pdC4NCiANCiBpZiAoZGV2LT5kZXZfb3BzLT5kZXRlY3Qo
ZGV2KSkNCiAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCiANCiByZXQgPSBkZXYtPmRldl9v
cHMtPmluaXQoZGV2KTsNCiBpZiAocmV0KQ0KICAgICAgICAgICAgcmV0dXJuIHJldDsNCg0KDQpB
cyBwZXIgdGhlIGNvbW1lbnQsIGVuYWJsZV9zcGlfaW5kaXJlY3RfYWNjZXNzIGZ1bmN0aW9uIGNh
bGxlZCB0d2ljZQ0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzIwMjIwNDA4MjMyNTU3
LmI2MmwzbGtzb3RxNXZ1dm1Ac2tidWYvDQpJIGhhdmUgcmVtb3ZlZCB0aGUgZW5hYmxlX3NwaV9p
bmRpcmVjdF9hY2Nlc3MgaW4gdGhlIGxhbjkzN3hfc2V0dXANCmZ1bmN0aW9uIGluIHYxMyBwYXRj
aCA2LiBCdXQgaXQgYWN0dWFsbHkgZmFpbGVkIG91ciByZWdyZXNzaW9uLg0KVGhlIFNQSSBpbmRp
cmVjdCBpcyByZXF1aXJlZCBmb3IgYWNjZXNzaW5nIHRoZSBJbnRlcm5hbCBwaHkgcmVnaXN0ZXJz
Lg0KV2UgaGF2ZSBlbmFibGVkIGl0IGluIGxhbjkzN3hfaW5pdCBiZWZvcmUgcmVnaXN0ZXJpbmcg
dGhlDQptZGlvX3JlZ2lzdGVyLiBXZSBuZWVkIGl0IGZvciByZWFkaW5nIHRoZSBwaHkgaWQuDQpB
bmQgYW5vdGhlciBwbGFjZSBlbmFibGVkIGluIGxhbjkzN3hfc2V0dXAgYWZ0ZXIgbGFuOTM3eF9z
d2l0Y2hfcmVzZXQNCmZ1bmN0aW9uLiBXaGVuIEkgcmVtb3ZlZCBlbmFibGluZyBpbiBzZXR1cCBm
dW5jdGlvbiwgc3dpdGNoX3Jlc2V0DQpkaXNhYmxlcyB0aGUgc3BpIGluZGlyZWN0aW5nIGFkZHJl
c3NpbmcuIEJlY2F1c2Ugb2YgdGhhdCBmdXJ0aGVyIHBoeQ0KcmVnaXN0ZXIgci93IGZhaWxzLiBJ
biBTdW1tYXJ5LCB3ZSBuZWVkIHRvIGVuYWJsZSBzcGkgaW5kaXJlY3QgYWNjZXNzDQppbiBib3Ro
IHRoZSBwbGFjZXMsIG9uZSBmb3IgbWRpb19yZWdpc3RlciBhbmQgYW5vdGhlciBhZnRlcg0Kc3dp
dGNoX3Jlc2V0LiANCg0KQ2FuIEkgZW5hYmxlIGl0IGJvdGggdGhlIHBsYWNlcz8gS2luZGx5IHN1
Z2dlc3QuIA0KDQoNCg0KDQo+IA0KPiA+ICAgICAgIGRldi0+cG9ydF9tYXNrID0gKDEgPDwgZGV2
LT5wb3J0X2NudCkgLSAxOw0KPiA+IA0KPiA+ICAgICAgIGRldi0+cG9ydHMgPSBkZXZtX2t6YWxs
b2MoZGV2LT5kZXYsDQo=
