Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A41A4587CE
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbhKVBnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhKVBnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:43:18 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E3FC061574;
        Sun, 21 Nov 2021 17:40:12 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id o20so25289807eds.10;
        Sun, 21 Nov 2021 17:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mc0Gs87vxXWEaCHkPv10q2v0pLp7INsdXI1aF1n6/XM=;
        b=W73IwcTobp6aeDPuLCBj75I5XjgJTAuCKui070/bNq6nCUDnA6WWdF637uWiGajEVx
         i9u9gmVoGgkItE+SICycSnfRBZ8XtpAo0frTJOP7bSxDsYAvZOqnrjP1ia286CJ9zglE
         V12ozW07ZU+oUx4RWhRrXyElGywKWZ0PwuAkFEQB+eJXKIvGX4SSIYvLD+WnSFihiY2T
         F/rva6BbMsEbgYXDqGRCqznTSZHxyx7/9EEYM4nPN/6UZEODkZQJlEmlivXhV8/LBVnO
         80Gd1HTYgNtZo4EyCy5TIPCe+NJa0QXNNhIsML73uLV0SPbVpF/hZaXgA7bhiFl+1hId
         jHgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mc0Gs87vxXWEaCHkPv10q2v0pLp7INsdXI1aF1n6/XM=;
        b=lZrrGgWHtfX1jmhgl6euUzG/as8/lG91iQjRpI+OM2oC4hAueOGnmHPj5snIP/shM3
         gBvLpRk4mi4FuPy6bE1P7sJoPFGnAmtNSbfOSVFs7ltpNiFiMIuwJ6eqUUniKf3bYXiS
         oU1uwvEV94bQNSi6Bcr5N/X3gLA1wC33gTM2vFRM3D8FunapzQoAJ3N0ove8txv752L9
         zdvFaAHUlrvHK38k8o6QUJn4MmWMY0g6mnRoEuwOVxkngUHqIS7lu69Npg3fXkmGjK/d
         h2IXcxCjgfBIOMV1EEmhkCK1cPzEB5ePLTr2/jQOEVrdC+phPpFyWTGV6Zecr8Cab4Ia
         vg3Q==
X-Gm-Message-State: AOAM531p0BGouxVfLEYCokjSUFsGAOGCMow1/cbC4UTik3sns8HruRYL
        LeRWXsV1zsVSszwIM6g38Ro=
X-Google-Smtp-Source: ABdhPJzhMUumycRrM5HTVm5qmOulO4QFAHGXnt2aPEdyKomMIA4m9EKlsPWLPMsYYMvU/TnG4/rBVA==
X-Received: by 2002:a17:907:1c9c:: with SMTP id nb28mr35027855ejc.184.1637545211473;
        Sun, 21 Nov 2021 17:40:11 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id i5sm2973713ejw.121.2021.11.21.17.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:40:11 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:40:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 7/9] net: dsa: qca8k: add support for port
 fast aging
Message-ID: <20211122014010.m67sebrogwajqkhh@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122010313.24944-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:03:11AM +0100, Ansuel Smith wrote:
> The switch supports fast aging by flushing any rule in the ARL
> table for a specific port.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
