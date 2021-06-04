Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8737D39BF3B
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFDSDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhFDSDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:03:49 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5962C061766;
        Fri,  4 Jun 2021 11:02:02 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y15so8006979pfl.4;
        Fri, 04 Jun 2021 11:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ADE2p/hPP5/U8XcqFG37FbK0JSAx4yTGIaCLDWMtCw=;
        b=BQrls1J+rNWjCtH2BHV9tzWENmVdXCAY58VxjDRB1+dSK1eXW5IyzAzjQBogrT6yWz
         Okz6PeEApAv7l0VSodmCHFv6MIkRa0NpVUkKmuInr5zTvATWiISNplgUxGhhFa9JE6XE
         JqKlC72flN/jcsrL6cQQOq5tEtodXiULfQBCRj5HtbZjA+fP2M1FRG4sdNRSkf91HcVe
         2Tiv7WZahDZdBPsMMDfSKtZ70Bzrc3F+JevoHhaBHadL4mZxdp5jyQVjmh+fnckxSI3n
         8W9euJvjEYBVqPFH4jJlvMZpVkBEiSHZIKUHEBmHrB6sdvGZwh5cMok2Fd6FQ5WWGv28
         tkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ADE2p/hPP5/U8XcqFG37FbK0JSAx4yTGIaCLDWMtCw=;
        b=BxZWUo9q9mhhbNmk1iDWd/JKlysxy/16GdH1l+GwTO9fjNCa2qOH9Q186TI6dTH80K
         ZIfypMBGWGe6XnByrjLpiKo7SsYpHYCIy8dw79DhleyveLSb1DTaCYMP3663BtKOphKL
         N9y2d9+m1TWAkguz5bI+yM4OpE8mSr/ebEdEFPCJd4DC5N8HShIiwYhMWvcK/Vm4ODOz
         fBEifx8ZbV8MBrYatbe8/cpyugg1w5XxRl3S7Rhdfi7atVIYnsba8F/q4avXrhj35vg8
         Q5rXIcTIWZSp97+PfPi46zcgcQW/jb6A8UOf/E7ib8IYnjB/H3GzuSp61rtvwTXODrCO
         4Cng==
X-Gm-Message-State: AOAM531BtZzEwhQtHlia1PDg4mMWgFnY1NfJK6JtIZ7HQ7iitY/ZLzPj
        2l/Sf8w7W/unp4sHsNleKeg=
X-Google-Smtp-Source: ABdhPJxDSQ9VKQQjUUKPVFc1yrP0oN4lJFgT5uw9cCssMxLdbkwZWDCT99GwknkDRM6sQm/+gO4DrA==
X-Received: by 2002:a63:974a:: with SMTP id d10mr6377394pgo.180.1622829721448;
        Fri, 04 Jun 2021 11:02:01 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:862d])
        by smtp.gmail.com with ESMTPSA id r25sm2424116pfh.18.2021.06.04.11.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 11:02:00 -0700 (PDT)
Date:   Fri, 4 Jun 2021 11:01:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20210604180157.2ne6loi6yi2pvikg@ast-mbp.dhcp.thefacebook.com>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-7-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604063116.234316-7-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 12:01:15PM +0530, Kumar Kartikeya Dwivedi wrote:
> +/* TC bpf_link related API */
> +struct bpf_tc_hook;
> +
> +struct bpf_tc_link_opts {
> +	size_t sz;
> +	__u32 handle;
> +	__u32 priority;
> +	__u32 gen_flags;
> +	size_t :0;
> +};

Did you think of a way to share struct bpf_tc_opts with above?
Or use bpf_tc_link_opts inside bpf_tc_opts? 
Some other way?
gen_flags here and flags there are the same?
