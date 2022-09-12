Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C925B5D90
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiILPoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiILPoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:44:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E553122D
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:44:02 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b75so3758718pfb.7
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=6WJMZkqzECuNlXYrbJHIhf2Iso7gO57IGnNjoxfryjs=;
        b=ZgFjFJEu2lDiUaEupCyLGy9GEEo+awCHkj/NUTwFjNNDf7WvTYERs7Rf+Pao2ZEJzu
         +VCrWTK2P9FQULhHVUQH7SfRiL97iEhwf5eVnkpJ0LpdPSiuP3rAztdYQEaqJ3KxQtiu
         tU1bTmRRRp9yF0UsKEzOkEJluYiG9LmIOb/FcexDA3U66NWCFtIwzsXNzPrytGtAKTp5
         JnMCPQouDlIap7j/tdbBJGk9aMGI/KO+Rfds5ZCXgNuesQEqe9HZ0SGEGXd1c+k5xWp0
         S7WV3MIoavd39iW+zJjr2Gp9/VUPMWjb2WZHZPEBsfQXx/coPKg2f+E452CWgG3RpglI
         LlAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=6WJMZkqzECuNlXYrbJHIhf2Iso7gO57IGnNjoxfryjs=;
        b=Krh5eEvlgku8H/fx1kN0miZaqe5WjJhfxqOwEySx+7Um0TLmhFwblPqgLAzLda7zZz
         OMQJqsZgd29sJx5P9ni++sLaii9xeuauETE9HRSGictJLsqEEth4zj9bGVK5hva8pxBz
         V6U+rBcuMHnbUoP0sGzvdJ0j0WI2ZG8g3Qy/6nHOi4sU1G1SHQFQvY82aFRSltPcRPm1
         Qax+4gyKfzoziY/eLmLUEAN26D23OgETrUvZGf3NLD6KXf4rq/wUbHzbAbKI29YIov6e
         sStcUpiOmiQ9j1VuwvkFbap6NqbFFBi4Bk/GZI65I/3Pwk3pTMVO4F7BBs0jlZwxq2wm
         7MDg==
X-Gm-Message-State: ACgBeo0v7gVhLDKJIWesoYMkFAaboyUcRmj0odcZgobfpTOSe9ncViQU
        NT/fsS2HaSjMYPltNy4H9Gw=
X-Google-Smtp-Source: AA6agR58BIZpMZAKNJB61PSPcMHEAUUDWKhD4JbjMpGkhAtk9ZadRNW2Aqy2ne+RYrCWGmSvSzhkiw==
X-Received: by 2002:a63:106:0:b0:430:805a:f1ad with SMTP id 6-20020a630106000000b00430805af1admr23674176pgb.284.1662997441983;
        Mon, 12 Sep 2022 08:44:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id n18-20020a170903111200b00174d4fabe76sm6165000plh.214.2022.09.12.08.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 08:44:01 -0700 (PDT)
Date:   Mon, 12 Sep 2022 08:43:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     netdev@vger.kernel.org, Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Jonathan Lemon <bsd@fb.com>
Subject: Re: [PATCH net-next 1/1] igc: ptp: Add 1-step functionality to igc
 driver
Message-ID: <Yx9Tv5IYqmcRFuz/@hoboy.vegasvil.org>
References: <448285BC-C58E-475C-BAA2-001501503D6C@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <448285BC-C58E-475C-BAA2-001501503D6C@timebeat.app>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 10, 2022 at 04:07:48PM +0100, Lasse Johnsen wrote:
> Would you be amenable to an addition to the API so we can take advantage of 
> hardware that offers only a subset of the options?

I think that is only user friendly option.  However, the question is
whether this would find broad use, or would it remain an isolated hack
for one borken hardware design?

> We could for example extend granularity of the HWTSTAMP TX API to make requests 
> for different features visible to the user space applications directly. So the TX side 
> would become much more granular as is already the case with the RX side. We could 
> add HWTSTAMP_TX_ONESTEP_SYNC_L2_V2, HWTSTAMP_TX_ONESTEP_SYNC_L4_V2 etc. 
> 
> My worry is that if we do not do this, then the ONESTEP option will continue 
> to not see much use because so many permutations (L2, UDPv4, UDPv6, V1, V2, VLAN etc.)
> currently have to be supported by the hardware.

Actually IMO the opposite is true.  If the API nickel and dimes every
last combination then:

- that will only encourage even more broken hardware designs
- no user space software will implement the combos

Case in point:

	/* PTP v1, UDP, any kind of event packet */
	HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
	/* PTP v1, UDP, Sync packet */
	HWTSTAMP_FILTER_PTP_V1_L4_SYNC,
	/* PTP v1, UDP, Delay_req packet */
	HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ,
	/* PTP v2, UDP, any kind of event packet */
	HWTSTAMP_FILTER_PTP_V2_L4_EVENT,
	/* PTP v2, UDP, Sync packet */
	HWTSTAMP_FILTER_PTP_V2_L4_SYNC,
	/* PTP v2, UDP, Delay_req packet */
	HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ,

	/* 802.AS1, Ethernet, any kind of event packet */
	HWTSTAMP_FILTER_PTP_V2_L2_EVENT,
	/* 802.AS1, Ethernet, Sync packet */
	HWTSTAMP_FILTER_PTP_V2_L2_SYNC,
	/* 802.AS1, Ethernet, Delay_req packet */
	HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ,

This monstrosity came about because of ONE early, brain dead HW
design.  Seriously, who would ever want to have just "PTP v1, UDP,
Delay_req packet" and not the other event messages?

This horrible API is now written in stone, but never, ever used.

If hardware claims to implement PTP one-step, then it really should do
so in a way that conforms to the published standards.

Thanks,
Richard
