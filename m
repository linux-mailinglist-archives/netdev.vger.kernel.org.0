Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B03369E4F
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 03:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236006AbhDXBKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 21:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhDXBKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 21:10:19 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BC4C061574;
        Fri, 23 Apr 2021 18:09:39 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id d10so36304190pgf.12;
        Fri, 23 Apr 2021 18:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Yak3dR9rFGELmftcVHe45byG+0N11NxkW2kkiG+MQlI=;
        b=obkUphGat2g/r/pUPizEP55m32qvBUjgdN3gZYQBMVOK24k23W3uT9m8btTzMmRkEZ
         DRptObNftALpxoCVgrGUyvnttI0IWSkewC9W0N1ByPcPgLZRMJ8rwhemTF0LK3AU2+wn
         gZHypCppb/OQy2siMR69fd3s2XqnHFxynET0WR7SgvUPiXnzJOdiciLMPhq5AM54ZtmU
         XN8UTBzXjgeAkyM1lQKZBSNB/vTJ1UIalFWkd0qtgJA+fR99q1axhpck1mKe60dHsnaf
         oJgNXEgbBdN5m3SHSnBZVxEcMBfd3dKoZNBF50nglgRGRDtQSalfEoLO9T2gPLuZ0sn3
         rU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Yak3dR9rFGELmftcVHe45byG+0N11NxkW2kkiG+MQlI=;
        b=X7d7M9JBkNv0jPjNJoCjKjaM+wse1tnYhdu9gwyw8D+5rZz3rO+bfJIdrGQ/IjHo7l
         3NncoaGJbzHTDaPAB12oc2UvmKuhvErz49qB5w7ISTwnSDfXpASIR8d3831OPn92Xd8m
         6eaC3+8aNPlE0zbdWLoDw6kWCO67WrepS3Q4U7BhMYiYW2++vu9wICbyizzN66YqYqga
         AZD1fVVR+R+8nEpmmGBFEK/G5mrc2D12P+oBovbYChXDsxVaU2umdoVGpihTMRorD73B
         YdYtiLi17pcZhPwMKIXOAzckMDZi5RFPB3/AQ0QTJJlwqYJI18E1WW8qGWgGkLNUv57X
         6yLw==
X-Gm-Message-State: AOAM531LNbBTjpcCiRcSLzTMffuIGI2fs/0n47BuYdghUTot8ZIU3PW4
        Qq6L9GuRORzp/JlHi4fW4TY=
X-Google-Smtp-Source: ABdhPJw1jivFCGPg1o/u4uvAe4j+BNGA/xhLtZoVNr1DZDGDVBhH/UslxJCUfdwTXqtyu/U0GIhoxA==
X-Received: by 2002:a62:52c7:0:b029:255:e78e:5069 with SMTP id g190-20020a6252c70000b0290255e78e5069mr6071901pfb.45.1619226579255;
        Fri, 23 Apr 2021 18:09:39 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c125sm5570875pfa.74.2021.04.23.18.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 18:09:38 -0700 (PDT)
Date:   Sat, 24 Apr 2021 09:09:25 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv9 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210424010925.GG3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
 <20210422071454.2023282-3-liuhangbin@gmail.com>
 <20210422185332.3199ca2e@carbon>
 <87a6pqfb9x.fsf@toke.dk>
 <20210423185429.126492d0@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210423185429.126492d0@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 06:54:29PM +0200, Jesper Dangaard Brouer wrote:
> On Thu, 22 Apr 2021 20:02:18 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> 
> > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> > 
> > > On Thu, 22 Apr 2021 15:14:52 +0800
> > > Hangbin Liu <liuhangbin@gmail.com> wrote:
> > >  
> > >> diff --git a/net/core/filter.c b/net/core/filter.c
> > >> index cae56d08a670..afec192c3b21 100644
> > >> --- a/net/core/filter.c
> > >> +++ b/net/core/filter.c  
> > > [...]  
> > >>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> > >>  		    struct bpf_prog *xdp_prog)
> > >>  {
> > >> @@ -3933,6 +3950,7 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> > >>  	enum bpf_map_type map_type = ri->map_type;
> > >>  	void *fwd = ri->tgt_value;
> > >>  	u32 map_id = ri->map_id;
> > >> +	struct bpf_map *map;
> > >>  	int err;
> > >>  
> > >>  	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
> > >> @@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> > >>  	case BPF_MAP_TYPE_DEVMAP:
> > >>  		fallthrough;
> > >>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > >> -		err = dev_map_enqueue(fwd, xdp, dev);
> > >> +		map = xchg(&ri->map, NULL);  
> > >
> > > Hmm, this looks dangerous for performance to have on this fast-path.
> > > The xchg call can be expensive, AFAIK this is an atomic operation.  
> > 
> > Ugh, you're right. That's my bad, I suggested replacing the
> > READ_ONCE()/WRITE_ONCE() pair with the xchg() because an exchange is
> > what it's doing, but I failed to consider the performance implications
> > of the atomic operation. Sorry about that, Hangbin! I guess this should
> > be changed to:
> > 
> > +		map = READ_ONCE(ri->map);
> > +		if (map) {
> > +			WRITE_ONCE(ri->map, NULL);
> > +			err = dev_map_enqueue_multi(xdp, dev, map,
> > +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> > +		} else {
> > +			err = dev_map_enqueue(fwd, xdp, dev);
> > +		}
> 
> This is highly sensitive fast-path code, as you saw Bjørn have been
> hunting nanosec in this area.  The above code implicitly have "map" as
> the likely option, which I don't think it is.

Hi Jesper,

From the performance data, there is only a slightly impact. Do we still need
to block the whole patch on this? Or if you have a better solution?

Thanks
Hangbin
