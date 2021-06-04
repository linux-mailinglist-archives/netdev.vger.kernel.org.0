Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B6D39BD85
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhFDQrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:47:00 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:36373 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbhFDQq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 12:46:58 -0400
Received: by mail-pl1-f174.google.com with SMTP id x10so4951601plg.3;
        Fri, 04 Jun 2021 09:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hpEYO1HIh/HlORQyrloW3Qi1Vf03iEGiIrmGG5LG65I=;
        b=E/yEFnY/gkfjcuPoZKtEWjcuORKimYwBDLfzPo8zTNtiJpwpmlacQwblzJI0UsfkQF
         8g94K7e2pEeKlM7dgo7Pz+E8vAC49fKwxVfOFQy08wXaYXX7Bxi6SiuFJvG8ZXDMrsLg
         6qX1XJbRrpP3kayB0kp6G0rd1eOP0wD+nyNTEKHeFaCUWryJISBtHytw1lZ5KVvyLjPi
         s07K//AU28xoT+inb/v6USdKImHa9YzTNmsztZq6rz38QQ/kh+5bIJ0N7bzBwHABjOb9
         H9qf7uV2nrj7TBA4btu/7j9N/dEP68UFJqLD3ZRttNiZ1L1sdn9pT3yQEU31nBk3kUNk
         wHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hpEYO1HIh/HlORQyrloW3Qi1Vf03iEGiIrmGG5LG65I=;
        b=tsVOp0pAqbxWwy0dwKmZkBQCQtU9wCqX6qJzw/jS7aezs3zBi4TqrrIgjNtu7LDb3F
         4rEiV7ts1qrENiebYcRlniayj0NzP/ifmcBbTpMFWp51lCadyY1P2t/PiodNYAjpGFWI
         5peP7mXDkPfuK7xFjEjaRRdREivroyc5oaixHzKory8w55U/ydCmKAOyVX/4QldujODi
         2T4ow3yAD6AG2h/XbNxJNqz+UvXJW23oSuMbPYhrsCgGvYLtfX953lMnOLyZ3Q0Gyxq2
         6meavzGnj6qcUIbNYOXObN+5he1au94YZ28poeN/BPBvH/SMHlmRi6KfQDAwf/UePXYQ
         gHDg==
X-Gm-Message-State: AOAM530p7znlQZ0qh8gRPFvag1Xdx/M9HDqzUg8JauTbQhBcT3F3ac3R
        W2vAlfNt8VB2h+bBCpFILc8=
X-Google-Smtp-Source: ABdhPJzJ5HmVHzE5rAhbBEMcJr5C2jQP8anveAUIn/6ym4qYqUODi1kdx5nuNnL8el3SKK1qoGdA5w==
X-Received: by 2002:a17:90a:520f:: with SMTP id v15mr17650451pjh.205.1622825043516;
        Fri, 04 Jun 2021 09:44:03 -0700 (PDT)
Received: from [10.230.24.159] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id c130sm2189853pfc.51.2021.06.04.09.44.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:44:03 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 2/4] net: dsa: sja1105: apply RGMII delays
 based on the fixed-link property
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210604140151.2885611-1-olteanv@gmail.com>
 <20210604140151.2885611-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <dfd44cb9-5ccc-0fcf-b91c-9d68227d6b3b@gmail.com>
Date:   Fri, 4 Jun 2021 09:44:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604140151.2885611-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2021 7:01 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The sja1105 driver has an intermediate way of determining whether the
> RGMII delays should be applied by the PHY or by itself: by looking at
> the port role (PHY or MAC). The port can be put in the PHY role either
> explicitly (sja1105,role-phy) or implicitly (fixed-link).
> 
> We want to deprecate the sja1105,role-phy property, so all that remains
> is the fixed-link property. Introduce a "fixed_link" array of booleans
> in the driver, and use that to determine whether RGMII delays must be
> applied or not.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
