Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4095929D3
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 08:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241026AbiHOGtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 02:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiHOGtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 02:49:45 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796521B79C;
        Sun, 14 Aug 2022 23:49:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7sFsfb4Syuj0vCObd1wOvKdYuBuLPavax84J/DfkhWFp9Hn6DliFkrS6KfSpjrc8A4jSKFyhIJAoOgK9Pto3QKb6V873tw2LUNnu6NQaVsNckbkUNoETbsCRN3PN0XPflKLINugfhcvJN9RvshTSMH3ri0O6myYm7NDbygJrUk1xXBtdQ8BsD+1GnDlMWWYdMQCDskNS20jPRdJOZSUwzSzQKD+E2vlBsE9chUbo1qZy43lD1ktGiaLJjwPLaguTe8L4G8b6z9E6IfLDGXEC0v921RXU/3lIWQB3Ih6zgJq84jztn5NThC8Y9KbhYeaCntpCbsuXqQVlYqY3oc5Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3s04vWXyR0A3hnY89m0OPxZfrDfVJGnw+bPeMcvXn4g=;
 b=Q0uZwMTn+VaiEPvAj/mqRyGoLh85vQPlFedmTTdcsMmUKszwdboLWebLBdP5Ci/hl9VAP3DM4BxsyhrJbvc1rdD6vJfkcBk3JoUHiUk5OEtROqJrH1ZHdSV89n/vhfC3SA5ZNR2XYPEeQFYMdW2qcthRAevyryDk1ZXFyMZfPanc2hJdO+8hYbuQxGTS4qrXaJTeJyMWptsDW00PEt+ELPhykobNr9NpyEXXyvWKuEkAZi6Ltefv7UEcY4z3Ze2HHs4wRpWaLcKINkqizsQOiyfTrXLDWrSfKirb66FDMOy0PJgYFUUBIDw2vAQSqM1MT/gBzXVxFG8o7JZhgtilwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3s04vWXyR0A3hnY89m0OPxZfrDfVJGnw+bPeMcvXn4g=;
 b=pp7IYyKzZ9cUWh8NeG3Kx+3dmgLgPreG5aOOmpLn5ZZS67TtkJLqVti3rLHQShcFKWJUIoHpeFd/ES06jgMzIgZi0jTQgUEi0qDTZsIhXcOR/8Ru1p2xwv8UXyCKl0q32LQ+9+3boR7ZUxUMqaEQim6LrAcRvAJ+fJcmuzOS3Ys=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DB7PR04MB5129.eurprd04.prod.outlook.com (2603:10a6:10:1f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Mon, 15 Aug
 2022 06:49:40 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Mon, 15 Aug 2022
 06:49:39 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Thread-Topic: [PATCH net 1/2] dt: ar803x: Document disable-hibernation
 property
Thread-Index: AQHYrhiZCawC+L8jOkCFO9wn08ratK2rT8AAgAQh61A=
Date:   Mon, 15 Aug 2022 06:49:39 +0000
Message-ID: <DB9PR04MB8106F2BFD8150A1C76669F9C88689@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com> <YvZggGkdlAUuQ1NG@lunn.ch>
In-Reply-To: <YvZggGkdlAUuQ1NG@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a630061f-4459-4887-b55f-08da7e8a5395
x-ms-traffictypediagnostic: DB7PR04MB5129:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WGdnSK/8PJeGSlb6DS/adI8ega05NZWckRJdLY0L7Y0sf9g7CQvxmFe4+ajjsIL2DYWskzsIksPgrRN/OJd1S7DbKOv2VOMxpRh8HqVcrZAs8DUlPpG2Za5oxnIbxaVzXJsuNZEH83iQcSakjY01gsu+vvS60ppnWaBL4JJjRYa4TPdeNmbmmkjOdrzn2n29iWaE2QemRKrZiLm5FzyqcQHdHC40yemuWQNX4ayginm/LVy3dgWjgGi2zA4TUVTZwOcwgSToJIoIFmiweHWoWV1+Q6/D7eitBdchlNFaHJxoxq3zQlw/AQm/iDHRRJYOVJXtabQToeGUl0hfqA/RzuRyTAz51sPdmw7aYWVm3QfGlLyvMlCoPFu6m1TTIHcq5nxDhs+VlyPPuU0HV3Htghi7xJFO9U3BSqe6Zz+IbsRhNudqEeJ1ZLb9c/q1QHTS/Qy35HPCFfsf2wf+UMhtFD5/md93uTxa5QIKnRy3iApTzunAVTA77K/dA8z5sfCPdGAaQmYSmNIg7pG988dikQT4mi+RoSDbH45DynysRvAFMMwgS+aGDO+3Gpwvwm96are1+JIyMHvoNMjnh9kxpSJhwN/FA2dJqUTcW3UmC5338iIdsgP1f0nBmpBueTLPDJwg0yEk9y3E3IqjAeZrzPXf3D2ZiRyaotuUYNxwd1qbf6CsgLikl+IuE9du6p3B5iq1ohgvy5S7pHGSfbN9Z7ckjnweDgZ+ZR4GfZ88GNZfBhLNL+rfKQt/X/oo81SqjfC4alLYLbuYSMi47MXDMZ8aF8mSqhN4Tmmhpm3dgaw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(66556008)(4326008)(76116006)(66946007)(26005)(53546011)(316002)(83380400001)(64756008)(66476007)(66446008)(8676002)(9686003)(186003)(33656002)(44832011)(5660300002)(2906002)(7416002)(86362001)(52536014)(55016003)(8936002)(71200400001)(478600001)(41300700001)(6916009)(54906003)(6506007)(7696005)(38070700005)(122000001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bnJpMEF2ZktmbXFOSG85bHdsRm52bEZnSkJJdjhQZU5peEg0endWZlo3US9l?=
 =?gb2312?B?QUZRS1V6a3Bkdm85cnhjWUd4Mi9ETTZEQ09MUEJPZVAyMWVGaFZXZG5HNXZJ?=
 =?gb2312?B?QUNsWXcyQTZpVzRtaXBlL3JlSGc1Ny8rU1NrNjhxbDBJWWE2ejY4T2ljSldO?=
 =?gb2312?B?M3RuamtzT1huUm1lMXJqU0FXOTJDTk9pTmRZTmZ1eHNsbUlDVWNpVHVxTmdZ?=
 =?gb2312?B?ejNodWR2QjBtQ2NlYXhoSXR5eVRqRGJ0TlJHNFd2WjF4SzBtTVBja0krWUVn?=
 =?gb2312?B?M1EwcjYxSjBtZFhLUjVDMVU4WklrczRuMmlpdFVRMWR6VHJuNDg3NTVWK0lK?=
 =?gb2312?B?WVN1a1BMUXBSVTBwL1pGaTZKeVVKd0E0KzBaWWZveWMybG8vRXk0MFMwVVRZ?=
 =?gb2312?B?ZlFING5qYWFvNnZXd3JaRHdHeXVJMWpaRWpIa0RneE8vMC9BWG91ZWlWZFdX?=
 =?gb2312?B?N2d3QnlxQTBtclVUVGsxTUw3S3oxZFBwdG4va0xiekxNSllCR1pQMjE3bWls?=
 =?gb2312?B?VS9vcTBadFZ4VXRpR2hDOU8xRS81eU9IazhXdkhlcnpSM2toa2FaenpQZXRZ?=
 =?gb2312?B?TTdOend6LzhURjdXTXZHN0M1aGF6Vkpud0RVSVI3OVdPS2JMbmg4ZkpuTVVs?=
 =?gb2312?B?SFZ3bkxOZnpZalhUUGc1UHFCMlAydkZmaXZtYXZRMlhIdXl0YjNBZlh5aUxQ?=
 =?gb2312?B?Q0FzYkdFbFI3NlV1cm80bUJoNFNZdEdycWx4c2ZIeThPcWwvL0Y3R1l1cmRO?=
 =?gb2312?B?VmVFNmZOY2lEVzRld1I2MklBam9QeW53WXYrYUVnVGNJQ2tKdG96bWJHR2ly?=
 =?gb2312?B?eTJscXJEY3FwQ3R4WHloNWhpMUcvcTNnNWJzbnlEeXZpUlBjTjRKcHh4Yko4?=
 =?gb2312?B?dis3QnViQWh3TC9ZeS9XM1NxWENiaWZ0bEpzZktob0E2MktYUGdxRDFoSFEv?=
 =?gb2312?B?QlVRMmVVSCsxOTRqN3puTENzMDNlQlcrT0ZyK3ZNY2dxK0wyZU9WNWpjMVo1?=
 =?gb2312?B?YzV6SnIrdmxzZG1iWHBVcncvbWJjcHBWWUVEOWt0M2hxVlRYODBwMHhmS2ho?=
 =?gb2312?B?RVRzZ2ZWbldnL0dDQ2dsTWZMYWlWL2NRSS9QOFBhSkJtck9nMTJGdStCcDN4?=
 =?gb2312?B?SUtkV0xRdVhDS1pLWVZXR3VBYWt0WncxcFJJRlN1bUpoaUJBbzZjVEh0b2Z6?=
 =?gb2312?B?YUJqa3Z0US96SWhGZ2dpUVdVWGVENFNQMVlhNXdNd1FVOE5BS09hVVVSYnU4?=
 =?gb2312?B?TUNBNm50QUhXMHh0YUtHcGhWZ3BhczZhWmRqVjNsTEJBelpxMzVLbmFnNUkv?=
 =?gb2312?B?V0o0RUo4MmRBVTVLaGZiaFRiZU1Gc0tRYzl3clpUVjV6RmNhN0duc2dLU0g3?=
 =?gb2312?B?YjhIRUJrTmMzN1p2dlFLdmhpQlY2Z25UUW4vUEJwSkJWZ3RhQUwyeGpKbUNX?=
 =?gb2312?B?MDNYU1BUSkZBVjc4K2NuZ1V4djJmcWQ1UndtL1psOE4wL3l6UmgzRGgyV0ts?=
 =?gb2312?B?VmdjRlFzTjZheEF0YnI5L0JTdUk3allOTUV1Mmk5YmU3Z0JCV1JHOENSRS94?=
 =?gb2312?B?SWhXclRsL3FNbGJsZUlLQlk4dlRqUThNdm1iUWcrOFZreGFPTXpMRldSNlpX?=
 =?gb2312?B?ZUVGUDNpSDhOcTlnZitlNzVjZFZ5Tm1ndHRvWkNkOEprS1RhYytGdGdLRWZy?=
 =?gb2312?B?NFowU2lyNVBmSmtlYnNuZVUrOGFGRlYvUEp0ZytQaURTU1JVc0dNaEFadS9L?=
 =?gb2312?B?Y05VOEdIeERMK1ZSNGowcHNPcWFhWU1OWS9Yclk1VEJ4Sk85OFRCbVk0cXU4?=
 =?gb2312?B?MUlQajkzaWFsNXZpRW5SLzI0bXhSWjBwL1cyR1BSR2lTSVJIeHNycFRkSjdT?=
 =?gb2312?B?UmRrdTZ4YWtieGhTdll4S2xqUWl1blNMZkZVN2VHS2ZXMVVJU1QxODZFRldB?=
 =?gb2312?B?U0h3d1QvSUtZRExVRnE2Z0xYSlhWUG5HTE9SYlcrZlNKckR5U1BBS3VMdjln?=
 =?gb2312?B?OGRFUnBVZWg3RWFQa0RyUmJaU0hHTlFzK1B5S2YwY0F4NEhwanBzK3RUYzY5?=
 =?gb2312?B?dG10K1h1MEEvNC84RGlZZmc3N3dUdE9IZlU2bUJ4bTFiWUc1VVJOY0M1aHdL?=
 =?gb2312?Q?9FY8=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a630061f-4459-4887-b55f-08da7e8a5395
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2022 06:49:39.8940
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tKXaH5E21W1yuUFi+nyflNP+cb9/+EjINuoSg8Q+GutxvGHB4JDK68r6q4A/WxVsl9zCFdvX5IJP9mSQf/gl0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOo41MIxMsjVIDIyOjE1DQo+IFRvOiBXZWkgRmFu
ZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gQ2M6IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBh
cm1saW51eC5vcmcudWs7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdvb2dsZS5j
b207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+IHJvYmgrZHRAa2VybmVs
Lm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOyBmLmZhaW5lbGxpQGdtYWls
LmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRD
SCBuZXQgMS8yXSBkdDogYXI4MDN4OiBEb2N1bWVudCBkaXNhYmxlLWhpYmVybmF0aW9uIHByb3Bl
cnR5DQo+IA0KPiBPbiBTYXQsIEF1ZyAxMywgMjAyMiBhdCAxMjo1MDowOEFNICsxMDAwLCB3ZWku
ZmFuZ0BueHAuY29tIHdyb3RlOg0KPiA+IEZyb206IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29t
Pg0KPiA+DQo+ID4gVGhlIGhpYmVybmF0aW9uIG1vZGUgb2YgQXRoZXJvcyBBUjgwM3ggUEhZcyBp
cyBkZWZhdWx0IGVuYWJsZWQuDQo+ID4gV2hlbiB0aGUgY2FibGUgaXMgdW5wbHVnZ2VkLCB0aGUg
UEhZIHdpbGwgZW50ZXIgaGliZXJuYXRpb24gbW9kZSBhbmQNCj4gPiB0aGUgUEhZIGNsb2NrIGRv
ZXMgZG93bi4gRm9yIHNvbWUgTUFDcywgaXQgbmVlZHMgdGhlIGNsb2NrIHRvIHN1cHBvcnQNCj4g
PiBpdCdzIGxvZ2ljLiBGb3IgaW5zdGFuY2UsIHN0bW1hYyBuZWVkcyB0aGUgUEhZIGlucHV0cyBj
bG9jayBpcyBwcmVzZW50DQo+ID4gZm9yIHNvZnR3YXJlIHJlc2V0IGNvbXBsZXRpb24uIFRoZXJl
Zm9yZSwgSXQgaXMgcmVhc29uYWJsZSB0byBhZGQgYSBEVA0KPiA+IHByb3BlcnR5IHRvIGRpc2Fi
bGUgaGliZXJuYXRpb24gbW9kZS4NCj4gDQo+IEl0IGlzIG5vdCB0aGUgZmlyc3QgdGltZSB3ZSBo
YXZlIHNlZW4gdGhpcy4gV2hhdCB5b3Ugc2hvdWxkIHJlYWxseSBiZQ0KPiBjb25jZW50cmF0aW5n
IG9uIGlzIHRoZSBjbG9jayBvdXQuIFRoYXQgaXMgd2hhdCB0aGUgTUFDIHJlcXVpcmVzIGhlcmUu
DQo+IA0KPiBZb3UgYWxyZWFkeSBoYXZlIHRoZSBwcm9wZXJ0eSBxY2EsY2xrLW91dC1mcmVxdWVu
Y3kuIFlvdSBjb3VsZCBtYXliZSBwaWdneQ0KPiBiYWNrIG9mZiB0aGlzLiBJZiB0aGF0IHByb3Bl
cnR5IGlzIGJlaW5nIHVzZWQsIHlvdSBrbm93IHRoZSBjbG9jayBvdXRwdXQgaXMgdXNlZC4gU28N
Cj4geW91IHNob3VsZCBkbyB3aGF0IGlzIG5lZWRlZCB0byBrZWVwIGl0IHRpY2tpbmcuDQo+IA0K
PiBZb3UgYWxzbyBoYXZlIHFjYSxrZWVwLXBsbC1lbmFibGVkOg0KPiANCj4gICAgICAgSWYgc2V0
LCBrZWVwIHRoZSBQTEwgZW5hYmxlZCBldmVuIGlmIHRoZXJlIGlzIG5vIGxpbmsuIFVzZWZ1bCBp
ZiB5b3UNCj4gICAgICAgd2FudCB0byB1c2UgdGhlIGNsb2NrIG91dHB1dCB3aXRob3V0IGFuIGV0
aGVybmV0IGxpbmsuDQo+IA0KPiBUbyBtZSwgaXQgc2VlbXMgbGlrZSB5b3UgYWxyZWFkeSBoYXZl
IGVub3VnaCBwcm9wZXJ0aWVzLCB5b3UganVzdCBuZWVkIHRvIGltcGx5DQo+IHRoYXQgeW91IG5l
ZWQgdG8gZGlzYWJsZSBoaWJlcm5hdGlvbiBpbiBvcmRlciB0byBmdWxmaWwgdGhlc2UgcHJvcGVy
dGllcy4NCj4gDQo+IAlBbmRyZXcNCg0KSGkgQW5kcmV3LA0KDQoJWW91ciBzdWdnZXN0aW9uIGlz
IGluZGVlZCBhbiBlZmZlY3RpdmUgc29sdXRpb24sIGJ1dCBJIGNoZWNrZWQgYm90aCB0aGUgZGF0
YXNoZWV0DQphbmQgdGhlIGRyaXZlciBvZiBBUjgwM3ggUEhZcyBhbmQgZm91bmQgdGhhdCB0aGUg
cWNhLGNsay1vdXQtZnJlcXVlbmN5IGFuZCB0aGUNCnFjYSxrZWVwLXBsbC1lbmFibGVkIHByb3Bl
cnRpZXMgYXJlIGFzc29jaWF0ZWQgd2l0aCB0aGUgQ0xLXzI1TSBwaW4gb2YgQVI4MDN4IFBIWXMu
DQpCdXQgdGhlcmUgaXMgYSBjYXNlIHRoYXQgQ0xLXzI1TSBwaW4gaXMgbm90IHVzZWQgb24gc29t
ZSBwbGF0Zm9ybXMuDQpUYWtpbmcgb3VyIGkuTVg4RFhMIHBsYXRmb3JtIGFzIGFuIGV4YW1wbGUs
IHRoZSBzdG1tYWMgYW5kIEFSODAzMSBQSFkgYXJlIGFwcGxpZWQNCm9uIHRoaXMgcGxhdGZvcm0s
IGJ1dCB0aGUgQ0xLXzI1TSBwaW4gb2YgQVI4MDMxIGlzIG5vdCB1c2VkLiBTbyB3aGVuIEkgdXNl
ZCB0aGUgbWV0aG9kDQp5b3UgbWVudGlvbmVkIGFib3ZlLCBpdCBkaWQgbm90IHdvcmsgYXMgZXhw
ZWN0ZWQuIEluIHRoaXMgY2FzZSwgd2UgY2FuIG9ubHkgZGlzYWJsZSB0aGUNCmhpYmVybmF0aW9u
IG1vZGUgb2YgQVI4MDN4IFBIWXMgYW5kIGtlZXAgdGhlIFJYX0NMSyBhbHdheXMgb3V0cHV0dGlu
ZyBhIHZhbGlkIGNsb2NrDQpzbyB0aGF0IHRoZSBzdG1tYWMgY2FuIGNvbXBsZXRlIHRoZSBzb2Z0
d2FyZSByZXNldCBvcGVyYXRpb24uDQoNCg==
