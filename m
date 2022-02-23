Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091274C1E18
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 22:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240606AbiBWV7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 16:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiBWV7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 16:59:15 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBC450442;
        Wed, 23 Feb 2022 13:58:46 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id c14so259645ilm.4;
        Wed, 23 Feb 2022 13:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SeBku3V4TaOpbCHf2mOteBWK7lzEcVbSOWaeQn/aOXM=;
        b=GLvWU7Y7zQOOdQkVluTt+awfPYu/WjpQqoRTn03UZkz1DbH9WB3rCUjoxGbB7lvZdy
         XN68ZQR2ZKnVfA8ylOsnZY5b5RIPdIWzJyWKkKmLyA8kQnmSrwcQPAaQc6wV0GzExHgA
         Gi5wqgxC9fWINoPl7HAjI4D67Qg4woTH3SwNVKeF6dEbKPAF/T06wr4HUbhq3XbLU1rE
         teXzZB4Yav8dnKM67ZtXDKODoTJD+jhibO4NQKFjDBspxh6MBSWd02xO5WRLm0Jk8foz
         PcxcuHA2NhczjQHfYFSWpKEAJBky2BBokZpf97T8oPKs0FI20gbABoFIJCgfhsM2SKh0
         /S+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SeBku3V4TaOpbCHf2mOteBWK7lzEcVbSOWaeQn/aOXM=;
        b=JdH6iJzQU5MGgDArS6uRA16zR8Gz3+hIi3BjnJ8j7J3p4f/XQCZmrwVjo9Y8szE8rx
         YjCDPrY8IFCk/4Jj9IQilQ89RMV2ddE6J61Ndb1Udg+y+4SKo0imL/cnED+n/+yKrMiA
         BxfmI42qActoorH8l0ESRhD91Mg1jNMJTZ5sJi0To0qPOncF64L4de0m0/8fo+Vlq5SL
         LKZenDQCQDxt2ijjbkH/IXo+haUO8Vsds0Y7F2oqdONocpXdmGj4T1j0U3qCLH2GjSpD
         tOJPRjrWlzmfFTluwuSaPFanHNQpHID5utHFM/SsH/BzlMsI+3xzBVwBUmv1nTJjW4+L
         4GBQ==
X-Gm-Message-State: AOAM530ogo0khiKARCzbjqwIm9zZc/hPD+7sCxP0a2QeWuEgjoYUZj9e
        17X+STEmelC/KdJzblTNzovHSCdk73qHekYs2/JhkQj6m78=
X-Google-Smtp-Source: ABdhPJxk2Bq8sJ6sfkWLtdiEzIO4fXpRQUyLFBAtcN4WsZ9VOEOzQV/8tNBD8ZimmqxCyPv6ALdDmisV4/4m75YNTp0=
X-Received: by 2002:a92:c148:0:b0:2c2:615a:49e9 with SMTP id
 b8-20020a92c148000000b002c2615a49e9mr1459221ilh.98.1645653526392; Wed, 23 Feb
 2022 13:58:46 -0800 (PST)
MIME-Version: 1.0
References: <7b2e447f6ae34022a56158fcbf8dc890@crowdstrike.com>
 <CAEf4BzbB6O=PRS7eDAszsVYEjxiTdR6g9XXSS4YDRh8e4Bgo0w@mail.gmail.com> <35873e0695014029a290ceb8cc767a7d@crowdstrike.com>
In-Reply-To: <35873e0695014029a290ceb8cc767a7d@crowdstrike.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Feb 2022 13:58:35 -0800
Message-ID: <CAEf4Bzbka1YAbFtVMU=KvCH6onFzB==F88vKSywypDLa+x2mBg@mail.gmail.com>
Subject: Re: Clarifications on linux/types.h used with libbpf
To:     Marco Vedovati <marco.vedovati@crowdstrike.com>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Martin Kelly <martin.kelly@crowdstrike.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 12:18 PM Marco Vedovati
<marco.vedovati@crowdstrike.com> wrote:
>
> From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Sent: Thursday, February 17, 2022 11:08 PM
> To: Marco Vedovati
> Cc: bpf@vger.kernel.org; toke@redhat.com; netdev@vger.kernel.org; kernel-team@fb.com; Martin Kelly; ast@kernel.org; daniel@iogearbox.net; davem@davemloft.net; Andrii Nakryiko
> Subject: [External] Re: Clarifications on linux/types.h used with libbpf
>
> > On Tue, Feb 15, 2022 at 4:58 AM Marco Vedovati
> > <marco.vedovati@crowdstrike.com> wrote:
> > >
> > > Hi,
> > >
> > > I have few questions about the linux/types.h file used to build bpf
> > [cut]
> >
> >
> > include/uapi/linux/types.h (UAPI header) is different from
> > include/linux/types.h (kernel-internal header). Libbpf has to
> > reimplement minimum amount of declarations from kernel-internal
> > include/linux/types.h to build outside of the kernel. But short answer
> > is they are different headers, so I suspect that no, libbpf can't use
> > just UAPI version.
>
> Thank you for clarifying some of my confusions.
>
> So if I understood correctly, the only use of libbpf:include/linux/types.h
> is to allow building the library out of the kernel tree.
>
> An ambiguity I have found is about what version of linux/types.h to use
> use when building bpf source code (that includes <linux/bpf.h>).
> I saw 2 options:
>
> - do like libbpf-bootstrap C examples, that uses whatever linux/types.h
>   version available on the building host. This is however adding more
>   dependencies that are satisfied with extra "-idirafter" compiler options.
>
> - do like bpftool's makefile, that builds bpf source code by including
>   tools/include/uapi/. This does not require the "-idirafter" trick.

Applications shouldn't be building against Linux-internal
include/linux/types.h. It should always be resolved to
include/uapi/linux/types.h.

>
> Anyway, checking the history of "tools/include/uapi/linux/types.h", I
> believe that this file is mistakenly licensed as "GPL-2.0" instead of
> "GPL-2.0 WITH Linux-syscall-note". I may come up with a patch to fix it.
>
> >
> > Thanks,
> > Marco
>
