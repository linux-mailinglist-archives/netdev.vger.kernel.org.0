Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CB7364922
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240046AbhDSRjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbhDSRjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:39:15 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EAFC06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 10:38:46 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id c6so26721108qtc.1
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 10:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PXeizkeMWE+/24RR1ZzajNSewxVrXulPMs/nV1PFkzU=;
        b=hk2EAFlBGD7gZ9bOyGpopNI23DoYHJf2r9YyFMMVPeZmXoV6305ZTjCJpGDfYSLAVr
         DJwcJSebpji424ASgOp69yMu3G20J12aI2alSZvZkHmxAI2hEro4Q6cfdcPArBS3kiAf
         mAIryybCfT/JIwO2y1Q4zv7lWxbcT5XkAGgwucqknmPW0U/Y1rfAzCmNoCnuphzd9iSw
         NMkngdp5hUdXf/BEvrwj6XKFu0rpc2+6DuMPDrIRTO1PL84nDP1wBiNHzWyjiauQAqLn
         Y9ObnzOg7grZuh/KSSWzry19SiRCzOxkf00Z4LoDEsDgh1y4nw8vBm+Ajngdb3zloAGd
         YqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PXeizkeMWE+/24RR1ZzajNSewxVrXulPMs/nV1PFkzU=;
        b=Ztng9BsqYh3Qp27LQYe2FAjr5TAZSa9pD06Y4TKIGfcgBSvjkMAQPz1xFpnZHXLsqH
         LmOSdb7v925q17ZcHFl/PF/5tv7fYmaqMk51sHNc/faoYspHshoYkkmh+p2CxSpjiitN
         CCR2GlcGo7yn4BQywlMNhiJ7L8JKgH0io0LbNZF/GtELoCOhIwc31AW+gu8D8R2xtz5g
         swRdZUwoLsNfJPmoU4GGWQMYYoZavuNc5jPSsOjDUdJexQL2A2Aft915xa+jY2beQZvv
         keVO+PZXhDvqF1/BIL/h8xh0dsJaRvSxAU7e3X3Jp1MV8ibnrcUfYChgb82xu4sm5HNG
         ZsZw==
X-Gm-Message-State: AOAM530M+dqMy+o7qZY5IZagvO2wfuiV8BoPLCw6Xc52fkj7hoD1u2RB
        PhAzyWgyPfyL/x6hEgQW20w=
X-Google-Smtp-Source: ABdhPJxmoOADiWEVP2LYeRnbBxZOgvQ8QFNuOWBxThr2H81PpMy8JbHX8Je7Wyrt4ROItHmH1QwfYQ==
X-Received: by 2002:ac8:7686:: with SMTP id g6mr787968qtr.388.1618853925257;
        Mon, 19 Apr 2021 10:38:45 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:cf2c:418f:6a5d:9c7a:3723])
        by smtp.gmail.com with ESMTPSA id x13sm9853303qtf.32.2021.04.19.10.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:38:44 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id CB3E8C07BF; Mon, 19 Apr 2021 14:38:42 -0300 (-03)
Date:   Mon, 19 Apr 2021 14:38:42 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wenxu <wenxu@ucloud.cn>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/sched: sch_frag: fix stack OOB read while
 fragmenting IPv4 packets
Message-ID: <YH3AIqKl8b7mF1Pj@horizon.localdomain>
References: <cover.1618844973.git.dcaratti@redhat.com>
 <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80dbe764b5ae660bba3cf6edcb045a74b0f85853.1618844973.git.dcaratti@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 05:23:44PM +0200, Davide Caratti wrote:
> when 'act_mirred' tries to fragment IPv4 packets that had been previously
> re-assembled using 'act_ct', splats like the following can be observed on
> kernels built with KASAN:

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
