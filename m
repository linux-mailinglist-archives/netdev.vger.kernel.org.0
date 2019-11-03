Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC5CED3FA
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 18:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbfKCRRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 12:17:01 -0500
Received: from mail-il1-f173.google.com ([209.85.166.173]:37670 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbfKCRRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 12:17:01 -0500
Received: by mail-il1-f173.google.com with SMTP id s5so2514246iln.4;
        Sun, 03 Nov 2019 09:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vqrDkseOZ0vsLWMY31zFljoc1Vkae38RgXhKbZkU4cM=;
        b=Zf5chmxu9ddGtc8GS5BByuieZUuk/AuveXujp9FTW2sfNXJ3n3KyjNMuxgrtKNKVMm
         vFQacTbYTcOwSktoOAcKl6+7hxQJNc7rny0kp1kyzxlCibmvq8OKB4b61f/25diM4qO+
         sm6t49ROY0dn+C5FM4eGx2O8pH17B7Ub1tAcoc87iWv+4CIxa80qAAnC8CJ0IYfbsuf5
         ZSYFBNI7Mxr77UE1rQvwDwHaalqYUR9YBIsbRy3ZxsPBTn6Ey4j9pf1AramBczbzSSBy
         InKaO4wTGQOlJhRqQwbg89ufQbUhzKuYGhH6auIho8I7+zt7gyD3FuNv9yqwp5PvxKC1
         GetQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vqrDkseOZ0vsLWMY31zFljoc1Vkae38RgXhKbZkU4cM=;
        b=EVGoUo/eqBy2qINY80ZOP+br0tpd0aLhkDiWwI+bjd/awBPKJR8PeoiZjpPcUDj1fl
         vEBkFTlY6BPprT4RB0D2LGXlAiKe6Ww7kaI/z2oLPyhYV6sLu8ouWWzY7vtW1EKPWVMe
         rW4EG/XbSdL+YR52FFxHviholf2bM6BryQ6EI3swD1lWj7+AjjetYYaZVaFrmN1H5gFJ
         MB/TTYClyfKUXDxdSAk/ZSC6zc781JJZy8vHi44GJgYSEZUmL3cRRNlRv8aQfojpTS5y
         HDHeZlIQA51BAWqOoTfWo+tU+TzHA8vQXPsXvb4Z1/T8llQyHJPYHoAt3H5Tvl2OdvRq
         psTw==
X-Gm-Message-State: APjAAAW6fSExtFnt04HLRyErW6RvIAJeb6vp2VF83b/Kb2fAsE5doV1i
        snMuHc34tPm8/XzCHzln8FHxmoN9
X-Google-Smtp-Source: APXvYqxRUnH6VnynMM2zfvaARHPOKEA66WM5uw4simzD+4MzVtkz82VhjjPPqBhcGGIeHAgR4MqCow==
X-Received: by 2002:a92:9a54:: with SMTP id t81mr25672179ili.197.1572801420161;
        Sun, 03 Nov 2019 09:17:00 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b1d3:36cc:8df:d784])
        by smtp.googlemail.com with ESMTPSA id y17sm231278iol.24.2019.11.03.09.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2019 09:16:59 -0800 (PST)
Subject: Re: Commit 0ddcf43d5d4a causes the local table to conflict with the
 main table
To:     Ttttabcd <ttttabcd@protonmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        "lartc@vger.kernel.org" <lartc@vger.kernel.org>
References: <YWOrt002RdCqkBeUL04N1MVxcsjRvmCb4iqMW67EmAQIG5erLlSntgQWmSYiHXAT8kgFTceURhTaP8dAp9nPD9q3lquhb0MTIRlP4Vy5k3Y=@protonmail.com>
 <CAKgT0Uc5Ba3Vno39KqdBRSXGYpyuGHeyef9=CkthoVkWipLS7g@mail.gmail.com>
 <vQHKO4hEjMsPEg58jVn-H9jQMjxIANbP2DLKgZBdlkgqJHd6p_rMnz-o5QhonUL8cJG_AwXhVwse0e5941mXjN-9LCbtdSVGDYK4OEv3hhM=@protonmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <24db8b01-17ae-c7fe-fead-c7a76f7d17d4@gmail.com>
Date:   Sun, 3 Nov 2019 10:16:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <vQHKO4hEjMsPEg58jVn-H9jQMjxIANbP2DLKgZBdlkgqJHd6p_rMnz-o5QhonUL8cJG_AwXhVwse0e5941mXjN-9LCbtdSVGDYK4OEv3hhM=@protonmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/19 1:07 AM, Ttttabcd wrote:
> However, please add an explanation of this merge in the man pages of "ip route" and "ip rule", and explain that the route table will be re-segmented after adding the policy route.

iproute2 is not the place for documenting internal details of the kernel
implementation.
