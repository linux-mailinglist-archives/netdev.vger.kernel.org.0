Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2870C1CE8A8
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 00:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgEKW7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 18:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725987AbgEKW7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 18:59:30 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19729C061A0C;
        Mon, 11 May 2020 15:59:30 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so13036272wra.7;
        Mon, 11 May 2020 15:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mjq0pbimoUm4QL423/eKvG2VO6IOscWEFedsVa9GPuM=;
        b=lHuLE2gzI57QM3q0SUyxnn4C7+YQFvWH0xvYGk53+cEjB3vryfa0z3xzffZBhkYnOC
         TV114/NZq+nJ4jbf2EaA+t6R1ro3DSUaOMWCGumX1XOozrjlIvONbhWKqcaImpDctpUI
         cKedDefER9dnGp8xPHyRs0H1Q1nKTW+t3BE3jqI7AbloFfgn6mdOkNu/YKR0hia2liPg
         xWQ2G4YDojBgyh1AzYFVGTxny4Wdy4oW2crKYzipxVncQE/3a5sNyzP2HJC09gfW92SJ
         L5cnW/QfEny/4zPCgOyB9LOEfQ56bNO+ncoHrcbv/6IMenVcnwNG/UzMGk9YXtfo5PpY
         so3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mjq0pbimoUm4QL423/eKvG2VO6IOscWEFedsVa9GPuM=;
        b=ELofeJzGyIXNkgx0M6N0UW/bxhkYGdCP/W/n4rmzC2/15fr31mmMWNFOvH8qBrEnpF
         t7j4AQ3yUG5JpLnqmLEWacf/FSkTGx6QTF7DfohIZJwD1qtr6PmH94eafGKm0tKcwejV
         8eJvSMUSHYM+Jm8/zMYNyq/hqIcQAj/AkXhloFVBTHqOMRWGmYh1JIntli1wLHnsD3l7
         1IqrNc4qstU31Yk+Ms0E3VbLXT5rRBWKQIFK3k+mcrZOHKBRJpYDmFBIyreVeIbNm5rT
         RpIjj+BoM5rF+wCCN5MvifebMN0MwLSZhxYOTc07SKTy1YbqdCbtxb7HLpKLYAPTw9bs
         WlGg==
X-Gm-Message-State: AGi0PubYnBfSypVbBGw3kNORqpxpWvVQVVWFvnIRjjXxlk/l8kwU8cqJ
        qhRai3Xl07lf+gtcLl4nZ9WJ2Djo
X-Google-Smtp-Source: APiQypL8NbOEQz++69SSmmDvBtk7c0K7HZoDLCMwsz8/w5JFcTKMmdffQytoRTwo1a9y5e42ROO6sg==
X-Received: by 2002:a5d:5686:: with SMTP id f6mr21882805wrv.168.1589237968634;
        Mon, 11 May 2020 15:59:28 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12sm8904375wrq.82.2020.05.11.15.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 15:59:28 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 02/15] net: dsa: tag_8021q: introduce a
 vid_is_dsa_8021q helper
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4905cf9e-b4ef-64d3-e5d9-7fe42e3775c3@gmail.com>
Date:   Mon, 11 May 2020 15:59:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-3-olteanv@gmail.com>
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
> This function returns a boolean denoting whether the VLAN passed as
> argument is part of the 1024-3071 range that the dsa_8021q tagging
> scheme uses.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
