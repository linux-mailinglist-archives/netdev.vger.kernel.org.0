Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01134672F8
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 08:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379021AbhLCIAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 03:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350800AbhLCIAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 03:00:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE329C06173E;
        Thu,  2 Dec 2021 23:57:25 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t9so3901647wrx.7;
        Thu, 02 Dec 2021 23:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TNV9fHEzEZVf5RgXSWpjSpluBeliapHUf8v5v/Opj/M=;
        b=d479v+zTrj3yISM6DulHtlbK/6f1XE8uPSziNBqeHqTrIzyMVmqeBGsmMPJIwn59we
         4KyKd66AiXBIAR9e9t5CxIz4+7gFIABd1OmkrB2rQ6Irs+6jJK1jxv/kv06v6f4WTIJm
         XDzamESwdaeQIwZGurAqansl6jhiAR/TcznUVHy2q6MI9VFFo4yBL+VIE5bUTZqrTX+O
         Nkhk3lcrdZug9n412p5lGTq5DOM9RgmPWPrYYzhIndIi07rKPHjUEBNxbDlYS2LIrH9r
         EmZd+FUOMdJmi4j8T2366SL2KI0g405NTwFpCy+FyUX2FYcRqIIimB85wRHtEtGobMbI
         1DkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TNV9fHEzEZVf5RgXSWpjSpluBeliapHUf8v5v/Opj/M=;
        b=fETbjw4/hhQ50scII3XI0zuG03Ud6SVTFpUxLIyyI341171LvOVaMSWqnx1c4pAeYA
         fe+EbGafrnZ2whk+2+UOx4axju+NopYh8IeYOrJKBk7t8jrY4HbtzDlroxzzj9YnsNjR
         9eqlrwXYdFU5eVksyYzUgDBek989nW8hb3bWM0ZLtfWdRnNQNDh/a+7Jo0i8B9uGOUpi
         4NRVKYYHJw9R9tBleVNQ9zNpCbi9010+KPb7jEVr6v3RoNV1dYBXZ3yloTeb7qwsZtY9
         N9zXvI7HjyY2n/OWU0abHKkBCz+FKZfrjct3uPEkvagbl5dLhomEAFiO/5Fi69dWYdKj
         oF7w==
X-Gm-Message-State: AOAM530ZZZIRT117l8T2MMxQqMxc3PD+m9SJBVDs8ohLMjVQznBsJk/4
        RFvjk1Xb6y5DgFUXskI5zg0=
X-Google-Smtp-Source: ABdhPJxDUgqqn9c7zvg5vFxi97QijfcIxWHGUUCcGiAVUTbknSza8LEL7TbAB3i/SG3WAzWTUNJGtA==
X-Received: by 2002:a05:6000:1681:: with SMTP id y1mr20072720wrd.52.1638518244267;
        Thu, 02 Dec 2021 23:57:24 -0800 (PST)
Received: from debian64.daheim (p5b0d7b73.dip0.t-ipconnect.de. [91.13.123.115])
        by smtp.gmail.com with ESMTPSA id f19sm4928700wmq.34.2021.12.02.23.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 23:57:23 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1mt2UB-0003lm-9X;
        Fri, 03 Dec 2021 08:57:23 +0100
Message-ID: <32587626-0dd5-f8d1-5573-1088fd6b375a@gmail.com>
Date:   Fri, 3 Dec 2021 08:57:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] carl9170: Use the bitmap API when applicable
Content-Language: de-DE
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        chunkeey@googlemail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1fe18fb73f71d855043c40c83865ad539f326478.1638396221.git.christophe.jaillet@wanadoo.fr>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <1fe18fb73f71d855043c40c83865ad539f326478.1638396221.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2021 23:05, Christophe JAILLET wrote:
> Use 'bitmap_zalloc()' to simplify code, improve the semantic and avoid some
> open-coded arithmetic in allocator arguments.
> 
> Note, that this 'bitmap_zalloc()' divides by BITS_PER_LONG the amount of
> memory allocated.
> The 'roundup()' used to computed the number of needed long should have
> been a DIV_ROUND_UP.
> 
> 
> Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
> consistency.
> 
> Use 'bitmap_zero()' to avoid hand writing it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
