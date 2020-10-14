Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0693F28DE2A
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgJNJ65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728780AbgJNJ5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:57:51 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF3C061755;
        Wed, 14 Oct 2020 02:57:51 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e22so3974247ejr.4;
        Wed, 14 Oct 2020 02:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VtXUrs3HvkSmOwbOHaAyusjO/2rUgksGvnN5UchroQw=;
        b=oT5bUv+od9VQQxqGhsrjHG+82/dnpqUHCiQnFTC/DzU00s+f+Si+Rv65bzsGWlg3ZC
         EJb5vB9z/1mlVOp7+nOeMN14LgusLlDFl9Hzq0CHt90cl25FrAXA7JAyaGBGdj9NbFpI
         qGrHtYPBx4Jyfo6sxwlDwhhN9S4EOHjSFZUfMI1L1ENFqfWfH/Cegk+eFrm0aDx3JJLo
         fkvZ54gxk6nPfBSbDjrGjWbfdsbs+kHQQXKPbx6ZXL7/o3L8ZVxz6/0h3/emNvvN6pRL
         PAUK8m8OJbgJ5ptuZgZ6/oBBTJ5GpSt+PDC7tTK+zQHMsWLt2cv53yByjV9+oAAorcZL
         zQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VtXUrs3HvkSmOwbOHaAyusjO/2rUgksGvnN5UchroQw=;
        b=l8Vi1yshFdLzm/xIjVkoMh9XHi9wY+NrKiJof3j7T2fXMJa8L0eoLXs4Hy0woX69gt
         HYevhd1YK/o8fAinXjprN2/8PBreCVXWj1abHyZAKpLFO8rFXrMkD36P8UusTvXKQ/gF
         p+sqdwOHqGejlqBz17VEK76Ihd1dDvrzfASJ8sos6MipJctaapLj9XGF4uUIXyyFYlhN
         dF3RoDO6jNgAMNHmwKXILyQBqocC8fxYJP6rT+JJH/syEGEoSreo/bfQBFE/qN021P+B
         CczkGlSYIeqmdrLj4X6cJp/XtU4G2jbKVWAKiZUTIUSr/T96A0DBvZUhODxyri1qY36a
         5ZkA==
X-Gm-Message-State: AOAM532uFZao7fy9if/m/vrMB6q2j2Mh7zNABfs6mvB0WqaPzAGZZbZQ
        XbddBAZlYLZgLxJRSQ/WOKY=
X-Google-Smtp-Source: ABdhPJw6o1YhX+FsWOwonbrza5pbiIZB9/F71b/Epd/hTd4tScJFuyfs0Cc1v+ymxyTddSylD+cMdw==
X-Received: by 2002:a17:906:86ce:: with SMTP id j14mr4450200ejy.158.1602669469761;
        Wed, 14 Oct 2020 02:57:49 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id v14sm1224071edy.68.2020.10.14.02.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 02:57:49 -0700 (PDT)
Date:   Wed, 14 Oct 2020 12:57:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 4/7] net: dsa: hellcreek: Add support for
 hardware timestamping
Message-ID: <20201014095747.xlt3xodch7tlhrhr@skbuf>
References: <20201006140102.6q7ep2w62jnilb22@skbuf>
 <87lfgiqpze.fsf@kurt>
 <20201007105458.gdbrwyzfjfaygjke@skbuf>
 <87362pjev0.fsf@kurt>
 <20201008094440.oede2fucgpgcfx6a@skbuf>
 <87lfghhw9u.fsf@kurt>
 <f040ba36070dd1e07b05cc63a392d8267ce4efe2.camel@hs-offenburg.de>
 <20201008150951.elxob2yaw2tirkig@skbuf>
 <65ecb62de9940991971b965cbd5b902ae5daa09b.camel@hs-offenburg.de>
 <20201012214254.GA1310@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012214254.GA1310@hoboy>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 02:42:54PM -0700, Richard Cochran wrote:
> If you want, you can run your PHC using the linuxptp "free_running"
> option.  Then, you can use the TIME_STATUS_NP management request to
> use the remote time signal in your application.

I was expecting some sort of reaction to this from Kamil or Kurt.

I don't think that 'using the remote time signal in an application' is
all that needs to be done with the gPTP time, at least for a switch with
the hardware features that hellcreek has. Ultimately it should be fed
back into the hardware, such that the scheduler based on 802.1Q clause
8.6.8.4 "Enhancements for scheduled traffic" has some time scale based
on which it can run. Running tc-taprio offload on top of an
unsynchronized clock is not something productive.

So the discussion is about how to have the cake and eat it at the same
time. Silicon vendors eager to follow the latest trends in standards are
implementing hybrid PTP clocks, where an unsynchronizable version of the
clock delivers MAC timestamps to the application stack, and a
synchronizable wrapper over that same clock is what gets fed into the
offloading engines, like the ones behind the tc-taprio and tc-gate
offload. Some of these vendors perform cross-timestamping (they deliver
a timestamp from the MAC with 2, or 3, or 4, timestamps, depending on
how many PHCs that MAC has wired to it), some don't, and just deliver a
single timestamp from a configurable source.

The operating system is supposed to ??? in order to synchronize the
synchronizable clock to the virtual time retrieved via TIME_STATUS_NP
that you're talking about. The question is what to replace that ???
with, of course.

> > I'm not an expert in kernel implementation but we have plans to discuss
> > possible approaches in the near future.
>
> I don't see any need for kernel changes in this area.

I'm not an expert in kernel implementation either, but perhaps in the
light of this, you can revisit the idea that kernel changes will not be
needed (or explain more, if you still think they aren't).

Since IEEE 60802 keeps talking about multiple time domains to be used
with 802.1AS-rev (a 'universal clock domain' and a 'working clock
domain'), a decision needs to be taken somewhere about which time base
you're going to use as a source for synchronizing your tc-taprio clock.
That decision should best be taken at the application level, so in my
opinion this is an argument that the application should have explicit
access to the unsynchronizable and to the synchronizable versions of the
PTP clock.

In the Linux kernel API, a network interface can have at most one PHC.

--------------

DISCLAIMER
Yes, I know full well that everyone can write a standard, but not
everyone can implement one. At the end of the day, I'm not trying to
make an argument whether the end result is worth making all these
changes. I'm only here to learn what other people are doing, how, and
most importantly, why.
