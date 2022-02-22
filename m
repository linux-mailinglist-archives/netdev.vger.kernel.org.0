Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F5E4C00FC
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 19:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiBVSKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 13:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbiBVSKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 13:10:19 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E52E1728BE
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:09:54 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p23so17711302pgj.2
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 10:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gEnj0v1tOxsK740DLh0+6gTCx0wOJGgd6bQVzp6TRDQ=;
        b=S/Y9Vfhyp+tP2xeA/zlpt1GYovfo64o4c5m11liPMjFPmjD+HWIci9mFEKj/wy1tH/
         C7kxfgw+AfldvNeWNdlIiO///R/NpCwKI+aD0bL8k6VaLMXezQs1B38j8tH4R6/DJnWF
         JAq/2WPGcfwSXHUUr8sCihkQzj5m1MfvAwECjQfEHIs4MUwyrheWk3DcKykt2ri9Sa2o
         SXomg/E7CRulXban2c7wZX00jMnSa+O+HhndV5fnGopsYTTS3OCuwBYEylg69Ads2MYI
         /MaJxnuckWKkLEaZepbM8xO4b0X39Bhz4nyd+dEiT9j5o1y7HUmN2w2XQvl+chH237KF
         8zLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gEnj0v1tOxsK740DLh0+6gTCx0wOJGgd6bQVzp6TRDQ=;
        b=wb2ekt6MPX+1RjEq9a6kUMOZ+JlVp/HYNcGsnlk2buuygHQLpbn9ZWugjx5NF8J2T+
         kTvkFEd0DnmFE108keZ/aQz9PuDXbdGdkaS0lFp1oRo8KtN5eNzXBLE2ZjX5i5O59qbx
         tGmqgydaLb606phYURm9/wTlKOIpmexgDHsafiuqxpfxCiia1tzrikso2S8nc0ei3yce
         ZQd+NLCmdYjoUm29wd+qm19bZJc10tTK6dXEMLWfDmSQIyYFLjBq4mZnOqmIjKjbW2+9
         fy6VXW6QXJIjEoQXKCjvR2JXWwWpZqG1XXg3cCDF9k+PgPyfOKrvR9/sAhCYesLR+ppT
         QC/A==
X-Gm-Message-State: AOAM530n2fONyZ6OXAccInfrn2aRa3DeMS6isroyYoxo6LuX6DBOiJV6
        e+4ig0OyhOOOPxjnJvgqHtI=
X-Google-Smtp-Source: ABdhPJzBYpzBvWB2AoimZGpp1suGyR6lpR9QyQdmQWIzXY0clCz/HivMwO1STXwWz2SVBvdNDvl+/g==
X-Received: by 2002:a63:df0d:0:b0:373:401:6818 with SMTP id u13-20020a63df0d000000b0037304016818mr20538814pgg.34.1645553393779;
        Tue, 22 Feb 2022 10:09:53 -0800 (PST)
Received: from [10.230.24.186] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id c19-20020a17090ab29300b001bc13b4bf91sm164289pjr.43.2022.02.22.10.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 10:09:52 -0800 (PST)
Message-ID: <cd61765a-02fa-f103-5f4b-0eff863bd86d@gmail.com>
Date:   Tue, 22 Feb 2022 10:09:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 0/5] net: dsa: b53: convert to
 phylink_generic_validate() and mark as non-legacy
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2022 2:14 AM, Russell King (Oracle) wrote:
> Hi,
> 
> This series converts b53 to use phylink_generic_validate() and also
> marks this driver as non-legacy.
> 
> Patch 1 cleans up an if() condition to be more readable before we
> proceed with the conversion.
> 
> Patch 2 populates the supported_interfaces and mac_capabilities members
> of phylink_config.
> 
> Patch 3 drops the use of phylink_helper_basex_speed() which is now not
> necessary.
> 
> Patch 4 switches the driver to use phylink_generic_validate()
> 
> Patch 5 marks the driver as non-legacy.

It has been applied anyway, but still:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

David, would you please allow reviewers 12 hours at least, 24 hours 
ideally just to account for time zone differences?

Thanks.
-- 
Florian
