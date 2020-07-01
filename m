Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22603210F00
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgGAPV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731586AbgGAPV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:21:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960E9C08C5C1;
        Wed,  1 Jul 2020 08:21:26 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b25so23936729ljp.6;
        Wed, 01 Jul 2020 08:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9aa8D6GnHFA/FGZ0poDZjtaJSCr13wpNPHW3T9d8QOI=;
        b=QFAvMwW+ZsBsJCq8e9J3fOYOYfeF4MhAKqPOOPS7IfMxZHOAHag40m8z4D/OV7HaHS
         7R0X1lb6RpGAUaooIGhukVLZIhaOnrhlh7XchyWkbPACYpVDnp/LtLm/u8Vbw+Fic66A
         +78haoKDrftLN6kTIh8Rm6FaUzCmsDLi8cXgqxrhUtwSUedt4lxRwKD53p8Ce5Vhhjgd
         kize7rZTx27P8lSUybv8ls7JWbQQUXaH5g4c7xbBQA35o+xljTG/M6S254lfpLArRn+y
         2sIhFbulC+rFkw1AgrdhLNG5fL4dmeem0Tu/NOq5JNBdLevF4XYCS9TVC7zKRV8mUYwN
         hsgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9aa8D6GnHFA/FGZ0poDZjtaJSCr13wpNPHW3T9d8QOI=;
        b=WKfneJG1Pw5UMCgk5v3jmzA3IjHmJx6ofPNCg3j6XBUCAFtd4KEoc04smxVkQxZVc1
         m+C3jfpscdBuatrYk5VNKHcFlhATnAh1vmOa10N3Zbb5gp1bzY9+xZS3WQWXrmHzRmJ5
         AfreNC6V2ooZ/as8KTjUMcvSfs+nh5nkVR8zmDCfhQwanJSLHMmUaclsAXGUoLGW2e1X
         wTE9YNolwY+08JvltAfZQZsGTJc3bbdt7OGTGG1uOmSQBYIN/adNu5lcDvTJHh3post3
         Z20Z82h/yicEN96qVUUtQDRcR3G5lybjOkU4t37v01UF8vU3RNCkFRtEwhqPzLuJOnOg
         5uTw==
X-Gm-Message-State: AOAM5311mrlZObhG9FwL1iXmh95Tyc7nuTGk+gAZtiWvxzM430O9FKef
        sKEn484xq/oX4yeebHqVn+Z3QQfuys4fd5wlONw=
X-Google-Smtp-Source: ABdhPJzJBXM9K1IaGexv5ofLOLjuL58H1BH26jahlj5Dt5OEmKGNj/BwhPFWKUhT4EUUfIuhmMUDKA6VyPXsLpoP23A=
X-Received: by 2002:a2e:8216:: with SMTP id w22mr7274311ljg.2.1593616885061;
 Wed, 01 Jul 2020 08:21:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com> <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
 <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com>
 <CACYkzJ5kGxxA1E70EKah_hWbsb7hoUy8s_Y__uCeSyYxVezaBA@mail.gmail.com> <5596445c-7474-9913-6765-5d699c6c5c4e@iogearbox.net>
In-Reply-To: <5596445c-7474-9913-6765-5d699c6c5c4e@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jul 2020 08:21:13 -0700
Message-ID: <CAADnVQLoVfPWNBR-_56ofgaUFv8k3NT2aiGjV9jj_gOt0aoJ5g@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 2:34 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> +1, I think augmenting mid-term would be the best given check_sleepable_blacklist()
> is rather a very fragile workaround^hack and it's also a generic lsm/sec hooks issue

I tried to make that crystal clear back in march during bpf virtual conference.
imo whitelist is just as fragile as blacklist. Underlying
implementation can change.

> (at least for BPF_PROG_TYPE_LSM type & for the sake of documenting it for other LSMs).
> Perhaps there are function attributes that could be used and later retrieved via BTF?

Even if we convince gcc folks to add another function attribute it
won't appear in dwarf.
So we won't be able to convert it to BTF in pahole.
Looking at how we failed to extend address_space() attribute to
support existing __rcu
and __user annotations I don't have high hopes of achieving annotations
via compiler (either gcc or clang). So plan B is to engage with sparse folks and
make it emit BTF with __rcu, __user and other annotations.
