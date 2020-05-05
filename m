Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83C01C51E8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 11:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgEEJ1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 05:27:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:3121 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728544AbgEEJ1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 05:27:19 -0400
IronPort-SDR: HrjuwcHloNRbAd3zNftqDzMMT8saE4++o85RMGWhTDJOnPhrY1buuCEaL2gBd7faZZfSOUPCXY
 28mJP4GxNamQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2020 02:27:17 -0700
IronPort-SDR: s6FRpRj89M396XsE4yZR/hrr04ao7pJ1lEGjCGn70zUoLNSqv1iOpU7i3IoAG4eosa8UfnpeLq
 WMJNPT6LRm7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,354,1583222400"; 
   d="scan'208";a="250848851"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga008.fm.intel.com with ESMTP; 05 May 2020 02:27:16 -0700
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 5 May 2020 02:27:17 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 5 May 2020 02:27:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 5 May 2020 02:27:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5mkUw8nicQ9kbweAe93mVBVit+JJZfhllmbngLEUotpSHKF3mikafWTj410/akBPXniLZleSwy61t4wGW1kdYvIEW1scFp9igGgL3Km903Sosqzz8m2KK0d8XJyWZBAf6mTPcaqlBwsaDDz2YWaJdrDJW8mqZ9VkQ425/6Bk5VyohrjFuvofOOTvpepeXn75VN2SzGoBT7asW5724vcVs6y5XnkkPOKkalFMmAXtt9oZmC8wV6TBI0jgrRumnXHnldSGsGH0Hd85fOtj9VtnsU/xYqqN51fW2qmwwcc3BTeAu2Ful5kd1nNsUK12X2ANNfyti2Dl995I2GOD4OCyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NexMdcUS9bKJcMQjpgiB4VWfCzHx3fWOC5Eo7cyE6Qs=;
 b=RuzMmClXbyArNopaujllgDEb/VF5l4YCVQQzVufEYX43DDOSyhirmYg7ds4ChDA2j4CXPrXreVAPlo629HMHDPxL/+BG0fTJu6T70aXMiqXy32lQXNQS/kBz8rzjMZctz3H8Nyn6stju30+mzLSrVeqH/EKSYlEDuCmeQGYLGd41KyJN9FdZoLH1YMfY3TFfQGN8OWGXH9pgm7pM2peayXoptM48mwIjBY3aQ7D7ShUjvO6LyfixthGK2VkkDfQAmU8TzlAnAJlfWAFnTPVi/opquo/g6hPu29q2jgpvVJBvqUY54DnEKciu/z+NSBpcMGZ5NpNvE5u0P1lw5gvrVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NexMdcUS9bKJcMQjpgiB4VWfCzHx3fWOC5Eo7cyE6Qs=;
 b=oJtJA+4XKUsNLP7QukT9HrxMDMf0M9Q4FkGDXKBP0+yxCGHwTUrPgHK28cFbudyo5EIjzrl1mEjDVstRpONwYnOMBY0ueIongmRIOKhtYKmgxNIO8RXyGktk6s+xS2YekJcTBNtFz/f2WCsLTbV+JbmOkyX1ftrfcqgi64O6vQA=
