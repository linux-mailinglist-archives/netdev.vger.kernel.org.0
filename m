Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239F858672E
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 11:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiHAJ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 05:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiHAJ4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 05:56:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F9B3C141;
        Mon,  1 Aug 2022 02:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659347809; x=1690883809;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4yoPPY+hp3gA4XjcSHsd1Ol8Kvyf5QOlGERbCu3UCOg=;
  b=ZMkknCV2biLlpQ+r6BNBxp44C7uDEL8IuFAFB0TXZItJF0MAaU0Jv7g1
   uTcAfBEpfTf3OvKAtFitt6G7G3BcszxfwYOwYIRo00pfxRxTBYTbFsBY8
   oxtwS1pDqFl99Q2mUabBNLD6aisQFra9yy0h0yyFNGcFg/tSeyrFnuJno
   7u29R7Faoe0uOUilSfMTNyRNLdgBiI82V0TepbcGqXHjByvuztdz0JW6N
   IM/IOH91gwvXF4MFH9aYJa/aNks6XZVeJVV6lKixji3zeB+aKdjeWsvgf
   PqxWyzRzc4Uq3C4k1qPDPOnuVYWNcylg2A7ISg0zu23xUS9Gmh6SnuR0C
   g==;
X-IronPort-AV: E=Sophos;i="5.93,206,1654585200"; 
   d="scan'208";a="174562139"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Aug 2022 02:56:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 02:56:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 1 Aug 2022 02:56:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtfYA6CoPMEZy2YAa9xIyzDqEZisyNusuAd/aBk/C3PlWQCfUCZsILK0FLqJHZfOV/Zcjk6sM6419GLKy8RwplIPmaJ/paMV0zwKN1yzXekpka2KC5BM0SvC8ZRhNt/g8B1fFEqh88hdjilYIRStGIasJrHHX8zaSGRne2CMGwN2FxztAk+HCajjcOW6t+D6Yk8ZNrRYHLWcHf4Xgy5jLViP2Lp8Oh931rUzsTSMMERd/ETeEttyZmQYWOPKbKwH7iz61+cDpYaVMBzjkqOH9txhnoiK0M37AVf9T1o+QZGi321llDkhoEn0JMuLZ8HZFZkopmg2pMG2HRHDYr+vfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yoPPY+hp3gA4XjcSHsd1Ol8Kvyf5QOlGERbCu3UCOg=;
 b=QhhW3FW3yrcRgzEiGQ8IRpuMlOjZKAW5lrjRgv0iRIAAoM++q4Vm6EDd3ggUi0BaIMcgl6lYkAedAK82mkZViPRdI/0szTnLkMDNRsVOisHXAETP9mZ6VcK8VpW7qsw6kgg5VdqNTOgJcEMgFAmrd1NFQgYF2xMJJpeeTGXu9DN6+gAJpzSQCDBkiR0LU46PaiPwKW5Yc/4snQViiwcDln4LCJ5nKdzZJD0q2R10RzqyCsh7KiIHHOK/DPypQyLKsBc9VdC1fCdHaqjHkK9lgBekVnplUaaHfNJqDJO87mgzt6Y3vCj1mh0+qddqHmZPuVAeKcEOMQZvKKI7mmGh7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yoPPY+hp3gA4XjcSHsd1Ol8Kvyf5QOlGERbCu3UCOg=;
 b=A8xDQoF9WKpJ8BXxiKuHehuuuZpwsi3JFk+z5Q2YjuDVv9bkIWAcV8ZO+wwGt56HqA6Hs6G18ZIepuA7C5ctXsiP1L2U1H4SQNwkiC4OEPoGML6wYHnnt0sFDmtKwysNn3HrLT3/4uvXrnPZVpcVbgDPqUMC7lEVgbAEjvLkE6g=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by BY5PR11MB4497.namprd11.prod.outlook.com (2603:10b6:a03:1cc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 09:56:40 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 09:56:40 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <git@xilinx.com>, <ronak.jain@xilinx.com>
Subject: Re: [PATCH v2 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Topic: [PATCH v2 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Index: AQHYpYz/w4ja8yXDQUmz9HznJF0suw==
Date:   Mon, 1 Aug 2022 09:56:40 +0000
Message-ID: <bcbea902-6579-f1d4-421e-915e8855822a@microchip.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1659123350-10638-2-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1659123350-10638-2-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aeb884c5-5b17-4ace-1a89-08da73a421f3
x-ms-traffictypediagnostic: BY5PR11MB4497:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /xRjNzgw0JV1iRGNEJsi5sONhkMVgaisobU0l2iJEpZfVoBy25qooIe2W6BgHcJBxCQT3O4wMmQyrCX5XcrmqN7pSyfBTX7lgmkLucscjl2WKpcAShZQ7vvIwamG0f6aMuH7Nq8P92FvTP1oogIDufDItUZzn7G1YKzkd5aOxknCFXK7GTp8OWgz71fkzUjdaBDLGa1BOhfXpXD9EUmL6E4iwbZYtEd+vN2JENl38uJOj71zJYUJARpTq+BuIPJAKqJI9DKzMSxw/xuV2LLplTVqBs5cHbia1eW8J0SSTslNGK9HOBsoqKTkaDd2RjK2tvhRowm/k/UC/A2Sye3DtUPwRdmXbeTwRL7v1XyStVlhMsvkuHFPCuC3HWV3Ra1kRDRDbuLHgLHIulegAfRNJwEGgdzZ61UzMJN8qX3RpT/jEsAKNxYZyCOCiT2jT1EjQIWWHTzHVYK6P3Pba94mn6Vazxu80SLPn0l4ShWVMTVCEzE5Urch9spYB8Ptsn2MFOVIFkTh/cZOK8TIH3aNcgL1Q0Qajpr9Q0aaTtf5slxV4Nrwx1amrxEIGZgoBQ9DZ1rXqlBHuF4oFbSUOioB99nXuxzvmh6+owSwMw5b2hnKCpPn9kP/6CiODGfd5LWEKWH+hS/15QMvpAtyGNokjLvI8HZzGF2W5oGp1Awfn7ic0CTyWpzkpdozViNXgKCqje5a0ME4tP920m6Orbkug8YpY8IrpRh3cwnL/hQieEpfkF9JY0VT7+DTCOlNg/m38vDgYeiON6qGbdfxI9L8XTtqDVPmeIeWmJTUMvZsPST/ipTXoPovsoBfhfkngghozXeBP6IRqfRQ2FtupZRYcT3dI6mfDFsUcO4ggaLslbRJlCd9R0Syye4ZehiFLswi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(39860400002)(376002)(366004)(136003)(6506007)(83380400001)(26005)(41300700001)(186003)(6512007)(2616005)(53546011)(38100700002)(38070700005)(122000001)(31696002)(5660300002)(7416002)(2906002)(8936002)(36756003)(478600001)(86362001)(71200400001)(6486002)(66946007)(76116006)(4326008)(8676002)(66556008)(66476007)(66446008)(64756008)(31686004)(316002)(91956017)(54906003)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3pxamluUVJlWG9jUVNOTE8zbGZGQjhvYno5MUQ3SXQweUZZSWM0d2lMVGta?=
 =?utf-8?B?NXZxZ3NPTytZVFZobFdVVS8zR2YzWmQveE5zK2dTSXVSa3ZJajhlTGR0eVFY?=
 =?utf-8?B?SWJOWERrTFBsdnJiLys4c1dZb0c1anhobmRvMWhJdHdRUk1ZTGswYUR0TXZH?=
 =?utf-8?B?ZjV4bTBZb2FXRCs3bS9KVkx4cEJlWkgvUThwS1pQVWpVdUhhWWkrWmdrQW9V?=
 =?utf-8?B?bWNkVWJyb2J0TmdQM0JuMjQvekdvWUJUdVpjcklmUDRLU0hrY2dXRXpkaXBF?=
 =?utf-8?B?M290ZU44R0Y4OUowaENEeDZMcDEwa005ai9FcW5xaDNCM2ZpODEzQ1BoT3NJ?=
 =?utf-8?B?anFmb0Zxbk1oYVo0ZFVYalBreG5TaXcvcTdaSEN6OFovMHVLYmVQa2J1Tm8x?=
 =?utf-8?B?QTJjcGVIR2JkWnhYUFBiRlA0MGFYTk0ycllxQUxMQ05FZVJOcEx6WmFKU3VR?=
 =?utf-8?B?eXFXZ0kzL1lDZVQ2MUN0K0NobjRrSGdvQ25pVWpJK2dySll4czdScGFnL0Rx?=
 =?utf-8?B?NkhGc0c1M0RubEhMQ1hZY25GRmVUUitpYml5d29ZOWVjbXdtQTdWQjVrd2tR?=
 =?utf-8?B?MGRTYUsvUEFRc1VmQUJ6YUJQMElweHl6bmt3ZjVRRGE0WVhsUVUzcjJtdVJj?=
 =?utf-8?B?UU9kb1N1UDJEa0wvNDRNYzBZbmp6KytvUWdidXRqWnVCZTNMazBXTitPUkNT?=
 =?utf-8?B?cFhhaVBvVzU1QnAvK3VjWXBxcUw4VFQ1T2Zyek16ZGUwVnVoT1RWcDhkRVVi?=
 =?utf-8?B?R3g0K2EyQ2xmb3VpU2xBenpOZnVRQWlUOU1MNHF2NzdyZ0RtZEhwZUM0Sld1?=
 =?utf-8?B?ekVMSmVpcFRZZW4yaTVpZkc0cTl5Zm1ZcGxRcXZmdzQvbEN2U0JRaTZFMVNP?=
 =?utf-8?B?MHdpamJMU3NsTzZOTXc0bUcwekc4eEZBMHJWak82bjZxZXI2K05mZjhZMTJ1?=
 =?utf-8?B?cnJWbjMxU1lsTUhJZW5mbnQrSm4zdnAvcnJnTHFTaHQ5dXpDb0VnOU1xRTdI?=
 =?utf-8?B?T2RmMWR2ZjJad2xjeVp2azhBRWE4YTdienRHTnpjL2d3YkRkRm1RRWFEbW81?=
 =?utf-8?B?akZ1a2NJcFF6a1FBZ2g4TnQzUGlxUVJndFNlUGsyVFRYVWNkUkpoNy9OeVlQ?=
 =?utf-8?B?QU4yYlA4MStwNW9xUGs3SjcvRVZlSmU0ZUh1WUN5TVpIeTJZaUM3STkyUkR3?=
 =?utf-8?B?eXZFZk42R1dOcS9xVSsrMGdjejZ4N0FtUXd0Y2d5Ty9Vb05RUEhYRGFndEdu?=
 =?utf-8?B?OU4wN0tVQmpvdEw3aTdDdmsyRkFkOEVRaSsvVHVvdjBKY0VtMk9IOC8yTkkv?=
 =?utf-8?B?ZzVGTHQrZXg1WTRERzNtL3RsTzVMNHo0NnRiZjRVbzNneUNHcGo1T25IZllw?=
 =?utf-8?B?Tk9aSG1nR2pNQksyWUJSM3BiTGVyRDhMZWNlTXh3dnMwSU5JZzE3TXZMNXlF?=
 =?utf-8?B?ZGkyUEltQWxGSEFkUVdRbElDWnh4VzhrK2owV3JnakJ3cWFoNWZFeUJyazc2?=
 =?utf-8?B?blg4ZEk2TXoyM0RaYmxsNVRNdzlBNkdFYmlMZFUwOUN1aTg3VWFSY1NyZ01z?=
 =?utf-8?B?QXVJOU1ESG5rb0JpRDVQb1NSbDEwZ2pnTUVzdlVBYmRxaXVlTS9kZUNDTWJO?=
 =?utf-8?B?VjI0aTh5aWhKWldIdkhEQzJMVis2Rk84MjhKdmxOZVY4Y3lwam1mcVk0d1hZ?=
 =?utf-8?B?MTh2N0tqUnNrUGduU3dlalhZK1p1amkrK01CYk9STzR3SEpBUjFCVFIzOEla?=
 =?utf-8?B?M3ZBV0JEakJkWkw0VFNUVk0wQk5FWlIzUHRxME1sdHJKYkJ5WUk2dGswc1NM?=
 =?utf-8?B?NUdpYkZMVmRVQ2hXWS9iWE9zTFgySmEzbVFPL3JrZ2poSkFzUWY3WDFXUlNn?=
 =?utf-8?B?Vk1YYlRnMWc2RUR6aUlGWEJPS0RucU5ZblJoaGQySVRZU1REbUdJUlgybnlt?=
 =?utf-8?B?Uno3TExzaWhHQlE4RFJGUnlkRys3M0J3TW40SFkySlBUZWlVWm16ZmhzZDFU?=
 =?utf-8?B?dlJXazBiRDJMditReGMreFFGVFJMcVd6d1ZJVnpJaFpJUXB1M1hHbVZCaXM5?=
 =?utf-8?B?d2twbDh5VTR5d1ZZaGxZQ3ZCR3RwS2EweTlMVzVDb2ZVVGNHS2lxS29hOVNm?=
 =?utf-8?B?dGFJVnQ0WTNoaG9pVlFObzdUU0UvNVZrUG8wOU5PV1I0N0ZVU2taZmVhWVdJ?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <397651ABEEFD614DAB3ABBF919698EB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb884c5-5b17-4ace-1a89-08da73a421f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 09:56:40.7444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b2D01ncjHh4mekyz/OnTi2FPMCv8SxyKtlZQC5jeBIiPOTVR/TGJNvGcoe6wFbcMKyzTnjwasOTNOAJCjelq/WGZ3KdVWmjKdEig0XlQQfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4497
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjkuMDcuMjAyMiAyMjozNSwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBGcm9tOiBSb25hayBKYWluIDxyb25h
ay5qYWluQHhpbGlueC5jb20+DQo+IA0KPiBBZGQgbmV3IEFQSXMgaW4gZmlybXdhcmUgdG8gY29u
ZmlndXJlIFNEL0dFTSByZWdpc3RlcnMuIEludGVybmFsbHkNCj4gaXQgY2FsbHMgUE0gSU9DVEwg
Zm9yIGJlbG93IFNEL0dFTSByZWdpc3RlciBjb25maWd1cmF0aW9uOg0KPiAtIFNEL0VNTUMgc2Vs
ZWN0DQo+IC0gU0Qgc2xvdCB0eXBlDQo+IC0gU0QgYmFzZSBjbG9jaw0KPiAtIFNEIDggYml0IHN1
cHBvcnQNCj4gLSBTRCBmaXhlZCBjb25maWcNCj4gLSBHRU0gU0dNSUkgTW9kZQ0KPiAtIEdFTSBm
aXhlZCBjb25maWcNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJvbmFrIEphaW4gPHJvbmFrLmphaW5A
eGlsaW54LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5
LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KPiAtLS0NCj4gQ2hhbmdlcyBmb3IgdjI6DQo+IC0gVXNl
IHRhYiBpbmRlbnQgZm9yIHp5bnFtcF9wbV9zZXRfc2QvZ2VtX2NvbmZpZyByZXR1cm4gZG9jdW1l
bnRhdGlvbi4NCj4gLS0tDQo+ICBkcml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYyAgICAg
fCAzMSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNsdWRlL2xpbnV4L2Zp
cm13YXJlL3hsbngtenlucW1wLmggfCAzMyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgNjQgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jIGIvZHJpdmVycy9maXJtd2FyZS94
aWxpbngvenlucW1wLmMNCj4gaW5kZXggNzk3N2E0OTRhNjUxLi40NGM0NDA3N2RmYzUgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jDQo+ICsrKyBiL2RyaXZl
cnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jDQo+IEBAIC0xMjk4LDYgKzEyOTgsMzcgQEAgaW50
IHp5bnFtcF9wbV9nZXRfZmVhdHVyZV9jb25maWcoZW51bSBwbV9mZWF0dXJlX2NvbmZpZ19pZCBp
ZCwNCj4gIH0NCj4gDQo+ICAvKioNCj4gKyAqIHp5bnFtcF9wbV9zZXRfc2RfY29uZmlnIC0gUE0g
Y2FsbCB0byBzZXQgdmFsdWUgb2YgU0QgY29uZmlnIHJlZ2lzdGVycw0KPiArICogQG5vZGU6ICAg
ICAgU0Qgbm9kZSBJRA0KPiArICogQGNvbmZpZzogICAgVGhlIGNvbmZpZyB0eXBlIG9mIFNEIHJl
Z2lzdGVycw0KPiArICogQHZhbHVlOiAgICAgVmFsdWUgdG8gYmUgc2V0DQo+ICsgKg0KPiArICog
UmV0dXJuOiAgICAgUmV0dXJucyAwIG9uIHN1Y2Nlc3Mgb3IgZXJyb3IgdmFsdWUgb24gZmFpbHVy
ZS4NCj4gKyAqLw0KPiAraW50IHp5bnFtcF9wbV9zZXRfc2RfY29uZmlnKHUzMiBub2RlLCBlbnVt
IHBtX3NkX2NvbmZpZ190eXBlIGNvbmZpZywgdTMyIHZhbHVlKQ0KPiArew0KPiArICAgICAgIHJl
dHVybiB6eW5xbXBfcG1faW52b2tlX2ZuKFBNX0lPQ1RMLCBub2RlLCBJT0NUTF9TRVRfU0RfQ09O
RklHLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNvbmZpZywgdmFsdWUs
IE5VTEwpOw0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwoenlucW1wX3BtX3NldF9zZF9jb25m
aWcpOw0KPiArDQo+ICsvKioNCj4gKyAqIHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyAtIFBNIGNh
bGwgdG8gc2V0IHZhbHVlIG9mIEdFTSBjb25maWcgcmVnaXN0ZXJzDQo+ICsgKiBAbm9kZTogICAg
ICBHRU0gbm9kZSBJRA0KPiArICogQGNvbmZpZzogICAgVGhlIGNvbmZpZyB0eXBlIG9mIEdFTSBy
ZWdpc3RlcnMNCj4gKyAqIEB2YWx1ZTogICAgIFZhbHVlIHRvIGJlIHNldA0KPiArICoNCj4gKyAq
IFJldHVybjogICAgIFJldHVybnMgMCBvbiBzdWNjZXNzIG9yIGVycm9yIHZhbHVlIG9uIGZhaWx1
cmUuDQo+ICsgKi8NCj4gK2ludCB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWcodTMyIG5vZGUsIGVu
dW0gcG1fZ2VtX2NvbmZpZ190eXBlIGNvbmZpZywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB1MzIgdmFsdWUpDQo+ICt7DQo+ICsgICAgICAgcmV0dXJuIHp5bnFtcF9wbV9pbnZva2Vf
Zm4oUE1fSU9DVEwsIG5vZGUsIElPQ1RMX1NFVF9HRU1fQ09ORklHLA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIGNvbmZpZywgdmFsdWUsIE5VTEwpOw0KPiArfQ0KPiArRVhQ
T1JUX1NZTUJPTF9HUEwoenlucW1wX3BtX3NldF9nZW1fY29uZmlnKTsNCj4gKw0KPiArLyoqDQo+
ICAgKiBzdHJ1Y3QgenlucW1wX3BtX3NodXRkb3duX3Njb3BlIC0gU3RydWN0IGZvciBzaHV0ZG93
biBzY29wZQ0KPiAgICogQHN1YnR5cGU6ICAgU2h1dGRvd24gc3VidHlwZQ0KPiAgICogQG5hbWU6
ICAgICAgTWF0Y2hpbmcgc3RyaW5nIGZvciBzY29wZSBhcmd1bWVudA0KPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9maXJtd2FyZS94bG54LXp5bnFtcC5oIGIvaW5jbHVkZS9saW51eC9maXJt
d2FyZS94bG54LXp5bnFtcC5oDQo+IGluZGV4IDFlYzczZDUzNTJjMy4uMDYzYTkzYzEzM2YxIDEw
MDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL3hsbngtenlucW1wLmgNCj4gKysr
IGIvaW5jbHVkZS9saW51eC9maXJtd2FyZS94bG54LXp5bnFtcC5oDQo+IEBAIC0xNTIsNiArMTUy
LDkgQEAgZW51bSBwbV9pb2N0bF9pZCB7DQo+ICAgICAgICAgLyogUnVudGltZSBmZWF0dXJlIGNv
bmZpZ3VyYXRpb24gKi8NCj4gICAgICAgICBJT0NUTF9TRVRfRkVBVFVSRV9DT05GSUcgPSAyNiwN
Cj4gICAgICAgICBJT0NUTF9HRVRfRkVBVFVSRV9DT05GSUcgPSAyNywNCj4gKyAgICAgICAvKiBE
eW5hbWljIFNEL0dFTSBjb25maWd1cmF0aW9uICovDQo+ICsgICAgICAgSU9DVExfU0VUX1NEX0NP
TkZJRyA9IDMwLA0KPiArICAgICAgIElPQ1RMX1NFVF9HRU1fQ09ORklHID0gMzEsDQo+ICB9Ow0K
PiANCj4gIGVudW0gcG1fcXVlcnlfaWQgew0KPiBAQCAtMzkzLDYgKzM5NiwxOCBAQCBlbnVtIHBt
X2ZlYXR1cmVfY29uZmlnX2lkIHsNCj4gICAgICAgICBQTV9GRUFUVVJFX0VYVFdEVF9WQUxVRSA9
IDQsDQo+ICB9Ow0KPiANCj4gK2VudW0gcG1fc2RfY29uZmlnX3R5cGUgew0KPiArICAgICAgIFNE
X0NPTkZJR19FTU1DX1NFTCA9IDEsIC8qIFRvIHNldCBTRF9FTU1DX1NFTCBpbiBDVFJMX1JFR19T
RCBhbmQgU0RfU0xPVFRZUEUgKi8NCj4gKyAgICAgICBTRF9DT05GSUdfQkFTRUNMSyA9IDIsIC8q
IFRvIHNldCBTRF9CQVNFQ0xLIGluIFNEX0NPTkZJR19SRUcxICovDQo+ICsgICAgICAgU0RfQ09O
RklHXzhCSVQgPSAzLCAvKiBUbyBzZXQgU0RfOEJJVCBpbiBTRF9DT05GSUdfUkVHMiAqLw0KPiAr
ICAgICAgIFNEX0NPTkZJR19GSVhFRCA9IDQsIC8qIFRvIHNldCBmaXhlZCBjb25maWcgcmVnaXN0
ZXJzICovDQo+ICt9Ow0KPiArDQo+ICtlbnVtIHBtX2dlbV9jb25maWdfdHlwZSB7DQo+ICsgICAg
ICAgR0VNX0NPTkZJR19TR01JSV9NT0RFID0gMSwgLyogVG8gc2V0IEdFTV9TR01JSV9NT0RFIGlu
IEdFTV9DTEtfQ1RSTCByZWdpc3RlciAqLw0KPiArICAgICAgIEdFTV9DT05GSUdfRklYRUQgPSAy
LCAvKiBUbyBzZXQgZml4ZWQgY29uZmlnIHJlZ2lzdGVycyAqLw0KPiArfTsNCg0KQXMgeW91IGFk
YXB0ZWQga2VybmVsIHN0eWxlIGRvY3VtZW50YXRpb24gZm9yIHRoZSByZXN0IG9mIGNvZGUgYWRk
ZWQgaW4NCnRoaXMgcGF0Y2ggeW91IGNhbiBmb2xsb3cgdGhpcyBydWxlcyBmb3IgZW51bXMsIHRv
by4NCg0KPiArDQo+ICAvKioNCj4gICAqIHN0cnVjdCB6eW5xbXBfcG1fcXVlcnlfZGF0YSAtIFBN
IHF1ZXJ5IGRhdGENCj4gICAqIEBxaWQ6ICAgICAgIHF1ZXJ5IElEDQo+IEBAIC00NjgsNiArNDgz
LDkgQEAgaW50IHp5bnFtcF9wbV9mZWF0dXJlKGNvbnN0IHUzMiBhcGlfaWQpOw0KPiAgaW50IHp5
bnFtcF9wbV9pc19mdW5jdGlvbl9zdXBwb3J0ZWQoY29uc3QgdTMyIGFwaV9pZCwgY29uc3QgdTMy
IGlkKTsNCj4gIGludCB6eW5xbXBfcG1fc2V0X2ZlYXR1cmVfY29uZmlnKGVudW0gcG1fZmVhdHVy
ZV9jb25maWdfaWQgaWQsIHUzMiB2YWx1ZSk7DQo+ICBpbnQgenlucW1wX3BtX2dldF9mZWF0dXJl
X2NvbmZpZyhlbnVtIHBtX2ZlYXR1cmVfY29uZmlnX2lkIGlkLCB1MzIgKnBheWxvYWQpOw0KPiAr
aW50IHp5bnFtcF9wbV9zZXRfc2RfY29uZmlnKHUzMiBub2RlLCBlbnVtIHBtX3NkX2NvbmZpZ190
eXBlIGNvbmZpZywgdTMyIHZhbHVlKTsNCj4gK2ludCB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWco
dTMyIG5vZGUsIGVudW0gcG1fZ2VtX2NvbmZpZ190eXBlIGNvbmZpZywNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICB1MzIgdmFsdWUpOw0KPiAgI2Vsc2UNCj4gIHN0YXRpYyBpbmxpbmUg
aW50IHp5bnFtcF9wbV9nZXRfYXBpX3ZlcnNpb24odTMyICp2ZXJzaW9uKQ0KPiAgew0KPiBAQCAt
NzMzLDYgKzc1MSwyMSBAQCBzdGF0aWMgaW5saW5lIGludCB6eW5xbXBfcG1fZ2V0X2ZlYXR1cmVf
Y29uZmlnKGVudW0gcG1fZmVhdHVyZV9jb25maWdfaWQgaWQsDQo+ICB7DQo+ICAgICAgICAgcmV0
dXJuIC1FTk9ERVY7DQo+ICB9DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgaW50IHp5bnFtcF9wbV9z
ZXRfc2RfY29uZmlnKHUzMiBub2RlLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBlbnVtIHBtX3NkX2NvbmZpZ190eXBlIGNvbmZpZywNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTMyIHZhbHVlKQ0KPiArew0KPiArICAgICAg
IHJldHVybiAtRU5PREVWOw0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW5saW5lIGludCB6eW5xbXBf
cG1fc2V0X2dlbV9jb25maWcodTMyIG5vZGUsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBlbnVtIHBtX2dlbV9jb25maWdfdHlwZSBjb25maWcsDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1MzIgdmFsdWUpDQo+ICt7DQo+
ICsgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ICt9DQo+ICsNCj4gICNlbmRpZg0KPiANCj4gICNl
bmRpZiAvKiBfX0ZJUk1XQVJFX1pZTlFNUF9IX18gKi8NCj4gLS0NCj4gMi4xLjENCj4gDQoNCg==
