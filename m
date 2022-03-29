Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E894EB1CA
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239710AbiC2Q2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbiC2Q1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:27:47 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DDC229C85;
        Tue, 29 Mar 2022 09:26:03 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v4so18004494pjh.2;
        Tue, 29 Mar 2022 09:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zSrzL4RcvPdwRrem0JkeQUvfghxscmF/IIS73/4ISuM=;
        b=bPfDbjpxT0DjSxL1JWnNIzaPLGLUUme9ZWh2cGwHb8l0KU6et+OSmZSHXDAfDMlBV7
         x9enOeMebdZsaPVu+3jwjyR3vpUVE315M4onO3XK9p5P/ErHPsG9n/RzTrJM32YLmVB2
         cjssIk65ai2vA3WifAewBN9c3HxMWnLGaE4Fs7X8RW48MOb4EFTFTm7EajCtTffqUZea
         BczMb7mH+NRyho4RPrfgnI7gwT47rolAYjj5kOyhWxinpzVAfA6CeoQBHcd/hFn0CqJ7
         DXvT6jKqwuSmbYPA2nnwELtAawLRF2kERBojv9dTU5loc10Wx26v2/2fkrWPSaqxXx4N
         ZDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zSrzL4RcvPdwRrem0JkeQUvfghxscmF/IIS73/4ISuM=;
        b=YhWl/AWyOvZFl2WiCZGbzG5Fcy0XW5gEzQ+3eozb58oNaDTxJjAVd91c03I20tsQt7
         G90SUIOSuEDLfttOjksmPSfH7QTWBj97DPFULCJfLBhuXjrI3WufwbZcJZd/C4TTB97P
         F/F+qrKtKruIkmYEVWAqSez4LUALg3tbYro8NX1YUeJk8OWLrXXIZ6/jTDQ1gYShoYKQ
         uawOx0ACH34wUOpLxuyLlPMKUboxICi9bIa5tFB+OLaaq8x0lXlBD5xvLPRv/OUBU2/i
         RPlCTER0dRR7FU5WGr5BdKZ/RygXsYEu70GE4cGxHP0Rss8DVh5yj2Mxa23tJJp/zA6p
         Uy6g==
X-Gm-Message-State: AOAM5313NtsQ++66AMAqUzELV9SF6cfcv1LdT4d7680McBSI5YnxZsjt
        E+vg3XcfGcHvWzRHK1zeRqk4gLk2W1HJ8/a34gY=
X-Google-Smtp-Source: ABdhPJy1y4rAeGRjAUma3/+QC6ZygqH6gCxyxvl+xjD9wME0wCYbFyY6Gq6YQ7F/SN+20kvJeSyRdQJx/ECNTEFRVzA=
X-Received: by 2002:a17:902:ba83:b0:154:727e:5fc5 with SMTP id
 k3-20020a170902ba8300b00154727e5fc5mr31922203pls.55.1648571163362; Tue, 29
 Mar 2022 09:26:03 -0700 (PDT)
MIME-Version: 1.0
References: <2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com>
 <20220329002935.2869-1-beaub@linux.microsoft.com> <1014535694.197402.1648570634323.JavaMail.zimbra@efficios.com>
In-Reply-To: <1014535694.197402.1648570634323.JavaMail.zimbra@efficios.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 29 Mar 2022 09:25:52 -0700
Message-ID: <CAADnVQK=GCuhTHz=iwv0r7Y37gYvt_UBzkfFJmNT+uR0z+7Myw@mail.gmail.com>
Subject: Re: Comments on new user events ABI
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Beau Belgrave <beaub@microsoft.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
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

On Tue, Mar 29, 2022 at 9:17 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> >
> >> include/uapi/linux/user_events.h:
> >>
> >> struct user_bpf_iter {
> >>
> >>         /* Offset of the data within the first iovec */
> >>         __u32 iov_offset;
> >>
> >>         /* Number of iovec structures */
> >>         __u32 nr_segs;
> >>
> >>         /* Pointer to iovec structures */
> >>         const struct iovec *iov;
> >>
> >>                            ^ a pointer in a uapi header is usually a no-go. This should be a u64.
> >> };
> >>
> >> include/uapi/linux/user_events.h:
> >>
> >> struct user_bpf_context {
> >>
> >>         /* Data type being passed (see union below) */
> >>         __u32 data_type;
> >>
> >>         /* Length of the data */
> >>         __u32 data_len;
> >>
> >>         /* Pointer to data, varies by data type */
> >>         union {
> >>                 /* Kernel data (data_type == USER_BPF_DATA_KERNEL) */
> >>                 void *kdata;
> >>
> >>                 /* User data (data_type == USER_BPF_DATA_USER) */
> >>                 void *udata;
> >>
> >>                 /* Direct iovec (data_type == USER_BPF_DATA_ITER) */
> >>                 struct user_bpf_iter *iter;
> >>
> >>                                ^ likewise for the 3 pointers above. Should be u64 in uapi headers.
> >>         };
> >> };
> >>
> >
> > The bpf structs are only used within a BPF program. At that point the pointer
> > sizes should all align, right?
>
> I must admit I do not know enough about the eBPF uapi practices to answer this.
> [CCing Alexei on this]

Mathieu,

Thanks for flagging.

Whoever added this user_bpf* stuff please remove it immediately.
It was never reviewed by bpf maintainers.

It's a hard Nack to add a bpf interface to user_events.
