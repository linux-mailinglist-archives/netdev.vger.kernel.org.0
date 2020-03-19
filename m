Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC0718AB3C
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 04:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgCSDon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 23:44:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40364 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCSDon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 23:44:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id l184so646284pfl.7
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 20:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xn2agwsU4HwttH/mXEjIXPUk+c6ODPCegO6RSyC6v3c=;
        b=Fhe/ImDYVZwJj0KbrHnCaevR030rzkHYgvfDNhMoRJraRYWG3qOV0fBIXmJCj9x11h
         HiRNvWcPOUUw9c69tzpd2EzrId5FJ2w6r2wYUiy7yMpJoLftCgHSKVH7QA639uTz7Lz7
         ocvfPazfROZJ5nxZYeJ+iH3p/cgcbBijeCfeYlyUl5QJrf/YYmNOM1iHviZdvrVHpZ1x
         sLep+mBTgV/Y2JVGf6hf6Yok21bgtQN6N0IdpoCVr203zC+pD+erxfbBBuuSlrdsEZHl
         huWy4ZQ1MlDFc/PVJsY3RPMExHOIgwG5kOpb2z0Dj3SVydJSzMdlnwUA8zRtb4DZNsoE
         kapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xn2agwsU4HwttH/mXEjIXPUk+c6ODPCegO6RSyC6v3c=;
        b=FzGRqfd3R7UVNVGaB5XZSj7l/nz6cHF4uW7CNqzVNlGOoKVN16Lg2pcQDA+zvv7Nor
         iTqOYyN0A5K+IhQOZmRNmVPF6piNu1Ol48Lzz6nSIZ4tjjCO5FuVFCng64mzh0BZridc
         Mx6+ZLDhYqpMsAxFs7Qp2XjQK3NWtGDC0Z+gE42u+RCa8noFdPCGucrDcZbptEigPxBF
         SRNugvPXVi9LaIqH01qGyvPwxNBsQ4jrzKY4AZz3Bl51+6vgQmxM8esKF3Rc9aLvO3k9
         +v8LmZVoMW3d2dSNv6x2Cn1NC5v3Rj5bJ13tUoOmEBu3klcFji6XQ9S2ns/Z1d8Os0Hc
         LurA==
X-Gm-Message-State: ANhLgQ1J9Mp+DnNRC074CkhNqtZPQ4GcHJFewAsw1gf5UuQCYriFRTmD
        KxaqoHHvjcRqjN2AsB/ERqA=
X-Google-Smtp-Source: ADFU+vtKv2/h2+tjnvf8tZbAdKlBwqF5Q2KjGiv0AdhZgeVl8qmiejoyt/GwP5a06BXTynfwj2V5jg==
X-Received: by 2002:aa7:9711:: with SMTP id a17mr1844107pfg.143.1584589481018;
        Wed, 18 Mar 2020 20:44:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f68sm364710pje.0.2020.03.18.20.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2020 20:44:40 -0700 (PDT)
Subject: Re: [RFC PATCH 09/28] gso: AccECN support
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1584524612-24470-10-git-send-email-ilpo.jarvinen@helsinki.fi>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6940af98-7083-15c7-dcea-54eb9d040a3d@gmail.com>
Date:   Wed, 18 Mar 2020 20:44:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1584524612-24470-10-git-send-email-ilpo.jarvinen@helsinki.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/20 2:43 AM, Ilpo Järvinen wrote:
> From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> 
> Handling the CWR flag differs between RFC 3168 ECN and AccECN.
> Take it into account in GSO by not clearing the CWR bit.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
>

Does it means TCP segmentation offload is disabled on all the NIC
around ?

Why tun driver is changed and not others ?

I believe you need to give much more details in changelog in general,
because many changes are not that obvious.
