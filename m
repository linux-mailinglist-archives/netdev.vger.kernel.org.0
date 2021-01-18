Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B452F9B75
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 09:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbhARIp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 03:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387771AbhARIps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 03:45:48 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20C2C061573;
        Mon, 18 Jan 2021 00:45:08 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d4so8264450plh.5;
        Mon, 18 Jan 2021 00:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y3r2tP8YnX1X5B9QdeuzmBKL86ouGSFP82KEzONkD4Q=;
        b=UXXWuhof0T4ppFAL/rZBcvNQVT+4DH0ZDWF5WB8H2JOyjRAYgchDSJDVzCOn/Cjfa8
         dnpBCG8zUS4pV/NUC2qkZs1/qMOXN44W7ivPRATLpJlQ8qYpYKTbbQNBRb/AIcQBb59g
         Z3WQQMQqDuoFg8iBleJIps+uaCdxmlQFdsatpwZ3iqtz9GA4y15TU/kKcpgdttbhchOv
         yS8cGRurd1ye9VXC4dUBTrqnqedoD6NByyKDLs4MpQJriSvIXHS3UU9tlK5LHueAroCu
         7QvHmY2ImaRfrkNYMDwWEXKK3+Sw1LtDgXg3YXgpsWrze6g7ZT9PYFSVTSdDcoqvm/35
         lWIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y3r2tP8YnX1X5B9QdeuzmBKL86ouGSFP82KEzONkD4Q=;
        b=Lpcmt9KL2Dwlzg9hzDcDdqmhU4enevVmLcz9SQCBDAAYuPmpnyNcYOLDV2sa7+Iass
         18cWaQFzmTVP7qOTtwP4tpPrLCbB8hNtSfC8PZxK+43b9TwUmgEdOEubGxmyfdjiYnYU
         +1RfEvIS8E0ksuOcy18A7Mib8A0PeQ7SDTUZryLuDkWYrYqyO7+oenh4JUk3Pg0UzKqd
         0ySdHQTIv9PdYEwY+RFR2KD2tYaLiAKtAAZmXKuD2hVZwRRGY3tqz84V4ArGSfXxnvBf
         8DKYbM1Tk29pNmZNH8l7SE14AgyH45gptQvibQapPT9cnn4YFCkFoaWETmy7jYDWrf25
         PQnQ==
X-Gm-Message-State: AOAM532b36Mzlt08/isQeMcs2oRCXxNJmtWnfNzYbUwIfgzThjHJl7mK
        KQMKbbp5JIkOgxpb5nTgUIBFlrY4HqK8Xw==
X-Google-Smtp-Source: ABdhPJzafb5yib/DuNopQnGd4bVTk9fO6r/FIXzPJDT8avH6F6tnLTMqp9ySV1qB+jEPTjCFAy7Oow==
X-Received: by 2002:a17:902:b606:b029:da:c8ed:7c2e with SMTP id b6-20020a170902b606b02900dac8ed7c2emr25515112pls.5.1610959508606;
        Mon, 18 Jan 2021 00:45:08 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p15sm15478579pgl.19.2021.01.18.00.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 00:45:07 -0800 (PST)
Date:   Mon, 18 Jan 2021 16:44:55 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCHv14 bpf-next 3/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210118084455.GE1421720@Leo-laptop-t470s>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
 <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210114142321.2594697-4-liuhangbin@gmail.com>
 <6004d200d0d10_266420825@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6004d200d0d10_266420825@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

Thanks for the reviewing.

On Sun, Jan 17, 2021 at 04:10:40PM -0800, John Fastabend wrote:
> > + * 		The forwarding *map* could be either BPF_MAP_TYPE_DEVMAP or
> > + * 		BPF_MAP_TYPE_DEVMAP_HASH. But the *ex_map* must be
> > + * 		BPF_MAP_TYPE_DEVMAP_HASH to get better performance.
> 
> Would be good to add a note ex_map _must_ be keyed by ifindex for the
> helper to work. Its the obvious way to key a hashmap, but not required
> iirc.

OK, I will.
> > +		if (!next_obj)
> > +			last_one = true;
> > +
> > +		if (last_one) {
> > +			bq_enqueue(obj->dev, xdpf, dev_rx, obj->xdp_prog);
> > +			return 0;
> > +		}
> 
> Just collapse above to
> 
>   if (!next_obj) {
>         bq_enqueue()
>         return
>   }
> 
> 'last_one' is a bit pointless here.

Yes, thanks.

> > @@ -3986,12 +3993,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> >  {
> >  	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> >  	struct bpf_map *map = READ_ONCE(ri->map);
> > +	struct bpf_map *ex_map = ri->ex_map;
> 
> READ_ONCE(ri->ex_map)?
> 
> >  	u32 index = ri->tgt_index;
> >  	void *fwd = ri->tgt_value;
> >  	int err;
> >  
> >  	ri->tgt_index = 0;
> >  	ri->tgt_value = NULL;
> > +	ri->ex_map = NULL;
> 
> WRITE_ONCE(ri->ex_map)?
> 
> >  	WRITE_ONCE(ri->map, NULL);
> 
> So we needed write_once, read_once pairs for ri->map do we also need them in
> the ex_map case?

Toke said this is no need for this read/write_once as there is already one.

https://lore.kernel.org/bpf/87r1wd2bqu.fsf@toke.dk/

Thanks
Hangbin
