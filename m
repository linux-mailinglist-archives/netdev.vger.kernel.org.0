Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB48563DCB
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 04:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiGBCe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 22:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiGBCe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 22:34:56 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA761ADAE;
        Fri,  1 Jul 2022 19:34:55 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id d187so3900585vsd.10;
        Fri, 01 Jul 2022 19:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XzrJ74Mq2J7i0uWext8oQxD8fgs8c6cXoUkiJ5+kvpc=;
        b=QG4dOJQ7dCYw4l4b56Xsl/rpwYA/YasHuDYQFRC5VONcbEsV/9x55dpCGFUpMb60bv
         Chme9/ccmks9oaUh33et6kKf9kl1tSO7Yi0M0g/GicLhPtcmUva6tu5q1xmFlAPV1qb3
         AIJvM4MwbDAMGzL61TPqmkNIJOqEEmYW0LbJLPyP/7p7gDXXik244ZStnQI0va6GNnVX
         xynHqWWqzX0A/tuvznF7bjlFn0lyLZul7hJ9YAv4VraEV/lab3RMURIjknTZzooGxhr7
         q7C8UvRnRhvPSjcKAx4AKh2ttoYetO3NdeFkGaYTL91y9yaqE5vmm55/8GrvibbsoF/Q
         Ytcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XzrJ74Mq2J7i0uWext8oQxD8fgs8c6cXoUkiJ5+kvpc=;
        b=PR+Eca8hMPhrRvrB9aFt2hR52Z1XT4Y4p7n0gfmhb9ZCaSwipulvS5o9oG64ITEgoM
         LTGnyDXSBhMqr48K7ohGnw+LX50MHWFDBTdMkw/GQmZuE/+54KVwruvE3ikwbaHsrtZ1
         KKRDewBuL4S6i3mPzZQ+2LNNj+57RPnPmuEj2WNRE1oQ0DRHKsE33qmOihIAKDPm/Yby
         VE4hsSPRvSE4L3fmUFqjLxZRGxq3Vo8O/k2MS5QgRIl0WTFmjJvV5ptwSvdEl9f4o78o
         eMUBpFQcPVtpq/9VOpzE+kMkDxQ+fNPZ/AFo8VmY0m5rcrEvcyC3aqSyZoIHUCuOL2iw
         xSEQ==
X-Gm-Message-State: AJIora/Tn5b7nSTuTCHN2B9H6jJOy3hjMtTSc0BLWa+E0LvETuIdB2dT
        7hJvJbILMhPhI7EszYmJYObL5pXnMftxYIQdVcU=
X-Google-Smtp-Source: AGRyM1vYPmiFz5mBxB5iu1UtJJ88zmxNQyEe1soOhxXApIXQ2vWBGIMxPS1Swz+f5cwfEN1ScQB1DbcPRmaRMQ8VQP4=
X-Received: by 2002:a05:6102:cc6:b0:356:3c5c:beb5 with SMTP id
 g6-20020a0561020cc600b003563c5cbeb5mr12760375vst.80.1656729294540; Fri, 01
 Jul 2022 19:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220629154832.56986-1-laoar.shao@gmail.com> <20220629154832.56986-4-laoar.shao@gmail.com>
 <CA+khW7h2DWPM4nAOav+t8k+zbnUOkCO9C+47bSVN0UMHRE-v_w@mail.gmail.com>
In-Reply-To: <CA+khW7h2DWPM4nAOav+t8k+zbnUOkCO9C+47bSVN0UMHRE-v_w@mail.gmail.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 2 Jul 2022 10:34:17 +0800
Message-ID: <CALOAHbDdj72pVsaohbj=JCsryiHFQYaia78OP5kO65OSYTVb5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] bpf: Don't do preempt check when migrate is disabled
To:     Hao Luo <haoluo@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Fri, Jul 1, 2022 at 4:43 AM Hao Luo <haoluo@google.com> wrote:
>
> Hi Yafang,
>
> On Wed, Jun 29, 2022 at 8:49 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > It doesn't need to do the preempt check when migrate is disabled
> > after commit
> > 74d862b682f5 ("sched: Make migrate_disable/enable() independent of RT").
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
>
> In my understanding, migrate_disable() doesn't imply
> preempt_disable(), I think this is not safe. Am I missing something?
>

It seems I have some misunderstanding of it after second thoughts.
I will think more about it.

-- 
Regards
Yafang
