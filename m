Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4E8666E60
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 10:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbjALJgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 04:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbjALJgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 04:36:01 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A355B5371A;
        Thu, 12 Jan 2023 01:29:27 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z11so26030834ede.1;
        Thu, 12 Jan 2023 01:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KPyNke11katUYVYKFm7Z4VEP11+FMuXLbYrVuyAaisM=;
        b=O9CF3UILkD2Mr9IK8SVJ90xKZ335osvzailKpYgakO4gbyoj31i2mjg1fQF6R/Cw1L
         nKnybvVITrO+RLm2dJlAe78fr5QciJVZZC7UftN9lPKNMIgayga19oinXzFzN4ngwcPE
         UykmK1utMfl6SsouSvJ2BwJ2p2dgrKgu+fYtTnRL6nSzipbbMXQyFI5lnHRSRzjfOTX1
         d49RM/3Ap+ncf+RrCY3cP901IFB/C/v2WUMmhnLvjqbaCezTahyTA+8QUg4TmiZBsyIv
         xsz3vi9QqjgCRAPT6NSwNg2hgeJdUugm01YInEBuUY8fvyz95Ui84RCqV9DWdkZsSyPw
         9Yhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPyNke11katUYVYKFm7Z4VEP11+FMuXLbYrVuyAaisM=;
        b=0dny6XQTK7JihQB9bdwSbD33aMUhQ+HPeCLtOLSQcimj3IMp7o8OX4AtYCHeXb/PCa
         LXUqvHoRHTI11xcSeT04jdpR3wRFUpYxEhTkv8uZW61FBdjcH7Zo+k6W7SMX1I7e15AF
         H136EmQJosDGF0qcZSjGVA0nyhym89nB1h+vuZ/IsAglJk/VJQwyUovUV7bA5iXFKBqG
         vTeNhDwRpF1LZ/fBwz5xW/YalLOVtIbhibyYWTgB9BngDCXFPLrOQWsYzoNa1ofSQbWi
         qO8hW+qdJCcRI8wpLqaB6aovWqtwiutCsgOC++5jlDf6x37n8r8RXZVSS/Adat2q1TPU
         fkmQ==
X-Gm-Message-State: AFqh2kotCtaTp/eC/YtJk558FNa+VnIxW4WejLkwa1+kJUTo7rKX9UBS
        qVz0iOAO1mftPKqlWf++VIGVQ3PugmAuDTipE0o=
X-Google-Smtp-Source: AMrXdXtSGPmcsUjSEtEVBaXtH2i+0rJGs5ljZRwqc6xoDn8ZOlubb6lKWu6F0VT7A6hpbAd2P0L08KC6LeKmWSAjfTE=
X-Received: by 2002:a05:6402:371a:b0:499:c424:e893 with SMTP id
 ek26-20020a056402371a00b00499c424e893mr1054351edb.156.1673515766217; Thu, 12
 Jan 2023 01:29:26 -0800 (PST)
MIME-Version: 1.0
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
 <20230111093526.11682-5-magnus.karlsson@gmail.com> <20230112022328.zbazaaoxbxfornh6@MacBook-Pro-6.local>
In-Reply-To: <20230112022328.zbazaaoxbxfornh6@MacBook-Pro-6.local>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 12 Jan 2023 10:29:13 +0100
Message-ID: <CAJ8uoz2ujrys-YbkV=+PeGoRfgTitmJstZQwbQcbBbb=nAZ7Ww@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 04/15] selftests/xsk: print correct error
 codes when exiting
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com,
        jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 3:23 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jan 11, 2023 at 10:35:15AM +0100, Magnus Karlsson wrote:
> > -                                             exit_with_error(-ret);
> > +                                             exit_with_error(errno);
> ...
> > @@ -1323,18 +1323,18 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
> >       if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
> >               if (opts.attach_mode != XDP_ATTACHED_SKB) {
> >                       ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
> > -                     exit_with_error(-EINVAL);
> > +                     exit_with_error(EINVAL);
>
> My understanding is that you want exit_with_error() to always see a positive error, right?
> Have you considered doing something like:
> #define exit_with_error(error) ({\
>   if (__builtin_constant_p(error) && error < 0) // build error;
>   __exit_with_error(error, __FILE__, __func__, __LINE__);
> })
> would it help to catch some of these issues?

Yes it would. Will add this to the next series. Thanks!
