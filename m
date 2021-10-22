Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1D7437C0F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbhJVRl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhJVRl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:41:58 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0310C061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:39:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id y4so3284858plb.0
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SdY2PE0TW+UHrnMr2vnSbFKiyxh0oNzxfY1cQrrqoyY=;
        b=JcJrt11Hi3FiTj871rrEUBMGp4KuelKbwpAHLj4bhP2qIGKkDMLEtMNZI9za2v0U3t
         ffE/y7jyjZYUtwZdQ87PNSBsJJYXIkAeaDO7Ob+hADYGHISmbqF9AKYaKHZtZcBwSDwG
         LgWbxk1o+FysaxJp7FtTWcWLgY5X5oxVl6fjYOaEtR0bHHWgPVxl/CxDbadQ5IkOig8Q
         X7V3VvuKH2j9NtDcRaoXJW2sYZrz5B5eZw92GTzSBldurAa1ooFi70qHbrtCnQ1NjJE7
         LagrGV8lo0mivBHS81TAxuv5dG1FIPjVNqxSg0a+TBmJ7kODlOdUIb6sY/9WlyHr8qVC
         e6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SdY2PE0TW+UHrnMr2vnSbFKiyxh0oNzxfY1cQrrqoyY=;
        b=AjZzNnTNPFnI91vKznp5P+EJT/RzK2j2oEC8cJLCMzTGcqyoxVhwdyaQngdtPbQlJD
         vvTIe9PyO0g7VIMrpxHfWldS7ILMTxw6KRlYD9fMvtNNMdFiM0Tzd/kH8PHxm19yv4Mz
         a4WXhTqqKezFtv7jC1zAa4MhvcJhAf6T9Uh4ubemfMMT+I+8Z4XHU1KUST7OA6w/qlqS
         CZeOZGPF1fdntiJEi2QsUJge5wII2hK1vOvLrfGOgC1aNrWEH2xYJGHrfdjE44BZ9oZ2
         ex9x7Y3dHgnHI9j+4LloQKN5PDi4Gn9UGcYrmbnLIo2Fby4DX7OpyL5pzqwXUDTCsc8N
         NDHw==
X-Gm-Message-State: AOAM532OuCH5nSAlbq+88x35+K+x+0S4l8u5g8VWk15J0RWalTGw+34Z
        v9I+PGF9h4TekAcnSUvuEsE=
X-Google-Smtp-Source: ABdhPJzQ4uQX65I2huA3PU9KLpcrRDS/HF7qUQNGxaPa8Krs7wLT7MLd3DwePJJCGnunAe7/hzp6xA==
X-Received: by 2002:a17:902:ba93:b0:13c:a76c:4906 with SMTP id k19-20020a170902ba9300b0013ca76c4906mr1182009pls.40.1634924380369;
        Fri, 22 Oct 2021 10:39:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z11sm13504434pjl.45.2021.10.22.10.39.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 10:39:39 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 8/9] selftests: lib: forwarding: allow tests
 to not require mz and jq
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Guillaume Nault <gnault@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-9-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bdf51f26-c5e3-af56-50ff-035b48a1d97a@gmail.com>
Date:   Fri, 22 Oct 2021 10:39:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211022172728.2379321-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> These programs are useful, but not all selftests require them.
> 
> Additionally, on embedded boards without package management (things like
> buildroot), installing mausezahn or jq is not always as trivial as
> downloading a package from the web.
> 
> So it is actually a bit annoying to require programs that are not used.
> Introduce options that can be set by scripts to not enforce these
> dependencies. For compatibility, default to "yes".
> 
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> Cc: Ido Schimmel <idosch@nvidia.com>
> Cc: Guillaume Nault <gnault@redhat.com>
> Cc: Po-Hsu Lin <po-hsu.lin@canonical.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
