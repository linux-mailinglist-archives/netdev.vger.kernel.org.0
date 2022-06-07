Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95B75401CF
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbiFGOw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343577AbiFGOwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:52:53 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60076.outbound.protection.outlook.com [40.107.6.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DB8F5068;
        Tue,  7 Jun 2022 07:52:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdOZp01ekCtmar+I2n5mGag2jtPP4udmiKgXabXofSpgyi6BQFPeHK+xdN7ZsRdHoYOe3lSQ107UsFW+1ghp2jnEYKq6n738X+tPdNEK0gCW4frR54zVNrVG4sZugbRxMMDI31vAGvJRfG3cCh3eBZRSKrvj8Khu6sKrs9YtpBOVYjvooH7nzDdOahPsFpVprniqt+1hn9VHoL/6xSuaOdslna3B70WxCmvmTSJmQc6DkOU+R4MJQ2qGjUOz1zndnfbq7sYkQNbzEMhv0mklhodjWeTjavbWq1I6E0oIwU3YuMsCTTgqFunslG1+8DWsx3Fj3NC4fDlM+zV0WzJkLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lI/aZPgWW0y2Ak0A4mWyYKTTJ17eFAACIX6vfD3VRR8=;
 b=e4gue+5DeAjyXs8nymf7qCUlYbzo6YLPKWAKh2Wf45+PaEemYtSMwD/IRb2/7u/o9Kvw5WOT3IrwwjNSRxv82uAT51PjdVghASy6lUIIViuw6mSRV67oy3yTrCWYTPc4QBV67dIAdjBf8SuvgZMG5cOYylq00GI8pPKOXgdzsk5jc3kynwVpPkTgHSFnRKku/kqXxIaUXleuQiC0jN968o1z+5LHyPkpniu6NZRgEc7YEc8vV23Z1WDwC3XPGMYI1edHjaC6cEauJ25QDDJkyLn0KCt4BmJOwBOuzJVmtZbnF3be+VzU1Fgq7irpagZ3LiAMzcG4aUZgZMEQAwMQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lI/aZPgWW0y2Ak0A4mWyYKTTJ17eFAACIX6vfD3VRR8=;
 b=EzaLbqji6LBiriMbZz8g0xhDwHrkrMxEDnYRYCwqf1NvGMOfEkfYT6QzJT2WiwNqy5RN5ki09hsD1FfWGXHWlLSBd1JsJFjj7UZlBBtUz7pA5bsU6tcLtR5vihL625FxT4cF3AAzHO76ojmQtDE6SZtxdviet35GtXwyd3Fpuj4=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4319.eurprd04.prod.outlook.com (2603:10a6:803:43::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 14:52:48 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::ac4a:d6c6:35f6:84fb]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::ac4a:d6c6:35f6:84fb%6]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 14:52:48 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        netdev <netdev@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: net: fman: IRQ races
