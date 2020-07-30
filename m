Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D767E2336AB
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgG3QYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG3QYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 12:24:21 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082CCC061574;
        Thu, 30 Jul 2020 09:24:21 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id t23so6003584ljc.3;
        Thu, 30 Jul 2020 09:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EaUMkD4dUAFEXrfJ2wjRDLLX2Bhfm0lP33zXQvqbIvs=;
        b=OlEQEojSb0LoAhVVfZ52xAL8AxY476YlkmAB1ePKevRLyNUkUQZosdui9mY+1DynmS
         lVyC2167XXfnYtIh/JYR5F317IkkXWuqllfow3750ih9GK28vfGw65bd5M1mLCwQIgB6
         nUJwFMFkSGfwYLKSDqUqlKLZfBTY5bD2ftkCFPA3A0LkT0dhoY4jjfgiaCXbfwI2z3sF
         StD1yVUKVk0CGB1nIa3S1jf3JMTb6SK72mcaCG/wGZHe5evS3wl5C3sQk4/PnHZZgvSO
         kJR/gqD20VQtwQ0jSBf0RjiGx2Up+rQhbUBV1mYGGOZtJ89CllZHui5xbINw5veLIIEV
         tsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EaUMkD4dUAFEXrfJ2wjRDLLX2Bhfm0lP33zXQvqbIvs=;
        b=LBfL8aJmxa4+kS5QDKXCu40fVgwm0vfURmgbyNy8u0IV0OAR1jm/WBzfP/+YToYxJy
         BDDbIZHZaw4pTZowV8eUo6UaaEzEp68P4K0LLuckkOi1xjDgbE83x7LDo96zIwP6SC8D
         Tiaghpsn3zeyvXYO0aXWh3k7MydZrumrKCrZMAxDO2Y2Yq5Ni0cFTbcOGz8Bq4uAhlaW
         jiYrl+Xprq/92UEJx7+uzdZeBLxMKtsxsvTTIwuvBIZchjCXoPcbQUPFSutmWjJAk6ic
         m+yDsYeJ3eM22vl3amMt3QqaBEXmCTYvKtnrJYOGFjBm6ZiRxcqQgjmnZni5Z33mL2wX
         mYUg==
X-Gm-Message-State: AOAM533qWzdBJDMhVoXC91RYeQNi1wYa7U/mynjQx5eZBrIY/tIMD+pv
        ndZiYcWzUMI3YTxLJGbXcYUwRCof4IE=
X-Google-Smtp-Source: ABdhPJx8h+RBtdYvgnuj9A/VtTtdk500fyRmIyF7J8fDYaROcyrlDdipJ/9M8rp31XPIK02UJ55zNA==
X-Received: by 2002:a2e:2f02:: with SMTP id v2mr25391ljv.79.1596126259161;
        Thu, 30 Jul 2020 09:24:19 -0700 (PDT)
Received: from wasted.omprussia.ru ([2a00:1fa0:217:b665:71e9:90c2:18f2:5bd7])
        by smtp.gmail.com with ESMTPSA id y19sm1288960lfe.77.2020.07.30.09.24.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 09:24:18 -0700 (PDT)
Subject: Re: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
 <TY2PR01MB36928342A37492E8694A7625D8710@TY2PR01MB3692.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <793b7100-9a3a-11fd-f0cd-bf225b958775@gmail.com>
Date:   Thu, 30 Jul 2020 19:24:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB36928342A37492E8694A7625D8710@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 7/30/20 2:37 PM, Yoshihiro Shimoda wrote:

>> From: Yuusuke Ashizuka, Sent: Thursday, July 30, 2020 7:02 PM
>> Subject: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
> 
> Thank you for the patch! I found a similar patch for another driver [1].

   It's not the same case -- that driver hadn't had the MDIO release code at all
before that patch.

> So, we should apply this patch to the ravb driver.

   I believe the driver is innocent. :-)

> [1]
> fd5f375c1628 ("net-next: ax88796: Attach MII bus only when open")
> 
>> ravb is a module driver, but I cannot rmmod it after insmod it.
> 
> I think "When this driver is a module, I cannot ..." is better.

   Perhaps "... is built as a module".

>> ravb does mdio_init() at the time of probe, and module->refcnt is incremented
> 
> I think "This is because that this driver calls ravb_mdio_init() ..." is better.

   Yep.

> According to scripts/checkpatch.pl, I think it's better to be a maximum
> 75 chars per line in the commit description.

   Yes.
   (Note that for the source code the new length limit is 100, not 80.)

>> by alloc_mdio_bitbang() called after that.
>> Therefore, even if ifup is not performed, the driver is in use and rmmod cannot
>> be performed.

   That's not really obvious...

>> $ lsmod
>> Module                  Size  Used by
>> ravb                   40960  1
>> $ rmmod ravb
>> rmmod: ERROR: Module ravb is in use

   Shouldn't the driver core call the remove() method for the affected devices
first, before checking the refcount? 

>> Fixed to execute mdio_init() at open and free_mdio() at close, thereby rmmod is
> 
> I think "Fixed to call ravb_mdio_init() at open and ravb_mdio_release() ..." is better.
> However, I'm not sure whether that Sergei who is the reviwer of this driver accepts
> the descriptions which I suggested though :)

   The language barrier isn't the only obstacle. :-)

> By the way, I think you have to send this patch to the following maintainers too:
> # We can get it by using scripts/get_maintainers.pl.
> David S. Miller <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,commit_signer:8/8=100%)
> Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS)
> 
> Best regards,
> Yoshihiro Shimoda

   For the future, please trim your reply before the patch starts as you
don't comment on the patch itself anyway...

>> possible in the ifdown state.
>>
>> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>

[...]

MBR, Sergei
