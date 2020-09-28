Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E33427A55B
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 04:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgI1COW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 22:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1COW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 22:14:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBE3C0613CE;
        Sun, 27 Sep 2020 19:14:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o25so6982742pgm.0;
        Sun, 27 Sep 2020 19:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FV8A+EywFsnOxUdutpQb62bbvJSvIf5l9P7xbyE+9No=;
        b=Dj6ITJi9NyA7HBzdPuxoWu7vEDpzb0kAZWxsjI3xBTXGdGAEhxL9xUpQtUfbLhShbd
         vwIielGoCVXEcyO5l+EsaXWkqGWd1n/h4LzWVwvNALELcxBWiEY1jRCxzWxvfw+GnAF9
         iJA3JyDV7A08PuLHXvKRYljMc5Ur85ovvQdPNbuN+/hAmwGP1HxS/4Yc/ILDIeYuJchM
         SsaOBbn6yWH44ZDfUGlHN+sYztbnYQozCnuuC9n5o0IaY0mcXQtGIeMm7ZdS+1IlR8tP
         rFqVd4P/QLV7Z2GH4dZGGzcWAEC8Kbvf8X8gGXY2MXj7JCU/ElwLZey0H3B5Z06ttych
         VFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FV8A+EywFsnOxUdutpQb62bbvJSvIf5l9P7xbyE+9No=;
        b=Y5eryTK4hZteoBjKrs40nIu4tWDkFuLLmbrngwHcFQaqO+XIkRSDiK/cBmpW/UIf8u
         JneeQ+tBoYASATuwOeD7F4qFfPOI7yvK7vCqEIy326GkDIb/HXdIIN4CdiGyl8AExI3x
         GsbrklMu0+FgYaa3SDXaK/g/aUNG0ResmnABqZBeRKLHmLL/8qHUB3Obu28xojuiy9nb
         ULlYZDVIyhRaPpRoNUgFzBEGFSt9xLL2feVNaWrU023C3PrHQiqll7n/79pyHeNCEexk
         LYsxPEUHsTkEFURbFOfvulntNUh+HVspbJuP412n8CBalLeQxKmkgCKbA0hdtrcDhuRF
         EiCw==
X-Gm-Message-State: AOAM530rCjgZVd4zHejgU83hLiVNOq6w0PYyLdkKgL2SxszimbMLJZSH
        wvzOZuAbGt3tzCARWhCgLDJKBKgOg2uaAQ==
X-Google-Smtp-Source: ABdhPJyXeD8y806F63aNJkcxnfEZZp9JH70sOwZOCakVTgo01Kj38Wtwjj9YkMb218pnkU+wXwIZ8w==
X-Received: by 2002:a17:902:b685:b029:d2:1e62:4cbe with SMTP id c5-20020a170902b685b02900d21e624cbemr9289994pls.58.1601259261194;
        Sun, 27 Sep 2020 19:14:21 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id y4sm7985924pgl.67.2020.09.27.19.14.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2020 19:14:20 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: vlan: Avoid using BUG() in
 vlan_proto_idx()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200925002746.79571-1-f.fainelli@gmail.com>
 <20200925.141234.274433220362171981.davem@davemloft.net>
 <20200925212020.5cniszgzxfw3lq7r@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f9de6169-7a1c-bb9f-67a5-fc724756e354@gmail.com>
Date:   Sun, 27 Sep 2020 19:14:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200925212020.5cniszgzxfw3lq7r@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/2020 2:20 PM, Vladimir Oltean wrote:
> On Fri, Sep 25, 2020 at 02:12:34PM -0700, David Miller wrote:
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Date: Thu, 24 Sep 2020 17:27:44 -0700
>>
>> Applied, thanks Florian.
> 
> Uh-oh, that 'negative value stored in unsigned variable' issue that the
> build bot reported was on v2, wasn't it?

Yes, I will be sending a fixup now.
-- 
Florian
