Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F913D0D99
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240491AbhGUKqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:46:49 -0400
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:44319
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237919AbhGUJsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 05:48:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cis+iPfASWBJRKZYPPl4bkdbywXpih8GM+TQ/W7uX/jSdbN8p45j7zFV34E7Z0VGlrKDakUgnSmo6+OKoHjddl411vLgpsLoCc1yDkFO8leTgiZlNw/ChGVFDk+AX7R2aF/21/Yeu89Lhvb07CJN/CWYbuiR/LCoFuAE5pzbRiNe5j7EUWGz/9wqEd6nLdVSn/X0h8PgSU6gCKzgVgQ3LmncDaonHGQbSGiRgZC/4qTIJAKlaOAyer/ebfwrE0woFBGk+R3iae2HgGtDkWbjtf2tpgQW5dlY16QYc5DR9Ua2pN0JDkKDGvrk105Hu0gMZos7QjPIpt+KF+Opk004Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aIrSJUn3axWWWn9pgnbQuaRNWgJSssTjQiP/+0mee8=;
 b=mhTVd0TUa3zvFkqsCzLUdj1LOe6iUHqB6ryZxueqvtxiKKPurclyMnYPnRThZ4SEB1G7JE5kP+DQt/6+609H8LdXRI8aT0mAWtFHku/T2NlQ3mmEZWopScnSf6JxqmMMfOpM3uPTHYxGoJ04VVVb1FDv5Djk8eB2BwDe7iJwS3o6hvSExE5ARqy3t6zc0f/cUS4P1+jS2vERWuKWH/UERfQAWzJVUHRedGl3XaZnHygoOIV0qvrBfIf4Szsy0waFy1Vmj17UO+hd/qQ5Sfcktw0SsZ+DKhnNgpCtGI3bqDj1ELJPURwnfbv1HLF/vASnBUK5uyzAEDFT/eW4cu154A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aIrSJUn3axWWWn9pgnbQuaRNWgJSssTjQiP/+0mee8=;
 b=Zhsz/nnjcBh7j+WQ6g3J9SrQc6Y3OSCkmeQhg2H3nheFxkur1cZgOqvyunAAp9Ko3rPtx4XbO61mrZO9VVlH7sm+5ON5lJiBC4w0ZkbmDCbDjCK9KBoxEqhdwxQLiGgh8MDXF+sdBbVTy13HrglJJEFHwgjD287PohEc+a40Cwg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 10:29:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 10:29:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2] net: switchdev:
 switchdev_handle_fdb_del_to_device(): fix no-op function for disabled
 CONFIG_NET_SWITCHDEV
Thread-Topic: [PATCH net-next v2] net: switchdev:
 switchdev_handle_fdb_del_to_device(): fix no-op function for disabled
 CONFIG_NET_SWITCHDEV
