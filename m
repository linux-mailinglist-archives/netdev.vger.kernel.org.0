Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5FE4900CA
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 05:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiAQEZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 23:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiAQEZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 23:25:30 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A9BC061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:25:30 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id f13so9754978plg.0
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 20:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ucTL3pQUJVn2+WtVeHKMYtUE6F9Gv7IZawA4eQ0/XIU=;
        b=J4FUC9q66FhVYYiftWthgvN2zvy61YSTtG2KPLv4UDKe7+x4+sZ9rj6VDOkPg2YE4S
         jK4d4OrPM82r3tMwWTS0aBR3+ncc239BRstPg4N7vhyfPVKsQBpWrhbgB0lf6qzTwVB5
         dYBjOIk3TkD/kiRUiZZS0Wnv68t9HzDZBPSkpWF1kCgaeNS+4avbHaOrF//T1tR8opjC
         StyOiIaouRpxRmPDhvLZrW6/cefUmjrqp9/DVPaZ+FavU/aOh84pbJJ03qyJY6nFDsU0
         ppTa5VrE2Bx6Acmlv3PG2rXk4mOHNkowS7dg0kswDkmpcUP4vCnE8EmgvJY5ZCGmHJR6
         Kv5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ucTL3pQUJVn2+WtVeHKMYtUE6F9Gv7IZawA4eQ0/XIU=;
        b=yPjkn0NZ9tqIgGheFd19b32mnw3AyXOepAOB1CPXORgFCadNqr1tZjHo5YyOD/k7lF
         q9S316crL2z8D0jYB8PkK3n3ne6zp82gDcfv2OriSAxERJ9Zu6KzpT1rjYd22G11KJxJ
         7DLFaLCcDkau6UzMo9BbdOkOyI16lXBwd7VQSiozjr8LerlBJE+NYph/3EGktSr/tUSr
         dJ4AcC6PlBaRxsn2DVrMFutuJG8IlgY02YQWwnK8ECP6EY1Rhr3Rj3uMHGKi2N0Hti5t
         RZ1snNsuHS2YwZ/QZYYpvn1MmwlbQHkCoz8KaGzE37ouLDWJETDQ+ZBluQNurpHQtAgi
         xnEg==
X-Gm-Message-State: AOAM530FElvWyWQyNctl4codyOiaekQCXr0DB40o1UD6FDMK/vyonTKc
        3HUR5H/J3jHvyT5P4fz/RcA=
X-Google-Smtp-Source: ABdhPJyoeyB/0ZVuKRwLTFmFV82f2hSF3ZUwPMPqKpjS/QOvzymeUMsFrm9e/4JGMRdoO0sI9O8aQQ==
X-Received: by 2002:a17:90a:2a03:: with SMTP id i3mr21528012pjd.30.1642393529599;
        Sun, 16 Jan 2022 20:25:29 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:10a9:f333:2ba1:b094? ([2600:8802:b00:4a48:10a9:f333:2ba1:b094])
        by smtp.gmail.com with ESMTPSA id o3sm10934545pjr.2.2022.01.16.20.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:25:29 -0800 (PST)
Message-ID: <ef3b02de-d745-e2cc-c7e3-2ad50badf288@gmail.com>
Date:   Sun, 16 Jan 2022 20:25:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 08/11] net: dsa: realtek: rtl8365mb: use
 GENMASK(n-1,0) instead of BIT(n)-1
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        frank-w@public-files.de
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-9-luizluca@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105031515.29276-9-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2022 7:15 PM, Luiz Angelo Daros de Luca wrote:
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
