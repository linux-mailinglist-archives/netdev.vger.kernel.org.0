Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0916319CF53
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 06:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbgDCEa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 00:30:27 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46466 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgDCEa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 00:30:27 -0400
Received: by mail-ot1-f68.google.com with SMTP id 111so5947008oth.13
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 21:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ol4C8g0+klaf0A6nMtyYR5Z8r2Ln5uSPPaqxsHbTubA=;
        b=UPDh2QNLDkvW9+Pj0o2auxtPk5bGvNH4ZUMEDZ1Sp4YUIloPUEN1dUS0DBSjLM3kwG
         bSbBH6OEuFJlYDQMULmn2jraRDRRcRX3ivfSg+LaxWtai5PuJnhyHCyYwLL+eV5DwytS
         edFRuXnEqR5MEv9K9UvnkeLi1l4glPzbayAE9xlZ7PbR52J5Op4nz1munevNgJw7IGER
         0SieiYcMmFwn7yRwFJztkNP1rN6BYefdFrLkW+mo9FBAQdscvqdCvHAcUN9V42f5IVRj
         fVs/1/bvkMen9u040FlPSFCPUbBLFF13714HwC8bs1dFTfGxWxhAMU3eFmpGh5d/q6Lg
         2yrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ol4C8g0+klaf0A6nMtyYR5Z8r2Ln5uSPPaqxsHbTubA=;
        b=k3jMrVU9bY3TAAleRgHP0NdfDLi6/krG3azTsGEWL6lRu3bqIYP4/3+v0S8nns1lSn
         +KKxtr/4RVdLfiUUpD2SujeOSxASXiTTMoH5X27F1z0o4pShzixITQP/Jvtttu1nRxoD
         +QjD9xTGMrolo8w+uxpaztafQhekUtStLl6h99bLF5fe/0VxQZqCK/r1LqD27rw6/10z
         gL1X3mE34w9oHoDMQwb654hVYaRNjtNDz5BYbg8E3IE8BZeIXsSzM09iKP9pL9AARcp0
         WuQ3qWqjsxmsJVDygvrvGOrJ1u1dzaKR1O0OUG7aEYuhVQRp8/bC5bKYjurRhRA6VM6p
         hTWw==
X-Gm-Message-State: AGi0Pubn689+foWsp3kNfvKfNFx5lBrnVqWgqWkCCfZ2oY5shtcdeYdb
        OANwQuBlIAFWmQynodtT3Q7KWHqhJJSU8geToco=
X-Google-Smtp-Source: APiQypIjAuWRS7pcR6IS1hZXaNmaKSCyNMPn6vZop8xk0NR48hrz0qxiW0Ktdlxbzc6bevRbVRbE83+6fIWZWmNGaMI=
X-Received: by 2002:a05:6830:1e96:: with SMTP id n22mr4929443otr.189.1585888226400;
 Thu, 02 Apr 2020 21:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200402152336.538433-1-leon@kernel.org> <20200402.180218.940555077368617365.davem@davemloft.net>
In-Reply-To: <20200402.180218.940555077368617365.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 2 Apr 2020 21:30:15 -0700
Message-ID: <CAM_iQpWvkTTRwV5-tj1Hj_a8hG2X-udU0BG2VXDbukuKFeN=JA@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: Don't print dump stack in event of
 transmission timeout
To:     David Miller <davem@davemloft.net>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, leonro@mellanox.com,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        itayav@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 2, 2020 at 6:02 PM David Miller <davem@davemloft.net> wrote:
>
> From: Leon Romanovsky <leon@kernel.org>
> Date: Thu,  2 Apr 2020 18:23:36 +0300
>
> > In event of transmission timeout, the drivers are given an opportunity
> > to recover and continue to work after some in-house cleanups.
> >
> > Such event can be caused by HW bugs, wrong congestion configurations
> > and many more other scenarios. In such case, users are interested to
> > get a simple  "NETDEV WATCHDOG ... " print, which points to the relevant
> > netdevice in trouble.
> >
> > The dump stack printed later was added in the commit b4192bbd85d2
> > ("net: Add a WARN_ON_ONCE() to the transmit timeout function") to give
> > extra information, like list of the modules and which driver is involved.
> >
> > While the latter is already printed in "NETDEV WATCHDOG ... ", the list
> > of modules rarely needed and can be collected later.
> >
> > So let's remove the WARN_ONCE() and make dmesg look more user-friendly in
> > large cluster setups.
>
> Software bugs play into these situations and on at least two or three
> occasions I know that the backtrace hinted at the cause of the bug.
>

I don't see how a timer stack trace could help to debug this issue
in any scenario, the messages out of this stack trace are indeed
helpful.

On the other hand, a stack trace does help to get some attention
via ABRT, but at least for us we now use rasdaemon to capture
this, so I am 100% fine to remove this stack trace.

Thanks.
