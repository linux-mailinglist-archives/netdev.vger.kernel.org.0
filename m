Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4220FBBE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390799AbgF3Scw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729676AbgF3Scv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:32:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C01C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:32:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k6so21163726wrn.3
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ywqGbLaOZJRaK/+jksBEOPLIHvYcYsOtOSjWtzE6UO8=;
        b=AxjCW+o+X1qxGzDAgR1X/eSREpJGmFqbBxanCFdgjW2mDk+C3t8fb0uxaDkTYnqVbs
         jbRRdvoM9J/Cz3S4oKG5wJ91PhfMuUO0wWjgB7GtEjIKrLPDwFfr5D7HCD52XEDPHZqb
         MXbxMMRChbKssgcOObCiq4FgM7/uSBKS99ELYxUrugQPxiZS13riSa3XKv1U0UwesTBo
         Dm2Df5C2W4hf1LFxKZ8YcnEJ0scCrkdkTcJH1Z/2ZrHJ8gOacgs8cWMF8K4AQ0muuuCQ
         UzLvztGc5rJbq1uP9NgB0z0MHJm50mUt5k8CLQUCVdE07EmXFWJVhwLUgfBuv9yeJgo/
         5S0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ywqGbLaOZJRaK/+jksBEOPLIHvYcYsOtOSjWtzE6UO8=;
        b=GvVkXVTGSLfOR4JvhwuHJG88OQnCHr1CvPbL1ix1M8ch9kJKfbRw9Q1V25OsQhOgsx
         T2NzTzaAOSgDaurnXWiQCpKphqAg4BI07+j5apAUcYB+U8qLWFT9RQ3jUAfxHHdnvrQl
         KT59gu4EFp+vfyI1iaOs8vIusk9+n4QQnXau3+SGQZ2t8TlxJ4PL0jCJmgf1ZZ/fKYrN
         DcZVGsAzvWrtETvWsAiejcKY8js0kCkVE13xsMW6kQ4I+1HtXwoAPe5S86x+aH4T7rz+
         edZbhsAhLPesd+wYa3CuDGkxiFTxwQ/enFaeuIhTRyZUhPlNaB49gNibypQgwOdLHkC5
         v5Sg==
X-Gm-Message-State: AOAM531mQAdRscbw/NSNi2u+oYmXqS0ZQA/Ra15kk1/QmN9B9107XLpr
        We+TQu8jswXv05V/QgFYk88p9nbd
X-Google-Smtp-Source: ABdhPJzF4oR4NSl967h1beTfRJnH2RJLPqJhbucvZ+h4jyywB0LzNMfZx8eTZoYzL3exSK/fUQG2VA==
X-Received: by 2002:adf:c185:: with SMTP id x5mr24981769wre.403.1593541969839;
        Tue, 30 Jun 2020 11:32:49 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z16sm4446440wrr.35.2020.06.30.11.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 11:32:49 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 03/13] net: phylink: rearrange resolve
 mac_config() call
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHFe-0006OT-0k@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3196df83-66ae-de68-54cd-c75b54cfd956@gmail.com>
Date:   Tue, 30 Jun 2020 11:32:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <E1jqHFe-0006OT-0k@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 7:28 AM, Russell King wrote:
> Use a boolean to indicate whether mac_config() should be called during
> a resolution. This allows resolution to have a single location where
> mac_config() will be called, which will allow us to make decisions
> about how and what we do.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
