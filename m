Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D522D224E
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 05:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgLHEvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 23:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgLHEvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 23:51:41 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F7DC061749;
        Mon,  7 Dec 2020 20:51:01 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id i24so8352583edj.8;
        Mon, 07 Dec 2020 20:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LpBxApSP8rCkKlkJaOOFJxIK7H0arGSthSf/Abqc1f0=;
        b=VcYmqqFkZcsz7ruK90wqwWcXsd76SC0LUJJ98io9ZKofQcbxNTMBIXLdfU/iaC0MpG
         /VDzjogKNREO57usDtzHJ5gBV4zXFWKvPbBmfiunp5uKqvt31DFaAN0vY/72GVkNbbG3
         odiQjoM5lrXpeu7ExSfIl20XVCYp4/NHEqEu83rUF03bAXO7U4Y9RLIQNWMrbVzYINiY
         kOSvwzl/VpcNjHA0CYD9MlE1gTm4uvu/hxPOw6d6682gqYIS1xNgEeIrCGo5E5Rlkhqt
         CucT/2rIdbGpjmIxyJoIJPyCIgF9ij8TShnlQJc8TjPXrz/98fvgKpaPRQSwOXPFEo2w
         rCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LpBxApSP8rCkKlkJaOOFJxIK7H0arGSthSf/Abqc1f0=;
        b=EZ35Eh9aRC/0hVRdxRy2FEgylUovJ6FEzGcHS00Sverftg7nZ0Ln25vqJNJiDWNkrL
         JMDhyrsTJLjjBUgAYhXV92Ebv9WTxpG5gp11KOy/x5DDDnjT9B7S0/QH648w8uaah1lH
         M8fjqdZmGP8ned2sno7wr6Ze/Hy5NjyAJg/fuC2vkJzmpZefz1A3tgC3a6Px2v21dGCo
         iM7jUr5pj8G/lg1OzmrzaBmJHkw0qnyLgoiCoY3GfPr7xRhg1o5Kp0vJNsv1BDWPB8q9
         80zoEsz0MnnZ0q15OI6MlbH1mQMEEu8kv2qUyN29dOIkebgb1+9PviqOvZNqqsFOkDwq
         HiLg==
X-Gm-Message-State: AOAM530lF1tb/fOY6bngMZrPrPCKfFJ3R9UP48ahoDLPkmkU6bLl0ziJ
        oGCKTF0k/jWXc+F958bdCH8=
X-Google-Smtp-Source: ABdhPJwJWwskX0ehYSyo/1zgQiqkcF4qXSsR/UjOZTLyj1endimvm9CQVWDIrjMNDUJyKgV7JIh+rg==
X-Received: by 2002:a05:6402:b57:: with SMTP id bx23mr22763851edb.191.1607403060074;
        Mon, 07 Dec 2020 20:51:00 -0800 (PST)
Received: from andrea (host-95-239-64-30.retail.telecomitalia.it. [95.239.64.30])
        by smtp.gmail.com with ESMTPSA id t26sm14439420eji.22.2020.12.07.20.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 20:50:59 -0800 (PST)
Date:   Tue, 8 Dec 2020 05:50:50 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: hv: vmbus: Copy packets sent by Hyper-V out
 of the ring buffer
Message-ID: <20201208045050.GA9609@andrea>
References: <20201109100727.9207-1-parri.andrea@gmail.com>
 <MW2PR2101MB1052B7CBB14283AA066BF125D7CF1@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052B7CBB14283AA066BF125D7CF1@MW2PR2101MB1052.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -419,17 +446,52 @@ static u32 hv_pkt_iter_avail(const struct hv_ring_buffer_info *rbi)
> >  struct vmpacket_descriptor *hv_pkt_iter_first(struct vmbus_channel *channel)
> >  {
> >  	struct hv_ring_buffer_info *rbi = &channel->inbound;
> > -	struct vmpacket_descriptor *desc;
> > +	struct vmpacket_descriptor *desc, *desc_copy;
> > +	u32 bytes_avail, pkt_len, pkt_offset;
> > 
> > -	hv_debug_delay_test(channel, MESSAGE_DELAY);
> > -	if (hv_pkt_iter_avail(rbi) < sizeof(struct vmpacket_descriptor))
> > +	desc = hv_pkt_iter_first_raw(channel);
> > +	if (!desc)
> >  		return NULL;
> > 
> > -	desc = hv_get_ring_buffer(rbi) + rbi->priv_read_index;
> > -	if (desc)
> > -		prefetch((char *)desc + (desc->len8 << 3));
> > +	bytes_avail = hv_pkt_iter_avail(rbi);
> > +
> > +	/*
> > +	 * Ensure the compiler does not use references to incoming Hyper-V values (which
> > +	 * could change at any moment) when reading local variables later in the code
> > +	 */
> > +	pkt_len = READ_ONCE(desc->len8) << 3;
> > +	pkt_offset = READ_ONCE(desc->offset8) << 3;
> > +
> > +	/*
> > +	 * If pkt_len is invalid, set it to the smaller of hv_pkt_iter_avail() and
> > +	 * rbi->pkt_buffer_size
> > +	 */
> > +	if (rbi->pkt_buffer_size < bytes_avail)
> > +		bytes_avail = rbi->pkt_buffer_size;
> 
> I think the above could be combined with the earlier call to hv_pkt_iter_avail(),
> and more logically expressed as:
> 
> 	bytes_avail = min(rbi->pkt_buffer_size, hv_pkt_iter_avail(rbi));
> 
> 
> This is a minor nit.  Everything else in this patch looks good to me.

Thanks for the feedback, Michael; I'll send v3 to address it shortly.

  Andrea
