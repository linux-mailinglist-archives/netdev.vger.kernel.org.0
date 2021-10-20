Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B634344AD
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 07:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhJTFbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 01:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhJTFbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 01:31:12 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64C8C06161C;
        Tue, 19 Oct 2021 22:28:58 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id l7so7486745iln.8;
        Tue, 19 Oct 2021 22:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+x9DXiYdDRIsiP7bgBCWfV0gd6Qocz/QJERxyybccio=;
        b=jyJuoKIWUMZdOIzsh6Zzki6M9PPhovKho30K33Q2vROnKVzaxFAxSg5/ixtHvm4UE3
         qJaXPA8wFMNENMUyrN4ejs+tVINnsxvfEhxguyOEKrrMFgmq7jMt9bSXt4dkv/m1fD6t
         k5qU3UfsBcVHOzvTwQNNdpOMHodPPumKbvPnMkPKz+nObKvrU5uTxPTTt3iyHPAI0ybo
         c4pbaup/0UnhrYPsRp6gcE5fIoGVqIFWxE0GHqWkdx8T5+D0PTzWPwxpKQNG8evKg655
         099knVI7fESunUWgUWI/yBYKFGVOiwfQCieVK/Udb1oU5aCUl2Z7PhGqJ7tOT7Qy52zs
         Iupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+x9DXiYdDRIsiP7bgBCWfV0gd6Qocz/QJERxyybccio=;
        b=A3IbbpQ+/E6sG7TvvaZCzhvP8qvmCyxY5KMtvf0e5wNo/KaANE449aiEFJDi1uKwhb
         KAjHO9cUKJLmMcnEmhn6K/aR1kAtmk5NLNgxldeCkYoZg5cveksxt2kdiRvmTiAs7Iyq
         wvmqs4rxRUyGBNxI9ttt6+o07W4zxw4dDdXg9JzZ0oVfYJ5wmeaS7ptJ2s7Uy2pLkvNA
         I+XUZD06uBtOHkqM8edKLF/wKrOmIqQrbNzkyPzRsl4D/OZ2EaiBGWhKKcSJde41EVAI
         mipGlr5v9ajtL2XXzZWRJh35IPUibvH5VOD3gKyJeFmQRDb7djZOLQrHEmBDlHKRR5bf
         q5zw==
X-Gm-Message-State: AOAM530mW5Ufqf9qiswjMNc569NT2NsPmzii7ac05tfnOOqklqUwl2U8
        DM/sI+OGrG/SqdV0Y2q/1hM=
X-Google-Smtp-Source: ABdhPJy0+fvkPqyUPTvV2FCqQGNH8O7psuxTP4qz7OaNSIBDMVMNbyF0CBCrP747Vn3uUx/nkzQwBw==
X-Received: by 2002:a92:cf50:: with SMTP id c16mr14215449ilr.145.1634707738196;
        Tue, 19 Oct 2021 22:28:58 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c11sm604874ilk.22.2021.10.19.22.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 22:28:57 -0700 (PDT)
Date:   Tue, 19 Oct 2021 22:28:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        joamaki@gmail.com, xiyou.wangcong@gmail.com
Message-ID: <616fa9127fa63_340c7208ef@john-XPS-13-9370.notmuch>
In-Reply-To: <87tuhdfpq4.fsf@cloudflare.com>
References: <20211011191647.418704-1-john.fastabend@gmail.com>
 <20211011191647.418704-2-john.fastabend@gmail.com>
 <87tuhdfpq4.fsf@cloudflare.com>
Subject: Re: [PATCH bpf 1/4] bpf, sockmap: Remove unhash handler for BPF
 sockmap usage
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Mon, Oct 11, 2021 at 09:16 PM CEST, John Fastabend wrote:
> > We do not need to handle unhash from BPF side we can simply wait for the
> > close to happen. The original concern was a socket could transition from
> > ESTABLISHED state to a new state while the BPF hook was still attached.
> > But, we convinced ourself this is no longer possible and we also
> > improved BPF sockmap to handle listen sockets so this is no longer a
> > problem.
> >
> > More importantly though there are cases where unhash is called when data is
> > in the receive queue. The BPF unhash logic will flush this data which is
> > wrong. To be correct it should keep the data in the receive queue and allow
> > a receiving application to continue reading the data. This may happen when
> > tcp_abort is received for example. Instead of complicating the logic in
> > unhash simply moving all this to tcp_close hook solves this.
> >
> > Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> 
> Doesn't this open the possibility of having a TCP_CLOSE socket in
> sockmap if I disconnect it, that is call connect(AF_UNSPEC), instead of
> close it?

Correct it means we may have TCP_CLOSE socket in the map. I'm not
seeing any problem with this though. A send on the socket would
fail the sk_state checks in the send hooks. (tcp.c:1245). Receiving
from the TCP stack would fail with normal TCP stack checks.

Maybe we want a check on redirect into ingress if the sock is in
ESTABLISHED state as well? I might push that in its own patch
though it seems related, but I think we should have that there
regardless of this patch.

Did you happen to see any issues on the sock_map side for close case?
It looks good to me.

.John
