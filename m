Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF43B6D01
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 05:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhF2De4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 23:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhF2Dez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 23:34:55 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7128EC061574;
        Mon, 28 Jun 2021 20:32:28 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id j24so2013766pfi.12;
        Mon, 28 Jun 2021 20:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uBxOpljOGcm1/gwGnziTsaGLnW/IZFNclIouVxEAQTM=;
        b=GlBM275AXJy0V6faEkaaGqpJcNj8AvSTYTkPTT71arsvlHLu6JDmbhtJVW5VAwVCh4
         w/ZhvzXF7iZ7KxX/HQgpZQz9CZPWVQFs2j/YV6s2CpsNbpK/jnv2aqJbkK9mbtStbG9B
         +LGHNcSKDTZLQZkCTXq0tApDq4VlOe1x8ibbX2ExA/L2Nfr4eLa/srHTrMz8LdcrZ1Ci
         7PQqjG/qIKABXLj6cMszsNKMfI+C12aWt4N3fXGPyr2B0Ln17V/+q7Cso0K6ohwLKWWb
         Ad1qzYLJ/yZq9Cn+OnjnXMSKgjr8TYiIKRsBtsLqBSE1SFOl+GikHrIUMs2DFRBz4ldD
         9a5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uBxOpljOGcm1/gwGnziTsaGLnW/IZFNclIouVxEAQTM=;
        b=coRVrLJ58WDt2PWKmYEGo/9D+OLEju5gqXu1uBSU6nAP9JeH/GLLkwZe+QY9IKjiCP
         ZAK2zQ9DZSzZ8bXVkUE0I0knaxuXgHQpuxbuEQfyu2r8iU2yQQ0qhtwykZwx7rwQm/Ub
         Rzx3e3rk5tArdIv9fL+XvUT4AnrDASX+oU7RbbqkIqmY2j5E9uTS2Y3A/AUwdtYZEILu
         soIvxR1YvXdBwzUX+DsI4TVmw7RJ3M/qVUEZx4PIqz2rN3T/W4yg9lnOuowlJbUEmRRd
         U23Wr7i7BKXDll+Jse4igPWM495hW85eOAboYJ6jRPASs+37WebrhrpVaqQke/UYTL7s
         hfBg==
X-Gm-Message-State: AOAM530tNq8yTSpu7frtuOdtFHe/vICwiD2/acXngFJCAvzHOAXsrzcG
        qHviSm2xnHBLneHCHg2zmvs=
X-Google-Smtp-Source: ABdhPJwyU0C6/L6r4khPqro224h2/4hSRTB9RVQI7Iz6kZ0yOVRCAbq/puAG9CTNFa6HjG4YUSMvyA==
X-Received: by 2002:a63:a54b:: with SMTP id r11mr25988904pgu.43.1624937547799;
        Mon, 28 Jun 2021 20:32:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:45ad])
        by smtp.gmail.com with ESMTPSA id a31sm16213874pgm.73.2021.06.28.20.32.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jun 2021 20:32:26 -0700 (PDT)
Date:   Mon, 28 Jun 2021 20:32:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
Message-ID: <20210629033223.yknyaj2trkvnm77v@ast-mbp.dhcp.thefacebook.com>
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com>
 <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
 <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
 <bcc2f155-129d-12f1-1e3d-c741c746df10@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcc2f155-129d-12f1-1e3d-c741c746df10@fb.com>
User-Agent: NeoMutt/20180223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 07:24:28PM -0700, Yonghong Song wrote:
> 
> > 
> > While talking to Martin about the api he pointed out that
> > callback_fn in timer_start() doesn't achieve the full use case
> > of replacing a prog. So in the next spin I'll split it into
> > bpf_timer_set_callback(timer, callback_fn);
> > bpf_timer_start(timer, nsec);
> > This way callback and prog can be replaced without resetting
> > timer expiry which could be useful.
> 
> I took a brief look for patch 4-6 and it looks okay. But since
> you will change helper signatures I will hold and check next
> revision instead.

Thanks. The verifier patches won't change though.

> 
> BTW, does this mean the following scenario will be supported?
>   prog1: bpf_timer_set_callback(time, callback_fn)
>   prog2: bpf_timer_start(timer, nsec)
> so here prog2 can start the timer which call prog1's callback_fn?

right.

> > 
> > Also Daniel and Andrii reminded that cpu pinning would be next
> > feature request. The api extensibility allows to add it in the future.
> > I'm going to delay implementing it until bpf_smp_call_single()
> > implications are understood.
> 
> Do we need to any a 'flags' parameter for bpf_timer_start() helper
> so we can encode target cpu in 'flags'?

I thought that bpf_timer_init will handle the cpu selection,
but you're right that having cpu in bpf_timer_start is more flexible.
So I'll add a flag.
