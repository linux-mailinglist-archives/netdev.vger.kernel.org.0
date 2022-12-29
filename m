Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1317B658C2C
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 12:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiL2Lab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 06:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiL2Laa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 06:30:30 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934BD13DE4
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 03:30:29 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id jo4so44349846ejb.7
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 03:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d7Di4KWlgTsvfALVLvBYEKwJPzYGtyAmvIfnzJKyHKw=;
        b=jHbN+Ca6XjfD1wQB7BOno04KO6Cnwf3Zp48sfmyL4c4zkBURbfqJzhrT7FmNbAAvRw
         kiPCiajHGEtogEKYZFc2RToJ+rrb23mBCSAqGSfyGdfstHC0FsBFfIOcOcLIV8ymKZID
         Kz3BN97o8UM/lyoXr/y0xyer8/rERu4Z2XJUpyYIZZJBFVBxBq9lHOir/+JCzjTXTYUf
         UNDgxIlVkegSBrj4P6TTuKxL9Klj6PHnH+pjU+G2MbITHoxM6X/vbHhv4B6LNdZt+0TP
         tmayeqvengJ8DXtPD6KvYVVITImhkgKJh8HnJ2ODBlx3RSLUemNs0yPmD09cnLgYJzfH
         naTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d7Di4KWlgTsvfALVLvBYEKwJPzYGtyAmvIfnzJKyHKw=;
        b=ohk6yLHgLcwDoEQ5BbxITYEfON+QPZht6/xNez1iKyoFzNykQVw+l4GBB/Sj3pqhKw
         eaDPM+LQoSufDOe2rZqfA8PqfyVgC6XnaZjXaMpPJRmoKW/QzzhMUJ4g5nVCaxKoUKMr
         OYnGG8pIs/ulzUIGApJXYOyjN4c1XGRO3CwGeFyHICdzrYXPeyaTjZ9iYBYos2AbW86N
         9elmY3ThFSuwTVtRv9R9M12bTNSUeBnf5uATYnGSgtxEzNihqLPCdZ3X9vv5E1J1cRHw
         gnIni9WhDVU3if55k+oagmeBesMh3BS1Z4w2DfSmIDz32vOwR1KigZOVurOjvfEJDyVG
         EM4w==
X-Gm-Message-State: AFqh2kpIszCQxX7/l4BRkuYqTg8v4HgG5N7qcHQHbMpsOr7GEoWZrbb1
        qCGkQC+pWYDcJnGzf/SKpfI=
X-Google-Smtp-Source: AMrXdXvaHvikwC2W8BICx1ru9vEBioSkWQ/2OVA9hjOaENBOWrJzSrfx9u+c1VSlhiM1S1/55ZiqFw==
X-Received: by 2002:a17:906:76c9:b0:7c0:ee31:d8df with SMTP id q9-20020a17090676c900b007c0ee31d8dfmr22445109ejn.63.1672313427954;
        Thu, 29 Dec 2022 03:30:27 -0800 (PST)
Received: from ?IPV6:2a01:c22:6ef3:b900:c038:4050:3e29:3663? (dynamic-2a01-0c22-6ef3-b900-c038-4050-3e29-3663.c22.pool.telefonica.de. [2a01:c22:6ef3:b900:c038:4050:3e29:3663])
        by smtp.googlemail.com with ESMTPSA id k6-20020aa7d2c6000000b00467c3cbab6fsm8208953edr.77.2022.12.29.03.30.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 03:30:27 -0800 (PST)
Message-ID: <ca237edb-eda8-84cf-22d4-b841a06e3848@gmail.com>
Date:   Thu, 29 Dec 2022 12:30:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] r8169: disable ASPM in case of tx timeout
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1847c5aa-39ff-4574-b1c5-38ac5f16e594@gmail.com>
 <20221228140509.21b14e7b@hermes.local>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20221228140509.21b14e7b@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.12.2022 23:05, Stephen Hemminger wrote:
> On Wed, 28 Dec 2022 22:30:56 +0100
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> There are still single reports of systems where ASPM incompatibilities
>> cause tx timeouts. It's not clear whom to blame, so let's disable
>> ASPM in case of a tx timeout.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Wouldn't a log message be appropriate here.
> 
> 	netdev_WARN_ONCE(tp->dev, "ASPM disabled on Tx timeout\n");

Right, that's something I could add. Message will be printed only
if return code of pci_disable_link_state() indicates success.
And I'd use netdev_warn_once() instead of netdev_WARN_ONCE(),
because net core prints a stack trace already in case of tx timeout.
