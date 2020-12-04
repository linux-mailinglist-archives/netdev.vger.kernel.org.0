Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FE22CE677
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgLDD0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgLDD0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:26:22 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160FBC061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:25:42 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id u19so5783032lfr.7
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mA1Wv1n0Daq3I8BlilK/8KwVWbxbDL4vk61Ftxly1uc=;
        b=gRNwNNlw1U8QA2hmClwF+qjbC7oMNWBG1xNWtNAOYvIibzJ7OYQBJuykBpxfEeYLK6
         QtudSIUg4vOTJ2JWxxKtR7Usjlq603GFH4qvSd994pr/xvSkrcIIn1x4XuGFIQQz69kj
         qXDfUy4W1cOHXHBaILB5bfY0CxclHj+uoApkgJq2Egs2RFtWeaiKw72CreJobkwWMTUf
         bC3Y7UKy68ccuf7V9BFbyPo0Zza47K+dhR1UYGvr1B2J8VlAx0Bm/QkXMBIRa+0D592l
         SEIYbV99QIE943PmG+Osaq3okD/IQmoqa5oQOX8FxTVKfczqgXcXCrFuu4/GgvrUJPYC
         LyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mA1Wv1n0Daq3I8BlilK/8KwVWbxbDL4vk61Ftxly1uc=;
        b=Bqzjze/tBbe9yO9yQs3V4qnbwiNRTp/YIPc/1Y84fTuQVvrI4Gk9E/wtkgM3b+owTl
         ArCdaT0muJQUzI0MBvsiiHAqUWx2oVgRtSoffszIzgw2DmW9JdWMhdWBugBy3qxeyNlg
         cMzZwJ7ozYpBq3XUvzIWr1hRH45POGzSxt/OzjF2p6JU6wMQC2yD7hWM7pUrvW42/QUQ
         nJ3wMnM3btvlP2xrQap80qj7AjYfZG4bW20G3SEmbpnOqLFHxFK1pnkiadLFAs+melPN
         GLGg/JI3HjkWmIrx/Llr+E00qkxhBrrCS/MKqtVBFa7tV4/kPyt7rb/YH6KPoQlbdzJt
         Lbrg==
X-Gm-Message-State: AOAM532O7LYTua/zaSes93ZDqJ/5v2phOE6jgfdW/CWbUBdF+XbnZ5So
        hUtjY2CNkAu+MJfgpGTRJBeLRCVfFG36obfBiuFl6Q==
X-Google-Smtp-Source: ABdhPJyQn7zdhlYenIte2Cy4pidG0EtQXYrXdRBjQoj/p0aEQBmtulIwC9KYNy7Au8oZ47MyTXsBuo+dbvagHaT006E=
X-Received: by 2002:a05:6512:338f:: with SMTP id h15mr2502528lfg.40.1607052340341;
 Thu, 03 Dec 2020 19:25:40 -0800 (PST)
MIME-Version: 1.0
References: <20201203102936.4049556-1-apusaka@google.com> <20201203182903.v1.1.I92d2e2a87419730d60136680cbe27636baf94b15@changeid>
 <20B6F2AD-1A60-4E3C-84C2-E3CB7294FABC@holtmann.org>