Thread-Topic: net: fman: IRQ races
Thread-Index: AQHYdSHwFebLnfwxmE+xbiOpPp5Baq1EDdZg
Date:   Tue, 7 Jun 2022 14:52:47 +0000
Message-ID: <VI1PR04MB5807729BF02C130EEEB65DFCF2A59@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <c6c6f425-d12b-3a16-2573-4c70b9c48b7e@seco.com>
In-Reply-To: <c6c6f425-d12b-3a16-2573-4c70b9c48b7e@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dced0c80-5962-427f-3eaa-08da4895635a
x-ms-traffictypediagnostic: VI1PR04MB4319:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR04MB4319DCB35DEE035B2735C289F2A59@VI1PR04MB4319.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y0g4pZZYe3u2UddedMdR9pH8koU1GBUPgQ86UG/iNPhmV8BfUjUvqXk7dw3/lwu5enodibfmKMadZk2kGY89HfHgeUEBppdByiTGx0yDOgDhlFmwYkp5UQ9+hNaNCSoQHncWqtRqAmNhmYsRS107uI0S7Y2D//yWrmThj3ZZwbAY4gsAhO+7W6JbkyPZrgrHlc4sracXhj2aFM9zmI2uBlu3gypWVJvhbw9vSjfT4fLuTMF9eg7FkZRvnE4/asp7WTj3X8QJp9bUwxJIUsgCbmuikyDVrCGjyu60auSqIrLSbaHEk4miQ9QiPUTwv9gHMKd51nkCzo9DEDoZp89uwh8nOM7r7fqcJIV+jA2Q4jcEMSKojoAWB17g0Zmys2WqYL9x1Chzb+f/lwdzhDZKIyvi5fPpGC4hvTpftWnWWtegFcCfdxzfd5317Ew4pOcw6CZk8D74iQoP9y0TphEunW2YSSEXOg0HVo3C4+6mqfGKcKgb911yAaNadQIy0C0pYTdrynSX3GQyLE57M4ycOcD+poZY+5uZHXIzN+jbOVCHp05SWp+BuvY2xS7TwfaERikLpDfNcJ3oqRaGEDmZtHTo6G5XXWG6h34HsFx8URtvNrU84ro5zN094WioAbPdIitnnNpUax8tlIxjIGbbNNPelhmQ5yZt1BA4mUPqJLOB0zrmcn0rIR8gPGcTN01IEX+sQv9yCqU03hbN5PFQsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66446008)(66556008)(38070700005)(8676002)(2906002)(64756008)(83380400001)(8936002)(71200400001)(55016003)(186003)(26005)(9686003)(110136005)(54906003)(316002)(6506007)(55236004)(53546011)(7696005)(33656002)(76116006)(66476007)(508600001)(5660300002)(66946007)(4326008)(38100700002)(52536014)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SE1oYk00SUpsQy8zUm1xTEpDcEV1eHVUQlcyMEpDUG1qU3RZdGZiVGlnUFJ5?=
 =?utf-8?B?aWNRWTVWd1BkMTRqNCtha3E0THdHRGoxZzM5RndXdTh0c0NwWUtnVmxENWN0?=
 =?utf-8?B?c05KY09DVnhUU2ZNQS9kWEpQcmtRblFrOTZyT2UrelY0U01RWWgybUNEWEpv?=
 =?utf-8?B?TlNRM0xHWWhEcXhhcFhIU3MzUEcvQXhSWGdTb0VKUHVPcVl1R3V0cWFzTUUy?=
 =?utf-8?B?YkJGSnNab1Nrc1ZhRW8rZkdJRUFSclllaXZ0R1Q1WCtBdkxlZXM3QXZteDhB?=
 =?utf-8?B?OC8xdWY2ZVUyNzB1YlQ0UW5KYWl2azc5eDFlZ2VHcERTTHJOOEFRTGF5SUta?=
 =?utf-8?B?NkVNOGFkTWkxekFJQmZKVW8yWFFCb3B6U2N5blAvSUUvV0UySWhuQ2toR1pO?=
 =?utf-8?B?T3RZbE1tTU5DU0syRFcyVkJxTzhVWlo0anQ5UTZHR1VyMDdDU0hCTEprT2RY?=
 =?utf-8?B?Z0dRT2NsYUxSU3FXNUkzRkdib2paUkh4d25hRlBNQ3IyZEJnM1VKdFAyL3cz?=
 =?utf-8?B?bWtVbCs3SXJhN1dEbWtWb1dua2J5aW8xWlNJL0JKREhNZ3lobUFhQ0V0YlQ1?=
 =?utf-8?B?c2wveGgybmszcWFSemU4dERNeU1aQ0FvQ21GdXNFc1UxcVBaUXlDdHpCMWJP?=
 =?utf-8?B?Ym1uSkNQTDlWNG5FZmx6NzhHY0dFYUhHcSt3T0xScWw3SU5Gb081NENBVy94?=
 =?utf-8?B?M2pzQW1zWEN6d1loUGZkRThpNXprN3hiM3I1R1BGaUhMNVFJQmdXMTYrYlV2?=
 =?utf-8?B?SXVJczhtdHBxNFNpT3Baa0RoL2VYcmRYZ2N5WSt6bkxld3RzbjZpY1o0djlF?=
 =?utf-8?B?ZTdkeXRQYmJVZ3NvOHk3TjQyeVFpcGxDQkZ5VlR2N1ZLdHZBQ1l4MjJUeFQv?=
 =?utf-8?B?MlBqWkM1VHlNZHljNytybnViS2pqcGRBZmw4K2tVZU1BQVBCaG5BOFAyelJB?=
 =?utf-8?B?bFpXM1E1Z1R3MnZNQUdZYUlQN3R1SVZOajlqNFFUVkdOMHlPSWlQSHhMRWRZ?=
 =?utf-8?B?MCtkVUNMQm1pWUw3MEdzQjYyTDk1Q29lSjhwemNkNWcrVnlvYUhJV1E5R1Bl?=
 =?utf-8?B?a1hYSHNEeUJIYnVlUTYyS0dkNHo5QjROOGl4SDBCbEZmUklmV1BFVGdqekh2?=
 =?utf-8?B?MkVmTnVQWi9Wd0Z6R2V6RUJoU3psVWt5UFJqLzBwKzlEVi9nbncyeDNHOXIr?=
 =?utf-8?B?bTlYcHM4YThnYVgxK0JoakJ4b0hXUVpmblhwa0tSYS9JY2RjRDR6VHRFd0ta?=
 =?utf-8?B?VlF5Sms1UVo1VzFoUlFYM01kV0xzZkpzc1VVNkxqNlhZSENmZFM2T2hodGRB?=
 =?utf-8?B?TERaK0NqM1Bxa2t4Z3RhMHhQb1NVTzBuU0lHUEVJMEVGSTBEZFVGZ0tqb3RX?=
 =?utf-8?B?aklXT0NqOFpuVDFBMEMramxHVlZzRWI3RE1FTmdXLzFRQ2JLYTNUZWkweUJH?=
 =?utf-8?B?dXBNTzM4djl3M0NCNm9VWGNnT21tRXZNd0IyNlNvS3Z4d1l4RE81Nzg5Zmxm?=
 =?utf-8?B?UGQwT3p6U3Z3YmI2U2JKR29MVFYxTGMwbWExTFU3TzNnM2pjeUpoMlE5OFN4?=
 =?utf-8?B?dCtSYW84dWZodVZ5M05PQVkyelM3dWJFQ3NjbUlCWHJQUC9yUzhtdm5IWHpC?=
 =?utf-8?B?cXZ3U012bEV1cjB0STVYVFlSVGUrNUNxUExqUDRLcHorM0VsL3c5cEFNWGJ6?=
 =?utf-8?B?OFhQL0NzaENLNjZYTzd6SEJtYi9WVlEyekJ6NFBzT3ZKQzdwcUZnK3dnNHFa?=
 =?utf-8?B?K2EvNU1MV2Rsc0xESXNqN0JMV2l1Qk44ZzUzQ1ZxWU05M21wRmVlbjEyTkpi?=
 =?utf-8?B?YzVWNEpYUzJLR0Qyb2xyZ3JQQVAyakJYbW1vd2xOc21vajdpYjd0K3ArZGNp?=
 =?utf-8?B?VDlET0RRcyt1Y0dsT08wNnVBTkRkYjBZKzBLaERhS29NMG9iVmJCN2FOUDlP?=
 =?utf-8?B?WFN5NUhEL0xWLzhpYUxyeDNWNWcvV2FjM1VvNzkrTHR0ZllUZ2NWWUtXdjVW?=
 =?utf-8?B?VEt4MjdqUFhENFJnc2JFTTJQeWZNNG00eGd4ME04M0pOZ0F5czR5VG5RQTNG?=
 =?utf-8?B?OEZqS2hOb2hjdkVMY011QnRYVFFCVnVkTGljdUlhMUtCR0JlR1JSOFUxQTkx?=
 =?utf-8?B?bHNYM0RPTlZWT1Nib1hKVXVmQjJScTNFTno3RXZhQkcyY2tLTGtuM3JZVEd0?=
 =?utf-8?B?SWpHRGZBMXVpOWpTdkRtZ1F1bkJVaWJQbThnNXZYM0lNejRmdGJUMnN4R2xa?=
 =?utf-8?B?VU9kSVowOW8yZXRucFNHQTFyS05tWmg5WHl3UnB6VmkybjJUVmZKYlFwZTYx?=
 =?utf-8?B?SHZSK0lLQVUxSlZnUUw2MmRKOHJCTDJwOWJ2ejhHbDBlb3VjR0lDUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dced0c80-5962-427f-3eaa-08da4895635a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 14:52:47.9907
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VUDHm5MA6pUj01NrusqRFp2i2Hp8+AqIK32nTcvljRNjZ++4WoLGQD164R1up7jnd1u9NbXhpi1+scCwPSPk5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4319
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWFuIEFuZGVyc29uIDxzZWFu
LmFuZGVyc29uQHNlY28uY29tPg0KPiBTZW50OiBUdWVzZGF5LCBNYXkgMzEsIDIwMjIgMjI6MDkN
Cj4gVG86IE1hZGFsaW4gQnVjdXIgPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT47IG5ldGRldg0KPiA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz4NCj4gQ2M6IExpbnV4IEtlcm5lbCBNYWlsaW5nIExpc3Qg
PGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBGbG9yaW5lbA0KPiBJb3JkYWNoZSA8Zmxv
cmluZWwuaW9yZGFjaGVAbnhwLmNvbT4NCj4gU3ViamVjdDogbmV0OiBmbWFuOiBJUlEgcmFjZXMN
Cj4gDQo+IEhpIGFsbCwNCj4gDQo+IEknbSBkb2luZyBzb21lIHJlZmFjdG9yaW5nIG9mIHRoZSBk
cGFhL2ZtYW4gZHJpdmVycywgYW5kIEknbSBhIGJpdA0KPiBjb25mdXNlZCBieSB0aGUgd2F5IElS
UXMgYXJlIGhhbmRsZWQuIFRvIGNvbnRyYXN0LCBpbiBHQU0vTUFDQiwgb25lIG9mDQo+IHRoZSBm
aXJzdCB0aGluZ3MgSVJRIGhhbmRsZXIgZG9lcyBpcyBncmFiIGEgc3BpbmxvY2sgZ3VhcmRpbmcg
cmVnaXN0ZXINCj4gYWNjZXNzLiBUaGlzIGxldHMgaXQgZG8gcmVhZC9tb2RpZnkvd3JpdGVzIGFs
bCBpdCB3YW50cy4gSG93ZXZlciwgSQ0KPiBkb24ndCBzZWUgYW55dGhpbmcgbGlrZSB0aGF0IGlu
IHRoZSBGTWFuIGNvZGUuIEknZCBsaWtlIHRvIHVzZSB0d28NCj4gZXhhbXBsZXMgdG8gaWxsdXN0
cmF0ZS4NCj4gDQo+IEZpcnN0LCBjb25zaWRlciBjYWxsX21hY19pc3IuIEl0IHdpbGwgcmFjZSB3
aXRoIGJvdGggZm1hbl9yZWdpc3Rlcl9pbnRyOg0KPiANCj4gQ1BVMCAoY2FsbF9tYWNfaXNyKQkJ
Q1BVMSAoZm1hbl9yZWdpc3Rlcl9pbnRyKQ0KPiAJCQkJaXNyX2NiID0gZm9vDQo+IGlzcl9jYihz
cmNfaGFuZGxlKQ0KPiAJCQkJc3JjX2hhbmRsZSA9IGJhcg0KPiANCj4gYW5kIHdpdGggZm1hbl91
bnJlZ2lzdGVyX2ludHINCj4gDQo+IENQVTAgKGNhbGxfbWFjX2lzcikJCUNQVTEgKGZtYW5fdW5y
ZWdpc3Rlcl9pbnRyKQ0KPiBpZiAoaXNyX2NiKQ0KPiAJCQkJaXNyX2NiID0gTlVMTA0KPiAJCQkJ
c3JjX2hhbmRsZSA9IE5VTEwNCj4gaXNyX2NiKHNyY19oYW5kbGUpDQo+IA0KPiBUaGlzIGlzIHBy
b2JhYmx5IG5vdCB0b28gY3JpdGljYWwgKHNpbmNlIGhvcGVmdWxseSB0aGVyZSBhcmUgbm8NCj4g
aW50ZXJydXB0cyBiZWZvcmUvYWZ0ZXIgdGhlIGhhbmRsZXIgaXMgcmVnaXN0ZXJlZCksIGJ1dCBp
dCBjZXJ0YWlubHkNCj4gbG9va3MgdmVyeSBzdHJhbmdlLg0KPiANCj4gU2Vjb25kLCBjb25zaWRl
ciBkdHNlY19pc3IuIEl0IHdpbGwgcmFjZSB3aXRoIChmb3IgZXhhbXBsZSkgZHRzZWNfc2V0X2Fs
bG11bHRpOg0KPiANCj4gQ1BVMCAoZHRzZWNfaXNyKQkJQ1BVMSAoZHRzZWNfc2V0X2FsbG11bHRp
KQ0KPiA8WEZVTkVOIGludGVycnVwdD4NCj4gaW9yZWFkMzJiZShyY3RybCkJCWlvcmVhZDMyYmUo
cmN0cmwpDQo+IAkJCQlpb3dyaXRlMzJiZShyY3RybCB8IE1QUk9NKQ0KPiBpb3dyaXRlMzJiZShy
Y3RybCB8IEdSUykNCj4gDQo+IGFuZCBzdWRkZW5seSB0aGUgTVBST00gd3JpdGUgaXMgZHJvcHBl
ZC4gKEFjdHVhbGx5LCB0aGUgd2hvbGUNCj4gRk1fVFhfTE9DS1VQX0VSUkFUQV9EVFNFQzYgZXJy
YXRhIGNvZGUgc2VlbXMgZnVua3ksIHNpbmNlIGFmdGVyDQo+IGNhbGxpbmcNCj4gZm1hbl9yZXNl
dF9tYWMgaXQgc2VlbXMgbGlrZSBldmVyeXRoaW5nIHdvdWxkIG5lZWQgdG8gYmUgcmVpbml0aWFs
aXplZCkuDQo+IA0KPiBTbyB3aGF0J3MgZ29pbmcgb24gaGVyZT8gSXMgdGhlcmUgYWN0dWFsbHkg
bm8gbG9ja2luZywgb3IgYW0gSSBtaXNzaW5nDQo+IHNvbWV0aGluZz8NCg0KSGkNCg0KWW91IGFy
ZSByaWdodCwgdGhlcmUgaXMgbm8gbG9ja2luZy4gVGhlIG9yaWdpbmFsIEZNYW4gZHJpdmVyIGRl
c2lnbiBkaWRuJ3QgaW50ZW5kDQpvbiBzdXBwb3J0aW5nIHJ1bnRpbWUgcmVnaXN0ZXIgY2hhbmdl
cy4gQ2xlYXJseSB0aGlzIHdhcyBhIG1pc3Rha2UgYXMgeW91DQpwb2ludGVkIG91dC4NCg0KQ2Ft
ZWxpYQ0K
