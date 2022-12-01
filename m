Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5307963FA39
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiLAWBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbiLAWAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:00:32 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50825C3FFB;
        Thu,  1 Dec 2022 14:00:31 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id s141so3490817oie.10;
        Thu, 01 Dec 2022 14:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CLhodCfebXacfzn8L0ng7IpfW1B6LHq2ScRWQhj4rlg=;
        b=Kaw8ZjlS7oWKg84Djg/nc94uSjxONMAd1O9JQMJltpDELtloI695wOzOmspstcG8V+
         Nrj8msAaD2hFXwDt1lTVmsyQyQkod/CDrqInaTHdp+vYeRr4LDutuy48b5/Z6m+G1v+x
         V4c/6GdXv6UZCTFKzDiUUchxQMPClV0O1tH0RLnyDP+wChgs35GZC1tzTcHsIHaDoafE
         rqyTkbJZb0CylLT4TODdLOARUmB0OkZfeRZ02c0ESAh3TYNF6r9wGY4qww7Y2nDyYCzy
         IflCq1QtwBXAWcoFXZCjyP3m/XnM9/wfowM//uT86rkMryNliQMhVZTdG6x+YuNmS+VH
         PR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CLhodCfebXacfzn8L0ng7IpfW1B6LHq2ScRWQhj4rlg=;
        b=ec8c2N/uprHT9Kmy60WjVCKkiz61XQKd2hupAAyi0R2LDecY/3OE0Q8NNlVdsWI3RM
         hsCeFAHYdE+483FnUSDdTo6fbmjN4aUonxkSIVmKVWaHGGmFoy5QLgr4rV9MHtMN7eVi
         E1loR41AAUTENc2b/ZZfvAYmc+tgnconHp53wf3j8ufniaVdGx7Xjbl4Urz+/argiYIS
         oug5R4beyk3FnZyw2V/N7mw/HlmXu2yamMaCovigN7WdDZ7iSJI7K+aNPMWCSAUX5Q04
         Zex7UyLTepvpaWDRD1DxX7qN4aN38rgpPsaKpcwWfssO3l7Yno+ozJeP0mYMcKcEkgcZ
         hwOw==
X-Gm-Message-State: ANoB5pm5+JW76RlTIQCuXFKivfDdwNPEmptCStfgVPHRVeefLUOIEC/Q
        0q/gbmOr6Op6FgI59qf20yg=
X-Google-Smtp-Source: AA0mqf6SItRmzib/rXONgSoka5uzg4GyQzIKbdUJU/SutPdeWnK1BiuOZ9Z/N3m9jyH5WJINA52zRg==
X-Received: by 2002:a05:6808:1592:b0:35a:e1a7:c3b2 with SMTP id t18-20020a056808159200b0035ae1a7c3b2mr23183424oiw.223.1669932030592;
        Thu, 01 Dec 2022 14:00:30 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:92a5:79c5:cf91:ba47:c68])
        by smtp.gmail.com with ESMTPSA id q23-20020a05683022d700b0066e7b30a98bsm708780otc.2.2022.12.01.14.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:00:30 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 18278479BE8; Thu,  1 Dec 2022 19:00:28 -0300 (-03)
Date:   Thu, 1 Dec 2022 19:00:28 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net-next] sctp: delete free member from struct
 sctp_sched_ops
Message-ID: <Y4kj/PXkDk/+qtzN@t14s.localdomain>
References: <e10aac150aca2686cb0bd0570299ec716da5a5c0.1669849471.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e10aac150aca2686cb0bd0570299ec716da5a5c0.1669849471.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 06:04:31PM -0500, Xin Long wrote:
> After commit 9ed7bfc79542 ("sctp: fix memory leak in
> sctp_stream_outq_migrate()"), sctp_sched_set_sched() is the only
> place calling sched->free(), and it can actually be replaced by
> sched->free_sid() on each stream, and yet there's already a loop
> to traverse all streams in sctp_sched_set_sched().
> 
> This patch adds a function sctp_sched_free_sched() where it calls
> sched->free_sid() for each stream to replace sched->free() calls
> in sctp_sched_set_sched() and then deletes the unused free member
> from struct sctp_sched_ops.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
