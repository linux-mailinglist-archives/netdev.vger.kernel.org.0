Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C47D59C4C3
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiHVRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbiHVRMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:12:46 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFD7D10C
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:12:41 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-11d7a859b3aso2435539fac.4
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 10:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=PrtiDQ9OPrQMRUdCwDdRm8WlD0zeJ8VLfdEjewyDClY=;
        b=NzRfMZ6yhNXzl8DnZrhKVgD5Td5QmNBo1q9vYfOsVcuVVBd+wJn2EyKR1BsCc3ZU26
         y2VQwy4jCtkF0ZKo/KZa8c0toqRuSKivApzEqN5OsEHa926iLkcmEcrbgKheKPGjeLej
         QeM0EaEtd8EOKjyeaNt0yLskJ9yZZVSTPUC+Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=PrtiDQ9OPrQMRUdCwDdRm8WlD0zeJ8VLfdEjewyDClY=;
        b=s9aA+K1oxfX57O7l+TU2gFXCF42K5YOryrLmv1ImBVmk65JpvXLiHqzO2xXVDydcUc
         ryHeWEYgouwdSdph8135LYkSe0VqoutkVYPwwMGYjKxWW8whjndtcVqIWd5OO1GFbb1y
         uyf18mZJ9ag1IP9/xmRD18LKsEbpxDH9JEYyxtEVEq3ARA/KJbcwAe/J8KUF4uWlg3H5
         gcvaNmjU2oncaWSz8o2oEaG0TxSjAZ3K/8e6u7BFD9xVNHe9fWOemgLodQZAx3zTebPq
         NQ8/nQRSdWewH6AeATiViKeAwLtP7C3k8Zi/eYo2ffG/SQ32MqF+M9c9Ea3uer8GzyNh
         ARWQ==
X-Gm-Message-State: ACgBeo3/NfAqO0dleeo7CiQHRtAOxEWqiVhqzjJm3uzrLUxgHUnCUZOd
        r6sKAhdWlfuR/rP4G11nxr/K5JerSsqKwQUkVBGv7fI7BNA3w7Km/nmfN+CprZXyGBJo8fRC2Yc
        ZiMDLK4Gb2bbW8W2b6gu4MfE=
X-Google-Smtp-Source: AA6agR4VPj3Omh7V60gBLwSLM7j3BS15r+4QNlm3ZSpGChFCdThHZlAHKDEJ4XaAZTnMqHCgFdBSfvYMS+4x1SEc5FY=
X-Received: by 2002:a05:6870:9a1f:b0:11c:86da:edf6 with SMTP id
 fo31-20020a0568709a1f00b0011c86daedf6mr10069172oab.120.1661188360643; Mon, 22
 Aug 2022 10:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220722122956.841786-1-alvin@pqrs.dk> <20220722122956.841786-2-alvin@pqrs.dk>
 <CA+8PC_fYF7aZCBEweF5s0+8Rr_5yRQcMutFJ2gCKs6QEdmrw6g@mail.gmail.com> <20220817085015.z3ubo4vhi5jeiopo@bang-olufsen.dk>
In-Reply-To: <20220817085015.z3ubo4vhi5jeiopo@bang-olufsen.dk>
From:   Franky Lin <franky.lin@broadcom.com>
Date:   Mon, 22 Aug 2022 10:12:14 -0700
Message-ID: <CA+8PC_fGeV09ve=VE=V9yneghg_rfDZmEAZBVmA9rivinMmd5A@mail.gmail.com>
Subject: Re: [PATCH -next 1/2] brcmfmac: Support multiple AP interfaces and
 fix STA disconnection issue
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alvin@pqrs.dk>,
        Arend van Spriel <aspriel@gmail.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Soon Tak Lee <soontak.lee@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000002a48e105e6d78e72"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000002a48e105e6d78e72
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alvin,

