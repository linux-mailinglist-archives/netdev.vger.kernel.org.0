Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B90F559EDA
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbiFXQug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiFXQub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:50:31 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563124EDCF;
        Fri, 24 Jun 2022 09:50:30 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id eo8so4365995edb.0;
        Fri, 24 Jun 2022 09:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D6bSR6eKZinN1uglMVeg9l3qo/AOUJIfypofdktuB4E=;
        b=WSBylA0owMVGcEdh93AP5NVJHW6tL1PlszLC9ZsTlN2oVBRMxpllo/mD84O2RdmM26
         wFQJI9sJatNUjam5txYBMCemE1OFvvi2HWRhScI90pNlIRzbvSQPlvUKhce06PN6Y3tm
         9H76N4O1AClN7AwJZuWcGJa8swByyAoFEdHGN7NlRU/+6A3qASSR3AdYlrPxm1LVxO4b
         zW5RgFjGKLCdSqKjXpNv0gai8dZBIQ3cNo4e1MmB2KPm57fxZpiix8E7X7M6IhTdaWBl
         Q63jZdSuMMhAKwRNlq/MfpERWaZyq9Izg+WPplhGNNS8dRsfKUwIW/OS3A9N7XPaEQCg
         pcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D6bSR6eKZinN1uglMVeg9l3qo/AOUJIfypofdktuB4E=;
        b=qwM+mxMLL3MZS/D1ZnPJTr2TuaD5W8f1yq433xumXqGuqOyS0brbFfRCSMgDH6f+oW
         KIEOHf6Xi8lL1za96Sxih1IGtQE5JDi1BrLSayYHGW6dV+K4H9zt//EYAjxwQngqcB8W
         LIC62LP0HGYPAEvyEWAJrDlsKFcMvwwwhUwZevD+SqeYBLvJPQaDdnRf0T6Ibzsy0WyC
         i1NaZGx3TivScVmUQpc9pkhWVK1xpdtuwwAQbNCYsL2i/TCa/mEtNXe3w7mf7IlNtKN5
         bjC/tFLxnmo2tBVWGzvhttqjVKB7d1yeSlgnjbgQkqhXtBs6/dSlyhYaU483RM4Lq7Rc
         WUIw==
X-Gm-Message-State: AJIora801lfhif4hdBbEtY4K4RFuhCyzj7SFZX2vQ5an0/QRmcJ1sAHi
        Mg+9xwaixuNqVE9l3rqS4rFWjqJIz7cgjyj1BYdLXUlqhYU=
X-Google-Smtp-Source: AGRyM1t+bTNZdEMZEsDZnO7STdl64p2wN3eY2r0luJn8BUEps4cKK8JgFGhhKrUrVSziA3+0tzaDUFTXjoLk97KmlLE=
X-Received: by 2002:a05:6402:3487:b0:435:b0d2:606e with SMTP id
 v7-20020a056402348700b00435b0d2606emr17614edc.66.1656089428911; Fri, 24 Jun
 2022 09:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-3-roberto.sassu@huawei.com> <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
 <796b55c79be142cab6a22dd281fdb9fa@huawei.com> <f2d3da08e7774df9b44cc648dda7d0b8@huawei.com>
 <CAADnVQKVx9o1PcCV_F3ywJCzDTPtQG4MTKM2BmwdCwNvyxdNPg@mail.gmail.com> <27e25756f96548aeb56d1af5c94197f6@huawei.com>
In-Reply-To: <27e25756f96548aeb56d1af5c94197f6@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 Jun 2022 09:50:17 -0700
Message-ID: <CAADnVQ+PnTOK-6dE2LMsjUU_OPksX=QVxZ-QvvaxDWTw7rRR5Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] bpf: Add bpf_lookup_user_key() and bpf_key_put() helpers
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

On Fri, Jun 24, 2022 at 8:32 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> > Sent: Thursday, June 23, 2022 10:54 PM
> > On Thu, Jun 23, 2022 at 5:36 AM Roberto Sassu <roberto.sassu@huawei.com>
> > wrote:
> > >
> > > > From: Roberto Sassu [mailto:roberto.sassu@huawei.com]
> > > > Sent: Wednesday, June 22, 2022 9:12 AM
> > > > > From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> > > > > Sent: Wednesday, June 22, 2022 12:33 AM
> > > > > On Tue, Jun 21, 2022 at 06:37:54PM +0200, Roberto Sassu wrote:
> > > > > > Add the bpf_lookup_user_key() and bpf_key_put() helpers, to respectively
> > > > > > search a key with a given serial, and release the reference count of the
> > > > > > found key.
> > > > > >
> > > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > > ---
> > > > > >  include/uapi/linux/bpf.h       | 16 ++++++++++++
> > > > > >  kernel/bpf/bpf_lsm.c           | 46
> > ++++++++++++++++++++++++++++++++++
> > > > > >  kernel/bpf/verifier.c          |  6 +++--
> > > > > >  scripts/bpf_doc.py             |  2 ++
> > > > > >  tools/include/uapi/linux/bpf.h | 16 ++++++++++++
> > > > > >  5 files changed, 84 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > > > index e81362891596..7bbcf2cd105d 100644
> > > > > > --- a/include/uapi/linux/bpf.h
> > > > > > +++ b/include/uapi/linux/bpf.h
> > > > > > @@ -5325,6 +5325,20 @@ union bpf_attr {
> > > > > >   *               **-EACCES** if the SYN cookie is not valid.
> > > > > >   *
> > > > > >   *               **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> > > > > > + *
> > > > > > + * struct key *bpf_lookup_user_key(u32 serial, unsigned long flags)
> > > > > > + *       Description
> > > > > > + *               Search a key with a given *serial* and the provided *flags*,
> > and
> > > > > > + *               increment the reference count of the key.
> > > > >
> > > > > Why passing 'flags' is ok to do?
> > > > > Please think through every line of the patch.
> > > >
> > > > To be honest, I thought about it. Probably yes, I should do some
> > > > sanitization, like I did for the keyring ID. When I checked
> > > > lookup_user_key(), I saw that flags are checked individually, so
> > > > an arbitrary value passed to the helper should not cause harm.
> > > > Will do sanitization, if you prefer. It is just that we have to keep
> > > > the eBPF code in sync with key flag definition (unless we have
> > > > a 'last' flag).
> > >
> > > I'm not sure that having a helper for lookup_user_key() alone is
> > > correct. By having separate helpers for lookup and usage of the
> > > key, nothing would prevent an eBPF program to ask for a
> > > permission to pass the access control check, and then use the
> > > key for something completely different from what it requested.
> > >
> > > Looking at how lookup_user_key() is used in security/keys/keyctl.c,
> > > it seems clear that it should be used together with the operation
> > > that needs to be performed. Only in this way, the key permission
> > > would make sense.
> >
> > lookup is roughly equivalent to open when all permission checks are done.
> > And using the key is read/write.
>
> For bpf_verify_pkcs7_signature(), we need the search permission
> on the keyring containing the key used for signature verification.

you mean lookup_user_key(serial, flags, KEY_NEED_SEARCH) ?

right. and ? what's your point?
