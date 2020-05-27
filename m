Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230FC1E4A3D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391156AbgE0Qck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387763AbgE0Qcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:32:39 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA78C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:32:38 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u12so10114wmd.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vY2QVhWmaQqGLVfc+JcB0EaFXTRD1jjecryekDDca60=;
        b=GpMejmc0bke7HDV1UFRLoubOMfiHkGy/St4IUJz8U4Q8CcdHZBnGD8CIHciwKMamuw
         vciILGhH1F7/DGrFj+SBbQkxXnOkeXXVW/8ooZK71ik/leg882/ZLqoVTW36ihQ+KsCW
         DnhvDY5T49LmIHwNwQSIytoZHyygybaKLkStRNeb0C3h8N20lBit56G+K4Osmm6whEo/
         1P4ILXjO/cTMGcrmdQlSFpUPqbNXbdxbN0J2SJNF7PlQqj3Yb3H7OjFQ3lyX9PiwlrVi
         cfvtyL0tCGD//anoAQD08Kzv0GOrpICy74G/xbKyyHoqCuF6sbUW6XqvZnL/4X3h257y
         QKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vY2QVhWmaQqGLVfc+JcB0EaFXTRD1jjecryekDDca60=;
        b=ayAcLNG1lRvZHFe8UDiwNl8hnbvgQ+YFhuhqS3qWdBsw8kM3rivnRmQqVEJuM1Jy7i
         60ZQxIyoqX0QzDNvRAFhMgySVR8w+xAr3L3kJi0BB8SxuMxbkbkuXrz4WUXKnUwoN+7G
         WDIoJbBrLHx390hkjIFk99liHqgZru2f+Y7mxC9MIz8a0Fx7nLspXBZbZmo0fgaijc+r
         kI8uWJOPpc+xtfAeF9U9MN5OhIlurzzJkDuPM01d8m+XUjbDc3IgcSyrmoVPxlmVsFFm
         A51ndcBgF/qCtNxQg3DeEdXKhz+7f2Yer9ZBmd4n6sUJlx+j6egRB4xtqUMDgFxyIx7p
         uHTQ==
X-Gm-Message-State: AOAM530HhRYp3aRj5jTqby88KS/2M3JYjxpJ3xcKZJkdM7r9l7cTygr0
        V9hGg5TdPG+r7t18+088kTfw31FX
X-Google-Smtp-Source: ABdhPJxlp5LghJTsRNQqWatB4skfmNrmEbLjWXNrc6nhRkQxxcVf9k+DaN/rqBtk6YjymOLKibFE8A==
X-Received: by 2002:a1c:a906:: with SMTP id s6mr5307726wme.171.1590597156877;
        Wed, 27 May 2020 09:32:36 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h137sm4368274wme.0.2020.05.27.09.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:32:36 -0700 (PDT)
Subject: Re: [PATCH RFC v2 3/9] net: phy: clean up get_phy_c45_ids() failure
 handling
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNk-00083V-Hm@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e517b38f-fe57-ab3d-3d9b-51cc3d119883@gmail.com>
Date:   Wed, 27 May 2020 09:32:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtNk-00083V-Hm@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:33 AM, Russell King wrote:
> When we decide that a PHY is not present, we do not need to go through
> the hoops of setting *phy_id to 0xffffffff, and then return zero to
> make get_phy_device() fail - we can return -ENODEV which will have the
> same effect.
> 
> Doing so means we no longer have to pass a pointer to phy_id in, and
> we can then clean up the clause 22 path in a similar way.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
