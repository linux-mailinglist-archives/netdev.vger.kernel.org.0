Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE94CE37B
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 08:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiCEHrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 02:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiCEHrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 02:47:42 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A2A26D550
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 23:46:51 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2dbfe58670cso114551267b3.3
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 23:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TjqsWBxxcZbi0ZyhuFzQQhnaPsJXUAJuTEaqNdWIwz0=;
        b=RgRaV0iWe0BQ5E8pr3RCiA5yXf2MEHXFDmuGl1GYpI0f8oylqwhLXyjJGvV3Xub2fR
         Jw/qpsd/D3WwVmxeKBYqxeZP7/YYymuDFlXdfKO3mQd8x1KFATWVTqx5mvTK8PjF2io+
         FCa6YtB3zAYeozbXafoOV1A+TkrVOp1jyUClTagNjzRptv6ifmxxUR91EFSxaVVwL44A
         Rf4hJarMscBw1/CungLIN1mCi4FjSz85nkvosSqEgm9YErQmafweZkAh/eWulgFES/OL
         060cfI+iPHugrqsBuU8uLOfjsQzqHbVpv7pTXX2vvTtfKK67N6pLGYtt3YNUi++hwEc9
         36UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TjqsWBxxcZbi0ZyhuFzQQhnaPsJXUAJuTEaqNdWIwz0=;
        b=6iAEuXRyQrlvqd0DzEfJNcVrVbNa2dTohX331zDoUAUVD4yE7XFYEEv4PQXWjYCOzQ
         DGs2AT/ahPnx7x0Oef1QLqfhwtnVjxBzJOmPg6Pu9igvE7fsTpNKZoYpF7q0cAbrzm6k
         3mRff24MCcs2S6aUkShTtoINvVjcewipy81X0YEpihLL79N3FzhEcz1uKSrm+ILW+2yz
         gFEtxVls40GPviE1i1TA/dA9CsIvcUS5DVyY8pJpZn5VhDtk/xaLKHMwJc+5RJw3P/PH
         Kb0c+1yLypWa9GtwaaQfaQjfaBN9j9hQwQl1CtCQrT7yZmDosVP9YOXxTy8dH+DjU+b5
         pXXg==
X-Gm-Message-State: AOAM530twcbnXhW2yTVxK+1Z/uNp5Qx/Op1MPFZHiB4Gf1c9PbiKdvuq
        /Agpgg8AkKzbsApmUUyo/+nyJG8vUB+08bJx91Ncxg==
X-Google-Smtp-Source: ABdhPJyerSsRJf9x3mqORsCC4Df7G8X8V13fK32S6E9bCocm6w6ms/Dd0DBJzzLOTK3oZKRzD7CmPN1aqHgBhSXga/Y=
X-Received: by 2002:a81:4f14:0:b0:2dc:266:1f26 with SMTP id
 d20-20020a814f14000000b002dc02661f26mr1865092ywb.127.1646466410710; Fri, 04
 Mar 2022 23:46:50 -0800 (PST)
MIME-Version: 1.0
References: <20220215213519.v4.1.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
 <20220215213519.v4.2.I63681490281b2392aa1ac05dff91a126394ab649@changeid> <FCAB9F47-39D4-4564-A0E6-530F79AF5B5B@holtmann.org>
In-Reply-To: <FCAB9F47-39D4-4564-A0E6-530F79AF5B5B@holtmann.org>
From:   Joseph Hwang <josephsih@google.com>
Date:   Sat, 5 Mar 2022 15:46:39 +0800
Message-ID: <CAHFy41-j7bsbPUZ8kTzs_bJJiRqXmFCGQJPJ_tZ7vHf2YGyRnA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] Bluetooth: btintel: surface Intel telemetry events
 through mgmt
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     BlueZ <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel, thank you for reviewing the patches! I have some questions.
Please read my replies in the lines below. Thanks!

On Thu, Feb 17, 2022 at 8:53 PM Marcel Holtmann <marcel@holtmann.org> wrote=
:
>
> Hi Jospeh,
>
> > When receiving a HCI vendor event, the kernel checks if it is an
> > Intel telemetry event. If yes, the event is sent to bluez user
> > space through the mgmt socket.
> >
> > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> > Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> > ---
> >
> > (no changes since v3)
> >
> > Changes in v3:
> > - Move intel_vendor_evt() from hci_event.c to the btintel driver.
> >
> > Changes in v2:
> > - Drop the pull_quality_report_data function from hci_dev.
> >  Do not bother hci_dev with it. Do not bleed the details
> >  into the core.
> >
> > drivers/bluetooth/btintel.c      | 37 +++++++++++++++++++++++++++++++-
> > drivers/bluetooth/btintel.h      |  7 ++++++
> > include/net/bluetooth/hci_core.h |  2 ++
> > net/bluetooth/hci_event.c        | 12 +++++++++++
> > 4 files changed, 57 insertions(+), 1 deletion(-)
>
> I don=E2=80=99t like intermixing core additions with driver implementatio=
ns of it. I thought that I have mentioned this a few times, but maybe I mis=
sed that in the last review round. So first introduce the callbacks and the=
 handling in hci_core etc. and then provide a patch for the driver using it=
