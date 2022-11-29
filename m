Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0D563BA79
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiK2HQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiK2HQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:16:35 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA5D391F1;
        Mon, 28 Nov 2022 23:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669706191; x=1701242191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pNaYIbLudgM6eIvSnwUsrpP18xns3Ky2Ae/8fmlKc+c=;
  b=JcsZSoXZ1GtsHs8zdeJU34T4ZpgvEXoAO0B2qVeh3Dll2R36yWsAJeDs
   q+4O14zPlDh+OXe++QavN1krizTA0NfE2m3IImk04g6lC95oc794FhAWo
   qrf/ddODIuqId/H9cpvQ2jdliA0SLJ9OujxK+qVQws4SMvVt9lAiOY57o
   IIiaqJ6txOnoYSLoXjImxO+JJBQVZjC+uvCdQWMGKPExrig/HBw/WNyxP
   clROtiOLD0Q3c2CT8QCEEMa4Ey6cDlC21aiBhrLXgLAVoiA3Q5x/Aitxw
   EcTpXPYmetSiXO3f7bEDQFhVakicHdYICKAkDr51kCrNzADAAQX5c23qP
   w==;
X-IronPort-AV: E=Sophos;i="5.96,202,1665471600"; 
   d="scan'208";a="189109520"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Nov 2022 00:16:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 29 Nov 2022 00:16:29 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 29 Nov 2022 00:16:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dM8PHIVG5oPKfBk7DIU4+SsYV6BRiW1CkyAo86CNR2wbWYY6E9+JwT8yTnPfq6qMUvU3UQSPqzpl/FPpUi5pu/vMZU3oLtzAzFss11E4RZy+8Yyx2EqHJsB/CmV49alVJ6Q256Hyo8klJf7S6094lTYgTA/wJwtT9bnY4iGVKjzepVAwKqPrerXRryjV+dteSkHgrYoTVkHpn18SG9JXQ+k1auL7LIt4HP7O8Pfk24nrCbE9baO0JZctuLMxN/QOYqF4/gvxceDt7LwJdhTURsIvksfl7GHghUT1i1C6bE1lHOOG6j4IVxmOCHiIFEj2Z3Y1EJI+C4W6gtHxaTIhFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNaYIbLudgM6eIvSnwUsrpP18xns3Ky2Ae/8fmlKc+c=;
 b=LVUTcvklJg+bwasROygmAL7xCCS777Fs2z59MpWIFBSBnLLF4F6Rlp0KhNdZ5YPWKoJBK0mvZAWb3K7DqWqXZ/iYEM7UJPQ7qzXyWFyDLb4OquDTpMSYb2Mvqz/8IqDt97peGeOPexc3gNPJ1b/zw6nlvn63CpK3mbxv0twUm8/fn/mPchE/G1Z0O20IvtGnwHSIhWFkE0zy2kLhDIuwziYAo+NkItF/3gHlVAVrKyNQgG2827kh6slX8vLmrQ91xWwDJuO5/FMQ6DZcDkovIzGYaFbUuZW6ZEO3u28ay5ONR+jOpAhh+i124/hHSu9UvZcXDyJ7N9SGf43WOsENYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNaYIbLudgM6eIvSnwUsrpP18xns3Ky2Ae/8fmlKc+c=;
 b=kToSkrnV8vijsrHdfL5THm4XqjUQk3wnYnXvahRVsiTmbMS5Nzg/32KaoOiEWLKgW99WNj16aHXB08bmEZS+vq3xNZap6H+lnuBX1Kt+Tul8Gj6ITu0XAoLYWT7JB0DlZPpKjjUm5IbuD2OYs8Peodq3CZ5HPMuX6HFl2elPpp0=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 IA0PR11MB7884.namprd11.prod.outlook.com (2603:10b6:208:3dc::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.6; Tue, 29 Nov 2022 07:16:27 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 07:16:27 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH v1 07/26] net: dsa: microchip: ksz8_r_dyn_mac_table():
 remove timestamp support
Thread-Topic: [PATCH v1 07/26] net: dsa: microchip: ksz8_r_dyn_mac_table():
 remove timestamp support
Thread-Index: AQHZAyEc2CPLknH7Yk2q51d/CLqPAq5VfroA
Date:   Tue, 29 Nov 2022 07:16:27 +0000
Message-ID: <a071d537a85a0cbde34ca20c08fd6243ce7c367f.camel@microchip.com>
References: <20221128115958.4049431-1-o.rempel@pengutronix.de>
         <20221128115958.4049431-8-o.rempel@pengutronix.de>
