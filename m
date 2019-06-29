Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752C35ABA7
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 16:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfF2OJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 10:09:22 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:35748 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfF2OJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 10:09:21 -0400
Received: by mail-lj1-f176.google.com with SMTP id x25so8736086ljh.2
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 07:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=2vgkR24VCzDd24PACdl2RAw9h3W04PNxs0MORMvbdWw=;
        b=BYBLjIyIVgszubuLYFlFbjUQQ5wv11XGOMxNdT3zSMFYUJyqIZgB6QMWdPc1QTIe1b
         F2IWGqXf0fxPMJm1Mctgri1PeVQ3Bm/dQ+kAI/zP7I+OJxDgm8Ec0WvZkJ72JLdRcIKE
         EeIOAy+IFJ6KpaUg0du+xNYlR8vgQ96INvdEPAIFthQxf3owh6f9rOBV29x4Lpk6rB8v
         GOVgYp2q8X54np7eigwY4N1G3GQlVLWkgxt+GLGJff89fwDpMKpFnfQeyvEVRcrfVvif
         glCO6rdEwgIr5G4B0ew09iqhypuCn0q1psz1n+jOEtj67lgTDABdUY9oURTlH9qG1AXM
         dKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=2vgkR24VCzDd24PACdl2RAw9h3W04PNxs0MORMvbdWw=;
        b=W/8vXUUWfTtYlCgIi4GB7yCt/jZkJcTDDRMxLgI3DUYXzAFBG7k6RZV9X0xDWG+PBM
         jKW2t+ohPppklyaeocd9c8a6QxBvMN2+zJdVmJtMoGjoSU93JEZ7nbLl9iGArcw1mxZb
         skJNedAtk+mncdTEnDfbU2clkmNaDPauIqzFqcRcD+bDdU+/8lmRRVX1c4dWPIdLH9Xt
         Um6INCmAg/gyHaTf+wjAKnr44OdiQxZrIxNmqC9tHRcfOuAVlJZB3RCCdLa8DTeVM+IJ
         sox5bLyeHci/HLW1NUlRVEQvgA/l/XnfhZhO7ILI65B93V8zmJvU0YwscbpZKjczZClF
         4Lhw==
X-Gm-Message-State: APjAAAWlL9bzvakJdtvd1XM1KfjYJp9QWamLGLuczgWWVIhnoomjzJFY
        UPgg3hCFx/7kKSzQdroq1xFlCV83WdQ56RuPnb5LHNno
X-Google-Smtp-Source: APXvYqz9aTiWi76cPU/MB4L9AhISP9Av6oMwjf4IU29we+J8THpM87Gcaafbesr+oW6nsS/nRR14LU56/FZv4b4jOJs=
X-Received: by 2002:a2e:8650:: with SMTP id i16mr9137473ljj.178.1561817359854;
 Sat, 29 Jun 2019 07:09:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAAg6XZOVbPexui=MZC6QaL1-4e8SL6Z_z8S0+B6YAzSpgf8t8Q@mail.gmail.com>
In-Reply-To: <CAAg6XZOVbPexui=MZC6QaL1-4e8SL6Z_z8S0+B6YAzSpgf8t8Q@mail.gmail.com>
From:   Aks Kak <akskak2012@gmail.com>
Date:   Sat, 29 Jun 2019 19:39:06 +0530
Message-ID: <CAAg6XZMCLaZhW9XZJTYZ5JMJjiDOD1w4PuFeOVUtH7SGsaetog@mail.gmail.com>
Subject: Re: Proxy arp for non-overlapping subnets on an interface without
 assigning IP aliases
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ignore previous one or consider /27 as /25 at two places in previous mail:
***************************************************************************************
I have a linux box with 2 interfaces with following IPs
eno1 : 10.1.1.0/24
eno2 : 192.168.2.0/25

I want to use network 10.3.3.0/25 as virtual IPs for 192.168.2.0/25
i.e. I will be doing DNAT using NETMAP target of IPTABLES.

DNAT and NETMAP, etc. is not the issue.

For my requirement to work, main thing is who (or how) will give arp
replies for 10.3.3.0/25 !!!
I have 2 ways of achieving this:
1. Create all 126 IPs 10.3.3.1 - 10.3.3.126 as alias IPs on eno1. I
want to avoid it.
2. Use proxy arp for entire subnet 10.3.3.0/25 on eno1 but this
require having atleast one IP from this subnet to be created as IP
alias on eno1, say 10.3.3.1/25. However, my concern is that this
10.3.3.1, as it has been assigned to eno1,may be used by mistake to
listen for any service, etc. or ping, etc. which otherwise I would
have to control using iptables rule set. I totally want to avoid it.

So, my query is how to do proxy arp for 10.3.3.0/25 on eno1 without
assigning 10.3.3.1/25 to eno1???

On Sat, Jun 29, 2019 at 7:34 PM Aks Kak <akskak2012@gmail.com> wrote:
>
> I have a linux box with 2 interfaces with following IPs
> eno1 : 10.1.1.0/24
> eno2 : 192.168.2.0/27
>
> I want to use network 10.3.3.0/25 as virtual IPs for 192.168.2.0/25
> i.e. I will be doing DNAT using NETMAP target of IPTABLES.
>
> DNAT and NETMAP, etc. is not the issue.
>
> For my requirement to work, main thing is who (or how) will give arp
> replies for 10.3.3.0/27 !!!
> I have 2 ways of achieving this:
> 1. Create all 126 IPs 10.3.3.1 - 10.3.3.126 as alias IPs on eno1. I
> want to avoid it.
> 2. Use proxy arp for entire subnet 10.3.3.0/25 on eno1 but this
> require having atleast one IP from this subnet to be created as IP
> alias on eno1, say 10.3.3.1/25. However, my concern is that this
> 10.3.3.1, as it has been assigned to eno1,may be used by mistake to
> listen for any service, etc. or ping, etc. which otherwise I would
> have to control using iptables rule set. I totally want to avoid it.
>
> So, my query is how to do proxy arp for 10.3.3.0/25 on eno1 without
> assigning 10.3.3.1/25 to eno1???
