Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE9621C11A
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 02:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgGKAVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 20:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgGKAVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 20:21:39 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403F2C08C5DC;
        Fri, 10 Jul 2020 17:21:39 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u185so3247652pfu.1;
        Fri, 10 Jul 2020 17:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jvJKiho3sN1lnYzc7c4qQg4mlV+detjlY6xsld+liCg=;
        b=DEWznsanFHETGzu+Cc7Rziu7HuSUi8alk2C6R9eLxW0ri9a20XKDFjn2/Ud8/F7sUr
         QDVJNl4s0+0gH4A9rQt2JCjx1VDPyFrQ7VrbLT3ftfnlFndqAkuqJcZAqCDr1Tn18H7L
         Q0XqmSllx8I+b2FgOQYx354m2IbfO1l5oqE0NjqdN+RL5dIG470aEnjO39sxEWSgSylT
         QGqsRi5mTaRsm4trTCMtZ4L2L+mUIUoVVBJGiaAYuiqE2lgElJd39npRKu4tkAGewQb8
         swBtmGof4jwc2RIkfFQllRrQmPW5Olw2VRks+E7KqwwNV8sCAt/HBgWQkSi9jUAZI4YP
         NOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jvJKiho3sN1lnYzc7c4qQg4mlV+detjlY6xsld+liCg=;
        b=aDipWDoI/6vfIfi9sxV1WalaYIg3SyAapaUWS/lTLvawZaFUiGaFTXPmnMmXyswHZk
         c0CM88CsoMd5/OGo2htSPlZ7D6L6ZDanxK00cVEFCUhQsADMrAybyXTA6MqsP8Gacl+1
         62ItyslY/ypj9S1Q4UlQIV4x+UhesGc1J5HhLN1On5TjSfIkpIKg/hDepg2B8M0O4LFq
         M0utuyaUpn6D/5l5cGvihLKdyqN/+8zN2rEGrIJA4aBJXyKY7g+iOo4lCr9KXDgNPW/k
         6reKVliGHNG9SYJBBj4Cc7DUISzk7FzJ6EBxMBra1oH2rDUL5en3Y097t4LDZEYxoJKD
         IRnA==
X-Gm-Message-State: AOAM531iHgKE+GkCyDkM85S/Rv46yMb1/mS4ZwLnEhPoD775ydLXOV5t
        rLaFd+Ip5sG0+esnfQyIl2XUrupT8rKu1A==
X-Google-Smtp-Source: ABdhPJzi3E5StPVi0VDPlqmknStEacVe/S5hlPZFX0f32TggtepUalwenlniKuvDj8Cst14++m24cQ==
X-Received: by 2002:a63:5623:: with SMTP id k35mr63995663pgb.325.1594426898785;
        Fri, 10 Jul 2020 17:21:38 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i23sm7371910pfq.206.2020.07.10.17.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 17:21:38 -0700 (PDT)
Date:   Sat, 11 Jul 2020 08:21:27 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCHv6 bpf-next 2/3] sample/bpf: add
 xdp_redirect_map_multicast test
Message-ID: <20200711002127.GD2531@dhcp-12-153.nay.redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-3-liuhangbin@gmail.com>
 <6170ec86-9cce-a5ec-bd14-7aa56cee951e@iogearbox.net>
 <20200710064145.GA2531@dhcp-12-153.nay.redhat.com>
 <f244bae1-25a8-58f7-9368-70c765ea5aae@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f244bae1-25a8-58f7-9368-70c765ea5aae@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 04:32:35PM +0200, Daniel Borkmann wrote:
> On 7/10/20 8:41 AM, Hangbin Liu wrote:
> > On Fri, Jul 10, 2020 at 12:40:11AM +0200, Daniel Borkmann wrote:
> > > > +SEC("xdp_redirect_map_multi")
> > > > +int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
> > > > +{
> > > > +	long *value;
> > > > +	u32 key = 0;
> > > > +
> > > > +	/* count packet in global counter */
> > > > +	value = bpf_map_lookup_elem(&rxcnt, &key);
> > > > +	if (value)
> > > > +		*value += 1;
> > > > +
> > > > +	return bpf_redirect_map_multi(&forward_map, &null_map,
> > > > +				      BPF_F_EXCLUDE_INGRESS);
> > > 
> > > Why not extending to allow use-case like ...
> > > 
> > >    return bpf_redirect_map_multi(&fwd_map, NULL, BPF_F_EXCLUDE_INGRESS);
> > > 
> > > ... instead of requiring a dummy/'null' map?
> > 
> > I planed to let user set NULL, but the arg2_type is ARG_CONST_MAP_PTR, which
> > not allow NULL pointer.
> 
> Right, but then why not adding a new type ARG_CONST_MAP_PTR_OR_NULL ?

Yes, that's what I plan for next step.

Thanks
Hangbin
