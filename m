Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6239D642650
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 11:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiLEKD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 05:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiLEKDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 05:03:54 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A992DE0A2;
        Mon,  5 Dec 2022 02:03:52 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id x22so4095837ejs.11;
        Mon, 05 Dec 2022 02:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fNuRqjS+ZUBnQZsQtw9JGsG30vnh+eH9L7Kxk3ae9cU=;
        b=N/lgNQNxbBaFWvzq+/n1/EEjJXSaUDWB8X0hkrj5h373512rRZ8YM9l5iTZxjT5Ob9
         KgkB170/270CKUD/DYA/xZ44O8usdVWs+vb8pc98IjlSSRnQMzSWPiu4GgrDQGPM+jDJ
         eCnOZub3wwWIJbMkLfjzCy/VWDo+meNe16yQmH2+o6KKAy+dpOkUUtWwHlBieizoQE8b
         nXcxv5a4jRyHnwaobLH+5Hz6enlO2VRoT1xrDy91V5g2+o65JjO74ZxEOxaTyPQ07+I1
         7O59lmegW9XUkuZWxaPxkXOf8s2SYNAodXrn34eMpWgPmB8WIMZLvyv42HAxML+o26Tf
         Tz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fNuRqjS+ZUBnQZsQtw9JGsG30vnh+eH9L7Kxk3ae9cU=;
        b=fMmWr4PSoxik9nNAS0qWz363I5WvZnMGv/91xgc9ImJccum7fWtMmUVA3gTb3RvZdJ
         ES7P7F1koi8QkaE1EVQvqp6+7Y0AzAlIwn1J7hKL+E0sbe30I9dpTTbOi3U3RFtDLX+0
         ZigjT8t3ej4asjzXLk508CQN6r/ZhTwEVFXuOfJ0wBbGXQzB+IwpOPEqZqVpxzyC5FZG
         s+Lp4gOSfzZJNIX6WyoVVgg5VlYo7O+xtZ73eG8K+VHNpj1HsrnlSklrXjevHL2alLae
         SUmC8zjK23NqE1D5tBSosWhgcmVDFefgqb5z+OOvyjMxTpHt+GpAVin4VLP/PLSx7c4z
         EHVw==
X-Gm-Message-State: ANoB5pn0RPdMSaomiYJIxEDghfGJk8Qqom5h8nJAWfwTOlRGOg9JFjMj
        Ty5ykb46R+J8FeZvZxuqy0A=
X-Google-Smtp-Source: AA0mqf7P7yXlrDkh2Q4jQUFJfLcktNpSvWFwFpCzxv8Qmnke4yB07obT5Zs1utSp18kqB8j/9RV9qQ==
X-Received: by 2002:a17:906:2e83:b0:78d:b3f0:b5c0 with SMTP id o3-20020a1709062e8300b0078db3f0b5c0mr71533164eji.141.1670234631152;
        Mon, 05 Dec 2022 02:03:51 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id r1-20020a1709061ba100b00779a605c777sm6041797ejg.192.2022.12.05.02.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 02:03:50 -0800 (PST)
Date:   Mon, 5 Dec 2022 11:03:58 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y43CDqAjvlAfLK1v@gvm01>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
 <20221205060057.GA10297@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205060057.GA10297@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oleksij, and thank you for your review!
Please see my comments below.

On Mon, Dec 05, 2022 at 07:00:57AM +0100, Oleksij Rempel wrote:
> > diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> > index aaf7c6963d61..81e3d7b42d0f 100644
> > --- a/include/uapi/linux/ethtool_netlink.h
> > +++ b/include/uapi/linux/ethtool_netlink.h
> > @@ -51,6 +51,9 @@ enum {
> >  	ETHTOOL_MSG_MODULE_SET,
> >  	ETHTOOL_MSG_PSE_GET,
> >  	ETHTOOL_MSG_PSE_SET,
> > +	ETHTOOL_MSG_PLCA_GET_CFG,
> > +	ETHTOOL_MSG_PLCA_SET_CFG,
> > +	ETHTOOL_MSG_PLCA_GET_STATUS,
> >  
> >  	/* add new constants above here */
> >  	__ETHTOOL_MSG_USER_CNT,
> > @@ -97,6 +100,9 @@ enum {
> >  	ETHTOOL_MSG_MODULE_GET_REPLY,
> >  	ETHTOOL_MSG_MODULE_NTF,
> >  	ETHTOOL_MSG_PSE_GET_REPLY,
> > +	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
> > +	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
> > +	ETHTOOL_MSG_PLCA_NTF,
> >  
> >  	/* add new constants above here */
> >  	__ETHTOOL_MSG_KERNEL_CNT,
> > @@ -880,6 +886,25 @@ enum {
> >  	ETHTOOL_A_PSE_MAX = (__ETHTOOL_A_PSE_CNT - 1)
> >  };
> >  
> > +/* PLCA */
> > +
> 
> Please use names used in the specification as close as possible and
> document in comments real specification names.
I was actually following the names in the OPEN Alliance SIG
specifications which I referenced. Additionally, the OPEN names are more
similar to those that you can find in Clause 147. As I was trying to
explain in other threads, the names in Clause 30 were sort of a workaround
because we were not allowed to add registers in Clause 45.

I can change the names if you really want to, but I'm inclined to keep
it simple and "user-friendly". People using this technology are more
used to these names, and they totally ignore Clause 30.

Please, let me know what you think.

> > +
> > +	/* add new constants above here */
> > +	__ETHTOOL_A_PLCA_CNT,
> > +	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
> > +};
> 
> Should we have access to 30.16.1.2.2 acPLCAReset in user space?
I omitted that parameter on purpose. The reason is that again, we were
"forced" to do this in IEEE802.3cg, but it was a poor choice. I
understand purity of the specifications, but in the real-world where
PLCA is implemented in the PHY, resetting the PLCA layer independently
of the PCS/PMA is all but a good idea: it does more harm than good. As a
matter of fact, PHY vendors typically map the PLCA reset bit to the PHY
soft reset bit, or at least to the PCS reset bit.

I'm inclined to keep this as-is and see in the future if and why someone
would need this feature. What you think?

Thanks,
Piergiorgio
