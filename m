Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BC14CEC65
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 18:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiCFRGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 12:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiCFRF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 12:05:59 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C64266217
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 09:05:07 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 195so11689621pgc.6
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 09:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OTP4QIebzh+EtuZdmsu3pDSobOQVzAynPhluEojjqYs=;
        b=kxaURlLpkNc/L/mSU+0Kjegs9+UT0cgqIE7Gznd0proRzBDdP1qCejo+jTjzWvxmI9
         WE4nuHC9YgT2/u8iK9IossqkHZnDTyfOwe0L2HV1Fpw+TUfx+6jTlJ9GfmnthAyOZ06O
         D+bvz0LZoIuvaBf0QTng311UcQxKgCHvkdBH/oW8DVFxhZTEIVnT9/+mDYQkeAJ4PR9d
         yqpRKdHGkuZwEb3Lwf+GUKQunSK9d4vWPgU/JECCSp1y8o9rnuyDRWQVTd3x5FYyKo6W
         y2THZmWGGjnwjw+fZ4iiCfHM8kZhkc2/Loej9ZJ9BOqKVkEDWJ8kUvGQpZiXBVgArFb3
         k+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OTP4QIebzh+EtuZdmsu3pDSobOQVzAynPhluEojjqYs=;
        b=YOdHm6dqmy4rkXLvOcwu7UK4SwNSBP7SmOcwv/Oa5JJ9NfcFKL07ge0fp2HtqqkMg2
         rjy5QePFO2Ojd54S8PqM8oNLcLWSlpFiV8f0E0F772MUI46t13w9xaRvUoXiA8kXvl2L
         95Go+geHS5hoPj4HguBy6jUgZkNdn4OSGZfY36JThWlWcmcI/B1FLyUVooGprEbcQMvF
         5+kJWB8d0d9uXLZPx1zs36EnzWwT1msZpOuy3T5PhqKpbrL5SAS5+fa6mTTWx0Z6W4ru
         Hwm9FX50uS3df/fJD1RTORm8EDuV9zTeZRoj5Dunad/XQwknjsr08UUyV6tK2AUxjsX4
         Y2bw==
X-Gm-Message-State: AOAM530mX6fU0GWh2TfcMpZnWCy4h+Ahy9sJkKur7zs7gh+nnND0Zrf2
        tuOjpxmL9U4SnrAYr9uH7YfN5zpqdJg=
X-Google-Smtp-Source: ABdhPJzUVLsyhcwJDCMGmpdPjtfwUE2il7IpubKohsJWhsoyzrMTFOMTEyZCe9UJchLCsAGPcETqdQ==
X-Received: by 2002:a05:6a00:1251:b0:4f1:2a1:3073 with SMTP id u17-20020a056a00125100b004f102a13073mr8911301pfi.72.1646586306966;
        Sun, 06 Mar 2022 09:05:06 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00218200b004f66d50f054sm12771795pfi.158.2022.03.06.09.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 09:05:06 -0800 (PST)
Date:   Sun, 6 Mar 2022 09:05:04 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220306170504.GE6290@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 09:56:52AM +0100, Gerhard Engleder wrote:
> ptp vclocks require a clock with free running time for the timecounter.
> Currently only a physical clock forced to free running is supported.
> If vclocks are used, then the physical clock cannot be synchronized
> anymore. The synchronized time is not available in hardware in this
> case. As a result, timed transmission with ETF/TAPRIO hardware support
> is not possible anymore.

NAK.

I don't see why you don't simply provide two PHC instances from this
one device.

AFAICT, this series is not needed at all, as the existing API covers
this use case already.

Thanks,
Richard
