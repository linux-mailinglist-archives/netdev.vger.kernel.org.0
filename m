Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0450B166FB5
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 07:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgBUGj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 01:39:29 -0500
Received: from dpmailmta03-35.doteasy.com ([65.61.219.55]:34012 "EHLO
        dpmailmta03.doteasy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbgBUGj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 01:39:29 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=192.168.101.84;
Received: from dpmailrp04.doteasy.com (unverified [192.168.101.84]) 
        by dpmailmta03.doteasy.com (DEO) with ESMTP id 54806286-1393314 
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 22:39:28 -0800
Received: from dpmail22.doteasy.com (dpmail22.doteasy.com [192.168.101.22])
        by dpmailrp04.doteasy.com (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id 01L6dR65013403
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 22:39:27 -0800
X-SmarterMail-Authenticated-As: trev@larock.ca
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49]) by dpmail22.doteasy.com with SMTP;
   Thu, 20 Feb 2020 22:39:12 -0800
Received: by mail-lf1-f49.google.com with SMTP id n25so676131lfl.0
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 22:39:03 -0800 (PST)
X-Gm-Message-State: APjAAAWFa2TnVqwFjbjl5/EO8RzPTW2IgI2tUbZ53F7Ln4UfKirb2zF/
        10OU/U81awi64K3axB9+ArUM7lXou5RtZV88M6k=
X-Google-Smtp-Source: APXvYqyTR4FgeoPS6cyWu4IcPmJkXLe5Nvq2HQmrB5Z3xtXtSAxa2DdYvX5iK/vvPXkNE8sy2jtRptXClStGc/qCs3c=
X-Received: by 2002:a2e:9b03:: with SMTP id u3mr20949715lji.87.1582260782183;
 Thu, 20 Feb 2020 20:53:02 -0800 (PST)
MIME-Version: 1.0
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com> <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
 <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com> <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
 <9777beb0-0c9c-ef8b-22f0-81373b635e50@candelatech.com> <fe7ec5d0-73ed-aa8b-3246-39894252fec7@gmail.com>
 <CAHgT=KePvNSg9uU7SdG-9LwmwZZJkH7_FSXW+Yd5Y8G-Bd3gtA@mail.gmail.com> <523c649c-4857-0d17-104e-fb4dc4876cc1@gmail.com>
In-Reply-To: <523c649c-4857-0d17-104e-fb4dc4876cc1@gmail.com>
From:   Trev Larock <trev@larock.ca>
Date:   Thu, 20 Feb 2020 23:52:51 -0500
X-Gmail-Original-Message-ID: <CAHgT=KcMoUysPzGL2NkWXbbdUTKZ2EViHyOjsZkTtowVwpM_BA@mail.gmail.com>
Message-ID: <CAHgT=KcMoUysPzGL2NkWXbbdUTKZ2EViHyOjsZkTtowVwpM_BA@mail.gmail.com>
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     David Ahern <dsahern@gmail.com>
Cc:     Trev Larock <trev@larock.ca>, Ben Greear <greearb@candelatech.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Exim-Id: CAHgT=KcMoUysPzGL2NkWXbbdUTKZ2EViHyOjsZkTtowVwpM_BA
X-Bayes-Prob: 0.0001 (Score 0, tokens from: base:default, @@RPTN)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: No geolocation information available for 192.168.101.22
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 0125iDrO3 - fb3b0962699f - 20200220
X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.168.101.84
X-To-Not-Matched: true
X-Originating-IP: 192.168.101.84
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 2, 2020 at 11:04 PM David Ahern <dsahern@gmail.com> wrote:
> I understand the problem you are facing. It is limited to xfrm +        qdisc
> on VRF device. I have a proposal for how to fix it:
>
>     https://github.com/dsahern/linux vrf-qdisc-xfrm

Thanks I tried the fixes on fedora31/ kernel 5.3.8, it did resolve
the qdisc looping packet issue.

> Right now I am stuck on debugging related xfrm cases - like xfrm
> devices, vrf device in the selector, and vti device. I feel like I need
> to get all of them working before sending patches, I just lack enough time.
>

Yes the vrf device in selector issue is still a puzzle.
Without the dev in selector the policy is triggered by the ip4_datagram_connect
call to xfrm_lookup, and there seems no xfrm_lookup call from vrf.c.

With a policy having vrf dev vrf0 in selector, just plaintext packets go out.
For that to trigger properly, should vrf.c be calling xfrm_lookup with the
vrf0 oif, or should that happen elsewhere?

