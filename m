Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C892DE088
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 10:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389016AbgLRJop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 04:44:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732789AbgLRJoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 04:44:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608284598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOXCSSkKJI7de3/xm9Rz2nHMEQCRsQTSOP3r0Paa/+c=;
        b=S07eP9i3wBSuuOZtvUsLW7x+oC9/kIRX6iihl2a3T8UmJXhDlKbNhuz5OejnDpAfvS7IQ3
        40IiXuQTwZZnRM07uGNw0VZCLWmO0mNj3myNjffR/jvUjem5AXBql4ZLsQHrktWNMVfqnZ
        fW/ThdPFQsOTSLi0wXcqvFW93mUPiu4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-k3eSJOEUPZq3rlDiB-TSAw-1; Fri, 18 Dec 2020 04:43:16 -0500
X-MC-Unique: k3eSJOEUPZq3rlDiB-TSAw-1
Received: by mail-pg1-f199.google.com with SMTP id 26so1307026pgl.2
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 01:43:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UOXCSSkKJI7de3/xm9Rz2nHMEQCRsQTSOP3r0Paa/+c=;
        b=QAWpFHaWH/9TmRNwwRJW3VsPcNMhTIHZ7SndkgeofWtiTVW9xYLq65EuxMsMoq2z5P
         P8xg7Vyk6FGcSwINNh9f1bS7iwrN7y/R89mctRs/gywXsSEXSDLPFha1bCliupl5nLwz
         AXJGOilcfsKB0dFwZNDrIye51q8nbloQq/HQyQcWJ9t4eH3sOFWlPAfMUAXJPRiEjICX
         qFQiDd2vAlmAuVWSaSHUmegYnd1BM3WWOVyGdUZ9ftRKh2sd2ITTUmWVCt+XkCChrXLX
         jGf03EJB2+2W6sRyrmCIw94egvnQ1F5FbRMjTw6Y+bWx4o7/cT8hMX2q60EymcTSQ6J0
         GWFQ==
X-Gm-Message-State: AOAM530UQjw5emR4PoiiDbMhasz8pHHbaH0H/QI3Lz3rfZmydsEzbK4K
        mI5xJ1s1uB4CxAFJ37fHUmO0MPrn+Hxmp8bkf7Ol94UWjS2cODbjjSJoWNuIe1UqIV+RG1dcAVx
        wbm7giU8qu1q3UmU=
X-Received: by 2002:a65:5c48:: with SMTP id v8mr3412668pgr.400.1608284595375;
        Fri, 18 Dec 2020 01:43:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyq3MAws4R4Zj4PouAry84JQThg/XDNcfDsfwHUHJWQyW+lVordcg66phsuFMiIN9DmeMif0A==
X-Received: by 2002:a65:5c48:: with SMTP id v8mr3412644pgr.400.1608284595155;
        Fri, 18 Dec 2020 01:43:15 -0800 (PST)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s29sm8854119pgn.65.2020.12.18.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 01:43:14 -0800 (PST)
Date:   Fri, 18 Dec 2020 17:43:02 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCHv12 bpf-next 1/6] bpf: run devmap xdp_prog on flush
 instead of bulk enqueue
Message-ID: <20201218094302.GN273186@localhost.localdomain>
References: <20200907082724.1721685-1-liuhangbin@gmail.com>
 <20201216143036.2296568-1-liuhangbin@gmail.com>
 <20201216143036.2296568-2-liuhangbin@gmail.com>
 <913a8e62-3f17-84ed-e4f5-099ba441508c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <913a8e62-3f17-84ed-e4f5-099ba441508c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Thanks for the comment.

On Thu, Dec 17, 2020 at 09:07:03AM -0700, David Ahern wrote:
> > +	return n - nframes; /* dropped frames count */
> 
> just return nframes here, since ...
> 
> > +		xdp_drop = dev_map_bpf_prog_run(bq->xdp_prog, bq->q, cnt, dev);
> > +		cnt -= xdp_drop;
> 
> ... that is apparently what you really want.

I will fix this

> > +	if (dst && dst->xdp_prog && !bq->xdp_prog)
> > +		bq->xdp_prog = dst->xdp_prog;
> 
> 
> if you pass in xdp_prog through __xdp_enqueue you can reduce that to just:
> 
> 	if (!bq->xdp_prog)
> 		bq->xdp_prog = xdp_prog;

And this in the next PATCH version.

Thanks
Hangbin

