Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4603C45D
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391264AbfFKGi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:38:28 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41465 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390485AbfFKGi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 02:38:28 -0400
Received: by mail-lj1-f194.google.com with SMTP id s21so10385755lji.8;
        Mon, 10 Jun 2019 23:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4V8OAbAgAw1bvmAqD0UnpvSRhF5f7ARJmj6R3bpeTI=;
        b=nZA8vm/bN2S8fhEu+frMoA5oHO1GTAkM8ypx3kwCkh5p7d2igMmMNHRbZambTrohTh
         vT7aClREWlwe6gKmhZI1iyfTtWhniRRPaUvRG8odTRnfiHVI3AxPn9iVqcoaWmbKZkh5
         /QC2yHE2p8tZALwprIsEXnvkNBpcDTEPuk30kD/CAcFJYg2rXqtiCJTdLTMtYijGXYYN
         eVoQLgZPJXVYoDmUDEkIPdeg18pCppHqMliJFDSALOuOeLd/ipAzIdilId2oRQ5OQaHy
         /7/kytq0f1Kbjs1Vi8im2HdJlqNbCOmZ7YNrfY4jlXWhjymTcny8a1OZm0P0n8WJ9bXd
         rx3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4V8OAbAgAw1bvmAqD0UnpvSRhF5f7ARJmj6R3bpeTI=;
        b=AqB4nh0Or93pOGEMp2pEIwKgEyi6yyc2bpZbhbg+3rLheZoeAb5/XBuhCx2zcunpGV
         X/1iR3xs4rrRsCrBsAl+s6bg71jsnpgheePER5ZRr64Mxn91hBbUvaA5eN6HcTKpg0dm
         sZ+L5NdUX2wc0Y7kzn7TMEWWtqqVMGdOYu7w9zCbsIPhBLFiVG6ipbHhDv1B5hfzktUO
         w7vInL6ZLnLjIIo72QNXZ4viLLe6HSwX187HmspiG/BHYR/zP92YJo+C6dQZeYAHqGMt
         vUJix2G75Yea3UC4xAIHktm+Fu21AE73XuBua5kpVyJblvijBmTgwYCwYk96z4v4JaNi
         0FMA==
X-Gm-Message-State: APjAAAU6SXwvEDrrjtqWvelcgdAxxh8hArM8JFmEi/0u9PFguUlvmkOO
        zaoXxWj6cdTp/naykx1AJjm996qY6Sq+LYjuIJg7ag==
X-Google-Smtp-Source: APXvYqymt0pZAX9/AgdJdlG+o3BK7Cp6HcsNSja4neI5oL0SZHA8s+ADd8CKk6OCp+X2Bsk6YZT+KwIjLaUs78e7ZXE=
X-Received: by 2002:a2e:9e1a:: with SMTP id e26mr23044925ljk.158.1560235106188;
 Mon, 10 Jun 2019 23:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190607171116.19173-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190607171116.19173-1-jakub.kicinski@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 10 Jun 2019 23:38:14 -0700
Message-ID: <CAADnVQJUuQqBXJw_kC5DcbYymM_3WoOYDLtWzhw+GNmHt5=RMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: don't run probes at the local make stage
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, oss-drivers@netronome.com,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 7, 2019 at 10:11 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> Quentin reports that commit 07c3bbdb1a9b ("samples: bpf: print
> a warning about headers_install") is producing the false
> positive when make is invoked locally, from the samples/bpf/
> directory.
>
> When make is run locally it hits the "all" target, which
> will recursively invoke make through the full build system.
>
> Speed up the "local" run which doesn't actually build anything,
> and avoid false positives by skipping all the probes if not in
> kbuild environment (cover both the new warning and the BTF
> probes).
>
> Reported-by: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Applied. Thanks
