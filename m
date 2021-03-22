Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A489A343924
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 07:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCVGEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 02:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhCVGEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 02:04:01 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C702C061574;
        Sun, 21 Mar 2021 23:04:01 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id x2so11908437oiv.2;
        Sun, 21 Mar 2021 23:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=L7oOn/ROAR60H6KG2WZjLarg9P4X7xIFiM6//2EpiH4=;
        b=RReUc0BWxXmf8zDGRBzHgEqjLOovym2EEzkAFzbie33DYd+hDLBPKhSOJiTdsBQbgU
         +6SjQTr/JTuxeFwRYC4eV4CgsFfVDI1UW1c8HhqvShbc0Id3WBXxzEvIAei6v4JC/1oI
         FLcU+hoMjXCfN63sqJBwVHHAn3Bh2r6YXf5kDHDHsR5eXQzUycYUXeegJ+nxXhHrfnz/
         aT94jHNVS9iyveE6Lg9vG3kmjL69eAFa7iKAkGzabpUStRfjiCcy6DUpAQHU+GKVTmT5
         h9rGCzaaTKv22nPNmy0D07bIj16570NkUcwIPP7ttKoz6NGQQc9fvSpNDB74lumXixYw
         tEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=L7oOn/ROAR60H6KG2WZjLarg9P4X7xIFiM6//2EpiH4=;
        b=KL/IcP33HTta7OLqxCDQvYed2M790G1TDPBQjRrJ42JlJmm6Bov0t6pj8/YgCbOqSL
         uT95htuJmG93bsouTQgN/PPZ02sYahWoK8wa7z2cmpvKA/lSGxV00JZe56HiWN3fp09q
         gC8yUsN5ighOEcTr1q5qR8ldt7BftVu0kY3L9lYOo6PRxPqfEhJWGqhfqKjIMcDSucUg
         Lhgbbe9OHwPnmn9ibTu0uqqO/WcIZr8rvCCGC55cBMl2N+k4/KmaXzHlrK5HdQNt/pll
         nHd2EPYG+4PBB5bWFDTLjEAVwkxFsYCaDKtoGf8HVJ3TonewPhdGkrAsjRJ3GKl+y+Qe
         +yAA==
X-Gm-Message-State: AOAM532BXv6OOtHpnkvHWv5IaTQ5u9nwcTQMq7+Gu/vQWODsDJrrRt6L
        rQJqQWA7tqngVGm4Z/U2AzYAfp3h1UXXEdHu5+GKIn02qog=
X-Google-Smtp-Source: ABdhPJwo8jDF1DKR/N3qakZot2XEAM4++S/V824wZ994yzuRdKsS/YYmW0kT1aWGYVcg4IDvgxi6A5nvGoq7Kl/jrMQ=
X-Received: by 2002:aca:c4c7:: with SMTP id u190mr8149442oif.161.1616393040807;
 Sun, 21 Mar 2021 23:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <13aed72.61c7.17853a6a5cd.Coremail.linma@zju.edu.cn>
 <CABBYNZKwHEXK680Xz+W=2qXdkO2eEzTBu38Hc=5DaxggkaTSsg@mail.gmail.com> <CAO1O6sfdpWzULj_Yj1s_GTFiLaZFFjrrj_0RPAVe1hyk3uuSsg@mail.gmail.com>
In-Reply-To: <CAO1O6sfdpWzULj_Yj1s_GTFiLaZFFjrrj_0RPAVe1hyk3uuSsg@mail.gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Sun, 21 Mar 2021 23:03:50 -0700
Message-ID: <CABBYNZKsenDE7FYVOY8V-YS4FeLg1UA82PMAM-Bo5y6Godebyw@mail.gmail.com>
Subject: Re: BUG: Out of bounds read in hci_le_ext_adv_report_evt()
To:     Emil Lenngren <emil.lenngren@gmail.com>
Cc:     =?UTF-8?B?6ams6bqf?= <linma@zju.edu.cn>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yajin_zhou@zju.edu.cn, syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Emil,

On Sun, Mar 21, 2021 at 4:23 PM Emil Lenngren <emil.lenngren@gmail.com> wro=
te:
>
> Hi,
>
> Den m=C3=A5n 22 mars 2021 kl 00:01 skrev Luiz Augusto von Dentz
> <luiz.dentz@gmail.com>:
> > Or we do something like
> > https://lore.kernel.org/linux-bluetooth/20201024002251.1389267-1-luiz.d=
entz@gmail.com/,
> > that said the reason we didn't applied my patches was that the
> > controller would be the one generating invalid data, but it seems you
> > are reproducing with vhci controller which is only used for emulating
> > a controller and requires root privileges so it is unlikely these
> > conditions would happens with hardware itself, in the other hand as
> > there seems to be more and more reports using vhci to emulate broken
> > events it perhaps more productive to introduce proper checks for all
> > events so we don't have to deal with more reports like this in the
> > future.
>
> Keep in mind that when using the H4 uart protocol without any error
> correction (as H5 has), it is possible that random bit errors occur on
> the wire. I wouldn't like my kernel to crash due to this. Bit errors
> happen all the time on RPi 4 for example at the default baud rate if
> you just do some heavy stress testing, or use an application that
> transfers a lot of data over Bluetooth.

While we can catch some errors like that, and possible avoid crashes,
this should be limited to just boundary checks and not actually error
correction, that I'm afraid is out of our hands since we can still
receive an event that does match the original packet size but meant
something else which may break the synchronization of the states
between the controller and the host, also perhaps we need to notify
this type of error since even if we start discarding the events that
can possible cause states to be out of sync and the controller will
need to be reset in order to recover.

--=20
Luiz Augusto von Dentz
