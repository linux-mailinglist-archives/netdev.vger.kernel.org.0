Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84421AFB5F
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 16:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDSOVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 10:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSOVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 10:21:01 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B66C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 07:21:01 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id s3so5695257eji.6
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 07:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sheYKXBGB4wnRB1mB40wii+pxy9iBUxAkM1H7XFRuJ4=;
        b=Jj/Lt54/CqEDcnEo0Pv97RLnwSwXNh9qpBP5vxJG9W7ZZf1q5TOxlj7QM/31sasm1e
         OcNvaw8X929j5pLlH9wjMJj7LMVgFtDk9ERUncXvvtk6tzqG8iH/juN2IZlcJ28vTZe+
         fKDsvrabslkmkxjOv+XSMTF58HWHIlvGZYZxBFITA31b9mb3xakH0NDEuI6C6Yfzhsmm
         9Hv0aHD+6MY4mbEeMUyRhL2Ic4Kfip7N1kK1go7QnovX80o+vSxVrwFRbEUVGVNY8LI+
         Pkfnkqu/FRpHPeOBuDwrpJZxsIgNZF8etDGhhc9tp+dXHSddUQTrwJKRDb/BT4aVqR0+
         OeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sheYKXBGB4wnRB1mB40wii+pxy9iBUxAkM1H7XFRuJ4=;
        b=YWG5fnIW8nMYefVn4tOyD2IGNWXGdAPDTURbHjLcYJApw+IeiRNfouy9IHjj7rs196
         QRNrCOYsEU89GF8pNCJZNasCqLxOOkN0lOFlzPozwbT/LwDGCM5PE/EiX3bdAKptEtza
         S3GoebIswy6I1zAGAKZdrIqq2iwpy0+YrGh3zKN6RbdlAT/lObWBHzVXcf9AuNbX8t4E
         JQ5XBy6+p8wmD+6EtAhNmfq0ICJYtKR6xvNZJLVL/2S4tw+6OcIfNCg645khoIhtRlda
         3Vh7i5s7OvKvdaBYjfBn1+9Sos9gSMjpIGE6FTBBX39r3OMJjE5+2LJqkcgoLsZaJdEn
         U3tg==
X-Gm-Message-State: AGi0PuY7yXcXxNKgeb8QDgQ80um4Oi7k4QSIegHRlAb5qcpxx/W4cKTJ
        Q9e/Uc57Twygje/mV52NCFlGwfx1Hydo7PdaUbk=
X-Google-Smtp-Source: APiQypIIlF5lBjjvGTx1yd42s7orNWvs5ct5MVJT8ZtJcnf+labQ+lqVdEUCIpwIDklm2FmMAyEqvP+Fp+iCc5zJm4g=
X-Received: by 2002:a17:906:78c:: with SMTP id l12mr11265193ejc.189.1587306059838;
 Sun, 19 Apr 2020 07:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200417190308.32598-1-olteanv@gmail.com> <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
In-Reply-To: <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 19 Apr 2020 17:20:48 +0300
Message-ID: <CA+h21hrvSjRwDORZosxDt5YA+uMckaypT51f-COr+wtB7EjVAQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, Po Liu <po.liu@nxp.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Apr 2020 at 10:33, Allan W. Nielsen
<allan.nielsen@microchip.com> wrote:
>
> Hi,
>
> Sorry I did not manage to provide feedback before it was merged (I will
> need to consult some of my colleagues Monday before I can provide the
> foll feedback).
>
> There are many good things in this patch, but it is not only good.
>
> The problem is that these TCAMs/VCAPs are insanely complicated and it is
> really hard to make them fit nicely into the existing tc frame-work
> (being hard does not mean that we should not try).
>
> In this patch, you try to automatic figure out who the user want the
> TCAM to be configured. It works for 1 use-case but it breaks others.
>
> Before this patch you could do a:
>      tc filter add dev swp0 ingress protocol ipv4 \
>              flower skip_sw src_ip 10.0.0.1 action drop
>      tc filter add dev swp0 ingress \
>              flower skip_sw src_mac 96:18:82:00:04:01 action drop
>
> But the second rule would not apply to the ICMP over IPv4 over Ethernet
> packet, it would however apply to non-IP packets.
>
> With this patch it not possible. Your use-case is more common, but the
> other one is not unrealistic.
>
> My concern with this, is that I do not think it is possible to automatic
> detect how these TCAMs needs to be configured by only looking at the
> rules installed by the user. Trying to do this automatic, also makes the
> TCAM logic even harder to understand for the user.
>
> I would prefer that we by default uses some conservative default
> settings which are easy to understand, and then expose some expert
> settings in the sysfs, which can be used to achieve different
> behavioral.
>
> Maybe forcing MAC_ETYPE matches is the most conservative and easiest to
> understand default.
>
> But I do seem to recall that there is a way to allow matching on both
> SMAC and SIP (your original motivation). This may be a better default
> (despite that it consumes more TCAM resources). I will follow up and
> check if this is possible.
>
> Vladimir (and anyone else whom interested): would you be interested in
> spending some time discussion the more high-level architectures and
> use-cases on how to best integrate this TCAM architecture into the Linux
> kernel. Not sure on the outlook for the various conferences, but we
> could arrange some online session to discuss this.
>
> /Allan
>

And yes, we would be very interested in attending a call for syncing
up on integrating the TCAM hardware with the flow offload
infrastructure from Linux. Actually at the moment we are trying to add
support for offloaded VLAN retagging with the VCAP IS1 and ES0 blocks.

Thanks,
-Vladimir
