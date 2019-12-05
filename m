Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBB9113975
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfLEB7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:59:31 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43802 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfLEB7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:59:31 -0500
Received: by mail-lj1-f193.google.com with SMTP id a13so1575060ljm.10;
        Wed, 04 Dec 2019 17:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oWkFNr4QlzStNffmGQUvt/xh0lAmaw/Gu1WQ6Zzy3Q8=;
        b=PH5IvmNPvyK5JL4kIAAyXiwS3sHEk2AcY9mZMzlKd0bp4mNgOOJt8Vc8dPpHq3tNT/
         iUiQ5nIPcJBPv9bQ00sHXJHz11TKVfkM0Ntq3d4lEPya71oS+D40qvNuSLN5Ea09hd2e
         Q7okCQUF0xJ1ldcENmtUy3i3mcz5oQu0QZNulsVmHx8kS51Z8BKL7E+OJ6NOas/z7Jpp
         aIINBSt5/ZHvrrGtf/jxnyE08OLh1HVBCUhV8Dg0gMMd7T/vlfAqE2UainiMPsTnuV2a
         dzVRGP7WKuIiu1PSWv45JrP7GtktVLr02IlkU3UV7GTzMRimqbMvGjbIi3QHxy6A7xnw
         ew5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oWkFNr4QlzStNffmGQUvt/xh0lAmaw/Gu1WQ6Zzy3Q8=;
        b=DqqX4W3eO2IgYMC0YKt6z9j9L1jQMocaTTLzSOUXaP6Z8ydznJgLjOS/e2JhY+UDYq
         SHZz5UQ5JgUiSxifNWr0aoKIPIgO9aNedhZpyZCn/w907+IjPV+XjW1pVANQXi7Q2umz
         Y9EzWdiOaawuCHXeXS1+I34lsOm4nygb00fbEKMZu2ntsTPI/IoPRMrRhMXcq2kcP8TH
         u+tAgz6Tu7WRObv7YFYMr0821RBj0NyEAl9izv6CyVNfUnFEfEbiTfwowbv+LH9LsKDa
         /ND43kBSWhsCekgmH7po36E13Y6GoJvMBqZ23l50m43AR7Laq15aDZB4gzDbxDKWCdId
         FZkQ==
X-Gm-Message-State: APjAAAUpAWQI7utc36SX4q7+G6fnhW+iH5Nk6vndvJP8JS5S8gJxbXqI
        b49JYgOeVBJonCkHEkOTQyW3U7MWhgECvGL0m6E=
X-Google-Smtp-Source: APXvYqxJXZogFBPqDe217DfUqObeOYrjvUFgdG8aYQ/KRrdaUCaHT4B9wzlaC3MctFZXQUAopOXqjPMGLlD6TEGsPUM=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr3815196lji.136.1575511169140;
 Wed, 04 Dec 2019 17:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20191202215931.248178-1-sdf@google.com>
In-Reply-To: <20191202215931.248178-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 4 Dec 2019 17:59:17 -0800
Message-ID: <CAADnVQ+=vqK9hbNbaRPtJSVGqN4EP=tDpPam7+1b7g0A1SGo_Q@mail.gmail.com>
Subject: Re: [PATCH bpf v2] selftests/bpf: bring back c++ include/link test
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 1:59 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
> converted existing c++ test to c. We still want to include and
> link against libbpf from c++ code, so reinstate this test back,
> this time in a form of a selftest with a clear comment about
> its purpose.
>
> v2:
> * -lelf -> $(LDLIBS) (Andrii Nakryiko)
>
> Fixes: 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks
