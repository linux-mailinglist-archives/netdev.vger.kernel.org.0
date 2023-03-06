Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3D76ACD49
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbjCFS4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbjCFS4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:56:07 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32702683
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 10:54:34 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id k10so18943143edk.13
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 10:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678128869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+AuRXdo16JeR9PnbP32vE+RmxUJH9KHyOeCFYJO9N8=;
        b=WSWV0lHS5z6adoe5Tiq41jiyuQXiRQUv/tsMy+arXcyMvRGgwt1caWCd9I0NLfIrlS
         ZdPvhB/BTWOxraqng1s3AsKWMvP1CFoOsMrSm7957YCncHrU49Qe9UlsvaYwhnX7FY95
         wnLhrkmybWCklJcyMqQ6+GVqMtim/wHIrY/IA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678128869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+AuRXdo16JeR9PnbP32vE+RmxUJH9KHyOeCFYJO9N8=;
        b=IiDeaDwe890C/9LyQK9wQtWsq3oL6wPbBJpfejDYH5AViwZP5cpPGEAtgrubTvraAq
         LW0VOuPwKLFNT6FZ+LJdsiM35mGq8h47IyCz/ky/LLTp3RVeUZcNDyPndQyxU1Qu2zPZ
         sCXKFRqIKYyvL1G59ODl0NBT+Xjimt2/RxJKbDNeQH1Z97sTU9zSlen21dfmettMbtyO
         JSHEQd4urXxJAtnVOvDfgQr0fwmLEEFFIYEOO+B9E8YuUQFMc2xE6oc5OW8H2g41eNxn
         rz9CO1ZmQvPhsUXGg6lhxbqrgH3ibG8uamxVkDFpoUpOL6tmBo0nrBa4DeDQC8OfrN5z
         b2VQ==
X-Gm-Message-State: AO0yUKWO8JGl/Ahhw5MTw/ALhcHUH6AEpXrv3iT9pmvJANLKnmQIPzLN
        j1Vr9puXJyF83jpQr6zkJAo67KSFvFV0SdzocycWng==
X-Google-Smtp-Source: AK7set+sTV82899T6g42Us2Nuxh27DOlosnoXzTLGbDHDVRWcfkUKveex6tw8MQeC8NKd6BbmfxJYg==
X-Received: by 2002:a17:906:eecc:b0:90b:167e:3050 with SMTP id wu12-20020a170906eecc00b0090b167e3050mr15333327ejb.36.1678128501746;
        Mon, 06 Mar 2023 10:48:21 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090651c900b008b2e4f88ed7sm4940282ejk.111.2023.03.06.10.48.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 10:48:21 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id a25so43012556edb.0
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 10:48:21 -0800 (PST)
X-Received: by 2002:a50:cd15:0:b0:4c1:1555:152f with SMTP id
 z21-20020a50cd15000000b004c11555152fmr6419391edi.5.1678128500729; Mon, 06 Mar
 2023 10:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-4-vernon2gm@gmail.com>
In-Reply-To: <20230306160651.2016767-4-vernon2gm@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 10:48:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj73=Os1p=W7D2va=Rd81ZKvjb35yWgXQNgn1hXNRpAbw@mail.gmail.com>
Message-ID: <CAHk-=wj73=Os1p=W7D2va=Rd81ZKvjb35yWgXQNgn1hXNRpAbw@mail.gmail.com>
Subject: Re: [PATCH 3/5] scsi: lpfc: fix lpfc_cpu_affinity_check() if no
 further cpus set
To:     Vernon Yang <vernon2gm@gmail.com>
Cc:     tytso@mit.edu, Jason@zx2c4.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 8:07=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> -                               if (new_cpu =3D=3D nr_cpumask_bits)
> +                               if (new_cpu >=3D nr_cpumask_bits)

This all should use "nr_cpu_ids", not "nr_cpumask_bits".

But I really suspect that it should all be rewritten to not do that
thing over and over, but just use a helper function for it.

  int lpfc_next_present_cpu(int n, int alternate)
  {
        n =3D cpumask_next(n, cpu_present_mask);
        if (n >=3D nr_cpu_ids)
                n =3D alternate;
        return n;
  }

and then you could just use

        start_cpu =3D lpfc_next_present_cpu(new_cpu, first_cpu);

or similar.

              Linus

PS. We "kind of" already have a helper function for this:
cpumask_next_wrap(). But it's really meant for a different pattern
entirely, so let's not confuse things.
