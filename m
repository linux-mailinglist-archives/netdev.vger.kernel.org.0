Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3756916B1
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjBJCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjBJCcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:32:13 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B725B1353F
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:32:12 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id c2so4446697qtw.5
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 18:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x64Js9rMHJ8IPun9toPGT3tuCa9KIOQNn5MUaoUfmU0=;
        b=nP6WBHC5Z9HGsUUS7hEYwFKsROCqNFMQr46Zym15RKiMNyv1++VSXoXafS2vI0aAEe
         4TpAZiDOUB6KL+mgjYFFzdlEHs0+cv1UB4xTfDFS3JhrKlxDbJ9KuXIDINGjExadqyPP
         6bXmxW5rR8VRVllzFjKH43XEaEbfV1nXsCNxaLlBLsqPTQ5nc9VjPpUVo0geZYdSuN2Y
         vjhaFQuJ7L9pF/fEgEbh8FYEk0xS4UE2f8Zf0gvRMWkaQuRqU91Pr7UmhW+ct3MGH6N/
         eQS28OTB6N8dOrUMl/soJJZ1csKB9uzqIUYxfLZPrO1y4o+JKsAMYCvJ70HROExUZA6n
         Wv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x64Js9rMHJ8IPun9toPGT3tuCa9KIOQNn5MUaoUfmU0=;
        b=GzYDfIqFa6tjz3/yE5WkW8QKL2PGfAOkoHuaW2oaIjeH88ouPy8x+VrQp/R0tygSRA
         U8dTTqwpW7X6ui7bUscVGY8uvZ6xUn5VO2rStmHDpCncaTuUqY6wEWg7Btqe964mSO99
         WYZIrHTf4ggOcy+kSsBNC8nPZgOeE27XP+wkAbATUxDTRIUSoU52KMs62bcla1igd2Jp
         raWbxN8WGuhNy3EYFx52k0gKOSxIpGZ7cL38L3AHm65HRJzc0qS3KczOVFkZ17osQxLX
         JPi4lqxjJmKM4cWh9vNo/121N4A98TUHJDhUlLU8OQBOjoSs3x0eetDQC4Pek4ok43GU
         HC5g==
X-Gm-Message-State: AO0yUKWc5835u2/vybQd3b9DaYNSzutpGa/EgwW3DbeRMM7cz3Aa6BwL
        verh1GMX58gkdKOvuA7pkCjkZkvFVig7IQ==
X-Google-Smtp-Source: AK7set8++BT1AMHM8ay9IlVr1YRjx0V1sge1IP2fIeeRrC95klDEjOuU8t7DqXrdkdd+0NMdtS9CTg==
X-Received: by 2002:a05:622a:487:b0:3b8:4694:b728 with SMTP id p7-20020a05622a048700b003b84694b728mr22777824qtx.1.1675996331674;
        Thu, 09 Feb 2023 18:32:11 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id h1-20020ac846c1000000b003b950b03b6dsm2511953qto.37.2023.02.09.18.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:32:11 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id EEAD74C1ECB; Thu,  9 Feb 2023 18:32:09 -0800 (PST)
Date:   Thu, 9 Feb 2023 18:32:09 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 3/9] net/sched: pass flow_stats instead of
 multiple stats args
Message-ID: <20230210023209.tti6hw4ggpbwycb5@t14s.localdomain>
References: <20230206135442.15671-1-ozsh@nvidia.com>
 <20230206135442.15671-4-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135442.15671-4-ozsh@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:54:36PM +0200, Oz Shlomo wrote:
> Instead of passing 6 stats related args, pass the flow_stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
