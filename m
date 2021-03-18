Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF303407D9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:31:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCROah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCROaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:30:03 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFC5C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:30:03 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x21so6917707eds.4
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PFm/T7cLfmUAhM0g0tAb/zAHVZrdHV8MtbmmWcgAouc=;
        b=hCNloPngrDUOc3LuX2gL5ZAeqqfSYtG9/2u4M5Qg/GcgJOFE7/VSaDWmD9OULlZAHL
         cEsMx2RI4mmvIhxPCIIs5+R7Sof6jtsQjFJ1Lc43kUfRun2GxcSH/OSMvdJ6Ou5pYWf1
         eGXYLRLhiuf4pfHVmBhIUZ2epfyMuJ0jxcRQfR2R/geQbSD82qv2IvpzlM0vVe9530Pd
         8PoOClQzDmG/DocojeOnKQoN0YpPHcNBuL7RT25E3If3Kp63fqcAKV4vAByRhqNj0HfF
         wZ/unzUdzdhWMrPzB+qZ27yEnadt8YaN6jOfEo1eCnBva3Gbg/R8x3okV5gcPU2H9ljE
         gGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PFm/T7cLfmUAhM0g0tAb/zAHVZrdHV8MtbmmWcgAouc=;
        b=WeCeNOd6me0AGsVuQNd9uDAiSTUDSD+J7x88pbgNfa2XFze7346/Eu67dOP1TwfAil
         jPXA1j9cTabERNK1Ot+yOnGfDO7olwvIIAFDAqb8w3eSo8ZFz6KtQxwLBM1J3aAUlPBX
         xTybye8utDupqKSJXPFFKIUsppUkqVyWKAqpo+Ei0hpDIoNydmisa5YPygK8w//4ykYk
         cbYld+JJ9EnOEA6Z6jBKkoNFI/3jcBj1J3wZ50W05u494AZQQihkIP4UhaajsnstmeLo
         xlSHD1KHldfvUcRzWSUvx28+NdUMXc68/6ILGkgtu9qYIqeFZ5NSTlghftLHIEHOxbbB
         t7hQ==
X-Gm-Message-State: AOAM531DAHADnX/EXjlFbVCsPrxnohBHDjCdQjwAsCnTzDQVTM0zNXDO
        GQP8m2joPdYsEhTUURQ/IPw=
X-Google-Smtp-Source: ABdhPJz4gWidLVXMG3BKZ4Ks6PT1mginMIeINgdqwzqKOv5Jc1BmysO7OtjVG15R9AVH5Wo7vpjrDA==
X-Received: by 2002:a50:ec96:: with SMTP id e22mr3987685edr.385.1616077801795;
        Thu, 18 Mar 2021 07:30:01 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id e16sm2030235ejc.63.2021.03.18.07.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:30:01 -0700 (PDT)
Date:   Thu, 18 Mar 2021 16:30:00 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 7/8] net: dsa: mv88e6xxx: Offload bridge
 learning flag
Message-ID: <20210318143000.m7prhml4cp6yzvxv@skbuf>
References: <20210318141550.646383-1-tobias@waldekranz.com>
 <20210318141550.646383-8-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318141550.646383-8-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:15:49PM +0100, Tobias Waldekranz wrote:
> Allow a user to control automatic learning per port.
> 
> Many chips have an explicit "LearningDisable"-bit that can be used for
> this, but we opt for setting/clearing the PAV instead, as it works on
> all devices at least as far back as 6083.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
