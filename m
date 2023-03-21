Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB9536C3976
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbjCUSql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjCUSqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:46:30 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C027D5617E
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:45:50 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h14so8957764pgj.7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679424348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9M8M7IInQVU+iyBpHPhc67fDUT5XDtEvAxluXmaN7aQ=;
        b=Hy3+bYbnBhFqAArV10Ykd5BRd70Z48mpTI27X42Ai9+2R8wXW5u/rimqgLJp+Ibswf
         YR44x0GVQ7gT8rdBjWMAKwimQS6CYxYUG8sc3gK1q5acCeanOiIGw2PAWOqHlI7/TFnj
         Dzq/LY5lgObm2IQd5rH8iigv4Q2ragNKBSV2DU7c+E5VbmBWaQLEgy6+X9WpUccLUorO
         +ES7ld+oCEaHs1V95DAaP8nBwKGFjBRqWWqYJfXnKkVfT/NB92UqP0U2/kC8GomIewkg
         j8NqSFiFWvg57K2eeu6dDa5z0jU+ogCbrGBWJyqmHWdeiTmhSpm/+qkJKJ1zVRfX5w9P
         KymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9M8M7IInQVU+iyBpHPhc67fDUT5XDtEvAxluXmaN7aQ=;
        b=0gk7ghwf9xhpTE2Ruhhdx0waeVM5eVofrIBawoD5nD/kfTuKqT35ddrREeVbKORVdZ
         ZDIZu7b8jpoOKjk9Bnkh74wvmt6HW1KqNw2CLvgI4fIgeSmOykad9oQfSws1wDBio4eT
         pb/hrgieTNB++EzhB3grqWI+NkQ2j4ckEEww45hGf9FVqnotzaXdt/6G4YqSvoob9a1f
         mRAZgFldxm2kCY+xg3xF7YxJhlln0kO/QAE7O5YrkGESAQVRo137yxFzY+ZgICF6Is+Q
         uDMzEpS9snRTMBXfr9sAqRJrPPwFPb4c5wm4XmZxeBbpgLvpQ5vjT3LY91sKePnnzqS3
         Z0tg==
X-Gm-Message-State: AO0yUKUooIt5puM4v9EV7pvgh9A3U9dYAOFzv5pWCVV9aEoMp8LH/H2M
        uRC1endkPUVcEes5WZh5juD+LHpIuViT7AHcI4dop+lR0jWuxnOzSNDfXw==
X-Google-Smtp-Source: AK7set8eWSOB+hY/s8FgnYAtG+oz9cOr6kNpMapkGLpcaiVk96EuV7hKGhrQ0/ZHT1qqMbVxbR/O/73ddcAj/GAwDUY=
X-Received: by 2002:a05:6a00:851:b0:628:30d:2d2f with SMTP id
 q17-20020a056a00085100b00628030d2d2fmr459685pfk.5.1679424348068; Tue, 21 Mar
 2023 11:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <167906343576.2706833.17489167761084071890.stgit@firesoul>
 <167906361094.2706833.8381428662566265476.stgit@firesoul> <ZBTX7CBzNk9SaWgx@google.com>
 <8edd0206-0f2a-d5e7-27de-a0a9cc92526e@redhat.com>
In-Reply-To: <8edd0206-0f2a-d5e7-27de-a0a9cc92526e@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 21 Mar 2023 11:45:35 -0700
Message-ID: <CAKH8qBvm24VJS4RMNUjHi24LqpYJnOYs_Md-J3FCEvp2vm7rcg@mail.gmail.com>
Subject: Re: [PATCH bpf-next V1 4/7] selftests/bpf: xdp_hw_metadata RX hash
 return code info
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 6:32=E2=80=AFAM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 17/03/2023 22.13, Stanislav Fomichev wrote:
> > On 03/17, Jesper Dangaard Brouer wrote:
> >> When driver developers add XDP-hints kfuncs for RX hash it is
> >> practical to print the return code in bpf_printk trace pipe log.
> >
> >> Print hash value as a hex value, both AF_XDP userspace and bpf_prog,
> >> as this makes it easier to spot poor quality hashes.
> >
> >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >
> > Acked-by: Stanislav Fomichev <sdf@google.com>
> >
> > (with a small suggestion below, maybe can do separately?)
> >
> >> ---
> >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |    9 ++++++---
> >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    5 ++++-
> >>   2 files changed, 10 insertions(+), 4 deletions(-)
> [...]
> >> diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> index 400bfe19abfe..f3ec07ccdc95 100644
> >> --- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> >> @@ -3,6 +3,9 @@
> >>   /* Reference program for verifying XDP metadata on real HW.
> >> Functional test
> >>    * only, doesn't test the performance.
> >>    *
> >
> > [..]
> >
> >> + * BPF-prog bpf_printk info outout can be access via
> >> + * /sys/kernel/debug/tracing/trace_pipe
> >
> > Maybe we should just dump the contents of
> > /sys/kernel/debug/tracing/trace for every poll cycle?
> >
>
> I think this belongs to a separate patch.

SG. If you prefer to keep the comment let's also s/outout/outPut/.

> > We can also maybe enable tracing in this program transparently?
> > I usually forget 'echo 1 >
> > /sys/kernel/debug/tracing/events/bpf_trace/bpf_trace_printk/enable'
> > myself :-)
> >
> What is this trick?

On the recent kernels I think this event has to be explicitly enabled
for bpf_prink() to work? Not sure.
That's why having something like enable_tracing() and dump_trace()
here might be helpful for whoever is running the prog.

> --Jesper
>
