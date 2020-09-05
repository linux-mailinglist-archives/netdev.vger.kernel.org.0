Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE7525E84E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 16:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgIEOPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 10:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728585AbgIEOPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 10:15:12 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7766C061244;
        Sat,  5 Sep 2020 07:15:11 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f142so9074380qke.13;
        Sat, 05 Sep 2020 07:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xrOzHn7owdx7Uqk54xwEOBwQTc/5Zou/9tg+v3Sm5mM=;
        b=My+gzL1dtCDjCYwsGT/4wS8pFAtxO3R60DrrBWntr1/NSvAgMoNCo0Xuatox/F4lkR
         1iB7IHmjqtvhqCKwvGzkuC9K0wHUlLe0DqK9xeMhInyAzYLtDhauNPT9hAi0HpwAfk/g
         Hw4KscWqZExiJr9gZVgssgm/P7ebgoWeqCZ6SXMmlR1FqfxEGeBjlUR2eS25GA+0tmDY
         DRGkK0Hzf7Kqf+vl/rwWN8/TwixQnyXV17Deq0oQU7Z9lKc3MyQtQM9hYWyydyWRGJ2d
         G9M5gW1ZSOopaSMlZcaDCK/FRUf+4EAOIrp+R9GgU9Ip+nPMl1/bc9TDLad7rc1Gyr/o
         ztKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xrOzHn7owdx7Uqk54xwEOBwQTc/5Zou/9tg+v3Sm5mM=;
        b=AIzda0G8AJwVndPMdX265TCO3eUGzrAkPzgSmfQCoeP48++zzdgA0sfmkEk8Qw9zQb
         XXIz+AGVrhAnDjNtoNtP4EOE4xPBvt9Wxf6DzskxXWTlsgHGgud0ee+dmRBtWOqo6/VM
         Urc75fTysK8SHdm5IKl2+wQ+tYOsiqFaO5qpgnDcKaMONSJHmLdczfdeL7NaDjy/35YC
         m4Lddomn2YN16ykp0anBGtcwRDPOlrfioEJANc2wOjiKnKECxkH4CqD/sn8CG+4Lt5Gm
         iUYjjLare++CY/S0hd3HnyYiw/vlHy3LJuB+SsUNNHU3i9YpsEeBve7WXUYtuxwdLSq4
         +SEA==
X-Gm-Message-State: AOAM530/DGZLxbXaBrlSp6wD3Ny3POm2wyouqHAhrrxCD/h2M8YT7oUn
        OSRavKHOHgKq+j7iij/yUq4=
X-Google-Smtp-Source: ABdhPJwfsxdbs3JPOHiHC4r6Z4olxcV3GzGLqJuHQ1rPyT7rdVeDcxNhdvzqkxj9kuS616KSDYqEnA==
X-Received: by 2002:a37:aa4d:: with SMTP id t74mr1366942qke.222.1599315308727;
        Sat, 05 Sep 2020 07:15:08 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id z29sm7090588qtj.79.2020.09.05.07.15.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Sep 2020 07:15:07 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id F09E827C0054;
        Sat,  5 Sep 2020 10:15:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 05 Sep 2020 10:15:05 -0400
X-ME-Sender: <xms:aZ1TX5PYNMtj8B87J-MXKNFXhjboT9twHSY1T92lrKXEbEWBxmszTg>
    <xme:aZ1TX79kjmkP3zWDBMSXYz6eKVtG2fxzy6GeZHqh1pVaMPr70xALNZjiv9HVZBJK0
    tL1pUY994xUSXr6AQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeghedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepvdelieegudfggeevjefhjeevueevieetjeeikedvgfejfeduheefhffggedv
    geejnecukfhppeehvddrudehhedrudduuddrjedunecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfh
    gvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:aZ1TX4TXmFnUSA7XBjjsVJ9HBrVLzCN4a3UExPk-788jSExZlt5xeA>
    <xmx:aZ1TX1vHR-LhMYqw_oyolzs8nGiSc3JCc1x5XbFmnHKma2GCJYTA-A>
    <xmx:aZ1TXxdo08OU905OUlSyK4Qt7qWxgKImZHDwbAPKi6CNCfPK7KCvAA>
    <xmx:aZ1TXx9l944jXfjKKNgGKgQLvWQOOLWTgIxT0Qh6aOXe0Gn4KAe4KNDZ0Z0>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id C602C3280059;
        Sat,  5 Sep 2020 10:15:04 -0400 (EDT)
