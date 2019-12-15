Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1711F584
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 05:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfLOEDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 23:03:35 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42260 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfLOEDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 23:03:35 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so3699354pfz.9
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 20:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xY694KnXGlHwEnM5IxCeasI3CBIwUmkENhRchcSKqBs=;
        b=jQMDnKdtj5UjOtGBLN76SKHmmIcQU5b7bnWPN53p7CZ/WbEMVXW3UZXOvkSbd2mXpP
         yKgn65PesyrI4h+gkOOiJ10S0fJBYKYSakWrCTvb7D3QWmQQ3kdNyHO1O7oLeXQKh7m9
         muFlUcabl/xplTzsi9cevgdgRsTiIbHrhk9xAoIkQe3RBcnl4GH3JBjBc5y7Ga3Bmz8c
         kfCOckUKF3mctdIZ1/wwZUS7SiRs1JyF4f8rfiD2i8Lw5wbOyipxvr0hwskmRdDAeW+c
         lvejhZciw3hsja6TWiDD6R2R+r4f/ThG6xjohlwoBEi47ZPXKJjxA2BsrRjKsD0l3LAM
         OaWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xY694KnXGlHwEnM5IxCeasI3CBIwUmkENhRchcSKqBs=;
        b=tqhn3jbDsTMNM7sk7oWQXcUguNiqOE5Y/UOj9W3uyMM9jzMNNxfwkWKmvivNvlROmP
         dye1NqPuQN0zZdMSM+3/UCzGZK9pXqrmBR2P1JnXnfenuN5Fap8j/9yBXUdSWcH2Nnas
         Kv7G5wOmPgSe51HpYrrk9De2JEwONnWzxfm75rrBa9FtbmW0vCEv93zU1LpMBTOxEWaC
         Yea5tZCjVI4FVt5dPzyP1H+h8ziZW46tT6FhJ+qkjKsfStFegfJGX/Km2RquOQa9acCB
         yRAg496swhdo/Ka0BQufNwSanMFXUb6d06kOMvoQnyMvpkGRaiKiApxCtKO4UBqsON4H
         o3qg==
X-Gm-Message-State: APjAAAXWBo0yPpPo6H27P3a/UpFJLiAVvDnD+5gHv705rWONEflDcCe4
        HpNXqEUlIfzeNTbc0U4Jxb7Ciw==
X-Google-Smtp-Source: APXvYqwbdy+7fNEzR4dEsZoza9VgO6c96pEK2SX1UlMZxBn7OPgObEd/YI7rd8E2ejr7kt1aEJsFVA==
X-Received: by 2002:a63:3756:: with SMTP id g22mr9734524pgn.375.1576382614756;
        Sat, 14 Dec 2019 20:03:34 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id n2sm7403672pgn.71.2019.12.14.20.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 20:03:34 -0800 (PST)
Date:   Sat, 14 Dec 2019 20:03:32 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next v3] net: bridge: add STP xstats
Message-ID: <20191214200332.1c4d414f@cakuba.netronome.com>
In-Reply-To: <20191212010711.1664000-1-vivien.didelot@gmail.com>
References: <20191212010711.1664000-1-vivien.didelot@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 20:07:10 -0500, Vivien Didelot wrote:
> This adds rx_bpdu, tx_bpdu, rx_tcn, tx_tcn, transition_blk,
> transition_fwd xstats counters to the bridge ports copied over via
> netlink, providing useful information for STP.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Applied, thank you!
