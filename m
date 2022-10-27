Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCAF60FCB6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiJ0QM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiJ0QMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:12:25 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B591814B9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:12:22 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id a5so1299505qkl.6
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L0bdTpcj+WbGFKk2v4mFRYypRLvTiL6KH7P5+kyi7Ow=;
        b=XD26mj8OaTKhebuTJZABAfddI72OUQI/DFz0Z1u8afltFDvDNUbG3ReUKYwKv0pFSr
         l9bdCjX3KuH7MZ+oQ6frQk0aXP7oPwngdl+Opuc/qKy3/Rh6+fmTsEVmlcxKs6uslxYW
         RkAMbyrYRQ89bcBDooedAV8l/0v4Jsjwfn+b8xrTFVV329QKc/HGHzbQUSutoSUGG+dN
         OCJrpQVQ/2AT5NkCe/Syiu/scgDZpz3yEvqwCrOOxMAuIwmFDMaD5TtAMXBheyspvB5f
         Gf5bIwmQN7F/SHzwL+zkv+oZGIdKRx9W9rGqeRzZxOepJLYIFYnQwqqYpUm3q7rlEv+t
         vT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L0bdTpcj+WbGFKk2v4mFRYypRLvTiL6KH7P5+kyi7Ow=;
        b=u8vyfxNQKVCbs8cntDwLW4XokwIwhKK3e23yxrxFFyxUp/eRCSVlXr0+gfGq4noolV
         RJLIEgum3hCdQCWayM7Bv1lwcOmULE2DoTr3Wg3g/qZJUI51Tx8eigQ7mPDnZ0Ql9qjk
         ZWr7Ywg/GwAUiEH7WQS24bGa66o3C64k5ghF9TI20KBfHgoL3SwoAY1vz6QKXWNxd7G4
         h8qIyP2gTDyCBLnBBm+OFAfrT/0SN7fHqG/VAAj73NuRXKiOIeNOrop9GfE95HcVmRbn
         k1SI9f7kpaXJWUSjOPbrG7jlb87MCtzZhoyf+fzNWqOiAU8ALzpWgjPW4D1EUwdtwMQF
         Mgpg==
X-Gm-Message-State: ACrzQf3qDQFG9JK0xLG7shJPwefQ6hK0+IM5EvYt6u4LjTVOSU0FLqHi
        eWJFvAEukc3vADsSZzv2MBU=
X-Google-Smtp-Source: AMsMyM5xGmmdoIeLv5uO4w/ZCmEOQcwpmAqUKwbgVJ3HvK4B+N34HOh6Mv9yTN5N6tJubpPuZhOoag==
X-Received: by 2002:a37:6945:0:b0:6f4:ae0f:648b with SMTP id e66-20020a376945000000b006f4ae0f648bmr16221747qkc.329.1666887141623;
        Thu, 27 Oct 2022 09:12:21 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id br7-20020a05622a1e0700b00399ad646794sm1067173qtb.41.2022.10.27.09.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 09:12:20 -0700 (PDT)
Message-ID: <087ad3a4-2be4-64ad-b5df-d0e31899ed1d@gmail.com>
Date:   Thu, 27 Oct 2022 09:12:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: update TX stats after actual
 transmission
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <20221027112430.8696-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221027112430.8696-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 10/27/2022 4:24 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Queueing packets doesn't guarantee their transmission. Update TX stats
> after hardware confirms consuming submitted data.
> 
> This also fixes a possible race and NULL dereference.
> bcm4908_enet_start_xmit() could try to access skb after freeing it in
> the bcm4908_enet_poll_tx().
> 
> Reported-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

To me this is 'net' material since it fixes a potential issue, but let's 
see what the netdev maintainers prefer.
-- 
Florian
