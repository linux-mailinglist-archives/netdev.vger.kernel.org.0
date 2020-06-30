Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B99B20FB86
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390665AbgF3SQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732595AbgF3SQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:16:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C69C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:16:06 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so19692394wme.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6RTSDs9QaxunBEZU3lx/3lfhJtZxOv531JGZQh/wb5I=;
        b=K4T5p/dbrL/UuV7UhDE3k2vlfmXfoeHmlhZW1z1xKne9pSiFPjLpVp/j2fpKy/HPR5
         mKd6GLDxk9qKkrM+2YK4nNQKYnRsLbicPMyYAjQin7HClUHQ96CKlXlgn9zh4TL4jC07
         HUbJ/4h9IOLba8KAl5WtaipH5X82EdBZ224pZQSfy7zOER0qx7kteN11aePqXzUlnl5p
         +21k+itK3HCZMnIoXn8DDnTEww7She8S68O3rclCzuwmKukhD9etUzX0RyoDe3W7EePC
         j0YWCFYBzA9nFOPIq2sAz3Nl73lIfDTnVLz+vPcZ1v04jVq7YGOHvmyqXrCttC0QoOGc
         wQbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6RTSDs9QaxunBEZU3lx/3lfhJtZxOv531JGZQh/wb5I=;
        b=Nnx4SuOc0OOI7vbshARNQ/IEbjQfQCiEo4SSFwBFrw6SwNPGC5DqVHueo4rP5ER7iS
         sWcLBuIhaMl3tlJxJGCP1Yn4op2uUXRMd4gaSp209/DtU9Zn6w8BeElmNEwdgS0XaeY7
         hpixxckRLFiIoHZ4aEwknAv9Fo8mjyl2YGCr8NKxsW5hYaYDuNlIFdTk1MKU/Tu8BD6i
         makCSKb9H5qudS2KPOYUfxoCJ6m1wn1Ql0/W6jLbHcL0esWlA3FlX2kPXW1+HDmIYtVQ
         UesjUvAApX8EBYEA/QvCL6kuZI9mrntmDGDQxFxBQZ4SLg35/+h1cAZjNxkWvnW8BVm5
         iRMg==
X-Gm-Message-State: AOAM530RNHEHpCxD13mLD8MdcmAA0seJHfvVtKEl3vFBg5mF0lnu7QWp
        xZJmdXqG3apsorpzr27urAyQ8j5E
X-Google-Smtp-Source: ABdhPJze3dg2g9I19Su/PZK284AvWR6svDDAsG+axdmBHIrLsFMIUbQvaoXgMD4lVx4Z4EkS/bWd0A==
X-Received: by 2002:a1c:1d93:: with SMTP id d141mr21955323wmd.14.1593540965141;
        Tue, 30 Jun 2020 11:16:05 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r12sm4471501wrc.22.2020.06.30.11.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 11:16:04 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 02/13] net: phylink: rejig link state
 tracking
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
 <E1jqHFY-0006OE-Sw@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5f31c142-9d94-c564-2d3e-1431d001de9e@gmail.com>
Date:   Tue, 30 Jun 2020 11:15:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <E1jqHFY-0006OE-Sw@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 7:28 AM, Russell King wrote:
> Rejig the link state tracking, so that we can use the current state
> in a future patch.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
