Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989A6611289
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbiJ1NUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJ1NUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:20:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA034D804;
        Fri, 28 Oct 2022 06:20:00 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso9855038pjc.0;
        Fri, 28 Oct 2022 06:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LOLDcm9SinQdmtgEj1AOeXmTD70A5sOMBvhcqSEa1og=;
        b=PlRi5AaoVDZ+jhS4DO0oAQzAAwpLIc0fKRhtSOLvHVtbGmOvN4N/Y6eq733ZZsWbiI
         m+RBSowqUGxzQHqaqR9M00Drt+fbIypr6eQNgMAX+GYhwl64+FPiQ/IeW4/+170YAWxw
         1I8U/ROvuQy1VQqi5YJl7FmW6vOFu4yZzWjRDspJVvGPCQYNIHVXjt0udZTWYxBLFuIP
         YX1MBDzv1wjdj68c3oFoDVi1Zx++3DKntT4qcqIfwHfvvrqEb15I4sUfN4knAlJVsEzw
         E4DsFhErm2nO3Ko6pAH1d+H6lLGmpnI0GpAEfkdVnSOVz38nku28tra+/3pjBcSbJjsY
         1neg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LOLDcm9SinQdmtgEj1AOeXmTD70A5sOMBvhcqSEa1og=;
        b=qRk7tDh35B6yTEyxSkZUxRs4keXtHm2be0cHqH+T4gX6g9nUkUY4jXMQjw+gXqF5Gc
         VbFn/VrzRh+Izb4/dAMm4h8Ve7OQOYGCwzuKhz+SnO3iJF6R/zMNF0quL0Pg9bfVfu4Y
         yk+oGomQrdBJNQJ/LlcM4GomiFYuvEAD5C0ujK4qFjzuMGOR2G5JeC5zZsEAQqhqe56i
         Ej63JM0Bw3hEbpOHEpCxQRjJv+HCEnvKgoCTuhb9Fdox94K2xMGV+QSpY6dXJsyekGzY
         j+qrKTwagkMy1nTLuGBybqllT/6dD87lOH8TwDg4udMMdopE3fu2eOX8bV6TXwe7j7IN
         eJ9Q==
X-Gm-Message-State: ACrzQf0W3O4f7AlJPlsVjnOu8C5pbzjWpOpYNpv2eBCbjakzQ9SUVqZB
        8MusLzAoEWtP8eDp5YxaoNQ=
X-Google-Smtp-Source: AMsMyM6Zd7SC5jdjDkmNaUZi94+5tNGmZfUEBwP2ohUAiotjrFLrzgnsaTdZ0pWm35UQKyLboe/a6w==
X-Received: by 2002:a17:90a:f2cb:b0:213:9afa:d13a with SMTP id gt11-20020a17090af2cb00b002139afad13amr1609986pjb.180.1666963200048;
        Fri, 28 Oct 2022 06:20:00 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id l14-20020a170903120e00b00186ff402525sm914863plh.213.2022.10.28.06.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 06:19:59 -0700 (PDT)
Message-ID: <4e7726a2-a631-642f-e8f5-c97ff3fc689f@gmail.com>
Date:   Fri, 28 Oct 2022 20:19:51 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 02/15] hamradio: yam: remove YAM_MAGIC
Content-Language: en-US
To:     =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Jean-Paul Roubelat <jpr@f6fbb.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Jakub_Kici=c5=84ski?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <e12d4648a757b613a2ecf09886116900fba1c154.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <e12d4648a757b613a2ecf09886116900fba1c154.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
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

On 10/27/22 05:42, наб wrote:
> This is cruft, and we have better debugging tooling nowadays: kill it
> 

That "mature phrase" again? Same reply as [1]. Thanks.

[1]: https://lore.kernel.org/linux-doc/47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com/

-- 
An old man doll... just what I always wanted! - Clara

