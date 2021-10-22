Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3271437BF6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233917AbhJVReM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhJVReL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:34:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFECC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:31:53 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t21so3224631plr.6
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m9GBo/L2YpGQFr6AD2YfDkl6rNFFC2mMXEaiDXThFc8=;
        b=btpRHXeYrGCN7P679Syaj1a9cgIp8zQ41MegmxfhrC6w4H0zVsXE3vR5411MFYGrS3
         KywFEb8cGBVqj6j11NqoLIvEH/AgTSogWGKXey7//U0mZC2h2fXNgVdSr2UPjc5g88w8
         BYdc6OBIYadqLWDPM9yrc6UW7xjC0MKRk+LnLDurwob+46yvb75GuhpZpfQjtoC0Wrkj
         CPQvyG1sU7iNS0rhUDDmJ92okqobhECqkaV+h3Q5NbyRb1j2N8ldZFq5LvmZvp6l9OuD
         vMfdHLkpXYgzpWCpL/njxuoRo/rHMVokiyNQkf4LZthPfW0+B2uh5gOBC+i7O71t/WFW
         Jfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m9GBo/L2YpGQFr6AD2YfDkl6rNFFC2mMXEaiDXThFc8=;
        b=Iihelf7MfVzte9TcmcKBvF9o7JolGUknsnbeMOgrk/CFI5lqXBS/AR2Yt3sHTUeI8n
         G3g8OWbO/u2K636DKjzPKttEmBibKXalzVubQT24pekQnUKQ2p20ldBgU/Tf1K85DbwJ
         9nAxxNC7nz3p7S1sHV+AIJVhV7CK9Cw1DNrQocqdDez0rO/F07gKGbka/KJItQ6IrpH6
         2eDBTWsPbo7zOOu1br7vTfNJW2iIk06O3VT3SepUNSIbOGb5yHw9JPtjpdpg2G95Mwg6
         gpYw7F+Jj/zWYK1Rt1Duegvb24sQ+IkvWGT5N9hAyhSv1ipThrMrDQVHNzaunlT4nf75
         poyw==
X-Gm-Message-State: AOAM533pzzzH74bMQHT8UFQjUYR+fYGvVLP6JMFF6W8hkQLxdTEtJXI6
        Nhbafn70rNI7nhTmIQ79Qeo=
X-Google-Smtp-Source: ABdhPJw6oFM2+737IhC18X6oFFX0czzWgOA5Q0pwNGNXf8hTr8z+kCeAx8ZfdbGIdsNrUNSlPfTn5w==
X-Received: by 2002:a17:90a:ae18:: with SMTP id t24mr1459170pjq.92.1634923913291;
        Fri, 22 Oct 2021 10:31:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t8sm9584801pgk.66.2021.10.22.10.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 10:31:52 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 5/9] net: dsa: lantiq_gswip: serialize access
 to the PCE table
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7eecb2e5-a859-10ef-2cca-767333688d90@gmail.com>
Date:   Fri, 22 Oct 2021 10:31:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022172728.2379321-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> Looking at the code, the GSWIP switch appears to hold bridging service
> structures (VLANs, FDBs, forwarding rules) in PCE table entries.
> Hardware access to the PCE table is non-atomic, and is comprised of
> several register reads and writes.
> 
> These accesses are currently serialized by the rtnl_lock, but DSA is
> changing its driver API and that lock will no longer be held when
> calling ->port_fdb_add() and ->port_fdb_del().
> 
> So this driver needs to serialize the access to the PCE table using its
> own locking scheme. This patch adds that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Looks like we are missing a mutex_init() for this driver, otherwise, LGTM!
-- 
Florian
