Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C950B53998F
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348457AbiEaWbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348437AbiEaWbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:31:07 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4847F9E9E2;
        Tue, 31 May 2022 15:31:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id bo5so230392pfb.4;
        Tue, 31 May 2022 15:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iDIWvySmHhcXU3aeCkY4PqLE8/TZPAUL6auJMc+U+/Q=;
        b=R658AtN7gfmLMHRF0bz2wPMFAVwJIURToBOsdJFDJA0KOXi6AMIOPcahHwOJ11P9+1
         YE5iRHXD7tuvZXtjFiR/MgZOzDpbF/XQBIrcuqS6Z3WD2PCISPB/MeGMAmV3R6MW6t2a
         8KzRcZAsjqdtKX3ueIw/5Sc/eonr134b+rd5yhGApDTh9Exeb6YcdowHwNOcRPUflPBP
         OicDNzNrUdwqcPvPXjlPWf93VHfDCnt3/dm/Z6RGj8TzuHtQqd883tfNUv6IKUg1A42c
         EfWw4ezMIlgZnXkf/mSyPRrPfNMOIdNs91tfoS4Fk88eb8YQ2+tfIw46cHQenNVMCGC0
         R90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iDIWvySmHhcXU3aeCkY4PqLE8/TZPAUL6auJMc+U+/Q=;
        b=QVgoB1sXCEtFh4ZG2aTzQPY8lKGv8Rn0IZ4NC3+64T65bSzFrqOnQ2gQXUUa7mbgZP
         M1xYt73f1p3KdYHDHz34m3cd92GE18YJifY3ueURBgWgz485UE0c/kbKmVl4VA1W2eES
         a7ACyZU+hUT+EyLlUorBGACwQ6qbzhPsc8G+TMTHyvHJtH/9ikKw0p6e/g3/5SRL2K0h
         AO2sPoKnG6IyFPcKExrKnAKNI/0v/ZXVmHrwIk4j5YA/gYytHxLj8TEycqSGTBV7VI8I
         6ni9pqMzcutcVOrgxd4zWeBUwnTbEKnFrF5tsmCMdBroGSl8h1E5+QTgj7nhJmoL5L3y
         qVaw==
X-Gm-Message-State: AOAM530jjOrqqp3teIDNrUCtZzD8LkqfUAi9JwhyP8VHPDskAdxlzzrF
        LmXTZ7sx2yr0J4VuAfq5n/soGpj1le/RezD7fLM=
X-Google-Smtp-Source: ABdhPJwTahi/HogSqmAuVd+ytqn+8nlk86IB1zgtlE69wFLorf8R22yTtS3k+hZkTqmYJ5r/FwTPTIpWvH4sbLLRwo4=
X-Received: by 2002:a65:6d08:0:b0:3c6:8a08:3b9f with SMTP id
 bf8-20020a656d08000000b003c68a083b9fmr54622657pgb.147.1654036264519; Tue, 31
 May 2022 15:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220526112135.2486883-1-josephsih@chromium.org>
 <20220526192047.v6.2.I2015b42d2d0a502334c9c3a2983438b89716d4f0@changeid>
 <CABBYNZLXzc2QDJ-8_XaoOSL+CXnrfHi-t8DPRTjO+wJjmCbV-w@mail.gmail.com>
 <CAHFy418Dfyio9ENfdJHfctWmHtmS7a2cOc2F2vyxi8pLESaQTw@mail.gmail.com> <CABBYNZ+drWbXtyx9+eT7DCXjTmNNzeTYvUAsVf3MAvU2HhWK-g@mail.gmail.com>
In-Reply-To: <CABBYNZ+drWbXtyx9+eT7DCXjTmNNzeTYvUAsVf3MAvU2HhWK-g@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 31 May 2022 15:30:53 -0700
Message-ID: <CABBYNZ+x7K-XL2tzgQPw-v=RadhhadtADpzuMS=HpDeiBQVY0g@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] Bluetooth: aosp: surface AOSP quality report
 through mgmt
