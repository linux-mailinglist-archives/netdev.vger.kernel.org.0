Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA8826092C
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIHEBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgIHEBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 00:01:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD8482087D;
        Tue,  8 Sep 2020 04:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599537684;
        bh=GqCayTmWwyDfWtRsKK1nlSzta0dDcdLkOkfevyt74oI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U/yQPy/9gSq7qXayTS+MBRnguMSq2lARYoUEROrOhSGGjihrubGcNgiEChRYQ5gqT
         EDiFYBXpOWpH1FD1JUXbR+cWhwKgOaA0koJLHUL5FU6Y0k9Jm8hWiwUPQyL9h8rBk9
         I8aR40S5qek6lxEQAIr3iCOJHXUIViKUPRLluHCw=
Date:   Mon, 7 Sep 2020 21:01:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: change PHY error message again
Message-ID: <20200907210122.0bd7a11e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907230656.1666974-1-olteanv@gmail.com>
References: <20200907230656.1666974-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 02:06:56 +0300 Vladimir Oltean wrote:
> slave_dev->name is only populated at this stage if it was specified
> through a label in the device tree. However that is not mandatory.
> When it isn't, the error message looks like this:
> 
> [    5.037057] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.044672] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.052275] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> [    5.059877] fsl_enetc 0000:00:00.2 eth2: error -19 setting up slave PHY for eth%d
> 
> which is especially confusing since the error gets printed on behalf of
> the DSA master (fsl_enetc in this case).
> 
> Printing an error message that contains a valid reference to the DSA
> port's name is difficult at this point in the initialization stage, so
> at least we should print some info that is more reliable, even if less
> user-friendly. That may be the driver name and the hardware port index.
> 
> After this change, the error is printed as:
> 
> [    6.051587] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 0
> [    6.061192] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 1
> [    6.070765] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 2
> [    6.080324] mscc_felix 0000:00:00.5: error -19 setting up PHY for tree 0, switch 0, port 3
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied.
