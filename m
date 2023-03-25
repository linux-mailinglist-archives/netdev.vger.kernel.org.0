Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5636C909F
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 21:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbjCYUHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 16:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCYUHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 16:07:20 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430949EEF;
        Sat, 25 Mar 2023 13:07:19 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i7so6167413ybt.0;
        Sat, 25 Mar 2023 13:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679774838;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+QZnDuhBKGyiLQZ4Hdc5Dwy7DdvOszyRK/ECjacvTwc=;
        b=byVYTzvl4qFy2rkriPrQKS7ycpx/UkOs7jqbOjkzIbCNLGD0sQF5smq6fr/NCRvepo
         E/8Fo27+JanWbNELJjtv9Q/6Q0AeTzmQQvN5d2jcPaFkxvkK7/pU9gBWBmFYSOdrbD57
         eslFCQ6Wh4d2gTC+3VcTc0mY1t/FTaLsuHLhPRksgAwCl+X/xWrIjG9Jt5Lu6BX8DFTV
         LBVabj3WGIvb1ZUT+vU5rdhCPvDhwwq/Bue6wO/ydirGltS/f4USuBDZzQ04S18VRv7l
         DlhQyvPwWL7HzIOKosMw2SxPX2v1QJR0mB9tom05RfmKraRqcQWweM0uSaqWhFpCZeQK
         YqSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679774838;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+QZnDuhBKGyiLQZ4Hdc5Dwy7DdvOszyRK/ECjacvTwc=;
        b=3rz8gbt2TeCZ5ABl7qTNL8V4tiiOdOwlpqjEcFIduwgRb+SJN8pUAeM3NAfaa9zPda
         V+aol3XxoAX5wQFp0LsXdjIV4xJrZ/CrZbrAHlVMptVFsvEMt+dFcVeDXPbs8vjj6yTP
         qfDUvyxf5tfpHvyq35JIfrN/KTwoNP/v/BZlRiUmnKM3324VTIUENqCWJWUnCEhlpUE2
         kF2yuQ5pogETXgVvi+PYCihQR7Lc31OUTR0SZqVJnprwrglZV5qS1P1S6es0Ujc/pf2E
         F1zATk/imjbl2eLv5BF9uUC3LW34mr6Lp3Ru58uLyksMWZPghfFZhVE1i0GeARVn6f5j
         nTmA==
X-Gm-Message-State: AAQBX9fUTYbBTzyQi5vIPKtaVQVlP/wcgMksvKBpbgZYfL1J2iS2UGY1
        Q8ZBp+el+A0m0tOOdpPEv4YlGaQEO4Q=
X-Google-Smtp-Source: AKy350YWT+NuT2aqCjk0SS5eSStwx3Io99d0kRupMx18+CnIT3UC8bRe1jGxW7iO1RiH1SCgL+VvXQ==
X-Received: by 2002:a25:ce48:0:b0:b75:a090:16f3 with SMTP id x69-20020a25ce48000000b00b75a09016f3mr6816708ybe.2.1679774838309;
        Sat, 25 Mar 2023 13:07:18 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:8df5:425c:8318:af19])
        by smtp.gmail.com with ESMTPSA id y6-20020a253206000000b00b7767ca7499sm1269743yby.54.2023.03.25.13.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 13:07:17 -0700 (PDT)
Date:   Sat, 25 Mar 2023 13:07:16 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch net-next v3] sock_map: dump socket map id via diag
Message-ID: <ZB9UdB5pgOAacioS@pop-os.localdomain>
References: <20230319191913.61236-1-xiyou.wangcong@gmail.com>
 <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 11:13:03AM -0700, Stanislav Fomichev wrote:
> On Sun, Mar 19, 2023 at 12:19 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently there is no way to know which sockmap a socket has been added
> > to from outside, especially for that a socket can be added to multiple
> > sockmap's. We could dump this via socket diag, as shown below.
> >
> > Sample output:
> >
> >   # ./iproute2/misc/ss -tnaie --bpf-map
> >   ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1
> >
> >   # bpftool map
> >   1: sockmap  flags 0x0
> >         key 4B  value 4B  max_entries 2  memlock 4096B
> >         pids echo-sockmap(549)
> >   4: array  name pid_iter.rodata  flags 0x480
> >         key 4B  value 4B  max_entries 1  memlock 4096B
> >         btf_id 10  frozen
> >         pids bpftool(624)
> >
> > In the future, we could dump other sockmap related stats too, hence I
> > make it a nested attribute.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> 
> Looks fine from my POW, will let others comment.
> 
> One thing I still don't understand here: what is missing from the
> socket iterators to implement this? Is it all the sk_psock_get magic?
> I remember you dismissed Yonghong's suggestion on v1, but have you
> actually tried it?

I am very confused. So in order to figure out which sockmap a socket has
been added to, I have to dump *all* sockmap's??? It seems you are
suggesting to solve this with a more complex and unnecessary approach?
Please tell me why, I am really lost, I don't even see there is a point
to make here.

> 
> Also: a test would be nice to have. I know you've tested it with the
> iproute2, but having something regularly exercised by the ci seems
> good to have (and not a ton of work).

Sure, so where are the tests for socket diag? I don't see any within the
tree:

$ git grep INET_DIAG_SOCKOPT -- tools/
$

Note, this is not suitable for bpf selftests, because it is less relevant
to bpf, much more relevant to socket diag. I thought this is obvious.

Thanks.
