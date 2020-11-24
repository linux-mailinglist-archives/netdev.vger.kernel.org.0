Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 495AF2C34B9
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbgKXXkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbgKXXkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 18:40:19 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 109AD2100A;
        Tue, 24 Nov 2020 23:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606261219;
        bh=giCpZGapcxWpM5p0nQyxtcjjwLKYdsIElIRJxgcHR+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DhhL9D0L0jN7zbYoTf50IX2cDaQ7oQVFRWvKMwgHtiX02VQYa4OawQAvdK8UYN9IN
         fWa73QsOHuMDFGcD3ROkq+U6TUq8WrXtMAjTDbvsMeuStzOYN9+bQ1s21nrqb9eOb9
         iuelTHBrjusxomQUe/qyOrBnYXC4EH2TO1lQ8QZQ=
Date:   Tue, 24 Nov 2020 15:40:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Subject: Re: [net-next v3 5/8] seg6: add support for the SRv6 End.DT4
 behavior
Message-ID: <20201124154017.4b1a905c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123182857.4640-6-andrea.mayer@uniroma2.it>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
        <20201123182857.4640-6-andrea.mayer@uniroma2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 19:28:53 +0100 Andrea Mayer wrote:
> +static int cmp_nla_vrftable(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
> +{
> +	struct seg6_end_dt_info *info_a = seg6_possible_end_dt_info(a);
> +	struct seg6_end_dt_info *info_b = seg6_possible_end_dt_info(b);
> +
> +	if (IS_ERR(info_a) || IS_ERR(info_b))
> +		return 1;

Isn't this impossible? I thought cmp() can only be called on fully
created lwtunnels and if !CONFIG_NET_L3_MASTER_DEV the tunnel won't 
be created?

> +	if (info_a->vrf_table != info_b->vrf_table)
> +		return 1;
> +
> +	return 0;
