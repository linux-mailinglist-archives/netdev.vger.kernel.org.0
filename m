Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8201B415007
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbhIVSl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhIVSl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:41:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DBAEC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:40:27 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g14so3523548pfm.1
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vTPNf/kTo/TH9SDJCPQ7/Gs3G3O6SAwKWu6wQOct3c4=;
        b=RBhwavhBnq0fV0TvaAqXYwkigZ9w2+TBtW0QfBLYhGzp0rU250dCGLdPC9B6EWdhqn
         RPN+lfY8UlBhQEppFEJqPLbtsWGHAZh6Lza10BOgCNVW6YHmrhZjyybSpJzbtbEco2+C
         3fZEi0sK7FYLQeJ/Hki2vSwDjypcGxjCPhaXDqgecioPO0NsQuk6+RV78gJ0M1T25SNf
         xZGwY4Vy0zJyzE+xYUgEzUJ+H4MHJk6viM5kNSIR77+UyJuBQqmW7woKmGj9k4lLToto
         7iK0yttZse+l9axD+ULE4iG8Pfqr2+BHYUxkQvWpIzqkNxYlgHUz/UbgQjLu4dM8+xqP
         RcGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vTPNf/kTo/TH9SDJCPQ7/Gs3G3O6SAwKWu6wQOct3c4=;
        b=pQw1nOfnAFmQlB4Sy1mQpreFWEKcPKYGbLtq6/3HQ4iLPSPJasLZojL6eAB6JPd+ad
         UWkqKO02owDJJf0VITsC6mQ0lLx6vEZG9cLzt2RBEtO2KiBZSHhxCXnW1LWmJyO5T2TC
         +t1/w13fj8LCxzeaToaWqX6BlCEKb9xZwc6bWIey0bkVa5GxSPkl6C9PoaKJodwpi3Vn
         dE7DfGrIWBybbA0hMo0GHItbah5EQNzaldV2DfdxCZmL61i82WM6awt/JQGGEt7wUYKn
         BMZAwuDzP/btcdaOrrbsyCzT71Wpq9hzvfjl43YDum/m+wEZyO9egAU9SlRFvv8sb1zU
         qhJA==
X-Gm-Message-State: AOAM531lq5gIfSkK7KW5MNsRbCKkMkLfOJ4b8wCET8H8tvB5/sXnZzGz
        8mVkNIfjEaS9m3KVukcXIm3rvYKHXF0=
X-Google-Smtp-Source: ABdhPJxQfJExAi00VKIW/cFMRcA0Kfo+dueUFTRYAWacM5LgfckeF/WtnI7FWgCGsJFe4VYlHU65tw==
X-Received: by 2002:a63:6941:: with SMTP id e62mr360759pgc.114.1632336026794;
        Wed, 22 Sep 2021 11:40:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x71sm3234706pfc.146.2021.09.22.11.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 11:40:26 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: sja1105: stop using priv->vlan_aware
To:     Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210922144401.2445527-1-vladimir.oltean@nxp.com>
 <20210922162443.rdwyp4phk6cwpmm3@skbuf>
 <20210922183837.z2ujekutxyasvxde@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d78f2bab-6c2a-73d3-080a-d5607af9be6e@gmail.com>
Date:   Wed, 22 Sep 2021 11:40:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922183837.z2ujekutxyasvxde@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 11:38 AM, Vladimir Oltean wrote:
> On Wed, Sep 22, 2021 at 07:24:43PM +0300, Vladimir Oltean wrote:
>> On Wed, Sep 22, 2021 at 05:44:01PM +0300, Vladimir Oltean wrote:
>>> +	if (!dsa_port_is_vlan_filtering(ds, port) &&
>>
>> omg, what did I just send....
>> I amended the commit a few times but forgot to format-patch it again.
>> The dsa_port_is_vlan_filtering prototype takes a "dp" argument, this
>> patch doesn't even build. Please toss it to the bin where it belongs.
> 
> Superseded by v2 which has message ID 20210922183655.2680551-1-vladimir.oltean@nxp.com
> Florian, please note that I did not preserve your Reviewed-by tag, due
> to the patch looking fairly differently now.

Yes I completely missed that argument misuse, the changes look logically
correct, too quick in reviewing I guess :)
-- 
Florian
