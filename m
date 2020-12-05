Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27A42CF7F2
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgLEAXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgLEAXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 19:23:14 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808FDC0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 16:22:34 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id d9so7250472qke.8
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 16:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FkPD1aZzFfxbNKEXezULyypGYdn+lULBoGE4KywUHwY=;
        b=swd6AnymVB1ySaiTv7vEeqzzxI6zNimRiZWEcM5gcBXDQ9Hxfjsdo65mW171IevrXn
         6px1pwGaWLiO32/WyU2WpS+Ou7kl7ECINw2bwmYm0fjm8b+dVnLsDR1ZpcQINvwtyFo5
         8bPi72ETsLl1saAwoBbBykRGA4OAAILqzPnpEK3aArAz52PxvoTerzT9s3X+6KLWhBYJ
         3jPiPvMVwkFj+UIDYQN7l+qf40gxYAn16O5CqgFnTfTwqRbcc4+RhBHWQg3HFVGOxzlv
         7zcXt2uzbbojpbROINXZ4dpKsYyTD71I6EtS1waLFAyQL9hkGkdywHlYc6aqZ5VXniyl
         U+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FkPD1aZzFfxbNKEXezULyypGYdn+lULBoGE4KywUHwY=;
        b=GbtKdY0YaeHF44c9XBaOW8ICuAY7TBKfESzlnObq44ktQyfjjskKJ8En0BjhGvX0Cq
         5MmOchHpHo4HkmmHDq5fxuHwe4PG6CpEpa/oVptNiSziPk37Me1RJ614Fb71mOVJSx/g
         LTxDbdshdp3PJOwU0bEus9SB886kKH4tpAJgUfY9wZEgHJXWL8KQP+PBR7s48KAeYt9t
         6SCzmPp44nLnUTuKmNvd603MLZz16D3iUpDmjN1X3hb078+bRi8ZvKQ2yEJB35ci7gdd
         upExDh33q0Wxj2/0MweDrXGDj+ivlIoIGDKB3iKRYaQ8STiEIOG0nd57/epuEQz7mdo8
         P1YQ==
X-Gm-Message-State: AOAM530fnEI0G34xoMuzlEraaI42YfN2DhXLrL+/HRwdEGKKEZaSl2g3
        lnXUc7qSniwmqWiXdqglmg==
X-Google-Smtp-Source: ABdhPJwuCpg2Ey99ULKIMYtFSSWF1MjF+O5QhinkAR4j6wYUrYGhC2qNgQw8QU6eUJwfadwZfbBp9w==
X-Received: by 2002:a05:620a:62b:: with SMTP id 11mr12151325qkv.229.1607127753705;
        Fri, 04 Dec 2020 16:22:33 -0800 (PST)
Received: from ICIPI.localdomain ([136.56.89.69])
        by smtp.gmail.com with ESMTPSA id h26sm6408817qkh.127.2020.12.04.16.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 16:22:33 -0800 (PST)
Date:   Fri, 4 Dec 2020 19:22:27 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] vrf: packets with lladdr src needs dst at input with
 orig_iif when needs strict
Message-ID: <20201205002227.GA8699@ICIPI.localdomain>
References: <20201204030604.18828-1-ssuryaextr@gmail.com>
 <6199335a-c50f-6f04-48e2-e71129372a35@gmail.com>
 <20201204153748.00715355@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204153748.00715355@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 03:37:48PM -0800, Jakub Kicinski wrote:
> On Fri, 4 Dec 2020 09:32:04 -0700 David Ahern wrote:
> > On 12/3/20 8:06 PM, Stephen Suryaputra wrote:
> > > Depending on the order of the routes to fe80::/64 are installed on the
> > > VRF table, the NS for the source link-local address of the originator
> > > might be sent to the wrong interface.
> > > 
> > > This patch ensures that packets with link-local addr source is doing a
> > > lookup with the orig_iif when the destination addr indicates that it
> > > is strict.
> > > 
> > > Add the reproducer as a use case in self test script fcnal-test.sh.
> > > 
> > > Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> > > ---
> > >  drivers/net/vrf.c                         | 10 ++-
> > >  tools/testing/selftests/net/fcnal-test.sh | 95 +++++++++++++++++++++++
> > >  2 files changed, 103 insertions(+), 2 deletions(-)
> > 
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> Should I put something like:
> 
> Fixes: b4869aa2f881 ("net: vrf: ipv6 support for local traffic to local addresses")
> 
> on this?

I was conflicted when I was about to put Fixes tag on this patch because
it could either be b4869aa2f881 that you mentioned above, or 6f12fa7755301
("vrf: mark skb for multicast or link-local as enslaved to VRF"). So, I
decided not to put it, but may be I should so that this is qualified to
be queued to stable?

Thanks,
Stephen.
