Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE354ADD76
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351976AbiBHPth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239907AbiBHPtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:49:36 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779A9C061578;
        Tue,  8 Feb 2022 07:49:35 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id z20so25077365ljo.6;
        Tue, 08 Feb 2022 07:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jKPmnUC6L/CUlDp8szM1YCCjQLDW+YvcV/DqXbymrLg=;
        b=f2WRHXLNfJOh7sW/V4/7apwC9vEcqbQDCu5ThTHxAjbf0FymsK82Q4rw6gMCGa01gN
         4xx/vbgf9yXx/k8BdfUkiUmlj5xJNFXdxj5q88rAbeuogtTBS346YPJA3qm+bMj+10+Z
         f6SKGWmzAP5T1w/mDDMDJF1DmH/TQWBkMUZPesR9oqq7pjT0N8jmBvNpKe1UYmdPL1o7
         XActh5t9D1lYngjG3RUaGgnbEtOaerM7QqSxam3phY2cZA0ndAI+5kV7lK376CJrYFCi
         vQH9B2H88FpNZ4/GcRQBFqk5uzlxoBl1lXY1CzwkB62EdAMCqO0Xy/gSYDWFgWTcBj6+
         uIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jKPmnUC6L/CUlDp8szM1YCCjQLDW+YvcV/DqXbymrLg=;
        b=6FY9TNnMU+bUADO5mDVXJ9vAlmdCPhlO0Ho+UewK4hL8vuArb6vYyF1uSSmwOBD0cA
         2ltCVF0HxK0HbC8COHEjp6xFaSKWMFU9C0cMObpVjXt6E0MQMfxHa3AxC42sYfGRhFAd
         ig0TpfT2uUSSVgdNGOAcpqke6mRw2jORSXMi+s7bcywUKC0odfu0j4N8qK5A6jTy50lG
         JZbWQ3JkrQZPKwK/THVBgiSsC1SYEBAiAufo9gfeeMnm+SJcjLAlZl91p6q35q3OAaO9
         etbcdgQn3aLrA6KYNR+p7Zf8Xzvi76COu+q62+206pUkzW6QrBTmSYYBrB/Vev3XVZ5V
         baBg==
X-Gm-Message-State: AOAM532XioYVTJvmsJp2agnrZtVClhAhTauqy4UIfVD4TayIqxC1mBp9
        vy5vMXcsYYFM3takcyRDWFY=
X-Google-Smtp-Source: ABdhPJw9LiyrQQ/0AXcRsE2Qr2EzS8Azw2M1dHgg7XpBuggCxJhcctze5CShZpEVzzzPswRmRv3TDg==
X-Received: by 2002:a2e:8495:: with SMTP id b21mr3126317ljh.89.1644335373825;
        Tue, 08 Feb 2022 07:49:33 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.201])
        by smtp.gmail.com with ESMTPSA id v7sm2018844ljv.68.2022.02.08.07.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 07:49:33 -0800 (PST)
Message-ID: <61f00e3c-06ea-20a6-4b76-2bddf986f074@gmail.com>
Date:   Tue, 8 Feb 2022 18:49:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 2/2] ath9k: htc: clean up *STAT_* macros
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        ath9k-devel@qca.qualcomm.com, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <28c83b99b8fea0115ad7fbda7cc93a86468ec50d.1644265120.git.paskripkin@gmail.com>
 <258ac12b-9ca3-9b24-30df-148f9df51582@quicinc.com> <87ee4d9xxe.fsf@toke.dk>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <87ee4d9xxe.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On 2/8/22 18:32, Toke Høiland-Jørgensen wrote:
>> It seems that these macros (both the original and the new) aren't 
>> following the guidance from the Coding Style which tells us under 
>> "Things to avoid when using macros" that we should avoid "macros that 
>> depend on having a local variable with a magic name". Wouldn't these 
>> macros be "better" is they included the hif_dev/priv as arguments rather 
>> than being "magic"?
> 
> Hmm, yeah, that's a good point; looks like the non-HTC ath9k stats
> macros have already been converted to take the container as a parameter,
> so taking this opportunity to fix these macros is not a bad idea. While
> we're at it, let's switch to the do{} while(0) syntax the other macros
> are using instead of that weird usage of ?:. And there's not really any
> reason for the duplication between ADD/INC either. So I'm thinking
> something like:
> 
> #define __STAT_SAVE(_priv, _member, _n) do { if (_priv) (_priv)->_member += (_n); } while(0)
> 
> #define TX_STAT_ADD(_priv, _c, _a) __STAT_SAVE(_priv, debug.tx_stats._c, _a)
> #define TX_STAT_INC(_priv, _c) TX_STAT_ADD(_priv, _c, 1)
> 

Good point, thank you. Will redo these macros in v4


With regards,
Pavel Skripkin
