Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC6F22BE
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 00:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732713AbfKFXiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 18:38:52 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46369 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbfKFXiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 18:38:52 -0500
Received: by mail-yb1-f193.google.com with SMTP id g17so211247ybd.13
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 15:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NXCGiVKTXXEjzDxDKPWm4qRbQINthtPG/DF3mE8dX04=;
        b=kxCPnkllRFkeV9ZKT0vPLK4zwrVw+ZIGPflI0u5vk0j5pV5zLWHRpkAzf35kkz/5XC
         RIlII4oE7WfBPgvN2mVCbQYEo9K5fyHa0b87urxXjOe1LqWcNYx1mQ+M1OENSM6qPNc1
         KKlDhCAKesadT+zSpoL5FMzs/ZDI2z/yuaG4z8Lh7st3mJDDhqDucU7bYyX8r6Tx8tTv
         IvWbK17y0NFyGnmfQKAGivMO8CFlccpSFp0KyWcXwip0cWszVzs5oguhC41DP9kdj+vc
         uzSbWQgVizDX0lT+3W8BRm8iLDVZd530GuZg1sYszeXs4yPAj/n7rNX/rkb6bP6sTFt1
         SRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NXCGiVKTXXEjzDxDKPWm4qRbQINthtPG/DF3mE8dX04=;
        b=sK191rnJa3lcWkm5EwW4z5dV+1F0omyLLysy4KBS4WEHSAPKZIcR6uKgOfk3WpLzKu
         NxQcFndt70Q3t3FmOLZsJ7qqbISRC2rS3PUebiGuXrlByu4fUWeQhMP3EAbtkegMOh51
         o4kVJLwsPbnykNBGl4tPOkHrLt0dumzKWjGGr0peSG3nAGI/bcJryP7YkhCSrmyI+7Qv
         g2SwXOHSYKeWgH+lr0fvITaNDcUqhjjy+elrl/6WGlvpMvQCChLzlHg0AXb9JziT8VEm
         IF/5sqtHakxfppZferefuAAYw7kXiVtoyGuyMHbo4zjpk20I6JEtk4JRTsJgN0Uws15d
         RAOw==
X-Gm-Message-State: APjAAAUODjaUfwkU7xbqM2ph1AydnVxLVbrWag140Tly8jlI6DWlzhyj
        WsLZLqUpGfTwHWWzRuj29NvhvQ==
X-Google-Smtp-Source: APXvYqym0i0romvCrdOaz7lsINZQYcGiuzpul4r2zM7EYgZuhgx34Vaj0wOMFqNyMeyL778+8rXK9g==
X-Received: by 2002:a25:af05:: with SMTP id a5mr633074ybh.155.1573083531576;
        Wed, 06 Nov 2019 15:38:51 -0800 (PST)
Received: from cakuba.netronome.com ([64.63.152.34])
        by smtp.gmail.com with ESMTPSA id z127sm194842ywb.38.2019.11.06.15.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 15:38:51 -0800 (PST)
Date:   Wed, 6 Nov 2019 18:38:48 -0500
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 1/5] rtnetlink: allow RTM_SETLINK to reference other
 namespaces
Message-ID: <20191106183848.3b914620@cakuba.netronome.com>
In-Reply-To: <20191106053923.10414-2-jonas@norrbonn.se>
References: <20191106053923.10414-1-jonas@norrbonn.se>
        <20191106053923.10414-2-jonas@norrbonn.se>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Nov 2019 06:39:19 +0100, Jonas Bonn wrote:
> +	if (tb[IFLA_TARGET_NETNSID]) {
> +		int32_t netnsid = nla_get_s32(tb[IFLA_TARGET_NETNSID]);
> +		tgt_net = rtnl_get_net_ns_capable(NETLINK_CB(skb).sk, netnsid);

No comments on merits but you should definitely run this through
checkpatch..
