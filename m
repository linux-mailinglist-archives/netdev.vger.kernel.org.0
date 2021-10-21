Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA313435854
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 03:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhJUBmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 21:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhJUBmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 21:42:03 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7D8C06161C;
        Wed, 20 Oct 2021 18:39:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f11so4466798pfc.12;
        Wed, 20 Oct 2021 18:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6z6pmntkws3JIoVxcs0cRfziVLFxgFIK3h3B/uS8Qww=;
        b=LBanFLyPzSy4d/c2YdGtHAuRS0rCwCC0fwxWZUD3uY72P4mIC5Q/Qd53om0M/xw+MR
         mBP84YbFvYoIYs3eOI7/+MG2cDLF20jsTLJ5BUV7niuEhXPbRRAipzBF4ALxSAZvRzsJ
         XGMyy30/96g5nxGuffdBMQfuhsgHhPI0TkQcp52sEJxHf1YMTRKV3oqKDg9EFXkVB0ar
         b1ghk7OOxKIU2wSmxBI/uAWkTP8nTCwZYJwaB4hODPYmneeBkGk2VRWf+zL4DGARSqVS
         ZwbJ9Q31a+pCWwFQ3WOUM9AW/9G/UhNcMtxB1nKHlcg/oU11Au0FY5jzphZAYqldyZaW
         j+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6z6pmntkws3JIoVxcs0cRfziVLFxgFIK3h3B/uS8Qww=;
        b=rAmHy+UVILfzITv+g8wrnJMGxTaSVkgniAfKfDlKIhr8CnwwBNZy/PwGD2q1PD4imv
         kckAALe28rz92FzCPvqECIHTC6urOKuN8CeMxfsRvDnrwIPITYuv2i/3zwOJtYOM7hEu
         mP+xile4Z/fzjYjCcQr/WfVXhjrGWz4/z2V5rexugWFjxaMegTCkkjqWlnKKdt1u65pv
         kWRKPIMW/e6PqnlQLIHrlKq0h86phByPrruRo5LtMZOvNTHKDpkFDSOdV4R0x5/sVRQa
         Z5Mr82ZfpPaMQoe80auhesb+YSYq/pT8eEDrJymyflpD4fqeCctSQ/J88tYO402QiUvO
         LnxA==
X-Gm-Message-State: AOAM531s60O/cZT9yu4jTZs+jvmWn+m/kKxOGH7mVDcpnGs4aZQ/dr/k
        ldhwOkIAmHtsPOPFtfJBof1fWJO1h6bgriAie9A=
X-Google-Smtp-Source: ABdhPJzKd1h2Y5XOg7sXlFNskYrVsISwIn9PO9O2R5DyAwwJEYWLWs7/Xr0+HOjNH9TCHjpzFZfYAiud2L7v5Xx5LhY=
X-Received: by 2002:a63:4f57:: with SMTP id p23mr2124913pgl.376.1634780388063;
 Wed, 20 Oct 2021 18:39:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211015112336.1973229-1-markpash@cloudflare.com> <20211015112336.1973229-2-markpash@cloudflare.com>
In-Reply-To: <20211015112336.1973229-2-markpash@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 20 Oct 2021 18:39:36 -0700
Message-ID: <CAADnVQ+_MysCNnaPZd550wQaohtWTikmgnsysoZhnNpwPgv23A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Add ifindex to bpf_sk_lookup
To:     Mark Pashmfouroush <markpash@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        Joe Stringer <joe@cilium.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 4:24 AM Mark Pashmfouroush
<markpash@cloudflare.com> wrote:
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 6fc59d61937a..9bd3e8b8a659 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -6262,6 +6262,7 @@ struct bpf_sk_lookup {
>         __u32 local_ip4;        /* Network byte order */
>         __u32 local_ip6[4];     /* Network byte order */
>         __u32 local_port;       /* Host byte order */
> +       __u32 ifindex;          /* Maps to skb->dev->ifindex */

Is the comment accurate?
The bpf_sk_lookup_kern ifindex is populated with inet_iif(skb).
Which is skb->skb_iif at this point (I think).
skb->dev->ifindex would typically mean destination or egress ifindex.
In __sk_buff we have 'ifindex' and 'ingress_ifindex' to differentiate them.
If it's really dev->ifindex than keeping 'ifindex' name here would be correct,
but looking at how it's populated in inet/udp_lookup makes me wonder
whether it should be named 'ingress_ifindex' instead and comment clarified.

If/when you resubmit please trim cc list to a minimum.
