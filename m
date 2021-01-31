Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4059B309F1E
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 22:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhAaVc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 16:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhAaVcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 16:32:54 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C41C061574
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 13:32:14 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id q131so10251076pfq.10
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 13:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dUJ1NRDip/2FpTcxrz9WCXrhIHy9fVFBKUFDvXxqcOI=;
        b=r9JCGrozY5QvsiJFzwHTE+MKs2P3ZGf7cEHgjc0RdMp0ioagP2XO4par41/YhlJLUV
         V7BYpDcFRP4Qqw9p83ByNnsrrCVcobWEwc4uiPMrN/RkQNDLxuPOfddPqBOuo18rRp1C
         7PpLQe5extwXjAo5nI3qh0cxjQgoLsS4dQyxGb9r9vhgEiNfcPKMdlPeXXmCLQmeR/Pf
         3quMxpBpBl3A22vYklfwEw/8AYcDiFc5Tq2f+ihaZhg9Tk23WZ/IDrTksPsQTSWa0DS2
         CN+DIt00dVlE/4HgZmOSri/DEvzb+XtG05nk7pSLRvyvFSgXU4XjAkQDyXAdWpLgD9St
         BdlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dUJ1NRDip/2FpTcxrz9WCXrhIHy9fVFBKUFDvXxqcOI=;
        b=W0PPQ6kL294KOmxHDhcdceAXl786t8RRKuGhXhwUdR2t0ZEcPUEpGdmE/60+MMsPGx
         pn5m3dSY7IUEmhpb9lor7mlMyfTCppKamFU7o/U3H/u4By3gOyLO+A+wLY5kuCe5zdtw
         0jtaT1Q9kdhLSJvROTFxni5FM5eArfgA27dnbQDp1fivAgn1kcB3tMMty9HhDQGcRk4b
         Jv/hdBlUNRTCDA5xwRcZgHRRdPzqR5DBvyvH60Bse19PdRkqeMhuHsslmbEneOcQg5re
         fwFpYlxtISCd1ro8ZChhiDxmXW/hQfSEoA3S/SzVrzR8BqBY3WEBXelqnlRl9nIe2cTw
         ypyQ==
X-Gm-Message-State: AOAM533wcUmMsJauTlUbKAwwBkahW71IX13CohICYHg1YvyAqBzoWe1o
        f3Ln5TsvGu4S7aR/JnlRzOEZksKuVg0=
X-Google-Smtp-Source: ABdhPJybLsuxHu54Ap0vH+f9/iYdDHK3rqIO7iwoQLzE266Novwn54m1ZNwb2JrPnDx7wmElq4WeQQ==
X-Received: by 2002:a05:6a00:a8d:b029:1ba:71d1:fe3c with SMTP id b13-20020a056a000a8db02901ba71d1fe3cmr13394383pfl.51.1612128733421;
        Sun, 31 Jan 2021 13:32:13 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j65sm374897pfb.23.2021.01.31.13.32.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 13:32:12 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net: dsa: hellcreek: Report FDB table
 occupancy
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210130135934.22870-1-kurt@kmk-computers.de>
 <20210130135934.22870-3-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <29d239fc-9f03-fef3-0a4e-ab217bb57b2b@gmail.com>
Date:   Sun, 31 Jan 2021 13:32:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210130135934.22870-3-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/30/2021 5:59 AM, Kurt Kanzenbach wrote:
> Report the FDB table size and occupancy via devlink. The actual size depends on
> the used Hellcreek version:
> 
> |root@tsn:~# devlink resource show platform/ff240000.switch
> |platform/ff240000.switch:
> |  name VLAN size 4096 occ 2 unit entry dpipe_tables none
> |  name FDB size 256 occ 6 unit entry dpipe_tables none
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
