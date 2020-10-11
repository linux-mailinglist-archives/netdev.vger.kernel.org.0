Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBAFE28A7F7
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388174AbgJKPbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 11:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388162AbgJKPa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 11:30:59 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59225C0613CE;
        Sun, 11 Oct 2020 08:30:59 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i5so14343397edr.5;
        Sun, 11 Oct 2020 08:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yT7iclCksjyvHogLFtUOukinR9Uqpwagw6AnAve1RRk=;
        b=LAbaDB+uFCIp7ilYU/QpL3TPS2IAsJHtvfp+OjrGyMGGAgSSflt5/QpAhZK+oJU38M
         GbRbn8hgjCkYtFSJvDIVzUUgQx/XRmQagLUDaqwwfVjdIdfnYB0eRlFqbK1eGX9D3rWb
         WjY7EgADGgawWSXAJRw1H7oAupSSW+9ifi6o0UrPo/0bl8XvWNLd/iDQAun3eMoWPl5j
         M+7oLsbznoLPGx/X/wEalVKrUtpT5R50vEnIvzZ1KwPDtV2BCPohi0UHyto4Rt4uMfGi
         pnkjOhaEaH9mjxEoFDjJyIczhHlb/vOU6546I30TfXoG721eggdZ3XUGKWwqV7PQiFJe
         jpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yT7iclCksjyvHogLFtUOukinR9Uqpwagw6AnAve1RRk=;
        b=K+vx4lGWis4JjtYmZT3kgWrI7PYqY6Z6es4w8VZQcWQ2isN46tw/xi73Cd/K/RunAl
         pmh91htbLdGiHCROZ2/igMActbcU7z+2CSt7Eb6j0sHEEfKgbBhdXWNdoyWdttguBHEb
         U++m/oerrVJmqylzFLma16B00ApLRt4wyWpxSZc7qB4WqdBZxka6/S6Ngf5Axo4sgYH+
         L6AjlRuV/uqOixDEUr7XwYdZiJZLBX03OHVAZlni0X2qhVmEUq+95G0wyi6zDTa+QMvy
         zU96REYbJEqYIqTa7iZvNUWPJchp9tptLpt17mt/hp0VBrXHclFuPFa06XoMdTniq0gQ
         6JeA==
X-Gm-Message-State: AOAM533aMPJ+CW2zgkkcP9t+7u0GWcTRqGAvs4YUwMzGXQAdVbwgTwp7
        RdhaZodUHSbd8pD1+1AR2R0=
X-Google-Smtp-Source: ABdhPJz27hJTv+CVz9EUFaC/hH1pBYtdr1Q+tDE8YdR+bI3QotRO1IE7H8F/n9V4vWndsPw08kdHmA==
X-Received: by 2002:a05:6402:651:: with SMTP id u17mr9372591edx.206.1602430257796;
        Sun, 11 Oct 2020 08:30:57 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id n22sm9269800eji.106.2020.10.11.08.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 08:30:57 -0700 (PDT)
Date:   Sun, 11 Oct 2020 18:30:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201011153055.gottyzqv4hv3qaxv@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
 <20201006113237.73rzvw34anilqh4d@skbuf>
 <87wo037ajr.fsf@kurt>
 <20201006135631.73rm3gka7r7krwca@skbuf>
 <87362lt08b.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87362lt08b.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 02:29:08PM +0200, Kurt Kanzenbach wrote:
> On Tue Oct 06 2020, Vladimir Oltean wrote:
> > It would be interesting to see if you could simply turn off VLAN
> > awareness in standalone mode, and still use unique pvids per port.
>
> That doesn't work, just tested. When VLAN awareness is disabled,
> everything is switched regardless of VLAN tags and table.

That's strange, do you happen to know where things are going wrong?
I would expect:
- port VLAN awareness is disabled, so any packet is classified to the
  port-based VLAN
- the port-based VLAN is a private VLAN whose membership includes only
  that port, plus the CPU port
- the switch does not forward packets towards a port that is not member
  of the packets' classified VLAN
When VLAN awareness is disabled, are you able to cause packet drops by
deleting the pvid of the ingress port? Therefore, can you confirm that
lan1 is not a member of lan0's pvid, but the switch still forwards the
packets to it?

> Therefore, the implementation could look like this:
>
>  * bridge without filtering:
>    * vlan_awareness=0
>    * drop private vlans
>  * bridge with vlan filtering:
>    * vlan_awareness=1
>    * drop private vlans
>  * standalone:
>    * vlan_awareness=1
>    * use private vlans
>    * forbid other users to use private vlans to allow
>      configure_vlans_while_not_filtering behavior in .vlan_prepare()
>    * forbid use of lan0.<X> and lan1.<X> in .port_prechangeupper()
>
> So, this should work, or?

Yes, this is an alternative that could work.
