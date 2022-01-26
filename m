Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AC949C93E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241058AbiAZMFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiAZMFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 07:05:39 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C30BC06161C;
        Wed, 26 Jan 2022 04:05:39 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id o11so5774607pjf.0;
        Wed, 26 Jan 2022 04:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZARXyeQlg5luOscbsmArF8xVktdStoU7fcfRA8fZs8I=;
        b=JayHx62MZ+0zcrjWO1RAPU3RqTz9Bz61ccATR2p+3qMcvidz/I9DLqC3siKcQVK8gP
         UjajrXNOo54Fp3GtJFxnDd1H8fq/1rCP23zZI5XqncDWtYnKUCTpxQCnPnlp0JNOhJV/
         8OQ9u0hiN0XVwlLhGzdf6W3xem2TMrkNDqoviS+N0sOypRhOlN627QOkYyuAn0l/G2Pa
         M4efcltDxoKA+fIhjlNIU23KJuJN+zyhDhjmlSf31tT0YQmd/DtYZAl2AEo8XkAy0qc5
         0B73P/vpq7m6cMd1cSjzP//+AAnj6tzCYJ8i736Kzhfj3vWEuQfemWiP+aMzRdB1a/mx
         f1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZARXyeQlg5luOscbsmArF8xVktdStoU7fcfRA8fZs8I=;
        b=GHBFFsG4VrVjAvqolHetHAPjfkfRtoN2ToAweitW2840W6GbxwXrtI3RKv733VMHH3
         kcBGrkdSdMbrr2/0pEsmLyhReb5JgNd38C2T2RYV4jeOY+lj4/yLbIVx8uaX0NOTDzkb
         tQOf/4eU53AMlcwHsXns03ZRKvQBYxIu57nTITU5mKxK5f1gMTo/hQC/ZHLqAN3E2ShK
         2nz9JmclrV4UK1m0GMUFvYoDwoIUKP9aoJxBMHRNFz8RFbwWoXkE2UrxNhE80t4924wB
         K4H7Ux9EjQaagU5O2DoZpxk17UPtmwObhqz2ai0GH0k4E1vcFZDRpStVjsWkuho76UKN
         y4sw==
X-Gm-Message-State: AOAM532wsBP3YxxG+0q1H4+D/3vUu+1ir7P7GQj+POe7vtR4IH5mYvDO
        YMTOCU7UtRE9DGjUia5ThZU=
X-Google-Smtp-Source: ABdhPJx06AZgoeK3Rdg74ijUBLl5ANnsa5saw8byqAabmNu2S63YN13jRwnPoQjiElRhDCBiizllHg==
X-Received: by 2002:a17:90b:4f44:: with SMTP id pj4mr8417288pjb.167.1643198738903;
        Wed, 26 Jan 2022 04:05:38 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id n4sm4987900pjf.0.2022.01.26.04.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 04:05:38 -0800 (PST)
Date:   Wed, 26 Jan 2022 17:33:47 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Message-ID: <20220126120347.cp3xvuxkwyi2o5wx@apollo.legion>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <878rv558fy.fsf@toke.dk>
 <YfEzl0wL+51wa6z7@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfEzl0wL+51wa6z7@lore-desk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 05:12:15PM IST, Lorenzo Bianconi wrote:
> > [ snip to focus on the API ]
> >
> > > +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> > > +				  struct bpf_fdb_lookup *opt,
> > > +				  u32 opt__sz)
> > > +{
> > > +	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
> > > +	struct net_bridge_port *port;
> > > +	struct net_device *dev;
> > > +	int ret = -ENODEV;
> > > +
> > > +	BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) != NF_BPF_FDB_OPTS_SZ);
> > > +	if (!opt || opt__sz != sizeof(struct bpf_fdb_lookup))
> > > +		return -ENODEV;
> >
> > Why is the BUILD_BUG_ON needed? Or why is the NF_BPF_FDB_OPTS_SZ
> > constant even needed?
>
> I added it to be symmetric with respect to ct counterpart

But the constant needs to be an enum, not a define, otherwise it will not be
emitted to BTF, I added it so that one could easily check the struct 'version'
(because sizeof is not relocated in BPF programs).

Yes, bpf_core_field_exists and would also work, but the size is fixed anyway and
we need to check it, so it felt better to give it a name and also make it
visible to BPF programs at the same time.

>
>  [...]

--
Kartikeya
