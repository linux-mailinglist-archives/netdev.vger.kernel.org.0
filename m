Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC2796BF8
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbfHTWJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:09:52 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:33439 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHTWJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 18:09:51 -0400
Received: by mail-ed1-f68.google.com with SMTP id s15so531598edx.0
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 15:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ZlKj4Hq74ohN10u13BZ42BHB1+jlv3FZ6NG4cXJ35Q=;
        b=qfW9p6zvNGf2KbHtPPemHsn1qfu2DqaVROtuB8FO6AhcdujEGrgWf6sVhHVprU8dnF
         4nZ26ryEW93OC2KYPWLyQsK+iGpqBlNThOG0NHx+cPEc5hy/Hcp8CPnhWMA++RQ7LEKd
         JGYgW6kG0cZv1pawkYr+BIxpmqnMAz/YuAYzRzFve3Q3OsMRTzSx7yUS63uZNSkNoW18
         mYpuXI/iWQgdyC27DJo+VEw22NEVaLpvMuK4qyscq7wPTaAdB5sx6SamgsaBlH3mI0JQ
         g3JihUVT1k+pJN8sTyCE77cp4/Aw2dRaVWZ7+puQLZirMOPy/LY1YuZBgpBZfhM1URcW
         in2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ZlKj4Hq74ohN10u13BZ42BHB1+jlv3FZ6NG4cXJ35Q=;
        b=SHI3KgGz84h22V00fcTsEzKdIp7h0x4r1GuoyLMlxmsG1fcPWAZNuKNbhOBaS+BqBa
         g3hZOukHYzTplZ5uIyFhGqYrOLGausKE9UBMhPWRrbhW9M2w8hwTFI5Rg487Vi9L29bf
         +l/WJEhax0IjpIRSbo8To7czWejIER51bQDz12/50xP5CdJqYEQ7ugggqRtRdPp9jkbL
         u7vMloPGvEe2H/sJapeLORdwUaIgQ5zXpF134RGxElHgmb55HI9Oox6nrt4zc3EG3Ale
         EItf77tVlYDfUr2UtrcSX0sajVObOnjpAY7e5QxQXRl0DrcDmW/q0T5c1/IqgPa5rcmQ
         Jq+w==
X-Gm-Message-State: APjAAAVVlofYOVYS197zLTSA9onMeRM/XfpLdiZ0afxhHmLR36Rj8LW1
        7ltn7KLTPrlD5+nmO9bfKTi3bEjp/amqf1inBKk=
X-Google-Smtp-Source: APXvYqxQHpq7D4FSY6jV3HbYRyxmFv5xfUqtQoqkPMUwkA+GubVQv156f8OcAPqrizMsz9i1hM/n+ZJZk1EEpXDSSNs=
X-Received: by 2002:a17:906:d298:: with SMTP id ay24mr4095359ejb.230.1566338990197;
 Tue, 20 Aug 2019 15:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-4-olteanv@gmail.com>
 <20190820015138.GB975@t480s.localdomain> <CA+h21hpdDuoR5nj98EC+-W4HoBs35e_rURS1LD1jJWF5pkty9w@mail.gmail.com>
 <20190820135213.GB11752@t480s.localdomain> <c359e0ca-c770-19da-7a3a-a3173d36a12d@gmail.com>
 <CA+h21hqdXP1DnCxwuZOCs4H6MtwzjCnjkBf3ibt+JmnZMEFe=g@mail.gmail.com>
 <20190820165813.GB8523@t480s.localdomain> <CA+h21hrgUxKXmYuzdCPd-GqVyzNnjPAmf-Q29=7=gFJyAfY_gw@mail.gmail.com>
 <20190820173602.GB10980@t480s.localdomain>
In-Reply-To: <20190820173602.GB10980@t480s.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 21 Aug 2019 01:09:39 +0300
Message-ID: <CA+h21hodsDTwPHY1pxQA-ucu6FU7rkOQa7Y4HJGZC0fRd8zmDA@mail.gmail.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: Delete the VID from the upstream
 port as well
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 at 00:36, Vivien Didelot <vivien.didelot@gmail.com> wrote:
>
> On Wed, 21 Aug 2019 00:02:22 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, 20 Aug 2019 at 23:58, Vivien Didelot <vivien.didelot@gmail.com> wrote:
> > >
> > > On Tue, 20 Aug 2019 23:40:34 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > > I don't need this patch. I'm not sure what my thought process was at
> > > > the time I added it to the patchset.
> > > > I'm still interested in getting rid of the vlan bitmap through other
> > > > means (picking up your old changeset). Could you take a look at my
> > > > questions in that thread? I'm not sure I understand what the user
> > > > interaction is supposed to look like for configuring CPU/DSA ports.
> > >
> > > What do you mean by getting rid of the vlan bitmap? What do you need exactly?
> >
> > It would be nice to configure the VLAN attributes of the CPU port in
> > another way than the implicit way it is done currently. I don't have a
> > specific use case right now.
>
> So you mean you need a lower level API to configure VLANs on a per-port basis,
> without any logic, like including CPU and DSA links, etc.
>
> The bitmap operations were introduced to simplify the switch drivers in the
> future, since most of them could implement the VLAN operations (add, del)
> in simple functions taking all local members at once.
>
> But the Linux interface being exclusively based on a per port (slave) logic,
> it is hard to implement right now.
>
> The thing is that CPU ports, as well as DSA links in a multi-chip setup,
> need to be programmed transparently when a given user port is configured,
> hence the notification sent by a port to all switches of the fabric.
>
> So I'm not against removing the bitmap logic, actually I'm looking into it
> as well as moving more bridge checking logic into the slave code itself,
> because I'm not a fan of your "Allow proper internal use of VLANs" patch.
>
> But you'll need to provide more than "it would be nice" to push in that
> direction, instead of making changes everywhere to make your switch work.
>
>
> Thanks,
>
>         Vivien

I mean I made an argument already for the hack in 4/6 ("Don't program
the VLAN as pvid on the upstream port"). If the hack gets accepted
like that, I have no further need of any change in the implicit VLAN
configuration. But it's still a hack, so in that sense it would be
nicer to not need it and have a better amount of control.
