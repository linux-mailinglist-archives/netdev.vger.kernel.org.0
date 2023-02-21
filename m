Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1505D69E181
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 14:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbjBUNkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 08:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234115AbjBUNkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 08:40:13 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810A727D74
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 05:40:08 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id q5so5052933plh.9
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 05:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dEYXM4+oHcAGumI0xJQMGPUyilaqpLWqpokDwoNCpZg=;
        b=QS815iKtcOYfULiTMuHFLHjlA8fmfIirKGJGgcdVdUK0tKosuyul5cB7EZ/FBrurri
         oIkZu6z1P74AW4V/l3vDj4kLYwP0uNrX0eRS5XiRmLPS9KfPqTtQ4PLpUAM1RG4tZKMa
         DODYBApDgKXSbezNhFnLpOj258n2sQOJvRnNJ30P1uZXj4RZOFp/PoG4EDmnYDA5tSEU
         33fHFgSUPXqsDVzq3Y6Idjx2ERtsb8qFDfWfHV/Es1PGjcH092WQaxnSREcYo4WJXAGh
         vomDkWWoQ/CE5Wu99+9qMdmrmGpu0yjUiFDKwEMCVfPCMkFjCwIXhaGZZLfmYJ7PKC1B
         mAgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dEYXM4+oHcAGumI0xJQMGPUyilaqpLWqpokDwoNCpZg=;
        b=JJI4xJ8Qua5c5HFSJMmPDiwiUOPq2KM6a0y8dpKoZG9noJ38ZfiaOhqotE7IaTKKhY
         6GriXc/CN2hLS70a+F8bJZKmbmtH9H04+kDditZNLKkZdILFAKmpE+SO4DuW1dYrtdjY
         2da+ZF6a9DQPCa6UGDBl5c3lHTO5Yg/GZ8GrZqkqKgTqt8qYKC4rV3S3//B3PwAoWRwI
         BdAl9TofFAg+t3xW1jL4qHnh9q5Yj/fAJowrsgRo1axRzQw3kfstfPa409iWaTKliIXf
         firnyQ0XCvWsnfOnKgs/Zh5tPQX8EcVq0s2Ai6qvpyVkbIae/VGV3+78ZWqBIvM6T0vo
         yEKA==
X-Gm-Message-State: AO0yUKVOK+pG0FQHIXlbdpuFqxusKaLoXOFH12RQr0VsWdhbhZ1VWqab
        VVSQ+pEORQcfsqJGW/YxS/NVY+tyMU9Em4AcjP4qFQ==
X-Google-Smtp-Source: AK7set/ReMS6ZFx7vaUwfqSm9m2t08ArF+D0nk1UAeSPgy8ZukK12KYl9sQ8IXM4xVBs8r6jSi00Vu4gDQtfd1c5oxo=
X-Received: by 2002:a17:90b:3912:b0:233:f53f:95eb with SMTP id
 ob18-20020a17090b391200b00233f53f95ebmr1501347pjb.51.1676986807690; Tue, 21
 Feb 2023 05:40:07 -0800 (PST)
MIME-Version: 1.0
References: <20230217121547.3958716-1-jiri@resnulli.us> <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho> <20230217083915-mutt-send-email-mst@kernel.org>
 <Y/MwtAGru3yAY7r3@nanopsycho> <20230220074947-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230220074947-mutt-send-email-mst@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Tue, 21 Feb 2023 15:39:31 +0200
Message-ID: <CAJs=3_BW+8xL9gvUvUpFwRM_tBVvK3HY5aAQsGboN933_br9Vg@mail.gmail.com>
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Vitaly Mireyno <vmireyno@marvell.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Our device offers this feature bit as well.
I don't have concrete numbers, but this feature will save our device a
few cycles for every GSO packet.
