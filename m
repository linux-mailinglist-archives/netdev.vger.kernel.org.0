Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A694AF6CA
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfIKHRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:17:42 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33545 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfIKHRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:17:37 -0400
Received: by mail-pl1-f193.google.com with SMTP id t11so9775825plo.0
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 00:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vK9LroaLrqFKTAAzuJSfW3S8K0J+oG9HVYeUV6VkQRQ=;
        b=AnYVwkT+JAZcu5bckHC3U+QWUpM0qh5ewaZj/QqEKbLogGVjDbC6QKU4tVHCPJvXG/
         WajIGDpz4PoHp9ILTSPV6E7ohZW01ugYD4KtvDo3reBJbxDPJeP7CgJj0djcpOiba57P
         F8ct5YY9ZXsihASVvEQXw52KjV4+R3CWgI3rvIPayMjPOMwR+kyr84/9eLzDxN6bsCED
         pLeKQRkW6WTrWgYUZG9wBAwJrGIHTO8yPndeD8i4tlLluIl8dLvld7OOfAwVQhhpr3VN
         morbk9HgvhtGpVFcbtodlMCnSyHa2nCSEDI+8zagYPuoJb5kK1aR9tHgnRqSlAI9e6pN
         rlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vK9LroaLrqFKTAAzuJSfW3S8K0J+oG9HVYeUV6VkQRQ=;
        b=XSypR9oMvuQirl++GJu2r0yt/ZgJRbiYeHjHdVpRp5wpx/DhJ6OBp+86EYtR9fY29w
         nbjLjS37K4jwAqccpqOC76eM1VhD7m3NF0xSsqv9s553FW29SoTDk4pO00GK+ZwU8uN2
         tFo3k4IyW8ep5YbYRr1pD/iCQKfiSdT3kcuEM3p1n7jiTP/sXcmN3JQG7Dn6wubJwurV
         ERi00vfvzWhtszm1UnqAL4A0MV3TsEEMGp3+J/gvramLdoO6hHgQjvGzdqQqZPokonKB
         3c5WpSLopb7kSDXyUtg6jYcZuIohfJ69jPvl5/2LHc/G3RZo4i8f64pkNa9WIt8+Nsqc
         zKYQ==
X-Gm-Message-State: APjAAAUM44d8p9HEYDJJ8utsSzvsB8CO1r6wuwv2FjmtlhfWgzNd2aT+
        NnHEC0TaEGaTMVwbodHG58AMUw==
X-Google-Smtp-Source: APXvYqw/gRDuv/wkYyVGBub57NLu9OUZaGAgKSO03/rLWxJ9rGUQVnyL4XTu4ULVNN8dTB8wdczBtw==
X-Received: by 2002:a17:902:7047:: with SMTP id h7mr33470433plt.275.1568186256537;
        Wed, 11 Sep 2019 00:17:36 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b20sm24444193pff.158.2019.09.11.00.17.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 00:17:35 -0700 (PDT)
Subject: Re: ixgbe: driver drops packets routed from an IPSec interface with a
 "bad sa_idx" error
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Michael Marley <michael@michaelmarley.com>
Cc:     netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
References: <10ba81d178d4ade76741c1a6e1672056@michaelmarley.com>
 <4caa4fb7-9963-99ab-318f-d8ada4f19205@pensando.io>
 <fb63dec226170199e9b0fd1b356d2314@michaelmarley.com>
 <90dd9f8c-57fa-14c7-5d09-207b84ec3292@pensando.io>
 <6ab15854-154a-2c7c-b429-7ba6dfe785ae@michaelmarley.com>
 <20190911061547.GR2879@gauss3.secunet.de>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <dbd7ca5e-289f-2937-5b49-f2440d825aa5@pensando.io>
Date:   Wed, 11 Sep 2019 08:17:31 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911061547.GR2879@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 11:15 PM, Steffen Klassert wrote:
> On Tue, Sep 10, 2019 at 06:53:30PM -0400, Michael Marley wrote:
>> StrongSwan has hardware offload disabled by default, and I didn't enable
>> it explicitly.  I also already tried turning off all those switches with
>> ethtool and it has no effect.  This doesn't surprise me though, because
>> as I said, I don't actually have the IPSec connection running over the
>> ixgbe device.  The IPSec connection runs over another network adapter
>> that doesn't support IPSec offload at all.  The problem comes when
>> traffic received over the IPSec interface is then routed back out
>> (unencrypted) through the ixgbe device into the local network.
>
> Seems like the ixgbe driver tries to use the sec_path
> from RX to setup an offload at the TX side.
>
> Can you please try this (completely untested) patch?
>
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 9bcae44e9883..ae31bd57127c 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -36,6 +36,7 @@
>   #include <net/vxlan.h>
>   #include <net/mpls.h>
>   #include <net/xdp_sock.h>
> +#include <net/xfrm.h>
>   
>   #include "ixgbe.h"
>   #include "ixgbe_common.h"
> @@ -8696,7 +8697,7 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
>   #endif /* IXGBE_FCOE */
>   
>   #ifdef CONFIG_IXGBE_IPSEC
> -	if (secpath_exists(skb) &&
> +	if (xfrm_offload(skb) &&
>   	    !ixgbe_ipsec_tx(tx_ring, first, &ipsec_tx))
>   		goto out_drop;
>   #endif

Thanks, Steffen, that looks right to me.

sln


