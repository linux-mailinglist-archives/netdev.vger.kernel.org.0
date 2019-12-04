Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1792C113425
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfLDSWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:22:16 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42449 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbfLDSF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:05:29 -0500
Received: by mail-qk1-f195.google.com with SMTP id a10so787698qko.9
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 10:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hBPDPqlOTcbRFWDkrHPNcSAGXGuhN4nHPkn7bkTrl0A=;
        b=kHeIf4+u5A6tqDKL5atJpA8nyriND2btWSu0Kskwa2+Bxjvkm1rzfs4IqFG59qwtJW
         +c0+MWjzcxPv+RJugUCMbW3GtPSrC7b2AmJ0pVIVE4bsn1YEtqPwam+a3Ib2wJUC7Kng
         s7DAffXxVtc01aVNykMrxCjoOw6KQ+lggfkhCy+Wdu6vWfW+TtqOh8pEH/SG1EgL9mUm
         uyXFobw3L/IIHsrAuE6OJz24vewHwG/ULX25aOJgDnvvIq2kzKW5Ksu3sXNx2RMJTted
         gJCqQHio5Ha1rQjKRzsL206HaNnEUPo5KkEVgxKUugvdO95w/Vtxpafo0MJNOpVZtyGq
         +t3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hBPDPqlOTcbRFWDkrHPNcSAGXGuhN4nHPkn7bkTrl0A=;
        b=NKIUXpxGuvmvr3NDIHr2TYVZ/1qV9pKHuiiRje93PQ5A2Pc+xJnIc6kb9hqYEwZpBn
         MTi9KL2zeGpSObXniJXZrI+l9XpNnL6+atriVQ1KpzDS5VHzfVSs33rvWHf+/WOseUA/
         65gAG/mGIeW3RYGKl+iHs0fgTum6I/NWcSsswJcYvC4igsg8UH6t2Fedv0fbFLm/pMJs
         1KK34078yzNhJtMX0SLr8gz0jSyVkClsOefdH39xcBxh4ioRm72gffsjrYBFWLbrlP03
         h4P1yi1M5Npd9ZbFGOTrRzvxOG1T0zVHNsA5r9yGvuL4yvJc1PHNBSg32VxlV6h+Rap3
         iTfg==
X-Gm-Message-State: APjAAAVr8MjP5jpTZ2pvzo/M8V3jRLYcO1e9iN4P8LfTQKk06ydntfmR
        i3oFZYWT1+FjHpKQyuI0ocu6+OyJ
X-Google-Smtp-Source: APXvYqx0dwLEY70lELpr9qewKz8oNjvaCjn52haiYTs9jvRRexlJ6n+f0ue/W1uEnpYai92xMZuSEg==
X-Received: by 2002:a05:620a:2094:: with SMTP id e20mr3725574qka.415.1575482727946;
        Wed, 04 Dec 2019 10:05:27 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bc97:d049:2862:6860])
        by smtp.googlemail.com with ESMTPSA id p7sm4022580qkm.123.2019.12.04.10.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 10:05:27 -0800 (PST)
Subject: Re: Endless "ip route show" if 255.255.255.255 route exists
To:     Sven-Haegar Koch <haegar@sdinet.de>, netdev@vger.kernel.org
References: <alpine.DEB.2.21.1912041616460.194530@aurora64.sdinet.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a57d26df-26a4-26dc-5acf-4a49f641bcb0@gmail.com>
Date:   Wed, 4 Dec 2019 11:05:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1912041616460.194530@aurora64.sdinet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/19 8:22 AM, Sven-Haegar Koch wrote:
> Then trying to show the routing table:
> 
> root@haegar-test:~# ip ro sh | head -n 10
> default via 10.140.184.1 dev ens18
> 10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
> 255.255.255.255 dev ens18 scope link
> default via 10.140.184.1 dev ens18
> 10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
> 255.255.255.255 dev ens18 scope link
> default via 10.140.184.1 dev ens18
> 10.140.184.0/24 dev ens18 proto kernel scope link src 10.140.184.244
> 255.255.255.255 dev ens18 scope link
> default via 10.140.184.1 dev ens18 
> 
> (Repeats endless without the "head" limit)
> 

Thanks for the report. Seems to be a problem with iproute2.
iproute2-ss190924 works fine. I'll send a fix.
