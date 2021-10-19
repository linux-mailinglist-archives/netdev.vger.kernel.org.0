Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B3E433585
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhJSMOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235431AbhJSMOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 08:14:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8357C061746
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:11:48 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id v195so2355087ybb.0
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 05:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=imTFDrWe85v4P6kkmQziiHJ0XlRBvngkTyOsy1ovX1A=;
        b=MHQ1lkouaegpQAmfQVB6poDsGHxVDgGqpCqsaU8e2cYImbn17EDdTRHxwb4Xoiw+fc
         xLUwt0nMvHga7UHcu5wGsAWDCmAg3IEjIBVx268YEEcqmBTo+NNB8HEdaCQLvHryMCgz
         hJvUxJ/zcDwpl9gMxLyKTWxqnQqEQwftQUks61MjH5UOaUGNr1ca/h0jv05ULEBtXZ1/
         ZQrkZMfiHQ5+q8fvg2FwDy4jAslfWEu1eLybh3xVAa8Dh2pMg2SfH9lw2/Dmvf5Snfa9
         zd8SoXV1lwajus2VU1648HU3srnLpgM6AfTEfybCRFicnXlC+K/hgFGQlBDIn4UVLO14
         qyig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=imTFDrWe85v4P6kkmQziiHJ0XlRBvngkTyOsy1ovX1A=;
        b=XSGEEqlSxUtDgvhGAyIM/cKs/4D+3ipgJxqSjWD9i8VUBKSyS3ZOYUTyuz8ZGkTZu5
         R3kukpyf1prn0E9Anmooiz3WMVUaYuoW8m34QPpv95hSjyBQV3Mx1y2jSDMX5ptVWI9a
         v+bBQ5+j4oHHdSfJVrz8+lI4aeykJDXvu+5sZPkUWFXx5DGMr7LDUYENpmTuLPiRGn1Y
         PK30zAOkGkyVpHJovgcE21Sv7JMc8g/33QNZ+p8xYbxg9A6t08y2bUg5/bdP606wi/c5
         deieWwtwYqPJAMhpyzKhL2XXE78Ah/J9mLaYlYyj3KER63BWdtgiv2oSj0aLcxxyvnVY
         Ta2g==
X-Gm-Message-State: AOAM532CPNzxiqZQE3svVm4AeZBlwviEaJrrJ2oi0pZFe0F/kcpWsvqm
        oIt7K9WhA/XB6yfmEE4Bme+VHM/aNXnHkLTUh99d5Q==
X-Google-Smtp-Source: ABdhPJxpGMJU0jUkBjGwARUpg9mOUyflDlUDvPVtfk54oNFIqj7YInNVhE+/JaXLBYpwo6bBlo3ZdmQ+NK7l2BQu5/Y=
X-Received: by 2002:a25:3817:: with SMTP id f23mr34089287yba.436.1634645507522;
 Tue, 19 Oct 2021 05:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210926150657.v4.1.Iaa4a0269e51d8e8d8784a6ac8e05899b49a1377d@changeid>
 <4A480983-CAF2-46B7-B462-9BC84E1783CC@holtmann.org>
In-Reply-To: <4A480983-CAF2-46B7-B462-9BC84E1783CC@holtmann.org>
From:   Joseph Hwang <josephsih@google.com>
Date:   Tue, 19 Oct 2021 20:11:35 +0800
Message-ID: <CAHFy41-sPBtMDtA7pmQz2Ey-3saaeKREX19uyHe20mnX6ngnTQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] Bluetooth: aosp: Support AOSP Bluetooth Quality Report
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel:

  Thanks for the RFC. I have fixed the patches per your request and
submitted them for re-review.

Thanks and regards!


