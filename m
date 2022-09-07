Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0718D5AF976
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 03:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiIGBuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 21:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiIGBuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 21:50:01 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60043.outbound.protection.outlook.com [40.107.6.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A27C20F6F;
        Tue,  6 Sep 2022 18:49:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9jT4l3QDqoWVtS2o5tdLLtXJ/KJb0eZ3ONkZuYVmfZj6fp5g+7iXbhpar60wLfkpdAZp24lfWHqfBRL9Z2q95q+O9vTKJekDOYJSiU+YyzT1C4UwIp5DlDDc1l3+cgq49sY7b/c3ehgpzrQBsIXtSVgPWpNZrlBo/agR11M74InOhspdLL6PcDa+a/h1y0mEYTE+tfaZC8Rm1YozBnYiC1M+Qqgyl5owbILi6trawwrpRQ0QxNUMUbEv/Z5qB6oxsfCpS558RvRj0jGKDNeczj0OHkjqVztOChnAex6KdTWQdDjKfWheMgY3ivG62eEGNhgFBgtkjOHGOsN6+Cvkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXg2t6Mcwn3Yvlb5mmqLZKu74neH1pGnZazG5oG1kBE=;
 b=Fg0hF2xCeo5N3AGCTH/TXp6/GvP7M5tcM4F+BxgRzPca5LHQhmCmoWrs/UxoFjTtaDFvYoudZyxkL4+oQoyoMsYMrZv5uN6Vc/JZ/cn2oyAYRow85Ri9LSV12a+TJyyIiDCjMA39uf3aC5IIFTNHRBZlyC0IxqMMRKx5Wg91hfjeUquH6dYaasCBwFeRlwRg6L1yQo/okfIMGn2KBiy12rIHXeUB+tCHdRcfyOza2moQPElY/KMQzAMPszurROBz68jFkWQtOUSeIjOl+GookLjkKcm9NIuaE5yhT3Hg6l/ORP4djY6m8xw1KBpK/5ptj1nYQSN80RXVpqjwmr0lXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXg2t6Mcwn3Yvlb5mmqLZKu74neH1pGnZazG5oG1kBE=;
 b=dySF0UQMUsVs742+MtRXIvmTizwrD+V0PM6ljEt0SJVUqkG2be3CYA4HYQ8VRAiqufq7i3u1SH+lKs9daHqIQRu0GMebkUFGtPtePCPw/MFwlim5Af0YxYpFlIvSe7H7zyq5fnrWnpHy4iKJb6ryPDnzWenTDA9LMj6TALtUW6Y=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DU0PR04MB9659.eurprd04.prod.outlook.com (2603:10a6:10:320::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.15; Wed, 7 Sep
 2022 01:49:55 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::4ba:5b1c:4830:113d%6]) with mapi id 15.20.5612.012; Wed, 7 Sep 2022
 01:49:54 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: fec: add pm runtime force suspend and
 resume support
Thread-Topic: [PATCH net-next] net: fec: add pm runtime force suspend and
 resume support
Thread-Index: AQHYwcw4RpEZ4U2eKUeLLxgjRCDiYa3SehAAgACxOiA=
Date:   Wed, 7 Sep 2022 01:49:54 +0000
Message-ID: <DB9PR04MB8106FD035EEF92E7556D2BF888419@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220906083923.3074354-1-wei.fang@nxp.com>
 <YxdcPJNgM+txE+8A@lunn.ch>
