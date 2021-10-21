Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D54436254
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhJUNH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhJUNH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 09:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C0FD60F6E;
        Thu, 21 Oct 2021 13:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634821511;
        bh=t/8qabPBNvjn1ixPBs/tBRYFKvKAXx6Bpv9UbxtYlKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KLoJXdvEu8upd9SH5EvZYtldJJ0MRs0tWFWj+zjlBQbA2t70DwEWEp3kCDq3KkGFu
         OgyqbRIayl+z2fFmgMMTLOHWY4G1VG09K9/ycZC7o5xYs+fLHcGUs1vkVWG6WPTCF8
         FITLdk7QzhbWEVLBljxcEL+RcHXkmgseC3f6Ey+vtzYJ1hKrUeaSAUtP5o3mxXzcce
         IcmFnr74yU1BW95pu0QjsYKzW6w2a1Zodu3ZwlsakvERUwwiXuyaTskXAjSzAMDVl0
         DyWdITQMwMdv033k4EEOJGEkoKsqlLLzcdGtPv/C1NKIH7Nf9hJA3A3+PFII1rIZ4W
         UBTzIs9FLfLoQ==
Date:   Thu, 21 Oct 2021 06:05:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] net: s390: constify and use
 eth_hw_addr_set()
Message-ID: <20211021060508.44358d5a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a028714d-6e69-dc7b-1b94-d946a7ecc942@linux.ibm.com>
References: <20211020155617.1721694-1-kuba@kernel.org>
        <20211020155617.1721694-10-kuba@kernel.org>
        <a028714d-6e69-dc7b-1b94-d946a7ecc942@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 00:30:23 +0200 Julian Wiedmann wrote:
> On 20.10.21 17:56, Jakub Kicinski wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it got through appropriate helpers.
> > 
> > Make sure local references to netdev->dev_addr are constant.
> >   
> 
> Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
> 
> Thanks Jakub. I suppose at some point __dev_addr_set() will then
> become more than just a memcpy, correct?

Yup, once all places are converted it will also adjust the position of
the address on the tree.
