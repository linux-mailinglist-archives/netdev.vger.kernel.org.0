Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205161DDAD3
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 01:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730782AbgEUXQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 19:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730716AbgEUXQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 19:16:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB7FC061A0E;
        Thu, 21 May 2020 16:16:23 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u35so4072181pgk.6;
        Thu, 21 May 2020 16:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=acfVlb2TMgscry80C0vTxbeOFW1Wr/1R1Z7DITt9fyI=;
        b=H0WI9PeWUPnz5xFZ3TBk4SOSYc7YkzDZTRlQKnZVD8rygYaqoTg7tuJYCOkNcMI/Rn
         aKbIQQnm+RzKFX1EUwtskyPGmagQ9oIgX14x26hmYrSKziF2z75WFft1pYIHDPgUEEtk
         et2CA4vb9w7j7A8uvShQs3RoxfoQEyFxtNZUrYFd1WM1Ittv6rbDur6hgwBiCQIJ9LC6
         UgHnkAJoGyPGVcjCLoVEFaF82Re+jNtEO/lDqNRw3e+JB94m2wkfPMmOnby++FivzVTK
         mc8XTdT9IT6EkyKUb0dmhNyxhEDfkdzLFSFUIaMny9BhKA5Nb9UjtSUpNQNUPmrreOkE
         6HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=acfVlb2TMgscry80C0vTxbeOFW1Wr/1R1Z7DITt9fyI=;
        b=EibwXu0I9YujdjrrBf7ojOSePvpAHdA+SZzNgP8VT7kB6SOOLmGdo5tVWVfXK9BRTK
         1UDKIjRUTHmuEkkQvE2KKZZPVyD4byFQ8x9RuSJ4FqNoB6MmpLSoaLiOgO68QTW+ikGF
         XL2I3XegJXjvqOVQUeAXssYtvNtotBOZW6lb6rj9UPV70jYpiNklqxtBbX8GdTRXMwHF
         W8ogsSBsvE+R1HNUfhfp7oq8ReyShytwi9t1GN8w/keaPFI2Fo/G2Ay0ulHQS3rufH/k
         jM0Lyzh8en+x1SMaCCLv0ItqXSiwtWgkBdd0e2ot8wJ2UYyPIKI7BiUfXyixLS9VXURl
         p0WQ==
X-Gm-Message-State: AOAM531HJuqCzRp2/jC361MYFP+EtvwcOfwDAaQaOpHBsX1qXXh12GCk
        ZpSQVm5rPXtcQPmDsJo0I/c=
X-Google-Smtp-Source: ABdhPJyUO688r4+mckiCu+4PrMsc+P6j+ZJXLtSXsUX/2FZ74kwJrRbbi7srOWRy7MaZYN3X0tNvJw==
X-Received: by 2002:a62:25c6:: with SMTP id l189mr1126140pfl.28.1590102982518;
        Thu, 21 May 2020 16:16:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id h4sm5159590pfo.3.2020.05.21.16.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 16:16:21 -0700 (PDT)
Date:   Thu, 21 May 2020 16:16:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/3] bpf: Allow inner map with different
 max_entries
Message-ID: <20200521231618.x3s45pttduqijbjv@ast-mbp.dhcp.thefacebook.com>
References: <20200521191752.3448223-1-kafai@fb.com>
 <CAEf4BzYQmUCbQ-PB2UR5n=WEiCHU3T3zQcQCnjvqCew6rmjGLg@mail.gmail.com>
 <20200521225939.7nmw7l5dk3wf557r@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZyhT6D6F2A+cN6TKvLFoH5GU5QVEVW7ZkG+KQRgJC-1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZyhT6D6F2A+cN6TKvLFoH5GU5QVEVW7ZkG+KQRgJC-1w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 04:10:36PM -0700, Andrii Nakryiko wrote:
> > > 4. Then for size check change, again, it's really much simpler and
> > > cleaner just to have a special case in check in bpf_map_meta_equal for
> > > cases where map size matters.
> > It may be simpler but not necessary less fragile for future map type.
> >
> > I am OK for removing patch 1 and just check for a specific
> > type in patch 2 but I think it is fragile for future map
> > type IMO.
> 
> Well, if we think that the good default needs to be to check size,
> then similar to above, explicitly list stuff that *does not* follow
> the default, i.e., maps that don't want max_elements verification. My
> point still stands.

I think consoldating map properties in bpf_types.h is much cleaner
and less error prone.
I'd only like to tweak the macro in patch 1 to avoid explicit ", 0)".
Can BPF_MAP_TYPE() macro stay as-is and additional macro introduced
for maps with properties ? BPF_MAP_TYPE_FL() ?
Or do some macro magic that the same macro can be used with 2 and 3 args?
