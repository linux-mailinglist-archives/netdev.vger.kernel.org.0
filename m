Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9DE92FA832
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407400AbhARSBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407432AbhARSAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:00:54 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18420C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:00:14 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id e9so4874169plh.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0nf0T7tu5VqzGMVofVQ1JLVSOdrIiLjFZwiQpsgx8nw=;
        b=OCY9CNkn+7eopdMvNOfoFQyNCOz6IHctrkGRzx2yIHgeiPlf6XDusn27e2aK59mj+a
         Ypz2I1ayyN6a02EWx9Jyg0E9fzwMeXqAKFnIEvO6uIuxXfHxo4SwL72Brq0GIISPhbg3
         5xI1mOz47f8g/Thfuy2T02ASZ7LDqmxzJ4lXJOfPcQi+hfe59pcvKVIkkOrpMd/+Pbso
         Puhj3iUvQUxBHIFhyNfXlW0shWtrKtDK2pLKqg4rG73aigqE/aXYi0sm/VA8F9cDVOgv
         qNqB+5yym9bF9XWmc0ijAZ+CkgIImP6F8va3zV3ULw95cd/+41Cm5FZ9jtNzf6ufOJYV
         nbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0nf0T7tu5VqzGMVofVQ1JLVSOdrIiLjFZwiQpsgx8nw=;
        b=DT+L6jIrb9Ubm9PiPt+61BzHsmT+OYlc6XkioVdrva/2rzArPLbkwK2buaqtjGNOOF
         ycTAYyynVHK8KOccUOY6dnqAxZbzi9xGgeK85Ve1sPLpJnwIDgJ8tdhvncMBVveupvVT
         xR+7ahoJ98/VY/urSodhHvkVHS18mcZw9bqC5j+sGog6DVh8Yb2swpWcycH4ursYSNO9
         08rhG0j30dUD4rG+tXxdPrwGvwUQE4Ks75IgEcA0jd1u1PSuPMD+BXMTLXgKsps/lrpX
         SJEE4v3IGM5T9lOUWMT4ItVR7JnWZD0bdDD75ZyrMVEzxxov3H6th6iMpXx/BKS2GFG1
         aDnw==
X-Gm-Message-State: AOAM532XbxvYQQ7UeBQa+xr5w+R70YGl2gWPVyeQ2VbtbF5fw+qsZ13W
        h/qcZMSTLbiPrILAL2uwTWQ=
X-Google-Smtp-Source: ABdhPJwpajOEUyfuFMZfdbae2GYLwgkQ8SDeqm8AL4YS0wjV3YLojjptNXSpzP0xRxURN26nKUuPWw==
X-Received: by 2002:a17:902:7086:b029:dc:8d:feab with SMTP id z6-20020a1709027086b02900dc008dfeabmr434127plk.22.1610992813190;
        Mon, 18 Jan 2021 10:00:13 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i6sm16903732pgc.58.2021.01.18.10.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:00:12 -0800 (PST)
Subject: Re: [PATCH v3 net-next 03/15] net: mscc: ocelot: store a namespaced
 VCAP filter ID
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
References: <20210118161731.2837700-1-olteanv@gmail.com>
 <20210118161731.2837700-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b327f41c-9013-0e86-24ab-c685ff420d94@gmail.com>
Date:   Mon, 18 Jan 2021 10:00:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210118161731.2837700-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2021 8:17 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> We will be adding some private VCAP filters that should not interfere in
> any way with the filters added using tc-flower. So we need to allocate
> some IDs which will not be used by tc.
> 
> Currently ocelot uses an u32 id derived from the flow cookie, which in
> itself is an unsigned long. This is a problem in itself, since on 64 bit
> systems, sizeof(unsigned long)=8, so the driver is already truncating
> these.
> 
> Create a struct ocelot_vcap_id which contains the full unsigned long
> cookie from tc, as well as a boolean that is supposed to namespace the
> filters added by tc with the ones that aren't.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
