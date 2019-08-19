Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B618949D2
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 18:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfHSQ1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 12:27:40 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39095 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbfHSQ1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 12:27:40 -0400
Received: by mail-qk1-f196.google.com with SMTP id 125so1918870qkl.6
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 09:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=awWzsurtd+9XBMdAYzQi8tyjcKIehHdkwPNu8Rbaxwo=;
        b=oSEmeHzzpgzmqjm/1aJULwHowj8b8iEbZcqua7HOj2SPGqJj8QEW9V+gTc9GI372qL
         Y4SkS2tJG63R4srAIvnxjBz50mOPbwWJccuOR2q3u89BsZpQoRV9NgIxteND7CZK5A8q
         aBgGfnKcHRisYiVLKy4pXoA21gCNsUdvD8ec7Bwh8cHowY+TBf8geMHPFkn9ppkZX19A
         toLeQkBz/bz9LKZRl2f3TOBsSBF4KGIk8z61HB3IsGSSPRyvnL4b4VIzFjufqTg/Wd6X
         ES9fIwzA9ozfBL6/LFQibrJXF2OeVb/+B3PZJ+XIV19u/hIXmxQjl64BSA7ss8fT2yAI
         D6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=awWzsurtd+9XBMdAYzQi8tyjcKIehHdkwPNu8Rbaxwo=;
        b=rly3YDfijJlFM4sUGxuYSu2sNZx0OVlQcx3fUz1vcegHDn7ABJo8cyRsyKs962KlqC
         KaQbX+BvX/L/3PmkNUY6PgAyXDEB2TnDW7YwvqwIUYlvPuJIkUbEGbh21xGRkduI2flK
         sx/eI4fIpsC9TG67iWYCTUhJGGEUv8W89Yr0znyAMGW+QdlAJO3a9sfoqmo3P0FeD+2K
         ImkQ9VTsTtD1KUr5wytoNUpLO25Ym/st18FiZ0wm0OOhj2urFui8Ari0EnsiAXz0O0DH
         mToTrInKiGgkPse9v6G91TWjzasRAwqatdt38/fBT0An2fhDDACjhPb/7FPwY0RXdoXu
         WX9w==
X-Gm-Message-State: APjAAAUZJw4jD6eKhpYxeAPD8XrJrS/ETG373gw9j+Be4gCjroc77I1f
        BUzaEQc5fRCUAM+drsgivjo=
X-Google-Smtp-Source: APXvYqx7cMtaXwSn/gepp6xJXNj6kfj2UrbPTzyFZZKS4gZZqy7I42OnSSJGV4fL7vAedNzk5rSIcg==
X-Received: by 2002:a37:d8f:: with SMTP id 137mr20784670qkn.254.1566232059708;
        Mon, 19 Aug 2019 09:27:39 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t189sm2017260qkd.56.2019.08.19.09.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 09:27:38 -0700 (PDT)
Date:   Mon, 19 Aug 2019 12:27:37 -0400
Message-ID: <20190819122737.GB16144@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, marek.behun@nic.cz, davem@davemloft.net,
        f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/6] net: dsa: mv88e6xxx: do not change STP state
 on port disabling
In-Reply-To: <20190819161018.GI15291@lunn.ch>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
 <20190818173548.19631-5-vivien.didelot@gmail.com>
 <20190819134057.GF8981@lunn.ch> <20190819112733.GD6123@t480s.localdomain>
 <20190819161018.GI15291@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 18:10:18 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Mon, 19 Aug 2019 15:40:57 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Sun, Aug 18, 2019 at 01:35:46PM -0400, Vivien Didelot wrote:
> > > > When disabling a port, that is not for the driver to decide what to
> > > > do with the STP state. This is already handled by the DSA layer.
> > > 
> > > Putting the port into STP disabled state is how you actually disable
> > > it, for the mv88e6xxx. So this is not really about STP, it is about
> > > powering off the port. Maybe a comment is needed, rather than removing
> > > the code?
> > 
> > This is not for the driver to decide, the stack already handles that.
> > Otherwise, calling dsa_port_disable on a bridged port would result in
> > mv88e6xxx forcing the STP state to Disabled while this is not expected.

[...]

> Are you saying the core already sets the STP to disabled, for ports
> which are unused? I did not spot that in your previous patch?

Just look at dsa_port_disable Andrew:


    void dsa_port_disable(struct dsa_port *dp)
    {
    	struct dsa_switch *ds = dp->ds;
    	int port = dp->index;
    
    	if (!dp->bridge_dev)
    		dsa_port_set_state_now(dp, BR_STATE_DISABLED);
    
    	if (ds->ops->port_disable)
    		ds->ops->port_disable(ds, port);
    }


The only thing worth arguing here is whether it makes sense to call
ds->ops->disable for a bridged port, or should we simply return right
away in this case. But this would be an independent patch anyway.


Thank you,

	Vivien
