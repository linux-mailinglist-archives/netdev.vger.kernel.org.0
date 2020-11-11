Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61452AFA41
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 22:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgKKVRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 16:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgKKVRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 16:17:30 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86936C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 13:17:30 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id f38so2284660pgm.2
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 13:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xKeSXUoPTb94VTZzArvQrdZOaZO1ARIP1gC1bThDFN0=;
        b=mEj+tQabiKrVPWL8ricFSm6QbRsIn9cB6UT88mz+ItP8ieG0GP7Y0/YecF1lvZvFxR
         SBQVSeplO78hEJR4u4dD8ABWa5NB5rPNyF8CfTSYLyhZLn24W8Xl9PJFbtUtfa1fDLEy
         HTAa2/fiv4LVqNF51B1sm+bNWjyCgffxJPSxddawWU4DaLfSgjU2an1VcYJ5POeBXDNZ
         3L2v6cUzlb/1FGI2nyLCLasXbe2ry+K7bNyifA92BgObPWVOWvrQTew+NgMteLssDHhb
         46QbYDL/yXJE0Ibu8a7DNPVRsw1IIOrweGBBBa/MdAGiHwm1nWnnQruHufyct4cwHSPD
         F8EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xKeSXUoPTb94VTZzArvQrdZOaZO1ARIP1gC1bThDFN0=;
        b=e3k09C4et62Zr+eEraf3ZiU6ktR0jss/TLEUavX7+yWCIVw97haA4qDDCCnRIHe5ac
         kOnuLQvKWlxv40Y2bXTF2Bfxkc4+q/dy8CEF8ZIcTtLYdG5+PFAwpAeQRJBP2Z1S0mSo
         fyocXUh7q49BMM5kb6S2ue/7CcPpIjyhK1yK/7zVWJnb2HH2A3MBkiLJRI3fB1yBfb/A
         gNghYyCk6i15C81olPH0CNYXP5ehjXGY5+X/96y4III5rnw1oN8FINL22Y6Jtd4zk0hp
         QpAWpPmjxQbdCppKU58OlLFI4Ip8mnSE+twW78qsPNQJNUDCQvJrQGT2hr5cEjfm53S3
         Pfww==
X-Gm-Message-State: AOAM533wnHU7B8QzEDG8lbAwMaaU/5Pur8tFJ1HLsfJWEziwCO/DnTze
        LP5hatyLTgyBEcljYkaUJnIBIw==
X-Google-Smtp-Source: ABdhPJyr/nmYBCSLIlqS8cvY75Jv9KTjZ2ftDsM3qoqfe5nvQbqssqXFDwCYzdAGnxSHEySZH3uucw==
X-Received: by 2002:a17:90a:1bc3:: with SMTP id r3mr5859850pjr.196.1605129449739;
        Wed, 11 Nov 2020 13:17:29 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y201sm3462776pfb.2.2020.11.11.13.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 13:17:29 -0800 (PST)
Date:   Wed, 11 Nov 2020 13:17:24 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Erik Kline <ek@loon.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?5p2c6Iux5p2w?= <leondyj@pku.edu.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: some question about "/sys/class/net/<iface>/operstate"
Message-ID: <20201111131724.3ee61c26@hermes.local>
In-Reply-To: <CAAedzxoW76P7jk3k4auR+DY_829FKwVLBi6uDzn7C2Y6381=YQ@mail.gmail.com>
References: <1a87f1b4.3d6ab.175b592a271.Coremail.leondyj@pku.edu.cn>
        <CAM_iQpVzC6PTX8b0cgXO=Pcp_jFCw-UtP__AYyoN7pZLovkqcQ@mail.gmail.com>
        <20201111115520.08b58818@hermes.local>
        <CAAedzxoW76P7jk3k4auR+DY_829FKwVLBi6uDzn7C2Y6381=YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 12:34:51 -0800
Erik Kline <ek@loon.com> wrote:

> On Wed, Nov 11, 2020 at 11:55 AM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Wed, 11 Nov 2020 11:02:14 -0800
> > Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > =20
> > > On Tue, Nov 10, 2020 at 8:32 PM =E6=9D=9C=E8=8B=B1=E6=9D=B0 <leondyj@=
pku.edu.cn> wrote: =20
> > > >
> > > > I want to use inotify to monitor /sys/class/net//operstate  to dete=
ct status of a iface in real time.
> > > > when I ifdown &amp;&amp; ifup eth3, the content of operstate change=
d, but the file's Modify time didn't change.
> > > > I don't know the reason, is there any file which can be monitored b=
y inotify to get iface status in real time?
> > > > Much appreciation for any advice! =20
> > >
> > > You need to listen to netdev netlink messages for changes like
> > > this. These messages are generated in real-time. =20
> >
> > The /sys and /proc are pseudo-filesystems. The file modify time and ino=
tify do not work
> > as expected on these files. Cong is right you need to use netlink for t=
his. =20
>=20
> Related question: could/should modify time and/or inotify be made to
> work?  I genuinely don't know if that would even be possible (separate
> from "desirable").

The problem is lots of data changes in /proc and /sys all the time, like ev=
ery counter
value. So having any kind of notification would be a major performance hit.
