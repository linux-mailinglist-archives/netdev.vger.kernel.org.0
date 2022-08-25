Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABC95A1CB1
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243595AbiHYWrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243576AbiHYWra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:47:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2EBC6B71
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:47:28 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z8so149754edb.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 15:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=xPrb+yONtKkYTwRPkY54tjflhpeDfiaSLhUEiqh7VoY=;
        b=Iho3wOmk2YbnySN1Px+D45pplFYtuUZsdWiMf9Y2caZiIh9+BpW5Vwpxb4VMmRACT3
         BRI2aahClUBljCNa6BA2ikbEyyqEwhI0BXNfjnvh5lSHSqJZHLl4Ed4EIi1mj1qr2WUM
         V1uXgxitG50tPmhQroU9KgiDV3bVcrgBA4Afh8KKZ7I6OzgzH9gfq2Nj7XTaR1R3tBGR
         okGzDWXURO35mT1i+k+OJ4boxFXd4kIkjazbtRUOQ55c0Gzm1x1kij48JF/NTBHB0Aek
         XBg9lJh+n74Sqws8XcgtF2zWzBxe8Iw7DwlHos5jz8vyn8IYEi+RFVHQ6QoAj0ZDJ1c/
         nN4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=xPrb+yONtKkYTwRPkY54tjflhpeDfiaSLhUEiqh7VoY=;
        b=6xyiJHEliOGmzbq8fyoOlHWi1qF+aMuQvSwd1wXyh7svfsc00pnnSE+jzahxlETr4W
         dSU9C2CJJhMn57jbskNbxG3QnCBomu0xWX0ZCV4W8DRJanwgVRfocobspiNCdcdOVQB/
         FNL+68jRTrx7CIxyoLWgtM/SrTxxP/vdkZi1rd7guLKfVqVqU9TIpX96HXQ+A+rAYEGX
         M1ki5ffuBu6kj+ZiCruH5P0kz+i+d+JKSd+MCER3mhxqIHuxOeOX0nqWKrJU+pnOWHw2
         H/iJxC8Annrvtu8Ny6K16PdBIqoHnCSYcOSRCxsaER6Q7FK9umfytNqBbi/LpDMlvOdU
         q0Kg==
X-Gm-Message-State: ACgBeo1jHIcRFiqKajgcSjrOktFgyHs2YBt609DwjzetZ6fOkOFnsHlR
        IGkA36MHykbwVL+j/ogaZvY=
X-Google-Smtp-Source: AA6agR5XEsUbTLx1F4DXkMbTKV34bYnjplH4u6J10PP/l27wOKIaYAec4PqEqa03y7eO+2bfscu1mQ==
X-Received: by 2002:aa7:d90e:0:b0:447:986d:b71e with SMTP id a14-20020aa7d90e000000b00447986db71emr4691963edr.235.1661467647449;
        Thu, 25 Aug 2022 15:47:27 -0700 (PDT)
Received: from skbuf ([188.27.185.241])
        by smtp.gmail.com with ESMTPSA id lo23-20020a170906fa1700b006fec4ee28d0sm148250ejb.189.2022.08.25.15.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 15:47:26 -0700 (PDT)
Date:   Fri, 26 Aug 2022 01:47:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: Re: [patch net-next 6/7] net: dsa: don't do devlink port setup early
Message-ID: <20220825224724.nwnczlksk3bgg3v3@skbuf>
References: <20220825103400.1356995-1-jiri@resnulli.us>
 <20220825103400.1356995-7-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825103400.1356995-7-jiri@resnulli.us>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 12:33:59PM +0200, Jiri Pirko wrote:
> Note there is no longer needed to reinit port as unused if
> dsa_port_setup() fails, as it unregisters the devlink port instance on
> the error path.
> @@ -957,8 +941,6 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
>  	dsa_switch_unregister_notifier(ds);
>  
>  	if (ds->devlink) {
> -		dsa_switch_for_each_port(dp, ds)
> -			dsa_port_devlink_teardown(dp);
>  		devlink_free(ds->devlink);
>  		ds->devlink = NULL;
>  	}
> @@ -1010,11 +992,8 @@ static int dsa_tree_setup_ports(struct dsa_switch_tree *dst)
>  	list_for_each_entry(dp, &dst->ports, list) {
>  		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
>  			err = dsa_port_setup(dp);
> -			if (err) {
> -				err = dsa_port_reinit_as_unused(dp);
> -				if (err)
> -					goto teardown;
> -			}
> +			if (err)
> +				goto teardown;
>  		}
>  	}

Please don't delete this, there is still a need.

First of all, dsa_port_setup() for user ports must not fail the probing
of the switch - see commit 86f8b1c01a0a ("net: dsa: Do not make user
port errors fatal").

Also, DSA exposes devlink regions for unused ports too - those have the
{DSA_PORT_TYPE,DEVLINK_PORT_FLAVOUR}_UNUSED flavor.

I also see some weird behavior when I intentionally break the probing of
some ports, but I haven't debugged to see exactly why, and it's likely
I won't have time to debug this week.
