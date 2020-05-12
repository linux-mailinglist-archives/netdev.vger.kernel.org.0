Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BAA1CEB54
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728726AbgELDZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:25:30 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F880C061A0C;
        Mon, 11 May 2020 20:25:30 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id s3so9786554eji.6;
        Mon, 11 May 2020 20:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nhIOhYwVXb94b0BLsBCMKt5cvncwU1zQHMuYPZV4aWA=;
        b=RmzL+kvYfi6zOYtspDdp4pm0Q1Kxfj2QOVHoH4SKscvNCyGLU7bBsADtx79L8kp46U
         y2a5S0GFyxp+q1CxwJdR/OQ1LwJdacJsSCwhC81rSPlrH769lAOkcMgt5ZCCRhrvwuWD
         YTKsJ5zY+CIGoyqpRJKCcw3qbWDVX0wkNxcQm0gkdUe6IIH8CIPAXgBcvzCeneD7XMg3
         5M+ZIYyVZ8bFuW1UoB6ykN0Ogb3+PDarwd5zmP3N6oYxT9ALViqPWCNJtpStgCH5ohvM
         mezy2X8vjsYPtAEVcULT1YPr2kArmjrx2NOH/ASfPLDZ4F04Fhyi56O35nHBsHQrfe63
         u4Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nhIOhYwVXb94b0BLsBCMKt5cvncwU1zQHMuYPZV4aWA=;
        b=c4RHXca0CRHHq40xcuH/b7jcavMIuei2pEsErnKdOQdME1sF6OX122h19R1PjKDlHv
         1HQg+wJ6Jv74djsI8kUQBgyC2Zp0qAgjO63ZgZpoWNOVXu+gxRt11hmIN/87WcxfH2h7
         aVnuQvsSw+MULfIyZDRvmhmSjaS/WNuYmbx51I7mcZkkYSbKjkU5G6rKg1VxPit73MX7
         p2NkKXrWEnk9x3j4UkMoSkZKY30pnj1y1cWnzw97SELCqhV2PrmdXsjKssQf90cUYjKc
         gUD0Fv3yqnH6QdJ3Cq6KD9c6hvgn5GY7JVBb99yKoSu1ZbyeBc6K7ItJTiAchl+pqt5R
         310w==
X-Gm-Message-State: AGi0PuY2wlTFouk8cB2mG/riRmjsO3X676R8J5duA6oBdHA1522HiJNY
        5cD2or1iEQrE+C5ZF4cYeJbL4aw2
X-Google-Smtp-Source: APiQypLeYzgv3zXR8LNlyeJJTfJOVvxm5y1rshMt0K6GvwlILJXt5x9BthKWrEQJk5Do+KMEjtLgSw==
X-Received: by 2002:a17:906:7ac8:: with SMTP id k8mr16370035ejo.235.1589253928872;
        Mon, 11 May 2020 20:25:28 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h8sm1213632edk.72.2020.05.11.20.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:25:28 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 06/15] net: dsa: sja1105: allow VLAN
 configuration from the bridge in all states
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <df19d2fc-d210-273c-b80f-b6415071d4eb@gmail.com>
Date:   Mon, 11 May 2020 20:25:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Let the DSA core call our .port_vlan_add methods every time the bridge
> layer requests so. We will deal internally with saving/restoring VLANs
> depending on our VLAN awareness state.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
