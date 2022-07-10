Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4C656CDAD
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 10:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiGJII5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 04:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJII4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 04:08:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7D3B497;
        Sun, 10 Jul 2022 01:08:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso2364136pjk.3;
        Sun, 10 Jul 2022 01:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R5UuRCOnxQJKj1KRa5RYRFK46VeiHSwmoO0SjXJK7BA=;
        b=fZTsjr3nDLxKq/JCypFx81zo0z9gMR9ciq3CRKUTbtFrcy2sKSBasxi1RpGv7dLHsK
         iixINN8cIVjfaG0LX/akRYO17/iZVb6t/7z7VJVkHfEwNqZ7Jaopl5Uvl4PwnMj3usHL
         sm/cD0NTgmBaQ1oxfFV4gwyNrlQ36K/Ng/Ep3HSi7W8u+9xcZrtZicVZx1bCsDDUvHP6
         J3Axvp61fu9tCn6BGxzDH+sI5FiqoPTtwvbo4CcHM54beienXwykrY0pb7RREMxeFhkO
         qkmh/QvnEskQLZwLRcXVWvja6uIliINv2A1ueb/ivk6ax1DwUMtl8ElYGklMMrgAMd9M
         Kv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R5UuRCOnxQJKj1KRa5RYRFK46VeiHSwmoO0SjXJK7BA=;
        b=SlLy/mb71UlNaCPAl8NJop5osZCZNaFHoMEt9rSb1q/6I3vt32J3ohUdeyH572r1x2
         LvVyEqtYpQyiePSPG3oTQp6dwlTt4zAIUMlpZlJZHl7cheDhpHzbjvrrn6YLSq42LYiK
         cmbx/v7UUZzgaV2YCa17ncNNwes2w2sDnEq9YeiLcpqF3LAR8OgyVqAFsmozCJA/DrpX
         FlYeM8GBvTetRAi+0z1xFcJYdXwDUSh3AMk0xR+ZLhF4COaYnilDmEvCM8Jh7nxLbKlD
         jXRARpXk926TFcx96uoxqRW/Al2d7Q0uitAQEE62YCXqXPeYR8vPdsSumACWmRKbCxpf
         ovUw==
X-Gm-Message-State: AJIora/+prToCbIHVJt3ypwgeZKfCxLjz99V3nj+bZQJnbKA4cxTIKfn
        B9epxpYsRuqgTkl37BJQXeByEZKvwd0=
X-Google-Smtp-Source: AGRyM1uKoo9M+f8Od5OQ6lLl4uLvA8/4yw+6ouzbk2COvHmvttM39GlLTwAKxlpXkZtCK/zFUFSG2Q==
X-Received: by 2002:a17:902:c146:b0:16b:db72:a9bb with SMTP id 6-20020a170902c14600b0016bdb72a9bbmr12487424plj.51.1657440532459;
        Sun, 10 Jul 2022 01:08:52 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id n5-20020a622705000000b005254c71df0esm2513711pfn.86.2022.07.10.01.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 01:08:51 -0700 (PDT)
Message-ID: <51ce6519-9f03-81b6-78b0-43c313705e74@gmail.com>
Date:   Sun, 10 Jul 2022 17:08:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 0/3] crypto: Introduce ARIA symmetric cipher algorithm
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, borisp@nvidia.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20220704094250.4265-1-ap420073@gmail.com>
 <YsoB9LBXOLEdV/2e@sol.localdomain>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <YsoB9LBXOLEdV/2e@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,
Thanks a lot for your review!

On 7/10/22 07:32, Eric Biggers wrote:
 > On Mon, Jul 04, 2022 at 09:42:47AM +0000, Taehee Yoo wrote:
 >> This patchset adds a new ARIA(RFC 5794) symmetric cipher algorithm.
 >>
 >> Like SEED, the ARIA is a standard cipher algorithm in South Korea.
 >> Especially Government and Banking industry have been using this 
algorithm.
 >> So the implementation of ARIA will be useful for them and network 
vendors.
 >>
 >> Usecases of this algorithm are TLS[1], and IPSec.
 >
 > Is this actually going to be used in the real world, or is this just 
a PhD
 > thesis sort of thing?  There are already way too many random crypto 
algorithms
 > that are supported in the kernel, and many have been removed due to 
lack of
 > users -- implying that they should never have been accepted in the 
first place.
 >
 > - Eric

The ARIA is used as the standard cipher algorithm in South Korea.
Therefore the government and companies who want to work with the
government should use this algorithm.
The specific usecase is the e-government standard framework[1] in South
Korea, which is a standard framework that helps to develop software for
the government, It uses ARIA cipher.

Also, the OpenSSL already supports ARIA cipher for TLS so I think we can
use ARIA-kTLS with a simple PR.

I think these are good usecases.
This is not just an idea/thesis without usecases.

[1] https://www.egovframe.go.kr/eng/main.do

Thanks a lot!
Taehee Yoo
