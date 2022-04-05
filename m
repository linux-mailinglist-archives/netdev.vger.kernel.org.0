Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D414F429E
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351035AbiDEUCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446702AbiDEPpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:45:01 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15AFE2AC50
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649168303; x=1680704303;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hbBDr6jboE4tvIVgiCU7Zlc3ZGQ6odBqHMNfrgwflnk=;
  b=xKIiEa7UcZ0HXpcDmMemBLxA6wLeaVDzFjda6dC901gLB/+GfnfDFOcC
   YAKmh1c7vEcpwPkcluuf3ZtC5V/tOyNHc0aangPi9Z8Opl5COVAH1oWpQ
   3vKvPbQ203lfWb4udghusyu8MpIriNscdosI6qEYqiT5jZaKDW5C4po5x
   gjwNueAz63F8RRGA40FM4wbuHE0+Eb3nV3swlTjU8cyUceXZLk7FvaX8M
   xLBCeUlLlVz3wJKWhR9RJ+VKTCmOz/9zHNXtxRFo1UFc8AoOS3fq4MhJe
   38eJiEsQsaux/xvbh6ZpBgUsSEd3yIY3yx6q8svzkDPicrDAhCZbBoPcs
   g==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="159370678"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 07:18:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 07:18:23 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Apr 2022 07:18:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bwlVp1TisvSj+Mcp04vlcQARhyzz8spP0yy7qEZXUquIB1pSto7fuyDPLMyA0JeJp1tR92QZYF8/7IxyCSGAW74hkZrMKlK2LaV8E2t6niFYOWVhZ/g4QaAjdqOX8Z8lHwbcnQkOCR7RVwhbnds/OcxpGk33LkeNGWNi02/lnttgcqD2yw423iIigKHHbctYvVsKJuaIfXlW7+XBAL0eAtvnOrGS/18t2Czgq9FwLcKixPQARFTX4HhF4xeU9V+x2FFYKJUlqLkD6YTlSNd3+ngd616JzSUov67I1s04FNwPCyVg0MQ072gPUdOZ66jbCB8OIkgcmTFSeYTEZP22EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbBDr6jboE4tvIVgiCU7Zlc3ZGQ6odBqHMNfrgwflnk=;
 b=SCjJwqy+LeHNgivvt1Kqqr6td0iWXN/LZgyQx4aonLPGW1KuPgwzgDnz3AAPZHE5DaDGiOKhlBD7T/83mN/wuHaEQe+I6auPYagykwjLPMn/41coxX8lb55B6TSY64ft8s9aHwsbFuR18kGIW4A6k8VjIkBEHDEzTD9raDsGHScrxXHE+8FihAhv2IFWVfWAOOzt2k3Shb+n1fWwoBMxfIb9ALDsMqVyjSk5u5ZlDXBu0bsHoChavqew2YDinIfEj6G18FQEHLHMaOQ881YHp/JT/y2eVgB28eojSMQ54RI2ZRRUTRRRketD/VKU4IfsMwGoIyZ5m+JSQv3KZEoqWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbBDr6jboE4tvIVgiCU7Zlc3ZGQ6odBqHMNfrgwflnk=;
 b=XRUTl7vhx4GNM5bwaPPqY/qlxCdjWoypiXUPdkYFJ/VPx3GE85kNf9HtjiDXAVoY+6NHS6Hz+zVokAV4OBH1Rj4T6x6jFSB6GhIxB8+v4M1QDNHkXDIA+koa82G7EI1YXvR9AOQJDTKlqZSaE2gZJLNrtz/14JK6xOlKs45V/HY=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:95::7)
 by BL1PR11MB5448.namprd11.prod.outlook.com (2603:10b6:208:319::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 14:18:17 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::dc95:437b:6564:f220%8]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 14:18:17 +0000
From:   <Conor.Dooley@microchip.com>
To:     <andrew@lunn.ch>
CC:     <palmer@rivosinc.com>, <apatel@ventanamicro.com>,
        <netdev@vger.kernel.org>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <linux@armlinux.org.uk>,
        <hkallweit1@gmail.com>, <linux-riscv@lists.infradead.org>
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Topic: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Thread-Index: AQHYSO3IJSdXwoud5UqKTAwCCAurg6zhT02AgAAOuAA=
Date:   Tue, 5 Apr 2022 14:18:17 +0000
Message-ID: <98b571fb-993e-9fe1-1cf9-dc09651feb0b@microchip.com>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
 <YkxDOWfULPFo7xFi@lunn.ch>
