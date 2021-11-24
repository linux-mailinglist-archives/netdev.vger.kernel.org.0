Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0876145B72D
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 10:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhKXJRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 04:17:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53101 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233741AbhKXJRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 04:17:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637745244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=an9x2Dfbh9wskzxQIisO81DRQJiZukEeOxv/VbqxnJw=;
        b=b7yL8dbd2RoMpKFGoUcxnVITcSNoCRVJQFGTd+oC2HbVynvdaPN7LS4AZgsrUtPos4MKXD
        6raazbloYeHnZf7sEthn9pfj6aLkr+dxX47yO8lblEfhBxL0LCn3Uf6HzWFiuM5mFPp2VC
        8YBAY6ABF8d8Yxj+gm07yfhVLX523p4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-OqBspVmWMxyH2ybPMslr-w-1; Wed, 24 Nov 2021 04:14:03 -0500
X-MC-Unique: OqBspVmWMxyH2ybPMslr-w-1
Received: by mail-wm1-f71.google.com with SMTP id j193-20020a1c23ca000000b003306ae8bfb7so994413wmj.7
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 01:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=an9x2Dfbh9wskzxQIisO81DRQJiZukEeOxv/VbqxnJw=;
        b=vf0NyeOx3BfGSCwLH1Um9JfKVfLOwxNHIgJllW2dY8ODSf0Nv2ti3FY7BEc3c2GggS
         o5jodRnGI6ENxWvkvD7c/3OAT6h8oZY72sI/yn81Xdr3r1sJ3xXLdfZLq/uvxWNEi87N
         a/NYo42LzFL9MxKUy0EFvZRhyp2MShyaxiGv8nfq+N9CyhlqTDjc9D32Zoa9WE0GrMAv
         uHiAPJzeh9e5N3bLKy+TABKvGfQh3OPNSICuOcXn9q6ii5jQc9ACCm6NlGqp7OqPMfD6
         Vu+ge2o+JHvDdir9cQXAoO1iDEUR8pLC2rmnGvSR7/sB1IJ9ob2rQv58ktdGHDZdAp0t
         VmFw==
X-Gm-Message-State: AOAM531Av1fQOyy0LLwsuIGGnzbNFkwtCPnDnvSP9v8LoUkzFXPTW7WA
        iYdVXlVxgAefFjIPI9L/C9dAWid+KOxBoimLVBs6yI28VWZgvP9H3vr69sJLAh5hVHlsWZPwsht
        m0fKRwuMID7bbkYaH
X-Received: by 2002:a05:600c:4f55:: with SMTP id m21mr13301416wmq.68.1637745241699;
        Wed, 24 Nov 2021 01:14:01 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz92Uf/bZfQdHLAF5h+SAPaRvQzfSkMisBxO1HG5jL3qGcu+oHn/oYyw4KoqRCkjlfQRNxCNA==
X-Received: by 2002:a05:600c:4f55:: with SMTP id m21mr13301367wmq.68.1637745241410;
        Wed, 24 Nov 2021 01:14:01 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-229-135.dyn.eolo.it. [146.241.229.135])
        by smtp.gmail.com with ESMTPSA id n32sm5431099wms.1.2021.11.24.01.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 01:14:01 -0800 (PST)
Message-ID: <8888189adb73b6d5a49fd197b6c205a2fb505996.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] bpf: let bpf_warn_invalid_xdp_action()
 report more info
From:   Paolo Abeni <pabeni@redhat.com>
To:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Date:   Wed, 24 Nov 2021 10:13:55 +0100
In-Reply-To: <87tug4cto2.fsf@toke.dk>
References: <cover.1637339774.git.pabeni@redhat.com>
         <2d7cdef73ce22021ee8ce40feeb9f084af066cea.1637339774.git.pabeni@redhat.com>
         <87tug4cto2.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-11-22 at 12:32 +0100, Toke Høiland-Jørgensen wrote:
