Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2743B884F
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 20:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhF3S0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 14:26:23 -0400
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:3622 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232358AbhF3S0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 14:26:23 -0400
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 15UDhsoO015624;
        Wed, 30 Jun 2021 14:23:48 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com with ESMTP id 39gsrm072x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Jun 2021 14:23:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fylen9LYpXXe0EIGLPgfsHUVNGzZ1DIZusG0WBrZEzjl+THMttD5MfZK6vU63YZ6bUgwwDyODs+Sni0XKisog3Jj09t6LErksWCMvjAmbitUbiMY2K/DueZesF/800oJaJZoiczSV/qoZhME8dQDCpamvj6rp5VfFn0zncmpi0aNYEWpDvzlQZjPJH69Hg9BTMdJ1dEvf8CdwT3BpCH6ssBL0HYjXigGbatEN8tLlkkM3zeoLzhj6OF4pYGNWK9LJb6CzdqwNRwQiLGtits3Coy3/qFG+ILrwWM8t+AJpV6qAhDkKZdQ3adQLuLnw8ahTJIyuq5xJpJGb6DDMqtcBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPc05PwWW/jTAGXOF/+SmdTs6RHOC8hHJNdU4a/Wsjo=;
 b=H50KFxs6tX35/GuV93Joc1JHcSIDHg+D5AoKUu95B0Y/Q3RKbXX25e6LU/uAp8nyHxsjz7Du7dMfonuTMOYasbh+CTfuitbva8adEZFRgwmF6a6Y/w0jAIVJYrZRHn4y/iW/VZv2C5saf3IYurd0fpMRF7HO+WgjyrA5eWlPWrJdWWlDGPMwsoCbVpPMqPqNdOdMHhzGhhr/0YhljUA7PV1+E8gAko5dgYHWEPJzL/sYPDgPM5FmhLrXBe64EjhV/5EoXriWaGGyBQ4IVp8kaMpTN8lxoxKak4RXEFc4O+K2TouO9mSOjofPVM9+6cBNTQTTqfLCJzS/1DyPJgwBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zPc05PwWW/jTAGXOF/+SmdTs6RHOC8hHJNdU4a/Wsjo=;
 b=QZhErD6ASngq8dc7LlJWYA93hqQZ57R/GBqOTTrlo/uNo7Vk8XQCi7meX4QzjkvpTkae73GKfu5MI8YOID5N6PhdrVXj75Za32Dbj8lhvc8CfofV4wgYao3NDdm+4sdOycxBiGiUIbtN4huLM5+YCPX6js5L++AsGuYOp1bcnAs=
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:27::23)
 by YQXPR01MB3541.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.23; Wed, 30 Jun
 2021 18:23:46 +0000
Received: from YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007]) by YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::88bb:860e:2f3a:e007%5]) with mapi id 15.20.4287.023; Wed, 30 Jun 2021
 18:23:46 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net-next] net: axienet: Allow phytool access to PCS/PMA
 PHY
Thread-Topic: [PATCH net-next] net: axienet: Allow phytool access to PCS/PMA
 PHY
Thread-Index: AQHXbdcWRgpOhOeyMUyeZA1aFcNoMqss1CKAgAAKT4A=
Date:   Wed, 30 Jun 2021 18:23:46 +0000
Message-ID: <df768ccb16990f35598d466ad674dfd7b36b8601.camel@calian.com>
References: <20210630174022.1016525-1-robert.hancock@calian.com>
         <20210630174651.GF22278@shell.armlinux.org.uk>
