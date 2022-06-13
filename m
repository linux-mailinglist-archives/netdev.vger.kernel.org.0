Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1E854A1A4
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 23:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343680AbiFMVkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 17:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbiFMVkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 17:40:31 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF9526DF;
        Mon, 13 Jun 2022 14:40:31 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id l192so2907819qke.13;
        Mon, 13 Jun 2022 14:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UlM+CjsQsvnlIzI7YJk0mgvDOIWQBkpMOR1+7OF1hHk=;
        b=VoS6foXu6pPH+uNF4FO1/2Kj2D0fU4up4Ag89DxC1cgBHdtd+xhTNGW8WiiUHNRRHR
         39ENvgeUZF4nSJeuOUXvuWJzCdV8dmcnk+eiyc0SpFjFWWwZnXYm2G2fVTd6f2OGAWvg
         FIoY30Z8Lfn1EDAcLkGei3+Xz2y1KQ0TlA18AorOPy6Mf+HCCMlVUMqlDZmtpT7xUa4U
         dZcKQ1ZTIHHj51akLGQn4LOMZQY0H20b3cdlocbSrgmS5Md26ArwyaGnZUz/uLsetRlS
         dDhYp66032OHqufLh/hI4ZOScAxP9g/t7rWSskpTy9KwHzMtMO2FETpm06RAdOOoqQac
         c5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UlM+CjsQsvnlIzI7YJk0mgvDOIWQBkpMOR1+7OF1hHk=;
        b=h6oFGlZNrCGl1hRgohndzaEE0li45RzgthwRD1d2uCOmOaraRVBpXA7ewtc/SGQpo8
         DTaevQbLbtKRxU5ZBkYNkeHRU3Fko7kO19ABKuEs50EGclu3zZ3WwtFxkdGtaBo9mfhE
         t32Rn6CC4gV0zJ3ET95qRsP4dsEF1htL2NQ9QRjtHhkHLccFLFFR1Y+bMkx2U25vv/bO
         tQUOeY4uWVNyyqNBD39sa02NMt/1kZaVgaVjbh0JxQ2ih72z+oAVtDeh1B1sImdQNSMu
         yFkSo3f8/8vFHJDg8D5ltKKgTotCX3Qg6YGTFgpDtpY0SFb3qz2wiyrtdFDBJBap8Pte
         ZF9Q==
X-Gm-Message-State: AOAM530S1ThlRpFhYuv8xYFgcBGNzWiRC3Fj0R/LZ6L7wUZJFlONIwp1
        FNB0k6yy6LePcejrsQw2LgE=
X-Google-Smtp-Source: ABdhPJwyEVaKmQX/qbSw6rap8a7P4wMumpVUdU6UeAYUevHyF5Ku6BkvK8tVjJLtP84AZRb0VGz3/Q==
X-Received: by 2002:a05:620a:22d3:b0:6a7:2202:62ba with SMTP id o19-20020a05620a22d300b006a7220262bamr1725887qki.148.1655156430164;
        Mon, 13 Jun 2022 14:40:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r145-20020a37a897000000b006a760640118sm7130943qke.27.2022.06.13.14.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 14:40:29 -0700 (PDT)
Message-ID: <d970c122-4b1b-d30e-8781-2227340b85c3@gmail.com>
Date:   Mon, 13 Jun 2022 14:39:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net: bgmac: Fix an erroneous kfree() in bgmac_remove()
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <a026153108dd21239036a032b95c25b5cece253b.1655153616.git.christophe.jaillet@wanadoo.fr>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <a026153108dd21239036a032b95c25b5cece253b.1655153616.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/13/22 13:53, Christophe JAILLET wrote:
> 'bgmac' is part of a managed resource allocated with bgmac_alloc(). It
> should not be freed explicitly.
> 
> Remove the erroneous kfree() from the .remove() function.
> 
> Fixes: 34a5102c3235 ("net: bgmac: allocate struct bgmac just once & don't copy it"
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
