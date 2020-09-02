Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B5225B056
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgIBP4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgIBP4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 11:56:37 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A75DC061245
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 08:56:37 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e23so7390533eja.3
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 08:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L/mko5z4Q8r0dHp0YoAcHTfZhNAOhoM40NzNyzQZzWM=;
        b=V9Y1XV/rbc8mkAW+tG0e59MdLQV8r3c4qkCha6H4k5cFC6+UMHJJL1GnuYQTjYAHKZ
         SXcA9l0djXpvYLcJVRsDYJaPOG03V7Ynrd5djFXfvrLd1lJNiUVLRcDD/WE/OXhY0EqQ
         PHDACPqtv1XiecfQ2gRls2OgRYIrrgsMqha/hZXr+5eoEZq8YF0FFqBqOFqDON43xBor
         Mgc5Vbyfj3TCGxmaaS03SoUusxXv3vAG5s8i5gwQQ1hYChv87z9uWMb3B4/gvZuLfVao
         cJjv5EtVNxNHczYuo/Kg2jpft8ESxfnVibPCjUf1+g48ifYbJVBDD5rGoC0Yh1Sq+lsF
         1icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L/mko5z4Q8r0dHp0YoAcHTfZhNAOhoM40NzNyzQZzWM=;
        b=mYh+MQprNtS9qdfTHzyLDBakF9BBq9S1K45X2ocGDPXXSUGcGDvzVrmzpPKVqGWazB
         a/IfFaozy0sBWaGAqdNmM9Is9ZC4M7L+1sUYc3NQ+HfsTOYpidZ3+oSOJTMk60gGl/kd
         80xMXyW85Vq0gytl0J9qqaCT/AQkjh9P1SrzLVqDgg9ZIFptGVpGJV4Q04lku3DObRLL
         VygcDAHO998t8Ovg/mQJ/foKornVgB0C0/j8c1OyVdsIxccNjeqCc1Nbt/mfnjgxXblc
         rB2BYjYdOqTwkHbFwuRybQ9chotjv1RPVMKQVDTQznzr3gUyxBz/6F86QEIEn01jneJj
         kZgA==
X-Gm-Message-State: AOAM531Rah4Xce+E1lT6OEHZXou+zdFf43c8EBnPWA6X+UvbbyA46AbQ
        tBG9yUn/KHYsYNMjfQ6igyzHbvdEk7fgj4RoHMePgw==
X-Google-Smtp-Source: ABdhPJyDm8fWg7kxusa9ui+F6PdxLHCWuE0KdTT123L3KZKQnYl7dAsSYboiSMbvx0ICUmBlnhDSxah4AGgX7TFtitU=
X-Received: by 2002:a17:906:3191:: with SMTP id 17mr627257ejy.239.1599062195391;
 Wed, 02 Sep 2020 08:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200831192506.28896-1-harshitha.ramamurthy@intel.com> <0333522d-7b65-e665-f19e-d36d11bd7846@iogearbox.net>
In-Reply-To: <0333522d-7b65-e665-f19e-d36d11bd7846@iogearbox.net>
From:   Tom Herbert <tom@herbertland.com>
Date:   Wed, 2 Sep 2020 09:56:24 -0600
Message-ID: <CALx6S36sG_-eT0ziTaAfeHkocBi_K6q646JzphHbQ_W4YxXd0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        "TOM.HERBERT@INTEL.COM" <tom.herbert@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 2:33 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 8/31/20 9:25 PM, Harshitha Ramamurthy wrote:
> > This patch adds a helper function called bpf_get_xdp_hash to calculate
> > the hash for a packet at the XDP layer. In the helper function, we call
> > the kernel flow dissector in non-skb mode by passing the net pointer
> > to calculate the hash.
>
> So this commit msg says 'what' the patch does, but says nothing about 'why' it is
> needed especially given there's the 1 mio insn limit in place where it should be
> easy to write that up in BPF anyway. The commit msg needs to have a clear rationale
> which describes the motivation behind this helper.. why it cannot be done in BPF
> itself?
>
Daniel,

We already have a fully functional, well tested, and very complete
parser supporting many protocols and packet hash functions in the
kernel in skb_flow_dissect and friends. I suppose we could replicate
all that code in eBPF but I don't think it's fair to say it's easy to
get to the same level in eBPF. eBPF does solve the problem of
extensibility of kernel code, however IMO if someone is looking for an
easy way to get a packet hash then a simple helper function makes
sense and results in a much simpler XDP program.

There's some nice potential follow on work also. If the hardware
provides a quality L4 hash that could be passed into the XDP program
to avoid having to call the helper. If we do invoke the helper it
would make sense to return the hash to the driver so that it can set
in the skbuff to avoid having the stack call skb_flow_dissect again.
We can also have an flow_diessct helper that invokes skb_flow_dissect
and returns the meta data based on input keys. This would be useful
for filtering in XDP etc.

Tom

> > Changes since RFC:
> > - accounted for vlans(David Ahern)
> > - return the correct hash by not using skb_get_hash(David Ahern)
> > - call __skb_flow_dissect in non-skb mode
> >
