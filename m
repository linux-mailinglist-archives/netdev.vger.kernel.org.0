Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A9D18FA6F
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 17:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbgCWQyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 12:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWQyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 12:54:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B27B20714;
        Mon, 23 Mar 2020 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584982454;
        bh=tlDkm10q/JLbAgD8F/jTvMTQNejG9n0yp9Rtz9MQ+WI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jK4LwzXS6QybTuMwzGKk5anPNOUh0xSSSyWb+GeMHj3G7k3aQnwSZivJDDTh/nle+
         qotGUsO8xCUwF0OPgJJh79tnZMB9zuzNLacMu9+8rMZ75xJMNdeceP6fAvPivuR5PT
         HVVTTV6PSW0E4tWhU2ZeF3UYnzhDVjhJunSdJ4r4=
Date:   Mon, 23 Mar 2020 09:54:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200323095412.15bff0cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87tv2f48lp.fsf@toke.dk>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
        <158462359315.164779.13931660750493121404.stgit@toke.dk>
        <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN>
        <875zez76ph.fsf@toke.dk>
        <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
        <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
        <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
        <87tv2f48lp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Mar 2020 12:24:34 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Well, my reason for being skeptic about bpf_link and proposing the
> netlink-based API is actually exactly this, but in reverse: With
> bpf_link we will be in the situation that everything related to a netdev
> is configured over netlink *except* XDP.

+1
