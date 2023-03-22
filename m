Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29206C46E9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCVJsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCVJsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:48:19 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB875FA74
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:47:52 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x3so70228129edb.10
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1679478470;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EI5kNSJUWZUDEom22MsOrhGWvDxqznok5W/2ifCXQ/A=;
        b=ZayfKBcIE/g358ru+OBzbdUpVdKJJ6zEn9KYnohTOMrCypLCOlJsJPvHeZkSJTLKlF
         mscVl2mfSar51SFRJBYZkgh5Bso3Y6EDchu9eNVsWRV8k59ohavBjtBQxWGC42QcNg8w
         goeE/6ZSuX2BEV4y5nwM15gcI6jh/O+KB/Qv8J2XbAYyMIamCFXM38iac5rxvH1jnbXW
         4U97OJZnSKgUP6rV/cl9eaDGvF0DzvZzsCeDHnqd8tQfHO9tH7VxFfQX4vKZZjnstm0F
         ZVYgWOAwLK4odh7EuBy/FFlNclJCrbZE/XZWXENZtZ3tgzQQ/+e85QovKeB6ulfpRaqJ
         UTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679478470;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EI5kNSJUWZUDEom22MsOrhGWvDxqznok5W/2ifCXQ/A=;
        b=eP8ZJEadklPrK7cFsZvzkUgQKWUuLNQ+jCu51Qdr38BKooI34ypw0FdXKCbVqfg9rd
         R+Ad2W84Rt+l4Zf2zb7ScZzl8cZ7wmrBlZWLq3fq838L0ACBZCJvQ5UATG5CabimihvA
         ITf0MdEj7sQ7iPBbCndbUlp6nOOCvX/LvxFlQr9v6q46E67MqADCk1l8ygyCvMLpMx01
         t1FqP6cLG+BLS6tmkDSlUj1KVZB/dsR9xfUXAZQ/vf+DGv+wrGNva3tVJc5OH7Z9y7rK
         Vavudn2PlE2V6Q8s+ifgg+liUK6Au8do9HUhIbWCO4ASxjbLKaXHAXmm+2lJAIZT3yfj
         iZbw==
X-Gm-Message-State: AO0yUKWGh347AyHSwo2wCj01Q+HQ8vzJZZ0MwhnpjdgS6PUSmyQ4ZfFC
        4FmPInylnnTQ6KA0j4Gl/WsAwg==
X-Google-Smtp-Source: AK7set9h5Mt4NiwOQ8mcl/9qNI/VDRZnKQXW2IOJRIy2u++JoitWwik/yB97L8cAOHVkdcm+1H/f1g==
X-Received: by 2002:a05:6402:414:b0:502:62:7c with SMTP id q20-20020a056402041400b005020062007cmr838503edv.24.1679478470525;
        Wed, 22 Mar 2023 02:47:50 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id k19-20020a508ad3000000b00501c0eaf10csm4493802edk.40.2023.03.22.02.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 02:47:50 -0700 (PDT)
Message-ID: <928a2124-e8c8-471f-feda-0651d6465e57@blackwall.org>
Date:   Wed, 22 Mar 2023 11:47:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v4] vxlan: try to send a packet normally if local
 bypass fails
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com
References: <20230322070414.21257-1-vladimir@nikishkin.pw>
 <ZBq7yv0W5MqhqYnm@shredder>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <ZBq7yv0W5MqhqYnm@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/2023 10:26, Ido Schimmel wrote:
> On Wed, Mar 22, 2023 at 03:04:14PM +0800, Vladimir Nikishkin wrote:
>> --- a/Documentation/networking/vxlan.rst
>> +++ b/Documentation/networking/vxlan.rst
>> @@ -86,3 +86,16 @@ offloaded ports can be interrogated with `ethtool`::
>>        Types: geneve, vxlan-gpe
>>        Entries (1):
>>            port 1230, vxlan-gpe
>> +
>> +=================
>> +Sysctls
>> +=================
>> +
>> +One sysctl influences the behaviour of the vxlan driver.
>> +
>> + - `vxlan.disable_local_bypass`
>> +
>> +If set to 1, and if there is a packet destined to the local address, for which the
>> +driver cannot find a corresponding vni, it is forwarded to the userspace networking
>> +stack. This is useful if there is some userspace UDP tunnel waiting for such
>> +packets.
> 
> Hi,
> 
> I don't believe sysctl is the right interface for this. VXLAN options
> are usually / always added as netlink attributes. See ip-link man page
> under "VXLAN Type Support".
> 
> Also, please add a selftest under tools/testing/selftests/net/. We
> already have a bunch of VXLAN tests that you can use as a reference.
> 
> Thanks

Right, that is what I meant when I suggested making it optional.
Sorry for not being explicit. Please use vxlan netlink attributes.

Cheers,
 Nik

