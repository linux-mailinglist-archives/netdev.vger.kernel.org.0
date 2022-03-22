Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B084E37F9
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 05:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236483AbiCVEiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 00:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236445AbiCVEiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 00:38:15 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B4821279
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:36:48 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id i23-20020a9d6117000000b005cb58c354e6so6359488otj.10
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 21:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pWoCluQr6j1ob9jpMIvAlBX1JYv39LxR41cUGuK+5cQ=;
        b=QoKrmSxCGtsS3n75RqR4e4le7iW21XkwUMxmbY61UUWAchNUvWkTbEOKbs9TkUQb/G
         dOP0JcrmmPLNM0M+1gA5yb8yGWAEF5qIIVmKXGd11wcKBkoG5yL4UbfxmIMdtLbn4rtc
         YcTbnWrfkaqRU9hXAg1udD3ExIYmbKwNKXknj44la5SbJv+QUQ0hUgdjUqRUHghVRgjy
         uYZQHzEFY6mg9x2gYnkT7CuK+GrTPPcAO8zTpn6Sv7HiEnqZs9XaxGAlvK6xUPh6CzGZ
         cBQ+bCPS0M7ZZCkm/N+kMk82Lag+CA/Zq3uo36gkGIkjVotYKfY4br0AQgBG2xTbQAfo
         7zfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pWoCluQr6j1ob9jpMIvAlBX1JYv39LxR41cUGuK+5cQ=;
        b=kzqa3182v28PlkQaKytLRXvbaYJe3HT34xaI5WDrxgHE6BiWMbD6yOZ9/HyC5Ivp6b
         lAch1MTG3MtyrsghmmFlSoWtG+kS1IfpjdRAjS8dCvQZQmze4QpbMois93iiQw0oZldg
         2ob03hkY6pIuuD6wjmnCULjkZYwxQN68Tp/hiPI1OLPUpEmF2xMRjzR59WPMaqvUYM+v
         u+8R62ogqZ8p7hTWFoMWHZQ3ikA9EB4cYs9mXtSOPRLe+MqkmLZyz1GZcmjxgCAvBWvS
         kdxjYJoa//KlXmPMVe/dc0Np0BIqDzsj9Gz7DmIwlfYwkLE88h+yqH09buVq73At3N2W
         WpTg==
X-Gm-Message-State: AOAM531GQdnjf3C2i7RCfzdqp+/rAER0mf/j4Ba++7CcUve1vfrXNkzZ
        AdN1ZIkVs4jvUW96GKA73hwS81U08dHa4onMLaLBpA==
X-Google-Smtp-Source: ABdhPJxx9TbGToyv92Xy4uBlcfb5JEaVDmok3zaQYYdhFooEaoVaICNxBtM6FZ3Cwh/PH8cXfkEL5piRkCyVzeX3AGU=
X-Received: by 2002:a05:6830:1b78:b0:5c9:48b3:8ab with SMTP id
 d24-20020a0568301b7800b005c948b308abmr9264741ote.235.1647923807807; Mon, 21
 Mar 2022 21:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220321152515.287119-1-andy.chiu@sifive.com> <YjjCCPk0qy4vt4Sg@lunn.ch>
In-Reply-To: <YjjCCPk0qy4vt4Sg@lunn.ch>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Tue, 22 Mar 2022 12:34:44 +0800
Message-ID: <CABgGipWouY-uEv3v5zWCYh8A+e9Om8oU+qa8ePyAtHBumeurDw@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] net: axienet: setup mdio unconditionally
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     radhey.shyam.pandey@xilinx.com,
        Robert Hancock <robert.hancock@calian.com>,
        michal.simek@xilinx.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Greentime Hu <greentime.hu@sifive.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for pointing that out.

The patchset I submitted is based on the net-next tree. But I think it
should be on the net tree after reading the FAQ since it is a bug fix
on DT handling. I will rework the patches and follow the format in a
v5 patch.

Andy
