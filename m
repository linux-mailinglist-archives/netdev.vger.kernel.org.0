Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903D72FADB1
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 00:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404014AbhARXLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 18:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbhARXLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 18:11:20 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708C0C061573;
        Mon, 18 Jan 2021 15:10:40 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id 34so7150459otd.5;
        Mon, 18 Jan 2021 15:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YKM2X4wwUdQ578gqAdzYuCY1qiQMQTEjO9ZyJU1dqug=;
        b=G2+vvjnutm+/HGZ9GjAjoAtP4zO26tu4TC44KdNHyc6BKPHNpiILtGGDx8GX/MJMqK
         13am9cCPL8CJnCH9/GXbUuvuJ+8VVYl4Uc14tx3qQF4DNw33Yz2vsLZ7ItamlR0GVoby
         xeDXm4DX7KeGgI/wzlAiIw91QZpUkzkZS5RC4lEcBxyJv/MgvqIIW/ceffrX1p2w+exl
         TkeQ5FsOT6XDgJuxHsNKz8SojlxnX8ULvSi+j6jZ3voVFQBJh1OvW3kFenDgENx+wlX4
         ceoZzaV/5+JWzGmJWodVjU2w5+eFnbjJQ1e0XwfqfFn1OMGhjlvlJN3Hg93wmWEgaBae
         EYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YKM2X4wwUdQ578gqAdzYuCY1qiQMQTEjO9ZyJU1dqug=;
        b=NQxX9X5rXI62jgV8S6cPm6xzVTi6buYYu6nf36zGcymD+TKaxe6/uWzjnJ1Mm4PhQ6
         Ryji1W2IWnfXfb7vsGsAFWFiDFK5J9ZxAs3F60KVeXJkQgQbWTY6JGuIKRHHjGlawRFZ
         o8TCuIM661W7WthZB1sm25K80AI6yCvFFeh0ctrZZktiFmJreTeNWDUMFx5GO1rpyTH2
         ha8CfcuSTfhf1E9NRWQwqhDgNEQAJY3IUZfGybdWYqbRXWSZDG6WZdgWSWJcPPMqUtJW
         ZuGp01icf8DkLvxfHRUJlrKAouyo07P2kDxF7GVokoWP+35Z9jWoaGwn3YkE2uNz73Ma
         Igbg==
X-Gm-Message-State: AOAM5306vlv7Ohgt93QRDLKAaXJ3VS6NlMSpMyFR0PEUR0xyuUCp8OIe
        HmIEywWLzF6aI+jW5GuLW0q8oRb5S/I=
X-Google-Smtp-Source: ABdhPJyxsLhsQOCA8/TPcEd2K77PtM2Fj43QMa42tZIIiyIz0RsgfxBQ7iALAI+u/0jWu82PNgLIQw==
X-Received: by 2002:a05:6830:1bef:: with SMTP id k15mr1338351otb.303.1611011439702;
        Mon, 18 Jan 2021 15:10:39 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.162])
        by smtp.googlemail.com with ESMTPSA id n11sm3563548oij.37.2021.01.18.15.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 15:10:39 -0800 (PST)
Subject: Re: [PATCH net-next v3] bonding: add a vlan+srcmac tx hashing option
To:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
References: <20210113223548.1171655-1-jarod@redhat.com>
 <20210115192103.1179450-1-jarod@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <79af4145-48cc-0961-b341-c0e106beb14b@gmail.com>
Date:   Mon, 18 Jan 2021 16:10:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210115192103.1179450-1-jarod@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 12:21 PM, Jarod Wilson wrote:
> diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> index adc314639085..36562dcd3e1e 100644
> --- a/Documentation/networking/bonding.rst
> +++ b/Documentation/networking/bonding.rst
> @@ -951,6 +951,19 @@ xmit_hash_policy
>  		packets will be distributed according to the encapsulated
>  		flows.
>  
> +	vlan+srcmac
> +
> +		This policy uses a very rudimentary vland ID and source mac

s/vland/vlan/

> +		ID hash to load-balance traffic per-vlan, with failover

drop ID on this line; just 'source mac'.


> +		should one leg fail. The intended use case is for a bond
> +		shared by multiple virtual machines, all configured to
> +		use their own vlan, to give lacp-like functionality
> +		without requiring lacp-capable switching hardware.
> +
> +		The formula for the hash is simply
> +
> +		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
> +
>  	The default value is layer2.  This option was added in bonding
>  	version 2.6.3.  In earlier versions of bonding, this parameter
>  	does not exist, and the layer2 policy is the only policy.  The
