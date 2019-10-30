Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A126AEA5F9
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfJ3WGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:06:55 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39487 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfJ3WGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:06:55 -0400
Received: by mail-lj1-f193.google.com with SMTP id y3so4416475ljj.6
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lxoBiXoE3IA3ag85nku1MYpWfHm9btyZTPZWJFJQhsM=;
        b=u7LvShCe7FXGwo9ndPbxRaXU98R6zL1S1zBoihwj0QbJFD/eueML2oUxgMrgS3iO8h
         FJdw2AW/IVazYMTDcViTrMDOi2TId85yLsXh2XtywjB4fIY/QQvoobED3CFBgbLJDRUH
         XgD3UF+rVS+XYg1hNCQNIuzXb/rpJJCvB+qH8xdoyj80xT6WXD7hPWJr4AlI8fOnEoi0
         cAnDdwin9p+cELZ4t0rVLcMmITXAR2n2RJ3MY33UYneVnzg9zmE9PzB7csLxozYaKg9F
         DYP1XLpcnIZbd4L7NJZU8fY5Lt9TxB4K6y3Ou5agioxK1RnW7M9x5IgVoXBf/lO/L6Jy
         dV9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lxoBiXoE3IA3ag85nku1MYpWfHm9btyZTPZWJFJQhsM=;
        b=Fy3fhjAplw/6eZ4eCjvsC9ZrZstXRNHKp4HcFyQUYoczSRlU8L2PE1DIElV+wRAZ+x
         7E9y6cEudfJGVdxT73B6XcZMUZofWDS8+3+9RHpaIP7kdN48ULnEHM2EapfN7wjA1h4e
         2YlD9TpixbaehmpK6Fsld9JSlfpLQqDvUrl7ELcCHk1+uSIbM8v2e+qbzCSbfXHePS/e
         EN1g9uiLb6PsFTt9ZUo+6bn+4SRiFUiirRgp6xhtzsVJh16HwOO8DHeFbKdEi5ugRwej
         IbD/+rD53Y/wacxPvD0KJ7ApbnJrmguImvv5zpBWnkoxGEbM1+pD93JN51mDsLT4NyxW
         MjVw==
X-Gm-Message-State: APjAAAXLRUODD/du51qf6514cJQHmEjE1oo+FBEIEf5kKUPR2xxHJyIf
        HPPLnGRbzsBrRJ0lOcphy9qikg==
X-Google-Smtp-Source: APXvYqwK2XkvI7GFLxS95pWhiPMxGsN/nna4IVxhVIFYPkNHX8fuHlHnj3auZvym9nkJGbPjftrINw==
X-Received: by 2002:a2e:3a09:: with SMTP id h9mr1384220lja.33.1572473212799;
        Wed, 30 Oct 2019 15:06:52 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r12sm976177lfp.63.2019.10.30.15.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 15:06:52 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:06:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 5/9] ice: Add support for AF_XDP
Message-ID: <20191030150642.5f008878@cakuba.netronome.com>
In-Reply-To: <20191030230406.00004e3c@gmail.com>
References: <20191030032910.24261-1-jeffrey.t.kirsher@intel.com>
        <20191030032910.24261-6-jeffrey.t.kirsher@intel.com>
        <20191030115009.6168b50f@cakuba.netronome.com>
        <20191030230406.00004e3c@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 23:04:06 +0100, Maciej Fijalkowski wrote:
> On Wed, 30 Oct 2019 11:50:09 -0700
> Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> 
> > On Tue, 29 Oct 2019 20:29:06 -0700, Jeff Kirsher wrote:  
> > > +/**
> > > + * ice_run_xdp_zc - Executes an XDP program in zero-copy path
> > > + * @rx_ring: Rx ring
> > > + * @xdp: xdp_buff used as input to the XDP program
> > > + *
> > > + * Returns any of ICE_XDP_{PASS, CONSUMED, TX, REDIR}
> > > + */
> > > +static int
> > > +ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
> > > +{
> > > +	int err, result = ICE_XDP_PASS;
> > > +	struct bpf_prog *xdp_prog;
> > > +	struct ice_ring *xdp_ring;
> > > +	u32 act;
> > > +
> > > +	rcu_read_lock();
> > > +	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
> > > +	if (!xdp_prog) {
> > > +		rcu_read_unlock();
> > > +		return ICE_XDP_PASS;
> > > +	}
> > > +
> > > +	act = bpf_prog_run_xdp(xdp_prog, xdp);
> > > +	xdp->handle += xdp->data - xdp->data_hard_start;
> > > +	switch (act) {
> > > +	case XDP_PASS:
> > > +		break;
> > > +	case XDP_TX:
> > > +		xdp_ring = rx_ring->vsi->xdp_rings[rx_ring->q_index];
> > > +		result = ice_xmit_xdp_buff(xdp, xdp_ring);
> > > +		break;    
> > 
> > From the quick look at the code it wasn't clear to me how you deal with
> > XDP_TX on ZC frames. Could you describe the flow of such frames a
> > little bit?  
> 
> Sure, here we go.
> The ice_xmit_xdp_buff() is calling a convert_to_xdp_frame(xdp) which in that
> case falls to the xdp_convert_zc_to_xdp_frame(xdp), because xdp->rxq->mem.type
> is set to MEM_TYPE_ZERO_COPY. 
> 
> Now we are in the xdp_convert_zc_to_xdp_frame(xdp), where we allocate the
> extra page dedicated for struct xdp_frame, copy into this page the data that are
> within the current struct xdp_buff and everything is finished with a
> xdp_return_buff(xdp) call. Again, the mem->type is the MEM_TYPE_ZERO_COPY so
> the callback for freeing ZC frames is invoked, via:
> 
> xa->zc_alloc->free(xa->zc_alloc, handle);
> 
> And this guy was set during the Rx context initialization:
> 
> ring->zca.free = ice_zca_free;
> err = xdp_rxq_info_reg_mem_model(&ring->xdp_rxq,
> 				 MEM_TYPE_ZERO_COPY,
> 				 &ring->zca);
> 
> Finally, the ice_zca_free will put the ZC frame back to HW Rx ring. At this
> point, the ZC frame was recycled and the content from that frame sit in the
> standalone page, represented by struct xdp_frame, so we are free to proceed
> with transmission and that extra page will be freed during the cleanup of Tx
> irq, after it got transmitted successfully.
> 
> I might over-complicate this description with too much code examples, so let me
> know if that makes sense to you.

Makes sense, thanks!
