Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7841E56A506
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbiGGOEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbiGGOEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 10:04:11 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6632CDDE;
        Thu,  7 Jul 2022 07:04:10 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bi22-20020a05600c3d9600b003a04de22ab6so10788507wmb.1;
        Thu, 07 Jul 2022 07:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:references:subject
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=jEk7NQXnrRcwYUUJ7a7WbG8rsOi2ymPcZ84wetxtqz0=;
        b=AOWvIcbSWkXTHu2AyWWwMx0Pcw9RfA0RIOMce0F6xF6TWRm+4arX8XHMnUQ1BDsrND
         uji0RSPNHvFYEYbbsLOcsIOfnFGVx2zMm/ypEOAtp4/Z9i4tVIXPoY1daT73KwPJVSsb
         SF/uGsXEYDl1kb9O+mHm2zyGS+fDNJQg2iqdT/zO3yD63ffwrnN5oGKs0yXlfGxlnSIu
         xLhiZZcZPbNw2Xvb0UKq/I50jszmSrD5n4PCPROVHv8k5qqqZBXguXUcijEzYe+Ur4M5
         2A3/A2rStZHOk3vY+heAGPCqamUWuK5XAaJGZKkQmoMA6wAIpNWSqL+OAX83Q9tJ5wqb
         knkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :references:subject:content-language:from:in-reply-to
         :content-transfer-encoding;
        bh=jEk7NQXnrRcwYUUJ7a7WbG8rsOi2ymPcZ84wetxtqz0=;
        b=WlYKpeYxO6WSB3lfoKb18SGSeAjsfbiQguA72GTz9ZwKNdiCNCtRGlvowKwol8f3mH
         j4EOH4qHdR98A5SvApVrajNX8BtfFUD+n/ykqPHn7GK0SfRxtWwK1yF/KNDYGAcOlQNR
         OmVRrdmvmBgNOE/MpK7DrXrMRGpmQBZ9g5GV7IQ5x1DBAy2SLC83gj+aTusoHYZRZymb
         RDfuq2vVu6b8dnSQKhOqYjn0nHLKNh32gTJTxPa7INiNHFzbzShzgkPaj+8gioJdUTLU
         Vches5BbUkY0xzthUEyL1WvogtFbHs6TV3hhrH+DkR4SsrohuSer9wXLfbvTq6cnyxxA
         qj4g==
X-Gm-Message-State: AJIora9QtheoFZrJL42fW+XEqlQzRnOHx/kj8PpS6773UysIcMOKOj7S
        bXN0HuCoKi5iRpvSs9sQF44=
X-Google-Smtp-Source: AGRyM1ufjsg/wTW3PHpDdJTz6e2emaA2g04EF1PgS0QMd/gU63XDp1oe2Z/NS8DgwtI15WHr6GXYtw==
X-Received: by 2002:a05:600c:354d:b0:3a0:5847:9a1 with SMTP id i13-20020a05600c354d00b003a0584709a1mr4561497wmq.142.1657202648588;
        Thu, 07 Jul 2022 07:04:08 -0700 (PDT)
Received: from ?IPV6:2a01:cb04:613:1800:e04b:ee8c:3bc3:648e? (2a01cb0406131800e04bee8c3bc3648e.ipv6.abo.wanadoo.fr. [2a01:cb04:613:1800:e04b:ee8c:3bc3:648e])
        by smtp.gmail.com with ESMTPSA id l14-20020a05600c4f0e00b003a199ed4f44sm19990769wmq.27.2022.07.07.07.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 07:04:08 -0700 (PDT)
Message-ID: <ee708c61-474a-ce89-3e8d-4c2e0bee30e4@gmail.com>
Date:   Thu, 7 Jul 2022 16:04:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
To:     dlan@gentoo.org
Cc:     andrii@kernel.org, aou@eecs.berkeley.edu, ast@kernel.org,
        bjorn@kernel.org, bpf@vger.kernel.org, chenhengqi@outlook.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        palmer@dabbelt.com, paul.walmsley@sifive.com,
        songliubraving@fb.com, yhs@fb.com
References: <20220706140204.47926-1-dlan@gentoo.org>
Subject: Re: [PATCH] riscv, libbpf: use a0 for RC register
Content-Language: en-US
From:   Amjad Ouled-Ameur <ouledameur.amjad@gmail.com>
In-Reply-To: <20220706140204.47926-1-dlan@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Amjad OULED-AMEUR <ouledameur.amjad@gmail.com>

