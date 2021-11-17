Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6D94541B5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 08:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbhKQHXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 02:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbhKQHXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 02:23:39 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD682C061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 23:20:41 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id z6so171275plk.6
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 23:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QxmuFfCaxgsz4KW6/sSRpOtCBikOyWQfYGvNQ0EqHsY=;
        b=OMDD7ayDii2zAT/nPW5+xjJnxLXFSPzj9finY3RsFqD/79d0CmW9PcwIKEoayes1W1
         VEw232cOE9fm5UsWm+xeaz+1QN8sQgROjG/tvolMxbNqTCdvAxO6b4ODgaPtJm16Axib
         0mRvc/MgPxHaaPfmKmLmx5MGwJkYOvguzg9Ryzpjglbw2l9xmSFoCG9ok6pRXs/mYJgG
         KC2stl+Uo4BiLAwHb0QRuEZD9jW8Jtgg6G8Zw2ecPROvSSpwJYhRfZMz6ighdd0xYnWZ
         ESg8Q+rWtjzwV6Hexwj6JHL+MLkKyotpJkbwcSiBSxS6HfepgBZKccL/pd8XcD5oYNMa
         oIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QxmuFfCaxgsz4KW6/sSRpOtCBikOyWQfYGvNQ0EqHsY=;
        b=mFoMmGkLuLSZIR9l9pv9WhA6K3OTtEwOQEZznJKSWw3RessJadZfEOOMTlaXYwOg8U
         VHXgtaR90bLJWXPdmBTXxPgdg+OwF1Tx08e1tzlaH8NQSKHW9wPvEJK1JQ490uX1nwaz
         hhKRiPI2FF2GZH2t4d5BNk67/TJIb8pYCn1dpPUFCqc7MrQvt+MPVT9gBIJer26tGpkU
         HMZ7eaRifHORFiVAFX075Rqk4yfNSoVpgAvH+8igp3zI/sEubPJxXk0FRtKp5N0bQl23
         4zFfd45KyMQiXW0dUfBwBeZUyZRVVL5SJ35Ys5GeTK5YTRNDRAKCAVwuqO5FWnmo/skQ
         njoA==
X-Gm-Message-State: AOAM530e1LgODruVxVh+Sdsg4LzUdkaOjlKTPR3DIRoHOGb+n0yea40a
        W2zacucm8gMs1DgmfZGNgoA=
X-Google-Smtp-Source: ABdhPJwni+cSfxv6xfUaDFMgFW/UHFctWtMlEsC6TlhrR4QCEDGl2F2x44ClPRB4h/QJr0a+BQzzwg==
X-Received: by 2002:a17:90b:3908:: with SMTP id ob8mr6878791pjb.57.1637133641485;
        Tue, 16 Nov 2021 23:20:41 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id mu4sm5032031pjb.8.2021.11.16.23.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 23:20:40 -0800 (PST)
Date:   Wed, 17 Nov 2021 15:20:34 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next] Bonding: add missed_max option
Message-ID: <YZStQmciqidnkL3/@Laptop-X1>
References: <20211116084840.978383-1-liuhangbin@gmail.com>
 <20211116120058.494d6204@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YZRUW6wfMdI1aN1o@Laptop-X1>
 <20211116184155.6c81b042@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116184155.6c81b042@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 06:41:55PM -0800, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 09:01:15 +0800 Hangbin Liu wrote:
> > > >  
> > > >  static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
> > > > @@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
> > > >  			return err;
> > > >  	}
> > > >  
> > > > +	if (data[IFLA_BOND_MISSED_MAX]) {
> > > > +		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);  
> > > 
> > > If you read and write a u8?  
> > 
> > Ah, that's a typo. I planed to use nla_get_u32(). But looks NLA_U8 also should
> > be enough. WDYT?
> 
> Either way is fine. To be sure we don't need to enforce any lower limit
> here? 0 is a valid setting?

Re-considered and I agree that the value should not be set to 0.

Thanks
Hangbin
