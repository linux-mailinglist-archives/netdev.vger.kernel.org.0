Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C824E2F24F5
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405404AbhALAZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403959AbhAKXQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:16:20 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66C4C061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:15:39 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id by27so28551edb.10
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uV41K99y9lBZhpgJUjD483NFbwIW66YVKPO41Hk6TII=;
        b=IzAUmxfNffqtAslmKn15Tpdsa22JQCCzh+ielVhygiYrtTkSG2lTj3Y9M5eY5plNSU
         d/SquHXndSSp24pS9xXUSVNIX5PDA5g8FHupdxCD8tHjBn2zEImGHP1QIlIOfRSC5GkE
         nXKqoZ+x418viPbcpVQ8VCXofOthPk+KMLp/qCciDGt7XaXjAzFw3Z75SFPYaVtzL65H
         aUIClDfHrqje4PPCF65mtUvQjPkhdMpIz6P46tfCBufvb44Cf0aldvULZ6DUImVSQqMG
         xLph4QxaLjf5zLanANA7YX3JE3WP718cyizVC6wyBRFZQlYcziY7gThR3xfqwlWhKIKq
         x8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uV41K99y9lBZhpgJUjD483NFbwIW66YVKPO41Hk6TII=;
        b=dafDcLxVVt2R87QDKH85laLM6IJZp+0Q3cUFfnRTpGmLlcz3qUiO+uiGHjp+1NlNHI
         zop1smmsAeusa+516uTNa4yzDPxeUxBmLB8cKASPgrPo2MCgybNhGFj5BSp2XWkVvEQ+
         XMLsFJLqrjeRhUCfwvYeb0GBvuTv902OxWXKms2/Ph0fVClIHfPYzHFZ4ely88TuatXv
         YHp9md4NIcST5H4+EBEizYMIex5v/iKoq8w6nT99uONvHPsG5Qri+VtekYYDvXTyzNoC
         jjJfywAiIMy/UQpEGZkpQ8drCuX7qR2WJv3P1NPrSgq+wynwCT8MZqT6UGBunq/Iw4CW
         tXtg==
X-Gm-Message-State: AOAM533ztv8bWrqJu3APJ9MubwJKhxbSj0m7jDq88cKyXAVqBCuisqST
        F1BGhG1wG+6kJK7LK8sril4=
X-Google-Smtp-Source: ABdhPJxwlml8TmU7WwfRRLoE39yXPi9o7WU/GfKrp3rLdjGINHKc48EAQjkIj1g3hlrvAg+oaizejw==
X-Received: by 2002:aa7:d485:: with SMTP id b5mr1155568edr.214.1610406938273;
        Mon, 11 Jan 2021 15:15:38 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id mb15sm438444ejb.9.2021.01.11.15.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 15:15:37 -0800 (PST)
Date:   Tue, 12 Jan 2021 01:15:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [PATCH v6 net-next 11/15] net: catch errors from dev_get_stats
Message-ID: <20210111231535.lfkv7ggjzynbiicc@skbuf>
References: <20210109172624.2028156-1-olteanv@gmail.com>
 <20210109172624.2028156-12-olteanv@gmail.com>
 <b517b9a54761a0ee650d6d64712844606cf8a631.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b517b9a54761a0ee650d6d64712844606cf8a631.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:54:50PM -0800, Saeed Mahameed wrote:
> On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > dev_get_stats can now return error codes. Convert all remaining call
> > sites to look at that error code and stop processing.
> >
> > The effects of simulating a kernel error (returning -ENOMEM) upon
> > existing programs or kernel interfaces:
> >
> > - ifconfig and "cat /proc/net/dev" print up until the interface that
> >   failed, and there they return:
> > cat: read error: Cannot allocate memory
> >
> > - ifstat and "ip -s -s link show":
> > RTNETLINK answers: Cannot allocate memory
> > Dump terminated
> >
> > Some call sites are coming from a context that returns void (ethtool
> > stats, workqueue context). So since we can't report to the upper
> > layer,
> > do the next best thing: print an error to the console.
> >
>
> another concern, one buggy netdev driver in a system will cause
> unnecessary global failures when reading stats via netlink/procfs for
> all the netdev in a netns, when other drivers will be happy to report.
>
> can't we just show a message in that driver's stats line about the
> occurred err ? and show the normal stats line of all others ?

So you're worried that user space apps won't handle an error code when
reading from a file, but you're not worried that they'll start scraping
junk from procfs when we print this?

cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
 bond0: Cannot allocate memory
  sit0:       0       0    0    0    0     0          0         0        0       0    0    0    0     0       0          0
