Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3D825137E1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348890AbiD1PP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348662AbiD1PP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:15:27 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBEE58E43;
        Thu, 28 Apr 2022 08:12:12 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q23so7216109wra.1;
        Thu, 28 Apr 2022 08:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=14cOKhrtV85brj7EJLBSPT810oxXMK2MopA8VY0TkAU=;
        b=XNVeILtiAib62IlV9+ASi6ROQuq0V1RgDvo+BTgl9R2j8ImTJUBEta78pI220+qa4b
         kfTRgL1nCSqumleFcevxLe64m+Lob5jOe9QjzZI1MFlAzH4Ei1j7I0bCsIiqQ6sVRG0M
         rogLJDHRPIsqhsLLkEMJzf2k2u75j07hFWRYMsRp1S5kOvNmqieeHX6mTWL8WU3PoVi3
         INqKmk0SQ/s6I68FufchVowKEEVQySIe4wSuUMpcAHQEeFJVC8zv9keKewaxYzaKOFU6
         plrHq+f1TRZvNrkCJXlej4hBP4UfpTCQJKvvFRZqpWEPCkr26S/ZtHfhizdqsL41uw1b
         REBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=14cOKhrtV85brj7EJLBSPT810oxXMK2MopA8VY0TkAU=;
        b=TBkQQ41RHnYLukocPitx2JTYEKZ8kUGjJtlGsrU8hwlMuTTPy30qOWxumTNgdZ5lOr
         tNm98/YL4Vs3mDPLwgScnT/pTUjJesBhKr1PntH8sSdj99Sm2bSERf+utQPzZjUUolaK
         khSNmPqnw9z85EmgRHzwaQmjuQoNB6lMyij5mD2MqCJ827G3IIJ41Uwue61HNCXyLJ7W
         PQamN0yp90K2RDtuQ0XZymzGuuAOqOmETV9y0iM7/qOeORBgJ8Pxx7IRjhU5E3G3GfQi
         LpfyYeLa40UPd2leau9CIKaIkm0vj5eg+gBsdibz2hu257TK+cXdWzmMESxeRBcW7Qke
         sTCw==
X-Gm-Message-State: AOAM530HK8dlUkSlie41LjTUkalHE+QpXlV8D4VqZt/h/2o+tk9KAAGP
        Yb2SAW67xTYaoIn9NhKcRlf5sYLYUhk=
X-Google-Smtp-Source: ABdhPJx7BcDxW6K5fn1I5IvZtYhoPkhaODGuV2G8cTePkRYvKM5oW41UxIr1UJ6/aG3VNldx+MAtrA==
X-Received: by 2002:a5d:680a:0:b0:20a:e5ed:9b5e with SMTP id w10-20020a5d680a000000b0020ae5ed9b5emr11073431wru.110.1651158730785;
        Thu, 28 Apr 2022 08:12:10 -0700 (PDT)
Received: from [192.168.8.198] ([85.255.235.145])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc14b000000b0039419dfbb39sm506553wmi.33.2022.04.28.08.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 08:12:10 -0700 (PDT)
Message-ID: <790ca4e6-e0c0-b454-6a50-f2e907523dd9@gmail.com>
Date:   Thu, 28 Apr 2022 16:11:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next 02/11] udp/ipv6: refactor udpv6_sendmsg udplite
 checks
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
References: <cover.1651071843.git.asml.silence@gmail.com>
 <33dfdf2119c86e35062f783d405bedec2fde2b4c.1651071843.git.asml.silence@gmail.com>
 <229c169ccf8fdbf7fc826901982f1f15e86f3d17.camel@redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <229c169ccf8fdbf7fc826901982f1f15e86f3d17.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/22 15:09, Paolo Abeni wrote:
> On Thu, 2022-04-28 at 11:56 +0100, Pavel Begunkov wrote:
>> Don't save a IS_UDPLITE() result in advance but do when it's really
>> needed, so it doesn't store/load it from the stack. Same for resolving
>> the getfrag callback pointer.
> 
> It's quite unclear to me if this change brings really any performance
> benefit. The end results will depend a lot on the optimization
> performed by the compiler, and IMHO the code looks better before this
> modifications.

There is a lot of code and function calls between IS_UDPLITE() and
use sites, because of alias analysis the compiler will be forced
to call it early in the function and store something on stack.
I don't believe it will be able to keep in a register. But it's
not a problem to drop it

-- 
Pavel Begunkov
