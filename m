Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB0E558A66
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 22:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiFWUy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 16:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiFWUy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 16:54:28 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DFB62728;
        Thu, 23 Jun 2022 13:54:27 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lw20so695437ejb.4;
        Thu, 23 Jun 2022 13:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+NeDhzIsosAc6zjoUbMznd330rNHziGlr8pP4p3fVF0=;
        b=fAx3pvL2mb1wUs/cl1pnaZOCuwao8+6SnBAODybSfO6ROi8NVo0gsKiyWCmyMbmkMF
         b9S4yoI2SKgUW/Vp2Y4iNLOKbFtK0G6tdJi2kYeqDOqZaUlXCixb5Yx09/gLwJDkX9g2
         WYGdfXOv7BKXlYhDmhz/UJrZDqvzmK5TbDKG9S39mn/+cW6tq78J/W6GZrg7aeuMCjOx
         bz6q/v5o5SuZy856wRedvW5sCeM0PJprg1hDe5IvdltJYfCPXMmnNkS8QYXRUI89g290
         AiXG2CJPs4gS2iuURPvnSXllm4vbU7SppK6KhveNTjEuGhjUDsg5v1ziIpgHh/S2n47a
         lGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+NeDhzIsosAc6zjoUbMznd330rNHziGlr8pP4p3fVF0=;
        b=TX766x9RN6iQgt5sl+tL+hokKmzPlBmAP4pZaJYHgH0KdjW5GXjHOrjAb4/NEnjwkR
         2HluYevT3cIFFue8Pb86QW9XdVSPgmOA4/wttBPY1QzNrNxtSMSnUp+scG4JXkaWL5ZL
         1HAteUtbh1nk2L5SQuYXpXpuwjBzo5XqWiiPNma3d8ZjeJsPRO6vDt4ArLEAnT75dZvE
         xA+xUt3OW8yQ8oqGHpjN3cd9XyxfLtpMnMoNPOSI0N3Kfw5EsY8+8Bq/rx4oISwqFij3
         e07OxdiXszyqwmmd3SwqGWDz6mvcvjyemsbwaXgsyzhf6Vd0Mv2t/DM605ZWL/uelRQS
         NsJQ==
X-Gm-Message-State: AJIora8nans6J/nKolpLjuTJFNSps6ppc1ngspxo2bxcdRJwsG1yRg3t
        JTXFZw0yABTCuwMBgdk7ESXFtQonNt4zvqX/ma0=
X-Google-Smtp-Source: AGRyM1uthzr9Oy84rLqxABiXeKGAOyvcg+MqzD8Qykjqulo8c8PXkSAiveDwBCRGCtZDd07fq0RBqRpxnYdg/51DLHM=
X-Received: by 2002:a17:907:971e:b0:71d:955c:b296 with SMTP id
 jg30-20020a170907971e00b0071d955cb296mr9639163ejc.633.1656017665626; Thu, 23
 Jun 2022 13:54:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-3-roberto.sassu@huawei.com> <20220621223248.f6wgyewajw6x4lgr@macbook-pro-3.dhcp.thefacebook.com>
 <796b55c79be142cab6a22dd281fdb9fa@huawei.com> <f2d3da08e7774df9b44cc648dda7d0b8@huawei.com>
In-Reply-To: <f2d3da08e7774df9b44cc648dda7d0b8@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 23 Jun 2022 13:54:13 -0700
Message-ID: <CAADnVQKVx9o1PcCV_F3ywJCzDTPtQG4MTKM2BmwdCwNvyxdNPg@mail.gmail.com>
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

On Thu, Jun 23, 2022 at 5:36 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> > From: Roberto Sassu [mailto:roberto.sassu@huawei.com]
> > Sent: Wednesday, June 22, 2022 9:12 AM
> > > From: Alexei Starovoitov [mailto:alexei.starovoitov@gmail.com]
> > > Sent: Wednesday, June 22, 2022 12:33 AM
> > > On Tue, Jun 21, 2022 at 06:37:54PM +0200, Roberto Sassu wrote:
> > > > Add the bpf_lookup_user_key() and bpf_key_put() helpers, to respectively
> > > > search a key with a given serial, and release the reference count of the
> > > > found key.
> > > >
> > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > ---
> > > >  include/uapi/linux/bpf.h       | 16 ++++++++++++
> > > >  kernel/bpf/bpf_lsm.c           | 46 ++++++++++++++++++++++++++++++++++
> > > >  kernel/bpf/verifier.c          |  6 +++--
> > > >  scripts/bpf_doc.py             |  2 ++
> > > >  tools/include/uapi/linux/bpf.h | 16 ++++++++++++
> > > >  5 files changed, 84 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > > index e81362891596..7bbcf2cd105d 100644
> > > > --- a/include/uapi/linux/bpf.h
> > > > +++ b/include/uapi/linux/bpf.h
> > > > @@ -5325,6 +5325,20 @@ union bpf_attr {
> > > >   *               **-EACCES** if the SYN cookie is not valid.
> > > >   *
> > > >   *               **-EPROTONOSUPPORT** if CONFIG_IPV6 is not builtin.
> > > > + *
> > > > + * struct key *bpf_lookup_user_key(u32 serial, unsigned long flags)
> > > > + *       Description
> > > > + *               Search a key with a given *serial* and the provided *flags*, and
> > > > + *               increment the reference count of the key.
> > >
> > > Why passing 'flags' is ok to do?
> > > Please think through every line of the patch.
> >
> > To be honest, I thought about it. Probably yes, I should do some
> > sanitization, like I did for the keyring ID. When I checked
> > lookup_user_key(), I saw that flags are checked individually, so
> > an arbitrary value passed to the helper should not cause harm.
> > Will do sanitization, if you prefer. It is just that we have to keep
> > the eBPF code in sync with key flag definition (unless we have
> > a 'last' flag).
>
> I'm not sure that having a helper for lookup_user_key() alone is
> correct. By having separate helpers for lookup and usage of the
> key, nothing would prevent an eBPF program to ask for a
> permission to pass the access control check, and then use the
> key for something completely different from what it requested.
>
> Looking at how lookup_user_key() is used in security/keys/keyctl.c,
> it seems clear that it should be used together with the operation
> that needs to be performed. Only in this way, the key permission
> would make sense.

lookup is roughly equivalent to open when all permission checks are done.
And using the key is read/write.

> What do you think (also David)?
>
> Thanks
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Yang Xi, Li He

Please use a different email server and get rid of this.
