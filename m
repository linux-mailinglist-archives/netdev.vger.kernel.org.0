Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD722CE6FF
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 05:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgLDETj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 23:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgLDETi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 23:19:38 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBA1C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 20:18:58 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id w4so2725529pgg.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 20:18:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jB3aM37k7Uof2qWslg0X91xBsYbluh3lH+Nx0B0+MGs=;
        b=bhxtXrT8sbwTgBojOk6v7ZjB/5FSKyjbu3k4oYCtt/MePZZtTpIwedQqBbaqdSScpQ
         7ag6n8UiYyUS5DktUdLv5ESf7IUrd6f1/simYSpARtccyKeFCgxVkdJ+aAdGYAQRLm6U
         mGbyiG9OBdVN9LSfLW4lshT6ws4i6zT+HUKOOblXTH4q2V4soxzpF17hwhpQRynYLmuF
         wLCZkXl9PU2eFe9hjhdCXlPuiLVuZ4XtdMXkJ4t5Ip8U9pK3XYsT/NqEbvqcIZ0sBqyd
         j1eZH7+6MEdxn/kJt+jngZRtw3cFL6olFBYqmOdMWl8UJNSXxoyOx8CzckkEhYEBPpPF
         hjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jB3aM37k7Uof2qWslg0X91xBsYbluh3lH+Nx0B0+MGs=;
        b=b/PYQXeTS5emc1QthbINNOFsQF8l9j0HZYdq9vUa7fh5vOVXeUnL/uR0OEAdV8RItK
         aFCHUh88CWaDU1Jwwg3GFHUMasTbSA9yhZlg77+Fhzv+tVJ8cTN+nKmJthWLRRp9d6t/
         NaPGlgcfhMwkZE3nw3SbLVu49sZuNrjMN9E8ghSwPlr6zTY3ogFxtQWPWu7B/wMhg9p2
         eruAMM111efZREppkind1aNV8Cnxp2m4S1dcG4hUblsg26coFHkmw4Z6JKQ56J3yHC0z
         /4lQVJA+77hFGeIbTRY0zQ20tnnRok/k19FHRJZ+jbDXTdpgc/1h9kRMndaPefLVR18p
         GZEg==
X-Gm-Message-State: AOAM5311e62JK6X32ex8RnO+t62sa2p4WQnzvgfyGNsFD/qfzOC7qveo
        YqvWmP+NUI8GvS4dPYlQZyCHXuqIxS8=
X-Google-Smtp-Source: ABdhPJzbjNARR/7IHZuWW8UNApabWIRR5q8UYV3se2ouRqvlDu719CWYiW2663/FuoM3R0wUYbKgJQ==
X-Received: by 2002:aa7:9706:0:b029:19d:a2c6:aeb with SMTP id a6-20020aa797060000b029019da2c60aebmr2086574pfg.36.1607055537671;
        Thu, 03 Dec 2020 20:18:57 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u6sm707364pjn.56.2020.12.03.20.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 20:18:57 -0800 (PST)
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org, vivien.didelot@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201203162428.ffdj7gdyudndphmn@skbuf> <87a6uu7gsr.fsf@waldekranz.com>
 <20201203215725.uuptum4qhcwvhb6l@skbuf> <20201204013320.GA2414548@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2e674d7b-0593-1293-ad4b-3f4a30efe4a1@gmail.com>
Date:   Thu, 3 Dec 2020 20:18:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201204013320.GA2414548@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/2020 5:33 PM, Andrew Lunn wrote:
>> Of course, neither is fully correct. There is always more to improve on
>> the communication side of things.
> 
> I wonder if switchdev needs to gain an enumeration API? A way to ask
> the underlying driver, what can you offload? The user can then get an
> idea what is likely to be offloaded, and what not. If that API is fine
> grain enough, it can list the different LAG algorithms supported.

For stack offloads we can probably easily agree on what constitutes a
vendor neutral offload and a name for that enumeration. For other
features this is going to become an unmaintainable list of features and
then we are no better than we started 6 years ago with submitting
OpenWrt's swconfig and each switch driver advertising its features and
configuration API via netlink.

NETIF_F_SWITCHDEV_OFFLOAD would not be fine grained enough, this needs
to be a per action selection, just like when offloading the bridge, or
tc, you need to be able to hint the driver whether the offload is being
requested by the user.

For now, I would just go with implicitly falling back to doing the LAG
in software if the requested mode is not supported and leveraging extack
to indicate that was the case.
-- 
Florian
