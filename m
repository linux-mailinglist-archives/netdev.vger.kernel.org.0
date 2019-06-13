Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4B3449BB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfFMR3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:29:43 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38683 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfFMR3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:29:42 -0400
Received: by mail-qt1-f195.google.com with SMTP id n11so21353687qtl.5
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Vkz0EExAX+LyWJhpQLekP+MxHO5+Vrab4RkRIVz5TI4=;
        b=jYJbRrX9v6Ln6k5PC/tNPKRlTuv1PGDu99M4fLHTGHzPYEi61JmDXa1PzRDIXYVT3k
         NN0RcUDmwcYuixseOcJtyR1W1EYCJPxpbXai8Rz/vkBjz0S4dDgNK3D4vZkJbNtgSGcP
         hcL8CG+FqTHo5ZZJ/0/7jcozkdW95UQwdZ13WOasVZfyU6kEboFEKEJCvnS3W93hrXPq
         swE+6nb8Wi4D95ukWQDv+CIaJ67X8an3z+hXyaZP72UgO1zU990KWedBaNSn6EM53VxF
         uC5Sdu0ruEKaZ4puFz6r1ub1ymS2UU+nXbmHLMGQlTdvC8c2nW+/nMMKWNhIrTypkPnc
         aCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Vkz0EExAX+LyWJhpQLekP+MxHO5+Vrab4RkRIVz5TI4=;
        b=JMudbhjnzvyRX3IJMHdD2+NhIP7gq8YAoERcna2crHUwRJRoIrU9nY7snYmXdvoCuU
         cs0yXWqGgWYXIJkXoHngFTCnDRoTHmE/UJxaxuZ7hf5He6dVyQJvLdoR6PuYpoBNB7Zu
         Q5kNxyzordoReo6faQQMxFup0CQpAneDDTqAV/t4bhBUQlEHu2r3mvUD4Xa4aJMyphjx
         LubRWRCJAoNZV1pDNrcE7tGEKmB6MGM3QVY0Hdjr5SkVzSGYyMYyfjHiBSuVss248WJb
         IKas/LUi3ewKicDkmCclcyFlpNTYGlmm/Q3bw0k6uipUWK4fKm7+Ve0uHVKy7R9iRUUj
         mZRw==
X-Gm-Message-State: APjAAAW+8IZUNaQQHO1pQmaboxJS+6b0qZJNXOs3cpzlRSelUnG3Y22R
        O8FSGBg26xWC0R1va91djjzyfo/6hVM=
X-Google-Smtp-Source: APXvYqxA/hsjUjmBs9SM6QXlL8NL+RTmlFAowM1RUue8CWvRAMj1II8Y3KSlaa/YWX1Lh8iVT6iKHg==
X-Received: by 2002:a0c:f9c1:: with SMTP id j1mr4501017qvo.235.1560446981811;
        Thu, 13 Jun 2019 10:29:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s134sm111885qke.51.2019.06.13.10.29.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 10:29:41 -0700 (PDT)
Date:   Thu, 13 Jun 2019 10:29:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= 
        <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 05/17] xsk: Change the default frame size to
 4096 and allow controlling it
Message-ID: <20190613102936.2c8979ed@cakuba.netronome.com>
In-Reply-To: <b7217210-1ce6-4b27-9964-b4daa4929e8b@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
        <20190612155605.22450-6-maximmi@mellanox.com>
        <20190612131017.766b4e82@cakuba.netronome.com>
        <b7217210-1ce6-4b27-9964-b4daa4929e8b@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019 14:01:39 +0000, Maxim Mikityanskiy wrote:
> On 2019-06-12 23:10, Jakub Kicinski wrote:
> > On Wed, 12 Jun 2019 15:56:43 +0000, Maxim Mikityanskiy wrote:  
> >> The typical XDP memory scheme is one packet per page. Change the AF_XDP
> >> frame size in libbpf to 4096, which is the page size on x86, to allow
> >> libbpf to be used with the drivers with the packet-per-page scheme.  
> > 
> > This is slightly surprising.  Why does the driver care about the bufsz?  
> 
> The classic XDP implementation supports only the packet-per-page scheme. 
> mlx5e implements this scheme, because it perfectly fits with xdp_return 
> and page pool APIs. AF_XDP relies on XDP, and even though AF_XDP doesn't 
> really allocate or release pages, it works on top of XDP, and XDP 
> implementation in mlx5e does allocate and release pages (in general 
> case) and works with the packet-per-page scheme.

Yes, okay, I get that.  But I still don't know what's the exact use you
have for AF_XDP buffers being 4k..  Could you point us in the code to
the place which relies on all buffers being 4k in any XDP scenario?

> > You're not supposed to so page operations on UMEM pages, anyway.
> > And the RX size filter should be configured according to MTU regardless
> > of XDP state.  
> 
> Yes, of course, MTU is taken into account.
> 
> > Can you explain?
> >   
> >> Add a command line option -f to xdpsock to allow to specify a custom
> >> frame size.
> >>
> >> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> >> Acked-by: Saeed Mahameed <saeedm@mellanox.com>  
