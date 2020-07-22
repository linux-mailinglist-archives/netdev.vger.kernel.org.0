Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B096722A33C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 01:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733124AbgGVXn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 19:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGVXn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 19:43:26 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C788C0619DC;
        Wed, 22 Jul 2020 16:43:26 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h17so1859318qvr.0;
        Wed, 22 Jul 2020 16:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l2HmVTWQFrIyLYEF4wtnm+j+dX6dmQDOMb0wFULihaY=;
        b=Roh2VRSQqjg3YvlHRwXYWPTStlTwk4zQWTNPrBykssmo2LuF3KWzn799ESJ8by8rvn
         ZdaLxmoRLr6AP5cXIl3Mm/P/lyGxmlZ2ysanTvmyx+z6tnI50aq98BhTu3+T7IQpmHiM
         d9mHOjodbqhmm/dZrcsgACpleooAB3RLzI9Tz4OddNe2+cOE1VjTpkkmw5MlK0UlSL6P
         RBbS1NvUZYZAze4ctI1cq3JjqRzB8TPoWvtoRxdYj2G6NuWJ03eraunKbc54BQUe6OEe
         6ilAsnLYEhVCFZRYL289q5knpRrRXFRoAriXAsE2nDWUg8Bgy8hZ502KpzkD/YFbFT+T
         ognQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l2HmVTWQFrIyLYEF4wtnm+j+dX6dmQDOMb0wFULihaY=;
        b=V+C794BJYrApci8hQIr7P5E6Hk+brtwCbXtlG8hbROKJ3R2zRw1SzAhFhW1HQDrFPm
         egkeutTYUc0GbaXnPCMwcgIQ1MZDsSdKz1FpN2MHTXPdP4MXZ4vdgVW/XquEIfhfR5eW
         arj28/3vIpBlVxRGo6GXGtPVBnEkTfXigapcPNmvaT9QmXLai0zvGHwYLAd2RzoFJLCb
         zen99BAohvQ63GB/Wg2hcKik8vXxdPrJO8f+L5o6A+/TekOqg00IjFhzTa4MVjJHWWSz
         coWa9U4clgj2eAh4Ni5RIeW38D9PZjEtSCRdaZz6tft/tSNhiBsA6Zvja7yu5L5UGVtU
         vxag==
X-Gm-Message-State: AOAM531XI4vVtig+Ln2pGQVrjB+rn26TVnrogGXkRT1huubjU7gDqJC1
        pX7KUKk3A3IDQD4XT4axLWU=
X-Google-Smtp-Source: ABdhPJy1f6boTE7FhwbHIyGPT+niBuJDADUvSj79UA7pGCTwufgaEZ8jshAaBRnnUAY0FYxrJoMy7g==
X-Received: by 2002:ad4:4105:: with SMTP id i5mr2375780qvp.170.1595461405233;
        Wed, 22 Jul 2020 16:43:25 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id n127sm1254128qke.29.2020.07.22.16.43.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 16:43:24 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 3254827C0054;
        Wed, 22 Jul 2020 19:43:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 22 Jul 2020 19:43:24 -0400
X-ME-Sender: <xms:G88YX6agW9mvoM2HasZTNFTyWyvJ65ka30j4rTxNI6j8j_x0BEBo5g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrhedtgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpedvleeigedugfegveejhfejveeuveeiteejieekvdfgjeefudehfefhgfegvdeg
    jeenucfkphephedvrdduheehrdduuddurdejudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvg
    hngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:G88YX9amVjMuo2L7hp5gmXUqAfcA0ObM4Cibhawg6jWZzc-Cb3T84Q>
    <xmx:G88YX0-lcQ5iokj1nfQGLu9xhJpeSfXSH5BwipWQ2S01ZCIpd0dIng>
    <xmx:G88YX8rIn2zD1Fq8g14ZL5BPVUQ7m7Xxcy1_iCiRko6eGWzCMc8-Jg>
    <xmx:HM8YXwDJ9MIK2Q9kuXGp7LoQm_ULlPgCG9hQ89kcmzuYn7lv2nC3VQ4-grQ>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 31E1C328005A;
        Wed, 22 Jul 2020 19:43:23 -0400 (EDT)
Date:   Thu, 23 Jul 2020 07:43:21 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Message-ID: <20200722234321.GC35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-4-boqun.feng@gmail.com>
 <MW2PR2101MB1052E3D15D411A5DC62A60F2D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052E3D15D411A5DC62A60F2D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:25:18PM +0000, Michael Kelley wrote:
