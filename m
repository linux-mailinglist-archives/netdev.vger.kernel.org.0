Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7AB846575
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfFNRQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:16:05 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35677 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfFNRQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:16:05 -0400
Received: by mail-pg1-f195.google.com with SMTP id s27so1917881pgl.2;
        Fri, 14 Jun 2019 10:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w4xkfhw9P/mZ5Ov6JWcVYWfC+GgKo69/kxNNY20kkhA=;
        b=aWr1mLGflo4B0gklLMgNG5TQYmjw4KhJEWBX01cWmxiTSa/6niCilaGzLttBFRHtOp
         eI6X2+PdURC14gRWzkvTDjp77K4JI5B7DdN+vm2c3wvEZgJHciFf4v8HUJSFykc/j+NL
         Pn99ZlkI9Apd+ki5nEdF3tAXFsRXejPigSGaU3/3+dK9ME1ot1zipNfXKo9pOcUxFUsQ
         H4nYwQohLLNHE4pDoYjpynzMUr3mjnaUWqKiIxeuVqHkOyfO9IyvbsShpFO8lwIrE54v
         ROg1lVrLHYxF+R1dWLg6LEXWU8mS7hWT7LVxFNAySd1i9K0hs4nX00Hu1wlApvZV+zLO
         oAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4xkfhw9P/mZ5Ov6JWcVYWfC+GgKo69/kxNNY20kkhA=;
        b=kID4kQxxYUfN3Ly/USSEjQH+SM7KedaZo/IUMT0m5yKeyc5z5jaoma3ssUGKmUvsQo
         fztuwfH1IcL7HQD2cVmqIwdRl7klZn0GDSWkQmhObr0B7AolWjrUo6rcQ0R/xsObC9cG
         7Z+2vXKfux3VL/ani1vX3pC2lndBhCVzCFMBhUktim8n3tBRpEOg6KatGHkDaB4tNBa5
         mB/qjylqGAZZDS+cnAHQXdJMOYDWQGEPTsLm/u3w5vKzWZf082xEtlUhQGQ1ODaXEpk4
         dwe2GX5ob0PSi8rpskVbBQyaYYOBEHEJHt85DX1vcUVK9yJC1y4djAd1kU5q+Lb5DpS5
         xgQw==
X-Gm-Message-State: APjAAAVr1xAwlbZ3I1UMbQx497kCmOpQa0wZv1tPhnE9OBzblAcNf7Y/
        w7H+kZWBLSD3Ou2HaqjeHuTfeSGdkmM=
X-Google-Smtp-Source: APXvYqx6xvb15603XcKfdISIGDjP0rvkCDGFkgv6fRaGiehXSy0ZApehsh6pSX46o+Jyo7+dL0zahA==
X-Received: by 2002:a65:60c2:: with SMTP id r2mr36174586pgv.156.1560532564021;
        Fri, 14 Jun 2019 10:16:04 -0700 (PDT)
Received: from localhost ([192.55.54.45])
        by smtp.gmail.com with ESMTPSA id r4sm2885535pjd.28.2019.06.14.10.16.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Jun 2019 10:16:03 -0700 (PDT)
Date:   Fri, 14 Jun 2019 19:15:49 +0200
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
Message-ID: <20190614191549.0000374d@gmail.com>
In-Reply-To: <eb175575-1ab4-4d29-1dc9-28d85cddd842@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-8-maximmi@mellanox.com>
 <20190612132352.7ee27bf3@cakuba.netronome.com>
 <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
 <20190613164514.00002f66@gmail.com>
 <eb175575-1ab4-4d29-1dc9-28d85cddd842@mellanox.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 13:25:24 +0000
Maxim Mikityanskiy <maximmi@mellanox.com> wrote:

> On 2019-06-13 17:45, Maciej Fijalkowski wrote:
> > On Thu, 13 Jun 2019 14:01:39 +0000
> > Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> >   
> >> On 2019-06-12 23:23, Jakub Kicinski wrote:  
> >>> On Wed, 12 Jun 2019 15:56:48 +0000, Maxim Mikityanskiy wrote:  
> >>>> Currently, libbpf uses the number of combined channels as the maximum
> >>>> queue number. However, the kernel has a different limitation:
> >>>>
> >>>> - xdp_reg_umem_at_qid() allows up to max(RX queues, TX queues).
> >>>>
> >>>> - ethtool_set_channels() checks for UMEMs in queues up to
> >>>>     combined_count + max(rx_count, tx_count).
> >>>>
> >>>> libbpf shouldn't limit applications to a lower max queue number. Account
> >>>> for non-combined RX and TX channels when calculating the max queue
> >>>> number. Use the same formula that is used in ethtool.
> >>>>
> >>>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >>>> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> >>>> Acked-by: Saeed Mahameed <saeedm@mellanox.com>  
> >>>
> >>> I don't think this is correct.  max_tx tells you how many TX channels
> >>> there can be, you can't add that to combined.  Correct calculations is:
> >>>
> >>> max_num_chans = max(max_combined, max(max_rx, max_tx))  
> >>
> >> First of all, I'm aligning with the formula in the kernel, which is:
> >>
> >>       curr.combined_count + max(curr.rx_count, curr.tx_count);
> >>
> >> (see net/core/ethtool.c, ethtool_set_channels()).
> >>
> >> The formula in libbpf should match it.
> >>
> >> Second, the existing drivers have either combined channels or separate
> >> rx and tx channels. So, for the first kind of drivers, max_tx doesn't
> >> tell how many TX channels there can be, it just says 0, and max_combined
> >> tells how many TX and RX channels are supported. As max_tx doesn't
> >> include max_combined (and vice versa), we should add them up.
> >>  
> >>>>    tools/lib/bpf/xsk.c | 6 +++---
> >>>>    1 file changed, 3 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >>>> index bf15a80a37c2..86107857e1f0 100644
> >>>> --- a/tools/lib/bpf/xsk.c
> >>>> +++ b/tools/lib/bpf/xsk.c
> >>>> @@ -334,13 +334,13 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
> >>>>    		goto out;
> >>>>    	}
> >>>>    
> >>>> -	if (channels.max_combined == 0 || errno == EOPNOTSUPP)
> >>>> +	ret = channels.max_combined + max(channels.max_rx, channels.max_tx);  
> > 
> > So in case of 32 HW queues you'd like to get 64 entries in xskmap?  
> 
> "32 HW queues" is not quite correct. It will be 32 combined channels, 
> each with one regular RX queue and one XSK RX queue (regular RX queues 
> are part of RSS). In this case, I'll have 64 XSKMAP entries.
> 
> > Do you still
> > have a need for attaching the xsksocks to the RSS queues?  
> 
> You can attach an XSK to a regular RX queue, but not in zero-copy mode. 
> The intended use is, of course, to attach XSKs to XSK RX queues in 
> zero-copy mode.
>
> > I thought you want
> > them to be separated. So if I'm reading this right, [0, 31] xskmap entries
> > would be unused for the most of the time, no?  
> 
> This is correct, but these entries are still needed if one decides to 
> run compatibility mode without zero-copy on queues 0..31.

Why would I want to run AF_XDP without ZC? The main reason for having AF_XDP
support in drivers is the zero copy, right?

Besides that, are you educating the user in some way which queue ids should be
used so there's ZC in picture? If that was already asked/answered, then sorry
about that.

> 
> >   
> >>>> +
> >>>> +	if (ret == 0 || errno == EOPNOTSUPP)
> >>>>    		/* If the device says it has no channels, then all traffic
> >>>>    		 * is sent to a single stream, so max queues = 1.
> >>>>    		 */
> >>>>    		ret = 1;
> >>>> -	else
> >>>> -		ret = channels.max_combined;
> >>>>    
> >>>>    out:
> >>>>    	close(fd);  
> >>>      
> >>  
> >   
> 