Thread-Index: AQHXfhmXgt1h7RyhkEeONYxWnbzsP6tNOlkA
Date:   Wed, 21 Jul 2021 10:29:25 +0000
Message-ID: <20210721102924.ejzv3lxwbltx2wr2@skbuf>
References: <20210721101714.78977-1-mkl@pengutronix.de>
In-Reply-To: <20210721101714.78977-1-mkl@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 036a07ca-f4e0-4046-cb85-08d94c326986
x-ms-traffictypediagnostic: VI1PR04MB5295:
x-microsoft-antispam-prvs: <VI1PR04MB52956637EF1663DDE2B8F342E0E39@VI1PR04MB5295.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wbsmiimb7a2KMgAw9V5EK2ERV9NqEHmxYBj++re+BmV7Z0XTqHdYS8MZwnBwAEngEmHlVgNpan5Oo00L9Gk6V8cuuVSzwseCyt6cUNQKNudX7/YWeNiS2Cc5qJQukfzt2cDzK1VzDeaIyYOgnS6HHBHtxKAg4xsxW7JMwLMFQ3ptlQlPso6yNlzPXBmiSk0qE4sdLKH6QiHMGXmHC75BGEoOVlqJk10jwFIiQSUEoQzEh+lk6PAgn2yrQykpX7xVU6/3iDqaLLA2v/MxvLNFtKbd+lljnh5W26I9/Anse7BZ35ZBqudQrpz1+Wxev1vEmXj1moleS6sEp5qK+QwumWZ4TxL++oWWV+5wetuz5n8pGRrrR7p0eb78LJtY6/J9VfXmmldXrwJPVaAVh/+oudeoRErSds9wzaH1oNnXW73jlxLlRvQQ7f8pn3MCwOeZTUINwTv/9IrVzKAaFHjNJ2wH3LMJ9lvajyTf2ZuDQtp0USrZRE/0HczkXgZJzmaTSpLHUdhsux47pKwzF+QpMCNA8XWfWWkndqeb/26nyizgJo0agoGmFS+WEbVE1xQYgKGFIrDekZZXyxCU+uzS1cQ6VJp3uTrekEdj4DRmQrBVF81u2I4Mg2kKTaRMZw6TenUiVi/fgiiXbu8ITdq0Kt5PkAyQEdw7KDYYPjLd0FicPfsxyU60DxKrsVQ/lsJHQhLJAKg8smzGL8lA6GwD/FihUOA3RcHNqKNURaQgxIuEfCij2LcZuuqqfj4nFK8393Snx2n3QI+Yu+oJ15kYpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(33716001)(6512007)(8676002)(5660300002)(4326008)(38100700002)(6506007)(6916009)(64756008)(54906003)(66476007)(66556008)(2906002)(8936002)(86362001)(9686003)(1076003)(966005)(66446008)(66946007)(316002)(44832011)(6486002)(122000001)(71200400001)(26005)(478600001)(76116006)(186003)(91956017)(83380400001)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rmh2VDRPTDAvRC9lbkxxNFgybDl5TlViSTgxTGpDTHJtNWVwNUZHdnlRYlBr?=
 =?utf-8?B?c1JiUm1RV3JjSTMvbmpxNk9OSWYza2FrYVFBalBTYUUrY1FjRGdOUm1YdFRR?=
 =?utf-8?B?aDhYMy9NOG9lbTZJcU4vSElnZEhRNmlDa1RsbzNOUnJEMk5BcVhWNU9QdDND?=
 =?utf-8?B?bWdUNHJvUU1kalRTZVorOTl2bXoyeHI4cE91MEFBeFIxR0hGb2ZtTFk1eVJh?=
 =?utf-8?B?T3dUdGdwdGNqdWRjeDVqSmc3aUlFVWlBU2lpeGc4ME4reEFHSnBORzU5Q3dD?=
 =?utf-8?B?djNZd3IvOTFCNUJBMFp6SXovWXp2RVdiT25JZUlyNDVZWnNNM1VCdkpXK0c1?=
 =?utf-8?B?NmhEbVZvNjlyNXl3TnFKc09UR295Y0RZMDJMd1FJR0ZlK3RXd3cvejdIdysv?=
 =?utf-8?B?VzZiM2dWcG9lWVFGbHBnWGEwNjcvUElILzg2cy9PUVQ2bUltbjJaT21uMmJJ?=
 =?utf-8?B?WVU2M0JRSWxycWppanJMTGM0S25QTmpzdnJJN2tQQXhrV2w5TmtJSE1hS1BX?=
 =?utf-8?B?eHR0OWhWbndtclQyUXVxRXRBYnRXV0tQM0o2R3NnWENYZ2h4c1BQUTNHK0xV?=
 =?utf-8?B?bkVtVUdYOEZmRHU3UEpQd0VaTW9VckVKTitVWHROSzVlZEhUbE93U1ZDM2Zn?=
 =?utf-8?B?MWZ1WUFmRGpUYXdtcmQ5RnBTSFBvU0dxSWI4MVM4dFBiaTBTZFlDQjNMMU1T?=
 =?utf-8?B?SG5xZUNZb0NpZ05yb1NORlZpdDNmTFd2bVM2REFuV3RucUVmMis2THptTFIw?=
 =?utf-8?B?OVI4ejgvcFcwOGRnb3dnVzVTZm9PcE9URUFualdvdGhQbXZuWXE3NEV4M09H?=
 =?utf-8?B?ekR5Vm9UU3lRRm53d25XWnRjcjFwTnZ4alZJcklNVUpxQzk1UCs1eW12MVc3?=
 =?utf-8?B?RlZCMlkvVDJnSUk2cGduSzFoOFJvczRvTzF2STZVNXFVbENWaG9WeitUdENy?=
 =?utf-8?B?MGg4WXYzOXZNSzJlQ3dWbEM4ckxJakxKOFlBWWlVSnhPTVJBZy9yU3BvMVo0?=
 =?utf-8?B?eEk5dGF6Tk1QMUFwRzlrTjkrcmtsWDNnVTJEZUJyMDZoWjYxbm5BeEhTcEJr?=
 =?utf-8?B?ZzVCV0owSU5iSDlGTG9wZVI2aU05Wk1HSmhPdHcrQkdINDZvNW9sTnZGYUcy?=
 =?utf-8?B?dFh1V2E2QUxCci8ydmo0S3k5S2dqbUh5OUN0N3F1a2EwODNhSTVRcG1ROHlH?=
 =?utf-8?B?R0RldDJIcmRHRnV0QUVDRzRlTlYzMUtIait4RkJseDc2cWYzQXJIamJKb3Az?=
 =?utf-8?B?THFBNUJBdDUwRFZwWTdrMFVZek41RzRFWmJzNmd4L3hKMHVUcHhzb2pCUXpz?=
 =?utf-8?B?N0pEZXpGSnA5S3R0WG9FVnlwb3luWE1BNmdVWTVrSFVOaHNuYXR2azlRcnZi?=
 =?utf-8?B?S2xDL2ZrL28ycmxEODcvdzlwY2dmbTA0N0l1bHk0ZjdqOG5ySzAvcDVxdXo3?=
 =?utf-8?B?WXZuVk1POWMvOEkyUEQvS24rZWg1ejVzRGE0Z2RpbWl1WmNLYkdJWTNxM3Fr?=
 =?utf-8?B?Tk5kbFBBaTdUZXRKaEZLV3hPVkNvQ29jL3p1cWVMTkp6bURkVnd4YitVeGV6?=
 =?utf-8?B?em1pZ2xSSjhhbGVVelhyYUpvV1Y0TnFBb0RtYkV2ODgzY0s4MEtYaVV6ekdx?=
 =?utf-8?B?V0hmdjNKWmNQVzBwaDNUdEc1VWhsL3pzUXNUMzA0emdBRkRrVUhtc0Iraitn?=
 =?utf-8?B?WmM0ZjM1V21lUkZGN294Z3Q4YytwMGJuanlzR0pFS21mNG1rQUcvUkFwQzR5?=
 =?utf-8?Q?bMbcLpJHkg9+LiNyXWvMMxyruopEAtbYwCPFef1?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B49F742532268459486F5892A05AC87@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 036a07ca-f4e0-4046-cb85-08d94c326986
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2021 10:29:25.1263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t5PNnOQa3eExpih3STLlsbAhU8ekzoB9Tzka47/C/SSgY7y5TpqwNAHTYzMdguNTFjapegV25lkozhuEK3+ZAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KT24gV2VkLCBKdWwgMjEsIDIwMjEgYXQgMTI6MTc6MTRQTSArMDIwMCwgTWFy
YyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+IEluIHBhdGNoIDhjYTA3MTc2YWIwMCAoIm5ldDogc3dp
dGNoZGV2OiBpbnRyb2R1Y2UgYSBmYW5vdXQgaGVscGVyIGZvcg0KPiBTV0lUQ0hERVZfRkRCX3tB
REQsREVMfV9UT19ERVZJQ0UiKSBuZXcgZnVuY3Rpb25hbGl0eSBpbmNsdWRpbmcgc3RhdGljDQo+
IGlubGluZSBuby1vcCBmdW5jdGlvbnMgaWYgQ09ORklHX05FVF9TV0lUQ0hERVYgaXMgZGlzYWJs
ZWQgd2FzIGFkZGVkLg0KPiANCj4gVGhpcyBwYXRjaCBmaXhlcyB0aGUgZm9sbG93aW5nIGJ1aWxk
IGVycm9yIGZvciBkaXNhYmxlZA0KPiBDT05GSUdfTkVUX1NXSVRDSERFVjoNCj4gDQo+IHwgSW4g
ZmlsZSBpbmNsdWRlZCBmcm9tIGluY2x1ZGUvbmV0L2RzYS5oOjIzLA0KPiB8ICAgICAgICAgICAg
ICAgICAgZnJvbSBuZXQvY29yZS9mbG93X2Rpc3NlY3Rvci5jOjg6DQo+IHwgaW5jbHVkZS9uZXQv
c3dpdGNoZGV2Lmg6NDEwOjE6IGVycm9yOiBleHBlY3RlZCBpZGVudGlmaWVyIG9yIOKAmCjigJkg
YmVmb3JlIOKAmHvigJkgdG9rZW4NCj4gfCAgIDQxMCB8IHsNCj4gfCAgICAgICB8IF4NCj4gfCBp
bmNsdWRlL25ldC9zd2l0Y2hkZXYuaDozOTk6MTogd2FybmluZzog4oCYc3dpdGNoZGV2X2hhbmRs
ZV9mZGJfZGVsX3RvX2RldmljZeKAmSBkZWNsYXJlZCDigJhzdGF0aWPigJkgYnV0IG5ldmVyIGRl
ZmluZWQgWy1XdW51c2VkLWZ1bmN0aW9uXQ0KPiB8ICAgMzk5IHwgc3dpdGNoZGV2X2hhbmRsZV9m
ZGJfZGVsX3RvX2RldmljZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KPiB8ICAgICAgIHwgXn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiANCj4gRml4ZXM6IDhjYTA3MTc2YWIw
MCAoIm5ldDogc3dpdGNoZGV2OiBpbnRyb2R1Y2UgYSBmYW5vdXQgaGVscGVyIGZvciBTV0lUQ0hE
RVZfRkRCX3tBREQsREVMfV9UT19ERVZJQ0UiKQ0KPiBDYzogVmxhZGltaXIgT2x0ZWFuIDx2bGFk
aW1pci5vbHRlYW5AbnhwLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTWFyYyBLbGVpbmUtQnVkZGUg
PG1rbEBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQoNClRoYW5rIHlvdSBmb3IgdGhlIHBhdGNoIGFu
ZCBzb3JyeSBmb3IgdGhlIGJyZWFrYWdlLCBJJ3ZlIGJlZW4gd2FpdGluZw0KZm9yIG15IHZlcnNp
b24gdG8gZ2V0IGFjY2VwdGVkIHNpbmNlIHllc3RlcmRheToNCmh0dHBzOi8vcGF0Y2h3b3JrLmtl
cm5lbC5vcmcvcHJvamVjdC9uZXRkZXZicGYvcGF0Y2gvMjAyMTA3MjAxNzM1NTcuOTk5NTM0LTIt
dmxhZGltaXIub2x0ZWFuQG54cC5jb20v
