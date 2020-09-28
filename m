Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EC527A5BB
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 05:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgI1DNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 23:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgI1DNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 23:13:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851E6C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:13:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so8038118pfa.10
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KCG7HYwJMoiOFJvw/5PkgII0ERY2IpaG7B2XRaf7Su8=;
        b=q78a5Bsu81G3cVielLFd3MdmyJJlfP9HEOFM7SUB4waTbvWq9Zw6f6fgkDdap7dVa5
         aMqthFanhOuqKSxajtv4hKWA1JrDPp2tLik1uVcW3J6su0vjn1EXYlKnZt0fCPs+MiSF
         oxc6JfMhZxP6K/Z9357YVuIeXg0aF/Y6aj+K2lGYpxtAEBPoVNUM9j9EE/OLoMqhVWGA
         zagUw6wyKnb2fmSGpsmREf0kNddNybgrcfWOgWqTnZJfbxuY1+TgF+wLvHb9biIbh/vU
         4ukHxXzuBlV9OPfg5pJSyLYSIiL/r45XeSUa/ooVZ2wuG9wypDrFtGsQBUO7Nm64WPzd
         jLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KCG7HYwJMoiOFJvw/5PkgII0ERY2IpaG7B2XRaf7Su8=;
        b=iejQnYbTLxzoArjc3I6AFiuZX4FiWsRhnfCCUqsZY1frmrEtvxpwYd66LoPvaaNJto
         EEB5G0/qiz4zU7PoS1iqzymWlgePmgwPbQ9iu2pbEmBcxEIXtomrJkOUJqZ8SqxKPSr/
         oavfL17j3LtPY3Fyl8/Cx9v3J/ro7HPbcsIjwsi4GS9kexPZ9r2p6+rEKRn3gUj16oIC
         KDB1i865MnzWFGxKMZpuAE6gDRK/IWoXS/95dZiSvdXhru18tcNsH4PeVRHeNPnqMv4Z
         dNR5oQCs7XScrNf246XquXcG7lE+HknN2xw0zXQ38k6NrnR/Z+jV/KDsLCc7SW9sZg2k
         Y/og==
X-Gm-Message-State: AOAM532a0O4nxfG+j6xxxw9xtNuqrwwshuTIiuEA9rNx0HHfQ10rpnmQ
        dIJK0r7yk4j6PKYGQnjBQVs=
X-Google-Smtp-Source: ABdhPJxfLGbfSdMp76BKstx+WDDkYAg8vIXXelk2YadkhWo/IedSdldyRIyMiubyi7DMFemVsaC21Q==
X-Received: by 2002:a63:5f55:: with SMTP id t82mr2428632pgb.195.1601262794792;
        Sun, 27 Sep 2020 20:13:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id i36sm2437222pgm.43.2020.09.27.20.13.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2020 20:13:13 -0700 (PDT)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dahern@digitalocean.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk>
 <0dc879c5-12ce-0df2-24b0-97d105547150@digitalocean.com>
 <87wo88wcwi.fsf@toke.dk>
 <CAJ8uoz2++_D_XFwUjFri0HmNaNWKtiPNrJr=Fvc8grj-8hRzfg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b6609e0a-eb2f-78bd-b565-c56dce9e2e48@gmail.com>
Date:   Sun, 27 Sep 2020 20:13:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2++_D_XFwUjFri0HmNaNWKtiPNrJr=Fvc8grj-8hRzfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/20 2:41 AM, Magnus Karlsson wrote:
> I will unfortunately be after Netdevconf due to other commitments. The
> plan is to send out the RFC to the co-authors of the Plumbers
> presentation first, just to check the sanity of it. And after that
> send it to the mailing list. Note that I have taken two shortcuts in
> the RFC to be able to make quicker progress. The first on is the
> driver implementation of the dynamic queue allocation and
> de-allocation. It just does this within a statically pre-allocated set
> of queues. The second is that the user space interface is just a
> setsockopt instead of a rtnetlink interface. Again, just to save some
> time in this initial phase. The information communicated in the
> interface is the same though. In the current code, the queue manager
> can handle the queues of the networking stack, the XDP_TX queues and
> queues allocated by user space and used for AF_XDP. Other uses from
> user space is not covered due to my setsockopt shortcut. Hopefully
> though, this should be enough for an initial assessment.

Any updates on the RFC? I do not recall seeing a patch set on the
mailing list, but maybe I missed it.
