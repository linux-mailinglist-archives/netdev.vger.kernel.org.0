Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74239487E77
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiAGVtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiAGVtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:49:31 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A26C061574;
        Fri,  7 Jan 2022 13:49:31 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id w16so26983047edc.11;
        Fri, 07 Jan 2022 13:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RspMXkYZE1kXoxKwa/CQSP2jEqRzQTcawQLJqDscxlg=;
        b=R1XA8DfuHUoxCJkTUnHLbyYiYvdnLaOBBTlAZ6Dh4nUcYp2IiagXePViXx8AY/72uy
         0yci5zKEOcNzLCfdiKTq6WxezE01NHmPWnaMr4rExaULelt6KxMzbulXkAzms3oCI/FZ
         22s0Vi+nWE9wW0aG1F65MLCPhIHCAgsq9gQRSAGtVdjkaujIuoR8n7R7WWZ0flG+tXx5
         lhMFkiXih/weusYfhzQSy/Y57BSflT+gKx1oYMvy+YqFQKe8wdyrhIN/qAa2uI2sWw8t
         AtoP+r9gNPYeBDxN7F6fmTrHkzmWFH7MoTsCosx4r4NupxdMpHNbkmh3LBYJaoZVMZOX
         VWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RspMXkYZE1kXoxKwa/CQSP2jEqRzQTcawQLJqDscxlg=;
        b=t/0h4ImazvFcdgO7q4lECFb04zSMaYEBijxBUGC7mpFJmC3pdoLAyggtcPpCdxKwQT
         KeCE9lPw9JcV4DNu1AgfqKNbfRC+S/hjVP99J/kLFzTRS20e4GNiAVWq2AvNb9gT+uSo
         zZ4EN8ZVYu/ULru4ZmGazXtbW5SfhR56YyCqLbEuVGNkNMhRHWcdHbeSX2Q3vKQ3lnQ+
         hB7dM+6msK8w4MM0RXh7CWGfzdWWCiAyKHW1ZU3fvzYVv/+mHhfGSL1vpv98MudpAlkT
         m9io2T22LnuNpjHXHGGtNUszEay186pjt3JlJzA95Qp22E9xUuWqegwneFpRL3oKkiNI
         gVHQ==
X-Gm-Message-State: AOAM533J6Dbdal9/htBnRJgOi1tIBp1x0nGRo76lFYGID5qS7T0ad4Y+
        vuSm4QV2ZCm1UfvDgR3BaUlzNX1RngRJIS2CtCs=
X-Google-Smtp-Source: ABdhPJxGAYMn4vkFzj+A8Ph9piejFUJ8XYBCn0XzxZQSSs48CD95us9gT+qmVwBRo0lcJI8Y6wa8jpIPLNZoyVXux8o=
X-Received: by 2002:a17:906:f46:: with SMTP id h6mr22234747ejj.281.1641592169540;
 Fri, 07 Jan 2022 13:49:29 -0800 (PST)
MIME-Version: 1.0
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com> <daba93973e5945f8bf611ce4c33c82e7@realtek.com>
In-Reply-To: <daba93973e5945f8bf611ce4c33c82e7@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 7 Jan 2022 22:49:18 +0100
Message-ID: <CAFBinCCnvDqC2HhUh6o-WSOaB-McdAmYznQd6t88ZNR0WrvOfA@mail.gmail.com>
Subject: Re: [PATCH 0/9] rtw88: prepare locking for SDIO support
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ping-Ke,

On Fri, Jan 7, 2022 at 10:19 AM Pkshih <pkshih@realtek.com> wrote:
>
>
> > -----Original Message-----
> > From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > Sent: Wednesday, December 29, 2021 5:15 AM
> > To: linux-wireless@vger.kernel.org
> > Cc: tony0620emma@gmail.com; kvalo@codeaurora.org; johannes@sipsolutions.net; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org; Neo Jou <neojou@gmail.com>; Jernej Skrabec <jernej.skrabec@gmail.com>;
> > Pkshih <pkshih@realtek.com>; Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > Subject: [PATCH 0/9] rtw88: prepare locking for SDIO support
> >
> > Hello rtw88 and mac80211 maintainers/contributors,
> >
> > there is an ongoing effort where Jernej and I are working on adding
> > SDIO support to the rtw88 driver [0].
> > The hardware we use at the moment is RTL8822BS and RTL8822CS.
> > We are at a point where scanning, assoc etc. works (though it's not
> > fast yet, in my tests I got ~6Mbit/s in either direction).
>
> Could I know if you have improvement of this throughput issue?
Yes, in the meantime we have made some performance improvements.
Currently the throughput numbers are approx.:
TX: 30Mbit/s
RX: 20Mbit/s

I have seen RX and TX throughputs of up to 50Mbit/s on my RTL8822CS,
but I cannot reliably reproduce this (meaning: if I don't touch my
board and run the same iperf3 test again then in one run it may
achieve 50Mbit/s, but in the next run only 25Mbit/s).
In other words: throughput is much better than what we started with in
summer, but I think it can be improved further.

> I have done simple test of this patchset on RTL8822CE, and it works
> well. But, I think I don't test all flows yet, so I will do more
> test that will take a while. After that, I can give a Tested-by tag.
I also got feedback off-list from a user who used the patches from
this series on top of the out-of-tree rtw88-usb driver. These patches
fix one "scheduling while atomic" issue for him as well.
Maybe you can do your extensive tests after I sent v3 of this series?
Also thanks for offering to test this, I don't have any Realtek PCIe
wifi, so I am unable to verify I broke anything myself.


Best regards,
Martin
