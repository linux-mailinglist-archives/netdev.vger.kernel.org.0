Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B11D5C8D9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 07:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfGBFgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 01:36:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35664 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBFgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 01:36:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id s27so7114003pgl.2;
        Mon, 01 Jul 2019 22:36:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ajy6JVx1lkWmN5uHLd7L06nEz3Uuy1QRH/zsClsO0DE=;
        b=kdiuZAoW1OqoK4OInQHEIfu1TF9gSzkxnvbY70Kkr1ScPCPK+sfFKPClZs1gQ/YguB
         /4V//hKurfoZKPZ5iWpTP/hiRjjXueil1p+dA/Fm3ZmEm/TjVwoJWJ6IMEq8sk0vv1lh
         /c7QwUIk5ymPT7Yhjy9d//lDb9aHjaKVmaIfY+DGXShiCEY3O3kazIHyJ2MvJL/7nZtY
         P3IQUIuMlJO579mO3vS5646EZcF9TRvINpiT2Gl21nKvALYRquB+DRZQH9SnOfHjl31q
         TthHzvUILfoC7ORVv8kK5mUChPkBNOFfGNezpS0ZosBh0EuHLAnc0Ov9jIOEiZ6Pb6Gi
         dPpg==
X-Gm-Message-State: APjAAAUPowr1SiMr18+sYiKu6/l8dZswRQiaU1YVu7gI50PLHy2i3UZg
        jc3ZBp0CTTTRUZVi4bvI0a4=
X-Google-Smtp-Source: APXvYqzE5ANjKE2++pjcZguPZrtGdktKUfRj1ZTXsr0NmYYYAdKj39W6LXv+M4cCgGIquaI+4Xf77A==
X-Received: by 2002:a65:4808:: with SMTP id h8mr6103131pgs.22.1562045803581;
        Mon, 01 Jul 2019 22:36:43 -0700 (PDT)
Received: from ?IPv6:2601:647:4800:973f:5da2:6508:3da7:e74a? ([2601:647:4800:973f:5da2:6508:3da7:e74a])
        by smtp.gmail.com with ESMTPSA id s11sm2767817pgv.13.2019.07.01.22.36.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 22:36:42 -0700 (PDT)
Subject: Re: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
To:     Idan Burstein <idanb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
 <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
 <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
Date:   Mon, 1 Jul 2019 22:36:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Idan,

> " Please don't. This is a bad choice to opt it in by default."
> 
> I disagree here. I'd prefer Linux to have good out of the box experience (e.g. reach 100G in 4K NVMeOF on Intel servers) with the default parameters. Especially since Yamin have shown it is beneficial / not hurting in terms of performance for variety of use cases. The whole concept of DIM is that it adapts to the workload requirements in terms of bandwidth and latency.

Well, its a Mellanox device driver after all.

But do note that by far, the vast majority of users are not saturating
100G of 4K I/O. The absolute vast majority of users are primarily
sensitive to synchronous QD=1 I/O latency, and when the workload
is much more dynamic than the synthetic 100%/50%/0% read mix.

As much as I'm a fan (IIRC I was the one giving a first pass at this),
the dim default opt-in is not only not beneficial, but potentially
harmful to the majority of users out-of-the-box experience.

Given that this is a fresh code with almost no exposure, and that was
not tested outside of Yamin running limited performance testing, I think
it would be a mistake to add it as a default opt-in, that can come as an
incremental stage.

Obviously, I cannot tell what Mellanox should/shouldn't do in its own
device driver of course, but I just wanted to emphasize that I think
this is a mistake.

> Moreover, net-dim is enabled by default, I don't see why RDMA is different.

Very different animals.
