Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59D6D7C2D
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 18:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfJOQnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 12:43:02 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42753 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbfJOQnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 12:43:02 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so47372931iod.9
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 09:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NJsqdzOxl/Z/qldt7cfzRazc4Tsw2VCm6QXzwKfMe5M=;
        b=smUMxNeGFVgzQXraJXtQRfBoAWz8uaxE3rXm+Pq7KlV6aPeW2Sk72xsgqMkRVWlVqm
         xRb3quXocb6vEu5znwBdwt8kDZRUWlQ/IXqn07/VOD3rbV/d7Rz11V1W+13cEJPofXId
         Bs+xHebjSmbIqnOy6BOO6MZPE252XCWQBQC/olBhtJR+romffPU9Yo7NfvQEm3borLUf
         EnjP+P8SX+acpqin9yxxhyr9TYWJ/jiYWG/HKtZ/Mev59qmGNtEtPsBNHUBvr/cHG9hE
         dw4OGcyCPt8YJ/bBGbWOxGtj5NF1AqnURc26cDOl44Q/yqNSd0ZkQgLsYLUjY6ZlP8hD
         dPTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NJsqdzOxl/Z/qldt7cfzRazc4Tsw2VCm6QXzwKfMe5M=;
        b=Jhwaimhp66LBWHBTtGw01FzY9w7wh9P8xeHh7jKdxcvoQT0jrU2YUbnT2NuUgSf96N
         uTz9A6TLOqghmHeJ3Hf0DJpEJlU0Ydelp/zhFyaKcyIeM6yjkdsB4mn+FOZstIom/Oyu
         8HxLC3gpMp3L0YqJHg1POGRtNcMYQybUedmaURWdxfxpvrCfF73B5SOACVPYKENmBRZU
         VHDOmGjDmKdvBt4D8JWMPJ+1wsqjy+MAlGQo44v0x0LHblNkBxZhHvSwfJtBhihbhkQQ
         2N+Opz4Q0SGTRKY9A5f34YK61kvWWbMkwD1EJf/w6wfx6Azrt/5tRa/AArp0caj7BVCF
         t6rw==
X-Gm-Message-State: APjAAAXaEN9tZksesCgiHE+ONM/X+xZKj+HMloWHuyc87ysyJvEnWwo3
        BTcGt4TJbOxluLUCUN64tAz7AATB2Snwq0/mc4PH0Q==
X-Google-Smtp-Source: APXvYqyiLQr26otrtNarntKSOUxE5SmfACfAtXLqQ8ok+c3xydH0C7bGdLavH/YFZkcQLn4ZW1oJb6u11TJDG+YhZ4U=
X-Received: by 2002:a92:4144:: with SMTP id o65mr7478826ila.206.1571157780904;
 Tue, 15 Oct 2019 09:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <CANSNSoV1M9stB7CnUcEhsz3FHi4NV_yrBtpYsZ205+rqnvMbvA@mail.gmail.com>
 <20191010083102.GA1336@splinter> <CANSNSoVM1Uo106xfJtGpTyXNed8kOL4JiXqf3A1eZHBa7z3=yg@mail.gmail.com>
 <20191011154224.GA23486@splinter> <CAEA6p_AFKwx_oLqNOjMw=oXcAX4ftJvEQWLo0aWCh=4Hs=QjVw@mail.gmail.com>
 <20191012065608.igcba7tcjr4wkfsf@kafai-mbp.dhcp.thefacebook.com>
 <CAEA6p_A_kNA8kVLmVn0e=fp=vx3xpHTTaVrx62NVCDLowVxaog@mail.gmail.com>
 <20191014172640.hezqrjpu43oggqjt@kafai-mbp.dhcp.thefacebook.com> <9d4dd279-b20a-e333-2dd6-fe2901e67bce@gmail.com>
In-Reply-To: <9d4dd279-b20a-e333-2dd6-fe2901e67bce@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 15 Oct 2019 09:42:49 -0700
Message-ID: <CAEA6p_A_zB0uLn34UeCpXOSQZiOsPFfcfvDtmNZWrks6PCj0=g@mail.gmail.com>
Subject: Re: Race condition in route lookup
To:     David Ahern <dsahern@gmail.com>
Cc:     Martin Lau <kafai@fb.com>, Ido Schimmel <idosch@idosch.org>,
        Jesse Hathaway <jesse@mbuki-mvuki.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 7:45 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/14/19 1:26 PM, Martin Lau wrote:
> >
> > AFAICT, even for the route that are affected by fib6_update_sernum_upto_root(),
> > I don't see the RTF_PCPU route is re-created.  v6 sk does
> > dst_check() => re-lookup the fib6 =>
> > found the same RTF_PCPU (but does not re-create it) =>
> > update the sk with new cookie in ip6_dst_store()
> >
Hmm... That is a good point. Why does v4 need to recreate the dst
cache even though the route itself is not changed?
Now that I think about it, I agree with Martin's previous comment: it
probably is because v4 code does not cache rt->rt_genid into the
socket and every user of the rt is sharing the same rt_genid stored in
the route itself.

>
> That's fine. The pcpu cache is per nexthop (fib6_nh) for a specific
> gateway/device.
>
> The invalidate forces another lookup for the intended destination after
> the change to the fib. If the lookup resolves to the same fib entry and
> nexthop, then re-using the same cached dst/rt6_info is ok.
