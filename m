Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0356624FD6C
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 14:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgHXMDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 08:03:48 -0400
Received: from mail-dm6nam10on2053.outbound.protection.outlook.com ([40.107.93.53]:22978
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbgHXMDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 08:03:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g63dxQyySU2N/00wlw7PVZH++L+Q7wU2pAAu05Awxw5dQQcdoEEMZ5vcLcHkMD14MQJAH/LtKNp6tyTLSQfedFCkHyE1BhYz2zHMY91JlkJ47nGbyX1qGC+fjzAfNXBM9U0CdG6TIxCGOQWPUkTM81sKYIc5DL4Kku6rxZT7cRf15GyGF9SN0grLxI9TijpqqJXY8PD4NPqJ+IeeJJHYlz6jPL/IoUhVA1edsRobOcBj6IrHw6wCaUYR/9cJz5RtmrtAA8KFIAWCTH7C6Q90JkUp3vz0CtMvgJMtgyffWrb1D68eR6lapmLMGRuk8fwk4EKYFrmaGiLSq2ydUO3Baw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zj2UzhlYptTmVUjphLKhxk60r5Lpq9m484szGYOJcRg=;
 b=j5AqEB4cTypD2Sb2jwVCNqzaxWSSKip66K5O6CAd95L4U8oG3IuHU08P+AVv5X7mjlTMYouAYl5RaNVCbd8zphlF0wjEGOx/rdLpGYyeycUIgs7rZUoyFtnejzFLiVYqKcLEQqJHABUM345EaanPAi8JF9FWZwy071XGgf6YIbz6CWU8947DgoxWRXlrpaTSgQg9j9lKMfj6jHsdUMcQsltP5YhuIDfObGEB02T0XqtUvCbHFvqxSf2dOWxVuZzpNjoREzZHtt5CDiv/l3IcbC7t6di5qCxmFojWJWD6KkL46loIrs1khKqqKAlpQLulXBza7ALWkDRY2dZSXF4fvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zj2UzhlYptTmVUjphLKhxk60r5Lpq9m484szGYOJcRg=;
 b=hYKONIzaU7L/65AZZ99IgFxhOstg40KMHCnVMmbVgPIHQ9v+X2XNlFyPyh7M/RR1GWBiDvq9c4qkaC5OUOBLUZyFMvys7kt+wEYDy6Vld++5lhpWie7eMqKJKb1i5KTl2fykRZF/oLB7gq/DLak0fn1rv2cY3ZwI0T/+OBP3H1E=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4685.namprd11.prod.outlook.com (2603:10b6:806:9e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Mon, 24 Aug
 2020 12:03:40 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 12:03:40 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 01/12] staging: wfx: fix BA when device is AP and MFP is enabled
Date:   Mon, 24 Aug 2020 14:03:33 +0200
Message-ID: <9806363.PRSCUAgTIS@pc-42>
Organization: Silicon Labs
In-Reply-To: <20200824095042.GZ1793@kadam>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com> <20200824095042.GZ1793@kadam>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PR3P191CA0060.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::35) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR3P191CA0060.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Mon, 24 Aug 2020 12:03:38 +0000
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6fa0e75-dd5c-4f53-2a0d-08d84825bd63
X-MS-TrafficTypeDiagnostic: SA0PR11MB4685:
X-Microsoft-Antispam-PRVS: <SA0PR11MB4685E767FA2DD1AEA56592CE93560@SA0PR11MB4685.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HqxWb+s/nkTPU8c4N9/4B1UdYtuIoRlU8udGcN3705lpod7PxZcjBosk4GkJK7hTLYcARJn1fTU82LnqxNazt5WxrUUsZWCf3ONfkytbm5r+2B4AzgLsBEVdW85ovHjFyNVJc6l864XsU0HC241F9rM9kBetJE0gKUBkSHzjUKgcn+zGMJQNKTGo3i6JqH6xPyP2saOXMhKLYtM6rZMHD6fXu2fqUFcUuIonZ6or3EpFH9FAqeYxfR3PC0FoBfEBf1JUMZ9Rmj1+TnwZ/oHZztudVVGxmiz1EsMqpjrbVuZaexXczNb4KLWhVn8hxYomxN9FTXb9xj24fhqfsxwqcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(366004)(39850400004)(376002)(396003)(136003)(5660300002)(66476007)(66556008)(33716001)(2906002)(8936002)(8676002)(36916002)(6666004)(66946007)(4326008)(52116002)(83380400001)(6916009)(956004)(66574015)(9686003)(316002)(54906003)(16576012)(478600001)(186003)(86362001)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: F/Wcfa2d8VtcrDIo0jvx30XaM3IabjzUw5k8jMqG7E/j+64vrW1gICp7biaMYJAIWPobL2yMIF1L3UD02c0DStrSxYm1X61QMsSmtEc0ZYFx/su5pLscJDMsetbL7wgKrXlZeL5AathBc+n96q1RGKfq9IuYeBPO8SmBGM72mVTIJIqbTZoV9uJZKEw/QWC5uq9ShpKrwwKr4BK0aO5Aj1jeGUQsGOtHlKAFc5nWRk0lXLAjvAg70N83sq35+en6x01dnNRuSYDCu1qlU3nuiLYfv+wI6LeE/bBQBzreNPP9F94+oju7JpjUUVaULriU+4o4K1aFGHtxMl9G3nUZBat9F3JD2T5pjK35iINS5ZNdY1lyaxfcec8pt82xFMAUQR1e0+c3icWCUULPb4tDU96zcrrQ95pcyeF/S6fSMzrMG0nmadggWqd4mrBWVPfp7wGjq7CkFgMyA1E3JyCKO3LAfABnDa2YViaRDDLgkiJ57wr6BACKR+ZxZaKvQTuvlbLjC29VBdx9dSDq2Y2xFy0IbcMuB5Iu62TC986iF/4lPjpMAoA7+RAvgAE9Ixf3UNOHdl+8AHmjM/1ReWtR6QYPbkS/xQlRQ4UJroBcdXUdyTM79xAxxZuMqmlZLO9G8kt3eMaoTdAU/V+GBAPvPw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fa0e75-dd5c-4f53-2a0d-08d84825bd63
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2020 12:03:40.3766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGzr56cJdUGfJq3y9jVsQNCRmmvk6iK4zJZQFgJIppkuzl22+XaBupm8kAee1A5/9Xu56wlPLNztriNJ0VLahw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4685
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 24 August 2020 11:50:42 CEST Dan Carpenter wrote:
> On Thu, Aug 20, 2020 at 05:58:47PM +0200, Jerome Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > The protection of the management frames is mainly done by mac80211.
> > However, frames for the management of the BlockAck sessions are directl=
y
> > sent by the device. These frames have to be protected if MFP is in use.
> > So the driver has to pass the MFP configuration to the device.
> >
> > Until now, the BlockAck management frames were completely unprotected
> > whatever the status of the MFP negotiation. So, some devices dropped
> > these frames.
> >
> > The device has two knobs to control the MFP. One global and one per
> > station. Normally, the driver should always enable global MFP. Then it
> > should enable MFP on every station with which MFP was successfully
> > negotiated. Unfortunately, the older firmwares only provide the
> > global control.
> >
> > So, this patch enable global MFP as it is exposed in the beacon. Then i=
t
> > marks every station with which the MFP is effective.
> >
> > Thus, the support for the old firmwares is not so bad. It may only
> > encounter some difficulties to negotiate BA sessions when the local
> > device (the AP) is MFP capable (ieee80211w=3D1) but the station is not.
> > The only solution for this case is to upgrade the firmware.
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/sta.c | 22 +++++++++++++++++++++-
> >  1 file changed, 21 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > index ad63332f690c..9c1c8223a49f 100644
> > --- a/drivers/staging/wfx/sta.c
> > +++ b/drivers/staging/wfx/sta.c
> > @@ -434,7 +434,7 @@ int wfx_sta_add(struct ieee80211_hw *hw, struct iee=
e80211_vif *vif,
> >       wvif->link_id_map |=3D BIT(sta_priv->link_id);
> >       WARN_ON(!sta_priv->link_id);
> >       WARN_ON(sta_priv->link_id >=3D HIF_LINK_ID_MAX);
> > -     hif_map_link(wvif, sta->addr, 0, sta_priv->link_id);
> > +     hif_map_link(wvif, sta->addr, sta->mfp ? 2 : 0, sta_priv->link_id=
);
> >
> >       return 0;
> >  }
> > @@ -474,6 +474,25 @@ static int wfx_upload_ap_templates(struct wfx_vif =
*wvif)
> >       return 0;
> >  }
> >
> > +static void wfx_set_mfp_ap(struct wfx_vif *wvif)
> > +{
> > +     struct sk_buff *skb =3D ieee80211_beacon_get(wvif->wdev->hw, wvif=
->vif);
> > +     const int ieoffset =3D offsetof(struct ieee80211_mgmt, u.beacon.v=
ariable);
> > +     const u16 *ptr =3D (u16 *)cfg80211_find_ie(WLAN_EID_RSN,
> > +                                              skb->data + ieoffset,
> > +                                              skb->len - ieoffset);
> > +     const int pairwise_cipher_suite_count_offset =3D 8 / sizeof(u16);
> > +     const int pairwise_cipher_suite_size =3D 4 / sizeof(u16);
> > +     const int akm_suite_size =3D 4 / sizeof(u16);
> > +
> > +     if (ptr) {
> > +             ptr +=3D pairwise_cipher_suite_count_offset;
> > +             ptr +=3D 1 + pairwise_cipher_suite_size * *ptr;
>=20
> The value of "*ptr" comes from skb->data.  How do we know that it
> doesn't point to something beyond the end of the skb->data buffer?

I think the beacon come from hostapd (or any userspace application with
the necessary permissions). Indeed, it could be corrupted.

I have noticed that WLAN_EID_RSN is parsed at multiple places in the
kernel and I haven't seen any particular check :( (and WLAN_EID_RSN is
probably not the only dangerous IE).

Anyway, I am going to add a few checks on values of ptr.

> > +             ptr +=3D 1 + akm_suite_size * *ptr;
> > +             hif_set_mfp(wvif, *ptr & BIT(7), *ptr & BIT(6));
> > +     }
> > +}

--=20
J=E9r=F4me Pouiller


