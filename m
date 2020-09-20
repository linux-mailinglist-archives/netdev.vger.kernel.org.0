Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CAE271588
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 18:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgITQA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 12:00:26 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:36075 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgITQA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 12:00:26 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MkHIV-1kmRhc3esD-00kdPN; Sun, 20 Sep 2020 18:00:22 +0200
Received: by mail-qk1-f178.google.com with SMTP id n133so12380961qkn.11;
        Sun, 20 Sep 2020 09:00:20 -0700 (PDT)
X-Gm-Message-State: AOAM533qKODglS4xYl9kvQmhZXZaVTIiXwaJgVF2yRB76sPP90XoTjCw
        kj9TpYQGvekzM+ISXbnVYovs8FTeynGFIH15g70=
X-Google-Smtp-Source: ABdhPJxWyfvCzQQBAWL//h6npTn88fQ05xaOWJspiDrXO43nFmdBtx69etP6R9R9/pXauFf/MfRV57t9JJqYkZya4Ms=
X-Received: by 2002:a37:5d8:: with SMTP id 207mr42809575qkf.352.1600617619461;
 Sun, 20 Sep 2020 09:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200918124533.3487701-1-hch@lst.de> <20200918124533.3487701-2-hch@lst.de>
 <20200920151510.GS32101@casper.infradead.org>
In-Reply-To: <20200920151510.GS32101@casper.infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 20 Sep 2020 18:00:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0utXQj+yLh3n2mvi-mX_fPnxz3hKB7+wEof53EgNzDvQ@mail.gmail.com>
Message-ID: <CAK8P3a0utXQj+yLh3n2mvi-mX_fPnxz3hKB7+wEof53EgNzDvQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Networking <netdev@vger.kernel.org>, keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:lNDlWc0Buitw3L4uhuGtwQ92/NRgJbW9dL1xVEoFiwPKF+Mna8g
 BdP2KanFhFZuk3fOTGN57tEkQzL1ph3WKs2AcSgU+CeX+Ab2aERPVddznUdHaAMJppuee5s
 VIzbmjWQQ6+7BmTHrEHpxP7MhzZM11lo/1SLP22iLAA/opCSIrmhMpGbvqQGIi5najpAfXU
 +us3JHjWmqydWqbJaik7g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4E94j39oYKo=:7VHv819McU18hTn3dg2fyO
 WsJ3X4OgNUsIyn6HHM8kNvuV5q7KfmxVsKDyAeqPIlqebvkEPz6ndia7Vv51biPfRFBBjoLEy
 ZAHy2saipBuiTnEV5+MbFcWvc0Hiw7tCChiZ0VZIJG1keApOw7sUf7hisFloLTDjAEnr0hFGN
 pvxkAuBlpciKrLll+JVxFslVJLQvIMCCfTXTaMqprY6GfOdVMQnjFtBsS5hLmyr6TozZJtz55
 WpS/kTKfJl2+lzx0Ii+4g6PI2erNGE9g8rovx2eXyar5ZLtp7706Rsz/LVl5hpW0hKEhqz8mc
 h7WttlVeFADhCsXBu/9HV1acpi6SjW61cwPfq7Z6veibgAVTU2nqDt4WokhXewxfDa2paiu5i
 BA9lN8ptOdKYCTwmGuX1T+lbPwOrwdL9Z07a2WnaUDiwePR8ejUJn+xTBiVuduLJ+0OpVl6Hl
 1tlo7XFggutUFJt3tAhJgIdJClj1i1Ct2sVY8mEHxJhttWG4xoQA/JwwebpMlBN6yl8U1H/k0
 tWC4toJ6YrGyA5GdJYadqsGPUJwtphYimKiMpn8J4iO++hlF35gA4mT7DndIQidITqUJ2eKX7
 JmusDcl4EZpY6lWyiORMy1z00AS/IPOHu6uun5BPZ3+gUYPi2Qv63WSsPp99igak/dNEIaV1Q
 JZnISm/Hep1MOGbaWlyawrmV2jzWrkZ3YVZU9EkWl2L8UPzsHTqOUwX0UjhyrpGPmGFFnz4T7
 SmWAce+DJsrZ7a5l/RRyGdIThTV/zpSM49vMFt1qXgKMIazjZmDuIqkItuVLsXyvgKZQppK0Q
 j0+iRa5LM+A0C82hzdyPTf403cp51JuM1HLg1NRgfjWbKDw0ushwxoV1LexgwtA+CJVF6Cm2v
 pYpMAzGQPc1WaCj3R4orovQJ6iNnHuhY0y//KGfYZXN3ZU9Jy2KciInMaYfgVqeTeTEDMexv7
 AfUR/cUk6dbxLNc80aliQmsDlGCigCKn29qxjYoWguFPyhQ8yj1jkUxjFrA59Qsc6Ln/DFl00
 Xpl9mJ/2xZEw4KeGsVI1eAW4qY4SsF1V8kA2boOmP5xpLW5bMbCi9xNucgIKS5hi1W8chza8Y
 wbeXG+sRUMACWQNpUeyDnlZ1BvSDOCfLI+qeAGLsW2QCEfV9mY7J+SdEU0xaWrkJO8islJFx5
 eK+DX1xrOADaqvWP5bpMaFQCFE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 20, 2020 at 5:15 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Sep 18, 2020 at 02:45:25PM +0200, Christoph Hellwig wrote:
> > Add a flag to force processing a syscall as a compat syscall.  This is
> > required so that in_compat_syscall() works for I/O submitted by io_uring
> > helper threads on behalf of compat syscalls.
>
> Al doesn't like this much, but my suggestion is to introduce two new
> opcodes -- IORING_OP_READV32 and IORING_OP_WRITEV32.  The compat code
> can translate IORING_OP_READV to IORING_OP_READV32 and then the core
> code can know what that user pointer is pointing to.

How is that different from the current approach of storing the ABI as
a flag in ctx->compat?

     Arnd
