Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B6269A3CF
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 03:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjBQCSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 21:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBQCSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 21:18:15 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2063.outbound.protection.outlook.com [40.107.247.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA0936087;
        Thu, 16 Feb 2023 18:18:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qc2pHjHHm+q+8gSb7eYk/m/ez7Cp3kDK9BD1V53LcO1gFYA+oFiRWwidojv0fuBWbgYhev2QPF8sBP/1T9awiAiVm/+hp35NpuEOkJh77ycrU7oqIUcwc9TgKi8SImP28R6b53M+LsMwLme/SzWkjqdjWj56tT9R9pbmHqW5nuRtDBpAUHSuOHfQpyqU2ZPxi5wa8gjysGi8e65c8fZPi6qEbHUlY1ZP1f01HFIy79gEahlOvlYJBRzdHxrrXB9F8k9Fu0NFAOefTAG/xsWZ+/NDxlgtkcQZCb3PGU2vL4pwoyJjlxX4jWf3Nwyz3smX9L2KI0V5DzeecSSTsYsqSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vQ0CL5Al/NAtO/4BwpNUa3iCWpBw4w2ua/sTj1DF04=;
 b=FueDBx6PG1KR4ol3BBFtpzUFcYV1Qy9CwQZ2GxUnaTnOVGsPvDV5u2dW9gVYJHADJyICgf02EMBW2PyDpL1WlMx/QpM0lEqz7m07WFef7s8TrQn/1SwjRxmGY6CWKRLbzCTr/893RgPgaTxuCJMJO0G6mpCUdF/nPsFXm0GDmBIOG63P+DXexxglc4DKJV6pG182lYiDLIb22yBxEYmw78/7Es2t/B84qZ6WzDJwp6o5gY5f5dqkL82Igyh8kIYy240J1UTQVkKAI5LCrIZYIqzkgKbwktIQzMKMikmT59WSR3s/v3ieSINSvZ3jxZWpeaPc9CwPixZqhIvgMr/zNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4vQ0CL5Al/NAtO/4BwpNUa3iCWpBw4w2ua/sTj1DF04=;
 b=Es9x4371j5J/LdZSY72A9xdJP6Bdxe/WRL73JzqxkC70kI6EBwSl4E1h/UohZdRPxLrE17apdOVMJkGz4dGrQbYn/T6YG0no0ZZC6FYjTLd8a23Hdi5fxfWPH7Smbh7rlLqGFmdJH+OLiKI6sAG8Zgj/+7ml3HKqx3dYEqYS9ZI=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PR3PR04MB7450.eurprd04.prod.outlook.com (2603:10a6:102:8a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 02:18:10 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6111.015; Fri, 17 Feb 2023
 02:18:10 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Topic: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Index: AQHZP44WIaasQ+1ZZ0O2FaaW5aXAcK7NCrmAgAEMUYCAAJJigIAC3+1ggAAuDgCAALMOUA==
Date:   Fri, 17 Feb 2023 02:18:10 +0000
Message-ID: <DB9PR04MB81062C8AA6FDBEA110094A2F88A19@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <ed27795a-f81f-a913-8275-b6f516b4f384@intel.com>
 <DB9PR04MB81064277AB7231F5775920D788A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <fb2a599f-4a7e-1755-fbcd-56e57abe80be@intel.com>
 <DB9PR04MB8106414C19433AB6B13369BF88A09@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <c7bcedf5-9768-780f-4438-9250faf711a0@intel.com>
In-Reply-To: <c7bcedf5-9768-780f-4438-9250faf711a0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|PR3PR04MB7450:EE_
x-ms-office365-filtering-correlation-id: 8fd8aa71-3cea-4c7b-574b-08db108d370c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TrDe7QINc56pFh0ThJk4vyVzLQubtymfKBXCABwtsQ7fCpUUgy4Fg4LPA98eGuAdsJ49rKN5uh3uM7drY6431agnsv0OsxUAbzHeGRHzgoYlrESpKHyn9IjnmWwA1gT3L8oDXxUm0otCWXudfpjWxnph9YLoAzoLbNxJVxSVg9C/CxIPrG4BTko71xLF8xJ6CMNyhPeU358ehkHC/dxG3DqdxuhVhfyhZzJcJm9V/XuFKSIA60UEZPgoBiaeCJf5QawLGlQq6jsL7cUu977oXw7MUQmjV6+CSiWTYLZRC4TFZL5ybYqcHDyEUT/zf88kxoB2R9oSfbuNVE6SM5YMYKnkzKG35XAGGiXUaLt/2Vc/l9Y6RnCW/8gWrNqhtScb73q5JlRqQzo4XPEDXypN2z8YnmeToTyN3ZKio02ivT4aHJbAOypxz3+V5GQkts4xwXPSIzqUSCXyT1nqy5P3n5JgB15EzEs13s2+/xiFZybQa6ChISvVELH7Z7lVYE0rYJKOfaJla+sqZvyk2grfQroSXDZfTP9Q0cjA5b9bZt7YNs72vax0JYSpbYkAOLBiFC8u6wDNKGBMrG+d3IxYrfmpdfv/+MRxRczAgV7f5OdhZoHOH9mWfKi7Hl8DFF2K7mFxz41qhCebe8s7t+edxq2DzFAOJSy3Q5XJH/3AylQkXJRbV8u71d+Zq7TVbAYTVFXqjnXA4J9xUVn8UG2WgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199018)(53546011)(478600001)(71200400001)(7696005)(6506007)(9686003)(26005)(186003)(2906002)(83380400001)(66946007)(66476007)(122000001)(54906003)(316002)(76116006)(66556008)(66446008)(38100700002)(64756008)(55016003)(8676002)(86362001)(38070700005)(41300700001)(44832011)(52536014)(8936002)(4326008)(6916009)(33656002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzllRzRMdzlJQlU2VENuS0QyME5DZ3R2R0dDdk9abDB3NjJsY3R0RVczeklQ?=
 =?utf-8?B?bWN0a0JBT2hnWEl4ajlBZXFnaUEvMlBoVHFtL3pHTEd1Q2tNeFFNZkRMc1U5?=
 =?utf-8?B?OWFtV3VhS2FTUm54TmNtOFVYcllXOWl0dXVrdGNZQkNIeURMaGEzM2VBVC83?=
 =?utf-8?B?ZzUxYk4xSGFKTldoRDRHVVpHSFNaUUkrRFVQRWxyVDhvU2N1Y0JVK2xjbFZk?=
 =?utf-8?B?UkdwRkJMdTVSN0RLeUdmVmEraTRrTEJ0Y0dORDkxaFVFdUd5RHp6Tm1xZ0g2?=
 =?utf-8?B?a1F2eVhOY3RqeVZzdGtVZm14a3VIUlRLZUpYY05ZZFY5bml3aS8xZ1N4cVE2?=
 =?utf-8?B?MHhHVDNGbG5GaGdjSjUvUW9ZdGtIQXBMa2JTV3lJUzMwMVk0QzFiRXllc05H?=
 =?utf-8?B?eW1VUVZ6TDFCSnh0Z0R6OEY0R05hWkdqZEFkaGRra1ZOQUJJUzdtdWVwY1cy?=
 =?utf-8?B?eWkwNzg0dkFXZ1RCekhNNEplQVJmZlBuQndwVys5VlQrM1RMY09ZZzkrdUpF?=
 =?utf-8?B?Yk9OdlhQcmxWYUR4b1J3VGpRdXNPWkxHQk0wZm11eDZucFR1bURkMjZQNTRM?=
 =?utf-8?B?cmsrV2gwRng3Smg5TSt6MWJKcUZVbVV4MzlhaU9pdWl5V0owZTIwbkk2R1BH?=
 =?utf-8?B?R3YvTk5xay93Wmd1QWx2bFdZVllhTGQ4RzEwME90WWdKQVNsdnQyK0JyaUZX?=
 =?utf-8?B?R3BzWWV3dGZwUVo5QWJxVzg2R0ZjQURCcnlrWmswUDZ2ekdadllIY20yTHZa?=
 =?utf-8?B?c2tyNkkvMDlxRG1mM05RS1JZWElIN016UmhnZFdlRTZzd0FDYzI2b2lYTm5Z?=
 =?utf-8?B?OXVLc0NGL3Y5UllJTUpzZlppRHRJRC94STdadzdjeHZwNDlra0dkUTVjYkVK?=
 =?utf-8?B?a3dISmhxc2F2YWpIR3U4NUIwVGt4OU9IK2xEalJxK1VTMkczak1OWDYrVi9W?=
 =?utf-8?B?Qmt2TjFRSzN5NVBPaytoMEZ1TGV3OHdPMS9QWHc1WmRwL3dnbEsxbnVCWTVU?=
 =?utf-8?B?Y1hhSksyeWxCRHVvZ1J3RXJQbEpwbGRUOGN4VG5uS0MzV3RIaFl4cnRMNGps?=
 =?utf-8?B?NEZDN0o1S0pBUys1OGEwTDZjUXI0bmFlZ0VMcFBNcFhUR2hNREZPZk9oaTZs?=
 =?utf-8?B?SUNyaXY4R2ZpSlR5Qm5rVkVaY250Nmx2YzNGT0w1eU04U2Qxbzc2SmhRYTZz?=
 =?utf-8?B?cUlOakFxQmJBSDAwQXFuVUNHVEI1a3BISnh5Z2R6dWV0dWptWkZKUkoyd0VQ?=
 =?utf-8?B?QnFNeGIycXdPMVYrZVVTcTE1dG16RlZ4cVhIT3ZwMU02RjRraEtSbk5PZ2kx?=
 =?utf-8?B?a1NsNTh5b3JxT2U4VUNBb2kxcFFLeUtyM0g2MEZYNm5NRnN0cEFtR1g4bFJu?=
 =?utf-8?B?UUd6MGRVaUpLZVVIekx3WS9ia3pUZzVXNGpGbllDUGxZWWRVWUVYdVB2bUc3?=
 =?utf-8?B?b1ljY1puVC80Z1JMMWpQS3dyVlllZDBuU3BEZ3pia2FHU3RJY1NJWkFMTE45?=
 =?utf-8?B?dlJWS1VNSjh5Vk96VlA5Uk1yNWF1QWs1NGl3NDN3b2dKR1BkMzFjeVN0QjFO?=
 =?utf-8?B?ckZWczdiSmUxb2p0S2NNdVpVOFdJK0gxc2R0ZjdPNEJaVjVWQVg1MzdXT3JM?=
 =?utf-8?B?MHNhRUtTWEQvWXdscnIyQWIvckZPSy9PTHU3Nm5FN2pjSzhQcU5UNUVKZk1q?=
 =?utf-8?B?SmpNQ1VjWm4rcEpremJpQk1WODRhcG1zYzI5QkQzeXVLS0d3YndMTHA4Mk13?=
 =?utf-8?B?SFBMQUhMa052a1RzZGU1RWRjNEMzUFFVaUVpYS9aZThJTlNhSGp3U0o0YXM1?=
 =?utf-8?B?YVJUUG9SK3BTMGpXdjFmcUw3VXlUWlFRTmV0dGp4NXZoQk0xWGlkSnNzNWdi?=
 =?utf-8?B?eUIvOCtycGhybkttdmlzU2FDSkttQW54WEk4NW1XTDBnUTdTM2x6MFhFcE5T?=
 =?utf-8?B?aTQzWFMyWGhGU3hQWGU3S1lZWk1UWW40NzdKNHdibXN4eHZZbWVlN1c3b0Mv?=
 =?utf-8?B?VFhNYVlSS2g2YU04VDhRbzhIWjNjd3NDR2l0M1F3WGZTSWtHK1pMZ0xDdjJa?=
 =?utf-8?B?QUNrZU9rS0RYcnZMTyt0a21KVzY1Qk5VdExBeHY2cFdQMjBJOHZ3S08xQzY1?=
 =?utf-8?Q?Q1qE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd8aa71-3cea-4c7b-574b-08db108d370c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 02:18:10.2889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sYkmzGznbYeZpIAntUaqfC/od4FQoAtTabZLNz5uTG/ZKPGEdqgGZo5pxl+OPtGdmOLTE7Y8oC2Cq0bXfajxNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7450
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQWxleGFuZGVyIExvYmFr
aW4gPGFsZWtzYW5kZXIubG9iYWtpbkBpbnRlbC5jb20+DQo+IFNlbnQ6IDIwMjPlubQy5pyIMTbm
l6UgMjM6MjgNCj4gVG86IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogU2hlbndl
aSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNvbT47IENsYXJrIFdhbmcNCj4gPHhpYW9uaW5nLndh
bmdAbnhwLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207DQo+
IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207IHNpbW9uLmhvcm1hbkBjb3JpZ2lu
ZS5jb207DQo+IGFuZHJld0BsdW5uLmNoOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkbC1saW51
eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIG5ldC1uZXh0XSBuZXQ6IGZlYzogYWRkIENCUyBv
ZmZsb2FkIHN1cHBvcnQNCj4gDQo+IEZyb206IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0K
PiBEYXRlOiBUaHUsIDE2IEZlYiAyMDIzIDEzOjAzOjM3ICswMDAwDQo+IA0KPiA+DQo+ID4+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IEFsZXhhbmRlciBMb2Jha2luIDxh
bGV4YW5kci5sb2Jha2luQGludGVsLmNvbT4NCj4gPj4gU2VudDogMjAyM+W5tDLmnIgxNeaXpSAw
OjQ5DQo+ID4+IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPj4gQ2M6IFNoZW53
ZWkgV2FuZyA8c2hlbndlaS53YW5nQG54cC5jb20+OyBDbGFyayBXYW5nDQo+ID4+IDx4aWFvbmlu
Zy53YW5nQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBlZHVtYXpldEBnb29nbGUu
Y29tOw0KPiA+PiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOyBzaW1vbi5ob3Jt
YW5AY29yaWdpbmUuY29tOw0KPiA+PiBhbmRyZXdAbHVubi5jaDsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgZGwtbGludXgtaW14DQo+ID4+IDxsaW51eC1pbXhAbnhwLmNvbT47IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiBuZXQtbmV4dF0g
bmV0OiBmZWM6IGFkZCBDQlMgb2ZmbG9hZCBzdXBwb3J0DQo+ID4+DQo+ID4+IEZyb206IFdlaSBG
YW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+PiBEYXRlOiBUdWUsIDE0IEZlYiAyMDIzIDA5OjM0
OjA5ICswMDAwDQo+IA0KPiBbLi4uXQ0KPiA+Pj4+IE9oIG9rYXkuIFRoZW4gcm91bmRkb3duX3Bv
d19vZl90d28oKSBpcyB3aGF0IHlvdSdyZSBsb29raW5nIGZvci4NCj4gPj4+Pg0KPiA+Pj4+IAlw
b3dlciA9IHJvdW5kZG93bl9wb3dfb2ZfdHdvKGlkbGVfc2xvcGUpOw0KPiA+Pj4+DQo+ID4+Pj4g
T3IgZXZlbiBqdXN0IHVzZSBvbmUgdmFyaWFibGUsIEBpZGxlX3Nsb3BlLg0KPiA+Pj4+DQo+ID4+
PiBUaGFua3MgZm9yIHRoZSByZW1pbmRlciwgSSB0aGluayBJIHNob3VsZCB1c2Ugcm91bmR1cF9w
b3dfb2ZfdHdvKCkuDQo+ID4+DQo+ID4+IEJ1dCB5b3VyIGNvZGUgZG9lcyB3aGF0IHJvdW5kZG93
bl9wb3dfb2ZfdHdvKCkgZG9lcywgbm90IHJvdW5kdXAuDQo+ID4+IEltYWdpbmUgdGhhdCB5b3Ug
aGF2ZSAwYjExMTEsIHRoZW4geW91ciBjb2RlIHdpbGwgdHVybiBpdCBpbnRvDQo+ID4+IDBiMTAw
MCwgbm90IDBiMTAwMDAuIE9yIGFtIEkgbWlzc2luZyBzb21ldGhpbmc/DQo+ID4+DQo+ID4gMGIx
MTExIGlzIG5lYXJlc3QgdG8gMGIxMDAwMCwgc28gaXQgc2hvdWxkIGJlIHR1cm5lZCBpbnRvIDB4
MTAwMDAuDQo+IA0KPiBmbHMoKSArIEJJVCgpIHdvbid0IGdpdmUgeW91IHRoZSAqbmVhcmVzdCog
cG93LTIsIGhhdmUgeW91IGNoZWNrZWQgd2hhdCB5b3VyDQo+IGNvZGUgZG9lcyByZXR1cm4/IENo
ZWNrIHdpdGggMHhmZiBhbmQgdGhlbiAweDEwMSBhbmQgeW91J2xsIGJlIHN1cnByaXNlZCwgaXQN
Cj4gZG9lc24ndCB3b3JrIHRoYXQgd2F5Lg0KPiANCk15IHJlYWwgaW50ZW50aW9uIGlzLCBpZiB4
ID49IDEuNSAqIDIgXiAoZmxzKHgpIC0gMSksIHRoZW4geCA9IDIgXiBmbHMoeCksIG90aGVyd2lz
ZSwNCnggPSAyIF4gKGZscyh4KSAtIDEpLiBBbnl3YXksIEknbGwgY2hlY2sgdGhlIGZpbmFsIGlt
cGxlbWVudGF0aW9uIGNhbiBtZWV0IG15DQpleHBlY3RhdGlvbi4NCg0KPiBJJ2QgaGlnaGx5IHN1
Z2dlc3QgeW91IGludHJvZHVjaW5nIG5vdCBvbmx5IHJvdW5kX2Nsb3Nlc3QoKSwgYnV0IGFsc28N
Cj4gcm91bmRfY2xvc2VzdF9wb3dfb2ZfdHdvKCksIGFzIHlvdXIgZHJpdmVyIG1pZ2h0IG5vdCBi
ZSB0aGUgc29sZSB1c2VyIG9mIHN1Y2gNCj4gZ2VuZXJpYyBmdW5jdGlvbmFsaXR5Lg0KPiANClll
cywgSSBhZ3JlZSB3aXRoIHlvdSwgaXQncyBiZXR0ZXIgdG8gdXNlIHRoZSBnZW5lcmljIGZ1bmN0
aW9uYWxpdHkuDQoNCj4gPg0KPiA+Pj4NCj4gPj4+Pj4gKwlpZGxlX3Nsb3BlID0gRElWX1JPVU5E
X0NMT1NFU1QoaWRsZV9zbG9wZSwgcG93ZXIpICogcG93ZXI7DQo+ID4+Pj4+ICsNCj4gPj4+Pj4g
KwlyZXR1cm4gaWRsZV9zbG9wZTsNCj4gPj4+Pg0KPiA+Pj4+IFlvdSBjYW4gcmV0dXJuIERJVl9S
T1VORF8gLi4uIHJpZ2h0IGF3YXksIHdpdGhvdXQgYXNzaWdubmluZyBmaXJzdC4NCj4gPj4+PiBB
bHNvLCBJJ20gdGhpbmtpbmcgb2YgdGhhdCB0aGlzIG1pZ2h0IGJlIGEgZ2VuZXJpYyBoZWxwZXIu
IFdlIGhhdmUNCj4gPj4+PiByb3VuZHVwKCkgYW5kIHJvdW5kZG93bigpLCB0aGlzIGNvdWxkIGJl
IHNvbWV0aGluZyBsaWtlDQo+ICJyb3VuZF9jbG9zZXN0KCkiPw0KPiBbLi4uXQ0KPiANCj4gVGhh
bmtzLA0KPiBPbGVrDQo=
