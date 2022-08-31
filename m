Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD065A8166
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiHaPiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiHaPiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:38:09 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B168DD8E14
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:38:08 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w2so3421130edc.0
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=TEtlNaEZ/NGkHaRfRANoWs1dAUq19ASkw09zMlPYlIE=;
        b=acz5kOltoFv7/rjQZLYF/GqSL+Un4BgW/8jZNv+K8BNiDHQcbbtaQzqqHWpo9aFfqG
         KeCOVQeeDTZHlcSaOParohtcfyr2/5auMLzf9NfDvX/hLnjuMaqbS85Tee0xgMK9Gk+W
         9CJfjMXdp7pQ0jKejLbQ7c9n1sPRBBdUAqmUMe3KjBTuq5ubtw2FSvwEukz8BAp2D0qJ
         s007FHluqVtDOPX7Lxwg4fj7S7KP4eJULwsOfcTwqJ3X5x8kvLR6NC9cxzqc+M8txoVG
         MJaei/hXmbSnkcKOdJlKitpdu3SOEPv4xNYkNr0PcjneH52V6gaMc5LApArngdIfRxxh
         vtqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=TEtlNaEZ/NGkHaRfRANoWs1dAUq19ASkw09zMlPYlIE=;
        b=D+fiuw4GPAqVn46uP+CW/AyGWZjLt7Ota9vt9cmYBcX0JF7br2++Ay1hf/TegB1d7d
         qNZ4oLJzV59ERAbtl7nRisQQor99k7AtfHbfeILydLFMtaoonaFIgvJcubGmVXDRsuCO
         T9gp7XITLjW82HmDEETP/AYPGyxseMSZoEKQ9q26GGkkcdmM6wfhYIBkCkReciz1P/aY
         lQ6REuLW1zikju8DK/Lammzb0PKaIHmrBr3zug5b5AAucJdlOdPjjWAmLt4RejlLQ0wZ
         3NUMHgX13UmlXPDfTuMqsXxdDvPeiZ6NX7qvYRmiMXSq30V/C9OXYiRqAigy1dRgj+Gv
         d91Q==
X-Gm-Message-State: ACgBeo24ERP94N7/x1skSicl4xqAyYvY/W1PYnoZU5W3yAz8AUgnUu2C
        qSAROoayHuN5eB0NpV/I0/w=
X-Google-Smtp-Source: AA6agR6lZBgfFYHUX6E24UR78tqRhYjpdI/BYCBKNHnCc2HyX7ZIlyvJD7GR/apyuOzuxIpVmMYHBw==
X-Received: by 2002:a05:6402:2a06:b0:447:820a:1afe with SMTP id ey6-20020a0564022a0600b00447820a1afemr25322012edb.291.1661960287130;
        Wed, 31 Aug 2022 08:38:07 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id d11-20020a50f68b000000b00445c0ab272fsm9347322edn.29.2022.08.31.08.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:38:06 -0700 (PDT)
Date:   Wed, 31 Aug 2022 18:38:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH v2 1/2] net: dsa: microchip: add KSZ9896 switch support
Message-ID: <20220831153804.mqkbw2ln6n67m6jf@skbuf>
References: <20220830075900.3401750-1-romain.naour@smile.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830075900.3401750-1-romain.naour@smile.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Romain,

On Tue, Aug 30, 2022 at 09:58:59AM +0200, Romain Naour wrote:
> It seems that the KSZ9896 support has been sent to the kernel netdev
> mailing list a while ago but no further patch was sent after the
> initial review:
> https://www.spinics.net/lists/netdev/msg554771.html
> 
> The initial testing with the ksz9896 was done on a 5.10 kernel
> but due to recent changes in dsa microchip driver it was required
> to rework this initial version for 6.0-rc2 kernel.
> 
> v2: remove duplicated SoB line

To be clear, was the patch also tested on net-next, or only formatted there?
