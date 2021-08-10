Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2A53E5880
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhHJKnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbhHJKnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 06:43:16 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEDCC0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 03:42:54 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id g21so29577794edb.4
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 03:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xiKDF5sk3nZVqiLvWljYWOnuO6utGOgyNbzwJDUY3Jc=;
        b=k/0dmRwzyl/h1/DIT/ZBTd7wOco3RdeLLqDPVQSvUXSni1cROiQM3WwzrTGiFPP69O
         vQU6yzVDX5UKBxs/7wvKmcV2fRN0/sjUWKIydN5/Hn24evQZsjaVUqr6Fr1ttcIMkWnj
         0TFQhT4wTuTbfcObgjt4v6Ins18QtMCZ1D/SgShVJluRXz196B9L43VuiHCyi08nl9Ab
         EmRjwxFl0vQFaQIPjRBMrpcpG2lv9QcwiFReDfetE+1jQlf3+krIG1bj/xWDeG9lzuTA
         Xm9NcAWUSU9h/8mVBoBQCmX/cHrXv1GbNJUFffbAuG0NyaDtf1egzKsvy/M8Qvz7wcit
         Ko6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xiKDF5sk3nZVqiLvWljYWOnuO6utGOgyNbzwJDUY3Jc=;
        b=rT1gKzk/lSUH1IEyK4TXxpJFKi2eEXgp324RHMgtC/jMSDFbD09uepe8wE7Xmr8Tjf
         UhdDLeUrCXzw3GwfBNnyPiJVfV5/IgbshydYoN2YOO2PR06pjI4Se5CpWshxMWaVE8Tq
         oBbRs9IlQ4USXXPXuBMX8WO16pr7yeOJ6UAjmpm07mWaL9DViEbm8QwouMsnxK7r41LR
         Y39bmTf+1LYQXIucVtFrcb4ZTP5so1R9msPTQi57S23wmhFrGdWo+BEtnS0/Mq/iohX7
         5+NP8VWdNGhSLbUbH6VioeKnJJDGCLVjxGWPS0Nq3VZdwIkUgaGfp/r9M87KeEFTtKME
         IIQw==
X-Gm-Message-State: AOAM532T/lne77seCTvufFSknM75z274ZK2wKlXUqF3mP9n4B1E1InVA
        r5nP7SfVc8uMtSqnmxc3Mgc=
X-Google-Smtp-Source: ABdhPJxRuTaO/745ELNpRppuiqMzNYiUkrwiHvoYei1nFybKYEMMVj6ft79tVSk05jWdgieVLgXF/Q==
X-Received: by 2002:aa7:db13:: with SMTP id t19mr4166345eds.72.1628592173526;
        Tue, 10 Aug 2021 03:42:53 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id v20sm6682115ejq.17.2021.08.10.03.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 03:42:53 -0700 (PDT)
Date:   Tue, 10 Aug 2021 13:42:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: Bridge port isolation offload
Message-ID: <20210810104251.k7w76aqlvsvb3jcy@skbuf>
References: <CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 12:40:49PM +0800, DENG Qingfang wrote:
> Hi,
> 
> Bridge port isolation flag (BR_ISOLATED) was added in commit
> 7d850abd5f4e. But switchdev does not offload it currently.
> It should be easy to implement in drivers, just like bridge offload
> but prevent isolated ports to communicate with each other.
> 
> Your thoughts?

If nothing else, do add BR_ISOLATED to BR_PORT_FLAGS_HW_OFFLOAD so that
switchdev drivers which have an offloaded data plane have a chance to
reject this new bridge port flag if they don't support it yet.
