Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E76D44A66
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbfFMSKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:10:03 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36856 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbfFMSKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:10:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so4261721qtl.3
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 11:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+LKZyqgGQbCIPl9Dm71zQyE2nqAwRgmaCQ11R0neIWo=;
        b=EmTuegif35siUUtwwIOMWur02oCKcpNgsi5u1MXNYXYDMY9z06Hq8WpZJOlRDRegNn
         6yuZNtHtej4ar2gORDRqfp+i09CMWqs7VE17tHHSsQqodgXyFzjYh66k18EQnOhbDTf0
         32PI/6bn/51pBk0+yaB4WLpQFdGbsjvb1XNyQDNN03R7RnReX3GM5OIYDA3DhuUvg1b1
         cN7OTfIGs7LB02XBtzXwqMucew9uDZ56h0/dxhCkZORYsRrRovrM0AN1kB+PCxG5155g
         mfiyHyQFNVZHvi4PJjig1maPM9IlEDYFbV1EAQet/oqkEkyKzx5H4dpObhvh93NwxCXr
         A4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+LKZyqgGQbCIPl9Dm71zQyE2nqAwRgmaCQ11R0neIWo=;
        b=pCWDVk2ygShGs2tbtKoqH+vAMUa6VpBF/ozO4htFlyvXFIHwyDpcHQv7vSLklrR8hR
         L0986FZ5Cwv0JbcuwjISp77uEng0tFNmV26lBoYFr7HLfoyLbEK1d7KMjXY58Wm+e/F6
         2Gp+Cjp2pz5TOco2+E7xtYXGs6RHx79ik0jDATVvRRTzHUunrTm2QCY4G6NUnlhbERJE
         vm4pJEFXMUpZDY5SagrMuTS5xkW9c6QLsHJK+DdV7R1dMNl+JTxPNIh+rpSjPBR3nSr5
         YlhpJuTwbFN+DyNd3Ilpw8rjVS5lzTKRNM+v1mkZaB1i7GjHvfiNwCHG2qJ5ggQ6hMZB
         YNIQ==
X-Gm-Message-State: APjAAAV0uZ+t5p+f8cJ/87Cwlipd4d+1MzbPB8dUSy+LeRwFLWf1uKND
        RBtEmmEbnMFvJqkxq863pId30Q==
X-Google-Smtp-Source: APXvYqxFKZWS2eCPpWb5I5tmIJOzuvY4s8b4e71351BqkWA9c9A4iwrqKm0UFbByhg0aGhU2TGsrIQ==
X-Received: by 2002:ac8:16a2:: with SMTP id r31mr75450617qtj.302.1560449401337;
        Thu, 13 Jun 2019 11:10:01 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o66sm121381qkb.90.2019.06.13.11.09.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 11:10:01 -0700 (PDT)
Date:   Thu, 13 Jun 2019 11:09:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Message-ID: <20190613110956.001ef81f@cakuba.netronome.com>
In-Reply-To: <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
        <20190612155605.22450-8-maximmi@mellanox.com>
        <20190612132352.7ee27bf3@cakuba.netronome.com>
        <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019 14:01:39 +0000, Maxim Mikityanskiy wrote:
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

curr != max.  ethtool code you're pointing me to (and which I wrote)
uses the current allocation, not the max values.

> The formula in libbpf should match it.

The formula should be based on understanding what we're doing, 
not copying some not-really-equivalent code from somewhere :)

Combined is a basically a queue pair, RX is an RX ring with a dedicated
IRQ, and TX is a TX ring with a dedicated IRQ.  If driver supports both
combined and single purpose interrupt vectors it will most likely set

	max_rx = num_hw_rx
	max_tx = num_hw_tx
	max_combined = min(rx, tx)

Like with most ethtool APIs there are some variations to this.

> Second, the existing drivers have either combined channels or separate 
> rx and tx channels. So, for the first kind of drivers, max_tx doesn't 
> tell how many TX channels there can be, it just says 0, and max_combined 
> tells how many TX and RX channels are supported. As max_tx doesn't 
> include max_combined (and vice versa), we should add them up.

By existing drivers you mean Intel drivers which implement AF_XDP, 
and your driver?  Both Intel and MLX drivers seem to only set
max_combined.

If you mean all drivers across the kernel, then I believe the best
formula is what I gave you.

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
