Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA89677400
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 03:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjAWCPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 21:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjAWCPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 21:15:31 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FA213506
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:15:28 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x4so7762047pfj.1
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 18:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ubW0L2HPMf+bfi0H4kmnSaQb2bPSPLTsa62daTYUEMA=;
        b=E1Z7pa0hkmayy3kzOqWxMf6n1qsp3dHFiC0q3wokyaWHZF9zU2K03g7vAW5smut1yP
         EQidXqKxpfeLDJT2imkZHynd6txj1Y0zT/Y2x73lVhTg7toXu8oxcy9Jzs6G6kr8EGWL
         w7yrijqvqbkRW3JkEls6dz+V3e0AvwDQpNXNZH71TARKiiHAW+q9RB2/PgOpr7St2ctA
         OEscTwHnAOSsUQ/eyGu+6aOytnaOxl/u1bQsNmivMkrF8tBX9Mkb6D/fp41CGriVEJLm
         Fvz1enBCE6S6gF+T5Xpv30Yo6K4/kcDfLk4UR7vNHMXvHOn+vF+4lyOMg3Pb8mQO+3lb
         vNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ubW0L2HPMf+bfi0H4kmnSaQb2bPSPLTsa62daTYUEMA=;
        b=IxkBT4MU5L97GepKa7YSjYmAMfVEN4wvw9foBdY0lyE/jad351iDjc1Hq5wmuQUmW0
         EWL39Md/6rzVMjcP5tHtiEN0dgl09ssrA57FU9AotEHSuCfzDTZHBFdQM+WDfn+BWk8h
         TQC1XZbkuAb0BBqLFxgckT2HGl0pDAw64ttNsXGBDXPpB+HFpRooo0Y6xRTjuiH1XxEy
         qulp6NGdRDPP6dXc7qWPymxVaSnYo/sLg1m347SS8u8qHBS2dtwm1p9hFrJmWMqviWyq
         IpwwGpPeBmfB0s++flL0ptUniUGN91hXwO5Uh486lXmiDYxXi84OwIMx9xwXA+k0YFOr
         vNrQ==
X-Gm-Message-State: AFqh2krslMytd/e3ROGgPAYjEZE+AMiBXbG58gcpYRFMmSy43i+oS35Q
        sFHZ9DSiRKB3ramRWvMB8uk=
X-Google-Smtp-Source: AMrXdXt9Cb0gFuXmTqtzTgVldGoi395I77pDCZPCP8beT7oqtD4Mu/ao/rmfRbGpLCBOlJgMUKdlyA==
X-Received: by 2002:a05:6a00:2147:b0:58d:e2b0:e480 with SMTP id o7-20020a056a00214700b0058de2b0e480mr17160630pfk.17.1674440128153;
        Sun, 22 Jan 2023 18:15:28 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id bv15-20020a056a00414f00b0058e1b55391esm5122369pfb.178.2023.01.22.18.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 18:15:27 -0800 (PST)
Date:   Sun, 22 Jan 2023 18:15:25 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <Y83tvS/b0NeSShpv@hoboy.vegasvil.org>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-4-saeed@kernel.org>
 <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
 <20230119194631.1b9fef95@kernel.org>
 <87tu0luadz.fsf@nvidia.com>
 <20230119200343.2eb82899@kernel.org>
 <87pmb9u90j.fsf@nvidia.com>
 <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
 <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wow, lots of confusion in this thread!

On Fri, Jan 20, 2023 at 03:58:25PM -0800, Jacob Keller wrote:

> Sure. I guess what I don't understand is why or when one would want to
> use adjphase instead of just performing frequency adjustment via the
> .adjfine operation...

The difference is in where the frequency adjust is calculated.  There
are two possibilities:

1. It may be done in user space.
   This is NTP timex's ADJ_FREQUENCY.
   PHC implements .adjfine

2. It may be left to kernel space.
   This is NTP timex's ADJ_OFFSET.
   PHC implements .adjphase

In case of #2, the hardware implements some kind of clock servo.  The
inputs to the servo are the reported phase offsets.  The output of the
servo is a frequency adjustment.

> Especially since "gradual adjustment over time" means it will still be
> slow to converge (just like adjusting frequency is today).

It depends on the servo parameters.
 
> We should definitely improve the doc to explain the diff between them
> and make sure that its more clear to driver implementations.

Sure.

> It also makes it harder to justify mapping small .adjtime to .adjphase,

adjtime is totally different.  Don't mix those two up:

- adjtime  sets the time (phase), plain and simple.

- adjphase feeds the phase offsets into a servo algorithm in hardware.

FWIW, the PHC subsystem handles the semantics of timex ADJ_FREQUENCY
and ADJ_OFFSET in exactly the same way as the NTP subsystem.


Thanks,
Richard
