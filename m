Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B314CE381
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 08:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiCEHwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 02:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCEHw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 02:52:28 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5DF4FC56
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 23:51:38 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id z30so8450272ybi.2
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 23:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/o1kjnWjgGNvQjpJi/ySlkvgbMCwezVPVBNag7xx6WA=;
        b=A4rJ0srk3Uiu3JEajAm6Ql1UI91zwRq52PNK94Hq63n/wCAuvh3VJatRYqOlQJrmKp
         QfebrOTccJQOXejSH6rWCCq1x/K5MKPPi6WAzKal8YzmYLNyIbcVs09RczRuTmifuZFf
         wCznlfEu/Zza8Tec58LX8mNyHtMsnzXGOjry04zOw23JrMkuwBhtJDa2lS98Z+UfAB9n
         ET0tLrZLqHK7sJbFBXgOl6ahjwjf1sZjYP9lSFZTKM1DLF1QNLbZ4K4rz8olJQTTWHeC
         VfqGaJ3uan14s1vs61JbagGudIlrwT2H/cRZ5GSsrgFK+stKcjLImP5bEg0NysGedGTF
         7gaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/o1kjnWjgGNvQjpJi/ySlkvgbMCwezVPVBNag7xx6WA=;
        b=IGdRLPmUlAFShB3NogxRnNIhOkzqRCtrCt/mjv4fk5yZzv0/FoTwKN2AXuRLyxkl9Y
         oh658Yc527HU7KelSjD01ELkGR4IYJP6P3fJBJ1qn4VPek8FAloTsZ6u2xsY2z6GSJwh
         YTbsNY1XL7rsEjbR/436FubECN32jW+ViiGVlbQI6G95KdqwSGSoDZNNESg/Cr0ThuXf
         1GaX6MO9pFYW764WJ18Tnt5wX8b7S47RlcECQFUxFRqkG+r+fk3akmfhdW7bru4SyCdZ
         oQosfV4BN+NuLpUZaNXpetTjWmEH1CBfldTX/8nDhrNKnqPcugOEZA++kfccZQSk3iGI
         BG6g==
X-Gm-Message-State: AOAM530HGbdnrANBHWd2tfp84euREypFbb1FfecSKeBs88pY25eo9Usp
        e8Zagy8nj1T96/DY1GZX8+9BhrzRfB3A4JEu+0qT9A==
X-Google-Smtp-Source: ABdhPJxIXwf6TRuS9Vyv/dLgQUeL9YnNazrM4r0fPRNM4zb7Rx938i5FPtYHLuYk3mVZByktJTRqI4TTGzMQesXUsng=
X-Received: by 2002:a25:3bd7:0:b0:628:f47a:f156 with SMTP id
 i206-20020a253bd7000000b00628f47af156mr1669657yba.468.1646466697871; Fri, 04
 Mar 2022 23:51:37 -0800 (PST)
MIME-Version: 1.0
References: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
 <20220215133546.2826837-1-josephsih@chromium.org> <DBB44155-EE79-4B1F-A947-FD6411FAC26D@holtmann.org>
In-Reply-To: <DBB44155-EE79-4B1F-A947-FD6411FAC26D@holtmann.org>
From:   Joseph Hwang <josephsih@google.com>
Date:   Sat, 5 Mar 2022 15:51:26 +0800
Message-ID: <CAHFy418qEFcpthsGmZ0aDnCpohoxCdxtJQPDdEP5xxfW5zz5YQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] Bluetooth: mgmt: add set_quality_report for MGMT_OP_SET_QUALITY_REPORT
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        pali@kernel.org, chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel, thank you for reviewing the patches! I have some questions.
Please read my replies in the lines below. Thanks!

