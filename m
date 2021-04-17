Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F691362D62
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhDQDqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbhDQDqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:46:43 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03F3C061574;
        Fri, 16 Apr 2021 20:46:17 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id r128so20822339lff.4;
        Fri, 16 Apr 2021 20:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3UKS3by2sRC26TiZQut2iFygOIbUq4FQcjO23uuSGpw=;
        b=cls8otFlkhE4SEaa1P7uPvIpmnhty0IKil4+wO18Wb3HP4JSIk5kxDkvEJPnRKy7pB
         9KdbfHzVU5I0rFzdaJqhBf7e0PnxMWBWfgqJh2xPoiUc5/SAw2gHCJNra+LZjlVAfCeL
         a4+W2wzqYvfXX7Zp/Ff0I/d+z4w+FxvQlsQUoxKwG5KnPPoyTM7zgjCF10UJ39Rx8/uV
         ey9G35g+PS6VGEISAscESGPXcBZhmP/0+KEROh5cNRfsvvqt61Kx0gnS5f/L4/CH1Nmv
         cW1v2fLv4KlGGxBiLxwup/YCD/uyHAGlNnsGoYkzh+ob/lBXlJ2rSgcHgNLCObjuM/Id
         PtRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3UKS3by2sRC26TiZQut2iFygOIbUq4FQcjO23uuSGpw=;
        b=prNf8QLgsi19uECxgw0WEZh1kmfAC4fT9aHUiugXdzYN50fnmzHsNXXHIzbAlzV3yw
         p1SWYI1FJz426NylV8WOmLibYcxM3XAAlptRFtRz0EkSW2IgNqDQOQD5DcF+1OWRibGO
         Rsut6Va57mRa3jyA+FhdmW4fk5bSyMxB2CiUQfx4OLZU+Z/MEWb8ssqbO2jPitTYwtF/
         1y3kB2p4N0ymeo0zFCBDvGSG52INo0VeOYp4gw4+R6tlu6Dab4VYPOyMO22JlKECWlHx
         SNVaBY+AxFDX28x1+mBdXEEFm5i6sD9vGjxLxFkoj+Y0nTvTg9yz2Z5ZtEjIGylDoNCc
         dKTA==
X-Gm-Message-State: AOAM531of0oTmfMHLcUumotnZpubiLut7JEqzWM1pMiOnz4p7aDvQe16
        mQsHFR+7cFvu5ys8jkFohpsJoZtwPvWJPksl6KWhqHK3
X-Google-Smtp-Source: ABdhPJylmVjCb+XDl1LDXBqn+2vSU7ZrEApcRGAMpVxUiEJ09xoj8yJS6fxQQ5/1vZx+2J4dW8xmok9ZUIvph85cKVs=
X-Received: by 2002:a05:6512:21a5:: with SMTP id c5mr5199445lft.534.1618631176390;
 Fri, 16 Apr 2021 20:46:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
 <20210417033224.8063-12-alexei.starovoitov@gmail.com> <YHpZGeOcermVlQVF@zeniv-ca.linux.org.uk>
In-Reply-To: <YHpZGeOcermVlQVF@zeniv-ca.linux.org.uk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 16 Apr 2021 20:46:05 -0700
Message-ID: <CAADnVQL9tmHtRCue5Og0kBz=dAsUoFyMoOF61JM7yJhPAH8V8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 11/15] bpf: Add bpf_sys_close() helper.
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 8:42 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Apr 16, 2021 at 08:32:20PM -0700, Alexei Starovoitov wrote:
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > Add bpf_sys_close() helper to be used by the syscall/loader program to close
> > intermediate FDs and other cleanup.
>
> Conditional NAK.  In a lot of contexts close_fd() is very much unsafe.
> In particular, anything that might call it between fdget() and fdput()
> is Right Fucking Out(tm).
> In which contexts can that thing be executed?

user context only.
It's not for all of bpf _obviously_.
