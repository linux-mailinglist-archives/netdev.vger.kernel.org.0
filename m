Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DA36AD62A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 05:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCGESc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 23:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjCGESM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 23:18:12 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D39B74A58;
        Mon,  6 Mar 2023 20:17:38 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ay14so43689177edb.11;
        Mon, 06 Mar 2023 20:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678162652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QTXjcayLZoZ4Jg8E7qsZ3gtXhW2rdu4DubQwwX1FJ4I=;
        b=QYh2DEkv2BMGpuJJDmLIX1WUe/a7HIX00XeWR3Kyvj1Tt9d3YeFdXt/3e40MCUM44p
         m5/fQwU6pN1gWJiYCEgyimDr+9mNryB3a4D75ampUl88kJV3DTUa/nrmc75f67Ra2Va3
         rXJBqHCJSHzGcjgCXAvPTHnQ1tAR6TRjdqOpMCTFaUJWaOra1aHQaMwk66rtN2uJzDBe
         h3FdGURc+qm7N7wrk2JwfxDEWH8Q4T8YqAZj1Za9xmjxtiA6gJQzHKgVrE4RMkEwo4OL
         1yTq94pnG8Q2t7I3deHKi3uuVbTqs9HQ2qll5nSoFncHOUkK1h1i2iYdkN7X5/OsqyDu
         TzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678162652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTXjcayLZoZ4Jg8E7qsZ3gtXhW2rdu4DubQwwX1FJ4I=;
        b=a9PmUwCS0OduELJsaJrXsWHJnA5o689gF6puzMWaGXG820EFmPxQHuP6TrvLOOpHkF
         twT9KZgpq+qPbPvY5nIeOV/78oAqN7RVw7uevygW9TUgqsyX8ci96zmgHorBm1SR6IC2
         P03XtiVE97wO5g/w5JfyXdMOTwWFK/7DzDUXM0HhK+WIWj4GnTPA3uuwvm66zsDyOoBW
         hnRuLcbb2ydPTDjbpwN5aYInqIeGMFsUocJpkBIQW+2joPRyQ+D4OC5k3XWqVm7Jh70c
         NmB6PzzWCyLDD4Xot9T4T2LFp4bvM88Bo//MTFcqXUsZS9wDbTyHOhrQqv7Nod5PjKRr
         iwOA==
X-Gm-Message-State: AO0yUKX+BO8P4NvwniEpLnbYnB0HM0F1PbFE/CoTq4LvlFY2x8gUt0zc
        rPUt2h+aPgnytC/DV/BVPHQPu/8tkckaz6LA7ZmDLDiKa0Y=
X-Google-Smtp-Source: AK7set+9D18dxn1tqA0s9eBHMgNpzz7jTmhfwaZbBkFF2okwzkos8TileTGlddttOhZNt6L/WK4bx/c60uE5Cm3/ijM=
X-Received: by 2002:a17:906:6b1a:b0:877:747d:4a85 with SMTP id
 q26-20020a1709066b1a00b00877747d4a85mr6451918ejr.3.1678162651705; Mon, 06 Mar
 2023 20:17:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.1677526810.git.dxu@dxuuu.xyz> <20230227230338.awdzw57e4uzh4u7n@MacBook-Pro-6.local>
 <20230228015712.clq6kyrsd7rrklbz@kashmir.localdomain> <CAADnVQ+a633QyZgkbXfRiT_WRbPgr5n8RN0w=ntEkBHUeqRcbw@mail.gmail.com>
 <20230228231716.a5uwc4tdo3kjlkg7@aviatrix-fedora.tail1b9c7.ts.net>
In-Reply-To: <20230228231716.a5uwc4tdo3kjlkg7@aviatrix-fedora.tail1b9c7.ts.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 6 Mar 2023 20:17:20 -0800
Message-ID: <CAADnVQKK+a_0effQW5qBSq1AXoQOJg5-79q3d1NWJ2Vv8SHvOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in BPF
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 3:17=E2=80=AFPM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> > Have you considered to skb redirect to another netdev that does ip defr=
ag?
> > Like macvlan does it under some conditions. This can be generalized.
>
> I had not considered that yet. Are you suggesting adding a new
> passthrough netdev thing that'll defrags? I looked at the macvlan driver
> and it looks like it defrags to handle some multicast corner case.

Something like that. A netdev that bpf prog can redirect too.
It will consume ip frags and eventually will produce reassembled skb.

The kernel ip_defrag logic has timeouts, counters, rhashtable
with thresholds, etc. All of them are per netns.
Just another ip_defrag_user will still share rhashtable
with its limits. The kernel can even do icmp_send().
ip_defrag is not a kfunc. It's a big block with plenty of kernel
wide side effects.
I really don't think we can alloc_skb, copy_skb, and ip_defrag it.
It messes with the stack too much.
It's also not clear to me when skb is reassembled and how bpf sees it.
"redirect into reassembling netdev" and attaching bpf prog to consume
that skb is much cleaner imo.
May be there are other ways to use ip_defrag, but certainly not like
synchronous api helper.
