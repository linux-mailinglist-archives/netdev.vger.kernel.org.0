Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789EE3451ED
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhCVVkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCVVkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28117619A9;
        Mon, 22 Mar 2021 21:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616449204;
        bh=ZjEe7Re0RKu002ndI22T8BlfDJ+aY+HHY+t9XvQS7Q8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bJZCpZ5EEGZerp3UrSyvokIM6nH3GPNLIsyJMJB5nyc4Sgnjtzn+OMtjUL2ZBSie+
         Fi83eey5HsMSKc/9qaD2RuZEeUeUwoE2M6qwk7wrSCjkj4ws8OGv18z8EyYcukmWHT
         jM35+ir6/srZfSH78DCRwpRXtTCanNR0ouNRk+r0zZqC9uicwbh5Vl6qVN2J0nC7fg
         yAR8A/u0nDcj41ohiNdL688eDQ2opEHdctaDOmgytVvpFgfvzBz92vFYBp5Nn21+zL
         vtNIUbcaOAFjelvCYqZ6uXvufN0DecSq4tETddYi+zxgAsQXGrS7YO4xRruhTqWyYj
         CraMDT8xmXxbw==
Received: by mail-ot1-f44.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso17476595otq.3;
        Mon, 22 Mar 2021 14:40:04 -0700 (PDT)
X-Gm-Message-State: AOAM533FUOhFfO7wq9f+GsWOzKkBqFJJDy1x14lvq359GYXwWaCk6hUk
        iGNe8yk9vCXFksLX6c2bH7EqB0oZSmM8DFSdmWI=
X-Google-Smtp-Source: ABdhPJzNzw6/c6SVRTMWeDvzQfOYlqmnHJ7XZUtZKGXGAyd4E2bODGHMqyepsXMnLh1hlMatZvPmNE5xJdhqw6/8ZCE=
X-Received: by 2002:a9d:316:: with SMTP id 22mr1561463otv.210.1616449203436;
 Mon, 22 Mar 2021 14:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
In-Reply-To: <20210322202958.GA1955909@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 22 Mar 2021 22:39:47 +0100
X-Gmail-Original-Message-ID: <CAK8P3a10d8hgBiO5W=34oLqw8m22=Xi4C=MxVSY_fGnXZUJ3iA@mail.gmail.com>
Message-ID: <CAK8P3a10d8hgBiO5W=34oLqw8m22=Xi4C=MxVSY_fGnXZUJ3iA@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Sebor <msebor@gcc.gnu.org>,
        Ning Sun <ning.sun@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        tboot-devel@lists.sourceforge.net,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        ath11k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 9:29 PM Ingo Molnar <mingo@kernel.org> wrote:
> * Arnd Bergmann <arnd@kernel.org> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>

> This is indeed rather ugly - and the other patch that removes a debug
> check seems counterproductive as well.
>
> Do we know how many genuine bugs -Wstringop-overread-warning has
> caught or is about to catch?
>
> I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
> until GCC-11 gets fixed?

See the [PATCH 0/11] message. The last two patches in the series are for
code that I suspect may be broken, the others are basically all false positives.

As gcc-11 is not released yet, I don't think we have to apply any of the
patches or disable the warning at the moment, but I posted all the patches
to get a better understanding on which of them should be addressed in
the kernel vs gcc.

       Arnd