To:     Joseph Hwang <josephsih@google.com>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

On Mon, May 30, 2022 at 2:00 PM Luiz Augusto von Dentz
<luiz.dentz@gmail.com> wrote:
>
> Hi Joseph,
>
> On Thu, May 26, 2022 at 9:37 PM Joseph Hwang <josephsih@google.com> wrote=
:
> >
> > Hi Luiz:
> >
> > Thanks for your review! The get_ext_vendor_prefix() in the table
> > provides a *unique* extended vendor prefix ( =3D vendor prefix + 1-octe=
t
> > subcode) that can uniquely identify a vendor event. I am not aware of
> > any situation that might cause an event to be incorrectly matched with
> > an extended vendor prefix. Maybe I am missing something?
> >
> > On the other hand, in your comment, to let a driver confirm whether it
> > is the vendor event structure it uses might be a bit risky. For
> > example, assume that we pass a vendor event to
> > msft.c:msft_vendor_evt() to determine whether it is a MSFT event. The
> > current implementation of msft_vendor_evt() is to call skb_pull_data()
> > to pull the event prefix for comparison with the dynamic MSFT event
> > prefix. No matter whether the event matches or not, the event skb has
> > been modified already and would cause bad behavior if we pass the
> > event skb to other vendor drivers/functions. How can we generally make
> > sure that every such vendor drivers/functions are implemented in a
> > read-only way that does not modify the skb when comparing the prefix?
> > In this patch, we propose to use get_ext_vendor_prefix() which is
> > guaranteed not to modify the skb in any possible way.
> >
> > Please also note that the mechanism here also takes care of older
> > controllers that might not support some of the vendor specifications.
> > For example, if an older controller does not support the MSFT spec,
> > the msft_get_ext_prefix() would return NULL as its prefix. And hence a
> > vendor event would not accidentally match the MSFT spec on the older
> > controller. Similarly, in the following patch =E2=80=9Cbtintel: setup
> > vendor_get_prefix and vendor_evt=E2=80=9D, on an older Intel controller=
 that
> > does not support Intel telemetry events, the btintel driver would
> > *not* set up
> >
> >     hdev->vendor_get_ext_prefix =3D btintel_get_ext_prefix;
>
> I see, while this does indeed prevent events to be misinterpreted,
> this locks us on only supporting vendor commands which use vendor
> prefixes, but perhaps that is fine since I assume there is probably no
> better way to create vendor opcodes in the first place.
>
> > such that an event would not match as an Intel vendor event in any way.
> >
> > Please let me know if I have any misunderstanding.
> >
> > Thanks and regards,
> > Joseph
> >
> >
> > On Fri, May 27, 2022 at 4:25 AM Luiz Augusto von Dentz
> > <luiz.dentz@gmail.com> wrote:
> > >
> > > Hi Joseph,
> > >
> > > On Thu, May 26, 2022 at 4:21 AM Joseph Hwang <josephsih@chromium.org>=
 wrote:
