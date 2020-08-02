Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C025235A74
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgHBUVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgHBUVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:21:08 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DC6C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:21:08 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l2so10755340pff.0
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=d9Mw9rIQdrWMle1va1lAxkJkin17+15DiO+P4X9ZzSPZUb5hPywNO4Gal2zGYmGjEl
         hMU1W6sdZ6xWoTxOMb/bkeN6ArKubp6tvusAVlAIF9cECRs+u3yLL5s5NpMAHHR1V4pw
         EnP5hNLYn27+gqJiTzNxZl2ed5+ic3ev8MIUz/jXu5E/MExn5tP2hWdQlvZNp1MHzAvK
         dl6Mwp7Nr0lnikP1Y9zkvaVTqLjzYEmomhH2OnrNgVQUvlZsFX2J4XW4e7e5vOXLQgBy
         jWnV+KWgrt+5MGEHF0qy/SSU8kZ1uRhBnQdetI/pPSb2BCWgvJeopptztrDr8oZg7Pgg
         4Z0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=rexd0XIirWvduBFQCPYlOG3WTFHLXSYU7Ulvwh2rXbtCzohfcimtO3OzST+m3zyPXg
         JURea6XeVo6z/rY+/AyUsNfEwUhFXZ9a9k+aRzMeuhuErAjyFDQEjddzr+1ZXZybQi6Q
         0bMR1O77F3nf05boZerb2NV11rQ36HAKAPgKX45+MMfeXUgWr3yWPvLF6L5RU4eXdyLu
         k4vszKq+letq0cVfZ/rlppPQV58eGLdRbMvlP2aSBC0LfC0k4ocCSx5Fkvg2yVoD3W4V
         PXxP6dcHyimCxBWq1jwzaiAoegMl0nbSMtBvl8oekhmK0ZP5ey0RRw3ZQUDGwhwtlYfk
         pKFA==
X-Gm-Message-State: AOAM531JqgavrVpEyA9XxsvsSAlbUjSho4I55C4eRDJtLViUdXXpqiIN
        y2rtww5/VCoTy6Uj/q7civPgP4CZ
X-Google-Smtp-Source: ABdhPJzCwNbNEpqozRbZc+pvwMWCajCHOaEwBxiwugYocPJ2IPo6eT9bJGBh01Rf92IAdrhvQ4HSAw==
X-Received: by 2002:aa7:94b5:: with SMTP id a21mr12826850pfl.237.1596399668127;
        Sun, 02 Aug 2020 13:21:08 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t63sm17519239pfb.210.2020.08.02.13.21.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:21:07 -0700 (PDT)
Subject: Re: [PATCH v3 3/9] net: dsa: mv88e6xxx: Use generic helper function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-4-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <725d7f90-a4ff-70fb-b8a1-cd3589087f6a@gmail.com>
Date:   Sun, 2 Aug 2020 13:21:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-4-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
