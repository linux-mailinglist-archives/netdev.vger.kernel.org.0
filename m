Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF165851E5
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbiG2O6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbiG2O6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:58:10 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DC07FE59
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:58:09 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id p5-20020a4a4805000000b0043548dba757so845719ooa.8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a/m/UU0XnOFa9/SuSo6JSXgweAh4UNHUQxGuM+Tu3pM=;
        b=Jv26Fs9HFYhpyD33DS+9fDpOGG5GLcn58KCOANn7BHZjOrxuAzO77LRHXhzYlneJQK
         Cex24XIN1l4MphrJN9FxLPBNzGblpUGpeOwfS8agKNHiXlmn++MgjoFg2tQwCsSd+Cbq
         Nk5a9b07PXIy/fzj4VnGmIHWawDVcENjeZ7tZFyJg9gwNqE+z+Ir+hueWr0l1yQbPwSi
         WtaE8bjnIg7ilfnwu5lZBwjiYI9cMOgYnYbCQ/uWuJy9TdUbvCNQDhyhO85qPVwUeJ1e
         YexfmGkdtAQY4YLlJDzBY2SVSJStRphTMEeq6YxO3HK9H8uSpgYAIk3+SZ8O4CzWbkMW
         xwyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a/m/UU0XnOFa9/SuSo6JSXgweAh4UNHUQxGuM+Tu3pM=;
        b=iRculJipFRx0ZTK/dPthR9MtyH8jRg4jSkoUW0nE0t59dh62GPJDVRqLAkktGNL/B3
         BtuaDef3ohj3Uu6320qcUAb829iRDfb4miC5J39viooHT3TkFWgW8LCH4GmSKh+IEtBx
         CTh3XQ5Urc6fSd5cORGtgnH7YaF8iFeDhOHU5fekMx7PLZSGoSbGeLk64fnCUdx7ZuCo
         QgU/zGYg9TWFi+zRxihpxahDNGLHnw4HPAOTrJhyQ1wUQgIyNMor4RLBqlAMcVzr851D
         08TZX0QF1rImM7XdtlLsD1OnFlNLWWn1AAoeLRRYS9A2Fz1UfP8zvCF7zw6GKNH+sCG9
         w2+Q==
X-Gm-Message-State: AJIora+SBtCubEu8IJPIUTfmd6Dpx2t/ZD7JX91ekk1hlBteBBnMk3bE
        WpvKZmH+mliGoaqsc/zNIXE=
X-Google-Smtp-Source: AGRyM1u9Eq8TrcUVx8/cr7vSM1jbWQPaeZkZ1rhb7OUtsjUpZOoRN4SJ/Rm1o/403nf5Y6mIHU9dLw==
X-Received: by 2002:a4a:d621:0:b0:435:d6cc:b2e1 with SMTP id n1-20020a4ad621000000b00435d6ccb2e1mr1412160oon.88.1659106688528;
        Fri, 29 Jul 2022 07:58:08 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:b47e:4ea2:2c6e:1224? ([2601:282:800:dc80:b47e:4ea2:2c6e:1224])
        by smtp.googlemail.com with ESMTPSA id x8-20020a05683000c800b00616d25dc933sm1251874oto.69.2022.07.29.07.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 07:58:08 -0700 (PDT)
Message-ID: <e00f3b23-7d9d-d8f1-646c-eaf843f744b5@gmail.com>
Date:   Fri, 29 Jul 2022 08:58:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH iproute-next v4 2/3] lib: Introduce ppp protocols
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, gnault@redhat.com
References: <20220729085035.535788-1-wojciech.drewek@intel.com>
 <20220729085035.535788-3-wojciech.drewek@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220729085035.535788-3-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/22 2:50 AM, Wojciech Drewek wrote:
> PPP protocol field uses different values than ethertype. Introduce
> utilities for translating PPP protocols from strings to values
> and vice versa. Use generic API from utils in order to get
> proto id and name.
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v4: ppp_defs.h removed
> ---
>  include/rt_names.h |  3 +++
>  lib/Makefile       |  2 +-
>  lib/ppp_proto.c    | 52 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 56 insertions(+), 1 deletion(-)
>  create mode 100644 lib/ppp_proto.c
> 

Ubuntu 20.04 with gcc 9.4 and clang 10.0 - both fail the same:

$ make

lib
    CC       ppp_proto.o
In file included from ppp_proto.c:9:
../include/uapi/linux/ppp_defs.h:151:5: error: unknown type name
‘__kernel_old_time_t’
  151 |     __kernel_old_time_t xmit_idle; /* time since last NP packet
sent */
      |     ^~~~~~~~~~~~~~~~~~~
../include/uapi/linux/ppp_defs.h:152:5: error: unknown type name
‘__kernel_old_time_t’
  152 |     __kernel_old_time_t recv_idle; /* time since last NP packet
received */
      |     ^~~~~~~~~~~~~~~~~~~
make[1]: *** [../config.mk:58: ppp_proto.o] Error 1
make: *** [Makefile:77: all] Error 2

