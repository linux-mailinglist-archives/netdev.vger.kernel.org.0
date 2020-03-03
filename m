Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0249178296
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbgCCSn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:43:57 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35445 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbgCCSn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:43:57 -0500
Received: by mail-pj1-f67.google.com with SMTP id s8so1746420pjq.0;
        Tue, 03 Mar 2020 10:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=o2s52Qbl0PNhCadCB1otS0CYR1jnvtic2xAxRNSIjBg=;
        b=X7BfWGriW03csmGwkOK/EPLk6X/O3ojb1VmDipegqUUkTSABR777OpYleaW0jD22HU
         qxiGRSFjglAQ431Cd14AReuBcxWFR30+zjBalLrYGngIYzduhONovZl0Nqn5Ay0EjXkv
         sP/K6/QpycEnh+pb3/8CxSAWn6o5YmhSTj6Qaxvhvb+o02L+K9Ref98WvvyV3Fhk+gbC
         g3ClOdMOrFxes2NaPDabHuCpyjzFodjMEgRW1hcv1cL0scGpXz8bBuh186+uuWExz9+s
         Qem0HV3eKL8nboh63KVAz8wh4NJ2+bvoD+B+iTQM9SYOHa5jD7lEVz5W0HhiGkdjOHPq
         lU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o2s52Qbl0PNhCadCB1otS0CYR1jnvtic2xAxRNSIjBg=;
        b=XOTIpCwTmObtmV15y01dRAvYdPTATXzuJEMa/GvKZI7Vj0A40kuMrlmXhud6X5fX9j
         ef9VTFHo/4B8lYDeCK81VFokqsbEUbs4Dm82+6sZ5J5FgY99LcyAQ1bd3+ZoHyZscP5I
         uPMLhteBDn5DyHmj7QkR1pxKZE48Hd/dMwI7ZzbXzf3wKnq0oQeb4qRZr5B5JkrXp7Fv
         3C9mSMVkqaNWS45QUGFpbgVXakxMZr/SavVNT3RYWizJ+CBRNklEfMU/CcgJVb6Q+TIo
         xXjZhwnOCdTGb1rtMKwnXdvn6siB9O7MgA6QfyFLPdpUn3WVAVGXiH2JmRFk3ONq+ASx
         kLWA==
X-Gm-Message-State: ANhLgQ0rmnctlQftXLYqvGYikMguuzeniyXoYomSxhj0lQ323NVjT7Mk
        sWnQ+E3s2CwkMO+wx7ku0N0=
X-Google-Smtp-Source: ADFU+vsUyny+fBfrVhpEUVaZmXQduHWlJv7RRyAiZAxZJOGHDQVtwsB8Qu47ECO7SbtnHHKWSGFjvQ==
X-Received: by 2002:a17:90b:1904:: with SMTP id mp4mr5595251pjb.110.1583261034899;
        Tue, 03 Mar 2020 10:43:54 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::4:a0de])
        by smtp.gmail.com with ESMTPSA id 196sm25561435pfy.86.2020.03.03.10.43.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 10:43:53 -0800 (PST)
Date:   Tue, 3 Mar 2020 10:43:51 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, gamemann@gflclan.com, lrizzo@google.com,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [bpf-next PATCH] xdp: accept that XDP headroom isn't always
 equal XDP_PACKET_HEADROOM
Message-ID: <20200303184350.66uzruobalf3y76f@ast-mbp>
References: <158323601793.2048441.8715862429080864020.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158323601793.2048441.8715862429080864020.stgit@firesoul>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 12:46:58PM +0100, Jesper Dangaard Brouer wrote:
> The Intel based drivers (ixgbe + i40e) have implemented XDP with
> headroom 192 bytes and not the recommended 256 bytes defined by
> XDP_PACKET_HEADROOM.  For generic-XDP, accept that this headroom
> is also a valid size.
> 
> Still for generic-XDP if headroom is less, still expand headroom to
> XDP_PACKET_HEADROOM as this is the default in most XDP drivers.
> 
> Tested on ixgbe with xdp_rxq_info --skb-mode and --action XDP_DROP:
> - Before: 4,816,430 pps
> - After : 7,749,678 pps
> (Note that ixgbe in native mode XDP_DROP 14,704,539 pps)
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h |    1 +
>  net/core/dev.c           |    4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 906e9f2752db..14dc4f9fb3c8 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3312,6 +3312,7 @@ struct bpf_xdp_sock {
>  };
>  
>  #define XDP_PACKET_HEADROOM 256
> +#define XDP_PACKET_HEADROOM_MIN 192

why expose it in uapi?

>  /* User return codes for XDP prog type.
>   * A valid XDP program must return one of these defined values. All other
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4770dde3448d..9c941cd38b13 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4518,11 +4518,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
>  		return XDP_PASS;
>  
>  	/* XDP packets must be linear and must have sufficient headroom
> -	 * of XDP_PACKET_HEADROOM bytes. This is the guarantee that also
> +	 * of XDP_PACKET_HEADROOM_MIN bytes. This is the guarantee that also
>  	 * native XDP provides, thus we need to do it here as well.
>  	 */
>  	if (skb_cloned(skb) || skb_is_nonlinear(skb) ||
> -	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> +	    skb_headroom(skb) < XDP_PACKET_HEADROOM_MIN) {
>  		int hroom = XDP_PACKET_HEADROOM - skb_headroom(skb);

this looks odd. It's comparing against 192, but doing math with 256.
I guess that's ok, but needs a clear comment.
How about just doing 'skb_headroom(skb) < 192' here.
Or #define 192 right before this function with a comment about ixgbe?
