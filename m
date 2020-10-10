Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531BE28A216
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387926AbgJJWyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731251AbgJJTFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:05:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD75DC08EC3C;
        Sat, 10 Oct 2020 11:04:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e7so710085pfn.12;
        Sat, 10 Oct 2020 11:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=G7Wfxd5rme1m7TClufp4VEut1kgj/lI9DWLimurfbPU=;
        b=LWsO8rw+FZR5RRECdnqbt7diUHNUjZdWF2oU2FMh0RyNEgdVxtw0fHHKEPiC/TmnF9
         j+lCXbh6uGaWIRSCzQoH3VogVmXxU0Szx4+bFHsB9bb/2F6rsOxPzirPJshPMdWoJP6Q
         CPvEXYrpZ+R7z2Hpv0HEpDoDGCrSctQpIsvrgVB/JbkttjjPTEhELFLz0t6adTLCtAfa
         +EbbDH6FYZ3txeF2PulBp/mzRnwj9vglchUGBtR2vD6XcIvoig6Xh7f7N9Abv10xBlvi
         4odPi5MLdHJjxReojngmNLMuO7zbszXE6I4SQEmDU3FIoEIb1W99pNyZXwJ0BB+lFj2C
         utKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=G7Wfxd5rme1m7TClufp4VEut1kgj/lI9DWLimurfbPU=;
        b=KL3tQKtkws4PzuripJJe2wAHLPxQY7wrAXYFe1E+vaqiE8bwJfmKDBz4koL1Lj6+ef
         1JczYAwD06V35W4L/IIXmmmvEf7YibZr8VA0ljJvd/j1q/moTcGDzk4ynUBru0b7bO1k
         Bej/WlUFmWOj0xYyCVwo4Wf6TcTzuENuXpU3w+nV6HqPG7bevc1jHhLOI87Cc8N+85NZ
         FytA7mMSAmkvly37Gcz03QD8etjjwC1XHMCix9eMF5+ofhD4LoEKxgTd/xsw1FPF+09k
         CWWnjoSekFKBRLqAhNlqKPzmWSVWbrPELC8InHpmja89s7Q02tpHfBy3UopIR1iNn4ki
         0+8A==
X-Gm-Message-State: AOAM532R55gMgapkklmfI9DjvAmImsxAXY7viY14MGxfTiCqFYqZ5nuP
        6rGxTLf08mLnyVyheYObAubWUF8KUN6QRNJ554o=
X-Google-Smtp-Source: ABdhPJxPOFAi9ocv/veCG4BPSrVt24N8PY2lvwQ4bnT1hXZ0f8ZFHG2J43pWpbWhkBhgpK3kdJP0uQ==
X-Received: by 2002:a17:90a:aa18:: with SMTP id k24mr11040344pjq.231.1602353096497;
        Sat, 10 Oct 2020 11:04:56 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.200.2])
        by smtp.gmail.com with ESMTPSA id t7sm16189012pjy.33.2020.10.10.11.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 11:04:55 -0700 (PDT)
Subject: Re: [PATCH] net: usb: rtl8150: don't incorrectly assign random MAC
 addresses
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Petko Manolov <petkan@nucleusys.com>,
        "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
 <20201010095302.5309c118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <0de8e509-7ca5-7faf-70bf-5880ce0fc15c@gmail.com>
Date:   Sat, 10 Oct 2020 23:34:51 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201010095302.5309c118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 10/10/20 10:29 pm, Jakub Kicinski wrote:
> On Sat, 10 Oct 2020 12:14:59 +0530 Anant Thazhemadam wrote:
>> get_registers() directly returns the return value of
>> usb_control_msg_recv() - 0 if successful, and negative error number 
>> otherwise.
> Are you expecting Greg to take this as a part of some USB subsystem
> changes? I don't see usb_control_msg_recv() in my tree, and the
> semantics of usb_control_msg() are not what you described.

No, I'm not. usb_control_msg_recv() is an API that was recently
introduced, and get_registers() in rtl8150.c was also modified to
use it in order to prevent partial reads.

By your tree, I assume you mean
    https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/
(it was the only one I could find).

I don't see the commit that this patch is supposed to fix in your
tree either... :/

Nonetheless, this commit fixes an issue that was applied to the
networking tree, and has made its way into linux-next as well, if
I'm not mistaken.

>> However, in set_ethernet_addr(), this return value is incorrectly 
>> checked.
>>
>> Since this return value will never be equal to sizeof(node_id), a 
>> random MAC address will always be generated and assigned to the 
>> device; even in cases when get_registers() is successful.
>>
>> Correctly modifying the condition that checks if get_registers() was 
>> successful or not fixes this problem, and copies the ethernet address
>> appropriately.
>>
>> Fixes: f45a4248ea4c ("set random MAC address when set_ethernet_addr() fails")
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> The fixes tag does not follow the standard format:
>
> Fixes tag: Fixes: f45a4248ea4c ("set random MAC address when set_ethernet_addr() fails")
> Has these problem(s):
> 	- Subject does not match target commit subject
> 	  Just use
> 		git log -1 --format='Fixes: %h ("%s")'
>
>
> Please put the relevant maintainer in the To: field of the email, and
> even better - also mark the patch as [PATCH net], since it's a
> networking fix.

The script I've been using for sending patches in had been configured to CC
the maintainer(s) and respective mailing list(s). Sorry about that.

I will put the relevant maintainer in the To: field, fix the Fixes tag, and
mark the patch as [PATCH net] as well and send in a v2.

Thank you for your time.

Thanks,
Anant