> > > >
> > > > When receiving a HCI vendor event, the kernel checks if it is an
> > > > AOSP bluetooth quality report. If yes, the event is sent to bluez
> > > > user space through the mgmt socket.
> > > >
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > >
> > > > Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> > > > Reviewed-by: Archie Pusaka <apusaka@chromium.org>
> > > > ---
> > > >
> > > > Changes in v6:
> > > > - Fixed a sparse check warning about using static for evt_prefixes.
> > > >
> > > > Changes in v5:
> > > > - Define "struct ext_vendor_prefix" to replace "struct vendor_prefi=
x"
> > > >   so that extended vendor prefix =3D prefix + 1-octet subcode
> > > > - Define aosp_ext_prefix to provide AOSP extended prefix which is
> > > >   returned by aosp_get_ext_prefix().
> > > > - Redefine struct ext_vendor_event_prefix such that
> > > >   . it uses get_ext_vendor_prefix to get prefix and subcodes where
> > > >     the prefix and the prefix length may be variable and are not
> > > >     unknown until run time;
> > > >   . it uses vendor_func to handle a vendor event
> > > >   This table handles vendor events in a generic way.
> > > > - Rewrite hci_vendor_evt() so that it compares both vendor prefix
> > > >   and subcode to match a vendor event.
> > > > - Define set_ext_prefix() to create MSFT extended vendor prefix
> > > >   which is returned by msft_get_ext_prefix().
> > > > - Do not EXPORT_SYMBOL(mgmt_quality_report).
> > > > - Keep msft_get_ext_prefix in msft instead of hci_dev since it is
> > > >   not used by any drivers.
> > > >
> > > > Changes in v3:
> > > > - Rebase to resolve the code conflict.
> > > > - Move aosp_quality_report_evt() from hci_event.c to aosp.c.
> > > > - A new patch (3/3) is added to enable the quality report feature.
> > > >
> > > > Changes in v2:
> > > > - Scrap the two structures defined in aosp.c and use constants for
> > > >   size check.
> > > > - Do a basic size check about the quality report event. Do not pull
> > > >   data from the event in which the kernel has no interest.
> > > > - Define vendor event prefixes with which vendor events of distinct
> > > >   vendor specifications can be clearly differentiated.
> > > > - Use mgmt helpers to add the header and data to a mgmt skb.
> > > >
> > > >  include/net/bluetooth/hci_core.h | 12 +++++++
> > > >  include/net/bluetooth/mgmt.h     |  7 +++++
> > > >  net/bluetooth/aosp.c             | 50 ++++++++++++++++++++++++++++=
+
> > > >  net/bluetooth/aosp.h             | 18 +++++++++++
> > > >  net/bluetooth/hci_event.c        | 54 ++++++++++++++++++++++++++++=
+++-
> > > >  net/bluetooth/mgmt.c             | 19 +++++++++++
> > > >  net/bluetooth/msft.c             | 28 ++++++++++++++++-
> > > >  net/bluetooth/msft.h             | 12 +++++--
> > > >  8 files changed, 195 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetoo=
th/hci_core.h
> > > > index 64d3a63759a8..f89738c6b973 100644
> > > > --- a/include/net/bluetooth/hci_core.h
> > > > +++ b/include/net/bluetooth/hci_core.h
> > > > @@ -328,6 +328,13 @@ struct amp_assoc {
> > > >
> > > >  #define HCI_MAX_PAGES  3
> > > >
> > > > +struct ext_vendor_prefix {
> > > > +       __u8 *prefix;
> > > > +       __u8 prefix_len;
> > > > +       __u8 *subcodes;
> > > > +       __u8 subcodes_len;
> > > > +};
> > > > +
> > > >  struct hci_dev {
> > > >         struct list_head list;
> > > >         struct mutex    lock;
> > > > @@ -1876,6 +1883,8 @@ int mgmt_add_adv_patterns_monitor_complete(st=
ruct hci_dev *hdev, u8 status);
> > > >  int mgmt_remove_adv_monitor_complete(struct hci_dev *hdev, u8 stat=
us);
> > > >  void mgmt_adv_monitor_device_lost(struct hci_dev *hdev, u16 handle=
,
> > > >                                   bdaddr_t *bdaddr, u8 addr_type);
> > > > +int mgmt_quality_report(struct hci_dev *hdev, void *data, u32 data=
_len,
> > > > +                       u8 quality_spec);
> > > >
> > > >  u8 hci_le_conn_update(struct hci_conn *conn, u16 min, u16 max, u16=
 latency,
> > > >                       u16 to_multiplier);
> > > > @@ -1894,4 +1903,7 @@ void hci_copy_identity_address(struct hci_dev=
 *hdev, bdaddr_t *bdaddr,
> > > >
> > > >  #define TRANSPORT_TYPE_MAX     0x04
> > > >
> > > > +#define QUALITY_SPEC_AOSP_BQR          0x0
> > > > +#define QUALITY_SPEC_INTEL_TELEMETRY   0x1
> > > > +
> > > >  #endif /* __HCI_CORE_H */
> > > > diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/m=
gmt.h
> > > > index c1c2fd72d9e3..6ccd0067c295 100644
> > > > --- a/include/net/bluetooth/mgmt.h
> > > > +++ b/include/net/bluetooth/mgmt.h
> > > > @@ -1127,3 +1127,10 @@ struct mgmt_ev_adv_monitor_device_lost {
> > > >         __le16 monitor_handle;
> > > >         struct mgmt_addr_info addr;
> > > >  } __packed;
> > > > +
> > > > +#define MGMT_EV_QUALITY_REPORT                 0x0031
> > > > +struct mgmt_ev_quality_report {
> > > > +       __u8    quality_spec;
> > > > +       __u32   data_len;
> > > > +       __u8    data[];
> > > > +} __packed;
> > > > diff --git a/net/bluetooth/aosp.c b/net/bluetooth/aosp.c
> > > > index 432ae3aac9e3..94faa15b1ea0 100644
> > > > --- a/net/bluetooth/aosp.c
> > > > +++ b/net/bluetooth/aosp.c
> > > > @@ -199,3 +199,53 @@ int aosp_set_quality_report(struct hci_dev *hd=
ev, bool enable)
> > > >         else
> > > >                 return disable_quality_report(hdev);
> > > >  }
> > > > +
> > > > +/* The following LEN =3D 1-byte Sub-event code + 48-byte Sub-event=
 Parameters */
> > > > +#define BLUETOOTH_QUALITY_REPORT_LEN 49
> > > > +
> > > > +bool aosp_check_quality_report_len(struct sk_buff *skb)
> > > > +{
> > > > +       /* skb->len is allowed to be larger than BLUETOOTH_QUALITY_=
REPORT_LEN
> > > > +        * to accommodate an additional Vendor Specific Parameter (=
vsp) field.
> > > > +        */
> > > > +       if (skb->len < BLUETOOTH_QUALITY_REPORT_LEN) {
> > > > +               BT_ERR("AOSP evt data len %d too short (%u expected=
)",
> > > > +                      skb->len, BLUETOOTH_QUALITY_REPORT_LEN);
> > > > +               return false;
> > > > +       }
> > > > +
> > > > +       return true;
> > > > +}
> > > > +
> > > > +/* AOSP HCI Requirements use 0x54 and up as sub-event codes withou=
t
> > > > + * actually defining a vendor prefix. Refer to
> > > > + * https://source.android.com/devices/bluetooth/hci_requirements
> > > > + * Hence, the other vendor event prefixes should not use the same
> > > > + * space to avoid collision.
> > > > + * Since the AOSP does not define a prefix, its prefix is NULL
> > > > + * and prefix_len is 0.
> > > > + * While there are a number of subcodes in AOSP, only interested i=
n
> > > > + * Bluetooth Quality Report (0x58) for now.
> > > > + */
> > > > +#define AOSP_EV_QUALITY_REPORT         0x58
> > > > +
> > > > +static unsigned char AOSP_SUBCODES[] =3D { AOSP_EV_QUALITY_REPORT =
};
> > > > +
> > > > +static struct ext_vendor_prefix aosp_ext_prefix =3D {
> > > > +       .prefix         =3D NULL,
> > > > +       .prefix_len     =3D 0,
> > > > +       .subcodes       =3D AOSP_SUBCODES,
> > > > +       .subcodes_len   =3D sizeof(AOSP_SUBCODES),
> > > > +};
> > > > +
> > > > +struct ext_vendor_prefix *aosp_get_ext_prefix(struct hci_dev *hdev=
)
> > > > +{
> > > > +       return &aosp_ext_prefix;
> > > > +}
> > > > +
> > > > +void aosp_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
> > > > +{
> > > > +       if (aosp_has_quality_report(hdev) && aosp_check_quality_rep=
ort_len(skb))
> > > > +               mgmt_quality_report(hdev, skb->data, skb->len,
> > > > +                                   QUALITY_SPEC_AOSP_BQR);
> > > > +}
> > > > diff --git a/net/bluetooth/aosp.h b/net/bluetooth/aosp.h
> > > > index 2fd8886d51b2..8208e01fffed 100644
> > > > --- a/net/bluetooth/aosp.h
> > > > +++ b/net/bluetooth/aosp.h
> > > > @@ -10,6 +10,9 @@ void aosp_do_close(struct hci_dev *hdev);
> > > >
> > > >  bool aosp_has_quality_report(struct hci_dev *hdev);
> > > >  int aosp_set_quality_report(struct hci_dev *hdev, bool enable);
> > > > +bool aosp_check_quality_report_len(struct sk_buff *skb);
> > > > +struct ext_vendor_prefix *aosp_get_ext_prefix(struct hci_dev *hdev=
);
> > > > +void aosp_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
> > > >
> > > >  #else
> > > >
> > > > @@ -26,4 +29,19 @@ static inline int aosp_set_quality_report(struct=
 hci_dev *hdev, bool enable)
> > > >         return -EOPNOTSUPP;
> > > >  }
> > > >
> > > > +static inline bool aosp_check_quality_report_len(struct sk_buff *s=
kb)
> > > > +{
> > > > +       return false;
> > > > +}
> > > > +
> > > > +static inline struct ext_vendor_prefix *
> > > > +aosp_get_ext_prefix(struct hci_dev *hdev)
> > > > +{
> > > > +       return NULL;
> > > > +}
> > > > +
> > > > +static inline void aosp_vendor_evt(struct hci_dev *hdev, struct sk=
_buff *skb)
> > > > +{
> > > > +}
> > > > +
> > > >  #endif
> > > > diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> > > > index 0270e597c285..8398971eddf4 100644
> > > > --- a/net/bluetooth/hci_event.c
> > > > +++ b/net/bluetooth/hci_event.c
> > > > @@ -37,6 +37,7 @@
> > > >  #include "smp.h"
> > > >  #include "msft.h"
> > > >  #include "eir.h"
> > > > +#include "aosp.h"
> > > >
> > > >  #define ZERO_KEY "\x00\x00\x00\x00\x00\x00\x00\x00" \
> > > >                  "\x00\x00\x00\x00\x00\x00\x00\x00"
> > > > @@ -4259,6 +4260,57 @@ static void hci_num_comp_blocks_evt(struct h=
ci_dev *hdev, void *data,
> > > >         queue_work(hdev->workqueue, &hdev->tx_work);
> > > >  }
> > > >
> > > > +/* Every distinct vendor specification must have a well-defined ve=
ndor
> > > > + * event prefix to determine if a vendor event meets the specifica=
tion.
> > > > + * Some vendor prefixes are fixed values while some other vendor p=
refixes
> > > > + * are only available at run time.
> > > > + */
> > > > +static struct ext_vendor_event_prefix {
> > > > +       /* Some vendor prefixes are variable length. For convenienc=
e,
> > > > +        * the prefix in struct ext_vendor_prefix is in little endi=
an.
> > > > +        */
> > > > +       struct ext_vendor_prefix *
> > > > +               (*get_ext_vendor_prefix)(struct hci_dev *hdev);
> > > > +       void (*vendor_func)(struct hci_dev *hdev, struct sk_buff *s=
kb);
> > > > +} evt_prefixes[] =3D {
> > > > +       { aosp_get_ext_prefix, aosp_vendor_evt },
> > > > +       { msft_get_ext_prefix, msft_vendor_evt },
> > > > +
> > > > +       /* end with a null entry */
> > > > +       {},
> > > > +};
> > > > +
> > > > +static void hci_vendor_evt(struct hci_dev *hdev, void *data,
> > > > +                          struct sk_buff *skb)
> > > > +{
> > > > +       int i, j;
> > > > +       struct ext_vendor_prefix *vnd;
> > > > +       __u8 subcode;
> > > > +
> > > > +       for (i =3D 0; evt_prefixes[i].get_ext_vendor_prefix; i++) {
> > > > +               vnd =3D evt_prefixes[i].get_ext_vendor_prefix(hdev)=
;
> > > > +               if (!vnd)
> > > > +                       continue;

We need to check like if (skb->len < vnd->prefix_len), btw are the
prefixes supposed to be changed at runtime? If not probably a const
table would work better. In fact I would suggest changing the
vendor_func to start parsing _after_ the prefix so you can use
skb_pull_data, or create a helper that does that conditionally e.g
skb_pull_data_cmp(skb, data, data_len).

> > > > +               /* Compare the raw prefix data in little endian dir=
ectly. */
> > > > +               if (memcmp(vnd->prefix, skb->data, vnd->prefix_len)=
)
> > > > +                       continue;
> > > > +
> > > > +               /* Make sure that there are more data after prefix.=
 */
> > > > +               if (skb->len <=3D vnd->prefix_len)
> > > > +                       continue;
> > > > +
> > > > +               /* The subcode is the single octet following the pr=
efix. */
> > > > +               subcode =3D skb->data[vnd->prefix_len];

This part I don't really get, so the core is doing subcode matching,
what if the vendor decides that the subcode is part of the prefix?
Prefix matching is one thing but prefix + subcode is another pattern,
or is this to allow 0 prefix_len so it essentially becomes subcode
matching? Anyway I was thinking this could all be work out in a single
const table e.g:

#define data(args...) ((const unsigned char[]) { args })

#define HCI_VENDOR_EVT(_func, _prefix_len, _prefix...)
{ \
    .func =3D _func,
    .prefix_len =3D sizeof(data(_prefix)),
    .prefix =3D data(_prefix),
}

const static struct hci_vendor_evt {
    (*func)...
    u16 prefix_len;
    u8 prefix[]; /* Prefix + subcode */
} =3D vendor_evt_table[] =3D {
    HCI_VENDOR_EVT(msft_monitor_device_evt, sizeof(msft_device_evt),
msft_prefix, MSFT_EV_LE_MONITOR_DEVICE),
};

So it becomes pretty similar to the existing const tables we have in
hci_event.c with the only difference is that we use prefix matching
where the length is not constant among each element, the only drawback
that I can think of is that all vendor events will need to be added to
the table (msftp, aosp, etc.) but perhaps that makes it more visible
on exactly what events are supported instead of every subcode being
handled automatically which is not always the case, the table(s) would
sit in the driver code and would be registered to hdev all at once
instead of setting each prefix separately at runtime this all happens
at build time so the compiler can do its job while compiling it.

> > > > +               for (j =3D 0; j < vnd->subcodes_len; j++) {
> > > > +                       if (vnd->subcodes[j] =3D=3D subcode) {
> > > > +                               evt_prefixes[i].vendor_func(hdev, s=
kb);
> > > > +                               break;
> > > > +                       }
> > > > +               }
> > > > +       }
> > > > +}
> > >
> > > I recall saying that having such matching logic applied without the
> > > driver confirming that is the structure it using to be a bad idea
> > > since it could actually cause an event to misinterpret and cause bad
> > > behavior, instead we probably need a callback that gets populated by
> > > the driver e.g.(hdev->vendor_evt) then the driver can either populate
> > > with hci_vendor_evt if it does use prefixes or its own specialized
> > > function or NULL if it doesn't use vendor events, specially for old
> > > controllers Id leave it as NULL.
> > >
> > > >  static void hci_mode_change_evt(struct hci_dev *hdev, void *data,
> > > >                                 struct sk_buff *skb)
> > > >  {
> > > > @@ -6879,7 +6931,7 @@ static const struct hci_ev {
> > > >         HCI_EV(HCI_EV_NUM_COMP_BLOCKS, hci_num_comp_blocks_evt,
> > > >                sizeof(struct hci_ev_num_comp_blocks)),
> > > >         /* [0xff =3D HCI_EV_VENDOR] */
> > > > -       HCI_EV_VL(HCI_EV_VENDOR, msft_vendor_evt, 0, HCI_MAX_EVENT_=
SIZE),
> > > > +       HCI_EV_VL(HCI_EV_VENDOR, hci_vendor_evt, 0, HCI_MAX_EVENT_S=
IZE),
> > > >  };
> > > >
> > > >  static void hci_event_func(struct hci_dev *hdev, u8 event, struct =
sk_buff *skb,
> > > > diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> > > > index 1ad84f34097f..9d3666bdd07c 100644
> > > > --- a/net/bluetooth/mgmt.c
> > > > +++ b/net/bluetooth/mgmt.c
> > > > @@ -4332,6 +4332,25 @@ static int set_exp_feature(struct sock *sk, =
struct hci_dev *hdev,
> > > >                                MGMT_STATUS_NOT_SUPPORTED);
> > > >  }
> > > >
> > > > +int mgmt_quality_report(struct hci_dev *hdev, void *data, u32 data=
_len,
> > > > +                       u8 quality_spec)
> > > > +{
> > > > +       struct mgmt_ev_quality_report *ev;
> > > > +       struct sk_buff *skb;
> > > > +
> > > > +       skb =3D mgmt_alloc_skb(hdev, MGMT_EV_QUALITY_REPORT,
> > > > +                            sizeof(*ev) + data_len);
> > > > +       if (!skb)
> > > > +               return -ENOMEM;
> > > > +
> > > > +       ev =3D skb_put(skb, sizeof(*ev));
> > > > +       ev->quality_spec =3D quality_spec;
> > > > +       ev->data_len =3D data_len;
> > > > +       skb_put_data(skb, data, data_len);
> > > > +
> > > > +       return mgmt_event_skb(skb, NULL);
> > > > +}
> > > > +
> > > >  static int get_device_flags(struct sock *sk, struct hci_dev *hdev,=
 void *data,
> > > >                             u16 data_len)
> > > >  {
> > > > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> > > > index f43994523b1f..c003e94faccd 100644
> > > > --- a/net/bluetooth/msft.c
> > > > +++ b/net/bluetooth/msft.c
> > > > @@ -116,6 +116,20 @@ bool msft_monitor_supported(struct hci_dev *hd=
ev)
> > > >         return !!(msft_get_features(hdev) & MSFT_FEATURE_MASK_LE_AD=
V_MONITOR);
> > > >  }
> > > >
> > > > +/* Add the MSFT vendor event subcodes into MSFT_SUBCODES which
> > > > + * msft_vendor_evt() is interested in handling.
> > > > + */
> > > > +static unsigned char MSFT_SUBCODES[] =3D { MSFT_EV_LE_MONITOR_DEVI=
CE };
> > > > +static struct ext_vendor_prefix msft_ext_prefix =3D { 0 };
> > > > +
> > > > +static void set_ext_prefix(struct msft_data *msft)
> > > > +{
> > > > +       msft_ext_prefix.prefix =3D msft->evt_prefix;
> > > > +       msft_ext_prefix.prefix_len =3D msft->evt_prefix_len;
> > > > +       msft_ext_prefix.subcodes =3D MSFT_SUBCODES;
> > > > +       msft_ext_prefix.subcodes_len =3D sizeof(MSFT_SUBCODES);
> > > > +}
> > > > +
> > > >  static bool read_supported_features(struct hci_dev *hdev,
> > > >                                     struct msft_data *msft)
> > > >  {
> > > > @@ -156,6 +170,8 @@ static bool read_supported_features(struct hci_=
dev *hdev,
> > > >         if (msft->features & MSFT_FEATURE_MASK_CURVE_VALIDITY)
> > > >                 hdev->msft_curve_validity =3D true;
> > > >
> > > > +       set_ext_prefix(msft);
> > > > +
> > > >         kfree_skb(skb);
> > > >         return true;
> > > >
> > > > @@ -742,7 +758,17 @@ static void msft_monitor_device_evt(struct hci=
_dev *hdev, struct sk_buff *skb)
> > > >                                  handle_data->mgmt_handle);
> > > >  }
> > > >
> > > > -void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_b=
uff *skb)
> > > > +struct ext_vendor_prefix *msft_get_ext_prefix(struct hci_dev *hdev=
)
> > > > +{
> > > > +       struct msft_data *msft =3D hdev->msft_data;
> > > > +
> > > > +       if (!msft)
> > > > +               return NULL;
> > > > +
> > > > +       return &msft_ext_prefix;
> > > > +}
> > > > +
> > > > +void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
> > > >  {
> > > >         struct msft_data *msft =3D hdev->msft_data;
> > > >         u8 *evt_prefix;
> > > > diff --git a/net/bluetooth/msft.h b/net/bluetooth/msft.h
> > > > index afcaf7d3b1cb..1515ae06c628 100644
> > > > --- a/net/bluetooth/msft.h
> > > > +++ b/net/bluetooth/msft.h
> > > > @@ -17,7 +17,7 @@ void msft_register(struct hci_dev *hdev);
> > > >  void msft_unregister(struct hci_dev *hdev);
> > > >  void msft_do_open(struct hci_dev *hdev);
> > > >  void msft_do_close(struct hci_dev *hdev);
> > > > -void msft_vendor_evt(struct hci_dev *hdev, void *data, struct sk_b=
uff *skb);
> > > > +void msft_vendor_evt(struct hci_dev *hdev, struct sk_buff *skb);
> > > >  __u64 msft_get_features(struct hci_dev *hdev);
> > > >  int msft_add_monitor_pattern(struct hci_dev *hdev, struct adv_moni=
tor *monitor);
> > > >  int msft_remove_monitor(struct hci_dev *hdev, struct adv_monitor *=
monitor,
> > > > @@ -27,6 +27,7 @@ int msft_set_filter_enable(struct hci_dev *hdev, =
bool enable);
> > > >  int msft_suspend_sync(struct hci_dev *hdev);
> > > >  int msft_resume_sync(struct hci_dev *hdev);
> > > >  bool msft_curve_validity(struct hci_dev *hdev);
> > > > +struct ext_vendor_prefix *msft_get_ext_prefix(struct hci_dev *hdev=
);
> > > >
> > > >  #else
> > > >
> > > > @@ -39,8 +40,7 @@ static inline void msft_register(struct hci_dev *=
hdev) {}
> > > >  static inline void msft_unregister(struct hci_dev *hdev) {}
> > > >  static inline void msft_do_open(struct hci_dev *hdev) {}
> > > >  static inline void msft_do_close(struct hci_dev *hdev) {}
> > > > -static inline void msft_vendor_evt(struct hci_dev *hdev, void *dat=
a,
> > > > -                                  struct sk_buff *skb) {}
> > > > +static inline void msft_vendor_evt(struct hci_dev *hdev, struct sk=
_buff *skb) {}
> > > >  static inline __u64 msft_get_features(struct hci_dev *hdev) { retu=
rn 0; }
> > > >  static inline int msft_add_monitor_pattern(struct hci_dev *hdev,
> > > >                                            struct adv_monitor *moni=
tor)
> > > > @@ -77,4 +77,10 @@ static inline bool msft_curve_validity(struct hc=
i_dev *hdev)
> > > >         return false;
> > > >  }
> > > >
> > > > +static inline struct ext_vendor_prefix *
> > > > +msft_get_ext_prefix(struct hci_dev *hdev)
> > > > +{
> > > > +       return NULL;
> > > > +}
> > > > +
> > > >  #endif
> > > > --
> > > > 2.36.1.124.g0e6072fb45-goog
> > > >
> > >
> > >
> > > --
> > > Luiz Augusto von Dentz
> >
> >
> >
> > --
> >
> > Joseph Shyh-In Hwang
> > Email: josephsih@google.com
>
>
>
> --
> Luiz Augusto von Dentz



--=20
Luiz Augusto von Dentz
