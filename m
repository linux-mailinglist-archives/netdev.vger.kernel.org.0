Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA28DE263
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 04:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfJUCwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 22:52:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42288 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfJUCwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 22:52:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id f14so6809703pgi.9;
        Sun, 20 Oct 2019 19:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3YcbFlGeukZjRaHUc52Yo3oow3dwGRvRToPt56X0JRM=;
        b=JvI3M1rWTuzFM3iSmyK6InPBkB4WEv/pU/GpE+bjUHjj0Fa0/IK2SCua5cuAieKgIo
         7YAOfmLd8d/Q0vaQ1aZLg3xVzse2dRHE2I54Lnp9iOMXSmhtA2q7mwytiY1cpkpEx+FB
         BfpLRHkL/PbuJQ9P2DcZOZbHXwEKbORTuVuwqPLQT6XytdE3jU92IcdW3/bJzISHaRlr
         ZSbVoELp5O1s7gYzkDL0hC3zCtSgYYLMYHxymywZWZMTHE1r+NJtcyxA2aelZRdL1kyt
         rRUg55BMbWbt4PpcWAObWrgPR8KjlD20exC1VVOjcbFy8ejMAhHX8YXbLfKMxmLyUjOM
         EKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3YcbFlGeukZjRaHUc52Yo3oow3dwGRvRToPt56X0JRM=;
        b=MlvXGfv3o1IqFw5OfX0a2+WHTEJVM3ngUMm+tuEI+KocULekGjGfSnbsrjr3ZtQGsj
         afY8qXNtE5ZpPXiARU4kU7TzAxF9Fv2lqClAw9LIT+Urb4eOLR1dN1sF/SAZP197pa0D
         5NbQY6vvr1bYX/XwH8DkYKMrkj1j4osTnp8dglbeVRcQpbr0brYWO8QeX9+Ebm2buS39
         5AX0EP+KSQfqQ20Pksui2LxLGIKSwUc5VW83m7j6NHYv+56IoJbM8lQ7Lbgy6V02gtFg
         e2dHD2Japwq800KlNfv98DSlDupWIkuFTIO3YBs97NwgIwy6JUcns/v1kPG2FZTKrz5T
         pRAA==
X-Gm-Message-State: APjAAAUsVu3NDRJSqI3mybi8UVP9fQeEBkeEX4r3EEwS3nZWIv68UAkv
        NvDGWi2i5Fh8xJD5rzew+zKEpP0E
X-Google-Smtp-Source: APXvYqx4a0OcWArwZ1Ln4fo0J8+fBzMMIz1WvSurss5T1G2/AgEkcePxTyFSqRtUr1xm460o3vP3iw==
X-Received: by 2002:a63:e056:: with SMTP id n22mr22410398pgj.73.1571626329018;
        Sun, 20 Oct 2019 19:52:09 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c8sm14454465pfi.117.2019.10.20.19.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2019 19:52:08 -0700 (PDT)
Subject: Re: [PATCH net-next 13/16] net: dsa: mv88e6xxx: use ports list to map
 bridge
To:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
 <20191020031941.3805884-14-vivien.didelot@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d6170cf3-233a-b632-9ab9-26101793f315@gmail.com>
Date:   Sun, 20 Oct 2019 19:52:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191020031941.3805884-14-vivien.didelot@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2019 8:19 PM, Vivien Didelot wrote:
> Instead of digging into the other dsa_switch structures of the fabric
> and relying too much on the dsa_to_port helper, use the new list
> of switch fabric ports to remap the Port VLAN Map of local bridge
> group members or remap the Port VLAN Table entry of external bridge
> group members.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---

[snip]

> -		for (port = 0; port < ds->num_ports; ++port) {
> -			if (dsa_to_port(ds, port)->bridge_dev == br) {
> -				err = mv88e6xxx_pvt_map(chip, dev, port);
> +	list_for_each_entry(dp, &dst->ports, list) {
> +		/* Remap the Port VLAN Map of local bridge group members and
> +		 * remap the PVT entry of external bridge group members.
> +		 */

If you do a v2, I would tend to put these comments under the appropriate
branches taken below for clarify although the code is actually clearer
this want than it was before IMHO, so up to you :)

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