> You still have:
> 
> > diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> > index 585b2b77ccc4..f7359bcb8fa3 100644
> > --- a/kernel/bpf/cpumap.c
> > +++ b/kernel/bpf/cpumap.c
> > @@ -195,7 +195,7 @@ static void cpu_map_bpf_prog_run_skb(struct bpf_cpu_map_entry *rcpu,
> >  			}
> >  			return;
> >  		default:
> > -			bpf_warn_invalid_xdp_action(act);
> > +			bpf_warn_invalid_xdp_action(skb->dev, rcpu->prog, act);
> >  			fallthrough;
> >  		case XDP_ABORTED:
> >  			trace_xdp_exception(skb->dev, rcpu->prog, act);
> > @@ -254,7 +254,7 @@ static int cpu_map_bpf_prog_run_xdp(struct bpf_cpu_map_entry *rcpu,
> >  			}
> >  			break;
> >  		default:
> > -			bpf_warn_invalid_xdp_action(act);
> > +			bpf_warn_invalid_xdp_action(xdpf->dev_rx, rcpu->prog, act);
> >  			fallthrough;
> >  		case XDP_DROP:
> >  			xdp_return_frame(xdpf);
> > diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> > index f02d04540c0c..79bcf2169881 100644
> > --- a/kernel/bpf/devmap.c
> > +++ b/kernel/bpf/devmap.c
> > @@ -348,7 +348,7 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
> >  				frames[nframes++] = xdpf;
> >  			break;
> >  		default:
> > -			bpf_warn_invalid_xdp_action(act);
> > +			bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> >  			fallthrough;
> >  		case XDP_ABORTED:
> >  			trace_xdp_exception(dev, xdp_prog, act);
> > @@ -507,7 +507,7 @@ static u32 dev_map_bpf_prog_run_skb(struct sk_buff *skb, struct bpf_dtab_netdev
> >  		__skb_push(skb, skb->mac_len);
> >  		break;
> >  	default:
> > -		bpf_warn_invalid_xdp_action(act);
> > +		bpf_warn_invalid_xdp_action(dst->dev, dst->xdp_prog, act);
> >  		fallthrough;
> >  	case XDP_ABORTED:
> >  		trace_xdp_exception(dst->dev, dst->xdp_prog, act);
> 
> ... and ...
> 
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 3ba584bb23f8..658f7a84d9bc 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -8179,13 +8179,13 @@ static bool xdp_is_valid_access(int off, int size,
> >  	return __is_valid_xdp_access(off, size);
> >  }
> >  
> > -void bpf_warn_invalid_xdp_action(u32 act)
> > +void bpf_warn_invalid_xdp_action(struct net_device *dev, struct bpf_prog *prog, u32 act)
> >  {
> >  	const u32 act_max = XDP_REDIRECT;
> >  
> > -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> > +	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
> >  		     act > act_max ? "Illegal" : "Driver unsupported",
> > -		     act);
> > +		     act, prog->aux->name, prog->aux->id, dev->name);
> >  }
> >  EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
> 
> This will still print the dev name for cpumap and devmap programs, which
> is misleading - it will have people looking at the drivers when the
> problem is somewhere else.
> 
> I pointed this out multiple times in comments on your last revision so
> I'm a bit puzzled as to why you're still doing this? :/

I'm sorry, quite a bit of relevant incoming messages keep landing in
the spam folder due to corporate/gmail filters.

> Just pass NULL as the dev from cpumap/devmap and don't print the dev
> name in this case...

No opposition on my side, but I think that is a bit conflicting with
Alexei suggestion of keeping the message handling as simple as
possible?!?

@Alexei, would something like the following:

	pr_warn_once("%s XDP return value %u on prog %s (id %d) dev %s, expect packet loss!\n",
  		     act > act_max ? "Illegal" : "Driver unsupported",
		     act, prog->aux->name, prog->aux->id, dev ? dev->name, "");

fit you?

Thanks!

Paolo

