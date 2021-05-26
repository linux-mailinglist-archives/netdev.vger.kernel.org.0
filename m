Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3260B391C3A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhEZPmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhEZPmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:42:39 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D58C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:41:06 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id b9so3132578ejc.13
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2XUw8q2SkfBAzYXqenQpuZK/WYD7ZXQuDS0AZSxjSqA=;
        b=KLgIz1CyB1gdUyQbB02x7FSN6UDJYk7jDjrswt+WYAMMnWO8Q8/PnMp0eCqyiEc/ED
         6y39ofXO7rjW2LFhJaNZlkLYMaUnKfJ1AoeZtUj6cA8OxaAt0Pus/rnCznIqaVzNS3XF
         flh7Shw+KHas699wSQPdr7+kIal2O2vzFGlt2PSDVTltYPkeFBH2M3jXwGkkap1mmSXi
         lFQOgfC87lmCDTC94qqOE08YGV7wKjdtkMYV81EbaZRdTxZzUi5sKHGl3zLgMS+QIZp5
         YA58w4rXnFnts50ZYUxUEs/2dNZMjJOXwK9e8lvj4EYAIUNnzyZ8wQLkVScFXzNEf9Pm
         wyoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2XUw8q2SkfBAzYXqenQpuZK/WYD7ZXQuDS0AZSxjSqA=;
        b=uNrvfVxs9dD9Ov72ffY7dRnmWkLuMLXv7kfBxmYlqV5DcvMYtwlW/vzEPHKuzoN/CN
         7V4C264qSHRl6SI1cBgKdc7R5tpv4INxtww93ZDeyT6omkzUF5+PsfrCJ9hUzL2qsHde
         wHHLmP78+WN7c6xy3xjrPE32oI1Rmgaz/zXiNQ9bKTHvy4NKPouW9Hr9nugFD6qcz8yJ
         JeqTetKtEchQ4eWusUYnzwsHXeGwlpeftZm6+3R5D9uLJvF9SJ7cVkZST33Cfatu4VoZ
         qhPjxA4JLQKoJ1gO/tMRXJ9c200fjSzwKOmegvtkDViJW3wGQWGLuungWVFHTOvZ61MF
         s8Cw==
X-Gm-Message-State: AOAM532fZYTx7kUXcWfi6qCeZX1WFo9a/V08gRVarJXPWdk6xXxnzObg
        PoV0cTYUistuwcHtpXvSysc=
X-Google-Smtp-Source: ABdhPJxOieqPAmYB9wHdlCKGCpAiBcX3lEfvfWMGCHf0attFFM84BgjnSWSp35cHu7kNvklvJ80DZg==
X-Received: by 2002:a17:906:b14f:: with SMTP id bt15mr35533554ejb.126.1622043664850;
        Wed, 26 May 2021 08:41:04 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id qx18sm10540061ejb.113.2021.05.26.08.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 08:41:03 -0700 (PDT)
Date:   Wed, 26 May 2021 18:41:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH v2 linux-next 13/14] net: dsa: sja1105: expose the
 SGMII PCS as an mdio_device
Message-ID: <20210526154102.dlp2clwqncadna2v@skbuf>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
 <20210526135535.2515123-14-vladimir.oltean@nxp.com>
 <20210526152911.GH30436@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526152911.GH30436@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 04:29:11PM +0100, Russell King (Oracle) wrote:
> On Wed, May 26, 2021 at 04:55:34PM +0300, Vladimir Oltean wrote:
> > Since we touch all PCS accessors again, now it is a good time to check
> > for error codes from the hardware access as well. We can't propagate the
> > errors very far due to phylink returning void for mac_config and
> > mac_link_up, but at least we print them to the console.
> 
> phylink doesn't have much option on what it could do if we error out at
> those points - I suppose we could print a non-specific error and then
> lock-out the interface in a similar way that phylib does, but to me that
> seems really unfriendly if you're remotely accessing a box and the error
> is intermittent.

I would like to have intermittent errors at this level logged, because
to me they would be quite unexpected and I would like to have some rope
to pull while debugging - an error code, something.

If there's an error of any sort, the interface won't be fully
initialized anyway, so not functional.

The reason why I added error checking in this patch is because I was
working on the MDIO bus accessors and I wanted to make sure that the
errors returned there are propagated somewhere.
