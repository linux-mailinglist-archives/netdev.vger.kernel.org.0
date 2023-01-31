Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92106835EB
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 20:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjAaTA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 14:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbjAaTA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 14:00:58 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C1B7DA7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:00:57 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bk16so15154436wrb.11
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SIJaGfWdRfJxS6q3tqM9XAVlnh9n1n3wd/3LvQMSRzw=;
        b=xwxvFcqLjJnew4mehUfiyv8u7x+VWUXfIaTQKsctNUAlYKVitu7h+y1heXMnVflfpu
         2njIIom0UbXkff070SCR48N5rtVy++PskgVzUp+oH+1F0qu1K3ShSSTrDL6vfqFMiPNb
         JU3eDfersxU9ilvLJGRF4uPYgkVds/GKg1AWzatLcLF3D7rRz8zsE5AXb9JSFnyYxitb
         v8bKxvPqItlxibtHZf300LSKUUwy0asXifbcflE1opOXQdQAm0dkYS/Aqtnf4oLA3YuM
         ZhP/uUAkqJr2T5YrWIC6y38vcSWib9lvCdaewlkQz0ubMhdoKW5yC7ZGysX+fV0xqR1P
         811A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SIJaGfWdRfJxS6q3tqM9XAVlnh9n1n3wd/3LvQMSRzw=;
        b=csyQMu04sYQiEko9MLUEYoWIt0nVCMvxfZ23qe3tzJoRQFFJ1J2sOCXH+VdzfNzJbQ
         I37A9XHzvQeiqxKgT+azZ5ACYGnvwWGpjlcjDmuSEmRiXqH/+4CviR6xLkXKrE788YnH
         q/bwWJPi/AAMfHPPKhKoYNy12A3q/oZlOSiiUraK12mZmlMdFh9FR8FWe/kEd/RNW5ZP
         vhnlri6WSCpa1BdQCDV1sFAHF6qEhh2KjBCGFaLvpvc0Xr/O65gCT6TpzJ3+t8SIaLrC
         F5nnOg7Cb6MOUgOHVBZAdRGYLl1k+TtdtnbgrgiGCRWp5YdP+seAeJyMW9y+B5iuR3te
         KfwQ==
X-Gm-Message-State: AO0yUKUmwH1Gn8n9pq8xGYCkGtF1Sm06Ikj0GcKG3wpn9+d6BAqP7Poe
        FOepu/jet/hKjUQViHNCs8nWZg==
X-Google-Smtp-Source: AK7set9f6mNUbT120znKVF+/TqYuNPTA/VMgJurzT6zxsEMrQvrRXBuPBoLC7BtLBwvLCSqqBigRsw==
X-Received: by 2002:a05:6000:16c4:b0:2bf:95fb:e5b3 with SMTP id h4-20020a05600016c400b002bf95fbe5b3mr53119wrf.33.1675191655850;
        Tue, 31 Jan 2023 11:00:55 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id m13-20020a5d56cd000000b002bfd462d13asm14868075wrw.18.2023.01.31.11.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 11:00:55 -0800 (PST)
Message-ID: <a18751a0-f51b-0a3a-58ff-2062a9dc46fb@linaro.org>
Date:   Tue, 31 Jan 2023 20:00:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
Content-Language: en-US
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
References: <20230131043816.4525-1-steev@kali.org>
 <20230131043816.4525-3-steev@kali.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230131043816.4525-3-steev@kali.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/01/2023 05:38, Steev Klimaszewski wrote:
> Added regulators,GPIOs and changes required to power on/off wcn6855.
> Added support for firmware download for wcn6855.
> 
> This is based on commit d8f97da1b92d ("Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6750")

Drop. If that commit is merged, how is it useful to keep it in git
history forever?

Dependencies go to the cover letter or under ---.


Best regards,
Krzysztof

