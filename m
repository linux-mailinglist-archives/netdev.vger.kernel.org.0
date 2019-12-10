Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0A12117FF2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 06:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfLJFur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 00:50:47 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41157 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfLJFur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 00:50:47 -0500
Received: by mail-pl1-f194.google.com with SMTP id bd4so6823502plb.8;
        Mon, 09 Dec 2019 21:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=LpfXDvbapYrtg2l9Hr3hABTZc33lhuy5qq0ylk91X+Q=;
        b=qSwxAN8b8Gv8Vv+oD2m09XI18cpBuYrhV1pp+1XYvxa9rRTky+MnJw1WlTokgVMFyO
         52G8hm9jR4EPSkVoXrdGQ+UAtxeczBiKa8Cz8Qo2wAkuOvAZiATuDodP/eTZrLdRVcad
         nrX3pWYwihC+nlpY46x6jc1MvsUmeZ+wVhQfRXqkIp+/R7fh4TjbGbS6vOUBaiTAfD/y
         semHCL1N6G+RV3Cj+upWk9anr2+tOr1gFfDlxZXBKGZ15m6R7ghP2u+UNlJof8cF7YGa
         t5+lYUsa8L6ae6yCBJYHOjaeTAj/gSm0LhsqaS63zlPjtfC3X+Ozu9pAxb1NQi+vUWEQ
         ETUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=LpfXDvbapYrtg2l9Hr3hABTZc33lhuy5qq0ylk91X+Q=;
        b=jyiQ5efiGGAawoAhESzN5v7mXBnu0HDK/6IAQL8bDm73HJueSWymaYRwb3bgvnP2lf
         xZivQLMt4QtVn/vNwFmV7Y38YAlLdc1SGmUgd4Fnv0ZV/Ap+2LFHx8hv42tJUnC0dQHj
         TaxsMdEX8+R3udRL+FfB9U2cxonYYlZc/8p0LzPCtKLWwop7E//lQiD3cGQAxihCpRD+
         epBjitaPF5RMIGFKzUpBX1S1MyqRmC30sKRnqJ6aonKSO+qT9R5sG1wfBe3I4v9QJ6aH
         SNwUnLKu6dVsoAqvfFYC6awcIMdXt26BxVO65kXNTfH/J8iN5qe2BD8iZ1aoiNCex8Yy
         7hwQ==
X-Gm-Message-State: APjAAAVlbGTyg+y2IdZHTkKg5VZdPeAMVw6ak1+IQ/CABTevTTmJzQjF
        y2bb3ohf69Iuv9K1d0kI/Qt+BDAF
X-Google-Smtp-Source: APXvYqxkQS5Qic7jTIUe4u8UBv/DEH4ck1R2GRCjzrKZzvAcB5b/OBMynr3+4Ols/OFhd0D/4nM5wQ==
X-Received: by 2002:a17:90a:e2ce:: with SMTP id fr14mr3358388pjb.99.1575957046274;
        Mon, 09 Dec 2019 21:50:46 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::ef95])
        by smtp.gmail.com with ESMTPSA id y199sm1459100pfb.137.2019.12.09.21.50.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Dec 2019 21:50:45 -0800 (PST)
Date:   Mon, 9 Dec 2019 21:50:43 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: Re: [PATCH bpf-next v3 2/6] bpf: introduce BPF dispatcher
Message-ID: <20191210055042.bhvm2gw633ts2gmg@ast-mbp.dhcp.thefacebook.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
 <20191209135522.16576-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191209135522.16576-3-bjorn.topel@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:55:18PM +0100, Björn Töpel wrote:
> +
> +struct bpf_disp_prog {
> +	struct bpf_prog *prog;
> +	refcount_t users;
> +};
> +
> +struct bpf_dispatcher {
> +	void *func;
> +	struct bpf_disp_prog progs[BPF_DISPATCHER_MAX];
> +	int num_progs;
> +	void *image;
> +	u32 image_off;
> +};
> +
> +static struct bpf_dispatcher *bpf_disp;
> +
> +static DEFINE_MUTEX(dispatcher_mutex);
> +
> +static struct bpf_dispatcher *bpf_dispatcher_lookup(void *func)
> +{
> +	struct bpf_dispatcher *d;
> +	void *image;
> +
> +	if (bpf_disp) {
> +		if (bpf_disp->func != func)
> +			return NULL;
> +		return bpf_disp;
> +	}
> +
> +	d = kzalloc(sizeof(*d), GFP_KERNEL);
> +	if (!d)
> +		return NULL;

The bpf_dispatcher_lookup() above makes this dispatch logic a bit difficult to
extend, since it works for only one bpf_disp and additional dispatchers would
need hash table. Yet your numbers show that even with retpoline=off there is a
performance benefit. So dispatcher probably can be reused almost as-is to
accelerate sched_cls programs.
What I was trying to say in my previous feedback on this subject is that
lookup() doesn't need to exist. That 'void *func' doesn't need to be a function
that dispatcher uses. It can be 'struct bpf_dispatcher *' instead.
And lookup() becomes init().
Then bpf_dispatcher_change_prog() will be passing &bpf_dispatcher_xdp
and bpf_dispatcher_xdp is defined via macro that supplies
'struct bpf_dispatcher' above and instantiated in particular .c file
that used that macro. Then dispatcher can be used in more than one place.
No need for hash table. Multiple dispatchers are instantiated in places
that need them via macro.
The code will look like:
bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog)
{
   bpf_dispatcher_change_prog(&bpf_dispatcher_xdp, prev_prog, prog);
}
Similarly sched_cls dispatcher for skb progs will do:
   bpf_dispatcher_change_prog(&bpf_dispatcher_tc, prev_prog, prog);
wdyt?

