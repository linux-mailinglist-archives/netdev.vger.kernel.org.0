Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7253359E798
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245050AbiHWQhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244812AbiHWQhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:37:07 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E087D8E24;
        Tue, 23 Aug 2022 07:45:19 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id sd33so6553796ejc.8;
        Tue, 23 Aug 2022 07:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=PZ5m+k6B5YpUHHcwQLGup/SYaFkGlGf+jzFdRUX/fG8=;
        b=baEOqFgNSVvs8MlfO5CupK9gJ3bJ0PxrrYky6ITqJ4DxTkmzgwCIzaw6vnFphQ4LQ4
         7p3/o7miOj2HWJm9DiYrb4gwtimZURw6hrwbtS8MjE7hsubu/m/yU6lHqrKsAtBra4D3
         odGjU6ZztSdbqIp9cJRrOPX2AiY3j/2RbYqLlJd/96QeLR3jTY+TM+s2eZ96+Lr+PTHU
         ayKBYVG7tV0DM5ZclpCCVkJpboywGve0nnYYAl1+3b181cW4yggunNrAQwuSz1LFH4Pf
         R10AH5AOlTR4RcV/uhiwlPpXcPa8Ym7u6BJonUxk/RFw/OmNq8kA0evV19VuAC9xFFSq
         GeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=PZ5m+k6B5YpUHHcwQLGup/SYaFkGlGf+jzFdRUX/fG8=;
        b=6aIV5daQYmE++gaDdNPcWdnlW4Dv6GWosDGRgooHFTPva+3QhXMIRAuCUfxURw0yBo
         ySZAbwRJR4+3b0XhcgMlg9lxAHo6TQiwQkbproVXdOCfUaJ4IUoA1tm+CqEbAWAH5ArU
         dCmun/vex6kox4nyapja//b62P1fH4NBpGZaSQcz024lmGa+wTUi9S6yfjmgjEJPPUeb
         kDPc//+sdRiaXVAu8eso1udNOPqWLoLjpzZPA98yzc1+Cqre21hVWA5q6JZnPX7ItleI
         lLEHNtYcN+4o9Za0gDO8dTeucd9EXl322t9nC+cR5vudLjQJle/wlcrdB/I5m/QjuHqi
         PBNw==
X-Gm-Message-State: ACgBeo1UAq6EvZHQQMPFSDP9PBaRCEMVktV73UpPXUAlTo8/4G61KxO4
        NjyA1nROTC1jKcfQzjvn3IE=
X-Google-Smtp-Source: AA6agR42/cMoZsbKpueyZTJXUy+J6e3t8HQp+OnDR8JqyGASO7jH4lLv0/5emULABnpmW/qLvcnoqw==
X-Received: by 2002:a17:906:478d:b0:73d:8ba3:d999 with SMTP id cw13-20020a170906478d00b0073d8ba3d999mr5365517ejc.77.1661265918186;
        Tue, 23 Aug 2022 07:45:18 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa? ([2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa])
        by smtp.gmail.com with ESMTPSA id kz22-20020a17090777d600b0073cc17cdb92sm6569354ejc.106.2022.08.23.07.45.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 07:45:17 -0700 (PDT)
Message-ID: <b1ef1422-ec84-0e36-8c85-d7d24642d9f2@gmail.com>
Date:   Tue, 23 Aug 2022 17:45:15 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 23/31] net/tcp: Add getsockopt(TCP_AO_GET)
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-24-dima@arista.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <20220818170005.747015-24-dima@arista.com>
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

On 8/18/22 19:59, Dmitry Safonov wrote:
> Introduce getsockopt() that let user get TCP-AO keys and their
> properties from a socket. A user can provide a filter to match
> a specific key to be dumped or TCP_AO_GET_ALL flag may be used to dump
> all keys in one syscall.

No equivalent for this exists for TCP_MD5SIG or my TCP_AUTHOPT series. I 
do however have a proc file to dump all keys in the system.

The list of keys is normally fully controlled by a single application so 
it shouldn't need to read back the keys that it wrote itself. The real 
reason this exists is because on the server side keys are copied on 
"synack" rather than "accept" and userspace can't know if a newly 
accepted socket has all the latest keychain updates.

This effectively dumps responsibility for a kernel implementation race 
onto userspace. At least you should mention how it's meant to be used in 
the commit message, and that it's not really optional.

I think making keys global is easier for userspace to use, despite the 
difference versus TCP_MD5.

--
Regards,
Leonard
