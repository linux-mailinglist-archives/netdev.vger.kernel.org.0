Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45EFC315F4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfEaUOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:14:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34186 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727282AbfEaUOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:14:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id h1so2492744qtp.1;
        Fri, 31 May 2019 13:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=SrFrfsFx1qakMW9D7wpc85uiqQlKUf3C8E4XcNEoPmc=;
        b=l0uJ75nGyJKjmtLWNYsS0VZObEvCGwf+J9e4r/jXY6r91rlwYgvvhJzc40BdKgRmey
         vREsUGni4pvspThS7IhDvb2GRbwh8ao1t7sFhXj7t/taMVAAP+bTIrighTsiyaZcIiFq
         uZE8n7mSOElvcY9g+Vr5cYBJzAdEJ8Z9i1pqcH2nnm730QTptgq/DlQsf6516EReRRbF
         C4tEX7KPix6t3qoyxaHeY9rmCHNnTO9xUVIRbcrM5Ra3vUy5KHHVKAF5PoIvWscG6SL3
         MAf/VOI+tslGHWqIGRIab5b5lrCUqKEW2wcYzAxV2dEUGyZulSzKIE+E2LqZ+svM8FZ0
         L8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=SrFrfsFx1qakMW9D7wpc85uiqQlKUf3C8E4XcNEoPmc=;
        b=SHcZkaR4oZ9DPyvcjOHBHjVxqQLhwiol1ezcz/05QksoCtZSF9+ycozYM97VOyA++u
         1p03FOy+iCLRBwjc/ZjylAAOHKxtIRejP/Q0Htb+9aX8jKBVpTK+DVan9+2UJlfIoCub
         Q9gafeayuPw9S/LH9JMEmcT3/g2979PzyUaLqr4bM8pjC/p1fRZRWpKEN4/wPArrwU+m
         Ydr1EvMvNQTQ5Mrv5Jw7anHXPBOPNLhV4ZwNsDhh0u/yh43zWk0Mf0qaslE8NTWY3tOx
         RD8LsYCdnhpGfN4UtV9sba8Yd2U9NKkl/UErOfqi73BAMU8J0KJ1PmwXrq+tP4/OKVk3
         jn5g==
X-Gm-Message-State: APjAAAXtbiKKLMFQsNZ/mxMO5E08j6e3O1Pkf4yXPWR8Mb4BFcHewGWm
        UNpxFKzE1aHkHExgounxQvBKPq+NyMQ=
X-Google-Smtp-Source: APXvYqxOA2p1hfPCt2uQJfEPlXITmRyCED7cNtZ+sqro3Afvm0k+FlTIPAjsFh5vWXBLVc3c9EgoaA==
X-Received: by 2002:ac8:45d2:: with SMTP id e18mr8896076qto.258.1559333694299;
        Fri, 31 May 2019 13:14:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d23sm5836221qta.26.2019.05.31.13.14.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 May 2019 13:14:53 -0700 (PDT)
Date:   Fri, 31 May 2019 16:14:53 -0400
Message-ID: <20190531161453.GC20464@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: avoid error message on remove from
 VLAN 0
In-Reply-To: <1814b2e2-1a89-89f8-9699-f13df5e826b2@gmail.com>
References: <20190531073514.2171-1-nikita.yoush@cogentembedded.com>
 <20190531103105.GE23464@t480s.localdomain> <20190531143758.GB23821@lunn.ch>
 <1814b2e2-1a89-89f8-9699-f13df5e826b2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Fri, 31 May 2019 09:34:03 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> On 5/31/19 7:37 AM, Andrew Lunn wrote:
> >> I'm not sure that I like the semantic of it, because the driver can actually
> >> support VID 0 per-se, only the kernel does not use VLAN 0. Thus I would avoid
> >> calling the port_vlan_del() ops for VID 0, directly into the upper DSA layer.
> >>
> >> Florian, Andrew, wouldn't the following patch be more adequate?
> >>
> >>     diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> >>     index 1e2ae9d59b88..80f228258a92 100644
> >>     --- a/net/dsa/slave.c
> >>     +++ b/net/dsa/slave.c
> >>     @@ -1063,6 +1063,10 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
> >>             struct bridge_vlan_info info;
> >>             int ret;
> >>      
> >>     +       /* VID 0 has a special meaning and is never programmed in hardware */
> >>     +       if (!vid)
> >>     +               return 0;
> >>     +
> >>             /* Check for a possible bridge VLAN entry now since there is no
> >>              * need to emulate the switchdev prepare + commit phase.
> >>              */
> >  
> > Hi Vivien
> > 
> > If we put this in rx_kill_vid, we should probably have something
> > similar in rx_add_vid, just in case the kernel does start using VID 0.
> 
> We use the prepare/commit model in the rx_add_vid() path so we deal with
> -EOPNOTSUPP, that was caught fairly early on by Heiner when I added
> programming of VLAN filtering through rx_{add,kill}_vid.
> 
> Nikita's patcha s it stands is correct and would make both
> mv88e6xxx_port_check_hw_vlan() and mv88e6xxx_vtu_get() consistent.

OK, I'll double check if I can simplify the management of VID 0 in mv88e6xxx to
match what other switches do. In the meantime, Nikita's approach is consistent.

Thank you,
Vivien
