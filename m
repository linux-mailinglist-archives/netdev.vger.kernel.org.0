Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA4635EDD
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiKWNAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbiKWNAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:00:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B42928E18
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:46:47 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id e11so16308792wru.8
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 04:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jvGO2Nvm32xK/MsUMocJs8mKLG8Z4xnEcLo3bEc2a5I=;
        b=fwzEZbMAifCV7S2eSSZ2rdll/ICww1DQrbnNsQP/BXjenBpF9TvFi+5niAy30WNKbQ
         813O8N21rniHzJB4NH3zugxWuv5cpsTmVhynv2a+UF/UUco8ZQpPEK6Uk4/sru8RasbW
         KOcO4pzcsNsDA+/qM0dfqo/ZmY6X71Nsje0kQmAh83HqWm7EQguczkdv2AvU4+7JjLet
         FSaZ9xMx7K5EBpLwl9Yz2bmlN0qkDpLY2R9nWUklVXnXlBNJPW7G3T0lYSZg7WCuNlCd
         /o+HjLpU6fV5AE4TP6GiwyvyXpMaBxMaon6c5PfUnH4q+BdqSW70qSfYp8G82DCM1hL0
         lGZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jvGO2Nvm32xK/MsUMocJs8mKLG8Z4xnEcLo3bEc2a5I=;
        b=QyZnOaHpsSfO3Pc5b05b0PMaFF3bpIwjIfbsrnhRwnWFMvp7nIdg6q6++T9cHQ51Cg
         dqrCklhWx/YkQFjpMRiuc0iKXPVF2VBy7OY+Q4jLghrYo581i+x33YoTFYrgeyRmGzWl
         AnkQFMuCCm/UwAYEnRX0gFB0bTHJU39qsa/oO0jwIzrAPRBJRksZi4qpm8bBe6jj1+ee
         mQniQdjKBZ4UUBryBD8lBXZTtHOa1/ybu1O/e+sf6rmScaNTuZHQ8oobTXh42ZHSwtXh
         qCVAzc9WGxrmpo1driSRm5z/suOecJ1hR5oYtTwaY8rQJ64l05DWp2jbkmCcsTbC+eYR
         pixA==
X-Gm-Message-State: ANoB5pm2x5wQ1ThV+fh6szQLAo8x+ALK/ch2zwjJZ2mJobViD9fF/KSC
        J35Fk5Jy9SpxwDr5Uap/9bDauA==
X-Google-Smtp-Source: AA0mqf78aCRpqupBoiMb4uq39Ygx8qtHSS9STQ71HwarXTsmzdF8ePVKAHAry9DElPCCy8l7q9f9Og==
X-Received: by 2002:a5d:6602:0:b0:236:651d:60cb with SMTP id n2-20020a5d6602000000b00236651d60cbmr7390660wru.474.1669207605356;
        Wed, 23 Nov 2022 04:46:45 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v192-20020a1cacc9000000b003b49bd61b19sm2174132wme.15.2022.11.23.04.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 04:46:44 -0800 (PST)
Date:   Wed, 23 Nov 2022 13:46:43 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Steve Williams <steve.williams@getcruise.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
Message-ID: <Y34WM8PkVvZ3Yb9y@nanopsycho>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
 <Y3zFYh55h7y/TQXB@nanopsycho>
 <20221122135529.u2sq7qsrgrhddz6u@skbuf>
 <CALHoRjdOPdipZ8kgBCxZ_45DXiurE57YFocvgnrugGt6ugG-Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALHoRjdOPdipZ8kgBCxZ_45DXiurE57YFocvgnrugGt6ugG-Dw@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 22, 2022 at 09:57:46PM CET, steve.williams@getcruise.com wrote:
>On Tue, Nov 22, 2022 at 5:55 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>> Neither bond nor team have forwarding between ports built in, right?
>> Forwarding is pretty fundamental to 802.1CB (at least to the use cases
>> I know of).
>
>This driver also does not forward between ports. My intent wasn't to
>implement a bridge,
>but an endpoint. If forwarding between ports is desired, then perhaps
>you want a bridge?
>I think some other 802.1cb offerings on this list took that approach,
>but didn't seem to
>handle the endpoint case well.

Okay, could you then reply to my question asked earlier in this thread
why don't you implement this a part of bond/team instead of a new driver?

Thanks!


>
>-- 
>
>Stephen Williams
>
>Senior Software Engineer
>
>Cruise
>
>-- 
>
>
>*Confidentiality Note:* We care about protecting our proprietary 
>information, confidential material, and trade secrets. This message may 
>contain some or all of those things. Cruise will suffer material harm if 
>anyone other than the intended recipient disseminates or takes any action 
>based on this message. If you have received this message (including any 
>attachments) in error, please delete it immediately and notify the sender 
>promptly.
