Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37444520E2E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 08:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbiEJG6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235052AbiEJG6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:58:48 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C0925D113
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 23:54:50 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 129so9569754wmz.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 23:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst.fr; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0TfaampWsjqskOTtcZzppsArhaON0S7YUZZ6lyDawxI=;
        b=rgZ0OGIxMMoe17aoko7VxTIjwCrOV4KWUogykchxpiV2WCAKajjjddK08xOCmLAuyH
         MCf+rXFkVTEHX2Gh+Aos9mzOfgdh/6dWyqS6ht/oaCj3Mn9rfX12G6JGTKrHignIsOIH
         62kPp4QjY3Ag/FWOpQPsoMtUJjzlfBgxlY9h021TcgLY/f+DQmmHM8knCCnj9lBux/pM
         /H9xRrD1GNU3Wqkfvd6VMUqbyfbBfcWu/wAQhAsYGbNqAyWDnsNVvHQLF6gdjR0z3n74
         jognzaFcKZ34xQq2t19k8R0Kni6JYr2zjVQmpBC8J+71IWmwN7jZFUymuWmV+BT4lh9+
         UehQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0TfaampWsjqskOTtcZzppsArhaON0S7YUZZ6lyDawxI=;
        b=gxa6Vp1C1bMCSB5z7d72onQLFl/yW4gGMw2CBVjIDR0uijYwWt1HvlEHPghiQLVPkM
         kzAVWApkrdCYUGlZhPtICoHULBAhDS/t+VDkeTwIUy8ZZnBwRJ0yYZS7LrfZ2S6bVxzy
         b3KoYvL2ll+61GsvkU7QJvXY5A/Bc9EwfB5stOqRect8f0lluqgnXo55RRXxV8V4JKj9
         X/OWW7eRyKBDIUP3hlR372QDtcotiNJolqCdlW+bo2TvuaXlR9j/XivThwFErjJxIUoy
         9Yu0lIu+qErrRbWmfemXtQOvwff/x8I+1p8yQMd+uOlXcmB84uiAuPG758uUve9Ie1Cd
         cAAA==
X-Gm-Message-State: AOAM530DYZ8THVDkEax42nRbLiyw3gEZfXb2SPfMpJ0hr1N6D5JfagOi
        Hmdc67vcDdVPb8/+uSJfQCgIcw==
X-Google-Smtp-Source: ABdhPJzQev3zqjVEhiZ6KSozO2jAzss5NLHpbOkrmk8alIMM0CSENDlNGODJwBRmWUfHmYD/TjMKSw==
X-Received: by 2002:a05:600c:5026:b0:394:92b4:7486 with SMTP id n38-20020a05600c502600b0039492b47486mr7731744wmr.65.1652165689239;
        Mon, 09 May 2022 23:54:49 -0700 (PDT)
Received: from [10.4.59.129] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id a12-20020a056000050c00b0020c5253d900sm12888238wrf.76.2022.05.09.23.54.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 23:54:48 -0700 (PDT)
Message-ID: <8653ac99-4c5a-b596-7109-7622c125088a@wifirst.fr>
Date:   Tue, 10 May 2022 08:54:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 net-next] net: neigh: add netlink filtering based on
 LLADDR for dump
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20220509205646.20814-1-florent.fourcot@wifirst.fr>
 <b84e51fa-f410-956e-7304-7a49d297f254@kernel.org>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
In-Reply-To: <b84e51fa-f410-956e-7304-7a49d297f254@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 10/05/2022 03:38, David Ahern wrote:
> that is done by a GET without the NLM_F_DUMP flag set; doing a table
> dump and filtering to get the one entry is wrong.

GET command takes a L3/IP address and one interface index. It returns 
unique entry matching this tuple.

This patch is for reverse lookup: you have one link layer address, and 
you need entries matching this link layer address. You can receive 
several results, since:

  * One link layer address can be used for several IP addresses on the 
same interface
  * One link layer address can be found on several interfaces

Best regards,

-- 
Florent Fourcot
