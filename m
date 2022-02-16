Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3046B4B9359
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 22:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbiBPVpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 16:45:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235531AbiBPVpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 16:45:00 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77110216179;
        Wed, 16 Feb 2022 13:44:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id r64-20020a17090a43c600b001b8854e682eso3665432pjg.0;
        Wed, 16 Feb 2022 13:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dgevcK5R5m/mKgU/mUZovQ8cDU/HLiXrSNnllT0PFZ4=;
        b=fI6BiBaB/KFR8JIrwfTJR9IpZIIkqHBKqnlj36NGUYWjFwh11k/Lr+FT9nLPhS+Ap0
         KFG8eFE3XIj0cxXPZ842euCnRnXFQc6Gors5iv3WL1NDiywM2a6PzFH3tVlSMwNoSdAD
         YU7pvKzwpaANZr1WrPp8pkGr9KY1EJ4f2dgId7t8xs3be5/fp7jK2NmZWbAxjKGMfy6y
         tqSJFXso75yGROqBI9YcLSee1bIyg1uq15hzMIoijCG3ADg3QveWR/VLvUfQNtDdlp52
         22dTJ1zOCVCxPdPyeHhD5KnmL8t/Q+fp75ioHCaxxH+1ggTLYRCkvoVcSeQ4Gz4x6gsq
         PgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dgevcK5R5m/mKgU/mUZovQ8cDU/HLiXrSNnllT0PFZ4=;
        b=SjWtPmT5jsvHDMufdkWWaWyOvx47iEhMQoJBP8H0SdvkP2MmLfvVCK8pX/JbzHeXC0
         PNVN2RO6GQlsdtiQygA5Njy2Hx+vfQJkcs6CWsMozEavICy57fo9ZLTbusjj5r1SRScJ
         LwK9QVg7aXOpCkA3OGe1FTXMBWdANQwwL43weG1hyn40CcaPn3nWkNVKnqfi9Zcs0Wb3
         /qh+9+m3tGCIQB3lOuBRdrGwOt2iHd0IeCb9ShA618Iu43mJYJzpnrucHuM1Z3qb8ytB
         QsfjVxoBrgOqAUrAkXjZSP+oxfcCyR+URpt8t3DUpLWVvrPL4rMioVoRwuuBCoh/3mH0
         IirA==
X-Gm-Message-State: AOAM5326CfRVtnpGWBvoD+zWwbWBVrWjPdbRZCQlPhRj78t5eG+AQQvW
        jNqWm1DpmxjSHd6cVzLeCT4wQeLfHyg=
X-Google-Smtp-Source: ABdhPJwjSqZG6jHNYjFZLHiYiyyR189FywSx/+qPJ60bxqqfQpHg8qI9iYmP0cC4MwLg4KJplox7dQ==
X-Received: by 2002:a17:902:7043:b0:14f:47:a455 with SMTP id h3-20020a170902704300b0014f0047a455mr4322627plt.44.1645047886611;
        Wed, 16 Feb 2022 13:44:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s37sm49276554pfg.144.2022.02.16.13.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 13:44:45 -0800 (PST)
Subject: Re: [PATCH v2] net: dsa: lan9303: add VLAN IDs to master device
To:     Mans Rullgard <mans@mansr.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220216204818.28746-1-mans@mansr.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b29ad7bc-c454-06c2-7f9e-23007339e4b2@gmail.com>
Date:   Wed, 16 Feb 2022 13:44:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220216204818.28746-1-mans@mansr.com>
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

On 2/16/22 12:48 PM, Mans Rullgard wrote:
> If the master device does VLAN filtering, the IDs used by the switch
> must be added for any frames to be received.  Do this in the
> port_enable() function, and remove them in port_disable().
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Should this have :

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the
SMSC-LAN9303")
-- 
Florian
