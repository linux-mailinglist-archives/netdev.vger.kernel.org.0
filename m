Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7982A6BEE72
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCQQgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjCQQgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:36:51 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40733D09B;
        Fri, 17 Mar 2023 09:36:46 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 97so3808615qvb.6;
        Fri, 17 Mar 2023 09:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679071006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4xX+EO6rXZGHeC6KXkQ7xjZWyXpk7rdx3ZD87mgVlRk=;
        b=o84Y5Nl+dcUA/KPNvm9AQTB3k4+jO50VM34n3lpGTB3vcN61EOa6Tds/FgOwqHis8n
         JzOGI6Sjt/IJ50LiUfJHwJ1aebdb3SfiaTAi9TiDud4vr1wQZh2vJHR/q5NW9WBBsxEW
         82gR8DGnqyeur3vV47EklAIeg05vJFkeEZ3gq6mkDqLt+otnwy552UsucC4NcBYbU3Kr
         EImnq2zrt947k89Tb7IObglVZclOiE+61zUuDIVhuA9komL/f8KNGHStMZLTfU0TUFWp
         AcXQCaQq4Q3UUQvyEYwG6wHEy8ID0uzQyYYR4r211ri/OpPjs3VC0VJ09fC+n+pLvlXq
         FZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4xX+EO6rXZGHeC6KXkQ7xjZWyXpk7rdx3ZD87mgVlRk=;
        b=7eio0oRPsGveWBd65BT8/GASxazEC+xWl/H4KXBlHxC2k/2Zi2jIUwwEzntw/C8Q9P
         BclPtQ3QWN31FHavKLi57uTJ3+7nlCHejNPo0KRh583LAz3Dc3tOAZGELKBewj6PTkGg
         N1SsCm6LwOS0ocwCz3SUjX60J5vt+CbIX2U/2c80eI/06psdH8M4PthQjbFJPBPS7myF
         IYDMB09qBlIEXnWBZVue6cWipKD39p9RnYl4k6MrTk4GQnfnoqpv193O2M0areVEzsrQ
         GMwVI/kIyFXouuFVmXpiGZDZv0TtgLx1ai18Svae0iS9GDxovkl2vj+cKENYFmQ3eZHD
         NfXg==
X-Gm-Message-State: AO0yUKUwhAxUt5H+isE5GtW1K7gdB6ne+0TUVFvf75xjlObjjPsuGcDG
        sKlFYIKlyPFxaw25I0YOBXfzr//PXvI=
X-Google-Smtp-Source: AK7set+A319Cvfk4veJMBPDm9PoDR1x5qXDSqO5nS8ADcITnIq4UPK+a6mGMJDwfaa2MjuBJKgHarA==
X-Received: by 2002:a05:6214:2406:b0:5c2:793e:3f6a with SMTP id fv6-20020a056214240600b005c2793e3f6amr97495qvb.14.1679071005740;
        Fri, 17 Mar 2023 09:36:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u16-20020a05620a431000b0074571b64f0fsm2014611qko.53.2023.03.17.09.36.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:36:45 -0700 (PDT)
Message-ID: <043f20c7-9084-8239-5836-d5438579e41d@gmail.com>
Date:   Fri, 17 Mar 2023 09:36:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
Cc:     jonas.gorski@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230317120815.321871-1-noltari@gmail.com>
 <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
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

On 3/17/23 09:32, Andrew Lunn wrote:
> On Fri, Mar 17, 2023 at 01:08:15PM +0100, Álvaro Fernández Rojas wrote:
>> When BCM63xx internal switches are connected to switches with a 4-byte
>> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
>> based on its PVID (which is likely 0).
>> Right now, the packet is received by the BCM63xx internal switch and the 6-byte
>> tag is properly processed. The next step would to decode the corresponding
>> 4-byte tag. However, the internal switch adds an invalid VLAN tag after the
>> 6-byte tag and the 4-byte tag handling fails.
>> In order to fix this we need to remove the invalid VLAN tag after the 6-byte
>> tag before passing it to the 4-byte tag decoding.
> 
> Is there an errata for this invalid VLAN tag? Or is the driver simply
> missing some configuration for it to produce a valid VLAN tag?
> 
> The description does not convince me you are fixing the correct
> problem.

I do not think this is going to work, except in the very narrow 
configuration that it has been tested with. If you configure VLANs on 
the BCM63xx internal switch, this will be stripping of any VLAN tag, 
thus breaking the data path.

It is not clear to me how to best resolve this, short of trying to 
coerce the BCM63xx internal switch into *not* tagging all ingress frames 
by default.
-- 
Florian

