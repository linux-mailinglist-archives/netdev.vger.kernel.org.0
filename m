Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34EB1516E7
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 09:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBDISW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 03:18:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30032 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726566AbgBDISW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 03:18:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580804301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pBGYZLblushYtsXweaHtBpvwr3TbUuhVxGoRYPzdYAM=;
        b=SPRkfazajf/zfUmufCGgUoDBMXQWQ53Cu3tMKiZXBYsA1UnSkO0SGjjaTEbHLfyf77unTS
        jPvNB3LCj+9wuBSbxK+MaCzqVlEkaH2mokarU7Q5RCS075r2FHH9uWc37l6D+dWxjensqz
        +A9G2e2lUnFCx/zFmD1a51fCirMLr14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-ygvo1I3NNG-N31GA9SxjfA-1; Tue, 04 Feb 2020 03:18:18 -0500
X-MC-Unique: ygvo1I3NNG-N31GA9SxjfA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 961431137840;
        Tue,  4 Feb 2020 08:18:16 +0000 (UTC)
Received: from krava (ovpn-205-67.brq.redhat.com [10.40.205.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 470A55D9CA;
        Tue,  4 Feb 2020 08:18:13 +0000 (UTC)
Date:   Tue, 4 Feb 2020 09:18:10 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: Re: [PATCH 5/5] bpf: Allow to resolve bpf trampoline in unwind
Message-ID: <20200204081810.GA1554679@krava>
References: <20191229143740.29143-6-jolsa@kernel.org>
 <20200106234639.fo2ctgkb5vumayyl@ast-mbp>
 <20200107130546.GI290055@krava>
 <76a10338-391a-ffca-9af8-f407265d146a@intel.com>
 <20200113094310.GE35080@krava>
 <a2e2b84e-71dd-e32c-bcf4-09298e9f4ce7@intel.com>
 <9da1c8f9-7ca5-e10b-8931-6871fdbffb23@intel.com>
 <20200113123728.GA120834@krava>
 <20200203195826.GB1535545@krava>
 <8f656ce1-c350-0edd-096b-8f1c395609ec@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <8f656ce1-c350-0edd-096b-8f1c395609ec@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 03, 2020 at 09:27:39PM +0100, Bj=F6rn T=F6pel wrote:
> On 2020-02-03 20:58, Jiri Olsa wrote:
> [...]
> > > > ...and FWIW, it would be nice with bpf_dispatcher_<...> entries i=
n kallsyms
> > >=20
> > > ok so it'd be 'bpf_dispatcher_<name>'
> >=20
> > hi,
> > so the only dispatcher is currently defined as:
> >    DEFINE_BPF_DISPATCHER(bpf_dispatcher_xdp)
> >=20
> > with the bpf_dispatcher_<name> logic it shows in kallsyms as:
> >    ffffffffa0450000 t bpf_dispatcher_bpf_dispatcher_xdp    [bpf]
> >=20
>=20
> Ick! :-P

yea, but it draws attention ;-)

> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index f349e2c0884c..eafe72644282 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -577,7 +577,7 @@ DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
>  	ret; })
>=20
>  #define BPF_PROG_RUN(prog, ctx) __BPF_PROG_RUN(prog, ctx,		\
> -					       bpf_dispatcher_nopfunc)
> +					       bpf_dispatcher_nop_func)
>=20
>  #define BPF_SKB_CB_LEN QDISC_CB_PRIV_LEN
>=20
> @@ -701,7 +701,7 @@ static inline u32 bpf_prog_run_clear_cb(const struc=
t
> bpf_prog *prog,
>  	return res;
>  }
>=20
> -DECLARE_BPF_DISPATCHER(bpf_dispatcher_xdp)
> +DECLARE_BPF_DISPATCHER(xdp)

yep, that's what I prefer ;-) I'll attach your patch
to my kallsyms changes

thanks,
jirka

