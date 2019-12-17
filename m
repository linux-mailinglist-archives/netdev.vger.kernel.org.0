Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD02B122EDF
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 15:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfLQOfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 09:35:19 -0500
Received: from mail-dm6nam11on2048.outbound.protection.outlook.com ([40.107.223.48]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726402AbfLQOfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 09:35:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5o8qvWYYYt/dVvhMHVooe4dHPWhUFgviG88VchTmkXKDWWuDJytMjgxiXT87xzcMcGk6BrlFfhQenAIIztKHFT0dLIKupYo+LaYUtERXjmXA/LWjYSZEKmMeP2IS+s5PYN+SJxVK65ut2QokbcjNfs0rvfLxhpR/McxGu4xoqtyyVskNGo6AQPpNzSrIuDsNbEmEI6hKxmJ+Qs8XYl/HqMYRoer2LuaV9+BNP9aN7OxgbkUGCm/b/GDs7s+GXeVa2SSrt8GTUi1WkZ5zkgKOLnQSdsztVfkfedJveU6bk5I3giL0kTFzUEbz5L72po0Ryz0rj4C4/CytL0+ofVT0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0431jdAdwH8QaOWg27l2Of05DPOcr5VIfbp2pnxOfQ=;
 b=kd3Aoge/wDc6ooNBq3f8ZSPrnJL6V7mfrBCvNi46QOXGx19+I98VeismrWk5Cc/MkarLBSI2A6IoU3WjIr6UNavuReZtvOfkik68hIKnO6qQWbJAVRg2IZ8ARuvLMjewixwW/brDDKTBG/Zfl8UTPZTyFXQDstEVAK2GVVrTpwun+K2Rv0s6/nA8Za07aM7LctxKsFtV25082xvlzMHimR2YL7nRCqMnny/BrF5+ESdqx241/eq9H/rwAu17E+qITamnyM1KyBtZo5v+/L6JmHkwEqvesauQWw255VzBWrPTpvJOi4qyUut/vURtT0htP4QBReRJIQms1unV/J3KPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0431jdAdwH8QaOWg27l2Of05DPOcr5VIfbp2pnxOfQ=;
 b=bBLVZySme55nu4RWudAyZPhFm9HNP+TyfWPj42pOiOXOjAvEyy3XRBQnIrrv9fH/ZukC0QuwtLSL/7xbdf0G1n5pobSdU8p8YfQGHY3NsLHRrHeloNqjHkbJNsDEselS2NBzD2SXHrGfIE1QqeuGH1VA+T/Ce0rKNPudnvBCIPE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3917.namprd11.prod.outlook.com (20.179.149.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 14:35:14 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 14:35:13 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 01/55] staging: wfx: fix the cache of rate policies on
 interface reset
Thread-Topic: [PATCH 01/55] staging: wfx: fix the cache of rate policies on
 interface reset
Thread-Index: AQHVtDK/FGlLQ2gb2UOMnSXAR2+Ao6e+OG+AgAAtjAA=
Date:   Tue, 17 Dec 2019 14:35:13 +0000
Message-ID: <3810318.2NmXUpVtm0@pc-42>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
 <20191216170302.29543-2-Jerome.Pouiller@silabs.com>
 <20191217115211.GA3141324@kroah.com>
In-Reply-To: <20191217115211.GA3141324@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ef2abe8-d4a6-40a2-ecc2-08d782fe5402
x-ms-traffictypediagnostic: MN2PR11MB3917:
x-microsoft-antispam-prvs: <MN2PR11MB3917642D15C848D1E9C02FE293500@MN2PR11MB3917.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(346002)(366004)(39860400002)(136003)(376002)(396003)(189003)(199004)(33716001)(186003)(4326008)(66446008)(91956017)(5660300002)(81166006)(66476007)(64756008)(66946007)(71200400001)(45080400002)(6506007)(8936002)(54906003)(6916009)(478600001)(8676002)(316002)(66574012)(6512007)(2906002)(76116006)(9686003)(86362001)(81156014)(66556008)(26005)(6486002)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3917;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KmApuDQXwWzNR9h80vBGjs30PcWnuN+sXBbhnpE+zGYPjhsKUMGFunpVSB54NENVJzARtB8Zp8AxMGvoDOuEqarZNsHiAxH4s5cPKgg1IzZhWDKD7j44eVj5mP8K4zYWTzuf5ef/NMGscOHRWWaMagFTd0sFItrWeyyBKwRgNZiDn6abJRWGKpaG8auXpZJDOe29aH+JHcJ67ZnHh/mpd5CE7BUM8t8FnKWw73+I/Cu0Bk8zPaM5GQEfz8E6ZbCgv4wjhbCwvmgk7gfaN+4OUEUn5kFCzSCTqdN8VYc3NMgeuDsCH5Wg83kw9MeiQerrvzIznJ0j/ngh+2zcKuxerPJUOGtdMFY0YAioYbdxGnRiUNenROvZ+jbxDbQUg/ail5JHn9Q8YnZ/lpGKB6oaYWevIgQVtyftXr3ht2wLz0fKzIvUxnU4Mobtl2aELmAO01oP/6une7q0yY8wZZ3z0BFGg0kV42G340Axk/VznFAM6z306CcRUH6J1vcJeBKy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <0B9AF899AEE67A4894F6D55A363DC177@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef2abe8-d4a6-40a2-ecc2-08d782fe5402
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 14:35:13.5458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /bj8gppgiicv+N+czxrgx1cgJdopjtUDwMho1B6luVPibXXgr+kxldN5g1ptruT9r+0C55IYYdRy2RbZYmYQhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3917
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 17 December 2019 12:52:11 CET Greg Kroah-Hartman wrote:
> On Mon, Dec 16, 2019 at 05:03:33PM +0000, J=E9r=F4me Pouiller wrote:
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> >
> > Device and driver maintain a cache of rate policies (aka.
> > tx_retry_policy in hardware API).
> >
> > When hif_reset() is sent to hardware, device resets its cache of rate
> > policies. In order to keep driver in sync, it is necessary to do the
> > same on driver.
> >
> > Note, when driver tries to use a rate policy that has not been defined
> > on device, data is sent at 1Mbps. So, this patch should fix abnormal
> > throughput observed sometime after a reset of the interface.
> >
> > Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> > ---
> >  drivers/staging/wfx/data_tx.c | 3 +--
> >  drivers/staging/wfx/data_tx.h | 1 +
> >  drivers/staging/wfx/sta.c     | 6 +++++-
> >  3 files changed, 7 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_t=
x.c
> > index b722e9773232..02f001dab62b 100644
> > --- a/drivers/staging/wfx/data_tx.c
> > +++ b/drivers/staging/wfx/data_tx.c
> > @@ -249,7 +249,7 @@ static int wfx_tx_policy_upload(struct wfx_vif *wvi=
f)
> >       return 0;
> >  }
> >
> > -static void wfx_tx_policy_upload_work(struct work_struct *work)
> > +void wfx_tx_policy_upload_work(struct work_struct *work)
> >  {
> >       struct wfx_vif *wvif =3D
> >               container_of(work, struct wfx_vif, tx_policy_upload_work)=
;
> > @@ -270,7 +270,6 @@ void wfx_tx_policy_init(struct wfx_vif *wvif)
> >       spin_lock_init(&cache->lock);
> >       INIT_LIST_HEAD(&cache->used);
> >       INIT_LIST_HEAD(&cache->free);
> > -     INIT_WORK(&wvif->tx_policy_upload_work, wfx_tx_policy_upload_work=
);
> >
> >       for (i =3D 0; i < HIF_MIB_NUM_TX_RATE_RETRY_POLICIES; ++i)
> >               list_add(&cache->cache[i].link, &cache->free);
> > diff --git a/drivers/staging/wfx/data_tx.h b/drivers/staging/wfx/data_t=
x.h
> > index 29faa5640516..a0f9ae69baf5 100644
> > --- a/drivers/staging/wfx/data_tx.h
> > +++ b/drivers/staging/wfx/data_tx.h
> > @@ -61,6 +61,7 @@ struct wfx_tx_priv {
> >  } __packed;
> >
> >  void wfx_tx_policy_init(struct wfx_vif *wvif);
> > +void wfx_tx_policy_upload_work(struct work_struct *work);
> >
> >  void wfx_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *cont=
rol,
> >           struct sk_buff *skb);
> > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > index 29848a202ab4..471dd15b227f 100644
> > --- a/drivers/staging/wfx/sta.c
> > +++ b/drivers/staging/wfx/sta.c
> > @@ -592,6 +592,7 @@ static void wfx_do_unjoin(struct wfx_vif *wvif)
> >       wfx_tx_flush(wvif->wdev);
> >       hif_keep_alive_period(wvif, 0);
> >       hif_reset(wvif, false);
> > +     wfx_tx_policy_init(wvif);
> >       hif_set_output_power(wvif, wvif->wdev->output_power * 10);
> >       wvif->dtim_period =3D 0;
> >       hif_set_macaddr(wvif, wvif->vif->addr);
> > @@ -880,8 +881,10 @@ static int wfx_update_beaconing(struct wfx_vif *wv=
if)
> >               if (wvif->state !=3D WFX_STATE_AP ||
> >                   wvif->beacon_int !=3D conf->beacon_int) {
> >                       wfx_tx_lock_flush(wvif->wdev);
> > -                     if (wvif->state !=3D WFX_STATE_PASSIVE)
> > +                     if (wvif->state !=3D WFX_STATE_PASSIVE) {
> >                               hif_reset(wvif, false);
> > +                             wfx_tx_policy_init(wvif);
> > +                     }
> >                       wvif->state =3D WFX_STATE_PASSIVE;
> >                       wfx_start_ap(wvif);
> >                       wfx_tx_unlock(wvif->wdev);
> > @@ -1567,6 +1570,7 @@ int wfx_add_interface(struct ieee80211_hw *hw, st=
ruct ieee80211_vif *vif)
> >       INIT_WORK(&wvif->set_cts_work, wfx_set_cts_work);
> >       INIT_WORK(&wvif->unjoin_work, wfx_unjoin_work);
> >
> > +     INIT_WORK(&wvif->tx_policy_upload_work, wfx_tx_policy_upload_work=
);
> >       mutex_unlock(&wdev->conf_mutex);
> >
> >       hif_set_macaddr(wvif, vif->addr);
>=20
> Meta-comment here.
>=20
> I've been having to hand-edit your patches to get them to be able to
> apply so far, which is fine for 1-10 patches at a time, but when staring
> down a 55-patch series, that's not ok for my end.
>=20
> The problem is that your email client is turning everything into base64
> text.  On it's own, that's fine, but when doing so it turns the
> line-ends from unix ones, into dos line-ends.  So, when git decodes the
> base64 text into "plain text" the patch obviously does not apply due to
> the line-ends not matching up.
>=20
> Any chance you can fix your email client to not convert the line-ends?

Arg... I apologize for that. Yes, I will fix it and re-send the
pull-request.

For the record:

In fact, the conversions to CR-LF and to base64 is done by the SMTP
server that I use (Microsoft Exchange... useless to say that I do not
administrate this server).

I have already noticed that my SMTP server did weird things. So, I
configured git to encode in base64 itself.
However, the configuration line "sendemail.transferEncoding" is ignored
in my version of git (2.20) (--transfer-encoding=3Dbase64 continue to
work). Fortunately, the problem seems fixed with git 2.24.

--=20
J=E9r=F4me Pouiller

