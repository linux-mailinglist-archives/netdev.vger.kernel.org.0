Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D35F7C65
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiJGRn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiJGRn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:43:27 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EEBD8EDB
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 10:43:26 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id v134so6291412oie.10
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 10:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=//pU+B4CdEHUXnP14JIGltVIuBGKM3zOSsugyiB6BLI=;
        b=aHQGkwWBLhml96bIzFmZ3ubLuJK0cbQjbPIxDHZsY02++EcR84DjhhKisldOYgGml+
         Q2wVg57JqSSM6P7+cEzqN+jfWdRlJ/XgWZy267JqBPKYOOkZjRLq0wxB4sa4fG5W6S9J
         Ycd6grWzP00JbXR9jtKiQBt5JnIiX8C+RUOkWEQdL6j6F8ALGJGPR/xzjfBLDuxwmWb2
         PZ9wjCGHYt2mde+t/P5gagAOoT+bgKHyNOL9FGpuNik3o3hNDti/HlufPjG6KrRUedtD
         LAfzXCoEXyjHUkCHMNeMjbZ4gEnup9ob88tgcBXlhDVmbUlH9oTbB787lf130onzR2E3
         gCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=//pU+B4CdEHUXnP14JIGltVIuBGKM3zOSsugyiB6BLI=;
        b=RoWrEEca9kRhb0JZrAL4KK59VgUOqEwliijvVc2v2vBOySseoCLgwVtoqvurksrcUd
         W3zbJx8Mw1WkjlU+Cyb/eEuFLQej/HjdNXdQxmDA171C9kcEHMQZklD2cPWQcu39d17E
         cScAVLHGvQ8JWaNqNAKD5+oCzNcmcqodNIwFzbEo7VV6xlWued4vNzA+HGasyBtznagj
         uTVN0y5rHj/ZD1UN6iRhJ3mCJt+6O3PcT+KDnoR+VBfNxjCUHiBdVNYO/21KzMY9gRbQ
         mXM4ovKON1eKo5S68wgy4pSCbu50/YUpTi5UgZUr0cQTXL9ky/7bCbdrty25+xLZfJpN
         alfA==
X-Gm-Message-State: ACrzQf21x+uJBpo6tNfhpMQqQ+ts4r5woM+iUaVePKxc7kgfdfPVjYRN
        A7d570fbrIOiQanqLw0M0s2HkXyqEU0MprPX1Gjx
X-Google-Smtp-Source: AMsMyM7RUzL2i9yHohtKY32yxs0duk7SA4vdOvoa1QxpjpNPWjJAIUwj3y8/0uSe2v0sVmSE5cLeJzawMX66Y6K/7rI=
X-Received: by 2002:a05:6808:218d:b0:354:b8c:f47f with SMTP id
 be13-20020a056808218d00b003540b8cf47fmr3248241oib.172.1665164605928; Fri, 07
 Oct 2022 10:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
In-Reply-To: <CAHC9VhTGE1cf_WtDn4aDUY=E-m--4iZXWiNTwPZrP9AVoq17cw@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 7 Oct 2022 13:43:15 -0400
Message-ID: <CAHC9VhT2LK_P+_LuBYDEHnkNkAX6fhNArN_N5bF1qwGed+Kyww@mail.gmail.com>
Subject: Re: SO_PEERSEC protections in sk_getsockopt()?
To:     Martin KaFai Lau <martin.lau@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 5, 2022 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
>
> Hi Martin,
>
> In commit 4ff09db1b79b ("bpf: net: Change sk_getsockopt() to take the
> sockptr_t argument") I see you wrapped the getsockopt value/len
> pointers with sockptr_t and in the SO_PEERSEC case you pass the
> sockptr_t:user field to avoid having to update the LSM hook and
> implementations.  I think that's fine, especially as you note that
> eBPF does not support fetching the SO_PEERSEC information, but I think
> it would be good to harden this case to prevent someone from calling
> sk_getsockopt(SO_PEERSEC) with kernel pointers.  What do you think of
> something like this?
>
>   static int sk_getsockopt(...)
>   {
>     /* ... */
>     case SO_PEERSEC:
>       if (optval.is_kernel || optlen.is_kernel)
>         return -EINVAL;
>       return security_socket_getpeersec_stream(...);
>     /* ... */
>   }

Any thoughts on this Martin, Alexei?  It would be nice to see this
fixed soon ...

-- 
paul-moore.com
