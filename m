Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BDA270960
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 02:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgISANe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 20:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgISANe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 20:13:34 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63091C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 17:13:30 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id j7so3814342plk.11
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 17:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DSivMfFX4LchJKRtonhlWtBQ7XG7j++xRPsnjvgGrDs=;
        b=OfSypDWsr5RLqbkMc/zGF3m2AZxt0sMZgaWtMW+8pUm99X8Y5HBwTlO3L6lBw6twCu
         Y7uS7Tx0ve2/PfXqKpw3GcMoIs8rZf1Hx6MRgN1PRiIXQfeKw0x8d4yOxXHlVSJjfXHT
         HZSuv2SB+aK7QuUkh89DsYe/c+HbvO7VstWrGKinHDSH1FT8qZQ5kLn3Owak661p8DtB
         50lexkkGCjcMHYIYetAweHL4+9bYFPQfu4MKIdlC55u/VmqHGQoKEoUiD0H6+tx/TBty
         MAebUJqHzWqxd++JL4Vh3COOg4Q9pJ8ZblEMfF8NW0G0K6cDuCUJVjagSZDtFzxC3JDR
         U33A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DSivMfFX4LchJKRtonhlWtBQ7XG7j++xRPsnjvgGrDs=;
        b=KE3DNJcRqQw5K1AMkgCJI8vORyR3ArAj6NhDl91ceJCthQHCv0anrL4o5HVk8Uut/+
         BwYzNJK7W56UgdziUPmbuyRTYLOUEz/k/DUxJUtsBvEDUd5FASdHI+EAJU++KbuY1stE
         Py2RA0fKeFaxYNXgROz03RGSUzELOS60CF7gUarzr7The6V4/dAwZvKkB+k3HfNh7htS
         +ovIwSfwfc15QciUFzHmu9+y9+b10tTUhapUMp2IL6UQesRkignQ6G5PlDnL1IrmCSyS
         9Su8NNEZfBz4HDn/vF32rVj6yPDyvna/bYsuH2CpIbYXNN5MUrEQGWUBG39snQKMXi48
         vXWQ==
X-Gm-Message-State: AOAM5333yzXhUOZfSGaYimZVERHOkq2GaXJffll3MhPVvske81rQ6yYA
        qGxXfW6BF7sMmkdsIa+j1EGHlw==
X-Google-Smtp-Source: ABdhPJw9a319JVbIqufugrOtEwzU8yliHBpQaBQFs/No7G2zEFX4Okg0e+r4N7A1cEbmZJeDmuL1YA==
X-Received: by 2002:a17:902:eb03:b029:d1:8c50:aafb with SMTP id l3-20020a170902eb03b02900d18c50aafbmr35721295plb.29.1600474409888;
        Fri, 18 Sep 2020 17:13:29 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id j13sm1236670pjn.14.2020.09.18.17.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 17:13:29 -0700 (PDT)
Subject: Re: [net-next v7 0/5] devlink flash update overwrite mask
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200918234208.1060371-1-jacob.e.keller@intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <08a7e6ef-ab23-9718-5fce-cdc53191197e@pensando.io>
Date:   Fri, 18 Sep 2020 17:13:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200918234208.1060371-1-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/20 4:42 PM, Jacob Keller wrote:
> This series introduces support for a new attribute to the flash update
> command: DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK.
>
> This attribute is a bitfield which allows userspace to specify what set of
> subfields to overwrite when performing a flash update for a device.
>
> The intention is to support the ability to control the behavior of
> overwriting the configuration and identifying fields in the Intel ice device
> flash update process. This is necessary  as the firmware layout for the ice
> device includes some settings and configuration within the same flash
> section as the main firmware binary.
>
> This series, and the accompanying iproute2 series, introduce support for the
> attribute. Once applied, the overwrite support can be be invoked via
> devlink:
>
>    # overwrite settings
>    devlink dev flash pci/0000:af:00.0 file firmware.bin overwrite settings
>
>    # overwrite identifiers and settings
>    devlink dev flash pci/0000:af:00.0 file firmware.bin overwrite settings overwrite identifiers
>
> To aid in the safe addition of new parameters, first some refactoring is
> done to the .flash_update function: its parameters are converted from a
> series of function arguments into a structure. This makes it easier to add
> the new parameter without changing the signature of the .flash_update
> handler in the future. Additionally, a "supported_flash_update_params" field
> is added to devlink_ops. This field is similar to the ethtool
> "supported_coalesc_params" field. The devlink core will now check that the
> DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT bit is set before forwarding the
> component attribute. Similarly, the new overwrite attribute will also
> require a supported bit.
>
> Doing these refactors will aid in adding any other attributes in the future,
> and creates a good pattern for other interfaces to use in the future. By
> requiring drivers to opt-in, we reduce the risk of accidentally breaking
> drivers when ever we add an additional parameter. We also reduce boiler
> plate code in drivers which do not support the parameters.
>
> Cc: Jiri Pirko <jiri@mellanox.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Bin Luo <luobin9@huawei.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Ido Schimmel <idosch@mellanox.com>
> Cc: Danielle Ratson <danieller@mellanox.com>
> Cc: Shannon Nelson <snelson@pensando.io>

Thanks Jake.  For ionic:
Acked-by: Shannon Nelson <snelson@pensando.io>


