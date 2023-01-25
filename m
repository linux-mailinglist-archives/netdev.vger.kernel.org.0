Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECE167B554
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 16:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbjAYPCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 10:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbjAYPCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 10:02:02 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C40B568AA
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 07:01:54 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id v6so48410351ejg.6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 07:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dkZAUhJHccIb6lLr4MUfBj+kO2V6xGZQ0n0DeoAqJ10=;
        b=O/uj/gDm2BpXN2uKHqSouIGzGIMU5epbU1pnNW0KN5zWSJLZusJFSPsQZrtpkI2toW
         KzyBZERDLCUcE+5KH2AyX60pYu8otYgr6MfDdtpwW6I1/sITp/9l1AwvTCpJyHy0zyLi
         UQLBZM44aWWGPmy8LbyMFTROUKH28nUoEmuaGm2eb3meovfyT/4zGObzzCAXYJ3afhRs
         KDoZ7lv7Mgd1ALn6ISP/twb/zCFMsFhhfHnfcJMqYbFKLJgdTR5A0OTKeTfo8z5fksV4
         JVzLFS7H8S0pce7brJbx2MkUiAwrhET860Lnmp62jwtvkxPuf70pRdXhQNBlIu31Ca9D
         m2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dkZAUhJHccIb6lLr4MUfBj+kO2V6xGZQ0n0DeoAqJ10=;
        b=HVFeHBzbd7DBHvlqkjiCregmTnFIKQQcek3YxSiAmeopvESSwz0q5Gi/7GeqMyVdQ2
         Y/KBnz51wN7fdA+3l7HKjglb/rp+rx4kFJenuPhWYxie4wIW8kbP/Ykmc1+KyYnKBAlR
         TQ3G2Adntxs70sDAJ6bgVW+R0lN4t/gFhFmEHBl0mvbkFH2ipqzDWlOnxBJ8dyttH9ef
         G4nzWd8qUAHv2cRxnjrtMqujR0IiN7QEbiYb1RzjjRcjEwiZ8VoooVQkREfKD+tWVKX/
         /zK2hhtqtmz4SQwdnG01EpexFcsPMFPyVAukMzqUf8XkOZuxAydyQkXFtps0d1dOtYJe
         PWkA==
X-Gm-Message-State: AFqh2kqaqyxm2eDXIumVoavEgscvshfvblnTuaRUcgqNsxAeiamhw+vJ
        vwzQJ79yyixAB09xPkIEUDRJx/Wgstk1JrZTcx/+UQ==
X-Google-Smtp-Source: AMrXdXtKPCzATc5PE6X3RNcl16KtazBAp/dwzTWY3VA9dwTrByw9ogtKlrvpISQrmOU5g1V6ENYXEg==
X-Received: by 2002:a17:906:7156:b0:86d:f880:5195 with SMTP id z22-20020a170906715600b0086df8805195mr33012172ejj.56.1674658912778;
        Wed, 25 Jan 2023 07:01:52 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id q4-20020a1709064c8400b007c0d4d3a0c1sm2451356eju.32.2023.01.25.07.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 07:01:51 -0800 (PST)
Date:   Wed, 25 Jan 2023 16:01:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: bnxt devl_assert_locked warning
Message-ID: <Y9FEXu1iyc4M8ODB@nanopsycho>
References: <Y9EwWk7jn5+VATav@x1-carbon>
 <Y9E54SibGQ2HSCPT@nanopsycho>
 <Y9E/phvj/nZoqmR1@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9E/phvj/nZoqmR1@x1-carbon>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 25, 2023 at 03:41:43PM CET, Niklas.Cassel@wdc.com wrote:
>On Wed, Jan 25, 2023 at 03:17:05PM +0100, Jiri Pirko wrote:
>> Wed, Jan 25, 2023 at 02:36:27PM CET, Niklas.Cassel@wdc.com wrote:
>> >Hello there,
>> >
>> >When testing next-20230124 and next-20230125 I get a warning about devlink
>> >lock not being held in the bnxt driver, at boot or when modprobing the driver.
>> >See trace below.
>> >
>> >I haven't seen this when testing just 1-2 weeks ago, so I assume that something
>> >that went in recently caused this.
>> >
>> >Searching lore.kernel.org/netdev shows that Jiri has done a lot of refactoring
>> >with regards to devlink locking recently, could that be related?
>> 
>> Oh yeah, this is due to:
>> 63ba54a52c417a0c632a5f85a2b912b8a2320358
>> 
>> I just set a patches that is fixing this taking devlink instance lock
>> for params operations:
>> https://lore.kernel.org/netdev/20230125141412.1592256-1-jiri@resnulli.us/
>
>Thank you Jiri!
>
>I applied the series, and I can no longer see the warning during boot.

Great. Thanks for testing!


>
>Kind regards,
>Niklas
