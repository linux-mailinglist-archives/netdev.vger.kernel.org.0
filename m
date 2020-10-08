Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636B528763E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730703AbgJHOjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730668AbgJHOjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:39:00 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2EBEC061755;
        Thu,  8 Oct 2020 07:38:59 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q7so5878337ile.8;
        Thu, 08 Oct 2020 07:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=d2Racxx6iK0pNc2CLbu137mr5AeTeYJhXKRP7tG7ObI=;
        b=uH9ooBSwFLCzXJjZmu3FhYNfCKZaVqLSsAWCOqMpGdMOW0H8I0+gIHcoBnmZLqXO80
         3Fj2HVMRd6tZJFQMRTVXxi33HqPtenuyBrnDbXRrx9tV84dAFQBpmQXLltyyi2m6Pgog
         ptprKAFE9hY8G05t76nAdjzTdbtZHU/V3MjVsZE92Y9P6hAV+OJQDCQv7mapxl3S8bvf
         uLigFGztwl35HjM0SlloNibTtAfL3gd16/NzUeWpQ/A7rgbF2g+6r79llEIVwPzze31b
         QMn7xseRV2wecfvli84FaJBgSe/K6XqQ8vTTyOY+xmKYyHTdejYLD29Gpfab8d6YtojU
         Ir/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=d2Racxx6iK0pNc2CLbu137mr5AeTeYJhXKRP7tG7ObI=;
        b=pFa+O05Qsaz5U0N1r/Qml/btH903ibTOxCAn/emfgZxxdg7gEhzbdDDsFTGi0yTxRP
         0/S9rF19KRRZKeyhAaSdAPUPs4H6Y1h8r6xDhA5h0Jwgy2DKAdgBx/dqq6S7Yha/ioS3
         JN8bwIiLaG5M3LupyfY5i0hKwh1GibY+q8q73mfcD1tWQliqOHn3+q8I2OtfSGdI968E
         7zmhL5yjCoB+7m32qf7jhy/TmSceInKJLqY9ZGP9VtJ7QC7IHzpvxDXycNhEFJKEg/Sw
         I/A6XbPe8j0vFYkOxReSW2qrkqYY+gTlUxutk/wRSAN5GEGrNBCtBhCorUZBqDHOCJT4
         5l/w==
X-Gm-Message-State: AOAM530TI0px0EOzumPUqKUBjLvjkNem3DNTWd2NyGJHfZq2SizzylUu
        2ugahmym7ip+Ny0GSuG8rig=
X-Google-Smtp-Source: ABdhPJwJIX3vRYewkNikOIhqH0ZLyaCY/9UC2nV/gLUAr1kAjdu1C7LtGgbISgalrlhPJYey+09j1g==
X-Received: by 2002:a92:a307:: with SMTP id a7mr6261969ili.97.1602167939157;
        Thu, 08 Oct 2020 07:38:59 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v15sm2778539ile.37.2020.10.08.07.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 07:38:58 -0700 (PDT)
Date:   Thu, 08 Oct 2020 07:38:50 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Tirthendu Sarkar <tirtha@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Message-ID: <5f7f247acf860_2007208c9@john-XPS-13-9370.notmuch>
In-Reply-To: <20201006152845.GC43823@lore-desk>
References: <cover.1601648734.git.lorenzo@kernel.org>
 <5f77467dbc1_38b0208ef@john-XPS-13-9370.notmuch>
 <20201002160623.GA40027@lore-desk>
 <5f776c14d69b3_a6402087e@john-XPS-13-9370.notmuch>
 <20201005115247.72429157@carbon>
 <5f7b8e7a5ebfc_4f19a208ba@john-XPS-13-9370.notmuch>
 <20201005222454.GB3501@localhost.localdomain>
 <5f7bf2b0bf899_4f19a2083f@john-XPS-13-9370.notmuch>
 <20201006093011.36375745@carbon>
 <20201006152845.GC43823@lore-desk>
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
> > On Mon, 05 Oct 2020 21:29:36 -0700
> > John Fastabend <john.fastabend@gmail.com> wrote:
> > 
> > > Lorenzo Bianconi wrote:
> > > > [...]
> > > >   
> > > > > 
> > > > > In general I see no reason to populate these fields before the XDP
> > > > > program runs. Someone needs to convince me why having frags info before
> > > > > program runs is useful. In general headers should be preserved and first
> > > > > frag already included in the data pointers. If users start parsing further
> > > > > they might need it, but this series doesn't provide a way to do that
> > > > > so IMO without those helpers its a bit difficult to debate.  
> > > > 
> > > > We need to populate the skb_shared_info before running the xdp program in order to
> > > > allow the ebpf sanbox to access this data. If we restrict the access to the first
> > > > buffer only I guess we can avoid to do that but I think there is a value allowing
> > > > the xdp program to access this data.  
> > > 
> > > I agree. We could also only populate the fields if the program accesses
> > > the fields.
> > 
> > Notice, a driver will not initialize/use the shared_info area unless
> > there are more segments.  And (we have already established) the xdp->mb
> > bit is guarding BPF-prog from accessing shared_info area. 
> > 
> > > > A possible optimization can be access the shared_info only once before running
> > > > the ebpf program constructing the shared_info using a struct allocated on the
> > > > stack.  
> > > 
> > > Seems interesting, might be a good idea.
> > 
> > It *might* be a good idea ("alloc" shared_info on stack), but we should
> > benchmark this.  The prefetch trick might be fast enough.  But also
> > keep in mind the performance target, as with large size frames the
> > packet-per-sec we need to handle dramatically drop.
> 
> right. I guess we need to define a workload we want to run for the
> xdp multi-buff use-case (e.g. if MTU is 9K we will have ~3 frames
> for each packets and # of pps will be much slower)

Right. Or configuring header split which would give 2 buffers with a much
smaller packet size. This would give some indication of the overhead. Then
we would likely want to look at XDP_TX and XDP_REDIRECT cases. At least
those would be my use cases.

> 
> > 
> > 
> 
> [...]
> 
> > 
> > I do think it makes sense to drop the helpers for now, and focus on how
> > this new multi-buffer frame type is handled in the existing code, and do
> > some benchmarking on higher speed NIC, before the BPF-helper start to
> > lockdown/restrict what we can change/revert as they define UAPI.
> 
> ack, I will drop them in v5.
> 
> Regards,
> Lorenzo
> 
> > 
> > E.g. existing code that need to handle this is existing helper
> > bpf_xdp_adjust_tail, which is something I have broad up before and even
> > described in[1].  Lets make sure existing code works with proposed
> > design, before introducing new helpers (and this makes it easier to
> > revert).
> > 
> > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org#xdp-tail-adjust
> > -- 
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 


