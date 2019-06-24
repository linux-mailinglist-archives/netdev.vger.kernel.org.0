Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD9451D47
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbfFXVqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:46:15 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34351 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbfFXVqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:46:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so7628986plt.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Zjff6rzfxdKfn/UuWv0kBdVmGmkrwqY+xuEbF8FfcPo=;
        b=ExDF5Z3nuM3dig0gGSHXA7mSsz/Iz9Ms5lNzOrWqD0Q5I3cVxkzIMDWlKsMDj6ACbe
         g4HKT47WVTQsasAryZlE7ei/8ZguxVBpvk7mGqi+S04KqMIeqnwuWAWIFJc0Vpii/jLU
         /t2DpVV7PwIa4egeUotpeMyh8j7qtU0nXfDU5bue4TArCrKlw167L9aN4FTyBKbNUM+2
         BaO3cal3tVQjW8rF5i6wiwvESlSD7lmaHu+IKE8QWVLRLFEm4hxJn9wJrgLgrHbJoAhK
         PQLdm3XiSj93l4WAHE/hYcye9UiidU2O4R23hc2QxucEsqAmttjPx/8NqZ0IoJMJ3FMY
         3OGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Zjff6rzfxdKfn/UuWv0kBdVmGmkrwqY+xuEbF8FfcPo=;
        b=m/Zc9X8nDPqBOHsT9WkqCr6aSC2/013Wf6/6w99R8uxWbuqga/hfTH4DsZPUDl+FFe
         +CVv+8rAGhnQU2dRkyriOtFSlaDwPeYl3/6XxFNwC/ouP2UpGS9r3+F9rl7kd1srbqX3
         Zs0+t5FPcCR0GqfdHMw6hV/8LweeFt4Tmnv3xGzw5jhbTcnB4wO3PndvK4swJjqWGHvF
         EBbL5hu3wV1lOnsiWcRt38xAE2KdnlxlXiQ82metAoGERbn9/7Pq5/agsi+vCDZsoU2j
         /vT0G/UnDdHqYeACVzddRJW3PPrdmwh1laQjQM/3ZC0o9dBL3TyuVyPpTLk+gJHaquj+
         B43A==
X-Gm-Message-State: APjAAAWqlBfk3RrdWfhQbpLSVFqVFljmk3OxWstV9/cQogXhyXsdQ75A
        L0id0mQ8nOF/hEUwyLdw+hvHxe6L3fs=
X-Google-Smtp-Source: APXvYqw5nz1Oz9yR0p8EekuSsgW+gewP+2TS9Ughw1lbh1BiUViUlRNwiWRuTfD0JfWnRwk9NWJ/zw==
X-Received: by 2002:a17:902:542:: with SMTP id 60mr128599128plf.68.1561412774838;
        Mon, 24 Jun 2019 14:46:14 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id d132sm15134996pfd.61.2019.06.24.14.46.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:46:14 -0700 (PDT)
Subject: Re: [PATCH net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-2-snelson@pensando.io>
 <20190624130327.2b16d149@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3ec1d5fe-e7bd-684a-55c2-7c8764d7bf7f@pensando.io>
Date:   Mon, 24 Jun 2019 14:46:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190624130327.2b16d149@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 1:03 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:07 -0700, Shannon Nelson wrote:
>> diff --git a/Documentation/networking/device_drivers/pensando/ionic.rst b/Documentation/networking/device_drivers/pensando/ionic.rst
>> new file mode 100644
>> index 000000000000..84bdf682052b
>> --- /dev/null
>> +++ b/Documentation/networking/device_drivers/pensando/ionic.rst
>> @@ -0,0 +1,75 @@
>> +.. SPDX-License-Identifier: GPL-2.0+
>> +
>> +==========================================================
>> +Linux* Driver for the Pensando(R) Ethernet adapter family
>> +==========================================================
>> +
>> +Pensando Linux Ethernet driver.
>> +Copyright(c) 2019 Pensando Systems, Inc
>> +
>> +Contents
>> +========
>> +
>> +- Identifying the Adapter
>> +- Special Features
>> +- Support
>> +
>> +
> nit: all instances of multiple empty lines in the docs look a bit
> unnecessary

Yep, looks like I missed a couple.  I'll check those again.
sln


