Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8313C25818E
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 21:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgHaTHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 15:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727993AbgHaTHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 15:07:35 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C1BE20866;
        Mon, 31 Aug 2020 19:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598900854;
        bh=vYQaPJXDET3eR9Juw3Nj+7VtleZCq8eRb/3gOFUqdxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uQDm4Bk371TYGZ6NA5xkLpL/nfpn/tcsNuqsQ2vmV9UHbOYIgWlpohglNf6ljIqnj
         lbMxhJLmNCacigqv5YdVnY9qBVn16YmmN4JjRvHzuEAzYE1cpbiOJbgFrCF7MkAczR
         yidx1xdU581yUSD8mmbOyaVmjZ+u37TFq1gT6SdA=
Date:   Mon, 31 Aug 2020 12:07:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.vnet.ibm.com,
        sukadev@linux.vnet.ibm.com, ljp@linux.vnet.ibm.com,
        cforno12@linux.ibm.com
Subject: Re: [PATCH net-next 2/5] ibmvnic: Include documentation for ibmvnic
 sysfs files
Message-ID: <20200831120732.2fa09746@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1598893093-14280-3-git-send-email-tlfalcon@linux.ibm.com>
References: <1598893093-14280-1-git-send-email-tlfalcon@linux.ibm.com>
        <1598893093-14280-3-git-send-email-tlfalcon@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Aug 2020 11:58:10 -0500 Thomas Falcon wrote:
> Include documentation for existing ibmvnic sysfs files,
> currently only for "failover," which is used to swap
> the active hardware port to a backup port in redundant
> backing hardware or failover configurations.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ibmvnic | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-ibmvnic
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ibmvnic b/Documentation/ABI/testing/sysfs-driver-ibmvnic
> new file mode 100644
> index 0000000..7fa2920
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-ibmvnic
> @@ -0,0 +1,14 @@
> +What:		/sys/devices/vio/<our device>/failover
> +Date:		June 2017
> +KernelVersion:	4.13
> +Contact:	linuxppc-dev@lists.ozlabs.org
> +Description:	If the ibmvnic device has been configured with redundant
> +		physical NIC ports, the user may write "1" to the failover
> +		file to trigger a device failover, which will reset the
> +		ibmvnic device and swap to a backup physical port. If no
> +		redundant physical port has been configured for the device,
> +		the device will not reset and -EINVAL is returned. If anything
> +		other than "1" is written to the file, -EINVAL will also be
> +		returned.
> +Users:		Any users of the ibmvnic driver which use redundant hardware
> +		configurations.

Could you elaborate what the failover thing is? Is it what net_failover
does or something opposite? (you say "backup physical port" which
sounds like physical port is a backup.. perhaps some IBM nomenclature
there worth clarifying?)
