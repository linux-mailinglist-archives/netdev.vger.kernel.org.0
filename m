Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAB1502E38
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 19:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbiDORIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 13:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356101AbiDORIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 13:08:01 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF4A84EFD;
        Fri, 15 Apr 2022 10:05:32 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id g20so10524400edw.6;
        Fri, 15 Apr 2022 10:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tPz8jhLel5NCB/c+wgUxB3HxNS9jpiNK/WGqp6Lz5oE=;
        b=bmzvRoxXUYN08ImLI8GChiltnBZ++UpOwMCJABu0q9+yZCFc6P3KmJ+eCUxf3GUNTz
         JmCY41h0LXy/oh3PT2JmAfv+662KfBG6RdJqoAA59mbedZm/Bw/zjBJvPOs8drW6CfXh
         8hGFU2cKLx9xQlfYDUlA98Huv0jMJTUicz33uiImtlh3l31R1KL1TC9/W1gbhw4+GXCl
         WLBQzr69B3R3z2gz2UtPVSWgIr3g6auVvg7E9jAXa5vG3Bm8wUjgXWr6LMT9epg91v4d
         8UmzLTu0bcUX0GQS6oOKvRmauc4kFRpClp3vivZyMZIWnmaFdU7K+B9Fn9PbR1ny/lVx
         e0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tPz8jhLel5NCB/c+wgUxB3HxNS9jpiNK/WGqp6Lz5oE=;
        b=nXLXG9fpHM347tttGn+gbdC+D5tKOGRfWryt0BsUCzCveNBA0H88OgxDdHqVHvTSje
         vMVJRn3an/JJfSUtUwigV6R2yvNGvbk6zORqI3Ukvul0Q+aOwGDBruZr1eD6BqFFXa1l
         /c6zVkD4u5bDUzAHtR7HrLjyQ5R0dtDlxpItmGFqULoJktFaD928STlerivVdSyzR36K
         xr+7rhdzfndwfBKXFo3TR3QSTcCJEEjZVd9a5V+7hOkfipwNbS3hmYCd+4Tn2tFphV61
         RpOtR4irR944Ew3pDwEr3Pfha3/XyIuI/4tcx/IShKEDePsFfNmDVvt5WZKsHNXvzzgf
         WpcA==
X-Gm-Message-State: AOAM533HztuxpYNl1pCtIrmkVUu6RbI0Zi2KOxu35r4irJ98HPYHeVBS
        K/kR3kfY6Lke4O6XTKAz1KE=
X-Google-Smtp-Source: ABdhPJxSQFT54MjAvSnz6QJUYmMr6+4q4fWd+q3ggPokB7m4jqJCd2gNdAzt7nGClmnxKUX3+u1uLQ==
X-Received: by 2002:a05:6402:14b:b0:418:d06e:5d38 with SMTP id s11-20020a056402014b00b00418d06e5d38mr211943edu.90.1650042331209;
        Fri, 15 Apr 2022 10:05:31 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id ee17-20020a056402291100b0041fe1e4e342sm2842777edb.27.2022.04.15.10.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 10:05:30 -0700 (PDT)
Date:   Fri, 15 Apr 2022 19:05:23 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 6/6] Drivers: hv: vmbus: Refactor the ring-buffer
 iterator functions
Message-ID: <20220415170523.GB97823@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-7-parri.andrea@gmail.com>
 <PH0PR21MB302516C5334076716966B7EED7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
 <20220415070031.GE2961@anparri>
 <20220415162811.GA47513@anparri>
 <PH0PR21MB3025ECBC7D7102B539A7705AD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB3025ECBC7D7102B539A7705AD7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 04:44:50PM +0000, Michael Kelley (LINUX) wrote:
> From: Andrea Parri <parri.andrea@gmail.com> Sent: Friday, April 15, 2022 9:28 AM
> > 
> > On Fri, Apr 15, 2022 at 09:00:31AM +0200, Andrea Parri wrote:
> > > > > @@ -470,7 +471,6 @@ struct vmpacket_descriptor *hv_pkt_iter_first_raw(struct
> > > > > vmbus_channel *channel)
> > > > >
> > > > >  	return (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi-
> > > > > >priv_read_index);
> > > > >  }
> > > > > -EXPORT_SYMBOL_GPL(hv_pkt_iter_first_raw);
> > > >
> > > > Does hv_pkt_iter_first_raw() need to be retained at all as a
> > > > separate function?  I think after these changes, the only caller
> > > > is hv_pkt_iter_first(), in which case the code could just go
> > > > inline in hv_pkt_iter_first().  Doing that combining would
> > > > also allow the elimination of the duplicate call to
> > > > hv_pkt_iter_avail().
> > 
> > Back to this, can you clarify what you mean by "the elimination of..."?
> > After moving the function "inline", hv_pkt_iter_avail() would be called
> > in to check for a non-NULL descriptor (in the inline function) and later
> > in the computation of bytes_avail.
> 
> I was thinking something like this:
> 
> bytes_avail = hv_pkt_iter_avail(rbi);
> if (bytes_avail < sizeof(struct vmpacket_descriptor))
> 	return NULL;
> bytes_avail = min(rbi->pkt_buffer_size, bytes_avail);
> 
> desc = (struct vmpacket_descriptor *)(hv_get_ring_buffer(rbi) + rbi->priv_read_index);

Thanks for the clarification, I've applied it.

  Andrea


> And for that matter, hv_pkt_iter_avail() is now only called in one place.
> It's a judgment call whether to keep it as a separate helper function vs.
> inlining it in hv_pkt_iter_first() as well.  I'm OK either way.
> 
> 
> Michael
> 
> 
