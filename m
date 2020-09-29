Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114D527D23E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731579AbgI2PNH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 29 Sep 2020 11:13:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37711 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgI2PNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 11:13:05 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1kNHJO-0005ZD-MS
        for netdev@vger.kernel.org; Tue, 29 Sep 2020 15:13:02 +0000
Received: by mail-pf1-f198.google.com with SMTP id s204so3953111pfs.18
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 08:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=chf6sW9f/7H17vcG0LBXg02B+gAENr3JISCPSgXJJLo=;
        b=g90E9j7sA4IdtIzpOOW6DnEMChRzfVZxdmzCQ9tsO9ujvUYjmi0gZ76wnr2Gx2hVNY
         daHV18zOT27uoT83T5mTYpVVRf9GQsdRhWL8QR/fqWaKvPo0S2bD0hpuCfuXCbef05vG
         cRx6Wu+0RdszEaAYdNR0bsgGTdXbP22hMH1Q9DZN83dWKobCoMd0orB+zsvbnz7S9rsg
         l9pVl93SqcDialNQsiUndQ38t00u6fUYJXpya+YQINKDFIaVlWAK750YKQlf7U8C6PmA
         wzwEpAhSuw9i/5XHiLOI0/58+F5H3Xo3p+pDP+htTU5zgOrFs+8ceaDCFep7ZadPv9Of
         LH0A==
X-Gm-Message-State: AOAM531ybQaVoy8x+aDdEOU1qiBedYNKzO+2NTid8uju9CJnWcqypwsd
        COqsNzESRJGs5kI1aTNn8LqA+J7P8NrB9kBeWna8JJc1H4/bF+vKr+YhxYtqrPKHnh/OJsBK5n1
        wV8RCb8FM590Vbr3KVE6lZZZzP/heIV6F1Q==
X-Received: by 2002:a62:cd46:0:b029:150:ddeb:646b with SMTP id o67-20020a62cd460000b0290150ddeb646bmr4303299pfg.27.1601392378319;
        Tue, 29 Sep 2020 08:12:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy0/olQ5yxz8/5kXGaM2e+jOh6gkWSTzzcliWV4N9POlON3DttDBggKkxhU1hGl3+7ZDtOILg==
X-Received: by 2002:a62:cd46:0:b029:150:ddeb:646b with SMTP id o67-20020a62cd460000b0290150ddeb646bmr4303259pfg.27.1601392377925;
        Tue, 29 Sep 2020 08:12:57 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id f4sm5595689pfa.125.2020.09.29.08.12.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 08:12:57 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [Intel-wired-lan] [PATCH v4] e1000e: Increase polling timeout on
 MDIC ready bit
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <f8bd6a07276a4289b102118a132bd793@AcuMS.aculab.com>
Date:   Tue, 29 Sep 2020 23:12:54 +0800
Cc:     "Neftin, Sasha" <sasha.neftin@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EF57895C-2B0D-4EE1-9A47-E3E07C04C9FB@canonical.com>
References: <20200924164542.19906-1-kai.heng.feng@canonical.com>
 <20200928083658.8567-1-kai.heng.feng@canonical.com>
 <469c71d5-93ac-e6c7-f85c-342b0df78a45@intel.com>
 <30761C6B-28B8-4464-8615-55EF3E090E07@canonical.com>
 <345fffcd-e9f1-5881-fba1-d7313876e943@intel.com>
 <3DA721C5-F656-4085-9113-A0407CDF90FB@canonical.com>
 <f8bd6a07276a4289b102118a132bd793@AcuMS.aculab.com>
To:     David Laight <David.Laight@ACULAB.COM>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 29, 2020, at 23:11, David Laight <David.Laight@ACULAB.COM> wrote:
> 
>> Hope we finally have proper ME support under Linux?
> 
> How about a way to disable it.

This will do, too :)

Kai-Heng

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

