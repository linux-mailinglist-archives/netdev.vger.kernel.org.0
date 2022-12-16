Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D09764EEC3
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiLPQPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiLPQOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:14:50 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE75F29
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:14:49 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id g20so1474544iob.2
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ATM7tkGgEplwEvG6qxehFV5CmukFi0UcegxWCu5skok=;
        b=EDQ18fSXOzwB/7IN2ELyuL38iYmRYx31YxdJAzowHQ5pBGcQMHOmuLnQ6LJviSKLqE
         hdcnhnLKPAMfjBWk6Mw3emgY7xlfQCHLnK//wvzW8pFKsrdLG62Fs8Ge4V6EjvCP8zgD
         A4+oU4/HpF7JZxTQWWh9MYH1U9KO93zt+S/WZNlxttkMxYoeIk/oQoGrqlR4l0CBcpjk
         Fu+3yDBthwyIcxlBNtly3qE5fIz9dNWqSlYBYnBqd/9jlswTI8802KKuvXSIMPdkfJHW
         SHDCdAB9s3BKnsC1oqWD9LQf8DNq1hY6COYUHJJ4xzCOu+w+SUI2Ue9JNiMC4XiqNv0S
         pTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ATM7tkGgEplwEvG6qxehFV5CmukFi0UcegxWCu5skok=;
        b=K6RZOQ47Pi7I81lkPe556xjyPT1lik+LH+MIy3BtdirjcbtEYXU4WUb88FncIgu8Mz
         W4cKfN2jfUk+b05jihKh3uVyT1FWBuE0EN14mU5SCEbb9di9S8Ar6Ya5vTZ/WPvbGgq0
         Im7v7pOR7xGViR95cVg/N/0NExok4EcL+TAuMv1GtJUQLK70G3g79uG35lVHiTpomkk2
         avRwt543caaqRkuO3g57dKSsYe9Z35cR5V5yLSet8Cze/yb1gvh9ZbycCy4iOXaTkLEq
         FVf53CMLoIE7Qs45a4M7xfFftc3xlLRyLWERLPpFcYW3o1O8m+ZuSPetOZw8zQx+zbyX
         E5tA==
X-Gm-Message-State: ANoB5pm9XvChsx5hTB9QyFBL7qngLg4mivgP3mmd/8SQFruceaLYgG17
        qE5lc8vrZZHreOm/UBR43Hw0v29wNJo=
X-Google-Smtp-Source: AA0mqf6ttyfQ7V+hmW9EsDiD3BJhLeWNO2rY1JgSkV0iho1SH4f/bHFjlBcb9jFpvXl8EHLIR6D7ZQ==
X-Received: by 2002:a05:6602:179a:b0:6e2:e6f9:ab29 with SMTP id y26-20020a056602179a00b006e2e6f9ab29mr23592166iox.17.1671207289190;
        Fri, 16 Dec 2022 08:14:49 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:10c5:1a0e:b024:2c54? ([2601:282:800:7ed0:10c5:1a0e:b024:2c54])
        by smtp.googlemail.com with ESMTPSA id e21-20020a02a795000000b0038a760ab9b3sm861549jaj.89.2022.12.16.08.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 08:14:48 -0800 (PST)
Message-ID: <ffeb2330-9c1b-2ec6-e5a0-bfdd614b3fb1@gmail.com>
Date:   Fri, 16 Dec 2022 09:14:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Content-Language: en-US
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   David Ahern <dsahern@gmail.com>
Subject: iproute2 merge conflicts
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal:

I merged main into next and hit a conflict with your recent patch set.
Can you take a look at devlink/devlink.c, cmd_port_fn_rate_add and
verify the conflict is correctly resolved?

Thanks,
David
