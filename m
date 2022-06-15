Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE3154C183
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345915AbiFOGEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345994AbiFOGEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:04:22 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4ED1A831
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 23:04:20 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id z14so6335545pgh.0
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 23:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/emfbk6xXeKgXC7BUbqwIopU/GwAfQPHMEJKU1j6FgY=;
        b=SbP/pVku71QCpxPRWTr0Ulw9sAQ0vVJULxgh/ODxAgqNuZxRJtS+lpXW0gFhsWhvth
         KAc1dnMdIerCeroxA9A4PfonWdxqW38tdAzw6wyW5an9T2uNownvFOG4JkZ7Oo4R/Xn3
         R/nAXH6q88GgV60ksq9n1NBTcO/l8ayPan8x/VgPSbVXF6m0yjQXWt4gsyLVuxIt+9os
         Fjt19GsyddcIgKzMurr+WZQyk042utwpWH+Am4R6PYT9QSURvDcFOz/ILsWEZ4U0baGD
         j/3QAQqBgmiaEt9g25uhrJjOtuFmWn5nEBnjGDgmZqtnwFIkClOsc5v3g5wCFfoQ0NFt
         LThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/emfbk6xXeKgXC7BUbqwIopU/GwAfQPHMEJKU1j6FgY=;
        b=YIUZnwo6/yC1ekOlhsXLoX5pR7BRbr4RtY9aUuyUUcZahbIgpLXp3VQDTcsKBiAiBc
         EAws7xucheuLyEIVVPLPViKjwOQjOb32K2zTR/0YhKSMEbNmWfah5ZHOsVbMWvmzAKi9
         G1IUzC8OFdzJPRz6QuLGQtI95XIivDS1MTDsXrb6jn39y00FpCpKrDnRnVRK1Qt63hfP
         8KcUCCxXhCr5GNRsvGJSqmVR5BUynBulhcrxV2PZM2lCKbWwCZgYwkct6FkTNNtXfDil
         XtKvjD6rQAqfF3kc9GbaYiJuKFdVxUaZ+45kF2L0qDOFxBzZS2nTopn/CYB5Q5b4MQTz
         Grnw==
X-Gm-Message-State: AOAM532m90eXF+PSuGyg6NcVGAdWu/1B8Wqa2trCYq0GuvF7d9u4Y1J3
        lEgry6m82SlCT682Jm963O+ah0rQLHw=
X-Google-Smtp-Source: ABdhPJy+p430w3qZ4dxogWkb5FEiW29pY3cVVlthrQvqDNpwTHpJIK5rCtcnTzv9PfU5ggI/GZ4+TQ==
X-Received: by 2002:a05:6a00:170b:b0:51b:d1fd:5335 with SMTP id h11-20020a056a00170b00b0051bd1fd5335mr8139267pfc.28.1655273060055;
        Tue, 14 Jun 2022 23:04:20 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x8-20020a637c08000000b003fe2062e49esm9017310pgc.73.2022.06.14.23.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 23:04:19 -0700 (PDT)
Date:   Wed, 15 Jun 2022 14:04:13 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add per-port priority for failover
 re-selection
Message-ID: <Yql2XVNxJ0VyLoCK@Laptop-X1>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
 <20220614205258.500bade8@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614205258.500bade8@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 08:52:58PM -0700, Stephen Hemminger wrote:
> On Wed, 15 Jun 2022 11:29:34 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
> > index 5a6f44455b95..41b3244747fa 100644
> > --- a/drivers/net/bonding/bond_netlink.c
> > +++ b/drivers/net/bonding/bond_netlink.c
> > @@ -27,6 +27,7 @@ static size_t bond_get_slave_size(const struct net_device *bond_dev,
> >  		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_AGGREGATOR_ID */
> >  		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE */
> >  		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE */
> > +		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
> >  		0;
> >  }
> 
> Why the choice to make it signed? It would be clearer as unsigned value.

Let's say you have a bond with 10 slaves. You want to make 1 slave with
lowest priority. With singed value, you can just set it to -10 while other
slaves keep using the default value 0.

> Also, using full 32 bits seems like overkill.

Yes, it seems too much for just priority. This is to compatible with team
prio option[1].

[1] https://github.com/jpirko/libteam/blob/master/man/teamd.conf.5#L138

Thanks
Hangbin
