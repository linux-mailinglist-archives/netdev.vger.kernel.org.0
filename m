Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6286E33A234
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 02:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhCNBmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 20:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhCNBls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 20:41:48 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678D5C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:41:48 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id z5so13664660plg.3
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 17:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vqZS7AJ5hYa5VdCNSzUw4T8e7p13stksPryGQlQT6Zw=;
        b=CWzROwIvItmHqOWy0zS4+qIcOVBmqjlSeg6aVpgzFsGjNthdU3HxWArqdJFH+hy/PO
         GpYcpb00cUhrmSZo52cMMuqSuFm984Rdk+UwXJwddp4uVJIl4s7d8wG9jF1Y1ZGjsAb+
         KP5Ltbl268e5GchuChrZLMpyKvqGdLBk/Gcu0AfEAcPdKLZv2RZcOPAoZnVkLQwBOlZx
         ubz7LUJb/c2d+gepIiMB33ImIfhc1p6qDRGuI/lHO4rqmFbgcT8NrAVYfu+b6ccM6ngN
         f98YCSTLZVowMDVsd5B2qqr8uYcTO/cNEgyt11e4DcbFLP9GYyQDKNtFcv8fqap/ZgVy
         c8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vqZS7AJ5hYa5VdCNSzUw4T8e7p13stksPryGQlQT6Zw=;
        b=bks2Vg8XZuV4fD/IECS+oMwY7BQqgT134J2AlvisLUd0BETXZyRTch7I5PAqy2TbA6
         7o8nOTqme0tU3/9HH/pa1tVhx4gjxdrlVZniipIjKBhw8FQiH/XmeWkJBlA8q6CignOY
         DR8D/9lpznxh5Mjk7JfkPqDgYxMbCyJ6bqEid2Dm5yt3wlciHKcGel4gTEtp09mfxPgP
         M0XYod2hWgl8hYK+v1YtKguo18LE1RVaLjwxLx0STr5/ItxkFSS0S1MgC7C+lqsdOPhm
         nS+fJVupwFwOZwpPbmbymGxk24uJF1kiX/F5O4w7mkLxNYUP4ztpmm0zhwxprKkimhau
         2P/A==
X-Gm-Message-State: AOAM533lM+6lCDany7S8PqEqTHXYMNZVjkcjVtU1j+g8Xm8bpBViZwhW
        NvjEhOIvvbSyC7IrvnbBc8tGHYMHev8=
X-Google-Smtp-Source: ABdhPJyHtr9YO2JHuAhLhp5sc6M1WpXoVChnMI3vALbiH2X1I9NWfThgYCbOfGVSuOYA56wzkKTi0w==
X-Received: by 2002:a17:90a:2c4b:: with SMTP id p11mr6091236pjm.75.1615686107642;
        Sat, 13 Mar 2021 17:41:47 -0800 (PST)
Received: from [10.230.29.33] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20sm6539041pjn.27.2021.03.13.17.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Mar 2021 17:41:47 -0800 (PST)
Subject: Re: [PATCH net-next v2 4/4] net: dsa: hellcreek: Add devlink FDB
 region
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-5-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <97ec9cd3-ea41-7ffd-345f-2130879d15af@gmail.com>
Date:   Sat, 13 Mar 2021 17:41:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210313093939.15179-5-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/13/2021 1:39 AM, Kurt Kanzenbach wrote:
> Allow to dump the FDB table via devlink. This is a useful debugging feature.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
