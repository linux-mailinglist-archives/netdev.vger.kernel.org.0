Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800855B2C3F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 04:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIICvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 22:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiIICvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 22:51:49 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C8C10F8FE
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 19:51:47 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c198so344395pfc.13
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 19:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ydCI0FgOBs+W3TpBM8ytzhRYEiN4ZJOqcymodJz38qQ=;
        b=ilGT+Q1nhJklEQHL03jOzGkt9drCB70fyJy8Pal7N5+IW580Tr5LN9fdGsXxG4OR1r
         um59wdDXqp68ePQKE6DFNcIabnevxjZQZC65rBIdfqpi/oTxbbzEOBEfxSD/2w3yhsXa
         ayYdF3wJTYguwhD0HDlyrFGCIY2LB5Xv4/Y0c0PPryFyOiXL4hdbQFSy+6jCzv0snRQA
         n3Vacr7gg18Y3ACCVHlOBWdz5mUazrACjSSPplcSSOEXRG8kRV088t3HWcWWFwOQxpms
         7Cp4ThiRKVrRzVnryffnsobo4c0Ahh06bhHeI+yc6utWcNy15qD3NdRmxDarQvBbbX94
         GoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ydCI0FgOBs+W3TpBM8ytzhRYEiN4ZJOqcymodJz38qQ=;
        b=eHCNzXRBS+k7LPshgr46MAlPfpVhawJdHMocvmDwFc+9DdZnyvMbILsFLAvTafFXgW
         Pyn9i84ummaseUspZ9uxIZB4R8YjJJ1NyWBeRdDkJJqDmn/2ZZ+tsmvuoML19MNt5H0K
         73LQAnmkOrme7IRfoxm36D7ryOrFO/roUAiRlbdo6XI0kCWl5lOV/+Baf/GWJSx6173Z
         Eaq1F0+i9OjmpaQIWKIlymDOFS1Pql4fGH1LOmFT6c3VE0Uf2kb9t4QUfxXxzR1TiMuW
         jsh51DCOMVwpFVlioKkAvBotia/1LbC9J122VWtU1aR4z+DLqijp+KsY6hiO96utgJNQ
         joQg==
X-Gm-Message-State: ACgBeo1Kj2zCAPKXIa+3zGvDd/hE1Fu+p6T0+osNqylWum9csjieiMXa
        PuCxRBmfhnWHDxoZNFDHHPU=
X-Google-Smtp-Source: AA6agR7eTHwa9WnCcTbyuBeELRut0Urs2oZ2l+cFo8Y1b1b9zuAjLQmYlLqQtx0X0se9GKny/q8QuA==
X-Received: by 2002:a63:6643:0:b0:42b:c05e:e3a9 with SMTP id a64-20020a636643000000b0042bc05ee3a9mr10311313pgc.513.1662691907023;
        Thu, 08 Sep 2022 19:51:47 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e1-20020aa79801000000b0053e3ed14419sm358483pfl.48.2022.09.08.19.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 19:51:46 -0700 (PDT)
Date:   Thu, 8 Sep 2022 19:51:44 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
Message-ID: <YxqqQDnNUITPLvlg@hoboy.vegasvil.org>
References: <44B51F36-B54D-47EB-8CDD-9A63432E9B80@timebeat.app>
 <YxpsejCwi8SfoNIC@hoboy.vegasvil.org>
 <C4B215C0-52DA-4400-A6B0-D7736141ED37@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C4B215C0-52DA-4400-A6B0-D7736141ED37@timebeat.app>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 11:48:48PM +0100, Lasse Johnsen wrote:
> PTP over UDPv4 can run as 2-step concurrently with PTP over Ethernet as 1-step.

That is not my question.

What happens when user space dials one-step and UDP?

Thanks,
Richard
