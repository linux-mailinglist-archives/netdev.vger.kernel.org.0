Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28A01D02D9
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 01:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731654AbgELXGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 19:06:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgELXGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 19:06:03 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1955C061A0C;
        Tue, 12 May 2020 16:06:03 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id u5so4272897pgn.5;
        Tue, 12 May 2020 16:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wP8h1NTa+U6Kk8/OOq/1Fxlcsz1oe6sfYA3PXqYlv4A=;
        b=mA59fOQF5Mh+NhiBoaCJPFwBzCILTMWrqD/lB+IuG0fPSiNARxYDmdalnYRn3eYtu+
         g9L7HxJ7E2IGQpkARoE4TjUvy4AqYfu+rXgvQCmeouyBpvyi9Hgouo5w2V554sLRM3jb
         4Kn5Wjxyq1+694WeZ31qs+Hnxwwdqkt5ZRwVq5t84yzqmzzwrsdXTV2H19Eer+v7hzkb
         s5JOKYFgaGyUJ6hoh2ti16P1gui5aaVcASr+5PNYoihO0yyCSY/an3GeO4gPxal8wQwM
         0v0fY63WDh0yTPa4l03JdE1PrSzpZHfBldzv4LIfcUpCWXCDwiq5mREUcT04Kqvp7RYx
         PPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wP8h1NTa+U6Kk8/OOq/1Fxlcsz1oe6sfYA3PXqYlv4A=;
        b=GxPm5PkPgEd5VMymXiOJLFVPKQgnRhxOXPtHQaEPxcin5/07wJ0Obmw5COAohnC8/C
         je98rj9MgL3I+yngBI1xenQO9g3BFU6AJSdra5WhgFvy5xdK6npG50/gO9QYHGMMMt3l
         UWvO6Hjt8nyxoEMWu7jeSQNPSTfFYHVbf5WOpH44Q8283pjLH43jFqdjuUvDckxpxT2N
         XcKkZAY12mPyxwicVSw0PWW0XWAVEXzC8kPiHCjNDDDQDTDcBcL82QkDb1y/L0tlUAQK
         hji9IDfp6AGYNka/JiY0DCXeOkEDW+OXOStCSI7WsaVuuWOKzX0Wz91RPabXpkYbrNIL
         xobw==
X-Gm-Message-State: AGi0PuZNMse+pW5L1M182UqSXQtMNFkv2Ozb5FCFny/VpOQ6TMA1srUY
        fWyrCDuGcdSBWFmIeTf92l4=
X-Google-Smtp-Source: APiQypLoeXHBgYqW+VcA9lLcNqtoOPC5S/yjt17YGOIAhDI4Va+p4d1AM63IMfYC3lS/SJdOR2eGvQ==
X-Received: by 2002:a62:a501:: with SMTP id v1mr16972236pfm.133.1589324763206;
        Tue, 12 May 2020 16:06:03 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:68dc])
        by smtp.gmail.com with ESMTPSA id i18sm13659859pjx.33.2020.05.12.16.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 16:06:02 -0700 (PDT)
Date:   Tue, 12 May 2020 16:06:00 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
Message-ID: <20200512230600.dxuvhy6cvwpkvlc5@ast-mbp>
References: <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326195340.dznktutm6yq763af@ast-mbp>
 <87o8sim4rw.fsf@toke.dk>
 <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
 <87o8s9eg5b.fsf@toke.dk>
 <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
 <87h7wlwnyl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h7wlwnyl.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 10:34:58AM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> >> > Currently fentry/fexit/freplace progs have single prog->aux->linked_prog pointer.
> >> > It just needs to become a linked list.
> >> > The api extension could be like this:
> >> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
> >> > (currently it's just bpf_raw_tp_open(prog_fd))
> >> > The same pair of (attach_prog_fd, attach_btf_id) is already passed into prog_load
> >> > to hold the linked_prog and its corresponding btf_id.
> >> > I'm proposing to extend raw_tp_open with this pair as well to
> >> > attach existing fentry/fexit/freplace prog to another target.
> >> > Internally the kernel verify that btf of current linked_prog
> >> > exactly matches to btf of another requested linked_prog and
> >> > if they match it will attach the same prog to two target programs (in case of freplace)
> >> > or two kernel functions (in case of fentry/fexit).
> >> 
> >> API-wise this was exactly what I had in mind as well.
> >
> > perfect!
> 
> Hi Alexei
> 
> I don't suppose you've had a chance to whip up a patch for this, have
> you? :)

On my priority list it's after cap_bpf and sleepable.
If it's urgent for you please start hacking.
