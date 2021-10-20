Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BE443564C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 01:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhJTXMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 19:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJTXMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 19:12:53 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0C4C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 16:10:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v20so17177415plo.7
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 16:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tA7dbZ5NEJkKQUncpuFcl0/mmniOX0dfo36d790QLlE=;
        b=b7AXjfO4cddXU7/bWRO3Jy4vsB5m64Whb/NGRKOHHEq6xaMIzHxvaB8T0UvvgmQm2I
         DAndWYy1psrK9nQleta7lyzOLuDhc21uYYLSGYoKQbhUwaZUYY/X3YovIjBAB5cfnUTL
         KKGHncuffqbnlhgy94kEDAAd6bOawozmHHUNk8ke8Qrv5fky7SCC8suQ+SEMVvlVvs0D
         EgwsM4Quk7a/6AVzrNf/7rjbVgRLt2rEYvUwpirHqJQ+a20rtl2tQ2Xv6DjY3HUeEFw2
         Qbw5SvkQFWQddqkXMHDjLbKRhCCOarIdbFHII/FDzMTpwVLV+dRXFX0XhSRMbU05YXTh
         +pVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tA7dbZ5NEJkKQUncpuFcl0/mmniOX0dfo36d790QLlE=;
        b=b/dmocc/GicYE4Yq9fy7jH2Vd8uibxyK3tVvpYcYsnbXCK4g6WTJIuwQLEkbHCnMyD
         m0XLS/el5M97UB+ZZisS559RxS1rlUUms2zL1EsXlLLSHuoBYTKzrK87cGQfEqK7OkDz
         u2NZVAkn+tzFYl7Zu69E1nPjQukD2PmcYZXWT0lrvA60M3DffS9S/D5BvRQ2zsnb4DUm
         2TdiXLxH37SUM4KMOce/S0ZVRWdKuQ70ceLR0UdVgeTNwUKWFCMjvdbf4zQ+aDPU2Nzr
         s9WXx4y4kGUfuuAGr2O8tIXTLd+IK2xlJWVXugp4LLgH/VIONvOVY95oWA0sEa6592Ah
         ejlQ==
X-Gm-Message-State: AOAM532SQ4FLDvgrI7xEyKfR47sTDv6hSPXBJec0HCcwo8MQjUo2IcYQ
        s5f7S2r88Za+6QXK/Uuu6m8=
X-Google-Smtp-Source: ABdhPJyiIgH53/r3qLoH0hznXLgPOtZOyS6fi//cnAkKyxka26ieD4hxiQm9tipX5iPCJcP/+dpSSA==
X-Received: by 2002:a17:90a:df02:: with SMTP id gp2mr2122407pjb.196.1634771438281;
        Wed, 20 Oct 2021 16:10:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k127sm3821059pfd.1.2021.10.20.16.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 16:10:37 -0700 (PDT)
Subject: Re: [PATCH RESEND v3 net-next 1/7] net: dsa: introduce helpers for
 iterating through ports using dp
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
 <20211020174955.1102089-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <09987a3f-4137-6115-0947-784712c4678f@gmail.com>
Date:   Wed, 20 Oct 2021 16:10:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211020174955.1102089-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/21 10:49 AM, Vladimir Oltean wrote:
> Since the DSA conversion from the ds->ports array into the dst->ports
> list, the DSA API has encouraged driver writers, as well as the core
> itself, to write inefficient code.
> 
> Currently, code that wants to filter by a specific type of port when
> iterating, like {!unused, user, cpu, dsa}, uses the dsa_is_*_port helper.
> Under the hood, this uses dsa_to_port which iterates again through
> dst->ports. But the driver iterates through the port list already, so
> the complexity is quadratic for the typical case of a single-switch
> tree.
> 
> This patch introduces some iteration helpers where the iterator is
> already a struct dsa_port *dp, so that the other variant of the
> filtering functions, dsa_port_is_{unused,user,cpu_dsa}, can be used
> directly on the iterator. This eliminates the second lookup.
> 
> These functions can be used both by the core and by drivers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
