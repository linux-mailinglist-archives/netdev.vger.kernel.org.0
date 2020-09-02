Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CD825B599
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIBVIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIBVIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:08:42 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368D0C061244;
        Wed,  2 Sep 2020 14:08:42 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f18so368078pfa.10;
        Wed, 02 Sep 2020 14:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EK6NricySUp/sEcvpqlTK1TfAw/t1m09azglRdZNI24=;
        b=txq2eiiWYaBZ/hxF9oDeyIWwlQ+5FANBgQHOD1w/I86/pNrZoioWs1e8uG3DOE0NC8
         8bs05yHI/tRw7C2gytWgVNFIvsyi87K0MUpcrr5PL90H8H0z069J0P6LgY+aGtIeAm+b
         KNgnDXZqJi+dRgMLZR98QJDq3pATLZu9lzhb9XrJW6HIVbg/zFs7Nw/Hv3VC09Zzej1A
         S53a9bX7UJ9BHwDGXmYrzhvzhEZ7//RzT4R0zE/vxlpsqnzbiFg5WfQjnHXj4r3SFgjg
         VKZICVF4RR6/LkQogFr330c2cos101n1EXYvlsJXjlFDkI80RTSpjczqV9AFZTpjmU8B
         OVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EK6NricySUp/sEcvpqlTK1TfAw/t1m09azglRdZNI24=;
        b=oMKljyv2JgEOZ+8+JO1AryJmD7cmZ4mMSBg8/EGDfOTSa+Z4r2saPojGoYfNGeXjzU
         0ZynBfh5724KWfpJKl1U58jCTBAzQBMUWQbtwYVOo0gOHwgdrNP37kfDyE1G2Gwnbv70
         XVsMqH6T9I1n92x2tFSEhL+tUAGnribFM/YHgBOyTTw8KzN/H9eR8mm5XL7bUkboHodA
         aCiLXvB9wam0nApWlgvP/O6LDyykP7k4M1pJY/z+3y3Lldm4tyK+UtsjPzRrn9M0mxlZ
         9oOtx4bboZJP0e4ZZfq1T/tHXO2H0yZI29YyzBeKGo9xBlJGckhES0xtlk0ySlj9c7gS
         /Xmw==
X-Gm-Message-State: AOAM531UVT6qAKuBMu13Wr0O5CGkKNCjy7A6tx4E06O6aNe85S+F0GDW
        hg476Osb8YMTKEUrsbGlfa4=
X-Google-Smtp-Source: ABdhPJzIotfeY8Ia0h0NGSoWYyGpifq5QfcTSU2eXljJFvt530GFJ5pF4Q5yaikhzLxrrpqT94UGOA==
X-Received: by 2002:a17:902:407:: with SMTP id 7mr282399ple.167.1599080921444;
        Wed, 02 Sep 2020 14:08:41 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b65c])
        by smtp.gmail.com with ESMTPSA id j19sm457778pfi.51.2020.09.02.14.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 14:08:40 -0700 (PDT)
Date:   Wed, 2 Sep 2020 14:08:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     sdf@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei1999@gmail.com>, andriin@fb.com
Subject: Re: [PATCH bpf-next v3 4/8] libbpf: implement bpf_prog_find_metadata
Message-ID: <20200902210838.7a26mfi54dufou5a@ast-mbp.dhcp.thefacebook.com>
References: <20200828193603.335512-1-sdf@google.com>
 <20200828193603.335512-5-sdf@google.com>
 <874koma34d.fsf@toke.dk>
 <20200831154001.GC48607@google.com>
 <20200901225841.qpsugarocx523dmy@ast-mbp.dhcp.thefacebook.com>
 <874kogike9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874kogike9.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 11:43:26AM +0200, Toke Høiland-Jørgensen wrote:
> >
> > I don't feel great about this libbpf api. bpftool already does
> > bpf_obj_get_info_by_fd() for progs and for maps.
> > This extra step and extra set of syscalls is redundant work.
> > I think it's better to be done as part of bpftool.
> > It doesn't quite fit as generic api.
> 
> Why not? 

It's a helper function on top of already provided api and implemented
in the most brute force and inefficient way.
bpftool implementation of the same will be more efficient.

> so. If we don't have it, people will have to go look at bpftool code,
> and we'll end up with copied code snippets, which seems less than ideal.

I'd like to see the real use case first before hypothesising.
