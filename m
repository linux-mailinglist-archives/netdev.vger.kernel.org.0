Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA463F50C5
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhHWSwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhHWSwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 14:52:11 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBF8C06175F
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 11:51:28 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id q70so19808872ybg.11
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 11:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IGiq29GFk3P75dTzLBRFVCOVxIjMhP+zPDseLPooMus=;
        b=DY+ce+4lE3pv3dR2RU00+sqPqweQbWEgVf8cKCIurM8GmERAWAcIt1u9J6gKWiF+d8
         k5pPcUp+MKYwS5VUSoJdeyYiYDaDx3x8bqpAqLD8fIeN3f/rnp1h2IHW5SoKGbwCoWiY
         VoaKLwEmRcw+Zh0v2zhBVuDLLcgR2NG9ZsqeRI+yAeLbcjrfUutaPGhIdv3q9Sq48onK
         nBXB5b53VaGgDMOXUK5K7NsMUde+SjEkX5vI8m4qJv7Pvx0hQgCiiqrO6s3vvJTmuIhj
         5Zm1tl1NsseOe5UioxIPjSdGigUGBXNJYbRnGpNbhcfoDw+bIHRg3YguXshmqi7B0rlD
         6EeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IGiq29GFk3P75dTzLBRFVCOVxIjMhP+zPDseLPooMus=;
        b=YUwG5V2H06CVLmtwcMNR++jcmjsPnilYL4u4mQqgEfMRsTmr4OWGdSnhOsjM09M6B1
         NX7MvBK/10DAnNRKn33fHyYbFj9bae/C37sTh73/Wq0imhvp+XIWpTGn3ie3wH/jfXDw
         Oh9oiovto+sIIwCjO+Vthc0MoKkRLTbaVTR73QOfgkkriTeMjqfAFaDKKZ10NXKSXlVT
         vJ26aty+ICbHjQJbpI9a0NsWUidWo/eaoHzjKDMrN9VIdQd6+0y/35yhcW+s7sWx1U+c
         Jn3NsBvSl0QJkyxpGoj76WCrgRFrAfmUe1WHXPutR61pzCgFU6iMvnh5QeH1LXxWxZkS
         hHOA==
X-Gm-Message-State: AOAM5301kNNOhaaI1W+CCacT50EYk2jlzJoLXNumu3AkfpAVGL74OpT/
        N2L8EH9gqa4jBdt6yFScvPX5v58jBrRtRG30xW0Kvw==
X-Google-Smtp-Source: ABdhPJyVCbpr9F96yW+KQXA2xcJZFYPbcJtmlBUL0uqtNWFiAsWWEt6sDAAsVoONOH0upiI7LssdQU2wmMSEsqdtTlc=
X-Received: by 2002:a25:81ce:: with SMTP id n14mr48517800ybm.32.1629744687198;
 Mon, 23 Aug 2021 11:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
 <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk> <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk> <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk> <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
 <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com> <14891624-655b-a71d-dc04-24404e0c2e1a@bang-olufsen.dk>
In-Reply-To: <14891624-655b-a71d-dc04-24404e0c2e1a@bang-olufsen.dk>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 23 Aug 2021 11:50:50 -0700
Message-ID: <CAGETcx-7xgt5y_zNHzSMQf4YFCmWRPfP4_voshbNxKPgQ=b1tA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 7:19 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> w=
rote:
>
> Hi Saravana,
>
> Thanks for the follow-up. I tested your change and it does the trick:
> there is no deferral and the PHY driver gets probed first-try during the
> mdiobus registration during the call to dsa_register_switch().

I'm fairly certain the mdiobus registration happens before
dsa_register_switch(). It's in the probe call path of the DSA. The
connecting of the PHYs with the DSA is what happens when
dsa_register_switch() is called.

> I tested
> with the switch, PHY, and tagging drivers all builtin, or all modules,
> and it worked in both cases.
>
> On 8/20/21 6:52 PM, Saravana Kannan wrote:
> > Hi Alvin,
> >
> > Can you give this a shot to see if it fixes your issue? It basically
> > delays the registration of dsa_register_switch() until all the
> > consumers of this switch have probed. So it has a couple of caveats:
>
> Hm, weren't the only consumers the PHYs themselves? It seems like the
> main effect of your change is that - by doing the actual
> dsa_register_switch() call after the switch driver probe - the
> ethernet-switch (provider) is already probed, thereby allowing the PHY
> (consumer) to probe immediately.

Correct-ish -- if you modify this to account for what I said above.

>
> > 1. I'm hoping the PHYs are the only consumers of this switch.
>
> In my case that is true, if you count the mdio_bus as well:
>
> /sys/devices/platform/ethernet-switch# ls -l consumer\:*
> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> consumer:mdio_bus:SMI-0 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0
> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> consumer:mdio_bus:SMI-0:00 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:00
> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> consumer:mdio_bus:SMI-0:01 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:01
> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> consumer:mdio_bus:SMI-0:02 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:02
> lrwxrwxrwx    1 root     root             0 Aug 22 16:00
> consumer:mdio_bus:SMI-0:03 ->
> ../../virtual/devlink/platform:ethernet-switch--mdio_bus:SMI-0:03

Hmm... mdio_bus being a consumer should prevent the sync_state() from
being called on "ethernet-switch". What's the value of the "status"
and "sync_state_only" files inside that mdio_bus folder?

> > 2. All of them have to probe successfully before the switch will
> > register itself.
>
> Yes.

Right, it's a yes in your case. But will it be a yes for all instances
of "realtek,rtl8366rb"?

> > 3. If dsa_register_switch() fails, we can't defer the probe (because
> > it already succeeded). But I'm not sure if it's a likely error code.
>
> It's of course possible that dsa_register_switch() fails. Assuming
> fw_devlink is doing its job properly, I think the reason is most likely
> going to be something specific to the driver, such as a communication
> timeout with the switch hardware itself.

But what if someone sets fw_devlink=3Dpermissive? Is it okay to break
this? There are ways to make this work for fw_devlink=3Dpermissive and
=3Don -- you check for each and decide where to call
dsa_register_switch() based on that.

> I get the impression that you don't necessarily regard this change as a
> proper fix, so I'm happy to do further tests if you choose to
> investigate further.

I thought about this in the background the past few days. I think
there are a couple of options:
1. We (community/Andrew) agree that this driver would only work with
fw_devlink=3Don and we can confirm that the other upstream uses of
"realtek,rtl8366rb" won't have any unprobed consumers problem and
switch to using my patch. Benefit is that it's a trivial and quick
change that gets things working again.
2. The "realtek,rtl8366rb" driver needs to be fixed to use a
"component device". A component device is a logical device that
represents a group of other devices. It's only initialized after all
these devices have probed successfully. The actual switch should be a
component device and it should call dsa_register_switch() in it's
"bind" (equivalent of probe). That way you can explicitly control what
devices need to be probed instead of depending on sync_state() that
have a bunch of caveats.

Alvin, do you want to take up (2)?

-Saravana
