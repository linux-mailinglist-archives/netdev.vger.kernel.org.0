Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAFA1CEB8E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgELDgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:36:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A9EC061A0C;
        Mon, 11 May 2020 20:36:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id l12so5512591pgr.10;
        Mon, 11 May 2020 20:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=98ScUSd7u4eiPskxsjw0S6fRqOEvDHaqgNIQy4oHnSs=;
        b=nraE9pjv01T/UHh8HDHQ8OKgaWSMvxLK8F6rtoOEThKeq7cY2gjcfV1ctmAR7Sgewg
         PtBZSZZvXzw8JqhMwxZghETIu39FQBiOa0NWrw6YKcjbfEPPF44QJkJ2UKYlkvrCwA+K
         tDxPHHEj1ZiWJENXzwDZ3FLvbFcG1cSdvt155M9rsF1p0jw59aFdKyio1PDmikKZUkvZ
         TLOjJBPXNctlNFXADlG/LbLm3jzppiEqbWnkb5V1Q1EsvfiFn8Nj4jAnAqtQu71FP79n
         2CQkcHCHeWv9JUHZ5zk9N59BGoZI2zXQpsq6/yIaf5uaKiAJwdlWkMNxyff4niYVsOJU
         XJWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=98ScUSd7u4eiPskxsjw0S6fRqOEvDHaqgNIQy4oHnSs=;
        b=r8diWn2eamGWOMoHLm+kPVcsGL4zDaMqUSaW+rgutK2epAPAISC5Yen+I5juYBAWGJ
         UR8IQrjESdNQDaRMp7VDADRjwyRBaGUxKda7rYZlDZ3dRdIsHNcZWYpbHTyPmKSF45Q0
         954H9GccgFuh0Tn/zP/5cqW8/13246uPsCya7VFvIKlfQsS6OD+6hvD1jJFVPvJt+UA2
         UUV07pMOGIGQcXYAN1nU2nxn3k/FFIhRn9Qtq+DMNmW68vhMd051dPa/Plgmh0fWW1H9
         G9/SV0Qjj2Cy1YvsEh4e5wBPjAhl+Z3S6x4++Xnl8Yj5jAB8c2DzfCDcByGqmnWzFfVS
         Wr+g==
X-Gm-Message-State: AGi0PuZAHG9ktP/cRnjt9WtzOXA9fhHODP4Yx1MKnd1BAmYzm2iwKnt4
        dyvz0ACnc+BhuoYF/f9pgqpPAh5z
X-Google-Smtp-Source: APiQypKl55LcEtxGIoSKqbiZ+X3lBjfLyQs/NAtOFQXxKvHJ4wfXq0KKmocY4NwdiLwSlpFlAIqeNg==
X-Received: by 2002:aa7:9802:: with SMTP id e2mr19079877pfl.213.1589254577540;
        Mon, 11 May 2020 20:36:17 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p189sm10713587pfp.135.2020.05.11.20.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:36:16 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 10/15] net: dsa: tag_sja1105: implement
 sub-VLAN decoding
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e44ddf8c-b73b-8773-1139-975880fdbaa1@gmail.com>
Date:   Mon, 11 May 2020 20:36:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-11-olteanv@gmail.com>
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
> Create a subvlan_map as part of each port's tagger private structure.
> This keeps reverse mappings of bridge-to-dsa_8021q VLAN retagging rules.
> 
> Note that as of this patch, this piece of code is never engaged, due to
> the fact that the driver hasn't installed any retagging rule, so we'll
> always see packets with a subvlan code of 0 (untagged).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
