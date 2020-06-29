Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B1420E8ED
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgF2WxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 18:53:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgF2WxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 18:53:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10B6C20702;
        Mon, 29 Jun 2020 22:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593471201;
        bh=WbA/SNaYeTh2fFHa9pU20MEVkKItVBLliJKQM2xPInE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1gV8QcYBHRpN6X2vkhaowd8s3R9vJ3jRXHpE6iOs+XJ/Vo/vq35nLhTIatyr0EMZ6
         kgtOM+rKHZs2ZtLkVJdHp8Ws964E+XQr5sBE8LClzj7ez++tW2HvOR6CqE0ukt3PV4
         WC8uKUL7HO3GUtHYO7DEDFx6bEnP8V0AjTDxlaNo=
Date:   Mon, 29 Jun 2020 15:53:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next 0/3] cxgb4: add mirror action support for
 TC-MATCHALL
Message-ID: <20200629155319.5fc32092@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200627064405.GA24993@chelsio.com>
References: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
        <20200625155510.01e3c1c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200626100614.GA23240@chelsio.com>
        <20200626095549.1dc4da9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200626205011.GA24127@chelsio.com>
        <20200626211750.66cd6d6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200627064405.GA24993@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 27 Jun 2020 12:14:07 +0530 Rahul Lakkireddy wrote:
> > What's the main use case for this feature? It appears that you're
> > allocating queues in patch 2. At the same time I don't see SWITCHDEV
> > mode / representors in this driver. So the use case is to redirect a
> > packet out to another port while still receiving a copy?  
> 
> The main use case is to sniff packets that are being switched out
> by hardware. The requirement is that there would be higher priority
> flower rules that will accept specific traffic and all the other
> traffic will be switched out on one of the underlying ports.
> Occasionally, we want to sniff the packets that are being switched
> out by replacing the redirect action with mirror action.
> 
> The reason for allocating queues is that the VIs are isolated from
> each other and can't access each other's queues. So, separate queues
> must be allocated for mirror VI.

Sounds reasonable, please fix the use of refcount_t (perhaps just use 
a normal integer since structures are protected), and repost.
