Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A28301569
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 14:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbhAWN1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 08:27:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbhAWN1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 08:27:12 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAA0C06174A;
        Sat, 23 Jan 2021 05:26:31 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id z21so5784348pgj.4;
        Sat, 23 Jan 2021 05:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LTEsSL5/qEA0pl5YAeZp3Gvk1wl1Tnvm61u8N/Wojw8=;
        b=imN4Tc5IQE20IPCzQAtZil2dfLwC3ISfTTRl29dgCela7E30vNY4WHna6RWDec1HLx
         88PzXcIgTFGtV5eAm55loQlFUBLyXQyHkzlG1cp3AwC+cpyukPYz4lHzLyqMdFcmOUrT
         D/Cmmv3DanBFuUf+nPl0uM4miAv3W8+K7WOoSmN2V7zxoQvHXtLV2kQ/kqm0nnw7QBHM
         +4Dt7ZKCNkNlZxgE+ImexYoUbBngpuWAZiNMbnbebK4obYzvdwahRyEXt3zVn7RLqER0
         ZqP2q8mbz1k6Xm5xPL8DAMjHGLPyUXJneYSFyp12E5RgoTPCNkffoGcc75Zs76shK3g/
         Do7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LTEsSL5/qEA0pl5YAeZp3Gvk1wl1Tnvm61u8N/Wojw8=;
        b=EIN9wl1l9OrW/Jewv4P+M7wLA0qISPFGXkqJn7R0atTnj74b/9JtOWszLiitjSsRZr
         E/DW4CQgdQ8GZnZeQnF+Lh6K/1X6ohq95L0zpwC3lYl1AQeR4Vq58hp4XL2xHl+4dqom
         9CZRXcmCxWUxBHEpbnA2f414ex2X58GwM/oCQmjNP2wzbZ4sujVksjQ0n1CHhcjsEIAm
         7+vCFaaPENECbCT2Rah5KAqb2Dr9xCxakfz42ASPs95lszPvSddSoVj7YQcJJMKQwRRp
         +84IqCwMKYng43iIC0FH3C/ouhRFhc9b0elzYQMhBo3yCfPb5mkWEzxm24oI0fWge+f/
         tBiQ==
X-Gm-Message-State: AOAM532PxXm+30ldvWsgzup2cONGTmXOTwoKaT6q65GnsDnMrEH4rQ7n
        2ofjYMc4qD9GEdRuVEUlUp+MoMXPbcU=
X-Google-Smtp-Source: ABdhPJw2DWv3ukp/JUCsF0PWYxhjjIIZkzQR8rWVQCFESgtuWCvz8iDhgT+eeHWJn8KKkdZkgw1XZw==
X-Received: by 2002:a63:564f:: with SMTP id g15mr2581916pgm.334.1611408391001;
        Sat, 23 Jan 2021 05:26:31 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id h3sm11236821pgm.67.2021.01.23.05.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 05:26:30 -0800 (PST)
Date:   Sat, 23 Jan 2021 05:26:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210123132626.GA22662@hoboy.vegasvil.org>
References: <cover.1611198584.git.richardcochran@gmail.com>
 <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
 <20210121102753.GO1551@shell.armlinux.org.uk>
 <20210121150802.GB20321@hoboy.vegasvil.org>
 <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 06:14:44PM -0800, Jakub Kicinski wrote:

> (I would put it in net-next tho, given the above this at most a space
> optimization.)

It isn't just about space but also time.  The reason why I targeted
net and not net-next was that NETWORK_PHY_TIMESTAMPING activates a
function call to skb_clone_tx_timestamp() for every transmitted frame.

	static inline void skb_tx_timestamp(struct sk_buff *skb)
	{
		skb_clone_tx_timestamp(skb);
		if (skb_shinfo(skb)->tx_flags & SKBTX_SW_TSTAMP)
			skb_tstamp_tx(skb, NULL);
	}

In the abscence of a PHY time stamping device, the check for its
presence inside of skb_clone_tx_timestamp() will of course fail, but
this still incurs the cost of the call on every transmitted skb.

Similarly netif_receive_skb() futilely calls skb_defer_rx_timestamp()
on every received skb.

I would argue that most users don't want this option activated by
accident.

(And yes, we could avoid the functions call by moving the check
outside of the global functions and inline to the call sites.  I'll be
sure to have that in the shiny new improved scheme under discussion.)

Thanks,
Richard
