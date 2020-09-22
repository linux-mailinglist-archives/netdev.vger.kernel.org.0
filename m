Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B7A274D46
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgIVXXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:23:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:48016 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgIVXXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 19:23:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D7BEBAA55;
        Tue, 22 Sep 2020 23:23:54 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5923D60320; Wed, 23 Sep 2020 01:23:17 +0200 (CEST)
Date:   Wed, 23 Sep 2020 01:23:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jarod Wilson <jarod@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] bonding: rename slave to link where possible
Message-ID: <20200922232317.jlbgpsy74q6tbx3a@lion.mk-sys.cz>
References: <20200922133731.33478-1-jarod@redhat.com>
 <20200922133731.33478-3-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922133731.33478-3-jarod@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 09:37:28AM -0400, Jarod Wilson wrote:
> Getting rid of as much usage of "slave" as we can here, without breaking
> any user-facing API.
> 
> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> Cc: Veaceslav Falico <vfalico@gmail.com>
> Cc: Andy Gospodarek <andy@greyhouse.net>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Thomas Davis <tadavis@lbl.gov>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
[...]
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 1f602bcf10bd..8e2edebeb61a 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
[...]
> @@ -143,12 +143,12 @@ MODULE_PARM_DESC(mode, "Mode of operation; 0 for balance-rr, "
>  module_param(primary, charp, 0);
>  MODULE_PARM_DESC(primary, "Primary network device to use");
>  module_param(primary_reselect, charp, 0);
> -MODULE_PARM_DESC(primary_reselect, "Reselect primary slave "
> +MODULE_PARM_DESC(primary_reselect, "Reselect primary link "
>  				   "once it comes up; "
>  				   "0 for always (default), "
>  				   "1 for only if speed of primary is "
>  				   "better, "
> -				   "2 for only on active slave "
> +				   "2 for only on active link "
>  				   "failure");
>  module_param(lacp_rate, charp, 0);
>  MODULE_PARM_DESC(lacp_rate, "LACPDU tx rate to request from 802.3ad partner; "
> @@ -176,24 +176,24 @@ MODULE_PARM_DESC(arp_validate, "validate src/dst of ARP probes; "
>  module_param(arp_all_targets, charp, 0);
>  MODULE_PARM_DESC(arp_all_targets, "fail on any/all arp targets timeout; 0 for any (default), 1 for all");
>  module_param(fail_over_mac, charp, 0);
> -MODULE_PARM_DESC(fail_over_mac, "For active-backup, do not set all slaves to "
> +MODULE_PARM_DESC(fail_over_mac, "For active-backup, do not set all links to "
>  				"the same MAC; 0 for none (default), "
>  				"1 for active, 2 for follow");
> -module_param(all_slaves_active, int, 0);
> -MODULE_PARM_DESC(all_slaves_active, "Keep all frames received on an interface "
> -				     "by setting active flag for all slaves; "
> +module_param(all_links_active, int, 0);
> +MODULE_PARM_DESC(all_links_active, "Keep all frames received on an interface "
> +				     "by setting active flag for all links; "
>  				     "0 for never (default), 1 for always.");
>  module_param(resend_igmp, int, 0);
>  MODULE_PARM_DESC(resend_igmp, "Number of IGMP membership reports to send on "
>  			      "link failure");
> -module_param(packets_per_slave, int, 0);
> -MODULE_PARM_DESC(packets_per_slave, "Packets to send per slave in balance-rr "
> -				    "mode; 0 for a random slave, 1 packet per "
> -				    "slave (default), >1 packets per slave.");
> +module_param(packets_per_link, int, 0);
> +MODULE_PARM_DESC(packets_per_link, "Packets to send per link in balance-rr "
> +				    "mode; 0 for a random link, 1 packet per "
> +				    "link (default), >1 packets per link.");
>  module_param(lp_interval, uint, 0);
>  MODULE_PARM_DESC(lp_interval, "The number of seconds between instances where "
>  			      "the bonding driver sends learning packets to "
> -			      "each slaves peer switch. The default is 1.");
> +			      "each links peer switch. The default is 1.");

Even if the module parameters are deprecated and extremely inconvenient
as a mean of bonding configuration, I would say changing their names
would still count as "breaking the userspace".

Michal

