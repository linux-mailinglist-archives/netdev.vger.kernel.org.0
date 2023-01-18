Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18968672484
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjARRK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjARRKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:10:17 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516745866E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 09:10:16 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id h21so30200793qta.12
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 09:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQ0Fy1gUWi32PVXGgfmGiODkzO6MGRTj/B9TCW4Y3i4=;
        b=GHCrLKBhJ5PPkq8sB5LuLiKkAy45xC3gXk3ebgSOOO6q6OcrtnDNuv3fJY8YX9nj1S
         9tmvvU7xZgiiX+wWfTEDVpTGKSrQegCFJELSORgCUTjvVCxlUxdLurO8INCpGqZkUaRN
         6CGpd7nVBCBjiUWzwd9UWQ1pkixMp84zCEAVG4zlC9Tc6BvNQa5dbxAXngED4LPjs6C5
         BJW6bolR6qGkF5nL2g58sJPaKJ/ZLUk7C6pE5YsBKyLY4vvTJnn//Nl407FrFAJIVrWl
         Vpuh1s88UggfwrmP2Fg3AO5up4Ta+zXgrIgxfd1Y6i/tsXtKgHC1LmtuJaIokHp2tpP/
         wzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQ0Fy1gUWi32PVXGgfmGiODkzO6MGRTj/B9TCW4Y3i4=;
        b=lMBpIr0HcCxZtooXka/DITD87C5jP2BfuMPOaqvDmNfd7p6P4MEPhJNxvXArAj0be6
         1bcnWP/pv1PNyoUlRwtZlvJN3vLbkt0cqCkcjP5etRhUeMBQSuD9o7N+i2du4W+0S7/M
         zxZXUD8S9pJcUviCn6uBNay9SgHYeT0QNJCy4sYoGmUFCpTPClclIatUqsiMxF1XjHII
         rAqgmXd14xCYRDA9D1auqxV7M/Vz8VNOrfn9kl9EO3h543wT563R3uU64ztVv/X26m1+
         PTgBS2qaklo4FfB1JF/NplTZwrH9xKgENiFu5wkjj0UnDWU3CSIxp7vYOPPs4Ov2WFf/
         xkdQ==
X-Gm-Message-State: AFqh2koZmg/GxHKKEDgsCdfG3BHsxcLFu2EAzSs1UvnMjuPCPBnrZcQq
        R4l2bT2PqVtttaGhRFGFoOk=
X-Google-Smtp-Source: AMrXdXuj7qm7QxmWCGqJAP9FAhpT5BRnltCOxZ4M9QnQnNcd2MafeOx7sUh7KzpdyelIoHXU48qkOA==
X-Received: by 2002:ac8:7353:0:b0:3b6:8ac4:4a41 with SMTP id q19-20020ac87353000000b003b68ac44a41mr1573178qtp.32.1674061815404;
        Wed, 18 Jan 2023 09:10:15 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:f76d:9b27:708b:8300])
        by smtp.gmail.com with ESMTPSA id d8-20020ac84e28000000b0039c7b9522ecsm17720720qtw.35.2023.01.18.09.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 09:10:05 -0800 (PST)
Date:   Wed, 18 Jan 2023 09:10:01 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com,
        Cong Wang <cong.wang@bytedance.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net] l2tp: prevent lockdep issue in l2tp_tunnel_register()
Message-ID: <Y8gn6fEUx6O0lD1t@pop-os.localdomain>
References: <20230117110131.1362738-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117110131.1362738-1-edumazet@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 11:01:31AM +0000, Eric Dumazet wrote:
> lockdep complains with the following lock/unlock sequence:
> 
>      lock_sock(sk);
>      write_lock_bh(&sk->sk_callback_lock);
> [1]  release_sock(sk);
> [2]  write_unlock_bh(&sk->sk_callback_lock);
> 
> We need to swap [1] and [2] to fix this issue.
> 
> Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
> Reported-by: syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Link: https://lore.kernel.org/netdev/20230114030137.672706-1-xiyou.wangcong@gmail.com/T/#m1164ff20628671b0f326a24cb106ab3239c70ce3
> Cc: Cong Wang <cong.wang@bytedance.com>
> Cc: Guillaume Nault <gnault@redhat.com>

Oops, my bad.

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.
