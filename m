Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7746380F30
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhENRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhENRqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 13:46:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6A0C061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 10:45:02 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id u76so236690pfc.11
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 10:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hGqCY9Dmnzd89b3/Qs1g3cAOLOW4kpJcOWI9OrW2mTE=;
        b=ZenlulqLxB/j4vPEsfQSyjqDPC/d2Y4Y0YqhceEbKEzfzSiSNy5rtt08m1qThU003u
         HIS/LrKyFchroXeefjgba/38JLOmFEEuJ9agTqqgIu0V7J23dfYIL/sD0tVUdnO8vs45
         tA8P/v9rbmPDyyoBt1JYBOpvlTtjgsLqaPtHGnKQI454LjwY4VoIrb3POu8oRf3jjhVp
         E0je0VBtErQ3PoOTAvO21Uzzu33gsykqxHllwZBccGicMv2GOfjmmw0tOmrQI7OJhHfi
         CeIhq9/WU7vLas7JUT7lnxAeS/z57kt0KOUjKoCm8zxg/7aorhmEb37ezy+KzQkjpi7n
         Et8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hGqCY9Dmnzd89b3/Qs1g3cAOLOW4kpJcOWI9OrW2mTE=;
        b=pnVKD+s0z5sabamCrS21ty9AEPiHdjOng7IGwEIP7kZbb2yJaWumXTnjIyJJqZ6ooR
         st7C1HZpq/7BGaQ8Lia6bxQF3cwwZwzU6RJ2qdYJMyTGlDwB+2qTJ2hGm0HbHJGUhvOR
         fWCkFV/M5PiTEK3F0pz9gD5kO+/83K9YBOaOE681FKGG9iWEz+HNQJUa2ABI3Wb6f5au
         i3u+8U1PEqBJNtDfKi4A3gXcGcm8GFxYWSPJChhN4bjlfhq2lQ6na+XttT5jjyyhIbk2
         5c/uhc6CSoxbQcjQmJNS7BjNXu+ZA/qaeLA6JYnZII7Y7O4C5J1ov7c410cc0LatjpSB
         eE8g==
X-Gm-Message-State: AOAM533F4hkYQPmhF4VphBh0Un1WBBj1n+UkODdnIrv3AQGmgLu1/Mx+
        bY5SnziWJcxbbHc3DHDi1gQ=
X-Google-Smtp-Source: ABdhPJxy1B6sQ6BX8gsEoD35aZWg0/I80egbTof3yD8aPjbyRzWcncvnZJPA0bCOGiGZWnhWUURr9g==
X-Received: by 2002:a62:644d:0:b029:2d1:1c84:dae5 with SMTP id y74-20020a62644d0000b02902d11c84dae5mr10138919pfb.77.1621014301592;
        Fri, 14 May 2021 10:45:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 79sm4405773pfz.202.2021.05.14.10.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 10:45:00 -0700 (PDT)
Date:   Fri, 14 May 2021 10:44:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next 0/6] ptp: support virtual clocks for multiple domains
Message-ID: <20210514174458.GB19576@hoboy.vegasvil.org>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
 <20210508191718.GC13867@hoboy.vegasvil.org>
 <DB7PR04MB50172689502A71C4F2D08890F8549@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210510231832.GA28585@hoboy.vegasvil.org>
 <DB7PR04MB501793F21441B465A45E0699F8539@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210511154948.GB23757@hoboy.vegasvil.org>
 <DB7PR04MB5017D35C76AAEDEE0319DA12F8509@DB7PR04MB5017.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB7PR04MB5017D35C76AAEDEE0319DA12F8509@DB7PR04MB5017.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 06:41:28AM +0000, Y.b. Lu wrote:
> I give up supporting physical clock and the timecounters adjusting at the same time, but I may continue to support virtual clock per your suggestion.

Okay, so the physical clock stays free running when virtual clocks are
active.

> Getting back to your user space idea, I'd like to understand further to see if I can make some contribution.
> Actually I can't think out how to track (there is not timecouner like in kernel) in a easy way, and I have some concerns too.

Maybe I was not clear before.  You can implement the virtual clocks in
the kernel.  User space will not need to be involved.

It is easy for the kernel to hide the physical clock when virtual
clocks are created from it.

Thanks,
Richard

