Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1BA36B1F4
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhDZKzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232266AbhDZKzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:55:39 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF78C061574;
        Mon, 26 Apr 2021 03:54:58 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w20so918186pge.13;
        Mon, 26 Apr 2021 03:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qlDy9pRNg1Kqoc8pGdoU3/wngWThiANlb7SSQhORbSg=;
        b=IF1uKz18hAHY26q2X3u/t4JHfR1T8SbbMrMaQkFQ6OFwyDxk+M1cit4xD6aV9hYKlk
         htcRlpgP/Iyn6NBsVDB2MGnO0XW7CGoswws5qnIQGcMQKFvBvCSm1bNYMknJrcTFGdH4
         3JrgEFi+g+GIDKD7oKm8AX1Mq6+63vkjRWbfcDdADd1Kxr0k1WPhmtIS9a0GmKghfmGw
         QESXRUErZztYiXGpbZoAJBBTdphKFxBDdDn99vESFWJcAerWjwgFFrxm0ZIaAbZGcew2
         ehbxZyJ0zcp/ikvJZ58VzhLxbfmROtNZdq6rxwTIyX3nA16TKf1c/lX0kqxs71OElbKL
         z8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qlDy9pRNg1Kqoc8pGdoU3/wngWThiANlb7SSQhORbSg=;
        b=lcg3hdfKsYoWIMhtrUERUj7TBHBQdz4rPdBoq/f2wRiYPetdh1JknJUF75RpEBqh6v
         yUJpW+FW1AioeusxIzHNaYxvJSC2WzkKqhp3le67BNEn470eWK8NYgCWHcziWJ77yI/t
         oBv0bHxgv8kQgRQ48I7kB2OLNkuKfe+D4cNKs59cpVsLek6UBPM3xnMPMh0mFHsbpiqE
         mWbFlpOJFrTFwMzuzgQlOvSD84fhYbqWzlJLpUJ+8QwqfaZNxrE6Qv2AapBUzhaxc8dt
         stxzsK71ww0MkLmBFUQjSKNRQJ3D6iBjkrHCn8L6rI9mCAqUBRjBa/wMSXfqQL/96fov
         UgdA==
X-Gm-Message-State: AOAM533G83omk93Hc0tFuUr3VuFCOIjeYKgoD+6H5zwhfz+EdyGsImjS
        f0JEA9RV1QbM0IR2ABlV9tQ=
X-Google-Smtp-Source: ABdhPJylaOmheQM+Plxzg4g49VnpMpDoWDopxuiwGRGwt49/KbFGrECb7fhgt5TQyEuIAT6uNjZwMg==
X-Received: by 2002:aa7:9ad4:0:b029:275:af4c:3988 with SMTP id x20-20020aa79ad40000b0290275af4c3988mr5869606pfp.78.1619434497906;
        Mon, 26 Apr 2021 03:54:57 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b20sm14502794pju.17.2021.04.26.03.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 03:54:57 -0700 (PDT)
Date:   Mon, 26 Apr 2021 18:54:44 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
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
Subject: Re: [PATCHv10 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210426105444.GS3465@Leo-laptop-t470s>
References: <20210423020019.2333192-1-liuhangbin@gmail.com>
 <20210423020019.2333192-3-liuhangbin@gmail.com>
 <20210426115350.501cef2a@carbon>
 <20210426104704.GR3465@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426104704.GR3465@Leo-laptop-t470s>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 06:47:17PM +0800, Hangbin Liu wrote:
> On Mon, Apr 26, 2021 at 11:53:50AM +0200, Jesper Dangaard Brouer wrote:
> > On Fri, 23 Apr 2021 10:00:17 +0800
> > Hangbin Liu <liuhangbin@gmail.com> wrote:
> > 
> > > This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
> > > extend xdp_redirect_map for broadcast support.
> > > 
> > > With BPF_F_BROADCAST the packet will be broadcasted to all the interfaces
> > > in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
> > > excluded when do broadcasting.
> > > 
> > > When getting the devices in dev hash map via dev_map_hash_get_next_key(),
> > > there is a possibility that we fall back to the first key when a device
> > > was removed. This will duplicate packets on some interfaces. So just walk
> > > the whole buckets to avoid this issue. For dev array map, we also walk the
> > > whole map to find valid interfaces.
> > > 
> > > Function bpf_clear_redirect_map() was removed in
> > > commit ee75aef23afe ("bpf, xdp: Restructure redirect actions").
> > > Add it back as we need to use ri->map again.
> > > 
> > > Here is the performance result by using 10Gb i40e NIC, do XDP_DROP on
> > > veth peer, run xdp_redirect_{map, map_multi} in sample/bpf and send pkts
> > > via pktgen cmd:
> > > ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> > 
> > While running:
> >  $ sudo ./xdp_redirect_map_multi -F i40e2 i40e2
> >  Get interfaces 7 7
> >  libbpf: elf: skipping unrecognized data section(23) .eh_frame
> >  libbpf: elf: skipping relo section(24) .rel.eh_frame for section(23) .eh_frame
> >  Forwarding   10140845 pkt/s
> >  Forwarding   11767042 pkt/s
> >  Forwarding   11783437 pkt/s
> >  Forwarding   11767331 pkt/s
> > 
> > When starting:  sudo ./xdp_monitor --stats
> 
> That seems the same issue I reported previously in our meeting.
> https://bugzilla.redhat.com/show_bug.cgi?id=1906820#c4
> 
> I only saw it 3 times and can't reproduce it easily.
> 
> Do you have any idea where is the root cause?

OK, I just re-did the test and could reproduce it now.
Maybe because the code changed and it's easy to reproduce now.

I will check this issue.

Thanks
Hangbin
