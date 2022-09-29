Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9095EFF22
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiI2VOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI2VOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:14:17 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1331C5CA2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:14:16 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-131b7bb5077so3322683fac.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=HD+AV33GDQnjyFVXDDTE0Wqisrv2J294cmXf6Dxy6WA=;
        b=Mb4+284uLNUfBJYApUvYWsjljBC6bGq9LhZBknmcfnWo1eaLky/ISSJhhaOjFstQ69
         EESn70/zMp+J3xBefr/MbuA5Vr+rEcTZX0gRmjfWULwdYczcZ2lKlPS4sUxlxvXW+hVd
         44eOaUNpMrVHDUEsMaQkQuKx/ovT0Z5ZK2d3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=HD+AV33GDQnjyFVXDDTE0Wqisrv2J294cmXf6Dxy6WA=;
        b=6bVosEulXB9LfHn11w+oTgi/dAJBcdVBfomsVrb9bYfyFSDGrRrMYgyQ2dQ88xMths
         G8sY3IK2eyr5zShsvyh42Jo8kPSp1wuHpZI+hUNRI1xzpWVasJDJFcnuwKLvNeP22X87
         kyv70pj162P3agtcoilQEk4ULy1B9Di138Gc8RA18YN8EOvTiveuri89Z5lZmWYhBH0I
         I09VeLyXKOGq2v2FA8Qdokxvb/i5HkxngtOm53p2oM+6gAdQcjSrOjh3MdUyp0phjCQD
         x51FGI0DYiMIq0ZQBd+WcMpMwSj19xqiMUtIKUSKQG6wkTVGXHpKMzuRDvS/bd4ddFlg
         US4w==
X-Gm-Message-State: ACrzQf0g7ieYXvyuSGo9ZZBuV1cL1XBtuc/EfoHMN6FCBMrSWiw2hFm9
        bgMh7hty7aznOo+Fh8IFwTnH4/qGpoMqHA==
X-Google-Smtp-Source: AMsMyM6tvafuVTf0gJTPvbe24cMHxJLOjcBNrAbaXRjDUidzXCSlvEBdQ08w6jcGhS6OShHvimYtDw==
X-Received: by 2002:a05:6870:b507:b0:127:d2f0:54e with SMTP id v7-20020a056870b50700b00127d2f0054emr3115437oap.250.1664486055461;
        Thu, 29 Sep 2022 14:14:15 -0700 (PDT)
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id l9-20020a05683004a900b0063725d33561sm170047otd.73.2022.09.29.14.14.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 14:14:13 -0700 (PDT)
Received: by mail-oo1-f46.google.com with SMTP id u19-20020a4a9e93000000b004757198549cso975660ook.0
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:14:13 -0700 (PDT)
X-Received: by 2002:a05:6820:1992:b0:475:c2c0:3f92 with SMTP id
 bp18-20020a056820199200b00475c2c03f92mr2154395oob.96.1664486053314; Thu, 29
 Sep 2022 14:14:13 -0700 (PDT)
MIME-Version: 1.0
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV> <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV>
In-Reply-To: <YzXzXNAgcJeJ3M0d@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Sep 2022 14:13:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgiBBXeY9ioZ8GtsxAcd42c265zwN7bYVY=cir01OimzA@mail.gmail.com>
Message-ID: <CAHk-=wgiBBXeY9ioZ8GtsxAcd42c265zwN7bYVY=cir01OimzA@mail.gmail.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 12:34 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Apparmor takes mount+dentry and turns that into pathname.  Then acts
> upon the resulting string.  *AFTER* the original had been resolved.

Ok. So it would have to act like a bind mount.

Which is probably not too bad.

In fact, maybe it would be ok for this to act like a hardlink and just
fill in the inode - not safe for a filesystem in general due to the
whole rename loop issue, but for /proc it might be fine?

                              Linus
