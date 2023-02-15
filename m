Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FEC69879B
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjBOWBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBOWBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:01:13 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D203A87C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:01:12 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id b21so174836qtr.13
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+6bgt08c7OEKv+L31DkVIMdRVD2x3vG9sxVuCKOLTw=;
        b=Pq42JMFUYfOaNPtHsfHUIwottbDftM2BR+wkLn/HiuvUsWJl1iv3pIZZ6sTHgv8LGQ
         dVNmLpRXIjG4qr9rM0Q56G5bXaB0rTKaoHaTAlJCP/nlgyVX0Me0DrZ0fDBJSCv/f1mC
         wccFARvVElhkbqME4AXnDY6+wWksqLtqNQSPC1spYnXlRF1hMbiTOPTZ6WNH7PuhCV0U
         FYOZNERspawjJPvUiks8lu/mRPmDpaZLl1x0SPjW1nRWf7izNOTGbR2XYJRpaQ7wrPRK
         hc5658ji44h8VnBYDmcXrrUZtrKmFxz4MMsT6sokxVcPTez5XGHwYYueE7ZG6S4Nt4mH
         uuIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+6bgt08c7OEKv+L31DkVIMdRVD2x3vG9sxVuCKOLTw=;
        b=tOqei7uQQP/rGHWdwOcH8M8Prf9Qa1Bq4JGXJ5MNIO1U9CG+kh0y+6cM0IaqrjlOYf
         XcvTXv1i6/5IqLX9F78hWtiQCCPFf/lEJbIvG/iV7qfTDkvdm11YaWS5EGSS9RpC/CFK
         NmgWWbVg04/hA2vNV7GQILcxjKk5hFmTjc2nuxzjH+GiqhDohmfMcop6kTYg1EgQma1a
         nLJH4eiIlF+rumf4iEIHbn37Nd0EQ5qyeSmCZaPVcmoXrXx90pQJajP/AqC4YjTBmcrW
         WNCBWtw4QwC6CsmPsTJLUAcZX15nopu9r1/cWHjS8KUzvE4Y8IJPdxDQtbw9nD++CGvh
         bDLw==
X-Gm-Message-State: AO0yUKVq1CV8sHQOOUl/eBESjcHDGRL2dLRaUCpncHaokohQi1mf3qVT
        5y1IhgnDBGElUYYrN7d14Gd5+Ah/JcVRpg==
X-Google-Smtp-Source: AK7set+Y3li/ZwSN5ndw2qwwFRePWojtK466iwe7WyGvfQ/a589HEk8EC7liz4S0GVTngZasS/ud4g==
X-Received: by 2002:ac8:4e89:0:b0:3b9:bc8c:c1fa with SMTP id 9-20020ac84e89000000b003b9bc8cc1famr268620qtp.5.1676498471956;
        Wed, 15 Feb 2023 14:01:11 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id r77-20020a374450000000b0073b425f6e33sm7257646qka.100.2023.02.15.14.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 14:01:11 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 36CDB4C2910; Wed, 15 Feb 2023 14:01:10 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:01:10 -0800
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
Subject: Re: [PATCH net-next v12 3/8] net/sched: flower: Move filter handle
 initialization earlier
Message-ID: <Y+1WJuC97kr3jv6s@t14s.localdomain>
References: <20230215211014.6485-1-paulb@nvidia.com>
 <20230215211014.6485-4-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215211014.6485-4-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 11:10:09PM +0200, Paul Blakey wrote:
> To support miss to action during hardware offload the filter's
> handle is needed when setting up the actions (tcf_exts_init()),
> and before offloading.
> 
> Move filter handle initialization earlier.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
