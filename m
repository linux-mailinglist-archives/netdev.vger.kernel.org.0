Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF4F5FEC3C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 12:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiJNKEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 06:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJNKEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 06:04:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1B027FD9;
        Fri, 14 Oct 2022 03:04:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DFA7B82295;
        Fri, 14 Oct 2022 10:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0815C43140;
        Fri, 14 Oct 2022 10:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665741885;
        bh=M1RHVhrd9CvGHsDLVTPIYyBQZd2boaXvVLczC8V1agw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cSjc0snQFw9N7np+xcZVe0pdiaXuGmgKZOfsbXqeSyQZyVnMhWevQh789ZMC/I480
         xuGynoflF8jZyym9WKjQXXpCHCsTlv7+akgvg3EnUy3KvsEkKyc9PCNf+9CiS1Vcol
         Zh+a206ZeF+2HQ2yhBQ6MQsAHCELN2YmyWnCm9LSCX8RGHptjM3SJakv4x9wXTrsmT
         qo+xjzSd7D82sa8ppvZhOzcFxBbeuSKWQ29Bh0mJ2TyaiKzAyGvmyKUq0EBdHbNbaw
         HDNlX7hfPNP7PxHDqVSEqzs/MRyKMtufQFA9foX/t53n1+xFXCMSHg+fIkVThHu9LE
         Ej28w10WEDNtw==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1370acb6588so5268272fac.9;
        Fri, 14 Oct 2022 03:04:45 -0700 (PDT)
X-Gm-Message-State: ACrzQf2RM1B9q1gSoeQrHX1cpBZ1gUcoYwJyBzILOHJJlcUk0/S/40EC
        e37RHDAbhvLpUeafDsErSU5arpIPdeKKOIfpuik=
X-Google-Smtp-Source: AMsMyM4AanB6DEc0QtQUMx97yjyTLDFYTwR7kLa4ZXZSkz9p6XoOhM8wnzzmCv9StC9733eUpY6ZLuCUTKfyFf7Xkuw=
X-Received: by 2002:a05:6870:4413:b0:136:66cc:6af8 with SMTP id
 u19-20020a056870441300b0013666cc6af8mr8049193oah.112.1665741884871; Fri, 14
 Oct 2022 03:04:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221014030459.3272206-1-guoren@kernel.org> <20221014030459.3272206-2-guoren@kernel.org>
 <Y0kzWQZSdCR93s/y@smile.fi.intel.com>
In-Reply-To: <Y0kzWQZSdCR93s/y@smile.fi.intel.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Fri, 14 Oct 2022 18:04:32 +0800
X-Gmail-Original-Message-ID: <CAJF2gTReV1JhfP2SN-3P3g4v6Mpgaq4CMb5COAiGCwo=onaAgQ@mail.gmail.com>
Message-ID: <CAJF2gTReV1JhfP2SN-3P3g4v6Mpgaq4CMb5COAiGCwo=onaAgQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] net: Fixup netif_attrmask_next_and warning
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@rasmusvillemoes.dk, yury.norov@gmail.com,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 6:01 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
>
> On Thu, Oct 13, 2022 at 11:04:58PM -0400, guoren@kernel.org wrote:
> > From: Guo Ren <guoren@linux.alibaba.com>
> >
> > Don't pass nr_bits as arg1, cpu_max_bits_warn would cause warning
> > now 854701ba4c39 ("net: fix cpu_max_bits_warn() usage in
> > netif_attrmask_next{,_and}").
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 2 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x14e/0x770
> > Modules linked in:
>
> Submitting Patches documentation suggests to cut this to only what makes sense
> for the report.
Right, thx for mentioning.

>
> --
> With Best Regards,
> Andy Shevchenko
>
>


-- 
Best Regards
 Guo Ren
