Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41EB2218B3
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 02:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGPAGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 20:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGPAGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 20:06:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FF7F20658;
        Thu, 16 Jul 2020 00:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594857994;
        bh=MFjfF4+oC01Y6bevI5egaBIFd+jsLP2iZgwBUEXBvUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VCtcqMJ0mmk+6vtldiSJQI/Ly9QMRV4sbHd2H08V5f55nY1rAGU3ucDyg97eRf7ou
         a6kw5sZF8kKZ7qSZOnlyw35KSmMccKI9MfSGTqMbuKMC0PNitazT71aiATqGdpg4I6
         XpaPKlhq+/651/Z2H19X+avmKufsYyfBjtoU+viw=
Date:   Wed, 15 Jul 2020 17:06:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        drt@linux.ibm.com
Subject: Re: [PATCH net-next] ibmvnic: Increase driver logging
Message-ID: <20200715170632.11f0bf19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594857115-22380-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1594857115-22380-1-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jul 2020 18:51:55 -0500 Thomas Falcon wrote:
>  	free_netdev(netdev);
>  	dev_set_drvdata(&dev->dev, NULL);
> +	netdev_info(netdev, "VNIC client device has been successfully removed.\n");

A step too far, perhaps.

In general this patch looks a little questionable IMHO, this amount of
logging output is not commonly seen in drivers. All the the info
messages are just static text, not even carrying any extra information.
In an era of ftrace, and bpftrace, do we really need this?
