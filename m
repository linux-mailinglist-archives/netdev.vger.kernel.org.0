Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0741274654
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 18:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgIVQOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 12:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgIVQOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 12:14:31 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86523C0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 09:14:31 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id cv8so9793831qvb.12
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 09:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zWPzhPXud6VNhoCoKGqUlfr5qEum5vqp/NMsQDoLUC4=;
        b=RRTG2t9njyMOevdlLC86wlJd8D+yLCyG9Mq/1GV3EqYWmcoFhCpIJCaqyD5hMjWHrm
         ASqRwBQZhe7tZdDG4NpyUvtKqravrSvdY63jU91WxlMbKC6k2KqS+9JJg1hVxH2hUYJW
         hRHVszuAnEfbFs+5BjttohWpXBv8jHWSsEnHn5ol0dVtpWBfbCtFir4O0FU2wwD/Xk6x
         RnXv40YGeTdbI9b35RLql3k3eznGKLEVtGReKnVFFYy0MPZHpIt2b4PkM5Byv6f5bZSi
         reykqmJQ67hPUeYRgwNtq67GR+xgJscw2aaO0BPzulVjXiFnubqwnIc/DPIeoNCo0uAb
         Rp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zWPzhPXud6VNhoCoKGqUlfr5qEum5vqp/NMsQDoLUC4=;
        b=VfVjbV5mWSPc+ECRi7qWvhXzLB7jkIHo0mGjQaIcrm9GUbX5EIzt6psQcc+pnP19Db
         ZqFycCs7oZtcd8Sq9ZF3RCMTi/eX8MNxiHg1bdfZ6uCmZus/JPjcgDqD2JVgK89kv9vV
         z61mzv3n+26FgzzzNye9yL8ItPTEbY+WJ7Z2urydhE6ncuU/v1L8ymDQpeHBQ3rjXBZy
         QsdTnkKmDcT95yFqTbc/v85B6/jK3wuu1wOz6xBfF9TJZVn7Shv0UwcQ0vQFQFHQP+2q
         MAbhXx0Wn4RQaYSP8+kqhQ5FKSbIdPRkUkV11WTrR9y2TAkS64GHgmrwdwJNC6w1yhv7
         4+Cg==
X-Gm-Message-State: AOAM533xNy9tzZa9K5gnQR+skrUoJK/VRlYqluYB2LpdxluRz0ppbOFW
        nPiOQiJ6EjvRAPxKFXuAja56oQ==
X-Google-Smtp-Source: ABdhPJw5me7Js3130zPe33NMl4wTjhVJqXvfKdaP/dBlNq6WGqmASS+7NuMfwF30JNVJVNBJuzrpMw==
X-Received: by 2002:a0c:9c09:: with SMTP id v9mr6773362qve.57.1600791270713;
        Tue, 22 Sep 2020 09:14:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t1sm13140036qtj.12.2020.09.22.09.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 09:14:29 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kKkw1-0034kp-8i; Tue, 22 Sep 2020 13:14:29 -0300
Date:   Tue, 22 Sep 2020 13:14:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        izur@habana.ai, Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200922161429.GI8409@ziepe.ca>
References: <20200918135915.GT8409@ziepe.ca>
 <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
 <20200918141909.GU8409@ziepe.ca>
 <CAFCwf121_UNivhfPfO6uFoHbF+2Odeb1c3+482bOXeOZUsEnug@mail.gmail.com>
 <20200918150735.GV8409@ziepe.ca>
 <CAFCwf13y1VVy90zAoBPC-Gfj6mwMVbefh3fxKDVneuscp4esqA@mail.gmail.com>
 <20200918152852.GW8409@ziepe.ca>
 <b0721756-d323-b95e-b2d2-ca3ce8d4a660@amazon.com>
 <20200922114101.GE8409@ziepe.ca>
 <a16802a2-4a36-e03d-a927-c5cb7c766b99@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a16802a2-4a36-e03d-a927-c5cb7c766b99@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 03:46:29PM +0300, Gal Pressman wrote:

> I agree, that makes sense.
> But assuming Oded actually goes and implements all the needed verbs to get a
> basic functional libibverbs provider (assuming their HW can do it somehow), is
> it really useful if no one is going to use it?
> It doesn't sound like habanalabs want people to use GAUDI as an RDMA adapter,
> and I'm assuming the only real world use case is going to be using the hl stack,
> which means we're left with a lot of dead code that's not used/tested by anyone.
> 
> Genuine question, wouldn't it be better if they only implement what's actually
> going to be used and tested by their customers?

The general standard for this 'accel' hardware, both in DRM and RDMA
is to present an open source userspace. Companies are encouraged to
use that as their main interface but I suppose are free to carry the
cost of dual APIs, and the community's wrath if they want.

At least for RDMA this is guided by the founding event of Linux RDMA
where all customers demanded the madness of every supplier having a
unique software stack from the kernel down stop. Since then the low
level stack has been cross vendor and uniform.

Jason
