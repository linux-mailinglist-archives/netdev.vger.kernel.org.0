Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB53495DA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbfFQX1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:27:47 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41804 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQX1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 19:27:47 -0400
Received: by mail-lf1-f66.google.com with SMTP id 136so7804972lfa.8;
        Mon, 17 Jun 2019 16:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QisCyCC54c07CEBGHobCKmvjRF6o16SJc0jsMHiIM7g=;
        b=hmbtH/IfkTu93XQQwhf9/9RUweB6+Pdartk6RdwC3ujCAXPsDneN73WM2Hw6zzgplF
         o7wbH2U1mFiDhflep7nxzQPruUf5LPsv1/RDuoED2C8iJvORZO4Q51hE6PKj8zf+XT02
         Go0FvHXeUdMEpyVozJjoKBAyX2WRsD4U+qFegmfvZ8Jwx7UwzrKxAPa0yoFSQ7zUau31
         XQXra2NH249uB7f7y613KX2GA/CcwKWiWN1LskOTdoGLzdz02gH8qjeCBd7+qce9BEhL
         1ElRkaIGUbi1djaHAQcyLVgeVmwIr6aHK7sOBZ7Ri9a/YNNQuWACWWDv/RxnMqH8vCZY
         am6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QisCyCC54c07CEBGHobCKmvjRF6o16SJc0jsMHiIM7g=;
        b=ETGC6yW2fBM0f+4ah5TeN63ufmwnP/ITh4x0fOEFU2EjkBGPHG7W0ZmiM4cXBHzbo2
         lve5L4i0VDFUvd57gHzzkiioQuSBXzt7xrVODC8vTCeSIXzO7ItDBo6KYz7MHb1T3t9k
         QVeOPkD7Md1nNooLxlwiES7grqNNMGTxPFLufhAtHW0ZaIzp1TtPmKWIlow3ipvcownf
         I4gE2aBLoCc2Gi3mUZgoP1Ms3kNEr0vxP3dJfCif7GQX/QCAr++HsZAB85OAc7DFedLJ
         Qd/8eQTrG9nEcMaouSXDnimKoEbVXLjBj228xJ9TL/1tkDiyvDN141drEKLLuS3lGP4O
         Gr9A==
X-Gm-Message-State: APjAAAVKcpG+RLvJvqrq0HIKMtRG14KT9+XZ/aH/L5AKe5etnym/mdHI
        JlBRsa6OwfnN3BYvaLAuPz6hU/KdNOxfhCvzCXc=
X-Google-Smtp-Source: APXvYqyfOPEJkS/5em0MecrHc0LkqJOWEx/G9vo7GL/zaM1yWRKjGDG3BHUevUEtJb9/Oph3JOElDJ6u3YctS6Eiq58=
X-Received: by 2002:ac2:46f9:: with SMTP id q25mr4317288lfo.181.1560814065032;
 Mon, 17 Jun 2019 16:27:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125724.1616165-1-arnd@arndb.de> <CAADnVQ+LzuNHFyLae0vUAudZpOFQ4cA02OC0zu3ypis+gqnjew@mail.gmail.com>
 <20190617190920.71c21a6c@gandalf.local.home> <75e9ff40e1002ad9c82716dfd77966a3721022b6.camel@fb.com>
In-Reply-To: <75e9ff40e1002ad9c82716dfd77966a3721022b6.camel@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 17 Jun 2019 16:27:33 -0700
Message-ID: <CAADnVQKCeHrq+bf4DceH7+ihpq+q-V+bFOiF-TpYjekH7dPA0w@mail.gmail.com>
Subject: Re: [PATCH] bpf: hide do_bpf_send_signal when unused
To:     Matt Mullins <mmullins@fb.com>
Cc:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Song Liu <songliubraving@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "arnd@arndb.de" <arnd@arndb.de>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 4:13 PM Matt Mullins <mmullins@fb.com> wrote:
> >
> > The bug (really just a warning) reported is exactly here.
>
> I don't think bpf_send_signal is tied to modules at all;
> send_signal_irq_work_init and the corresponding initcall should be
> moved outside that #ifdef.

right. I guess send_signal_irq_work_init was accidentally placed
after bpf_event_init and happened to be within that ifdef.
Should definitely be outside.
