Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293DC4B2E18
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 21:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353038AbiBKUAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 15:00:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiBKUAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 15:00:38 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC45BC4E;
        Fri, 11 Feb 2022 12:00:36 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y17so5516485plg.7;
        Fri, 11 Feb 2022 12:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZAD+P+VJ1MwGt/Eut/YOU5G/gK3K/qVJgmrZH73VLZo=;
        b=csnYMqMTQMRt7onhd7oLmJvRmzc87upJaCf1A1RF7LcJn+phll8oV8PD15SBOkzXMB
         BHcJtNQ+cI5YfxDitM69JLVp3pXlqd4cKHet0E7UFAF27qMFLvSfDUtcRujyLXZkq2YQ
         ebkpYLB+Ih7w7P/AhJ5zSGnGB8t2k/6JGi3aDmlJehwnM1WvtXNmATMcRZWZuZpwARpw
         EqN6znzbkmtVfT0Jawm04f+rJ6fvrsUSSsCFrQ+2csNPAn97wOBhRXlCvexUcx9XFRlw
         ajTFXEFsqpxctxYnOg8VIiMhh7wXo6uq3lFjyuaVJi54Gn2L1JuM0RJlmMRckxhS6OaW
         x5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZAD+P+VJ1MwGt/Eut/YOU5G/gK3K/qVJgmrZH73VLZo=;
        b=iO3kuYcwO6xnlKopPygXKvP2xX/ZPe0nowD2hfAPNC+coLJ3G4c+OU80E1ktqa8yFu
         YLg+bx6iignhirYoFdlK5R5xC2Y53vyD4F559J6uW1WIdvaBu/Gtfz32gJK9g/zSCCW1
         YrFHgLuk1Qypzsvbe9cebeigBSErxzUAZjBR7rKQJWwfEcKjOCslMmDwpurqBZN7lcL6
         9tmMXCcuaK0cF/5/u8US7lkhdkmbLDfkC+e8dBnWpCZ605d6sDs30srwR8JMWPTAJzYn
         TlqwLqhk3bzrNdgHShSx2n2Gc35/Quaw0JVKnAvQe/TWFCgG5j3Od/LdT9v4UA0DIadW
         jKWQ==
X-Gm-Message-State: AOAM533bwYSdMPa87Xz5CpCOV/gmg03ZRGa4kYErrZA5F14dmfGISvnB
        s9B95p6bl1x4x0e9RoMvvuL95cOh5q8=
X-Google-Smtp-Source: ABdhPJxAUVfHNx/9r3Qa/LLDDTz/HxOWTWFwdhPXAgFAwqshVRx9DjzK4lcsdBbtufcssaZs5dKCuA==
X-Received: by 2002:a17:90b:a06:: with SMTP id gg6mr2011554pjb.153.1644609636090;
        Fri, 11 Feb 2022 12:00:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id kk17sm6017558pjb.21.2022.02.11.12.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 12:00:35 -0800 (PST)
Subject: Re: [PATCH] net: dsa: lan9303: fix reset on probe
To:     Mans Rullgard <mans@mansr.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220209145454.19749-1-mans@mansr.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ac022ba4-7f26-b9b8-2e78-3ca27b400ab6@gmail.com>
Date:   Fri, 11 Feb 2022 12:00:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220209145454.19749-1-mans@mansr.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 2/9/22 6:54 AM, Mans Rullgard wrote:
> The reset input to the LAN9303 chip is active low, and devicetree
> gpio handles reflect this.  Therefore, the gpio should be requested
> with an initial state of high in order for the reset signal to be
> asserted.  Other uses of the gpio already use the correct polarity.
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>

Reviewed-by: Florian Fianelil <f.fainelli@gmail.com>
-- 
Florian
