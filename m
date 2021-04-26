Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1969236B178
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 12:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhDZKUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 06:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhDZKUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 06:20:35 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8731C061574;
        Mon, 26 Apr 2021 03:19:53 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d124so38580037pfa.13;
        Mon, 26 Apr 2021 03:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TMUYLOMPKfiyNVH9R9syHPSncS85mDZLJ69XxngYkXM=;
        b=p/T+P+Z3nNh+ICNzkff0+aA5sRrWUA7FjjwNBZum+2SkLOk6ezWwAbhqtvlmKlJ6AW
         Bz+wofyyn5ZHqcIOuK/eTmoNs9gKO/tepGQyFa/9/+KdmMN5JSz0lJAjRohHkx1BUvOE
         SJi5Qeka+aL0S0Yqpghap9imxXI2z3g9oMuwcXSCeXxdKtmMsYexJHkL4o9pKKC83jor
         ptV9hI5q5ZQDWyfQAWTBiuwG9YTC9doJbAvxMg9NySslsJnEd9NTFgT6MhR+rGYXwX5G
         FIb7JmWBSM+O5vGkSt8IxR4wCD/h856Xq3y8GruVZrIbaRFXinnT5v4UdngXKHlUd/4Z
         TC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TMUYLOMPKfiyNVH9R9syHPSncS85mDZLJ69XxngYkXM=;
        b=lqrS5GdPCNBTSwH1SIHMIcEx84ok42/0mG/YMFRn7TttUBn1/gHYNRjbpfIU84c5Nc
         4asZirnKlKuMBcpvjar3+Sm4yEX6FFvq57b2qTswMg/d0K91ejKFiWuM9XSpiHLEOv2K
         WjG5GV61dPPMxi7Kt6XmKnzZW2XYKBw1WrmfcWuhKIRU6aVDtYQFrXVRNr+pVPlwgMes
         y6lexCDTZMChVqqhjdkeEcg9c9Sji96z3Q6/ROMDjB/jYZ4+OVG/60sZMVCjI+2TzshL
         JBThYvacdne+HQvssTath1r56d/j2gOY5P1vaUnRfiDejDpI1r3USCgi40KmfOopfidk
         yyGQ==
X-Gm-Message-State: AOAM533w+BnMCHEiTWvIhb3CPu9n9LYsCYLgtjdSeN+g3t3oXEw0JBbG
        q3qqmIsPHhAcxLPFeFbWaQ8=
X-Google-Smtp-Source: ABdhPJxWFNCYnPaEmjp/nkrRGy8IE00cJ6xOqefmGDs6u14tD/3HgEQcAWZ9y5NBGRehfNYu2KNs9A==
X-Received: by 2002:a62:2c46:0:b029:245:6391:b631 with SMTP id s67-20020a622c460000b02902456391b631mr16682125pfs.67.1619432393497;
        Mon, 26 Apr 2021 03:19:53 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k20sm10870556pfa.34.2021.04.26.03.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 03:19:53 -0700 (PDT)
Date:   Mon, 26 Apr 2021 18:19:40 +0800
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
Subject: Re: [PATCHv9 bpf-next 4/4] selftests/bpf: add xdp_redirect_multi test
Message-ID: <20210426101940.GP3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
 <20210422071454.2023282-5-liuhangbin@gmail.com>
 <20210426112832.0b746447@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426112832.0b746447@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 11:28:32AM +0200, Jesper Dangaard Brouer wrote:
> On Thu, 22 Apr 2021 15:14:54 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > Add a bpf selftest for new helper xdp_redirect_map_multi(). In this
> > test there are 3 forward groups and 1 exclude group. The test will
> > redirect each interface's packets to all the interfaces in the forward
> > group, and exclude the interface in exclude map.
> > 
> > Two maps (DEVMAP, DEVMAP_HASH) and two xdp modes (generic, drive) will
> > be tested. XDP egress program will also be tested by setting pkt src MAC
> > to egress interface's MAC address.
> > 
> > For more test details, you can find it in the test script. Here is
> > the test result.
> > ]# ./test_xdp_redirect_multi.sh
> 
> Running this test takes a long time around 3 minutes.

Yes, there are some sleeps, ping tests. Don't know if I missed
anything, is there a time limit for the selftest?

Thanks
hangbin
> 
> $ sudo time -v ./test_xdp_redirect_multi.sh
> Pass: xdpgeneric arp ns1-2
> Pass: xdpgeneric arp ns1-3
> Pass: xdpgeneric arp ns1-4
> Pass: xdpgeneric ping ns1-2
> Pass: xdpgeneric ping ns1-3
> Pass: xdpgeneric ping ns1-4
> Pass: xdpgeneric ping6 ns1-2
> Pass: xdpgeneric ping6 ns1-1 number
> Pass: xdpgeneric ping6 ns1-2 number
> Pass: xdpdrv arp ns1-2
> Pass: xdpdrv arp ns1-3
> Pass: xdpdrv arp ns1-4
> Pass: xdpdrv ping ns1-2
> Pass: xdpdrv ping ns1-3
> Pass: xdpdrv ping ns1-4
> Pass: xdpdrv ping6 ns1-2
> Pass: xdpdrv ping6 ns1-1 number
> Pass: xdpdrv ping6 ns1-2 number
> Pass: xdpegress mac ns1-2
> Pass: xdpegress mac ns1-3
> Pass: xdpegress mac ns1-4
> Summary: PASS 21, FAIL 0
> 	Command being timed: "./test_xdp_redirect_multi.sh"
> 	User time (seconds): 0.15
> 	System time (seconds): 0.51
> 	Percent of CPU this job got: 0%
> 	Elapsed (wall clock) time (h:mm:ss or m:ss): 3:09.68
> 	Average shared text size (kbytes): 0
> 	Average unshared data size (kbytes): 0
> 	Average stack size (kbytes): 0
> 	Average total size (kbytes): 0
> 	Maximum resident set size (kbytes): 6904
> 	Average resident set size (kbytes): 0
> 	Major (requiring I/O) page faults: 13
> 	Minor (reclaiming a frame) page faults: 46316
> 	Voluntary context switches: 1907
> 	Involuntary context switches: 371
> 	Swaps: 0
> 	File system inputs: 0
> 	File system outputs: 0
> 	Socket messages sent: 0
> 	Socket messages received: 0
> 	Signals delivered: 0
> 	Page size (bytes): 4096
> 	Exit status: 0
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
