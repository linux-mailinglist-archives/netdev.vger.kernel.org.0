Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4F967ADD
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 17:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfGMPNw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Jul 2019 11:13:52 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35074 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfGMPNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 11:13:52 -0400
Received: by mail-ot1-f68.google.com with SMTP id j19so12452676otq.2
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 08:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0PMxlvPFej/K8H4dBy+8uMq9iVXA9coH+2yUUvPdrF8=;
        b=QQ286EDcVdsw0HPjSS5AjMBsYNgY9QouR9s+2wujv2mf6z+cxyyHOrCfRQDCY/ikQ0
         VVC8OczrFn3yxl+KC+EWnF00tlkSab+ptXZUnC1VwnEN6m2Ts+2h6LXTffpMkIsX1D4Y
         t9rYKBOigiuJk37gBHyjJswQnAeIpG1989mGErRiOtwVA0XvYcW+6YMZi3L/38JvpmGh
         S0+rSHIRsp6mNll3b4nWjW41X8yErQ/DHsDSvk6fVvVAufLNaeNm9hMXquWFGQvpTmml
         2YSJZVJnVBqZTUapCrc50pKCkW/bX3AVDt8MPCgyZo/EXEDNjTSpIatDsDG6H/7DqdRc
         60ew==
X-Gm-Message-State: APjAAAX2K/kuxoPTLKdNWMza9N4EMO2HjyeM8dO5VLXx8Vp3VNeZ10Fa
        oRfH8f1yj1CWrJvGdDTb/u6BCoJYi+pJblqJQK0ayQ==
X-Google-Smtp-Source: APXvYqwGEG+1LMaDQ8nLpCUkZJWpPVlTXVBYGxp0PwdULLA2yMlGDFwp/0GCy4Vg7zfbhEls32WtXXFEdgJ0FdpHesg=
X-Received: by 2002:a9d:4d04:: with SMTP id n4mr11808765otf.234.1563030831165;
 Sat, 13 Jul 2019 08:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <7b254317bcb84a33cdbe8eed96e510324d6eb97c.1562951883.git.lorenzo.bianconi@redhat.com>
 <20190712.154047.1787144778692165503.davem@davemloft.net> <20190712.154225.26530675805696474.davem@davemloft.net>
In-Reply-To: <20190712.154225.26530675805696474.davem@davemloft.net>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 13 Jul 2019 17:13:40 +0200
Message-ID: <CAJ0CqmXZgaHV+NQ6fcaJQvmg3FL-tYfvaz6E9FFyXXGZtHonyg@mail.gmail.com>
Subject: Re: [PATCH net] net: neigh: fix multiple neigh timer scheduling
To:     David Miller <davem@davemloft.net>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> From: David Miller <davem@davemloft.net>
> Date: Fri, 12 Jul 2019 15:40:47 -0700 (PDT)
>
> > From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > Date: Fri, 12 Jul 2019 19:22:51 +0200
> >
> >> Neigh timer can be scheduled multiple times from userspace adding
> >> multiple neigh entries and forcing the neigh timer scheduling passing
> >> NTF_USE in the netlink requests.
> >> This will result in a refcount leak and in the following dump stack:
> >  ...
> >> Fix the issue unscheduling neigh_timer if selected entry is in 'IN_TIMER'
> >> receiving a netlink request with NTF_USE flag set
> >>
> >> Reported-by: Marek Majkowski <marek@cloudflare.com>
> >> Fixes: 0c5c2d308906 ("neigh: Allow for user space users of the neighbour table")
> >> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> >
> > Applied and queued up for -stable, thanks.
>
> Actually, reverted, you didn't test the build thoroughly as Infiniband
> fails:
>
> drivers/infiniband/core/addr.c: In function ‘dst_fetch_ha’:
> drivers/infiniband/core/addr.c:337:3: error: too few arguments to function ‘neigh_event_send’
>    neigh_event_send(n, NULL);
>    ^~~~~~~~~~~~~~~~

Hi Dave,

sorry for the issue. I will post a v2 fixing it

Regards,
Lorenzo