In-Reply-To: <YkxDOWfULPFo7xFi@lunn.ch>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ccae532-e946-4b71-09b2-08da170f2145
x-ms-traffictypediagnostic: BL1PR11MB5448:EE_
x-microsoft-antispam-prvs: <BL1PR11MB5448D948D45DEB881241103698E49@BL1PR11MB5448.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mvUcG6Tn8p36b8FQ5oVKmpEQ37/VVUNuFjMx2isgIY/kS0pY9zvzPpe/XOWQPYxVGlyYPJIQm6XAyL40XUZScb2yxJsfu6xAj03WbJ2OX0SppnIsLDQL1bGcbA45bXZc8OHjLmfwa+ooGaZYdjx+w32LcEBnE5o9kZJ7+tQlbfS+jNh7yKrRfkU1pCapHR8cuOzGP8AY6tZFBl5umUijZA6GkKPrVLjaGG3AsxGGg3rRsT/cff4eymlvH1g6GjJ2ntv0pvo04O+QWm5ma9tkVZJNwGVKzV3Ua5jWUyVceG8QKIC1WHXVTLdyExllQkqpuY8tCqfqITH1lbNV4lEs3OBCWeCTecN5C+jCFo+FnBagr6dXBjny2iXizVlYjTZybA7gpK8DcXVTlXcbEW9ec/SpheknAhkBAZ27yl0CyxffyfcPV+0qWW9dK0ixpDZ/acLmfLLDqWU5ivV68wXGGvF0uAzKgI+HgjXGZdZtW72jNkimAjl4fQxwwV/gdE6GZe2v1QZuf2tWE7AgAmiDpH9RDG9MKPLehR99KPy220NTSf1i7XljxEjcopUVbqNjwH7XmG5dOHHNbVrJh1jNuBpTAgnjhLnZZ1FJpu9qAKCJcMSDn2PD/6D5VC+DRVA2i72cprA0KJnoOd85s5YYzzeJ0q/Lln0qmb/6Cs8ensoRvrua7Kjm423YMkNWfyhd10itJtWaLT5kRLo6Zil5cDnR0/Lc2w5rusyEDrZbd1EoaXsTu0K9zaVeeJfe0lyeOGd91P+0pkDDcfZE9A9KajdjBOcvZ3e/w0R2BB3MLqXJTCOzQnc8ALbZ6tJXp+K0zrXJKxl0QkInOoX87mg0ZPLiLIffmvg5Q4dcvkzR55ZXh4m6TFFk7X68Y/voN5EK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(966005)(508600001)(71200400001)(6512007)(2616005)(86362001)(6486002)(53546011)(38070700005)(31696002)(2906002)(38100700002)(91956017)(54906003)(6916009)(66556008)(76116006)(64756008)(8676002)(66446008)(316002)(66946007)(36756003)(26005)(186003)(122000001)(5660300002)(8936002)(31686004)(4326008)(66476007)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE01TUpkeHMrK080Rml0eWJ4OFgyd2tCN093Tld4ai9qYVg4ei9XSTBycVlj?=
 =?utf-8?B?SFN0ZEl6MWZ2US9KRjVGR2FBVWpNRjlsdngyV1RsdGFMM2llNXpkQ0NzUFZX?=
 =?utf-8?B?bmcrcXJaZ25KRWc3bmkzVUFCUC9rOEJSclpIaDFrUytBMDd1VXVLVVVNeXJF?=
 =?utf-8?B?VHFSUHYvais2bUZaN0VYdUhoS2IvbTdhNVlsRVRlRFRQS0VYTTNHNE5LQVY1?=
 =?utf-8?B?NElJM01XZjBtTnR4UUo4VEJLbjJCVnJvTVBoamlETU1LQVdHUS82R1dVdXVz?=
 =?utf-8?B?UVdESXk5TFZRYUlBUSt2cDViOWpaaDdwZFNOdXNPRDVNZVArNi9VemZETS9F?=
 =?utf-8?B?M0Y1QWdvZzVnUlRuVzlSOHVVVmJiVlRQd2JSTElvVW5oM01SSDVjY2lySXNY?=
 =?utf-8?B?L2hLMDRQNzMwQjlGdVBtK3RmdVUwSld4YUxWcDlHVWxtMzVQZnRjZXZRcHBN?=
 =?utf-8?B?Q2w3VXhWQnhDZEt3eE84N2FZcGcyMFVFUEtXL1BTQ0JVa1JQOXN0MjBXeHVJ?=
 =?utf-8?B?MGhtSXYwcTJpNEFqOG1iNDZ3Q1FEcEU1TE9LdTg2cUNhZkgrREF1ZGN5UzR2?=
 =?utf-8?B?RUp2aEJuell2Njd3Y0doV1p1YmlIYTN0Y0NuN1dsZElDREJMSXBxaEZmc0FT?=
 =?utf-8?B?WVBxSkRVZVlkRGIwTlczdkF3S1ZWNjFIcmlUajJ5N3lacTZqTitiSS9TTGpY?=
 =?utf-8?B?UDYveEpCaVQ1dkw5ZW9BOFMvTlRLS29DNFU3KzVOTE5xMUltU2dXUmMreFNI?=
 =?utf-8?B?ZE0wSWJIMUQwcE0xN1ZZa1NMQ1lWckQ4anJXcXZ4bjVIOE1RT2FTOEtyWmEw?=
 =?utf-8?B?OXJJNjJTU0V2blNVemhsN2ZjLzY2ZER4bnVPbmhIclpUWktEaXcrRjJOaWoz?=
 =?utf-8?B?bkE3eDZUd2NtZnBONHg2bDM0eHpJWkRXOHEvWk9DTXFLMHBublRmdCs1ZUc4?=
 =?utf-8?B?bHBtRzlva3hOaXdjS1ZYVDA3YjhvaXJVQVRlYVIyQ1N0ZERMNFJXOVhaRE5G?=
 =?utf-8?B?U096TlNaODhpVUJOa0hDQThQeUdscmg2NmdKVlpURThYZXhxVnpVUDdPUGg5?=
 =?utf-8?B?QVVzakpGbWhkMkFCOXJESHNTUkVIbndHdHd3dXMvZkk0OWNnMWJHSDl4OElh?=
 =?utf-8?B?OVRsOFpBRHhacC9EOG1QNXE3S1VkeG5hdG94dmtNVlNOYXVDVytaMnVVbjBj?=
 =?utf-8?B?STFiWWpmSENXajlwQUxCcmZDc2xLWWJQM1FvTFFxWlBMcGhZMkRYZk4rUUV2?=
 =?utf-8?B?aEY0U2dyQ0thbzhQUFJSMWZyTlZidnRwV2xwUG1zVCtBcytlSlArTVRNdnMy?=
 =?utf-8?B?WUFtTkpiT2tXcDNteDl0UE1HS1VLdFVBbE56ckpDUVpvTTNoZU5CWW9ZQ1c5?=
 =?utf-8?B?Y2g4UWZYYWl2MGRxd0piVmhFQ0F1NjJNT0R2MXdhdnpyVTZ2cmxMKzhydG5p?=
 =?utf-8?B?bU9BbEJkaER6Q2dhbU9XUE0wUyswMEdPUUxZWFNmak1Td3U4bHZrbFI4cUJz?=
 =?utf-8?B?RE1zbEREdUUwT1haalJCa29yaDFxMUZVS0JTcEFJOUxZS2lpYUZpU3JNTTRm?=
 =?utf-8?B?eUdyQXhBb01BeXFQcElnODB1d05uSUtvUTJZRG83RkVKaGNYZ2ZLbURKaGVU?=
 =?utf-8?B?bWFPazVuTHN3UVpsSTZINVhTdXpmZzJGam9VeUhwOGJwYTBuK21CY00xUHcy?=
 =?utf-8?B?b1FWS0RTVzYvKzlFM0E0dmtYTnV5a0lZbUV0V0pEYy9OVGRjS09GUHU1SDly?=
 =?utf-8?B?M0FqNjYycUhma2ltaEc2b2k0bWl0Ykd0N3JxeDNtSUVsV1NEc1BFQWVBeXN3?=
 =?utf-8?B?cDBRRHhtdGpodTlSekJWU2Y0Q3J4YUlEd2s3SGVXQUlmMGFwdEZzN21aWGVD?=
 =?utf-8?B?VXVpRk5jOGxhRGlBVlAxcm1JNnVZUTRsUzZUbHhvbk95Sk52bTU5azAzYnZa?=
 =?utf-8?B?LzM5K0tmY3NPb1hNbG9ORFRXR3owZ2xsMlJoZkpQTTN5dnFMT3BJZFFWbk5G?=
 =?utf-8?B?dnd5cVB3MWVUd0ZaWkNoc1BZUUpXLzFNM2hpRGJNckpINnBkRzZSYmJKaE9G?=
 =?utf-8?B?bU9wcmkxeWtqcmQ5ZEgrWklobWZlbU40cEQyU2t6WTBMYkQ4N3o3bnJqYW9h?=
 =?utf-8?B?UCs1anRkbjJ6ZzRRYlJLZ2p4NTUxa2dKVlREeVFLTUJJM0FTck1velBxWGJK?=
 =?utf-8?B?enpoNXM1N0FYU3pmZlZHcHFZMFc3aUV5U1cyVnpicGVMTzBaZ1B1OVgxZVZS?=
 =?utf-8?B?eWs0M1RDSDd2R24yMzBZV0Yrb1VjY3Z5VVhzanI3U21ya3FJdzFTSElzM2hp?=
 =?utf-8?B?MGlHV2QyZmVXejhnYUhlVnI2c2hOUEdmTmlKQ240dzVURFpwU1FXQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25E4D65E2B3CDD4DB027578BFA90E09F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ccae532-e946-4b71-09b2-08da170f2145
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 14:18:17.5516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c1qfj+De/UwLX6x6NB/xse/LSZsTMVSvj116q2XO/A5FV/2ZQUDSvetZumJc0g1Wf0KcTdnQQj3wrOZgVJs8+IbCtmM7bDm4wIrCHzNcwxg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5448
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDA1LzA0LzIwMjIgMTM6MjUsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBUdWUsIEFw
ciAwNSwgMjAyMiBhdCAwMTowNToxMlBNICswMDAwLCBDb25vci5Eb29sZXlAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4+IFsgMi44MTg4OTRdIG1hY2IgMjAxMTIwMDAuZXRoZXJuZXQgZXRoMDogUEhZ
IFsyMDExMjAwMC5ldGhlcm5ldC1mZmZmZmZmZjowOV0gZHJpdmVyIFtHZW5lcmljIFBIWV0gKGly
cT1QT0xMKQ0KPiANCj4gSGkgQ29ub3INCj4gDQo+IEluIGdlbmVyYWwsIGl0IGlzIGJldHRlciB0
byB1c2UgdGhlIHNwZWNpZmljIFBIWSBkcml2ZXIgZm9yIHRoZSBQSFkNCj4gdGhlbiByZWx5IG9u
IHRoZSBnZW5lcmljIFBIWSBkcml2ZXIuIEkgdGhpbmsgdGhlIEljaWNsZSBLaXQgaGFzIGENCj4g
VlNDODY2Mj8gU28gaSB3b3VsZCBzdWdnZXN0IHlvdSBlbmFibGUgdGhlIFZpdGVzc2UgUEhZcy4N
Cg0KSGkgQW5kcmV3LCB0aGFua3MgZm9yIHRoZSBxdWljayByZXBseS4NCkl0IGRvZXMgaW5kZWVk
IGhhdmUgYSBWaXRlc3NlIFZTQzg2NjIsIGJ1dCB0aGUgbGluayBuZXZlciBzZWVtcyB0bw0KY29t
ZSB1cCBmb3IgbWUgWzFdIHNvIEkgaGF2ZSBiZWVuIHVzaW5nIEdlbmVyaWMgUEhZLiBJJ2xsIHRy
eSBsb29rDQphdCB3aHkgdGhhdCBpcy4gRWl0aGVyIHdheSB3b3VsZCBsaWtlIHRvIGtub3cgd2hh
dCdzIGdvbmUgd3JvbmcgaW4NCnRoZSBHZW5lcmljIFBIWSBjYXNlIHNpbmNlIHRoYXQncyB3aGF0
J3MgYXZhaWxhYmxlIGluIHRoZSByaXNjdg0KZGVmY29uZmlnLg0KDQpUaGFua3MsDQpDb25vci4N
Cg0KWzFdOg0KWyAgICAxLjUyMTc2OF0gbWFjYiAyMDExMjAwMC5ldGhlcm5ldCBldGgwOiBDYWRl
bmNlIEdFTSByZXYgMHgwMTA3MDEwYyBhdCAweDIwMTEyMDAwIGlycSAxNyAoMDA6MDQ6YTM6NGQ6
NGM6ZGMpDQpbICAgIDMuMjA2Mjc0XSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IFBIWSBb
MjAxMTIwMDAuZXRoZXJuZXQtZmZmZmZmZmY6MDldIGRyaXZlciBbVml0ZXNzZSBWU0M4NjYyXSAo
aXJxPVBPTEwpDQpbICAgIDMuMjE2NjQxXSBtYWNiIDIwMTEyMDAwLmV0aGVybmV0IGV0aDA6IGNv
bmZpZ3VyaW5nIGZvciBwaHkvc2dtaWkgbGluayBtb2RlDQooYW5kIHRoZW4gbm90aGluZykNCg0K
PiANCj4gICAgQW5kcmV3DQo+IA0KPiBfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXw0KPiBsaW51eC1yaXNjdiBtYWlsaW5nIGxpc3QNCj4gbGludXgtcmlzY3ZA
bGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlzdHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2xpbnV4LXJpc2N2DQo=
