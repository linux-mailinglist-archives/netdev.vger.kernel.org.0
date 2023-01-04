Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC30865DB4C
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbjADRdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:33:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235439AbjADRc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:32:58 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE201AA07;
        Wed,  4 Jan 2023 09:32:57 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id tz12so84373457ejc.9;
        Wed, 04 Jan 2023 09:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MEegHzGTQTeTa1NUIepj4R3JBIHY1olyOe+oTPFcWR8=;
        b=UEeSJjGPFJrjKKpusUDJdN1P9nuCL4nm4TB99LM7ucYWow3oP/OyZCO4R+AvSm2vDv
         VZYTsrLTXkauuWXnLie470POs0Ql0p1omob5Ou6iv3Mnl3BRXlaAMczETEhw+pE9ljo1
         SHWUk9kfJ0rFEZWgwMOA+tcvmBavL7RjqiPA6Cp6aH6B1MGakbPj7Z9JqQFb/Ngifz3C
         AdxhGp+xgMXHEqqNDIU6Td/k292e5ztnHTqYfwusI6S7C1Ssu6U91se0d68YJfYFwb0S
         JiLIi348x149+te5Vu5dJHN8iG1gN0swrf8s5Fx+aO8ldV6ldDWP6coDe4YMDTllDbDW
         wghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MEegHzGTQTeTa1NUIepj4R3JBIHY1olyOe+oTPFcWR8=;
        b=NiVD1Plc3ZwMMG8Ag9Tz6+lDo2+43LzMd00J/t2bKqgIVCIeYyxzl+FhZZBuwsREC4
         AEwo4FyRe27C5Gw8rZFDYphLksfWW2+2m01CR2FEUZuNM3K4q/sdIn87hHiDzUbSV8oF
         YGnjXe9f26yOMZA8n5fSaXlHo6UH1s+z2VqrELJxjl29htUcMaUBR/z4Zh0d+4Lbk/da
         lSMpy9wNjgVoiyb2luHSp5EbqOF+MjwEQ3OVn2b4FLEvznBRr+YcgLpWj7ABKviFqPZT
         BQbnVdOEBL/hwGjeYBGu98FV4IACHeQLszUAo972C7BOUWG7i05WZWB44osL6cXXbHkZ
         DvDg==
X-Gm-Message-State: AFqh2koXZcKR1kTmMk2uq9gEJhRycJ2dF6/j9+S3o53wo2prexX6FRae
        2Nv0bHAapYgvC7fxptOnrtQ=
X-Google-Smtp-Source: AMrXdXsh2etwUVakYyUdLmkNHEbZayYU/QZf8Fb6zvQ1thqBc5rmTe7M6zeOGVU3GS+4x020mrptAQ==
X-Received: by 2002:a17:906:3ec8:b0:846:cdd9:d23 with SMTP id d8-20020a1709063ec800b00846cdd90d23mr38536318ejj.19.1672853575691;
        Wed, 04 Jan 2023 09:32:55 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id l12-20020a17090615cc00b007c0cd272a06sm15490891ejd.225.2023.01.04.09.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:32:55 -0800 (PST)
Date:   Wed, 4 Jan 2023 19:32:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Hans J. Schultz" <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/3] net: dsa: mv88e6xxx: disable hold of
 chip lock for handling
Message-ID: <20230104173253.77wa6kmi4fzglc6v@skbuf>
References: <20230104130603.1624945-1-netdev@kapio-technology.com>
 <20230104130603.1624945-1-netdev@kapio-technology.com>
 <20230104130603.1624945-3-netdev@kapio-technology.com>
 <20230104130603.1624945-3-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104130603.1624945-3-netdev@kapio-technology.com>
 <20230104130603.1624945-3-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 02:06:02PM +0100, Hans J. Schultz wrote:
> As functions called under the interrupt handler will need to take the
> netlink lock, we need to release the chip lock before calling those
> functions as otherwise double lock deadlocks will occur as userspace
> calls towards the driver often take the netlink lock and then the
> chip lock.
> 
> The deadlock would look like:
> 
> Interrupt handler: chip lock taken, but cannot take netlink lock as
>                    userspace config call has netlink lock.
> Userspace config: netlink lock taken, but cannot take chip lock as
>                    the interrupt handler has the chip lock.

Ultimately, none of this explanation is really relevant, and it requires
too much prior reviewer knowledge. I would phrase the commit title as
"shorten the locked section in mv88e6xxx_g1_atu_prob_irq_thread_fn()"
and say, as an explanation, that only the hardware access functions (up
until the call to mv88e6xxx_g1_atu_mac_read()) require the register lock.
The follow-up code, which processes the ATU violation data, can run
unlocked, and in a future patch will even run from a context which is
incompatible with the register lock being held. If you wish, you can
mention here as a small note that the incompatible context comes from an
AB/BA ordering inversion with rtnl_lock().

> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  drivers/net/dsa/mv88e6xxx/global1_atu.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> index 61ae2d61e25c..34203e112eef 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
> @@ -409,11 +409,11 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  
>  	err = mv88e6xxx_g1_read_atu_violation(chip);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
>  
>  	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &val);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
>  
>  	err = mv88e6xxx_g1_atu_fid_read(chip, &fid);

If mv88e6xxx_g1_atu_fid_read() fails, it will goto out, which will exit
the IRQ handler with the mv88e6xxx_reg_lock() still held.

Probably not a good idea, since the driver will access the registers
again in the future (errors in IRQ handlers aren't propagated anywhere),
and the user might need a computer which is not deadlocked.

>  	if (err)
> @@ -421,11 +421,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  
>  	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
>  
>  	err = mv88e6xxx_g1_atu_mac_read(chip, &entry);
>  	if (err)
> -		goto out;
> +		goto out_unlock;
> +
> +	mv88e6xxx_reg_unlock(chip);
>  
>  	spid = entry.state;
>  
> @@ -449,13 +451,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>  						   fid);
>  		chip->ports[spid].atu_full_violation++;
>  	}
> -	mv88e6xxx_reg_unlock(chip);
>  
>  	return IRQ_HANDLED;
>  
> -out:
> +out_unlock:
>  	mv88e6xxx_reg_unlock(chip);
>  
> +out:
>  	dev_err(chip->dev, "ATU problem: error %d while handling interrupt\n",
>  		err);
>  	return IRQ_HANDLED;
> -- 
> 2.34.1
> 