On Wed, Aug 17, 2022 at 1:50 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> w=
rote:
>
> Hi Franky,
>
> On Wed, Aug 10, 2022 at 02:32:06PM -0700, Franky Lin wrote:
> > On Fri, Jul 22, 2022 at 5:30 AM Alvin =C5=A0ipraga <alvin@pqrs.dk> wrot=
e:
> > >
> > > From: Soontak Lee <soontak.lee@cypress.com>
> > >
> > > Support multiple AP interfaces for STA + AP + AP usecase.
> >
> > AFAIK, Broadcom's fullmac firmware doesn't support such 2AP + 1STA use =
case.
>
> Thanks for the clarification. The series should be ignored by Kalle
> then.
>
> >
> > > And fix STA disconnection when deactivating AP interface.
> > >
> > > Signed-off-by: Soontak Lee <soontak.lee@cypress.com>
> > > Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> > > Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> > > Signed-off-by: Alvin =C5=A0ipraga <alsi@bang-olufsen.dk>
> > > ---
> > >  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 48 +++++++++++++++--=
--
> > >  .../broadcom/brcm80211/brcmfmac/cfg80211.h    |  1 +
> > >  .../broadcom/brcm80211/brcmfmac/common.c      |  5 ++
> > >  3 files changed, 44 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg8021=
1.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> > > index 3ae6779fe153..856fd5516ddf 100644
> > > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> > > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> > > @@ -4747,6 +4747,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, st=
ruct net_device *ndev,
> > >                   settings->inactivity_timeout);
> > >         dev_role =3D ifp->vif->wdev.iftype;
> > >         mbss =3D ifp->vif->mbss;
> > > +       brcmf_dbg(TRACE, "mbss %s\n", mbss ? "enabled" : "disabled");
> > >
> > >         /* store current 11d setting */
> > >         if (brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_REGULATORY,
> > > @@ -4961,6 +4962,9 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, st=
ruct net_device *ndev,
> > >         if ((err) && (!mbss)) {
> > >                 brcmf_set_mpc(ifp, 1);
> > >                 brcmf_configure_arp_nd_offload(ifp, true);
> > > +       } else {
> > > +               cfg->num_softap++;
> > > +               brcmf_dbg(TRACE, "Num of SoftAP %u\n", cfg->num_softa=
p);
> > >         }
> > >         return err;
> > >  }
> > > @@ -4975,6 +4979,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy =
*wiphy, struct net_device *ndev,
> > >         s32 err;
> > >         struct brcmf_fil_bss_enable_le bss_enable;
> > >         struct brcmf_join_params join_params;
> > > +       s32 apsta =3D 0;
> > >
> > >         brcmf_dbg(TRACE, "Enter\n");
> > >
> > > @@ -4983,6 +4988,27 @@ static int brcmf_cfg80211_stop_ap(struct wiphy=
 *wiphy, struct net_device *ndev,
> > >                 /* first to make sure they get processed by fw. */
> > >                 msleep(400);
> > >
> > > +               cfg->num_softap--;
> > > +
> > > +               /* Clear bss configuration and SSID */
> > > +               bss_enable.bsscfgidx =3D cpu_to_le32(ifp->bsscfgidx);
> > > +               bss_enable.enable =3D cpu_to_le32(0);
> > > +               err =3D brcmf_fil_iovar_data_set(ifp, "bss", &bss_ena=
ble,
> > > +                                              sizeof(bss_enable));
> > > +               if (err < 0)
> > > +                       brcmf_err("bss_enable config failed %d\n", er=
r);
> > > +
> > > +               memset(&join_params, 0, sizeof(join_params));
> > > +               err =3D brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
> > > +                                            &join_params, sizeof(joi=
n_params));
> > > +               if (err < 0)
> > > +                       bphy_err(drvr, "SET SSID error (%d)\n", err);
> > > +
> > > +               if (cfg->num_softap) {
> > > +                       brcmf_dbg(TRACE, "Num of SoftAP %u\n", cfg->n=
um_softap);
> > > +                       return 0;
> > > +               }
> > > +
> > >                 if (profile->use_fwauth !=3D BIT(BRCMF_PROFILE_FWAUTH=
_NONE)) {
> > >                         if (profile->use_fwauth & BIT(BRCMF_PROFILE_F=
WAUTH_PSK))
> > >                                 brcmf_set_pmk(ifp, NULL, 0);
> > > @@ -5000,17 +5026,18 @@ static int brcmf_cfg80211_stop_ap(struct wiph=
y *wiphy, struct net_device *ndev,
> > >                 if (ifp->bsscfgidx =3D=3D 0)
> > >                         brcmf_fil_iovar_int_set(ifp, "closednet", 0);
> > >
> > > -               memset(&join_params, 0, sizeof(join_params));
> > > -               err =3D brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_SSID,
> > > -                                            &join_params, sizeof(joi=
n_params));
> > > -               if (err < 0)
> > > -                       bphy_err(drvr, "SET SSID error (%d)\n", err);
> > > -               err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
> > > -               if (err < 0)
> > > -                       bphy_err(drvr, "BRCMF_C_DOWN error %d\n", err=
);
> > > -               err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_AP, 0)=
;
> > > +               err =3D brcmf_fil_iovar_int_get(ifp, "apsta", &apsta)=
;
> > >                 if (err < 0)
> > > -                       bphy_err(drvr, "setting AP mode failed %d\n",=
 err);
