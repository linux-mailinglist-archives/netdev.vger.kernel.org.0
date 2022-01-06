Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D868485FA1
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbiAFEUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiAFEUb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 23:20:31 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9CBC061201;
        Wed,  5 Jan 2022 20:20:31 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso1897306pjb.1;
        Wed, 05 Jan 2022 20:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XFyPWySpG/eTVU9P9gQaXzmlhOo5LJXbONaRr08875g=;
        b=JwKhgb6Q2A3pr1O6mTBTzASepduhzVE+V5J0lpHXPdzyWxfgwmRspLrbqTAxKbs8Qo
         rKMwRyqqzNebgEQ80XUuktg0KXMYVFdTqlN/c5dgr4K/y/gIZ2CUKS/rxsoUvQx6xVGC
         SQyfN1dS29uGf3SdAPN4CUEkq0Exi2cOMitAW2J6xgS25JBkr6JcqRWW4zbZcmX81pJq
         QwWgoQ+9dxsLVpprzRmMNkgKGGEF9h4TSX9qNNHUrPWj0oyEIubM53z0+e8sNASXFmJ/
         rEAi3WRX4mvhlhsXsU4UWLzGF9K/u8bqQgd5DRJGjADFTi84s05iyPNSsrQV3jMHMZP/
         gvPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XFyPWySpG/eTVU9P9gQaXzmlhOo5LJXbONaRr08875g=;
        b=vBKD93jjsOoIclmW3nJtLErpllijwPhwRELcm0rDzhfnw/5zTKFphNHHGHrFkEVee6
         /Yy97jmvhzIj4amCVMrCAXTjjKv33QTowIEHXX98wLurAMRNBLUjSCUb3XGZzVDmFylg
         RzvYwB7cfzwJgI3GtrvAzhKzWYy0pFL4apxXYekNENSjATz1fKJU4E1IxIEXKgWSSLyA
         E7DSlBBShX99ihKu5SFqM0AYc2MkvE6iscHULoLdO80YOWaIxa4mEGSvfUcPS7K/7AzK
         y+++LLVce/jyCC50n7RpCsxHctSCChpfkhhJs6QzsI1YjkkO8NZMRQfNxo0B2w5zRZL8
         mqJw==
X-Gm-Message-State: AOAM532cBwK4+x3115pHJEvUVgKsjjVnRYWt1sbQfeXbtPtN/hk+TjNL
        00zSFabUwxfChR2DsIpyGCo=
X-Google-Smtp-Source: ABdhPJygTiLePf+5dyNrGntX9XvEJMsjQ+3wBbnQMWHeh7Oh9OrP/Qe4ygqMkkHO63yejza3iYuimA==
X-Received: by 2002:a17:90a:bc92:: with SMTP id x18mr7971959pjr.130.1641442830784;
        Wed, 05 Jan 2022 20:20:30 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1a5b])
        by smtp.gmail.com with ESMTPSA id k6sm590615pff.106.2022.01.05.20.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 20:20:30 -0800 (PST)
Date:   Wed, 5 Jan 2022 20:20:27 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 7/7] selftests/bpf: Add selftest for
 XDP_REDIRECT in bpf_prog_run()
Message-ID: <20220106042027.zy6j4a72nxaqmocw@ast-mbp.dhcp.thefacebook.com>
References: <20220103150812.87914-1-toke@redhat.com>
 <20220103150812.87914-8-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220103150812.87914-8-toke@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 04:08:12PM +0100, Toke Høiland-Jørgensen wrote:
> +
> +#define NUM_PKTS 3

May be send a bit more than 3 packets?
Just to test skb_list logic for XDP_PASS.

> +
> +	/* We setup a veth pair that we can not only XDP_REDIRECT packets
> +	 * between, but also route them. The test packet (defined above) has
> +	 * address information so it will be routed back out the same interface
> +	 * after it has been received, which will allow it to be picked up by
> +	 * the XDP program on the destination interface.
> +	 *
> +	 * The XDP program we run with bpf_prog_run() will cycle through all
> +	 * four return codes (DROP/PASS/TX/REDIRECT), so we should end up with
> +	 * NUM_PKTS - 1 packets seen on the dst iface. We match the packets on
> +	 * the UDP payload.
> +	 */
> +	SYS("ip link add veth_src type veth peer name veth_dst");
> +	SYS("ip link set dev veth_src address 00:11:22:33:44:55");
> +	SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
> +	SYS("ip link set dev veth_src up");
> +	SYS("ip link set dev veth_dst up");
> +	SYS("ip addr add dev veth_src fc00::1/64");
> +	SYS("ip addr add dev veth_dst fc00::2/64");
> +	SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb");
> +	SYS("sysctl -w net.ipv6.conf.all.forwarding=1");

These commands pollute current netns. The test has to create its own netns
like other tests do.

The forwarding=1 is odd. Nothing in the comments or commit logs
talks about it.
I'm guessing it's due to patch 6 limitation of picking loopback
for XDP_PASS and XDP_TX, right?
There is ingress_ifindex field in struct xdp_md.
May be use that to setup dev and rxq in test_run in patch 6?
Then there will be no need to hack through forwarding=1 ?
