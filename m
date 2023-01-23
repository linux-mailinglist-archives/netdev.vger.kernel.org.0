Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F25B678AD9
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjAWWjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjAWWjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:39:43 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4171D303FD
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:39:42 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id a18so392136plm.2
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MdRxdAest4QsTG8p/mxisKQ5YOo7yPrkdNCxSVXRrp4=;
        b=JP56GleMpiRkCPkOsi900Fw4pPBFO3bTGhUkqAutMKqsOc1yjVcdL44Rxm9JUeBPBp
         FzxJpjsiD/cDLUgssB5IY2aOfOISbmHHlT8K33mKDXKum00X5HFKRaurpv67RQu+eRJA
         gUHreT8RhXerNOTVwqKjkPhPVp9cR/i/n2CAbLJ0a2AOKqqUDQnNzOwubXZblMZnYJHS
         Sjf7itTl9QIMN/6I4s50zY5hdINnwEecibWMxutq9Ic6TdhrV9LibFSqVRI+z0p4OcFZ
         2d6/lsIlR9hRVTRL9oe7J/md4I7eZgXLAH587HLVJSGQ04AluuFIyJWoxhdzhO8MY0BU
         Xz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MdRxdAest4QsTG8p/mxisKQ5YOo7yPrkdNCxSVXRrp4=;
        b=auKlQe4YZjeuBpqg+krnIHZxMN41sLl/BVHoi9rFpt/RSjK8cqwS+2YsQzgI3OsUYa
         VJDL1eUa5ymDLv1jCjBQQCifFPu2TkE7op3EbXuDMiaDVCEAMH/er5yFtRIYU16ZeV3C
         9TYSU7sZwXDF/MgkyVwLIMqHsTAN/3z8mJvVR0d2lwSxpzv1KyZAP1sbG0N5XOkrCF3e
         0f5tcmvMPxBc0hGoVPj1Lp/WWwHpLElD3Z8Nbzt01mb0IFRBNiRlgum0RnMUMOFIQHbw
         RYuwBJPc3cttGoLmUSlW+CwHAzabQ5jnPURwdvhC22mFV9+6wXqcTEX4w9vCDx+f2dxC
         EHdQ==
X-Gm-Message-State: AFqh2kojvjiCsA3D6gbRiOwdV0P2iydWOnVLSoK5qzhoqFMg9gonV7WP
        0dmzBl7Kp4IraJt3ZcFWMuU=
X-Google-Smtp-Source: AMrXdXv1uC0DoVBBURKQtt9XiJ80KElqgAKcnYvhzn6vXV+21AAiMuNGDM4VpY09DFgpwcX/+XTZgg==
X-Received: by 2002:a17:902:ab88:b0:189:7919:de3c with SMTP id f8-20020a170902ab8800b001897919de3cmr22212368plr.43.1674513581693;
        Mon, 23 Jan 2023 14:39:41 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id ja5-20020a170902efc500b001930b189b32sm201501plb.189.2023.01.23.14.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 14:39:41 -0800 (PST)
Date:   Mon, 23 Jan 2023 14:39:38 -0800
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
Message-ID: <Y88MqqbnUE6JWP3k@hoboy.vegasvil.org>
References: <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
 <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org>
 <87ilgyw9ya.fsf@nvidia.com>
 <Y83vgvTBnCYCzp49@hoboy.vegasvil.org>
 <878rhuj78u.fsf@nvidia.com>
 <Y8336MEkd6R/XU7x@hoboy.vegasvil.org>
 <87y1pt6qgc.fsf@nvidia.com>
 <14e5bddf-9071-55b9-a655-7ea9717d33b4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14e5bddf-9071-55b9-a655-7ea9717d33b4@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 11:13:35AM -0800, Jacob Keller wrote:

> > 1. Can the PHC servo change the frequency and not be expected to reset
> >    it back to the frequency before the phase control word is issued? If
> >    it's an expectation for the phase control word to reset the frequency
> >    back, I think that needs to be updated in the comments as a
> >    requirement.
> 
> 
> My understanding from what Richard said is that .adjphase basically
> offloads the entire servo and corrections to the hardware, and thus
> would become responsible for maintaining the phase correction long term,
> and callers would not use both .adjphase at the same time as .adjtime or
> .adjfine

Right.

> > 2. Is it expected that a PHC servo implementation has a fixed
> >    configuration? In userspace servo implementations, configuration
> >    parameters are supported. Would we need devlink parameters to support
> >    configuring a PHC servo?
> > 
> 
> I would assume some sort of parameter configuration, either via devlink
> or something in the ptp_clock ecosystem if we get a device that has such
> configuration?

Yeah, but so far no one has asked for this.

Could also be debugfs if no commonality between hardware exists.

Thanks,
Richard
