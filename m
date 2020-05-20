Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A421DA905
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgETEUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgETEUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 00:20:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CB1C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:20:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p21so825929pgm.13
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 21:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ueruhMXrrR0BWvHwK13v2cjhD6cYrhNlJB/app8VWPY=;
        b=IT4AZz3Fa/swwvGrATsONM8qvKAn3wafRE29J7+SSmPGpycFddb7AVJW/P100rCkRU
         ajXe3IqYwX3gMimT70TJgi4Pes+AtcCtEefgFG86BdoBLPyf9s/t/QbM3soh0Nkg++B/
         pR1K0a2k3IWEF0m+oQNKSmCLowT5WteIQQKWy2kbPdv1QxUot2vAsuUOnA1800s1qo9w
         +1pkSf/j7uMPAZw9ZVSLn+cSVhEUCOa2X8TXMiQlq3b6UGH3C8i+Nhu4OTrLcIpDcCC1
         9CPnelxvVI20Tk7E9LZyDI4L+nwYYIAq37GGHXzXljQm00K0wcR34s4tjQpM1GYYbrA4
         Xjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ueruhMXrrR0BWvHwK13v2cjhD6cYrhNlJB/app8VWPY=;
        b=Y3aNGlGiMAr543YNs4Cslof6BXCrAqK3QkxY6yF7dwqKAewXLYcUCG5hjrECWD83c4
         Zbw9syhxzQST+D5akQZcQpMkziUopLMeWylAyufVpj9A+88/e7OZ244guSLmaV5CRxJN
         8Tc6QMT8+95ds1SeE5Qbe81xfZkdNns3s+AyMEtWRMzqQFaGpE58ZiubrfkB9cU/JFpd
         UAXewuKH/Ouq6Mfo1fl8i5Dz27B+n8QXB84GBnefZhE93vPy/zjr/RMRSG6+l9UvbXj/
         b8Mp90RluhiHWh07BmAknnmYO9hBIaux70ChONmKE+yWg5wIBSsyEaN+XvjcaqyBnlRY
         7fIQ==
X-Gm-Message-State: AOAM533WowW1Hx+zHdWTiyEjoPyqUqs9CxlZfhVg7elFsKSwuPyGgEOz
        Wm5aqAXCcpb1FgdHZoihziG8MQ==
X-Google-Smtp-Source: ABdhPJxBRb3Yf6McFpP2bVpTe2bCsyAhp7YjDiKA6bwD5xxumedpgDaepW4XByt7OZLw78tbDLQO9w==
X-Received: by 2002:aa7:9f5a:: with SMTP id h26mr2343866pfr.51.1589948413903;
        Tue, 19 May 2020 21:20:13 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q16sm732639pgm.91.2020.05.19.21.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 21:20:13 -0700 (PDT)
Date:   Tue, 19 May 2020 21:20:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2 v2 1/1] tc: action: fix time values output in
 JSON format
Message-ID: <20200519212005.451c806d@hermes.lan>
In-Reply-To: <1589936384-29378-1-git-send-email-mrv@mojatatu.com>
References: <1589936384-29378-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 20:59:44 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> Report tcf_t values in seconds, not jiffies, in JSON format as it is now
> for stdout.
> 
> v2: use PRINT_ANY, drop the useless casts and fix the style (Stephen Hemminger)
> 
> Fixes: 2704bd625583 ("tc: jsonify actions core")
> Cc: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Applied thanks.
