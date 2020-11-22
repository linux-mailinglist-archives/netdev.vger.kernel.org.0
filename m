Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6602BFBDF
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 23:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKVWBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 17:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgKVWBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 17:01:17 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B23C0613CF;
        Sun, 22 Nov 2020 14:01:15 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id 7so20651519ejm.0;
        Sun, 22 Nov 2020 14:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xds3EV1u8LFX/eLCQkAEEEQ5tbAtE69pORfGo1Yk0E4=;
        b=qBdPUPS6EKKPu17iN3L111KhOsLD6ml1IZMXCdRQj+shf+z/RfO2R0b38Z/5vKH1FA
         j+8UNlP8OTMPWrbAdBxpKJwp5of33Sve1g3argPzJSpZCXtXIY8NXdjYNG+0OorYpSNN
         YmVvuV5FpM8COMtY983KT58FG+7pBuBUEb+5i2U99D76qn/rmSu2Qtin8D1SS4pGZTPC
         9wUSx+qJgaQChElucO/4DBxcZoYxQJAmnQHcyqpTO340VZab+wEsZTC8oEjJWQ6E62Cp
         HVSCHDkUdS8RfbqVffiLg5eKc2c3OfvrTa3I4Vnyqv++hgE8UwTJHktdlTd+2MptcbjQ
         fg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xds3EV1u8LFX/eLCQkAEEEQ5tbAtE69pORfGo1Yk0E4=;
        b=iy1c5o0u86rLT8ffoYJtI26ihZOmiefg6moLYjrCgznrxk/IUbf1HB4iu/bx36Db0/
         ZxjPgRwPIHMd1pmHXZvkE4WNQO3/EiWpxeKnPoTkQxqYLh1zNPlF5mpgzgkk01irMA7q
         sE94qzEd6cdMBZcAMXUX2Tb15myzYe6i4yQSXVK5KBel2oTY7+Cwdu0Yxs98qsR4iO+7
         XepWDoQOr51+A05+4X2RLqwJy3KI1jhqpQ77TAkGS6pTgJs2niC3z8DpB6DsFpP0JHwC
         r/jA7qPRJifCOdX91CmxrOSjWeIvpHDGkuOQs77mLvakN2xJU3zv69Qkw8s2oMc98983
         a7HQ==
X-Gm-Message-State: AOAM531y1I1EuULIPIemm+fvZj+tjcGC/7Ikyed8N3ig2XIcf0SaziYL
        q1q1UN/0mweAHMm2fAszMfc=
X-Google-Smtp-Source: ABdhPJw1b318SLMdEfEhxRpbnkq7+lW3TIKweZq98g+ZP8iZqn9j8ey5boOlz2blAsXlFG6uXLX7Cg==
X-Received: by 2002:a17:906:1758:: with SMTP id d24mr3855704eje.287.1606082474566;
        Sun, 22 Nov 2020 14:01:14 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id t11sm3956022ejx.68.2020.11.22.14.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 14:01:13 -0800 (PST)
Date:   Mon, 23 Nov 2020 00:01:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Machata <petrm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/3] mlxsw: spectrum_ptp: use PTP wide message
 type definitions
Message-ID: <20201122220112.6ci624wfqp5hefou@skbuf>
References: <20201122082636.12451-1-ceggers@arri.de>
 <20201122082636.12451-3-ceggers@arri.de>
 <20201122143555.GA515025@shredder.lan>
 <2074851.ybSLjXPktx@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2074851.ybSLjXPktx@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 08:29:22PM +0100, Christian Eggers wrote:
> this was also not by intention. Vladimir found some files I missed in the
> first series. As the whole first series had already been reviewed at that time,
> I wasn't sure whether I am allowed to add further patches to it. Additionally
> I didn't concern that although my local build is successful, I should wait
> until the first series is applied...

When I said that, what I was thinking of (although it might have not
been clear) was that if you send further patches, you send them _after_
the initial series is merged.

Alternatively, it would have been just as valid to resend the entire
series, as a 3+3 patchset with a new revision (v3 -> v4), with review
tags collected from the first three, and the last 3 being completely
new. Jakub could have superseded v3 and applied v4.

The idea behind splicing N patches into a series is that they are
logically connected to one another. For example, a patch doesn't build
without another. You _could_ split logically-connected patches into
separate series and post them independently for review, as long as they
are build-time independent. If they aren't, well, what happens is
exactly what happened: various test robots will report build failures,
which from a maintainer's point of view inspires less confidence to
apply a patch as-is. I would not be surprised if Jakub asked you to
resend with no change at all, just to ensure that the patch series
passes build tests before merging it.
