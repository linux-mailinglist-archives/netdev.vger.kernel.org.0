Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF6F1B23A3
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgDUKPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:15:07 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59470 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbgDUKPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:15:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587464103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JMXCCN2HDOIJrfbYQQ/wgmrrJgdlZiV7fsSSc0nzaH4=;
        b=J+/oASgDFb+5qxsrDcOL0iEL0OX64xOTmxbXPhXY70Nmoy7jUvnVG6aupubELzqxEtKlyJ
        GZXssomKlKxnhP3crSJATlmWCURARMjrVAinEtuSa+YGaMs616Qx/zYycjtfSrsOBVdxvx
        Q1INf0BA7N3ye4WewkQdzztaPtpGs8s=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-MYyaG7fWNmKxFC2HYCCTKQ-1; Tue, 21 Apr 2020 06:15:01 -0400
X-MC-Unique: MYyaG7fWNmKxFC2HYCCTKQ-1
Received: by mail-lj1-f197.google.com with SMTP id c2so1986742ljj.2
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 03:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JMXCCN2HDOIJrfbYQQ/wgmrrJgdlZiV7fsSSc0nzaH4=;
        b=TRhO91k4Gf9fAIMEpZoPcUU9neH9EdkgkIx8zBY9I2aWsOBuP3TrxVXUuEuZTElZWg
         u9m9iR0d/tKLI5RqIZExo7SfGLJeFoSo4yx69PRb7a2OiLodpSY9vFz81tzcyh5F0iE1
         Xh/E9nBsD4tUZgxxiCWLznUjC1uu3TTpFkPYphO3becb2EJnsYoYG8ndn5Zydto96sI8
         nG3HRLpp7jh8qPJZsGSAk3Bx5seWtJr3QKAfXJpaks0GKgZ7M8SeqoaE3/LJwOSB3246
         gV6j+jLkvyu+qZODCJQrianAJ1uGJHtzuNlrcEehshHPMjRydXxyZUiOWu80VAbHDf5I
         1TXw==
X-Gm-Message-State: AGi0PubFu71xDwBWaxVXKTV1A0cAQuG3L+o8Un1OalCnfNRpsNyu1OBo
        UA7wu6aQL+LHpGoXDOf8uZfGHZ2wqTJK4OTS3jr+tvhJD93VUPvZIqWcjcuFwcBArZtgcl10Fef
        YpTi5OGXblA1/k92O
X-Received: by 2002:a19:4a03:: with SMTP id x3mr13325522lfa.159.1587464099110;
        Tue, 21 Apr 2020 03:14:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypLPugM2/PIyyWx1s9aYMf1aiV6E8MHVxMDi5D07/bBVKY5tY0Z89rNA6L/uGBl4gVVrL4zQcQ==
X-Received: by 2002:a19:4a03:: with SMTP id x3mr13325502lfa.159.1587464098838;
        Tue, 21 Apr 2020 03:14:58 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w16sm1513572ljd.101.2020.04.21.03.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 03:14:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5453418157F; Tue, 21 Apr 2020 12:14:56 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <20200420200055.49033-5-dsahern@kernel.org>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-5-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Apr 2020 12:14:56 +0200
Message-ID: <87ftcx9mcf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> Add new bpf_attach_type, BPF_XDP_EGRESS, for BPF programs attached
> at the XDP layer, but the egress path.
>
> Since egress path will not have ingress_ifindex and rx_queue_index
> set, update xdp_is_valid_access to block access to these entries in
> the xdp context when a program is attached to egress path.
>
> Update dev_change_xdp_fd to verify expected_attach_type for a program
> is BPF_XDP_EGRESS if egress argument is set.
>
> The next patch adds support for the egress ifindex.
>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  include/uapi/linux/bpf.h       |  1 +
>  net/core/dev.c                 | 11 +++++++++++
>  net/core/filter.c              |  8 ++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  4 files changed, 21 insertions(+)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 2e29a671d67e..a9d384998e8b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -215,6 +215,7 @@ enum bpf_attach_type {
>  	BPF_TRACE_FEXIT,
>  	BPF_MODIFY_RETURN,
>  	BPF_LSM_MAC,
> +	BPF_XDP_EGRESS,
>  	__MAX_BPF_ATTACH_TYPE
>  };
>  
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 97180458e7cb..e8a62bdb395b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8732,6 +8732,17 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
>  		if (IS_ERR(prog))
>  			return PTR_ERR(prog);
>  
> +		if (egress && prog->expected_attach_type != BPF_XDP_EGRESS) {
> +			NL_SET_ERR_MSG(extack, "XDP program in Tx path must use BPF_XDP_EGRESS attach type");
> +			bpf_prog_put(prog);
> +			return -EINVAL;
> +		}
> +		if (!egress && prog->expected_attach_type == BPF_XDP_EGRESS) {
> +			NL_SET_ERR_MSG(extack, "XDP program in Rx path can not use BPF_XDP_EGRESS attach type");
> +			bpf_prog_put(prog);
> +			return -EINVAL;
> +		}
> +
>  		if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
>  			NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
>  			bpf_prog_put(prog);
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7d6ceaa54d21..bcb56448f336 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6935,6 +6935,14 @@ static bool xdp_is_valid_access(int off, int size,
>  				const struct bpf_prog *prog,
>  				struct bpf_insn_access_aux *info)
>  {
> +	if (prog->expected_attach_type == BPF_XDP_EGRESS) {
> +		switch (off) {
> +		case offsetof(struct xdp_md, ingress_ifindex):
> +		case offsetof(struct xdp_md, rx_queue_index):
> +			return false;
> +		}
> +	}

As I pointed out on the RFC patch, I'm concerned whether this will work
right with freplace programs attaching to XDP programs. It may just be
that I'm missing something, but in that case please explain why it
works? :)

-Toke

