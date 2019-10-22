Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2555DFBED
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 04:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387537AbfJVCku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 22:40:50 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:46223 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVCku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 22:40:50 -0400
Received: by mail-pl1-f169.google.com with SMTP id q24so7571640plr.13
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 19:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iMhPIZNyIdvIDV2I55lP3X83QZvIWU0XIDvHalmkorg=;
        b=IEzAouKUhzPhbS8a95MfrQgFBuQU8k9vZUFMw2VsfGtIdeZeeaBdPTkUhBq1BWrhn3
         hWoK1VUNnmW68adNsepy8Xp2/HgSxdSb1rIV/k4L9hgLKAPTV4JyiAWkQUQcNUkT2xy+
         bmWsBhEaEhi/cYwLa46ekbcW6NcD3TobVpZ33cJwkqJmQ2W0JuL+6is2xWyWDmr+3ywA
         JWejdVbAynyfOIaUT2/LOQigtrD/rwkCpoC9Gm2ID3tNVPOyir4Z+i8hv6TUqJap3ZmD
         47NrlsB29Eqn6EV41tJ3AlVIkxX/qv7gGwirRLvuKjoLiBWMnosuMZYQ5dnpHdWVFUsG
         QccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iMhPIZNyIdvIDV2I55lP3X83QZvIWU0XIDvHalmkorg=;
        b=iR54lMyq9kJmt8+6rVWcVEVtc2Vp3zhpxXkOuWtRXeS9xvWmS75zyJIi4rEPg9p41L
         EHdl8bWwuv6HvlVDsJci0ySB1iCD2m3Mf1f9TZL7gdQlYrsgkGRlu1lLSBHvIL5nd4fn
         zUcwhtP+C2RJljwoxrLeWqT5JAgLEhux6rHK/rAuNYOEH5Pm3tSISeveV4p+LZvBSYKm
         gkrRFe9XXIZBhHxXiTkdvn2fsQZ8KkhYWWljEpJXyzZ+BUJzpzPnlLLVt9gLDzvvo4Ei
         Z+AupS/MNA5Vmhz0BDE/Z2LeyT7d18o+CpXY27IXGYjS/1GYcJ9kR27y00ut785mtdPe
         5B9Q==
X-Gm-Message-State: APjAAAUaAubRCwiopyQTgHwiXImp10pbh/SL/tPP54YQqAu1pQV0/KkX
        WbvgOBA273S/sNVz6gz8+PVd0HwU
X-Google-Smtp-Source: APXvYqz4pIA1a1/YAqHvxYoEFUubEcXndPKENN8Bnpd/WLVYYANVkZqhVyJro36CguHuMRaNYgXSXQ==
X-Received: by 2002:a17:902:788d:: with SMTP id q13mr1228404pll.41.1571712049250;
        Mon, 21 Oct 2019 19:40:49 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id l24sm17507611pff.151.2019.10.21.19.40.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 19:40:48 -0700 (PDT)
Subject: Re: [net-next] tipc: improve throughput between nodes in netns
To:     Hoang Le <hoang.h.le@dektech.com.au>, jon.maloy@ericsson.com,
        maloy@donjonn.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org
References: <20191022022036.19961-1-hoang.h.le@dektech.com.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <88e00511-ae7f-cbd3-46b1-df0f0509c04e@gmail.com>
Date:   Mon, 21 Oct 2019 19:40:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022022036.19961-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/19 7:20 PM, Hoang Le wrote:
>  	n->net = net;
>  	n->capabilities = capabilities;
> +	n->pnet = NULL;
> +	for_each_net_rcu(tmp) {

This does not scale well, if say you have a thousand netns ?

> +		tn_peer = net_generic(tmp, tipc_net_id);
> +		if (!tn_peer)
> +			continue;
> +		/* Integrity checking whether node exists in namespace or not */
> +		if (tn_peer->net_id != tn->net_id)
> +			continue;
> +		if (memcmp(peer_id, tn_peer->node_id, NODE_ID_LEN))
> +			continue;
> +
> +		hash_chk = tn_peer->random;
> +		hash_chk ^= net_hash_mix(&init_net);

Why the xor with net_hash_mix(&init_net) is needed ?

> +		hash_chk ^= net_hash_mix(tmp);
> +		if (hash_chk ^ hash_mixes)
> +			continue;
> +		n->pnet = tmp;
> +		break;
> +	}


How can we set n->pnet without increasing netns ->count ?

Using check_net() later might trigger an use-after-free.

