Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1488E1EB1BD
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgFAWbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAWbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:31:51 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB7AC061A0E;
        Mon,  1 Jun 2020 15:31:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d6so474907pjs.3;
        Mon, 01 Jun 2020 15:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TaL9dBLflepRYzoRLaZFanEEmw69HewulymdvVbPJiQ=;
        b=Ej6mEz13A1I/PIEnfB0zEr+K2X4sJ7B2kFZbGaj3HaaJbufV0Vy/lVSjbaoXTPgt/U
         5fqdWTWacgYqBNyEHRNfrJBremKWeIJcTYvjZseHiGCMWI+iU9b7ER2tcbtUeoGMmCrY
         Es3M9eRYXnIvLtw1fUHzsSwSAljH0rDchVF5DroRdC+jnYuJ3EozmIiICAdBDcbrGUaz
         qlxiSVnTdnYcosz1oq32Q2B/oMNvEszmPWJFgmBiX/b/H0sqw+d1mfcUvCBOP+3cTraV
         w9LPJRTufJvuUroxKYNWNq4elW/DRSGggflJk262lghAGAWD0fMWTq5iiOeVV4VOMpgF
         iwPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TaL9dBLflepRYzoRLaZFanEEmw69HewulymdvVbPJiQ=;
        b=TAdAXV2uI0MoBKZY2rSB0TQBGONhRoQd6FS6nOoLNZjuTq8wcpqn02MczSBc7+d5LP
         3V7/jwzW/Gr8gNeBWG28jf+Tz48V05yPg/uFArvQHhoXsL+UXMw6uv2Hn8wUdWLnwrrX
         UT1mnFjukA70sRblVE5gl4DGM9VDBf98pWYnTy7A34aumtX3EhZa5gf7J5vCzqVZGqYi
         Cq/pG29qdR5DdYQVbL/TKqX/LdsMHxlbZlturSFVsjXzwprHRL4gjJhY+P5UWqEJvKV7
         PVyogpZMB0g8hcWPO1HcHoNu/hdkCu0YdQ1m2pLA8aleNQQz7WhPD4+6S26bHM/PV8nX
         7nJQ==
X-Gm-Message-State: AOAM5321QJg62zEYH/VD22KPU8xHFTLSdDjPu/laA4MZ+qqmbTDKi/rc
        OIB2UbeR5tc84OhqRRYh06IgtI0j
X-Google-Smtp-Source: ABdhPJyOoPJLBwFk1aceBWA7ggfa15g8836ZqkW+xNAY/tYxQ4YLJmQphAvrgEjyaOD4kr6tZ9xQNQ==
X-Received: by 2002:a17:902:7e41:: with SMTP id a1mr21844801pln.72.1591050711026;
        Mon, 01 Jun 2020 15:31:51 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id 140sm370953pfv.38.2020.06.01.15.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 15:31:50 -0700 (PDT)
Date:   Mon, 1 Jun 2020 15:31:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v4 bpf-next 0/5] bpf: Add support for XDP programs in
 DEVMAP entries
Message-ID: <20200601223146.bghhao75rzpdk3kx@ast-mbp.dhcp.thefacebook.com>
References: <20200529220716.75383-1-dsahern@kernel.org>
 <CAADnVQK1rzFfzcQX-EGW57=O2xnz2pjX5madnZGTiAsKnCmbHA@mail.gmail.com>
 <ed66bdc6-4114-2ecf-1812-176d0250730b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ed66bdc6-4114-2ecf-1812-176d0250730b@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 01, 2020 at 04:28:02PM -0600, David Ahern wrote:
> On 6/1/20 3:12 PM, Alexei Starovoitov wrote:
> > In patch 5 I had to fix:
> > /data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c:
> > In function ‘test_neg_xdp_devmap_helpers’:
> > /data/users/ast/net-next/tools/testing/selftests/bpf/test_progs.h:106:3:
> > warning: ‘duration’ may be used uninitialized in this function
> > [-Wmaybe-uninitialized]
> >   106 |   fprintf(stdout, "%s:PASS:%s %d nsec\n",   \
> >       |   ^~~~~~~
> > /data/users/ast/net-next/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c:79:8:
> > note: ‘duration’ was declared here
> >    79 |  __u32 duration;
> 
> What compiler version? it compiles cleanly with ubuntu 20.04 and gcc
> 9.3. The other prog_tests are inconsistent with initializing it.

official rhel's devtoolset-9
gcc version 9.1.1 20190605 (Red Hat 9.1.1-2) (GCC)

> > 
> > and that selftest is imo too primitive.
> 
> I focused the selftests on API changes introduced by this set - new
> attach type, valid accesses to egress_ifindex and not allowing devmap
> programs with xdp generic.
> 
> > It's only loading progs and not executing them.
> > Could you please add prog_test_run to it?
> > 
> 
> I will look into it.

Thanks!
