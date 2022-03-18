Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260DB4DE376
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 22:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237812AbiCRVYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 17:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiCRVYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 17:24:08 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0FD2EDC1F
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:22:48 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so2011035pjf.1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 14:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lZF3K3v6AzQxxSQQgRTl+ejSMbRcJZHLWjFM0XUDJFA=;
        b=lsMdoJloJU89gC1xnoJPuEgHM3XO57J2ndZE+ziuXq5uqO0WYjDqSpA86qYnpOGjbB
         Xv0D7MFOg5TcdW9bYZxMzPVyKgeLiP2Mos9pse571ddfKC5Bc2yv0gjugSKgd0Drp8iW
         hIQ5kBDtUr/ixEZSFv/BlgL7HZexB70i2XSVzbLYiqhnmxkN73xtEzbWRUcaH7rGBfju
         APZEHIUblVVzIn+TrUGzuMhnx6KHeT30HF5VwgdqA6BLX45+24ikd/IESnXYlYmnZT/T
         NtHOOzBMb07IRwEU0+TGdzIoJjMCgB8pPcyWsBKYTkeughOkmHtl/nlsfr3B9uGUGZs6
         mxUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZF3K3v6AzQxxSQQgRTl+ejSMbRcJZHLWjFM0XUDJFA=;
        b=59UnW+0KMofiHYVPxuqzn5Ss0YRT3zMu0nB3f0NBzR5joi7LfGlRzSDczTvPT0GFSx
         J8+/L/fbMQauFY+ajo36x5BjE2oYtH87Tvw0gJ5Msm5DFR/CIvtLXshX0kq24zEHpVuX
         GPZaYjSOhBws/Kj5P6gYvH+NUIH7XsT2UMtlxG6ML6ec2OSi8FzSgQrdQDJelxy3YtX+
         vvnaM5417sthrOJOokAxfw+gC/3xL/ZJ8NbEjxJuKJkx2dr21E7PtD5DopuRDRYqhRAd
         NHWsQTqv49mFKik9tHZWJiEDEnx5BKe+4WRfWF6HSJW5QJfWse6BswcmIAsjF7YLof3o
         bl+Q==
X-Gm-Message-State: AOAM533hzRvtrFtIjtBiKQ1YjOUsHlBFUvwIemDHrAbruRhO+AAc9Zmk
        /KMNHxRFcXCdLUNWqyLf0kFiE7hQ1j8=
X-Google-Smtp-Source: ABdhPJxgBDupFb3Q/WLPibCbqRvGsR0BUjMAZlg2RLCpk8NrQag0StpiWj+221iKv3QYS7bhcQugug==
X-Received: by 2002:a17:90b:4c8f:b0:1bc:a64b:805 with SMTP id my15-20020a17090b4c8f00b001bca64b0805mr13249554pjb.156.1647638568330;
        Fri, 18 Mar 2022 14:22:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 124-20020a621682000000b004f6a2e59a4dsm9817666pfw.121.2022.03.18.14.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Mar 2022 14:22:47 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: felix: allow
 PHY_INTERFACE_MODE_INTERNAL on port 5
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
References: <20220318195812.276276-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <78658409-40f6-227e-78e7-92364cffabd2@gmail.com>
Date:   Fri, 18 Mar 2022 14:22:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220318195812.276276-1-vladimir.oltean@nxp.com>
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

On 3/18/22 12:58 PM, Vladimir Oltean wrote:
> The Felix switch has 6 ports, 2 of which are internal.
> Due to some misunderstanding, my initial suggestion for
> vsc9959_port_modes[]:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220129220221.2823127-10-colin.foster@in-advantage.com/#24718277
> 
> got translated by Colin into a 5-port array, leading to an all-zero port
> mode mask for port 5.
> 
> Fixes: acf242fc739e ("net: dsa: felix: remove prevalidate_phy_mode interface")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
