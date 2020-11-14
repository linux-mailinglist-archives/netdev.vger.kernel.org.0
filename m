Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214FC2B2D35
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 13:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgKNMwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 07:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgKNMwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 07:52:14 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168C5C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 04:52:12 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id l11so6103671lfg.0
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 04:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=Muh+U/HOD1oqUPIRK4+cE/Wp1iWkLaOeubzgucrbuN8=;
        b=cKNvYeYaphLK4iZhhmdNr/m1Wg141OER1E+909AiVpLyZG4l4fee5NV8EjKXTt2xeG
         LfyXqDw/OQAR0GdLzjfPZVFwp2SpkTaB517jXUKJYxBeaDv6B/41P3IK7kr0wGdx60yE
         UT4vC9ahCsLvpFqbanRjWJJG6p16T4dvXaOZ11j2gvrGhJ040UkqgBaYCxI11MBGVVyV
         cysuVyMMKQyygNR8Q364CEUI9ALnoShQhIl7dtAClg3PbX6tC5ugfQIwE5auOwCRe6n1
         EWx1edapd0i9+T7rXBBsQ4iFoS2iVHRoZ6dLqG77XzPu26BDk0YWEWOfGKYgyuf1XyRO
         8czQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=Muh+U/HOD1oqUPIRK4+cE/Wp1iWkLaOeubzgucrbuN8=;
        b=KX2aCTu7IGAq8+9YtZoj+boIxFfvptq/XV8JJOzu2YmicS/gs92aH2NzZ5dGdrF2jG
         mLsc8R5mCA8XqFDChU6PoecMATbrubHE7XbtfSl4YIT0tWejXPr8elQLSJg3Bzi3RoFB
         +gaNScmYiSFuzEIaFHSLMuQxxU/sMNAdwD39lBU/r4CvrY47g0tHgq+i3GMxNA/O0W2D
         M7UE4WW4o0Cw0nrXbA+ffa7MxMJgWqquP6DZPuYMWb64TNDXqix0lc5lcW0d+edprbHl
         wRfGRxzPrq7MwBtfH211yguph8jWRfiDlUpemri6m2K3T6tx3uGCSRPjNfJOzYNQWN/k
         vp5g==
X-Gm-Message-State: AOAM531E/BaNUvP5xSHNRb6fVNrTLzZrK/xrewOFwbmVCe6KjK17VM1V
        jJ46oXYdePDRvteeMY7CLwcn8Q==
X-Google-Smtp-Source: ABdhPJyrLRTO9ZgEB9vfCRQqNEWKKk27eVEjCh8bDF2oel0V+dkk63JsGxlxxQx4H9RlB3LAy/8AUA==
X-Received: by 2002:ac2:5462:: with SMTP id e2mr2749408lfn.552.1605358330243;
        Sat, 14 Nov 2020 04:52:10 -0800 (PST)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id i6sm1816973lfo.70.2020.11.14.04.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2020 04:52:09 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "Andrew Lunn" <andrew@lunn.ch>, <davem@davemloft.net>,
        <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Vladimir Oltean" <olteanv@gmail.com>
Date:   Sat, 14 Nov 2020 13:36:25 +0100
Message-Id: <C72ZP5LRG8GP.1HOGSHPU7HJB@wkz-x280>
In-Reply-To: <20201114122051.4nwjjkjhrbb344vy@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat Nov 14, 2020 at 3:20 PM CET, Vladimir Oltean wrote:
> On Sat, Nov 14, 2020 at 12:29:32PM +0100, Tobias Waldekranz wrote:
> > > Humm, yes, they have not been forwarded by hardware. But is the
> > > software bridge going to do the right thing and not flood them? Up
> >
> > The bridge is free to flood them if it wants to (e.g. IGMP/MLD
> > snooping is off) or not (e.g. IGMP/MLD snooping enabled). The point
> > is, that is not for a lowly switchdev driver to decide. Our job is to
> > relay to the bridge if this skb has been forwarded or not, the end.
> >
> > > until now, i think we did mark them. So this is a clear change in
> > > behaviour. I wonder if we want to break this out into a separate
> > > patch? If something breaks, we can then bisect was it the combining
> > > which broke it, or the change of this mark.
> >
> > Since mv88e6xxx can not configure anything that generates
> > DSA_CODE_MGMT_TRAP or DSA_CODE_POLICY_TRAP yet, we do not have to
> > worry about any change in behavior there.
> >
> > That leaves us with DSA_CODE_IGMP_MLD_TRAP. Here is the problem:
> >
> > Currenly, tag_dsa.c will set skb->offload_fwd_mark for IGMP/MLD
> > packets, whereas tag_edsa.c will exempt them. So we can not unify the
> > two without changing the behavior of one.
> >
> > I posit that tag_edsa does the right thing, the packet has not been
> > forwarded, so we should go with that.
> >
> > This is precisely the reason why we want to unify these! :)
>
> Shouldn't the correct approach be to monitor the
> SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute in order to figure out
> whether IGMP/MLD snooping is enabled or not?

The correct thing is to do both.

Independent of wheter IGMP/MLD snooping is statically or dynamically
enabled, it is always true that a TO_CPU with code 2 has _never_ been
forwarded in hardware and a FORWARD _always_ has been (which is the
tag you would see on IGMP frames reaching the CPU in that case).

In the static case, we would always get TO_CPUs with code 2, and thus
never set offload_fwd_mark. If snooping is enabled on the bridge, they
won't be forwarded. If snooping is disabled, the bridge will want to
forward, which it can since the mark is not set.

In the dynamic case, we would get TO_CPUs with code 2 when snooping is
enabled. The mark won't be set, but the bridge does not want to
forward anyway. When snooping is disabled, we would get FORWARDs. The
bridge will want to forward those, see that the mark is set, and skip
it.

The only combination that does not work is of course to have snooping
permanently _off_ in hardware and expect to use snooping correctly on
the software bridge. In that case you would always get FORWARDs, and
always set the mark. The bridge will not want to flood, but it is too
late since the hardware has already done it.