> > > +                       brcmf_err("wl apsta failed (%d)\n", err);
> > > +
> > > +               if (!apsta) {
> > > +                       err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_DO=
WN, 1);
> > > +                       if (err < 0)
> > > +                               bphy_err(drvr, "BRCMF_C_DOWN error %d=
\n", err);
> > > +                       err =3D brcmf_fil_cmd_int_set(ifp, BRCMF_C_SE=
T_AP, 0);
> > > +                       if (err < 0)
> > > +                               bphy_err(drvr, "Set AP mode error %d\=
n", err);
> > > +               }
> > >                 if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MBSS))
> > >                         brcmf_fil_iovar_int_set(ifp, "mbss", 0);
> > >                 brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
> > > @@ -7641,6 +7668,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_atta=
ch(struct brcmf_pub *drvr,
> > >
> > >         cfg->wiphy =3D wiphy;
> > >         cfg->pub =3D drvr;
> > > +       cfg->num_softap =3D 0;
> > >         init_vif_event(&cfg->vif_event);
> > >         INIT_LIST_HEAD(&cfg->vif_list);
> > >
> > > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg8021=
1.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
> > > index e90a30808c22..e4ebc2fa6ebb 100644
> > > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
> > > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
> > > @@ -371,6 +371,7 @@ struct brcmf_cfg80211_info {
> > >         struct brcmf_cfg80211_wowl wowl;
> > >         struct brcmf_pno_info *pno;
> > >         u8 ac_priority[MAX_8021D_PRIO];
> > > +       u8 num_softap;
> > >  };
> > >
> > >  /**
> > > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.=
c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> > > index fe01da9e620d..83e023a22f9b 100644
> > > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> > > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
> > > @@ -303,6 +303,11 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
> > >                 brcmf_dbg(INFO, "CLM version =3D %s\n", clmver);
> > >         }
> > >
> > > +       /* set apsta */
> > > +       err =3D brcmf_fil_iovar_int_set(ifp, "apsta", 1);
> > > +       if (err)
> > > +               brcmf_info("failed setting apsta, %d\n", err);
> > > +
> >
> > I do not understand why entering apsta mode by default. The mode is
> > supposed to be enabled only when an AP interface is created in
> > brcmf_cfg80211_start_ap. I think one of the side effects of apsta mode
> > is that memory footprint significantly increases. It should remain
> > disabled for STA only mode (which is the major use case) for better
> > performance.
>
> By better performance, do you just mean "lower chance of memory
> exhaustion"? If so, surely the firmware would be designed such that it
> doesn't run out of memory under the advertised use-cases (STA, AP+STA
> etc.), regardless of the current apsta setting?

I think some packet related buffers will be adjusted for apsta mode so
the sta mode performance will hurt because there is less buffer to
use.

Another significant impact I am sure about is some power saving
features will be turned off once apsta mode is enabled. So the chip
will drain more power even the AP interface is not created.