In-Reply-To: <20210630174651.GF22278@shell.armlinux.org.uk>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-17.el8) 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=calian.com;
x-originating-ip: [204.83.154.189]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb5d82ef-0674-4b28-e96c-08d93bf432fd
x-ms-traffictypediagnostic: YQXPR01MB3541:
x-microsoft-antispam-prvs: <YQXPR01MB35413FD7400AB321CAFC398EEC019@YQXPR01MB3541.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ynj65RKs4zPOAF4wdmEwaa3IsWxY4z/IJiO3ClnAzBzVaIe7ddagWxTx+d9crNy8eqOOR3Urb+rSJJAkPpvsAxg/8nrXtHvzEJqn1Ssk6nYD0+mwjONGkoO06C09k5F2z+W+k2XizpBm9evH/uQi7wq8+Em86FQxVgd+8ADBi5rZYtkBiWMlVF03K3PDldPfiyqpLYO+0ibV8aUuWQZDj13zD+2yVg0NTPYl18vwH7Vxi5bURICEdH1fLgvI8xrL65j5PxY0tIcN4ii9XTlZ6+yXEWWUEU/5Bvc1GSOpQCkkAGzxdCYWUvONYu5hJFJuChYQeiQOzhZG59249e8UfZwnDCJPvPjqCzlj4gKeJ1YjeQdeZzUUtjiqRj1OXLcdB5CHoKigJLmjdr9/4E1GwggR2xA2Y0p9euO2dnn7BUUgfQCBnlxb/pw6BPYt5LVCfrMJ/UQgAJdAi9wVgiWDT1NfA1WwrudNeHzegZXC1rxuQJx5T/wZWEWfxLH2HPuavygeXmAGXM9I91NnZdEZPMWLmQNPeOkdganu6ph8QPb/meNtsmgQ84NZk6bVbjbnSt2kTxNH3Ix2B6WWq+XLDPrcCgO0lhxN1NLeKbpEsLmGKgJWTltHhQZDeJXmyODSWLHZXZl462TlkDDmt8UaDCwUB7AzPi7oUh9PF4T1hSmR1Mkqn+FUwMKnXXfblT+Z547o9q874/3Kg+FPtN7wzY2tvYi+d5L9wHKGYo36SwpQV21t/W9TBtgtdaehoqcD/ZS9aLU2/SmjrFPnK4dhur1BlBVUyCj/ZmRnkhbkZ3beUoIbI66rU9rT7vR4yvfwHCl0K6826riOIHKSqtEq6wNEmOis/y94zNQ/8UKwNwM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(36756003)(5660300002)(4326008)(83380400001)(15974865002)(498600001)(6512007)(54906003)(66476007)(66946007)(8676002)(71200400001)(2616005)(6506007)(38100700002)(44832011)(122000001)(64756008)(66446008)(186003)(8936002)(66556008)(26005)(91956017)(2906002)(76116006)(86362001)(6916009)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mi96SFIweVFBc3ZoaUFWbERRbUdiWldjKzlFWjAwWkpWWUFGWGhELzE5SDVI?=
 =?utf-8?B?WE95emg2UThaUG5JRlkvcENNSWcvNjJFOEpRbkZkckhEb1grM2kxNzR6U2oy?=
 =?utf-8?B?aEtkSWZoY3hvOFBVWk5TMklTbmtacDRjcHFNaUdjeFQzUS96TWVzNEpKTGQ3?=
 =?utf-8?B?R2pXUldNZVR5cEFhRFExWU1LL2xreXNiVWN0WUZSamlSTkpGM1ZiUDUwVCt5?=
 =?utf-8?B?VEJ5b1JHRHdzODdaU1R2SFVDamlHOVk1N2NUS1Z4L0V2aDNBTnBkd0F2TktP?=
 =?utf-8?B?eG5GOTB5SDg5T0JldG9qV1gxSER2dkdVdmNDeHZYRkxqNG5Idng4VkZMWlE1?=
 =?utf-8?B?MmZqbEo1bko3ZGlYeE1JLzBham53ZStnRTBDbzdYWTRadUl5TkJFbndwNlhK?=
 =?utf-8?B?Ui91TC9ZSHNaQVJGZ0MvOEdBY2UweEpVc25ySlBzUnNnMFQvMmhON2poamlE?=
 =?utf-8?B?cDNxbFMyMkt3dlpxSmlqUThQNEZvZDcvYmRuUm0vVFJnbnVHSTE4QW1BZmRv?=
 =?utf-8?B?NUl4L3BEdnBvcFRLa1AvYjUyc3lNV0pjZnVtT1VJMFhPYnVvV3hBdVQwQ0hB?=
 =?utf-8?B?OGYyV3hsQ3JxNnpSK2dhUFV6THdyczVaVWkvSlJIZHQyUEN2cjhPL1k4ekJq?=
 =?utf-8?B?YmJYVUFDZExqeHN0NmJVMU1POGNIYU9rSlIyT2luMFZiaGlITFZTNFdvWXIx?=
 =?utf-8?B?S3haSVhPS1VQTkVrc3VWTHFjZm1yaTZCS3JPYUI3cG1iWlNJait4MFNadnEx?=
 =?utf-8?B?bWljdjFtdzY0ZTc1b084WjJSajFBa3BzM0ZaRnpUK0JYOTk3bmxKeGh3R0lX?=
 =?utf-8?B?aWlhdkpFTmlHVzhXb2dBajJWVkNHTXkvMzFlV1RXMWV2bzNLZzNiWW1TL0Nv?=
 =?utf-8?B?YVU5OVFjTDBsUnZReXYrek9MMXNwMmphZTNPVFJTbnNpNnZPWXFtNFkrUVNk?=
 =?utf-8?B?WFJvbUJtdWZ4dno4QjVBcWhqYUZ5S0FaMmw5azUwakowZWVuUS9iSXJIZGNy?=
 =?utf-8?B?MVRZbUJLMVJhbCs3b2h5ajNpdFhucW9UeWZ1MUNrcHIvQ1dvbmE5OUlLT0E1?=
 =?utf-8?B?NXpDU3hDc3JYYjlrRGV4VkRwdTVjcVIyK0U2ejFMcVMzL3Qrc3pSeUNQSys4?=
 =?utf-8?B?dkRjWCtzNjRZY1V4OEpla1ZUbm5XOGdnNlNjeldHRFZsdCtvN0lnUFo5TmFO?=
 =?utf-8?B?ZmpYVnJqK2tLMGJmcHNXUGlrVElEWEsvS1Jva0htamxTblJiWm9KUnlBUS9B?=
 =?utf-8?B?MUhMMU5RWmZ6bXdlMmt4VlZBOHBxVTBLbXlDVFhWZWU2TGRkc2xMaGhXQ3U4?=
 =?utf-8?B?dzdKNGd5czdISndqNE9kZWNhVFJ4Q1U1bzljdy9TSzlLalkvWktPNndxTUtt?=
 =?utf-8?B?ajh6QWhEaDVqS0RQZThCbHVYR3dINnJ5b2krMzhWR1dZN1M1KytxemVLMzZ6?=
 =?utf-8?B?V3lGL1B6RDE5bC9pbTRBMUdodTRETVl0YWRGdWdRajRNM2tDeTFMOXlKQWYx?=
 =?utf-8?B?SUxlV0NXU0VCWjg1bE8yVEtVemhERVl0aHJiYy9yUkNINTdNUThOUnY4MThK?=
 =?utf-8?B?RTFuVnZHZEpRbEVLbkNObnJCVEdTenpKazF2VnhFcGxzRGttWnZZa3h0MWhZ?=
 =?utf-8?B?UXVlUEtzSXp4eVhlU1F0cWVqMzFNWjVUajNBV2lTZW5iWm1GaVJ3a2pnQXJ3?=
 =?utf-8?B?SmVDY0IxcTc5c0Y5NGE3ZzgwUThtaTA0QWV5UnVXbVFubDNYMGRpTTFzQUZ4?=
 =?utf-8?Q?2hpc5VL3m0torTh0a+y7mqLCOryGunWGanIOUiO?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <18DD9A4D32243144B2BA06DC2F79B900@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YQXPR01MB5049.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5d82ef-0674-4b28-e96c-08d93bf432fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2021 18:23:46.2290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NUajAKEFDFYuLT46RGeKePh3iYRyuKYIDWgwQyGl1lMNLNg5UyBvLrwzj1XqX4cJsYNRIBZm+vlqTHqVQXu6jtUgpUxpI14K96xJIPfBSVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3541
