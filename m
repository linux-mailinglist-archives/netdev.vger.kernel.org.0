Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A842B47321E
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhLMQo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhLMQo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:44:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D07C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 08:44:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4149861188
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 16:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC78C34603;
        Mon, 13 Dec 2021 16:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639413866;
        bh=Uzjjlm7Df7+4mUhVfz+tq5QCKvHI/nPplkrGGmZRMNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UrLVeNAZjskXLjGiEYiHxJ6ON3t2xug0gyzeJs+ByQQmtGf8GnZHWmIGKCz09zOjh
         l/GxWo6CMq+1vZo+brR+DEmGue1UXqzN43hiVRfJqG4qVwuUdZYaOM22BQH4x3EJf8
         b2yA46QCbpX+JyLM9/s9z5Euen0dmdmloFVZKJT8xYy5DSnTfPVgMKUrixSCXI39i5
         oU5ERzrz0OxE/MOMRpnf2lXYYRwOTbh0xhV0k2+y0JRjipNZgF1ipE71fSmQ0uTLr4
         uPl+5ymkHuMW32wITKfnaGGDafawf1m4TrX6z1crcap76r5QpkyJtZWcweDFwfJmkl
         ho855QB2ZMv/w==
Date:   Mon, 13 Dec 2021 08:44:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <20211213084425.65951354@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211213121045.GA14042@hoboy.vegasvil.org>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
        <87y24t1fvk.fsf@waldekranz.com>
        <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211211153926.GA3357@hoboy.vegasvil.org>
        <20211213121045.GA14042@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 04:10:45 -0800 Richard Cochran wrote:
> I looked at 1588 again, and for E2E TC it states, "All PTP version 2
> messages shall be forwarded according to the addressing rules of the
> network."  I suppose that includes the STP state.
> 
> For P2P TC, there is an exception that the peer delay messages are not
> forwarded.  These are generated and consumed by the switch.

Indeed, looks like a v1 vs v2 change :S
