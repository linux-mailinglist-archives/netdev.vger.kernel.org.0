Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EECEF59895B
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345056AbiHRQv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345012AbiHRQvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:51:25 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F094DE0AE;
        Thu, 18 Aug 2022 09:51:23 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id fy5so4341672ejc.3;
        Thu, 18 Aug 2022 09:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=RncwsDAl9D9YrGT5yUZLBhI7CeCArAJv9CfHaqtop+w=;
        b=I7B1lEpDZoEUNKIRXhWCHXz47RM5OfX5Vu+g5brJthx82bxdV6TSVg2R0P+YY0Lnu1
         KFS905yausRwdQ+nl9Qh0+hB7Gij1yt2NQjWTVjue6rC7+hsgze1QrSr9L3K7uz9RIFN
         YdkspZmmThvEZI9WbMKdcsZX5SLxbK4ZU1scawZap2+sC44avpiP1TTX8yan+1wU8Kt6
         ztvNuJxebaORfZjlr1lfcbZOhTxBna76XEyU/OUmc8d2LCegYjFY0JP4GSuddDQyN9uq
         asz9HgOYTuTZvUSD1gOA0EuC0CKT4ZrhdrsXw7tHUMKapQ0m5NZh+DpULQcGu2/Lo7nc
         /RIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=RncwsDAl9D9YrGT5yUZLBhI7CeCArAJv9CfHaqtop+w=;
        b=JNj465BhSAWPcfDLaz/PdjnCsqY+czqKp8vMLHTaBXHqJZE/1pe3pSboBsAZmXHgHH
         3MKlfSsf1hTe4AB7tNwLTX+VmpCGX8qjS73zBDktTwZFGgLNfPzHQVwL03ds4M4a+t+H
         HUkeev89woIbe69sIPdNf5quuGCHCemfD7v9PfJaYlxJw0t2X456OLGeucl/MWtjoyfW
         sdmFX+smBuIhRUSEMgFPtQ2H8nTazhZ/HYqmNvuFtuX0m6lnd7/sKBnuXp03nFppw2R5
         ZhGcHRx5l29ZTR+qNg/DiuIfT6Os2ypR288phN3YndK7I1LuZc/CKxrCsevedphjc/U4
         2hkg==
X-Gm-Message-State: ACgBeo2I2izTw/hbgXB52r0Dv4MCeHYacFjeLvIsl/AnXByJevwBqRxW
        DLD6jX5jNegATik9EHQ22Bg=
X-Google-Smtp-Source: AA6agR5Hwxc4dbJo1jshhS+saNZAKTuKJs+Jl8/ezr7al5ARjpXSYJW+qel9q7bjWcn4kraAf0RL6Q==
X-Received: by 2002:a17:907:3da6:b0:739:282d:987f with SMTP id he38-20020a1709073da600b00739282d987fmr2471037ejc.222.1660841482357;
        Thu, 18 Aug 2022 09:51:22 -0700 (PDT)
Received: from skbuf ([188.25.231.137])
        by smtp.gmail.com with ESMTPSA id v17-20020aa7dbd1000000b0043cc66d7accsm1445985edt.36.2022.08.18.09.51.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:51:21 -0700 (PDT)
Date:   Thu, 18 Aug 2022 19:51:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next] net: dsa: qca8k: convert to regmap
 read/write API
Message-ID: <20220818165119.c5cgk5og7jhmzpo6@skbuf>
References: <20220806192253.7567-1-ansuelsmth@gmail.com>
 <20220806192253.7567-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806192253.7567-1-ansuelsmth@gmail.com>
 <20220806192253.7567-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 06, 2022 at 09:22:53PM +0200, Christian Marangi wrote:
> Convert qca8k to regmap read/write bulk API. The mgmt eth can write up
> to 16 bytes of data at times. Currently we use a custom function to do
> it but regmap now supports declaration of read/write bulk even without a
> bus.
> 
> Drop the custom function and rework the regmap function to this new
> implementation.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Nothing in this change jumps out as wrong to me, but maybe you should
copy Mark Brown too when you submit it proper, as the first user of the
bulk regmap read/write over Ethernet, IIUC.
