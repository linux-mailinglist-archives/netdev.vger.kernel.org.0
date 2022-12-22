Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5953B653AEB
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 04:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbiLVDZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 22:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLVDZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 22:25:28 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB2C20F63
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 19:25:27 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n65-20020a17090a2cc700b0021bc5ef7a14so625647pjd.0
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 19:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xprklr2DQlNtzcncGGgpKUiT9FUJ0kSLAKBIgLB/1ZA=;
        b=FV0XKY+C/Bjb48nnT7zhUoG//rhdNJgKZDrKPYQzZfQHZ4ToKh3P6nCFNJPERlhyo/
         FcDtvKBmLSaE6RWeJLRCbgQgHrphhaUPbJVPRgfxijMS6YS7y9Kw/fdERFuq4y1y2KXc
         k/Cx7jQXF+vwu/i3zReuVCZtc2oKp21G7EqwC+E2tkg8AfbOWsTDEpJAwvIxSqY0vLbD
         OccCWUUO1pjEPWrhnHPlU/UDFy+td2Z+Qhh7aC2uz3iTFTAr0yj/hxw85L4ZglIioyCs
         ROsIQOZzDfiW7NBnMm46A70Vmgh6RL/z2rcAp4atsenZLWXZG6dXvfOzIX1ZZymLjWye
         KuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xprklr2DQlNtzcncGGgpKUiT9FUJ0kSLAKBIgLB/1ZA=;
        b=Rq3F0kOnYPyl1M6LM6vMSjZGEVD4/V8DdCrkRa/Io/42mk93NmZRypoS1zzb5jo1CO
         FqikE+nzFIXFlkLZxeY8C2qptuwdQqqbt4GDKdEC7bvH1kzgqizrmhADj1C7zIn2Ftpm
         r5jZdfV8s6SmDN3sT73lhZAoGGQyezr7AE0G0iM7WCXtsIMt9Ng7DlL7PtOy6NfjiDXc
         oHUT9pgpwZcleKg713jIXukP0aJwOVbRJNrbGQzodArzKRp9tP0XNIdIvgHafyxZFdAy
         7x1sKNwkxLI2eeOTLdVyZ+h4v9PBQ6wVHTb99zUdx/Y11DwSajAoOr/BOnXcLASCb6NV
         MSWA==
X-Gm-Message-State: AFqh2krc8lV4nSNNh+i4/zEU9LQd5WRsSPWKkNkb4iuYjbuC/OyBoVVQ
        5GlqQ3KECP+k5h1MU1tVZRcKLQ==
X-Google-Smtp-Source: AMrXdXviuvo86csWt3zikDt4xDQYG0+EWx6DUXOqCC0Hcze802MGv1i8imSTN7Ujdbx9Lz5PEQ5fAA==
X-Received: by 2002:a05:6a20:cf62:b0:ab:ee20:b003 with SMTP id hz34-20020a056a20cf6200b000abee20b003mr4725299pzb.14.1671679526971;
        Wed, 21 Dec 2022 19:25:26 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 15-20020a63144f000000b00478d947ed5esm10515149pgu.27.2022.12.21.19.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 19:25:26 -0800 (PST)
Date:   Wed, 21 Dec 2022 19:25:25 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     netdev@vger.kernel.org, heiko.thiery@gmail.com
Subject: Re: [PATCH iproute2] configure: Remove include <sys/stat.h>
Message-ID: <20221221192525.5b02610d@hermes.local>
In-Reply-To: <20221221225304.3477126-1-hauke@hauke-m.de>
References: <20221221225304.3477126-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Dec 2022 23:53:04 +0100
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> The check_name_to_handle_at() function in the configure script is
> including sys/stat.h. This include fails with glibc 2.36 like this:
> ````
> In file included from /linux-5.15.84/include/uapi/linux/stat.h:5,
>                  from /toolchain-x86_64_gcc-12.2.0_glibc/include/bits/statx.h:31,
>                  from /toolchain-x86_64_gcc-12.2.0_glibc/include/sys/stat.h:465,
>                  from config.YExfMc/name_to_handle_at_test.c:3:
> /linux-5.15.84/include/uapi/linux/types.h:10:2: warning: #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders" [-Wcpp]
>    10 | #warning "Attempt to use kernel headers from user space, see https://kernelnewbies.org/KernelHeaders"
>       |  ^~~~~~~
> In file included from /linux-5.15.84/include/uapi/linux/posix_types.h:5,
>                  from /linux-5.15.84/include/uapi/linux/types.h:14:
> /linux-5.15.84/include/uapi/linux/stddef.h:5:10: fatal error: linux/compiler_types.h: No such file or directory
>     5 | #include <linux/compiler_types.h>
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> ````
> 
> Just removing the include works, the manpage of name_to_handle_at() says
> only fcntl.h is needed.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Please add a Fixes tag.

Fixes: c5b72cc56bf8 ("lib/fs: fix issue when {name,open}_to_handle_at() is not implemented")
Cc: heiko.thiery@gmail.com
