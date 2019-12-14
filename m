Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43D111EF75
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLNBQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:16:09 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44869 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfLNBQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:16:09 -0500
Received: by mail-lf1-f66.google.com with SMTP id v201so560026lfa.11
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mKfO80HVl7EsV6C4mJyH1H17kBZBpZ6fAqSX07dZXsQ=;
        b=1+pSDWMjaLMP9KDo7Q1K/eUDDJeZMh0SpUwsYMtlJneTtKAjVXWnNNd8kjC/4/BtcC
         em0VMyj8CwECm8BbrQukS2hexDZFznx/r27s/NsxqoiC4Ru6s0+czev9OAmRCkxLr7Rz
         dDexthKVVX3vDQDkIwrd9fMkEx+MHl4zeEQ2qrEk7a0/AZOnkT0aiKU+ePnZ37OnnFvr
         Tc99Kk+LReyqg24//joLfxKE4jyud9CsWXTUbmX6Gp4hxKXyARlQ6IblZY61cWmpXXg2
         JD+Lnybza4Rs9MqcerWKKSmyLiiY4r7yjmj/duyct50js36q62C7VG3V/YOlfjEuP+qE
         VrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mKfO80HVl7EsV6C4mJyH1H17kBZBpZ6fAqSX07dZXsQ=;
        b=hS683pOxHv3+neKP6UhoiUfdGsSj4A73V+YFwl6Rc9fNk+sqNwDbxw03H47ZF4P02L
         ZYedEtbFdoyyXtgSL1KIXeGyFBdTxF/Z26qnTdAOaCI9kq0RGp/kSL9wHxOrCE9roREX
         m04MrAuga69tvd1+sB+bkKMIPSfvQQ5hRe/BqC/r2Lifth4kdPLpxAsnpvfxTNAClq54
         Yxz7eoQoySCJ3U6rnTeMJcybz11KLwOdGrk2XEjcwuE7wy5PNTVoV5+/e7pcVBqeFYMK
         Mg0StZA1JuMiqeEu5/lXD9m8/qaZGTk1joTdG4/ILGu1c5aI60Czhn1dxA/fqoKk6YJc
         lW3g==
X-Gm-Message-State: APjAAAXtzfI188bSREon3HDbQTrkM2oUFGw4GCru9yVgPmY7fFpTRPKM
        LBRP3kwehLs13L9wLYLAHvKqEQ==
X-Google-Smtp-Source: APXvYqwL37eGJJIVXJO6e4ohLwGQiWLLwOwCHScRz3e66u1SNnt3y9McEC8vuulGja/+DJPuZBOknA==
X-Received: by 2002:ac2:4c98:: with SMTP id d24mr10391549lfl.138.1576286167120;
        Fri, 13 Dec 2019 17:16:07 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x85sm5874464ljb.20.2019.12.13.17.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 17:16:06 -0800 (PST)
Date:   Fri, 13 Dec 2019 17:15:59 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net] ipv6/addrconf: only check invalid header values
 when NETLINK_F_STRICT_CHK is set
Message-ID: <20191213171559.74d73d6a@cakuba.netronome.com>
In-Reply-To: <20191211142016.13215-1-liuhangbin@gmail.com>
References: <20191211142016.13215-1-liuhangbin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 22:20:16 +0800, Hangbin Liu wrote:
> In patch 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit
> handlers") we add strict check for inet6_rtm_getaddr(). But we did the
> invalid header values check before checking if NETLINK_F_STRICT_CHK is
> set. This may break backwards compatibility if user already set the
> ifm->ifa_prefixlen, ifm->ifa_flags, ifm->ifa_scope in their netlink code.
> 
> I didn't move the nlmsg_len check becuase I thought it's a valid check.
> 
> Reported-by: Jianlin Shi <jishi@redhat.com>
> Fixes: 4b1373de73a3 ("net: ipv6: addr: perform strict checks also for doit handlers")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, and queued for stable, thanks!
