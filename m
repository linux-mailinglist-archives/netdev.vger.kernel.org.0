Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F29146C1
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbfEFIt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 04:49:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40518 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfEFIt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 04:49:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so16172186wre.7
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 01:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fYN/6GDN+nENRFzZcXvnQ7/LdAUQ4tlCkdHDCr7kHiI=;
        b=URnDtY1eKxPAv7PEvcUcvNiZcEXGtH7ylgkcBGZNsVQZeFe2k/pyFTa6+13a6IOSCF
         gqlb/YGYnfvIce2o3QAyf0jKceDoP33X/kde7b3YOtomZ+L6DTUqlZX64I9cnMtgudMK
         i2lWel9ejr5iBd6+IAIZvNgzdlmbQndkC5FPjPOEDod04+pO1MMb/o3mInky8TMAcVWb
         zpHLviLK9mas77Z8jVtPnC69g4eckvCD5R/Glqxaj4yamAwfFzAWQg7AF7MHYz/gOeDK
         xQU4AMfz+voyQAq4BukHhvK9WjgcEK9j0qz29C1h4j7AV15aBidAkZSTL+G9dB1zk2lP
         suxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=fYN/6GDN+nENRFzZcXvnQ7/LdAUQ4tlCkdHDCr7kHiI=;
        b=bFf2LygsUJkPA1sxuCDSSKcy/yYx/I0xVVrnwDlNkWndQppOJtFgjVaIhSJSC6Yid1
         c+qKnc+5Ul+5hhS0553o214/RswDUVbAiqLwQwUpUlydul0k4cc+H1bqs7FYq6Y3uVn3
         8Zp2AgS7FnDin2H2OL2WSZ+V9Civ0laRANd9TsFGCf5scASa15F3w5TA0gxurVPJLxqs
         cumo0Fs+YXHlWTGrS8db9EnNvswOzeHA6pheeYbTNfn5N03r99oRkdqJ1zzbwwddG/K4
         DrLXHZ2hcisIKoC4N3ec0+uLJQVZhIhDhYHNioRq8lL3dzxcfPtEoMRqmozSNatv7fKt
         o9ng==
X-Gm-Message-State: APjAAAWyercWeLgVy9eHyN43gdxQgngxnJKIDx75ZKIBXwv0rGr9xHjC
        0UvCwEv3XcZhEssc4oJr2Cz/Yw==
X-Google-Smtp-Source: APXvYqybCiX8dVUjWGyMpToHJsHKjEWTr/pgichjTRTSrm2rivStQzlABLsGYDHYy47ArA+NIppfVg==
X-Received: by 2002:adf:db0b:: with SMTP id s11mr9988959wri.180.1557132594286;
        Mon, 06 May 2019 01:49:54 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:35a7:9cb3:43e0:63e? ([2a01:e35:8b63:dc30:35a7:9cb3:43e0:63e])
        by smtp.gmail.com with ESMTPSA id a22sm7612539wmb.47.2019.05.06.01.49.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 01:49:53 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol flush
 regression
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20190503154007.32495-1-kristian.evensen@gmail.com>
 <20190505223229.3ujqpwmuefd3wh7b@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <4ecbebbb-0a7f-6d45-c2c0-00dee746e573@6wind.com>
Date:   Mon, 6 May 2019 10:49:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505223229.3ujqpwmuefd3wh7b@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 06/05/2019 à 00:32, Pablo Neira Ayuso a écrit :
> On Fri, May 03, 2019 at 05:40:07PM +0200, Kristian Evensen wrote:
>> Commit 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
>> on flush") introduced a user-space regression when flushing connection
>> track entries. Before this commit, the nfgen_family field was not used
>> by the kernel and all entries were removed. Since this commit,
>> nfgen_family is used to filter out entries that should not be removed.
>> One example a broken tool is conntrack. conntrack always sets
>> nfgen_family to AF_INET, so after 59c08c69c278 only IPv4 entries were
>> removed with the -F parameter.
>>
>> Pablo Neira Ayuso suggested using nfgenmsg->version to resolve the
>> regression, and this commit implements his suggestion. nfgenmsg->version
>> is so far set to zero, so it is well-suited to be used as a flag for
>> selecting old or new flush behavior. If version is 0, nfgen_family is
>> ignored and all entries are used. If user-space sets the version to one
>> (or any other value than 0), then the new behavior is used. As version
>> only can have two valid values, I chose not to add a new
>> NFNETLINK_VERSION-constant.
> 
> Applied, thanks.
> 
Thank you.
Is it possible to queue this for stable?


Regards,
Nicolas
