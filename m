Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F36DC104791
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 01:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfKUAet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 19:34:49 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41201 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbfKUAet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 19:34:49 -0500
Received: by mail-yw1-f68.google.com with SMTP id j190so701997ywf.8
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 16:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VWaEHl8kXnc/ilBwIC0fKVOLGYT5m0zyjw0M9xnnzec=;
        b=Az2PFRJ8EoqwtO1bnQ8JGV3VAc56DAnemflFAP0xrpuL2abK/J9DufsGpYWK58Lqdj
         GkjIXEiU0StKTI/wK4U9PrC3pqu2Nrmfo33rpm9q0s9Rb2Su9DGJGsJ72BvJaOJNuA9l
         tpJgRQaLUMJZ/cEkMCXd/1iwXYEj5GdV4lXAOOI3CwARuABYLPAmLGg2WPM8H1sbGjv9
         60E50LFMpIe2eE7yqTXwUABDYhEBQzTvlR8HgTSXwg7ocCDMWQK2nyFMF8h4yBm/Jokz
         jd+RcqIV09Yp9KwZ/31o4tpeDK+WZRLUJel0vbFmIJIzVVxdlL7NxrHrygzf7r/xJl6T
         GVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VWaEHl8kXnc/ilBwIC0fKVOLGYT5m0zyjw0M9xnnzec=;
        b=ci57xuxevmpqY4DhusPN7RFwDLWU+WuGMBAfP5ViVIslp9r6Fqyayzvr/U92poNMnB
         EBX0E0i+6H3c7W+GZBgFtm1uGLIewon2AD5rxepmsrCCcF/jfA1qTdLmtt2vmi7TLUvQ
         N7NuuawmOgGrXVKNT2pBzYAp28eVrWkVkzoyxleOoaw0mwSV8kNqdrMc3eHREMm+6a3C
         mH7WiePZahI0IGGOgBXWwJuD2nyMEKvRT9VIkfGtIEkgJ5YJqb7dwLubRivgvnQfFdV8
         gYPmxBZxQZ39+knn7snbY+2aoTX0ZAZkDiWmOO9gfil9/N5QBtdCDcfrULum+M7a3XiH
         zfxg==
X-Gm-Message-State: APjAAAW38PlKvSPXIwqWTiL9kaQTHvd99gc6531sP4bQ35WTB3NqAVO3
        9JwwQybrycek0REq8xK8Q6mn+Hls
X-Google-Smtp-Source: APXvYqwmeobVmfY6RALReOsJ6JnoX0e1cn4vGAaIwIwTk2fGjy04rpgyhna4cFSPD3xNQZaGgqvUHQ==
X-Received: by 2002:a81:3cd4:: with SMTP id j203mr3702902ywa.234.1574296487342;
        Wed, 20 Nov 2019 16:34:47 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id t15sm531284ywh.70.2019.11.20.16.34.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 16:34:46 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id a11so779236ybc.9
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 16:34:45 -0800 (PST)
X-Received: by 2002:a25:dd04:: with SMTP id u4mr4257316ybg.419.1574296485124;
 Wed, 20 Nov 2019 16:34:45 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYsmZOf9zgo5dy2_HfPPK-0tBYfCXpZy2DneFOeiJfN=_g@mail.gmail.com>
 <CA+FuTSd3t9fju3seZQ0OMTxSkPtysG88stMoqMAV4G1Mj3wsVA@mail.gmail.com> <CA+G9fYu=GXCZTQHU2kX0yoUxPgWkKVF44NJhadTP07uHF9St3g@mail.gmail.com>
In-Reply-To: <CA+G9fYu=GXCZTQHU2kX0yoUxPgWkKVF44NJhadTP07uHF9St3g@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 20 Nov 2019 19:34:08 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdYOnJCsGuj43xwV1jxvYsaoa_LzHQF9qMyhrkLrivxKw@mail.gmail.com>
Message-ID: <CA+FuTSdYOnJCsGuj43xwV1jxvYsaoa_LzHQF9qMyhrkLrivxKw@mail.gmail.com>
Subject: Re: selftest/net: so_txtime.sh fails intermittently - read Resource
 temporarily unavailable
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        jesus.sanchez-palencia@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 1:33 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Fri, 15 Nov 2019 at 21:52, Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Nov 14, 2019 at 3:47 AM Naresh Kamboju
>
> > This appears to have been flaky from the start, particularly on qemu_arm.
>
> This is because of emulating 2 CPU.
> I am gonna change this to emulate 4 CPU for qemu_arm.
>
> >
> > Looking at a few runs..
> >
> > failing runs exceeds bounds:
> > https://lkft.validation.linaro.org/scheduler/job/1006586
> ...
> > delay29722: expected20000_(us) #
> > # ./so_txtime exceeds variance (2000 us)
> > "
> > These are easy to suppress, by just increasing cfg_variance_us and
> > optionally also increasing the delivery time scale.
>
> Alright !
> The variance is 2000.
> static int cfg_variance_us = 2000
>
> > Naresh, when you mention "multiple boards" are there specific
> > microarchitectural details of the hosts that I should take into
> > account aside from the qemu-arm virtualized environment itself?
>
> The easy to reproduce way is running 32-bit kernel and rootfs on
> x86_64 machine.

Thanks. As soon as I disabled kvm acceleration, it proved also easy to
reproduce on an x86_64 guest inside an x86_64 host.

> # ./so_txtime read Resource temporarily unavailable
> read: Resource_temporarily #

This occurs due to sch_etf dropping the packet on dequeue in
etf_dequeue_timesortedlist because of dequeue time is after the
scheduled delivery time.

There is some inevitable delay and jitter in scheduling the dequeue
timer. The q->delta argument to ETF enables scheduling ahead of the
deadline. Unfortunately, in this virtualized environment even the
current setting in so_txtime.sh of 200 us is proves too short. It
already seemed high to me at the time.

Doubling to 400 usec and also doubling cfg_variance_us to 4000 greatly
reduces -if not fully solves- the failure rate for me.

This type of drop is also reported through the socket error queue. To
avoid ending up with wholly meaningless time bounds, we can retry on
these known failures as long as failure rate is already low.
