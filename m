Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6156678AD3
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 23:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjAWWga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 17:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjAWWg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 17:36:29 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7882E1EFFB
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:36:28 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id p24so12909668plw.11
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 14:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oYovDWEKrBADD9Aaa4tDOwHIGB9wam0Ek2LerhZP9aQ=;
        b=f574ArMOwv4PRGG4CM8704vkmMSOoihPN0GvvAk6xl9uY7DDAucYeVXxDd2FgBNVVv
         K5hHCfKiMPnlic25Oen3cyz37ETou0X4+wISxY66Syi/91ici/xg7okzlBSxtLJyi/xJ
         R9PwuPg2Eus76gE43MmrbZA++/7PygkY/ZVZjKZjFkWQbuFM+g04jIpz3Siobs1LZYNP
         RxB2F7J2dW3Hk9WjXtHvieFC9u9M6cxyinfUaApCLb5kChdaFib03ryU4y8iifkJpIfs
         tn3DSyqeMg78L9A9zxcWAiY4JWmj26aprk0Krul9zS9YZaxiVZ1ODkOTbabMKrcJ5SKd
         +9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYovDWEKrBADD9Aaa4tDOwHIGB9wam0Ek2LerhZP9aQ=;
        b=uhg62JwXCy8omgOijT563ripGboZo73CjoSokXqR+7Yg9jWWguke/19/WFQZ6MFRle
         /NPObDI11nu0P5VKdMvVIehX4mdgpUSM9IYh8lBL5dCe8yhOsLqCrvnC/VlPbQAF0eP0
         dK4ZVfLFRYyDypJBKqd5lgSZF0mMdDTvv9T0PJ6EZlOYI/uLIQTYNBbbxUXsHRJZ8kdf
         r1g6PTtmtwMTmPfInZ5dyCIa/HgEwRepu6irkInbQtCsL3e/8cVX1K/eWNAq4uoCDCsU
         l6tYS1p6mwLGuHfGmBjkHBNyKHNHMLChfJT/ZgQjQPbYMxlo03O/fw7T97FqjZ3VRGS6
         HujQ==
X-Gm-Message-State: AFqh2koHGjRn0+PnZI14YENE85/yYMhfStHXpLqZXl00d6aWAiF2WbJ0
        5Rpvpn6u9uQe/mF2B+0xCgs=
X-Google-Smtp-Source: AMrXdXte9k6Y6YXo16ZC8CWVVtXYsqjq4jbTXUsmDXo4tYHekS5/3jv9mWQ2PRUFl87yR/1ABjvQfA==
X-Received: by 2002:a05:6a21:8cc3:b0:b8:7d27:2cbd with SMTP id ta3-20020a056a218cc300b000b87d272cbdmr25744474pzb.43.1674513387844;
        Mon, 23 Jan 2023 14:36:27 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id w8-20020a63f508000000b004351358f056sm47138pgh.85.2023.01.23.14.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 14:36:27 -0800 (PST)
Date:   Mon, 23 Jan 2023 14:36:24 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
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
Message-ID: <Y88L6EPtgvW4tSA+@hoboy.vegasvil.org>
References: <87pmb9u90j.fsf@nvidia.com>
 <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
 <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org>
 <87ilgyw9ya.fsf@nvidia.com>
 <Y83vgvTBnCYCzp49@hoboy.vegasvil.org>
 <878rhuj78u.fsf@nvidia.com>
 <Y8336MEkd6R/XU7x@hoboy.vegasvil.org>
 <87y1pt6qgc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1pt6qgc.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 10:44:35AM -0800, Rahul Rameshbabu wrote:

> 1. Can the PHC servo change the frequency and not be expected to reset
>    it back to the frequency before the phase control word is issued? If
>    it's an expectation for the phase control word to reset the frequency
>    back, I think that needs to be updated in the comments as a
>    requirement.

I would expect the PHC to restore the previously dialed frequency once
the ADJ_OFFSET (adjphase) calls stop.

Thanks,
Richard
