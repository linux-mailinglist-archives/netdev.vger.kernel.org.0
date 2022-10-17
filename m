Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6DA601C06
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 00:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiJQWFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 18:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiJQWFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 18:05:09 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DE442D49;
        Mon, 17 Oct 2022 15:05:04 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id i9so8268812qvu.1;
        Mon, 17 Oct 2022 15:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DssZsc8JKMF1awEwlDsN4AMClu2uwwnMwqvekwDKbXA=;
        b=fIie9ryQuFmgjhfhmiwrF/oNoWaSTnsPmHFzuTHTaEIrYvl8ka95V74shLjhvojcCo
         V/YEEAgs5wPf6NanMZrNuhun8XKX0FJOB6jSP/1G4O43k6nfATg3LrWMU+tK3qYcfvTl
         17WtvVgW2dFIMtkzvExPEvQQftyjg6ZP09NEDsVJda00K4iWmqeV1L4wPIFacmJJSNMl
         bcuoM8kDyNrS5VnkSCzjbl/YLFPMT/qKFT0RqPWib15artkKggJiIN8Ky75OIKEpmgXk
         xmY8FIOKrT80ERb3N31xVsSq3LcsWkBVV8UcC3J5S52BRXzRjFZgmaDKpCQzzGd4C9U2
         nj/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DssZsc8JKMF1awEwlDsN4AMClu2uwwnMwqvekwDKbXA=;
        b=ZrVXVTtI3BVpkbBCFWnBDyPnWsRZiJ5UyQQox7brppqu8X4Mz8wngqijAgEZfX2q8L
         G1USo6Cfrs0CirbTMvCzmDOrUhCIH8CPaBXCAvGR1EA39TYoj6QNIVTHGr89BQHE6gwu
         oQ6mrHzA58hS3+bcFkQVnm/SrmtBLEn3NdrZtg9wNqTUA1HPOolL1v/0V4hwimN28Yb0
         HLDtPch0eUA3Yc8MRrwtkklOMg30D4fdQ5WvbEuR87lyukdM3GXHkcpa2z/u/XALRFs9
         j5iHwASdg8yYPf9Ur2Jb4EWPvl2RBDE2kjoFDF66JOrb0OzyMcajlDe3prjcWm6dBkA+
         3pxg==
X-Gm-Message-State: ACrzQf2V9UM9DDTAq57nSMygxjQ9Op4K1fSDO7zwHdkaJP9Gqx8lQtM7
        /zr7LrbzT8E4cpSuS9WUltk=
X-Google-Smtp-Source: AMsMyM5as1ayOW+Golkh1TQyc4CLOQs5dc/ylLjRk3XKO9VPgCzsYa0i8sI1Lq8rfgJoxV8tsum8vg==
X-Received: by 2002:a05:6214:5cc5:b0:4b3:ec9e:79d8 with SMTP id lk5-20020a0562145cc500b004b3ec9e79d8mr10067857qvb.61.1666044304032;
        Mon, 17 Oct 2022 15:05:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cj24-20020a05622a259800b00399fe4aac3esm666777qtb.50.2022.10.17.15.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 15:05:03 -0700 (PDT)
Message-ID: <d78a51ea-8244-6911-8944-c1bdd209b96f@gmail.com>
Date:   Mon, 17 Oct 2022 15:05:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: bcmgenet: add RX_CLS_LOC_ANY support
Content-Language: en-US
To:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221017213237.814861-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221017213237.814861-1-opendmb@gmail.com>
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

On 10/17/22 14:32, Doug Berger wrote:
> If a matching flow spec exists its current location is as good
> as ANY. If not add the new flow spec at the first available
> location.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
