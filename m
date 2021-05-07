Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E543766CC
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbhEGOIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 10:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbhEGOIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 10:08:45 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A19C061574
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 07:07:45 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id c3so12916181lfs.7
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 07:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=QpyA+nj/BQj1dOJlKR0su/Gn9HnLp019BSEel+6x8Uw=;
        b=B+KlOFdvSwMTeEr6MD710pM0z+4lUxCDHEg4YhWJV13+OJRJB41zAb4TzJys6sDl2o
         DVtArYEtxNU8rwHugD6QwWU3Z33KgXrSdYhSYvJWZZra5l78MhlOFi/87Fxd94xWUsE7
         WGh10LySGJ7iwLPrRlRPdWiazSTkmCgXmP6SA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=QpyA+nj/BQj1dOJlKR0su/Gn9HnLp019BSEel+6x8Uw=;
        b=TgM8WLsiBAQ03vubiLzBQ6WV8+GEA11rnw7NbdLGnd5ydomPbL/J9mJmTKc4+5N2Lf
         ee5g5WpRXCZqdm2N6RHr2EnDkg2yTNjFmPi2GyUvYr3RUwc0htEwdqnWrpL7LNu1QCel
         /zGLn1/HDCiDn4+dIF8W1v9lT9rPQG/9hLbq8XCieobbHffgWg9efXuaTyMQFcExqxAg
         1ZEC7LvvDK9VFREcyx8CsFl+cVnW8TMwOv6xrpgBoDS1vrmoepihpc9r9hesaZ1nKcqI
         kM+ZRw4DnMbLfXlc+fH6jEz6E2zRRxRbzNEWYzm55QLUQOe0X6Q09LhNDAbXao+L1KOn
         kuPw==
X-Gm-Message-State: AOAM530YzpPpDbO49tVhVuGrallrbOmzzQLLwJyUToTIQ7bD2iKrvR3/
        Ly5ikoW/b5U7n50h0aIubdyt8w==
X-Google-Smtp-Source: ABdhPJzbRAxu3XaagF4mlsQDRTYvNVdCLQ50h4Vkdzn6qB8YPIkhgT60bFDuNuq7RV2YDE2ptNAVJw==
X-Received: by 2002:ac2:5ec6:: with SMTP id d6mr6436566lfq.365.1620396463491;
        Fri, 07 May 2021 07:07:43 -0700 (PDT)
Received: from cloudflare.com (83.31.64.64.ipv4.supernova.orange.pl. [83.31.64.64])
        by smtp.gmail.com with ESMTPSA id l23sm1011472ljb.26.2021.05.07.07.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 07:07:42 -0700 (PDT)
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        jiang.wang@bytedance.com, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch bpf-next v3 00/10] sockmap: add sockmap support to Unix
 datagram socket
In-reply-to: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
Date:   Fri, 07 May 2021 16:07:41 +0200
Message-ID: <87k0oavdqq.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 04:49 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> This is the last patchset of the original large patchset. In the
> previous patchset, a new BPF sockmap program BPF_SK_SKB_VERDICT
> was introduced and UDP began to support it too. In this patchset,
> we add BPF_SK_SKB_VERDICT support to Unix datagram socket, so that
> we can finally splice Unix datagram socket and UDP socket. Please
> check each patch description for more details.
>
> To see the big picture, the previous patchsets are available:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e0ab70778bd86a90de438cc5e1535c115a7c396
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=89d69c5d0fbcabd8656459bc8b1a476d6f1efee4
> this patchset is also available:
> https://github.com/congwang/linux/tree/sockmap3
>
> ---

Thanks for the patches. I did a round of review.

Out of curiosity - is there interest on your side to have sockmap
splicing for UDP / UNIX dgram on transmit (sendmsg()) as well?
