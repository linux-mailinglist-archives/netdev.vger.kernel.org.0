Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2A151F6C3
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiEIINP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 04:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237628AbiEIIFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 04:05:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F71B15EA5F;
        Mon,  9 May 2022 01:01:35 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u3so18239865wrg.3;
        Mon, 09 May 2022 01:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2xFvAUu2Mi5eQC7Ozo69GKucsTfJHJ60BEy3d9RaYNk=;
        b=QTYEuxBrySeygqE9/VtZUARHlYpRUDDnHJiufCAnDQhgtCNlt0G8xsngJxuGBaAzM+
         N3gwfHjWe1p7X+qUQ3yjBqrH1cktJIvXSvA/DVvOtPwoNwe6vg2DuQqqN/nGXbt/0L1k
         dcfoNd1TQLoD7jDONs/CnCcLYvVtLwdhVs4U/KAzH/F2fZ597lmFLyc5IJje0mRXRrjj
         BP4s3SSfHKC3mAE88m/qQ+lx1e5mSyVMHQhQ0nzf3hPANLsqNGARitzLS5ilZlf2s9Dt
         VcYQn81XEOrdsrHTQt/l0C3qkH4KsKIXl7c+QnuYsEYCKUPvBn2Ps+DZWbxyLL4UPp3X
         KOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2xFvAUu2Mi5eQC7Ozo69GKucsTfJHJ60BEy3d9RaYNk=;
        b=eYlfF6IRkPUXTbkdsbNxqaLsP0Y0cm3hnhIgoauwBU2lAXwqVmptW/Xyw0iNj23lZR
         yR+gydFpc7oUgS32c9rthZCYy3TenOfHBCjbOXuGu/NRT1x9zkow7SLTFB/Moh5XYWIa
         ncD0AeyENTF/ZdPAy4HIxyYr2SVi0lAKw8qmM8J7O8F6XKbla/rtrqs3z/EhWPBnN4VM
         LBCg4/u1l3PtkcsFHZ4QdCPtO2+olAyOmQ/wZSJOcPzl63dUT2/uW5dfV2+dtnAj3nNM
         QoqEijqo8yNuwmF0NXU7buah5gGgcwF+wh2RdX5hhh2MLjbZFxKoadAGSzAVmPRBuPCU
         HTlA==
X-Gm-Message-State: AOAM530gQG13wmU+RlVZYjHiHF3vlAl5gB/pFR/HTi8YvzEBsZ02T3Rv
        qapVb5+OrVYFta8n6e2ouAHyPS/L2mDqrH52G6mOSn9wVHGQLw==
X-Google-Smtp-Source: ABdhPJwDlmtMZ5dUkpujCx+0M1K6rytzDgpjReAOAEEoDP6/0eGSTUfB3xMJevDLkZRohPi0uFJ8i5YU+cUEgDrP0Dg=
X-Received: by 2002:a17:907:7296:b0:6e8:97c1:a7ef with SMTP id
 dt22-20020a170907729600b006e897c1a7efmr13221254ejc.262.1652082819903; Mon, 09
 May 2022 00:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651800598.git.peilin.ye@bytedance.com> <f4090d129b685df72070f708294550fbc513f888.1651800598.git.peilin.ye@bytedance.com>
In-Reply-To: <f4090d129b685df72070f708294550fbc513f888.1651800598.git.peilin.ye@bytedance.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Mon, 9 May 2022 00:53:28 -0700
Message-ID: <CAA93jw4dFxwWCrhv98wwbPvM+UrAQKYRNbbSVp3UCp1zOnsD5w@mail.gmail.com>
Subject: Re: [PATCH RFC v1 net-next 1/4] net: Introduce Qdisc backpressure infrastructure
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am very pleased to see this work.

However,  my "vision" such as it was, and as misguided as it might be,
was to implement a facility similar to tcp_notsent_lowat for udp
packets, tracking the progress of the udp packet through the kernel,
and supplying backpressure and providing better information about
where when and why the packet was dropped in the stack back to the
application.

I've been really impressed by the DROP_REASON work and had had no clue
prior to seeing all that instrumentation, where else packets might be
dropped in the kernel.

I'd be interested to see what happens with sch_cake.

--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
