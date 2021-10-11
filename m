Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AD0428547
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhJKCry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhJKCrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:47:52 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7235FC061570;
        Sun, 10 Oct 2021 19:45:53 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id d21-20020a9d4f15000000b0054e677e0ac5so5943513otl.11;
        Sun, 10 Oct 2021 19:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=mtEc0q1ZAK70NG42idQdFNRceyD2otnL/SO0S5AnFRI=;
        b=RaIxldsfvXYL5i04wysGkvW42TH/j08LGn6MoeWeBXkx9YCMjVfgcw4NI05oJDb8+e
         zrKtouXYxfvDdDSQEl4fjOSA3TYCh6xwMSu2ljh3A+O6bwk5ZQFPP9YYi+oi2CpVqE91
         yaafjhS32g5UdzTSZNjP5SBDAQYJYOHxQzqb8fXAThzl72Sqqt8SajXZvxH/GB5wIiL5
         4ys/t3QnslwHCqh8i6ZrByZf7918GB1Sy09PX4ufJV/allL759oi6fJNU9ncEPudrsOF
         UH9XT3dUC4to64xcTVarkTfpZakN6eanivIO5qTU5KQCeZnX1j2TXHsYa2PwdZiUI2k4
         Y4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mtEc0q1ZAK70NG42idQdFNRceyD2otnL/SO0S5AnFRI=;
        b=W4RDKQRUSSLDN+kRzTZmnWzoKaYkMymVljwWehogDzo+CJxwFY4JDTpz4Ya6M1ocJl
         7xPl3EN6mK7tEWk5NHVX2DOJzCXZOy2Nj80TBJoyIeX0EE3UiGVMyOQJMbnDbTEgeWXs
         Y0S0tmuY2pzoCcDy17SKFMP4KhxMUsiJQzVl0W7b8o0ZtWMVi6hI5LM/GhX6+hgewGs3
         gm6dutB6BglH4lcIVr5YOnfoIWtAPyCOFP3fQNlN1/ysEd8eXJZ7QWS2ex/dF9sqBBB7
         OdfwqEOJLhOkv5/sjIfIBBCfUotgEpc+5c56N/U4VB+W272CFd36/dZGQrkk1XStrIcx
         neYQ==
X-Gm-Message-State: AOAM533Ws8yO05aH7Y5VgtSyIGyqLrLPjp2DSDTmtM/Q/SqtBrpfEiYk
        zxQejl0q2zy3Nts8P82djxtMJ0xOWww=
X-Google-Smtp-Source: ABdhPJzB+2t7WwQBN+NmaWvk1/PgzrTjuYnEgzjB/i4wIHtS8yogUndrOxurn4rPsCBHaI7pvdaH1Q==
X-Received: by 2002:a05:6830:4033:: with SMTP id i19mr18180750ots.320.1633920352849;
        Sun, 10 Oct 2021 19:45:52 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:3cb6:937e:609b:a590? ([2600:1700:dfe0:49f0:3cb6:937e:609b:a590])
        by smtp.gmail.com with ESMTPSA id i25sm1515549oto.26.2021.10.10.19.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:45:52 -0700 (PDT)
Message-ID: <6cfe6214-7b78-feca-e7ad-796a37ab369c@gmail.com>
Date:   Sun, 10 Oct 2021 19:45:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 06/14] net: dsa: qca8k: rework rgmii delay
 logic and scan for cpu port 6
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-7-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-7-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Future proof commit. This switch have 2 CPU port and one valid
> configuration is first CPU port set to sgmii and second CPU port set to
> regmii-id. The current implementation detects delay only for CPU port
> zero set to rgmii and doesn't count any delay set in a secondary CPU
> port. Drop the current delay scan function and move it to the sgmii
> parser function to generilize and implicitly add support for secondary
> CPU port set to rgmii-id. Introduce new logic where delay is enabled
> also with internal delay binding declared and rgmii set as PHY mode.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

>   	/* We have 2 CPU port. Check them */
>   	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
> @@ -1009,14 +948,56 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
>   
>   		dp = dsa_to_port(priv->ds, port);
>   		port_dn = dp->dn;
> +		cpu_port_index++;

Does not this need to be bounded by QCA8K_NUM_CPU_PORTS somehow to be on 
the safe side?
-- 
Florian
