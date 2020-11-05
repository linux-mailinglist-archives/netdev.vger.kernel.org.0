Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A80F2A7931
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 09:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbgKEI0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 03:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgKEI0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 03:26:01 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0408C0613CF;
        Thu,  5 Nov 2020 00:26:00 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t11so585271edj.13;
        Thu, 05 Nov 2020 00:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CUJEr0lyZ2FU4AN5m4PBTXwWLzjC0fib3G/YnJPxjZc=;
        b=Gfcc7sle2V8J9m3BUZ/qf3oGxYR7rIeXP1pRNWULj9rrdMrNYfJZKrZ9WCGeYnw6pL
         NVr7QM7sfUbKgGKxIM5eDdF3L6zlVH2n7F6iuntm7DmWruV55U/dYvLCODinjoZMqjpd
         HFh7qai07AD66Uh96zY3eMP4gPYNPQBIhM8SI7bsMYKWtZRqeY/wQDcQYIqYe6EOBqqp
         w7h9b2YkZSJI6F1V766LaQ9S0ZvWf3il+vOhqihPkt5ADGFmTcX40zjItdMuzCUdDTtC
         Qpm4VB42MyhkwxE0Cg5GlZ19FhD9WlLNdCSli8emjBdLUo+oOYTyRCgztM+lKwUYtXtk
         a+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CUJEr0lyZ2FU4AN5m4PBTXwWLzjC0fib3G/YnJPxjZc=;
        b=ONWihz/4bUUX2e1ddSCG6/qXFAnZxCWDjT8CkyOk7nvaMhnFrIFj9wcKl/I633XuY+
         STJm4RM0Hzsx8nluNL8Wtw0R3BBrMGK8xOd5p5ZR5bzPjq0358lnkA4qpncuzYIylY9w
         NeuZXvWiHE3s6uKzZPEaZ0JuZvxZaf2LXxn6KezvsFWr2NaLbf33hcVA2UCyEwbN5ZwX
         Ahe/cBGAa90YGrmhMOwelvRB1sbIqWMmAJO4njTKEtOnX+QJU2YKCqY88VQALNun6v1U
         hDuXRbfaljFzsxvxApGJXeLW8l8uHIAh0zZ+HZKqxJ1z54ABmUXSyFlwNf5Ocg54MjqP
         8XrA==
X-Gm-Message-State: AOAM533rRh7eAQ++LV7fe58PNZqRmupqqIWtEuuQfWMt+fjRB1s8b5XB
        zUX7oEXlvgrk/BCT2zNcQXfFA7ooKfn9Zw==
X-Google-Smtp-Source: ABdhPJzMIjaLTPqJeLzp2kDIQJwyVf4nqD63/R0gI+iZ3Gva8aCAGAqgWtxmeC9XpzI9QhQDMbPpEA==
X-Received: by 2002:a50:9e86:: with SMTP id a6mr1393953edf.238.1604564759329;
        Thu, 05 Nov 2020 00:25:59 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id f19sm489095ejk.116.2020.11.05.00.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 00:25:58 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 5 Nov 2020 10:25:57 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 6/9] staging: dpaa2-switch: add .ndo_start_xmit() callback
Message-ID: <20201105082557.c43odnzis35y7khj@skbuf>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-7-ciorneiioana@gmail.com>
 <20201105010439.GH933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105010439.GH933237@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 02:04:39AM +0100, Andrew Lunn wrote:
> > +static int dpaa2_switch_build_single_fd(struct ethsw_core *ethsw,
> > +					struct sk_buff *skb,
> > +					struct dpaa2_fd *fd)
> > +{
> > +	struct device *dev = ethsw->dev;
> > +	struct sk_buff **skbh;
> > +	dma_addr_t addr;
> > +	u8 *buff_start;
> > +	void *hwa;
> > +
> > +	buff_start = PTR_ALIGN(skb->data - DPAA2_SWITCH_TX_DATA_OFFSET -
> > +			       DPAA2_SWITCH_TX_BUF_ALIGN,
> > +			       DPAA2_SWITCH_TX_BUF_ALIGN);
> > +
> > +	/* Clear FAS to have consistent values for TX confirmation. It is
> > +	 * located in the first 8 bytes of the buffer's hardware annotation
> > +	 * area
> > +	 */
> > +	hwa = buff_start + DPAA2_SWITCH_SWA_SIZE;
> > +	memset(hwa, 0, 8);
> > +
> > +	/* Store a backpointer to the skb at the beginning of the buffer
> > +	 * (in the private data area) such that we can release it
> > +	 * on Tx confirm
> > +	 */
> > +	skbh = (struct sk_buff **)buff_start;
> > +	*skbh = skb;
> 
> Where is the TX confirm which uses this stored pointer. I don't see it
> in this file.
> 

The Tx confirm - dpaa2_switch_tx_conf() - is added in patch 5/9.

> It can be expensive to store pointer like this in buffers used for
> DMA.

Yes, it is. But the hardware does not give us any other indication that
a packet was actually sent so that we can move ahead with consuming the
initial skb.

> It has to be flushed out of the cache here as part of the
> send. Then the TX complete needs to invalidate and then read it back
> into the cache. Or you use coherent memory which is just slow.
> 
> It can be cheaper to keep a parallel ring in cacheable memory which
> never gets flushed.

I'm afraid I don't really understand your suggestion. In this parallel
ring I would keep the skb pointers of all frames which are in-flight?
Then, when a packet is received on the Tx confirmation queue I would
have to loop over the parallel ring and determine somehow which skb was
this packet initially associated to. Isn't this even more expensive?

Ioana

