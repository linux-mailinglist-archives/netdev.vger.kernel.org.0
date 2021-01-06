Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5EB02EBF1B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbhAFNqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbhAFNqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:46:00 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A57C06134C;
        Wed,  6 Jan 2021 05:45:20 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g20so5167292ejb.1;
        Wed, 06 Jan 2021 05:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FeJdQ/c5c3Yk5ETXkZRfgUT36HQYoNuNNY5hhZyt1Zw=;
        b=hSC55QP6a+jYHRxCa+TgeWcHTDjcrHo0Y56fHl+KSs4kIqESl4MXCSckZ+YoDGe1N0
         /ucn8xl1M5eSFXXgKAf04Kdczt/jlyFXX6QL+vDWgU0YMY88lU7ODUlncMy+A0k7Wb6V
         gVY7Bc4nzPmw/XGlLPm0coTTox5ZeDmqtbdHN8b860ei4H2rqMTSuhrdd0rcInFouw/R
         cyZPXO5ttKNNn14k60uqEsiwL/JKgt0wSxikJkAXAQY6yzhVxNF5Qz43HSCti7/04Ll0
         m7cWPj+mnCMh+dijqzjx0K0KRLo/a9/g5MhNQaIIRCFDWqsLT1u/5cNwY0E+1g59Xx54
         Nf5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FeJdQ/c5c3Yk5ETXkZRfgUT36HQYoNuNNY5hhZyt1Zw=;
        b=BnV2oVCrMlTC89OoErCOxl0yjy4UjswSXm285rp9ZZJp0tUu3RtSL/kX1xX3RYBj3O
         fUeh/7i8zVNsRxc/6CwSGKxZvMUWmN3+hdxnmh80t7xXUtjwWb015TH+jgAtbDYUzN1h
         4exVuYeOXbtc3YByCL9w3fVHNxyAqPeTllrOlR8DYymbyEEfsX2US+J6MIKAj95f9JRw
         uaw/DJ5uy5nQf/ZZ9Hovy4LqPTapmPcP3mDCuoFiBHuNtvaOcwKC+2JaEjqGUE94Vw9A
         dHXUv5DYjZwRKqXOMw6bOT8ATczRtVmldUu8JVqFdqxRnPWlEfWNMaVQGoKiBdvUWmJj
         YUZg==
X-Gm-Message-State: AOAM533YEtyqcBjYWWV7yemnnHvukJcw5NLRk2uw4W+68qivpOG2p7Vs
        15tyVy1v5z5u/ezyV7FjqGQ=
X-Google-Smtp-Source: ABdhPJy+1yovqw8J45ec7rwvhTOy5Zsk9UBBbrIpibmzvsCCOp1GbbwivAw4eZio5ckmV8dO4hgrRQ==
X-Received: by 2002:a17:906:2984:: with SMTP id x4mr2962425eje.239.1609940718823;
        Wed, 06 Jan 2021 05:45:18 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z26sm1470222edl.71.2021.01.06.05.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:45:18 -0800 (PST)
Date:   Wed, 6 Jan 2021 15:45:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Florian Westphal <fw@strlen.de>, linux-s390@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-parisc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [RFC PATCH v2 net-next 00/12] Make .ndo_get_stats64 sleepable
Message-ID: <20210106134516.jnh2b5p5oww4cghz@skbuf>
References: <20210105185902.3922928-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105185902.3922928-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 08:58:50PM +0200, Vladimir Oltean wrote:
> This is marked as Request For Comments for a reason.

If nobody has any objections, I will remove the memory leaks I
introduced to check if anybody is paying attention, and I will resubmit
this as a non-RFC series.
