Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E32F3157D7
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhBIUkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbhBIUd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:33:58 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C219C0698C6;
        Tue,  9 Feb 2021 12:20:49 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y18so25566246edw.13;
        Tue, 09 Feb 2021 12:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OJBJZoWtqasITVYW+Sh00YF0phZ4lq1R3a/gcaU0ls4=;
        b=o/AxlQl0i/wUD4989dM3BQ9Gi/UH+Je6cbHNhA84lwvzRqeUwuhW4S4haRyZI0GgPd
         Ej/r7H/wM6R3hOXnDtJJF14SNOLs40Wvo4qGFTwwD4QlpUsFij206pVp+GJb4kxAsY3F
         z65T8HrcYQbcL8vFhr2HcbobpEEWPUvqncsAmlpky62S2x5+q3vCbm2JTJId8ZDe3J8n
         VrW5z3qLoSpLdUyM43J9QjBj6MqZJ7WdU6UztgN2EideHqQQZevsC6BV7EoRN6w051Hr
         G2lyfCoI3UgEmrYW+DhPm9tOlmz3duWY6/FQFMvZd6sjKzVuJ0rn7BFROqc83Ob/Wvtd
         hRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OJBJZoWtqasITVYW+Sh00YF0phZ4lq1R3a/gcaU0ls4=;
        b=hboDIpr1xEDoRJI8vKesysCEHxlZ2mA8OWGIS7/Y4dLxD20cEWssq++tvtjE9eQFOE
         1dEQNgbpoTTWHjmla2I6ipRzaMuwzNP+3h8DWBwZSdZha7GvzQNhhdbfKk1xaaBRN5cs
         gS7rrsbRqexZe7eu7aU4Ebi9VEmREeUO4D3eaedFjBkFeXCWIZcbrZBxwDBSDV1Ynd/2
         6juWbk5FkIyBN4xvuOZO/uAg48eQ3mfVLJvv5yacAJ74PnNjVdL7nsKrqO02+5tVjKxo
         +LGZj2dNuM53cBlJKrNHatwhuMKP2G6kQi24Sj3cXkfFgu1iPJ09dfqN9hAimaDfx/DZ
         2z6w==
X-Gm-Message-State: AOAM532AYppR1xhJ4m/+VBfSrfdfPrqCM7a3SWdCLbWZr1A0Ry1Ph3lj
        DY3/Uojv1mAcLK3G9LpdPOY=
X-Google-Smtp-Source: ABdhPJwJtHUiJJW8tLUk73YO+ec8lbnMpR7egGqbTCfnV7RroIzrPKEhDhjC2bnmohYOtx/S8OFm6A==
X-Received: by 2002:a50:cd8c:: with SMTP id p12mr25052831edi.114.1612902048344;
        Tue, 09 Feb 2021 12:20:48 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q14sm12228756edw.52.2021.02.09.12.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 12:20:47 -0800 (PST)
Date:   Tue, 9 Feb 2021 22:20:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/11] net: bridge: offload initial and final
 port flags through switchdev
Message-ID: <20210209202045.obayorcud4fg2qqb@skbuf>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-5-olteanv@gmail.com>
 <20210209185100.GA266253@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209185100.GA266253@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 08:51:00PM +0200, Ido Schimmel wrote:
> On Tue, Feb 09, 2021 at 05:19:29PM +0200, Vladimir Oltean wrote:
> > So switchdev drivers operating in standalone mode should disable address
> > learning. As a matter of practicality, we can reduce code duplication in
> > drivers by having the bridge notify through switchdev of the initial and
> > final brport flags. Then, drivers can simply start up hardcoded for no
> > address learning (similar to how they already start up hardcoded for no
> > forwarding), then they only need to listen for
> > SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and their job is basically done, no
> > need for special cases when the port joins or leaves the bridge etc.
> 
> How are you handling the case where a port leaves a LAG that is linked
> to a bridge? In this case the port becomes a standalone port, but will
> not get this notification.

Apparently the answer to that question is "I delete the code that makes
this use case work", how smart of me. Thanks.

Unless you have any idea how I could move the logic into the bridge, I
guess I'm stuck with DSA and all the other switchdev drivers having this
forest of corner cases to deal with. At least I can add a comment so I'm
not tempted to delete it next time.
