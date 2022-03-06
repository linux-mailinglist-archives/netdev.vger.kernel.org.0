Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B3F4CED38
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 19:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiCFSkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 13:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiCFSj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 13:39:58 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAAC25C48
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 10:39:05 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id f14so14906822ioz.1
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 10:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9j4rxqkFvudE6edfDTrSZc6T4GWXMAOtNWayS7Y3Fh4=;
        b=rmNiJNwn2SVuYMYdbVMStjgzLzfUx/7Dahg9TuEx9bGARhHeSjljs+a3V7E6wvefqY
         d6bq1RWSBB/T0Ve1UXrbRuveKYtRGVgbrC+qcmh7Y+Uqow3y7G02ziOeyAmuEq4Vz+PF
         dzceMiI19Gf15Z/+F9cjqC8REJ1/oTv1r2dmO7cNr9zztCtFz4q07THvXpa6cgr1/s0a
         ImoTYMsM3TugyadeRLARPLixIEGTBIcQ91jDCmrKmzgaAIJSaNre050PftFmTql0jww9
         +hMpf1WdxbwpDVfyCX6Ai4vOhs8Kgv7hl8QM1mAFa4s6RGqwpUgevHvkWAd3GZHB9Ex1
         lctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9j4rxqkFvudE6edfDTrSZc6T4GWXMAOtNWayS7Y3Fh4=;
        b=JgXRD0dwlSapOgNv7INT/rwb+WC5CSMHcsHm4f/ZT7qwTuB3qo7iz/c1cH/joNLxkw
         hJA9tJipWC4YJRbqv+ag+s849JNqVQA9rhcqhqrdRG7+f4NIEcgvQ6kIc9RuTDvGkR9w
         XZkDcPDOpogeSGHu7yT992+amBd01lcVIqiO3rNbIiajrbil/iKzfYaDoc/VOXQdK7Xl
         FqzRo9Qu0meA/l78Fwmn4WXg7onkEr8c42ZN0NdF1lH5VJ90qvCrgqs8DcC6EdjujzRV
         Tx10AaMeurbihaJZUVbG7zcX23GcSbLmrzfWSwcxfad9A2Rgw1zDELsllRS21vhs0osr
         3u9w==
X-Gm-Message-State: AOAM531Lbv4u+gf3785Tqbst15ARaGNFcH5BrlAHdwLJgtZ+JQUAPbUc
        doQFlrYOEtQvQs0KEPGmWFtbqp4s0KwGduwBWYIrPQ==
X-Google-Smtp-Source: ABdhPJxawtA9Eq0xBKDsLpOnQ/xn5w2MDpr4IMuFE/hUFRC1rqxBh0qAUReI4BrqrDF5vDUJw0DI2ixBUsNAx1h+lj0=
X-Received: by 2002:a05:6638:1453:b0:30e:221e:d497 with SMTP id
 l19-20020a056638145300b0030e221ed497mr8022316jad.115.1646591944989; Sun, 06
 Mar 2022 10:39:04 -0800 (PST)
MIME-Version: 1.0
References: <20220306085658.1943-1-gerhard@engleder-embedded.com> <20220306170504.GE6290@hoboy.vegasvil.org>
In-Reply-To: <20220306170504.GE6290@hoboy.vegasvil.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
Date:   Sun, 6 Mar 2022 19:38:55 +0100
Message-ID: <CANr-f5wNJM4raaXrMA8if8gkUgMRrK7+5beCnpGOzoLu59zwsg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 6, 2022 at 6:05 PM Richard Cochran <richardcochran@gmail.com> wrote:
> > ptp vclocks require a clock with free running time for the timecounter.
> > Currently only a physical clock forced to free running is supported.
> > If vclocks are used, then the physical clock cannot be synchronized
> > anymore. The synchronized time is not available in hardware in this
> > case. As a result, timed transmission with ETF/TAPRIO hardware support
> > is not possible anymore.
>
> NAK.
>
> I don't see why you don't simply provide two PHC instances from this
> one device.

Because with vclocks the user space interface is already available. Also In
my opinion it is a good fit. The second PHC would be based on the free running
hardware counter. So it would not provide any additional functionality compared
to the vclocks based on it.

Are two PHC instances supported? At least for ethtool there is only a single
phc_index field.

> AFAICT, this series is not needed at all, as the existing API covers
> this use case already.

I assume that you mean for ETF the transmission time can be converted,
similar like for time stamps. So for ETF you are right. It was too quick to
mention ETF along with TAPRIO.

My use case is TAPRIO with hardware support. For TAPRIO the hardware
has to act based on the synchronized time within the TSN network. No
transmission times, which could be converted, are used. The hardware
is in charge to transmit frames from a certain queue only during defined
intervals. These intervals are based on the synchronized time. So the
hardware must be synchronized somehow. This is my solution to keep
the hardware synchronized while vclocks are in use.

How can I cover my use case with the existing API? I had no idea so far.

Thanks!

Gerhard
