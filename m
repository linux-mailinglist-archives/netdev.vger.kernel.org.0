Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A728728C81C
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 07:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732288AbgJMFKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 01:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbgJMFKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 01:10:43 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34688C0613D0;
        Mon, 12 Oct 2020 22:10:43 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id c21so18980035ljn.13;
        Mon, 12 Oct 2020 22:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hK0wq5TYtu4CbgyWj0slcUjypLXIPkC3crHQS4fmi60=;
        b=W2PRgL+E4l/FgMDKFhT9G2yInReFYMwPRyjLpEp89OhHX0TxFKLlkBiNIFjfAu5HLF
         IquTfcW4V6CoR0DwjGgWab490UZEehJwv/3e3fRxp0L4QGnhUMHc6VDIzkcweZ4WXbkE
         3N70ady5ojtp+ro2ynKFp8oUzggkF67sp0xtNZOHBV5t0fRKGQ5ZnTTWQgQjDQIi5NBO
         Jdkyx0XVK5LF7fLdWCz2Cn9TTQsbkDlpe9jJqGyQOMSMVBzxpXR3uK+P4pKIzoDcvpa2
         vl7zTs/4gtNNdbjQrpfDvpMYNfmbXtepistA2XfrIgsCL4EL+gzn9ozvb7uakrsowwjw
         AxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hK0wq5TYtu4CbgyWj0slcUjypLXIPkC3crHQS4fmi60=;
        b=WsEt87lxlyozQh+jF3Q3SQVWw396lJV6fQP1k/2mPzSOmev6d7yd0ThcKOnhRqFiRR
         4kRJNxKf8bwQq+JcHxb0/JzgAWO/5334u78cBEZjLHmMVdmuGWq9FH8o36c/ynJ8O6e9
         twtsRDITJ1AITCA53m2QiKBSTx+90OUrvExROU8o9JtwJp5pI7SHZ8ghqWZpb4cN4t5U
         f2X6DE5qVS9n9AbPHxPXYY9rijYnNpRMQEAJOHl2Xh4Jl55IHMeRJUZKu75mkrxRg0gf
         DWW+tA9rQLIpjg5NMCkUYAdode0etRdBAmgp660o9q2y4NeUNP/BsBb+894p1wfGdIDv
         ax6Q==
X-Gm-Message-State: AOAM532QmR4pi6cEzEs4mA2rrw3YoCMaOKmNzOUSXdrWb2I5J+T8LhWV
        mVozqraYw1vDmHb0onjilJjHYtAlotLpZuooFO8=
X-Google-Smtp-Source: ABdhPJxfEIgaqk5j6DLVDWEk4eng393qHmcvgOh1K3aPKL9V9vpwiUhB/m+FPxmCAhk0NAyy4++G9m5YGzjkRtmsQwo=
X-Received: by 2002:a05:651c:10b:: with SMTP id a11mr4479478ljb.49.1602565841740;
 Mon, 12 Oct 2020 22:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201012093542.15504-1-ceggers@arri.de> <CA+FuTSfkBHtKqjppMmqudj9GwZBidSqvOP6WCzoxLGihqiz5Qw@mail.gmail.com>
In-Reply-To: <CA+FuTSfkBHtKqjppMmqudj9GwZBidSqvOP6WCzoxLGihqiz5Qw@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Mon, 12 Oct 2020 22:10:31 -0700
Message-ID: <CABeXuvrgdP9C4jM2VhNn_FAdTvW5EVMoNSOmca2YW-XtM544rw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] socket: fix option SO_TIMESTAMPING_NEW
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Oct 12, 2020 at 5:36 AM Christian Eggers <ceggers@arri.de> wrote:
> > v2:
> > -----
> > - integrated proposal from Willem de Bruijn
> > - added Reviewed-by: from Willem and Deepa

You may add my
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>


-Deepa
