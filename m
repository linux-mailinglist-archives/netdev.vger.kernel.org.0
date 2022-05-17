Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D18529BB6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiEQIFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242278AbiEQIFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:05:04 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02EA43AC6
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:05:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i1so16671264plg.7
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x8+fl7ePwuiiUgMo5eXBIBD8OY9rBhYCwDeJff3SYxc=;
        b=iGV83ZxDu0bRrnvIXsECDceF4okSVt4V3VCtLiJNCVUtSGyBtd+XZR5rUI7gje43zE
         6u/6PKOhJF4tI2nBL/rlXvH9kzF3sXpGAEgdR6BkovLTkxsWSP7oeJKKdqH0i7ktz9Nx
         iVz9q8S1BsgUjaTP4d02/URXenXuJSHKylzgomPZSzV5BI1BqY0korELHinLgV7u7tLd
         kPv0gapSlEiAGOIZ5OmEL9MCwqPwvPHcssZQFR+kEwLne8296H9B5n7tHG5SFZIaIpg2
         9ZuPRZJrwrBmGibQU0hEWGVDZQEDDZHx7W5t1oHtCdUr1LSVYuVKPkt2e8QHmYoJ4YRV
         WE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x8+fl7ePwuiiUgMo5eXBIBD8OY9rBhYCwDeJff3SYxc=;
        b=RAbdAOzr9x8U1WwvVdMuzB49OXNSF91dWo7lSUb3PU4eDC51sCnxesgStEAdK49R6x
         zxJq77kVphu5zXJJbHeeAY9do9kbXK4MZQu4ApBX9ny4sLDanPTrT28A6tnD2+hxjqtL
         2o47wCmaWx5+dyet31u+jA+mKMUTYzLt97XvvqxBr2u2qvLTt632ouQ11IQhpmeVLLXz
         /WQ6fFhujmCG/DNaxaL8CKY709u8e9vyQS6bujtjja3OJnv2Tf46253tZDrL9rauBwL+
         rwP57K+OxCW49nKzs1zrv1sCnJt0DDoWB1S3NjzNtPwF0KW/qDo5kbArYTG0ZCFnBcWj
         Dlew==
X-Gm-Message-State: AOAM530U77fLLZVkgebFjac0QqI9BjyisUM1vkFP8ncRDOvXDFEhseUT
        rLlIA5L9jB5rspHoTD9NuXQ=
X-Google-Smtp-Source: ABdhPJyhjY+bo5Uxqg6UD1YjdrA1KD1C2qBYUA0DVydwt+1QUzE7YtdEuJKW0BUbZwDXtDnb7IQ0HA==
X-Received: by 2002:a17:902:cac4:b0:161:7729:4a65 with SMTP id y4-20020a170902cac400b0016177294a65mr9289271pld.35.1652774702151;
        Tue, 17 May 2022 01:05:02 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x18-20020a17090abc9200b001cd4989feccsm997983pjr.24.2022.05.17.01.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:05:01 -0700 (PDT)
Date:   Tue, 17 May 2022 16:04:55 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RESEND net] bonding: fix missed rcu protection
Message-ID: <YoNXJ0XGY2csweTj@Laptop-X1>
References: <20220513103350.384771-1-liuhangbin@gmail.com>
 <20220516181028.7dbbf918@kernel.org>
 <YoMZvrPcgIm8k2b6@Laptop-X1>
 <0c47e205ee226bb539ec649c5dc866301c710b9d.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c47e205ee226bb539ec649c5dc866301c710b9d.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:24:00AM +0200, Paolo Abeni wrote:
> On Tue, 2022-05-17 at 11:42 +0800, Hangbin Liu wrote:
> > On Mon, May 16, 2022 at 06:10:28PM -0700, Jakub Kicinski wrote:
> > > Can't ->get_ts_info sleep now? It'd be a little sad to force it 
> > > to be atomic just because of one upper dev trying to be fancy.
> > > Maybe all we need to do is to take a ref on the real_dev?
> > 
> > Do you mean
> > 
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index 38e152548126..b60450211579 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -5591,16 +5591,20 @@ static int bond_ethtool_get_ts_info(struct net_device *bond_dev,
> >  	const struct ethtool_ops *ops;
> >  	struct net_device *real_dev;
> >  	struct phy_device *phydev;
> > +	int ret = 0;
> >  
> 
> You additionally need something alike the following:
> 
> 	rcu_read_lock();

Thanks Paolo, I only thought the real_dev ref and forgot the initial problem
is the rcu warning...

Hangbin
