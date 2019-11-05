Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3A56F0423
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390194AbfKERdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:33:12 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39171 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387776AbfKERdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:33:12 -0500
Received: by mail-pf1-f196.google.com with SMTP id x28so12843727pfo.6
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 09:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tHjWUkxRNifLcA5hnSBRCik22pJdccsL67Zae/WYwLI=;
        b=kYCpAn1LTyDLN2YnjW5HzPjIGJmQa6MBJIBqBbM3DCHBmxWdOslrw0vfzLndnGbZ+I
         LsFO5rFKrKoanK1PdGZJgnK/F+5Gy6kwq8UuB/Q8E60rSKTVtlatxOnRnZgrssvzptdL
         nrJDRkw/WT5y18sgmutgeYmZ2TGBWfQDu201wPrV4IBrsDkUB6VB3ra29cY9HB7kXCfx
         x2QgU1N2nQQtpdq7JQNkTJLrMoLalwmF1wy+oaSSoa3Y+eiGgVPqFYrELRs127jF0PXW
         PHpSdTl3yfp4i2KcU+Wvai/CFRxbY0DyBP39IDhRSv2GFL3qgv2RXJhzr2hDM7BU33xx
         uY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tHjWUkxRNifLcA5hnSBRCik22pJdccsL67Zae/WYwLI=;
        b=a7f0kKwT/Xi17k1bbdHn3brVuQSy//XWcUYVS8DmriqLT0gEppfeLk0fKum013j/XJ
         McCODfiMyBbkZGh+XqiVFLAR4PIYr2aCE42fbHq1b5ZFT6YeRwDoQGFvXDrKEc+H1neC
         gxesly3irGxYhIi3X8jPMpS+1sfkJzctRlHQD2Gd/r2pSUgSTi1QPZJoY9e4ABhYdtlB
         ndRCwX0Qnj1AzvNLo2iiSFK8kdA6vL1QgURaLk8XrP/yjGzAbCnys/HNUJA0Qfb7tYpu
         TxQoIUSB9p/i/u3FG2/AwqvDJoozndv66+aa1Stkj4683AWDLo59/7bZNqzCo1IKq2Qu
         mfBA==
X-Gm-Message-State: APjAAAVi8wn5k0sU0cke4Fokh5+ogpnq3R3PzlEjM3NNkHeWWX7Q2qZu
        bFItXaN4qTxpT1CRfJa4twY=
X-Google-Smtp-Source: APXvYqz70lp+h8LWE9+XgkAfXUmvfr76EepfBENzf+Tx1VFNZfA7LY08cG3j4AzzIjWkRTsOF7r+1g==
X-Received: by 2002:a17:90a:3807:: with SMTP id w7mr205812pjb.33.1572975190929;
        Tue, 05 Nov 2019 09:33:10 -0800 (PST)
Received: from localhost (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id w189sm21312420pfw.101.2019.11.05.09.33.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 Nov 2019 09:33:10 -0800 (PST)
Date:   Tue, 5 Nov 2019 18:32:50 +0100
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Subject: Re: [net-next v2 9/9] ice: allow 3k MTU for XDP
Message-ID: <20191105183250.000052bd@gmail.com>
In-Reply-To: <20191105133723.5dbe6aa0@carbon>
References: <20191104215125.16745-1-jeffrey.t.kirsher@intel.com>
        <20191104215125.16745-10-jeffrey.t.kirsher@intel.com>
        <20191105133723.5dbe6aa0@carbon>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 13:37:23 +0100
Jesper Dangaard Brouer <brouer@redhat.com> wrote:

> On Mon,  4 Nov 2019 13:51:25 -0800
> Jeff Kirsher <jeffrey.t.kirsher@intel.com> wrote:
> 
> > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > 
> > At this point ice driver is able to work on order 1 pages that are split
> > onto two 3k buffers. Let's reflect that when user is setting new MTU
> > size and XDP is present on interface.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_main.c | 16 ++++++++++++++--
> >  1 file changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > index 29eea08807fd..363b284e8aa1 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -4658,6 +4658,18 @@ static void ice_rebuild(struct ice_pf *pf, enum ice_reset_req reset_type)
> >  	dev_err(dev, "Rebuild failed, unload and reload driver\n");
> >  }
> >  
> > +/**
> > + * ice_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> > + * @vsi: Pointer to VSI structure
> > + */
> > +static int ice_max_xdp_frame_size(struct ice_vsi *vsi)
> > +{
> > +	if (PAGE_SIZE >= 8192 || test_bit(ICE_FLAG_LEGACY_RX, vsi->back->flags))
> > +		return ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;  
> 
> I've not checked the details of the ICE drivers memory model, are you
> using a split-page model?

Yes.

> 
> If so, in case of ICE_FLAG_LEGACY_RX and PAGE_SIZE==4096, then other
> Intel drivers use headroom size 192 bytes and not
> XDP_PACKET_HEADROOM=256, because it doesn't fit with split-page model.

That's not quite right.

What mostly ICE_FLAG_LEGACY_RX does is that it indicates whether we're using
build_skb() or not.

If !ICE_FLAG_LEGACY_RX && PAGE_SIZE==4096, we provide a 192 byte headroom and
320 byte tailroom dedicated for skb_shared_info in order to support the
build_skb(). We can piggy-back on that headroom for XDP purposes, which we're
currently doing in intel drivers.

Otherwise, the legacy Rx flow doesn't provide *any* headroom/tailroom, so to
satisfy the XDP headroom requirement, it needs to be explicitly taken into
account, which is what I'm trying to address in this series, see
ice_rx_offset()@[1].

Seems that i40e is not doing it and I suppose it is broken for case where XDP
prog is enlarging the frame and legacy Rx path is taken. I can later submit
small set with other two issues that came up from Jakub's review on first
revision of this set.

> 
> Asked in another way: Have you taking into account the 320 bytes needed
> by skb_shared_info ?

For legacy Rx there's no particular need for it as __napi_alloc_skb() is
handling it for us (note that legacy Rx implies ice_construct_skb() call where
we get the skb allocated via already mentioned __napi_alloc_skb() and then
memcpy the actual frame contents onto this skb).

Thanks,
Maciej

[1] :
https://lore.kernel.org/netdev/20191104215125.16745-8-jeffrey.t.kirsher@intel.com/

> 
> 
> > +	else
> > +		return ICE_RXBUF_3072;
> > +}
> > +
> >  /**
> >   * ice_change_mtu - NDO callback to change the MTU
> >   * @netdev: network interface device structure
> > @@ -4678,11 +4690,11 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
> >  	}
> >  
> >  	if (ice_is_xdp_ena_vsi(vsi)) {
> > -		int frame_size = ICE_RXBUF_2048 - XDP_PACKET_HEADROOM;
> > +		int frame_size = ice_max_xdp_frame_size(vsi);
> >  
> >  		if (new_mtu + ICE_ETH_PKT_HDR_PAD > frame_size) {
> >  			netdev_err(netdev, "max MTU for XDP usage is %d\n",
> > -				   frame_size);
> > +				   frame_size - ICE_ETH_PKT_HDR_PAD);
> >  			return -EINVAL;
> >  		}
> >  	}  
> 
> 
> 

