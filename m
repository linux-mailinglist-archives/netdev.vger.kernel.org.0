Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD6CB19C6D5
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389793AbgDBQOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 12:14:55 -0400
Received: from mail-eopbgr700086.outbound.protection.outlook.com ([40.107.70.86]:27392
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389041AbgDBQOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 12:14:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSEiKPbr8X5wL1jsZ5MvBPxxN6CiEOdeUKwfwfb60TjtsOpalGPaZ11pfm2da58bJbuQ7pqqLgapMYnCk++TPjsPR5QcH1fKIiAktoM3e8fYIUdjrAh2pzl1QsDkWWx0F7L4ecF6qSss+ZxHIcMl3F0DxelJhVtxdpf1u2YDYawxpomUX6f67qCYXzMkd9cQ6OiUK8AZqnj0Q3WxjzOVOnCJtW9HLzj7Wu2dsiL7v9NC31ag4Z/OABmMAwN5GoRbSUjX1EZH3csggEzFs5a7Qaxh8/eOfnRl6DY7lb5CppYhZ3U7kV54iY//fyH+hp71eSzBjU0uC6zsE2Ne1xnUaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4NMsPse/N4poIiaYAtI0ewjmuBpTbdJRqPfkJBu4IY=;
 b=aTV/kp5uOU5d7kY1JV6UBrR23gKBqjd+caVzp3PAfzub4vb112nzayHwKG2hWhfnrJuEyirVecLKYNZl5WkN1mBoE3rr31vg8Xhgx0giBlqWTUeY6AViIautxn8IfkyBdjfFp8PlYkHuQAGjNWC6xxpqD8BfZcnvz9p/6wZ4KAmOHjYpx9cD2+oT3NSsFGJU5HLV+clGPjIBZ/2yfohUD5Cp8UlaK/zz3iA1ZLnEbPedMK6P/TN0lPhJ5WUkhuo+fhA/ochiYeuYLdfBqdLVgoGcWzV33DD4F2R6O2r4ta0zsjwW9UyA2hGoOeOAU+kMxKvR4id4aO5hPhkd+D4MDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4NMsPse/N4poIiaYAtI0ewjmuBpTbdJRqPfkJBu4IY=;
 b=Hc8/3VyCAxEr593thwxImCjUbxc23uSyxmFxbHO5ySNvrsExk0m02Kdgsuy7AFNm7zgtXq/fOPst2kiBKuxfzharoECq70P+mH5Xnwxh/FpzFlxio8cx220lYRs+rasOFLzT64rhCSCFvmwFYMGyGJtdGh3oGYmMQNz3GlSKF0c=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4583.namprd11.prod.outlook.com (2603:10b6:208:26a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Thu, 2 Apr
 2020 16:14:17 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 16:14:16 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 01/32] staging: wfx: add sanity checks to hif_join()
Thread-Topic: [PATCH 01/32] staging: wfx: add sanity checks to hif_join()
Thread-Index: AQHWCBVMCH2afVbB10mhdLojoO/GiKhlyCWAgAA7MQA=
Date:   Thu, 2 Apr 2020 16:14:16 +0000
Message-ID: <2026476.QLiXXEGFCf@pc-42>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
 <20200401110405.80282-2-Jerome.Pouiller@silabs.com>
 <20200402124223.GQ2001@kadam>
In-Reply-To: <20200402124223.GQ2001@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [82.67.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23c7bc09-d5a6-4eb0-9d8f-08d7d720e492
x-ms-traffictypediagnostic: MN2PR11MB4583:
x-microsoft-antispam-prvs: <MN2PR11MB4583BCB377290048452686E993C60@MN2PR11MB4583.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(376002)(366004)(396003)(39850400004)(136003)(346002)(6486002)(5660300002)(54906003)(2906002)(4326008)(316002)(26005)(71200400001)(33716001)(478600001)(9686003)(6916009)(6506007)(6512007)(66556008)(8676002)(66574012)(76116006)(186003)(91956017)(66946007)(86362001)(66446008)(64756008)(8936002)(66476007)(81166006)(81156014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QXfLnyujnRrxkaefmhb8mK1hVk4gZrn9ocGhu4GMEQLrEWzDvBdfaVog2mxrG0wuNvK3iKHsJtdD0Q4sniNep3SFDr7vV7d2WbtXJBLAZTUlmEJTes6VNTect8BZPm4HqHRkzv0qYWB5XeswMYPp9s/fL9xKa5Nb/OmGxSpwyJ7sM3aGzqgIljm41vc/kldNVsKtbEONyaRgm+mSAGORS+oeL1wz6gQ/+7ymTYuGA3I1Mnbc2W2eNst1Po3Ui39c3hBvBcuW+UlwK1V94eVeUIeYwjDfPRQiQex1LV3OUEpC0fZY8qu28/UkfV2ItXYJONwvpKMssTDQ2nwO65SY8vBS0xtN7bFhnmqirwgIfGLRxSgXwVAhXJtY8EYtnPXCPOP6Vwxlzd/80P0BemOnnxUxLQTYnoxHLIblyhwyyBf5lid62F20W4d9d+2b27oK
x-ms-exchange-antispam-messagedata: MmEW+CrhGX0UtLkFUXHPuv8NcD8SCSc2ajZywqZ3pG20U+OJMEG2P1tNB1Qn/vK44WVyTxijT/25Ljqlf45BR8Q7EGrdOH7Sro5q1FA3MuqygCh1K8ZIElMGGg36XXT9ZEx6EOlydtpYT6QkhyaxAA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <08CAE85A1A96544D80CD9EE9C3D0BFFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c7bc09-d5a6-4eb0-9d8f-08d7d720e492
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 16:14:16.9004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b2KkUuV7Qy/z1/CxkOYexTCD6MQC+j2cytSat/9c4IuQhU0IBH3xPmjTD3Y5T3ERcqqIsJeZ4G/eQLQt7nlF0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4583
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 2 April 2020 14:42:23 CEST Dan Carpenter wrote:
> On Wed, Apr 01, 2020 at 01:03:34PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Add a few check on start of hif_join().
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/hif_tx.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.=
c
> > index 77bca43aca42..445906035e9d 100644
> > --- a/drivers/staging/wfx/hif_tx.c
> > +++ b/drivers/staging/wfx/hif_tx.c
> > @@ -297,6 +297,8 @@ int hif_join(struct wfx_vif *wvif, const struct iee=
e80211_bss_conf *conf,
> >       struct hif_req_join *body =3D wfx_alloc_hif(sizeof(*body), &hif);
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> We've got an allocation here.  It's a mistake to put the allocation in
> the declaration block because you're going to forget to check for
> failure.

arf... this remark also applies to all functions of hif_tx.c. This
issue has already been reported. I will send a patch that solve that in
one batch.

> >       WARN_ON(!conf->basic_rates);
> > +     WARN_ON(sizeof(body->ssid) < ssidlen);
>=20
> Put the variable on the left.  WARN_ON(ssidlen > sizeof(body->ssid)).
> I'm not a big fan of adding this sort of debug code, just audit the
> callers to see if it's possible or not.

My personal opinion is these checks does not replace the audit of the
callers. It mainly provides a kind of documentation for the reader
("not supported, please check the callers"). It is especially true when
it is an internal API and there is only one caller.

> I have audited the caller for you, and I believe that this condition
> *is possible* so we need to return -EINVAL in this situation to prevent
> memory corruption.
>=20
>         if (ssidlen > sizeof(body->ssid))
>                 return -EINVAL;

In this case, I think the problem will also impact wfx_do_join() (the
only caller of hif_join()):

   514          u8 ssid[IEEE80211_MAX_SSID_LEN];
   [...]
   538          if (!conf->ibss_joined)
   539                  ssidie =3D ieee80211_bss_get_ie(bss, WLAN_EID_SSID)=
;
   540          if (ssidie) {
   541                  ssidlen =3D ssidie[1];
   542                  memcpy(ssid, &ssidie[2], ssidie[1]);
   543          }
   [...]
   554          ret =3D hif_join(wvif, conf, wvif->channel, ssid, ssidlen);

Does data returned by ieee80211_bss_get_ie() could be bigger than
IEEE80211_MAX_SSID_LEN? Not sure. I am going to add a check in
wfx_do_join(), just in case.


--=20
J=E9r=F4me Pouiller

