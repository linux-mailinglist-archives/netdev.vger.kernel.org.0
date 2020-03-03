Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E129B176DD6
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgCCEJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:09:20 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38734 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgCCEJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:09:20 -0500
Received: by mail-wr1-f67.google.com with SMTP id t11so2576792wrw.5
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K1+0Hw8A10KIQNoZ/bGWDgQ9UvIvjHdM2+A6AYv3gfs=;
        b=EVoQ4dPp46GKlTJYWzdgz6IAvMccOHm7EAwRPMtKgbAoxZqLM6HJk/IQKBpWwe+xyu
         8e9jmV4WCQCx2DZuowzbC68UwVfBSY4BFZ+iOBjYmnMlmOoVEdfIFr+xWHKTjcedlWwb
         oeyUjjl1xhmRvU3/ZueiXat1+JOR/F2u5E3M27yfQY35KZZ6yFWxsZJyria7GaQc3AXm
         vXE0HhtSanZ7TqxqQZG5K5kiUYvBskpWNbIrr67g8UxomAMD0JN1+3eX3mmdHxJy6TLk
         VC7sZSPIBykSmsFaBVwjcGMUDhaAuoM+U86Sh9BdvW87AXCbR8B6KR+uGrWnChi5yIOX
         KLqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K1+0Hw8A10KIQNoZ/bGWDgQ9UvIvjHdM2+A6AYv3gfs=;
        b=cne3I7hvsOC3EtwbrA8bmg7uM9qyXYwNDSTe5KQKByXtyRyJDmLlJjH+0M1qvUYZqw
         34h8ynMQu5ngWju9J1tIMku07Jm/pryXt2n8/d6Yi0rpC3YE+qdvWflQM/zkdnFVJI4o
         kyB0iNsXwtVGEpqM+U1Fs+N5ULNG4ydT9/K3MYHu0qbtVDhLSomg4QtSTYVP871eRD/U
         4uXP7rBQiwammaiN5f8WaUErNUsBkwZkNmnHQGyHTZCs7CVhtJqEnkbLoB/b6H3zHjWA
         7qANMNauA4msziQ8VormI9AGwEZmesxSuqLoFpranNP+qH7xoFe8kE/Yjoi/5pCk5Jov
         DSWQ==
X-Gm-Message-State: ANhLgQ0bNUwumGSkH9RMu4J82v/AxzA4WzOBcLzeRzyrz19WTTAVXNue
        HJFxUx/WEjcXudx1tTvZ6dU=
X-Google-Smtp-Source: ADFU+vshvAt/0r71mhWw729WuKGFs/o6/ilo6+oVCmTHEdnZW8VomUfvWURKGkidIJrWvyHl9KDI3w==
X-Received: by 2002:adf:ee09:: with SMTP id y9mr2913153wrn.393.1583208558503;
        Mon, 02 Mar 2020 20:09:18 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id m19sm1636984wmc.34.2020.03.02.20.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:09:17 -0800 (PST)
Subject: Re: [PATCH v2 net-next 09/10] net: dsa: Add bypass operations for the
 flower classifier-action filter
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
References: <20200229143114.10656-1-olteanv@gmail.com>
 <20200229143114.10656-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bb0ed386-8e41-0fd1-aa6f-a78906b750be@gmail.com>
Date:   Mon, 2 Mar 2020 20:09:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200229143114.10656-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/29/2020 6:31 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Due to the immense variety of classification keys and actions available
> for tc-flower, as well as due to potentially very different DSA switch
> capabilities, it doesn't make a lot of sense for the DSA mid layer to
> even attempt to interpret these. So just pass them on to the underlying
> switch driver.
> 
> DSA implements just the standard boilerplate for binding and unbinding
> flow blocks to ports, since nobody wants to deal with that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
