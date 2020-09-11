Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39832265AA8
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 09:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725777AbgIKHmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 03:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgIKHmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 03:42:49 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C0DC061573;
        Fri, 11 Sep 2020 00:42:49 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id u126so8547638oif.13;
        Fri, 11 Sep 2020 00:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WQ/Y5klvASid4l7LE9orQamQKfODVtQvXjKUrtElCr8=;
        b=B0ZSIeIdFJY3qwVi7UTdqgyDpDDR5NBsSikIDlDodrahrtzIHK4yo/sfJFJT4dzAOA
         F62hElVAm2O1cEhFMSOcOcjheMm4UihA+hPJqIRSGwTnxde3zjFnvaOFj+vjlEIH4m4d
         n+BnbHTviAsyw+ynTvLbUhJRx6Sd5IKl4GO4+H6Hw6aHkbUVSahxXqjD7XGkEaUCEYzi
         vVKUz+yznVadHYoAnTmp45dtGiaCcSIf8zRZWnO/6aG+9cvwH1ZSaGMPKCf3LsMdytB/
         WgDC5ZmdP6eziy1fOBWWPWkYIlVRXXkzZCb72pgR98oebfJEhQjI3P6pJnMsJbR9P686
         0fuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WQ/Y5klvASid4l7LE9orQamQKfODVtQvXjKUrtElCr8=;
        b=k6+rsf6GbTGVCZx0dfLoN1Btq+ihLSk+Ldu8QuvpKaklTrXz6fuiXmXc8sFHuGNPdT
         CTjFzXwxwRbsoWbNva4f965vANymjjTPv9ZCUXLAdbGrFrcyuW5jrk+yDNqagZQTktvO
         fNw6sn93xjADGMl8aAlv0zLyZeqFF+XoA0t2o+41gxwCpYHxjafcySlOgA9gnrpAQu9b
         8QIzTVc31/Ij9CvugOBnH0QpETYrrykLk6ocX7BUDieh6phAtZynkCSJgwg+188WCz/I
         bBdXmrfmEVuwX/4XxYh1I/r8kPHQFUILBaRADNVlSRceWbHl40AEyLR46TlHHfSrXKpF
         CUpw==
X-Gm-Message-State: AOAM531oIxTjjeXZ4XDMFqcJPZPXGGQpTpzjGxmqPQu6PqunSIeNyf2Y
        jvkaMpYs5xAxO+eR29Ime6iMolZgRXdnl8U8EWk=
X-Google-Smtp-Source: ABdhPJxFTdO10jmbUyTG1HrZg/xxHBxBwLdTlbKvGcRKVggC5D2rEFpvkQJZuesgF4wyQux1h/mQI9ZbNBPtO39LfoU=
X-Received: by 2002:aca:4e03:: with SMTP id c3mr498798oib.169.1599810168883;
 Fri, 11 Sep 2020 00:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200904162154.GA24295@wunner.de> <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de> <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
In-Reply-To: <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Fri, 11 Sep 2020 09:42:37 +0200
Message-ID: <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Tue, Sep 8, 2020 at 2:55 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Hi Lukas,
>
> On 9/5/20 7:24 AM, Lukas Wunner wrote:
> > On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
> >> On 9/4/20 6:21 PM, Lukas Wunner wrote:
> [...]
> >> The tc queueing layer which is below is not the tc egress hook; the
> >> latter is for filtering/mangling/forwarding or helping the lower tc
> >> queueing layer to classify.
> >
> > People want to apply netfilter rules on egress, so either we need an
> > egress hook in the xmit path or we'd have to teach tc to filter and
> > mangle based on netfilter rules.  The former seemed more straight-forward
> > to me but I'm happy to pursue other directions.
>
> I would strongly prefer something where nf integrates into existing tc hook,
> not only due to the hook reuse which would be better, but also to allow for a
> more flexible interaction between tc/BPF use cases and nf, to name one

That sounds good but I'm afraid that it would take too much back and
forth discussions. We'll really appreciate it if this small patch can
be unblocked and then rethink the refactoring of ingress/egress hooks
that you commented in another thread.

Thanks!
