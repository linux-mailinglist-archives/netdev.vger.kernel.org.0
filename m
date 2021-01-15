Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B282F7E60
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbhAOOhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbhAOOhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:37:33 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD77C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:36:52 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id r12so2239230ejb.9
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4iuWlaSTknRDH9Jbx1b5JQ/w8x3dN2CKguk801qy7nw=;
        b=E72w2PNhsOY+1pc7VIzZvxc9KYslsn9V7ITOIOgqJXOBlYwE18MqzcdL1BzzTVetif
         WfkaYO+ExSGs+JxjQMABawlyyTHOlK0auxkBwBzFi19QvilptoD/YofcVlZuGdppBOZ/
         BzMPmY3Oar1McTJpxJPZjzXdxoPERdDnELz/nAoDxXXlvpLGJgnRtrcD2JdCH3EA4zwD
         9S2/+6EF36mQlbNNZ2so69sWX+VlyXh6XC9Zl0qt8dQGUC8eDAqWpBiNtCb0rkIDdfc9
         FJS3AqXb32jzMKqUzTGL8MQziShX/m5dOpQOEc6K18fsQ4Ip1i5pDURni+Db5FHdeAzE
         bVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4iuWlaSTknRDH9Jbx1b5JQ/w8x3dN2CKguk801qy7nw=;
        b=SvjMpRhGTJmTvbx7atK5eL0J6wcSpCUMVoxWdDWhTRAhRuzYdJqZgK4SeCFoNqZvfI
         AGkTp6ZHbs8g7IpGmPVzz9IZ+r4qBGChrphTNQGVENwWQ9tMsbTdGZiu+J962TU+ArYA
         zNuBy21G1hxgI17EVQm6rDblmal1Oi0Vrubd7Sc9J4niVOQZYF/j7S8CB/LZDkbyrUa9
         z913Q7T6BIz7Ywi6H5/n//imXP6ZD5aU5wnaxHhAO38b1TdiHW1JB5jsSkZvybTXsD1Q
         5L0Et19CH4bTU1m68AT01o46esJDx0o6uQdRxorC+Jo7rU7Ws+O6yfNvX1EOpHHAT1ms
         aEtQ==
X-Gm-Message-State: AOAM533YMnBOwp088AHEmn7LJO8n2mElrkG/oKYzl11i10aJIl+7JDDY
        f1S9YZI3rmTX/vY+bP4AS/xq5eGgswg=
X-Google-Smtp-Source: ABdhPJwxhRZK7tbQqvrOCyKJWPogsdyBYjnrYZZKlBXZe+q/TH3hDWqK0V2PGvKGG8R3VC22l0MqXA==
X-Received: by 2002:a17:907:10db:: with SMTP id rv27mr7120230ejb.275.1610721411306;
        Fri, 15 Jan 2021 06:36:51 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id he16sm2302718ejc.76.2021.01.15.06.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 06:36:50 -0800 (PST)
Date:   Fri, 15 Jan 2021 16:36:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: Provide dummy
 implementations for trunk setters
Message-ID: <20210115143649.envmn2ncazcikdmc@skbuf>
References: <20210115105834.559-1-tobias@waldekranz.com>
 <20210115105834.559-2-tobias@waldekranz.com>
 <YAGnBqB08wwWQul8@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YAGnBqB08wwWQul8@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 03:30:30PM +0100, Andrew Lunn wrote:
> On Fri, Jan 15, 2021 at 11:58:33AM +0100, Tobias Waldekranz wrote:
> > Support for Global 2 registers is build-time optional.
> 
> I was never particularly happy about that. Maybe we should revisit
> what features we loose when global 2 is dropped, and see if it still
> makes sense to have it as optional?

Marvell switch newbie here, what do you mean "global 2 is dropped"?
