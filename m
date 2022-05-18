Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279FF52C4C1
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242685AbiERUue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242665AbiERUud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:50:33 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EAB16328A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:50:32 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w200so3202871pfc.10
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W2FpeQBcw8y3RImXNc67GOhTjf3q/P5qNmbw2uYCbiA=;
        b=OHamEYQ5Et8AFPG4kdUOMCl5LHQDBG1tGYkHK6KUQZcOJBW/eaMi8RzUVHXJKOeByg
         RkcjyaC9OrKv1syZooUiJZ+2XYkHHCg88Z5MCaNlCS258VFR5mgIX6EO3LMhA+UdVpXk
         hw0QMRb8HlWRDLotZZhVIiCZtgZMiZnHhbl2nBn1qlHhGt4ixg/amJi7agIZvSawVkK/
         r+X6htdyLsLywEpZlhR9AtjSTt0cLFibTqgQwf92Em8dfzKnT2py5ZKheEkW1/7UUL2O
         0u9SirubUM92tzQ0lWhwGUoKJggj3FrZXZCygow8D+6D+ONWuZCSEGxYskVApR3pY7MN
         kmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W2FpeQBcw8y3RImXNc67GOhTjf3q/P5qNmbw2uYCbiA=;
        b=esEftGECceElS4JDjEfBrMUJ5hJQTilFoDbHlF3ELJE5EqK7LaBCpWZyxADHcN/lq5
         xfavJ23KOF5SAI+xvrQqvVJxqUncQyC9I7+UznrHWoVm5RLYIza0JeVpgqKFRbc1IVBy
         pkmpmhT0v/b/mLtfkeyrx5Td2KelWz8lZi7NtRQCitnHUDz1JhoA5D6uO2MABj4fm3am
         CcnftYs3I4F/CqzYO6zIu7hQ8opDKYOuOIbCpjtsdH5eB+gdkQtR3nknsnNkWQt+43Qt
         VA8tl51Lu5Ir1tTOph1aIZxYDvwZ81dis4VUEXm1DhtzJBl7L4s0KMPZk+bkkH1fcpTO
         nuBg==
X-Gm-Message-State: AOAM530/iVkTANGDLxnRlCBYJvCF4wb9ybzT+jUKSvf/ftprnuQXGQ6V
        LQAgETZ6/UzyYBvjHueNS3E=
X-Google-Smtp-Source: ABdhPJyN81t9yiY/dUyHxJNXAuB/hh2JdpdvfIv7uAz2YyAhXh0fvk6p2HhtedexwGLS7aJEAJ3yag==
X-Received: by 2002:a63:2cc3:0:b0:3db:5e24:67fa with SMTP id s186-20020a632cc3000000b003db5e2467famr1077774pgs.46.1652907032417;
        Wed, 18 May 2022 13:50:32 -0700 (PDT)
Received: from [100.127.84.93] ([2620:10d:c090:400::4:4b54])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902eac300b0015e8d4eb2b9sm2150870pld.259.2022.05.18.13.50.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 May 2022 13:50:31 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        kernel-team@fb.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, lasse@timebeat.app,
        clk@fb.com
Subject: Re: [PATCH net-next v4 0/2] Broadcom PTP PHY support
Date:   Wed, 18 May 2022 13:50:29 -0700
X-Mailer: MailMate (1.14r5852)
Message-ID: <8C6FF7E7-83AF-403D-A79D-10F5C0E92FB8@gmail.com>
In-Reply-To: <d58a9e3b-b492-8a56-964a-e9599cfe3009@gmail.com>
References: <20220506224210.1425817-1-jonathan.lemon@gmail.com>
 <d58a9e3b-b492-8a56-964a-e9599cfe3009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18 May 2022, at 13:14, Florian Fainelli wrote:

> On 5/6/2022 3:42 PM, Jonathan Lemon wrote:
>> This adds PTP support for the Broadcom PHY BCM54210E (and the
>> specific variant BCM54213PE that the rpi-5.15 branch uses).
>>
>> This has only been tested on the RPI CM4, which has one port.
>>
>> There are other Broadcom chips which may benefit from using the
>> same framework here, although with different register sets.
>
> Jonathan, any chance you could repost this before net-next closes? Thanks

Sure, let me rebuild today and submit.
—
Jonathan
