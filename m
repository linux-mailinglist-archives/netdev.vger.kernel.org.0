Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67439554360
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 09:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiFVG0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 02:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiFVG0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 02:26:15 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE2F34661;
        Tue, 21 Jun 2022 23:26:14 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g186so15235413pgc.1;
        Tue, 21 Jun 2022 23:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=m/dwJ5GkvdRqF8i/FJCV6U5TfXaqqW4/+acx6XlqPIM=;
        b=So2bHRLns9H65VGHYIZ8HkBHDsTq0Cwej2+x8KGmget+zxwuKyca8q+0GVCWkxGoHB
         836eZwdbyHGbXkom0/WgcYn2hMMjdLXJqec+6UrXpbmsnZb1+f/9mw6ZPvhX/4SPyEYx
         oU2aTZdByX6wdK0nt1TarH5XsNexN2ubSB2Q8HU1QzfrVdw0FNXRWdhYP/8Ssa5OUyD9
         cindH6lB7Lq3cPgSuvKyhNgfE44mofHLQoe9S4KMT9CtBDdJ3eLSxmX9d18YMj+44odM
         aa+PnS5GxDzTBxSms/EJGzlxtmrINf1UJtplIJLBsbzIHRNE4aeFShTwFs4iV91hJSJm
         8t3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m/dwJ5GkvdRqF8i/FJCV6U5TfXaqqW4/+acx6XlqPIM=;
        b=yCzlmuFxtlf5yy4/OJLyQBD+nBcGJQXKKygQUsxiXj5pxWcWqiFSext/nu52NHR1LD
         mbWvmtwzuV5udgHnkCh/Ar5uhojihDFLb0aD5p1aZ0gTHPhOJbru9t3H3VA2FQwT/j0s
         z+O/zyBFpkAVFCc9okga/Zgt7J+h19+FjVPwI+MyiDz6b8X0Flx6Iv+QGMKA4cIrSuMs
         6gT06EeIlzGOPvLTGlCVErquaUT2XLBeHt8Bc0sOTmC2inmeN3v8d+vodewA/VHITfmb
         gHWHcFg2TjRLMPT3msB3DTv76UsRbiNLZAGjlfCJZzhMxAeP49xHUTDSFmy7abRJelcN
         oiVw==
X-Gm-Message-State: AJIora/I0RbXROMlZPD64OjsFFiF3hZCuTbKThcHFkYTNJHEEdabOnww
        XEQX4y4n0NgBxe+pI8gFlNQ01iG4vIU=
X-Google-Smtp-Source: AGRyM1uQOnQLLSMsKyssUP8Yz8gRrHGT43pevs3zv/a3Lx+/L8LkFkDyk2zefikgVn2vMtH8f4Dlnw==
X-Received: by 2002:a05:6a00:190e:b0:4f7:8813:b2cb with SMTP id y14-20020a056a00190e00b004f78813b2cbmr33894715pfi.54.1655879174334;
        Tue, 21 Jun 2022 23:26:14 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id js15-20020a17090b148f00b001ec9d45776bsm5932679pjb.42.2022.06.21.23.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 23:26:13 -0700 (PDT)
Message-ID: <c7986d32-384a-6bbd-39e2-27a537be9637@gmail.com>
Date:   Wed, 22 Jun 2022 15:26:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] amt: remove unnecessary (void*) conversions.
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Yu Zhe <yuzhe@nfschina.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com
References: <20220621021648.2544-1-yuzhe@nfschina.com>
 <20220621222607.75e66eec@kernel.org>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220621222607.75e66eec@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu Zhe,
Thanks a lot for your work!

On 6/22/22 14:26, Jakub Kicinski wrote:
> On Tue, 21 Jun 2022 10:16:48 +0800 Yu Zhe wrote:
>> remove unnecessary void* type castings.
>>
>> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> 
> Taehee, ack?  Your call.

Hi Jakub,

It looks good to me.
I tested this and It works well.

Thanks a lot!

Acked-by: Taehee Yoo <ap420073@gmail.com>
