Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6619137247C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 04:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhEDCjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 22:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDCjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 22:39:33 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB81CC061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 19:38:39 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso6982767otv.6
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 19:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fzswr3T0DuRH4QtHMTEbRmKutb10AfnTUoiq4bmIlUs=;
        b=UysPz4NjsfbkIB7XD5jTFYqj/5PFS9+I9PlvETtvR38++PJywDUmLPoYL7LxyMiUhV
         n0g3si6UQVBO7vVZmeXJHlPEuPIagi9t7sg/Psy+dZIa5G7NdiZwqan99+28QkCd7RbL
         J1jaQ+ZMQCUpCIr8LiiG35tyJdGuLVVCe2UE/BbY8cSeftDf9tlrT37l3U6PflJ4d+pe
         QckhDcXmKS6AaRtLOIWvXPdgicwtRA65i7MOwe43coyrk98qmJamNebi5UzELc+n58Yu
         AdVEyXUxNjS5ViMeGMUBkbBKoOwzL9nnFYvuv+VsCi8JPJJPXkYzDz33piQ8Aczc9whV
         1HVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fzswr3T0DuRH4QtHMTEbRmKutb10AfnTUoiq4bmIlUs=;
        b=YrAuZaS7AqBIq4bSCEOuuYIKdl2EJoyP8SL66rpoJW1wMDOuFfp9XYAzsOIDHkN3Rp
         Lh9rI/ouOgiulkK3VlMGmMcrse0DaWFlh+mKusOvXDvY6PricDmZEozYwV/uHsnhj7UY
         /boKK/p23PKRCOnAEWahdPK7+QOkRQN83Xuz5Hm83b6EPVH2I2Nj0IfR70eV1bxjB7iS
         IF28cPJDnIwZvnb8zB6vasq2UGh8PVkt3KlRK0XhM0f+5ayo8Yw/oy97sW1BxkTntKb2
         PDq8kmF9swjs2N7r+kgs2DlBE/UdRTnvHjhlfSGn7Kg70xSlwQEDxlC13uDG233MdI3t
         A6Ag==
X-Gm-Message-State: AOAM533rrLWo9U060T5mdtAjsfqfYPDTatr1fT6bdANy+1AjL2RoFjEs
        kUsUGLZFzhqb2TTDSqjMghA=
X-Google-Smtp-Source: ABdhPJzMuBEzzoa6bS7JgL//h/qaQ+XkUlRWC7KJFUIYde+WpIWBnKL3dvKy369MMoNrLc67oc3/Sw==
X-Received: by 2002:a05:6830:13c4:: with SMTP id e4mr3050559otq.315.1620095918101;
        Mon, 03 May 2021 19:38:38 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id 64sm386427oob.12.2021.05.03.19.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:38:37 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 03/10] ipv4: Add custom multipath hash policy
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210502162257.3472453-1-idosch@idosch.org>
 <20210502162257.3472453-4-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7cfadc51-2d4a-f7ed-f762-eb001b0c2b32@gmail.com>
Date:   Mon, 3 May 2021 20:38:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210502162257.3472453-4-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 10:22 AM, Ido Schimmel wrote:
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 8ab61f4edf02..549601494694 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -99,6 +99,8 @@ fib_multipath_hash_policy - INTEGER
>  	- 0 - Layer 3
>  	- 1 - Layer 4
>  	- 2 - Layer 3 or inner Layer 3 if present
> +	- 3 - Custom multipath hash. Fields used for multipath hash calculation
> +	  are determined by fib_multipath_hash_fields sysctl
>  

If you default the fields to L3, then seems like the custom option is a
more generic case of '0'.
