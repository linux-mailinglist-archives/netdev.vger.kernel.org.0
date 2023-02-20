Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B46869C410
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 03:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjBTCL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 21:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjBTCLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 21:11:24 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2052.outbound.protection.outlook.com [40.107.8.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE5C65B;
        Sun, 19 Feb 2023 18:11:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIMslBdvqZ+FnngY5da5nbEc12b6plTGeETtTlcAkzI5ka75/UKSSCkzCCZc5lqwwoX4dk0+H8MHWizgosQUfn2shZlRr0Vd9uK+lBb7OAUhV+HH/iLcioLQrwV+3zVMSh6Vl1mPHnlIXZ60frVA1eYHvNQ/37OCiqFTQbXM9D+IRsAp/6d4rVOLx3/BfmfI25RnfJwZ2MbO+fhtKw5haRXVMU7WXJjX+FbKwtV+YrBlaJqDDHQDH7+Q7vEMvfGTYi1QGnzHXU88/e24eefMYr4rejiIn0/a2XdyFn1/gznMH2MfI7K0apq/P+OtzRC5sGXR6jQHCNlZMBx4p5M1aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3G3hK39oTjYF/1wzLnmQLciNBac8UN0L3088MgrOMrM=;
 b=b+gVyLwzRn4g7kTcS7e2xexoSU+1acY4h2sSojEU/gyF94vchSQ/lOrheTYp20jMpUIpyZqG4L9jksYFSCziIeyAgGPnlcivuehtvC9o9sCwcpT8kENkeAahAkAFy1+f6jDssRCuiNM4Rwgb8bQ0KdvpCVEkTOZU76awZ/oC827bx052fvCeNMp+mGOYsxd1dj0q3Coa0QvgRgFwNt99o4/OweM0I3dRn0Kxq28lb5JNFQiQUViPVyCevZSo/v3OCS1Rpqa4WalWv0SUab5FmgGMNgCPooPWyOR2m3chtXHQtl7tzQvCP96U1TAIv1lsaIlY5jgI/bYLovMcp2PPqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3G3hK39oTjYF/1wzLnmQLciNBac8UN0L3088MgrOMrM=;
 b=CTSWWihoqkQwOxxuNe/YzHm4ek+wdrsfuaR49Mxtx2E1dUroSRdqo7AVXnGL+XhStJa70vEaGZF8jS48Yl8lpXYYnBeE+Y0Dui3GPkfYZPGmcP96UaWLLIpq4HgfOaYmSj5kBfplf+ABLwk145y7FsH1jTN3/eImf78uhDbeK/Q=
Received: from PAXPR04MB8109.eurprd04.prod.outlook.com (2603:10a6:102:1c2::11)
 by AS8PR04MB7703.eurprd04.prod.outlook.com (2603:10a6:20b:23c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 02:11:11 +0000
Received: from PAXPR04MB8109.eurprd04.prod.outlook.com
 ([fe80::ab56:7b1b:c330:b948]) by PAXPR04MB8109.eurprd04.prod.outlook.com
 ([fe80::ab56:7b1b:c330:b948%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 02:11:11 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Richard Weinberger <richard@nod.at>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        dl-linux-imx <linux-imx@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: RE: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
Thread-Topic: [PATCH] [RFC] net: fec: Allow turning off IRQ coalescing
Thread-Index: AQHZQ+Gy2VXqw+BDuEeU3ZeJCH1tfq7XFCgQ
Date:   Mon, 20 Feb 2023 02:11:11 +0000
Message-ID: <PAXPR04MB81093DB4BF1F6A6B3F8F895088A49@PAXPR04MB8109.eurprd04.prod.outlook.com>
References: <20230218214037.16977-1-richard@nod.at>
In-Reply-To: <20230218214037.16977-1-richard@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB8109:EE_|AS8PR04MB7703:EE_
x-ms-office365-filtering-correlation-id: 5d8206f4-08e8-46c8-0bf2-08db12e7bcbd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rDiB4R05Roxwz22WEE3fAbqLmr3SohOD8/4slkdMUd4UVsAqUsl9Nncv0sZttqhkqUh+ZG7gAMuWlK9t8rrIUmloycdJ7nXdhr2j9f0ugxOd+mkIIh6K8CXeI/PkTTimEaTD47KMpTehFEYp12jpoPRcwKbweUA01xx4V6EXalB5MPMo6xI86GS2XCGY31oFn7LSQ+hOPxco1bylJVEjKrxDyFjv1XYE4ehk0tENh1IYGSGvTJmIV50g8/4aiGwYvBikcWBW3+eBu5Hey+T63OrpYxzrhKwsWX9cUzBYQzMswHMG9tc2zpH7DMyNsoHVkkVRxi2pRKlGuhXrGsS8ogEA8Tv9NOPHjN57Xik8mwfaBcB4I2kXlYZfxQPP15ZZdksnC2Lrqlizj+kF1rfdl/kfUfM728KWTCoDd+uhVmn/cF0tJ2D92jnN/dDF24CAut/d4kUVnKzQK0PnDRxHMSmZSmKdORaiUqkWD2zU42eahkoD2dA2VwvROYMTCJHFpdQQ1eTMew1D2A9viiA1CdAP+d2UUIobnY/CYuX8v9ly/d/Zzi/F88+CsGmDzv8IqaRqbwL/jDqZOG7pnp+WSBHXVbz/m8TdS0ImrhEeWjykeLJzxE+xUR8BSQ5K+FUyR+Rr7ZbFD0TIexxdTIOt+1/Om1h5gowMai7uS5oY07QEbDuM07vddXRVmIQr4nTtVgUYmi+mGvI0vfLDxdeVLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB8109.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199018)(5660300002)(44832011)(86362001)(2906002)(38100700002)(122000001)(7696005)(71200400001)(478600001)(9686003)(53546011)(186003)(26005)(33656002)(55016003)(38070700005)(66946007)(76116006)(54906003)(316002)(66556008)(110136005)(41300700001)(4326008)(8676002)(6506007)(66476007)(8936002)(52536014)(64756008)(83380400001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?UmFsZ095c3JnQk9XampGcHhoZ3QwcXNQVGMyU2xNdjQvcTNoVXRRWEdoR3Ns?=
 =?gb2312?B?YlpmT3AvMEhGazJWejFjM0Y1WXNWOVd3bXVzb3hmd29SUlViRThSOGN1UndL?=
 =?gb2312?B?T0VTYmdHNWxib2U2aTNVaGdGaG92V3MybHZhakF6K3NUMzIySXpxRUlsaWU0?=
 =?gb2312?B?bWJ5VUlEMGtXUTluK2pyWFdBem9SYkhpMHUzSEc3SnVBNy9yWC9pYTVYT09w?=
 =?gb2312?B?aXF5elAySUVJODdhUFB0RXBnVDdUTnQ1RGsrYm1ZRmJZNFFpOWlYQnNvVXp5?=
 =?gb2312?B?SFVlak9EUGxLK1VOUTZEY3FQVFBta21YdEF0L3pEaDlaZHdtbXE1UjBSMm9F?=
 =?gb2312?B?UlVTVGdOWCtEczFweENSMlFXTXZ3NVB3cEdHeEJtKzdlOFZRL0FFNmJYbUh6?=
 =?gb2312?B?TEJjSTd1aStxWHY5MGtDVkpOZEcwT0k0clFUZ2V6bEpZVGtHSzdQZUpHTXJ3?=
 =?gb2312?B?K3dYc1ZkOXFXK1J5dW9ITkVWanJHb2h0Tk4wV0toaktzb0ZTVUc2ZFEzeUhW?=
 =?gb2312?B?RExkOWVtanRpdTBjOXRPT2IvQ29SQXlhMFVLUDJpblIyTG5oRUFlYU91YVlh?=
 =?gb2312?B?Z1VRNXAvTkxmbytnMmVNRmRhOUFiRS9SVjcxcGRaNUhkZmdQMTQ0RnVIcG5k?=
 =?gb2312?B?cGo1dERyczNVcjU2aGNKRlVpSkM0TjY1R2JzSTIwWmsvczBOdDJCVVZTa0JR?=
 =?gb2312?B?MkhldGlRNXAzaHF3QWthMW9BQ0FWRmVQOGN3TXVOVlBnOXpwS3N2NDRidk1M?=
 =?gb2312?B?MVZLcndUa2pUQUM5N3pGeFd2TGFvTHA1a0xKYzZ0UkZlMzJGdmZaclUrV1BV?=
 =?gb2312?B?VFprQ20rYjR1ejcvdlZ6VnVYQ3lnRm5XQzZSbVVGVHFpeXFMVjJuSGlacXBo?=
 =?gb2312?B?YVFoNXAvSjVsdlFnQmQ1dy9va1VKQjNBN1BhdVprZ01Sd1M4WUlBdEQ5cjF1?=
 =?gb2312?B?U3QrRFhMQnpGVkxsMTJrM21wcnpSVTJianBlaDlJeDcxUjgxRWVxRFFILzBi?=
 =?gb2312?B?WTlCTXl4RDMrRk5hcGhiYmZLQTFVdWJubEF0ZFJOSzg4VkpsV3hlVU9rbTE4?=
 =?gb2312?B?RnY4cURpNjE1VWhsRWFCTWZiUHJvNk82WFVYelJ4Ni9KODMwUWJRdnd2U2gv?=
 =?gb2312?B?eURtanFINXJEMldBZkZPNFd0aU9FQlBSSlJSUnRRT3BobHpsVnVJRlBiQlBu?=
 =?gb2312?B?QzRYNzQwZzAvTTBvQVpEUEVzYUFQcCtJR3Fzd2hteXNBZVhLRXlIcDJMV2Mz?=
 =?gb2312?B?a2xJR0V6dXBpeFcxVm5yTVdyUHNUNG1RUzc3dE5EOXZscENEUnJ1aEdhdHNI?=
 =?gb2312?B?NkxjTGx1WFpGR2VZUVovbjN6TGwySGhwdnBKTmRXRytNRkJFSjVoQmZBbEpo?=
 =?gb2312?B?TlNnSWJSREFWVEI3ZlpsUTBoODBpZE1tc2MrRzF4ZmpFQjdLRGpQM0lYNk43?=
 =?gb2312?B?VytLdnhoNTk1ZksyK0hBejhGQ0lDZzREdEJvdUpaLzFhNXk2dGEwajRqM01l?=
 =?gb2312?B?cDRQdFk4SE9HcjllaS8wQUR4Q28yVE93WHE4c1NBN3V2N21jSG5vRHJIOUNa?=
 =?gb2312?B?Q21uVFdIRE05Q1ppTTVPY05jTUZpdkxESkx4b0F0U0lwKys4b0NOU1VodUo1?=
 =?gb2312?B?S1Vxbnh0aFZhU0RrK0pmWUl4Y1hFcCtrMlQrWDU1OEdITldzVld3MFEzMmN1?=
 =?gb2312?B?T1NSdGw3MEhYUSswclVkc1kwRFloSzRKRU9rKzlXbTRvMDRhOEdVK0ppZFps?=
 =?gb2312?B?dFFOZ2MvTXkwelA3U3dkajU2cXl4aURLZFUyMTNCK2FMUDNzcEpuTjRoU2pi?=
 =?gb2312?B?cHh0NUR1eFhvcTFkL3BickdsVFZnUlZiZlpOSlN1SFNaaStGU1MrU2VZb2FW?=
 =?gb2312?B?VkFWaDdSalFYWDNzN0YrZlAzOWJ6NXBzNGhocmJXR1A0R1NzTjJEQXRNMVJD?=
 =?gb2312?B?Rk43R0NUdWFGd0diR09aNkwwQjFFR2lqampvWm5IejdkL3Y3dC9PV0c0Z0kz?=
 =?gb2312?B?Zm00NnRQdFIxdzlWeVpkV2xTZFU5YWRUWEZwRzF1VmZlVUFBM2c3dnVVR3VG?=
 =?gb2312?B?UVVLRzhuTitRRTdRNEpOTkNlQUpwMXNjNEYxTi9iclpkQzBDbkZ2bEFqVjJU?=
 =?gb2312?Q?0kr4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB8109.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d8206f4-08e8-46c8-0bf2-08db12e7bcbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 02:11:11.5839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PIcPeFBw+VH6DcmoNc6f6f0V9sQlwdWBhAi5qmvsBOQzyp7obamP+LvfVBATWKMAVtWSvnBlMTmb5xORw/n1mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7703
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIFdlaW5iZXJnZXIg
PHJpY2hhcmRAbm9kLmF0Pg0KPiBTZW50OiAyMDIzxOoy1MIxOcjVIDU6NDENCj4gVG86IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHBh
YmVuaUByZWRoYXQuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IGVkdW1hemV0QGdvb2dsZS5jb207
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+
OyBDbGFyayBXYW5nIDx4aWFvbmluZy53YW5nQG54cC5jb20+OyBTaGVud2VpDQo+IFdhbmcgPHNo
ZW53ZWkud2FuZ0BueHAuY29tPjsgV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+OyBSaWNoYXJk
DQo+IFdlaW5iZXJnZXIgPHJpY2hhcmRAbm9kLmF0Pg0KPiBTdWJqZWN0OiBbUEFUQ0hdIFtSRkNd
IG5ldDogZmVjOiBBbGxvdyB0dXJuaW5nIG9mZiBJUlEgY29hbGVzY2luZw0KPiANCj4gU2V0dGlu
ZyB0eC9yeC1mcmFtZXMgb3IgdHgvcngtdXNlY3MgdG8gemVybyBpcyBjdXJyZW50bHkgcG9zc2li
bGUgYnV0DQo+IGhhcyBubyBlZmZlY3QuDQo+IEFsc28gSVJRIGNvYWxlc2NpbmcgaXMgYWx3YXlz
IGVuYWJsZWQgb24gc3VwcG9ydGVkIGhhcmR3YXJlLg0KPiANCj4gVGhpcyBpcyBjb25mdXNpbmcg
YW5kIGNhdXNlcyB1c2VycyB0byBiZWxpZXZlIHRoYXQgdGhleSBoYXZlIHN1Y2Nlc3NmdWxseQ0K
PiBkaXNhYmxlZCBJUlEgY29hbGVzY2luZyBieSBzZXR0aW5nIHR4L3J4LWZyYW1lcyBhbmQgdHgv
cngtdXNlY3MgdG8gemVyby4NCj4gDQo+IFdpdGggdGhpcyBjaGFuZ2UgYXBwbGllZCBpdCBpcyBw
b3NzaWJsZSB0byBkaXNhYmxlIElSUSBjb2FsZXNjaW5nIGJ5DQo+IGNvbmZpZ3VyaW5nIGJvdGgg
dHgvcngtZnJhbWVzIGFuZCB0eC9yeC11c2VjcyB0byB6ZXJvLg0KPiANCj4gU2V0dGluZyBvbmx5
IG9uZSB2YWx1ZSB0byB6ZXJvIGlzIHN0aWxsIG5vdCBwb3NzaWJsZSBhcyB0aGUgaGFyZHdhcmUN
Cj4gZG9lcyBub3Qgc3VwcG9ydCBpdC4NCj4gSW4gdGhpcyBjYXNlIGV0aHRvb2wgd2lsbCBmYWNl
IC1FSU5WQUwuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBSaWNoYXJkIFdlaW5iZXJnZXIgPHJpY2hh
cmRAbm9kLmF0Pg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNf
bWFpbi5jIHwgNzMgKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA1
MCBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+IGluZGV4IDIzNDE1OTc0MDhkMS4uY2MzYzVl
MDllMDJmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVj
X21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4u
Yw0KPiBAQCAtNzQsNyArNzQsNyBAQA0KPiAgI2luY2x1ZGUgImZlYy5oIg0KPiANCj4gIHN0YXRp
YyB2b2lkIHNldF9tdWx0aWNhc3RfbGlzdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldik7DQo+IC1z
dGF0aWMgdm9pZCBmZWNfZW5ldF9pdHJfY29hbF9zZXQoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYp
Ow0KPiArc3RhdGljIGludCBmZWNfZW5ldF9pdHJfY29hbF9zZXQoc3RydWN0IG5ldF9kZXZpY2Ug
Km5kZXYpOw0KPiANCj4gICNkZWZpbmUgRFJJVkVSX05BTUUJImZlYyINCj4gDQo+IEBAIC0xMjE3
LDcgKzEyMTcsNyBAQCBmZWNfcmVzdGFydChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikNCj4gDQo+
ICAJLyogSW5pdCB0aGUgaW50ZXJydXB0IGNvYWxlc2NpbmcgKi8NCj4gIAlpZiAoZmVwLT5xdWly
a3MgJiBGRUNfUVVJUktfSEFTX0NPQUxFU0NFKQ0KPiAtCQlmZWNfZW5ldF9pdHJfY29hbF9zZXQo
bmRldik7DQo+ICsJCVdBUk5fT05fT05DRShmZWNfZW5ldF9pdHJfY29hbF9zZXQobmRldikpOw0K
PiAgfQ0KPiANCj4gIHN0YXRpYyBpbnQgZmVjX2VuZXRfaXBjX2hhbmRsZV9pbml0KHN0cnVjdCBm
ZWNfZW5ldF9wcml2YXRlICpmZXApDQo+IEBAIC0yODY3LDMwICsyODY3LDU3IEBAIHN0YXRpYyBp
bnQgZmVjX2VuZXRfdXNfdG9faXRyX2Nsb2NrKHN0cnVjdA0KPiBuZXRfZGV2aWNlICpuZGV2LCBp
bnQgdXMpDQo+ICB9DQo+IA0KPiAgLyogU2V0IHRocmVzaG9sZCBmb3IgaW50ZXJydXB0IGNvYWxl
c2NpbmcgKi8NCj4gLXN0YXRpYyB2b2lkIGZlY19lbmV0X2l0cl9jb2FsX3NldChzdHJ1Y3QgbmV0
X2RldmljZSAqbmRldikNCj4gK3N0YXRpYyBpbnQgZmVjX2VuZXRfaXRyX2NvYWxfc2V0KHN0cnVj
dCBuZXRfZGV2aWNlICpuZGV2KQ0KPiAgew0KPiArCWJvb2wgZGlzYWJsZV9yeF9pdHIgPSBmYWxz
ZSwgZGlzYWJsZV90eF9pdHIgPSBmYWxzZTsNCj4gIAlzdHJ1Y3QgZmVjX2VuZXRfcHJpdmF0ZSAq
ZmVwID0gbmV0ZGV2X3ByaXYobmRldik7DQpkaXNhYmxlX3J4X2l0ciBzaG91bGQgYmUgZGVmaW5l
ZCBiZWxvdyBmZXAgdG8gZm9sbG93IHRoZSBzdHlsZSBvZiB0aGUgcmV2ZXJzZSBDaHJpc3RtYXMg
dHJlZS4NCg0KPiAtCWludCByeF9pdHIsIHR4X2l0cjsNCj4gKwlzdHJ1Y3QgZGV2aWNlICpkZXYg
PSAmZmVwLT5wZGV2LT5kZXY7DQo+ICsJaW50IHJ4X2l0ciA9IDAsIHR4X2l0ciA9IDA7DQo+IA0K
PiAtCS8qIE11c3QgYmUgZ3JlYXRlciB0aGFuIHplcm8gdG8gYXZvaWQgdW5wcmVkaWN0YWJsZSBi
ZWhhdmlvciAqLw0KPiAtCWlmICghZmVwLT5yeF90aW1lX2l0ciB8fCAhZmVwLT5yeF9wa3RzX2l0
ciB8fA0KPiAtCSAgICAhZmVwLT50eF90aW1lX2l0ciB8fCAhZmVwLT50eF9wa3RzX2l0cikNCj4g
LQkJcmV0dXJuOw0KPiArCWlmICghZmVwLT5yeF90aW1lX2l0ciB8fCAhZmVwLT5yeF9wa3RzX2l0
cikgew0KPiArCQlpZiAoZmVwLT5yeF90aW1lX2l0ciB8fCBmZXAtPnJ4X3BrdHNfaXRyKSB7DQoN
CkkgdGhpbmsgdGhlIGJlbG93IHNob3VsZCBiZSBiZXR0ZXI6DQppZiAoISFmZXAtPnJ4X3RpbWVf
aXRyID09ICEgZmVwLT5yeF9wa3RzX2l0cikNCg0KPiArCQkJZGV2X3dhcm4oZGV2LCAiUnggY29h
bGVzY2VkIGZyYW1lcyBhbmQgdXNlYyBoYXZlIHRvIGJlICINCj4gKwkJCQkgICAgICAiYm90aCBw
b3NpdGl2ZSBvciBib3RoIHplcm8gdG8gZGlzYWJsZSBSeCAiDQo+ICsJCQkJICAgICAgImNvYWxl
c2NlbmNlIGNvbXBsZXRlbHlcbiIpOw0KPiArCQkJcmV0dXJuIC1FSU5WQUw7DQo+ICsJCX0NCj4g
DQo+IC0JLyogU2VsZWN0IGVuZXQgc3lzdGVtIGNsb2NrIGFzIEludGVycnVwdCBDb2FsZXNjaW5n
DQo+IC0JICogdGltZXIgQ2xvY2sgU291cmNlDQo+IC0JICovDQo+IC0JcnhfaXRyID0gRkVDX0lU
Ul9DTEtfU0VMOw0KPiAtCXR4X2l0ciA9IEZFQ19JVFJfQ0xLX1NFTDsNCj4gKwkJZGlzYWJsZV9y
eF9pdHIgPSB0cnVlOw0KPiArCX0NCj4gDQo+IC0JLyogc2V0IElDRlQgYW5kIElDVFQgKi8NCj4g
LQlyeF9pdHIgfD0gRkVDX0lUUl9JQ0ZUKGZlcC0+cnhfcGt0c19pdHIpOw0KPiAtCXJ4X2l0ciB8
PSBGRUNfSVRSX0lDVFQoZmVjX2VuZXRfdXNfdG9faXRyX2Nsb2NrKG5kZXYsIGZlcC0+cnhfdGlt
ZV9pdHIpKTsNCj4gLQl0eF9pdHIgfD0gRkVDX0lUUl9JQ0ZUKGZlcC0+dHhfcGt0c19pdHIpOw0K
PiAtCXR4X2l0ciB8PSBGRUNfSVRSX0lDVFQoZmVjX2VuZXRfdXNfdG9faXRyX2Nsb2NrKG5kZXYs
IGZlcC0+dHhfdGltZV9pdHIpKTsNCj4gKwlpZiAoIWZlcC0+dHhfdGltZV9pdHIgfHwgIWZlcC0+
dHhfcGt0c19pdHIpIHsNCj4gKwkJaWYgKGZlcC0+dHhfdGltZV9pdHIgfHwgZmVwLT50eF9wa3Rz
X2l0cikgew0KDQpTYW1lIGFzIGFib3ZlLg0KDQo+ICsJCQlkZXZfd2FybihkZXYsICJUeCBjb2Fs
ZXNjZWQgZnJhbWVzIGFuZCB1c2VjIGhhdmUgdG8gYmUgIg0KPiArCQkJCSAgICAgICJib3RoIHBv
c2l0aXZlIG9yIGJvdGggemVybyB0byBkaXNhYmxlIFR4ICINCj4gKwkJCQkgICAgICAiY29hbGVz
Y2VuY2UgY29tcGxldGVseVxuIik7DQo+ICsJCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwkJfQ0KPiAr
DQo+ICsJCWRpc2FibGVfdHhfaXRyID0gdHJ1ZTsNCj4gKwl9DQo+ICsNCj4gKwlpZiAoIWRpc2Fi
bGVfcnhfaXRyKSB7DQo+ICsJCS8qIFNlbGVjdCBlbmV0IHN5c3RlbSBjbG9jayBhcyBJbnRlcnJ1
cHQgQ29hbGVzY2luZw0KPiArCQkgKiB0aW1lciBDbG9jayBTb3VyY2UNCj4gKwkJICovDQo+ICsJ
CXJ4X2l0ciA9IEZFQ19JVFJfQ0xLX1NFTDsNCj4gKw0KPiArCQkvKiBzZXQgSUNGVCBhbmQgSUNU
VCAqLw0KPiArCQlyeF9pdHIgfD0gRkVDX0lUUl9JQ0ZUKGZlcC0+cnhfcGt0c19pdHIpOw0KPiAr
CQlyeF9pdHIgfD0gRkVDX0lUUl9JQ1RUKGZlY19lbmV0X3VzX3RvX2l0cl9jbG9jayhuZGV2LA0K
PiBmZXAtPnJ4X3RpbWVfaXRyKSk7DQo+ICsNCj4gKwkJcnhfaXRyIHw9IEZFQ19JVFJfRU47DQo+
ICsJfQ0KPiArDQo+ICsJaWYgKCFkaXNhYmxlX3R4X2l0cikgew0KPiArCQl0eF9pdHIgPSBGRUNf
SVRSX0NMS19TRUw7DQo+ICsNCj4gKwkJdHhfaXRyIHw9IEZFQ19JVFJfSUNGVChmZXAtPnR4X3Br
dHNfaXRyKTsNCj4gKwkJdHhfaXRyIHw9IEZFQ19JVFJfSUNUVChmZWNfZW5ldF91c190b19pdHJf
Y2xvY2sobmRldiwNCj4gZmVwLT50eF90aW1lX2l0cikpOw0KPiArDQo+ICsJCXR4X2l0ciB8PSBG
RUNfSVRSX0VOOw0KPiArCX0NCj4gDQo+IC0JcnhfaXRyIHw9IEZFQ19JVFJfRU47DQo+IC0JdHhf
aXRyIHw9IEZFQ19JVFJfRU47DQo+IA0KPiAgCXdyaXRlbCh0eF9pdHIsIGZlcC0+aHdwICsgRkVD
X1RYSUMwKTsNCj4gIAl3cml0ZWwocnhfaXRyLCBmZXAtPmh3cCArIEZFQ19SWElDMCk7DQo+IEBA
IC0yOTAwLDYgKzI5MjcsOCBAQCBzdGF0aWMgdm9pZCBmZWNfZW5ldF9pdHJfY29hbF9zZXQoc3Ry
dWN0IG5ldF9kZXZpY2UNCj4gKm5kZXYpDQo+ICAJCXdyaXRlbCh0eF9pdHIsIGZlcC0+aHdwICsg
RkVDX1RYSUMyKTsNCj4gIAkJd3JpdGVsKHJ4X2l0ciwgZmVwLT5od3AgKyBGRUNfUlhJQzIpOw0K
PiAgCX0NCj4gKw0KPiArCXJldHVybiAwOw0KPiAgfQ0KPiANCj4gIHN0YXRpYyBpbnQgZmVjX2Vu
ZXRfZ2V0X2NvYWxlc2NlKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiBAQCAtMjk2MSw5ICsy
OTkwLDcgQEAgc3RhdGljIGludCBmZWNfZW5ldF9zZXRfY29hbGVzY2Uoc3RydWN0IG5ldF9kZXZp
Y2UNCj4gKm5kZXYsDQo+ICAJZmVwLT50eF90aW1lX2l0ciA9IGVjLT50eF9jb2FsZXNjZV91c2Vj
czsNCj4gIAlmZXAtPnR4X3BrdHNfaXRyID0gZWMtPnR4X21heF9jb2FsZXNjZWRfZnJhbWVzOw0K
PiANCj4gLQlmZWNfZW5ldF9pdHJfY29hbF9zZXQobmRldik7DQo+IC0NCj4gLQlyZXR1cm4gMDsN
Cj4gKwlyZXR1cm4gZmVjX2VuZXRfaXRyX2NvYWxfc2V0KG5kZXYpOw0KPiAgfQ0KPiANCj4gIHN0
YXRpYyBpbnQgZmVjX2VuZXRfZ2V0X3R1bmFibGUoc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiwN
Cj4gLS0NCj4gMi4yNi4yDQoNCg==
