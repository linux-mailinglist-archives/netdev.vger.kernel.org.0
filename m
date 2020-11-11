Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42B42AF9D2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKKUfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 15:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKKUfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:35:04 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5BEC0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:35:04 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id m16so1938813vsl.8
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 12:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=loon.com; s=google;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=RMl4KDgGZ/EpMapFL4KPnRlmEYjfr1x8joycjp3aRI0=;
        b=ZPWDQaEMSuMlNRoYzO860tIIn76m5ICvwJjzXYTLQzo0qUQnpajWyVp+YCvezSKaSl
         JRrwF2jFl/AOzd7Ndx9/tjp5MLD+xsZgbl5W1ms4PTsAhmS3E4lMPHtQ8WcEyLMg2b1W
         rrXpfarCmkDIWm5fLBqTfnBe/Q2fADlCk/444=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=RMl4KDgGZ/EpMapFL4KPnRlmEYjfr1x8joycjp3aRI0=;
        b=QBZSU05VRwUTus2d+SYEah23h8CT91D2SZTeQD8qChSquV79Mcyk+AQ4zrinoEMz1Z
         rH+KxsgTKmMBHZBE6DU9dxQGCWXE8kojH/1kAfZs4zuPR2+CiFi7aPHTiYnGTtlIPZoj
         4Cdzp4XKvWx0u3RDsFGaWBHAT2aC1dAq+ttoc3VTAlqju5Vn+MZ/XLbIl3TQAPmAXsDr
         eTqqIZeKvK+HoHru3et8GC3/cCbuhBru76sVrKOqTpl37jtIJCBPbhsCUF9TKBLcXCan
         kVaMAip33OEAVtK8GwY8eEcCN5HSKwQrwS1m/TYZrXtT+D+/GoPuj5+LxZUkrKZas3Y/
         KxzQ==
X-Gm-Message-State: AOAM532YfZwiRej1C2J8qJos1JjpAwbXRVvuh2riI8Ou4MAEOP7j+OGG
        23pfi1RIgQi4NYf6mNaB+ZXNcpfbEbuXEYFNIkxPqg==
X-Google-Smtp-Source: ABdhPJxXxnXmn6dauIjSozqPoLRjqKjEZtPhAF98lCtl6e4zV8F52CWDOuDaunOYy4Cl8IjCktSqua9p3g+MNAjfLgU=
X-Received: by 2002:a67:1e01:: with SMTP id e1mr17544073vse.49.1605126903325;
 Wed, 11 Nov 2020 12:35:03 -0800 (PST)
MIME-Version: 1.0
References: <1a87f1b4.3d6ab.175b592a271.Coremail.leondyj@pku.edu.cn>
 <CAM_iQpVzC6PTX8b0cgXO=Pcp_jFCw-UtP__AYyoN7pZLovkqcQ@mail.gmail.com> <20201111115520.08b58818@hermes.local>
In-Reply-To: <20201111115520.08b58818@hermes.local>
Reply-To: ek@loon.com
From:   Erik Kline <ek@loon.com>
Date:   Wed, 11 Nov 2020 12:34:51 -0800
Message-ID: <CAAedzxoW76P7jk3k4auR+DY_829FKwVLBi6uDzn7C2Y6381=YQ@mail.gmail.com>
Subject: Re: some question about "/sys/class/net/<iface>/operstate"
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?5p2c6Iux5p2w?= <leondyj@pku.edu.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 11:55 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Wed, 11 Nov 2020 11:02:14 -0800
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> > On Tue, Nov 10, 2020 at 8:32 PM =E6=9D=9C=E8=8B=B1=E6=9D=B0 <leondyj@pk=
u.edu.cn> wrote:
> > >
> > > I want to use inotify to monitor /sys/class/net//operstate  to detect=
 status of a iface in real time.
> > > when I ifdown &amp;&amp; ifup eth3, the content of operstate changed,=
 but the file's Modify time didn't change.
> > > I don't know the reason, is there any file which can be monitored by =
inotify to get iface status in real time?
> > > Much appreciation for any advice!
> >
> > You need to listen to netdev netlink messages for changes like
> > this. These messages are generated in real-time.
>
> The /sys and /proc are pseudo-filesystems. The file modify time and inoti=
fy do not work
> as expected on these files. Cong is right you need to use netlink for thi=
s.

Related question: could/should modify time and/or inotify be made to
work?  I genuinely don't know if that would even be possible (separate
from "desirable").