In-Reply-To: <20B6F2AD-1A60-4E3C-84C2-E3CB7294FABC@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Fri, 4 Dec 2020 11:25:29 +0800
Message-ID: <CAJQfnxHDThaJ58iFSpyq4bLopeuATvd+4fOR2AAgbNaabNSMuQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] Bluetooth: advmon offload MSFT add rssi support
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        Yun-Hao Chung <howardchung@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Thu, 3 Dec 2020 at 22:03, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> > MSFT needs rssi parameter for monitoring advertisement packet,
> > therefore we should supply them from mgmt.
> >
> > Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> > Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> > Reviewed-by: Yun-Hao Chung <howardchung@google.com>
>
> I don=E2=80=99t need any Reviewed-by if they are not catching an obvious =
user API breakage.
>
> > ---
> >
> > include/net/bluetooth/hci_core.h | 9 +++++++++
> > include/net/bluetooth/mgmt.h     | 9 +++++++++
> > net/bluetooth/mgmt.c             | 8 ++++++++
> > 3 files changed, 26 insertions(+)
> >
> > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/h=
ci_core.h
> > index 9873e1c8cd16..42d446417817 100644
> > --- a/include/net/bluetooth/hci_core.h
> > +++ b/include/net/bluetooth/hci_core.h
> > @@ -246,8 +246,17 @@ struct adv_pattern {
> >       __u8 value[HCI_MAX_AD_LENGTH];
> > };
> >
> > +struct adv_rssi_thresholds {
> > +     __s8 low_threshold;
> > +     __s8 high_threshold;
> > +     __u16 low_threshold_timeout;
> > +     __u16 high_threshold_timeout;
> > +     __u8 sampling_period;
> > +};
> > +
> > struct adv_monitor {
> >       struct list_head patterns;
> > +     struct adv_rssi_thresholds rssi;
> >       bool            active;
> >       __u16           handle;
> > };
> > diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.=
h
> > index d8367850e8cd..dc534837be0e 100644
> > --- a/include/net/bluetooth/mgmt.h
> > +++ b/include/net/bluetooth/mgmt.h
> > @@ -763,9 +763,18 @@ struct mgmt_adv_pattern {
> >       __u8 value[31];
> > } __packed;
> >
> > +struct mgmt_adv_rssi_thresholds {
> > +     __s8 high_threshold;
> > +     __le16 high_threshold_timeout;
> > +     __s8 low_threshold;
> > +     __le16 low_threshold_timeout;
> > +     __u8 sampling_period;
> > +} __packed;
> > +
> > #define MGMT_OP_ADD_ADV_PATTERNS_MONITOR      0x0052
> > struct mgmt_cp_add_adv_patterns_monitor {
> >       __u8 pattern_count;
> > +     struct mgmt_adv_rssi_thresholds rssi;
> >       struct mgmt_adv_pattern patterns[];
> > } __packed;
>
> This is something we can not do. It breaks an userspace facing API. Is th=
e mgmt opcode 0x0052 in an already released kernel?

Yes, the opcode does exist in an already released kernel.

The DBus method which accesses this API is put behind the experimental
flag, therefore we expect they are flexible enough to support changes.
Previously, we already had a discussion in an email thread with the
title "Offload RSSI tracking to controller", and the outcome supports
this change.

Here is an excerpt of the discussion.
On Thu, 1 Oct 2020 at 05:58, Miao-chen Chou <mcchou@google.com> wrote:
>
> Hi Luiz,
>
> Yes, the RSSI is included as a part of the Adv monitor API, and the RSSI =
tracking is currently implemented (the patch series is still under review) =
in bluetoothd and used by bluetoothctl (submenu advmon). As mentioned, we a=
re planning to offload the RSSI tracking to the controller as well, so ther=
e will be changes to the corresponding MGMT commands.
> Thanks for your quick feedback!
>
> Regards,
> Miao
>
> On Wed, Sep 30, 2020 at 2:00 PM Von Dentz, Luiz <luiz.von.dentz@intel.com=
> wrote:
>>
>> Hi Miao,
>>
>> I do recall seeing these at D-Bus level, or perhaps it was in use by blu=
etoothctl commands? Anyway since these are still experimental it should be =
fine to change them.
>> ________________________________
>> From: Miao-chen Chou <mcchou@google.com>
>> Sent: Wednesday, September 30, 2020 12:51 PM
>> To: Holtmann, Marcel <marcel.holtmann@intel.com>; Von Dentz, Luiz <luiz.=
von.dentz@intel.com>
>> Cc: Alain Michaud <alainmichaud@google.com>; Yun-hao Chung <howardchung@=
google.com>; Manish Mandlik <mmandlik@google.com>; Archie Pusaka <apusaka@g=
oogle.com>
>> Subject: Offload RSSI tracking to controller.
>>
>> Hi Luiz and Marcel,
>>
>> Going forward to 2020 Q4, we will be working on offloading the content f=
iltering to the controllers based on controll's support of MSFT HCI extensi=
on. In the meantime, we are planning to change the existing MGMT commands o=
f Adv monitoring to allow the offloading of RSSI tracking shortly. Here is =
a snippet of potential changes.
>>
>> +struct mgmt_adv_rssi_thresholds {
>> +       __s8 high_rssi_threshold;
>> +       u16 high_rssi_threshold_timeout;
>> +       __s8 low_rssi_threshold;
>> +       u16 high_rssi_threshold_timeout;
>> +} __packed;
>>
>> struct mgmt_cp_add_adv_patterns_monitor {
>>         u8 pattern_count;
>> +        struct mgmt_adv_rssi_thresholds rssi_thresholds;
>>         struct mgmt_adv_pattern patterns[];
>> } __packed;
>>
>> Note that as suggested by you, the D-Bus Adv monitor API which accesses =
these MGMT commands is currently hidden behind the experimental flag, so th=
ey are still mutable. We'd like to hear your early feedback on changing the=
 corresponding MGMT commands.
>>
>> Thanks,
>> Miao

Thanks,
Archie
