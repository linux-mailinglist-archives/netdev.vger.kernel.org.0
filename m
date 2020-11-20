Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5DF2BB16D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgKTR1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgKTR1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 12:27:41 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317F0C0613CF;
        Fri, 20 Nov 2020 09:27:41 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id f18so7837385pgi.8;
        Fri, 20 Nov 2020 09:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tTaqUjFR6qohzjo0Ozc5Dz6/DxjLc48CR/b9BYuGS5Y=;
        b=ZSq9w9daEKh7gjtCs4Qi3wXJinXvZAq4OworGl/BOQCPqCQhz633qsHfEky4mBQPNf
         We3kDc9/eGtHdwCj09Hm06MDloYQZoTDrjKfk++aMa1fCfVX8eZ3cfLwq0u8lNmw2sh9
         s9stQwhNl9IKY0FiKoJjAO1M41e6anSpHH0oA169LRq0/RAinLP0YwF/HTIMhv53by5z
         p+D+jMO4W7bO54tzXbE1Y7PjzLiUzmzGJS7HOi0+FZH7bT3Ee3oRrmWEqL2t1smVOrFz
         yB/TO+9AIWuZksg0XA3l5LUo5ir7fwchvXB5s5A3N0zvCgWKCvs41qH9EUF7a8/A9UiS
         EZjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tTaqUjFR6qohzjo0Ozc5Dz6/DxjLc48CR/b9BYuGS5Y=;
        b=B0W634IzZIFva3plWcLzUUPZfcB16bM4dVhJl9upuodqvV6YZnrkx/TU727qBLnVxD
         JlwjHfwp+aMdnDxEfKEocOHijhzspQvz0oOXir3yG/2/IUurYLQ4LEFtJu2lzl3lk/Ik
         yMxhIA5LrGH87K8yPdBEIbBRlQn+H7XANWYbnB5Y6BQdC4896jO47EvKw+flwB3FkN/I
         BROGcQyGwxiMyRMNrO0yX6bn7iM7LWmi/mhUYZPUYkdNLB7yGvpI5lLtlliSl4f+wyuv
         DzYRnUxrMLpktRjVucidMw1KkfNV/7X/alTmd2k3d73F+5i0uGmDLNJ99eEiKg9uRgJt
         IWFw==
X-Gm-Message-State: AOAM530Yno2OVcyrb3tEkglayZxKuo0fXHHFUwtG/T9Ld9N3AkLOfGdV
        QgJnkryZl3YjBb1L3LzZ6K52303Ln/YnzQ==
X-Google-Smtp-Source: ABdhPJxRrba6MdAsnXAspyEBbcbm/tLVhWs2u98EkeXDKVN8iYN/kg2b7/dKjflk0gUXsHzerJhESg==
X-Received: by 2002:a63:5043:: with SMTP id q3mr17493250pgl.137.1605893260530;
        Fri, 20 Nov 2020 09:27:40 -0800 (PST)
Received: from ?IPv6:2601:648:8400:9ef4:34d:9355:e74:4f1b? ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.gmail.com with ESMTPSA id i13sm4132181pfo.139.2020.11.20.09.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 09:27:40 -0800 (PST)
Message-ID: <b7b2f834e2ecdd0a973d65b0cbaf73ef2c68e899.camel@gmail.com>
Subject: Re: [PATCH v4 net-next 0/3] add support for sending RFC8335 PROBE
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 20 Nov 2020 09:27:39 -0800
In-Reply-To: <8ac13fd8-69ac-723d-d84d-c16c4fa0a9ab@gmail.com>
References: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
         <b4ce1651-4e45-52eb-7b2e-10075890e382@gmail.com>
         <8ac13fd8-69ac-723d-d84d-c16c4fa0a9ab@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-11-19 at 21:01 -0700, David Ahern wrote:
> On 11/19/20 8:51 PM, David Ahern wrote:
> > On 11/17/20 5:46 PM, Andreas Roeseler wrote:
> > > The popular utility ping has several severe limitations such as
> > > the
> > > inability to query specific  interfaces on a node and requiring
> > > bidirectional connectivity between the probing and the probed
> > > interfaces. RFC8335 attempts to solve these limitations by
> > > creating the
> > > new utility PROBE which is a specialized ICMP message that makes
> > > use of
> > > the ICMP Extension Structure outlined in RFC4884.
> > > 
> > > This patchset adds definitions for the ICMP Extended Echo Request
> > > and
> > > Reply (PROBE) types for both IPv4 and IPv6. It also expands the
> > > list of
> > > supported ICMP messages to accommodate PROBEs.
> > > 
> > 
> > You are updating the send, but what about the response side?
> > 
> 
> you also are not setting 'ICMP Extension Structure'. From:
> https://tools.ietf.org/html/rfc8335
> 
>    o  ICMP Extension Structure: The ICMP Extension Structure
> identifies
>       the probed interface.
> 
>    Section 7 of [RFC4884] defines the ICMP Extension Structure.  As
> per
>    RFC 4884, the Extension Structure contains exactly one Extension
>    Header followed by one or more objects.  When applied to the ICMP
>    Extended Echo Request message, the ICMP Extension Structure MUST
>    contain exactly one instance of the Interface Identification
> Object
>    (see Section 2.1).

I am currently finishing testing and polishing the response side and
hope to be sendding out v1 of the patch in the upcoming few weeks.

As for the 'ICMP Extension Structure', I have been working with the
iputils package to add a command to send PROBE messages, and the
changes included in this patchset are all that are necessary to be able
to send PROBEs using the existing ping framework.

