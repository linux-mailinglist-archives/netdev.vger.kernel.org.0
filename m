Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD0B27157C
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 17:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgITPzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 11:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITPzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 11:55:45 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA728C061755;
        Sun, 20 Sep 2020 08:55:44 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 16so12427329qkf.4;
        Sun, 20 Sep 2020 08:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=wK83tl6Aps7O/Nyle+fjor+3BT0ZPHQ73i72gH6haeo=;
        b=j4uRAT2E8fdr2YaqrsiSPOPm8SjiSJMcVFWHVJQhudY7AjMagOuTaPaUrJZNB/DBxT
         RsSoXPsH0OZD1fdr6pAc+sedSbMtOJwM9dBbGX8EN9WBkRUekzOQnQi4yezBjIKvjoxp
         4pTmIYXjTwfM8Ld7eN31Snn3HDl+xaBbxHqYulOMGjuIpzvi82ZxqqNXiPf1uBPbl0mW
         R3NIOxISkFL7B3tRSyYt+xnjnX4aUHUa0CKdIWEe71XW1d+175gN1d4Ezj+1k468etjw
         /p5aXBL9ieWXzE65cwKlIMBtQsaHBRTVaj0KGV3HN1O35ptGSjHCYh1Za9qlu8Ia58/F
         0ILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=wK83tl6Aps7O/Nyle+fjor+3BT0ZPHQ73i72gH6haeo=;
        b=MVEvg7GVE0UwEB/ZAZ6gif/de22ie6uJH02CpMntE3eCjMiLc4mtOVY35v/lCpmGI1
         do5epLnA0IOlZBcyYJpJHy+yAE8B81RoKiT9KIGTWhoAxJlwGBtfxriBrAhPIN4/Z+dT
         lYvjOZGNloV1B9R88+E8aovv9+C0tXS2KAzlzsu3JfAoYVTi1qGiwO56odm9U3yH9zOl
         v4mAHouV/IVfNaPp8CP2slwszyXAgV/E53rz/xQfbxx07tnK3mONhiXFmK6QA5GW3Jk5
         vzfvcTK3oF5O/ozhCfkXIZpf7cEQU6BkLSBjkFcZx1zpDKXuSwY5oCkOnw/E+cXcsY6a
         HPjw==
X-Gm-Message-State: AOAM53079/7R18hIx/eWVGFWm1GSrmbGEBNsXKkfLXBXONkxCpNv9qkt
        qlqM8bYTN9eBcVOFs/2dhI3mekHPJDjjcD++
X-Google-Smtp-Source: ABdhPJy0BhskiTDfvD8MBwip85dcX1wIsXPWtdth0juyqPe/DUqb3tBX97TvqdwX16zuipDqY5+Gyg==
X-Received: by 2002:a05:620a:c10:: with SMTP id l16mr40194491qki.245.1600617343577;
        Sun, 20 Sep 2020 08:55:43 -0700 (PDT)
Received: from localhost.localdomain ([65.140.37.34])
        by smtp.gmail.com with ESMTPSA id v30sm7605819qtj.52.2020.09.20.08.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2020 08:55:42 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   William Kucharski <kucharsk@gmail.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Date:   Sun, 20 Sep 2020 09:55:40 -0600
Message-Id: <76A432F3-4532-42A4-900E-16C0AC2D21D8@gmail.com>
References: <20200920151510.GS32101@casper.infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20200920151510.GS32101@casper.infradead.org>
To:     Matthew Wilcox <willy@infradead.org>
X-Mailer: iPhone Mail (18B5052h)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I really like that as it=E2=80=99s self-documenting and anyone debugging it c=
an see what is actually being used at a glance.

> On Sep 20, 2020, at 09:15, Matthew Wilcox <willy@infradead.org> wrote:
>=20
> =EF=BB=BFOn Fri, Sep 18, 2020 at 02:45:25PM +0200, Christoph Hellwig wrote=
:
>> Add a flag to force processing a syscall as a compat syscall.  This is
>> required so that in_compat_syscall() works for I/O submitted by io_uring
>> helper threads on behalf of compat syscalls.
>=20
> Al doesn't like this much, but my suggestion is to introduce two new
> opcodes -- IORING_OP_READV32 and IORING_OP_WRITEV32.  The compat code
> can translate IORING_OP_READV to IORING_OP_READV32 and then the core
> code can know what that user pointer is pointing to.
