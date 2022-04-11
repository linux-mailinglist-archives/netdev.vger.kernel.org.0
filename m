Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0154FBD15
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346487AbiDKNb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbiDKNbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:31:55 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865AB30B
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:29:41 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id g18so5927576ejc.10
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xx8B9iV3eFQTHNCQU0x6tR9ebBt9XQPeyD++UJegCMk=;
        b=QVWKX45+xis/VKK0oc6/ATP0sxCAZY0teK949vkBup2GRSt0aiSxnMpAUwCQmzz+TI
         pxWNK0h8f26L5WH1seio0B9tS22uELKkfhKCGv1tyr8LZdii1p8kpSv8EP0ctO4SCnOm
         NxSNXkeN5KAnzpv3K0V9elHgWcwN2aUnwCsfVCkighpZpX4Loy6WzZ2HUZ6SwBHrdgfl
         aQd55FbJwnEZ9o3wbVKvAg7jzZ2YgVmPIavJ+1I8E8xcwBw5AGMUTI2U5i6swCpvPfJF
         X2Eyetwn6ykKl5eeq5M4bd6Hh0saktwlNmGep++bLDrG+7AP4uat/2CwLQq2U2aT9a82
         0zFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xx8B9iV3eFQTHNCQU0x6tR9ebBt9XQPeyD++UJegCMk=;
        b=qc0GoTvCe2T0c1vow1oF79/YP6QZvTKcLyexx0oBgw+2I6vtVPYWec8YZzhpRfAihQ
         wDEQE5B1Ne8Pa1epBGaYze21hT06TVb0HBylPmKX5XVkguVUqaI+4GQhDtHfafZ9F1A0
         dt5KC2gCF7qHCmaYg12oYInFkHz/N9lp5z00X0IWOK6N6s27Wdts/eZTY3vhKRq6qXqu
         1H6AF2cA8BmuHwcgQrvuKoxAjF6OkLeqzu6oM5LdL9LfJKwxTJFCzmxoZSxpWhQGKHPD
         eoWaWinKrWIGbqByHjoKDIPhM95onjFUU4lq9SKpy8Br42KYK696TnvJ0aQBJrkFCHLc
         x2TQ==
X-Gm-Message-State: AOAM532aC+dSSfKA0ArIAFmcOipnF2shv4ig5+KoeqyGGMNv1gKoH8Kt
        g/MnpY2mMdFiF3KvM0A0qCE=
X-Google-Smtp-Source: ABdhPJzr7nTPIlbnHBaVUgMXiIP3ACpMavJfCy8baMMe/pqiLuHl7KauHLmoDClNDDR/r1CygYTi/Q==
X-Received: by 2002:a17:906:2403:b0:6d1:ca2:4da7 with SMTP id z3-20020a170906240300b006d10ca24da7mr28728145eja.533.1649683779872;
        Mon, 11 Apr 2022 06:29:39 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id p3-20020a1709060e8300b006d0e8ada804sm11896131ejf.127.2022.04.11.06.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:29:39 -0700 (PDT)
Date:   Mon, 11 Apr 2022 16:29:38 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Erez Geva <erez.geva.ext@siemens.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Sudler <simon.sudler@siemens.com>,
        Andreas Meisinger <andreas.meisinger@siemens.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH 1/1] DSA Add callback to traffic control information
Message-ID: <20220411132938.c3iy45lchov7xcko@skbuf>
References: <20220411131148.532520-1-erez.geva.ext@siemens.com>
 <20220411131148.532520-2-erez.geva.ext@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411131148.532520-2-erez.geva.ext@siemens.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 03:11:48PM +0200, Erez Geva wrote:
> Provide a callback for the DSA tag driver
>  to fetch information regarding a traffic control.
> 
> Signed-off-by: Erez Geva <erez.geva.ext@siemens.com>
> ---

This is all? Can you show us some users?
