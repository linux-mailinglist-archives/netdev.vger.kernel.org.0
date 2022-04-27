Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCBF5112AA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiD0HlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358947AbiD0HlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:41:01 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA4EBF97E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:37:51 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id c190-20020a1c35c7000000b0038e37907b5bso2918642wma.0
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YFaQWdNCP8eBXRlYbrYalN77IGArAHfTCC3mEA2almU=;
        b=o/Mb3D0fZerAz+7Py2vdYU8V3TzUTob9fsbFQ6+RZeBnl3E2tBBj9NQoUVu30+Igyy
         8DxFLnO39wQm563OFnNvitJT0aLk2e7R+EVnHYZnILaI5H3RW6uT9xDGtfldi96E3gUx
         AkSGf0eH5dLdSi76YkeOFSuwDTMyet5jtGKbX7jnej+0QihGyF3dEaQtbbG2192u1W0u
         TneDmCsrg6XPW3GUDCZTW3mZkmMgHivx5rYoME2zcs4q9rIKUqOzvomEwqBsBgipxJfF
         T0kxthlldF0stv0BduoBsmJx9F3Vuk9dH/U75e8fW6oXJXikMi+sa9gUl+dYbprvJPRT
         rISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YFaQWdNCP8eBXRlYbrYalN77IGArAHfTCC3mEA2almU=;
        b=7vAlAQ0vIAuhRoZgKkCc2S0uQiQ6a0fybMwIJFy+5bistk7EU/NCDZbXPXrFO0DTk+
         nxxgP9PRrPgTHP6pboJFmx6/SJZZOPfnM/ocaIOUJM5Jnu7aCOZKEDEdeY0AGeEi84Ls
         DESOIqmY3G8ws5APlXnokUPBuBUcl0jHwxdnw3bn4PRQVsFIDP6BgHqPzImUOLQDD9ip
         CVTmObuEVsG9QEgGRibLE8k4K/dZYeg2xMJxFGbp9wkSPdpNelF92zQMjttUBIX0m8nY
         VgZkHMW3xXp4JQgyhnZwcg/iLRDZ6fGj3Q7+lbiJ7Ct7jX753UTFNYyTutuQwWiWdrAn
         8v/g==
X-Gm-Message-State: AOAM532rmT000uVfgEws2bxgW3aGzoVPpdszt/NTZF+RbKnDXvrM6Nl1
        uw0522C06RV0IYsz5Ag2VAvYiw==
X-Google-Smtp-Source: ABdhPJzUq08G7rNFNA/uiWQtbxOuZXbBvOWn8rnUoEOvQZ291DAepsHI20HtCCc2VAvKijXP48ZQ7g==
X-Received: by 2002:a05:600c:4e46:b0:393:f5fb:b3df with SMTP id e6-20020a05600c4e4600b00393f5fbb3dfmr6948700wmq.80.1651045069709;
        Wed, 27 Apr 2022 00:37:49 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id bi7-20020a05600c3d8700b0038eb78569aasm939713wmb.20.2022.04.27.00.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 00:37:49 -0700 (PDT)
Date:   Wed, 27 Apr 2022 09:37:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <YmjyywZ1U8U5svzu@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
 <20220425090021.32e9a98f@kernel.org>
 <Ymb5DQonnrnIBG3c@shredder>
 <20220425125218.7caa473f@kernel.org>
 <YmeXyzumj1oTSX+x@nanopsycho>
 <20220426054130.7d997821@kernel.org>
 <Ymf66h5dMNOLun8k@nanopsycho>
 <YmgOuUPy9Digezvh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmgOuUPy9Digezvh@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 05:24:41PM CEST, andrew@lunn.ch wrote:
>> Does not make sense to me at all. Line cards are detachable PHY sets in
>> essence, very basic functionality. They does not have buffers, health
>> and params, I don't think so. 
>
>Ido recently added support to ethtool to upgrade the flash in SFPs.
>They are far from simple devices. Some of the GPON ones have linux
>running in them, that you can log in to.
>
>The real question is, can you do everything you need to do via
>existing uAPIs like ethtool and hwmon.

No, it does not fit. Ethtool works with netdevices which are
instantiated for separate port. The disconnection between what we can do
with netdev as a handle and how the devices are modeled was the reason
for devlink introduction in the past.

>
>	Andrew