> From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:41 PM
> > 
> > This patch introduces two types of GPADL: HV_GPADL_{BUFFER, RING}. The
> > types of GPADL are purely the concept in the guest, IOW the hypervisor
> > treat them as the same.
> > 
> > The reason of introducing the types of GPADL is to support guests whose
> > page size is not 4k (the page size of Hyper-V hypervisor). In these
> > guests, both the headers and the data parts of the ringbuffers need to
> > be aligned to the PAGE_SIZE, because 1) some of the ringbuffers will be
> > mapped into userspace and 2) we use "double mapping" mechanism to
> > support fast wrap-around, and "double mapping" relies on ringbuffers
> > being page-aligned. However, the Hyper-V hypervisor only uses 4k
> > (HV_HYP_PAGE_SIZE) headers. Our solution to this is that we always make
> > the headers of ringbuffers take one guest page and when GPADL is
> > established between the guest and hypervisor, the only first 4k of
> > header is used. To handle this special case, we need the types of GPADL
> > to differ different guest memory usage for GPADL.
> > 
> > Type enum is introduced along with several general interfaces to
> > describe the differences between normal buffer GPADL and ringbuffer
> > GPADL.
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >  drivers/hv/channel.c   | 140 +++++++++++++++++++++++++++++++++++------
> >  include/linux/hyperv.h |  44 ++++++++++++-
> >  2 files changed, 164 insertions(+), 20 deletions(-)
> 
> [snip]
> 
> > 
> > 
> > @@ -437,7 +528,17 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
> >  	open_msg->openid = newchannel->offermsg.child_relid;
> >  	open_msg->child_relid = newchannel->offermsg.child_relid;
> >  	open_msg->ringbuffer_gpadlhandle = newchannel->ringbuffer_gpadlhandle;
> > -	open_msg->downstream_ringbuffer_pageoffset = newchannel-
> > >ringbuffer_send_offset;
> > +	/*
> > +	 * The unit of ->downstream_ringbuffer_pageoffset is HV_HYP_PAGE and
> > +	 * the unit of ->ringbuffer_send_offset is PAGE, so here we first
> > +	 * calculate it into bytes and then convert into HV_HYP_PAGE. Also
> > +	 * ->ringbuffer_send_offset is the offset in guest, while
> > +	 * ->downstream_ringbuffer_pageoffset is the offset in gpadl (i.e. in
> > +	 * hypervisor), so a (PAGE_SIZE - HV_HYP_PAGE_SIZE) gap need to be
> > +	 * skipped.
> > +	 */
> > +	open_msg->downstream_ringbuffer_pageoffset =
> > +		((newchannel->ringbuffer_send_offset << PAGE_SHIFT) - (PAGE_SIZE -
> > HV_HYP_PAGE_SIZE)) >> HV_HYP_PAGE_SHIFT;
> 
> I couldn't find that the "downstream_ringbuffer_pageoffset" field
> is used anywhere.  Can it just be deleted entirely instead of having
> this really messy calculation?
> 

This field is part of struct vmbus_channel_open_channel, which means
guest-hypervisor communication protocal requires us to set the field,
IIUC. So I don't think we can delete it.

To deal with the messy calculation, I do realize there is a similar
calculation in hv_gpadl_hvpfn() too, so in the next version, I will
add a new helper to do this "send offset in guest virtual address to
send offset in GPADL calculation", and use it here and in
hv_gpadl_hvpfn(). Thoughts?

> >  	open_msg->target_vp = newchannel->target_vp;
> > 
> >  	if (userdatalen)
> > @@ -497,6 +598,7 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
> >  	return err;
> >  }
> > 
> > +
> 
> Spurious add of a blank line?
> 

Yeah, I will fix this, thanks!

Regards,
Boqun

> >  /*
> >   * vmbus_connect_ring - Open the channel but reuse ring buffer
> >   */
> > diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> > index 692c89ccf5df..663f0a016237 100644
> > --- a/include/linux/hyperv.h
> > +++ b/include/linux/hyperv.h
> > @@ -29,6 +29,48 @@
> > 
> >  #pragma pack(push, 1)
> > 
> > +/*
> > + * Types for GPADL, decides is how GPADL header is created.
> > + *
> > + * It doesn't make much difference between BUFFER and RING if PAGE_SIZE is the
> > + * same as HV_HYP_PAGE_SIZE.
> > + *
> > + * If PAGE_SIZE is bigger than HV_HYP_PAGE_SIZE, the headers of ring buffers
> > + * will be of PAGE_SIZE, however, only the first HV_HYP_PAGE will be put
> > + * into gpadl, therefore the number for HV_HYP_PAGE and the indexes of each
> > + * HV_HYP_PAGE will be different between different types of GPADL, for example
> > + * if PAGE_SIZE is 64K:
> > + *
> > + * BUFFER:
> > + *
> > + * gva:    |--       64k      --|--       64k      --| ... |
> > + * gpa:    | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k |
> > + * index:  0    1    2     15   16   17   18 .. 31   32 ...
> > + *         |    |    ...   |    |    |   ...    |   ...
> > + *         v    V          V    V    V          V
> > + * gpadl:  | 4k | 4k | ... | 4k | 4k | 4k | ... | 4k | ... |
> > + * index:  0    1    2 ... 15   16   17   18 .. 31   32 ...
> > + *
> > + * RING:
> > + *
> > + *         | header  |           data           | header  |     data      |
> > + * gva:    |-- 64k --|--       64k      --| ... |-- 64k --|-- 64k --| ... |
> > + * gpa:    | 4k | .. | 4k | 4k | ... | 4k | ... | 4k | .. | 4k | .. | ... |
> > + * index:  0    1    16   17   18    31   ...   n   n+1  n+16 ...         2n
> > + *         |         /    /          /          |         /               /
> > + *         |        /    /          /           |        /               /
> > + *         |       /    /   ...    /    ...     |       /      ...      /
> > + *         |      /    /          /             |      /               /
> > + *         |     /    /          /              |     /               /
> > + *         V    V    V          V               V    V               v
> > + * gpadl:  | 4k | 4k |   ...    |    ...        | 4k | 4k |  ...     |
> > + * index:  0    1    2   ...    16   ...       n-15 n-14 n-13  ...  2n-30
> > + */
> > +enum hv_gpadl_type {
> > +	HV_GPADL_BUFFER,
> > +	HV_GPADL_RING
> > +};
> > +
> >  /* Single-page buffer */
> >  struct hv_page_buffer {
> >  	u32 len;
> > @@ -111,7 +153,7 @@ struct hv_ring_buffer {
> >  	} feature_bits;
> > 
> >  	/* Pad it to PAGE_SIZE so that data starts on page boundary */
> > -	u8	reserved2[4028];
> > +	u8	reserved2[PAGE_SIZE - 68];
> > 
> >  	/*
> >  	 * Ring data starts here + RingDataStartOffset
> > --
> > 2.27.0
> 
