Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B77131871B
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 10:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhBKJ3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 04:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhBKJ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 04:27:33 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A20C061786
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 01:26:52 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id h6so5373031oie.5
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 01:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jsCRFes+iNIOcA6nuOPlPmxykHMWcGsGKAHRk6OtZ4g=;
        b=CTHYiCAbf+o6JC9kn+qEUxdqKhPrVEV3YHNVIaKlDvhW6HYWNLZ1W3A4T48m22bJi3
         mn3k02g7hun/GzF2Qv1AupXiGmP1A0Pp7t86Njpka0mvNRuEeYmUkZTG7Y4pqSSpaHOh
         IST7SBiMiLkIKs8YD/FXWIX0evIZ8d2xDIr7cUv3XSky7rvPzP/QJQr4dpegaUm0lZDg
         VF6Zm9+DXPlobw9KtY9X+0+LAYD5Hih9mkOLjQ67XV6heoyAekh2xHbN6sNp6X3Zdn9r
         UM5CjPi+sc8e05LPoYBM6GNO3GPlMbSBkFlfXlo5igoLlZSeV/KyOMFpgPeSxce05Qht
         4WkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jsCRFes+iNIOcA6nuOPlPmxykHMWcGsGKAHRk6OtZ4g=;
        b=i9yulJbbPlGr8Ozr3OgXwgCw2D5sYKIhYNdWfuozzbXZn9NJZ4qB+lRg6bKQ/aFj53
         pfBRCsrtIF3GgUjVwTdV5CGd9a9NIxr8K6kf/AaMTjrxD6vxcxzlOV9tK2XGw7CUTDpA
         XZDuhD1mmHikk0Ql4yi4NO2voryrfyfPY405RJJyFbLq/gYEhvGdn1hG+MByq6PqSfKu
         MSt2xraJZEnWXbIpntCWq/jDA9VZbzIgG92L+4V65vbGmcuH9+4tgt2fLqSzgZLdRR3w
         w5ddN80XNiQsQQFIVSma8kBAPlwyAxDwxRykhLy9j3DAtR6Ef/zhvlYLzt2Fmq3C5iol
         /45w==
X-Gm-Message-State: AOAM531XZOAJcnYi2WCK0FyC+9l75iyLY054U+zrgqIOlpvHZ5LA3bF0
        IehNpoN/mDrm8GKSPQM7KrPtvuqG4fir9VHYDZs8S+hi1nGcT9Po
X-Google-Smtp-Source: ABdhPJxGM+df1a7ssbuK/9sS4Nwt+ETuRDz+SyJX9bnygZ54cEdli2nkn1V9NZXjSzOez+Ij/NdOZz87tIt/ywTNQfk=
X-Received: by 2002:aca:e108:: with SMTP id y8mr2194310oig.114.1613035611589;
 Thu, 11 Feb 2021 01:26:51 -0800 (PST)
MIME-Version: 1.0
References: <YBfi573Bdfxy0GBt@kroah.com> <20210201121322.GC108653@thinkpad>
 <20210202042208.GB840@work> <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org> <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
 <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAAP7ucLZ5jKbKriSp39OtDLotbv72eBWKFCfqCbAF854kCBU8w@mail.gmail.com>
 <20210209081744.43eea7b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210210062531.GA13668@work> <20210210104128.2166e506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210210104128.2166e506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu, 11 Feb 2021 10:26:40 +0100
Message-ID: <CAAP7uc+cEeD=G4H-2+Jbt3j15tuak6PruVnAbJhhbeUsizwhYA@mail.gmail.com>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
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

> What bothers me is maintaining shim drivers which just shuttle opaque
> messages between user space and firmware. One of which definitely is,
> and the other may well be, proprietary. This is an open source project,
> users are supposed to be able to meaningfully change the behavior of
> the system.

libqmi is an open source library under the LGPL; so all the messages
that are passed between e.g. ModemManager and the modem firmware can
be easily inspected by anyone. It is true, though, that libqmi may
also allow passing "unknown" messages between other proprietary third
party applications and the firmware, but that is very much like any
other modem control port that we already have; be it a plain tty, or a
ttyUSB or a ttyACM or a cdc-wdm port. The kernel drivers are passing
unknown stuff between modem firmware and userspace; I don't see how
the kernel driver would be interested in any other thing really. QMI
and MBIM are just 2 binary protocols (and we have libqmi and libmbim),
and there's a generic 3GPP AT command set, but every vendor then has
its own interpretation of that AT command set, and vendor-specific AT
commands, and what not. From my point of view, it's not like the
kernel should know or have much to say on what's being passed to the
modem.

>
> What bothers me is that we have 3 WWAN vendors all doing their own
> thing and no common Linux API for WWAN. It may have been fine 10 years
> ago, but WWAN is increasingly complex and important.
>

A WWAN modem is nowadays a complete Linux system itself with tons of
features, and if there is sometime a generic WWAN system in the kernel
providing API/ABI for generic features (e.g. data connection), that
API/ABI should anyway provide access to pass messages (be it binary,
or text AT commands) between firmware and userspace, for all the other
side features for which no generic API/ABI is provided by that
hypothetical generic WWAN system. Unless we don't want any of those
side features... like Voice call management, SMS, USSD, GNSS, SAR,
OMA-DM, carrier config selection, multi-SIM setups...

-- 
Aleksander
