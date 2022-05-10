Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0248520B0B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiEJCP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiEJCPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:15:25 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FE420BEF
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:11:28 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i11so6187703ybq.9
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/fgPEvdaGGIfTr+8GoIFKM1Dax204RTM5raL5XrigRU=;
        b=j9WAU2g5V+NDH0WYsOtmc152QJ6nHcGFOJhh+7VgB5mUyZKPxHjNsZCdTAR++P+WUZ
         cYZiPWs5ur6UjbckRPUPE7ajMnZP+0hi7TD1Muj+FFsOm9byVUmRmpw+DyFBuQsicWEf
         bjm0TFIRXru7MNlTc+p83qPf0CQGO9tuVAN2ghmJotcslPVtXyrWYYmxVuPQ6tZfUx9n
         sTNFwrDCL5gOZBOdp14Sh46bHy2esfvy8hBr4bq7jQq9YvP9bGRO4qecSk3elsBPteg5
         BoSP63vYMPnd323FORIIFViZ1It58cnZysljuiOPV1Jv+7Cwq8Jh77/j4dMs0EApfgpx
         HwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/fgPEvdaGGIfTr+8GoIFKM1Dax204RTM5raL5XrigRU=;
        b=2UW2f1fzTLMfqsLjFxCja9VJWdKwnt1BIJzoC4KZGbp27AFj4yIxsYPNSJWhVVMdqa
         mxUt/M7TaWCKYQS4P7QupRUT8IqRIpoF3njplbI69CPPsJg/vxxg8rygzdlqOvRV/8sN
         WN8BsziaBcgcT4nMBM/zlNH2AD/100TVtXWGeF3aWDQxk8/moxpGPFXEjkFJgXbZfWw9
         0lkaQYD3PLAjp7f/G3JQfb3GMgkHQtnOq2p4egzTrTS4H//HFcmal6V02l6I1b/9xtJz
         FKH9ImhK+gHzzhgTat9dDq2EYxebkd646eHnJFRuyGnNzEXovHWHIHQ9IlYU6PcpQv83
         kzHA==
X-Gm-Message-State: AOAM532zWmP4EAOiqQyoYmWHAcdho3Lklv/4tkglCZ0SGbxRWF7TF6Ds
        spL1LHTko+aHmTsU3pZLqQofSHOdEwyp081Vp8t9xQ==
X-Google-Smtp-Source: ABdhPJyGZheQEeUKRr7uJsK4Oc0vi//VBL2AJER2oD9LzixvSliDTO1nFJRTB+V2Sa0Y6reQRmfdYlQAjPHIngH0YBE=
X-Received: by 2002:a05:6902:c9:b0:641:1998:9764 with SMTP id
 i9-20020a05690200c900b0064119989764mr15973908ybs.427.1652148687044; Mon, 09
 May 2022 19:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220509190851.1107955-4-eric.dumazet@gmail.com>
 <202205100723.9Wqso3nI-lkp@intel.com> <CANn89i+rMnV8RotzD7jfp8TgbJeV+XpzJFkWrhJe9YAtD9Wdbg@mail.gmail.com>
 <20220509183024.0edd698f@kernel.org>
In-Reply-To: <20220509183024.0edd698f@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 19:11:15 -0700
Message-ID: <CANn89iK6ydh4JctuYN3DCpMxp+5NhbSVV2=CA50MLOJYJH6HFQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: warn if transport header was not set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 6:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
>
> Yeah the order of inclusion is skbuff -> netdevice, as you probably
> figured out by yourself. We may want to pull back the code move for
> the print helpers. Unless you have cycles to untangle that :S

I added at the beginning of the new file :

#include <linux/bug.h>
struct net_device;

Hopefully this is enough.
