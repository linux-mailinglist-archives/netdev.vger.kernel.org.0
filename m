Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26B831545F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhBIQvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbhBIQun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:50:43 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39965C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 08:50:02 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id k10so15704558otl.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 08:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKwNo6TC+1q3oQgv5Miw/gtfysz963YICrpQOCkStJ8=;
        b=nRmGzLhyU4G9H274uUqksm/3yq38VX5VcGp0ZwGZqNDUNETv8QvewOOKe0Y+SwksNG
         t3oES0hFI9jU/A0sJF1MenV1DhvlYGoOkQm1Ua0A5c4uVI3uFifwp7gL0ZeWKDtQPRcJ
         58PvjG/3BhqPJm8FAp9d2KFgOawr5WCwgRBCpaKQ4Scj51MSJ5MMqCpo9eN2/w29f27m
         GvLP2d711dMWgtB/1BeAe4CE+0pMPPHhwj1TfIEtUh6zZIHB/wHP6xvrd8GkpL0uJviC
         +OEkeACTEZgt2TNjef6IRGtWDcMiKQoP4oqriD/vQxpIAzciIxkAnEntXXVfAH999IC3
         c9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKwNo6TC+1q3oQgv5Miw/gtfysz963YICrpQOCkStJ8=;
        b=dkP5HG3iLVJ2ot4z3LgKh8G3EMqqB4E3v84rjOrgw2SWgvY/dB0GsZRLUAZA8TFS6Y
         kvqA/MCusKcX/r1B5np9nPXF9eKBxK2EgSDO9PyvDqNfRrmS+9bx3K2DMbUkRn2McGWW
         F2LV4bD06dFOYR6JkG4ZUWCwGjqWXEEAC2ST2c8lfNaUw14u18FczRRR8VvnKTanWT6v
         LMUEzfjL+DV7KDEHruby666lvQUgmA9qztIuBaqViQIU/5gd9ZDukAgIHX0oXOO9v/Ia
         RD5fqFs1X/Ap1tWUpwPMLtikPi/pKkMfpmj3aPP+RSVYRfN6yLz42fDCsta3KERGJD8Y
         dGtg==
X-Gm-Message-State: AOAM531gXaCuyw7YDV30inRgbvyFBxGY1Vab17LPskPZpSkTIRXYj2We
        lMdsrj+TMYgKF7ybzqa7fHwk0au37Fa7zGxYV7ZWzQ==
X-Google-Smtp-Source: ABdhPJxi3nburzdMpmtBueqBH1zmdUHAFcqMySogLILTXDVvPm/8sGfTIrB4GvKr/ee2mYjeic1LaaWxwIWNVa+Tumg=
X-Received: by 2002:a9d:6358:: with SMTP id y24mr16384584otk.229.1612889401486;
 Tue, 09 Feb 2021 08:50:01 -0800 (PST)
MIME-Version: 1.0
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
 <20210113152625.GB30246@work> <YBGDng3VhE1Yw6zt@kroah.com>
 <20210201105549.GB108653@thinkpad> <YBfi573Bdfxy0GBt@kroah.com>
 <20210201121322.GC108653@thinkpad> <20210202042208.GB840@work>
 <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org> <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
 <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com> <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Tue, 9 Feb 2021 17:49:50 +0100
Message-ID: <CAAP7ucLVVTUqMX4_jFvvYNXALHgHZmcvX4WQei8cPubfUgXKGQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey,

> On Tue, 9 Feb 2021 10:20:30 +0100 Aleksander Morgado wrote:
> > This may be a stupid suggestion, but would the integration look less a
> > backdoor if it would have been named "mhi_wwan" and it exposed already
> > all the AT+DIAG+QMI+MBIM+NMEA possible channels as chardevs, not just
> > QMI?
>
> What's DIAG?

DIAG/QCDM is an older protocol in Qualcomm based modems; in USB based
devices we would get a TTY that speaks this protocol. In legacy CDMA
modems this was required for actual device control (and ModemManager
has a libqcdm for that
https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/tree/master/libqcdm)
but in all newest modems I'd say this is exclusively used for modem
trace retrieval (e.g. asking the modem to enable some internal traces
of the LTE stack which are downloaded in the host via this port). When
debugging issues with manufacturers, this is what they would ask you
to do, use this port to retrieve these traces (e.g. Quectel's QLog
program does that, each manufacturer keeps its own).

> Who's going to remember that this is a backdoor driver
> a year from now when Qualcomm sends a one liner patches which just
> adds a single ID to open another channel?

I'm obviously not going to argue about that possibility; although,
wouldn't it make more sense to discuss that whenever that happens?
This work is implemented in a very generic way probably, but it
focuses on WWAN control ports, which is what we need in userspace.

Right now this mhi_uci integration can be used for QMI control of the
modems, and I assume once that gets merged (if ever!), more patches
would arrive to enable AT, DIAG and MBIM control ports. The channels
associated to these WWAN control protocols have clearly defined
channel ids, and I believe the device itself chooses which channels
are exposed, so a device may e.g. say that it's going to expose only
the MBIM control port. This is also very manufacturer dependent I
think; I know for example that WWAN modules for laptops will probably
want to expose the MBIM channel instead of QMI, so that the same HW
integration is used in both Linux and Windows easily. The single and
generic mhi_uci integration for all these different WWAN control ports
would allow any of those combinations, very much like with USB devices
and different USB configurations.

Userspace is also ready for this integration, btw; at least libmbim
and libqmi don't have any problem with these chardevs, and
ModemManager has a branch ready to land to support this new
integration. A lot of new laptops that are already being sold since
last year come now with PCIe-only WWAN modules, and unfortunately I've
also seen different manufacturers pushing their own out-of-tree
variants of this same mhi_uci idea with better or worse luck. I
personally was very glad to see this work moving forward.

--
Aleksander
