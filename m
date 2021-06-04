Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC6939BD8F
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbhFDQth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:49:37 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:35646 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhFDQth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 12:49:37 -0400
Received: by mail-pj1-f54.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso1241024pjb.0;
        Fri, 04 Jun 2021 09:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zVtGdk0rjbG9zPS1H0OAGsOMKM79c2DLp8XtkFgZJJg=;
        b=NmgnYEKuJGca57vXvjrxkyGWDKyxWvR4N9hm8Dt+ruEie8ENfCocAcLKJR34+o63sA
         YkcJzVbLPqxMh4i3DNWWd9Oc6a0E3NX587twmrvGXhplqBHa/KX7vrKxlLYWgkl5olgS
         WVJ6OJsiX30c4fUuzoYzJ8zJOhsjhGdezPBkvouPZWVxLb25J1cKodinqdGz+F+wA4Av
         aWFy4fQ2NP8YkmLWrCEH5ipi/u6Nh+ND+H4YMcEWFqyzkVi9A5Zy5U9Z+ED3mGAFMrs7
         WWxVlMajQ0PLPzZcBFCNxCovgTsTSsPUh1uqJNjB3hdQDlpo/wPBXo9B2K7ohaIKivWA
         vjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zVtGdk0rjbG9zPS1H0OAGsOMKM79c2DLp8XtkFgZJJg=;
        b=PJqqi6G/NhZ6knq+tpD/2v+82cseeSgh1pk9rpNJ/JLB//fuTNGCUZfjX/p9pZ3KcS
         UVUd5HSpTM6kS67PXgB+P7zPFruS/DVIgRU3vhjxSg8YsVB52zHGMkx0NaaoJO+UzapE
         PhY1Tj6rDpgTHPgSt2QLp7q1pJ3d5PIR1mAfFzTVhGJzgyUIwqofmQhsB5ryjk5BYnOl
         Vqtn9pzyHQjXvaj6N4w6H4k8rr2K9b0xuZ6ZQ85uzA7cCW3ANFpqSKanfQqdTfrf0LIH
         74Yug1E6ZQGXBmmG3oQiZ5tqY2qJ8iRfaoUcnnREZGn7zWhWSpLmFf6B1Uk3pDK7DwWM
         Sy7w==
X-Gm-Message-State: AOAM5339akikGiP4nAs+VNbxs9e3MEvdraXYePoT1v2xfK6Bb9QaKEI0
        rVjZvky2KCw1WsONIu2o7eg=
X-Google-Smtp-Source: ABdhPJwM962tGF6UtjnRbh5Fcr29d0zSiopF749THBT1YU/JKjGTWcyORTFSoyNQ4/lZljoCHtKvIw==
X-Received: by 2002:a17:90a:7bce:: with SMTP id d14mr5924645pjl.38.1622825197025;
        Fri, 04 Jun 2021 09:46:37 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id w2sm5107613pjq.5.2021.06.04.09.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:46:36 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 3/4] net: dsa: sja1105: determine PHY/MAC role
 from PHY interface type
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
 <20210604140151.2885611-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc631491-d3bf-ae89-5d64-a6e347ab9a05@gmail.com>
Date:   Fri, 4 Jun 2021 09:46:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210604140151.2885611-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/4/2021 7:01 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Now that both RevMII as well as RevRMII exist, we can deprecate the
> sja1105,role-mac and sja1105,role-phy properties and simply let the user
> select that a port operates in MII PHY role by using
> 	phy-mode = "rev-mii";
> or in RMII PHY role by using
> 	phy-mode = "rev-rmii";
> 
> There are no fixed-link MII or RMII properties in mainline device trees,
> and the setup itself is fairly uncommon, so there shouldn't be risks of
> breaking compatibility.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
