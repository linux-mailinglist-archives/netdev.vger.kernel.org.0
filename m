Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B9A31ADB6
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhBMTQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:16:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:57453 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbhBMTQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:16:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613243812; x=1644779812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pmi3l9Eqb5ADxUb53z6ke060z/yfZzQidwUbDbC6ifo=;
  b=QlcimctyjXxwAbp6paV28FGyyhTk0e/fGQd4KHKmCoTfj3QH21PkwIzQ
   yslBerW9QbM5rUJ9LpdwNCVfTZiAAtkGPrxd4aaYTVaCYOy4rh0CYxpO9
   LXDrlwhPp2Eji202Vd1tWv3/CKaIcEHc4cntVttVSUJ4E5DU/3rafKUPf
   tfiaj/5F1t+WVy+o9DjvS4jTljFUgiDCh6YLtjUaKrb8qmNmK0ygypG3j
   453gwqLjYCdAiS0gfAAIXzUgVRa4u6AFR3WYR87tifVjOsh+2O+efkI9R
   A7hAUiCuCkFGxXHcnHGIYV6vhNYDCr0P3zXCn37T/lZE7yWIldDkMFtZE
   Q==;
IronPort-SDR: 75fUHP6+hQroWy+Lvk5STGZCRHqzIY6cKevt+l758sxuOHq2OJ2wFZ8+WWrPfFfQGRqqrR36Uc
 PabJkm8slAD3bVNngWyuQ/UZXRAQB83MZlzPFUfAuDEJtgjQBVkz/ZV3Y7Xk6BWFxn+3H/SeCW
 QZNoKAfBWT4/iwdAw1FWWPjnKJT2qSAHcvMBFEyRgOHpkYy/JggOgL4yxx2w7hqp9EZCHoZ4xl
 dYtXAT6IY1gxo1+fHMbq5PDqBAM5l4fV3hx2MxdZ4ATa2BZLy40aUdEFi1ZUkk6/lpdKTjMmH9
 i3U=
X-IronPort-AV: E=Sophos;i="5.81,176,1610434800"; 
   d="scan'208";a="103661208"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2021 12:15:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 13 Feb 2021 12:15:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Sat, 13 Feb 2021 12:15:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lf2+iLEzfShX3+QjN0nAeKhgjfckvqqY0ZjcaGF1rB/MTCdylYh9uGiGLqK5/NppT2Ydvp6Hyd2NRNR3F/onTfm/2vlIuxMeY9jdXL9cpHVjBGD3gdPjwxk4s+eAjRZSNRZiNDRuiMQ39/Qrqv2fHt4WajEu2GMna6lkkTHdxCZFe84f8sX5SySFPw5Lz9ZpaSDU6kJ6ZPFkXUJ1+oPwKUo7cWwrvvOo5EzuVDvPpM0ILeCMDIZw+XEwCPcpMrnTr9gpzH8OGprSZAu7ICx4zARa2fJz1mLNpvergbFwUCfXtbHBbF3C1URiHq5DbsSI1sucQme/1aH6NiAks6KB7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pmi3l9Eqb5ADxUb53z6ke060z/yfZzQidwUbDbC6ifo=;
 b=TVXVKRD3pg6jxxuLeFOynP+BhJ35vC+svJB5AQDaTITBEZL7Nr/aGCfYUan8abTFlufTiCKWbkaTJJSpALxXNcTnHht5v2nKSt/ERCdag9AiRYrW97M01ZBDlecMYYv0P9T9GpD0/7v7QQE3WRbO9+DdsuO/RbNKNroZMnaGxylfno0CpfqgvimSFIgHKBvDM86igm4Bg1c3N5woyYkzhclV8oVU4gsAXOkdWP9y4X4VIFnfDQiDSf4AhW1iwVeYSMrYLZjSztPRIYZuwyxtyhiO0ZtUoR7bRcjNfO2fveJhiBGeLO42fIHPcoup1crpIo6or2C1i1BzsXoFtndOzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pmi3l9Eqb5ADxUb53z6ke060z/yfZzQidwUbDbC6ifo=;
 b=aLRpqoxvUBJT2zf3EmkUlS84wN+Mu7VyqkPEyZEJqlV98/OxmY01d4iGzguCV69YUGHnK+0y1cG2CrXODqIkopBEkWgqJZeyi/OOebPYjaE9yNaorAwIjSj0Zow8Kn1T51GQTswvTl2Mu9Nxi14KFIZgnO4Z5JV1rjQHqRzT6P4=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3869.namprd11.prod.outlook.com (2603:10b6:208:138::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Sat, 13 Feb
 2021 19:15:30 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3825.031; Sat, 13 Feb 2021
 19:15:29 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <andrew@lunn.ch>, <rtgbnm@gmail.com>,
        <sbauer@blackbox.su>, <tharvey@gateworks.com>,
        <anders@ronningen.priv.no>, <hdanton@sina.com>, <hch@lst.de>,
        <willemdebruijn.kernel@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/5] lan743x: sync only the received area of
 an rx ring buffer
