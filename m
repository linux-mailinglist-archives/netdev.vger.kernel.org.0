Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B0249FD45
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349771AbiA1P6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349779AbiA1P6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:58:06 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F79DC061747
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 07:58:05 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id t7so9606664ljc.10
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 07:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=rdqNVlz+Cyc8myXWRL1zbi9RLP5JsoCgCgrxEyq+0D8=;
        b=geB9gT44qCgCx6MurvtMTbN+AJ0zoPBklqVq/ZpyNHNvO26u7l44gdWfDFsDKZpWf0
         OPaAVZtrWuItmqFR4VjmNQipyXusDjZqlpweq7ecbNJ0iyPxP1NOzK9WaAnKZyjYP8AO
         EbFy5enohSNxOr/yYK8j6xekD94DrYhc/Mi1T3Oe4M0vVPEdrRkWxECq3xWIFUR5vqpu
         d+xAps4wZ4TQVTDiNpz7GJaPaniuz/Xgc1qLKP9LmtV+JgeHNNsU0fiDUMfxSL725oFZ
         YImCOqmIhXTRtFmwBr7ZkKoU8Ofe4wqAEFxbMTJRE8SupfWbdRF1K6NF1ZCKn1cNsWcY
         NMmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rdqNVlz+Cyc8myXWRL1zbi9RLP5JsoCgCgrxEyq+0D8=;
        b=q6nGmuTCWKmQjHAYCea9ZRy/oN/dSl/yw/SrNWYS9bGFSvn+EQ34WUPpDr4HLJuEcz
         X7b98bUWNeyXsstOPuTqbsa304/fydvD/4eOP4NBsLLABuL+QboqotVn5Wlq532hSTBO
         t0g+ptPTfVCf9cDjsAqqFkPzAKOf2EsppfDcoxLiN4LF8ZsGsDjUqD0i0yeZyHc2nyN+
         wXYT/ivrEv5xCXTMT3aCJpBco8ars2qhLO4euUqoEqr9PR/d+fvbbuFZFQnEhNerDdP5
         ETBj+2LcfQFfcvSwozw1h2ymTX5NimB5egN8Y17OmaLKcg+eNTX3K8XknOUw2heBHQ73
         1MgQ==
X-Gm-Message-State: AOAM532swWx7SRXKlzkkq7sCuEr/B0xq26eJW0cNpC4zAT3oU8DkxfmC
        Udr2BXQuYvabi1nbLouPVjjmuR+ZnjJ+PA==
X-Google-Smtp-Source: ABdhPJzQq1dEzWqAu5OxxmtIjBf5eMOHcCOBOlHmJKQorYtU+f15ATp3bhPEJVl70AKOb/pRMr0qDQ==
X-Received: by 2002:a2e:86cb:: with SMTP id n11mr6147417ljj.250.1643385483720;
        Fri, 28 Jan 2022 07:58:03 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id q14sm825468lfm.120.2022.01.28.07.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 07:58:02 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
In-Reply-To: <c3bc08f82f1c435ca6fd47e30eb65405@AcuMS.aculab.com>
References: <20220128104938.2211441-1-tobias@waldekranz.com>
 <c3bc08f82f1c435ca6fd47e30eb65405@AcuMS.aculab.com>
Date:   Fri, 28 Jan 2022 16:58:02 +0100
Message-ID: <87k0ejc0ol.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 14:10, David Laight <David.Laight@ACULAB.COM> wrote:
> From: Tobias Waldekranz
>> Sent: 28 January 2022 10:50
>> 
>> The individual patches have all the details. This work was triggered
>> by recent work on a platform that took 16s (sic) to load the mv88e6xxx
>> module.
>> 
>> The first patch gets rid of most of that time by replacing a very long
>> delay with a tighter poll loop to wait for the busy bit to clear.
>> 
>> The second patch shaves off some more time by avoiding redundant
>> busy-bit-checks, saving 1 out of 4 MDIO operations for every register
>> read/write in the optimal case.
>
> I don't think you should fast-poll for the entire timeout period.
> Much better to drop to a usleep_range() after the first 2 (or 3)
> reads fail.

You could, I suppose. Andrew, do you want a v3?

> Also I presume there is some lock that ensures this is all single threaded?

Yes, all callers must hold chip->reg_lock, which is asserted by
mv88e6xxx_{read,write}.

> If you remember the 'busy state' you can defer the 'busy check' after
> a write until the next request.
> That may well reduce the number of 'double checks' needed.

With 2/2 in place, we have already reduced it to:

read:
  Write command
  Poll  command
  Read  data

write:
  Write data
  Write command
  Poll  command

The poll in read is always required to that you know that the value in
the data register is valid. The poll in write is always required because
most of the writes are going to have side-effects on how the fabric
operates. So you want callers to be able to rely on the data being in
place once the function returns.

Am I missing something?
