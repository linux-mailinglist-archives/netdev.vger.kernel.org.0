Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D28F21F3E6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgGNOXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbgGNOX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:23:28 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1D4C08C5C1;
        Tue, 14 Jul 2020 07:23:28 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id e22so17347092edq.8;
        Tue, 14 Jul 2020 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yj4YngiWsS66KFBhHQNvP0iXHHrupb/I73MOX6zQuxI=;
        b=D0TwkZttUgirge+0ki1rNiGdNAYGRqdzSbECsq6txGeQgcGhjnw6UQbqAvoLBbcvPe
         4wJHfWUP7VOA4yP70Lu4wyDDAAl4cXxKwwGSJIIK+jTM3Gf3GN/11HXo6++Vssk4flD/
         7aL5WDx7Tjhpl0snBUJQW/CXOf2owc/FC2LozpGzozta+hSf3AyGBGtHJqMlmrTmuAgX
         DgI0JfL5j5ESl3tKx/I5Xgryz+zTlAeoj0jJiJ2NicXWbOdlWy7sEbpddusIvX+sefKa
         Tz1nmFsmPgaf+Fjl9iQdu0ZQPo8Z2hgTJ9bQHaMND4yi0cleXhkOQeHUimgNvhVVcYza
         Sseg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yj4YngiWsS66KFBhHQNvP0iXHHrupb/I73MOX6zQuxI=;
        b=dZGhBlXGx8tN4ywFSkQWbuA+cI1hWVrH11uUjcI2t0K9VCCDVBw1ZCUOLR4AmGMHCd
         k9kgU8GtmOWIRk80DnuvR3St7XNgv8R8wetyovXOCqxccF3jZL8/BhwZzRNGTyikDb2R
         Uc6ZMLR7kbZkUgyvwrnzOIVOS/hxo4xrVzHvjpHGwxOfhMINRYzg5hkU99rQnFLSfweB
         QTcGtMUoSfAT9+4QSoar6Qh0AY71w8sWwKyDrJZ3LY24ydoFoJbhFCW+NaA2q1KnO95y
         S8+UJqi61SXk3EyH4k1T8BicYeAuvYrzBoP4aXsaAnmCaknMMBHo+sp/feOcO1cqvJDm
         /Puw==
X-Gm-Message-State: AOAM532Kl9WfaA2rL+rwxhqgHAPzq7NMAUPHB1AuDw1mmxeDmJAIfjCZ
        csyyi1QFdXpSBSLwpK8qfPQ=
X-Google-Smtp-Source: ABdhPJw/mL+XRrYzd+WySm6VWsyTQbtT9aJqxr72L+WpFfCqKQgagxPOQ0I5wkq95e75hBYXmONPVg==
X-Received: by 2002:a05:6402:1d14:: with SMTP id dg20mr4850520edb.23.1594736607009;
        Tue, 14 Jul 2020 07:23:27 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id w24sm14543877edt.28.2020.07.14.07.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 07:23:26 -0700 (PDT)
Date:   Tue, 14 Jul 2020 17:23:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
Message-ID: <20200714142324.oq7od3ylwd63ohyj@skbuf>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200711120842.2631-1-sorganov@gmail.com>
 <20200711231937.wu2zrm5spn7a6u2o@skbuf>
 <87wo387r8n.fsf@osv.gnss.ru>
 <20200712150151.55jttxaf4emgqcpc@skbuf>
 <87r1tg7ib9.fsf@osv.gnss.ru>
 <20200712193344.bgd5vpftaikwcptq@skbuf>
 <87365wgyae.fsf@osv.gnss.ru>
 <20200712231546.4k6qyaiq2cgok3ep@skbuf>
 <878sfmcluf.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sfmcluf.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 03:39:04PM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > On Mon, Jul 13, 2020 at 01:32:09AM +0300, Sergey Organov wrote:
> 
> [...]
> 
> >> > From the perspective of the mainline kernel, that can never happen.
> >>
> >> Yet in happened to me, and in some way because of the UAPI deficiencies
> >> I've mentioned, as ethtool has entirely separate code path, that happens
> >> to be correct for a long time already.
> >>
> >
> > Yup, you are right:
> >
> 
> [...]
> 
> > Very bad design choice indeed...
> > Given the fact that the PHY timestamping needs massaging from MAC driver
> > for plenty of other reasons, now of all things, ethtool just decided
> > it's not going to consult the MAC driver about the PHC it intends to
> > expose to user space, and just say "here's the PHY, deal with it". This
> > is a structural bug, I would say.
> >
> >> > From your perspective as a developer, in your private work tree, where
> >> > _you_ added the necessary wiring for PHY timestamping, I fully
> >> > understand that this is exactly what happened _to_you_.
> >> > I am not saying that PHY timestamping doesn't need this issue fixed. It
> >> > does, and if it weren't for DSA, it would have simply been a "new
> >> > feature", and it would have been ok to have everything in the same
> >> > patch.
> >>
> >> Except that it's not a "new feature", but a bug-fix of an existing one,
> >> as I see it.
> >>
> >
> > See above. It's clear that the intention of the PHY timestamping support
> > is for MAC drivers to opt-in, otherwise some mechanism would have been
> > devised such that not every single one of them would need to check for
> > phy_has_hwtstamp() in .ndo_do_ioctl(). That simply doesn't scale. Also,
> > it seems that automatically calling phy_ts_info from
> > __ethtool_get_ts_info is not coherent with that intention.
> >
> > I need to think more about this. Anyway, if your aim is to "reduce
> > confusion" for others walking in your foot steps, I think this is much
> > worthier of your time: avoiding the inconsistent situation where the MAC
> > driver is obviously not ready for PHY timestamping, however not all
> > parts of the kernel are in agreement with that, and tell the user
> > something else.
> 
> You see, I have a problem on kernel 4.9.146. After I apply this patch,
> the problem goes away, at least for FEC/PHY combo that I care about, and
> chances are high that for DSA as well, according to your own expertise.
> Why should I care what is or is not ready for what to get a bug-fix
> patch into the kernel? Why should I guess some vague "intentions" or
> spend my time elsewhere?
> 
> Also please notice that if, as you suggest, I will propose only half of
> the patch that will fix DSA only, then I will create confusion for
> FEC/PHY users that will have no way to figure they need another part of
> the fix to get their setup to work.
> 
> Could we please finally agree that, as what I suggest is indeed a simple
> bug-fix, we could safely let it into the kernel?
> 
> Thanks,
> -- Sergey

I cannot contradict you, you have all the arguments on your side. The
person who added support for "ethtool -T" in commit c8f3a8c31069
("ethtool: Introduce a method for getting time stamping capabilities.")
made a fundamental mistake in that they exposed broken functionality to
the user, in case CONFIG_NETWORK_PHY_TIMESTAMPING is enabled and the MAC
driver doesn't fulfill the requirements, be they skb_tx_timestamp(),
phy_has_hwtstamp() and what not. So, therefore, any patch that is adding
PHY timestamping compatibility in a MAC driver can rightfully claim that
it is fixing a bug, a sloppy design. Fair enough.

The only reason why I mentioned about spending your time on useful
things is because in your previous series you seemed to be concerned
about that. In retrospect, I believe you agree with me that your
confusion would have been significantly lower if the output of "ethtool
-T" was in harmony with the actual source of hardware timestamps.
Now that we discussed it through and I did see your point, I just
suggested what I believe to be the fundamental issue here, don't shoot
the messenger. Of course you are free to spend your time however you
want to.

Acked-by: Vladimir Oltean <olteanv@gmail.com>

Thanks,
-Vladimir