Date:   Sat, 5 Sep 2020 22:15:03 +0800
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
Subject: Re: [RFC v2 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Message-ID: <20200905141503.GD7503@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-12-boqun.feng@gmail.com>
 <MW2PR2101MB10523D98F77D5A80468A07CDD72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10523D98F77D5A80468A07CDD72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 02:55:48AM +0000, Michael Kelley wrote:
> From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 1, 2020 8:01 PM
> > 
> > Hyper-V always use 4k page size (HV_HYP_PAGE_SIZE), so when
> > communicating with Hyper-V, a guest should always use HV_HYP_PAGE_SIZE
> > as the unit for page related data. For storvsc, the data is
> > vmbus_packet_mpb_array. And since in scsi_cmnd, sglist of pages (in unit
> > of PAGE_SIZE) is used, we need convert pages in the sglist of scsi_cmnd
> > into Hyper-V pages in vmbus_packet_mpb_array.
> > 
> > This patch does the conversion by dividing pages in sglist into Hyper-V
> > pages, offset and indexes in vmbus_packet_mpb_array are recalculated
> > accordingly.
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >  drivers/scsi/storvsc_drv.c | 60 ++++++++++++++++++++++++++++++++++----
> >  1 file changed, 54 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index 8f5f5dc863a4..3f6610717d4e 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1739,23 +1739,71 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct
> > scsi_cmnd *scmnd)
> >  	payload_sz = sizeof(cmd_request->mpb);
> > 
> >  	if (sg_count) {
> > -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> > +		unsigned int hvpg_idx = 0;
> > +		unsigned int j = 0;
> > +		unsigned long hvpg_offset = sgl->offset & ~HV_HYP_PAGE_MASK;
> > +		unsigned int hvpg_count = HVPFN_UP(hvpg_offset + length);
> > 
> > -			payload_sz = (sg_count * sizeof(u64) +
> > +		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
> > +
> > +			payload_sz = (hvpg_count * sizeof(u64) +
> >  				      sizeof(struct vmbus_packet_mpb_array));
> >  			payload = kzalloc(payload_sz, GFP_ATOMIC);
> >  			if (!payload)
> >  				return SCSI_MLQUEUE_DEVICE_BUSY;
> >  		}
> > 
> > +		/*
> > +		 * sgl is a list of PAGEs, and payload->range.pfn_array
> > +		 * expects the page number in the unit of HV_HYP_PAGE_SIZE (the
> > +		 * page size that Hyper-V uses, so here we need to divide PAGEs
> > +		 * into HV_HYP_PAGE in case that PAGE_SIZE > HV_HYP_PAGE_SIZE.
> > +		 */
> >  		payload->range.len = length;
> > -		payload->range.offset = sgl[0].offset;
> > +		payload->range.offset = sgl[0].offset & ~HV_HYP_PAGE_MASK;
> > +		hvpg_idx = sgl[0].offset >> HV_HYP_PAGE_SHIFT;
> > 
> >  		cur_sgl = sgl;
> > -		for (i = 0; i < sg_count; i++) {
> > -			payload->range.pfn_array[i] =
> > -				page_to_pfn(sg_page((cur_sgl)));
> > +		for (i = 0, j = 0; i < sg_count; i++) {
> > +			/*
> > +			 * "PAGE_SIZE / HV_HYP_PAGE_SIZE - hvpg_idx" is the #
> > +			 * of HV_HYP_PAGEs in the current PAGE.
> > +			 *
> > +			 * "hvpg_count - j" is the # of unhandled HV_HYP_PAGEs.
> > +			 *
> > +			 * As shown in the following, the minimal of both is
> > +			 * the # of HV_HYP_PAGEs, we need to handle in this
> > +			 * PAGE.
> > +			 *
> > +			 * |------------------ PAGE ----------------------|
> > +			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
> > +			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
> > +			 *           ^                     ^
> > +			 *         hvpg_idx                |
> > +			 *           ^                     |
> > +			 *           +---(hvpg_count - j)--+
> > +			 *
> > +			 * or
> > +			 *
> > +			 * |------------------ PAGE ----------------------|
> > +			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
> > +			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
> > +			 *           ^                                           ^
> > +			 *         hvpg_idx                                      |
> > +			 *           ^                                           |
> > +			 *           +---(hvpg_count - j)------------------------+
> > +			 */
> > +			unsigned int nr_hvpg = min((unsigned int)(PAGE_SIZE / HV_HYP_PAGE_SIZE) - hvpg_idx,
> > +						   hvpg_count - j);
> > +			unsigned int k;
> > +
> > +			for (k = 0; k < nr_hvpg; k++) {
> > +				payload->range.pfn_array[j] =
> > +					page_to_hvpfn(sg_page((cur_sgl))) + hvpg_idx + k;
> > +				j++;
> > +			}
> >  			cur_sgl = sg_next(cur_sgl);
> > +			hvpg_idx = 0;
> >  		}
> 
> This code works; I don't see any errors.  But I think it can be made simpler based
> on doing two things:
> 1)  Rather than iterating over the sg_count, and having to calculate nr_hvpg on
> each iteration, base the exit decision on having filled up the pfn_array[].  You've
> already calculated the exact size of the array that is needed given the data
> length, so it's easy to exit when the array is full.
> 2) In the inner loop, iterate from hvpg_idx to PAGE_SIZE/HV_HYP_PAGE_SIZE
> rather than from 0 to a calculated value.
> 
> Also, as an optimization, pull page_to_hvpfn(sg_page((cur_sgl)) out of the
> inner loop.
> 
> I think this code does it (though I haven't tested it):
> 
>                 for (j = 0; ; sgl = sg_next(sgl)) {
>                         unsigned int k;
>                         unsigned long pfn;
> 
>                         pfn = page_to_hvpfn(sg_page(sgl));
>                         for (k = hvpg_idx; k < (unsigned int)(PAGE_SIZE /HV_HYP_PAGE_SIZE); k++) {
>                                 payload->range.pfn_array[j] = pfn + k;
>                                 if (++j == hvpg_count)
>                                         goto done;
>                         }
>                         hvpg_idx = 0;
>                 }
> done:
> 
> This approach also makes the limit of the inner loop a constant, and that
> constant will be 1 when page size is 4K.  So the compiler should be able to
> optimize away the loop in that case.
> 

Good point! I like your suggestion, and after thinking a bit harder
based on your approach, I come up with the following:

#define HV_HYP_PAGES_IN_PAGE ((unsigned int)(PAGE_SIZE / HV_HYP_PAGE_SIZE))

		for (j = 0; j < hvpg_count; j++) {
			unsigned int k = (j + hvpg_idx) % HV_HYP_PAGES_IN_PAGE;

			/*
			 * Two cases that we need to fetch a page:
			 * a) j == 0: the first step or
			 * b) k == 0: when we reach the boundary of a
			 * page.
			 * 
			if (k == 0 || j == 0) {
				pfn = page_to_hvpfn(sg_page(cur_sgl));
				cur_sgl = sg_next(cur_sgl);
			}

			payload->range.pfn_arrary[j] = pfn + k;
		}

, given the HV_HYP_PAGES_IN_PAGE is always a power of 2, so I think
compilers could easily optimize the "%" into bit masking operation. And
when HV_HYP_PAGES_IN_PAGE is 1, I think compilers can easily figure out
k is always zero, then the if-statement can be optimized as always
taken. And that gives us the same code as before ;-)

Thoughts? I will try with a test to see if I'm missing something subtle.

Thanks for looking into this!

Regards,
Boqun


> Michael
> 
> 
> 
> 
> 
> 
> >  	}
> > 
> > --
> > 2.28.0
> 
