Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798F11E4A58
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388970AbgE0Qfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgE0Qfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:35:41 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD86AC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:35:39 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x14so19289023wrp.2
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6GykYKG2ZvCHWJPasK96C8sKhsaLLGAcsGooJE05DWE=;
        b=kfgIf7nGustdTLsugylihaXoUHeXHYiOQxU2RVgBlwb+e2cgWKswNd52QFhZy1VhYY
         Egj2Ir22wH7UiCIWiQ3r9XKD3KFehjTAvf1ckCtrfOCb36CwS+f8tzv+UIx/n93dwKpp
         ib/nxodpgpnHmHXav93pkEUb3iAOmIpHxSx22188wMZV1Fr/JnSQ8tsMXyc/hLnc9pJN
         dGI4M4TMH1g42wTiWzs1iWsPzQPg0lLWSbNEyFNT7nieEz+GJft7YdMMsYbT5ajNbzyi
         JGU6NtU2GFRUUnRWzRSzCOGozETjIRNwq9QzDJ8eeFk6abIGvBFt1jmjgWKKhgyVqcek
         x+1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6GykYKG2ZvCHWJPasK96C8sKhsaLLGAcsGooJE05DWE=;
        b=LvX1Y8ifDRAWi/fNLS+tBQAlQJ/Gmvja5//vJRYnr1wQpKOosclec1TM2Xx2feVF7K
         OVCcDczP8PHA+LAtHSEMwTOg/VApnWuGP8dcUbO+5RgEPmN/BuD1J9y2H+EYUL8Xp8+7
         kGc+GbT91AEPtmepJPh2j8HX3Yy9Vwc7hf4Zup8yZQDLj86Qi9xbi3SW4xoXdtZKDF8O
         Ra+aJ0UvFamFm1ATLuDdIi3kkpypln0tweHRu4uGl8/Q0hAPpNhg0ZDaEj0rb3JZEWpv
         V6ooEagpDuQwLkRCkgZjt1ien2B6Oejjre3nLtEN6MK8tAxHXzeY0mEwfGJZTK7Qt/J7
         YSCQ==
X-Gm-Message-State: AOAM5313aCutRpyRME0jp7g425lv/zOdKZwB0fIUT+y6w82YSg0aatk9
        b6sFoSgUQdja/APAt2Np8/iobG3U
X-Google-Smtp-Source: ABdhPJw8n+eJAwiRJ3UXlkdteluUJxWnTRahKgYiqWPs3LxuZlNcZFmvbxH+dhlmVmgdbz1knRrDBw==
X-Received: by 2002:adf:ea12:: with SMTP id q18mr25768772wrm.413.1590597338244;
        Wed, 27 May 2020 09:35:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t6sm3162619wma.4.2020.05.27.09.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:35:37 -0700 (PDT)
Subject: Re: [PATCH RFC v2 7/9] net: phy: set devices_in_package only after
 validation
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtO5-000849-0b@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <daf57698-2252-d96c-367e-d741f1d06f39@gmail.com>
Date:   Wed, 27 May 2020 09:35:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtO5-000849-0b@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:34 AM, Russell King wrote:
> Only set the devices_in_package to a non-zero value if we find a valid
> value for this field, so we avoid leaving it set to e.g. 0x1fffffff.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
