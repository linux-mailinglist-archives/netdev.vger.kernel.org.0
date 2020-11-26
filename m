Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A4A2C5674
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389769AbgKZNuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388331AbgKZNuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:50:07 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9010C0613D4;
        Thu, 26 Nov 2020 05:50:07 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id gj5so3007772ejb.8;
        Thu, 26 Nov 2020 05:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Au9jO1brenTUNmfurtsLw99ldLx7tyWqwvCB6Mj1r+4=;
        b=IejSREL7FzS0DHrd1huLkHojrGp49eZgIXq2lSG6V33EYAafg5e6vStVRhMvT9Kkbh
         knmKpR+OQdl7kLz+PKV9k3QfUNlZb/S/iFMXLlkX6Mv9RWM56HSbggf2dMn3Y9h4SrbB
         BFLsKYtO/r+hAEquM5Pazktn7KMTzDMtqNUBFyN0ayCmcjE4c2JBM/UQNqQ0O7QQlzxP
         RaWHzFgDxzmG/GlZJuuehhYQz42wDumALLlGnYOpSyTZ38qwMuY+9a/1Q34FLoP1Y5fh
         yB3Zc/xu/NDxRZWGgMd074MMjLgXiHW6Kb71LyS6V2WlUWvQh1VNHJrjdVr7uRk/k9dC
         2U7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Au9jO1brenTUNmfurtsLw99ldLx7tyWqwvCB6Mj1r+4=;
        b=E49li/2QNUhRTPML+Mz8PryBNVoRye1igdE5qKf5NkUN9fIN0qE0KIqjx8Eck/zlld
         +8HOdfSWuA4uU8j7O75yi+yeKWMjI5/+imGdaMOVVmYM/H9K29MDU4wCRF6ExS7EQ4zM
         Ut7W5Pwpre9SejXpfw5ThsVrQOTDqN8UVVWDV4DrB0K8iAxJROop3l0m7lvrwo/h7cBq
         vmWgjn6IijjKvLT2TD9FZD5FTufBi3goMuP9ejsOyKNTvKpAPwm1lWSEoqLuppaFOy3F
         85CHs1z2Zr4An5Yyk+yMp3IaCQ8BnoOvN3mIPo7chHMMuC5FjmZKHHaFzPaZEIDkOZM+
         dy/Q==
X-Gm-Message-State: AOAM532Iq6FJNLpSG/or4h7tcw3RgloYDIphx4G071BOoZ2wiDFdPkCW
        /mG8gxwjf6GBVFvE12bAZaPk/aUpP+8=
X-Google-Smtp-Source: ABdhPJxW8VBQeRuZMkxMdnfmWP+3/BNbY2kMbIBhRHKctmwxIzQ7Sbe+RxnbflnfRfPluCqqr+tSww==
X-Received: by 2002:a17:906:f8c5:: with SMTP id lh5mr2721714ejb.77.1606398606535;
        Thu, 26 Nov 2020 05:50:06 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id z29sm3241441edi.1.2020.11.26.05.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:50:06 -0800 (PST)
Date:   Thu, 26 Nov 2020 15:50:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/3] dsa: add support for Arrow XRS700x tag
 trailer
Message-ID: <20201126135004.aq2lruz5kxptmsvl@skbuf>
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-2-george.mccollister@gmail.com>
 <20201125203429.GF2073444@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125203429.GF2073444@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 09:34:29PM +0100, Andrew Lunn wrote:
> > +static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
> > +				   struct packet_type *pt)
> > +{
> > +	int source_port;
> > +	u8 *trailer;
> > +
> > +	if (skb_linearize(skb))
> > +		return NULL;
>
> Something for Vladimir:
>
> Could this linearise be moved into the core, depending on the
> tail_tag?

Honestly I believe that the skb_linearize is not needed at all. It is
copy-pasted from tag_trailer.c, a driver that has not exercised at
runtime by anybody for a long time now. The pskb_trim_rcsum function
used for removing the tail tag should do the right thing even with
fragmented packets.

> > +	if (pskb_trim_rcsum(skb, skb->len - 1))
> > +		return NULL;
>
> And the overhead is also in dsa_devlink_ops, so maybe this can be
> moved as well?

Sorry, I don't understand this comment.
