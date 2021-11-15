Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F5544FFFB
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 09:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhKOId6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 03:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhKOId4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 03:33:56 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C07C061746;
        Mon, 15 Nov 2021 00:30:56 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id z8so33743164ljz.9;
        Mon, 15 Nov 2021 00:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QQ+tRnGMv7HCE8tWnOOxb60WEdKs2mEC1kY560cUZIc=;
        b=kal1w4vxwyqTIc3+EQZ9fx++Hhza9E8rptgelO8UtlTrjFAxtIqINF2mUDHvZUTKRu
         4R5do/lLz5ihmzWLAlM2QzhsYVNo6+OuQs8Y1PaDIijqoMVFpwXaPVtONroDEJez3PdW
         zggeo81bghaayjMTcpa2YBV8U98u9ny+N385gHlQoJg7EOWO3S88GtCNK6McwsuzJbHE
         tIxAhCbIMOSGJUy2DWoPuy9fToeyClQKGf+QeVEJT3A5joHGsiKPQGHQkmWEudueZJwq
         cS5OdYNtI1GCa+TDedyLeoonSzARKTlo89TPn7QgH07i2S9XI89PlFR0evv/Wp1TbZCk
         Humw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QQ+tRnGMv7HCE8tWnOOxb60WEdKs2mEC1kY560cUZIc=;
        b=1uf7fzKbw3zd7BaXeiZRsLxFbcZ5djvahFOzYzEWxNxzBOh9Rw0vvVqS52cjOR9LFV
         vuV3BHPIeFgs1jCQ9ezjSOiAFLoR2DqQK5EumqCPy5DDC07h6wFw++hxOjhwZjvVJe1P
         7xV11pCMsiztFe8+UF+5Qm2xFabwnZyt+jEdRj2O8fUQm6vYtyV25PL6bAcYc9e4PBB8
         0Mio/yd5p10HbwhfrOdZTFhmeGOPW4o7KQ853DWuSHUSfVrfBGgjo489TXHvxrt6B0RI
         ZBPDZn11WYNNgjtlRotOHKHAK3s5cdHvQv/wWl6Cqw2mml8UuH9PJsC0UC5DnZF/r4Jz
         aPAg==
X-Gm-Message-State: AOAM530RLHib5u/amVBXq0JNE27jyd7vGLyocHDMlY2B0VmbqTaP1fgP
        BVW+WYmqmZBmfkIfQd+ulg/FrLgBWBA=
X-Google-Smtp-Source: ABdhPJyXpogCQSJ8M5IwEkKXOzIFkcg2itll7gpYGdqO02lwiXj6KcJQpgFYG2bUPGaja1S2c7rMMw==
X-Received: by 2002:a2e:890d:: with SMTP id d13mr36341168lji.396.1636965055101;
        Mon, 15 Nov 2021 00:30:55 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id a6sm1344734lfs.115.2021.11.15.00.30.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 00:30:54 -0800 (PST)
Message-ID: <e91eb5b1-295e-1a21-d153-5e0fa52b2ffe@gmail.com>
Date:   Mon, 15 Nov 2021 11:30:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] can: etas_es58x: fix error handling
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>
Cc:     mailhol.vincent@wanadoo.fr, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAMZ6Rq+orfUuUCCgeWyGc7P0vp3t-yjf_g9H=Jhk43f1zXGfDQ@mail.gmail.com>
 <20211115075124.17713-1-paskripkin@gmail.com>
 <YZIWT9ATzN611n43@hovoldconsulting.com>
 <7a98b159-f9bf-c0dd-f244-aec6c9a7dcaa@gmail.com>
 <YZIXdnFQcDcC2QvE@hovoldconsulting.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <YZIXdnFQcDcC2QvE@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/21 11:16, Johan Hovold wrote:
> On Mon, Nov 15, 2021 at 11:15:07AM +0300, Pavel Skripkin wrote:
>> On 11/15/21 11:11, Johan Hovold wrote:
>> > Just a drive-by comment:
>> > 
>> > Are you sure about this move of the netdev[channel_idx] initialisation?
>> > What happens if the registered can device is opened before you
>> > initialise the pointer? NULL-deref in es58x_send_msg()?
>> > 
>> > You generally want the driver data fully initialised before you register
>> > the device so this looks broken.
>> > 
>> > And either way it is arguably an unrelated change that should go in a
>> > separate patch explaining why it is needed and safe.
>> > 
>> 
>> 
>> It was suggested by Vincent who is the maintainer of this driver [1].
> 
> Yeah, I saw that, but that doesn't necessarily mean it is correct.
> 
> You're still responsible for the changes you make and need to be able to
> argue why they are correct.
> 

Sure! I should have check it before sending v2 :( My bad, sorry. I see 
now, that there is possible calltrace which can hit NULL defer.

One thing I am wondering about is why in some code parts there are 
validation checks for es58x_dev->netdev[i] and in others they are missing.

Anyway, it's completely out of scope of current patch, I am going to 
resend v1 with fixed Fixes tag. Thank you for review!





With regards,
Pavel Skripkin
