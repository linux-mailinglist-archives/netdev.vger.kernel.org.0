Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083061CEB55
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgELD04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELD04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:26:56 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C29C061A0C;
        Mon, 11 May 2020 20:26:56 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mq3so8818320pjb.1;
        Mon, 11 May 2020 20:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xaWj+teTXP6iDsXPKlYym5W1AjYjyj3dZUYFmMRFXko=;
        b=qkp22iLLeW/etLliDGQXyqAKwzy+OyWE1Hh106YlfoPnqmm9Y2pHEuKeVPf2tz3rST
         II/mRX2gfcPtNwM9+RYKBjOXbGYScfpoiQc6KJEvDYKWEig51L+VIdQHcjan85XJogpX
         Z++NyW5vqOm6SGeakKcr66P4oqjV+GrMY+WH5AQCpmgunBkSPKoZUa9EzA+1Xa5MHlgm
         VvPJ/1w3bdP9vWM15T+PqibFiemvx8R1P4QweMIHdWrBH0IrfY1gsLeMnqBtIRaIRNA9
         di7ogEhVQFIcNP8xMI9+TMeB9qKmKIOy3koOntjLMHjKcyjzt8Rv0GL/NZWCguOHROvg
         RLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xaWj+teTXP6iDsXPKlYym5W1AjYjyj3dZUYFmMRFXko=;
        b=uPA3hOH8w3ZiEP+99BMBA71yq3rsG99htT5x0st+JKA6vjAYMvvD7wZBEk/hs23/8E
         NjRgKK3qkOIUf4Yisefs/dhLoV2B3XnPtpK7bckluSyt/6vvJ7pzYrhz6kHIqKW26L2y
         2+6k5OS1Ach1NjGw3y51AcJKRulDpYAJ+hpb5B+wpqDbFTIvj8ygQYclTjNYum/4AVsA
         9zmrFHz57cifaBDG7FObeLwgILuLRSw5Ei+cbqX4I5b+jzYiSnYbfJvobdGsOXLuwrcf
         XCfY/nxsnB2JYVqX604CAMEhf+TK5u6SkAxlj/ChpSP11BKPoHCSticHplJLPLYwxnZE
         TcAw==
X-Gm-Message-State: AGi0PuYZStelsQuvz+mkA9erFRqnFi10tYA1eYLPwBdJGzTYBhYPFdNp
        VKfh/ESP9HG1/GNM96TqNbON1/qp
X-Google-Smtp-Source: APiQypIs47MgVSyeCd3AQPD2pP2/Z6aSEwsqRBTDE86dhEVclsOpdoswLiRFjt+6TQs11i0pVZzgdQ==
X-Received: by 2002:a17:902:6b8b:: with SMTP id p11mr17768739plk.134.1589254015061;
        Mon, 11 May 2020 20:26:55 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x19sm10474601pfq.137.2020.05.11.20.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:26:54 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 03/15] net: dsa: sja1105: keep the VLAN
 awareness state in a driver variable
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7987b485-1f67-ff9f-08bb-45202c1c5422@gmail.com>
Date:   Mon, 11 May 2020 20:26:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Soon we'll add a third operating mode to the driver. Introduce a
> vlan_state to make things more easy to manage, and use it where
> applicable.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
