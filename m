Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFFA285DA5
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgJGKzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbgJGKzB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:55:01 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF70C061755;
        Wed,  7 Oct 2020 03:55:01 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l24so1664384edj.8;
        Wed, 07 Oct 2020 03:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=miz5GwevOoSj80fnl3ty9JVj8BuR70y6a/kr6x7hJWA=;
        b=tZokdP9aY/Ct2/hi7yXT7g5NuCM8mjouuPNjqkYseaEWGDW+5mUrlOS67PUAP9Kmft
         vyGQHmqmzrj1qqyCZkfDQVQsqnUlBI3rilQzSNVFBoy6Q+wuQVp7/z3baZ72wTREV0RH
         GQLkQ6nzw6ZlNANKJEHupotTPTOzrH/Ocvlj8X3m2H5RqI8MJTrBuNX6FiIul0r4I14z
         /08Iue16lcSsFPyl5d1xz+OzSY/bcXr3nlGogdZ+VDP4GGFCDB/eZMrL7eRx4H6PWN85
         gqNBvPqaRwXazBDHJ7WXQCqh709YzqDU4EFMhBI2PeIaQ9TmoZ1uroVSS04tJlMYvBvR
         EXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=miz5GwevOoSj80fnl3ty9JVj8BuR70y6a/kr6x7hJWA=;
        b=gk105V1yPYAV/mhKms7XnSjpofC4Cw7nHu7SWpaAzOReU/b0VwBYm+M2P+FKFnlvPh
         SLBl1ac8lvQKUbhSdR0gYKKRjr3kl8btJqi4UAMFfZkaRkSBOpmQWvm2XYXhjbDGa24w
         wLRmx2Tm/KSdCd9TeykmxP5fMgCqa6DDS7mq2dmqlZkGXJd9458WXb3rxi3jtT4aiLqD
         pucr46oCXuKWOfIcQlMB/QvFJ5qy3cfE9eBDV5OpMDN6mxE6iox/wt7dIbvOlYHkZHG5
         cxcyfnLDWIzkFhB6VgizC5To3dbAV7aTEtsN67rVNixxqrVTGWATb2T7M14tTRz6S/y/
         +O2g==
X-Gm-Message-State: AOAM532iL/5LpmH8hJsYrlKL4vAhj6zUXVP+0noju0/xsL/ZvEVFOkKo
        qqCI0uMGHJy3/4jkEQbkWxw=
X-Google-Smtp-Source: ABdhPJy8eVk0/mVC/Wv86ko+tH4o/GH5cjP42RAZY/ZXT4lmQhHZRjsNYeP+9MrDBGj5eE5GwfEsEg==
X-Received: by 2002:a50:da84:: with SMTP id q4mr2838211edj.238.1602068100161;
        Wed, 07 Oct 2020 03:55:00 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id p12sm1198414edr.18.2020.10.07.03.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:54:59 -0700 (PDT)
Date:   Wed, 7 Oct 2020 13:54:58 +0300
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
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201007105458.gdbrwyzfjfaygjke@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-5-kurt@linutronix.de>
 <20201004143000.blb3uxq3kwr6zp3z@skbuf>
 <87imbn98dd.fsf@kurt>
 <20201006072847.pjygwwtgq72ghsiq@skbuf>
 <87tuv77a83.fsf@kurt>
 <20201006133222.74w3r2jwwhq5uop5@skbuf>
 <87r1qb790w.fsf@kurt>
 <20201006140102.6q7ep2w62jnilb22@skbuf>
 <87lfgiqpze.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lfgiqpze.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 12:39:49PM +0200, Kurt Kanzenbach wrote:
> On Tue Oct 06 2020, Vladimir Oltean wrote:
> > On Tue, Oct 06, 2020 at 03:56:31PM +0200, Kurt Kanzenbach wrote:
> >> Yeah, sure. That use case makes sense. What's the problem exactly?
> >
> > The SO_TIMESTAMPING / SO_TIMESTAMPNS cmsg socket API simply doesn't have
> > any sort of identification for a hardware TX timestamp (where it came
> > from).
> 
> This is sounds like a problem.

Yeah, tell me about it.

> For instance the hellcreek switch has actually three ptp hardware
> clocks and the time stamping can be configured to use either one of
> them.

The sja1105 also has a corrected and an uncorrected PTP clock that can
take timestamps. Initially I had thought I'd be going to spend some time
figuring out multi-PHC support, but now I don't see any practical reason
to use the uncorrected PHC for anything.

> How would the user space distinguish what time stamp is taken by
> which clock? This is not a problem at the moment, because currently
> only the synchronized clock is exported to user space. See change log
> of this patch.

It wouldn't, of course. You'd need to add the plumbing for that.

> > So when you'll poll for TX timestamps, you'll receive a TX
> > timestamp from the PHY and another one from the switch, and those will
> > be in a race with one another, so you won't know which one is which.
> 
> OK. So what happens if the driver will accept to disable hardware
> timestamping? Is there anything else that needs to be implemented? Are
> there (good) examples?

It needs to not call skb_complete_tx_timestamp() and friends.

For PHY timestamping, it also needs to invoke the correct methods for RX
and for TX, where the PHY timestamping hooks will get called. I don't
think that DSA is compatible yet with PHY timestamping, but it is
probably a trivial modification. Please read
Documentation/networking/timestamping.rst, we try to keep it fairly
comprehensive.

Thanks,
-Vladimir
