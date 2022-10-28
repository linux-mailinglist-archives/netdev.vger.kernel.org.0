Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D05D6113A9
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiJ1Nyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJ1Nyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:54:51 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E0E201BB;
        Fri, 28 Oct 2022 06:54:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id l6so4786860pjj.0;
        Fri, 28 Oct 2022 06:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zAImP6PWJ5WKUhDLfWykBuCXt66Oh0xkfiNtM65y4vc=;
        b=odgyqA70A3ESvmjUlqp5hpilRZmgvLyLT/NCtcrt8ymsLwCJENdZpKZFuSXCBG+AnY
         Q86vMciO80RAUc9b91LXgCHhLD3fLj9NKeBiIlI3CATTCHkZLfgLJZx2UwLTBFJk/GME
         Zk4GvwmIfod3CnXPtr+jRck8cjW2nWNElHM7wK/WyLdpdkH2Xee+QBW02diy9iVkGDVB
         Oy/a/G9W/aIytmcyDgVJ6d0FwtEwmOeyVnDwRQSfgEzx09p4bt6RxuJXvPo5zxfI/OdC
         S7YQ4OhwxQQBNs9ySlo2ARuVeNZQzElfeINCyLkgJ4DZAiHDzbL00ZP62fZyiStptrSv
         CWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAImP6PWJ5WKUhDLfWykBuCXt66Oh0xkfiNtM65y4vc=;
        b=hZv8B/BgHin4jnlxKdwVxWzXKHbwa9FkfWawFshAx+yuUFdo4JPiFKO2HeCD/4LChN
         YGVvTGtb2Zy5DHL3LyUvqRIleSVo4MI8xR/gG7BY2oLJoBx1AP+iwNe/CEpu9Ryk4INs
         ANu1MlUybiQXZT1VkRYJTkAiYBHVnIstHT3+868vxaNJWU5cuZ1i1MsNyAbE63VOxe8G
         mZ8QitK2RE1s0oIbW7uxhtOrZUvc+7XlrK08lSXt3JuMZucvzfYh3FJ0fGtMxMN7m/zJ
         Yz1q2nYy0ExuLDXB6HDe9JPgPL2KZjiXzw9gtB4MdpHcqeJ4aT8kjGa4/J3Q5W5T15Wh
         Kdug==
X-Gm-Message-State: ACrzQf07Z1L5qoOhiZthBD620eQKMorUD1U0zk/o4/Jx5VXhkzE70Wv4
        Eev7PRtB9APlnQpl9SV21lU=
X-Google-Smtp-Source: AMsMyM7raeSiL0bcANzUkRefG1GBCNbNvX1iZSwHR+qG9H5Nlc3HgW1g9UH/63LhwEBggls+D9Xr9g==
X-Received: by 2002:a17:902:e74e:b0:186:f3f4:f7fc with SMTP id p14-20020a170902e74e00b00186f3f4f7fcmr6116570plf.130.1666965288563;
        Fri, 28 Oct 2022 06:54:48 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id 73-20020a62194c000000b00561cf757749sm2869821pfz.183.2022.10.28.06.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 06:54:48 -0700 (PDT)
Message-ID: <9386b19f-dd99-3601-9e87-3056100dfe53@gmail.com>
Date:   Fri, 28 Oct 2022 20:54:40 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 11/15] hdlcdrv: remove HDLCDRV_MAGIC
Content-Language: en-US
To:     =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Jakub_Kici=c5=84ski?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <ad19b20f5867e845a843884bbb0f107e7ea7e11a.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <ad19b20f5867e845a843884bbb0f107e7ea7e11a.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/22 05:43, наб wrote:
> We have largely moved away from this approach,
> and we have better debugging instrumentation nowadays: kill it
> 

Same reply as [1].

> Additionally, ~half HDLCDRV_MAGIC checks just early-exit instead
> of noting the bug, so they're detrimental, if anything
> 

"... instead of handling the magic number"?

Thanks.

[1]: https://lore.kernel.org/linux-doc/80c998ec-435f-158c-9b45-4e6844f7861b@gmail.com/

-- 
An old man doll... just what I always wanted! - Clara

