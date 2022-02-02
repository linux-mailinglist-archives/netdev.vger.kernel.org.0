Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955C34A6A62
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 03:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243910AbiBBC5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 21:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiBBC5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 21:57:51 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C28DC061714;
        Tue,  1 Feb 2022 18:57:51 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o64so18997229pjo.2;
        Tue, 01 Feb 2022 18:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=4lpa46JOOI9+V6m/Wzg81wuGZMW8WCd8g9diUYRKJRo=;
        b=bEeMQnuvWJ1aGbO//Fc/wxTCCioVLMfDGrIyOiBtWiBzXHmtxFHe4d7edEzrp1aiGH
         fSAre48ZdUbFByceEC6Bnib8R6vIUI/MGPSgiWwOQ353VCbHVqoJTAx/f2f4RnNnBN4V
         BKZra8NzIpoyD8OqlV5uSHBnY8tqQ8jZI1U7S2w4tC8zX+n+A9Wmd4xCM/1/9Ct2blGV
         YWR5SYV/09eJfowAyt2f7/wsGNMGzxmAYDwE/O6/RAJi45CgAOApoumieJPuRbszyzee
         WPvSwS6m0rGGIPhvxu04PPIN8fFPQjZxU1xtBY/nYUQ3bRj6dGLYlV1CzORupnLNRO73
         r2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4lpa46JOOI9+V6m/Wzg81wuGZMW8WCd8g9diUYRKJRo=;
        b=lf+0JQl87Ahtb/qjGmD+eWg1Z82T2lavIyAhPqsNuPrP4bySr/fCoSOt4l2HgRCegA
         zITylr3jIQMDIxfiXRDch59MzFWIpLX8uyVxIYeKm+DFUk8xAj0dquLsp+lVtl9YM4Ni
         WkoajfFXHDGR9qOy842iJLskwhXX00trbzlg5sL+jOqeafqco1FxDxbBDuZKPdXkLHXi
         fB4uLV9wqADoFXcY/CLJ1LIgpJtaQyUwykks8dFKw/0xiYr1AvvpH+EaeFjHa978SaYg
         A7MbwbjNa282BvGVDZgxaQrT2/gro60uyeN1EyLFop4bO2WiuMddlYt7JSgKsKMKAtF4
         zBhw==
X-Gm-Message-State: AOAM530PAH5jOqPPf2LUpGf1EER7C296+PPFvcAEUWMUVabu3H0RLGWt
        gbUZvakzGMnDjjMKn/aoykk=
X-Google-Smtp-Source: ABdhPJyMqKtVMrpgb3NQq4XodSedpDTNMaLHjedEHjkl/sUBM3iUP1hWQ1pr5NRRrlcTgFJICJg4fw==
X-Received: by 2002:a17:90a:70c8:: with SMTP id a8mr5850615pjm.184.1643770670940;
        Tue, 01 Feb 2022 18:57:50 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:a52e:6781:7ca4:b203? ([2600:8802:b00:4a48:a52e:6781:7ca4:b203])
        by smtp.gmail.com with ESMTPSA id r4sm4093936pjj.56.2022.02.01.18.57.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 18:57:50 -0800 (PST)
Message-ID: <d7e25f71-69e0-1f84-215a-422c7ee4388e@gmail.com>
Date:   Tue, 1 Feb 2022 18:57:49 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [net-next PATCH v8 13/16] net: dsa: qca8k: move page cache to
 driver priv
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
 <20220202000335.19296-14-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220202000335.19296-14-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/2022 4:03 PM, Ansuel Smith wrote:
> There can be multiple qca8k switch on the same system. Move the static
> qca8k_current_page to qca8k_priv and make it specific for each switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
