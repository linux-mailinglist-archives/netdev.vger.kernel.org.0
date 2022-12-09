Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB2764883B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLISNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLISNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:13:21 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9EDA4308
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 10:13:20 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id x66so4268414pfx.3
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 10:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pvfycwltgPHZI7Fpznfw7FyfA5x8ooB+LWWo1xUMJMM=;
        b=UOxD9vCFTEAda7GUDOehw1t+7qeja1dXd1SA59DOSzQn++I/B4Dvc8QZCPUDzfapEv
         Sl1JW/W0r4Oa9XqlZ9PMEnhgyh3XKorWtBXm/qkyR3FIdMq2Lu0prtBF3Or4DBgqr03O
         66BhOC5HQAnWkxQInDcH/BG7QbrtaxlOCAHCsFIwuL5jSBEdgP0vy7270i1lmSiVgxul
         2DJIF0843DfC3vTPEXVDLuxVwIL/VmU6A0IpfhG9C9NaBi86fc+9jtAvs72se2bMJzf6
         arCtj4eVqjeBzQ7vFLNoUKWOI6RcqiKIp847tqIyDwF0C5WDtXN7kNjJAPX67RCKwr8e
         K2Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pvfycwltgPHZI7Fpznfw7FyfA5x8ooB+LWWo1xUMJMM=;
        b=DdhoG+GB36DDtqVrvlgWPmqAIeZYB2Ol5pZ5bt62y3iQ3gHjXjdhT6Ai0JHEjfO9j0
         /tBOfYRnxzSec1miXpfrkm3Ltrg+Ad9xAqhullytdZcyqf0l2bUB9AWGColM/sJ3dYaq
         68JcuPa0yOX877rfVCBDwSzyk+xzcLtHNXwJtDEUjblrSx6JR2DKciuNTuCkBOV3cx6n
         OquzetitSL1A6J4MqKUxJwkp1NGItGnIxHBQmmxyyFYWtV6A3bFp+YbpPYcTbaAPKxQ/
         lwjdJDgaXpn5nc61LtqGNBL50UK2oDdynYc8jCxAQb8SJur3Qu9JCuzkI605tkepO1Gj
         839g==
X-Gm-Message-State: ANoB5pmUILo1ny0xzzwGYirXcNyo8yjYbKtQ0AX9rGHvVc1UjTJqAXWz
        6CalCqkh6rUyIVvegLsC4e0nuA==
X-Google-Smtp-Source: AA0mqf4jsNgvKNxTQJLn0S9GuIjZnWewGoqx+GusBh/+GdQqdEsA1PTHSBw+6OFmXGeqRi5n5xV47w==
X-Received: by 2002:a62:687:0:b0:56c:eaa5:465c with SMTP id 129-20020a620687000000b0056ceaa5465cmr7612230pfg.17.1670609600127;
        Fri, 09 Dec 2022 10:13:20 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 81-20020a621954000000b0056b9ec7e2desm1510094pfz.125.2022.12.09.10.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 10:13:19 -0800 (PST)
Date:   Fri, 9 Dec 2022 10:13:18 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: iproute2 - one line mode should be deprecated?
Message-ID: <20221209101318.2c1b1359@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The one line output mode of iproute2 commands was invented before I was involved.
It looks like the only real usage is for scripts to consume the output of commands.
Now that JSON is supported, the one line mode is just lingering technical debt.

Does anyone still use oneline mode?
Could it be removed in some future version of iproute?

There are still output format bugs in oneline, and some missing bits
of JSON support as well.
