Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA995EC08
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfGCS4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:56:09 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:42534 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCS4I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:56:08 -0400
Received: by mail-ot1-f41.google.com with SMTP id l15so3454453otn.9;
        Wed, 03 Jul 2019 11:56:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XbGfq/PAiJTXoAc1HjE+sQp+PXQfka3LFi4ll00sUJw=;
        b=S/hl3o1gh6ILV9qkxZYeEv+8Y7vmbXoFaUUJtfV0nzlKvJ0qvRaxdggBR2WgmMXDjf
         bwrpS9oPtwhkL/zdY0jYnG8Q+QHHYAj+IBI7aqpGsc9OLuTJrTf3K6U0KX/HxqY9Jaqs
         CjfxR07s+CMFaUHWN/DlMvgrsHNhikW7jTxItnliBCx0itoVvJ74L18JYG4058gnMjnN
         +0goD2JSfGlHBbZizagd+RgXsuAfneZslf/P3ygME1Yl94on67P2lDXkcioxfetMaT2s
         4hhAVvVTJChDFk6Nq4QsyCJBMzeW6pvUi9lzHEASOQcezsTpl3mjb0AIUyQeCen0DoVy
         +VgQ==
X-Gm-Message-State: APjAAAVJxhRsPbNuu3JV6D7PUTO5uFXJd6n2rRA34k79L64XBfRDa4s5
        A2ruz6Ig1r4yAapwX8PNgYQ=
X-Google-Smtp-Source: APXvYqy2R9aumMpDTLirR1puM7NSB+IwaCirVNlXze9r0ln+QvNiL7ZvSmD67CEBitnhsgEzHCYAqw==
X-Received: by 2002:a9d:7451:: with SMTP id p17mr31392726otk.204.1562180168075;
        Wed, 03 Jul 2019 11:56:08 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id k10sm1012084otn.58.2019.07.03.11.56.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 11:56:07 -0700 (PDT)
Subject: Re: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
To:     Leon Romanovsky <leonro@mellanox.com>
Cc:     Idan Burstein <idanb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
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
 <9d26c90c-8e0b-656f-341f-a67251549126@grimberg.me>
 <20190702064107.GS4727@mtr-leonro.mtl.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <8d525d64-6da1-48c3-952d-8c6b0d541859@grimberg.me>
Date:   Wed, 3 Jul 2019 11:56:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702064107.GS4727@mtr-leonro.mtl.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Hi Sagi,
> 
> I'm not sharing your worries about bad out-of-the-box experience for a
> number of reasons.
> 
> First of all, this code is part of upstream kernel and will take time
> till users actually start to use it as is and not as part of some distro
> backports or MOFED packages.

True, but I am still saying that this feature is damaging sync IO which
represents the majority of the users. It might not be an extreme impact
but it is still a degradation (from a very limited testing I did this
morning I'm seeing a consistent 5%-10% latency increase for low QD
workloads which is consistent with what Yamin reported AFAIR).

But having said that, the call is for you guys to make as this is a
Mellanox device. I absolutely think that this is useful (as I said
before), I just don't think its necessarily a good idea to opt it by
default given that only a limited set of users would take full advantage
of it while the rest would see a negative impact (even if its 10%).

I don't have  a hard objection here, just wanted to give you my
opinion on this because mlx5 is an important driver for rdma
users.

> Second, Yamin did extensive testing and worked very close with Or G.
> and I have very high confident in the results of their team work.

Has anyone tested other RDMA ulps? NFS/RDMA or SRP/iSER?

Would be interesting to understand how other subsystems with different
characteristics behave with this.
