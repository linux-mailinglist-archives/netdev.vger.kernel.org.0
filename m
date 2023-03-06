Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7596ACCC3
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjCFSfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjCFSfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:35:17 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4749879B14
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 10:34:41 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id o12so42551771edb.9
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 10:34:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1678127661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUkuyszYTAoQtNUlKsSSIkY0E3vOhynrc0QM2L0Yxu4=;
        b=ApSrgLIXz4JjA09pC4lJ23b/ViBE9xa/BHSWJAYZZt9VJxMEzUQO12mOvi/25MWpyr
         v/oArdsyZA1V7cJArI270gsaf3V1GgsFiM0ij+oMDX7nfvEIOrZeVjdE/R+9p9P7Exwa
         gl3Vd+wv89xHSW03UrJuYFJ3rJBzUkE9sx9q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678127661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jUkuyszYTAoQtNUlKsSSIkY0E3vOhynrc0QM2L0Yxu4=;
        b=koJPbzQIcU+FL9vPFLNyynxXI6u/OGUcTMaGjvhiUrYJqhXZtu6yBddIEGRK+mnw9/
         paSmG6QTSIP3NPY3aH8xDpqvAcgLNn6cH/CRfpSdTffbpyRyEclCXgHOASo3zJfVcJra
         c6W5/QZRBSrutiV/pRqZUuHyugC/AYJadE4mWE7FBuAPK+87/3PGmZ/oPADoI7cQU+1N
         J7MWJY/zU24uI8LYA7ElV8CAxADAateaX0FUWT1FR2RjrC2tFLlud48hkupqBmilk1Ab
         dNoeauLrLDulUJ+7qegqJPoeyjCE+vVImci9H37Jsi2B+FM4AIKHv/mWPAcAFjDLQ0KG
         wMbA==
X-Gm-Message-State: AO0yUKVF7Jgil/nfe9WTxdq1c0D4tZVfh/p3nzHS7hTsq8MqpApCLcfj
        NsbnUwYPYXtZXvGnhfN9cSUIa6OLrMarsK2CtqxYKA==
X-Google-Smtp-Source: AK7set/ZWLHjiHXwL5EVOiz/RGsDoFxOzVh1GaSY+BcXr4xJhvcDUdHorx52nkJiv16XmM+fH/+2hA==
X-Received: by 2002:a17:907:3ea9:b0:88d:777a:9ca6 with SMTP id hs41-20020a1709073ea900b0088d777a9ca6mr14542474ejc.18.1678127661640;
        Mon, 06 Mar 2023 10:34:21 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id e2-20020a170906504200b008f767c69421sm4913658ejk.44.2023.03.06.10.34.19
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Mar 2023 10:34:20 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id ay14so38928547edb.11
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 10:34:19 -0800 (PST)
X-Received: by 2002:a50:8711:0:b0:4bb:d098:2138 with SMTP id
 i17-20020a508711000000b004bbd0982138mr6329093edb.5.1678127659323; Mon, 06 Mar
 2023 10:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20230306160651.2016767-1-vernon2gm@gmail.com> <20230306160651.2016767-6-vernon2gm@gmail.com>
 <CAHk-=whVnaTBt2Xm-A+8SMc5-q5CuZBDU6rUZ8yC8GoAnbTBvw@mail.gmail.com> <ZAYtRcbMeRUQFUw/@vernon-pc>
In-Reply-To: <ZAYtRcbMeRUQFUw/@vernon-pc>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Mar 2023 10:34:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=whA2kEBk3ibg3mrxpuXOAJKdM_MC4MQ8gLmxerZ5URfvg@mail.gmail.com>
Message-ID: <CAHk-=whA2kEBk3ibg3mrxpuXOAJKdM_MC4MQ8gLmxerZ5URfvg@mail.gmail.com>
Subject: Re: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
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

On Mon, Mar 6, 2023 at 10:13=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> w=
rote:
>
> I also just see nr_cpumask_size exposed to outside, so...

Yeah, it's not great.

nr_cpumask_bits came out of the exact same "this is an internal value
that we use for optimized cpumask accesses", and existed exactly
because it *might* be the same as 'nr_cpu_ids', but it might also be a
simpler "small constant that is big enough" case.

It just depended on the exact kernel config which one was used.

But clearly that internal value then spread outside, and that then
caused problems when the internal implementation changed.

            Linus
