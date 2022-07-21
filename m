Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A96D57C5CC
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiGUIFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiGUIFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:05:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3FA237
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:05:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bv24so1103518wrb.3
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=oMezIl3MODyEWDKeXD47e22fDPTf1Eql4Ed8O/dFGiA=;
        b=Rn4JYKPKybeoUYZNdX1pt+5kkJs44S0CWgoOMBkI2Upy5D3eyLLCs4Jor5AimJFPmI
         PuqOeNlX2J1HNVilQYUu8Ee0Rp52mct/wdRaTy3IVqG+YKYyWIhfFrD2RSZ7bmqxvIBw
         LHOopcZl7qV+nUuiTUxirIMgDTgMW9YX5s9yO5zmV8SH/NL7Br8+0ksSDlHJ08/wxYIB
         zv0i14yZYGYkv8AfJEEcBUBkVAi3gNS0EpBlSVuEfXoxHApMkEMPLp9Xuqn/HxyPoO5G
         4LlKoSde4252QEiprKdpKhfRifpLNUc1HMlPBxnhiySjhbxmlres2/WPbjBMnko9Pfk9
         2dmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=oMezIl3MODyEWDKeXD47e22fDPTf1Eql4Ed8O/dFGiA=;
        b=MrY7zzoIs+HJrkR9wqGLbabhkVHwNyMxNDzrL8neyZWL2mlJF7kvykWMbFSTi0f+Nl
         4Kx+P9lpP8VdMbliL8YyUj/Apmci4VoXETiyyyBbwHdWwjru+3a31PtTewM/ZkAAoCRN
         XqV/Xpvq374UlpLTX1sa/XDvdQ/Ke6dNi+DXTvJ2EwoNCqpEI48EFB8SjDyACqQ1JQ4F
         U1bIdqe8DqL8sguWK+/qUwEyrlbYkKQRuWCL5pjI7NC1LVbFrXhkhaWJLP5hjZULVSZS
         mQ/2wX5n4GGx7YxaZq4pIukkmGvN1CDrQcDivkT4jZitgzntMc2kSl2z4KLk8sQPERLh
         N31A==
X-Gm-Message-State: AJIora8pvSVPGfedRPNEDAN3IrnwIRhHArmBAKESI79BRPoh679oroX5
        5GNtcErL9rMpnWVIt+CGnNa9Qw==
X-Google-Smtp-Source: AGRyM1ulFq7YfmAN3uAewgqgmv5h6VdKZFvVZqQqdD9xm/gDePXo5J3ZNvQNVxYmeHNE1VfbWQsiWg==
X-Received: by 2002:a05:6000:68b:b0:21e:5134:c80c with SMTP id bo11-20020a056000068b00b0021e5134c80cmr2726761wrb.625.1658390703127;
        Thu, 21 Jul 2022 01:05:03 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:956c:3203:b371:1705? ([2a01:e0a:b41:c160:956c:3203:b371:1705])
        by smtp.gmail.com with ESMTPSA id x15-20020adfdd8f000000b0021d60994b0asm1072918wrl.100.2022.07.21.01.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 01:05:02 -0700 (PDT)
Message-ID: <dd8e2d43-7432-ce01-5dd5-64a69a3789b7@6wind.com>
Date:   Thu, 21 Jul 2022 10:05:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ip_tunnel: allow to inherit from VLAN encapsulated IP
 frames
Content-Language: en-US
To:     Matthias May <matthias.may@westermo.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Eyal Birger <eyal.birger@gmail.com>,
        linux-kselftest@vger.kernel.org
References: <20220705145441.11992-1-matthias.may@westermo.com>
 <20220705182512.309f205e@kernel.org>
 <e829d8ae-ad2c-9cf5-88e3-0323e9f32d3c@westermo.com>
 <20220706131735.4d9f4562@kernel.org>
 <bcfcb4a9-0a2f-3f12-155c-393ac86a8974@westermo.com>
 <20220707170145.0666cd4c@kernel.org>
 <b046ef4e-cb97-2430-ab56-e2b615ac29eb@westermo.com>
 <20220711112911.6e387608@kernel.org>
 <331695e3-bfa3-9ea7-3ba9-aebd0689251c@westermo.com>
 <42015af3-daa5-7435-725e-8197adbbf3b8@6wind.com>
 <88cbeaff-4300-b2c4-3d00-79918ec88042@westermo.com>
 <f8eb52c3-40a7-6de2-9496-7a118c4af077@6wind.com>
 <ba54b498-5388-44c2-9554-953a3cf1b8eb@westermo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <ba54b498-5388-44c2-9554-953a3cf1b8eb@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


+ linux-kselftest@vger.kernel.org

Le 20/07/2022 à 17:24, Matthias May a écrit :
> Hi
> 
> I finally got around to do the previously mentioned selftest for gretap, vxlan
> and geneve.
> See the bash-script below.
> 
> Many of the vxlan/geneve tests are currently failing, with gretap working on
> net-next
> because of the fixes i sent.
> What is the policy on sending selftests that are failing?
> Are fixes for the failures required in advance?
I don't know, I've added linux-kselftest@vger.kernel.org to the thread.


Regards,
Nicolas

> 
> I'm not sure i can fix them.
> Geneve seems to ignore the 3 upper bits of the DSCP completely.
