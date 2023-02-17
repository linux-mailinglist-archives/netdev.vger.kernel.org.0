Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C280E69B152
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjBQQs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjBQQsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:48:55 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ADC47432;
        Fri, 17 Feb 2023 08:48:54 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u2so1146783wrs.0;
        Fri, 17 Feb 2023 08:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CnTobjfJ9ngXJcsvpPg7My3HLghl3TXCWSpFjr9HubU=;
        b=VXheOQKWN2RjWb0nI9tMGc+Cfw0mtSZfYK2MvuqPqgoHgmi88jV3hrSwsydygBGuJa
         C4xbPPyPJKyebnfy8L4cD3h4PGETNxg3sFFLLJuJWkqrEpnf4uT5YP5Cyypnr7Y0OF37
         djdobhwJx1IjvvWmQGNn8ZGNO7XNPpKnoCYHIOBmHJfgCJcmOhkwyco1vyraGAX3FuY4
         Du/bc4LlqTGEZlBX/ZczFISeuJuGt7ujFGFZm0IFkmmO+M2gpc35ucnaq0DbO29qhXq8
         XEd/Ap0ZRfIYJ8+afxEF5F53DJwPB1T4R67ICwKBsf7zVdYQ8BUt39ZHFVEsUJMEI2Nb
         5B6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnTobjfJ9ngXJcsvpPg7My3HLghl3TXCWSpFjr9HubU=;
        b=BEBW5FGoCxsKggQj053s+oI4rXjQz/8du/UF6Dgn3ECTJP1WWi7+mBEjmX1Z7ihlKx
         qhWqi6sYRWXM4yksCgrZKY84ut/Wqn6p+O9Afbb3h8lYQTRU+obX8a+q22l+IWT6AGWJ
         krMfC6/Mvt+OwPUJEabSDvGxTC/WgngT/NqG9B+KiV+RBpQdiFBUfeI69J2MHvNhEiM8
         UMhnQkqmzHKdKvdg9fq06lRsRHw/GKcOe+yWrNcXsL4W0epFMLal6Tr+oupx+FfKjRoS
         BKlIujJFFaiFYuoRcUUOWTUtLNslEGxexfG/fu6gt443EFb/h0g99TKxd8/xXfcaujtL
         h+fw==
X-Gm-Message-State: AO0yUKXwaWKDdEi4zAwpMeo0rXnPAWOQ5D2WFA2amhgj0peCDyMJNBsB
        YKm+rje61B29zLKROI9787Q=
X-Google-Smtp-Source: AK7set+h7/QTZ74TQrxH9VXmo+Z3s61a6s5kTq6X3ugp25wMKac6v1kzpNViA5W1Nm3b6JeY67uWHA==
X-Received: by 2002:adf:eb43:0:b0:2c5:76bd:c0f3 with SMTP id u3-20020adfeb43000000b002c576bdc0f3mr6154679wrn.6.1676652532631;
        Fri, 17 Feb 2023 08:48:52 -0800 (PST)
Received: from skbuf ([188.25.231.176])
        by smtp.gmail.com with ESMTPSA id o9-20020a056000010900b002c54241b4fesm4617497wrx.80.2023.02.17.08.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 08:48:52 -0800 (PST)
Date:   Fri, 17 Feb 2023 18:48:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 0/5] add ethtool categorized statistics
Message-ID: <20230217164850.3jps62p2sfomee4r@skbuf>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <a0898de5-5990-4198-cda2-fe22679aec90@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0898de5-5990-4198-cda2-fe22679aec90@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 03:54:48PM +0100, Alexander Lobakin wrote:
> From: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
> Date: Fri, 17 Feb 2023 16:32:06 +0530
> 
> > [PATCH v2 net-next 0/5] add ethtool categorized statistics
> 
> I'd like to see the cover letter's subject prefixed as well, e.g.
> 
> [PATCH v2 net-next 0/5] net: dsa: microchip: add ethtool categorized
> statistics
> 
> ...or so, depending on the usual prefix for ksz.
> Otherwise, it looks like you're adding something generic and only
> realize it targets a particular driver only after opening the thread itself.

+1

some people just look at the KSZ DSA driver all day, and so in their mind, it
then becomes implicit in the subject. But the cover letter description gets
turned by the netdev maintainers into a branch name for a merge commit, see:

fa15072b650a Merge branch 'sfc-devlink-support-for-ef100'
e9ab2559e2c5 Merge branch 'net-sched-transition-actions-to-pcpu-stats-and-rcu'
10d13421a6ae Merge branch 'net-core-commmon-prints-for-promisc'
a1d83abc8f2f Merge branch 'net-sched-retire-some-tc-qdiscs-and-classifiers'

and so, the naming of the cover letter has non-zero importance.

I agree that the contents of this patch set is absolutely disappointing
for someone reading the title and expecting some new ethtool counters.
