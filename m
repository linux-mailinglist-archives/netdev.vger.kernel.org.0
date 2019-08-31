Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C94EA457D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 19:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbfHaRDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 13:03:49 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46967 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbfHaRDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 13:03:49 -0400
Received: by mail-ed1-f68.google.com with SMTP id z51so11535995edz.13
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 10:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ynzbLDIYduGWlJTerT5lIgUW2PqopidGtOcZKRCWn4Y=;
        b=qYkqLMLw0eJ+LSFq8CL7sZzhHWh4HawL6i8N+T/p7+ihb13RcPz5a5CalNd+Bt6sCS
         9Z4zxiRTKMMCx4hWoyLmtnzyI7sLyHEcXXSA/MZsVRX5xPwx9XEyAb7vxBlhOISx+OxI
         qfAS7CR/3c2s+k65KTSpHCOAp7a1JRs4KFUe+vQE8GyLjtUFg8tAQvVriwUQLkTMgVBh
         Rvrgz7qmvY4uxOJ5f5L6mDwNgpRmQfqsBTEsZDGBcDUrlmGnYlUMJoi4D8ZEAD9JABoU
         V8YTJTiQ8fxWeBzynwXOMjvMSLDg2tjBn6zf8lQLte50hRE4Ka8YTn5V/rw4cHKZspKy
         O8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ynzbLDIYduGWlJTerT5lIgUW2PqopidGtOcZKRCWn4Y=;
        b=IKqOQZtg6M2dZl44fQvDG2sSDmT3EbOyqnIvt1ydGiiKkBHXV2sCTe1J1dRz2laFkZ
         IJnKHfdFdJO+oKq8EiT4fcbWzaaNAN5GgOMMjipnveHPIYG/ThDDDQ55cHufZ6pvxLyc
         7rDU0ONYi4XGyvRCLXzZ57IscDuKtI4F5FN7mS4x6kZ++Xsjyn8YAy6LeqPSCx2/2eN4
         hAfaEirEaiFGtjdLqUk8o0/N2ZRcmVuv5JBMxrR3p40bhnB08MrzPyQ0ZcjNEw5LuBIR
         gWKJQMwlbrSq9iXeg45g+as+MrG/FiaSUD5r9F01QmqbAwc7f05604GMTIwmlalEhffP
         L1eA==
X-Gm-Message-State: APjAAAXUljLj7/fxOe3VN9blGtbyyZ3pqoD4DFYB1i1OA4cnmdIneQdQ
        MADTM5ad5vp66UXa4/AfXgRGPPz6/whV0so93Ys=
X-Google-Smtp-Source: APXvYqxR5AXTB/9uwUgi5DwGAFIgjdBNON/RVRb/y2It/XAoi3/uF2QeiBPc/q2l/M7bsah3r6OOWXZwg45qBwZ1mNU=
X-Received: by 2002:aa7:d811:: with SMTP id v17mr21816182edq.165.1567271027572;
 Sat, 31 Aug 2019 10:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190830004635.24863-1-olteanv@gmail.com> <20190829182132.43001706@cakuba.netronome.com>
 <CA+h21hr==OStFfgaswzU7HtFg_bHZPoZD5JTQD+-e4jWwZYWHQ@mail.gmail.com> <20190830152839.0fe34d25@cakuba.netronome.com>
In-Reply-To: <20190830152839.0fe34d25@cakuba.netronome.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 31 Aug 2019 20:03:36 +0300
Message-ID: <CA+h21hohAqxytjrkMb7Xwa2goa2sBbiMLcwBWae5ERxu5YDuaA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 net-next 00/15] tc-taprio offload for SJA1105 DSA
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        vedang.patel@intel.com, Richard Cochran <richardcochran@gmail.com>,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        xiyou.wangcong@gmail.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Aug 2019 at 01:29, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 30 Aug 2019 13:11:11 +0300, Vladimir Oltean wrote:
> > On Fri, 30 Aug 2019 at 04:21, Jakub Kicinski wrote:
> > > On Fri, 30 Aug 2019 03:46:20 +0300, Vladimir Oltean wrote:
> > > > - Configuring the switch over SPI cannot apparently be done from this
> > > >   ndo_setup_tc callback because it runs in atomic context. I also have
> > > >   some downstream patches to offload tc clsact matchall with mirred
> > > >   action, but in that case it looks like the atomic context restriction
> > > >   does not apply.
> > >
> > > This sounds really surprising ndo_setup_tc should always be allowed to
> > > sleep. Can the taprio limitation be lifted somehow?
> >
> > I need to get more familiar with the taprio internal data structures.
> > I think you're suggesting to get those updated to a consistent state
> > while under spin_lock_bh(qdisc_lock(sch)), then call ndo_setup_tc from
> > outside that critical section?
>
> I'm not 100% sure how taprio handles locking TBH, it just seems naive
> that HW callback will not need to sleep, so the kernel should make sure
> that callback can sleep. Otherwise we'll end up with 3/4 of drivers
> implementing some async work routine...
>
> Sorry, I know that's quite general and not that helpful.
>
> > Also, I just noticed that I introduced a bug in taprio_disable_offload
> > with my reference counting addition. The qdisc can't just pass stack
> > memory to the driver, now that it's allowing it to keep it. So
> > definitely the patch needs more refactoring.
>
> Ah, a slight deja vu, I think someone else has done it in the past :)

Ok, I think I managed to move the ndo_setup_tc callback outside of
atomic context and nothing broke so far... Any other comments or
should I go ahead and send a first proper patchset?

Thanks,
-Vladimir