Received: from BL0PR11MB3057.namprd11.prod.outlook.com (2603:10b6:208:76::21)
 by BL0PR11MB3345.namprd11.prod.outlook.com (2603:10b6:208:6f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Tue, 5 May
 2020 09:27:13 +0000
Received: from BL0PR11MB3057.namprd11.prod.outlook.com
 ([fe80::a486:da53:2f51:3eb7]) by BL0PR11MB3057.namprd11.prod.outlook.com
 ([fe80::a486:da53:2f51:3eb7%7]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 09:27:13 +0000
From:   "Ooi, Joyce" <joyce.ooi@intel.com>
To:     David Miller <davem@davemloft.net>
CC:     "thor.thayer@linux.intel.com" <thor.thayer@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westergreen, Dalon" <dalon.westergreen@intel.com>,
        "Tan, Ley Foon" <ley.foon.tan@intel.com>,
        "See, Chin Liang" <chin.liang.see@intel.com>,
        "Nguyen, Dinh" <dinh.nguyen@intel.com>
Subject: RE: [PATCHv2 01/10] net: eth: altera: tse_start_xmit ignores
 tx_buffer call response
Thread-Topic: [PATCHv2 01/10] net: eth: altera: tse_start_xmit ignores
 tx_buffer call response
Thread-Index: AQHWIe38IzYWwFsQS0ypU6jURd+N3KiYMheAgAECGmA=
Date:   Tue, 5 May 2020 09:27:13 +0000
Message-ID: <BL0PR11MB305783B621110C7A38675659F2A70@BL0PR11MB3057.namprd11.prod.outlook.com>
References: <20200504082558.112627-1-joyce.ooi@intel.com>
        <20200504082558.112627-2-joyce.ooi@intel.com>
 <20200504.103935.1584665284135386530.davem@davemloft.net>
In-Reply-To: <20200504.103935.1584665284135386530.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [175.139.126.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d8075056-b820-4b0c-efae-08d7f0d67ee2
x-ms-traffictypediagnostic: BL0PR11MB3345:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB334526A7EF8312A68518B795F2A70@BL0PR11MB3345.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XCsX3euWXweA446m85Q4yukWk+R1svCc6J7FbiUjExCCbY9g0iEKt5hSF6SGR+/UJ6WfodlPsQPse1hV4rQo9oqPEv5JhNZnbiFHzGV5ZFBVLib5OesU9LflNXCouPz+D/rbF6DZPY6oZoiLsZ3fEFjldK3TsTN8QR+be0y5hotSoB8V2CDlQ+ALwK1WyMhiAA6fz+CZQgHI1d4wXd9DXcr9YA4g7sdADB5r0IwvCWbJyndjdr7olGbxTklzJOyAo35fKp197QVVMtn0U8A91OG1pAe8CWQBKwyGLpeHjF7tE32Nix666Xk/bsmSkTIchG44C40Ov3atLNh3d4e5sYJfnIWGHK73LUJunroQYLS9GP729CiWn+SXIiDWeuyDxtQSSJU1uREvKXbM8h+ckI0MLgay7w49p9iQyr6Oj6Yjp8ukjS+OtEcWFoZD1+Tq7660OQP6jdeslFM98fSo4H6LeA2zUZ1EfXGQYnOscRMOSlpe1uWTcCvWDpQJU5lZVu6KcsZwfjKd/ZmI6QHk1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3057.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(376002)(39860400002)(346002)(396003)(366004)(33430700001)(54906003)(316002)(26005)(52536014)(66946007)(186003)(76116006)(71200400001)(86362001)(66556008)(66476007)(66446008)(33440700001)(8936002)(64756008)(5660300002)(7696005)(53546011)(55236004)(478600001)(6506007)(8676002)(9686003)(55016002)(2906002)(4326008)(33656002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hWLu+YTyzj5U4YwjrqnryEz1joHIL7YdvkIOMkZdxShbgsi/z9X/T1XqxXr/9AweY2wgGN83HzcQHXJjz0h1NpeNrIHKH7vd119EA1BAHcb6LzvF32n8pQHkmrhi4gr5BTC3zehkRFI75mxF0nBdfyfBpwssfQp+VItYcsNLMb9fs6ntWVYdhq4BVob/17k3hrIIP+HZORaxpgSjiiP08XVls2nRg2xWet0gBBsahyJv4JO4scIpnTK7Ao9SUzadrliEKOYtEphTt5wNKXqFOG9u0bwoWjJER1bx/kEQAzKaHaHcdboYUHxcjjKNWe6StwKbm3ovCpOuky70q/7iuDUVza/B9QMFhO9448lKDQI+c3V/RsVN3Mlh+0DdaQ9Wo3QNtHHD7/J/3AfTEC2aMt0YtlwJltrhGUQo1qKbxwaCjDdIb5OC4qGiOZwBVUUKvZtL9w6cePK7rHybJ1dvJ9StLTTvzm2OYt1E8IZRrde6PyL8oLzUxnrkBWeHjhC8CI/dJJ6NY8DegFM6mDoAzoZDMddcaTmmIZCsCRJl0a9SmKygowSqNRuy1h4KSd23Id9cteq12UurqwYGP55CCqD4g8fYWxlqZLkzPGHgI9sU42AvWus4ICIEZwiMgOFsspNC+o5lRp8RgIuvhwqcnFmH3hOLucXVrdtqf5qwLqR0436f98OEoTjfs1ZTT1lGSxaDPqhDucfQVgeBbmPlTzVXAQZUUwKutyj7iTW1tjKnz4sYZvAROjYJ6gNuhOuQWxZax6ARgmIiJNU9S8JOJXACFe6w09ultPmzerLiez0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d8075056-b820-4b0c-efae-08d7f0d67ee2
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 09:27:13.7134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ISbxG5cpBpGLi5LNb1L5ZgtctpbloJlPhBDPoAC/pNsL4QdGDYiesvkjdROonw+sY3U/OIEP0ucWwQ+Dgjd8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3345
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Tuesday, May 5, 2020 1:40 AM
> To: Ooi, Joyce <joyce.ooi@intel.com>
> Cc: thor.thayer@linux.intel.com; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Westergreen, Dalon <dalon.westergreen@intel.com>;
> Tan, Ley Foon <ley.foon.tan@intel.com>; See, Chin Liang
> <chin.liang.see@intel.com>; Nguyen, Dinh <dinh.nguyen@intel.com>
> Subject: Re: [PATCHv2 01/10] net: eth: altera: tse_start_xmit ignores tx_=
buffer
> call response
>=20
> From: Joyce Ooi <joyce.ooi@intel.com>
> Date: Mon,  4 May 2020 16:25:49 +0800
>=20
> > The return from tx_buffer call in tse_start_xmit is inapropriately
> > ignored.  tse_buffer calls should return
> > 0 for success or NETDEV_TX_BUSY.  tse_start_xmit should return not
> > report a successful transmit when the tse_buffer call returns an error
> > condition.
>=20
> From driver.txt:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) The ndo_start_xmit method must not return NETDEV_TX_BUSY under
>    any normal circumstances.  It is considered a hard error unless
>    there is no way your device can tell ahead of time when it's
>    transmit function will become busy.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The problem is that when you return this error code, something has to tri=
gger
> restarting the transmit queue to start sending packets to your device aga=
in.  The
> usual mechanism is waking the transmit queue, but it's obviously already =
awake
> since your transmit routine is being called.  Therefore nothing will reli=
ably restart
> the queue when you return this error code.
>=20
> The best thing to do honestly is to drop the packet and return NETDEV_TX_=
OK,
> meanwhile bumping a statistic counter to record this event.

My change is similar to this hard error mentioned in drvier.txt:
/* This is a hard error log it. */
if (TX_BUFFS_AVAIL(dp) <=3D (skb_shinfo(skb)->nr_frags + 1)) {
	netif_stop_queue(dev);
	unlock_tx(dp);
	printk(KERN_ERR PFX "%s: BUG! Tx Ring full when queue awake!\n",
	       dev->name);
	return NETDEV_TX_BUSY;
}

So, before returning NETDEV_TX_BUSY, I can stop the queue first by calling
netif_stop_queue().

