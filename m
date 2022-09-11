Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918365B4AF5
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 02:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiIKANy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 20:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIKANx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 20:13:53 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DEA2E694;
        Sat, 10 Sep 2022 17:13:52 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z21so7886441edi.1;
        Sat, 10 Sep 2022 17:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=bppXW6VDR+pb+O0s/GBMgHjeo0dyk4Z19CwR9nRdUqY=;
        b=I/dbdccpmFyof6NN2fUQMmS80Kye7WCB0cQOnWsCWr6kbYBSqsVNXYvpajN4WTXs5N
         PXhbKdVGq8qaZvgMB0u24QvcgieMU5sZBUZfzJF2amKkSCjUsiAOitoc/N3eYjx4+nbU
         UkvrRIvjsJnsPK6sjy/HtdP6xSLhmtUOAOXnyRclsyX3fiW0yb7AKTCDLDXVMQdlnFWk
         mil8xpZZTzvqkglqCqTqsMJxVx8FC4xg6utVXrjwvfOZdCzMwfSKP+sa1fb1IAQfgDPQ
         pESQws6EXy9LgJ4AVvyxftq7I/HfsvAzi5cWrDfXOlqoYDBtxh9cVpuCsIrL0Hca4ds+
         PlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=bppXW6VDR+pb+O0s/GBMgHjeo0dyk4Z19CwR9nRdUqY=;
        b=6i5RrHr4AIjiu4minWhu7eZ3nuHOj7o92JMK4qN0UHDPI3qEhDpsuZmmvOC10eq96p
         CDxef1LzefhJQeCAmB+MPtgJW3oYtVZhM+Ql02YwQLJObKFwreCz27ofFuYKrOCIXSa+
         mZxnuYpCqDoFcmzylb+M9BO69FYizlAgzTDK0Qlif+X0snQQNJFD8z/4bPz2dhtZVxmq
         YO0ljaIEYU35jF+desU79zF/PKg7miDpU8SlfSSLnB0wPfevHlx4/id0wMzU1EE2qEUe
         xjWLdPDfneSXNEK2ILQkNawYHHBMrKzeCfhH7AuJLtHXswTgS/uNrnj6/lZTxmvWbEzi
         V0yA==
X-Gm-Message-State: ACgBeo30soNkELZdwX8mfJ8aAYH+NLM4S0JjGspeaDm2n4Q1YVWOW20p
        J26aeEtDTIXhsdq9WpbAPys=
X-Google-Smtp-Source: AA6agR52fycHpO9WU3O4tQqWIpSfhUKG2OMNd9yKS0R5NgefgysDjUnyzSr5YsGH9u2uheidlYIZ6Q==
X-Received: by 2002:a05:6402:110d:b0:451:9fc5:fe7f with SMTP id u13-20020a056402110d00b004519fc5fe7fmr346191edv.200.1662855231160;
        Sat, 10 Sep 2022 17:13:51 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id c18-20020a17090618b200b00773f3ccd989sm2265945ejf.68.2022.09.10.17.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 17:13:50 -0700 (PDT)
Date:   Sun, 11 Sep 2022 03:13:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 net-next 6/6] selftests: forwarding: add test of
 MAC-Auth Bypass to locked port tests
Message-ID: <20220911001346.qno33l47i6nvgiwy@skbuf>
References: <YwzPJ2oCYJQHOsXD@shredder>
 <69db7606896c77924c11a6c175c4b1a6@kapio-technology.com>
 <YwzjPcQjfLPk3q/k@shredder>
 <f1a17512266ac8b61444e7f0e568aca7@kapio-technology.com>
 <YxNo/0+/Sbg9svid@shredder>
 <5cee059b65f6f7671e099150f9da79c1@kapio-technology.com>
 <Yxmgs7Du62V1zyjK@shredder>
 <8dfc9b525f084fa5ad55019f4418a35e@kapio-technology.com>
 <20220908112044.czjh3xkzb4r27ohq@skbuf>
 <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152c0ceadefbd742331c340bec2f50c0@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 09, 2022 at 03:11:56PM +0200, netdev@kapio-technology.com wrote:
> > > > On Wed, Sep 07, 2022 at 11:10:07PM +0200, netdev@kapio-technology.com wrote:
> > > > > I am at the blackhole driver implementation now, as I suppose that the
> > > > > iproute2 command should work with the mv88e6xxx driver when adding blackhole
> > > > > entries (with a added selftest)?
> > > > > I decided to add the blackhole feature as new ops for drivers with functions
> > > > > blackhole_fdb_add() and blackhole_fdb_del(). Do you agree with that approach?
> > > >
> > > > I assume you are talking about extending 'dsa_switch_ops'?
> > > 
> > > Yes, that is the idea.
> > > 
> > > > If so, it's up to the DSA maintainers to decide.
> > 
> > What will be the usefulness of adding a blackhole FDB entry from user
> > space?
> 
> With the software bridge it could be used to signal a untrusted host in
> connection with a locked port entry attempt. I don't see so much use other
> that test purposes with the driver though.

Not a huge selling point, to be honest. Can't the blackhole flag remain
settable only in the device -> bridge direction, with user space just
reading it?
