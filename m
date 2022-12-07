Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DED6645AED
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLGN2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbiLGN2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:28:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349ED3B9D5
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 05:28:22 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id m18so12430021eji.5
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 05:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mrZ3BGsfaA32811go0kCKtKR+PUZof+SC4fHx7E1Rus=;
        b=nmUd9khxZnwExuxkqPp8/QfSy3uUl1d1E0Gi57Xrw9cSYQ3s7dCr1MIlKz6och0sW9
         XKRK1NJjONY97Sy1Z9XAZhUVdEA8n4RsRZoID4y0qPyPGEMwJzo+rnQe+1jATQc/upe9
         jf7I8nKgtJdprOMJFd/HFtka3+aXpsXgiBCt+NH7U7J9O4hgE0d2+qYl8EJ6/lJCFrpz
         kK+NWeYv6xhWIlexmrRiKnVbT4lBkU3oe7B0JNffKH66eEiwn8aJRXT/K/GU7tXdvX/c
         2TanbEYcfjIfY/VH8SzqZVdugHfrlnctOpcxwVNH7KKGyr3pucUxUnvfroQSrczQVMmQ
         xdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrZ3BGsfaA32811go0kCKtKR+PUZof+SC4fHx7E1Rus=;
        b=QyvqG/u8PNDF7YNrRvgnYoRyQi1Ltw05DIv0raGqLjBsio1ptuRpSO9TD50rcD5PtH
         qoJgeov57TXAZdo9TsVdrJPj0x+hVBC3DbPNTeivdM9xK6zcU/NUislPlLEs1ePHD4Iu
         /LsLLQKWfUB0+1zlarUK9nDYhS3o75Oj+rhttgW/pLahiGKpONXeRBz/fFIs0CwG/rIR
         a3dj0R5zkn6tpr/XNDiP5m3k93bm1ryNYzZyGaAJdoc19Ny09fVjlKJmhOkQjQCsn4q/
         4MT6D8/pYHtYzPFAUITK+w7u29FgLu0D9q1sBIKWBi95L58MAqszULd0mjAjMIU9/4bH
         a7SA==
X-Gm-Message-State: ANoB5pm/NElme375e2Y4s2o+S6YwOkCpqSSIlMcYhS5KQhtbR8+Tt+9I
        Jh0pDGjvvI1bd2msEPj1gUFeOw==
X-Google-Smtp-Source: AA0mqf5y3GZ6RJJUHAc13DXeDPm82KLE0rrb8kerhA7uBIfNc59g5jJH7chDXlN2F6mK12Xg/2eMxQ==
X-Received: by 2002:a17:906:5583:b0:78d:b3ef:656c with SMTP id y3-20020a170906558300b0078db3ef656cmr58684353ejp.627.1670419700812;
        Wed, 07 Dec 2022 05:28:20 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k2-20020a170906680200b0077077c62cadsm8437961ejr.31.2022.12.07.05.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:28:20 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:28:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: Re: [patch net-next 0/8] devlink: make sure devlink port
 registers/unregisters only for registered instance
Message-ID: <Y5CU81h+NDjUVVSJ@nanopsycho>
References: <20221205152257.454610-1-jiri@resnulli.us>
 <20221205170826.17c78e90@kernel.org>
 <Y47y0FZQxPDK3B5X@nanopsycho>
 <20221206121226.21de7ca3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206121226.21de7ca3@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Dec 06, 2022 at 09:12:26PM CET, kuba@kernel.org wrote:
>On Tue, 6 Dec 2022 08:44:16 +0100 Jiri Pirko wrote:
>>> I didn't reply because I don't have much to add beyond what 
>>> I've already said too many times. I prefer to move to my
>>> initial full refcounting / full locking design. I haven't posted 
>>> any patches because I figured it's too low priority and too risky
>>> to be doing right before the merge window.  
>> 
>> I'm missing how what you describe is relevant to this patchset and to
>> the issue it is trying to solve :/ 
>> 
>>> I agree that reordering is a good idea but not as a fix, and hopefully  
>> 
>> I don't see other way to fix the netdev/devlink events ordering problem
>> I described above. Do you?
>
>Just hold off with your patches until I post mine. Which as I said will
>be during/after the merge window. I've been explaining this for a year now.

Sure, no problem.
