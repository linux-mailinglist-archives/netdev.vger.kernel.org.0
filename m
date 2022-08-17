Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1998E596A8E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 09:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbiHQHo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 03:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiHQHo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 03:44:57 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00058.outbound.protection.outlook.com [40.107.0.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EB8326D9
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 00:44:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C01M5t4uu31QfjvhXfX6gdVOWmPgA0qk7xWvprbIznCXQhujSND0HC3vfuyOzov2VVZvvI0Jvi4rM/dliD4gGCjHzqAYebdkk0ANoxZq9qlp+5Q0jivJhhM6PWU4RI0A1aFpp7sEEMB9iPqw6FUNhm1bf7i8lnK4WZ+Tfk0Ni0xyK8eoh+XS4vIIldBqvTGCyRTHoq75a5h65TbKlvN9eDBZw90ttrIp3ruAP8kHFSW7CZPbPnvEwXtJfksOFS65SxYTp6gct5OTL9GgokAKrB3UGk+bhjgqQZba3xWSdwaJRhjEOE/bRZjrlO1PAWlLzapGyUzW6w1fLBb9lFmpGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qg0j74MOppwPnGnbvYr/lEzWnypnMyojid/5Mk/GAq0=;
 b=eKqtOC+DZ/QHeJZRk+FeF1uoffxWDQbouQDHUmQK+YXOr0hZKSk8GbK2IY6Un+2EubZMP+MqP10cYLdGR4qjX9DaNGBCdAHw8sZCk9ZhNGFH9P0GJaQMejzSEr5+RqmYrNuaMlEfVpjanuSgvAuMJK5oDH6qlyT2rqwVFeK9cKmKRiqsAof6Of6okZ4q8CUgJyMagS3y41XsmC1uZPFTkSxTMbHmvhq847yTeykuQod9RUbzswdca7xbOLksu+9hi+ujTu1UVb9XDsWaF22T1T658O8K43Ki4RrJEY1HgshQq9gmTtr+lEYGVSgAIUZ4eS86+TAybFpxV+tFHTR2rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qg0j74MOppwPnGnbvYr/lEzWnypnMyojid/5Mk/GAq0=;
 b=mf8wWqECl9hHdV1CmjWbREhgJSr9mZPogARxRQ0KgKhME9InkEHwnLfPjqFZVjNji6o8KjOJxfAP5hIRcK+S4wZ5Fpzzc78O4g6QY0f8Rb80TFl/F2ZbrtoEPDj2g+ryChAnA0XvlTav5jUYOLbrCBT1D5RxdwIH9pt+EFn+V7w=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by PR1PR07MB5898.eurprd07.prod.outlook.com (2603:10a6:102:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.15; Wed, 17 Aug
 2022 07:44:53 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::dd4a:cda1:59f2:a19a%5]) with mapi id 15.20.5546.015; Wed, 17 Aug 2022
 07:44:52 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
CC:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2vsfIAgAHAowCAAXQNgA==
Date:   Wed, 17 Aug 2022 07:44:52 +0000
Message-ID: <75b5a39959ad1c80ce10978dcf63fb98391ba703.camel@ericsson.com>
References: <VI1PR07MB4080AED64AC8BFD3F9C1BE58E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <VI1PR07MB4080DC45051E112EEC6D7734E18D9@VI1PR07MB4080.eurprd07.prod.outlook.com>
         <87tu7emqb9.fsf@intel.com>
         <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
         <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
         <87tu6i6h1k.fsf@intel.com>
         <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
         <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
         <20220812201654.qx7e37otu32pxnbk@skbuf>
         <1016fb1e514ff38ebfd22c52e2d848a7e8bc8d1a.camel@ericsson.com>
         <20220816093314.hqfnzangzamjdpkl@skbuf>