.
>
> >
> > diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
> > index 06514ed66022..c7732da2752f 100644
> > --- a/drivers/bluetooth/btintel.c
> > +++ b/drivers/bluetooth/btintel.c
> > @@ -2401,9 +2401,12 @@ static int btintel_setup_combined(struct hci_dev=
 *hdev)
> >       set_bit(HCI_QUIRK_SIMULTANEOUS_DISCOVERY, &hdev->quirks);
> >       set_bit(HCI_QUIRK_NON_PERSISTENT_DIAG, &hdev->quirks);
> >
> > -     /* Set up the quality report callback for Intel devices */
> > +     /* Set up the quality report callbacks for Intel devices */
> >       hdev->set_quality_report =3D btintel_set_quality_report;
> >
> > +     /* Set up the vendor specific callback for Intel devices */
> > +     hdev->vendor_evt =3D btintel_vendor_evt;
> > +
> >       /* For Legacy device, check the HW platform value and size */
> >       if (skb->len =3D=3D sizeof(ver) && skb->data[1] =3D=3D 0x37) {
> >               bt_dev_dbg(hdev, "Read the legacy Intel version informati=
on");
> > @@ -2650,6 +2653,38 @@ void btintel_secure_send_result(struct hci_dev *=
hdev,
> > }
> > EXPORT_SYMBOL_GPL(btintel_secure_send_result);
> >
> > +#define INTEL_PREFIX         0x8087
> > +#define TELEMETRY_CODE               0x03
> > +
> > +struct intel_prefix_evt_data {
> > +     __le16 vendor_prefix;
> > +     __u8 code;
> > +     __u8 data[];   /* a number of struct intel_tlv subevents */
> > +} __packed;
> > +
> > +static bool is_quality_report_evt(struct sk_buff *skb)
> > +{
> > +     struct intel_prefix_evt_data *ev;
> > +     u16 vendor_prefix;
> > +
> > +     if (skb->len < sizeof(struct intel_prefix_evt_data))
> > +             return false;
> > +
> > +     ev =3D (struct intel_prefix_evt_data *)skb->data;
> > +     vendor_prefix =3D __le16_to_cpu(ev->vendor_prefix);
> > +
> > +     return vendor_prefix =3D=3D INTEL_PREFIX && ev->code =3D=3D TELEM=
ETRY_CODE;
> > +}
> > +
> > +void btintel_vendor_evt(struct hci_dev *hdev,  void *data, struct sk_b=
uff *skb)
> > +{
> > +     /* Only interested in the telemetry event for now. */
> > +     if (hdev->set_quality_report && is_quality_report_evt(skb))
> > +             mgmt_quality_report(hdev, skb->data, skb->len,
> > +                                 QUALITY_SPEC_INTEL_TELEMETRY);
>
> You can not do that. Keep the interaction with hci_dev as limited as poss=
ible. I think it would be best to introduce a hci_recv_quality_report funct=
ion that drivers can call.

Do you mean to set a callback hdev->hci_recv_quality_report in the
kernel (which will invoke mgmt_quality_report) so that the driver can
call it to send the quality reports?  There would be very few things
done (maybe just to strip off the prefix header) in the driver before
passing the skb data back to the kernel via
hdev->hci_recv_quality_report. Does this sound good with you?

>
> And really don=E2=80=99t bother with all these check. Dissect the vendor =
event, if it is a quality report, then just report it via that callback. An=
d you should be stripping off the prefix etc. Just report the plain data.

I will remove those checks. As to stripping off the prefix, that was
what I did in Series-version: 1. Your comment about my AOSP function
in pulling off the prefix header from the skb was =E2=80=9Cjust do a basic
length check and then move on. The kernel has no interest in this
data.=E2=80=9D So that is why the whole skb->data is sent to the user space
for further handling. Please let me know if it is better to strip off
the prefix header for both Intel and AOSP.

>
> > +}
> > +EXPORT_SYMBOL_GPL(btintel_vendor_evt);
> > +
> > MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
> > MODULE_DESCRIPTION("Bluetooth support for Intel devices ver " VERSION);
> > MODULE_VERSION(VERSION);
> > diff --git a/drivers/bluetooth/btintel.h b/drivers/bluetooth/btintel.h
> > index e0060e58573c..82dc278b09eb 100644
> > --- a/drivers/bluetooth/btintel.h
> > +++ b/drivers/bluetooth/btintel.h
> > @@ -211,6 +211,7 @@ void btintel_bootup(struct hci_dev *hdev, const voi=
d *ptr, unsigned int len);
> > void btintel_secure_send_result(struct hci_dev *hdev,
> >                               const void *ptr, unsigned int len);
> > int btintel_set_quality_report(struct hci_dev *hdev, bool enable);
> > +void btintel_vendor_evt(struct hci_dev *hdev,  void *data, struct sk_b=
uff *skb);
> > #else
> >
> > static inline int btintel_check_bdaddr(struct hci_dev *hdev)
> > @@ -306,4 +307,10 @@ static inline int btintel_set_quality_report(struc=
t hci_dev *hdev, bool enable)
> > {
> >       return -ENODEV;
> > }
> > +
> > +static inline void btintel_vendor_evt(struct hci_dev *hdev,  void *dat=
a,
>
> Double space here.
>
> > +                                   struct sk_buff *skb)
> > +{
> > +}
> > +
> > #endif
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index ea83619ac4de..3505ffe20779 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -635,6 +635,8 @@ struct hci_dev {
> >       void (*cmd_timeout)(struct hci_dev *hdev);
> >       bool (*wakeup)(struct hci_dev *hdev);
> >       int (*set_quality_report)(struct hci_dev *hdev, bool enable);
> > +     void (*vendor_evt)(struct hci_dev *hdev, void *data,
> > +                        struct sk_buff *skb);
>
> So I do not understand the void *data portion. Just hand down the skb.
>
> >       int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
> >       int (*get_codec_config_data)(struct hci_dev *hdev, __u8 type,
> >                                    struct bt_codec *codec, __u8 *vnd_le=
n,
> > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > index 6468ea0f71bd..e34dea0f0c2e 100644
> > --- a/net/bluetooth/hci_event.c
> > +++ b/net/bluetooth/hci_event.c
> > @@ -4250,6 +4250,7 @@ static void hci_num_comp_blocks_evt(struct hci_de=
v *hdev, void *data,
> >  *       space to avoid collision.
> >  */
> > static unsigned char AOSP_BQR_PREFIX[] =3D { 0x58 };
> > +static unsigned char INTEL_PREFIX[] =3D { 0x87, 0x80 };
>
> This really bugs me. Intel specifics can not be here. I think we really h=
ave to push all vendor events down to the driver.

Can we have new hdev callbacks like hdev->get_vendor_prefix() and
hdev->get_vendor_prefix_len() so that the vendor drivers such as Intel
can set up their driver functions to derive the prefix and its length?

>
> >
> > /* Some vendor prefixes are fixed values and lengths. */
> > #define FIXED_EVT_PREFIX(_prefix, _vendor_func)                        =
       \
> > @@ -4273,6 +4274,16 @@ static unsigned char AOSP_BQR_PREFIX[] =3D { 0x5=
8 };
> >       .get_prefix_len =3D _prefix_len_func,                            =
 \
> > }
> >
> > +/* Every vendor that handles particular vendor events in its driver sh=
ould
> > + * 1. set up the vendor_evt callback in its driver and
> > + * 2. add an entry in struct vendor_event_prefix.
> > + */
> > +static void vendor_evt(struct hci_dev *hdev,  void *data, struct sk_bu=
ff *skb)
> > +{
> > +     if (hdev->vendor_evt)
> > +             hdev->vendor_evt(hdev, data, skb);
> > +}
> > +
> > /* Every distinct vendor specification must have a well-defined vendor
> >  * event prefix to determine if a vendor event meets the specification.
> >  * If an event prefix is fixed, it should be delcared with FIXED_EVT_PR=
EFIX.
> > @@ -4287,6 +4298,7 @@ struct vendor_event_prefix {
> >       __u8 (*get_prefix_len)(struct hci_dev *hdev);
> > } evt_prefixes[] =3D {
> >       FIXED_EVT_PREFIX(AOSP_BQR_PREFIX, aosp_quality_report_evt),
> > +     FIXED_EVT_PREFIX(INTEL_PREFIX, vendor_evt),
> >       DYNAMIC_EVT_PREFIX(get_msft_evt_prefix, get_msft_evt_prefix_len,
> >                          msft_vendor_evt),
>
> Regards
>
> Marcel
>


--=20

Joseph Shyh-In Hwang
Email: josephsih@google.com
