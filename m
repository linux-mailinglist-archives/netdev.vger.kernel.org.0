Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1D832A3ED
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348770AbhCBKDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 05:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379115AbhCBJsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 04:48:14 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D10EC061788
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 01:47:23 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id u18so9494075ljd.3
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 01:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7kcgL94+L1tIXT1R8vfU9UzdbVrMKYIDLcHvPGal+1A=;
        b=SurN3sWHWBPKkLlGNZc6rYyjJtp8AA/I2oXOTORAolb7hFvo7bfaUhEMmYnvL9t/eV
         lX70eBcFbTYDzPxYJFrDwpr1iGSt7PkyTCRxzAkSHJR8OMWI5IkYUuKCCG2ZTlt0f2kO
         IRqX8Vh8c1GRXIZ4HZUGAXxuD7wo4pek3aQ6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7kcgL94+L1tIXT1R8vfU9UzdbVrMKYIDLcHvPGal+1A=;
        b=Xn7HMoE46b23BAdHekMupQ1iCfQvQ5BW97EmGF0fnzES+67Zk1UDL+FV0W0S+Xy1V9
         DLkNzExZB0hoSHXeTkhgiFognBtEHI7CA9u5vmZohHiIrc6PXo5H8hYkn2UqL00F0fPz
         lxcDAPM27zvoE0D2wT/95zZnyqFidE7pRpqe/hQ+NWodzVTHrmWbpquDQnxdS5SoGXKK
         YiLDvaFonCLHBW96rFLXHjFSCcAMhqbrNhzC31bv04Lg0ntEzq+or6tGJBWYO895n+oQ
         WC/KyS8G9Edh3NIXdGivdg8skWkmWPh5vYkfy58C0Muuut9JBFdsdaroRYhvxLNtSHkL
         Hk6Q==
X-Gm-Message-State: AOAM533aPkiQPmCUktvKK4kvL07Q4szh76ZJu+hth/J8cvhCctFhkuFY
        p6GnU7cgFr4irLztM44uuoNUxq+zgwpdG359xL4owA==
X-Google-Smtp-Source: ABdhPJwg1ssQ28iX2I+mijjOyb6szTErEc2v03CrScKzyn9CA47P04+7k072VSz5R/vYT31LV7LexBEMXka7Q6QXIJg=
X-Received: by 2002:a05:651c:1318:: with SMTP id u24mr11838773lja.426.1614678441745;
 Tue, 02 Mar 2021 01:47:21 -0800 (PST)
MIME-Version: 1.0
References: <20210210120425.53438-1-lmb@cloudflare.com> <20210210120425.53438-3-lmb@cloudflare.com>
 <20210301100420.slnjvzql6el4jlfj@wittgenstein>
In-Reply-To: <20210301100420.slnjvzql6el4jlfj@wittgenstein>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 2 Mar 2021 09:47:10 +0000
Message-ID: <CACAyw9_P0o36edN9RiimJBQqBupMWwvq746+Mp1_a=YO3ctfgw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/4] nsfs: add an ioctl to discover the network
 namespace cookie
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Mar 2021 at 10:04, Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> Hey Lorenz,
>
> Just to make sure: is it intentional that any user can retrieve the
> cookie associated with any network namespace, i.e. you don't require any
> form of permission checking in the owning user namespace of the network
> namespace?
>
> Christian

Hi Christian,

I've decided to drop the patch set for now, but that was my intention, yes. Is
there a downside I'm not aware of?

Lorenz

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
