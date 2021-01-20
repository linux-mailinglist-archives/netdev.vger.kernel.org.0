Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC352FC9D5
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 05:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbhATESs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 23:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728240AbhATERU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 23:17:20 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E710C0613CF;
        Tue, 19 Jan 2021 20:16:40 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q7so14355054pgm.5;
        Tue, 19 Jan 2021 20:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9jjlra2ch2Xsqe0ISFMS2Qh77D3vPA65jwCpuP2CbHo=;
        b=bjMhN2TFCn//WVlaqtZwyiM2V2rbcB8VS5u/iL8nNy5mIkdm26HZAgK+IK6LIdEO4c
         MHm9K3PcMMXW0/pHOSmLOo3Qe0eYOWsui3XCgmVbQoWvqH4hIsGCbfzq9rEpI157xHT9
         hrKXbh1WboA9eN2KX0I7H9VLCAykH3x2bAXejFbdTCqU/3UfRu/XodOAxu7yIDAbCnul
         pJe/G4G+MfmdtYGTegKXumxGi11AvUvDqYi8CfKBwoI1i48zzNFU7PAFokC7Tpyc9yXk
         xcOQ6kskGNMABUBGeVUdrPz0w5khgPS0ebpTYrjhtfv5H3t5ePqRkrQosxG7GVNaMShT
         RL+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9jjlra2ch2Xsqe0ISFMS2Qh77D3vPA65jwCpuP2CbHo=;
        b=uU97/s1CZaczyOIbK2VhevcIwBSy6PSZOJyhLmNjnwe0TGkYRPPtNa0QqAVYoinmcA
         u8OlvM7+vWvu3Pekknfwu4uKhDgdGMzkVnNdYXnqSOoJkYC19AT/JULdeT+V6FiUGo3x
         Pnk+YXQdEAPQ0ICgRz0lyZe7Y1WVbEvlX6eOCRLEqB3khUr4foJ9I6JaJi1wVeRNF+6A
         +LIl21k7kqfcemQ85GfpZP2Z0PqfR7COzAWQ8iOX3MJHPenqAr989vU+UnjBcHfwOfTt
         jpBrKYlsYa5VI7YGa+RoTqV1+yJsiP7i8bRs9iQchzBSTiaUFPmXzui1MaegYGRDilGb
         Cc1g==
X-Gm-Message-State: AOAM531n5FF7IGH/DgMRbJC0ASYL7lUXTZ2+TVYhFrg/AHTBo9ZBfA7r
        cy/SoOtco3QTe9eusFhG6iBAW09wb67v8Kq2
X-Google-Smtp-Source: ABdhPJwDi6mA0Z6G5Hv25j0WRk+RdtlWLRksCFTDp31HpfJgI1QNWZ77msZDhvXmXE5UGye0/JIdoA==
X-Received: by 2002:a65:63c7:: with SMTP id n7mr7575913pgv.285.1611116199979;
        Tue, 19 Jan 2021 20:16:39 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y22sm561464pfb.132.2021.01.19.20.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 20:16:39 -0800 (PST)
Date:   Wed, 20 Jan 2021 12:16:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv8 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20210120041628.GH1421720@Leo-laptop-t470s>
References: <20210115062433.2624893-1-liuhangbin@gmail.com>
 <20210119031207.2813215-1-liuhangbin@gmail.com>
 <20210119155127.1f906018@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119155127.1f906018@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 19, 2021 at 03:51:27PM +0100, Jesper Dangaard Brouer wrote:
> > @@ -73,13 +90,63 @@ int xdp_redirect_map_prog(struct xdp_md *ctx)
> >  
> >  	/* count packet in global counter */
> >  	value = bpf_map_lookup_elem(&rxcnt, &key);
> > -	if (value)
> > +	if (value) {
> >  		*value += 1;
> > +		if (*value % 2 == 1)
> > +			vport = 1;
> 
> This will also change the base behavior of the program, e.g when we are
> not testing the 2nd xdp-prog.  It will become hard to compare the
> performance between xdp_redirect and xdp_redirect_map.

I just did a test with/without this patch on 5.10 using pktgen

By ./xdp_redirect_map -N/-S eno1 eno1

Without this patch
- S 1.8M pps
- N 7.4M pps

With this patch
- S 1.9M pps
- N 7.4M pps

So I don't see much difference.

> 
> It looks like you are populating vport=0 and vport=1 with the same ifindex.
> Thus, this code is basically doing packet reordering, due to the per
> CPU bulking layer (of 16 packets) in devmap.
> Is this the intended behavior?

I didn't expect this could cause reordering. If we want only do it when
attached the 2nd prog, we need add a check like

key = 1;
value = bpf_map_lookup_elem(&tx_port_native , &key);
if (value)
	do_2nd_prog_test
else
	do_nothing_and_redirect_with_port_0

But an extra bpf_map_lookup_elem() for every packet may cause more performance
drop. So WDYT?

Thanks
Hangbin
