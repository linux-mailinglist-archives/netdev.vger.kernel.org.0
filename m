Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 270172DF0BB
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 18:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgLSRn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 12:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgLSRnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 12:43:55 -0500
Date:   Sat, 19 Dec 2020 09:43:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608399795;
        bh=VEOiMPwYCrLobBbh+ETaBDQMPWSJeemnBGmjOj3E4ao=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jUZ4vp8bW/7LrAcMxChaGic+R7zP1XMhSQTQP0vErycCg29pHhZVMsRwNhCLMbc1N
         s5mO+EUQlnk/JzmTw7DDOBdQ0Mu7IpxEj+t7j/ABWAanjMkD2WxXQs777iw2bP7KyE
         CK842cR4QGz4HPbjlmIpr6nwQJC7xCdGmdFtQkUjeAhaae9UTDBpRECWt8dZJkKXrU
         AVbzUUqzIlEm4YAf/vWoauQTxXpHHuCkYB3/g2aTb+yB4IJZnP0TgJsXbwniVeufXN
         TRG9n2i0op2kOhVe2tKj84YPfiwWOCsamU6MZDJgG2O+H0Q1dC3s9K1XY1v923aie3
         1duWr+Z8DXIMQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 07/15] net/mlx5: SF, Add auxiliary device support
Message-ID: <20201219094313.27c3d383@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB4322A0E514FD1B4FDCAB0735DCC20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-8-saeed@kernel.org>
        <20201215164341.51fa3a0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322B0DC403D8B5CEFD95585DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201216161154.69e367fe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322009AFF1E26F8BEF72C72DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201218115834.0f710e0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322A0E514FD1B4FDCAB0735DCC20@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Dec 2020 04:53:45 +0000 Parav Pandit wrote:
> > Why can't the SF ID match aux dev ID?   
> Auxiliary bus holds the SFs of multiple PFs.

I see it now. Very unfortunate :(

> SF ID can be same for SFs from multiple PFs. Encoding PCI address in SF auxiliary device name doesn't do good.
> So SF ID attribute of device is more appropriate.

