Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D0D68C083
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjBFOvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBFOvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:51:00 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CFB25E31
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:50:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvxLjod2TTbSMg6J7wNU4VbUFcHVV5dSJXB45m4J0VmAhDmzzhbpse0wVkwJO1UWy6P50BscGFMfDVxD1o36fiD8D3D3WZw90jA3IhInZNiAjvSi2MA1GiUv1D/6ZHj0b5YT1KLoaMTrKFGWn3sUQ6UWenSlTdMeHsOjbJGCu44isqHrjbfimZCICNjCLOMHk5JMMuik0Yxyk4DGTeW+YayYcsRasgsccmlxnY4/Fdu7opEUx6lMNT1NNOCPgkqUb/pYtAlyfXPSBTWUZu6WJHecnp664jzVRhynizKLfrst1BLJkVTEA2CnYQPOgASDCHyCsTeRAn/3qcQlq9O5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UfUwtSmkrvq+sBemxb+hdaAtgr62QeedYBvrz5CdXQ=;
 b=XxHh680gfPqp8p23H/wgS3kRHdylVfCFGorBR501rYHyYecoLK8bgMO/YxcseFA9DgOuJR8OFUDnd+NH/ZGZ+vU0CWdXuyGXom5c89ji12j+WvUjWG2RdAR9Lm3QYF/93r5jkm3uF7EGPVhtNpfMosmtLGjEqKuGbSWT4MWOnkKD7Y/VLk9ccaxZJukPHOChubFU4JEi5mzTJEv8HKV2jLU+We0nBQNFTRP9lsCB9ZtTBq/v2v/LgAl01QI1o0ILL+8XZ0qTPHgcz4SM1SLuvAEIs89rjg70iXvWmP877ZjE1d1clBziGVRr2p/CYyynAERrRm++PZv3tS9Ro1fGQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UfUwtSmkrvq+sBemxb+hdaAtgr62QeedYBvrz5CdXQ=;
 b=Xle0NLbC/gJ7kNCOvTyiNtZC640TEcCusef32gGw0mDeRPXvIgmJVH+CRMG+iyljM5+MT+lYi8kyzSc0mgHPfCx3OYFdBGl00+jPWj5HKexo6pINXrlQSBIfadpGIkPQRkuJZzrBZ1Yr5lGSi2iUY60L+n07b5mt62m64cTzx92a5et4VhDhVVhajrb7e3PCvH66hWbwarUMTeJ9v75rzAZJkOacY3HO22/RXvOBJslh0cBDjelUozXYW/8eBkpXVbGTG/oDT91fq8E+f+AJIEPStbNH7qPm6iG7muv3SvVglzV0zdFNFUjlvbYrKwzMU466AVz1siTEqa+YmhjERA==
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:138::9)
 by DU0PR10MB7531.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 14:50:55 +0000
Received: from DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0]) by DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8ab5:2969:2854:63f0%6]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 14:50:55 +0000
From:   "Valek, Andrej" <andrej.valek@siemens.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DSA mv88e6xxx_probe
Thread-Topic: DSA mv88e6xxx_probe
Thread-Index: AQHZNxmfDlWccw5bT0qZPgjeOkJESa69P8iAgAAOzgCABLgIgA==
Date:   Mon, 6 Feb 2023 14:50:54 +0000
Message-ID: <23fc6ed6d91cb3fa528976b782a6d2605bbf17dd.camel@siemens.com>
References: <cf6fb63cdce40105c5247cdbcb64c1729e19d04a.camel@siemens.com>
         <Y9vfLYtio1fbZvfW@lunn.ch>
         <af64afe5fee14cc373511acfa5a9b927516c4d66.camel@siemens.com>
         <Y9v8fBxpO19jr9+9@lunn.ch>
         <05f695cd76ffcc885e6ea70c58d0a07dbc48a341.camel@siemens.com>
         <Y90SA/8RzaRCvna8@lunn.ch>
         <3669ddc5bead14b0d400c92adb8f95850ef4ec1b.camel@siemens.com>
