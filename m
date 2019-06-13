Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C34437A9
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732896AbfFMPA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:00:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45122 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732584AbfFMOps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:45:48 -0400
Received: by mail-pg1-f195.google.com with SMTP id s21so551657pga.12;
        Thu, 13 Jun 2019 07:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vUzDilXp+WPpMTvJTzw1yqDN0+0/72oHGkw9u/TSfdM=;
        b=hIoYbyb0+WjfWaGXFFcbf1UmNm7/kww3HsQflw9TVvTpthWuw6Qn50rfD+7DFF2xk1
         wd4uDV7sYHb+TRealUNM7lgziSzF6d8iMr/y4TCqtmKkriIv9l6TVrmtCWgF4rirHgd2
         OIVt4901i8EMipWFxqUkdd2AaZe/Kfu8zx5nhZkV5vLlHlCt3l3OSfJZMtH9MfQD8rZX
         hTfcg1U0gwMq5HVqC9hDMEvCSpv4H21dOMGxBCahGK0Bj50DjSjPBQ605OSoMYN18HVw
         IGwORpVVN5y941OElIn0W+ayX2topXcyUtyXc+nWY22PSywFfK8iUwkRO/JS2Kj4iLM5
         gBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUzDilXp+WPpMTvJTzw1yqDN0+0/72oHGkw9u/TSfdM=;
        b=RpNMhPDgglcvF9Rr9RepOxcfUsOHxAGsTswxmKpiPSVHey73T8o9uAXWE2UK6vrPvP
         rtjDND1OtcF5jzpGek9IOju1XR5vm1Z10TzhbApcCen7XRCRV/L4qnbDo/2NoiGQVqn7
         ifxJHMkxvylb4KqSqzkznQtaWXVZNHFLabfG2dWA+Y73x/VqYMyQQ19Rw1RlTs22nZ6r
         ApqdMoR5mgY/lp/pnhXBKqmjDZ4glRyHUChwwWxk25v3fowIK1pIuAWTF86wMLS7pqIV
         DXlF8cMH6NBqFUrPdSYU1ZR0a0F6VC8leiVTIbtdg7cyvQe1csJ6rpbo++erOgm8gRjq
         s7pg==
X-Gm-Message-State: APjAAAUqemey8fiJJZ1sL7u4rpj57E4NmvSA5780TapiVYcPOaz///1L
        PSkEaDFtbr9ieaFILwxO9ng=
X-Google-Smtp-Source: APXvYqw8N1JXllKIOnVP7H70yd1i3MWWJsNboCSPXH0JWljYxy8OqBs6F4LW4pAQDejFhZUK7tWZIw==
X-Received: by 2002:a65:4283:: with SMTP id j3mr30294812pgp.88.1560437147998;
        Thu, 13 Jun 2019 07:45:47 -0700 (PDT)
Received: from localhost ([192.55.54.45])
        by smtp.gmail.com with ESMTPSA id n66sm3208845pfn.52.2019.06.13.07.45.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Jun 2019 07:45:47 -0700 (PDT)
Date:   Thu, 13 Jun 2019 16:45:37 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Message-ID: <20190613164514.00002f66@gmail.com>
In-Reply-To: <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
        <20190612155605.22450-8-maximmi@mellanox.com>
        <20190612132352.7ee27bf3@cakuba.netronome.com>
        <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019 14:01:39 +0000
Maxim Mikityanskiy <maximmi@mellanox.com> wrote:

> On 2019-06-12 23:23, Jakub Kicinski wrote:
> > On Wed, 12 Jun 2019 15:56:48 +0000, Maxim Mikityanskiy wrote:  
> >> Currently, libbpf uses the number of combined channels as the maximum
> >> queue number. However, the kernel has a different limitation:
> >>
> >> - xdp_reg_umem_at_qid() allows up to max(RX queues, TX queues).
> >>
> >> - ethtool_set_channels() checks for UMEMs in queues up to
> >>    combined_count + max(rx_count, tx_count).
> >>
> >> libbpf shouldn't limit applications to a lower max queue number. Account
> >> for non-combined RX and TX channels when calculating the max queue
> >> number. Use the same formula that is used in ethtool.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> >> Acked-by: Saeed Mahameed <saeedm@mellanox.com>  
> > 
> > I don't think this is correct.  max_tx tells you how many TX channels
> > there can be, you can't add that to combined.  Correct calculations is:
> > 
> > max_num_chans = max(max_combined, max(max_rx, max_tx))  
> 
> First of all, I'm aligning with the formula in the kernel, which is:
> 
>      curr.combined_count + max(curr.rx_count, curr.tx_count);
>
> (see net/core/ethtool.c, ethtool_set_channels()).
> 
> The formula in libbpf should match it.
> 
> Second, the existing drivers have either combined channels or separate 
> rx and tx channels. So, for the first kind of drivers, max_tx doesn't 
> tell how many TX channels there can be, it just says 0, and max_combined 
> tells how many TX and RX channels are supported. As max_tx doesn't 
> include max_combined (and vice versa), we should add them up.
> 
> >>   tools/lib/bpf/xsk.c | 6 +++---
> >>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >> index bf15a80a37c2..86107857e1f0 100644
> >> --- a/tools/lib/bpf/xsk.c
> >> +++ b/tools/lib/bpf/xsk.c
> >> @@ -334,13 +334,13 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
> >>   		goto out;
> >>   	}
> >>   
> >> -	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
> >> +	ret = channels.max_combined + max(channels.max_rx, channels.max_tx);

So in case of 32 HW queues you'd like to get 64 entries in xskmap? Do you still
have a need for attaching the xsksocks to the RSS queues? I thought you want
them to be separated. So if I'm reading this right, [0, 31] xskmap entries
would be unused for the most of the time, no?

> >> +
> >> +	if (ret == 0 || errno == EOPNOTSUPP)
> >>   		/* If the device says it has no channels, then all traffic
> >>   		 * is sent to a single stream, so max queues = 1.
> >>   		 */
> >>   		ret = 1;
> >> -	else
> >> -		ret = channels.max_combined;
> >>   
> >>   out:
> >>   	close(fd);  
> >   
> 

