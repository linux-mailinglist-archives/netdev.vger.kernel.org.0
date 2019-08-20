Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D733A9552F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 05:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfHTDdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 23:33:04 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39754 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbfHTDdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 23:33:03 -0400
Received: by mail-pl1-f195.google.com with SMTP id z3so1996370pln.6
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 20:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lWnueG3cbqs85/iU3BNzSfMXa/XIwh5pNM4H4cjtMUE=;
        b=D6FgzoLF7k79zDh3s9RMF60rjzkobXIhhrKGcZ9L47RorA5baXQvYKl46rv4VGjItj
         k1dlIrS67XrDvrumxn2pDjs9fwKWRvI0JOH4hLpxxBwxOqpgtzy9VCCALPNXMpdOMUg9
         ftHWMXbc9bR1e0Aa/c2wzaPfYiu+Mk9OOManhv27Q14RKtEj+krsXSBQ+mu7sJHwv2I/
         PbDpKqdyElDHx1ZlQ7sBwABOfTgq+29NzrGd9mn4m5/aSwMFLqIrPQC43ucG28JpMrGK
         4CeUHKX3oVrcBmu+NIltvV/veU0NuchP0yw2cBB8Y48UXrkgW3b7c/slF5X0kXtD5IRl
         fa9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lWnueG3cbqs85/iU3BNzSfMXa/XIwh5pNM4H4cjtMUE=;
        b=ms+eCviYIdWLvU/ffDGg1V6MMBBzm1uZJwHj/+iOwQCSWFioNmM0t84MLsQxV/K8gb
         zWDHBgDihfZKnxmFW/3mwlzvsnovY+B9V6PhBINQcfsxYSVXyVBiqhbUC2eztFfh5xBn
         FaNR2kEsLqj1jeDVgW0Gott4YeNspN6qNPVP3I8V+k6boMwvGjlwNoTytN+SfDNJLt/2
         CABXxPbFwJZxdxS30uiKjihxerecUmc5hQdlix4SUyC1YtpbxKVXHBWDhMDEaC24t7B1
         b8cF3FCYPESF5Q6TgTodMDB8DZMe5mDpem2l/6OHK48Tu5aKpYDwTzN+mh4B4m5w5yqf
         ObjA==
X-Gm-Message-State: APjAAAXrTs0T50fS+4JRpkRv02YWOiqkiqsgwcd25+v3EXmOhWG9O0OL
        8+Pc123jVy2909BYqGvavHDPpLI9
X-Google-Smtp-Source: APXvYqz8/xhO2O/etsuIYiVfOv6eFUKa2G4/w38Zr3bqvrHCaWACAzo6t8eFdPKWF+wldF234jOFGQ==
X-Received: by 2002:a17:902:20c2:: with SMTP id v2mr23786939plg.209.1566271982863;
        Mon, 19 Aug 2019 20:33:02 -0700 (PDT)
Received: from [10.230.7.147] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id k64sm22019009pgk.74.2019.08.19.20.33.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 20:33:02 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] net: dsa: tag_8021q: Restore bridge pvid
 when enabling vlan_filtering
To:     Vladimir Oltean <olteanv@gmail.com>, vivien.didelot@gmail.com,
        andrew@lunn.ch, idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20190820000002.9776-1-olteanv@gmail.com>
 <20190820000002.9776-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <bf0c064e-6304-ba31-8f45-3a6226ed8939@gmail.com>
Date:   Mon, 19 Aug 2019 20:32:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190820000002.9776-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2019 5:00 PM, Vladimir Oltean wrote:
> The bridge core assumes that enabling/disabling vlan_filtering will
> translate into the simple toggling of a flag for switchdev drivers.
> 
> That is clearly not the case for sja1105, which alters the VLAN table
> and the pvids in order to obtain port separation in standalone mode.
> 
> So, since the bridge will not call any vlan operation through switchdev
> after enabling vlan_filtering, we need to ensure we're in a functional
> state ourselves.
> 
> Hence read the pvid that the bridge is aware of, and program that into
> our ports.

That is arguably applicable with DSA at large and not just specifically
for tag_8021q.c no? Is there a reason why you are not seeking to solve
this on a more global scale?

> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---
>  net/dsa/tag_8021q.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
> index 67a1bc635a7b..6423beb1efcd 100644
> --- a/net/dsa/tag_8021q.c
> +++ b/net/dsa/tag_8021q.c
> @@ -93,6 +93,33 @@ int dsa_8021q_rx_source_port(u16 vid)
>  }
>  EXPORT_SYMBOL_GPL(dsa_8021q_rx_source_port);
>  
> +static int dsa_port_restore_pvid(struct dsa_switch *ds, int port)
> +{
> +	struct bridge_vlan_info vinfo;
> +	struct net_device *slave;
> +	u16 pvid;
> +	int err;
> +
> +	if (!dsa_is_user_port(ds, port))
> +		return 0;
> +
> +	slave = ds->ports[port].slave;
> +
> +	err = br_vlan_get_pvid(slave, &pvid);
> +	if (err < 0) {
> +		dev_err(ds->dev, "Couldn't determine bridge PVID\n");
> +		return err;
> +	}
> +
> +	err = br_vlan_get_info(slave, pvid, &vinfo);
> +	if (err < 0) {
> +		dev_err(ds->dev, "Couldn't determine PVID attributes\n");
> +		return err;
> +	}
> +
> +	return dsa_port_vid_add(&ds->ports[port], pvid, vinfo.flags);
> +}
> +
>  /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
>   * front-panel switch port (here swp0).
>   *
> @@ -223,7 +250,10 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
>  		return err;
>  	}
>  
> -	return 0;
> +	if (!enabled)
> +		err = dsa_port_restore_pvid(ds, port);
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
>  
> 

-- 
Florian
