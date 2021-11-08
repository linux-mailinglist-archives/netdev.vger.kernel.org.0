Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329C2449A62
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239317AbhKHRFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:43806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239264AbhKHRFs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:05:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86768613B3;
        Mon,  8 Nov 2021 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636390984;
        bh=zrbTUgiWFKy9WRGguNicvKrCsEpNnvi38XByEj5zrtU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SysNDm5qCXqdETv6f2JC/bFWsduWWi4GhtvZ0A099MvfewzJyiHEVG5nsZtOET2yq
         MtnxXIznzjxDIVa4tielj+253FglFOZmBdRPo1zqOpTDymwoDM+JbfmTmJaOyY6Ckg
         IhMbvuBygwHjyCAkdyDMnZGVut2w3tCuwPlUbhuFw46NGUxMaUspLdJCzEgm+EcMcl
         7SPZqtLi0KDP284EDx4ZtCV4v6T/T9svRsRKhyFe1DJm3qX/06OuFbjy8HwsgZP6fW
         JPseQKFyAQ4jWBpn8HS7luxOTt27UKGuK/xykslkhAmr5lKA6UAXXZcTWLoM84AXF9
         BYnhpT6IS8GKA==
Date:   Mon, 8 Nov 2021 09:03:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Message-ID: <20211108090302.64ca86a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYlQfm3eW/jRS4Ra@shredder>
References: <20211105205331.2024623-1-maciej.machnikowski@intel.com>
        <20211105205331.2024623-7-maciej.machnikowski@intel.com>
        <YYfd7DCFFtj/x+zQ@shredder>
        <MW5PR11MB58120F585A5CF1BCA1E7E958EA919@MW5PR11MB5812.namprd11.prod.outlook.com>
        <YYlQfm3eW/jRS4Ra@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 18:29:50 +0200 Ido Schimmel wrote:
> I also want to re-iterate my dissatisfaction with the interface being
> netdev-centric. By modelling the EEC as a standalone object we will be
> able to extend it to set the source of the EEC to something other than a
> netdev in the future. If we don't do it now, we will end up with two
> ways to report the source of the EEC (i.e., EEC_SRC_PORT and something
> else).
> 
> Other advantages of modelling the EEC as a separate object include the
> ability for user space to determine the mapping between netdevs and EECs
> (currently impossible) and reporting additional EEC attributes such as
> SyncE clockIdentity and default SSM code. There is really no reason to
> report all of this identical information via multiple netdevs.

Indeed, I feel convinced. I believe the OCP timing card will benefit
from such API as well. I pinged Jonathan if he doesn't have cycles 
I'll do the typing.

What do you have in mind for driver abstracting away pin selection?
For a standalone clock fed PPS signal from a backplate this will be
impossible, so we may need some middle way.