In-Reply-To: <3669ddc5bead14b0d400c92adb8f95850ef4ec1b.camel@siemens.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB8PR10MB3977:EE_|DU0PR10MB7531:EE_
x-ms-office365-filtering-correlation-id: 0845b06e-ccf0-41a0-6f0d-08db08518ccb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4vLCfpmKWy/tvKGQf+Ofs2MatZD8RiUd7xyJhnn4WRv7F6HoVmdyY+y8JczeLIS0AjM5xj1IdQFkWjVTWiVhKv61UpQM9unjfdqioSCVUkgS9A+NhFz+1jgbpdHP/kx0R9aGDMM84RVPBenKhH3yZHqnYfXlvqpwKpjSXP+hOi3PvSo9CnMQii05WW4W/4qN1ALH7YIl+Lw0m11BQhJC6jWb7FQ7XDn8fcT+PDtfcKMC7vdHc1NEodxu907vobo8kjy/eReSkmBe9shrStjxeRWHKqOkiiO5F6GSECYFYPaWc4GrhjaNUFzdy7oyFwpkvRdlZ5K+gt65zPKkkUQi+d5glN/7MjzrquoUr6457t5NZWod616ITeYveF7+OGyE3+DRkTpH8XEifDKmsAsHpy5muBmWhwYCHGPv/NbBf19Ie2VpUU5sdzWA9OLsUV/dytdSMoGO0odlPfJgoddxnaCvcCbLGuDMip9RMjCX3EG6fp+YmPr1jOI7UNx94fqbrzKFpydlZViHEOcHXuB+yjF0Xj6mtn98g6vpH5rpk0FuGgi2QYr3K8Ij4TOBNvc8K4SpqhDhUc8oKAoyZ6a3EXXPxhXWikn4bg8xVzZiDRA5TVkQDBAVIJQY7CVONTBMj1Lgyf9Vi8jNBWfXKY3y5fEkrapH+0jpi4Nc4ZFx6SSw3Vgx1pKFYBq+WFtTL0cBiatQCE6Jq6HsKgokZLPeELUQkwLrsyURVAIkwmt9ZAk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199018)(36756003)(54906003)(71200400001)(316002)(8676002)(6506007)(6486002)(966005)(91956017)(4326008)(5660300002)(66556008)(66476007)(7116003)(66446008)(2906002)(64756008)(6916009)(41300700001)(66946007)(8936002)(76116006)(478600001)(26005)(82960400001)(38070700005)(122000001)(38100700002)(86362001)(6512007)(83380400001)(186003)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0daUHoxWTc2RlV5VnNuSEM1UWt5VVpOa3pkMVEvY1BWdVFoY3lic3NRRnlJ?=
 =?utf-8?B?UnFjK2k5NldOY05SUkZYQkN5aVYzNGV6YVpjRTI3akYvUEY4Q2lHa25MRFl5?=
 =?utf-8?B?WHFIRDVKMzhkVDUxWlNKZWIvcHNiTUhrZWhJTXdmNE1xMTYzbTlqMmhiMFpH?=
 =?utf-8?B?TWVDU3cyd2tZaCtWcDFyUlNPNUZDSHFubVkrV2VwYy9MSllWa2VlcmFvcjEr?=
 =?utf-8?B?WkE5Q09IeGhXWGhKRVVKOTR0NFdISjR4T1VNa3RoZi96Q0VpMUxCUk9mOW9z?=
 =?utf-8?B?c29XVXdYV2dqWGJ4R3o4elZxL2tRekxCZmg4aE1NNnRBaXd2OVhub0tSVnd3?=
 =?utf-8?B?cGZMOE5yRjJIUUluZXVhQ1A2UEhZZExyTGhNTzBsMmxxbS9EN3hCeUNMQW5R?=
 =?utf-8?B?SFZqVnRWM1ZRNDBnWGRJSWJTYTVhWkVxTm8ydTRuVUR2cHJSc1JyU2JIMDZK?=
 =?utf-8?B?NTRvSXpVVzVXSHpRMXIyUktRYTM0VzVTc29GQ0RtMlNFMHBaT3NpQ2ErQVdC?=
 =?utf-8?B?NGp0cU1uZ010ZmhWbkZMOE52aFpPd21hSzdrSCswdG14Wk0rWGxzeXFZekxw?=
 =?utf-8?B?TzFDK0pYb1AyWWpSUlRVNlFEUDlHbWg0a2ZFbUNKNjlZT2kxREhMT1l4c29r?=
 =?utf-8?B?WndrYmcxRVJxVHVLTGZ0NkFJNWRGRHM1MnVrbDcwdzQ1QWg3Sm0rU0xmRmtC?=
 =?utf-8?B?d2wyVGVyMUpDMjJwZlRPL2kxNTFOSjFjbUxuK29Kb0EzdlNpNDBDSDUxNkRG?=
 =?utf-8?B?dnlGNG5LTHU0OUxqKzluaDhNSlBhWVlFaU5lM0pyTjlQMHZON2VVRUo3c2Nj?=
 =?utf-8?B?WXp0SitpMHJPTTRObmdUQUZIMitReWFIdGhjeHpyaUZ1bnUybXpYdUtxZkwy?=
 =?utf-8?B?Q2RKZzRpcHI2bHJ4SzdwYVBkTThiQUs4eHpYcTd6ZHZxZU52TjZjbXg1QkN1?=
 =?utf-8?B?VU05T2tWSndQTS9oT2k0aE85SmdPYXh6VFdNUHlSNHROaHBBQzBhWnAzOFZP?=
 =?utf-8?B?enE3TnlhVjFWM3FOU2Y4eDlHM2dsUkpub1VjalpOM2FQSVkrQnNWWk1NeXUx?=
 =?utf-8?B?M0VPSTd5cnFRbFlCWFpuSGQyVXg0dGZJeXdiQ2IybWVMZWtiM0NzVk9NaEtL?=
 =?utf-8?B?bjZKRnVXS05HZW5OQmVkWlIyOXE1YllZcWVseHI1clFRTWpwU2tiWDN5bGlL?=
 =?utf-8?B?ZkRSb2hyUVJ3L25JRkRUczN1RVZmRlc3Zi85OW8xclFSVUV3RnNCVS80eWxJ?=
 =?utf-8?B?QkVOa25mUi9OdW9FQ01VZ2FTbXJZMUUrN1ZaMTFkUldhV3pVaG9UNmNmZ0xE?=
 =?utf-8?B?dlRrMFo4M1ljdjkxQVEreXBiT1RtUG5qM01lR2hEYXVxL2UwVFp6enJ1dXNZ?=
 =?utf-8?B?VVF1WXE0ZWM5VFRVbFZoSldxclFDNjYrVHhCZEQ3QUlZWHNENEhGOS9CYUNr?=
 =?utf-8?B?Z1RuYVA0N2plSlBXZnZLbXB0WVdXODZYUGpYRVJQelR4R3hOYWtFYWFIY1Jo?=
 =?utf-8?B?VHZBcURmREMvblFKdkNnaG55Qk9ObTlDeGpaY0RuWnNLaG5xRmJ3TDNFS1hh?=
 =?utf-8?B?c1pHZmtoZXdOcVRSSE54Tkg5TmYzZEd5QzFyVkpKZ2I1bnF0RW1LN2dEQ2lG?=
 =?utf-8?B?a2g2Y2ErY0Zjb0U0RWZRS3M0M0NFUXh1ejkxODBGbDFDRjdQY3BhZVpNTStB?=
 =?utf-8?B?eXE5R0liQ25IVFVzbG5Wb1FpUnlPRTB2ZFlFZlpFa3BJSTNpd1p4YjhVeXVC?=
 =?utf-8?B?ZkNvdHhpMDV6TE1PRWQyZnVKVkNCU3hhMjQySGpreHo5OHVvSnZyLzZvTFY3?=
 =?utf-8?B?TFZNVGtnZUkyTTFwNjhhZGdialdQYXQwUDIwai81dEd3ckNhWXVjK1p3K01O?=
 =?utf-8?B?ek1zYW5nSHBuZFk5NkxkcVR1UEtPZnRRY1JvTlZBd2J2YzQxSll1Yi9odzJQ?=
 =?utf-8?B?ZlYxMmtCRmZETko2MWZScyt0UFM1cks4Mnk2dFR4SVI4WFJod0NXSnhJcTJX?=
 =?utf-8?B?bUNhSGVZVHgvVDczWGtUOHI2eGp0eDBvdzZHRlhjSGdIYUd0VXMxODNTUXJI?=
 =?utf-8?B?WE5jeUp2bnVFVjRydFVSOXROTmlNOE9ua2IzN2tnUVVrLzJReWJDMktxbElU?=
 =?utf-8?B?aXdYY1R4UkhqSjQ4bUFpMEgxdis2aUdhcGc1UGVtSmlBcmFoaHdhZlZuYVg1?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C1B78ADC1C2C2146BF6493F9856B2BC5@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR10MB3977.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0845b06e-ccf0-41a0-6f0d-08db08518ccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 14:50:55.0260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zxDSD7fVa9UFZk+1j0391CT2eEp2tMWPu8IpopeppAqlSlEf+k+PojBLHpq1zGI5M3+BHhjPWSBbd1yt3EJEp65lCQRMWbM6EryfnoMm/Ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR10MB7531
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gYWdhaW4sCgpJIHB1dCBzb21lIG1vcmUgImRlYnVncyIgdGhlcmUuCgo+IAkvKiBhc3Nl
cnQgYnVzIGxldmVsIFBIWSBHUElPIHJlc2V0ICovCj4gCWRldl9pbmZvKCZidXMtPmRldiwgImdl
dHRpbmcgZ3Bpb2RcbiIpOwo+IAlncGlvZCA9IGRldm1fZ3Bpb2RfZ2V0X29wdGlvbmFsKCZidXMt
PmRldiwgInJlc2V0IiwgR1BJT0RfT1VUX0hJR0gpOwo+IAlpZihncGlvZCkgZGV2X2luZm8oJmJ1
cy0+ZGV2LCAiZ3BpbyBmb3VuZDFcbiIpOwo+IAllbHNlIGRldl9pbmZvKCZidXMtPmRldiwgImdw
aW8gTk9UIGZvdW5kMVxuIik7Cj4KPiAJLyppZiAoSVNfRVJSKGdwaW9kKSkgewo+IAkJZGV2X2lu
Zm8oJmJ1cy0+ZGV2LCAiZ3Bpb2QgZXJyb3JcbiIpOwo+IAkJZXJyID0gZGV2X2Vycl9wcm9iZSgm
YnVzLT5kZXYsIFBUUl9FUlIoZ3Bpb2QpLAo+IAkJCQkgICAgIm1paV9idXMgJXMgY291bGRuJ3Qg
Z2V0IHJlc2V0IEdQSU9cbiIsCj4gCQkJCSAgICBidXMtPmlkKTsKPiAJCWRldmljZV9kZWwoJmJ1
cy0+ZGV2KTsKPiAJCXJldHVybiBlcnI7Cj4gCX0qLwo+Cj4gCWlmIChncGlvZCkgewo+IAkJZGV2
X2luZm8oJmJ1cy0+ZGV2LCAiJXA6Z3Bpb2QgZm91bmRcbiIsIGdwaW9kKTsKPiAJCWJ1cy0+cmVz
ZXRfZ3Bpb2QgPSBncGlvZDsKPiAJCWZzbGVlcChidXMtPnJlc2V0X2RlbGF5X3VzKTsKPiAJCWdw
aW9kX3NldF92YWx1ZV9jYW5zbGVlcChncGlvZCwgMCk7Cj4gCQlpZiAoYnVzLT5yZXNldF9wb3N0
X2RlbGF5X3VzID4gMCkKPiAJCQlmc2xlZXAoYnVzLT5yZXNldF9wb3N0X2RlbGF5X3VzKTsKPiAJ
fQoKQWZ0ZXIgdGhhdCBJIHNlZSBtZXNzYWdlcyBsaWtlOgo+IFsgICAgMS41MzAyNTFdIG1kaW9f
YnVzIDViMDQwMDAwLmV0aGVybmV0LTE6IGRldmljZSByZWdpc3RlcmVkCj4gWyAgICAxLjUzNTg0
MF0gbWRpb19idXMgNWIwNDAwMDAuZXRoZXJuZXQtMTogZ2V0dGluZyBncGlvZAo+IFsgICAgMS41
NDExNTBdIG1kaW9fYnVzIDViMDQwMDAwLmV0aGVybmV0LTE6IGdwaW8gZm91bmQxCj4gWyAgICAx
LjU0NjIxMF0gbWRpb19idXMgNWIwNDAwMDAuZXRoZXJuZXQtMTogZmZmZmZmZmZmZmZmZmRmYjpn
cGlvZCBmb3VuZAo+IFsgICAgMS41Njc5MDBdIGdwaW9kX3NldF92YWx1ZV9jYW5zbGVlcDogaW52
YWxpZCBHUElPIChlcnJvcnBvaW50ZXIpCgpTbyB0aGVyZSBpcyBhIHByb2JsZW0sIHRoYXQgZnVu
Y3Rpb24gImRldm1fZ3Bpb2RfZ2V0X29wdGlvbmFsIiBpcyBub3QgcmV0dXJuaW5nIHRoZSBjb3Jy
ZWN0IHBvaW50ZXIuCgpSZWdhcmRzLApBbmRyZWoKCk9uIEZyaSwgMjAyMy0wMi0wMyBhdCAxNDo0
NyArMDAwMCwgVmFsZWssIEFuZHJlaiB3cm90ZToKPiBPbiBGcmksIDIwMjMtMDItMDMgYXQgMTQ6
NTQgKzAxMDAsIEFuZHJldyBMdW5uIHdyb3RlOgo+ID4gPiA+ID4gVGhpcyBsb29rcyBwcm9taXNp
bmcuIFNvIEkgaGF2ZSB0byBqdXN0IG1vdmUgdGhlICJyZXNldC0KPiA+ID4gPiA+IGdwaW9zIiBE
VEIKPiA+ID4gPiA+IGVudHJ5IGZyb20gc3dpdGNoIHRvIG1kaW8gc2VjdGlvbi4gQnV0IHdoaWNo
IGRyaXZlciBoYW5kbGVzCj4gPiA+ID4gPiBpdCwKPiA+ID4gPiA+IGRyaXZlcnMvbmV0L3BoeS9t
ZGlvX2J1cy5jLAo+ID4gPiA+IAo+ID4gPiA+IFllcy4KPiA+ID4gPiAKPiA+ID4gPiA+ID4gbWRp
byB7Cj4gPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqAjYWRkcmVzcy1jZWxscyA9IDwxPjsKPiA+
ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoCNzaXplLWNlbGxzID0gMD47Cj4gPiA+ID4gPiB3aGls
ZSBoZXJlIGlzIG5vIGNvbXBhdGlibGUgcGFydC4uLiAuCj4gPiA+ID4gCj4gPiA+ID4gSXQgZG9l
cyBub3QgbmVlZCBhIGNvbXBhdGlibGUsIGJlY2F1c2UgaXQgaXMgcGFydCBvZiB0aGUgRkVDLAo+
ID4gPiA+IGFuZCB0aGUKPiA+ID4gPiBGRUMgaGFzIGEgY29tcGF0aWJsZS4gUmVtZW1iZXIgdGhp
cyBpcyBkZXZpY2UgdHJlZSwgc29tZXRpbWVzCj4gPiA+ID4geW91IG5lZWQKPiA+ID4gPiB0byBn
byB1cCB0aGUgdHJlZSB0b3dhcmRzIHRoZSByb290IHRvIGZpbmQgdGhlIGFjdHVhbCBkZXZpY2UK
PiA+ID4gPiB3aXRoIGEKPiA+ID4gPiBjb21wYXRpYmxlLgo+ID4gPiA+IAo+ID4gPiA+IMKgwqDC
oCBBbmRyZXcKPiA+ID4gSSB0cmllZCBwdXQgdGhlICJyZXNldC1ncGlvcyIgYW5kICJyZXNldC1k
ZWxheS11cyIgaW50byBtdWx0aXBsZQo+ID4gPiBtZGlvIGxvY2F0aW9ucywgYnV0IG5vdGhpbmcg
aGFzIGJlZW4gd29ya2luZy4gRFRCIGxvb2tzIGxpa2UKPiA+ID4gdGhhdDoKPiA+ID4gCj4gPiA+
ID4gJmZlYzEgewo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqBwaW5jdHJsLW5hbWVzID0gImRlZmF1
bHQiOwo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqBwaW5jdHJsLTAgPSA8JnBpbmN0cmxfZmVjMT47
Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHBoeS1tb2RlID0gInJnbWlpLWlkIjsKPiA+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgdHgtaW50ZXJuYWwtZGVsYXktcHMgPSA8MjAwMD47Cj4gPiA+ID4gwqDC
oMKgwqDCoMKgwqDCoHJ4LWludGVybmFsLWRlbGF5LXBzID0gPDIwMDA+Owo+ID4gPiA+IMKgwqDC
oMKgwqDCoMKgwqBzbGF2ZXMgPSA8MT47wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAvLyB1c2Ugb25seSBvbmUgZW1hYyBpZgo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqBzdGF0
dXMgPSAib2theSI7Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoG1hYy1hZGRyZXNzID0gWyAwMCAw
MCAwMCAwMCAwMCAwMCBdOyAvLyBGaWxsZWQgaW4gYnkgVS0KPiA+ID4gPiBCb290Cj4gPiA+ID4g
Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoC8vICMjIyMgMy4gdHJ5ICMjIyMKPiA+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgLy9waHktcmVzZXQtZ3Bpb3MgPSA8JmxzaW9fZ3BpbzAgMTMgR1BJT19BQ1RJ
VkVfTE9XPjsKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgLy9yZXNldC1kZWxheS11cyA9IDwxMDAw
MD47Cj4gPiA+ID4gCj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoGZpeGVkLWxpbmsgewo+ID4gPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3BlZWQgPSA8MTAwMD47Cj4gPiA+ID4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBmdWxsLWR1cGxleDsKPiA+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgfTsKPiA+ID4gPiAKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgbWRpbyB7Cj4g
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAjYWRkcmVzcy1jZWxscyA9IDwx
PjsKPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCNzaXplLWNlbGxzID0g
PDA+Owo+ID4gPiA+IAo+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLy8g
MS4gdHJ5Cj4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXNldC1ncGlv
cyA9IDwmbHNpb19ncGlvMCAxMyBHUElPX0FDVElWRV9MT1c+Owo+ID4gPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmVzZXQtZGVsYXktdXMgPSA8MTAwMDA+Owo+ID4gCj4gPiBU
aGlzIGxvb2tzIGxpa2UgdGhlIGNvcnJlY3QgbG9jYXRpb24uIEhhdmUgeW91IHB1dCBhIHByaW50
aygpIGFmdGVyCj4gPiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC9sYXRlc3Qvc291
cmNlL2RyaXZlcnMvbmV0L3BoeS9tZGlvX2J1cy5jI0w1NjkKPiA+IHRvIG1ha2Ugc3VyZSBpdCBo
YXMgZm91bmQgaXQ/Cj4gPiAKPiBZZXMsIEkgcHV0IHRoZXJlIG11bHRpcGxlIHByaW50ay1zLi4u
IC4KPiA+IMKgwqDCoMKgwqDCoMKgwqBkZXZfaW5mbygmYnVzLT5kZXYsICJkZXZpY2UgcmVnaXN0
ZXJlZFxuIik7Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqBtdXRleF9pbml0KCZidXMtPm1kaW9f
bG9jayk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgbXV0ZXhfaW5pdCgmYnVzLT5zaGFyZWRfbG9jayk7
Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqAvKiBhc3NlcnQgYnVzIGxldmVsIFBIWSBHUElPIHJl
c2V0ICovCj4gPiDCoMKgwqDCoMKgwqDCoMKgZ3Bpb2QgPSBkZXZtX2dwaW9kX2dldF9vcHRpb25h
bCgmYnVzLT5kZXYsICJyZXNldCIsCj4gPiBHUElPRF9PVVRfSElHSCk7Cj4gPiDCoMKgwqDCoMKg
wqDCoMKgZGV2X2luZm8oJmJ1cy0+ZGV2LCAiZ2V0dGluZyBncGlvZFxuIik7Cj4gPiAKPiA+IMKg
wqDCoMKgwqDCoMKgwqBpZiAoSVNfRVJSKGdwaW9kKSkgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBlcnIgPSBkZXZfZXJyX3Byb2JlKCZidXMtPmRldiwgUFRSX0VSUihncGlv
ZCksCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgICJtaWlfYnVzICVzIGNvdWxkbid0IGdldCByZXNldAo+ID4g
R1BJT1xuIiwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYnVzLT5pZCk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGRldmljZV9kZWwoJmJ1cy0+ZGV2KTsKPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGVycjsKPiA+IMKgwqDCoMKgwqDCoMKgwqB9IGVsc2XC
oMKgaWYgKGdwaW9kKSB7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldl9p
bmZvKCZidXMtPmRldiwgImdwaW9kIGZvdW5kXG4iKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgYnVzLT5yZXNldF9ncGlvZCA9IGdwaW9kOwo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBmc2xlZXAoYnVzLT5yZXNldF9kZWxheV91cyk7Cj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdwaW9kX3NldF92YWx1ZV9jYW5zbGVlcChncGlvZCwg
MCk7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChidXMtPnJlc2V0X3Bv
c3RfZGVsYXlfdXMgPiAwKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZnNsZWVwKGJ1cy0+cmVzZXRfcG9zdF9kZWxheV91cyk7Cj4gPiDCoMKgwqDC
oMKgwqDCoMKgfQo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGJ1cy0+cmVzZXQpIHsKPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2X2luZm8oJmJ1cy0+ZGV2LCAicmVz
ZXQgZm91bmRcbiIpOwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIgPSBi
dXMtPnJlc2V0KGJ1cyk7Cj4gCj4gQW5kIHRoZSBvdXRwdXQgbG9nIGxvb2tzOgo+ID4gW8KgwqDC
oCAxLjQ0NjA5NV0gbWRpb19idXMgZml4ZWQtMDogZGV2aWNlIHJlZ2lzdGVyZWQKPiA+IFvCoMKg
wqAgMS40NTA2OThdIG1kaW9fYnVzIGZpeGVkLTA6IGdldHRpbmcgZ3Bpb2QKPiA+IFvCoMKgwqAg
MS40OTQ4NzBdIHBwcyBwcHMwOiBuZXcgUFBTIHNvdXJjZSBwdHAwCj4gPiBbwqDCoMKgIDEuNTA1
ODg4XSBtZGlvX2J1cyA1YjA0MDAwMC5ldGhlcm5ldC0xOiBkZXZpY2UgcmVnaXN0ZXJlZAo+ID4g
W8KgwqDCoCAxLjUxMTU1Ml0gbWRpb19idXMgNWIwNDAwMDAuZXRoZXJuZXQtMTogZ2V0dGluZyBn
cGlvZAo+ID4gW8KgwqDCoCAxLjU1MDcwNV0gcHBzIHBwczA6IG5ldyBQUFMgc291cmNlIHB0cDAK
PiA+IFvCoMKgwqAgMS41NjEyMDNdIG1kaW9fYnVzIDViMDUwMDAwLmV0aGVybmV0LTE6IGRldmlj
ZSByZWdpc3RlcmVkCj4gPiBbwqDCoMKgIDEuNTY2NzkxXSBtZGlvX2J1cyA1YjA1MDAwMC5ldGhl
cm5ldC0xOiBnZXR0aW5nIGdwaW9kCj4gPiAuLi4KPiA+IFvCoMKgwqAgMi41NjgxNzRdIGZlYyA1
YjA1MDAwMC5ldGhlcm5ldCBldGgwOiByZWdpc3RlcmVkIFBIQyBkZXZpY2UgMAo+IAo+IFNwIHRo
ZXJlIGFyZSBvbmx5IGEgImRldmljZSByZWdpc3RlcmVkIiBhbmQgImdldHRpbmcgZ3Bpb2QiIG1l
c3NhZ2VzCj4gYW5kIG5vciAiZ3Bpb2QgZm91bmQiIGFuZCAicmVzZWQgZm91bmQiLgo+IFNvIG5v
dyB0aGUgcXVlc3Rpb24gaXMgd2h5IGl0IGRpZG4ndCBmaW5kIHRoZSByZXNldCBpbiBkdGIsIG9y
IHdoZXJlCj4gdG8gcGxhY2UgaXQuCj4gCj4gQW5kcmVqCj4gCj4gPiBZb3UgbWlnaHQgYWxzbyBu
ZWVkIGEgcG9zdCByZXNldCBkZWxheS4gSSdtIG5vdCBzdXJlIHRoZSBkZXZpY2UKPiA+IHdpbGwK
PiA+IGFuc3dlciBpZiBpdCBpcyBzdGlsbCBidXN5IHJlYWRpbmcgdGhlIEVFUFJPTS4gV2hpY2gg
aXMgd2h5IHRoZQo+ID4gbXY4OGU2eHh4IGhhcmR3YXJlIHJlc2V0IGRvZXMgc29tZSBwb2xsaW5n
IGJlZm9yZSBjb250aW51aW5nLgo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqAgQW5kcmV3Cj4g
Cgo=
