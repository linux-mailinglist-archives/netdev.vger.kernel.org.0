Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7926C5F3E29
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 10:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJDIWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 04:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJDIWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 04:22:15 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7D51B792
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 01:22:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id bh13so12112178pgb.4
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 01:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=NkqVW79qk0SY621WMzEcJClgD2DOExzh/f1d2nMDHrw=;
        b=n5VJm3s1VJ0qdXKzKm017msvWnJUTMESqo3NJln4lX2iNxaHnrcla1vve8X3fRjWLc
         52oh44G4vj+/ZBNFiijdrq3IUon+D7I1cMH6OnKiScU/CyiJ9v3Gy0HIaTPp076FbXPO
         IWo92tqEZR1yyY+yUDfM4Q4h8ew6EzDUMj95hcdVyxejmy82Ymuurj9WdvbMdbcq93eZ
         M7xK5mMwFz/0AWnZJ24WK5DI1wMpG/qwu2CxgiqABcG1MHDhVhon6/C1bjt/h84Pw3kF
         qilcRWRLZf3DGYLau+7I7I0rfXd2UhtFAMj9jw2b62VkJ5JMIyWrh2atJOplROL6ts18
         5gEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NkqVW79qk0SY621WMzEcJClgD2DOExzh/f1d2nMDHrw=;
        b=dAgPZZP9BXspm0pzzhWASu8tdE5fpG/moS4YP0gGTMo2BdZ8NiFo946vNF2avRpWca
         G0p4uDM7OAggslNKx/Db5V7iraLu/dEFgdu7NpClcpXxy/0X0oWWgCjXl0hxKwi2XLr8
         qPSRB7zvndAdcxh+/YPe+kC117bu/8GA54WXP+OpZ8KvIacTP3Rwr2K/5bj7pwnxHH1r
         ohV1SoFRxmZ+eN8EWm00gzqoTTunox/oOBd0pJP7HFldqHwnaKyIfuKb3JXHfnVAwjHP
         DuN2yXupcrY6PSsPsj1r0JABJXZjl1mn5TFO/dkCZhWN8+JTzxfO1dUzsUI6Ru3tVNfV
         u7zg==
X-Gm-Message-State: ACrzQf0WWT4Ru8pt7opAU582qRbiva3ZQz/bB1XHZS8DCftdbYXTk20j
        2HRGL8xV1kgeBYdPJhddL/U=
X-Google-Smtp-Source: AMsMyM5Fvpn6ZbQyEXrhFTec0cnAMpxfojX1mSYo1y8qbR81Oxy/0BGtr6Is9DzH9o7yiwKQyld3Rg==
X-Received: by 2002:a63:dc54:0:b0:44c:ce26:fa35 with SMTP id f20-20020a63dc54000000b0044cce26fa35mr9858881pgj.374.1664871734326;
        Tue, 04 Oct 2022 01:22:14 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h190-20020a6253c7000000b0053e93aa8fb9sm8728710pfb.71.2022.10.04.01.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 01:22:13 -0700 (PDT)
Date:   Tue, 4 Oct 2022 16:22:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCHv5 net-next 1/4] rtnetlink: add new helper
 rtnl_configure_link_notify()
Message-ID: <YzvtL76biCs2gZVp@Laptop-X1>
References: <20220930094506.712538-1-liuhangbin@gmail.com>
 <20220930094506.712538-2-liuhangbin@gmail.com>
 <ede1abd0-970a-dec8-4dee-290d4a43200f@6wind.com>
 <20220930160150.GD10057@localhost.localdomain>
 <275e78cc-5728-8551-ec70-8cb7c1a38b45@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <275e78cc-5728-8551-ec70-8cb7c1a38b45@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 11:40:21PM +0200, Nicolas Dichtel wrote:
> Le 30/09/2022 à 18:01, Guillaume Nault a écrit :
> > On Fri, Sep 30, 2022 at 04:22:19PM +0200, Nicolas Dichtel wrote:
> >> Le 30/09/2022 à 11:45, Hangbin Liu a écrit :
> >>> -int rtnl_configure_link(struct net_device *dev, const struct ifinfomsg *ifm)
> >>> +static int rtnl_configure_link_notify(struct net_device *dev, const struct ifinfomsg *ifm,
> >>> +				      struct nlmsghdr *nlh, u32 pid)
> >> But not here. Following patches also use this order instead of the previous one.
> >> For consistency, it could be good to keep the same order everywhere.
> > 
> > Yes, since a v6 will be necessary anyway, let's be consistent about the
> > order of parameters. That helps reading the code.
> > 
> > While there, I'd prefer to use 'portid' instead of 'pid'. I know
> > rtnetlink.c uses both, but 'portid' is more explicit and is what
> > af_netlink.c generally uses.
> > 
> +1
> 
> pid is historical but too confusing.

Thanks for all the comments. I will post the new patch when net-next
re-open.

Hangbin
