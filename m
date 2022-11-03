Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D5661876D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 19:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiKCSZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 14:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKCSZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 14:25:42 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14101101;
        Thu,  3 Nov 2022 11:25:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so7603028eja.6;
        Thu, 03 Nov 2022 11:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CmAWGKBob4ajna9d7ChomIXoAVnmFlU700TCR9p9bo0=;
        b=Amg+SNaDfDt+t5LEAgXldWsvmyAtrHrVVdqntq71NzejgOLZ7Fx5m5FPlH4iRMTA3t
         2QUQFV+eUIHhsgR8ATiKWT9AuFCPkUuxlf8NO4ou9n4fHtwEAbm6kWXzMjt1RPTfmQhD
         /6Ther50F1+8aVVUFg3xnD6g8lrnOHB3klMTGNkRtf7SyWGiajc1tnw8cJuGVJr1NGV7
         YGTWlxdquSOiKLigYaP46Og0ytWzG4kIZjTBBlvyPTmaY2kfSEJnvf5Tr9VC+k3sCwFo
         XnV+Vhrj03yIUuNVZ2egolhkBV5EBbQ16hTVcaWHCSN3BOhg1Sk7VwkgKJllafCfMme8
         PMmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CmAWGKBob4ajna9d7ChomIXoAVnmFlU700TCR9p9bo0=;
        b=gKK627uEyfp3geGca8yeFo5pjq+H18p/FRmQOhoV+IU2bzKmRblyY7a4SRASbgUhjR
         DQyYaFyGfBxwtEghnmVwQf2cM4captwB+URuzbpnJ8DlIE8behiluIUJ/nPCLZAdd2N2
         A2fC+3a6YWWUUzeoQz0v16WLcwwkHViKOoNbvECGZCTX/vh5sPYf7TzcopkO0GU+1Ezb
         GnG/sB2KTeVTB7oNZ1hkVLtewLkoTNdUY6WvVLWZFKo8bQs8maRH1iIf3B+P6zq4XQNp
         Zatbmc6PoDD5n7liLezmfjmvkyvZ6zS+jsbzugv7dshQDKo/olPLJPIoi0LO8FXeu2aW
         eC4Q==
X-Gm-Message-State: ACrzQf3yvdkFpbrVIwuqLr478xYHE+ZaxNKHqQ7oIHleRrbaSHw0aDxX
        uAdsEzxWlRKdLbVzvv3hIywON0MpcPown6A/0IE=
X-Google-Smtp-Source: AMsMyM6k8GluPFiYvW0Mp4dqUy3zaBENCNmA6TSseyrHeFsZJT0uMgjobBo3tsXopCjYXASbGy5Qj/3gn0NtMG8x2Wc=
X-Received: by 2002:a17:907:9705:b0:7ad:b14f:d89e with SMTP id
 jg5-20020a170907970500b007adb14fd89emr29157797ejc.745.1667499940169; Thu, 03
 Nov 2022 11:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221103055304.2904589-1-andrii@kernel.org> <20221103055304.2904589-11-andrii@kernel.org>
 <8e7802a4-9854-aabc-bc4b-3aba21440f7f@meta.com>
In-Reply-To: <8e7802a4-9854-aabc-bc4b-3aba21440f7f@meta.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Nov 2022 11:25:27 -0700
Message-ID: <CAEf4BzbvHzHzgAKN_bpQmaFC2yt_pMn2vtmW=r7rpa4HMXQh4Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/10] selftests/bpf: support stat filtering in
 comparison mode in veristat
To:     Alexei Starovoitov <ast@meta.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kuba@kernel.org, kernel-team@fb.com
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

On Thu, Nov 3, 2022 at 9:46 AM Alexei Starovoitov <ast@meta.com> wrote:
>
> On 11/2/22 10:53 PM, Andrii Nakryiko wrote:
> > Finally add support for filtering stats values, similar to
> > non-comparison mode filtering. For comparison mode 4 variants of stats
> > are important for filtering, as they allow to filter either A or B side,
> > but even more importantly they allow to filter based on value
> > difference, and for verdict stat value difference is MATCH/MISMATCH
> > classification. So with these changes it's finally possible to easily
> > check if there were any mismatches between failure/success outcomes on
> > two separate data sets. Like in an example below:
> >
> >    $ ./veristat -e file,prog,verdict,insns -C ~/baseline-results.csv ~/shortest-results.csv -f verdict_diff=mismatch
>
> All these improvements to veristat look great.
> What is the way to do negative filter ?
> In other words what is the way to avoid using " | grep -v '+0' " ?
>

for grep -v '+0' replacement you can do `-f 'insns_diff>0'`.

But what I meant by negative filtering is adding '!' in front of the
filter to make it a "deny filter". E.g., -f '!*blah*.bpf.o' will
exclude any file matching "*blah*.bpf.o" naming glob. Similar for the
stat conditions, you should be able to do `-f '!insns_diff=0'`, which
in this case is equivalent to just `-f 'insns_diff>0'`.
