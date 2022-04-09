Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D740D4FA06E
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 02:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236743AbiDIAKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 20:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiDIAKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 20:10:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE018167CE;
        Fri,  8 Apr 2022 17:08:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bg10so20257640ejb.4;
        Fri, 08 Apr 2022 17:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RvZAa7SKDRUob+n4fTMpikTEqqS+v/QxENsH8RtzPww=;
        b=Hf3GAkOQzv9e8PvaX4T37CgoPYyjwun300cYmypPebz99NbqI5XWgZUUr/cRfgCQ0q
         yEyPv3iui1C1/grSAXRrWRuN8dbz6cBQEpg3lM9C37EBvM5sQDouUxhFabNcQizQcdU8
         1s+r7XOnue2u+UMcpKJu/o5yZnpvCQoIqy1MlxgC7F/5F2fvQ+eQEk2tTjLrTRaQwq71
         fGM/L62bKnVvaOGDbo+8C5lRYbmkPMu3xXTxHpTBlvwi8Nl0ZlKE28458OZhFawR3t/T
         U/DFqLcUt7Ns/zgPRVKNPT4qAkIRo6ipV/fvzLQk22ztkCl4kIxx7nuo9Oa47HrHOD0G
         Hjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RvZAa7SKDRUob+n4fTMpikTEqqS+v/QxENsH8RtzPww=;
        b=DuFlUL0AdFL9aigZWfRgz6nQhRNo13rTf8y59hasdKWvgqQQj4cpAPl+KjkaD37bmP
         /jEiVQkBqcza5+g2ZESLQ0KtoVfEI9zh+V/IjsDp7moEI5JS2bGv0c0uyzowyE8kuioH
         cgw/3PCBMBddKnGrhtR0m2aKKrtArvlWFsN13c0TYzm1kTSsje/SjQwg4+fgro0QWpel
         KLA04NHCWGi6APQGhcx3Qv2FGMY20ThlyewmpxuZdSF0rMNrUzifYeY3knaFl4xixvm8
         0k8Jb7NSkS3ZPQBZK7eArm1ODWQCf6wfIuZ9qXBiXApTFQJ8DTpVZ5CXlWRimBFQo35T
         Gg1w==
X-Gm-Message-State: AOAM532tfNyLkYKIiTPBRrbuNIg13bLQNYVaxEu71YEP0KQJjPmBe8I7
        uXkP/WkwhfxcDxeOeUAHOi0=
X-Google-Smtp-Source: ABdhPJxa+uwu4gunlQPwRdiolDxha0utOQH8M/7X9mDxxlHZQFL3dCLpiHOPKltrB32NP/LUIeS0CA==
X-Received: by 2002:a17:907:6e04:b0:6e0:95c0:47b8 with SMTP id sd4-20020a1709076e0400b006e095c047b8mr20688094ejc.483.1649462905357;
        Fri, 08 Apr 2022 17:08:25 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id v2-20020a509d02000000b00412d53177a6sm11146780ede.20.2022.04.08.17.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 17:08:24 -0700 (PDT)
Date:   Sat, 9 Apr 2022 03:08:22 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Message-ID: <20220409000822.mbz34qevh7babqo5@skbuf>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220407205426.6a31e4b2@kernel.org>
 <AAB64C72-5B45-4BA1-BB48-106F08BDFF1B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AAB64C72-5B45-4BA1-BB48-106F08BDFF1B@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 01:58:29AM +0200, Jakob Koschel wrote:
> Hello Jakub,
> > Also the list_add() could be converted to list_add_tail().
> 
> Good point, I wasn't sure if that's considered as something that should be
> done as a separate change. I'm happy to include it in v2.

By now you probably studied more list access patterns than I did,
but I wrote that deliberately using list_add(..., pos->prev) rather than
list_add_tail(), because even though the code is the same, I tend to
think of the "head" argument of list_add_tail() as being the actual head
of the list, and therefore the head->prev being the tail of the list
(hence the name), something which doesn't hold true here where we're
inserting in the middle of the list. Anyway it's just a name and that's
what felt natural to me at the time, I won't oppose the change, but do
make it a separate change and not clump it together with the unrelated
list_for_each_entry() -> list_for_each() change.
