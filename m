Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31DB4FC0DD
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348027AbiDKPgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348012AbiDKPge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:36:34 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7CE13DDF
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:34:18 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id g18so6737404ejc.10
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 08:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+iPA1sYr6xRtXgWJso/vieljuHVBzmEfWgtT8rn06kM=;
        b=tK+ZCp7C1FZZIQ3upJvS0ntSBmHbgwb4BzTcDQ14gApAI7xno5OUUt6jlGenHTCGLN
         gQEFdIxkNCiW4bx4INm59HEzfU+XNVvw64TfBWDLgMhcDk16FPyOdvSwZ7V4esdWCtQd
         /30Spp2+jzl6rwUXL4fkaX3lBZbGGYZ8dJxFmNmy/lSpLoMVBsd0corkFH+bDQ90gMu/
         h2E8Rt/lP55mb2p5cJJjBUc8RistsXvvinIk9EMWRkqN1RX4+NQ9L3CNkUhvRNI6iU3n
         HmUFtnXqzBmQpNvQc8pBqHTHSCBS8eEa27G4lYJj7+Rjn1bwNn35i8QTaDi8p5+vNnCB
         FpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+iPA1sYr6xRtXgWJso/vieljuHVBzmEfWgtT8rn06kM=;
        b=fyzmUShlZA/JDJCQ0Nea8JyUO7kgRz1ja2iNUb+8UDdM+3Xqd8Z1NWNtTZVwmhCPX/
         jXEYwkV+mHTh1v/k097i49pgHaJcdQbxHUEwv3pM8AmONSkhTnB9P86QZM/l2JbKxQB2
         /TYQacNS3i2Ns5HMtzEsbMISJAml9pzIWrsTdMoGBdzfY1PrCNwPcldeyu9tPXtfameJ
         q9Cso5Ooqx7dBL8Qfx5NPkWTJ2dbMvOhRzGyqvO3uKkj6YxjLuJFvnpzQJgPB+eLC8cv
         1pIEqEERFsoHPBYoMHoaIK516shcayvlZD5179xQIYUSsW58zZ31cmzrz9Wd8M3vRn2g
         RI3g==
X-Gm-Message-State: AOAM531K7rs0id6xDuKe3FxXsmqyu0eME6FYP1dzwm6za2ang3OqRp6l
        S0RtxPPCIKXfZpeF59UbDF+Uuw==
X-Google-Smtp-Source: ABdhPJwxSjoDVoAsJWN7sz/PGzxUab+yWdrwncprbD2EHwmVDEQvskcaLPR1EpJ4raO3M7UCY/r9PQ==
X-Received: by 2002:a17:907:7b8b:b0:6e8:9dd9:59ac with SMTP id ne11-20020a1709077b8b00b006e89dd959acmr2470222ejc.588.1649691256260;
        Mon, 11 Apr 2022 08:34:16 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ka6-20020a170907990600b006ce54c95e3csm12052016ejc.161.2022.04.11.08.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 08:34:14 -0700 (PDT)
Date:   Mon, 11 Apr 2022 17:34:13 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next 5/5] Consider the number of vlan tags for vlan
 filters
Message-ID: <YlRKdX+uxdjuPslp@nanopsycho>
References: <20220411133100.18126-1-boris.sukholitko@broadcom.com>
 <20220411133100.18126-6-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220411133100.18126-6-boris.sukholitko@broadcom.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 11, 2022 at 03:31:00PM CEST, boris.sukholitko@broadcom.com wrote:
>Currently the existence of vlan filters is conditional on the vlan
>protocol being matched in the tc rule. I.e. the following rule:
>
>tc filter add dev eth1 ingress flower vlan_prio 5
>
>is illegal because we lack protocol 802.1q in the rule.
>
>Having the num_of_vlans filter configured removes this restriction. The
>following rule becomes ok:
>
>tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
>
>because we know that the packet is single tagged.

From this patch description, I'm unable to tell what the patch is doing.
Tell the codebase what to do.

Also, in subject line of the patches, it is customary to put prefix
like: "net/sched: cls_flower:"

The the first glance, the patchset looks fine to me.
