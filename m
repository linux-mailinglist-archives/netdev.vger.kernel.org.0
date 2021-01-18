Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB022FA7C1
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436645AbhARRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393214AbhARRmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:42:38 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A68C061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:41:57 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s2so18466647oij.2
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yEW2I0gsD1vAgt7tarv/tDD8O3Fnrfnq/jUF4oIrxMA=;
        b=F/UQUldJ8H1WNCJXWNfLbiOSfye4srSPXk7tvvP4yCroOTGQWrGkCFkDNpmp/I+OH7
         B6kcyIHPiSEKg5Xq3mLhUTzo9896RwyBTmuDLJeD9tWT65gCCdBttr3CCeTrIKXwNBAj
         Ukvmqo2QsHT6o0BwceytU6E3hxABIkjBHP2FFfC1i4BIEaqOCU0O0EmKVz4D+XiuqZ7E
         5XA2P4c6fH+CyJAYrdtqTYhpMunULw47DnVB/7w1KBsSFQAhXtAhybay0Pp0U7srL1R7
         20+K4DFFgOUy5ZWDxyy7svI9j9bkDOKroG6o4FlGreWsjJhpqeC9PhOGgKddPI111BXs
         6sWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yEW2I0gsD1vAgt7tarv/tDD8O3Fnrfnq/jUF4oIrxMA=;
        b=fcThZUM2aYZi/M0uxYhTonvegDKyQ2ebhwooBbrMjHjgCJdC5KEdLctzn2CYrRVZMk
         nA/t8cqFkbjsV47aw1A6G2Pnlb8FGW0EYe1g4yVJIoq1Ty+NVKC1snh9iuZhasCH7X5c
         gY1x+jXErSp6BYCdRECMMe7uDgaMB+BE7FXv6TE/fYqkwNmc+5UqF+IsuSC2dmq+So/t
         1QxJJcJsdO/e7obeuMSMqCR6aLei1x2q+ryb12fKNzojP+1gdnZElvQHlQoan9/fv+rQ
         0FInlsTs5pHY4h3HaqkCXj+GW3Vdk2ln4e6jP+/MJelpVHC/Wq6m+4LcFGTio/SytmOF
         v51A==
X-Gm-Message-State: AOAM533NyKkToOd7IwWlWsmoRZTJ4yD9FU/WSySkHEAPq3iAk5Y/43sZ
        9JBusxyD56L6aXAcvMV/jbU=
X-Google-Smtp-Source: ABdhPJyrXVi0P5UxgE/3kvUP6JpZNUaqPLfP9vAXPZMSjmm7gx/9SFBE7VyOLcG1XoPDLpHBp89cyg==
X-Received: by 2002:aca:f15:: with SMTP id 21mr271516oip.151.1610991717137;
        Mon, 18 Jan 2021 09:41:57 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.6.112.8])
        by smtp.googlemail.com with ESMTPSA id k3sm3693555oor.19.2021.01.18.09.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:41:56 -0800 (PST)
Subject: Re: [PATCH net-next 2/3] nexthop: Use a dedicated policy for
 nh_valid_dump_req()
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1610978306.git.petrm@nvidia.org>
 <151e504b32f5005652c64cdde5186ef8f96303e5.1610978306.git.petrm@nvidia.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8cf6b179-b870-f53f-6af0-f471f3f4c522@gmail.com>
Date:   Mon, 18 Jan 2021 10:41:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <151e504b32f5005652c64cdde5186ef8f96303e5.1610978306.git.petrm@nvidia.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 7:05 AM, Petr Machata wrote:
> This function uses the global nexthop policy, but only accepts four
> particular attributes. Create a new policy that only includes the four
> supported attributes, and use it. Convert the loop to a series of ifs.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 57 +++++++++++++++++++++-------------------------
>  1 file changed, 26 insertions(+), 31 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


