Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE6D339DF1
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhCMLrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:47:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhCMLqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:46:51 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042D6C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:46:50 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id h10so11612148edt.13
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mCh3xsV/ugrQNa1kP7seFNBisOBj0HrMHmT/wwYE6Ro=;
        b=j+QC0PcJvnMRdIEvxTAlzYIXlQv+Hs4U97JcbWp+MtY+d0P2uhIHvNi+hBfs+zZ0JK
         m6foRVghq9zBz+jr72lYvIggZgLdTd1pj4ehVn2Xp7d64WeTRWNwSwkKjN9wV+j++wKl
         57uG+W8L8yym30caUjMGtcq8rT5wLm93Qy16+EYzCbYFYlZrhwJ4ckMbzzYiLIwHxGo5
         eqiY/nMCvRU1Yd53oQW3G75abTpNpvEXwmVfo3kynY8Y/1RpefP0oiMRmsg/oTKpKuoG
         ZwIE41awzx3xr513fRhgccfqrGyDzmHglR41egpjJl1MIpv7h+xkrULh5s50e2B7K1FA
         6BPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mCh3xsV/ugrQNa1kP7seFNBisOBj0HrMHmT/wwYE6Ro=;
        b=Ez5vZWG1Yn0G0LDcFUXN+PsDcRYzj6j1S5b67yRo8BNOmT5Pi7j/TV0u4WYUMFF2mA
         Vpak20CMmPzi41dAXAe1ZJTqNoIys0k2Ak46rkUodj+8UlWTFuXIxJj2svNxElZhablk
         U6Dzet9ZK4T0M7F7MKqryncow9sKYpfhgTqSNOrAJzXn40uRU9MR2TgKwSk3p5lKcFbA
         mZzjMtzrZfsil0zNysT64xQcE51BMKXbRrJQgfFeMzS4u7awyrsHqzG71J1aWQWNziuS
         I8sxSoEyZ0gXAK6iA4Y2gTdLnWGjQIaW2QPIPTt3kfp7uS2L4QeoCDJ5AD8sGdA/L74X
         pwBA==
X-Gm-Message-State: AOAM533MNUyWfzkyqxUPhqrEDxU0KVpmw5ajxAnJudMQuHCpV4byPj/d
        1IWlRuj6gt9HrOpISwSZoSQ=
X-Google-Smtp-Source: ABdhPJxKTr0bCyI6Db5r/paQ6rolvTOuP2qZWHlUN1RUSRhtcjPMG9mJRrPEMkNWOyFMuVgsfg8h6g==
X-Received: by 2002:aa7:c7da:: with SMTP id o26mr2283755eds.244.1615636009026;
        Sat, 13 Mar 2021 03:46:49 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id bj7sm4220965ejb.28.2021.03.13.03.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 03:46:48 -0800 (PST)
Date:   Sat, 13 Mar 2021 13:46:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: dsa: hellcreek: Add devlink FDB
 region
Message-ID: <20210313114647.4njhja3qsquu225q@skbuf>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-5-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313093939.15179-5-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 10:39:39AM +0100, Kurt Kanzenbach wrote:
> Allow to dump the FDB table via devlink. This is a useful debugging feature.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

By the way, what user space program do you use to dump these? Did you
derive something from Andrew's mv88e6xxx_dump too? Maybe we should work
on something common?
