Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E68939C5ED
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 06:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFEEyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 00:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFEEyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 00:54:44 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECCFC061766;
        Fri,  4 Jun 2021 21:52:40 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y15so8909796pfl.4;
        Fri, 04 Jun 2021 21:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UWD95gQ3JprHuJsVesTxvFp9SGOjQceV8uCU80BBLwM=;
        b=I7uwpMWqemLF+QHopkm7rdzKRiakZYCPLK5PUwax4iuVtRMsofP0bDVnGEs3JFrrxx
         RYlfnJNw7VqwqK5lBeUCW1W4fIEgJmUpJ49Xdf3gzPEN3n96MLZgXJ6Qv+Jp65y1NtkA
         d872JQqgaB6kE61ivmLF4EY3ZGlPitfOrapbUmV0UKfTDDG2Qj68Ya3xwjTzDZDchQqN
         pFFECR97vACxYujP+HwOg6QHCL6apB8yft6dSJj14/IswOKhcZ1Ho9X3X+C4/dP86F8J
         SPhoFvg5Zp+L0ywO185zn5pcIFPu/XdCjUIeyZ23THajugRcGYVVTFRVdYrTPLIEXTzR
         bPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UWD95gQ3JprHuJsVesTxvFp9SGOjQceV8uCU80BBLwM=;
        b=Pk2UxqkBOjD8+buYMtcTBzBvBaDj6bK9B2iM65JMz9ySP9UDWtMv3UGMggqNYl5Id2
         Gu1Vf5NrNd5fj32wTnWHL7SSAkVRKnS7d1UbbzaodjEx1qkUy+Vj91n8fB7yVRrz2cO+
         Y99fTTe1UldP+1cp6PvCq1yx3SDyysdQw9f3S/PgWGEYRukm35rRGlItU1HaoM60pizQ
         y+ZdiNzj4cOR+JJOEvXGUE7iH5x+/sBu1FiZmuHtXiuXVmZKD05596B2A+fuUnX+a9ZP
         Wx0O2IGmBcb/QdcNF67XgtZp8og2w9i6J7n2ki0ukM6AeyPDd1TknG22p2tMh9077QCE
         Q+qg==
X-Gm-Message-State: AOAM533/568yS7SQf7JlPmL3O3+q5AKiaeWW9NV3r0ekshOPO8UIOcpx
        IGgy/3n1/cIz008zbhwlwdY=
X-Google-Smtp-Source: ABdhPJzG0VYAeYu+hU5x5AKZSIomiHrhdcguWr6GTFBD8LokrfXxxjkg4Yu4Rg6s73uba9lbtblYKA==
X-Received: by 2002:a65:584d:: with SMTP id s13mr8257498pgr.77.1622868759795;
        Fri, 04 Jun 2021 21:52:39 -0700 (PDT)
Received: from localhost ([2402:3a80:11c3:3c31:71d1:71f6:fb2:d008])
        by smtp.gmail.com with ESMTPSA id w2sm280992pfu.164.2021.06.04.21.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 21:52:39 -0700 (PDT)
Date:   Sat, 5 Jun 2021 10:21:38 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 6/7] libbpf: add bpf_link based TC-BPF
 management API
Message-ID: <20210605045138.7kbnag6e4zjithjm@apollo>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-7-memxor@gmail.com>
 <20210604180157.2ne6loi6yi2pvikg@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604180157.2ne6loi6yi2pvikg@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 11:31:57PM IST, Alexei Starovoitov wrote:
> On Fri, Jun 04, 2021 at 12:01:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> > +/* TC bpf_link related API */
> > +struct bpf_tc_hook;
> > +
> > +struct bpf_tc_link_opts {
> > +	size_t sz;
> > +	__u32 handle;
> > +	__u32 priority;
> > +	__u32 gen_flags;
> > +	size_t :0;
> > +};
>
> Did you think of a way to share struct bpf_tc_opts with above?
> Or use bpf_tc_link_opts inside bpf_tc_opts?

A couple of fields in bpf_tc_opts aren't really relevant here (prog_fd, prog_id)
and will always be unused, so I thought it would be cleaner to give this its own
opts struct. It still reuses the hook abstraction that was added, though.

> Some other way?
> gen_flags here and flags there are the same?

No, it was an oversight that I missed adding gen_flags there, I'll send a patch
separately with some other assorted things. It's used when offloading to HW.

We don't really support any other flags (e.g. BPF_TC_F_REPLACE) for this.

--
Kartikeya
