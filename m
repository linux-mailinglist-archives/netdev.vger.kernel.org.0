Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FCD576617
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiGORdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 13:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiGORdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 13:33:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3CF83F31
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:33:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q9so7641173wrd.8
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 10:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r/j/m+wyr307kXy5lDQqkPdMiEPAS3CHEBDizNY4AHg=;
        b=hF39XAP/v2azVgo6MzG6JSpJCFT2cNv3ocE0sQhzJ6wi5bTN2YWutgSYJRo1r6+ihw
         TCrrPAMy0ldc2yta6wuzwuQL9koG8Xyz/MDauuQvlITNLfk5czZTMpR3w2RAHrJe0OZJ
         tQC9nO7BwIX/eRzKSap1/0MbStIP2cxCiqXIRImn2sCOCY2hmFbLZ9lNjkMfTvN8mGwC
         ErlAhEy2Cg2pYMEYQF0R3bM97H93L7QpP0bTcIhaMnMYTSwWKrnIq6aiIr4smINbxUSZ
         eeLbjseeIxg5wQfLOCfD57arQihWp/WCU8AyOhSR2HZlyHlJ8uUMZgWOfNdK9SokpPHu
         2REg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r/j/m+wyr307kXy5lDQqkPdMiEPAS3CHEBDizNY4AHg=;
        b=g1sW3F6nPyNg5DD0Nd824qmZj6KncLcDfbzrJSy4vPhKajY3QzbeZ5ggEJDsBzdH70
         8tb7fAxJ5OamBHmMR+XNNxL/RsXB8+NulyZ03LX9KWyBWYQ7b4E8pVq4AQoXHr26R4Bw
         dIYL3UItNYy9s9cT8A1XiK7lA40D31PSZoK3fA6OkPB0TxUGePbap2oKWhZDSO9RFUZw
         g19Mh5RWSkmbzZcDua0gQ1xXEhBNM1f7QLF4v+PU4L8V2jzcXmqN8xXWbkCzgewkPnHm
         kuqx1w3S8Kkek651ymFmpPrSOvLjGECxIx9thheMrar4JkWq2+F5YNTGlYejAp1Ds6oX
         BUrQ==
X-Gm-Message-State: AJIora9I4j6eYwBlRTmXtaKKxq8heU1rTsgDXkiPy9ifnU0/2D/+a7lH
        EZapvSTXBpgyGvQmzPGYxQJ6kg==
X-Google-Smtp-Source: AGRyM1tcFyG5FnrA5P4VLrG8T8mmfCFyZQh3fzCp4bSeGshwogoDUfjmIcAU8JcmIOxcGpClhVr/5A==
X-Received: by 2002:a5d:4c91:0:b0:21d:8293:66dc with SMTP id z17-20020a5d4c91000000b0021d829366dcmr14512376wrs.30.1657906400259;
        Fri, 15 Jul 2022 10:33:20 -0700 (PDT)
Received: from [10.35.4.171] ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id y16-20020adfe6d0000000b00213ba3384aesm4260976wrm.35.2022.07.15.10.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jul 2022 10:33:19 -0700 (PDT)
Message-ID: <9b37e02f-137f-2f93-43b9-eb5bb9814e97@sifive.com>
Date:   Fri, 15 Jul 2022 18:33:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] net: macb: fixup sparse warnings on __be16 ports
Content-Language: en-GB
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Sudip Mukherjee <sudip.mukherjee@sifive.com>,
        Jude Onyenegecha <jude.onyenegecha@sifive.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220714084305.209425-1-ben.dooks@sifive.com>
 <20220714164336.0f2768a2@kernel.org>
From:   Ben Dooks <ben.dooks@sifive.com>
In-Reply-To: <20220714164336.0f2768a2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2022 00:43, Jakub Kicinski wrote:
> On Thu, 14 Jul 2022 09:43:05 +0100 Ben Dooks wrote:
>> -			htons(fs->h_u.tcp_ip4_spec.psrc), htons(fs->h_u.tcp_ip4_spec.pdst));
>> +		        be16_to_cpu(fs->h_u.tcp_ip4_spec.psrc),
>> +		        be16_to_cpu(fs->h_u.tcp_ip4_spec.pdst));
> 
> There are some spaces on this line, please use tabs,
> checkpatch will be able to help you validate.

Thank you, didn't spot an issue with my editor config.
Sent v2 patch
