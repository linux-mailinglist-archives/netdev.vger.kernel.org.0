Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C433E155F2C
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 21:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgBGURR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 15:17:17 -0500
Received: from mail-ot1-f41.google.com ([209.85.210.41]:41598 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgBGURR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 15:17:17 -0500
Received: by mail-ot1-f41.google.com with SMTP id r27so511743otc.8;
        Fri, 07 Feb 2020 12:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x3wB7YY1fRCwc0Rcjpsnf9RPpbvUJVdJq+zyRdJ95Ew=;
        b=k20bEmKmL7wIEsac3txRhkfqmaxW+RKc3FUw9I9jiIOtkfvXWEaGFNz6ew4ilU6+4s
         SFEANniV07StdP9ull4Cxb2VEwvydqSU+LaWdtbYNkHHbavsag7368FnmXQnnA5nj7Wd
         GqYlMupz+gMi+nepsNFyYJxSRbVOy6kiQt0aOBtl/HH00Gtx4RuG7zXgUMB+YAF7RhFn
         3Y6lxtwWyinAChAzP6KaFoOiP+Ricobng7IBw1Oi0TqYfFvye1Z4AiIqlBWMlRvP9ow4
         ekLEMtZ7bfTQ7DLxjZIBQi4To6YWEeyjH3AWrfMiWCwbt/uspJ+9mMOiTEy9YMgvJXjy
         JTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x3wB7YY1fRCwc0Rcjpsnf9RPpbvUJVdJq+zyRdJ95Ew=;
        b=dO9PvRx532WmL17VMfBQ4Bjikz1YNJhslY7LAjfGrmwzVwSkkcjuPBRtb0VgLlrZhV
         IFhNocUlXBFbJEd+rzhb8VOs/ku90NkFcMpfDWCOamfmQUeU7DN37xPvkMtsz1ZSiRHv
         5xMZ+DTRwmIjSne8xoROPeILoKjjCT7KU9T7r6+vmpQzObuQIaPxOXje1ZOvjQ59sVUa
         9HG3sxCHaC6LbmQMiYMDYnCa1BOpE2qFOh6AzHSNGJ01il5VjKvJjmdeVPr1VHpaZH/6
         3M2MFIHuHXMRSNY6UtNxUn5UPRWkOHEopFsrCUYjs6iDoVcVw7ov91DLZhLvSnKgBKMC
         NqNw==
X-Gm-Message-State: APjAAAXR5wwtlTSIPSlpi6v8yM20DBIXQQjqxPL1HAT4H2ASKHjdA6iI
        3W7//gQbYD+VU9srNUYBRD4Q22bzvIlGzyghyRM=
X-Google-Smtp-Source: APXvYqxq2Jc5425rLZWEg0IJjCR46RUq8RdDjqQ6Tzlm5oIX3JntSyCApIE3AeChzQhwYxWlJB7meg9PeHV2hRDJM2E=
X-Received: by 2002:a05:6830:1e64:: with SMTP id m4mr936111otr.244.1581106635947;
 Fri, 07 Feb 2020 12:17:15 -0800 (PST)
MIME-Version: 1.0
References: <CAK4PFCXqPw2GwaaqLKAsinShVYDLZP3BpWN8Jc5sxyvmy9=H3Q@mail.gmail.com>
In-Reply-To: <CAK4PFCXqPw2GwaaqLKAsinShVYDLZP3BpWN8Jc5sxyvmy9=H3Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 7 Feb 2020 12:17:04 -0800
Message-ID: <CAM_iQpWgH9NpEMDaSiRp2ZXay-m=KwD6t+gNo6v4zPo2c+8_0w@mail.gmail.com>
Subject: Re: network stack rate shaping queues
To:     Kent Dorfman <kent.dorfman766@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Please always CC netdev for networking questions.)

On Thu, Feb 6, 2020 at 9:45 PM Kent Dorfman <kent.dorfman766@gmail.com> wrote:
>
> A general question:
>
> Do the network rate shaping queues apply to all network traffic in the
> system, or just to the AF_INET address family?

If you mean Qdisc's like HTB, they apply universally to all traffic going
through it, unless of course you do your own packet filtering on top.

>
> What if we have other classes of network drivers (non ethernet) that
> also use a BSD socket interface, but a different address family?  Are
> those messages also subject to the rate shaping, or are they generally
> FIFO to the driver queue?
>

They are not specific to Ethernet either.

Thanks.
