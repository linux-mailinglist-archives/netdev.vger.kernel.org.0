Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA5130D74
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 07:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgAFGOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 01:14:51 -0500
Received: from dpmailmta01-01.doteasy.com ([65.61.218.1]:49851 "EHLO
        dpmailmta01.doteasy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726338AbgAFGOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 01:14:51 -0500
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jan 2020 01:14:50 EST
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=192.168.101.83;
Received: from dpmailrp03.doteasy.com (unverified [192.168.101.83]) 
        by dpmailmta01.doteasy.com (DEO) with ESMTP id 53108146-1394429 
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 21:58:46 -0800
Received: from dpmail22.doteasy.com (dpmail22.doteasy.com [192.168.101.22])
        by dpmailrp03.doteasy.com (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id 0065wjLO024937
        for <netdev@vger.kernel.org>; Sun, 5 Jan 2020 21:58:46 -0800
X-SmarterMail-Authenticated-As: trev@larock.ca
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174]) by dpmail22.doteasy.com with SMTP;
   Sun, 5 Jan 2020 21:58:34 -0800
Received: by mail-lj1-f174.google.com with SMTP id m26so47278239ljc.13
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 21:58:26 -0800 (PST)
X-Gm-Message-State: APjAAAXqVllHxn4MIWEkgOWWdofewumsjObkPcqbTXY+6d8Gj5hg+Y4J
        FnXJEyVNaLkoJMB10haVvHMFrvLktfqdtw9bZd4=
X-Google-Smtp-Source: APXvYqwOWIElIX1LSMV3WF1bQXz8i+x+qNs1RqkojF+3R2NU2KfImGbAeNuCoESN8QLBhJVNhN8vh9XwattbdFIh89s=
X-Received: by 2002:a2e:9e55:: with SMTP id g21mr37865955ljk.245.1578290305037;
 Sun, 05 Jan 2020 21:58:25 -0800 (PST)
MIME-Version: 1.0
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com> <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
 <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com>
In-Reply-To: <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com>
From:   Trev Larock <trev@larock.ca>
Date:   Mon, 6 Jan 2020 00:58:14 -0500
X-Gmail-Original-Message-ID: <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
Message-ID: <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     David Ahern <dsahern@gmail.com>
Cc:     Trev Larock <trev@larock.ca>, netdev@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Exim-Id: CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA
X-Bayes-Prob: 0.0001 (Score 0, tokens from: base:default, @@RPTN)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: No geolocation information available for 192.168.101.22
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 011KRWJV4 - 13cb1e100c36 - 20200105
X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.168.101.83
X-To-Not-Matched: true
X-Originating-IP: 192.168.101.83
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 5, 2020 at 11:29 PM David Ahern <dsahern@gmail.com> wrote:
> I was able to adapt your commands with the above and reproduced the
> problem. I need to think about the proper solution.
>
Ok thanks for investigating.

> Also, I looked at my commands from a few years ago (IPsec with VRF) and
> noticed you are not adding a device context to the xfrm policy and
> state. e.g.,
>
Yes was part of my original query, that makes sense in order to be able to have
multiple vrf each with their own xfrm policies.
I will investigate further on it.  The oif passed to xfrm_lookup seemed to be
enp0s8 oif rather than vrf0 oif, so I was observing just cleartext
pings go out / policy wouldn't match.
Perhaps I'm missing something to get vrf0 oif passed for the ping packet.

Thanks,
Trev

