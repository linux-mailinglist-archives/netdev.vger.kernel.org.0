Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1F2F85C7
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388268AbhAOTyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbhAOTyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:54:50 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D2BC0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 11:54:10 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id g12so14974777ejf.8
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 11:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6PPG6lXGZN+21fwcww0RDWdMIJ8BX6ET/3DqRAj9jcQ=;
        b=iMwmbJErDWv/43Pm+8zfn0CqKUfGfFi+ZlidCCnAtuA4gufO1X7YcbUQwaXM0d9jtj
         lDN5QK/wGmtVhNfF3VEYHoAKxluW9ZZ26MENdT5Yiv5bMCri/eu2UjBDnzS554oBovGD
         I4kCxC2tvQNgUbUEOppi+jRra1QXD/YgOx+sWCl4qvBrPDUD9r7r8yl5vtCRxC9poetY
         cHCp485sdcdwBknWaKenyniDZK/MY4yLxYdnXeIE/6/kJK3bAbZA6Z3rkUyonlDtOi19
         mXIfATaC0nxoXDMNnoSJU4d5dfC0s1LSHJMQ3UKkUIIsFEZ0jt3EF1LboopCYAcVmKmN
         WJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6PPG6lXGZN+21fwcww0RDWdMIJ8BX6ET/3DqRAj9jcQ=;
        b=kr8u+WPuFNMf/X3EqxAIa9xoTzUCuhUhwsXpTdp9n8HsnCjnvtrAg7QQt8hSlsbs3a
         3Wk99ufVcN0+xTUBAaKRCxL+orUgUe7SRIanOlgAqZ8SdCjuUMDhsTGNacNk6UFvuqGt
         e3WTfAE10I0hgdh+LoxiLpepaNYFqraa2WMaq4pZn2QCu/1OewWouS4VBnqUaRUkSVv2
         CN5LPQFM7vt7DvgrT9LAeBrZ17UoAQS7/zpjFe1gffniXyPVLi6uJFok8pDF+C2hdwN4
         a97GLlcwQitJpt3Dk52nytBVR2hwUsl5ELqKHYVQ4J2pzK2nfoPQANPt3BAOnYlxFbYZ
         PkmA==
X-Gm-Message-State: AOAM5338g+qD2jgsfY6j1EIfRfv2NLdcxw8uisVcWLi8Kr8Jo4xaZGY5
        XL8nZMJIBuErrMjSEcZyF6Y=
X-Google-Smtp-Source: ABdhPJzJk9CiGP4IcOYFt9cA5NThV0L8v1JIXYG3a2xOnsU4xg4SMmj4NGkRBj4b4jq+5axmEfo1IQ==
X-Received: by 2002:a17:907:c01:: with SMTP id ga1mr9740624ejc.488.1610740449111;
        Fri, 15 Jan 2021 11:54:09 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u26sm4685548edo.37.2021.01.15.11.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 11:54:08 -0800 (PST)
Date:   Fri, 15 Jan 2021 21:54:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: Renaming interfaces that are up (Was "Re: [PATCH v3 net-next
 08/10] net: mscc: ocelot: register devlink") ports
Message-ID: <20210115195407.2flujwhhm24y6tty@skbuf>
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-9-olteanv@gmail.com>
 <20210109174439.404713f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210111171344.j6chsp5djr5t5ykk@skbuf>
 <20210111111909.4cf0174f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114103405.yizjfsk4idzgnpot@skbuf>
 <20210114084435.094c260a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210115171142.4iylui5uuv5vljwq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115171142.4iylui5uuv5vljwq@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 07:11:42PM +0200, Vladimir Oltean wrote:
> By the way I removed the if condition and added nothing in its place,
> just to see what would happen. I see a lot of these messages, I did not
> investigate where they are coming from and why they are emitted. They go
> away when I rename the interface back to swp0.

Looks like it's again related to dhcpcd. If I rename the interface while
it's down, the link-local IPv6 addresses don't get endlessly deleted as
they do if I rename it while it's up. Also, if I live-rename the interface
while dhcpcd isn't up, that behavior disappears too.

Still not sure why it happens.
