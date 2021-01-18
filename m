Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A2B2FA82D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407396AbhARR7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407382AbhARR7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:59:11 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BE7C0613C1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:58:30 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id md11so10022960pjb.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2XfmgRqZlmVElxQswgcboMvT5kdF7Jy4zVh84CgZmjc=;
        b=WHPctcsHSAPHN4m2Dh3Ejo8LwA60jWPxT+zRek/rTwGhTjW8OcVdJdBiYKBG23HFqH
         7vHAscLUOlyjHTR7Pb2W9vEKeU07mPEvdneXJGsCaijUBFGSYooA48Syu+tyrjehSHsD
         nLFqM2C6x548TIt2bVHmc2UfxI5yuoRc7WTgheYsc22skksWeZ3VWWG7J/td4EDp/fuJ
         6/B6R2TngEUZeBvdCjnXSDxOoj3qLg8odqV7zSKIIVGW+VV3dIRGWB3z0jDVu8pKghbV
         l6NEllAdWRwqB0SOG4M2sEC1yiDOtqK3l705885ipGB+7Sr61qc5RYy8PORI2bJU9Z8B
         7IVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2XfmgRqZlmVElxQswgcboMvT5kdF7Jy4zVh84CgZmjc=;
        b=CR7kbiuk0RyWgr1kY56cFlQ5gCz6pZPGB9TEh2y/28xfXjg/WvcWSKylVusGsjaddA
         caR0w4zSzYxcjyhuw68qaLca+IxqxBc1wsDecQ1uyPswaMV/OpUtVP01XN7u08somS4e
         0fEejJLw/BmFDEI4u9lsV3m1l/3Ag0JQgexxYyB3AoUG+70GRQc21NIiDNDdQARkB5ZE
         XLdiP97I0xRZgk3ga0I/L3zoCoOzx3npEnHqFk8sE+NVI/9HDB3WQPFTLVIOHOLqzaVN
         PlnloO24APGcBd+FPMMErcOjSEw/jZVnKuiGlbvVjp1yFgEgn6gady55H3xwf6I6FITH
         ybfQ==
X-Gm-Message-State: AOAM530ktUriXm4KNjEGfyoSbndOwXTbBjLHSTk7CbvEgedauMIuWQ0P
        vTO0QcPX0WNoP9o2rqGrXu8=
X-Google-Smtp-Source: ABdhPJySD4N/pT1BFfikRbr4lu+FEgvVvmhshE91mTAVXisZ8eNPxzfsbuJDXOx4m2gkPjbgW11ueg==
X-Received: by 2002:a17:90a:d3d3:: with SMTP id d19mr504616pjw.196.1610992710389;
        Mon, 18 Jan 2021 09:58:30 -0800 (PST)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id i25sm16266994pgb.33.2021.01.18.09.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:58:29 -0800 (PST)
Subject: Re: [PATCH v3 net-next 02/15] net: mscc: ocelot: export VCAP
 structures to include/soc/mscc
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
 <20210118161731.2837700-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <05c9f856-4645-4e27-8e80-864960414e64@gmail.com>
Date:   Mon, 18 Jan 2021 09:58:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210118161731.2837700-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2021 8:17 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The Felix driver will need to preinstall some VCAP filters for its
> tag_8021q implementation (outside of the tc-flower offload logic), so
> these need to be exported to the common includes.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
