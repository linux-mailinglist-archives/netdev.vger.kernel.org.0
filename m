Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D624C5FC5FA
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 15:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJLNKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 09:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJLNKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 09:10:38 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C255422B1B;
        Wed, 12 Oct 2022 06:10:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r13so26142901wrj.11;
        Wed, 12 Oct 2022 06:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ek9VkJ83quJtUtnSAvpPVFNwZimiNL61Oc75DRl7mjQ=;
        b=kE6KkQ5D5U5QHf3HKPbSFIOJNTg360tYiAXhJjwvKPj+HTVAUoCKGrqebgQIeAEwk0
         ZzbCGYllAFLMBsters68mKXJYh8DnRvF5+6AOln7I7XUO/ISyOTIr6aKkyrDZv4YuZvh
         ec1PnuxxsMZqi1yarFUs9ctI6asVwdBVFyQfbrZLh24Jj/7wZI3NabOYADM4qBbhj+/H
         rygWdyEmy+SPVyTpyDWY8zakQql/DWSjkyDsGsBWHpz+fMFJK4Q2kinGRd4GAE7ROz6o
         WMvVPtgfx/t9pzJNL4wPjsk4r2HHOxhiMLxuQy5eyYUePRCreVDopllQh9aaeMoDR0at
         9sUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ek9VkJ83quJtUtnSAvpPVFNwZimiNL61Oc75DRl7mjQ=;
        b=A7GL7tElhGXnJTJrftUpDTLj4yf2E1mopE6HWF6YeNNHRt0e+cwzub2zjmABRukxnF
         8hxZcdPbg7gJhEQiyibF7NJjR8o0O4zerdIOKYR9oqUh6qUkOyhejliT8tJv4v9PNorB
         VcN6hQ0I8XiDl9VpV2fCOeAs6lIfGZbfFIIYjE0q5xwnAxtGeegtH5KHgnYG8Hj34TJp
         VhzG0PSvRHHM85rxkP9X+OJ/IoHelSGL8g0LItY25SuVGB10/emDHWIatzRxTgZMPwgF
         ETE5vAvjFxLmifTiC6kvcnK8rKS0kZapUKLNS5O5SfrYArEkyQovsWq60vC7d0iII2T0
         2Ezw==
X-Gm-Message-State: ACrzQf3DL0y14O/H+Z0U3jEuGJ1DlUng3JHoalI6eDzLNQTP2TlKXcYD
        Zb0FiLs3x8wlOxAks1TtjQQ=
X-Google-Smtp-Source: AMsMyM6Ezkylv26MEOzvYnklx7hcQAX4Q1CGcE9Wnn/aLcn79zEse5AsnR4e7c452HNbdCg5yIsA7Q==
X-Received: by 2002:adf:9dd0:0:b0:22c:d6cc:b387 with SMTP id q16-20020adf9dd0000000b0022cd6ccb387mr19196687wre.353.1665580235258;
        Wed, 12 Oct 2022 06:10:35 -0700 (PDT)
Received: from [192.168.0.209] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id bp4-20020a5d5a84000000b00231893bfdc7sm3820340wrb.2.2022.10.12.06.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 06:10:34 -0700 (PDT)
Message-ID: <11ea25ad-0ad9-7d34-de3f-09ca7d9c4ee2@gmail.com>
Date:   Wed, 12 Oct 2022 14:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
Subject: rtlwifi: missing return value in
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with cppcheck has found an issue with a function that 
returns an int value but there is a code path that does not return a 
value causing undefined behaviour:

Source: drivers/net/wireless/realtek/rtlwifi/usb.c function 
_rtl_rx_get_padding - introduced by commit:

commit 354d0f3c40fb40193213e40f3177ff528798ca8d
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Wed Sep 25 12:57:47 2013 -0500

     rtlwifi: Fix smatch warnings in usb.c

The issue occurs when NET_IP_ALIGN is zero and when len >= sizeof(*hdr), 
then the following return is *not* taken:

	/* make function no-op when possible */
         if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
                 return 0

and then execution reaches the end of the function where no return value 
is returned because the #if NET_IP_ALIGN != 0 is false so the return 
padding hunk of the code is not compiled in.

Colin
