Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDF43E574E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbhHJJoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239303AbhHJJoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:44:12 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0E4C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:43:50 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l11so8587715plk.6
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HuDel8ayMwuZGcNVC/Xca01aagp05sJ/uzkjO6nmwrY=;
        b=MfmFVDcau+Ht5MC0Z11A0Lodc1upVa5x8ongdWS8TE8tjKiQLuzuK0pn8mBCNzIfSI
         qs5dNWnAfz2I+dUz6znusiGsfKJ7BDJMNJJqNHtjgPgDuOz/w6QTWaycta6RfSaj5fJd
         xRELdlQj1pSRQzr80J9k4mya1b6nFDdCC1Y7iw8GO8T31QuclJkAvIMX521fpn85ZBU9
         FZJOhHVQgXcQmfBRdZHxeYjK0v6CfHTqslJchOvJxdxdb8QzvGcT/6Rqkrmf2JcIGtd8
         Wk6mB9mSaA1A3L0d8p7I/YpIoBt259/YJdwN1q0JP7svIeqbfMiNa3IMTA8NHqiRtn/+
         U/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HuDel8ayMwuZGcNVC/Xca01aagp05sJ/uzkjO6nmwrY=;
        b=kQv9ovulDCJdS7qXVnMJNCC1ll0xXAmJ5VEb2RE3xxgM9XqZUzR7tjBH3ffnysmZRG
         dxCNsEvuIHgcf1zlg7DCFT2QqG+jTGwCQG4eJYnYhb8f/Jo1T5urhpH8EqWDWC8OwiSX
         e+QvwCpQC8GzFEQzpkiaCaWbf0zFy6mX+UF9nwsZfQ/IcOPdAMfqFftM6e8StM2vzull
         rUq1RcnYDkZohLII0sgb8cLmLfjfPb/WNcO9pdq61peMueeUR5UPMtAZ0vqBfDa2YZ2M
         ZKJmAcZP5ziQBbrLCx0RabvqgHtcISzmGdaDbOl3KOQyHmY/OCVeplFOZDB3xxRs5ymI
         dosw==
X-Gm-Message-State: AOAM533S3NSI1y+SiDJnK5zpqrzGWrXACKpY9tJ/97nADQz8tnOBgm9l
        rUmMwo3aF6WyBHBc2yIiEKw=
X-Google-Smtp-Source: ABdhPJyYxxRshDihijJiBRh2viwhTJjaq/7HY4JjQ/hF2XykKb5wH9QSzJq7MDY2D/2Z/D0DzVB3HQ==
X-Received: by 2002:a17:90b:228c:: with SMTP id kx12mr30807002pjb.38.1628588630078;
        Tue, 10 Aug 2021 02:43:50 -0700 (PDT)
Received: from [192.168.1.22] (amarseille-551-1-7-65.w92-145.abo.wanadoo.fr. [92.145.152.65])
        by smtp.gmail.com with ESMTPSA id h11sm11561709pfv.154.2021.08.10.02.43.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:43:49 -0700 (PDT)
Subject: Re: Bridge port isolation offload
To:     DENG Qingfang <dqfext@gmail.com>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b9a61559-e7f7-86e9-6ac2-c988255db5f0@gmail.com>
Date:   Tue, 10 Aug 2021 02:43:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 9:40 PM, DENG Qingfang wrote:
> Hi,
> 
> Bridge port isolation flag (BR_ISOLATED) was added in commit
> 7d850abd5f4e. But switchdev does not offload it currently.
> It should be easy to implement in drivers, just like bridge offload
> but prevent isolated ports to communicate with each other.
> 
> Your thoughts?

It maps well on Broadcom switches but there was not a known use case 
AFAICT that warranted mapping this flag to program the switch hardware 
accordingly.
-- 
Florian
