Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8061C9BDCB
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 14:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfHXMwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 08:52:00 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42794 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbfHXMwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 08:52:00 -0400
Received: by mail-lj1-f194.google.com with SMTP id l14so11221456ljj.9;
        Sat, 24 Aug 2019 05:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YWjQDcR3SyjBjxbrtuLUq15ebNFkva/QIGban7v8NSc=;
        b=mjNQ/LdS0aYAyb0aqPuW5wdN3YlRF/aY6wvqim/K3eNJKoos8w0+Eb2qZjLRMjVA3r
         e+qpbjYWeUbhENYe9cB3n//mvgqYKl9tfCoSFk1kTkM0eVkKpuMLU/aPXOjTuEuGM76T
         WYptAt1v6Zux5ZhuEVRY3i5G0DqoysOiTbavafxIiHcYcPYaWKuEvWNdyNgKHriK4xmR
         50lFPUtc56azVVthFub54oQijZmrJN4MOa0harJ1YioeZyfCVFbMJW/byyynQttQEw1i
         PPzGJ9gWDniIM2hhmQDLEoaOPcqYrAEeD9KilkLlshJ9CsnbodjQKLDs3op6f7XWb6Hs
         c4uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YWjQDcR3SyjBjxbrtuLUq15ebNFkva/QIGban7v8NSc=;
        b=O/BvJfcAAypPozbmk4Fvu0FfINTiMJ7xKfCz9zatPiL24Limrp0qlPQGQN7XRDCVak
         tvbFDxXNFzk145rnSrsy7serVv9Zmj9bpcpczKNIY5zbPr/I1pJgxLa49h1TywWBelTC
         hbJrXiKFW0/PVdaaRv1FXpOy1vtjqjbBhx48TSlnKbpkEtZDvswm2Gtan/KPGz8Gv5bf
         QvedXKiEnr8BoY5Qrd5jf+lk2ihO6ZRn/CCIZYLsBVbu+sHFRnZ3PwCCUD7VzqNxKjiI
         O5oWmQxxrFJIppLSJ+v4EWNcWYk4VXu1YPOFLwLg/AG7gPT7mk9vDA+qRB4xkFDzk8ur
         cROQ==
X-Gm-Message-State: APjAAAWwyz4BkZWWRxoCX9oyEY2gvvqz7SyJf/bgVnNUTZelLgaF3/LK
        hfu7XPZdqoet5cfJ/wI9F9jYjS2r8RHK5fRMe4A=
X-Google-Smtp-Source: APXvYqyHtw1FTYe9kkYawhnkpb+wecngYXNr30IXM7HV/hlNB81jnyil/sZTAUEmSRyUiWt5CVdf6rHd0I8KkCLnAZk=
X-Received: by 2002:a2e:9d90:: with SMTP id c16mr5739562ljj.221.1566651117285;
 Sat, 24 Aug 2019 05:51:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
 <20190812215052.71840-14-ndesaulniers@google.com> <20190813083257.nnsxf5khnqagl46s@willie-the-truck>
In-Reply-To: <20190813083257.nnsxf5khnqagl46s@willie-the-truck>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sat, 24 Aug 2019 14:51:46 +0200
Message-ID: <CANiq72mXvuVdO2i9gobmh9YeUW4bhe7YnqQc6PaZrbqua1DoYw@mail.gmail.com>
Subject: Re: [PATCH 14/16] include/linux: prefer __section from compiler_attributes.h
To:     Will Deacon <will@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Yonghong Song <yhs@fb.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        David Windsor <dwindsor@gmail.com>,
        Marc Zyngier <maz@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        Dou Liyang <douliyangs@gmail.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sparse@vger.kernel.org, rcu@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:33 AM Will Deacon <will@kernel.org> wrote:
>
> -ENOCOMMITMESSAGE
>
> Otherwise, patch looks good to me.

Do you want Ack, Review or nothing?

Cheers,
Miguel
