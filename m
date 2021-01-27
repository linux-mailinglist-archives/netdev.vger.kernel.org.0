Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2D03053F6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhA0HIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbhA0HEx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 02:04:53 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51479C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 23:04:12 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id p15so753747wrq.8
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 23:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zTHZXEGeii8Bg/PBKpUvY3fvjskZYo9P7jh7mQMVolE=;
        b=SMuJVa733/vU8SWUbOy/efzai3Lm5+Hiq64tsQq5sR8J2x5WStuU06BefxQD3/CecO
         ldXB04w751u0CuBpNS1sG1IZAcL5rlFTZWnMrwhYTrffi/EhUK84DlJOwBFjfvvLS0XJ
         +1heNKyp4mZ9ZoF/QR3Kz2vCHWGQcqhrWAYaJslGxR+9ROZqypqpaWtMyPlelr+RGE1d
         jYbZkoupCQXTIyvO0sAzkps9NPJdJlSb9FoAsMAFAqpw7GSMuQeZ1uveXxutrz6AASQQ
         KWPuWMHKNm5HiBRihzdBYq6DLZWB2sRuopfAeoxW9WUyS0kSyshV+tVL5cbd0zlk7k9I
         bw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zTHZXEGeii8Bg/PBKpUvY3fvjskZYo9P7jh7mQMVolE=;
        b=pnIxnJgAbLpCy0d0yaiYcEZhJznNzDJVbd5UeuCeEpBWuH7Xugj5/zGvOkUPnVydEf
         fai76jKfcQCBxNN22In6AlQsyBlwUOFRLPLQlbpqQlxdZclxgNL05RKC97qvWr9hinZC
         JPP6aqud7u/cTcUJcharYW6luWrafZGtgwXghQ+kC9jUglwcyJf/0dCkdfop5vLtqlqJ
         ZoBdSJYKHgwOv6Ai9I/lro6G5NWtLHebWBKa59P4YSj6ISHjO0C7KWqugbtsroDpIj3e
         d7oxYAOH/8GGGliMbL/dHbngK48olt9VYFOtFSF6QXzF34n7WLLrHfb2rv4ZRxkoa7Jx
         vCaQ==
X-Gm-Message-State: AOAM531081kisxeSn/bE+k8OE6q9efjFz2F6NZvEKp4+I8enmq8oqwUZ
        ELKbR8XJ9wZz/ecbd78e7rk=
X-Google-Smtp-Source: ABdhPJxexQcjxpW1yblXpxsrwBGeIcgbhPcEIV2PInMqbQnrc2LYls6d1IEShV+jKRKsKZFsbqfdAQ==
X-Received: by 2002:adf:fbc5:: with SMTP id d5mr9552323wrs.82.1611731050936;
        Tue, 26 Jan 2021 23:04:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b9df:6985:25af:fab5? (p200300ea8f1fad00b9df698525affab5.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b9df:6985:25af:fab5])
        by smtp.googlemail.com with ESMTPSA id y11sm1638902wrh.16.2021.01.26.23.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 23:04:10 -0800 (PST)
Subject: Re: [PATCH net v2 7/7] igc: fix link speed advertising
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
References: <20210126221035.658124-1-anthony.l.nguyen@intel.com>
 <20210126221035.658124-8-anthony.l.nguyen@intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <988cd2d7-e9f2-3947-7fcc-3da7fef7e34b@gmail.com>
Date:   Wed, 27 Jan 2021 08:04:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126221035.658124-8-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.01.2021 23:10, Tony Nguyen wrote:
> From: Corinna Vinschen <vinschen@redhat.com>
> 
> Link speed advertising in igc has two problems:
> 
> - When setting the advertisement via ethtool, the link speed is converted
>   to the legacy 32 bit representation for the intel PHY code.
>   This inadvertently drops ETHTOOL_LINK_MODE_2500baseT_Full_BIT (being
>   beyond bit 31).  As a result, any call to `ethtool -s ...' drops the
>   2500Mbit/s link speed from the PHY settings.  Only reloading the driver
>   alleviates that problem.
> 
>   Fix this by converting the ETHTOOL_LINK_MODE_2500baseT_Full_BIT to the
>   Intel PHY ADVERTISE_2500_FULL bit explicitly.
> 
> - Rather than checking the actual PHY setting, the .get_link_ksettings
>   function always fills link_modes.advertising with all link speeds
>   the device is capable of.
> 
>   Fix this by checking the PHY autoneg_advertised settings and report
>   only the actually advertised speeds up to ethtool.
> 
> Fixes: 8c5ad0dae93c ("igc: Add ethtool support")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_ethtool.c | 24 +++++++++++++++-----
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 

Would switching to phylib be a mid-term option for you?
This could save quite some code and you'd get things like proper 2.5Gbps
handling out of the box. Or is there anything that prevents using phylib?
