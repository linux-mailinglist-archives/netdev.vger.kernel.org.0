Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D1931AEA8
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhBNBVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBNBVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:21:16 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B35C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:20:36 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id 100so2974893otg.3
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 17:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cZ1P+tibN6lpIsdwaeKhkGSV2GuB6Gw+9d6ezOKYHz0=;
        b=GYDCdKe2bxVR3dBk92L9PwMzI55hAOau1WoTQ/l3o9gXoxfms2J/Sz3wug/t+MxssG
         XzfbINBPyZWgqHIHwUFmN3UETzJCWeom9yRhw5ZG7NK6dsaFoHJedU/g36gTpPoO8rOq
         8BXsPuOQeVlceU+ilOCLtZ1WHt6AL3nhoKPQjboSenqblOtUO+nuIc2TnXKYLptqaoyD
         Vv9/2moxlWDN6sYRKn8I/FDLFjwTKb8t8kGIksqbQhcGJcJTupv67InFWzvwQzhkA9FD
         tKCjPuvnH8kCOyiQqpNeLZlUyT+wtG39Fs9g1QdYyTapePz4LfmaXkxNRArx9o2P1Ivp
         64SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cZ1P+tibN6lpIsdwaeKhkGSV2GuB6Gw+9d6ezOKYHz0=;
        b=CKyU1RtNtXKism90PGa+yfZQbfjzL4n1cMnvafSae4k6yWQcDJLlDr2wc+5703luqV
         hEp1ixoehC6vRFuHXg3SdSUgoCAJGsQGoZW1Y5xfh5bAn1apUDcftzVfW97ZymgKiIo4
         tmKYW5rfcSs56Na+gDWp6KUju/wr4QhEGZ2gX/c9eD02WW8YN6fILQGIXlU9fJykKhw0
         +swEZgjXlMIGoLV9tivNe0IX5QV1Pv2j4PPneSXbdnGbDBSNZIaIpChzf1cr2maxxyD8
         MhOo2RGingBOzddRNNVQlZ4wjocGlM4b3ktBR4lzYItPM0RMIXRvOv5j6f5PKYSD6tl7
         XMdQ==
X-Gm-Message-State: AOAM530nKV1i1o1XbMdlsYr16DCA3saw3eCa2PjBtgV1VJRj9gr/Wnx2
        2KdUmVRuz4OSbJQQ/70PWcQ=
X-Google-Smtp-Source: ABdhPJy6aB9aYHGjS7TIBYVe7WUFmOkUp9i45qP9eQmpgXucqjLp2LlNM+HmgJ/oUBaukeMjgcvtjg==
X-Received: by 2002:a9d:69d9:: with SMTP id v25mr6987285oto.126.1613265635477;
        Sat, 13 Feb 2021 17:20:35 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:e93c:cbea:e191:f62a? ([2600:1700:dfe0:49f0:e93c:cbea:e191:f62a])
        by smtp.gmail.com with ESMTPSA id p7sm2430500ooa.13.2021.02.13.17.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 17:20:34 -0800 (PST)
Subject: Re: [PATCH v2 net-next 03/12] net: mscc: ocelot: better error
 handling in ocelot_xtr_irq_handler
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
References: <20210213223801.1334216-1-olteanv@gmail.com>
 <20210213223801.1334216-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5ef6ca75-1e5d-3b07-766f-acb786e0c6f3@gmail.com>
Date:   Sat, 13 Feb 2021 17:20:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213223801.1334216-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/13/2021 14:37, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot_rx_frame_word() function can return a negative error code,
> however this isn't being checked for consistently. Errors being ignored
> have not been seen in practice though.
> 
> Also, some constructs can be simplified by using "goto" instead of
> repeated "break" statements.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
