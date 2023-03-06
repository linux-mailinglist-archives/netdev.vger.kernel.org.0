Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3B36ACEE6
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjCFULB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbjCFULA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:11:00 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5C634322;
        Mon,  6 Mar 2023 12:09:44 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id v11so11734350plz.8;
        Mon, 06 Mar 2023 12:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678133383;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6/LQ22SxCIaIMKCmzqtubiDIW3rGorKjMWE5QuR4ZXc=;
        b=fHyBqUUng0UtV2DrPjYsCsxUdTJ0m92kQd6HPV9pj4B7tkHIl2tI/EGKc1+lBqHwWr
         dS+YnXVZUQAQdgrw4g/nsX3PlB3PCAA1/fKNTO3g6Pa8BlX0xwcwOHuJQp/o4Ftt06U7
         SCwmAdgtzvw7JEjy3zW8BDcHQjKudPCgkjuRafuzM42A+0bK0f+jnrbQxPtb0okVQ2/A
         nccDT5T4/ir/zLCsOtcqRbz7FIVzqeNDs+zWimcQahkKSDSwCsxVAh0bcEzP1akiZNMw
         f6M+0CT4biDiU1LRo58zXen/y5TeCXYFQqRnUw3sZzwnXJ2+PEeKDAxWlPM+rpBS1ZJB
         Cbcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678133383;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6/LQ22SxCIaIMKCmzqtubiDIW3rGorKjMWE5QuR4ZXc=;
        b=PRo+FPdfuwtDs12zKsZKFA+Ngb4q7NKiccghuKRKdA2pK6hXgoNKBAjssOgKvDEvMK
         kOdW5j1lIYhwuhvrp8sZtZH+8Jjb06IXhFZwnnRK9ehw+gC5yMm/p8LQGwAlFW8/w555
         KXu9baJR11KYcEtmjUE/VCscG7L13XObrUc51mTEHstKKsdNo/eAH/ZyGzKC/XaQlj99
         2pYUqxjRBtTj8PrHP9qUusyh+eMbYZuriGm2X4UIDFCK7eKvr0joi1g/6hxlCruFJ9dl
         +Ktt9sD+G5xgiNVzAbWsPh1FKyTbpifWtKHKeJNSJwtAJkvoZRy0KuijWqy3yQzL1MF8
         REkw==
X-Gm-Message-State: AO0yUKXVZC4homHKoDTlXwvACdovSEIychLf29BmclaoemL2MAk8XTJq
        lOZB7YomCXQfTt4ZIdcA/cI=
X-Google-Smtp-Source: AK7set8ml1Zwwn2Jgrqz4SIpPButPySeJkHFErNLtXD+4bzwyvrMYjJswOKnxcAA24bZzTL44s7Ohw==
X-Received: by 2002:a17:902:ea0c:b0:19a:727e:d4f3 with SMTP id s12-20020a170902ea0c00b0019a727ed4f3mr18574527plg.5.1678133383608;
        Mon, 06 Mar 2023 12:09:43 -0800 (PST)
Received: from vernon-pc ([49.67.2.142])
        by smtp.gmail.com with ESMTPSA id v4-20020a1709029a0400b00198b01b412csm7059281plp.303.2023.03.06.12.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 12:09:43 -0800 (PST)
Date:   Tue, 7 Mar 2023 04:09:37 +0800
From:   Vernon Yang <vernon2gm@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     tytso@mit.edu, Jason@zx2c4.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        yury.norov@gmail.com, andriy.shevchenko@linux.intel.com,
        linux@rasmusvillemoes.dk, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/5] scsi: lpfc: fix lpfc_cpu_affinity_check() if no
 further cpus set
Message-ID: <ZAZIgcpEBE7HXBuy@vernon-pc>
References: <20230306160651.2016767-1-vernon2gm@gmail.com>
 <20230306160651.2016767-4-vernon2gm@gmail.com>
 <CAHk-=wj73=Os1p=W7D2va=Rd81ZKvjb35yWgXQNgn1hXNRpAbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wj73=Os1p=W7D2va=Rd81ZKvjb35yWgXQNgn1hXNRpAbw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 10:48:04AM -0800, Linus Torvalds wrote:
> On Mon, Mar 6, 2023 at 8:07 AM Vernon Yang <vernon2gm@gmail.com> wrote:
> >
> > -                               if (new_cpu == nr_cpumask_bits)
> > +                               if (new_cpu >= nr_cpumask_bits)
>
> This all should use "nr_cpu_ids", not "nr_cpumask_bits".
>
> But I really suspect that it should all be rewritten to not do that
> thing over and over, but just use a helper function for it.
>
>   int lpfc_next_present_cpu(int n, int alternate)
>   {
>         n = cpumask_next(n, cpu_present_mask);
>         if (n >= nr_cpu_ids)
>                 n = alternate;
>         return n;
>   }
>
> and then you could just use
>
>         start_cpu = lpfc_next_present_cpu(new_cpu, first_cpu);

OK, thanks you very much.

I'll send a second version shortly

>
> or similar.
>
>               Linus
>
> PS. We "kind of" already have a helper function for this:
> cpumask_next_wrap(). But it's really meant for a different pattern
> entirely, so let's not confuse things.
