Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39345B3A97
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 16:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiIIOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 10:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiIIOVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 10:21:16 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3722B0B2E
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 07:21:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q63so1701804pga.9
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 07:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=I23Zo/RofEI50w+2kqOPpeoE11yPpjgH8hLSd5ejJ7o=;
        b=b6LbGaXYK1tsGdLHwgPFP7CnXANJcUnVHtKC9xhf1M1+GT5U/iK/dcB+9dn8hJWZ0g
         xOrlzgQsuyCi6xOa/HW/gA2HuWrK7v4qrEg94RR671QM3wTnfELUvlCUPtac5OxJ0szR
         ot/PYLfz/0yxx4Du+3sCcDylW5G3/JUhjh9vMkNs7Z9tVZ/G3FYX/IwHHch+5mHe38Od
         A43PAJ5ggQs+96mUB3t7eniZYYKnX97aCKyuRhAsQGQ7iL514Ysxj1WztQ5WhBTwxHI9
         AyXVPpV1epX5Bb9UU3nM2N9tY9vs2L6gwdTvOo7pxg+1V7lcxKAJOEHB3o6m6FvL849C
         FFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=I23Zo/RofEI50w+2kqOPpeoE11yPpjgH8hLSd5ejJ7o=;
        b=cHJGX5miRwvrI9S1e3kAsRJKWh5tGZgsKL4VvNLlrXLkopjH45c6RrpFzd8jQLg06e
         SupViJnp/nHRg3LAIGECph6r4bXNTdhyCdTxrQ7dneA+Rj4a0q8zGysajXGtCP6dsTVt
         DXla+7WAIMnioJI+PMJVp4b/IjlQUCA5ryK3+ooxFsbW9yxQH/IyNiEVdpeKwQh8BlrS
         OPWbD+39+GOTe7Ccxl1sHpzeUyANddg6cV1ZXDySRyqyB88DSz6WFalUE8A7XB1nFGge
         OKOhl/lIVb1p3fVf7hl4TANjji+ZOeTmnZYr6+Z2n/EheNjMAI8ZQObl45X24RMXkkRT
         sh2Q==
X-Gm-Message-State: ACgBeo1R0jq4wQzBWeRSwnhLx9ICaxEDPjjhDUfiXskJOUH9yRBHhnzl
        bUy/14fu/IEoSYEeTjVRid4=
X-Google-Smtp-Source: AA6agR7USnxvuVcE5Dsx9JOYn5/1VtrRBC5Cnroh/Pa4vMoXFegY8evWH3yb8eNyZw9kM/RaP2Eztw==
X-Received: by 2002:a05:6a00:10c2:b0:4f7:5af4:47b6 with SMTP id d2-20020a056a0010c200b004f75af447b6mr14697429pfu.6.1662733273894;
        Fri, 09 Sep 2022 07:21:13 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ea8400b0016f975be2e7sm541176plb.139.2022.09.09.07.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 07:21:13 -0700 (PDT)
Date:   Fri, 9 Sep 2022 07:21:11 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
Message-ID: <YxtL14dZBgDLgvge@hoboy.vegasvil.org>
References: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
 <YxpsejCwi8SfoNIC@hoboy.vegasvil.org>
 <C4B215C0-52DA-4400-A6B0-D7736141ED37@timebeat.app>
 <YxqqQDnNUITPLvlg@hoboy.vegasvil.org>
 <D9C2C300-C517-4904-ACDA-80681766F3E4@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9C2C300-C517-4904-ACDA-80681766F3E4@timebeat.app>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 09:51:23AM +0100, Lasse Johnsen wrote:

> So where the driver received an ioctl with tx config option HWTSTAMP_TX_ONESTEP_SYNC it will process 
> skbs not matching the above criteria (including  PTP_CLASS_IPV4) as it would have had the tx config option 
> been HWTSTAMP_TX_ON. This patch does not change the behaviour of the latter in any way.
> 
> Therefore a user space application which has used the HWTSTAMP_TX_ONESTEP_SYNC tx config option
> and is sending UDP messages will as usual receive those messages back in the error queue with 
> hardware timestamps in the normal fashion. (provided of course in the case of this specific driver that
> another tx timestamping operation is not in progress.)

Okay, then I must NAK this patch.  If driver offers one-step and user
enables it, then it should work.

The option, HWTSTAMP_TX_ONESTEP_SYNC, means to apply one-step to any
and all Sync frames, not just layer 2.  The API does not offer a way
to advertise or configure one-step selectively based on network layer.

Thanks,
Richard
