Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820C9195430
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgC0Jj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:39:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39331 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgC0Jj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:39:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so10563522wrt.6
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 02:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=48hZS89xmAyHCOE0ApnOj1N48gY8ID4cAQz2E2A0Azc=;
        b=V9c30TsK8PsLns3yn2l4Ccl/KdXM5UPqHFpGi7i8J3ZV81kcD9uUUfzHYbfEm9sKLs
         gVJxyQfn8SDERVNyU8JLUkSvQJBdaYkhXIhhf5z0pTzsZVHGPx6sJxTASR0uWM7Qwrt+
         PTFp9WHx11YuXF8qRqafYbDbTEsX+F5Rfb8Y56FJnXwhKtCia3uRMrCoFSzVV6x05cTP
         pgIgUlTlZaEwzBo9c+sECtiN7Qit9PZ+kXDS4AOxyoa9VEZmG3jA4X2gUWv8I4l+J/ho
         3K+FBngDl3yepsX+AqXgE5j8ibNaDg1H9VeHsQjGMmRtDXgcN10Ya8I6SkqXOxpJLaLe
         mNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=48hZS89xmAyHCOE0ApnOj1N48gY8ID4cAQz2E2A0Azc=;
        b=LD68ECAtctmPpsU4wj2yqq2kmJdBO1pT9NqlyRlJgNzWgyahgIx7p+8QTKuIaZmrNF
         Tzo1Gxxo1ORZOZkSDemLXAGYBLqXjKRHlj5FN3rJ6uenkZ57XWd1Y/OkmoUydo87JTDX
         jAEdN7KxVqCBov8IzIeCAgf5oWaZ29ywfPn8VM2ch1OAwjRfDLKm9rXtoOF/4uR3Oh+Y
         paOGwmC4laaabZAr/8wdtPlGYyljRfWZk1qJNM7NyGXghBU2KmgZRyf40B9FXA+J4RJv
         rlknPAEcyTjEDMF0C1SbBcgNzop/0F2Z/NTuZcT7LITuhJSHj4F+lu91X3NU8cM+5Nwz
         2XfA==
X-Gm-Message-State: ANhLgQ3ftJ0dJLMLGc51KxDMJmWlUtejS6WpgmyTD31LHCCIj6mK1wPt
        v4akdISUTLkzpl+hs0lb1zpcA803
X-Google-Smtp-Source: ADFU+vvsi42vksdqfGi1sFTX56HaSVup10tyXT181KAOtuhQaX8s3Cg2rEN/lMMw72jMgNRJBuyydQ==
X-Received: by 2002:adf:ec02:: with SMTP id x2mr10656058wrn.365.1585301966262;
        Fri, 27 Mar 2020 02:39:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:9d76:401f:98cb:c084? (p200300EA8F2960009D76401F98CBC084.dip0.t-ipconnect.de. [2003:ea:8f29:6000:9d76:401f:98cb:c084])
        by smtp.googlemail.com with ESMTPSA id e5sm7231461wru.92.2020.03.27.02.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 02:39:25 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Charles Daymand <charles.daymand@wifirst.fr>,
        netdev@vger.kernel.org
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
Date:   Fri, 27 Mar 2020 10:39:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200327090800.27810-1-charles.daymand@wifirst.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2020 10:08, Charles Daymand wrote:
> During kernel upgrade testing on our hardware, we found that macvlan
> interface were no longer able to send valid multicast packet.
> 
> tcpdump run on our hardware was correctly showing our multicast
> packet but when connecting a laptop to our hardware we didn't see any
> packets.
> 
> Bisecting turned up commit 93681cd7d94f
> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
> which is responsible for the drop of packet in case of macvlan
> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
> case since TSO was keep disabled.
> 
> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
> issue, but we believe that this hardware issue is important enough to
> keep tx checksum off by default on this revision.
> 
> The change is deactivating the default value of NETIF_F_IP_CSUM for this
> specific revision.
> 

The referenced commit may not be the root cause but just reveal another
issue that has been existing before. Root cause may be in the net core
or somewhere else. Did you check with other RTL8168 versions to verify
that it's indeed a HW issue with this specific chip version?

What you could do: Enable tx checksumming manually (via ethtool) on
older kernel versions and check whether they are fine or not.
If an older version is fine, then you can start a new bisect with tx
checksumming enabled.

And did you capture and analyze traffic to verify that actually the
checksum is incorrect (and packets discarded therefore on receiving end)?


> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr>
> ---
>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
> index a9bdafd15a35..3b69135fc500 100644
> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>  		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>  		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> +		if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
> +			dev->features &= ~NETIF_F_IP_CSUM;
> +		}
>  	}
>  
>  	dev->hw_features |= NETIF_F_RXALL;
> 

