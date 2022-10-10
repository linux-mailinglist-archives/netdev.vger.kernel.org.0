Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0845F9E08
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiJJLy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiJJLyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:54:12 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6BD71BCB;
        Mon, 10 Oct 2022 04:53:58 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ot12so24387844ejb.1;
        Mon, 10 Oct 2022 04:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r8MQPm1VfyR8WR3YDKpuy0rJ4sH/UdP+G9t2xvIlExE=;
        b=B8XNUCS398qRKnyuP7lY3magbVPGqQS07zishCxCW532zytekRB9zlpJXOIpsGcb7q
         +Yp1VrQwFI+QvAAqm1rNsFbqZyFCyw4e4GVLXRTz2aNUkIqyU3+5JY4YvntdWU8dsbfh
         JII4Ombw0QwY6pMTk/cZ8E6VjCo4I4MowHD7YXa1LGFvcomxNE9/iUa1IN+PWquV2FHh
         xvb0Ks8UMqE+jiJN30viSGg4kjMpTSu40Moa/E+Py0OJcHQwXYb9bdXmRUebtVsASFN1
         SojX53ZPznZeD0GAVPP52CjfLouowHucLnB8pLc7nU66Avy/CScftEI5EmEtPsHgkF0F
         jpwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8MQPm1VfyR8WR3YDKpuy0rJ4sH/UdP+G9t2xvIlExE=;
        b=6upctFKbC2aX3UfspGDYYEyzx7d6/pcFRr1DmOKeAGUjjt3uH5XK5humfZCYueuc1U
         lOOMHXZHaIecMRV30XTcsJlG2tce/ZciGlx5/I00IZ9a4wOApWXbrq8ibDoVJ5K4nxfS
         O6/ZQBudqXPDlqR9HrFvnmxZCvU0Ngtv3r5RHLJm2Mkv9C5oJ/FP+JI2kZ+P9jNWda/T
         t5in+6JkN1cd/s/8M7LSmXeH/0J3Mcl9vyHwXzhCvvdMZYGUOIA1koziO6JXQs+KeZEu
         yd3SUGLs99zYdaGF10HZFL1+ycX3n7Kvx73DD19K5oWiV2iB4WnmH7W5rNLOGiSoe3Ha
         1jPg==
X-Gm-Message-State: ACrzQf33uHnF+7Ndxm2N1Qhb0q76A1EknER1fpA/BvM8ZjBytmOvsv5f
        qaIqhz5bSb6ddQjhIERGRTC2u1LA4H0=
X-Google-Smtp-Source: AMsMyM6xZGhjDBIsN0LBBIGEUQQGakL3/52H0DngiOquCY+AmQ7Ti629+a32bOQa4gp3GdB7nkbXhg==
X-Received: by 2002:a17:907:2cf1:b0:78d:cafc:caba with SMTP id hz17-20020a1709072cf100b0078dcafccabamr1455430ejc.154.1665402835990;
        Mon, 10 Oct 2022 04:53:55 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id ti5-20020a170907c20500b0073d9630cbafsm5223140ejc.126.2022.10.10.04.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:53:54 -0700 (PDT)
Date:   Mon, 10 Oct 2022 14:53:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 10/73] net: dsa: all DSA masters must be
 down when changing the tagging protocol
Message-ID: <20221010115352.dhei6vmdtlhod2bh@skbuf>
References: <20221009221453.1216158-1-sashal@kernel.org>
 <20221009221453.1216158-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009221453.1216158-10-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:13:48PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [ Upstream commit f41ec1fd1c20e2a4e60a4ab8490b3e63423c0a8a ]
> 
> The fact that the tagging protocol is set and queried from the
> /sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
> the single CPU port days which isn't aging very well now that DSA can
> have more than a single CPU port. This is because the tagging protocol
> is a switch property, yet in the presence of multiple CPU ports it can
> be queried and set from multiple sysfs files, all of which are handled
> by the same implementation.
> 
> The current logic ensures that the net device whose sysfs file we're
> changing the tagging protocol through must be down. That net device is
> the DSA master, and this is fine for single DSA master / CPU port setups.
> 
> But exactly because the tagging protocol is per switch [ tree, in fact ]
> and not per DSA master, this isn't fine any longer with multiple CPU
> ports, and we must iterate through the tree and find all DSA masters,
> and make sure that all of them are down.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.