In-Reply-To: <20220816093314.hqfnzangzamjdpkl@skbuf>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40b3e85a-5e1c-4ed6-c8b2-08da80245ee3
x-ms-traffictypediagnostic: PR1PR07MB5898:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: btQWO8gdG2Th5s30HffLnrZp5DmOWucX8iTZDYPeZ8BytogArj3riStCCznfEqkaKtZcTBI0VXp5u2fal+QSr+I77UNJw5NA+K8k4pCdTS4bJrHv6OypHEtO9oNar67Z2gqKI1rxWWOu9OAh7QSLqmxBz1GrZrtICkWUKoB9qh4BBGXltz5G5loGDJ+yKgGswq0uiFLX8B9VyOzqc16vw78PoAxgKMqjRcKd8nR/TBtXwcLU6uuQlWlkeGJr8OS86NHh5G0EUJW5hV/gNgS6syC3535U9zcSG4rlp26fVJ7l3gispzzea7yCmnStLT0s11xr3CK5bEgNPdlu1X0E+485aDWfru8VL6PISSqL1yYGfjmzrY82ic96cNDcgH8W26ZbEIgx/hsQILO4k5iPgoliwiSFsk9ceRkzRqdzrS0ZM7JQLofHDf23q8dkDBMXs4fNruL+bPP4OjTsaI4nLavgt6yjhqpu5rYoNlPNT1QFqUboQ+RsF+pbPN+MnihCLPtrJbIeN+3yf1a/PkssL5dDjyFnCET4yIhzBxk4Ojt8XhwJ4sgEf1BeM+qN1VPP2wkj7FkYFapmR9yZYCa/VqFvU4t5kWYfSOCmjgUx48Ku76BObQ5LnndbrMcCli007X0YNUSb/dGDMDG6iPQbj6BZr1S3GrUg6Ye03GqBwihvUG6nPxWtGp8c8FZ/Ig+cq6qGE/yETPBYTHwWXOcQWJVhOE31PWNmhQLdZmnyQTkDQ2XlsfYKlaelM2nY8w3o5VsbaureEXEcmJ8Ct28a9fa1j3863byGEkhje6oScQDnzpJ7VUzMpoKXDAx4HRK6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(6916009)(6486002)(54906003)(316002)(478600001)(82960400001)(186003)(2906002)(2616005)(83380400001)(38070700005)(71200400001)(38100700002)(6512007)(41300700001)(26005)(122000001)(6506007)(66946007)(44832011)(36756003)(5660300002)(8936002)(76116006)(91956017)(66556008)(66446008)(64756008)(4326008)(66476007)(8676002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djdYREhNMHRoazhoWlkxNlF1MGd4cDJUS0pnRnJkeVF2cUFMcTNwOHc0NGZV?=
 =?utf-8?B?ekVTdEt4ME0rN2hTWUxqclJsMmxlSWlvOGZ6dmt2WkdsVy9FeGQ3Z1hXcWgy?=
 =?utf-8?B?RzlnZ2ZTRkpsb203YXVmcEZYWVBUOE1UNStTdWFnb1pvN29LRG9GUjlyNkRL?=
 =?utf-8?B?WUpaSEpSRmRhamdZSE0yT2tieWdYUTNJZ1lGSGZOcG9SbXJpUjd0bWFrU0NJ?=
 =?utf-8?B?WjNGUU1rWG8xYWo0UjZ4RjNlaERKczYzczRqUVQ5MzBJbzBpamtkRHFQNmJ1?=
 =?utf-8?B?ckhxNWVuNGNqWWJnRUhNLzJGT3k5TitaQU1XdnJIVzFDU1YxZmpqUitRSS9V?=
 =?utf-8?B?TWJEYlRubUFkMEpOZUwvbWd4RGEwTjU1cG9WclBYV29GcXRqck1BUm5Wd1oz?=
 =?utf-8?B?c2tJV0svM25LajFJNUZsWklTMTJvRTlTUEYzTXdVZmhMQzFWOUJiZTZhZXBt?=
 =?utf-8?B?b3lldVNuWWx1MVU3ZVI1YUxZbmhWWitDTnZWVWtkTGFQQmRVQ2M5c0dnNUc3?=
 =?utf-8?B?MHpDM0pLSktRYTcrTndPaTlmc0lPalplQlRaY3JocEkrTFVxV3Rudm1qUFFh?=
 =?utf-8?B?b2x0S1ViRjMwQ0U1NDI3U25TT3N1WFNWbHBWVEpZNmJFbzJ3UkwvMVVUcDV0?=
 =?utf-8?B?N0RqUzdneTVaUWN4SmFBS0lkTkpENTZlMXlhYXBHUkZhU0VtVkFCR1A0UXZq?=
 =?utf-8?B?TTk2d3RIQnFWb3VleTY5OTVXcjZ1RkV4TGhlRFlOc1U3M2JXaDNPYmE2azc0?=
 =?utf-8?B?enBGQmxvQkNON050RnBXYVhwRlF5OVE1dFNOYlVlYnhXM0JpVG0wc3pHUFJm?=
 =?utf-8?B?TkZYYXNJZVV6SThMR1hlV3E0d3lLb0RCbXBkU003bTlKdXVvV21SSEZ5Z2xt?=
 =?utf-8?B?aUgxcVRJTHoybE81bkxvakt1N0xJTmRsMzVLTG85NTJWYWdpak5sM0ZGRjRP?=
 =?utf-8?B?UTI3UUlpY3FJY3hPSEZZRUIwUzBaNzJncU9rSmxxMXVFdnZad203bEdhdUpj?=
 =?utf-8?B?cHRJNU5yOXhEUWQ2bEVqczVHRWFWTWRCNHVsdHZGVDRxRFZHQk9KSDd6d0E3?=
 =?utf-8?B?RWlid0ZlVG1jdzFUME4ySE5Salp5Y2szWmZ2cUk0MkJOcUFPYUVoOVJObmM3?=
 =?utf-8?B?VGFuVEovR3YvRkllR3pxc2hsaFJLSERtYkVLVjVQUDAzTGgvckZ0WERMQytK?=
 =?utf-8?B?OTVpbUt2eW9zU3VnTHhzVmloUXJMV2Z3UWw0U0ZaWllMaGczUzlzT3gyT1Js?=
 =?utf-8?B?REJjQ2c2d0FvODZwTjJqc3lDaVdyTjVXTExtNVBOQW5oR2ZDeUxGWjRTeUZz?=
 =?utf-8?B?K2k0Y3BZV0JET3U2MklZOGJqT0g2VFFGUzRxSTlDdENUL2xGRVk3QkNqOEVr?=
 =?utf-8?B?QjVIVnR4cksyMGdpNUFRdndGcFlZWWdNcmNmaHlGV01Kc0FaTkZsbjl3Nkc1?=
 =?utf-8?B?S241M3RyVzMvL0NBeW8wK2xxdzA3Ylc2cjlHUTU1ZHVLNDEyS2c3SGJzeldh?=
 =?utf-8?B?Tk9qQWVEWTZSaWF5cnBHZ0xCWTJPQjZ0RnRCUURKYkkyQzNZQlNXNUZDbGpa?=
 =?utf-8?B?dU9MZkVjSXZmZUJ3M0ZTNG5yUEEvVHpmVENuT25RSVM1Yzl0MllpTlVKTy93?=
 =?utf-8?B?SDBZK0hwRVc1eGpzNHFDM21DV3RMV3Z2Rmw0dE95aGpER2lSVnZDSHkvMHdP?=
 =?utf-8?B?NDJoaWg2OURnYzZGekFOQVZiOFJDZm00QWlQb2xJd24xazV6SjAva3RtL0lB?=
 =?utf-8?B?VUpqRTVNMk8ydk5VSklIWTRjWVFxenlZVS9ETGlVRXZza1JQVTRzVlJMNzdV?=
 =?utf-8?B?UkpuZnJIODBQM3VkWXVmNXVEWHY0UkoyeXBpK01QZjJSZUdQM0JnTURMQ0No?=
 =?utf-8?B?T2dLejBYdXdMbys4UUhnYmgyc2VjT0h3YUluY3JDOStDTmhwY29icjVwTFhm?=
 =?utf-8?B?U2dOcEhCVkFmQnZMakk1TmVlZzJHVEVqbkorQkJ3ak5BZm1oRlJBUkdIZFkv?=
 =?utf-8?B?UnVvcXRNbjc2RXZRRzc2WmV5c0Z4VFA3TjZDZUhLTGtlVnJLT3ZENlk3amR1?=
 =?utf-8?B?Vmx4QXVOeUY2cUJqOWhuUE1lVjJLQnZPTGhtTWQ1b1p1cXJnU3Bzc3JtUEFU?=
 =?utf-8?B?Ri9HSm5vR1c4QkFRSERDZTNlS1k4T2JMTGZzMTJjT0Q0Rkp6aUFxN2RvMFBS?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0872A4098A773409248473E77E1F4BD@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b3e85a-5e1c-4ed6-c8b2-08da80245ee3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 07:44:52.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXi0BQsdkozjY5nKs6hKINp4yHOtyVa1RmGRG/gAGHHsslPVD0yOUJ+tbv1//wHLWVrLLkWPySQP2Dv8fXwhcgh0Hr1B6kspsX8p4WfE8wM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR07MB5898
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIhDQoNClRoYW5rIHlvdXIgZm9yIHRoZSBleHBsYW5hdGlvbi4NCg0KT24gVHVl
LCAyMDIyLTA4LTE2IGF0IDA5OjMzICswMDAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IEhp
IEZlcmVuYywNCj4gDQo+IE9uIE1vbiwgQXVnIDE1LCAyMDIyIGF0IDA2OjQ3OjMxQU0gKzAwMDAs
IEZlcmVuYyBGZWplcyB3cm90ZToNCj4gPiBJIGp1c3QgcGxheWVkIHdpdGggdGhvc2UgYSBsaXR0
bGUuIExvb2tzIGxpa2UgdGhlIC0tY3B1LW1hc2sgdGhlDQo+ID4gb25lIGl0DQo+ID4gaGVscHMg
aW4gbXkgY2FzZS4gRm9yIGV4YW1wbGUgSSBjaGVja2VkIHRoZSBDUFUgY29yZSBvZiB0aGUNCj4g
PiBpZ2NfcHRwX3R4X3dvcms6DQo+ID4gDQo+ID4gIyBicGZ0cmFjZSAtZSAna3Byb2JlOmlnY19w
dHBfdHhfd29yayB7IHByaW50ZigiJWRcbiIsIGNwdSk7DQo+ID4gZXhpdCgpOyB9Jw0KPiA+IEF0
dGFjaGluZyAxIHByb2JlLi4uDQo+ID4gMA0KPiANCj4gSSB0aGluayB0aGlzIHByaW50IGlzIHNs
aWdodGx5IGlycmVsZXZhbnQgaW4gdGhlIGdyYW5kIHNjaGVtZSwgb3IgYXQNCj4gbGVhc3Qgbm90
IHZlcnkgc3RhYmxlLiBCZWNhdXNlIHNjaGVkdWxlX3dvcmsoKSBpcyBpbXBsZW1lbnRlZCBhcw0K
PiAicXVldWVfd29yayhzeXN0ZW1fd3EsIHdvcmspIiwgYW5kIHF1ZXVlX3dvcmsoKSBpcyBpbXBs
ZW1lbnRlZCBhcw0KPiAicXVldWVfd29ya19vbihXT1JLX0NQVV9VTkJPVU5ELCB3cSwgd29yayki
LCBpdCBtZWFucyB0aGF0IHRoZSB3b3JrDQo+IGl0ZW0NCj4gYXNzb2NpYXRlZCB3aXRoIGlnY19w
dHBfdHhfd29yaygpIGlzIG5vdCBib3VuZCB0byBhbnkgcmVxdWVzdGVkIENQVS4NCg0KSSBzZWUs
IGdvb2QgdG8ga25vdy4gSG93ZXZlciB3aGVuIEkgbGV0IGJwZnRyYWNlIHJ1biBkdXJpbmcgdGhl
IHdob2xlDQptZWFzdXJlbWVudChzKSBpdCBhbHdheXMgcHJpbnRlZCB0aGUgc2FtZSBDUFUgY29y
ZS4gSSBhZ3JlZSB0aGF0IG1pZ2h0DQpoYXBwZW5zIGJ5IHB1cmUgY2hhbmNlLCBidXQgZnJvbSBt
YW55IG1lYXN1cmVtZW50IEkgY2FudCBzZWUNCmNvdW50ZXJleGFtcGxlIHNvIGFmdGVyIHRoYXQg
SSBkZWNpZGVkIHRvIGp1c3QgcnVuIHRoZSBicGZ0cmFjZSBhdCB0aGUNCmJlZ2lubmluZyBvZiBt
eSBleHByaW1lbnRzLiBJbnRlcmVzdGluZyBuZXZlcnRoZWxlc3MuLi4NCg0KPiBTbyB1bmxlc3Mg
dGhlIHByaW50cyBhcmUgdGFrZW4gZnJvbSB0aGUgYWN0dWFsIHRlc3QgcmF0aGVyIHRoYW4ganVz
dA0KPiBkb25lIG9uY2UgYmVmb3JlIGl0LCB3aGljaCBwZXJjcHUga3RocmVhZCB3b3JrZXIgZXhl
Y3V0ZXMgaXQgZnJvbQ0KPiB3aXRoaW4NCj4gdGhlIHBvb2wgbWlnaHQgdmFyeS7CoCBJbiB0dXJu
LCBfX3F1ZXVlX3dvcmsoKSBzZWxlY3RzIHRoZSBDUFUgYmFzZWQNCj4gb24NCj4gcmF3X3NtcF9w
cm9jZXNzb3JfaWQoKSBvbiB3aGljaCB0aGUgY2FsbGVyIGlzIGxvY2F0ZWQgKGluIHRoaXMgY2Fz
ZSwNCj4gdGhlDQo+IElSUSBoYW5kbGVyKS4gU28gaXQgd2lsbCBkZXBlbmQgdXBvbiB0aGUgdHN5
bmMgaW50ZXJydXB0IGFmZmluaXR5LA0KPiBiYXNpY2FsbHkuDQo+IA0KPiA+IA0KPiA+IExvb2tz
IGxpa2UgaXRzIHJ1bm5pbmcgb24gY29yZSAwLCBzbyBJIHJ1biB0aGUgaXNvY2hybzoNCj4gPiB0
YXNrc2V0IC1jIDAgaXNvY2hyb24gLi4uIC0tY3B1LW1hc2sgJCgoMSA8PCAwKSkgLSBubyBsb3N0
DQo+ID4gdGltZXN0YW1wcw0KPiA+IHRhc2tzZXQgLWMgMSBpc29jaHJvbiAuLi4gLS1jcHUtbWFz
ayAkKCgxIDw8IDApKSAtIG5vIGxvc3QNCj4gPiB0aW1lc3RhbXBzDQo+ID4gdGFza3NldCAtYyAw
IGlzb2Nocm9uIC4uLiAtLWNwdS1tYXNrICQoKDEgPDwgMSkpIC0gbG9zaW5nDQo+ID4gdGltZXN0
YW1wcw0KPiA+IHRhc2tzZXQgLWMgMSBpc29jaHJvbiAuLi4gLS1jcHUtbWFzayAkKCgxIDw8IDEp
KSAtIGxvc2luZw0KPiA+IHRpbWVzdGFtcHMNCj4gKC4uLikNCj4gPiBNYXliZSB0aGlzIGlzIHdo
YXQgaGVscHMgaW4gbXkgY2FzZT8gV2l0aCBmdW5jY291bnQgdHJhY2VyIEkNCj4gPiBjaGVja2Vk
DQo+ID4gdGhhdCB3aGVuIHRoZSBzZW5kZXIgdGhyZWFkIGFuZCBpZ2NfcHRwX3R4X3dvcmsgcnVu
bmluZyBvbiB0aGUgc2FtZQ0KPiA+IGNvcmUsIHRoZSB3b3JrZXIgY2FsbGVkIGV4YWN0bHkgYXMg
bWFueSB0aW1lcyBhcyBtYW55IHBhY2tldHMgSQ0KPiA+IHNlbnQuDQo+ID4gDQo+ID4gSG93ZXZl
ciBpZiB0aGUgd29ya2VyIHJ1bm5pbmcgb24gZGlmZmVyZW50IGNvcmUsIGZ1bmNjb3VudCBzaG93
DQo+ID4gc29tZQ0KPiA+IHJhbmRvbSBudW1iZXIgKGxlc3MgdGhhbiB0aGUgcGFja2V0cyBzZW50
KSBhbmQgaW4gdGhhdCBjYXNlIEkgYWxzbw0KPiA+IGxvc3QNCj4gPiB0aW1lc3RhbXBzLg0KPiAN
Cj4gVGhhbmtzLg0KPiANCj4gTm90ZSB0aGF0IGlmIGlnY19wdHBfdHhfd29yayBydW5zIHdlbGwg
b24gdGhlIHNhbWUgQ1BVICgwKSBhcyB0aGUNCj4gaXNvY2hyb24gc2VuZGVyIHRocmVhZCwgYnV0
ICpub3QqIHRoYXQgd2VsbCBvbiB0aGUgb3RoZXIgQ1BVLA0KPiBJIHRoaW5rIGEgc2ltcGxlIGV4
cGxhbmF0aW9uIChmb3Igbm93KSBtaWdodCBoYXZlIHRvIGRvIHdpdGggZHluYW1pYw0KPiBmcmVx
dWVuY3kgc2NhbGluZyBvZiB0aGUgQ1BVcyAoQ09ORklHX0NQVV9GUkVRKS4gSWYgdGhlIENQVSBp
cyBrZXB0DQo+IGJ1c3kNCj4gYnkgdGhlIHNlbmRlciB0aHJlYWQsIHRoZSBnb3Zlcm5vciB3aWxs
IGluY3JlYXNlIHRoZSBDUFUgZnJlcXVlbmN5DQo+IGFuZA0KPiB0aGUgdHN5bmMgaW50ZXJydXB0
IHdpbGwgYmUgcHJvY2Vzc2VkIHF1aWNrZXIsIGFuZCB0aGlzIHdpbGwgdW5jbG9nDQo+IHRoZQ0K
PiAic2luZ2xlIHNrYiBpbiBmbGlnaHQiIGxpbWl0YXRpb24gcXVpY2tlci4gSWYgdGhlIENQVSBp
cyBtb3N0bHkgaWRsZQ0KPiBhbmQNCj4gd29rZW4gdXAgb25seSBmcm9tIHRpbWUgdG8gdGltZSBi
eSBhIHRzeW5jIGludGVycnVwdCwgdGhlbiB0aGUNCj4gInNpbmdsZQ0KPiBza2IgaW4gZmxpZ2h0
IiBsaW1pdGF0aW9uIHdpbGwga2ljayBpbiBtb3JlIG9mdGVuLCBhbmQgdGhlIGlzb2Nocm9uDQo+
IHRocmVhZCB3aWxsIGhhdmUgaXRzIFRYIHRpbWVzdGFtcCByZXF1ZXN0cyBzaWxlbnRseSBkcm9w
cGVkIGluIHRoYXQNCj4gbWVhbnRpbWUgdW50aWwgdGhlIGlkbGUgQ1BVIHJhbXBzIHVwIHRvIGV4
ZWN1dGUgaXRzIHNjaGVkdWxlZCB3b3JrDQo+IGl0ZW0uDQoNCkknbSB1c2luZyB0aGUgcGVyZm9y
bWFuY2UgY3BmcmVxIGdvdmVybm9yIHNvIGFsbCBvZiBteSBjb3JlcyBydW5uaW5nIGF0DQpwZWFr
ICg0LDJHSHopIGZyZXF1ZW5jeS4gRG9lcyB0aGF0IG1hdHRlcj8gSSdsbCB0YWtlIGEgbG9vayBp
bnRvIHRoYXQNCmxhdGVyLCBhZnRlciBhIHF1aWNrIHRyeSBzb21lIG90aGVyIHNldHRpbmdzIG1p
Z2h0IGJlIGRlcGVuZGluZyBvbg0KQ1BVX0ZSRVEgYmVjYXVzZSBtZW51Y29uZmlnIGRvbnQgbGV0
IG1lIGRpc2FibGUgaXQgbm9yIC4vc2NyaXB0cy9jb25maWcNCihpdCB3YXMgZW5hYmxlIGFmdGVy
IEkgY29tcGlsZSB0aGUga2VybmVsKS4NCg0KPiANCj4gVG8gcHJvdmUgbXkgcG9pbnQgeW91IGNh
biB0cnkgdG8gY29tcGlsZSBhIGtlcm5lbCB3aXRoDQo+IENPTkZJR19DUFVfRlJFUT1uLg0KPiBN
YWtlcyBzZW5zZT8NCg0KVGhhbmtzLA0KRmVyZW5jDQoNCg==
