Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3F9315668
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 20:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhBIS5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbhBIStY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 13:49:24 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1F2C061756;
        Tue,  9 Feb 2021 10:36:40 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b9so33306293ejy.12;
        Tue, 09 Feb 2021 10:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h5l91mm4OgKaf6t4atmXs6oRTo1mGTbQpbu5LCCZIuM=;
        b=PH/c8cc/nyi8SJ24Y6mtv07Cd3UG37HbaCBZFb/gGuIRXMEUpKHmM+2ZUOmF2+nqL9
         9fP2aFSMimwDJ/NO/IJ32fpVaI6KGoscHBMhYZlu/5HDW4stPD0ZoRDcjJ4r3RQCpQsl
         B2Lo76Uupeums/vpHZj1sNYxQyk/Bcp3sb0SLdAcfOXv1PppGyWsE4WqyVJV4FTIu8ST
         qPHdOEJrlLS4mFyXBzjhmThK1mXDcyUEPVPzNmKCBM54ip5fAiecL0pr0Gh6mopToQ6h
         oc3pr+iC3sOvR8LKjxp/EzHVdnrNZpvTAA66NVbpFmesm0FtAvCy+2WUP7htpdG49wUy
         qZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h5l91mm4OgKaf6t4atmXs6oRTo1mGTbQpbu5LCCZIuM=;
        b=hoML8Twd/QSkqK3RA8NFuvNnXAnEXbBBBkvxVQfDzXjHMHVCWYqw2wPJznhxw1mQmx
         OfbJpgAtFTxmPiQd1Ll15xtQPul0hvu5ri6/gSOqLPK4mFG4rpNgIEHroqQdxO9a4M+9
         SKrPRRslioxoLMp+mfy2awKkzvEzEaFBcH7htmqwS4RBYLab7Waxkn5ANBuu0ize0nG7
         k8Jn/KLguiUbVkfzhwZI7+HlgNNu5NCNIslsbzMAlw1CEZ7U7//czzvFhcZjkT+bg06R
         uS7yzQpeG2J8YXSPq94B2d7NEq2+xKdPU8ngzIdlr9tWxn9gugTXlp76RYz144XO+uJn
         1owg==
X-Gm-Message-State: AOAM533bTwY267pIfMP0TwIrMevGXqmP9WcaAj+IDnUEJMgMayqrlDT2
        c7bztr/Yr3ngnjRwmtZXOWs=
X-Google-Smtp-Source: ABdhPJyoe3o/Na0RHyb9qfjkzfhKzq1xxSdMlcvobWLsw4nkDyluOrrgDInbafWA2lB0jkXYy2Os2Q==
X-Received: by 2002:a17:906:2ccb:: with SMTP id r11mr24291107ejr.39.1612895798802;
        Tue, 09 Feb 2021 10:36:38 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p32sm5666584edd.96.2021.02.09.10.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 10:36:37 -0800 (PST)
Date:   Tue, 9 Feb 2021 20:36:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 02/11] net: bridge: offload all port flags at
 once in br_setport
Message-ID: <20210209183636.l5h4zyknk5q4kvgl@skbuf>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-3-olteanv@gmail.com>
 <20210209182724.b4funpoqh6kgoj6z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209182724.b4funpoqh6kgoj6z@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 08:27:24PM +0200, Vladimir Oltean wrote:
> But there's an interesting side effect of allowing
> br_switchdev_set_port_flag to run concurrently (notifier call chains use
> a rw_semaphore and only take the read side). Basically now drivers that
> cache the brport flags in their entirety are broken, because there isn't
> any guarantee that bits outside the mask are valid any longer (we can
> even enforce that by masking the flags with the mask when notifying
> them). They would need to do the same trick of updating just the masked
> part of their cached flags. Except for the fact that they would need
> some sort of spinlock too, I don't think that the basic bitwise
> operations are atomic or anything like that. I'm a bit reluctant to add
> a spinlock in prestera, rocker, mlxsw just for this purpose. What do you
> think?

My take on things is that I can change those drivers to do what ocelot
and sja1105 do, which is to just have some bool values like this:

	if (flags.mask & BR_LEARNING)
		ocelot_port->learn_ena = !!(flags.val & BR_LEARNING);

which eliminates concurrency to the shared unsigned long brport_flags
variable. No locking, no complications.
