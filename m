Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78213FDE1D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 16:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245279AbhIAO42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 10:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbhIAO4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 10:56:18 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C27C0613C1;
        Wed,  1 Sep 2021 07:55:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s29so2249336pfw.5;
        Wed, 01 Sep 2021 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=OXnaUXnPiLKsNovMhvipaKPWm7GzIVfHvGw3TUPMneE=;
        b=Zm/PTIWnIJVbqsPPFPtdnI6NMwoq3fuB1mWnUrRjV/eS/prkUlru2+c/p5nS+8ihr3
         R0LjSU73W3W75fWFV87cWG61Oqy0aHsT9x5A9dl6FzI7D85nb58iVIWsTXCp/SIlOqTs
         KmFSNvqVAsDFmJ8KruXbBR8CljjgVqs6zcJDk9EMdRBxVyU4qgdScABjw3OeVdg+Qt+a
         tI2pAZyoudj0VvWk8RfYZKJaPFeMy9Qzi9sOYN5tPhr13qJ4dhTrfeCmf5DyJovsyGBp
         jfns5QcgWdtudiu8mFyRUqY6WttYDBPUws0L2flAna4pzzXvd6Q0/xPKFUSybLV80Z7M
         pVZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OXnaUXnPiLKsNovMhvipaKPWm7GzIVfHvGw3TUPMneE=;
        b=HOSsVQemRPksQ5EvainBTYtBfWxRoR0KjWgNzxmY4FnSGCrADNshkAs1VZXdjgi3no
         s91a3//SwLmS/0/0MS87kJ+19nA9INIbsBVXWpU/Pn9512cPh+a6FUOhvxWKXUOD4NmA
         YqvXoLwQhyIzx93o8GBCAX7TAs11DRH//CmjCQdNqZG0MQieJ5UQNqdV80ik+oG80lb+
         +kEVI/NCd7LvSBVaU6YeHyRBqD9XqGZ2uOtjqpyAqn0hMjiSLT6xombVr8nU0uz2rXBl
         cxtKdneFgYMzxGM9EgmRi8TK/fH0EopWYWBYk9AOFlYA99HtTrsr2y82U19rODFmeWP/
         4+kg==
X-Gm-Message-State: AOAM531wg6AMHK1u9lFw5p740M8T6RXWI66wCCrNE2XWITffRpHKXZSs
        ZhJDy0st9rzHdEnjzknjZqNoDjFmM5s=
X-Google-Smtp-Source: ABdhPJx8yrwHgmL13buQFFNZyJ/WOhAPD1G+uSH1ENzeamWqBHoNEApEFTF5Qt0kCH9uyF4xuXMxbw==
X-Received: by 2002:a63:d0d:: with SMTP id c13mr32314921pgl.294.1630508119294;
        Wed, 01 Sep 2021 07:55:19 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y2sm171567pjl.6.2021.09.01.07.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 07:55:18 -0700 (PDT)
Message-ID: <6bac579b-5261-f96b-7a26-61cfe5f8ce87@gmail.com>
Date:   Wed, 1 Sep 2021 07:55:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] net: phy: fix autoneg invalid error state of GBSR
 register.
Content-Language: en-US
To:     =?UTF-8?B?6ams5by6?= <maqianga@uniontech.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     davem <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ming Wang <wangming01@loongson.cn>
References: <20210901105608.29776-1-maqianga@uniontech.com>
 <YS91biZov3jE+Lrd@lunn.ch> <tencent_405C539D1A6BA06876B7AC05@qq.com>
 <YS95wn6kLkM9vHUl@lunn.ch> <tencent_312431A93CE3F240692EF111@qq.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <tencent_312431A93CE3F240692EF111@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2021 6:40 AM, 马强 wrote:
>  > > > It looks like you are using an old tree.
>  > > Yes, it is linux-4.19.y, since 4.19.y does not have 
> autoneg_complete flag,，
>  > > This patch adds the condition before
>  > > reading GBSR register to fix this error state.
>  >
>  > So you first need to fix it in net/master, and then backport it to
>  > older kernels.
> 
> This patch is modified according to the contents of the latest kernels,
> the following is a reference:
> [ Upstream commit b6163f194c699ff75fa6aa4565b1eb8946c2c652 ]
> [ Upstream commit 4950c2ba49cc6f2b38dbedcfa0ff67acf761419a ]

Then you need to be extremely clear in the commit message which specific 
branch you are targeting, which commits you used as a reference, and how 
you are fixing the problem. Also, the register is commonly named BMSR 
(Basic Mode Status Register), no idea what GBSR means.
-- 
Florian
