Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4200F3CCC28
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 04:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhGSCUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 22:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234097AbhGSCT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 22:19:59 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7DCC061762
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:16:59 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id b18-20020a0568303112b02904cf73f54f4bso3153593ots.2
        for <netdev@vger.kernel.org>; Sun, 18 Jul 2021 19:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w7nShgb27jDKQVYMgG8IWKFdPwetpVboImcgOULQ/YY=;
        b=qR9Hpg7hczMNvHldptKxCfeB8bnltYjFNGAOrpLxJ0fjxgsH0TEcXKePOdb0+4zHhx
         i+CbS7QUfObSIbiml7hczxclRzY0HSE1+3QEDRu17782crlKU5YHbbRMy3vimhwu7APq
         eSh0AvLSGFINfmH/bt9Xw+HZgWKFII+zKS8wSJxw63AzKMi8CcnpY5iDwUqWKAFBpRXw
         4MxbuC+h8CsW2voXsxUCTtzZj78VTwScpq36K4/bckp5+LqbfEetWhMdY+29w48N9BcK
         k3nmrYVGECTm4vHQB9c5tHTlVz6TWXsb+5eScLxNFBWGkIfU050wQZY36WcQnvvrj8ZR
         oPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w7nShgb27jDKQVYMgG8IWKFdPwetpVboImcgOULQ/YY=;
        b=GBxmq9NG/3Rh/jvw6ngNtJu21t+CwRNU++99J1gBStD7Vtat7pSjpo1+k6054R9M8v
         IxVl1PYbQ6tZYlpgY7JtI3sMy3qWDR511mHuCOGaBgmt9WB23xXsxTw6z6/Yw/t6CN3/
         toZLwlHVpTe3nRJ9BDC7UxUQVUqhUXN5FuFtOmtl1XM9OhThsSxgS1b54G5NxiR7CMGD
         PBYzeJX2vzlTweA8XSmxTZWyqWrYhNnTwXYdVdwZ+1mFqnVuneUk+Q9jqZrFWNGY0vVr
         QbaDHRKRNlM1D2/F9+INaTVEXzXpOd9tuYZRxkdLg4AwyGvaLYjEkYZUYQcfiJk0/fJn
         np2g==
X-Gm-Message-State: AOAM530nFt7wIwhbzqyqGjmz3dWsL/5/vFuaCEZrgBSBOJDTXKOMI0V9
        k/BAlc3UENZUpfuuVbm/DfA=
X-Google-Smtp-Source: ABdhPJw3Z0O9xpMZ/9kBd85A56qzTvgp3b9GEbiY8M7MHmazE8vsqz12+pQmXSH8lkgoTbtDMYWxZQ==
X-Received: by 2002:a9d:6ad4:: with SMTP id m20mr17288876otq.338.1626661019135;
        Sun, 18 Jul 2021 19:16:59 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:49e1:751f:b992:b4f3? ([2600:1700:dfe0:49f0:49e1:751f:b992:b4f3])
        by smtp.gmail.com with ESMTPSA id t10sm3381730otd.73.2021.07.18.19.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 19:16:58 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 04/15] mlxsw: spectrum: refactor leaving an
 8021q upper that is a bridge port
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210718214434.3938850-1-vladimir.oltean@nxp.com>
 <20210718214434.3938850-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <64fc7812-3c86-14ad-8245-ed84fc488b95@gmail.com>
Date:   Sun, 18 Jul 2021 19:16:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718214434.3938850-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/2021 2:44 PM, Vladimir Oltean wrote:
> For symmetry with mlxsw_sp_port_lag_leave(), introduce a small function
> called mlxsw_sp_port_vlan_leave() which checks whether the 8021q upper
> we're leaving is a bridge port, and if it is, stop offloading that
> bridge too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
