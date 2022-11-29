Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8298263BB7D
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiK2I0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiK2I0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:26:40 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EBA56D5B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:26:38 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id d20so7976563edn.0
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pgrzkkklPcAQYmyQMmCpEE1o3a9ohgeq3WVDc+0vm08=;
        b=XiAjLYS5j4RwLKJGZxfsDINusHr9CRwW/Y3flS/dZFlY4O60OTBiKSUQjxvGIX+3Rg
         dWAJ1ca2t+K0d+bi0hYAhKvXStoidmphxQ0TDLO6BSnIL0/DN3PnlJFDIMFRt3mXIa4g
         ZMPEl75jJykR9z7KbG5TQ2wepgiS9FlevG8+O0tg70kUd7KYg2ugRDQg84wgWnAptk9T
         NHGqa/dI8nJ2hDhtgvRxfieYv/2wyABK91GuDzW2R+fCWgqEG0yJvCUyqY3kdcbZmt0P
         gS7yCTuTDX6ORTNxuGB1qv1ErmB0M7sxgSP6i5oaQm/rCTvkHAkTwlvZFSa7282d1MRL
         RrTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pgrzkkklPcAQYmyQMmCpEE1o3a9ohgeq3WVDc+0vm08=;
        b=s3/RXeW3oH0MewwzWOB1pvLn7Fal2CNbOnj63yL7AP8ZK/l+SZid2FYZVdXAAJZWtg
         8vpIZGn7mybndaKo7ceaISU00prwAwuRCTH0boSgH4CY6oOZLaTt5MHAPpYL+9uQahH0
         tcPKe1M1KjictFWQSc5FeA2o4TybDuFQE61ZQWgBE7nRSPXIuyCRk2yQNqmNofig7TcS
         bYGLS1X4YrKKphC0R7c1Qx6zAwAUAgTqQq5i1sdZf06nr9UQOWE8tKpQz95Gy88u8Tvf
         TwoJzJuqKSlAeBXp5V9/SXpaeEhNE1EHacMbd2bsvabrbheccU0qzR7xhH2qUJgXW7sR
         2n1Q==
X-Gm-Message-State: ANoB5plem8X9AgDg3DiL4YZEGsKEoFLIg5ZtDXMDBTz1PBgfYHDPkr9d
        eD8Lhh/UGV/GzNLwuze4gjl/xw==
X-Google-Smtp-Source: AA0mqf6AhCTZUtOfuGYDhXfqaKP0HI3CcryljG1Et3fvW7wqzGVxjYaxttb++c6crBKvAOdrZVKVcw==
X-Received: by 2002:a05:6402:1f14:b0:461:c7ef:b09e with SMTP id b20-20020a0564021f1400b00461c7efb09emr37432404edb.58.1669710397245;
        Tue, 29 Nov 2022 00:26:37 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id r9-20020a50aac9000000b00461c6e8453dsm6017247edc.23.2022.11.29.00.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 00:26:36 -0800 (PST)
Date:   Tue, 29 Nov 2022 09:26:35 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Shalom Toledo <shalomt@mellanox.com>,
        linux-crypto@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, oss-drivers@corigine.com,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>
Subject: Re: [PATCH net-next v5 3/4] net: devlink: make the
 devlink_ops::info_get() callback optional
Message-ID: <Y4XCO21nYeJZKUh5@nanopsycho>
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
 <20221129000550.3833570-4-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129000550.3833570-4-mailhol.vincent@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 01:05:49AM CET, mailhol.vincent@wanadoo.fr wrote:
>Some drivers only reported the driver name in their
>devlink_ops::info_get() callback. Now that the core provides this
>information, the callback became empty. For such drivers, just
>removing the callback would prevent the core from executing
>devlink_nl_info_fill() meaning that "devlink dev info" would not
>return anything.
>
>Make the callback function optional by executing
>devlink_nl_info_fill() even if devlink_ops::info_get() is NULL.
>
>N.B.: the drivers with devlink support which previously did not
>implement devlink_ops::info_get() will now also be able to report
>the driver name.
>
>Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
