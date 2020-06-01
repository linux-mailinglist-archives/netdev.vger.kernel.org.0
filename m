Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A814A1EA533
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 15:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgFANk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 09:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgFANk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 09:40:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCBEC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 06:40:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id p5so5618910wrw.9
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 06:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IG1LNnXURRkU6TgMc6yGnkqy1XnH8Wt7NC9998fcIzw=;
        b=ItEaAklqEaZ9ggAUrZd+fvG2Zq5B8zUJD6j093SbAkr6lksa24WHO2LqB3Lwxuc6f0
         SqEldx/7pLjdTcaMcSsdGPAWPx4V2QRH05ufrUg8mK53Bxwemqta/L2rGZZnfre3OYQK
         xYnJ1Xx9ckYtimNnP3UPGUjcoVEqVN39iKt0TrEoRG8cfvaR11o3nRCLik6oOvIwsykB
         J1KV3qMreVWUlhde6RYrXQkcCzFVc7uZ4hCmwIc/EPRG//CSCRvNa1+KRjUDOoF6oQ5J
         jBsWlvRj3SKeaKeLXKXTCITPpe56MnEipEwIl2z/arO+OfCswylpNBsN1+JjOHlHIf9t
         IdiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IG1LNnXURRkU6TgMc6yGnkqy1XnH8Wt7NC9998fcIzw=;
        b=ixX4ITbpZVW+rsVCdMHvfS2M0QVNKm31PKmE7Y0CoPYqIsCb+ItRbWhVDuScLT3cPa
         A6/q9QpOz2WUgcMNslC+6X84O2/S1IQmcK8FhaGFqMfL5B9mjyD+cLZwMBmxKHj+Ms9T
         a7THdneRG4Ct08z1dNbqFPOeM2boIzB+WmmlHmAEUTsEWD3u76RpIRJAcssZcJ6//W18
         fln73N0pPrXo+wYstVUoG90UOhYDfGU5XQQYkn7nLqD7ssxm1r8KB8PQdrcdPmRuqhN+
         FJmRkTr1gV5x1hYtponUxYNi8b7H9fg3OXlu6ztwBnDJT4aimK+Kkq8VNMf1QqDlPK6z
         AQTg==
X-Gm-Message-State: AOAM5331acllcKIcfJeYEFtr8F7evEtpFxWnH7Jfbnu775a2F9Rv8P/R
        t+GIiPCN/6UM4M4OITGnPTOoJw==
X-Google-Smtp-Source: ABdhPJwLH7JtfmcI2VjUTgSLJfnjYw5rNvZSSo9t3BoS+uzgXZD2JCKTsCJnQlfkPinO9DXcVZQLAA==
X-Received: by 2002:adf:f0c6:: with SMTP id x6mr23679334wro.301.1591018825409;
        Mon, 01 Jun 2020 06:40:25 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id u3sm13851540wmg.38.2020.06.01.06.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:40:24 -0700 (PDT)
Date:   Mon, 1 Jun 2020 15:40:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Petr Machata <petrm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
Message-ID: <20200601134023.GQ2282@nanopsycho>
References: <cover.1590512901.git.petrm@mellanox.com>
 <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, May 27, 2020 at 06:09:03AM CEST, xiyou.wangcong@gmail.com wrote:
>On Tue, May 26, 2020 at 10:11 AM Petr Machata <petrm@mellanox.com> wrote:
>>
>> The Spectrum hardware allows execution of one of several actions as a
>> result of queue management events: tail-dropping, early-dropping, marking a
>> packet, or passing a configured latency threshold or buffer size. Such
>> packets can be mirrored, trapped, or sampled.
>>
>> Modeling the action to be taken as simply a TC action is very attractive,
>> but it is not obvious where to put these actions. At least with ECN marking
>> one could imagine a tree of qdiscs and classifiers that effectively
>> accomplishes this task, albeit in an impractically complex manner. But
>> there is just no way to match on dropped-ness of a packet, let alone
>> dropped-ness due to a particular reason.
>>
>> To allow configuring user-defined actions as a result of inner workings of
>> a qdisc, this patch set introduces a concept of qevents. Those are attach
>> points for TC blocks, where filters can be put that are executed as the
>> packet hits well-defined points in the qdisc algorithms. The attached
>> blocks can be shared, in a manner similar to clsact ingress and egress
>> blocks, arbitrary classifiers with arbitrary actions can be put on them,
>> etc.
>
>This concept does not fit well into qdisc, essentially you still want to
>install filters (and actions) somewhere on qdisc, but currently all filters
>are executed at enqueue, basically you want to execute them at other
>pre-defined locations too, for example early drop.
>
>So, perhaps adding a "position" in tc filter is better? Something like:
>
>tc qdisc add dev x root handle 1: ... # same as before
>tc filter add dev x parent 1:0 position early_drop matchall action....
>
>And obviously default position must be "enqueue". Makes sense?


Well, if you look at the examples in the cover letter, I think that they
are showing something very similar you are talking about:

# tc qdisc add dev eth0 root handle 1: \
        red limit 500K avpkt 1K qevent early block 10
# tc filter add block 10 \
        matchall action mirred egress mirror dev eth1


The first command just says "early drop position should be processed by
block 10"

The second command just adds a filter to the block 10.



We have this concept of blocks, we use them in "tc filter" as a handle.

The block as a unit could be attached to be processed not only to
"enqueue" but to anything else, like some qdisc stage.

Looks quite neat to me.



>
>(The word "position" may be not accurate, but hope you get my point
>here.)
>
>Thanks.
