Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769716060BD
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJTM5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJTM5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:57:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424131578B4;
        Thu, 20 Oct 2022 05:57:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so3428722pjs.0;
        Thu, 20 Oct 2022 05:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RGzI2xTjckuAW3hVQGc+Pzc+7ksS8aSUUgI7rwODeNw=;
        b=AFAs7EP6zykYYreGg7FW3rkbLrOwSY+ge4rj39XBvXgYM0Qj5yCqRl3ro60ZgJyN9K
         dvow5TrDjOja4R7h/Ah5TxPVBC7O5kJMhx27V5DW+g0WAVZqQ9lpT+ZA1n0RDQUPgNup
         SXh2Ojj1QbByfSUSUax/uyiZjyqjfbdjviSY8U28cP44M2CFMwwC5P3h9hZYQjP16Jfh
         7We60X4CW1X861PwBw5hsrV6VFQ0ArirebTizYHX8Yw3vB7zh961wFuMJBGoTIqOLi9C
         +j5OudDSs4eneT8PRjerBIUrMCft3yhDUsaSBy5BPF29vLmZRGGn1fapRJEAo7ezTQbw
         8LfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGzI2xTjckuAW3hVQGc+Pzc+7ksS8aSUUgI7rwODeNw=;
        b=z0CTXBdI2X6W6HYnhPdUGz/fDLngtssZuvso8fKZdTXye6cNQpQbaGr06BwPbTApjp
         CehvVWHOM6N+Xs9ufmKJ+73YsFC0NElD3CgiuaoAvE/+CO8xl7AoFKRRrEBgR67eglvn
         qQFiP7JrFpunl4/QEo+tPoVsxI8q4uqmPZC3Wcv7EBlN8DHkojuMYOGdCfv0DbQEfiEf
         wLqrymdEWobPOd5xivd6DxVzrOL9PwJ9i7ordSF94FNaLFIuCZrOSwvPkthDOyuVvXQL
         NRSc6bxSNU6F35lfFm714IsemGWxtqJGkhrTTHAAn1V62w57JmWg/tgbwHZRthjdrt49
         0z4Q==
X-Gm-Message-State: ACrzQf3mVepq4EHuCCZi+g4RLh6P4kgHBP3t1O1LiBWluR6H8UCTejbb
        Y8Ya+9W4oRK10c0HzHl7qrMDki7oL/o=
X-Google-Smtp-Source: AMsMyM6LATzCVk6eC7hTTrqx7ZRbtMCEy3zD3ZdEdv1ahXovELCqw8eAuWjIdcxH1DYt8TfvbELjcQ==
X-Received: by 2002:a17:90b:3a90:b0:20d:a54c:e5cd with SMTP id om16-20020a17090b3a9000b0020da54ce5cdmr43742988pjb.183.1666270641091;
        Thu, 20 Oct 2022 05:57:21 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x190-20020a6286c7000000b0055f1db26b3csm13129637pfd.37.2022.10.20.05.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 05:57:20 -0700 (PDT)
Date:   Thu, 20 Oct 2022 05:57:18 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frank.li@nxp.com
Subject: Re: [PATCH net-next] net: fec: Add support for periodic output
 signal of PPS
Message-ID: <Y1FFrjjNyU3VaYBI@hoboy.vegasvil.org>
References: <20221020043556.3859006-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020043556.3859006-1-wei.fang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 12:35:56PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> This patch adds the support for configuring periodic output
> signal of PPS. So the PPS can be output at a specified time
> and period.
> For developers or testers, they can use the command "echo
> <channel> <start.sec> <start.nsec> <period.sec> <period.
> nsec> > /sys/class/ptp/ptp0/period" to specify time and
> period to output PPS signal.
> Notice that, the channel can only be set to 0. In addtion,
> the start time must larger than the current PTP clock time.
> So users can use the command "phc_ctl /dev/ptp0 -- get" to
> get the current PTP clock time before.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
