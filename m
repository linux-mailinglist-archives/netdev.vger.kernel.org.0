Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BAF214239
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 02:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgGDAHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 20:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgGDAHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 20:07:48 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDDBC061794;
        Fri,  3 Jul 2020 17:07:48 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id j12so14522283pfn.10;
        Fri, 03 Jul 2020 17:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GOrV10005Q8Q4suTbzF/djiO885k3lcqkfEIQyIUln8=;
        b=AlkMmIXmIN1+mJPkeXxi7wbVl/3gUDtdVqrGu45rkqPp8QUNnY3mE3U8ahC17XLeUp
         PVMz9+9e8+WcbQ7k2h9mNIwnpp5URDWUSahfLqB6Zy5L4htBhhHZjGVe+DIRgWN09N11
         e8xnbm/+DoR1QAFh/cAfkLcf1Hb0ODIQ5jCDqHxM25adV4cfucBdx+khQ56MZBAApqo9
         6FacpXI3INz24VqGMGdtoda5nes1Buei5PQAzqpYJglBRZtmOp5W74FLCs/ZjKD++jsO
         GJVFLn3VFW8jedijcjhXlpFnkoezY2fWkTTFXW84VH+tg9dnaR0a1zajEXadQ/QvZ4mm
         i95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GOrV10005Q8Q4suTbzF/djiO885k3lcqkfEIQyIUln8=;
        b=nigZ4UJruX9WkTJZKfhvTlO8gOgUJtUTFVyGizk/6IS0kJ+ZDzAEE6WTkExe+x5Fwr
         6Y9apxW+w+HuVh8pR/SlxM4HOfLYALSEK31DBFa/PkoleZKjYDfFexj9I+uH2d3ZbxsV
         WgaG/W6PJ7gVXm70eg7I2G5EYYpORXAg0BypfftIBa10Uf83P6nowVswNdLLQxFbvJpA
         aHSSz5tL8aHMY8HFIJx5GdKrJBChwU69q28kIoIOTkz1Xs+GV/pVtZPbOQ1kkEq9DFWB
         YrkxH7nPypsrl33lpiMwDUa1SCqEkWuCTduphEpUkjvzvhVWFwpR2m0Ukt1AXrWcD9jN
         C0LQ==
X-Gm-Message-State: AOAM531/d4WigMvU6lN6VUPmMtQRSxUPPLUK/KbIPi5grc6wf5cCoOWY
        i2JBALAFheMOTvyT13K4yww=
X-Google-Smtp-Source: ABdhPJwQQPLCwUIh+RPyc2M+my4C/NEHSFIAKEkU0j8nCNzFXhyTwFoRtMeWsG+2htW8ppgejPn2vw==
X-Received: by 2002:a62:4e06:: with SMTP id c6mr35060710pfb.296.1593821268411;
        Fri, 03 Jul 2020 17:07:48 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d8c2])
        by smtp.gmail.com with ESMTPSA id 21sm12760164pfv.43.2020.07.03.17.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 17:07:47 -0700 (PDT)
Date:   Fri, 3 Jul 2020 17:07:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        daniel@iogearbox.net, ebiederm@xmission.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 0/3] bpf: Populate bpffs with map and prog
 iterators
Message-ID: <20200704000745.hv4fyewbm4f5ttao@ast-mbp.dhcp.thefacebook.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
 <878sg0etik.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878sg0etik.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 01:18:43PM +0200, Toke Høiland-Jørgensen wrote:
> > The user mode driver will load BPF Type Formats, create BPF maps, populate BPF
> > maps, load two BPF programs, attach them to BPF iterators, and finally send two
> > bpf_link IDs back to the kernel.
> > The kernel will pin two bpf_links into newly mounted bpffs instance under
> > names "progs" and "maps". These two files become human readable.
> >
> > $ cat /sys/fs/bpf/progs
> >   id name            pages attached
> >   11    dump_bpf_map     1 bpf_iter_bpf_map
> >   12   dump_bpf_prog     1 bpf_iter_bpf_prog
> >   27 test_pkt_access     1
> >   32       test_main     1 test_pkt_access test_pkt_access
> >   33   test_subprog1     1 test_pkt_access_subprog1 test_pkt_access
> >   34   test_subprog2     1 test_pkt_access_subprog2 test_pkt_access
> >   35   test_subprog3     1 test_pkt_access_subprog3 test_pkt_access
> >   36 new_get_skb_len     1 get_skb_len test_pkt_access
> >   37 new_get_skb_ifi     1 get_skb_ifindex test_pkt_access
> >   38 new_get_constan     1 get_constant test_pkt_access
> 
> Do the iterators respect namespace boundaries? Or will I see all
> programs/maps on the host if I cat the file inside a container?

why are you asking? I'm pretty sure you know that bpf infra isn't namespaced yet.

> > Few interesting observations:
> > - though bpffs comes with two human readble files "progs" and "maps" they
> >   can be removed. 'rm -f /sys/fs/bpf/progs' will remove bpf_link and kernel
> >   will automatically unload corresponding BPF progs, maps, BTFs.
> 
> Is there any way to get the files back if one does this by mistake
> (other than re-mounting the bpffs)?

Same as user A pining their prog/map/link in bpffs and user B removing it.
