Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021F62A4EC5
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgKCSYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgKCSYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:24:01 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE86C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 10:24:00 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 10so14981305pfp.5
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 10:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BNxKP04EVMUTaGOfOb9r5XgAOwx9E5YadlzRZT0Y6so=;
        b=YjhR0VrS28GIv8KwSH8dB1KfhwO7SIG7a2HMYl9iE3WhI7ncKYoGpjzRdiL9EKC6OU
         Y24baZovWzOLTjA3slfFKjJ7dqD/eN1POb6K5xlMjsgtsSoSiEBWAKw3o/yrPKc0IOyo
         PIoSlUkg8Wl7q9EKzm/efmOSeD4eJZEF1An2/v9g2bv3Pobg4L5vfM+OF4k+nQlaxEga
         6YVIlCTgKFe8yTzS0/OgDGPsQ3uUBI7PjDsnNrlECnE9iOSwsgRDBTjGRYqgyOF/Id6X
         0Bo0vImW08yQQBYsaCYw6HOSkU7NysFeBBlP94Fhls9WtN2AzyDoHcnNpxJpGJuavGX2
         94Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BNxKP04EVMUTaGOfOb9r5XgAOwx9E5YadlzRZT0Y6so=;
        b=Hd/P1whm9yecxNXWh13QFHfEe9htDNgWOaxunEBCPzoom//HWyR75aVWbVgnK6chO3
         DJ48c3q7Y+h6jq2CZFLs1OIoXjBQ50E3viJJy5i+NV7UH+O1fwGrEDr2ONahoOBlVGvD
         iVWYxEy3fSvovWo4moWgapHfvRbrkM04pt0G5xn7s0DgTNS7v1x7c/unCZqjcF6nmcB2
         H3F8petT6oyPkUhvaYtPIB/TcJemmIhfRgFNrEVw2tF+TLZcVOWl4IR0hoxwNxKAN4tW
         RwZwqBfUt9Ag/eKmlfWZ42XT3Mlk9CwqdGDNCOpBYwNcvaFrAJZjOyVI+zcX/mOCuU2v
         FnwQ==
X-Gm-Message-State: AOAM533bLw/UO4woAE5XGOcqk7/23Z5F0AgwWWc81+TOuOYbIOa2R1DR
        jxtsnIZwHXVFFUU19+1OfnytPA==
X-Google-Smtp-Source: ABdhPJyTOrd/svwqOBTwp6j1WhlW8OupV70YCfTZHEabwFoFTI7yiCT03e0F2Grr6Kquu5HFk3s1Aw==
X-Received: by 2002:a17:90a:5e45:: with SMTP id u5mr469803pji.83.1604427839842;
        Tue, 03 Nov 2020 10:23:59 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id mv16sm7403pjb.36.2020.11.03.10.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 10:23:59 -0800 (PST)
Date:   Tue, 3 Nov 2020 10:23:51 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201103102351.13a2bb9a@hermes.local>
In-Reply-To: <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
        <20201029151146.3810859-1-haliu@redhat.com>
        <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com>
        <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
        <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net>
        <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
        <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 09:47:00 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Tue, Nov 3, 2020 at 9:36 AM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 11/3/20 1:46 AM, Daniel Borkmann wrote:  
> > > I thought last time this discussion came up there was consensus that the
> > > submodule could be an explicit opt in for the configure script at least?  
> >
> > I do not recall Stephen agreeing to that, and I certainly did not.  
> 
> Daniel,
> 
> since David is deaf to technical arguments,
> how about we fork iproute2 and maintain it separately?

A submodule is not a practical viable option.

Please come back when you are ready to use distro libbpf packages.
This seems a microcosm of the Linux packaging problem that was discussed
around Kubernetes and "vendorizaton"
