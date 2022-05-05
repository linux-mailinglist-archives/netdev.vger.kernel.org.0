Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E111851BE62
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 13:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbiEELxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 07:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiEELxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 07:53:47 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F0BA5419E
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 04:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651751407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i67tjVaHB78cF63WCGFJ3CI1nO+ngKMIoetrGgmJHsE=;
        b=V1hPzsD/jysvk4A0+nwNEQq26G3nhHKHG045vABEkWDexxrd4o9VZivz5NG4GqPP46KfyX
        R2Aeva4W7GhaVE2H4rK8L7BaY+pdd4XNxmDdkjZBjo5Dh9fRb+J+S20u0Qa7R+EZk8KFeE
        VBDaa5ueF2Vp6y3Yn+jFQBQ5R5qk7P4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-482-pN2cmblFMUKztr8JCX2WhQ-1; Thu, 05 May 2022 07:50:06 -0400
X-MC-Unique: pN2cmblFMUKztr8JCX2WhQ-1
Received: by mail-qv1-f70.google.com with SMTP id j1-20020a0cf9c1000000b0045abd139f01so2370629qvo.23
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 04:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=i67tjVaHB78cF63WCGFJ3CI1nO+ngKMIoetrGgmJHsE=;
        b=ZVaDyFEK5Jfw2LP6fUufcwNciNtvZ7HOW2azZ4O8iNiVTrVQMi7wDe+nkLSX66kPil
         8f47NjHkYi/6uMQCd/Jx6EorvLAHVKnOB6zF7J+tp1pMsoPX41nVnAQ02nKo9vK7HO8t
         nva38N5PaaTNdUplw2m0K2PScDZItaxIf78zpAjOvsWWwPeloh1Zm9fhe1jFZeFxqCLs
         m4OhqXCHfKRz/N8gZ6hZzMvtN4Gx/n+wosXEROoY5MwPDmkQLt9BeKAPggAuMPXpRLMo
         KAirReL8TgHzHmq1q2mvj13xw8YdKjqrzOYYnruf300WShQl4N2tzV+66nP2+EEpjIue
         MJGg==
X-Gm-Message-State: AOAM532OymhnKUoudI1FqEJh73EvMxV5xh/IIBJ0kV0M7TqBiPpgBury
        GWLZSDgmEAhr2kKJpIaAg6kYE+mXjKAEgHN+6hG92s3VIj2RrNbUnIrd6ouZRSA4b7acG7aqPNj
        bPt5cjESMQ13NTUBz
X-Received: by 2002:a05:622a:c6:b0:2f3:bc21:6618 with SMTP id p6-20020a05622a00c600b002f3bc216618mr2180832qtw.581.1651751405822;
        Thu, 05 May 2022 04:50:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOTBe3w3XwO/LTDfuNLb9fUejFkDt19134p1Vhe3E4XGpHcM00tYTmOmxXiDwwWATyL/GdXw==
X-Received: by 2002:a05:622a:c6:b0:2f3:bc21:6618 with SMTP id p6-20020a05622a00c600b002f3bc216618mr2180819qtw.581.1651751405564;
        Thu, 05 May 2022 04:50:05 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id b10-20020a05620a270a00b0069fc13ce202sm656175qkp.51.2022.05.05.04.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 04:50:05 -0700 (PDT)
Message-ID: <0606e0fede42a16c93231498d23c9afd5c05e26e.camel@redhat.com>
Subject: Re: [PATCH net-next] mptcp: fix deadlock in mptcp_close()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliang.tang@suse.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, kernel-janitors@vger.kernel.org
Date:   Thu, 05 May 2022 13:50:01 +0200
In-Reply-To: <YnOu5xlGgE2Ln7lj@kili>
References: <YnOu5xlGgE2Ln7lj@kili>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-05-05 at 14:03 +0300, Dan Carpenter wrote:
> The mptcp_data_lock/unlock(sk) functions are taking the same spin lock
> as the lock_sock()/release_sock() functions.  So we're already holding
> the lock at this point and taking it again will lead to a deadlock.

Note that lock_sock() (and release_sock()) releases the relevant
spinlock before completion. AFAICs the above deadlock is not possible.

Still I think we can revert commit 4293248c6704, I don't see why we
need the addtional spin lock ?!? 

Thanks!

Paolo

