Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D504BF094
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiBVD1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:27:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiBVD11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:27:27 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F5822B1E
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:27:03 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 12so12343861pgd.0
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 19:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oosvhhGqSE9FHEk58PsT6zEWSMh+PTx2VY2e0ji2RYw=;
        b=gub6Qs1U67JFZZKUbCGdBU6yhPpGoeKeMqbhHYJmzRLtAwCzWGEMEiLmR9wATdYwZp
         4qQ/Wra2QhNescOGKC2FKWBtxCCWA85rQorTa1usERAXRgGPoc4GNU3TgivRLUYcrtLh
         Hnd0/qyko4vDzoZvq+iaAhsu7FTQ/MS+kYQ6uGnxBxbPbUmOeDXsQF3h8ES3expBe+ri
         itTyxBT+Ke2WuhCN35Ns9muBWutsrin+Sjl7Q79HFExqP19Mb/Jhrp5xH4f3Be3VVwuV
         icpP9idM42W/gn1vUvgZXaas8MMyXbTZSk9tHjFLo0t42pCxnAXSXUZexWiukEXimtHS
         PfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oosvhhGqSE9FHEk58PsT6zEWSMh+PTx2VY2e0ji2RYw=;
        b=iyHDUF5MWsYnfXl8sd1fWmxcXtKGDITEIDoFBnq25XL3SDS7OuP8Sw/uJEvJgnmLKu
         sdmlzg96MaeN9+DPeqXf6wgUvjkdFAAQoZyeuFEQYGZJyJ0zakn35UHwz6Yx7lYaBcql
         01yKDDLgkvCQlbmjBFoJX6kpT/d/sg2a5Gj7k7tcmWEZTgp5x8aDbA4pvgV8vjqicY0D
         GOvGk5S1BTXlXE0/Ukw3D4A2yF67SdTHuGLUyzS8DBHt9+wgTo9qcDvIprpFFqiHQ/E9
         yJm9fnkGEhZHmT3lbRIOPH7tY+ya6RofVnpKHrAWM9TtvORyGv/2YQRqgcU4LRnMbE1B
         WyyA==
X-Gm-Message-State: AOAM533C+fOarL5klQbOV4n74jwi4IsDZtWwFE+BDVzKwKD2vP9OpGEh
        VxTDojnMKvOTMzzpn43R6yY=
X-Google-Smtp-Source: ABdhPJx4GDsMYF/FTcgIV2tJ9V23ZlDLUA/sY77KU3gYLnO+bHW6ldbXcc1cogen/U78DKlqLn/m1w==
X-Received: by 2002:a63:6b04:0:b0:365:2e3b:f8e5 with SMTP id g4-20020a636b04000000b003652e3bf8e5mr18055849pgc.585.1645500422847;
        Mon, 21 Feb 2022 19:27:02 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id x126sm13471831pfb.117.2022.02.21.19.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:27:01 -0800 (PST)
Message-ID: <42d2ed4c-27ff-cd3f-226e-6f36cec7b754@gmail.com>
Date:   Mon, 21 Feb 2022 19:27:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 net-next 05/11] net: dsa: mv88e6xxx: use
 dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
 <20220221212337.2034956-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220221212337.2034956-6-vladimir.oltean@nxp.com>
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



On 2/21/2022 1:23 PM, Vladimir Oltean wrote:
> Make the intent of the code more clear by using the dedicated helper for
> iterating over the ports of a switch.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
