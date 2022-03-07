Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925FB4D018C
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242346AbiCGOit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241358AbiCGOir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:38:47 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADBF38D94
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 06:37:51 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso13477447pjb.0
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 06:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CYKQ+Lga0njXQ4q0XNJwLSe6bn6m2eFhWk63t2A6T6Q=;
        b=SyE9kHBzNL4AaY9lRoIX/M5MI2V50P+/GfhI6f1QNNFv3q1HjMSuDQiCCp81rnhNxt
         2LDlQK+W9USjv9zLWHjaHmCW0aV2KPsWuIGBbRgsxiA3FzqQWImojJtiw7dvKejTzcre
         3aNx2Ib8lMsFXKY4zlHLxCXpjZPp/7zivypmq3hssCGCJvrk1CfHZAptGo4RgopuuVvW
         vQ+PoF+pa3TwtMffBLikaoh+vly6JuxwawnyGSrTEOEjS/vAybtMpP1xntNiYY+fDk04
         vHuKbv6qOa/XKWSKTtkuwiyjt0xuPNqu0jkp8oCgPsehwzepoY49KhekEH647Vy/Jdym
         1y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CYKQ+Lga0njXQ4q0XNJwLSe6bn6m2eFhWk63t2A6T6Q=;
        b=D8zq6ImcIHuztVoBvSG0joIam2KNpd5P0spVlPCBg9JoOJhk8vNh+ftJ5UIcgWKRoY
         W1CSMuitnNbBjcD4PboXf+KcwUXC98H843djIsComI2v4h/ZNXmNJyL1r4PZ4GZSfOaJ
         t9CRnMNEI2nKEBgTG++VJyVgQqTYiSn51VN3JP3AqS9Wc0YUoJSICQBtPYPBkJzqAJ64
         z6iLQTA3Zf3Pe5dffGxvPwvPXok4e4DQgIXl46HmKfbEuq+BDkYhw5r1gxkifOa4tadH
         3Gr0l+zRKBUB1hxgFJwHxBYUc85J3iGvdJU+jvZGR9QjQOtXW/kSDjwvUdwXcluWj32G
         kREw==
X-Gm-Message-State: AOAM530zp+5tS/v6MSaPEdDXifLKB29jZxnsztakOfE0MAx2xmSiI3hT
        e6dmSfVEu1xgTwiaMwa97j0=
X-Google-Smtp-Source: ABdhPJx5AZh/k80EiyRtYQXBtSgaHYsM6YZ+e6B+GBcDuLrVTPwocqITXD0rCTZwa97Z0j5QBBkZsQ==
X-Received: by 2002:a17:902:d4c2:b0:151:d590:a13d with SMTP id o2-20020a170902d4c200b00151d590a13dmr10289248plg.85.1646663870878;
        Mon, 07 Mar 2022 06:37:50 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id e10-20020a056a00162a00b004f6fc39c081sm4386078pfc.211.2022.03.07.06.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 06:37:50 -0800 (PST)
Date:   Mon, 7 Mar 2022 06:37:48 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Michael Walle <michael@walle.cc>, gerhard@engleder-embedded.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, yangbo.lu@nxp.com
Subject: Re: [RFC PATCH net-next 0/6] ptp: Support hardware clocks with
 additional free running time
Message-ID: <20220307143748.GD29247@hoboy.vegasvil.org>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
 <20220307120751.3484125-1-michael@walle.cc>
 <20220307140531.GA29247@hoboy.vegasvil.org>
 <YiYVfrulOJ5RtWOy@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiYVfrulOJ5RtWOy@localhost>
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

On Mon, Mar 07, 2022 at 03:23:58PM +0100, Miroslav Lichvar wrote:

> There is a need to have multiple PHCs per device and for that to work
> the drivers need to be able to save multiple timestamps per packet.

That is a big job that entails a new user API.

For the present, this device can be supported with only minimal
changes in the PHC class layer.  See my other reply.

Thanks,
Richard
