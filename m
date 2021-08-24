Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E063F622D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbhHXQEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 12:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbhHXQEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 12:04:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670DCC061757
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 09:03:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 83-20020a251956000000b0059948f541cbso7404099ybz.7
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 09:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=05vqUW6OwLWYXc+OPJ8qxf+QjEHafU46xQaB07y1qjo=;
        b=BKopjjtG61k30Gt7+80Bi73Lg/I48KMqot/gpNLdLYl8EUENPa536uMe716RGsZEmL
         P1aDyAAgXOGEoS+iKmSHq2J1Vl4zza/gnVwID7l76MXdqGjO9X1fZzcoR1IHRttHoHOp
         hoK7NbmAyk7xqK0F/U08A9+tIczuxy8jRJX7UHRPEY12BpcWahhsJ9Z7MN82MoJ3nB1z
         SoktX/s+oFJkfZEONIKbKGS3aHwhzBuCEgrfJfa4O4FPyrx6b7W19BSpQw68fv/Xf3tC
         pUiYKRR4BU2KjDF7ldaMX5mGEB7t+ePA0cNiZ9XeL0706AF9BECp7xiUM21Ej3A2GObU
         V9iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=05vqUW6OwLWYXc+OPJ8qxf+QjEHafU46xQaB07y1qjo=;
        b=YqfrpP70cMPWz2OvvIUc/QY86TljMJeXV5ltJ0vSTL+kp8ilU4ksc72uKrki8nmF4v
         ofTTQOqivVj44PuDkBR9EbCwq7VJW9na6qS0BJjey/lbQhpPUn6fB9Kl7pW79ZZm2awl
         yoRatzHfyEQzr2+ulWIE2fZrMaXvg4g7ZIr9rNt6UEBdNsMUUtKDDIKdjCVYF5VhvZi5
         2AqKLjUk7kOzwtAUJObdWhRtGRiPQqAUZCWboIQh97avMpG5drLw14WOfqPHyB5eag9D
         LLK73kVQtUVkmG4TCzuxMD/Xs111hG/80MCFcF30Y0wiAY1bW4mUahsuf2Fewy8g0Z+G
         fH/Q==
X-Gm-Message-State: AOAM531XsIFTv0jz2SMh83Nm4ZPwvU6bE6HWs1YP1FXhuD44Tt4JQUay
        8awGq2mWGJbxfU8wjOBYKtvLXSc=
X-Google-Smtp-Source: ABdhPJzXOQ558n+UrYBdrkaMXLI4eXBMLtEOTcokxStclEv/TlpUe1eDPFTI8RYGkpFM9uVU+GX8Igc=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:ac1a:67e0:c919:fba5])
 (user=sdf job=sendgmr) by 2002:a25:2ac5:: with SMTP id q188mr15642828ybq.77.1629821002659;
 Tue, 24 Aug 2021 09:03:22 -0700 (PDT)
Date:   Tue, 24 Aug 2021 09:03:20 -0700
In-Reply-To: <20210824003847.4jlkv2hpx7milwfr@ast-mbp.dhcp.thefacebook.com>
Message-Id: <YSUYSIYyXmBgKRwr@google.com>
Mime-Version: 1.0
References: <20210823215252.15936-1-hansmontero99@gmail.com> <20210824003847.4jlkv2hpx7milwfr@ast-mbp.dhcp.thefacebook.com>
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: Implement shared persistent
 fast(er) sk_storoage mode
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     hjm2133@columbia.edu, bpf@vger.kernel.org, netdev@vger.kernel.org,
        ppenkov@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/23, Alexei Starovoitov wrote:
> On Mon, Aug 23, 2021 at 05:52:50PM -0400, Hans Montero wrote:
> > From: Hans Montero <hjm2133@columbia.edu>
> >
> > This patch set adds a BPF local storage optimization. The first patch  
> adds the
> > feature, and the second patch extends the bpf selftests so that the  
> feature is
> > tested.
> >
> > We are running BPF programs for each egress packet and noticed that
> > bpf_sk_storage_get incurs a significant amount of cpu time. By inlining  
> the
> > storage into struct sock and accessing that instead of performing a map  
> lookup,
> > we expect to reduce overhead for our specific use-case.

> Looks like a hack to me. Please share the perf numbers and setup details.
> I think there should be a different way to address performance concerns
> without going into such hacks.

What kind of perf numbers would you like to see? What we see here is
that bpf_sk_storage_get() cycles are somewhere on par with hashtable
lookups (we've moved off of 5-tuple ht lookup to sk_storage). Looking
at the code, it seems it's mostly coming from the following:

   sk_storage = rcu_dereference(sk->sk_bpf_storage);
   sdata = rcu_dereference(local_storage->cache[smap->cache_idx]);
   return sdata->data

We do 3 cold-cache references :-( This is where the idea of inlining
something in the socket itself came from. The RFC is just to present
the case and discuss. I was thinking about doing some kind of
inlining at runtime (and fallback to non-inlined case) but wanted
to start with discussing this compile-time option first.

We can also try to save sdata somewhere in the socket to avoid two
lookups for the cached case, this can potentially save us two  
rcu_dereference's.
Is that something that looks acceptable? I was wondering whether you've
considered any socket storage optimizations on your side?

I can try to set up some office hours to discuss in person if that's
preferred.

> > This also has a
> > side-effect of persisting the socket storage, which can be beneficial.

> Without explicit opt-in such sharing will cause multiple bpf progs to  
> corrupt
> each other data.

New BPF_F_SHARED_LOCAL_STORAGE flag is here to provide this opt-in.
