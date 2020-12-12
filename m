Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4552D85C6
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 11:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438703AbgLLKMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 05:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405402AbgLLJyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 04:54:00 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4D8C0617B0
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:00:36 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r14so11381827wrn.0
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 01:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IZlaIKVtrg8qzgSFC0THOEwpAeCHFxmFJHfoeQvXzwg=;
        b=SXnJHntleovr/6Zly+vGN5bl+yLENDAMavmbZTz5IsxlN9cNBjcuEqhLRV2C2IdKX1
         XhflofSt0OOjV1PiRPBdP9yIauVbU+8yZXlaPdAUicpqO9Ggh2LzOG005d/h5+rqGIp6
         xGxfJ8QV5Ge5A8vyVUJ+wb7p07BbjiCD87HiPt2kIXB36o/hM3pQ8nGZQMk8KF3yGCaI
         flubUaGjBYuoysMH2xYImUtwbRPI8lz9QMG5EDs/CkSXFmvp5dqjkjpg3eIXtj1ZJ/kc
         mksbBFCTyD84vGZA7YTtocaFNawkdPRFBxb2EGokiy56MT7AEPMuToBnNhLfponppekL
         /zHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZlaIKVtrg8qzgSFC0THOEwpAeCHFxmFJHfoeQvXzwg=;
        b=ezFA/sKcr7+OiBhD7eFsS1Kg24Y/19Q9vOcJLIUdAAmZLOF9oMUOD3N/DAo5Z7UaCK
         mpiCubE581Gp9UqbnbKnsrVm8p/bexTLdO3Dkck2DXK65rhDpZ7UHYo5+Do2U7lWYdFN
         LubOZUPwHemLmTHpLLYzTO+RiSXVf+q8V9rxL8tqRn+l0GO0javIZJxu+9dNS1Wt8nur
         qErppa0CTWxtMeBzxf0tqoEjs9DJQWgxB8dno9vdt/OF4HNSEx1zx6XltgrqQFO0pE0Z
         k+v/lCWp2bAc4DNIVK54QE1CV/64k2Gbw4wrrs6Eub9NokHUCWKqrPApUk9ilu5jvjSG
         A28A==
X-Gm-Message-State: AOAM530VwaK5cDNa3oTFgrvAib7iLwbj6t6EQ0fybB2FYmWEEp1jm08S
        zdQNCtnpD2VxMsgXRU6cpecnVnH97K+W4A==
X-Google-Smtp-Source: ABdhPJw1hc+oG7iwq5QfXkuDP3g4x60MRM7cWl/XUXbCE6T/FHA3c6gxO8VltuA3yrUKk2NhkqZU9A==
X-Received: by 2002:a05:6512:287:: with SMTP id j7mr6115139lfp.541.1607759383361;
        Fri, 11 Dec 2020 23:49:43 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id e15sm235356lft.242.2020.12.11.23.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Dec 2020 23:49:42 -0800 (PST)
Subject: Re: [PATCH net-next v2 07/12] gtp: use ephemeral source port
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
References: <20201211122612.869225-1-jonas@norrbonn.se>
 <20201211122612.869225-8-jonas@norrbonn.se>
 <CAOrHB_CzXgf9mOr+LhSOKcJ1uzTQBqMmWiDCMkutCF7VRJ9Djg@mail.gmail.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <98f0ddde-e98f-67d5-7506-e197f69b281f@norrbonn.se>
Date:   Sat, 12 Dec 2020 08:49:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAOrHB_CzXgf9mOr+LhSOKcJ1uzTQBqMmWiDCMkutCF7VRJ9Djg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2020 06:35, Pravin Shelar wrote:
> On Fri, Dec 11, 2020 at 4:29 AM Jonas Bonn <jonas@norrbonn.se> wrote:

>>          /* Read the IP destination address and resolve the PDP context.
>> @@ -527,6 +527,10 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
>>                  return -EMSGSIZE;
>>          }
>>
>> +       sport = udp_flow_src_port(sock_net(pctx->sk), skb,
>> +                       0, USHRT_MAX,
>> +                       true);
>> +
> why use_eth is true for this is L3 GTP devices, Am missing something?

No, you are right.  Will fix.

/Jonas
