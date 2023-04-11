Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9CA6DD738
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDKJwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjDKJwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:52:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678CC2722
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:52:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v9so12776888pjk.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681206730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9z7w0EiBZ/kTaXcVHYnuJAr+WShSyva/hufvnUvn+Ag=;
        b=fPZXlebdRTVGM6VkRVhA7006t8vjs1Mp5IEYTxysCfwd3xydsjRx5ESOWhxIw+Yiut
         1bAaU9vyIKzgUGNzBEzlEu74QgA+kBs0NiLgrJANqP4wDaT/hQDKp8gX24xg+TguwjhX
         M7ENkPi8tf2sJEuQQ4dCIpcmp0MxzwsXoZ1Rik8SIaNR8GYXK7tISz88AdAp4NAqKUyA
         qVBAPzwdd8a/vdFD3laYX+z9IZdIoVnybQWsBQzk0NVUf2NtZ06QknxqWH/yuPHqoC3o
         UIfWC5P/PlQcbQS8hKSnm/hGUozlcGMe3nGNCihRc7Cy000YYW/aOSKUG9FzzPFHouy4
         EEbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681206730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9z7w0EiBZ/kTaXcVHYnuJAr+WShSyva/hufvnUvn+Ag=;
        b=e9F/lSY1hpo1Okzb22+s4rVkghT0yUr3yDop3ZSu71KzLa2N23XuAJdckSO2UKAGGL
         osiK2w9GMGhDwSqU0uhPul0u0bKkdOy7uVLh0MTMqqdMrUQ9Gd0HL2KCKfgSdX2M+ogQ
         qlDS009PN4c8+3pDcQO384tbDuWy48VhzfjBy+O2umLI2X4uOsV/K1GUw0jTjy3JOTaR
         Zlx05V55la7YEqBwr9c9ueGojjK/yGLTmh+5Ko7l3ATkc2X2bkQjpsKdLbIkfSvMMeH/
         Hz4AnY9tTqnv9CEyPfJqiUqXO/mzzTADc14rMzZM+toIgsoI/dVpcfzXdnAu7dMpGHj4
         MwcQ==
X-Gm-Message-State: AAQBX9dXzC765fZehMPdQBzgJOMA3P5wAfLTHtPSxi5mjeneFeVbekDi
        z9p6w79I61rtYyQ6uz6vp4o=
X-Google-Smtp-Source: AKy350YbhBdmOgUVAujZTuZ3GVkPqR6Kf3kx8tAm6T9s80txFVwZ7+Am3BD/8t7CLhme1drXZ6yO1g==
X-Received: by 2002:a05:6a20:b547:b0:e4:9940:d7c9 with SMTP id ev7-20020a056a20b54700b000e49940d7c9mr11789067pzb.39.1681206729767;
        Tue, 11 Apr 2023 02:52:09 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t184-20020a635fc1000000b00513973a7014sm3904879pgb.12.2023.04.11.02.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 02:52:08 -0700 (PDT)
Date:   Tue, 11 Apr 2023 17:52:03 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin Willi <martin@strongswan.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification
 behavior
Message-ID: <ZDUtwwNBLfDuo9dq@Laptop-X1>
References: <20230411074319.24133-1-martin@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411074319.24133-1-martin@strongswan.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 09:43:19AM +0200, Martin Willi wrote:
> The commits referenced below allows userspace to use the NLM_F_ECHO flag
> for RTM_NEW/DELLINK operations to receive unicast notifications for the
> affected link. Prior to these changes, applications may have relied on
> multicast notifications to learn the same information without specifying
> the NLM_F_ECHO flag.
> 
> For such applications, the mentioned commits changed the behavior for
> requests not using NLM_F_ECHO. Multicast notifications are still received,
> but now use the portid of the requester and the sequence number of the
> request instead of zero values used previously. For the application, this
> message may be unexpected and likely handled as a response to the
> NLM_F_ACKed request, especially if it uses the same socket to handle
> requests and notifications.
> 
> To fix existing applications relying on the old notification behavior,
> set the portid and sequence number in the notification only if the
> request included the NLM_F_ECHO flag. This restores the old behavior
> for applications not using it, but allows unicasted notifications for
> others.
> 
> Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
> Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
> Signed-off-by: Martin Willi <martin@strongswan.org>

Not sure if the Fixes tag should be
1d997f101307 ("rtnetlink: pass netlink message header and portid to rtnl_configure_link()")

Others looks good to me.

Thanks
Hangbin
