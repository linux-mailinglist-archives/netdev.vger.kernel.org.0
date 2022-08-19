Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D56B5996D4
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347497AbiHSIM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347509AbiHSIMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:12:23 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5147BE68C7
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:12:19 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w3so4749472edc.2
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=+4EAKvesIPwq/W2hA8zX0Ovt5poM6noxw0nRwCgtE9E=;
        b=5+2a2wPRbgQdmzw73xLJbGjAChOCZFM2iafaBJPPfOAwGP1g34G3S6gz5Ps6JxbSxc
         tIEGPQ6S9YiJPeWb+7EtjJEsS42efjXPhDUR6nrO6D5Vy2t54FANgxGXHw5eruKBd+5f
         2XOZzCE9RbCBVNF8Tu5Xi7RAbqhHfZn8zCjV1tqkvpZypdkDHfedBLf4seZ0OdPWE8gz
         PVLb1x/uAgeeZrfVbC24uWYCIAoVpYzQhtS50AdvffJbxPFPfSVl/QFcVJSTYU7ZHD3M
         fHAZh6gaRymvhzJGizkDWxq6Y11RJ7ro6SUO3hZSU5ZJLgQj+0OQGHRQSr18oyjcv2Yi
         Ltog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=+4EAKvesIPwq/W2hA8zX0Ovt5poM6noxw0nRwCgtE9E=;
        b=hkq5S82/S/6DYkLoeDaqwGeu1hrCBnndfx8GGWSMAlONgAWVNHk5MpEVP8Tpy0+qG9
         YxrNGGTuTzIzsk6vVbnRlB6mHiOLQLuQzw5qZMrLEdALuxHdY3In9DEDsESWTaDd4vpI
         DsVAEPRUmnLvlc7LkSNefbodH7EZZo8upfzwlKCNNzkqgmNPiuCNyT/4+jW33AcNiaTq
         WH3EApf2+6laRS2ng8+xLkiSw5LCbVf645jgsxofGb5brCrVJuEec9+oj4swS+o6/IUq
         A9jkmmuG/cDGT86JQKnuxf741opH54LhSAmyReWRZf3XAA87+gCJJEVwnNG73Lpzy8Wp
         cyZQ==
X-Gm-Message-State: ACgBeo0olHuvyf2aZIMsguKGxgdR+/ohO31Pt3pOLYClz9XtCdPmfhe4
        0ZA4ctzSKHRCenXTSppdaljfcA==
X-Google-Smtp-Source: AA6agR6m1YnCLaRatbISitRZaV+2YjFaNlbHJGVevr/zFntAIpkb0Yaoic/1JMWvYRQXN3wZWMIXKg==
X-Received: by 2002:a05:6402:d05:b0:425:b5c8:faeb with SMTP id eb5-20020a0564020d0500b00425b5c8faebmr5037894edb.273.1660896737895;
        Fri, 19 Aug 2022 01:12:17 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906210100b0072f4f4dc038sm1967647ejt.42.2022.08.19.01.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 01:12:17 -0700 (PDT)
Date:   Fri, 19 Aug 2022 10:12:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
 target
Message-ID: <Yv9F4EpjURQF0Dnd@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
 <20220818130042.535762-5-jiri@resnulli.us>
 <20220818195301.27e76539@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818195301.27e76539@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 19, 2022 at 04:53:01AM CEST, kuba@kernel.org wrote:
>On Thu, 18 Aug 2022 15:00:42 +0200 Jiri Pirko wrote:
>> Allow driver to mark certain version obtained by info_get() op as
>> "flash update default". Expose this information to user which allows him
>> to understand what version is going to be affected if he does flash
>> update without specifying the component. Implement this in netdevsim.
>
>My intuition would be that if you specify no component you're flashing
>the entire device. Is that insufficient? Can you explain the use case?

I guess that it up to the driver implementation. I can imagine arguments
for both ways. Anyway, there is no way to restrict this in kernel, so
let that up to the driver.


>
>Also Documentation/ needs to be updated.

Okay.

