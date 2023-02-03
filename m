Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E40B68A6F5
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjBCXhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjBCXhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:37:23 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A301F71BFB;
        Fri,  3 Feb 2023 15:37:21 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id mc11so19537981ejb.10;
        Fri, 03 Feb 2023 15:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GfdEQsWft1yQ3mAyWOQZMQC1cO9oHeHtoaPzwv9bnzU=;
        b=meRM8LkqoRXF49sHjr3w0qWZtqFtO+pUO3TsbTjmMUS8+pIecdIo0FAgJ70qCpkkQ0
         Rp8HcO80LPchSAFjAFoZ3j5m6RCX1D9Q6jMRuNvOOTJ+Cp3/vidp7MOFhuggfGWsbIy9
         JzbnQegkCsMD5qGGz0t4l3rI3nwqXpN58a5L9GA0RQnBWbF9zAhT7qxXWjpzYNXzt2r/
         EOReEK7mwi9HDDnC6K92Uc9Cylk9w9QhFa1ajnDzliYl29gCjNQcI+OigeZF3tBqQR/f
         u786PaohAfSB+1Gw7twysZvnTPwI6Ajgd2HkxDZaizaYq+wXX6B12fNoYkRmkUc9Qul1
         oVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfdEQsWft1yQ3mAyWOQZMQC1cO9oHeHtoaPzwv9bnzU=;
        b=UCzxwJLnCXulLE0itAVFWdzBgjAP4FwfzGkeePrCJF/E/eskkUHiF6HC4Z+BQjjo7L
         2+XcPjUp82YFXDp1RHrEg9M9ey9PHt0dBN0RlHicpO2WgHI/PtC99m+412NRnjlRH8sY
         //7YYpYgVCh707PVFIdlSH+ROyhzolCAcqVhOeaN4hHfzU6MVjQrJiBeKFvoeg3e0TAn
         0e6r3ghIcYQYup7nZPV+eto6mbqWaFELmrEKt+0bfswQDCs0lNmfC27rONLmY+J2j3f4
         8Q4EGp18Mi3ttu1ulFTUBDgVUHaEu/U+EkBiSQJLAQXi66ldeRaSMah826jUomKr62gW
         cbVQ==
X-Gm-Message-State: AO0yUKXwklmS6uBwMZwEQZ9IDQPuNRJ48KjbveD7jMiQs9tgC04avHJl
        E22GC5ABXnFZEHSbazSpZgk=
X-Google-Smtp-Source: AK7set+QGhCuaAyqx0U5ASfUPsrdgtBLl30l/fBPG2eqLlR3aDlU+JSb/wvV6YkK2r0ctYPQob/B0w==
X-Received: by 2002:a17:906:3192:b0:889:58bd:88a3 with SMTP id 18-20020a170906319200b0088958bd88a3mr11628748ejy.68.1675467439684;
        Fri, 03 Feb 2023 15:37:19 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id o15-20020a170906600f00b00857c2c29553sm2014609ejj.197.2023.02.03.15.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 15:37:19 -0800 (PST)
Date:   Sat, 4 Feb 2023 01:37:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 07/11] net: dsa: microchip: lan937x: update
 switch register
Message-ID: <20230203233717.m3s6xm4fynqmkx7h@skbuf>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-8-rakesh.sankaranarayanan@microchip.com>
 <Y9vZdMQgqhaGIcdf@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9vZdMQgqhaGIcdf@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 04:40:36PM +0100, Andrew Lunn wrote:
> On Thu, Feb 02, 2023 at 06:29:26PM +0530, Rakesh Sankaranarayanan wrote:
> > Second switch in cascaded connection doesn't have port with macb
> > interface. dsa_switch_register returns error if macb interface is
> > not up. Due to this reason, second switch in cascaded connection will
> > not report error during dsa_switch_register and mib thread work will be
> > invoked even if actual switch register is not done. This will lead to
> > kernel warning and it can be avoided by checking device tree setup
> > status. This will return true only after actual switch register is done.
> 
> What i think you need to do is move the code into ksz_setup().
> 
> With a D in DSA setup, dsa_switch_register() adds the switch to the
> list of switches, and then a check is performed to see if all switches
> in the cluster have been registered. If not, it just returns. If all
> switches have been registered, it then iterates over all the switches
> can calls dsa_switch_ops.setup().
> 
> By moving the start of the MIB counter into setup(), it will only be
> started once all the switches are present, and it means you don't need
> to look at DSA core internal state.

+1

Also there's a bug in its own right in ksz_mib_read_work(), here:

			if (!netif_carrier_ok(dp->slave))
				mib->cnt_ptr = dev->info->reg_mib_cnt;

The code accesses dp->slave, so naturally it kicks the bucket for
cascade ports.

It doesn't crash with CPU ports because dp->slave is in a union with
dp->master, which is also a struct net_device * with its own carrier:

struct dsa_port {
	/* A CPU port is physically connected to a master device.
	 * A user port exposed to userspace has a slave device.
	 */
	union {
		struct net_device *master;
		struct net_device *slave;
	};

This needs to be fixed, since accessing the DSA master through a
dp->slave pointer is dangerous and unintended.

Easiest thing to do would be to only check link state if (dsa_port_is_user(dp)).
For other ports always read all MIB counters.
