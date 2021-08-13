Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4225E3EB297
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 10:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhHMI1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 04:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhHMI06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 04:26:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF7BC061756;
        Fri, 13 Aug 2021 01:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=YEwjQFo7Tx0VL17MD4O47XBig2dYQpejA0GRz46DLE0=;
        t=1628843192; x=1630052792; b=OL/8zSuUwiVu9UBCi6zNNhDY6+pVkOu5Yhl7e7FGA1mLz6Y
        EXvALba0lFR4yZ9+LN+13I63hW3SCtDhp/Va8RuqoSrUljprDtc26tRrkyg9rIj0L5ayXbobhzOw1
        QEE739auEUre/V0c8PQKmhULSbfeqnxRyC/UIxUh3vdi6a1tR65TCixxhLBsc+oMjAcFZZjVPoLx5
        N7aAlAaO2K2MfBGcPqqqiWitqsUg60Dey4WytRUh81gBVsPBf08UlPTsMGLkhSuxQubW5UyxN60Bk
        oCIOeqHxq863KUKXWBQRY4BlJ0fF8s81PoRaysxIrA9V+tJ7JYqI/dS6phSUChBQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mESWH-00A9vJ-HT; Fri, 13 Aug 2021 10:26:25 +0200
Message-ID: <64b3313ec8a15229e75a29fac2fb5ba1491a2191.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] rtl8xxxu: unset the hw capability
 HAS_RATE_CONTROL
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Chris Chiu <chris.chiu@canonical.com>
Cc:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        code@reto-schneider.ch
Date:   Fri, 13 Aug 2021 10:26:24 +0200
In-Reply-To: <CABTNMG0Q6Oh8T_sqW-b3ymdbepYmMRQALGozo6pXiKg=r-ndxA@mail.gmail.com>
References: <20210603120609.58932-1-chris.chiu@canonical.com>
         <20210603120609.58932-2-chris.chiu@canonical.com>
         <5bb08a2db092c590119ff706ac3654de14c984fc.camel@sipsolutions.net>
         <CABTNMG0Q6Oh8T_sqW-b3ymdbepYmMRQALGozo6pXiKg=r-ndxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-06-11 at 22:47 +0800, Chris Chiu wrote:
> 
> Based on the description in
> https://github.com/torvalds/linux/blob/master/net/mac80211/agg-tx.c#L32
> to L36, if we set HAS_RATE_CONTROL, which means we don't want the
> software rate control (default minstrel), then we will have to deal
> with both the rate control and the TX aggregation in the driver, and
> the .ampdu_action is not really required. 
> 

I don't think this is true. You'll probably still want to use the A-MPDU
state machine in mac80211, etc.

What you *don't* get without rate control in mac80211 is any decision on
whether or not to enable A-MPDU, but that's something you can easily do
elsewhere and just call ieee80211_start_tx_ba_session() at an
appropriate point in time.

johannes

