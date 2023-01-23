Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6380F677ACF
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjAWMYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjAWMYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:24:45 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48407ED5
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 04:24:44 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id az20so30044036ejc.1
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 04:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=q5h9WZaA7sid1P2R+YZM07D3y7vsLpPRGJjIsAtpibY=;
        b=KSRKwiqsGdsKsxXFcaWpu2IxB2vyojXgffLp0hYPRJb4exE2X98t1b50dHmqV/T+4B
         JdLHbpfhXlcq46t+pZZZSKe8q+m1S12nl1nCgHHshorPw7uKZzIRWhmSt7U/OVtGtcd3
         yBHatWisFrGU/dt3BBhtVDqSe9RubX1hLn/JijjCKZhCRgvmXSrUXTMJy/iVnY+ChIB9
         xC8Kpxja91Gk5gIXBIBUK1pVIvPE7aj+xFVz8L0slUh5UnFkH+7wFLKytulsHnwOYUmG
         hFnIkZQIKtaNrS5o1PF+frX96AhjqbIa9+llCjSpNgIhblVtk9O6jG4Pfd/liW5VItOq
         X/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q5h9WZaA7sid1P2R+YZM07D3y7vsLpPRGJjIsAtpibY=;
        b=qs2kInvc3HkY9x6tfD+A5VZLgQIKrZ31SRlg3J70ZxRy03TPBhEwxeNfck8lT9Q2Vf
         oqFYlQWpY2H2r7G5trw2sfXsOiSwQ371lVKh32CblZs84QLsn9HkYXkqMyPq22f3D+m3
         zEKkFlGZgwICr9e6ZuDNOOMwukrjDHpuMAY5UhctUtsw0EhsAtFzlstuy/l5aiwixSrj
         zZWnIZbryIPtWOgWWN3tFc+nen9vnSgtJCwVz6jykeBA1XHZJrKx6trSvuqORrSuYLUN
         b5W1EEDUtZjLWTnxeQ61HybCXUCGJgQ/tQJHc/nW4n0fbM3FnlGSqljTlIvfnodBIwti
         62bQ==
X-Gm-Message-State: AFqh2kr3RxzkBPPh8IuyOf+nvoezmAXz4IrhGDRBU3LrxL9CpRvL11R1
        oWc4SL/Fzxr5cgWP8y1TnF3j50zPZUOWp0oFFeuAZD/mgkpx0A==
X-Google-Smtp-Source: AMrXdXvrxzRMuIcj1bujn+Z278SmC0fqpmILPJ6YBnGDJgAknj1oLg/+3O9HpRIdPeQtLGD2LmFLJ2hh0vYsF8EfRwk=
X-Received: by 2002:a17:907:989c:b0:871:65a3:1729 with SMTP id
 ja28-20020a170907989c00b0087165a31729mr2462272ejc.572.1674476683108; Mon, 23
 Jan 2023 04:24:43 -0800 (PST)
MIME-Version: 1.0
References: <20230121054430.642280-1-kuba@kernel.org> <20230121054430.642280-2-kuba@kernel.org>
In-Reply-To: <20230121054430.642280-2-kuba@kernel.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 23 Jan 2023 13:17:07 +0100
Message-ID: <CAGRyCJHAGYF0F9UyL0d5DGpzxxgcdN=6P5yE3tfnorRJd_SWTw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] ethtool: netlink: convert commands to common SET
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, piergiorgio.beruto@gmail.com, gal@nvidia.com,
        tariqt@nvidia.com, sean.anderson@seco.com, linux@rempel-privat.de,
        lkp@intel.com, bagasdotme@gmail.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno sab 21 gen 2023 alle ore 06:44 Jakub Kicinski
<kuba@kernel.org> ha scritto:
>
> Convert all SET commands where new common code is applicable.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Tested just the coalesce aggr settings and looks good.

Thanks,
Daniele
