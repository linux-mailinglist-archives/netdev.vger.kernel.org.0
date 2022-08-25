Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7920F5A1D5C
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiHYXxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiHYXxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:53:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77009C59C2;
        Thu, 25 Aug 2022 16:53:46 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id bj12so140698ejb.13;
        Thu, 25 Aug 2022 16:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=PdaXudCOGj32vCBzYEwKoFsRR206fL59N9F6XcpqUXg=;
        b=M30XLzIGsB2C/iLNsRciX+9IawIJSA5wmdwkD99xptGasxI+N2kPZIjv+uxjmaGL5W
         ut3nFeiNi5fIgwfbYoLVEGRg3lbFrgR/9sAe9s73hEIkl6uNkEGGgwCG1mSB1oHRIrvL
         5xTyav3WgYDuebrxRykIeayUw3S6Jm3V0Hlj1RZ+O7dW0sMt3fX1drSDWlhIfI5dwtnC
         pCf2AT96mAqF5qwViL4uwsq2Zi3gV/yFgzpqwAkqHyBP1lgiD+ZtpraNPIgT1JYwxlhs
         gIRSJXgofN4ej2zioxCt1TGR9bi/wCFw8MQvmyu91hUgz+yK1gkUjsdJwPCCx7UjyPv4
         ReYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=PdaXudCOGj32vCBzYEwKoFsRR206fL59N9F6XcpqUXg=;
        b=alE0yZ2oL6tfCgtiXbml9CagyRACuCp3tNEDv7kOKkhlungMFD/du0Rhd3xd4wG8w4
         /Z79e26SoG+MgZRlAE4HLxA+oM384w6J7rjU1hhxEkLxu98+Q4V2G2ACgLa4t7HGCAEo
         4rhN+zh14ylyLr1UBNo74h+T6nN/4fJXGc1AjiIXbHj+zCy94YWaUIoco1KVL+9Dh7Mu
         QaGuja06TM4Ie+Unbe4VRqiJc2UuRkb74v2fDaXF8EChZLvsBZExgJ66s57muRQBcBGT
         iiWUeyhkHP3ZVmEMiqkegSUc9WcTEdYI0/QehPkZGkfT8WLITuZF05lyf18ket4ktLmJ
         HwuQ==
X-Gm-Message-State: ACgBeo1ajXk6ZkUNCttV2JeBbkGZVu2p7ivSaAop48HJI5ZVvveUS4h/
        vpCgu0NtwtFsyQDD5iuPqYQ=
X-Google-Smtp-Source: AA6agR4QjdYGqhomuECcxo2K8qgXz9LlsdHK9vPGEh7LDu+Css0c9htE5zVkm2aPBBNh2Xygufkeqw==
X-Received: by 2002:a17:907:6d9b:b0:731:1135:dc2d with SMTP id sb27-20020a1709076d9b00b007311135dc2dmr4017180ejc.76.1661471625077;
        Thu, 25 Aug 2022 16:53:45 -0700 (PDT)
Received: from skbuf ([188.27.185.241])
        by smtp.gmail.com with ESMTPSA id n26-20020a056402061a00b004464c3de6dasm419978edv.65.2022.08.25.16.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:53:44 -0700 (PDT)
Date:   Fri, 26 Aug 2022 02:53:42 +0300
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
Message-ID: <20220825235342.ofqedobcb6jg5bxz@skbuf>
References: <20220806192253.7567-1-ansuelsmth@gmail.com>
 <20220806192253.7567-1-ansuelsmth@gmail.com>
 <20220818165119.c5cgk5og7jhmzpo6@skbuf>
 <62ff7b28.170a0220.91820.52c8@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ff7b28.170a0220.91820.52c8@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 01:43:57PM +0200, Christian Marangi wrote:
> On Thu, Aug 18, 2022 at 07:51:19PM +0300, Vladimir Oltean wrote:
> > On Sat, Aug 06, 2022 at 09:22:53PM +0200, Christian Marangi wrote:
> > > Convert qca8k to regmap read/write bulk API. The mgmt eth can write up
> > > to 16 bytes of data at times. Currently we use a custom function to do
> > > it but regmap now supports declaration of read/write bulk even without a
> > > bus.
> > > 
> > > Drop the custom function and rework the regmap function to this new
> > > implementation.
> > > 
> > > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > > ---
> > 
> > Nothing in this change jumps out as wrong to me, but maybe you should
> > copy Mark Brown too when you submit it proper, as the first user of the
> > bulk regmap read/write over Ethernet, IIUC.
> 
> Should I send a v2 without RFC and CC Mark or CC directly here in the
> RFC? This is ready so v2 won't have changes.

v2 without RFC and CC Mark, please.
