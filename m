Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A4E56C355
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238449AbiGHSkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236808AbiGHSkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:40:36 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BECA13CFE;
        Fri,  8 Jul 2022 11:40:35 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id d12so14369824lfq.12;
        Fri, 08 Jul 2022 11:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DfjJfpHS3v6csJ5REpxxK0NrTLQeFjR+dlso3qlNSvU=;
        b=OE/4FaWK7bD0OhB0sQ5cglvrD5JgM7ooEm7igt8XC8kzKlH+RN0SxabKKtkoudFqUU
         QB7cV8mdy6m5tMK8lfrl01i+sJr5op5A0zzzApDOvNi9xiJSoecxM+tpd9I7iq8xM/5o
         mZ6FnsYPPe1r1WH7L0P9mTlNdjIUSf+ytIoYHRrw7bYr7M7ZfaGtesm9t/TWbxCe0i5B
         4Ck2N2S/mSQ+M+esaelczHGu385KP4UvDF/BsUjkoXcdYeT+YmT21w3hpyR4qNcky3vn
         i5vjqh64WrObvUsdtAjBP9UuJFI1X1oLJXCKnk6WHZhsYk8zj/A0mJJqw6n1yeGwy5nW
         IF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DfjJfpHS3v6csJ5REpxxK0NrTLQeFjR+dlso3qlNSvU=;
        b=O2u4sCjgpLk2WtSMIyThjnZ9i5UGBbGsyDrJC4zNfCUK7xMi93UAGavErqV3OeZK8I
         jxHnsv2pXEEp3siqaYCmFl5X3ewkTGPIaLV4Vjk1BGxlZU52TWpfsyI7Hx2aCM0ztTfu
         nIouXb1os+mYyA3s1qvTiLnJQmIJe9+3IGLgpLSdtPvsUhY2Lh7RJNJPNePuwl0kx7H5
         AE+SgiVZXrX5l0vwSm0oUTSU9nfpKeHfqXhAYAh+wpiWgOJ/VhsmR08TdF82U+TgB/EJ
         nPK2Rp1jcjDn49UcQLdz38UEH7xF7s1KmVIrVLdpBtnXS//AmBi/3VQtmFMiIr2JsE2V
         xyiw==
X-Gm-Message-State: AJIora9r6lUvcxLS0LNtVLDterZMqCOGMlB9CFQnfIA4CS94KuF5bBYt
        nSs/ja75DKVkPMueh/2ytS60A1+0SD7GEeuPI2g=
X-Google-Smtp-Source: AGRyM1ueOgfntledxcBKr3ksLbw/BRAgaD6wdlm81vWNHvF+9rBG70KkAhcVXM6DFjcZLlfZcnoQAl8unxsBmqwklos=
X-Received: by 2002:a05:6512:108d:b0:481:6f3:e641 with SMTP id
 j13-20020a056512108d00b0048106f3e641mr3032801lfg.251.1657305632618; Fri, 08
 Jul 2022 11:40:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220707151420.v3.1.Iaf638bb9f885f5880ab1b4e7ae2f73dd53a54661@changeid>
 <20220707151420.v3.2.I39885624992dacff236aed268bdaa69107cd1310@changeid>
 <CABBYNZL5oXFsyBN6JRdt1JeD2v5h3MOpCAa4hF0sXfw5F6u3Pg@mail.gmail.com> <CAGPPCLDBVwaXNbr6_wsj-M+Lbdbn6CbZippHYS5F-2vREBPHbg@mail.gmail.com>
In-Reply-To: <CAGPPCLDBVwaXNbr6_wsj-M+Lbdbn6CbZippHYS5F-2vREBPHbg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 8 Jul 2022 11:40:21 -0700
Message-ID: <CABBYNZLWTbogiUvs3pxE=JPtVX-bxpBa7dKNUL3jh1-a8axR5A@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] Bluetooth: Add sysfs entry to enable/disable devcoredump
To:     Manish Mandlik <mmandlik@google.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Manish,

