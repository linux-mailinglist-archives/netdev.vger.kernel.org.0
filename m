Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C079712092E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 16:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfLPPBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 10:01:17 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:46618 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbfLPPBR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 10:01:17 -0500
Received: by mail-il1-f196.google.com with SMTP id t17so5624770ilm.13;
        Mon, 16 Dec 2019 07:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zn62EC+SRJNqnlXjqFaeTezjxELxXVZIr2BFFX93d7s=;
        b=ts/OM7nMG2XyF61v+PSyB7rzRYD2//G6jvqO5r5ysBw9AnsK3+MeY8EuLYDcot1e/q
         0RDkKUaRCUH9CBA79lbTJRUvBsyHDygqskpkqRvtmvjasx6PmRZnRgpI+g8C6z1N4DQe
         SPyMhtRlniKzfN/kvz4hkqOsMA8Rr54mVeAsMdRK2KdxGW4H65fQGYob7CHUt+Q41Nfv
         av5PtUx5qlJGDnAJ3q/ZUaJydJE8LKord5MBJhtRdUKPlyi9a/OsOU6EsmKREFym5xp7
         qePYwQIWROpCUEAHXsIaogN2iP57zAYlvig62uqGNB8md5AZg0vCZWFVbFcUwO/+jjHX
         oe+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zn62EC+SRJNqnlXjqFaeTezjxELxXVZIr2BFFX93d7s=;
        b=SlqM25wV0OprVpVeVq34j5pH1oblJz4ivUMW0OiIJsVbJkcnzgocQppC35oZXujjF7
         tG1WhINsiI4UGLf6znxPrFYitZ1N3tg9CFXEBR1YLUFFbJSeac+rpTKiZOA+ksoc8hnn
         g5lb7Smhyk/aOEVJriGUwUVArV3UAiBdqhk7Y6p6PCbzA8EW7JqQLy+Zxklyse6U3doP
         ohkerFBqvmbL7B0Sfr3Fv3YWgiBOo3ys84h8FBgNR61eymmQKM9LSrun4TN0bwdx65V2
         aOhGj0C6ZMHuSfXMKGfQysj5h4lJZkGs1iVq3e4wPrxwEYtWhHI/gHoMO5G0hdQODcqX
         15EQ==
X-Gm-Message-State: APjAAAWJSnXckgD6lOLnbLegS+U2B6bkkeamQ1QugZJX61gHgWxW95Ij
        LtxSBFp/sBQ+kxLlspv473Q=
X-Google-Smtp-Source: APXvYqxpEv++noZ9Rkk/ZXc5tQYObTgkWZ0UitIrJ+OJ5B7JFEPDDmVrNw3QkZg+QUg0nYqVuVr10g==
X-Received: by 2002:a92:8b03:: with SMTP id i3mr12205907ild.7.1576508476311;
        Mon, 16 Dec 2019 07:01:16 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:6046:f5bd:4635:2d5b? ([2601:284:8202:10b0:6046:f5bd:4635:2d5b])
        by smtp.googlemail.com with ESMTPSA id j17sm5909468ild.45.2019.12.16.07.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Dec 2019 07:01:15 -0800 (PST)
Subject: Re: [PATCH bpf-next] samples/bpf: Attach XDP programs in driver mode
 by default
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <20191216110742.364456-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <71b7ba89-7780-8ce1-1b30-67ae6ebc214c@gmail.com>
Date:   Mon, 16 Dec 2019 08:01:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191216110742.364456-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/16/19 4:07 AM, Toke Høiland-Jørgensen wrote:
> When attaching XDP programs, userspace can set flags to request the attach
> mode (generic/SKB mode, driver mode or hw offloaded mode). If no such flags
> are requested, the kernel will attempt to attach in driver mode, and then
> silently fall back to SKB mode if this fails.
> 
> The silent fallback is a major source of user confusion, as users will try
> to load a program on a device without XDP support, and instead of an error
> they will get the silent fallback behaviour, not notice, and then wonder
> why performance is not what they were expecting.
> 
> In an attempt to combat this, let's switch all the samples to default to
> explicitly requesting driver-mode attach. As part of this, ensure that all
> the userspace utilities have a switch to enable SKB mode. For those that
> have a switch to request driver mode, keep it but turn it into a no-op.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  samples/bpf/xdp1_user.c             |  5 ++++-
>  samples/bpf/xdp_adjust_tail_user.c  |  5 ++++-
>  samples/bpf/xdp_fwd_user.c          | 17 ++++++++++++++---
>  samples/bpf/xdp_redirect_cpu_user.c |  4 ++++
>  samples/bpf/xdp_redirect_map_user.c |  5 ++++-
>  samples/bpf/xdp_redirect_user.c     |  5 ++++-
>  samples/bpf/xdp_router_ipv4_user.c  |  3 +++
>  samples/bpf/xdp_rxq_info_user.c     |  4 ++++
>  samples/bpf/xdp_sample_pkts_user.c  | 12 +++++++++---
>  samples/bpf/xdp_tx_iptunnel_user.c  |  5 ++++-
>  samples/bpf/xdpsock_user.c          |  5 ++++-
>  11 files changed, 58 insertions(+), 12 deletions(-)
> 

Acked-by: David Ahern <dsahern@gmail.com>

Thanks for doing this, Toke.

