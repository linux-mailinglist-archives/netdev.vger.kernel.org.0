Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD99F90CD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfKLNiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:38:24 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:40381 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfKLNiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:38:23 -0500
Received: by mail-ed1-f68.google.com with SMTP id p59so14934461edp.7
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 05:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oTkGs3E4cyhBFvtBbvOOnReb2xYX7GZo01zY+pBZjtw=;
        b=Is6VRR7y4w6sNH77Kr94q7PMyqUXVY0rcLbLydlfNSdQAHfrhBi/vUGIFL0AfYB19P
         h2sjC6Jfk7Rucic8RDSLeKuw3KSWuEZQGQMT2RBr2q5GaNZcmZeN2P3FULnKAM0ukI8n
         ch3GGq/0iB7udYc8Sj9Vnaa1Aqfn7HYe3BYgZsvh4k86q5Nqc/SQtQ2OY0dq72lzI7K2
         Ryo+tYlwbt1GK2S06bJHaR5QXhLCPEIBksP8g/15OD9kIS08LSKYraCuN7TVU39PQNzU
         fN92GvF0hxjAZ0VlYzSfx7vFLCk4Q6QfObAmH7eZj7AUTzfC44G64YpywxcoOmUOnf1v
         W8DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oTkGs3E4cyhBFvtBbvOOnReb2xYX7GZo01zY+pBZjtw=;
        b=tQBsCr/PwY1P+6IVk+hh7V3iq8sPXjCYXq/6dXZTgaBUqQVFA9evUpkiOBaAqbupWF
         f2mOUlJDmPbwGEHzfCt2AUNYZj5OmjUiLnTDWGdrqjvEk+BNlYrbQvIb1meBM4OGd4CT
         Vvhr3Dvm2ohyafofr+gHB+hIv4e1uv2JqSlKpiVlKNVlgoOF//NuLZJHu0sqjoI2xWFk
         MTSgGFseFYlHcElxA4BG3Ih09Uj2zCxeBFJze0fS3oHXBX9H5Fa0wdG/RrBnXsJ+XMxS
         pUfoPxc8PW0gPmMRXAJQqjJeUm7SGcAsPMtgH3RMR0yyuV3DSJnE2yhcacdLCEEsk5o4
         9Rxg==
X-Gm-Message-State: APjAAAXl6mnGqyi2vZFysNwshwgKI/MS1633W8DdVDZy08xidqKSe4nu
        H5hIj8JP2A8EYa0Pu1nvog0kmAIuyghSYszm0Zo=
X-Google-Smtp-Source: APXvYqxkNJ7yC4frWzLyg67N+fivvJfZ1XCTHhn2UqC6sfLXgCgb1jnURI7vHE/kK9Wxl5zBkGiwb6/aK4xGHkIy1A4=
X-Received: by 2002:a17:906:a94e:: with SMTP id hh14mr28668670ejb.164.1573565901784;
 Tue, 12 Nov 2019 05:38:21 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-4-olteanv@gmail.com>
 <20191112133544.GE5090@lunn.ch>
In-Reply-To: <20191112133544.GE5090@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 15:38:10 +0200
Message-ID: <CA+h21hqT=rGdTTEEv06X_QHmwY_MvzA+eFXzdCfdU+=+4sGOZw@mail.gmail.com>
Subject: Re: [PATCH net-next 03/12] net: mscc: ocelot: move invariant configs
 out of adjust_link
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 15:35, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Nov 12, 2019 at 02:44:11PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > It doesn't make sense to rewrite all these registers every time the PHY
> > library notifies us about a link state change.
> >
> > In a future patch we will customize the MTU for the CPU port, and since
> > the MTU was previously configured from adjust_link, if we don't make
> > this change, its value would have got overridden.
>
> This is also a good change in preparation of PHYLINK.  When you do
> that conversion, ocelot_adjust_link() is likely to become
> ocelot_mac_config(). It should only change hardware state when there
> actually is a change in link state. This is something drivers often
> get wrong.
>

Yes. We'll need PHYLINK because the CPU port is 2.5G fixed-link, which
is something PHYLIB can't describe. One at a time, though.

> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew
>
>

[snip]
