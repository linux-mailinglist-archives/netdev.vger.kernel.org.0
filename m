Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9161358E47D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 03:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiHJB1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 21:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiHJB1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 21:27:08 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D025FADD;
        Tue,  9 Aug 2022 18:27:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w14so12903564plp.9;
        Tue, 09 Aug 2022 18:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=aMmzBt/TBT59uBGgogc8HNMQteHV+aheJkP8yVZzq38=;
        b=fHR57LZaM+eGHS8Kvxf+MdiXJkXyfzeDA4Vk/JzKtfiCwZRhUPn3KWl3V/q5iDdKsc
         W8D739RIOCAwDUAPBW8YWUqDrgyxZjSutzq05wRMOmau4JEosK7H8fP+E/aziyBkAe3H
         z9kqGn2u3QRBMPACkLT/3w5p+AggUYLCpI0zQGhK0aGHDoDEPx7Hqwzd8xXXrzWJo5V7
         Ispcan8lwNq7IRwPlVyN6ACGl0WM+I7dIJF3tTT7yrqj/72PG/PCryz7adTZwXkMdA6X
         Q9W8loZpzQtQlaSzAZWmHkxv+6EQAAcyXW9/KDemK3AW7tAjubV2CWwoIcj3V9qQYeiS
         GEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=aMmzBt/TBT59uBGgogc8HNMQteHV+aheJkP8yVZzq38=;
        b=IkF2+3l8e1MyzCBewAmrGFtkjrOoU86tD+AliXj5GfkR3QfaqnQfVlCFfBZYA7/xVe
         bXWjSo2as4mZNvy5aVhr3iTwMh9iGj4g0v2aGUOQEolwwGPlOU/h5V8KrfK1e6UTxgnf
         6BvNwdoFpwPiJpDDnmFx7UZqPo2My8ZYjd3j2ZFnaJUnk2rZPIs1BjLm2Qb3O01RFU6Q
         h9WHTwETJp4Taz/2/FWx/JrmuE79mzZamfAEWZ7IMxB9/IvC8tsh1s9r6OAczNC1jrHP
         xrpg994FMJWqp9M3QYu2KWMCZkgy/cbYj73kYm+a9mBTzl2+FBaEmmaumYoEbXSUDe6H
         0dVg==
X-Gm-Message-State: ACgBeo2+WiaufJ1ktCf+FmCQit5f0DbAVJr7pnUwCJXBHS9229O7bJpd
        raeu6VGo6jpbTspMTlVKil0=
X-Google-Smtp-Source: AA6agR5ttwmHSdAARFoSlrXLSeIVikShFhitZkshbZZxVg5OnVr/Y53jsTLQPRB5rC2ztDWn9l7ikw==
X-Received: by 2002:a17:902:c24c:b0:16d:d5d4:aa84 with SMTP id 12-20020a170902c24c00b0016dd5d4aa84mr25307703plg.36.1660094825222;
        Tue, 09 Aug 2022 18:27:05 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h3-20020a17090a580300b001f2ef2f9c6fsm223336pji.56.2022.08.09.18.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 18:27:04 -0700 (PDT)
Date:   Wed, 10 Aug 2022 09:26:57 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC net] bonding: 802.3ad: fix no transmission of LACPDUs
Message-ID: <YvMJYb0VDJW+6CRh@Laptop-X1>
References: <c2f698e6f73e6e78232ab4ded065c3828d245dbd.1660065706.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2f698e6f73e6e78232ab4ded065c3828d245dbd.1660065706.git.jtoppins@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 01:21:46PM -0400, Jonathan Toppins wrote:
> ---
>  MAINTAINERS                                   |  1 +
>  drivers/net/bonding/bond_3ad.c                |  2 +-
>  .../net/bonding/bond-break-lacpdu-tx.sh       | 88 +++++++++++++++++++

Hi Jon,

You need a Makefile in this folder and set TEST_PROGS so we can generate the
test in kselftest-list.txt.

Thanks
Hangbin
