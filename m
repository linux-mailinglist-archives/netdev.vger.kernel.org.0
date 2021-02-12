Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C1A319B4D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 09:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhBLIgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 03:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhBLIgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 03:36:51 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59309C061574;
        Fri, 12 Feb 2021 00:36:10 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id bl23so14253996ejb.5;
        Fri, 12 Feb 2021 00:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ezkeluSd4BagWsILaf5/hUzcBicqZlpvmIkdsGSPDRo=;
        b=at4BigjysdRTlvmAHpGvKMJOJyedyTJmIQVo3VlJXyd8c55IC1lqPE1agEyURsnTix
         A/8NnmTmCO4a+Hh8fSs+cSQnMEtM3iviPtUHmSpf10z2YyJQdxYuzrG07CwK9GkXoZ9V
         uB/0W8OLbrh3RjKaHWLIDBaNz/v2YBUINgodO3/Vy6Qz2eFoQ9+CKU1OBhahM20tESVG
         GF74+8TVi1J71NzdSiTR+C3ksWnL6DYbx9oJkTZoae4bSsAdkYhnnM29ghemS2SNdsT9
         //7MzaTi5ht9BMOnTiIqt59NH3ez7SXUkX+nwwei/hxh3ieT7B4ABZHND5N3lgRZLLH6
         xj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ezkeluSd4BagWsILaf5/hUzcBicqZlpvmIkdsGSPDRo=;
        b=UIBFKHP7IkJ8QqqWxWHGIF20MNN2kVw2gHCwqu+s8qodX2hvCmWUBtMxXiInVPzE2S
         WJDJMA4sS0rmqdEnKUmiJpx75faoVckiNJNRsF4TXQ3jT6ahOKaSYy8m/ln49bVUvs3M
         KZmfuCADwJ6Xfn5zcMZwz8qncHaXJfPfMyvEJ6MvdGYBYSi11lS6o2xjTVRDv6qnKzDf
         N+hu95XfhGmfjhNaIs31CQBhL9jLEq1GR/JmWekL3f/BvxqYvpsd8QDh+Gkl3HltVFa1
         WRuWfLboqSbQ3UCS7jbZBgKUeUpOQKGOOU69/uJF98hxwzpGShZ2mPp9PNM+a64EQuPJ
         9J+w==
X-Gm-Message-State: AOAM5326WD2FzDjhkDKcIx2radSUix19swpHMHaGeVcj+fx4JJkMIJxt
        riPAf6bQ9bIOho5eNC1D7O8=
X-Google-Smtp-Source: ABdhPJy/HltcIda+pT8wJyJl+7I+N7SBnqR6xSW2Hl3W57Qa0EfEmJya9dDHfQXYJgqT5EQ5FAtrsw==
X-Received: by 2002:a17:906:2993:: with SMTP id x19mr1840796eje.409.1613118968909;
        Fri, 12 Feb 2021 00:36:08 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m10sm5688975edi.54.2021.02.12.00.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 00:36:08 -0800 (PST)
Date:   Fri, 12 Feb 2021 10:36:06 +0200
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
Subject: Re: [PATCH v4 net-next 6/9] net: dsa: act as ass passthrough for
 bridge port flags
Message-ID: <20210212083606.by43rrib65uuxxlu@skbuf>
References: <20210212010531.2722925-1-olteanv@gmail.com>
 <20210212010531.2722925-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212010531.2722925-7-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 03:05:28AM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There are multiple ways in which a PORT_BRIDGE_FLAGS attribute can be
> expressed by the bridge through switchdev, and not all of them can be
> emulated by DSA mid-layer API at the same time.

Oops, odd typo in the commit title. I only remember something was not
right, I had noticed the "as" word was missing so I added it, but I
apparently did not notice why it was missing...