X-Proofpoint-GUID: aBnIjW6C4puOHdwImRrkJBa9j048TL5y
X-Proofpoint-ORIG-GUID: aBnIjW6C4puOHdwImRrkJBa9j048TL5y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-06-30_08,2021-06-30_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=771 malwarescore=0 clxscore=1015 impostorscore=0
 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106300101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA2LTMwIGF0IDE4OjQ2ICswMTAwLCBSdXNzZWxsIEtpbmcgKE9yYWNsZSkg
d3JvdGU6DQo+IE9uIFdlZCwgSnVuIDMwLCAyMDIxIGF0IDExOjQwOjIyQU0gLTA2MDAsIFJvYmVy
dCBIYW5jb2NrIHdyb3RlOg0KPiA+IEFsbG93IHBoeXRvb2wgaW9jdGwgYWNjZXNzIHRvIHJlYWQv
d3JpdGUgcmVnaXN0ZXJzIGluIHRoZSBpbnRlcm5hbA0KPiA+IFBDUy9QTUEgUEhZIGlmIGl0IGlz
IGVuYWJsZWQuDQo+IA0KPiBJIHdvbmRlciBpZiB0aGlzIGlzIHNvbWV0aGluZyB0aGF0IHNob3Vs
ZCBoYXBwZW4gaW4gcGh5bGluaz8NCj4gDQoNCklmIHRoZXJlIGFyZSBvdGhlciBkcml2ZXJzIHdo
aWNoIGhhdmUgYSBQQ1Mgd2hpY2ggY291bGQgYmUgYWNjZXNzZWQgd2l0aA0KcGh5dG9vbCBldGMu
LCBpdCBtaWdodCBtYWtlIHNlbnNlLiBSaWdodCBub3cgcGh5bGluayBjb3JlIGRvZXNuJ3QgcmVh
bGx5IGhhdmUNCmFueSBrbm93bGVkZ2UgdGhhdCB0aGUgUENTIFBIWSBhY3R1YWxseSBleGlzdHMg
YXMgc29tZXRoaW5nIHRoYXQgY2FuIGJlDQphY2Nlc3NlZCB2aWEgTURJTyByZWdpc3RlcnMsIGl0
IGp1c3QgdGFsa3MgdG8gaXQgaW5kaXJlY3RseSB0aHJvdWdoIHRoZQ0KbWFjX2NvbmZpZyBhbmQg
bWFjX3Bjc19nZXRfc3RhdGUgY2FsbGJhY2tzIGluIHRoZSBkcml2ZXIgd2hpY2ggdGhlbiBjYWxs
IGJhY2sNCmludG8gdGhlIGMyMl9wY3MgaGVscGVyIGZ1bmN0aW9ucyB0byBhY3R1YWxseSB0YWxr
IHRvIHRoZSBQQ1MuIA0KDQpJJ20gbm90IHN1cmUgcGh5bGluayBjb3VsZCBnZW5lcmljYWxseSBh
c3N1bWUgdGhhdCB0aGUgUENTIGNhbiBiZSBhY2Nlc3NlZCBvdmVyDQpNRElPIGhvd2V2ZXIsIGFz
IEkgYmVsaWV2ZSB0aGF0IHRoZSBDYWRlbmNlIE1BQ0IgSVAsIGZvciBleGFtcGxlLCBhdCBsZWFz
dCBhcw0KaW1wbGVtZW50ZWQgaW4gdGhlIFhpbGlueCBaeW5xTVAgcGFydHMsIGV4cG9zZXMgaXRz
IFBDUyB3aXRoIHNvbWUgUEhZLXN0eWxlDQpyZWdpc3RlcnMgYnV0IHRoZXkgYXJlIGp1c3QgYSBw
b3J0aW9uIG9mIHRoZSBkZXZpY2UncyByZWdpc3RlciBzcGFjZSBhbmQgbm90DQphY2Nlc3NlZCB2
aWEgTURJTywgc28gd2UnZCB3YW50IHRvIHN1cHBvcnQgdGhhdCBraW5kIG9mIHNldHVwLiBJIHN1
cHBvc2UgaXQNCmNvdWxkIGltcGxlbWVudCBhbiBlbXVsYXRlZCBNRElPIGJ1cyB0byBhY2Nlc3Mg
dGhvc2UgcmVnaXN0ZXJzIGZvciB0aGF0DQpwdXJwb3NlPw0KDQotLSANClJvYmVydCBIYW5jb2Nr
DQpTZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMN
Cnd3dy5jYWxpYW4uY29tDQo=
