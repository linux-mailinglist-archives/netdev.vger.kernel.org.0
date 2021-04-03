Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523573534FE
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 19:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhDCRra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 13:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbhDCRr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 13:47:28 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7B8C0613E6;
        Sat,  3 Apr 2021 10:47:26 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e14so3849774plj.2;
        Sat, 03 Apr 2021 10:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aMqC3q3yAP+PRhHyfHb6sOXU6iKAQ26G+msN6ctwe/U=;
        b=MM8I/HCn9NjggsmbOVUE4dFRaa40dMCKk+N69/vwAtOjkg9EpPjsyAzNF7yGZhzSoH
         bMzR0GYE2HeMvjKADEbh2po3MvsO09EQsd9OviK5O0ZvJxLuACuIHJ1QllINe/86dCNX
         cESc1/5t4m+cZe5lyrNfHmbSBnEkTnKxLFduelrokyCGkjb10ldXREoFU4TANnqBjLCS
         lFmv2MNsBn0yolCUFqxKHomdCtfYI2inorMaBqeZMY1jsZkkQMCMsbroHgaIHP8yE7jN
         IdMNm25PZqHGxOl8J1fWR/0zUMayaM9YOQR7rl2ooa7yzk3alUbTL9KP6TVclBaHssYS
         wT/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aMqC3q3yAP+PRhHyfHb6sOXU6iKAQ26G+msN6ctwe/U=;
        b=j3u9zFNNYVe1Gviw+fGeIEYMwNWm760Luqr/pYLpJXShv7Q+n+BA2IZEm7lJGrzEBi
         BXepf/KFgl/kP6sTzVdULMK3R++dpTvNSJAvOCckt9pURoImuEceu99KDEpiMZX8adwV
         VeTO/4U2j9JHsPM2rLQ9SQh5mzbrw2MY5lpnkzOiJ29/VLkxN3hnVABI7w4OcwSL+NBJ
         1IzKHwTvn0GB1xAbgPSA2x1nnaXbD0hI9ce9/nqSQaEmOvmukN8irYqzAwYNPwxGP6ID
         m0fGidch1bbURo1H59w96t75Uboeef3RKFpRlUJkKcUggYhdaCX6WxcOF6wlTaE7qztz
         4CQw==
X-Gm-Message-State: AOAM531fAIl6hzmQYzeX2P+P6ULmZVlWjwIG8vl/zvVvSkZeAZtWuknT
        2gtwvKz+tnbPMTpiR2pzL/Ht3gee2c4=
X-Google-Smtp-Source: ABdhPJw98FxrUA+nG7Dgj63yP9uw4Ls/uaKtpJd0lUtudDmGb99lgUjMghgofjQLVwoS740Zg1zlSg==
X-Received: by 2002:a17:90a:8a0f:: with SMTP id w15mr18919553pjn.200.1617472044863;
        Sat, 03 Apr 2021 10:47:24 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f671])
        by smtp.gmail.com with ESMTPSA id f21sm10709658pfe.6.2021.04.03.10.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 10:47:24 -0700 (PDT)
Date:   Sat, 3 Apr 2021 10:47:21 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
Message-ID: <20210403174721.vg4wle327wvossgl@ast-mbp>
References: <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
 <20210331094400.ldznoctli6fljz64@apollo>
 <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net>
 <20210402152743.dbadpgcmrgjt4eca@apollo>
 <CAADnVQ+wqrEnOGd8E1yp+1WTAx8ZcAx3HUjJs6ipPd0eKmOrgA@mail.gmail.com>
 <20210402190806.nhcgappm3iocvd3d@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402190806.nhcgappm3iocvd3d@apollo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 12:38:06AM +0530, Kumar Kartikeya Dwivedi wrote:
> On Sat, Apr 03, 2021 at 12:02:14AM IST, Alexei Starovoitov wrote:
> > On Fri, Apr 2, 2021 at 8:27 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > [...]
> >
> > All of these things are messy because of tc legacy. bpf tried to follow tc style
> > with cls and act distinction and it didn't quite work. cls with
> > direct-action is the only
> > thing that became mainstream while tc style attach wasn't really addressed.
> > There were several incidents where tc had tens of thousands of progs attached
> > because of this attach/query/index weirdness described above.
> > I think the only way to address this properly is to introduce bpf_link style of
> > attaching to tc. Such bpf_link would support ingress/egress only.
> > direction-action will be implied. There won't be any index and query
> > will be obvious.
> 
> Note that we already have bpf_link support working (without support for pinning
> ofcourse) in a limited way. The ifindex, protocol, parent_id, priority, handle,
> chain_index tuple uniquely identifies a filter, so we stash this in the bpf_link
> and are able to operate on the exact filter during release.

Except they're not unique. The library can stash them, but something else
doing detach via iproute2 or their own netlink calls will detach the prog.
This other app can attach to the same spot a different prog and now
bpf_link__destroy will be detaching somebody else prog.

> > So I would like to propose to take this patch set a step further from
> > what Daniel said:
> > int bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):
> > and make this proposed api to return FD.
> > To detach from tc ingress/egress just close(fd).
> 
> You mean adding an fd-based TC API to the kernel?

yes.

> > The user processes will not conflict with each other and will not accidently
> > detach bpf program that was attached by another user process.
> > Such api will address the existing tc query/attach/detach race race conditions.
> 
> Hmm, I think we do solve the race condition by returning the id. As long as you
> don't misuse the interface and go around deleting filters arbitrarily (i.e. only
> detach using the id), programs won't step over each other's filters. Storing the
> id from the netlink response received during detach also eliminates any
> ambigiuity from probing through get_info after attach. Same goes for actions,
> and the same applies to the bpf_link returning API (which stashes id/index).

There are plenty of tools and libraries out there that do attach/detach of bpf
to tc. Everyone is not going to convert to this new libbpf api overnight.
So 'miuse of the interface' is not a misuse. It's a reality that is going to keep
happening unless the kernel guarantees ownership of the attachment via FD.

> The only advantage of fd would be the possibility of pinning it, and extending
> lifetime of the filter.

Pinning is one of the advantages. The main selling point of FD is ownership
of the attachment.