On Thu, Feb 17, 2022 at 9:04 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Joseph,
>
> > This patch adds a new set_quality_report mgmt handler to set
> > the quality report feature. The feature is removed from the
> > experimental features at the same time.
> >
> > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> > ---
> >
> > Changes in v4:
> > - return current settings for set_quality_report.
> >
> > Changes in v3:
> > - This is a new patch to enable the quality report feature.
> >  The reading and setting of the quality report feature are
> >  removed from the experimental features.
> >
> > include/net/bluetooth/mgmt.h |   7 ++
> > net/bluetooth/mgmt.c         | 168 +++++++++++++++--------------------
> > 2 files changed, 81 insertions(+), 94 deletions(-)
> >
> > diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.=
h
> > index 83b602636262..74d253ff617a 100644
> > --- a/include/net/bluetooth/mgmt.h
> > +++ b/include/net/bluetooth/mgmt.h
> > @@ -109,6 +109,7 @@ struct mgmt_rp_read_index_list {
> > #define MGMT_SETTING_STATIC_ADDRESS   0x00008000
> > #define MGMT_SETTING_PHY_CONFIGURATION        0x00010000
> > #define MGMT_SETTING_WIDEBAND_SPEECH  0x00020000
> > +#define MGMT_SETTING_QUALITY_REPORT  0x00040000
> >
> > #define MGMT_OP_READ_INFO             0x0004
> > #define MGMT_READ_INFO_SIZE           0
> > @@ -838,6 +839,12 @@ struct mgmt_cp_add_adv_patterns_monitor_rssi {
> > } __packed;
> > #define MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZE       8
> >
> > +#define MGMT_OP_SET_QUALITY_REPORT           0x0057
> > +struct mgmt_cp_set_quality_report {
> > +     __u8    action;
> > +} __packed;
> > +#define MGMT_SET_QUALITY_REPORT_SIZE         1
> > +
> > #define MGMT_EV_CMD_COMPLETE          0x0001
> > struct mgmt_ev_cmd_complete {
> >       __le16  opcode;
> > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > index 5e48576041fb..ccd77b94905b 100644
> > --- a/net/bluetooth/mgmt.c
> > +++ b/net/bluetooth/mgmt.c
> > @@ -857,6 +857,10 @@ static u32 get_supported_settings(struct hci_dev *=
hdev)
> >
> >       settings |=3D MGMT_SETTING_PHY_CONFIGURATION;
> >
> > +     if (hdev && (aosp_has_quality_report(hdev) ||
> > +                  hdev->set_quality_report))
> > +             settings |=3D MGMT_SETTING_QUALITY_REPORT;
> > +
>
> the hdev check here is useless. The hdev structure is always valid.
>
> >       return settings;
> > }
> >
> > @@ -928,6 +932,9 @@ static u32 get_current_settings(struct hci_dev *hde=
v)
> >       if (hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED))
> >               settings |=3D MGMT_SETTING_WIDEBAND_SPEECH;
> >
> > +     if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
> > +             settings |=3D MGMT_SETTING_QUALITY_REPORT;
> > +
> >       return settings;
> > }
> >
> > @@ -3871,12 +3878,6 @@ static const u8 debug_uuid[16] =3D {
> > };
> > #endif
> >
> > -/* 330859bc-7506-492d-9370-9a6f0614037f */
> > -static const u8 quality_report_uuid[16] =3D {
> > -     0x7f, 0x03, 0x14, 0x06, 0x6f, 0x9a, 0x70, 0x93,
> > -     0x2d, 0x49, 0x06, 0x75, 0xbc, 0x59, 0x08, 0x33,
> > -};
> > -
> > /* a6695ace-ee7f-4fb9-881a-5fac66c629af */
> > static const u8 offload_codecs_uuid[16] =3D {
> >       0xaf, 0x29, 0xc6, 0x66, 0xac, 0x5f, 0x1a, 0x88,
> > @@ -3898,7 +3899,7 @@ static const u8 rpa_resolution_uuid[16] =3D {
> > static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev=
,
> >                                 void *data, u16 data_len)
> > {
> > -     char buf[102];   /* Enough space for 5 features: 2 + 20 * 5 */
> > +     char buf[82];   /* Enough space for 4 features: 2 + 20 * 4 */
> >       struct mgmt_rp_read_exp_features_info *rp =3D (void *)buf;
> >       u16 idx =3D 0;
> >       u32 flags;
> > @@ -3939,18 +3940,6 @@ static int read_exp_features_info(struct sock *s=
k, struct hci_dev *hdev,
> >               idx++;
> >       }
> >
> > -     if (hdev && (aosp_has_quality_report(hdev) ||
> > -                  hdev->set_quality_report)) {
> > -             if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
> > -                     flags =3D BIT(0);
> > -             else
> > -                     flags =3D 0;
> > -
> > -             memcpy(rp->features[idx].uuid, quality_report_uuid, 16);
> > -             rp->features[idx].flags =3D cpu_to_le32(flags);
> > -             idx++;
> > -     }
> > -
>
> (I see, you copied it from here. Yes, here you need to check for hdev!)
>
> >       if (hdev && hdev->get_data_path_id) {
> >               if (hci_dev_test_flag(hdev, HCI_OFFLOAD_CODECS_ENABLED))
> >                       flags =3D BIT(0);
> > @@ -4163,80 +4152,6 @@ static int set_rpa_resolution_func(struct sock *=
sk, struct hci_dev *hdev,
> >       return err;
> > }
> >
> > -static int set_quality_report_func(struct sock *sk, struct hci_dev *hd=
ev,
> > -                                struct mgmt_cp_set_exp_feature *cp,
> > -                                u16 data_len)
> > -{
> > -     struct mgmt_rp_set_exp_feature rp;
> > -     bool val, changed;
> > -     int err;
> > -
> > -     /* Command requires to use a valid controller index */
> > -     if (!hdev)
> > -             return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
> > -                                    MGMT_OP_SET_EXP_FEATURE,
> > -                                    MGMT_STATUS_INVALID_INDEX);
> > -
> > -     /* Parameters are limited to a single octet */
> > -     if (data_len !=3D MGMT_SET_EXP_FEATURE_SIZE + 1)
> > -             return mgmt_cmd_status(sk, hdev->id,
> > -                                    MGMT_OP_SET_EXP_FEATURE,
> > -                                    MGMT_STATUS_INVALID_PARAMS);
> > -
> > -     /* Only boolean on/off is supported */
> > -     if (cp->param[0] !=3D 0x00 && cp->param[0] !=3D 0x01)
> > -             return mgmt_cmd_status(sk, hdev->id,
> > -                                    MGMT_OP_SET_EXP_FEATURE,
> > -                                    MGMT_STATUS_INVALID_PARAMS);
> > -
> > -     hci_req_sync_lock(hdev);
> > -
> > -     val =3D !!cp->param[0];
> > -     changed =3D (val !=3D hci_dev_test_flag(hdev, HCI_QUALITY_REPORT)=
);
> > -
> > -     if (!aosp_has_quality_report(hdev) && !hdev->set_quality_report) =
{
> > -             err =3D mgmt_cmd_status(sk, hdev->id,
> > -                                   MGMT_OP_SET_EXP_FEATURE,
> > -                                   MGMT_STATUS_NOT_SUPPORTED);
> > -             goto unlock_quality_report;
> > -     }
> > -
> > -     if (changed) {
> > -             if (hdev->set_quality_report)
> > -                     err =3D hdev->set_quality_report(hdev, val);
> > -             else
> > -                     err =3D aosp_set_quality_report(hdev, val);
> > -
> > -             if (err) {
> > -                     err =3D mgmt_cmd_status(sk, hdev->id,
> > -                                           MGMT_OP_SET_EXP_FEATURE,
> > -                                           MGMT_STATUS_FAILED);
> > -                     goto unlock_quality_report;
> > -             }
> > -
> > -             if (val)
> > -                     hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
> > -             else
> > -                     hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
> > -     }
> > -
> > -     bt_dev_dbg(hdev, "quality report enable %d changed %d", val, chan=
ged);
> > -
> > -     memcpy(rp.uuid, quality_report_uuid, 16);
> > -     rp.flags =3D cpu_to_le32(val ? BIT(0) : 0);
> > -     hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
> > -
> > -     err =3D mgmt_cmd_complete(sk, hdev->id, MGMT_OP_SET_EXP_FEATURE, =
0,
> > -                             &rp, sizeof(rp));
> > -
> > -     if (changed)
> > -             exp_feature_changed(hdev, quality_report_uuid, val, sk);
> > -
> > -unlock_quality_report:
> > -     hci_req_sync_unlock(hdev);
> > -     return err;
> > -}
> > -
> > static int set_offload_codec_func(struct sock *sk, struct hci_dev *hdev=
,
> >                                 struct mgmt_cp_set_exp_feature *cp,
> >                                 u16 data_len)
> > @@ -4363,7 +4278,6 @@ static const struct mgmt_exp_feature {
> >       EXP_FEAT(debug_uuid, set_debug_func),
> > #endif
> >       EXP_FEAT(rpa_resolution_uuid, set_rpa_resolution_func),
> > -     EXP_FEAT(quality_report_uuid, set_quality_report_func),
> >       EXP_FEAT(offload_codecs_uuid, set_offload_codec_func),
> >       EXP_FEAT(le_simultaneous_roles_uuid, set_le_simultaneous_roles_fu=
nc),
> >
> > @@ -8653,6 +8567,71 @@ static int get_adv_size_info(struct sock *sk, st=
ruct hci_dev *hdev,
> >                                MGMT_STATUS_SUCCESS, &rp, sizeof(rp));
> > }
> >
> > +static int set_quality_report(struct sock *sk, struct hci_dev *hdev,
> > +                           void *data, u16 data_len)
> > +{
> > +     struct mgmt_cp_set_quality_report *cp =3D data;
> > +     bool enable, changed;
> > +     int err;
> > +
> > +     /* Command requires to use a valid controller index */
> > +     if (!hdev)
> > +             return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
> > +                                    MGMT_OP_SET_QUALITY_REPORT,
> > +                                    MGMT_STATUS_INVALID_INDEX);
> > +
> > +     /* Only 0 (off) and 1 (on) is supported */
> > +     if (cp->action !=3D 0x00 && cp->action !=3D 0x01)
> > +             return mgmt_cmd_status(sk, hdev->id,
> > +                                    MGMT_OP_SET_QUALITY_REPORT,
> > +                                    MGMT_STATUS_INVALID_PARAMS);
> > +
> > +     hci_req_sync_lock(hdev);
> > +
> > +     enable =3D !!cp->action;
> > +     changed =3D (enable !=3D hci_dev_test_flag(hdev, HCI_QUALITY_REPO=
RT));
> > +
> > +     if (!aosp_has_quality_report(hdev) && !hdev->set_quality_report) =
{
> > +             err =3D mgmt_cmd_status(sk, hdev->id,
> > +                                   MGMT_OP_SET_QUALITY_REPORT,
> > +                                   MGMT_STATUS_NOT_SUPPORTED);
> > +             goto unlock_quality_report;
> > +     }
> > +
> > +     if (changed) {
> > +             if (hdev->set_quality_report)
> > +                     err =3D hdev->set_quality_report(hdev, enable);
> > +             else
> > +                     err =3D aosp_set_quality_report(hdev, enable);
> > +
> > +             if (err) {
> > +                     err =3D mgmt_cmd_status(sk, hdev->id,
> > +                                           MGMT_OP_SET_QUALITY_REPORT,
> > +                                           MGMT_STATUS_FAILED);
> > +                     goto unlock_quality_report;
> > +             }
> > +
> > +             if (enable)
> > +                     hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
> > +             else
> > +                     hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
> > +     }
> > +
> > +     bt_dev_dbg(hdev, "quality report enable %d changed %d",
> > +                enable, changed);
> > +
> > +     err =3D send_settings_rsp(sk, MGMT_OP_SET_QUALITY_REPORT, hdev);
> > +     if (err < 0)
> > +             goto unlock_quality_report;
> > +
> > +     if (changed)
> > +             err =3D new_settings(hdev, sk);
> > +
> > +unlock_quality_report:
> > +     hci_req_sync_unlock(hdev);
> > +     return err;
> > +}
> > +
> > static const struct hci_mgmt_handler mgmt_handlers[] =3D {
> >       { NULL }, /* 0x0000 (no command) */
> >       { read_version,            MGMT_READ_VERSION_SIZE,
> > @@ -8779,6 +8758,7 @@ static const struct hci_mgmt_handler mgmt_handler=
s[] =3D {
> >       { add_adv_patterns_monitor_rssi,
> >                                  MGMT_ADD_ADV_PATTERNS_MONITOR_RSSI_SIZ=
E,
> >                                               HCI_MGMT_VAR_LEN },
> > +     { set_quality_report,      MGMT_SET_QUALITY_REPORT_SIZE },
> > };
> >
> > void mgmt_index_added(struct hci_dev *hdev)
>
> So this patch I actually get merged first.

I do not see this patch getting merged yet. I guess I still need to
remove the =E2=80=9Chdev=E2=80=9D that you mentioned above and re-submit th=
is patch?

>
> However we still need to figure out if this setting is suppose to survive=
 power off/on cycles. Right now as far as I can tell it is added to hci_dev=
_clear_volatile_flags and thus needs to be set again after power on.

Thank you for pointing this out. Whether the setting should survive
power off/on cycles is not mentioned in the AOSP BQR and Intel
telemetry specifications. I did a quick test on an Intel platform, the
setting does NOT survive over power cycles probably due to the HCI
Reset command during power off. Hence, I will need to address this
issue by restoring it explicitly. Please let me send separate patches
later to address this issue for both Intel and AOSP specs.

>
> Is this the expected behavior? I don=E2=80=99t think we want that. Since =
normally all other settings are restored after power on. And it is explicit=
ly mentioned in doc/mgmt-api.txt as well.

I will mention this in the Set Powered Command in doc/mgmt-api.txt in
the separate patches later.

>
> Regards
>
> Marcel
>
>


--=20

Joseph Shyh-In Hwang
Email: josephsih@google.com
