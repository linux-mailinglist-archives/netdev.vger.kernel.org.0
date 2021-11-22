Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24417459315
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbhKVQe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240250AbhKVQew (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 11:34:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F6460F5B;
        Mon, 22 Nov 2021 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637598705;
        bh=ic8gKA36IMsoJ6BJiADBmlFVE7jaTkQK5Flnj9qq/gQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e2lxcam4X+3MWVHJ6sX4rnd5SRciP/e5NTTqZcrt0vRL5YW6F4r7Q1bvUKmJGQ4Zk
         Eujvk/h0j+gnHh7Z0zSSTjvSA15cE3HsicGvMOGXLB/X+SGGaX+8b3gL0UvrIWTAIW
         yaoWpDS+dmMYHKCvIEfAguLhfSHpzowaWBL/g6v0XBv8xBJ5s7hznoEJerGnaGO5rO
         1ii3rEPs8MZdAwHsct7gXvUha68B890dwgNHQz8CKY5JVwS7pnHNFLXx6phMPq2VxE
         Laec6HnCtyBOQ45XKVaFvoy+6hkC9Y6eGVYCPsKtwCbADPQ/NDVEQr2CRCvQy/obtD
         it3Q1xn4D+XRw==
Date:   Mon, 22 Nov 2021 08:31:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net v2] net: avoid registering new queue objects after
 device unregistration
Message-ID: <20211122083144.7d15a6ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211122162007.303623-1-atenart@kernel.org>
References: <20211122162007.303623-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 17:20:07 +0100 Antoine Tenart wrote:
>    veth_set_channels+0x1c3/0x550
>    ethnl_set_channels+0x524/0x610

The patch looks fine, but ethtool calls should not happen after
unregister IMHO. Too many drivers would be surprised. 

Maybe we should catch unregistered devices in ethnl_ops_begin()?
