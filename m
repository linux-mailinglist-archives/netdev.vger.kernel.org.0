Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2977865C21D
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 15:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbjACOig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 09:38:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238071AbjACOiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 09:38:19 -0500
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CF711C27;
        Tue,  3 Jan 2023 06:37:43 -0800 (PST)
Received: by mail-vk1-xa36.google.com with SMTP id i32so8744058vkr.12;
        Tue, 03 Jan 2023 06:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6zcaKdjHs/IOE4tOfaWhbeLsQns1sQhgnZYCw2R1ym8=;
        b=nZC5hpyefkKqFPCxNLXj4xdfqCcCUHARhke5VosBxauXt5iQGrV7rJJo8Pp4nUad/N
         ROye3eKw3XJXHhTWgbfjAJJmNnC9o0nWnnECJjTPWmMW4tMOl1oweto4c8UGihHmVAJ1
         Mtebvgup+p1fn39ILtMdqQACp9bydidNVDGeO+51iP1gYKi7dZPws+DPLWyEg2t1g8wT
         Gy0EPP5PXh6FT7mrHfTMuC2FjUMI9I5N2n24tnzByHTxSD4yCtcR+vjI0jPCLbnteq7/
         z4NWja17EZxTOuFsUQMohRlMur16Vihv8e3R9Z7gQDuh7P8c+hnYlzRYCv0tPb5YaukG
         g9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zcaKdjHs/IOE4tOfaWhbeLsQns1sQhgnZYCw2R1ym8=;
        b=4snmtWzTs+lqV5YFI3KqYmbwj/rMpV1pwsfIyinpTg9AiOzHXOQyPvtFC7DrgCdKlf
         GEy/mRuwURea4zDhHbkX5M2sqr0U2iFq6zJ1K0F95fedPp0dTfYGUoQvnZcWzEDeXpyy
         bhvpmqiSjAMEXuMZBhbDmpTcUJeIhwMxP4LOkVScs0GjjU0hFaK2Fzp0lm/Uyovmy/Zg
         rfyzJr9vEqyOeNyFl8bYr3rJ1jAV8GvhuUo6EHM0bVv+bPVRCS3mszf/E1HEX1opfwze
         7/KLzv4CbicX17eaANUggwswVn7TXYEwmNDKfkIY1UUWzC+mrJXjB6reJ0NDWfrtPGs8
         ZrBw==
X-Gm-Message-State: AFqh2kp29n6MPJJtqeWikGK9te8PqyBrMARNdMo1KRUmysln6PZ6+i1n
        rptGJkK0u0RKrEr+BzyggUQ=
X-Google-Smtp-Source: AMrXdXtZ+q7I7eiLP1KVRUe7C6iyesDHh/yaAx2btFMioOsT+Gkz1SvjJVmR+M6wXfduWSVwlGOaoQ==
X-Received: by 2002:ac5:c5d6:0:b0:3d5:8601:dac with SMTP id g22-20020ac5c5d6000000b003d586010dacmr10142535vkl.3.1672756662777;
        Tue, 03 Jan 2023 06:37:42 -0800 (PST)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a0bcd00b006e16dcf99c8sm22532454qki.71.2023.01.03.06.37.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 06:37:42 -0800 (PST)
Message-ID: <04c0adce-3850-aa73-6bad-a10973d83df3@gmail.com>
Date:   Tue, 3 Jan 2023 09:37:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: dpaa: Fix dtsec check for PCS availability
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Zigotzky <info@xenosoft.de>,
        linux-kernel@vger.kernel.org
References: <20230103065038.2174637-1-seanga2@gmail.com>
 <Y7PyStu4s79FAHWH@nanopsycho>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Y7PyStu4s79FAHWH@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/23 04:15, Jiri Pirko wrote:
> Tue, Jan 03, 2023 at 07:50:38AM CET, seanga2@gmail.com wrote:
>> We want to fail if the PCS is not available, not if it is available. Fix
> 
> It is odd to read plural maiestaticus in patch desctiption :) Better to
> stick with describing what code does wrong and then telling the codebase
> what to do.

Writing a kernel is a collaborative effort :)

>> this condition.
>>
>> Fixes: 5d93cfcf7360 ("net: dpaa: Convert to phylink")
>> Reported-by: Christian Zigotzky <info@xenosoft.de>
>> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> 
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

