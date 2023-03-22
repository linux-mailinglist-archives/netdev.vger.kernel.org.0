Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E948E6C417E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCVERo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCVERl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:17:41 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ACA656144;
        Tue, 21 Mar 2023 21:17:41 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id ix20so18194599plb.3;
        Tue, 21 Mar 2023 21:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679458661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4noCRqZTyGso4rcJ9tz0BhnJ1ueJhB3rLMlziX6jcSw=;
        b=O9gBomO3JUVG38cUvlpHj75evR+sq2Jz9eF5+rYK1syse9gK24g5Zc9ZhD4WNLxzD9
         PeuUsmLtznFXb7E7vfRWFKVcrM5h1DL562uWmP0cwBbmlIZQi43+nEDAQAKIh1Ul+0/u
         9m2uAQTsvW3LaGeyKkZlmjaf01OShBcARRVfrcu+YTlUV77YD8d1ZEFZli0k+mwWGQzT
         ODGAGJGlejPP9tj/LohCLu0fNxxiPMR3r3kVKtPwKSLn8lyCAMzBaTa+W2guIQ5nSHMV
         xH6jZsv1D/6AbFPgyb3tzwHaqi/AP8OQcr89a8yI/8c72unYlSFEln+Evk1z8uiM2xUt
         J2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679458661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4noCRqZTyGso4rcJ9tz0BhnJ1ueJhB3rLMlziX6jcSw=;
        b=vYQsLhS8wsrCYfZzqytajXSMuOMN279mzcUhxoGO/XWIBEuCI06652QurARVVbV8Xp
         GTJ8d1KzZ04nuBvUTKmBVbFyi/ZCidGNQT2DCd7VdvsYI1CgpFH9nj3dsw4y9rufB7Tz
         DH7ex+z9Zszk9YZf5Sczjpen7gHjKtXBZWOckInKYmCa4A5oDDSAUsiFQgQJv42GFb8q
         AwRWp4Z97RlsK9bAH8EOeB+EV9L+U0TnCwhNqHqb2Og77mLm/vRz/UbFCXrql796pe7F
         gdBXmurfd9GnAFuZHccXiBPxEPVi8LiwECITeuPcC2jYZP++7muosM47eOBDw383Y3t0
         S6qw==
X-Gm-Message-State: AO0yUKVeJ/Fk/KGNuXtLnzw7CNPTx0U8EUcl0oY1Pr2iSRf5MjsBDLKm
        v2afjtJCLcvsRfzSSB6/X1g=
X-Google-Smtp-Source: AK7set8Zq7ZQ2YiJvjka/7HV7FgrZ3NuNeD2Hx8KwQQHGIFjX/sn1rnOY0Zf9TIpfAB6yEVhvbtB6Q==
X-Received: by 2002:a05:6a20:7f8c:b0:d9:f4e9:546d with SMTP id d12-20020a056a207f8c00b000d9f4e9546dmr4584846pzj.6.1679458660666;
        Tue, 21 Mar 2023 21:17:40 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t187-20020a635fc4000000b0050be5236546sm8944922pgb.59.2023.03.21.21.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 21:17:40 -0700 (PDT)
Date:   Tue, 21 Mar 2023 21:17:37 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Zhang, Tianfei" <tianfei.zhang@intel.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: Re: [PATCH v1] ptp: add ToD device driver for Intel FPGA cards
Message-ID: <ZBqBYbYvd9fMCaSz@hoboy.vegasvil.org>
References: <ZBHPTz8yH57N1g8J@smile.fi.intel.com>
 <73rqs90r-nn9o-s981-9557-q70no2435176@syhkavp.arg>
 <ZBhdnl1OAPcrLdHD@smile.fi.intel.com>
 <4752oq01-879s-0p0p-s8qq-sn48q27sp1r7@syhkavp.arg>
 <ZBi24erCdWSy1Rtz@hoboy.vegasvil.org>
 <40o4o5s6-5oo6-nn03-r257-24po258nq0nq@syhkavp.arg>
 <ZBmq8cW36e8pRZ+s@smile.fi.intel.com>
 <BN9PR11MB548394F8DCE5AEC4DA553EB6E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
 <ZBnBwa/MLdH0ep3g@smile.fi.intel.com>
 <BN9PR11MB5483DA8ED31B3294C60FC827E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5483DA8ED31B3294C60FC827E3819@BN9PR11MB5483.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 02:52:34PM +0000, Zhang, Tianfei wrote:
> I think sending the other patchset to fix this NULL handled issue of PTP core will be better?

Yes, please just fix the driver to conform to the current API.

Thanks,
Richard