On Tue, Sep 28, 2021 at 6:45 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Joseph,
>
> > This patch adds the support of the AOSP Bluetooth Quality Report
> > (BQR) events.
> >
> > Multiple vendors have supported the AOSP Bluetooth Quality Report.
> > When a Bluetooth controller supports the capability, it can enable
> > the capability through hci_set_aosp_capable. Then hci_core will
> > set up the hdev->set_quality_report callback accordingly.
> >
> > Note that Intel also supports a distinct telemetry quality report
> > specification. Intel sets up the hdev->set_quality_report callback
> > in the btusb driver module.
> >
> > Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> >
> > ---
> >
> > Changes in v4:
> > - Move the AOSP BQR support from the driver level to net/bluetooth/aosp=
.
> > - Fix the drivers to use hci_set_aosp_capable to enable aosp.
> > - Add Mediatek to support the capability too.
> >
> > Changes in v3:
> > - Fix the auto build test ERROR
> >  "undefined symbol: btandroid_set_quality_report" that occurred
> >  with some kernel configs.
> > - Note that the mgmt-tester "Read Exp Feature - Success" failed.
> >  But on my test device, the same test passed. Please kindly let me
> >  know what may be going wrong. These patches do not actually
> >  modify read/set experimental features.
> > - As to CheckPatch failed. No need to modify the MAINTAINERS file.
> >  Thanks.
> >
> > Changes in v2:
> > - Fix the titles of patches 2/3 and 3/3 and reduce their lengths.
> >
> > net/bluetooth/aosp.c     | 79 ++++++++++++++++++++++++++++++++++++++++
> > net/bluetooth/aosp.h     |  7 ++++
> > net/bluetooth/hci_core.c | 17 +++++++++
> > 3 files changed, 103 insertions(+)
> >
> > diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
> > index a1b7762335a5..c2b22bc83fb2 100644
> > --- a/net/bluetooth/aosp.c
> > +++ b/net/bluetooth/aosp.c
> > @@ -33,3 +33,82 @@ void aosp_do_close(struct hci_dev *hdev)
> >
> >       bt_dev_dbg(hdev, "Cleanup of AOSP extension");
> > }
> > +
> > +/* BQR command */
> > +#define BQR_OPCODE                   hci_opcode_pack(0x3f, 0x015e)
> > +
> > +/* BQR report action */
> > +#define REPORT_ACTION_ADD            0x00
> > +#define REPORT_ACTION_DELETE         0x01
> > +#define REPORT_ACTION_CLEAR          0x02
> > +
> > +/* BQR event masks */
> > +#define QUALITY_MONITORING           BIT(0)
> > +#define APPRAOCHING_LSTO             BIT(1)
> > +#define A2DP_AUDIO_CHOPPY            BIT(2)
> > +#define SCO_VOICE_CHOPPY             BIT(3)
> > +
> > +#define DEFAULT_BQR_EVENT_MASK       (QUALITY_MONITORING | APPRAOCHING=
_LSTO | \
> > +                              A2DP_AUDIO_CHOPPY | SCO_VOICE_CHOPPY)
> > +
> > +/* Reporting at milliseconds so as not to stress the controller too mu=
ch.
> > + * Range: 0 ~ 65535 ms
> > + */
> > +#define DEFALUT_REPORT_INTERVAL_MS   5000
> > +
> > +struct aosp_bqr_cp {
> > +     __u8    report_action;
> > +     __u32   event_mask;
> > +     __u16   min_report_interval;
> > +} __packed;
> > +
> > +static int enable_quality_report(struct hci_dev *hdev)
> > +{
> > +     struct sk_buff *skb;
> > +     struct aosp_bqr_cp cp;
> > +
> > +     cp.report_action =3D REPORT_ACTION_ADD;
> > +     cp.event_mask =3D DEFAULT_BQR_EVENT_MASK;
> > +     cp.min_report_interval =3D DEFALUT_REPORT_INTERVAL_MS;
> > +
> > +     skb =3D __hci_cmd_sync(hdev, BQR_OPCODE, sizeof(cp), &cp,
> > +                          HCI_CMD_TIMEOUT);
> > +     if (IS_ERR(skb)) {
> > +             bt_dev_err(hdev, "Enabling Android BQR failed (%ld)",
> > +                        PTR_ERR(skb));
> > +             return PTR_ERR(skb);
> > +     }
> > +
> > +     kfree_skb(skb);
> > +     return 0;
> > +}
> > +
> > +static int disable_quality_report(struct hci_dev *hdev)
> > +{
> > +     struct sk_buff *skb;
> > +     struct aosp_bqr_cp cp =3D { 0 };
> > +
> > +     cp.report_action =3D REPORT_ACTION_CLEAR;
> > +
> > +     skb =3D __hci_cmd_sync(hdev, BQR_OPCODE, sizeof(cp), &cp,
> > +                          HCI_CMD_TIMEOUT);
> > +     if (IS_ERR(skb)) {
> > +             bt_dev_err(hdev, "Disabling Android BQR failed (%ld)",
> > +                        PTR_ERR(skb));
> > +             return PTR_ERR(skb);
> > +     }
> > +
> > +     kfree_skb(skb);
> > +     return 0;
> > +}
> > +
> > +int aosp_set_quality_report(struct hci_dev *hdev, bool enable)
> > +{
> > +     bt_dev_info(hdev, "quality report enable %d", enable);
> > +
> > +     /* Enable or disable the quality report feature. */
> > +     if (enable)
> > +             return enable_quality_report(hdev);
> > +     else
> > +             return disable_quality_report(hdev);
> > +}
> > diff --git a/net/bluetooth/aosp.h b/net/bluetooth/aosp.h
> > index 328fc6d39f70..384e111c1260 100644
> > --- a/net/bluetooth/aosp.h
> > +++ b/net/bluetooth/aosp.h
> > @@ -8,9 +8,16 @@
> > void aosp_do_open(struct hci_dev *hdev);
> > void aosp_do_close(struct hci_dev *hdev);
> >
> > +int aosp_set_quality_report(struct hci_dev *hdev, bool enable);
> > +
> > #else
> >
> > static inline void aosp_do_open(struct hci_dev *hdev) {}
> > static inline void aosp_do_close(struct hci_dev *hdev) {}
> >
> > +static inline int aosp_set_quality_report(struct hci_dev *hdev, bool e=
nable)
> > +{
> > +     return false;
> > +}
> > +
> > #endif
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index aeec5a3031a6..a2c22a4921d4 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1315,6 +1315,21 @@ static void hci_dev_get_bd_addr_from_property(st=
ruct hci_dev *hdev)
> >       bacpy(&hdev->public_addr, &ba);
> > }
> >
> > +static void hci_set_quality_report(struct hci_dev *hdev)
> > +{
> > +#ifdef CONFIG_BT_AOSPEXT
> > +     if (hdev->aosp_capable) {
> > +             /* The hdev->set_quality_report callback is setup here fo=
r
> > +              * the vendors that support AOSP quality report specifica=
tion.
> > +              * Note that Intel, while supporting a distinct telemetry
> > +              * quality report specification, sets up the
> > +              * hdev->set_quality_report callback in the btusb module.
> > +              */
> > +             hdev->set_quality_report =3D aosp_set_quality_report;
> > +     }
> > +#endif
> > +}
> > +
>
> I think that I wasn=E2=80=99t super clear in my review on how I wanted th=
is feature. So hdev->set_quality_report should really only ever set by a tr=
ansport driver. The core stack should never touch it.
>
> So I wanted something like this:
>
>         if (hdev->set_quality_report)
>                 err =3D hdev->set_quality_report(hdev, val);
>         else
>                 err =3D aosp_set_quality_report(hdev, val);
>
> I send a RFC showing you how I think this should be done.
>
> An extra important step of course is to check if the Android extension ac=
tually supports the quality report feature in the first place.
>
> And while writing that patch, I realized that your initial support has a =
mistake. I send a patch for fixing it. The mgmt document is pretty clear on=
 how experimental flags are defined.
>
> Read Experimental Features Information Command
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>         Command Code:           0x0049
>         Controller Index:       <controller id> or <non-controller>
>         Command Parameters:
>         Return Parameters:      Feature_Count (2 Octets)
>                                 Feature1 {
>                                         UUID (16 Octets)
>                                         Flags (4 Octets)
>                                 }
>                                 Feature2 {  }
>                                 ...
>
>         This command is used to retrieve the supported experimental featu=
res
>         by the host stack.
>
>         The UUID values are not defined here. They can change over time a=
nd
>         are on purpose not stable. Features that mature will be removed a=
t
>         some point. The mapping of feature UUID to the actual functionali=
ty
>         of a given feature is out of scope here.
>
>         The following bits are defined for the Flags parameter:
>
>                 0       Feature active
>                 1       Causes change in supported settings
>
> So please don=E2=80=99t just make up things and exp UUID should only be p=
resent if they are supported. If they are not supported because the hardwar=
e is lacking support, they should not be reported.
>
> Regards
>
> Marcel
>


--=20

Joseph Shyh-In Hwang
Email: josephsih@google.com
