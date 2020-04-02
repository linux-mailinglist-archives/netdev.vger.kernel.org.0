Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEAC319CCA2
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 00:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389444AbgDBWBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 18:01:19 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:46993 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388630AbgDBWBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 18:01:19 -0400
Received: by mail-pf1-f172.google.com with SMTP id q3so2402419pff.13;
        Thu, 02 Apr 2020 15:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=37dRGmZCWDfrsr/yQKihQyb75KURA+A7EOa/wR7mD64=;
        b=sjgm/m4AZnRKO6c06PcaXwk/TpffUJrxlvFhAPOdY52ksIYg4p1rGpJYi3yBW1oycB
         WYTDzPxGWQmbb3P8/1v1CbZMbMvnWF86a2Vg+0Qedo05TsaEuZOIvEcdtxFDzKqrFs2V
         pCAwhIFw55F/tj6A/tev91MU5htGoJkKYsUT9oE2n7tyygf/T7g/usOjyWARPFL3K3I7
         ReoMBsQopbU/UmrBoEPe7Dydif8B+61vKqYCFzDlwZmy/eIyPvzeqs0xbSyIhyVsyWWZ
         U8bQdHJMEvE76ITftSiSKCTNXtkSWm0HUvmNWaAq7BnILc4i4NPRq5BbzDRxtJfaZDEk
         91Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=37dRGmZCWDfrsr/yQKihQyb75KURA+A7EOa/wR7mD64=;
        b=TAKY+xb8KAZr6S7NXs0DWoDp46hYt0j1gUv8RvmNTH5oWm7GGjJWTCbImhXuu9SAcl
         /+9i7mLQKG1wzsGeu4YOOJAokOdvsSpg6o5LweJi69+ODwIcBT9i2oFeqVsB/axTcS3H
         R95QgOe6Knx8ebuXNWISi2NC7ObPcw+S2EpN5xvY/48LQI4Ylix3zVtUez3HX4FhTiUD
         ECtdD5VvqVNOoAGwKxfP/9EKHOYfchNo8jSAfz3B7jJifhJ+neG2dcggzVVX+AKtZhSp
         7GJP/29/pYKhA2s2pEuxQaciRfTxtdMpIdnHrosawF2RpoDj4DcrjNoQA+L9CBTMMNeE
         9VuA==
X-Gm-Message-State: AGi0PuasoeCTXCEfa434FyTADBU6psPq/fGyvxH+HraIXjFrB1ig26O0
        AgmpQz19/EDd4emguq4c7nA=
X-Google-Smtp-Source: APiQypIvPfpNLZiQo7v+ODJh0Xn7WIGxyW+UjNFUNhb1e0t9AWYePXCdnmjZks23v7hZxX5C79cQsA==
X-Received: by 2002:a63:fd11:: with SMTP id d17mr5507288pgh.213.1585864877440;
        Thu, 02 Apr 2020 15:01:17 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b3a4])
        by smtp.gmail.com with ESMTPSA id u3sm4555230pfb.36.2020.04.02.15.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 15:01:16 -0700 (PDT)
Date:   Thu, 2 Apr 2020 15:01:13 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
Message-ID: <20200402220113.cqrh6hdjwt4ycvip@ast-mbp>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com>
 <20200326195340.dznktutm6yq763af@ast-mbp>
 <87o8sim4rw.fsf@toke.dk>
 <20200402202156.hq7wpz5vdoajpqp5@ast-mbp>
 <20200402212433.GA12405@rdna-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200402212433.GA12405@rdna-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 02, 2020 at 02:24:33PM -0700, Andrey Ignatov wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> [Thu, 2020-04-02 13:22 -0700]:
> > On Fri, Mar 27, 2020 at 12:11:15PM +0100, Toke Høiland-Jørgensen wrote:
> > > 
> > > Current code is in [0], for those following along. There are two bits of
> > > kernel support missing before I can get it to where I want it for an
> > > initial "release": Atomic replace of the dispatcher (this series), and
> > > the ability to attach an freplace program to more than one "parent".
> > > I'll try to get an RFC out for the latter during the merge window, but
> > > I'll probably need some help in figuring out how to make it safe from
> > > the verifier PoV.
> > 
> > I have some thoughts on the second part "ability to attach an freplace
> > to more than one 'parent'".
> > I think the solution should be more generic than just freplace.
> > fentry/fexit need to have the same feature.
> > Few folks already said that they want to attach fentry to multiple
> > kernel functions. It's similar to what people do with kprobe progs now.
> > (attach to multiple and differentiate attach point based on parent IP)
> > Similarly "bpftool profile" needs it to avoid creating new pair of fentry/fexit
> > progs for every target bpf prog it's collecting stats about.
> > I didn't add this ability to fentry/fexit/freplace only to simplify
> > initial implementation ;) I think the time had come.
> > Currently fentry/fexit/freplace progs have single prog->aux->linked_prog pointer.
> > It just needs to become a linked list.
> > The api extension could be like this:
> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
> > (currently it's just bpf_raw_tp_open(prog_fd))
> > The same pair of (attach_prog_fd, attach_btf_id) is already passed into prog_load
> > to hold the linked_prog and its corresponding btf_id.
> > I'm proposing to extend raw_tp_open with this pair as well to
> > attach existing fentry/fexit/freplace prog to another target.
> > Internally the kernel verify that btf of current linked_prog
> > exactly matches to btf of another requested linked_prog and
> > if they match it will attach the same prog to two target programs (in case of freplace)
> > or two kernel functions (in case of fentry/fexit).
> > 
> > Toke, Andrey,
> > if above kinda makes sense from high level description
> > I can prototype it quickly and then we can discuss details
> > in the patches ?
> > Or we can drill further into details and discuss corner cases.
> 
> That makes sense to me.
> 
> I've also been thinking of a way to "transition" ext prog from one
> target program to another, but I had an impression that limiting number
> of target progs to one for an ext prog is "by design" and hard to
> change, and was looking at introducing a way to duplicate existing ext
> prog by its fd but with different attach_prog_fd and attach_btf_id (smth
> like BPF_PROG_DUP command) instead.

I think cloning the whole program is useful.
iirc cilium folks wanted an ability for clone to have a different 'flavor' of
the program. Like re-verifying and re-optimizing with new dead code elimination
when global data changed. Like loading a prog to manage traffic for one k8
container with given IP, then cloning this prog for a different container with
different IP. So clone is effectively a fast load where the verifier
potentially doesn't need to do full verification of all paths. I think it's
still a useful feature, but for this case, I hope, much simpler approach would do.