Thread-Topic: [PATCH net-next v2 2/5] lan743x: sync only the received area of
 an rx ring buffer
Thread-Index: AQHXAJGpa8G4jGvBo06W56EUgcdc1KpU/sdQgAAfvICAAVlvsA==
Date:   Sat, 13 Feb 2021 19:15:29 +0000
Message-ID: <MN2PR11MB36627F1F2BC0F7B4082037C1FA8A9@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210211161830.17366-1-TheSven73@gmail.com>
 <20210211161830.17366-3-TheSven73@gmail.com>
 <MN2PR11MB36628F31F7478FED5885FB92FA8B9@MN2PR11MB3662.namprd11.prod.outlook.com>
 <CAGngYiXE1pajamOKhtMN8y243Gh8ByWA=AHP80jM=uDsYxTmsQ@mail.gmail.com>
In-Reply-To: <CAGngYiXE1pajamOKhtMN8y243Gh8ByWA=AHP80jM=uDsYxTmsQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a086e67d-da71-4aa7-7619-08d8d053ba3e
x-ms-traffictypediagnostic: MN2PR11MB3869:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3869650FC9F5A1F3A1BBFC30FA8A9@MN2PR11MB3869.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U9yPv9Pn7dTMXOiKTZerZuH3A0JAOYSehj9QtZyO/VTMsoDMJwXibsiPH4JjdwgKemYqAV3RleqPngDZ0eZ1hGmFDoVWYyUctII2NrxmD28OU0S5+L34n40infQchWFQV7y8UyL6atbCkEI03dGruwcmNh+ZIEB6pE7Dl4JzuR9ZMz7eyU7v7bcs7tAiMF12EVTanSV9fhVDINMPQaFwaox9V75WT4XSg4of3wX/SbOkq3luNMmYcTF1YbCy7B4yxH2iPaE7ns5mRAa1OhkL7QKNz4GrIs8Zjw3/+gj5dHplVe06LYGwYIad3s/Z4TmpETjjtyovRl/l1N/KLXSubRxiJ4ZjIaC1mKtzeXnyFwmRIBH93C1iquSYXac1EJY/ZboBdpv9HDPxhhLrVkKlklDUbVLO/YLCYULywg7pXdEFTFBEHwno+EncCOyGwrdVUubmSN2lf2GRXZ5kqdi2ZIy/KYPPqLGOyeCBnSwmtWG5Zny2a7M3iT6Av3rlKlooIqg/GaZ9WnQsmUFVQOzlTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39850400004)(26005)(7416002)(86362001)(6916009)(478600001)(186003)(8676002)(6506007)(8936002)(558084003)(4326008)(71200400001)(55016002)(66446008)(2906002)(52536014)(76116006)(7696005)(64756008)(66476007)(66556008)(66946007)(33656002)(316002)(9686003)(54906003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?MkhVelB2ZGViUCtaeWlhYjhZRVA2dG9VbUd2blZqWklRYk4xZHZEWjM5c3dX?=
 =?utf-8?B?VUJ1V3hhUG9TN3pRbXkyLzRoZ0xlZGtndENUblpTaDlIazBxMWdmL1czL0J1?=
 =?utf-8?B?MUV3RFNTQzVpK29mOFd5cFFEbHR3U0lMbzhpazJwT3lEWUQ3QisvdlZsdFFu?=
 =?utf-8?B?Ukd2Y3dVb3p2OEMzdTU2OE1DVms0dHRwMFU5cEx5STd4MFdBelQzcFpxL3Jt?=
 =?utf-8?B?T2t0ZU92eXlJaHNoY1NXOXZhbnhWVHVSVzduKzlsdGNmQ2JPTzN6NDJHZmcw?=
 =?utf-8?B?SU14bm02dmpmRHU2U3hWekNtNUNWbmF1MWZnYjYwTCtmMnhDR2RrYks5dUJ0?=
 =?utf-8?B?cTNBTS9kRm16NXYyOEEvcksrZ0QzajE2VlQ3ejV6b1NXYlQzM1ptRlhKaEpv?=
 =?utf-8?B?NzYwWHJvcWk0MkJlTDRWT3lhVEMzNDF3aXpacWJCNlNWbmdPYjF5Y28xKytU?=
 =?utf-8?B?b09yMTlSYlNtaGFpaUExNlVDSEpGeThlMUZOMDVmVXB2VCsrTWUxUFFqNU1n?=
 =?utf-8?B?M010bmUvRFdOSTloSCtHczRTaE9CejQ1U1VyNjc5Y1VUWlRTRHB0ck5RRW9V?=
 =?utf-8?B?bll2K2JwNnZteEFJZUlBU2trRDhUbC9hdFU1TmlhYmNPYWw2MXJ2b2RNVXl0?=
 =?utf-8?B?MWZsMUdOQW5jVFRwSk1XbS9YVXFmWmVEems0QU1xYXJvTTVzbmRESFVmcDdN?=
 =?utf-8?B?Vk90VTM4UFJYb1pVTmM3S3J5WGVndG1TSEE1c1ErdkhvVDcxQ241YkF5ckFJ?=
 =?utf-8?B?ZFNZK1doU1RLemlpT2ZGZ0hydHdFdHZHMU5jMk9xa0NDdCtFYnBMME9FWWx3?=
 =?utf-8?B?UXdKc3FyWE5uaDJFVzd0WC9nK3E5NlgwdnU4bFZRWGdFRXc5TDlYOUZLWlZp?=
 =?utf-8?B?TldWOU9qcW04VGFoUG9mbGJ3VzhpZTNXNFBmN3Y1dUg0MVljNDBJWlBFaklo?=
 =?utf-8?B?Q21oaFM3SjNYeWZoSlI3WkkxbkVHUGVqSlRmU0R0Y2taK2Y0SWpLR3NNMTRx?=
 =?utf-8?B?cnoxYldZdG1BVUtJU2E5OUtZdFJ2b0pmWVlOdk5ZZ2xmYVNpcTUyTkMzdXlC?=
 =?utf-8?B?ekxNeVFFSDdtUUNLSFdNb0FwdnJBKzFJRVVUUDAwbHZpUFNvYUV0ZVhJcEJW?=
 =?utf-8?B?MnNiUHpZQ2VydC9ZRlNjTVRhbHBJcktHR1dhOXdvMVNpZzd2WG9ablk4dTNp?=
 =?utf-8?B?S1BCeDA5OU15bnBFNFpSWEFuR3ZiQ0xyRXhOTFlRQ3YxRlV3WDBuRFJ6ekNu?=
 =?utf-8?B?RWsycXNCak5IZGVyeGxMY2RlQmhoTXpTNlFFNlkzRmp6Q2F0dmhkMjJ0TUJx?=
 =?utf-8?B?dDdQWVBJZjM1SGd1Sm9DV3FGZjlmVlAreXNtUjhHVTFWcXdvdDVCR0dieTJv?=
 =?utf-8?B?Q3pnRDNaM0llQ0FrN2JXZlM0Um9ROUJnRUo3dHVvQ3IxbnFmU2x2OFp2MnVk?=
 =?utf-8?B?V3lCUWNxQmlOdE50UWloQnNrRE84aUVtUmFhRHlUdnJLRW16eENEZmU1SVM4?=
 =?utf-8?B?MWZaY3FVZU1kbktrbUJVTm1Na2cra2p0cVNyTDdFNXZ6encwdDNTVE4xekts?=
 =?utf-8?B?Qm1iOWlPZ0NoVlRWYkQrVm44T3ozL0FoaFJTUHBFckJaUHZuVGpHZ2FkSFg0?=
 =?utf-8?B?Q0x2S3UvSFpOSDN0bjk2Y3ZRTFQ0M3FKK1lRRGNTanhPV1FLZ0hVR1I1cVVG?=
 =?utf-8?B?Vk5GYkowS3JDdW9ITk5JbXRNa05EdmVaYlhjb0YzalptZmRTa2NtWjloUzdv?=
 =?utf-8?Q?qzqlpt61gltYdXFaaA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a086e67d-da71-4aa7-7619-08d8d053ba3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2021 19:15:29.6904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sj7uOqk7KD6w/XNKfPFBJwpB0ttZ7At+Wc7TrdDIlrKa1wI8qTzJpAbIIuLrZr59vcMA3HDdPi7U6+lYHQN9w97/LEhzF2JVbSITNueSgSA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3869
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IA0KPiBXaWxsIGRvLiBBcmUgeW91IHBsYW5uaW5nIHRvIGhvbGQgb2ZmIHlvdXIgdGVzdHMgdW50
aWwgdjM/IEl0IHNob3VsZG4ndCB0YWtlIHRvbw0KPiBsb25nLg0KDQpTdXJlLCB3ZSB3aWxsIHdh
aXQgZm9yIHYzDQo=