In-Reply-To: <YxdcPJNgM+txE+8A@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DU0PR04MB9659:EE_
x-ms-office365-filtering-correlation-id: 4933e6ad-15e0-4d1b-c765-08da90734332
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jv9ZsinEyHWt5kPGcJwEPX0sYrMZNWwN3XvjpmZqKzUlhIdkFBXeXE1W2TUzc7bR5zMo3w6pzamrEYaNSJgy6rbbTW8cf65w8tVKT0XYHW6Zk1uu2DwUJP2Rd52L9LUMLheUfEZT8UXgGr7e0wsqOEUXCaxbx9IFuFjrwwiDlrIIX5kkQwpAXTLKJvLKn/+YXajqxqagO9tMWJluGH8E6Sm2RFxbWgf1alkrloEk/SQSgQdWqCRX62w2rYq3ng6jBmzDIxlT5LfvYphs4PzLoHnS1tS17dTmjwy8eRUZ8Tgyqi2XJK8xp5N8MTpmy04z+6YaJpZEeNR6swfoogj9vPMM55DR8eKOSMITzbaNzHNdqv4nlhFrbrmm6cljLkiSo0ey0ic25Igu1i2aoC1JaJsI5VkwRIsyCSxYspgas1SCuWAX0/XwxwURSsgJfHZRaqlXw28jzcWHfR6u7ZFOzsQGRe72z463DH4IZQnELD1JsfmWmZT8CxQWBhQ7DYBcBY4yQ1R9aWY7fVpT5UptNuYIUM1jak/fIS541bU2dBoDKz+zuiaX/esFabLE9fNOmML6LW6r8GhQ8PTPZmeieyEJperE7G+8EqZIQKZZ1tkLiXFzRy+jljHH4vZ6ODwoXXUTznarp3EbfN8ZuDLaprzMN1XRBJN1G0a6IH9i7t+ohCJI4poamArKg+KGnjW9qm+RYlShZEvzeJdDrokjSU2j3jp522A62PJifD1FWD48KcnzmLjkaVHCih5cBPI7fsDEm0jdjISGbQ1dzLyeGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(366004)(39860400002)(396003)(9686003)(26005)(186003)(5660300002)(52536014)(8936002)(71200400001)(7696005)(86362001)(44832011)(33656002)(2906002)(478600001)(53546011)(41300700001)(6506007)(38100700002)(38070700005)(66946007)(6916009)(55016003)(15650500001)(64756008)(66446008)(66476007)(66556008)(54906003)(76116006)(4326008)(316002)(83380400001)(122000001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?SDU1RUVNd2FNZml4V1ZaQUYzZUgwSCtpOTNZcGNlMEZhWUttM2QyL2xYTzRs?=
 =?gb2312?B?a1I0VUdUZWpvc2RSVnJGQS93SzdHM0ozOU00YVBHdWZrcUh0RXptMVV5NWQx?=
 =?gb2312?B?L25lUlU5WjR0ZkZuM25hcmV0b2ZFTEYxYTZ1eGltQy9mWkwxb3JuNTNmQjUy?=
 =?gb2312?B?MkhDbWFacUJxM25HYmRrSmtRWWRaSGo3MWlsNWlFMXFQSDNLODBISXZ0dlc5?=
 =?gb2312?B?VmpJdlUzNWpGTGtJZ3RpKzNjZzIzVEl1RUwxTS9vcjVyQ1BwMmw2QUJqellY?=
 =?gb2312?B?a1NRRThFYzBpcmNMWWJ6NXE2LzZ3ZlErMVRYaUhWbGk1dGdhc01JdjFDbzI3?=
 =?gb2312?B?WFFNdyt1bUMvb20za0V6RjZMdTZIZ1FuYXFYOTBiYkRFMkhTcVZMZkZXZmN5?=
 =?gb2312?B?VmVCWDBiRlpyTTBTUmJoS25BdmU5SkFUWStzeGdrTEdEd29NSEg5NDlLYmJZ?=
 =?gb2312?B?VWw3bzk4bHkzSFRpbllaekE5NUc4QUh5a0s5N1RmMW9BaTE4VW1Rb2JlMkRX?=
 =?gb2312?B?V3E0M2ZuL0RyNW1nQUZ0aDdJQjlNbFdZVkpvYnBFVmxNaXd3aEY5VXg1dGV2?=
 =?gb2312?B?amhHMTdOY0VmMFAwK3oxYjdXNTkrdHV3RUpIVktwb3h0aDQxdUc2VkZHU3FI?=
 =?gb2312?B?NjZDVGxkamhHTGhEVVdSMWo5UzZTZkNOTnFZdFRRdm1LMEU2QzdRMG80TFhq?=
 =?gb2312?B?MThFdzFHR0lKQ0dGejRoT2N6Z01SdDlkOS9WaDl0S0pEN1h0RHluNDNXelFJ?=
 =?gb2312?B?OXpGdTFBOTFXakhaZFVvUUJuTmhVSkFHQ3kzdWVoVDZ3cXFuVndiRG9EeGNk?=
 =?gb2312?B?OTUzZk1aeHVwanA1UkJMNDZ5anZUb0dZRElHMnJpMEE5TzN0ckN4ajU1eHBk?=
 =?gb2312?B?VExhcWFNM2I1T3Y2eVZudS9QU2N3NVZPK2cxZDd0S3RFTzcweTFURjcwOFRp?=
 =?gb2312?B?RUFoc2xpWHZsUHpxTHF1cmdIeTlVazhVLzMzbjY3emhYOXZOSnFTemF6Tjda?=
 =?gb2312?B?ZXFRK2FuMG9Uajlzb0xYOGtFblBkdUEyQTNIUWRYMTh5Sk9vMWl4b0JSdGVK?=
 =?gb2312?B?YnQ1d2E3MGk2NGQ4OGFxaDBBTVF1S2tQRDJIVHRlT1ZIR3J0Z1AyanZ1MURq?=
 =?gb2312?B?OHpnUFVuTm5ZalRBNXQyb1VjdGQyZkg5a2I1OCtZd0VmWTBDRVZoU24yc3Z1?=
 =?gb2312?B?T3I5dXBYZ3VaNCt6NEhCbitaeW83Q1BPQy9sdXlDT3o2c1FuTm92T0JBd1hh?=
 =?gb2312?B?ZnkyY2c3ZGpQOVIzQ0NCVU9yRU45SGdGYWNNSDhXSUN4NWNCOHp4ajRubE5Q?=
 =?gb2312?B?U2EwSjVZdmttSk5TWHNya2NRYlZwYzJsZForVTJ5emtRUXpVUld6cjJPSTNs?=
 =?gb2312?B?WjFhTERSWjZRVjdtT1ZNVlpoYjFzTTloMXB1ZVE4TFpXMnlpWllJUGowWHBN?=
 =?gb2312?B?V0JtdktHeFdDU0lLallGNjFwdjE2OFpCQ1c0dWdWZDF6aWdFV2IxTGM1Nnor?=
 =?gb2312?B?U3JaRy9kcVRJOHdGdXEzZHZiblc1dm9FdTF2YXJDVVpEWkl3blUvWk5pSXJL?=
 =?gb2312?B?ZURiS3Z4dlpFQUFUd2FlWEFKRXVJQUtIbjl5Q1Jkblcwa1VYdmxwb01yeWZI?=
 =?gb2312?B?MUFHQSs1cFhVVWZBNExKMTVYOHhLM0s3Z0J6cnFuQ1ZqZW9sZXlXNlhTSkxW?=
 =?gb2312?B?THY1bk1yZGpPWDZYNHVBVlZlVVAzNVJQRUwwSnUzVktGMHRzWnpXZGdiWllE?=
 =?gb2312?B?MTFxNXdBdFNQNlgrelRJbVM5TzBWNjVXN1dVSFFKS25CQWpkNndvYTdWZXEr?=
 =?gb2312?B?YXpvTkxVeUVrQ1Y2WVNtK0YxZWFzMDlGTEJQQ29BUXpadUg5eUpNWXpSanI1?=
 =?gb2312?B?R2c1aUtkYTk1d3ZSbjg3Nmk5VGtGQjViN25URFVIcGdCci9YUGZkTXJTMlZ3?=
 =?gb2312?B?djV4dGFLelBObkVXa2JJeWZheENZbm9hWHFpaG0xTU5mL1llTEQ2OVR1SDU0?=
 =?gb2312?B?amwyaE5DbHlIaVVrY3pGeG5GazNtcjhOVVZxWit6RFpQakJDNnhyNzB5bkh5?=
 =?gb2312?B?Vm91ck1HRkFxRjJxcGx4Z01qelpraW41bUh2VGx2N0Z0RkdXUmo4ZWVuWWFJ?=
 =?gb2312?Q?f0Cc=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4933e6ad-15e0-4d1b-c765-08da90734332
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2022 01:49:54.8761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5E+C4dUNgN8jN6CCOlAMSNIRysv13FSddHkO3J+LmVy2pV5b4AptguRfiwQ1QkX0sMdgDgIaBplXrw7UWQ8KWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9659
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
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOo51MI2yNUgMjI6NDINCj4gVG86IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRA
Z29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0
OiBSZTogW1BBVENIIG5ldC1uZXh0XSBuZXQ6IGZlYzogYWRkIHBtIHJ1bnRpbWUgZm9yY2Ugc3Vz
cGVuZCBhbmQNCj4gcmVzdW1lIHN1cHBvcnQNCj4gDQo+IE9uIFR1ZSwgU2VwIDA2LCAyMDIyIGF0
IDA0OjM5OjIzUE0gKzA4MDAsIHdlaS5mYW5nQG54cC5jb20gd3JvdGU6DQo+ID4gRnJvbTogV2Vp
IEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+ID4NCj4gPiBGb3JjZSBtaWkgYnVzIGludG8gcnVu
dGltZSBwbSBzdXNwZW5kIHN0YXRlIGR1cmluZyBkZXZpY2Ugc3VzcGVuZHMsDQo+ID4gc2luY2Ug
cGh5ZGV2IHN0YXRlIGlzIGFscmVhZHkgUEhZX0hBTFRFRCwgYW5kIHRoZXJlIGlzIG5vIG5lZWQg
dG8NCj4gPiBhY2Nlc3MgbWlpIGJ1cyBkdXJpbmcgZGV2aWNlIHN1c3BlbmQgc3RhdGUuIFRoZW4g
Zm9yY2UgbWlpIGJ1cyBpbnRvDQo+ID4gcnVudGltZSBwbSByZXN1bWUgc3RhdGUgd2hlbiBkZXZp
Y2UgcmVzdW1lcy4NCj4gDQo+IEhhdmUgeW91IHRlc3RlZCB0aGlzIHdpdGggYW4gRXRoZXJuZXQg
c3dpdGNoIGhhbmdpbmcgb2ZmIHRoZSBNRElPIGJ1cz8NCj4gSXQgaGFzIGEgbGlmZSBjeWNsZSBv
ZiBpdHMgb3duLCBhbmQgaSdtIG5vdCBzdXJlIGl0IGlzIGd1YXJhbnRlZWQgdGhhdCB0aGUgc3dp
dGNoIGlzDQo+IHN1c3BlbmRlZCBiZWZvcmUgdGhlIEZFQy4gVGhhdCBpcyB3aHkgdGhlIE1ESU8g
cmVhZC93cml0ZSBmdW5jdGlvbnMgaGF2ZQ0KPiB0aGVyZSBvd24gcnVudGltZSBQTSBjYWxscywg
dGhleSBjYW4gYmUgdXNlZCB3aGVuIHRoZSBpbnRlcmZhY2UgaXRzZWxmIGlzDQo+IGRvd24uDQo+
IA0KU29ycnksIHdlIGRvbid0IGhhdmUgdGhlIHByb2R1Y3QgdGhhdCBhbiBFdGhlcm5ldCBzd2l0
Y2ggaGFuZ2luZyBvZmYgdGhlIE1JRE8NCmJ1cyBvZiBGRUMuIEJ1dCBJIGhhdmUgdGVzdGVkIHN5
c3RlbSBzdXNwZW5kL3Jlc3VtZSBvbiBpLk1YNlVMIHBsYXRmb3JtIHdoaWNoDQpoYXMgdHdvIEZF
QyBNQUMgYW5kIHNoYXJlIG9uZSBNRElPIGJ1cy4gSSBoYXZlIGNvbmZpcm1lZCB0aGF0IHRoZSB0
d28gUEhZcw0KYXJlIHN1c3BlbmRlZCBiZWZvcmUgdGhlIEZFQy4gU28gaXQncyBzYWZlIHRvIGZv
cmNlIHRoZSBNRElPIGJ1cyBpbnRvIHJ1bnRpbWUNCnN1c3BlbmQgc3RhdGUuIEluIGFkZGl0aW9u
LCB0aGlzIHBhdGNoIGhhcyBiZWVuIGFscmVhZHkgc3VibWl0dGVkIHRvIG91ciBsb2NhbA0KcmVw
b3NpdG9yeSBmb3IgMyB5ZWFycyBhbmQgb3VyIHRlc3QgdGVhbSBoYXMgdGVzdCBpdCBmb3Igc2V2
ZXJhbCB0aW1lcy4NCg==
