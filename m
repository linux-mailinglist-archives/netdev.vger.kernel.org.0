Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1B962357F5
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHBPNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgHBPNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:13:25 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB379C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 08:13:24 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 2so875572pjx.5
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 08:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IZaMYz7lhUKFWKtqXtf/xZsCp842yF9PZPlQaVZlAgo=;
        b=p9QPQZS7dyb3uNVYri9NMgHyKie4TymlrLJ55vfRVcxC4T1BYO8O15AOeqwHWfKCs7
         hKYJxtB+BraRfPYW6sj6U/Zg2r2u1SLIMSpefDh8EgMGGSEDw1WocjGrz3BeafLcYRJG
         toqcGsX6A1UfPoWylyOqcJtwW/5y5lpkKr+DZfNci3DVZm3TgYDYYrmR65Auu1w3ZpEE
         0zrYLeu3nNdgAvE5cWipWYLSRs1G9LhgmEWqZnutH8EO56i3NaRTe1A129Hz3kPGATTp
         0t6IFcXpp6yliC6+AhkcK3rNcMbBLqhUWc3YrpU0Y+zJHZWfRMbOsvXZcaeR0YFbHLnl
         +y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IZaMYz7lhUKFWKtqXtf/xZsCp842yF9PZPlQaVZlAgo=;
        b=X+pOsRAeiAsle/VsRiXtusN/XD3TaML3z16s65bpfbN8wMTX5aIuWs7mJMzCAxbGYh
         86qeI6qSG+Zfhv6zJG7wIr+5TpKFluauPZKLgE/Ox5B3FDcO80tRwTfY1vnBRAF7r+O/
         iKzPrArY+3w1fI8PD6IbbnKJxfzQ95BwneafHTRDUZho9xi3z2p/+OmIqvavakCD9nE0
         2zzAB7BF9Ht20nUao/oqbIS1Jea7YjQ6j+QVKDfB6Got4sd3GfFlPVCl/aE+lC4DiyAb
         c1pYidD1IHWRwuwCijI1pIPpycxwf0mezynK81nOg0wZmceyEoYcg8KO3yJLgxsiQ70H
         GN8A==
X-Gm-Message-State: AOAM5306O2nDcAucXUsiCnfyn85hc11ENyqEjlDpRXsSbO1LGhX5nsAI
        huMPE4sNbBUXxp9Ptp4c/RQ=
X-Google-Smtp-Source: ABdhPJy3Pnb3HUZVoBJUBk2K0s8dIP6BYaqGxOYinbdjreb8YOngiGGrslfqtsb7xhccztQFCWMimw==
X-Received: by 2002:a17:902:7585:: with SMTP id j5mr11742449pll.168.1596381204495;
        Sun, 02 Aug 2020 08:13:24 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id lx16sm16585038pjb.1.2020.08.02.08.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 08:13:23 -0700 (PDT)
Date:   Sun, 2 Aug 2020 08:13:21 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
Message-ID: <20200802151321.GA14759@hoboy>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730080048.32553-2-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 10:00:40AM +0200, Kurt Kanzenbach wrote:
> Reason: A lot of the ptp drivers - which implement hardware time stamping - need
> specific fields such as the sequence id from the ptp v2 header. Currently all
> drivers implement that themselves.
> 
> Introduce a generic function to retrieve a pointer to the start of the ptp v2
> header.
> 
> Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