On Fri, Jul 8, 2022 at 11:30 AM Manish Mandlik <mmandlik@google.com> wrote:
>
> Hi Luiz,
>
> On Fri, Jul 8, 2022 at 10:24 AM Luiz Augusto von Dentz <luiz.dentz@gmail.com> wrote:
>>
>> Hi Manish,
>>
>> On Thu, Jul 7, 2022 at 3:15 PM Manish Mandlik <mmandlik@google.com> wrote:
>> >
>> > Since device/firmware dump is a debugging feature, we may not need it
>> > all the time. Add a sysfs attribute to enable/disable bluetooth
>> > devcoredump capturing. The default state of this feature would be
>> > disabled and it can be enabled by echoing 1 to enable_coredump sysfs
>> > entry as follow:
>> >
>> > $ echo 1 > /sys/class/bluetooth/<device>/enable_coredump
>> >
>> > Signed-off-by: Manish Mandlik <mmandlik@google.com>
>> > ---
>> >
>> > Changes in v3:
>> > - New patch in the series to enable/disable feature via sysfs entry
>> >
>> >  net/bluetooth/hci_sysfs.c | 36 ++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 36 insertions(+)
>> >
>> > diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
>> > index 4e3e0451b08c..df0d54a5ae3f 100644
>> > --- a/net/bluetooth/hci_sysfs.c
>> > +++ b/net/bluetooth/hci_sysfs.c
>> > @@ -91,9 +91,45 @@ static void bt_host_release(struct device *dev)
>> >         module_put(THIS_MODULE);
>> >  }
>> >
>> > +#ifdef CONFIG_DEV_COREDUMP
>> > +static ssize_t enable_coredump_show(struct device *dev,
>> > +                                   struct device_attribute *attr,
>> > +                                   char *buf)
>> > +{
>> > +       struct hci_dev *hdev = to_hci_dev(dev);
>> > +
>> > +       return scnprintf(buf, 3, "%d\n", hdev->dump.enabled);
>> > +}
>> > +
>> > +static ssize_t enable_coredump_store(struct device *dev,
>> > +                                    struct device_attribute *attr,
>> > +                                    const char *buf, size_t count)
>> > +{
>> > +       struct hci_dev *hdev = to_hci_dev(dev);
>> > +
>> > +       /* Consider any non-zero value as true */
>> > +       if (simple_strtol(buf, NULL, 10))
>> > +               hdev->dump.enabled = true;
>> > +       else
>> > +               hdev->dump.enabled = false;
>> > +
>> > +       return count;
>> > +}
>> > +DEVICE_ATTR_RW(enable_coredump);
>> > +#endif
>> > +
>> > +static struct attribute *bt_host_attrs[] = {
>> > +#ifdef CONFIG_DEV_COREDUMP
>> > +       &dev_attr_enable_coredump.attr,
>> > +#endif
>> > +       NULL,
>> > +};
>> > +ATTRIBUTE_GROUPS(bt_host);
>> > +
>> >  static const struct device_type bt_host = {
>> >         .name    = "host",
>> >         .release = bt_host_release,
>> > +       .groups = bt_host_groups,
>> >  };
>> >
>> >  void hci_init_sysfs(struct hci_dev *hdev)
>> > --
>> > 2.37.0.rc0.161.g10f37bed90-goog
>>
>> It seems devcoredump.c creates its own sysfs entries so perhaps this
>> should be included there and documented in sysfs-devices-coredump.
>
> I deliberately created it here. We need to have this entry/switch per hci device, whereas the sysfs entry created by devcoredump.c disables the devcoredump feature entirely for anyone who's using it, so it can act as a global switch for the devcoredump.

We should probably check if there is a reason why this is not on per
device and anyway if seem wrong to each subsystem to come up with its
own sysfs entries when it could be easily generalized so the userspace
tools using those entries don't have to look into different entries
depending on the subsystem the device belongs.

>
>>
>> --
>> Luiz Augusto von Dentz
>
>
> Regards,
> Manish.



-- 
Luiz Augusto von Dentz
