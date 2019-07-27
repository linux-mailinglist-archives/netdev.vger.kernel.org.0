Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DEE77555
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 02:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfG0ACm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 20:02:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35345 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfG0ACm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 20:02:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id r21so40392941qke.2
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 17:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Omap8MuSNMpMlJrwRp0fKJkqfN+/zphM0XGrQBpUabM=;
        b=clqDqJ1//MGOVtqTMSnfGsZuoRX62xv3sT/E8ZGARanP+4aCirNJ3jWMzmmHGfSlvO
         cdkcym/mah5SCx1R3OZNJ110ZxKD4HxwA5w2UUzOgs0JNZxIs4NomIPUf6YzekokepNJ
         qhFqrg8ua0D17hSDOb2GA8fBzk/NExbzL6hLuBpCD8O/ikJQSgnvHsroOby64Ho5FD4D
         LzBfm5mLWDQKKjfeEOeW818q3LoncLmQigfiKuVbe2niQ5mpdQASaLfucj7XpdMIPjt9
         +ApbOna2NDr8lKUenskQbM8/7JAC1WpeBBSV131ibx7FzgUjvU7sUnSbp2PZeC62V9bI
         zB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Omap8MuSNMpMlJrwRp0fKJkqfN+/zphM0XGrQBpUabM=;
        b=hz6TN6k8BV1Ic1weMwMY1j07e5dE3/CM5G9vdcGKq9FooNiPO4NU1Cs/SX+zzNSjOi
         lRFsGXSSqqPuscFff9iU8xaOoGfsgXE9j7QewpVdVo6fng9rWGn/9hiAAMqlrvg/tCUJ
         uQYKuYXQ0dHYMLs/SKY+0oxp4IXYql3Z4YFWIA1++4voXUJ9YLFVOE2+IbrlFtd8WrCH
         Vz/KBWD4ho9oqbPf/oNMEpmojcRH90zZ/ZxPKOzjxknQD9mTS91CwJOIBIzrscyCMKvj
         fAZMTVwBDdMP2cMuiZ8sP6kHwRQKMYa23p11yXgamdMKGkXaRto+zgfg8fiS4LkoTbnm
         pKLQ==
X-Gm-Message-State: APjAAAVrRqNoU6QVT5kdVRy/Ro6vwtcDBDveBwPzd2eD2E0DINSpCQiq
        KaxTKl6Dgec00w0W30BfluBUGA==
X-Google-Smtp-Source: APXvYqwiAhO29aqc1TWS9CHsGzin0qBUhjL1vEgMm2TRG7Af7yQnXcCdG0sw5cKoWmyvyUw4H23agQ==
X-Received: by 2002:a37:9644:: with SMTP id y65mr64328377qkd.191.1564185761194;
        Fri, 26 Jul 2019 17:02:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q32sm23122415qtd.79.2019.07.26.17.02.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 17:02:40 -0700 (PDT)
Date:   Fri, 26 Jul 2019 17:02:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/6] bpf: add BPF_MAP_DUMP command to dump more
 than one entry per call
Message-ID: <20190726170234.1b925a97@cakuba.netronome.com>
In-Reply-To: <CABCgpaVB+iDGO132d9CTtC_GYiKJuuL6pe5_Krm3-THgvfMO=A@mail.gmail.com>
References: <20190724165803.87470-1-brianvv@google.com>
        <20190724165803.87470-3-brianvv@google.com>
        <CAPhsuW4HPjXE+zZGmPM9GVPgnVieRr0WOuXfM0W6ec3SB4imDw@mail.gmail.com>
        <CABCgpaXz4hO=iGoswdqYBECWE5eu2AdUgms=hyfKnqz7E+ZgNg@mail.gmail.com>
        <CAPhsuW5NzzeDmNmgqRh0kwHnoQfaD90L44NJ9AbydG_tGJkKiQ@mail.gmail.com>
        <CABCgpaV7mj5DhFqh44rUNVj5XMAyP+n79LrMobW_=DfvEaS4BQ@mail.gmail.com>
        <20190725235432.lkptx3fafegnm2et@ast-mbp>
        <CABCgpaXE=dkBcJVqs95NZQTFuznA-q64kYPEcbvmYvAJ4wSp1A@mail.gmail.com>
        <CAADnVQJpp37fXLsu8ZnMFPoC0Uof3roz4gofX0QCewNkwtf-Xg@mail.gmail.com>
        <beb513cb-2d76-30d4-6500-2892c6566a7e@fb.com>
        <CABCgpaVB+iDGO132d9CTtC_GYiKJuuL6pe5_Krm3-THgvfMO=A@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Jul 2019 16:36:19 -0700, Brian Vazquez wrote:
> > In bcc, we have many instances like this:
> >     getting all (key value) pairs, do some analysis and output,
> >     delete all keys
> >
> > The implementation typically like
> >     /* to get all (key, value) pairs */
> >     while(bpf_get_next_key() == 0)
> >       bpf_map_lookup()
> >     /* do analysis and output */
> >     for (all keys)
> >       bpf_map_delete()  
> 
> If you do that in a map that is being modified while you are doing the
> analysis and output, you will lose some new data by deleting the keys,
> right?
> 
> > get_next+lookup+delete will be definitely useful.
> > batching will be even better to save the number of syscalls.
> >
> > An alternative is to do batch get_next+lookup and batch delete
> > to achieve similar goal as the above code.  
> 
> What I mentioned above is what it makes me think that with the
> deletion it'd be better if we perform these 3 operations at once:
> get_next+lookup+delete in a jumbo/atomic command and batch them later?

Hm. The lookup+delete are only "atomic" if we insert an RCU sync in
between right? The elements' lifetime is protected by RCU.

	CPU 1				CPU 2
					val = lookup(map, key)				
	val = lookup(map, key)
	delete(map, key)
	dump(val)
					val->counter++

So we'd need to walk the hash table, disconnect all lists from the
buckets and splice them onto one combined list, then synchronize_rcu()
and only after that we can dump the elements and free them.

> > There is a minor difference between this approach
> > and the above get_next+lookup+delete.
> > During scanning the hash map, get_next+lookup may get less number
> > of elements compared to get_next+lookup+delete as the latter
> > may have more later-inserted hash elements after the operation
> > start. But both are inaccurate, so probably the difference
> > is minor.

> > For not changing map, looping of (get_next, lookup) and batch
> > get_next+lookup should have the same results.  
> 
> This is true for the api I'm presenting the only think that I was
> missing was what to do for changing maps to avoid the weird scenario
> (getting the first key due a concurrent deletion). And, in my opinion
> the way to go should be what also Willem supported: return the err to
> the caller and restart the dumping. I could do this with existing code
> just by detecting that we do provide a prev_key and got the first_key
> instead of the next_key or even implement a new function if you want
> to.

My knee jerk reaction to Willem's proposal was to nit pick that sizing
the dump space to the map's max entries doesn't guarantee all entries
will fit if an entry can be removed and re-added in a different place
while dumper proceeds.

If we keep elements disconnected from the hash array _without_
decrementing element count until synchronize_rcu() completes we have
that guarantee, but OTOH it may not be possible to add any new entries
from the datapath, so that doesn't sound great either :/
