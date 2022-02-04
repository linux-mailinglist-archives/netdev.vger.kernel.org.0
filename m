Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5084A920A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 02:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356534AbiBDBfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 20:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiBDBfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 20:35:06 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AEDC061714;
        Thu,  3 Feb 2022 17:35:06 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i30so3767176pfk.8;
        Thu, 03 Feb 2022 17:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2bpGEL1s7vwy9yPRn1lbRnxaJLI1WAuazQwx6NrRDQY=;
        b=czQEscCtwlYRzgBzIFtw1PupejjJC/HH6fUW/QGebzll5RE15jdecT1kb53Ep81cT9
         CX2to994pbDs6YT8TFL9PsHwAioVntitZikiCNfM/s/8hiwKlQisJB5ZFHUMqng2/wYb
         wOdxyCd5Tx9Gr8juHLUn6oQoOhAb1XHthF9DY8urZll2TBj1v1t2nBH3zJB3FIjjvjLH
         1B7RgsvgW/2NgV4XLaYvQb9vRrSJDyOeJVvjkBnbhbNTgMz7ICVUj0h8exXmyEt2W/i4
         vmGj9m5h9Z0tgFXbhBsIGM4AZEkaWFsifKimV4aw7EDCbIX8FiQUtEsbQxSm//ni+yOM
         HiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2bpGEL1s7vwy9yPRn1lbRnxaJLI1WAuazQwx6NrRDQY=;
        b=uy8o+YWYGNmuhLXqmHj+Sr5Vzd6SmRaAsBB0qdnYOXN2pPyeNptH782Aq2CqsETFpw
         QUwzOfQmA1uynLhuwo/KjhLHlgx7FRWjqjt+AysBmXC5xeKOlBUst/UQyhmWAsxUZQvU
         GLvfRfzS18EDfivo30wb9Be08i6f+TFOZRKlArVSd+Gx9vNUB2U+nSp45WwqtglwJxDC
         39DpXqha1CDMBgq+MJfVAFNKC3osOMJrDUGDBtcL8DkinvGs3DkUc6hYdEeMV/rakH1K
         BjJR45Uf6/wAst2KxnbyU4RT30eEBmPAdemFOgq29oFZCILq/Mkr53vZjYAA5yg10vhP
         3gCw==
X-Gm-Message-State: AOAM533+VIOIuFjBrVzyQyY4z67IdgyKQHmN4nZl0oqxdGGuzIq3WH4y
        Oyc0gDB9bx6sNnjKDx+PlsyA6MCGtQfTgo+J79M=
X-Google-Smtp-Source: ABdhPJzlcHJJ9cjr7j9mNMGV9qin+A2a4K9zPmGHjXnh50EbOAqrDhjI/toPjUuZ1c87JIht7o/ot/2oTc8mbONZMoA=
X-Received: by 2002:a63:5b43:: with SMTP id l3mr611410pgm.375.1643938505671;
 Thu, 03 Feb 2022 17:35:05 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <CAADnVQ+hTWbvNgnvJpAeM_-Ui2-G0YSM3QHB9G2+2kWEd4-Ymw@mail.gmail.com>
 <Yfq+PJljylbwJ3Bf@krava> <CAADnVQKeTB=UgY4Gf-46EBa8rwWTu2wvi7hEj2sdVTALGJ0JEg@mail.gmail.com>
 <YfvvfLlM1FOTgvDm@krava> <20220204094619.2784e00c0b7359356458ca57@kernel.org>
In-Reply-To: <20220204094619.2784e00c0b7359356458ca57@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Feb 2022 17:34:54 -0800
Message-ID: <CAADnVQJYY0Xm6M9O02E5rOkdQPX39NOOS4tM2jpwRLQvP-qDBg@mail.gmail.com>
Subject: Re: [PATCH 0/8] bpf: Add fprobe link
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 4:46 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
>
> I thought What Alexei pointed was that don't expose the FPROBE name
> to user space. If so, I agree with that. We can continue to use
> KPROBE for user space. Using fprobe is just for kernel implementation.

Clearly that intent is not working.
The "fprobe" name is already leaking outside of the kernel internals.
The module interface is being proposed.
You'd need to document it, etc.
I think it's only causing confusion to users.
The new name serves no additional purpose other than
being new and unheard of.
fprobe is kprobe on ftrace. That's it.
Just call it kprobe on ftrace in api and everywhere.
Please?
