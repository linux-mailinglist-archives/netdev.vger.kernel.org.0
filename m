Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D7651993E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 10:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346042AbiEDIK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 04:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346036AbiEDIKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 04:10:25 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A728222B8
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 01:06:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lo/Gwt2WlDpAT/UH8Ktsv7js1OgbVD3SXqnOU4xOzhsh6dU5xf5KxwQGp+lohvDHTPd2tc+6Pbd/2LVfZNmM1u5CGv1vTnEQ/wLr2k7X83JjszVyxR1gkrPBn0HPSNQIeY41NrTPnhA7UzrCVszrKPQZRMi4bY0H9/0IPFu5HKlPiHfTHf5tlXw9aPj/RkIdOfJqhpRCBt5IunQ1H9X7j7FEsCSrzE7yagDGDQom+OubPNtGtAwhfKjwGy1u9Su2MmxG9wLyCANU3yMx/3xmn0fjK0Pn4x/E/aO4IYr64JawKUcCpG4foskwCYrwP+puYg87JOiEyzuSWi41ixoewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+cSCrLb5D6kSJIo/5DroYBEUJmPLe6Cfxtnwdid4U0=;
 b=YZBQ5e98SOpDm5GvYcoQwG3/rdSdTHFitG9yZpZHrIPBu/kx3QCqRSGuh0Xe2eCnRulKa4AVpkkRQWBCtV2y1E/Mi6SHKtCLm2FvlEeZSNCCkF0LMG/w4uRlF5EptMyA98xa8HzQnQiKF50YaSsRcjS/9vy+vjsHBgWtY5gt1VidEUuJ4qklwvjpkYVU1NPMWfgU27n2zidI9YhhBxQa3z82Nwse9K/AJNmsmtFPAuCMmiBt9rgdf3yDg7dP6sejeetDQHiKr5OuH2+C+rkbR7nLGbFqilTSy+haRe1McaaN+HYQrzqtnwTl1zeIpfWt6EKvX7hIQgIZiYsejufP2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+cSCrLb5D6kSJIo/5DroYBEUJmPLe6Cfxtnwdid4U0=;
 b=PrRlGTMAIeWKR4hhxt6WWUmHPrNkdpkIuYWgKLL8WYMtZSklHDbcRMiwQF3DJeCS/NON7o3Qd7Xj+7tKAmn3NE6KJfsEguGxFn1+DYf37EWWjue7mMSS/rOUFAZyJKSETDU17r7587a4PUNpCJiZtQ1mrHHGiONyX0Bz4Z7WFtc=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM6PR04MB6647.eurprd04.prod.outlook.com (2603:10a6:20b:f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Wed, 4 May
 2022 08:06:47 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::482e:89a:5ef4:21fd%6]) with mapi id 15.20.5186.021; Wed, 4 May 2022
 08:06:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [regression] dpaa2: TSO offload on lx2160a causes fatal exception
 in interrupt
Thread-Topic: [regression] dpaa2: TSO offload on lx2160a causes fatal
 exception in interrupt
Thread-Index: AQHYX4sgSGttsWNE0UqPktXtQunnrq0OXLUA
Date:   Wed, 4 May 2022 08:06:47 +0000
Message-ID: <20220504080646.ypkpj7xc3rcgoocu@skbuf>
References: <7ca81e6b-85fd-beff-1c2b-62c86c9352e9@leemhuis.info>
In-Reply-To: <7ca81e6b-85fd-beff-1c2b-62c86c9352e9@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22f79d27-5b8b-40da-5688-08da2da5092c
x-ms-traffictypediagnostic: AM6PR04MB6647:EE_
x-microsoft-antispam-prvs: <AM6PR04MB6647644D400E3B7B6EBE1133E0C39@AM6PR04MB6647.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7G/lOZEX//NKbdsEnkV+EDoGL6wsMY2ExK9zQOdV89+bPS/1KNMUwwn/Rec5MA5U55dVV6oRB8zwyJOM+poiG2ujqJfNxCsrUYW8b+NK/ecS6nOBu3S4h/+uvi5QWU+TCLfMhhgycs4oLKMPWu67l51ZeQnphL5NseL2wdEbIFQddgr2nB1/W8v6pcToOcZu9OYKo87zpl6Vrs87eUMhZh1ags1ZgbAQyUq4p4VZjDKQhFQj/JgQBShrQWQMDqfCLPvlI0MKq+KyH3jYGVbEA9/Uk/Wc4aaMcfYmHQt45t/h34pn28tgLuD1MKBi1jue8HWPR/xzEdL3B7DfXRC2n4vv6e8xV5zAqp17IQTGSYj3BWAe/D5ZsL2mYyVnmPKqeLsbNDuG34J20pV+JepP2gu0vGle1lEqX7A9Bifsf6pJQHB9WvV7yo+dz333hbZuY0zZtBbxmUQPqZ+Yo33Y+BlAOApnT5XfyyZPx3fgGQuhozMFbFm7y7ok/qyC3nDaGf2uwz9VY8hX/2Ml4WzaNJ9qoHunxRi5M+npdzryHrqFNqJHm1YflUnCUNhD7E9sDMWbo4rEeJ3A/88Xy+eFD9SYyG4LlHnumNcwAhZCWHu7nGOesPUHtvB8mSoOoDl4gymETJnL8bvgRidC2H9w+tYBWneYFJZCaslQ3vfijVVKSv2xPjYwVWqgH2fmTJDXvz+CBW1+NVke/Vel5qWo65UzHHwfXZIOXF6VkGxXlVySX8O9vjzVtTVVfKR6iEB85ikepFFdWWlFOibOwC80VRYdWiNTt0asHdkFTS4K7UQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(2906002)(122000001)(6506007)(71200400001)(8676002)(966005)(26005)(6486002)(508600001)(38070700005)(38100700002)(66946007)(76116006)(9686003)(4326008)(66476007)(6512007)(64756008)(66556008)(66446008)(91956017)(86362001)(8936002)(5660300002)(316002)(33716001)(186003)(44832011)(83380400001)(6916009)(54906003)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q3VvQVU1aHRCVmpYMG44bzVnejZOSGJickxuSldUMS84SXNuNnFKTzFBNzVy?=
 =?utf-8?B?NEQrV3dEUWNqU0F5VzFjU21sb254bDg1STBFYWlvZmtGRmdZRGE0bi9tR2sy?=
 =?utf-8?B?UmR2WHhEQjUvNkZRK0VjZzBjVUhoYno4akkrbFNmNmEvMU1QcDQxN3ZWai96?=
 =?utf-8?B?VWp3Q0lEQVJDOTNYQjJsemV3N211dFk4aFpUU0hrRWZ6a21jSWZtUXVTa3lh?=
 =?utf-8?B?bFByOHc1THIzRjlLSFlEM2oxdFltMFZHeHUvREt0Nmh3NnNsSDdpdHZQbWll?=
 =?utf-8?B?UGdrNklNLzMxRzloajJSdC9MVlBFSGREb1VFb2NsOUs0WTUzSzBrT2ZVV1c4?=
 =?utf-8?B?ZjAxdFFrMU14aGNUNnVEUDR2WmtCSDgxTGtrRG5uaXMveVhjK2lOaG9PZVpO?=
 =?utf-8?B?VmRlL2FBVW4rTEFuaXBtSnlPZG1FOG1YVVlwNXFiUjJNbGpnVkFxSlF3NjU2?=
 =?utf-8?B?SGxtYVZaSDZMZ01ZOW1EbTJMZ2Urd05aYko5U1BIUUx5U3crUFZEWFB2US9W?=
 =?utf-8?B?UlpDMGpPTVRXMyt3ZmJKZjg3RytrN0lwa3F6RkN5eVVpSXNFWEJQWmtDTEVY?=
 =?utf-8?B?MXY3OEpBSzRULzNCVFlvNFRjQTBtTzV4YVljbHpSbkVYT1hhbjF1dVAxTDRZ?=
 =?utf-8?B?MWJwSHVhb2dsSEt1SjVqcTBvSzhMSDVVRlMxbUQ0T0tDcXl2bk5WT01CQXZG?=
 =?utf-8?B?VHNPNmkrT1FLMHRrL0J3MHNFWUFTUFVxTzVudjdMU3c2UDY1amwxK3JoRFhK?=
 =?utf-8?B?NmVWR3hkbGdqd3VnZCtlSUxoL0pDaW13SlZPL3BMMUczNXNIb1ZVazg0OXVh?=
 =?utf-8?B?WDE2RC85S0dGcVBuQjlsTVVuaVpmRXBjdFRNOVl1eFJQR3VhM3RIUW4vaFpH?=
 =?utf-8?B?SFY2SGxoUmE5ZWhqclVtaWVRd1hJM3llVER6eVFIbWZMZGRrenEycmlHZmZn?=
 =?utf-8?B?RTdiNmUyOVdJYXdaRXpXdGpZVnZPYVNUcW95MlV4cnRNNVpOZGZyaFI3b0xZ?=
 =?utf-8?B?TkRqRTFZYTFCS1NVUmFLZ3F0WmY4RTM1RUZmZCtmbVV3L0QvZENXdGwwczQ5?=
 =?utf-8?B?U1d1ak5kMkgrMWxIbmNKa0c0TEVCL3gyekZkT2FOSjRRT1pMemxQNk1pRDdI?=
 =?utf-8?B?YThMREFlcTEwNnF4UlRRNk9uQmtYUXFqVFFWcGxRRHFFM1EvT0pvTXprRFBF?=
 =?utf-8?B?c1o2YjVJN2Rkc1hkeCtORUo0VGVxcFBxc1ljR2JNNFFJaERDTkc4ajNTR0ZS?=
 =?utf-8?B?cDZiTjhUVUY4bUNFRFZwSDBEYnU0REU2RUhUeXpLbUg4elhpdEpKVWJPSmNs?=
 =?utf-8?B?cWVveUJLS0RpY2hndEtvMHpoNWxGT0VuTmVBdi9QSVE3ZnkwSmxSTzkvQ0c1?=
 =?utf-8?B?VWhKa0hJNzJZRGcyNGRzcWJDL3cxRjh2ekZRTGYvV0xoR2RpZTh5a09WYUox?=
 =?utf-8?B?djFtVlNWeE85ZlZpamxWOWZueUxmQXdEK0RaaVBWSkpPMXRsS0tLdDRNWWZC?=
 =?utf-8?B?bGlnbWhCKzE3YnZKZk9oL3dibEpidE56WjJtTHFWVzh4WkVPdHhiMzBnaXlU?=
 =?utf-8?B?RTExZEcydzhIekhGOTZxdE9yeU9GTVJFaWdMQ0h5Ykg3UUIva3dzL2RvTHpO?=
 =?utf-8?B?VGJqOGlrenlJVkExSkpJSEFmWEdQTmI5cFd2NDNWQnE0bG1CZ1Zxdy9pckpL?=
 =?utf-8?B?dUVDRFJzeHYvdWxhV3YybEVxRE0ybWhSNG5pZDVYYi9LY0tPcnZBOEJHTVdm?=
 =?utf-8?B?emF2OTRvT2prNkRVN01WWGFndTcyZ1BOcWtwMWFxR1FydkhkYzBOdmkxTHVU?=
 =?utf-8?B?T0FFWWR1ZVRnWnlSZjRtTjcrdFV2dU94MkczY3kwLzdCVUQ4RkhEaUFxMjRk?=
 =?utf-8?B?Mkw4akxvSDlmWXgvcmozaW1wNHhoKzQvSjBMUlNHTDNQK2dOMzhhNldPREc3?=
 =?utf-8?B?SVIrRXZMN0FPK3Vzb1czOWlkZnh6WTRBV2JQNWJVNWVnN081VkFSaERxSzNH?=
 =?utf-8?B?Vit6eHhhUlBLK0hDMHN1R2g3RWVXenBEZ2xyR0s2dFhEYXh0OFhvWUd0ekVS?=
 =?utf-8?B?RmU1bVFpTHpLdWZLY3hJUk5neW1RcU5MTlhOWnFEaCtRc25Ba2NNeEI5ak1H?=
 =?utf-8?B?ckVrTWJYNVE1bzVoOXloNHFScjJLZi9IenJna09uSHRwTEg3Tm4zRVBiWVk1?=
 =?utf-8?B?ZGxlc1JXS3RzdFZFT0l3YVJ5b1pENSs1alFWdm9QaXUxVk1KTXJLZklKaWo0?=
 =?utf-8?B?dW56MVVYcEl1R3U5OCs0NmROK2xraERXam1qb0NQYjBIR1Q2UDJSa3FaZ0hV?=
 =?utf-8?B?UXFrUXdsMStRY0s1aEF1MTJVN25pd3N2Q01QeGpaWFJtQmR3RWpSUFV2ayty?=
 =?utf-8?Q?0imED2OoQBvOY1mU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BC4AC8C6909FC45AAB3F980355B1AE9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22f79d27-5b8b-40da-5688-08da2da5092c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2022 08:06:47.2788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oZVlQVw97oMPvPMONiV/GbUa/p06tQlvTrrSnApA0kH7JjVlIUH1QnbhG36L9pRumx9oVfE2/5zzNy3aDBvM6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6647
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBNYXkgMDQsIDIwMjIgYXQgMDk6NDY6NDlBTSArMDIwMCwgVGhvcnN0ZW4gTGVlbWh1
aXMgd3JvdGU6DQo+IEhpLCB0aGlzIGlzIHlvdXIgTGludXgga2VybmVsIHJlZ3Jlc3Npb24gdHJh
Y2tlci4NCj4gDQo+IElvYW5hLCBJIG5vdGljZWQgYSByZWdyZXNzaW9uIHJlcG9ydCBpbiBidWd6
aWxsYS5rZXJuZWwub3JnIHRoYXQgYWZhaWNzDQo+IG5vYm9keSBhY3RlZCB1cG9uIHNpbmNlIGl0
IHdhcyByZXBvcnRlZCBhYm91dCBhIHdlZWsgYWdvLiBUaGUgcmVwb3J0ZXINCj4gKnN1c3BlY3Rz
KiBpdCdzIGNhdXNlZCBieSBhIHJlY2VudCBjaGFuZ2Ugb2YgeW91cnMuIA0KDQpJIHdhcyBub3Qg
YXdhcmUgb2YgdGhpcyByZWdyZXNzaW9uIHJlcG9ydCwgdGhhbmtzIGZvciBsZXR0aW5nIG1lIGtu
b3cuDQoNCj4gVGhhdCdzIHdoeSBJIGRlY2lkZWQNCj4gdG8gZm9yd2FyZCBpdCB0byB0aGUgbGlz
dHMgYW5kIGFsbCBwZW9wbGUgdGhhdCBzZWVtZWQgdG8gYmUgcmVsZXZhbnQNCj4gaGVyZS4gVG8g
cXVvdGUgZnJvbSBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIx
NTg4Ng0KPiANCj4gPiAga2VybmVsYnVnc0A2M2JpdC5uZXQgMjAyMi0wNC0yNSAxODoxNTozOCBV
VEMNCj4gPiANCj4gPiBOZXR3b3JrIHRyYWZmaWMgZXZlbnR1YWxseSBjYXVzZXMgYSBmYXRhbCBl
eGNlcHRpb24gaW4gaW50ZXJydXB0LiBEaXNhYmxpbmcgVFNPIHByZXZlbnRzIHRoZSBidWcuIExp
a2VseSByZWxhdGVkIHRvIHJlY2VudCBjaGFuZ2VzIHRvIGVuYWJsZSBUU08/DQo+ID4gDQo+ID4g
Q3Jhc2g6DQo+ID4gDQoNCjxzbmlwPg0KDQo+ID4gTWl0aWdhdGlvbjoNCj4gPiBldGh0b29sIC1L
IGV0aFggdHNvIG9mZg0KPiA+IA0KPiA+IFtyZXBseV0gW+KIkl0gQ29tbWVudCAxIGtlcm5lbGJ1
Z3NANjNiaXQubmV0IDIwMjItMDUtMDIgMDE6Mzc6MDYgVVRDDQo+ID4gDQo+ID4gSSBiZWxpZXZl
IHRoaXMgaXMgcmVsYXRlZCB0byBjb21taXQgM2RjNzA5ZTBjZDQ3YzYwMmE4ZDFhNjc0N2YxYTkx
ZTk3MzdlZWVkMw0KPiA+IA0KPiANCj4gVGhhdCBjb21taXQgaXMgImRwYWEyLWV0aDogYWRkIHN1
cHBvcnQgZm9yIHNvZnR3YXJlIFRTTyIuDQo+IA0KPiBDb3VsZCBzb21lYm9keSB0YWtlIGEgbG9v
ayBpbnRvIHRoaXM/IE9yIHdhcyB0aGlzIGRpc2N1c3NlZCBzb21ld2hlcmUNCj4gZWxzZSBhbHJl
YWR5PyBPciBldmVuIGZpeGVkPw0KDQpJIHdpbGwgdGFrZSBhIGxvb2sgYXQgaXQsIGl0IHdhc24n
dCBkaXNjdXNzZWQgYWxyZWFkeS4NCg0KSW9hbmE=
