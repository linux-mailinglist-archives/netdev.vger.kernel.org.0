Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13AC606289
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJTOLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJTOLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:11:12 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D32B170B77;
        Thu, 20 Oct 2022 07:11:11 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id r17so47672146eja.7;
        Thu, 20 Oct 2022 07:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lmwon3whKue/CVr8WrW952+rwBDr0RPAb1kYusMk964=;
        b=h80IgPyAct7MK5zRLczRsF/1fG3PBVUcnjpRONux/l7QMniZAgQZF7KLJ/b8Xb57nV
         eNAHIneSfPVRYfQcjBU3UbTc8pcRnTz9EZFVSA2Wme8B885eczCZhwaStsn2GzrZ+2Yh
         enoURpRTuzQsVnhi3X9wa5HCqzTl9P29ZaZd/6G3Bqi5N6nREPYEZxVqPLjXeaVZq0Ps
         fqwmyJ29Jjtsc72JKjktuIL9cU5LUimNJgQZFh2PNUR3x6l8gj7g9UKGLd4ZQxSomeBp
         sbCQCd8BswmIENyTJcTrmwGkm6PzlkR13ILiaHEOGbZjT+4lhpa2zKxGvQ6fu5DKQUUB
         em4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmwon3whKue/CVr8WrW952+rwBDr0RPAb1kYusMk964=;
        b=KB991ka1v00FADRhHBeNS+LRvDsWvYR2tjajeBCpXYz1A11W44eIFzsXFs5F4QGcVc
         czXrk+kENlIO0WVTs8mmo1iOwrnePssU0MgaG3c70Ia+hBfWevESFuFpMfpZoKsRBOg7
         4F2tyR2pnss0EzXiPQhFnvHYqC8X7yAkwPLVj5gD44BD2G/SoAsmt3JZj0TNRqw8MNbS
         D7VFZGrPf+8D3y1CAJ6YvRdyaMXQ6SMEexbTgRsORyWBoNn7CZcVNnO/kHnFi337Bhxv
         ZcaXAzV4x3SV9cY6Sjvze1KkNDrpMeqN90HOJky0MZOYCeEtOYmNMleNyXYfnhaecBrD
         sr2g==
X-Gm-Message-State: ACrzQf1+zXGVj1KwUlx4nyrNJrP6H0h3vhtPeoFaPo6qRUCopWXrnB1z
        sIFE6botQASoVo3mlYA6m94=
X-Google-Smtp-Source: AMsMyM57aHXW/RGGiBVsB52ziBQZJfs8YnrGc+aSU1SEGc3QC4xsLDheavS6ccxJp971i10kW+FYgA==
X-Received: by 2002:a17:906:a4a:b0:782:686d:a1b6 with SMTP id x10-20020a1709060a4a00b00782686da1b6mr11023934ejf.232.1666275069320;
        Thu, 20 Oct 2022 07:11:09 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id l17-20020a056402345100b0045cba869e84sm12232510edc.26.2022.10.20.07.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 07:11:08 -0700 (PDT)
Date:   Thu, 20 Oct 2022 17:11:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     "Hans J. Schultz" <netdev@kapio-technology.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 05/12] net: dsa: propagate the locked flag
 down through the DSA layer
Message-ID: <20221020141104.7h7kpau6cnpfqvh4@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221018165619.134535-6-netdev@kapio-technology.com>
 <20221020130224.6ralzvteoxfdwseb@skbuf>
 <Y1FMAI9BzDRUPi5Y@shredder>
 <20221020133506.76wroc7owpwjzrkg@skbuf>
 <Y1FTzyPdTbAF+ODT@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1FTzyPdTbAF+ODT@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 04:57:35PM +0300, Ido Schimmel wrote:
> > Right now this packet isn't generated, right?
> 
> Right. We don't support BR_PORT_LOCKED so these checks are not currently
> enabled in hardware. To be clear, only packets received via locked ports
> are able to trigger the check.

You mean BR_PORT_MAB, not BR_PORT_LOCKED, right? AFAIU, "locked" means
drop unknown MAC SA, "mab" means "install BR_FDB_LOCKED entry on port"
(and also maybe still drop, if "locked" is also set on port).

Sad there isn't any good documentation about these flags in the patches
that Hans is proposing.
