Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1746916B3
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 03:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBJCcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 21:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjBJCck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 21:32:40 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B7121A22
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 18:32:39 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id nd22so151265qvb.1
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 18:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=euw3IUsuHfwCdoZdhQYYhxeWy8iQVoSmgfPz7OWEOmE=;
        b=k0rjFSXMtfxpuFg6fSIdhnx+w/91pLxlv2nULnwl5fbD+xTHubA0Tw/J4GZVj8OLKM
         ITV+TqhaVlfR3D5ct2l/vxRJCTe9c4LTXGhtnvNrWS1jV+LX3jYgj+/Nz+my09OonuUu
         nmZt8RD9d+672tBEX3VnqIiglsCJFTMCRKM3jGt5ZY871iIYe7EBsbJm2hcPx7wO5ce/
         cIfH+tNHgpAhgL5NUvaCJ7LP8u+ncI46CsY4xxqc1JRmDGp7v9JHG4vgY46/oTyGw7VL
         4IkIEnll13PZiijGauTqPDNFfi+8lk7lsB8ex5AVtl75NPNNupsRSECvg7v9UafZRag2
         FvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=euw3IUsuHfwCdoZdhQYYhxeWy8iQVoSmgfPz7OWEOmE=;
        b=Kn/s4kOSueHNz0BcHyQsJ6UtJWX3YUTjiNhCeeG27JP0FEwv0FnSTSoEy/1VdWBz1r
         PrRT0Fx/RA3kBejVvZDzR1sXmoIeznSEFHQ+t5m4ETVMVmNO73LZCbfX7YSFth+4xA6T
         jXRX3WSe1YJAKGYyCCB2JGtcDikkKVy52s1mRdP7kLY8A6NSFkJyZO3W1rfrxbLXytBS
         50lJQ/u8rD/BbhjgN6hTJD9l13gkekknYY3n9WMzRQVKxkMzsa41/xgRY6kHTJPHXuoa
         6473B7R8UJ/UhiQliQ2U8loDEjrkzloLU/WN7QsWpgG6gregjwx5DuNHOEwQcrEKszA4
         S4WQ==
X-Gm-Message-State: AO0yUKXT02sICtYkXerD1ez00dA8BUmUfcBnh2FxyrfS0xth9kJ9SydE
        R8WuqGE0Ncjgecji8fHVGNc=
X-Google-Smtp-Source: AK7set9gQJVSkkEO0yBaqV9tns8cJWxEz7jQWEhvkIMW8PaMa1TUEyZ6qGBjH4tWR4jDA8BZGce8Xg==
X-Received: by 2002:ad4:5dc2:0:b0:56b:f0a4:7b77 with SMTP id m2-20020ad45dc2000000b0056bf0a47b77mr24166342qvh.6.1675996358368;
        Thu, 09 Feb 2023 18:32:38 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id c20-20020ae9ed14000000b00720ae160601sm2608842qkg.22.2023.02.09.18.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 18:32:38 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 272954C1ED1; Thu,  9 Feb 2023 18:32:37 -0800 (PST)
Date:   Thu, 9 Feb 2023 18:32:37 -0800
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next v3 5/9] net/sched: support per action hw stats
Message-ID: <20230210023237.skdiyav6rvn5tzmr@t14s.localdomain>
References: <20230206135442.15671-1-ozsh@nvidia.com>
 <20230206135442.15671-6-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206135442.15671-6-ozsh@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 03:54:38PM +0200, Oz Shlomo wrote:
> There are currently two mechanisms for populating hardware stats:
> 1. Using flow_offload api to query the flow's statistics.
>    The api assumes that the same stats values apply to all
>    the flow's actions.
>    This assumption breaks when action drops or jumps over following
>    actions.
> 2. Using hw_action api to query specific action stats via a driver
>    callback method. This api assures the correct action stats for
>    the offloaded action, however, it does not apply to the rest of the
>    actions in the flow's actions array.
> 
> Extend the flow_offload stats callback to indicate that a per action
> stats update is required.
> Use the existing flow_offload_action api to query the action's hw stats.
> In addition, currently the tc action stats utility only updates hw actions.
> Reuse the existing action stats cb infrastructure to query any action
> stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
