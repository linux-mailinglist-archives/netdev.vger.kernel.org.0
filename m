Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2386269879C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjBOWBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjBOWBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:01:44 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB701A5D5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:01:43 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id nd22so95675qvb.1
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 14:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CbCFJR152yn7IOp4//HBvIEuHBLkbh+a0ZRm/4c2Ie8=;
        b=Y/9bBzPIr+wwyFERSrIGh0/KPEb7WjTgiFyW+vViLpvquAKTMC0n2fsk8gXdx3mo2k
         N/EZGE/wA8HFRjunZ6RFV2TZtur/kkjgW6fEdgyUKGUjNxuDcRIOnn52wjXg7fieW/25
         dIfNC1lfp4/7yIuMt/9Wun2D11CEc1XOh7iHbUoGu8OjSOphidiNJHbOa0/KPOezBrTD
         VE3Tx+S7UCk98nRw8CY6jDkktf2UpJi8scEIg+iAGJsQsAIAr2YSVvm1giG4UFOwJvQE
         NPyEiE7wzIXRtS1fb7TZ4xsSudktpRywuklCqZY4pAZBuK4VobaXZ/ptKkSp2fPpbwwN
         y3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbCFJR152yn7IOp4//HBvIEuHBLkbh+a0ZRm/4c2Ie8=;
        b=QN5yo1t8qsADDS9kxVyNE+AhFtHqJy5KvL01GjN775BZYmZE43NVT1s6dM7m3XDz33
         luVFPMigq9LXxiE2bGNpW1f2AWPDYMdvFVh3Kwc/vcFw0yr/mwZwiM4ghCr4qXehgRoM
         trFAYkv0bXxlatBR8cVxNjjCCDPQDS2JSuO+r3J7fCGSDT4GH4Gh/hvr6hzZS49t3wx+
         S58uh5QXAHwDdRFGrhvEhYIfPWtfNXRH3QoGeiYncVDdkjalaoSZ9GhaPHj0Z5zfNy75
         CCkY/DCLhkDO5FaXmgMH7oIlrg9M8q5GWC5uFmqcMZNl1MBvZNmNz3mtC3DGZcYB/QwM
         Wz2A==
X-Gm-Message-State: AO0yUKVNYadh6VysPnOljLaewJAbjEGNX2zr1A+VXwWnYnRzcWkB+pqO
        1SEAZivj1PM3C/kLI8/MFFA=
X-Google-Smtp-Source: AK7set+vadTWD8/vzgh6glTT+ltD64/EZ7P9vSNpKSDTESQxe0dOH+7GxYLSSWtQe/6InFKb9guXAA==
X-Received: by 2002:ad4:5cad:0:b0:56e:af4a:11f8 with SMTP id q13-20020ad45cad000000b0056eaf4a11f8mr7765175qvh.4.1676498503028;
        Wed, 15 Feb 2023 14:01:43 -0800 (PST)
Received: from t14s.localdomain (rrcs-24-43-123-84.west.biz.rr.com. [24.43.123.84])
        by smtp.gmail.com with ESMTPSA id c20-20020ae9ed14000000b00720ae160601sm14659908qkg.22.2023.02.15.14.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 14:01:42 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 3A51E4C2914; Wed, 15 Feb 2023 14:01:41 -0800 (PST)
Date:   Wed, 15 Feb 2023 14:01:41 -0800
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
Subject: Re: [PATCH net-next v12 4/8] net/sched: flower: Support hardware
 miss to tc action
Message-ID: <Y+1WRYwNHufH2MBw@t14s.localdomain>
References: <20230215211014.6485-1-paulb@nvidia.com>
 <20230215211014.6485-5-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215211014.6485-5-paulb@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 11:10:10PM +0200, Paul Blakey wrote:
> To support hardware miss to tc action in actions on the flower
> classifier, implement the required getting of filter actions,
> and setup filter exts (actions) miss by giving it the filter's
> handle and actions.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thx!
