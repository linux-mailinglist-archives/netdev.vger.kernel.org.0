Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4971D1651D7
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBSVmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:42:02 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32846 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSVmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:42:01 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so1366641lfl.0;
        Wed, 19 Feb 2020 13:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VEk1jczyN0OI7UPJElzxYnut4DWzleHzhCa3whUE/CU=;
        b=S/7npCVFJFbsTkochGFmBPTlrGIJaY7oXM9SGAEuujzbQJYcVKLD4qB2hMsBNLQ6D1
         1qbBNi24oKyWaBR/faUh9QiZ7f7UAuDZfzmYk0Ckf3OreL+EI48f0txeWiz2n+1uNtRl
         Ct7TZ6PU7/iesTYju+4FtJawwbOID9IoWeWQlPSjp0EQ08gAgn4qNkUro0CbFDJeNXeS
         JyO3MCSi48tVG6+gShp5M6y2vl5YgjtULhS6nKw8pwT+iQpyIdyJhnf5FDR+MPmTRn+i
         JkcjHJNJiPLvTBp5D1BD7TVGVUE6zos1eXhAliOzRjTsYKymLbp6OQ6WQrQ44r7MrQ/I
         KCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VEk1jczyN0OI7UPJElzxYnut4DWzleHzhCa3whUE/CU=;
        b=RcjxlHAUL2KqN++jnlJ1grEvuRC3ZcZCYcylBFO7Y7m43OF6WyQjZQ+1BCYfeY3h/+
         Oa88r4MovB+e77JVRkmdffBadeAKP+JlmXE5riLtWg88AGyqAio/XnzQI8TJWbqCj+Zo
         7LsgVrzTvbQgYCN06xG3/bJLKrvGdAzmXtoVQzec4PysKUXsWDODM2ungKnp+lWkMsHn
         BO4c+oPEiCdOzkgLjCsS8sN/CRJ9MLQO3+6J6HVv1b+USNx2RRRguFwfv7FsOSevkPKj
         EI+2fWAIn8x4ZZpKNT1XZBzHR6Ek9Bbyb5EvqFeP2tqvbvHGH3YtTxo/m/eVsZbgvX9C
         HpiA==
X-Gm-Message-State: APjAAAUSlEvHWdHwer2BHl4FFD5UGKCZB16CorrImeC3sImsDihcc81o
        b1uRnLsISSvyI80zs6iLERm0a5fi
X-Google-Smtp-Source: APXvYqzpG6cs12Rq8hl94132hyOOS/pxFQUZtufPNFB7XWQgAC1lHrRFOlMN0zDX9fZ1O1r0Lyl+fA==
X-Received: by 2002:a19:c3c2:: with SMTP id t185mr14600751lff.56.1582148518536;
        Wed, 19 Feb 2020 13:41:58 -0800 (PST)
Received: from [192.168.2.145] (79-139-233-37.dynamic.spd-mgts.ru. [79.139.233.37])
        by smtp.googlemail.com with ESMTPSA id m24sm546736ljb.81.2020.02.19.13.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 13:41:57 -0800 (PST)
Subject: Re: [PATCH v1] nfc: pn544: Fix occasional HW initialization failure
To:     David Miller <davem@davemloft.net>
Cc:     sameo@linux.intel.com, david@ixit.cz, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200219150122.31524-1-digetx@gmail.com>
 <20200219.111130.5189327548859835.davem@davemloft.net>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <7723e3ad-e004-a691-6605-50ce05132162@gmail.com>
Date:   Thu, 20 Feb 2020 00:41:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200219.111130.5189327548859835.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

19.02.2020 22:11, David Miller пишет:
> From: Dmitry Osipenko <digetx@gmail.com>
> Date: Wed, 19 Feb 2020 18:01:22 +0300
> 
>> The PN544 driver checks the "enable" polarity during of driver's probe and
>> it's doing that by turning ON and OFF NFC with different polarities until
>> enabling succeeds. It takes some time for the hardware to power-down, and
>> thus, to deassert the IRQ that is raised by turning ON the hardware.
>> Since the delay after last power-down of the polarity-checking process is
>> missed in the code, the interrupt may trigger immediately after installing
>> the IRQ handler (right after the checking is done), which results in IRQ
>> handler trying to touch the disabled HW and ends with marking NFC as
>> 'DEAD' during of the driver's probe:
>>
>>   pn544_hci_i2c 1-002a: NFC: nfc_en polarity : active high
>>   pn544_hci_i2c 1-002a: NFC: invalid len byte
>>   shdlc: llc_shdlc_recv_frame: NULL Frame -> link is dead
>>
>> This patch fixes the occasional NFC initialization failure on Nexus 7
>> device.
>>
>> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> 
> Applied and queued up for -stable, thanks.
> 

Awesome, thanks!
