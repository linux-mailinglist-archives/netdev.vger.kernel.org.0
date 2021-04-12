Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5B35C3A1
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238230AbhDLKU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238201AbhDLKUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:20:25 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BD8C06174A;
        Mon, 12 Apr 2021 03:20:07 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id v6so18085807ejo.6;
        Mon, 12 Apr 2021 03:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5hqw/44+1SIH720EkfWDzKzcUCIKnta6uVc1fnKDxhA=;
        b=sX8l7AZdKd3Lti0uXjwNsts08RmyL5T6dZ+1ek/fSnyPkehCkMoLpF3IefDDf0CI+g
         qdg1vCMnEb7Oc8vCNOsiOdWzoJPchrRp5GM4ZtTMqDU4P8chGvnZXSGSCvBJYWdMPoiG
         w42lr0ZUlXwpxDM7R9Hy/GX08WJrqPh9VZc1zpB7K0nwuqe+sj3RCOW7qRTZTjzyod76
         yFL3iiYX7WMrknVFy8RB00M5p63ocOc8ojNcPC01qHXYov50Zd+gYlf/g4qMWDGlk0NC
         TeEtaa1CsOIuZK2gIWxiwseWzEj9wulzeIEmw4lJ/u3oK32PiLrNsTtQ07b/0I6dEkHx
         8weA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5hqw/44+1SIH720EkfWDzKzcUCIKnta6uVc1fnKDxhA=;
        b=kkwHp/j1zdyHjIvqEqNtio0hPf2yZCJ4w1frOSQ0hpdWvirRmDM3D4cM7EePCg4VHC
         aNDJyiN6lh0YKECQGxcYwJsb2RLYH9gTR/JQ2q8EgNIZqOfQDckgqVOztPVVmMm2Uyl/
         Gt8E1fRYDmijOjsznZ/wS65pQsqA8/bkRqMOnMGHUv9zE7PgbiroExb6uG6BVFjAAdgk
         Rth4walk5aUV2RbiGJL4kr1uJd7kuxd+TWQvvWCoUBqULPfRqbeEKi9mWZd2XnMdxb1n
         S/I4ol4fEBUqylqrpLdass68ZAHvbCZu7zdLDTld/eX7qatB8YM9OiF2UzNpWCSl4GcR
         sDFw==
X-Gm-Message-State: AOAM531r3GQdQlXkIeBNsXgNV0H3SJ4RK+SPdwSht4/OKAYMAG3QpjSh
        a1IUQf/pg7pUx/H7C9wwT0Y=
X-Google-Smtp-Source: ABdhPJweNUwzhWu8CG3IKOG0D1pQ7wG6gc+gU5r6VNp4baO7HjwmCRRZ54TJPVET9sdDTdAlXIOQwg==
X-Received: by 2002:a17:907:76a7:: with SMTP id jw7mr2828285ejc.322.1618222804696;
        Mon, 12 Apr 2021 03:20:04 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-34-220-97.business.telecomitalia.it. [79.34.220.97])
        by smtp.gmail.com with ESMTPSA id q16sm6310602edv.61.2021.04.12.03.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 03:20:04 -0700 (PDT)
Date:   Mon, 12 Apr 2021 06:41:58 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/3] net: dsa: allow for multiple CPU ports
Message-ID: <YHPPlnXbElN4qJ/r@Ansuel-xps.localdomain>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210410133454.4768-2-ansuelsmth@gmail.com>
 <20210412033525.2472820-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412033525.2472820-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 11:35:25AM +0800, DENG Qingfang wrote:
> On Sat, Apr 10, 2021 at 03:34:47PM +0200, Ansuel Smith wrote:
> > Allow for multiple CPU ports in a DSA switch tree. By default the first
> > CPU port is assigned mimic the original assignement logic. A DSA driver
> > can define a function to declare a preferred CPU port based on the
> > provided port. If the function doesn't have a preferred port the CPU
> > port is assigned using a round-robin way starting from the last assigned
> > CPU port.
> > Examples:
> > There are two CPU port but no port_get_preferred_cpu is provided:
> > - The old logic is used. Every port is assigned to the first cpu port.
> > There are two CPU port but the port_get_preferred_cpu return -1:
> > - The port is assigned using a round-robin way since no preference is
> >   provided.
> > There are two CPU port and the port_get_preferred_cpu define only one
> > port and the rest with -1: (wan port with CPU1 and the rest no
> > preference)
> >   lan1 <-> eth0
> >   lan2 <-> eth1
> >   lan3 <-> eth0
> >   lan4 <-> eth1
> >   wan  <-> eth1
> > There are two CPU port and the port_get_preferred assign a preference
> > for every port: (wan port with CPU1 everything else CPU0)
> >   lan1 <-> eth0
> >   lan2 <-> eth0
> >   lan3 <-> eth0
> >   lan4 <-> eth0
> >   wan  <-> eth1
> 
> So, drivers will read the name of every port and decide which CPU port
> does it use?
>

Yes, this seems to be an acceptable path to follow. The driver can
provide a preferred CPU port or just tell DSA that every cpu is equal
and assign them in a round-robin.

> > 
> > Signed-off-by: Marek Beh?n <marek.behun@nic.cz>
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
