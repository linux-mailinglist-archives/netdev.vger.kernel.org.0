Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F4E48155A
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 17:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240955AbhL2Qvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 11:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240895AbhL2Qvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 11:51:35 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEC1C061574;
        Wed, 29 Dec 2021 08:51:35 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id x15so16250935plg.1;
        Wed, 29 Dec 2021 08:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eyiokD87yXLE7dKoF/rAesIX6IaZjzEtJI7+LN04FEk=;
        b=jbps2qryj0Z0zQWn+lrBBlSxcDefe6KXi88QIlXKVc6Y7PKqWfUapjY8JxFcaIGigd
         ft7+84WoQ0h4UhL3vyJ1DIBHIIiAm5llGYmfk4nVkAe+3GrrBf97zhKbWsvTPX6JejKF
         1dkXJo0UGl+pIxJTyh0L4R8V7cOazLao67YG1WvcCgMJUT7Zmhf0eicJkPKKBztKsk7v
         D05fKDj1dOQc8zLv828bRzJys90kfBlRY+f583hLSA+S27xtYBrr/t46oqhBNzw2uXBi
         meZ8HORQpYNqIJLSkK446oH4j64Ut5bibHP4XsZdHoPvyO6AnHzKO5rs+vK+c+HbGKip
         7LUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eyiokD87yXLE7dKoF/rAesIX6IaZjzEtJI7+LN04FEk=;
        b=hWiaPoUqJrVzY5vg6f/c77RBAEYa17d/E6UGC8KAVQ+PYzfl82InjrArHXDEYwGOrL
         Qzc7Ez+e+rsoxqHvzJ2Tl5tnaatkpPeDU21KW9xHyhXtBw89SFUtYFgniKE3B5IUj+qj
         9HQKl6gBjyYgTyZV5+siJvSF+1TSNYukxsk33ecnbRThqJlu8stTQBgWADo8WNiKz+h+
         D8Du/HL+xqgYpxsgJgqRHxplC8RyPO08lvkqj80xLavY1gGH9lcjdPKFx4iQpJ05bB67
         et7HX70AlLPPjV0Uy+wW3vf7NXVl3Ns3muYCId5E1T9/1lcC9YEpMHm2D4XpWeMKeyrb
         e2iA==
X-Gm-Message-State: AOAM532kVlzxktAb+63NYKaT5zI1au11QfZbWHHa7x75GfqwF4Be4MwS
        CzTN9/xCStm7aaFTSxXK+usG6kccsejec4v8/5A=
X-Google-Smtp-Source: ABdhPJxws7iMiWFQ81pkeV1J6AYDjsQKCDaoIm81c0ZOXt5vTQ/CRD6VrIFy5sdtzv5w8UmX3Hk8KIPfWDSHxOMnNg4=
X-Received: by 2002:a17:902:c443:b0:148:f689:d924 with SMTP id
 m3-20020a170902c44300b00148f689d924mr27252809plm.78.1640796694708; Wed, 29
 Dec 2021 08:51:34 -0800 (PST)
MIME-Version: 1.0
References: <20211229004913.513372-1-kuba@kernel.org>
In-Reply-To: <20211229004913.513372-1-kuba@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Dec 2021 08:51:23 -0800
Message-ID: <CAADnVQLd2y_Cuqrn+cAQzCjpXM_Lub5_X6xEfZdMMC2a2Jq41A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] net: don't include filter.h from net/sock.h
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, Leon Romanovsky <leon@kernel.org>,
        Taehee Yoo <ap420073@gmail.com>, wg@grandegger.com,
        woojung.huh@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        olteanv@gmail.com, george.mccollister@gmail.com,
        Michael Chan <michael.chan@broadcom.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        anthony.l.nguyen@intel.com,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>, saeedm@nvidia.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, jreuter@yaina.de,
        David Ahern <dsahern@kernel.org>, kvalo@codeaurora.org,
        pkshih@realtek.com, trond.myklebust@hammerspace.com,
        anna.schumaker@netapp.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>, nikolay@nvidia.com,
        jiri@nvidia.com, wintera@linux.ibm.com, wenjia@linux.ibm.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, kgraul@linux.ibm.com,
        sgarzare@redhat.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>, linux-bluetooth@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        linux-hams@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-nfs@vger.kernel.org,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        linux-decnet-user@lists.sourceforge.net,
        linux-s390 <linux-s390@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 4:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> sock.h is pretty heavily used (5k objects rebuilt on x86 after
> it's touched). We can drop the include of filter.h from it and
> add a forward declaration of struct sk_filter instead.
> This decreases the number of rebuilt objects when bpf.h
> is touched from ~5k to ~1k.
>
> There's a lot of missing includes this was masking. Primarily
> in networking tho, this time.
>
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: https://lore.kernel.org/all/20211228192519.386913-1-kuba@kernel.org/
>  - fix build in bond on ia64
>  - fix build in ip6_fib with randconfig

Nice! Applied. Thanks