In-Reply-To: <20221128115958.4049431-8-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|IA0PR11MB7884:EE_
x-ms-office365-filtering-correlation-id: 4722d7d1-fc2d-46ed-b248-08dad1d9a155
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wjHwOQta+Qm7v5Lg5JE+p713eUl8+CWVCFSeWLcH6ulaPL0roFepMgmoRWx9H6rE90Z9CM0pZ62jA2sbUG/uzKtoRCgEqEzNr/HcmldT6pznLZoqK7GBWG8G44Za8hsKTUEOcBDcF7jY6gzmehErX7EjMn8FkCPN2gCFOiM0NhMz8TLtVUjDUDw9PeYQ9yhefU0vX58i6Jyci+ueodo3QxDSn8e/qE3Ilgjx8/aGgc+XiIr/qoFtXjMfCzZLVo1OjP9S6FASGECYt7hihKGxnVI69qRQ82lVdQ+i66nUtMK+89IPI35ClVXBjxUE7DfRYVZlE23uWnC6u457M3nRnjgGzO5BUTvyTBYsptLKlhDZh8e+svbtlorVjiFgNigFMV2TgsRLTSuaiS8kVT60+z4+nFS1UAQWu6e24YR3nGf0G6Ai9ockGooA352NJAM0pV84o6UBQXPAnPtN4Y5a5795E4o7RhleB2bQAiI/RAUYgBetmw5muyvJpDsNxibm5ZDeOM2u3VTK4yU0Z+bj5oA8+SN/uV2AMRoQS8jALq13e8vZj1JqrtB8p3DLRX+VddUILDFQj5epQl6SRlwXWbdoB9iGz4OVK3PpRX2OgXnKCJJPXQju+nfbzQh/zmIsCcOMHx0hNE6eEi2lmaJPpZri/mSSgV2ePgkGYR1QEndJ6vL3Nat3U8APkEhW5OgWB7B4gzyqsTiLSSeTWwzPryqKHdEiQvHmUo2uIj+Ty/lwMhoxkhASjCFfH6RYmuh8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(36756003)(122000001)(4001150100001)(2906002)(7416002)(41300700001)(38070700005)(921005)(38100700002)(86362001)(83380400001)(66946007)(6486002)(54906003)(8676002)(76116006)(91956017)(2616005)(316002)(71200400001)(66446008)(66556008)(478600001)(110136005)(64756008)(66476007)(8936002)(5660300002)(6512007)(186003)(26005)(6506007)(4326008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WndjQkVoeUl4TkRwMm56dFdDZW4wRXlyYnpwTVJHejQ5NUVmWUZMNFIvV3JJ?=
 =?utf-8?B?Nk1Rd2VUSTM4OEhwd1BOOEx0bWxuS2JYbmMwYnlNRFRqZEtyZmRSZUJYR1pV?=
 =?utf-8?B?Q2lvVS9zWjR4V2NXVTZxYUNlRldrTEQxdEtkeFJPZzFjUDVYak0zZGFLOUk5?=
 =?utf-8?B?MVV1ajN0dWFLM0t0ODkyWmVtMWkzOTc1dHBOVEQzUEU1Y2cvMGtiUVpmcVR2?=
 =?utf-8?B?TFhlcGUvS2dsbG5VdjhzamxFUS9Tamg4cmVUMEIxYjBlQk9HbU5GQllaaW5S?=
 =?utf-8?B?VXJYTUwyNGF5MDVYZ2ExQ3lJV3RLM2FPY3hYZFhORWQwdTZiaDBjVGtISkNX?=
 =?utf-8?B?bmRqbXRBQ0RxL3pkdW5Ub1lBeDU3cWpQZTZ5R2ZZQTBlVTdjOSs5YjVFQzc1?=
 =?utf-8?B?cWlyNjVNMzBlek1najhsTm5MNVBmN3M2MFFQMVVzVExBRC8zdE9DVEJ2RGJu?=
 =?utf-8?B?ZFUzUEtldkRmR0lIZTluakIrdnNIOThvMG1wV3FrT2VSb1ZjWllSQWJqc3pQ?=
 =?utf-8?B?K1ZIdVNvaGFTRUdiUHFHdGpHcmc4bU1ZbUNCRURrLzNkbUJ4disrM1pzU24y?=
 =?utf-8?B?YjlWRStMZEh3eGJ2Y1hZaXJOa21uQ1NSbkd3WmhCSWRYRU9Lck93aW9sQ2oz?=
 =?utf-8?B?ekNueWM1ZnVQemdUWGxuSDB5bklyS2MvdnZKSDlBSUx1Z2NydE8xeTFmSmFG?=
 =?utf-8?B?QWlIL0ZYaGhQcDdIVndLSFA3b0tIZU5vM2s1bHhZeCtXSmU5RWFOV1ZTMXVB?=
 =?utf-8?B?Ny84UmNJZURvdUYwM3g2Yy9pWEtuUEtTdmRHQkFyM3JVYWUzaEJYcXRPTmZT?=
 =?utf-8?B?eW4xUHk0M2tKUGVJVW5jdks3WUJzNHVyMG1SNmNlSVZWd21MdHkyTkg2YmRO?=
 =?utf-8?B?YnVYdi9TQjhpaCtTUDZnQ0d6WnlQdVIyeUNoWmdNTTZCNlhKTWZ3TFRldWNC?=
 =?utf-8?B?SU55S29jYmVkVnpIZFhHdlE3ejdkci9tQWNyQVV2d3lDaXBpbiswNjZEU1ZY?=
 =?utf-8?B?NkhRUy9FYURCYlBYS09zcitxS1NKeUppRnF4RkMwVGZyRHlEK05pWWJvYTZ6?=
 =?utf-8?B?Ym5MS1NqSk1tVEo0YW5QdGplanQ0YXhJQVFhdFUxa1Q4aVYzTW1CTjNlWFpW?=
 =?utf-8?B?Y2h2UVh1V1UraXowQlU5cW1WNndWdVBJNGdRa016K21tR2pVVVkyYnNRVm83?=
 =?utf-8?B?NHVWNWpCRHR4Tjhscklhc1E5dEFQK2IyY0dpeFdUVmN2cjRCU1hGNXdVMVlG?=
 =?utf-8?B?VWs4c0s2SGxFdXBDY1pxMGJKL0VqVGZUREJ4SXRlTkNNZXZvL1kyNVkvcjEx?=
 =?utf-8?B?V0UwSG81MGVXc0ZuZVRXTVROa2JQeE9sWWYzOWcwTmZaUlorWEMxRFArdnkv?=
 =?utf-8?B?alV6d1podDFWOE9HK2liTnB1TkozazFZU1FJdDdKNkxhbmRFM0VZZjI3ZnhS?=
 =?utf-8?B?Z3V5a2Z3cytlSUVkak5JYWhEK3JsdDRiZkNpTVBRSFplblo3QVFiRUxyNmxX?=
 =?utf-8?B?N2lLY3F4cTBRRE5veVNaQ2dyMFhnQllJalZQU1BDcnJacWV6c1hHbXJxVWpZ?=
 =?utf-8?B?K2J1aEJ2T3R3bXZYTnNFVWw5R3lZN3BUeFZlK1ZtUTN3dE9EYkFxWHpUMnZI?=
 =?utf-8?B?UnNsK3dTZnVISk9TODZERVJuTEpScVo0SEIvZ3NxK2Nzc044UWVOQTBNVnlM?=
 =?utf-8?B?SlpWaVM2dHJXUUF3bzM4RnA1dlZFREpHU0ZLTUVud2I4d3FOMFAzZ2ZvcTM0?=
 =?utf-8?B?a2ZRVzRBNmU5em5FMmo2WHIwdzQ1SndpRm5xanBPR1IvT1FRYzBnMVpMNHNH?=
 =?utf-8?B?bUw3TnRzb3h4VmE2Z3h4L25uL1EyczArdU1TaTFyem4xeEVSY2tJQXVLZ3BZ?=
 =?utf-8?B?RVEzelZsMCs0K0dZSG9OS3Z4VGppZGtvbDE4Y1VCeDBBRWFMdUZaTHd4RWRN?=
 =?utf-8?B?MkJhc1pCbXYrajE5TS9tOEhrZ3k5QWFPaUczRjNsdENiS2VhTFI1d21IVXZK?=
 =?utf-8?B?ZzZvYkZlSlJsQVVka1Q3NFVoWTNzMkNnS3lmQlBZOW94WWtBVGdwQVBCVDRV?=
 =?utf-8?B?aGJMNzJ6dWRhV09HUEhCUE9tN0dCclN1ZjlIMkhZcGdtalZDQys0NGRBL3Bq?=
 =?utf-8?B?bVZVa1F0MzNuY1ZmVWJ2SmZ1UThXQnNaL28zd1IxQVhJTjVtZjc4eUVlUkFJ?=
 =?utf-8?Q?9tncS+6+JfjKKCpF0wF0Gf8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B27D6C0068E3E44B48E7DB457100D6D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4722d7d1-fc2d-46ed-b248-08dad1d9a155
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 07:16:27.1046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u0xkUq4WwOagpViMs70uP6yNGgiSdHezbELv77CkJ73KloK1eCcHqwM689GFSdiAoEUbcXZrBDwh3CVxQywspmQg25sGOjh8n37ngRortTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7884
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gTW9uLCAyMDIyLTExLTI4IGF0IDEyOjU5ICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBXZSBkbyBub3QgdXNlIEZEQiB0aW1lc3RhbXBzLiBTbywgZHJvcCBpdC4NCg0KSWYgdGhl
IEZEQiB0aW1lc3RhbXBzIGFyZSBub3QgdXNlZC90byBiZSBkcm9wcGVkLCB0aGVuIGRvIHdlIG5l
ZWQgdG8NCmhhdmUgcGF0Y2ggNCAgKiBuZXQ6IGRzYTogbWljcm9jaGlwOiBrc3o4OiBrc3o4X2Zk
Yl9kdW1wOiBmaXggdGltZQ0Kc3RhbXAgZXh0cmFjdGlvbiAqIHdoaWNoIGlzIHRvIGZpeCB0aGUg
b2Zmc2V0Lg0KDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxA
cGVuZ3V0cm9uaXguZGU+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4
LmggICAgfCAyICstDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYyB8IDcg
KystLS0tLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25z
KC0pDQo+IA0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6
ODc5NS5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gaW5kZXgg
ZTA1MzBiYzNiZWMwLi5kMGNmZTc0ZDViMTMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2Rz
YS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
a3N6ODc5NS5jDQo+IEBAIC0zOTUsNyArMzk1LDcgQEAgc3RhdGljIGludCBrc3o4X3ZhbGlkX2R5
bl9lbnRyeShzdHJ1Y3Qga3N6X2RldmljZQ0KPiAqZGV2LCB1OCAqZGF0YSkNCj4gIH0NCj4gDQo+
ICBpbnQga3N6OF9yX2R5bl9tYWNfdGFibGUoc3RydWN0IGtzel9kZXZpY2UgKmRldiwgdTE2IGFk
ZHIsIHU4DQo+ICptYWNfYWRkciwNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgIHU4ICpmaWQs
IHU4ICpzcmNfcG9ydCwgdTggKnRpbWVzdGFtcCwgdTE2DQo+ICplbnRyaWVzKQ0KPiArICAgICAg
ICAgICAgICAgICAgICAgICAgdTggKmZpZCwgdTggKnNyY19wb3J0LCB1MTYgKmVudHJpZXMpDQo+
ICB7DQo+ICAgICAgICAgdTMyIGRhdGFfaGksIGRhdGFfbG87DQo+ICAgICAgICAgY29uc3QgdTgg
KnNoaWZ0czsNCj4gQEAgLTQ0MCw4ICs0NDAsNiBAQCBpbnQga3N6OF9yX2R5bl9tYWNfdGFibGUo
c3RydWN0IGtzel9kZXZpY2UgKmRldiwNCj4gdTE2IGFkZHIsIHU4ICptYWNfYWRkciwNCj4gICAg
ICAgICAgICAgICAgICAgICAgICAgc2hpZnRzW0RZTkFNSUNfTUFDX0ZJRF07DQo+ICAgICAgICAg
ICAgICAgICAqc3JjX3BvcnQgPSAoZGF0YV9oaSAmDQo+IG1hc2tzW0RZTkFNSUNfTUFDX1RBQkxF
X1NSQ19QT1JUXSkgPj4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgc2hpZnRzW0RZTkFNSUNf
TUFDX1NSQ19QT1JUXTsNCj4gLSAgICAgICAgICAgICAgICp0aW1lc3RhbXAgPSAoZGF0YV9oaSAm
DQo+IG1hc2tzW0RZTkFNSUNfTUFDX1RBQkxFX1RJTUVTVEFNUF0pID4+DQo+IC0gICAgICAgICAg
ICAgICAgICAgICAgIHNoaWZ0c1tEWU5BTUlDX01BQ19USU1FU1RBTVBdOw0KDQpUaGUgbWFjcm9z
IERZTkFNSUNfTUFDX1RBQkxFX1RJTUVTVEFNUCBhbmQgRFlOQU1JQ19NQUNfVElNRVNUQU1QIG5l
ZWRzDQp0byBiZSBkZWxldGVkIGluIGtzejg3OTVfc2hpZnRzL21hc2tzIGFuZCBrc3o4ODYzX3No
aWZ0cy9tYXNrcw0Kc3RydWN0dXJlIGluIGtzel9jb21tb24uYy9oIGZpbGVzIHNpbmNlIGl0IGlz
IG9ubHkgaW4gdGhpcyBmdW5jdGlvbi4NCg0KPiANCj4gICAgICAgICAgICAgICAgIG1hY19hZGRy
WzVdID0gKHU4KWRhdGFfbG87DQo+ICAgICAgICAgICAgICAgICBtYWNfYWRkcls0XSA9ICh1OCko
ZGF0YV9sbyA+PiA4KTsNCj4gQEAgLTk1NiwxNCArOTU0LDEzIEBAIGludCBrc3o4X2ZkYl9kdW1w
KHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludA0KPiBwb3J0LA0KPiANCj4gLS0NCj4gMi4zMC4y
DQo+IA0K
