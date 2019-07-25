Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61B075BB1
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfGYXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:54:37 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41928 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfGYXyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:54:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so23908917pls.8;
        Thu, 25 Jul 2019 16:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jbjn6X1o+b+RloH7E/SSTLYw0cWzlKuB788mEgA/bpM=;
        b=P+R+4w2MxJZR2ZtX05liUIbVVC5sHJ1cw/fh/WcaeHysDxmi3GzLzGaWIp5i3b7Wpp
         Z5axEdJM0C9BxpHhuJgeIfMtZiJ7OqS55l0Vk59YkWRWJYtV1I/xYiTpcPhaBxl9DoGE
         VWSFrwfLKi5hXTOVrjw1Bg4X9Xatca02BwLVrlB1NQsTop3tDT+bPDNuhMI8GNxI2Ohr
         WdJK53rB4iq8IIAsOClZ9aGiFSX5o+twaXEa8q0fMxEm5tfROzEPOFV0VtctPb/A6xTo
         C9MGQjy1vM0Vo3/n5ReQCnqqIc4dSzextvN953XLWfo+GRG43E2+T7NzSwkUQOaC1mXB
         5uRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jbjn6X1o+b+RloH7E/SSTLYw0cWzlKuB788mEgA/bpM=;
        b=PKjuRydWHLXvoYpOPK71GHMd8Hi+40bwYCPZZ6hPvdi2opVLtixTNhMRG4qMDEEAsH
         a9/UFeikLt7g3pLUhCxZ+lceMlmn1VuqvPWdQuL4l9z/dc2XBePdhNti2DXzLFuQVU1u
         AsFovNX8lc71+SsJcZRFKXMVCbVDhmu3GC6k5yumx6jAMmC0sJhe04CSbanaTZSt8fRl
         AbkBUoGcn+aTeT+cecHK7U8REL0csu+NOJpwRV8zA7pupPp7dXncR+C7aZ61WzIr8r5K
         4h4qq+btUaOYWNJqRmC6Azczm/nN6CKrXGgawKw84E9aMKBRU7Cr5RZenq9BnzFQbHoX
         +fQw==
X-Gm-Message-State: APjAAAWDRVsOdOzT5WX0NLh4KWPscg0qhYUXINiel3OI6UjenrPc1Zks
        tArGygBKDY0W/cG2sQmNB0w=
X-Google-Smtp-Source: APXvYqxZ/3rxr8khd3NQIG7YTDRhwqCZcgL8B3stAATASb/7sIT0JVYywxlJ/HpSESLgObq4pmW5Dw==
X-Received: by 2002:a17:902:7612:: with SMTP id k18mr92208136pll.48.1564098875806;
        Thu, 25 Jul 2019 16:54:35 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::1:85f9])
        by smtp.gmail.com with ESMTPSA id w18sm64466745pfj.37.2019.07.25.16.54.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 16:54:34 -0700 (PDT)
Date:   Thu, 25 Jul 2019 16:54:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
Message-ID: <20190725235432.lkptx3fafegnm2et@ast-mbp>
References: <20190724165803.87470-1-brianvv@google.com>
 <20190724165803.87470-3-brianvv@google.com>
 <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
 <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
 <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
 <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 04:25:53PM -0700, Brian Vazquez wrote:
> > > > If prev_key is deleted before map_get_next_key(), we get the first key
> > > > again. This is pretty weird.
> > >
> > > Yes, I know. But note that the current scenario happens even for the
> > > old interface (imagine you are walking a map from userspace and you
> > > tried get_next_key the prev_key was removed, you will start again from
> > > the beginning without noticing it).
> > > I tried to sent a patch in the past but I was missing some context:
> > > before NULL was used to get the very first_key the interface relied in
> > > a random (non existent) key to retrieve the first_key in the map, and
> > > I was told what we still have to support that scenario.
> >
> > BPF_MAP_DUMP is slightly different, as you may return the first key
> > multiple times in the same call. Also, BPF_MAP_DUMP is new, so we
> > don't have to support legacy scenarios.
> >
> > Since BPF_MAP_DUMP keeps a list of elements. It is possible to try
> > to look up previous keys. Would something down this direction work?
> 
> I've been thinking about it and I think first we need a way to detect
> that since key was not present we got the first_key instead:
> 
> - One solution I had in mind was to explicitly asked for the first key
> with map_get_next_key(map, NULL, first_key) and while walking the map
> check that map_get_next_key(map, prev_key, key) doesn't return the
> same key. This could be done using memcmp.
> - Discussing with Stan, he mentioned that another option is to support
> a flag in map_get_next_key to let it know that we want an error
> instead of the first_key.
> 
> After detecting the problem we also need to define what we want to do,
> here some options:
> 
> a) Return the error to the caller
> b) Try with previous keys if any (which be limited to the keys that we
> have traversed so far in this dump call)
> c) continue with next entries in the map. array is easy just get the
> next valid key (starting on i+1), but hmap might be difficult since
> starting on the next bucket could potentially skip some keys that were
> concurrently added to the same bucket where key used to be, and
> starting on the same bucket could lead us to return repeated elements.
> 
> Or maybe we could support those 3 cases via flags and let the caller
> decide which one to use?

this type of indecision is the reason why I wasn't excited about
batch dumping in the first place and gave 'soft yes' when Stan
mentioned it during lsf/mm/bpf uconf.
We probably shouldn't do it.
It feels this map_dump makes api more complex and doesn't really
give much benefit to the user other than large map dump becomes faster.
I think we gotta solve this problem differently.

