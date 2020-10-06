Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389392844D3
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 06:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgJFE3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 00:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgJFE3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 00:29:45 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBBBC0613A7;
        Mon,  5 Oct 2020 21:29:45 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u19so11662410ion.3;
        Mon, 05 Oct 2020 21:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=e3La3o/PaCpx3r0ht4G/d6LvHRWphH0B2pGDFYrXkpI=;
        b=ouTfOSoegCuoJ63G5XuAAIot2C7Nt6oHxcRv05bweNVqa4OIcVdxI12KSsiQDsAAz2
         XvpdvdvyER9SCP4iTFJiBhXrH7qQDTKdUaIgNLlYDZmRlpw33FWCa5mnC2GYWPnvE1Qo
         Lw+Icf7N8rjbiSzywDlfvJyu+b/8AtLADSP0knadxRfPb+hjPuMAW5jkvrpr2liAebjw
         LXtpDE7prUZBYH6lfgpW8sB9kxylnUj7fOvih6OYrdS45Nw18RtMEw5NdZ7iZI7gdggL
         WkkCg97AzA2j9azGFSKaXaDRaczy09ECWjWTF3cqRhPWKprHcJVYP5Y87CgumhiNuYoL
         C2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=e3La3o/PaCpx3r0ht4G/d6LvHRWphH0B2pGDFYrXkpI=;
        b=LTtTX4E7dWqbR/IxeNe9mQd1rJu/8zDAA65LbqrOP1uDymQHdGbxTlIgyEbpOaG/DM
         ZTWQHmqydnD0LS555svzhx60kLyaL40nFFwA4k8b6O3qP7UoQDemui7MMDRy0M7KBkw9
         iFecxeqqjV4BjroyxWqMtak3NRE5VhmNF3tRO5k/lNbPoj0ZEbXHu+LG6eguP1w3kTIu
         SkOsrQfWYUxs7KecGMRUTZdIsj2CVNO3l1kwb4U/TGVoj6Qu6ApWKftDJuvcDymzGQU/
         VMQo6D1deMmOOZGozKYk0Br93nSJXeOQxEOtBTvuefSfi6/gI0heeBDwUldMyHVhd7ni
         nZWw==
X-Gm-Message-State: AOAM530ySssVC56LvpzVPaD+KwCJcYFvHnCPI7Y+XH0zFwyUu2/d5Myv
        /pfMNM6D8+vtZ/tjLeTrUXU=
X-Google-Smtp-Source: ABdhPJzPdPSN2LUhlBVng95AzZLUoQU+Epnodjx6nFq3/o5jti/GCGVqWjVwjbwqJ3XSnb0VDhK2Iw==
X-Received: by 2002:a02:c785:: with SMTP id n5mr2975946jao.128.1601958584489;
        Mon, 05 Oct 2020 21:29:44 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m18sm1033864ili.85.2020.10.05.21.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 21:29:43 -0700 (PDT)
Date:   Mon, 05 Oct 2020 21:29:36 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        shayagr@amazon.com, sameehj@amazon.com, dsahern@kernel.org,
        echaudro@redhat.com
Message-ID: <5f7bf2b0bf899_4f19a2083f@john-XPS-13-9370.notmuch>
In-Reply-To: <20201005222454.GB3501@localhost.localdomain>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
 <20201002160623.GA40027@lore-desk>
 <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
 <20201005115247.72429157@carbon>
 <5f7b8e7a5ebfc_4f19a208ba@john-XPS-13-9370.notmuch>
 <20201005222454.GB3501@localhost.localdomain>
Subject: Re: [PATCH v4 bpf-next 00/13] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> [...]
> 
> > 
> > In general I see no reason to populate these fields before the XDP
> > program runs. Someone needs to convince me why having frags info before
> > program runs is useful. In general headers should be preserved and first
> > frag already included in the data pointers. If users start parsing further
> > they might need it, but this series doesn't provide a way to do that
> > so IMO without those helpers its a bit difficult to debate.
> 
> We need to populate the skb_shared_info before running the xdp program in order to
> allow the ebpf sanbox to access this data. If we restrict the access to the first
> buffer only I guess we can avoid to do that but I think there is a value allowing
> the xdp program to access this data.

I agree. We could also only populate the fields if the program accesses
the fields.

> A possible optimization can be access the shared_info only once before running
> the ebpf program constructing the shared_info using a struct allocated on the
> stack.

Seems interesting, might be a good idea.

> Moreover we can define a "xdp_shared_info" struct to alias the skb_shared_info
> one in order to have most on frags elements in the first "shared_info" cache line.
> 
> > 
> > Specifically for XDP_TX case we can just flip the descriptors from RX
> > ring to TX ring and keep moving along. This is going to be ideal on
> > 40/100Gbps nics.
> > 
> > I'm not arguing that its likely possible to put some prefetch logic
> > in there and keep the pipe full, but I would need to see that on
> > a 100gbps nic to be convinced the details here are going to work. Or
> > at minimum a 40gbps nic.
> > 
> > > 
> > > 
> 
> [...]
> 
> > Not against it, but these things are a bit tricky. Couple things I still
> > want to see/understand
> > 
> >  - Lets see a 40gbps use a prefetch and verify it works in practice
> >  - Explain why we can't just do this after XDP program runs
> 
> how can we allow the ebpf program to access paged data if we do not do that?

I don't see an easy way, but also this series doesn't have the data
access support.

Its hard to tell until we get at least a 40gbps nic if my concern about
performance is real or not. Prefetching smartly could resolve some of the
issue I guess.

If the Intel folks are working on it I think waiting would be great. Otherwise
at minimum drop the helpers and be prepared to revert things if needed.

> 
> >  - How will we read data in the frag list if we need to parse headers
> >    inside the frags[].
> > 
> > The above would be best to answer now rather than later IMO.
> > 
> > Thanks,
> > John
> 
> Regards,
> Lorenzo


