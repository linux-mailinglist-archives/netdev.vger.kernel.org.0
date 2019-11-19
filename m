Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEED102AA3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfKSRRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 12:17:24 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:43626 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbfKSRRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 12:17:24 -0500
Received: by mail-pj1-f68.google.com with SMTP id a10so2875739pju.10
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 09:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SkUrXg9/rRQwrGDaQvMDHhFrvTWxqZ4qFgsVbyPlGag=;
        b=VRqQ0GFMRnjzY5zCtH0HLdG9OWc25Vop244eEmOIVGasgVYOuFd77l7c7ro58eV9k1
         TH2OK2OlANVx1/6YWi03/7EU9vef9P/t6JgIoe1jAko7KeTHKgFzgNE5MdNlsRuEc6j9
         HDBl0WhxsCAr9EcTRIza4NnDiejyEiOB6tlL6+CJDeCFnt9m2TAWe4mHZQCt/a+MDhIB
         wu2UApeNu0NNVmfY8nuIW3HiGdInqQXvXAe3dcXL+n2woqthO8SafenPeFBZcmn5pRqj
         8picaldzJmkH4u2Vls6TLhwvfEbqYGowlJ/et3/lxYU4iFHYon1M88lnVuVnywtuKM9I
         fvHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SkUrXg9/rRQwrGDaQvMDHhFrvTWxqZ4qFgsVbyPlGag=;
        b=tM/rPjivEYdJZZJqMEKc3yEusHWX/AhnbZ1gKIJ8t5EFSi3rVDWkjan4PEyERTsYTc
         9Xk4/2V8iU1R6/TzwovWfXCVbLAvqGlE1gmfHl3NUTn1868M7tTpzdFlXSgd5th2Llzy
         +WN2QHb0hyAU9OOTk6FFQJf2HQ4JxIH5MN1pyrq7afkBF4XGN0TFuigXnl7LQ5N+Awlb
         Ju4u+d5Wm6xrmXQf+J5hupvuNKXJ6jdxnU46Rt7XhjtGsRxuXoiWujj871IUuHmX5Mfh
         sG8A2oXkXlHNZHvALKwpshGEhbdpor54SM0NMIj0H97LtC0CraPQZIe5QgsFvtGE8njh
         vN+g==
X-Gm-Message-State: APjAAAWfFMFpNMpwUSB5vo6H1KGxGwt/jkFRBmGtFsJxZTSjgJ9sALX3
        FdhFwwGwh+IAHW7HrxNlCDo=
X-Google-Smtp-Source: APXvYqzLSuc6gg6CUUttRdazU2hfEpmfP1ZFDtxB1O7NHd9YT6YP8Ud7TPwxzGc92KpqXCe+o5Hdiw==
X-Received: by 2002:a17:90a:741:: with SMTP id s1mr7998331pje.107.1574183843890;
        Tue, 19 Nov 2019 09:17:23 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id 193sm28792172pfv.18.2019.11.19.09.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 09:17:22 -0800 (PST)
Subject: Re: [PATCH net] tcp: switch snprintf to scnprintf
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
References: <20191114102831.23753-1-liuhangbin@gmail.com>
 <557b2545-3b3c-63a9-580c-270a0a103b2e@gmail.com>
 <20191115024106.GB18865@dhcp-12-139.nay.redhat.com>
 <20191115105455.24a4dd48@redhat.com>
 <20191119015338.GD18865@dhcp-12-139.nay.redhat.com>
 <22361732-351e-4768-0974-bd4050eb9f2e@gmail.com>
 <20191119134051.GE18865@dhcp-12-139.nay.redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0af010ef-7930-8b9b-24c7-5789b391d12e@gmail.com>
Date:   Tue, 19 Nov 2019 09:17:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119134051.GE18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/19 5:40 AM, Hangbin Liu wrote:

>>
> OK, I will post a v2 update. Should it target to net or net-next?
> 

Since there is no bug to fix, net-next is appropriate.

