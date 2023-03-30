Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55F96D0BD9
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjC3Qwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbjC3Qwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:52:31 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ED6EF80;
        Thu, 30 Mar 2023 09:51:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w4so18626095plg.9;
        Thu, 30 Mar 2023 09:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680195097;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TN84UAm9uo2g8A+E0ZnufT0CTPTZwSQT4jeM4sRw1V8=;
        b=o0CzKe2I39j6+UaJbrBFsw26RL8QgD2SERp6qPNQmXN/yzxqb/ez+doK/B4zXLJqhy
         48RPQtZelAnuTXVUOZPSHiif8EplV7a1yoO3cj/aXLZcQOYHnEW5P/qw/cw2oKGU904L
         gBBqzuXm/pGrCXYCkGQSypu98EKCVrEHHyx5kaBzoXKsCUtgz3LuDueawgPBfmbkvcyV
         ZAgUHs1OGo09XkxL32OgkzpmhxFY0RpRxv85HOFR9sV0YJyqF63LklwrqTLXQt+rV8VP
         slzqd78gRrTPAJyYTlzBRzSGdfMfMoEvezyTugXjOgdS9f+dGbUia5fmLljGf+xg7AEJ
         MjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680195097;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TN84UAm9uo2g8A+E0ZnufT0CTPTZwSQT4jeM4sRw1V8=;
        b=xg9BmTxP5LNudqbIssQCdVVmIXsIqwzTOG6zkeoO+ji8YN35fNV0eMddZv4YFUjCoD
         S+Lalx26eMJDFE5XeMlCdPKalZ48/fj3asRa8xWR4Hw54TwIl3LO9AcoeFog7M9d3xhI
         H6/B1jOfW/BggCGTaD56YxhfMs9pFiENDV9NAeekz7o5fvKRJ78Q/hr4Lxe+yC9wZMO2
         0+nXGdRLXfa6jheMHMdJiq2zB2n4k6kfjipOjpSWNm2ZeV+hTP6/bK7xFbNLUwEGp4HU
         oyJ2sc5wnfz9thOj9K1ruy6xvbmwWno44Re7s6mgB+crmFt8Oy5IASbPxFYMlnnPyCzA
         jX9Q==
X-Gm-Message-State: AO0yUKVUDD+gKs5bTzS41CF5YE+Z7Be/KfYCQKqzD9VzCconM29ecynW
        1/eYOj2jblfUj4Nago/fNKs=
X-Google-Smtp-Source: AK7set8yLcttLav6v2ClI9R/rTmCWZORspzl9e0vlLwNdn/+zeBtbviH/QnnJ1dg5TyyR+J3tTSukQ==
X-Received: by 2002:a05:6a20:1a92:b0:d7:8ad3:bc66 with SMTP id ci18-20020a056a201a9200b000d78ad3bc66mr19976600pzb.11.1680195097528;
        Thu, 30 Mar 2023 09:51:37 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s37-20020a634525000000b00507249cde91sm25422pga.91.2023.03.30.09.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 09:51:37 -0700 (PDT)
Date:   Thu, 30 Mar 2023 19:51:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Alexis =?utf-8?Q?Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: rzn1-a5psw: enable DPBU for CPU
 port and fix STP states
Message-ID: <20230330165123.4n2bmvuaixfz34tb@skbuf>
References: <20230330083408.63136-1-clement.leger@bootlin.com>
 <20230330083408.63136-1-clement.leger@bootlin.com>
 <20230330083408.63136-2-clement.leger@bootlin.com>
 <20230330083408.63136-2-clement.leger@bootlin.com>
 <20230330151653.atzd5ptacral6syx@skbuf>
 <20230330174427.0310276a@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230330174427.0310276a@fixe.home>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 05:44:27PM +0200, Clément Léger wrote:
> Le Thu, 30 Mar 2023 18:16:53 +0300,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
> 
> > Have you considered adding some Fixes: tags and sending to the "net" tree?
> 
> I wasn't sure if due to the refactoring that should go directly to the
> net tree but I'll do that. But since they are fixes, that's the way to
> go.

My common sense says that code quality comes first, and so, the code
looks however it needs to look, keeping in mind that it still needs to
be a punctual fix for the problem. This doesn't change the fact that
it's a fix for an an observable bug, and so, it's a candidate for 'net'.

That's just my opinion though, others may disagree.

> > To be absolutely clear, when talking about BPDUs, is it applicable
> > effectively only to STP protocol frames, or to any management traffic
> > sent by tag_rzn1_a5psw.c which has A5PSW_CTRL_DATA_FORCE_FORWARD set?
> 
> The documentation uses BPDUs but this is to be understood as in a
> broader sense for "management frames" since it matches all the MAC with
> "01-80-c2-00-00-XX". 

And even so, is it just for frames sent to "01-80-c2-00-00-XX", or for
all frames sent with A5PSW_CTRL_DATA_FORCE_FORWARD? Other switch
families can inject whatever they want into ports that are in the
BLOCKING STP state.
