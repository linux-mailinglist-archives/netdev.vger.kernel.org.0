Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB039577746
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiGQQRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGQQRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:17:39 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B794BBF55;
        Sun, 17 Jul 2022 09:17:37 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z22so2077954lfu.7;
        Sun, 17 Jul 2022 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LVtaKxs7d9jWGW/ag4VeQH2lASOiSRK3darGXEw5b+U=;
        b=gedTpL2OT34yCe/KuASkLyO3C/L80JXn9+OEqfQ+pGkTpW9/Y2ACVLp6MQGZhEQxrN
         zK63Xc6ppPeUC42LbHqnVbKos2kVBh1pcE0c4t+FQFk+XL1dV9OP+SWPU586LraMUza5
         Yk72O6cuPD2WgMIh8NPsL3m8y6SLHufSB+f4UTQ4k1WXKJYV7QZp88lTFfnI0CKNDedv
         xPPFB13HySiOa0tOXAUfctc1UYtVGAVREHC/yzL6TmKxNiDcHect7/0oS58J5cWE0Q47
         bNNcNPz26nA4qkhXajcLIjYb7z3AUxjEC29HsImU5T8koNWEu5xq/rFzZaU2S2M135/7
         zB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LVtaKxs7d9jWGW/ag4VeQH2lASOiSRK3darGXEw5b+U=;
        b=jh4WKj0zsJfoJsFBzxVgIZdqCpxGvPWpDdZGgnYoX0e3moT2HnjK8dMdcaN1SejmXv
         nmtmvoUpasSbL7jTlY72ViObmnSNAcJ/6U5TTzf2K9JcjK6wA13eaMJL1zFzOE5FKIed
         dUmubLjWvAajYQj6RrpTY3oFpllqDW1ixX18/IIlIGJydokuZhdZnSZNLA7qc1wzKq9r
         ZVyWDwUzY87VDTKn25sD2et4wbQe4vENeT/kY+ukAplwQ/IhGvE3PhirdhQh2vGziUVP
         m519uMlPfiqV8arC7J4FoZGo4qiodZfS699f0OOkBkSKjeiziujcIHKmmzRCyeOLy/74
         6rsw==
X-Gm-Message-State: AJIora+l4uZnGzdJwQgTRLxhjy+xxTRQJaczfYxYYdB4HlwU8enWlLwW
        RzkhbNbAYm3b+HmiYLnkJ+0=
X-Google-Smtp-Source: AGRyM1usQ/hmPjYoBgRoc5730r0JGodxe2wwtcp8bDxVCiijxctBNh+Rbdu3DWbgJ+1LjgCBQ5w4Jw==
X-Received: by 2002:a05:6512:31cf:b0:489:da0d:df52 with SMTP id j15-20020a05651231cf00b00489da0ddf52mr12952240lfe.221.1658074655836;
        Sun, 17 Jul 2022 09:17:35 -0700 (PDT)
Received: from [192.168.1.11] ([46.235.67.63])
        by smtp.gmail.com with ESMTPSA id b17-20020a056512071100b0048a29c923e4sm1246402lfs.7.2022.07.17.09.17.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:17:35 -0700 (PDT)
Message-ID: <3ea0ea90-48bf-ce19-e014-9443d732e831@gmail.com>
Date:   Sun, 17 Jul 2022 19:17:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Bluetooth: hci_core: Use ERR_PTR instead of NULL
Content-Language: en-US
To:     Khalid Masum <khalid.masum.92@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
References: <20220717133759.8479-1-khalid.masum.92@gmail.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <20220717133759.8479-1-khalid.masum.92@gmail.com>
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

Hi Khalid,

Khalid Masum <khalid.masum.92@gmail.com> says:
> Failure of kzalloc to allocate memory is not reported. Return Error
> pointer to ENOMEM if memory allocation fails. This will increase
> readability and will make the function easier to use in future.
> 
> Signed-off-by: Khalid Masum <khalid.masum.92@gmail.com>
> ---

[snip]

> index a0f99baafd35..ea50767e02bf 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -2419,7 +2419,7 @@ struct hci_dev *hci_alloc_dev_priv(int sizeof_priv)
>   
>   	hdev = kzalloc(alloc_size, GFP_KERNEL);
>   	if (!hdev)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>   

This will break all callers of hci_alloc_dev(). All callers expect NULL 
in case of an error, so you will leave them with wrong pointer.

Also, allocation functionS return an error only in case of ENOMEM, so 
initial code is fine, IMO




Thanks,
--Pavel Skripkin
