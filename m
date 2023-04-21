Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9216EA26A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 05:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjDUDmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 23:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDUDmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 23:42:08 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C3830FF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 20:42:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-51efefe7814so1754308a12.3
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 20:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682048527; x=1684640527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n/sRJAtEd/uD1OOqv9s/og+8s+YNsRdKo/znPIbylR0=;
        b=rIUoEBc8XndLuA2ByBWs6ucycfZ9AyZ38X8Z5+iSAquwKaGfXYgA0IQQTjc+c7ZnFJ
         qm71Dw96maqElUswhvdvCjh/kiFl3Av4RR/gJor8N7QnhgY2RCjwX3ORaAtugDFObD7B
         YyP9EW7D3ehJUz34pUyCDQt/56b5fQNWz3pXue0LMz1THkUFoNwCie9T28E56gOiZziB
         AfIwx0ADJxptUUhNqqLAk9G6by4+wGrPM21nldAgWJyFaEx11O/VGx2lXaKJ4EnvLNWM
         aqrfmD6Xqnfj4DJv5AbL6i4aCn59QfQVLdavzhEmgYuB5tABcfHCFxeVWK76lIlOq8UA
         +EKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682048527; x=1684640527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n/sRJAtEd/uD1OOqv9s/og+8s+YNsRdKo/znPIbylR0=;
        b=OZutI10Dk6dVd9sRSkNdDSShl6uMtv6xTws/7+9vNKaFHLYF5yyuMOyW7+SDia4PFP
         BeKDe9AhEd1gaWYW7JZblAROdJBOWdlzE+c41QbKC4IAs5rH1AQyDyCjwezVen91FLy1
         BnZ5BbjWTyCTWOd0QIMIaDsC5RzVOj651tIT0+IsyUil3xmpP98Sn8iide2JdVSVaUC/
         ZsCo46voGQq1+DZzLbn15J8Ajfsk9kDbvpqGkQcjxahBxSchLQsm274Zj9DYongF8yIH
         A3ElhY5T+Gxw6AsobytshwcaOlzJ1kaCBBfTnzEUp4PgYq9RtpPrZWyTxJfQk5p4bjtC
         Kb/g==
X-Gm-Message-State: AAQBX9cD3Ahiw1KNubU5hHfIfgQPGMeGyijSh04LvjJ9RuZ+Bxqpn1jx
        bfnScXQ/TWFBk91xqasNiJs=
X-Google-Smtp-Source: AKy350a2fOKURicCVwpAoIzbsgabuKHf58wyDxP3sEYVCAwk5j7ErM/0SJZgl5bUzW1LxfDGKYLaEA==
X-Received: by 2002:a17:902:ec8c:b0:1a6:9f9b:1327 with SMTP id x12-20020a170902ec8c00b001a69f9b1327mr4605882plg.45.1682048527109;
        Thu, 20 Apr 2023 20:42:07 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iy1-20020a170903130100b001a65258011bsm1795671plb.26.2023.04.20.20.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 20:42:06 -0700 (PDT)
Date:   Fri, 21 Apr 2023 11:42:01 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        oe-kbuild-all@lists.linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCH net 1/4] bonding: fix send_peer_notif overflow
Message-ID: <ZEIGCaLWKIY3lDBo@Laptop-X1>
References: <20230420082230.2968883-2-liuhangbin@gmail.com>
 <202304202222.eUq4Xfv8-lkp@intel.com>
 <27709.1682006380@famine>
 <20230420162139.3926e85c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420162139.3926e85c@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 04:21:39PM -0700, Jakub Kicinski wrote:
> On Thu, 20 Apr 2023 08:59:40 -0700 Jay Vosburgh wrote:
> > >All errors (new ones prefixed by >>, old ones prefixed by <<):
> > >  
> > >>> ERROR: modpost: "__umoddi3" [drivers/net/bonding/bonding.ko] undefined!  
> > 
> > 	I assume this is related to send_peer_notif now being u64 in the
> > modulus at:
> > 
> > static bool bond_should_notify_peers(struct bonding *bond)
> > {
> > [...]
> >         if (!slave || !bond->send_peer_notif ||
> >             bond->send_peer_notif %
> >             max(1, bond->params.peer_notif_delay) != 0 ||
> > 
> > 	but I'm unsure if this is a real coding error, or some issue
> > with the parisc arch specifically?
> 
> Coding error, I think. 
> An appropriate helper from linux/math64.h should be used.

It looks define send_peer_notif to u64 is a bit too large, which introduce
complex conversion for 32bit arch.

For the remainder operation,
bond->send_peer_notif % max(1, bond->params.peer_notif_delay). u32 % u32 look OK.

But for multiplication operation,
bond->send_peer_notif = bond->params.num_peer_notif * max(1, bond->params.peer_notif_delay);
It's u8 * u32. How about let's limit the peer_notif_delay to less than max(u32 / u8),
then we can just use u32 for send_peer_notif. Is there any realistic meaning
to set peer_notif_delay to max(u32)? I don't think so.

Jay, what do you think?

Thanks
Hangbin