Regards,
- Franky


>
> I would hope that somebody from Infineon could chime in here, as I am
> not privy to the FW design.
>
> Kind regards,
> Alvin
>
> >
> > Regards,
> > - Franky
> >
> > >         /* set mpc */
> > >         err =3D brcmf_fil_iovar_int_set(ifp, "mpc", 1);
> > >         if (err) {
> > > --
> > > 2.37.0
> > >
> >
> > --
> > This electronic communication and the information and any files transmi=
tted
> > with it, or attached to it, are confidential and are intended solely fo=
r
> > the use of the individual or entity to whom it is addressed and may con=
tain
> > information that is confidential, legally privileged, protected by priv=
acy
> > laws, or otherwise restricted from disclosure to anyone else. If you ar=
e
> > not the intended recipient or the person responsible for delivering the
> > e-mail to the intended recipient, you are hereby notified that any use,
> > copying, distributing, dissemination, forwarding, printing, or copying =
of
> > this e-mail is strictly prohibited. If you received this e-mail in erro=
r,
> > please return the e-mail to the sender, delete it from your computer, a=
nd
> > destroy any printed copy of it.

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--0000000000002a48e105e6d78e72
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
kjY1BnpEEF8LCZw5w2Xi0x6RQM2QSte4iTxLzeLvVFJLJj1KtNi1VWvXYCzMuTbhLMikZHLqMxkf
4oNJJGHKt8xzvUC1Tu5vjMbOCEgQD5Ikz2gOLwIDAQABo4IB2DCCAdQwDgYDVR0PAQH/BAQDAgWg
MIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9iYWxzaWdu
LmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUFBzABhjVo
dHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMDBNBgNV
HSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2ln
bi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAiBgNVHREEGzAZ
gRdmcmFua3kubGluQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAW
gBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEKPgvCN0J2rCGluIqTKO+62QXKgwDQYJ
KoZIhvcNAQELBQADggEBAIlQsf/NPacuX/yG96v+J49ix14aQ6BYdmSvmuabgx/vWk/pjLsQkPBD
lW4mwEblmXeGUDOZBE494ybTSYo7XWTuFdWd1FuCipxnzMJ+WAtf7NiXW8Ayrfttq6i+4+AAjwHu
gs5HcDKeBuQEC3XVssC/06M32EuxlkCxKrQXNqYzkMJ5fdLLVPpFjjsK2fH/X2X8muS8KT4GXbUs
HGETPmDhjFb5DzuWn33x2GmWziWNQExeyehcQPFhE0rJMX6lLa2IOMLRi8FNPyb3Fa28AOyh4XOh
sQ+3AGeTN+7hJgf8DM9I47l561iQfieaicKnM/WPpmbIMuqLHbCOvgK2PFExggJtMIICaQIBATBr
MFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9i
YWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw/qDnpsvwdlpxf7x0wDQYJYIZI
AWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHjheL7Mx57z0yOFAKyATC5LwANYXHpDNAoXU8qD
btdlMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDgyMjE3MTI0
MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQB
AjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkq
hkiG9w0BAQEFAASCAQCCh30Ui6jyHUdw5QT8Csme5X6ezGjXR/tpu7Py2T9tSu6bOLrXVNGZZUAA
iFIX6tkBxv3PUQeZjyMgbpCiYRrST9hEMHkQHHAYFugXsO3Kl0m9RUyRCzyUbM5xkJNtc03OzkAZ
9Ioj6779SCXnZq39qHuNYEwygcRHL9YteT7o3vQvRjQ0Kn6g/AJ10ADrhSmF8Kr42z8vezN82IEJ
9Jfd5yuR/kIqL7YAYdrW3KnrJsFzInxRgES9BtNj4AY5esyRqrirPW9gXtuOTD1EAjMcb4ZeTHuo
EszlXaN2p/pE2nrRIouQfHCVcq1QeQ3q+d1+C4mcYIHTxJBqE9CFLZhb
--0000000000002a48e105e6d78e72--
