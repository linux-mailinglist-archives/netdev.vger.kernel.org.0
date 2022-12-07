Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C83645D57
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLGPMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiLGPLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:11:54 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83DC461B8C
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:11:51 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a14so13657273pfa.1
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 07:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lN+y24HtPTtYsU4nJrvB6CVlWdApjZBrH5S1DCC2kXg=;
        b=IFcVuLFIXQyhqB7xwRNHbt8wlXk/GKwZ+NAtI2ye9vGnU3euJUumbJIKXGyssRypFI
         /xeN15jHdNFC+Nznb5rWm+oOs14M/9PXLMCqWXEa/mcxJyZp6a+XNMIG8ImuXsDpyl50
         fByLpxnsTKAZu7FCkhxvobLNcqkoQHxtpIC7s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lN+y24HtPTtYsU4nJrvB6CVlWdApjZBrH5S1DCC2kXg=;
        b=J6u+waizkxISJTPoLH1i7HrVHEF7/Bew7Xuml3t/mau24GKKWVgR7ofMppe+tgAAk8
         kDcKvtwyPZjNc7XSaU95WQhjD6/7dZb0UibSUgGWfDAWABY780SsrCzXSVvAS6Epo+Ju
         GlFtsYWC1CXxJR7RqZL2r9wkFDi9fv3WrjyRUMwuoMQ2ersLVk7jp3AuHRku34w3QQ4R
         NDZurmx1VJyzdtLzqRicuZ3nNX6uLeYpKuU7EXV03DoIfZg/9yUqY3SqZr8e+LiLvxfK
         07MYO46Iwyjco+eEdUvwsWPoWB9AC68Da7H5HKlyauXL6ET/FNSQ8d+nhFbuHQRK2gwS
         +fSQ==
X-Gm-Message-State: ANoB5pl6WLiOla4T/zXEZuMO7CigXBnwzn8zETTMrRWZyGZLRnzOwdAS
        MuG4Wz69ou5oQpqShu7i375QQjAxcAqYFGAh+5YAzQ==
X-Google-Smtp-Source: AA0mqf7aWAEOQCVyJoQT+sLcmLykvW+jmp5tFrVTULLQMFDGR0lVkdnDP5crGEOtMJ5nf8lGxlhb53dFKh5Q0j7rRrA=
X-Received: by 2002:a63:180a:0:b0:470:63e5:5c59 with SMTP id
 y10-20020a63180a000000b0047063e55c59mr63840166pgl.172.1670425910989; Wed, 07
 Dec 2022 07:11:50 -0800 (PST)
MIME-Version: 1.0
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
 <20221206145936.922196-4-benjamin.tissoires@redhat.com> <CAO-hwJJq23V+ceJvX8zz-wGB6VgByuMY-xGu8VukiOmP+FfXHA@mail.gmail.com>
In-Reply-To: <CAO-hwJJq23V+ceJvX8zz-wGB6VgByuMY-xGu8VukiOmP+FfXHA@mail.gmail.com>
From:   Florent Revest <revest@chromium.org>
Date:   Wed, 7 Dec 2022 16:11:39 +0100
Message-ID: <CABRcYmL_hAyH0QY7bP1Eh7atXeFDYg3-orht=KK1Zjcj9RNpqg@mail.gmail.com>
Subject: Re: [PATCH HID for-next v3 3/5] HID: bpf: enforce HID_BPF dependencies
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 3:58 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Tue, Dec 6, 2022 at 3:59 PM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > As mentioned in the link below, having JIT and BPF is not enough to
> > have fentry/fexit/fmod_ret APIs. This resolves the error that
> > happens on a system without tracing enabled when hid-bpf tries to
> > load itself.
> >
> > Link: https://lore.kernel.org/r/CABRcYmKyRchQhabi1Vd9RcMQFCcb=EtWyEbFDFRTc-L-U8WhgA@mail.gmail.com
> > Fixes: f5c27da4e3c8 ("HID: initial BPF implementation")
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > ---
> >
> > no changes in v3
> >
> > changes in v2:
> > - dropped ALLOW_ERROR_INJECTION requirement
>
> Florent, can I keep your reviewed-by on this patch?

Yes! :)
Reviewed-by: Florent Revest <revest@chromium.org>

Thank you for the updated series, I think it's cleaner than relying on
error injection indeed.

I still believe that, in the future, BPF should offer a proxy config
to expose if BPF tracing is supported because 1- the implementation of
BPF tracing could someday change 2- to be exactly correct, ftrace
direct call isn't _really_ a sufficient condition either: the BPF JIT
also needs to implement the arch_prepare_bpf_trampoline function.
Currently, there is no config to check if that feature is available.
But as agreed in a previous thread, that consolidation can be done
separately. For now your patch looks good enough to me already.
