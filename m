Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5952A1EDB
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 16:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgKAPEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 10:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgKAPEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 10:04:49 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D215C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 07:04:46 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so15120050ejm.0
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 07:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3X/lPFEvigjBKi9WSbgYI8nd1qcO82zJQqf+5l7Q7P4=;
        b=oPdq5AP10thldtOJ2syi6/nl5aQso8C73Qb+kBRXQoWq8UQnBc5jHjvzYZ6qVXk45B
         yFf7PJ6i/hUYCtRAOuod2snhKGsdhanTzTxUJpnOT1HZXkkUwfQTpLNLousP/ESxFeiu
         mt3yvV1EoJ6d/51UdGxxlXiTDvx3Wi1ASAw8hdDFwQNzKuH4AjPmmPqSSP0yzwqk5FmZ
         AQU8lqjnUdVNilS69d0oZEx/dKrDxNb6GsE6+K09odPVlWQLqeELfvq2mTgpfI5lCYTS
         jqFKatl8t+dBx0Wi9pITjshmQH9zI1zwv4zztnqsmX77LIe82ouwzmkfJ1AzCdyxat8U
         0i/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3X/lPFEvigjBKi9WSbgYI8nd1qcO82zJQqf+5l7Q7P4=;
        b=rVNCYiF0iPmDXR5/el3SJSZH6AnwTbAynB0pc4RRZ5i8/NMvZTWf03uGnzB5MUyCkb
         sMlIgA5XdNbggupUt6yBTwkHVkZDtPUFXxfYUwvJFsf3HICdlAnxVtoL/mtNixNv1NNi
         t3p7HAhotMAvcmwYsP4KDu18LoIWKsauq4hNBXvZHHw6W6Orp8pCQTp7KitdYoSf82z1
         7YH2JO9LlCkVdMfmSH170eO7qVyABTFfz0MDsx7vqeA0bQfpKv2xfIjCdHiW9eRYnOCI
         qAw9cOS9QKRhBRZCyWu740TbCQhtCn7RR+jnSchjFz9s1SqmuHOQ9qUjr5SGPYdGqrLi
         FVxw==
X-Gm-Message-State: AOAM533DxnOOALs7xDNjuJo9OgbeibaEZTL9Xya97yXcwO6lDY88/y92
        YVTv2vCzoNn0yftRGrFjwE0=
X-Google-Smtp-Source: ABdhPJyT9VWDFOca9W+pMIW4b4YkZnJwuF2vl67yBl5l11e1DNM7TBzEzYr0DKY3XdBMnXLwBGfUtg==
X-Received: by 2002:a17:906:8398:: with SMTP id p24mr11620814ejx.401.1604243084754;
        Sun, 01 Nov 2020 07:04:44 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id op24sm7571215ejb.56.2020.11.01.07.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 07:04:44 -0800 (PST)
Date:   Sun, 1 Nov 2020 17:04:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Ivan Vecera <ivecera@redhat.com>, vyasevich@gmail.com,
        netdev <netdev@vger.kernel.org>, UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: Re: [PATCH RFC net-next 00/13] RX filtering for DSA switches
Message-ID: <20201101150442.as7qfa2qh7figmsn@skbuf>
References: <CA+h21hqTxbPyQGcfm3qWeD80qAZ_c3xf2FNdSBBdtOu2Hz9FTw@mail.gmail.com>
 <20200528143718.GA1569168@splinter>
 <20200720100037.vsb4kqcgytyacyhz@skbuf>
 <20200727165638.GA1910935@shredder>
 <20201027115249.hghcrzomx7oknmoq@skbuf>
 <20201028144338.GA487915@shredder>
 <20201028184644.p6zm4apo7v4g2xqn@skbuf>
 <20201101112731.GA698347@shredder>
 <20201101120644.c23mfjty562t5xue@skbuf>
 <20201101144217.GA714146@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101144217.GA714146@shredder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 04:42:17PM +0200, Ido Schimmel wrote:
> If the goal of this thread is to get packet sockets to work with
> offloaded traffic, then I think you need to teach these sockets to
> instruct the bound device to trap / mirror incoming traffic to the CPU.
> Maybe via a new ndo.

A new ndo that does what? It would be exclusively called by sockets?
We have packet traps with tc, packet traps with devlink, a mechanism for
switchdev host MDBs, and from the discussion with you I also gather that
there should be an equivalent switchdev object for host FDBs, that the
bridge would use. So we would need yet another mechanism to extract
packets from the hardware data path? I am simply lacking the clarity
about what the new ndo you're talking about should do.
