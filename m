Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D96E1F0F1A
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 21:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgFGTOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 15:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFGTOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 15:14:16 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0953C061A0E;
        Sun,  7 Jun 2020 12:14:15 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 10so1671827pfx.8;
        Sun, 07 Jun 2020 12:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+svPP8iGom+ruKXEfuIvy+SlCKGd8G4YhLvw6wX/K/M=;
        b=UY72aou8tdcZ8ENLbUmt3iCah1qc9veFcYBzI71UqEX0Equ6C6vKIVR8l0qzhq9vVB
         Pbx3JARWwm2QBHbCqoDX74Pol61Xge8JnfWQs/3j2a4ZqyrGvKSIG4C9oDyDWEV+MogT
         TqPtp1pOw1SYSc6F2UtzkM6N+pmof0CkjaQwT2kiCiYbdy6tpxMOqeroCFcuju/lSqxS
         bwlagtc9coKpDRs9ezGvNA4FoqJD0L+Vv23KQ4pIVS5qXv3q+rKInh5dfCkcqU/5oIIE
         RnGt6DNIY4xBw07tZUAv4Riw46Drakt/a2B3Fe8k468NNxd7Pga7Bl1xXlQLIZooWTOh
         Dcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+svPP8iGom+ruKXEfuIvy+SlCKGd8G4YhLvw6wX/K/M=;
        b=DCSYeuMf5SCBGGu9l/VfIeI1Jj+2lWlCLHplPeQePB/tDX4n7iB3PJciNIbBb+V/Qp
         Rw9NM/DtZTXNCLcwpEcoW77Klmyg4G3fuEobahJg+347/eh8KBpNIkvyYHajlk1PuGjg
         lpCaZxmIEOxQTVaAHhH47atAIBdvd03Uchfzia9CQ12RtX6UflDIbwSrY688qSOPMcZr
         d6cjfFhMoourTXFpVYhIo/DPUcYx12uvwJI+yoEHhwXo3TgxauXz6TxCW8b0Iu6NIVIo
         JyMNcqyQiBswnyn5jTh0UpfLKzulorZ7moZixJr0Vg8mAz+PoK4oy57g5FDgnmAzbvRW
         DTKw==
X-Gm-Message-State: AOAM530IR1ZPIf1AuSFWKW7ZvSqSDbqRixj09lDK47gHrFgB5HkUFpFR
        ilOArkYIjx0i8Oa1vCH9GWktn6vT
X-Google-Smtp-Source: ABdhPJxDK4CrZc7z16E6xg7w7jLRIx+nCU33l6Vu1p0pC0Hz40Oi7HT4bDiPBsu/xO+t9oYF9t/lNw==
X-Received: by 2002:aa7:9439:: with SMTP id y25mr18570777pfo.268.1591557255152;
        Sun, 07 Jun 2020 12:14:15 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id u7sm5161197pfu.162.2020.06.07.12.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 12:14:14 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 02/10] mlxsw: Move ethtool_ops to
 spectrum_ethtool.c
To:     Amit Cohen <amitc@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-3-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <83606c5a-2fc5-f596-f6c3-ac0d1bdc8c32@gmail.com>
Date:   Sun, 7 Jun 2020 12:14:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-3-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> Add spectrum_ethtool.c file for ethtool code.
> Move ethtool_ops and the relevant code from spectrum.c to
> spectrum_ethtool.c.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
