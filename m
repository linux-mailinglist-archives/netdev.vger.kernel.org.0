Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E0F69879A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjBOWBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjBOWBC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:01:02 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5C320D1A
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:01:00 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id l18so36371qvo.13
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nG52OJ2gxjyiSocN1Mj1oY2FCCwWeCckVMvDBzKYA1A=;
        b=NYbUVgK1PJfAK6pBg1myMIJ5e0lKAL/UP+HPEAkLy9NHIMfErOfFC55PsqKLNJBf0W
         ssvFDMKP8gJmQQPh/UzMuRqDoIRArdHD9Z1vmNjuKZMwgtsJ5VcalHxKIodXItNqTzDV
         69ruW3tmeatVdpZfkY+ZMefEMo9C8BKNl5rMTP6EhhOk+SxDo/CyUJVZi4M2uSrfpyQf
         vY/7JYTzgdo+k1bvfUW1UzDV8oryUokOaarkiEmgWhoqx9LJ/RFe5foBZBYfNB7vN2UQ
         0fl8zrjk3KCvhlL8iOaXQRlncDqTOwHGrBqKdLW+YqvEc3ESeusLDQ485wdweMidFmFs
         JrgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nG52OJ2gxjyiSocN1Mj1oY2FCCwWeCckVMvDBzKYA1A=;
        b=0zZ1f645eJCyrnuiOAhZ+uEIvDAyw4RcGXRMQjaxFpEiY9q5GRxQGdmFFKNphQTIcZ
         +ijl32SxmuPgEDxr135qxYJ/dPNJ3c25XQ8htciGdDoTPHMsTtEb3CACPM8Rm8nUt4ZF
         xJphANcE/WPZBwyAj+/Dxff/KUZEmSDL1tJCVCGh6sVRV6fmqq2AE62PebeZhdpb5xKt
         KU8Z3OntK+x2KokmXjFx3Y6axdzr/ubkmBGWRd1DLxR0ZUITQLCqTnDNMXLZChn3PIX4
         SnL72zg7gmA1CnlY0386uLCoLXX4tCdEwYcs0Ct1vdi1tvrdF87jqfekKjzMfL54yW8N
         juPQ==
X-Gm-Message-State: AO0yUKWgfL4NEF6jwImKZ7bkPbvPHKKSK85Y8oBLlmv+jeza7ajjvh/5
        zaZ6wYeMSPrvYCwnFI/SbP4=
X-Google-Smtp-Source: AK7set9IDV0Z3A208vZmrRDORrB1Ad1CR0g9HF5z2W49xuwiKbDXAE3x7Hnjs6FGCRW6gFFSyKmrXQ==
X-Received: by 2002:a05:6214:d47:b0:56e:f4e0:a4e0 with SMTP id 7-20020a0562140d4700b0056ef4e0a4e0mr739507qvr.12.1676498459492;
        Wed, 15 Feb 2023 14:00:59 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id t73-20020a37aa4c000000b0071eddd3bebbsm1400555qke.81.2023.02.15.14.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 14:00:58 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id AC25D4C290C; Wed, 15 Feb 2023 14:00:57 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:00:57 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v12 2/8] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y+1WGWZiLfEYNC3M@t14s.localdomain>
References: <20230215211014.6485-1-paulb@nvidia.com>
 <20230215211014.6485-3-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215211014.6485-3-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 11:10:08PM +0200, Paul Blakey wrote:
> For drivers to support partial offload of a filter's action list,
> add support for action miss to specify an action instance to
> continue from in sw.
> 
> CT action in particular can't be fully offloaded, as new connections
> need to be handled in software. This imposes other limitations on
> the actions that can be offloaded together with the CT action, such
> as packet modifications.
> 
> Assign each action on a filter's action list a unique miss_cookie
> which drivers can then use to fill action_miss part of the tc skb
> extension. On getting back this miss_cookie, find the action
> instance with relevant cookie and continue classifying from there.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Paul Blakey <paulb@nvidia.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
