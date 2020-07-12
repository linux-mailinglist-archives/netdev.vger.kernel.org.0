Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF1E21C955
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 15:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgGLNBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 09:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbgGLNBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 09:01:01 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18CEC061794
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 06:01:00 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id j186so5262131vsd.10
        for <netdev@vger.kernel.org>; Sun, 12 Jul 2020 06:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EoqZ6levth+U1GgQAklrGA1ktkRlSfeyVPRWCIp1zvc=;
        b=Y0aliTUQQpHYA99NAoe3sxkz+TalU/xx1mN1W2oajAJlE+zWvq7Lkc77F6VRCXyVrI
         Zea8qhzOoD5E4oaxtrrnS+PVXMcAUEnylNB2lUOjhXvJnZQAXEn6iV15vTJcJo+Er1U3
         wledBNeQstZGRtbljphVEb3Cl7s4bhpHEJjvFNW08H823YZmRjHfo8tuCzuA9s5dReEh
         QSCG+qXWpZiTLkORSC5uboBExno11FL18Gp9j5kAxmqwTC9r6bH1FHjCSVU5xX1hLdR/
         I4dn8u2Z1jH7miCAZ2BxZfeSAZVekdmYvo6qOeMYI9tAsSSOcoH4KGcm7eVxaCXuB016
         BoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EoqZ6levth+U1GgQAklrGA1ktkRlSfeyVPRWCIp1zvc=;
        b=eXv0v/tAkhXLWAJApG3xEGy+4Dp3DwFxzrovfdYteRJs0VI2HplyC2wTTvmKC9lF7B
         HNibVNQeCltHEeMlkQIGqorpLClkuSd3y2chkXwb9jSYmxP+3dV93Cg9fSVoZr0YrWyx
         Y3LkJ7Yzqc+F8iPkBJ+TXMf1reB7W/F3VFxvuVBrpuAFT2Eq3kOgHHEj69Q6rnkuBUMg
         G6YuykJkiHDwoeeP8Kq7XgSq6JC7yoOgsFlCxPYshY2PLxx9ycJqGwEDOmx8tXI2jjLW
         Ht08yxUQh7/hYEboWTjlr7HRTZ03tWQEFRv1gTrscW8rERcuxKKmDUINvucKT+bOymIa
         j2kQ==
X-Gm-Message-State: AOAM532LxBHBYRlbXUNNtubqjzEt5Ja4jhBiMTUPuu/VVgsglZuGFPwS
        KUMvu2PujlFImaSfEUd7PE9etzehYF0dZpKh7G42Pg==
X-Google-Smtp-Source: ABdhPJw/5WYmT3dWLgiebSg+T3jhnM3wYUECF9vPlrfWxAnBD3y8mkj1aAb0S81e7eVUz9c/cXHc+Ya+kQb/ustWPGM=
X-Received: by 2002:a67:6785:: with SMTP id b127mr58056073vsc.186.1594558859923;
 Sun, 12 Jul 2020 06:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAOAjy5T63wDzDowikwZXPTC5fCnPL1QbH9P1v+MMOfydegV30w@mail.gmail.com>
 <20200711162349.GL1014141@lunn.ch> <20200711192255.GO1551@shell.armlinux.org.uk>
In-Reply-To: <20200711192255.GO1551@shell.armlinux.org.uk>
From:   Martin Rowe <martin.p.rowe@gmail.com>
Date:   Sun, 12 Jul 2020 13:00:48 +0000
Message-ID: <CAOAjy5TBOhovCRDF7NC-DWemA2k5as93tqq3gOT1chO4O0jpiA@mail.gmail.com>
Subject: Re: bug: net: dsa: mv88e6xxx: unable to tx or rx with Clearfog GT 8K
 (with git bisect)
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jul 2020 at 19:23, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
> On Sat, Jul 11, 2020 at 06:23:49PM +0200, Andrew Lunn wrote:
> > So i'm guessing it is the connection between the CPU and the switch.
> > Could you confirm this? Create a bridge, add two ports of the switch
> > to the bridge, and then see if packets can pass between switch ports.
> >
> > If it is the connection between the CPU and the switch, i would then
> > be thinking about the comphy and the firmware. We have seen issues
> > where the firmware is too old. That is not something i've debugged
> > myself, so i don't know where the version information is, or what
> > version is required.
>
> However, in the report, Martin said that reverting the problem commit
> from April 14th on a kernel from July 6th caused everything to work
> again.  That is quite conclusive that 34b5e6a33c1a is the cause of
> the breakage.

I tried it anyway and couldn't get any traffic to flow between the
ports, but I could have configured it wrongly. I gave each port a
static IP, bridged them (with and without br0 having an IP assigned),
and tried pinging from one port to the other. I tried with the
assigned IPs in the same and different subnets, and made sure the
routes were updated between tests. Tx only, no responses, exactly like
pinging a remote host.

I'm now less confident about my git bisect, though, because it appears
my criteria for verifying if a commit was "good" was not sufficient. I
was just checking to see if the port could get assigned a DHCP address
and ping something else, but it appears that (at least on 5.8-rc4 with
the one revert) the interface "dies" after working for about 30-60
seconds. Basically the symptoms I described originally, just preceded
by 30-60 seconds of it working perfectly. I will re-run the bisect to
figure out what makes it go from "working perfectly" to "working
perfectly for less than a minute", which will take a few days.
