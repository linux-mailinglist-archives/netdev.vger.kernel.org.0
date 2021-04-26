Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF136B290
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 13:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhDZLzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 07:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbhDZLzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 07:55:21 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C49C061574;
        Mon, 26 Apr 2021 04:54:40 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p17so2901561plf.12;
        Mon, 26 Apr 2021 04:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YVWBdeIeN9rQKY5lpBVWnLapN4/WYy+0IlaZ07mPtA8=;
        b=bLSE5s3Nb++c9HkSnlzRQvkZhLg7gD9S+SAWsDALfYLhFSFLhuj/HaDA0rPWKaWe2+
         xDBNAqrJzGmWQvIj0bzUyW9b1PxdYFD5gfkE+8A4SvbpvQE19nadYfBmfo8CgjWyXC61
         o0hrQtlx9zZBpsEDdE38T8QaXDqUQEI6Uizc+QmhIB1fuQ+hAKc9s+vaNGwmubEKBYq8
         17CC9FtRzqJIzZUM1Y7yNkFzgQsrEUxldxWYc3TZjOGBc4hw5saL4aARXv9xUM89i1MC
         2StUJhlKgTxqXNPVqhcrUGda/L8nnbnowe4uU85OF9FPMO3iyO4omCtzKz9Y5wfbf3/6
         aZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YVWBdeIeN9rQKY5lpBVWnLapN4/WYy+0IlaZ07mPtA8=;
        b=OQbAMMNtNbq1+HtRMAEMhYkLt3EFOBOZgX3RKxcpuaha1UnjphKj8nrn0O8jqRfzz2
         m4tLITfOwk69ZNCkh+6rym1Woq58dAnd0LDRm2A7ePsMpdA5cIsAv2D7+tsKf25/u1jz
         SwzcZXnse2KTBoldnnyd8YUJP0DqEIZvgXpcBH5XlB4aWhwB8E8uuUKnXkul8d84wW5C
         4SVtoaLCurwTpKPmC2TYy1a+PL+l43SNXYoI7OQEd1j5k5EFgOe+mu++leB5eTwthrBN
         D/2Qq/D7Bm4WsgiEBdfObeu60j8QaPdk8hAfh1vmCzmTYCIQ2uPM5m1XThwI9jw5d7UH
         Dmqw==
X-Gm-Message-State: AOAM533s1eEAgo7WL243x39vJe6xlPXKPlyWNtPTuwn5RFdR5bAveiRU
        MUdFlLfBaDBfUZy73I1KEzY=
X-Google-Smtp-Source: ABdhPJyDmCNBbXjgPoQfyUpH3P7GgTT/p/hZdoP4V4NEDpYo1PkuUyZ9ojCD5sga5uZvDaungiEaxA==
X-Received: by 2002:a17:90a:77c8:: with SMTP id e8mr23009425pjs.69.1619438080122;
        Mon, 26 Apr 2021 04:54:40 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i131sm11033068pgc.20.2021.04.26.04.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 04:54:39 -0700 (PDT)
Date:   Mon, 26 Apr 2021 19:54:27 +0800
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
Message-ID: <20210426115427.GV3465@Leo-laptop-t470s>
References: <20210423020019.2333192-1-liuhangbin@gmail.com>
 <20210423020019.2333192-3-liuhangbin@gmail.com>
 <20210426115350.501cef2a@carbon>
 <20210426104704.GR3465@Leo-laptop-t470s>
 <20210426134105.4706af0b@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426134105.4706af0b@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 01:41:05PM +0200, Jesper Dangaard Brouer wrote:
> > > While running:
> > >  $ sudo ./xdp_redirect_map_multi -F i40e2 i40e2
> > >  Get interfaces 7 7
> > >  libbpf: elf: skipping unrecognized data section(23) .eh_frame
> > >  libbpf: elf: skipping relo section(24) .rel.eh_frame for section(23) .eh_frame
> > >  Forwarding   10140845 pkt/s
> > >  Forwarding   11767042 pkt/s
> > >  Forwarding   11783437 pkt/s
> > >  Forwarding   11767331 pkt/s
> > > 
> > > When starting:  sudo ./xdp_monitor --stats  
> > 
> > That seems the same issue I reported previously in our meeting.
> > https://bugzilla.redhat.com/show_bug.cgi?id=1906820#c4
> > 
> > I only saw it 3 times and can't reproduce it easily.
> > 
> > Do you have any idea where is the root cause?
> 
> All the information you need to find the root-cause is listed below.
> I have even decoded where in the code it happens, and also include the
> code with line-numbering and pointed to the line the crash happens in,
> I don't think it is possible for me to be more specific and help further.

Thanks, I mixed this issue with the one I got previously, which I haven't
figure out yet. For this one, I have sent a propose in another reply (that
fix it in trace point event). Would you please help review.

Hangbin
