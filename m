Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB9F69779F
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjBOHyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjBOHx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:53:59 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B8713D6C
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:53:57 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id s13-20020a05600c45cd00b003ddca7a2bcbso820307wmo.3
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NyDPTqU5takt/z9NYDygAZ2zBovcJb8ophw2it442ic=;
        b=ZxNLiDB6aZikuyUgHZZsYQGYeCoEubb0Cg40UbtKmOU51LDsnHUOfTTcpG5GwHJ/Cq
         kBDwlcTT/0XH8TD1Quea9xnNWzBUdyUcqJAWLZ7QMG+nC3dXGwlfv8TB6K0VKxZOB7XB
         siBjBb/7I2LFqjTzWAFUtZAx2QTXC2c25Q1fiSY/yiAb/Ac744j2D6zQCO0GTOjvxIg4
         h521lODvHU6Xt/DPzUyfxvai03ujzEq1Yaj29eMTamxiyTWkBdHJj4PCqcxgZeWI3g8X
         4qAleDwpJFWiE7guMUpjWtXQS1Ks4F8QYauMqpiUeFsGz1eM9nLS7tY0+bSBE6BZahtr
         8T7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyDPTqU5takt/z9NYDygAZ2zBovcJb8ophw2it442ic=;
        b=gWsvlRqhS8gX389ovXELj2QSyy/1W/A8ksxmqwBNeJ4FMqGl1eQuW3ZY4D28F0LO7M
         VakcnowRXWGFB7AxBo8u+/rOUeQfaVPy8d25sXo8Zrb6KNveosBKI4zv6L5UeGe/cr/Y
         ITwvJwbhvL/aaNNNZn2DkjN/vDhVUFsjL+bt22Wanp8CV0zY+WbpZ1nk7YY5Pu6Xy+c/
         1eOW6NrI0T0j87vel4GUYfHcVAstb/1APk8d7WO2Htx324rolzjMk0TNfpVbFP7Vr2PU
         kTyt34TnvYUF/+PNWztG6r4p3M0+QAG9GutA6OD4bS0x0Hzn3tTVrBARbB+jymZC2pS3
         PgdQ==
X-Gm-Message-State: AO0yUKW7gNZdrqTIUQv2Vod6abMJK6k1XXchYyuTZV246SRyzRf7H2qd
        Q8SG+YO2Q3UtoIza4n++zg55PA==
X-Google-Smtp-Source: AK7set9yRI1mlN6WQYv/Y1LXTg+CemPHHOlkwOXvw4O6Cb/qSi/O0m15zQKNwSr6b3oil7YRNtgvlA==
X-Received: by 2002:a05:600c:4e43:b0:3df:e46f:c226 with SMTP id e3-20020a05600c4e4300b003dfe46fc226mr1228965wmq.16.1676447636123;
        Tue, 14 Feb 2023 23:53:56 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c2-20020a05600c0a4200b003e1fb31fc2bsm1288936wmq.37.2023.02.14.23.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 23:53:55 -0800 (PST)
Date:   Wed, 15 Feb 2023 08:53:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next V2 01/15] net/mlx5: Lag, Control MultiPort E-Switch
 single FDB mode
Message-ID: <Y+yPksh2RMHDP6D+@nanopsycho>
References: <20230214221239.159033-1-saeed@kernel.org>
 <20230214221239.159033-2-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214221239.159033-2-saeed@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 14, 2023 at 11:12:25PM CET, saeed@kernel.org wrote:
>From: Roi Dayan <roid@nvidia.com>
>
>MultiPort E-Switch builds on newer hardware's capabilities and introduces
>a mode where a single E-Switch is used and all the vports and physical
>ports on the NIC are connected to it.
>
>The new mode will allow in the future a decrease in the memory used by the
>driver and advanced features that aren't possible today.
>
>This represents a big change in the current E-Switch implantation in mlx5.
>Currently, by default, each E-Switch manager manages its E-Switch.
>Steering rules in each E-Switch can only forward traffic to the native
>physical port associated with that E-Switch. While there are ways to target
>non-native physical ports, for example using a bond or via special TC
>rules. None of the ways allows a user to configure the driver
>to operate by default in such a mode nor can the driver decide
>to move to this mode by default as it's user configuration-driven right now.
>
>While MultiPort E-Switch single FDB mode is the preferred mode, older
>generations of ConnectX hardware couldn't support this mode so it was never
>implemented. Now that there is capable hardware present, start the
>transition to having this mode by default.
>
>Introduce a devlink parameter to control MultiPort E-Switch single FDB mode.
>This will allow users to select this mode on their system right now
>and in the future will allow the driver to move to this mode by default.
>
>Example:
>    $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
>                  cmode runtime
>
>Signed-off-by: Roi Dayan <roid@nvidia.com>
>Reviewed-by: Maor Dickman <maord@nvidia.com>
>Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
