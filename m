Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC6932FC8C
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 20:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhCFTES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 14:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:34846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231215AbhCFTDw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Mar 2021 14:03:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3072064FE2;
        Sat,  6 Mar 2021 19:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615057432;
        bh=JRtZ/TFBXzkK441kvDgVCYr+nOIEuplebT+5LmNhL+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M/tqtZLCOY2K9aDiV+xcCBp0qT0j3Skg+nCh9Vrt5jxHnqa1c/SFrwWbf+nJXxOfe
         NkoMTUhwAh+jG08tB/M/O0j9eqYdYEicAjPw+4SKt2vJSoLkYyQlxit4FQWtr60BxB
         x1Iu7ZkPh7m2DlaXqPZWcTH32HeCoDg/mc60M0N66ejSjP8vZCr1yrIrf7cJpeDaJV
         bZvg1EstbQ6g5NxdnbWnhKYN21rdvJWozIRakO6ns3b/eG9deyHB8LUTiiPsXwzNt6
         fi5cO6llEHD4cKhnl2EgDslbFnhh59HECQTxCk40MZhia0qOnnE8mLN4ryWe2VL3XN
         HkxJbDPIv4Hmg==
Date:   Sat, 6 Mar 2021 11:03:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com
Subject: Re: [RFC] devlink: health: add remediation type
Message-ID: <20210306110351.1d04f344@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YEOWK7HtiRz09XZm@lunn.ch>
References: <20210306024220.251721-1-kuba@kernel.org>
        <YEOWK7HtiRz09XZm@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Mar 2021 15:48:11 +0100 Andrew Lunn wrote:
> +/**
> > + * enum devlink_health_reporter_remedy - severity of remediation procedure
> > + * @DLH_REMEDY_NONE: transient error, no remediation required
> > + * @DLH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
> > + *			will be reset
> > + * @DLH_REMEDY_RESET: full device reset, will result in temporary unavailability
> > + *			of the device, device configuration should not be lost
> > + * @DLH_REMEDY_REINIT: device will be reinitialized and configuration lost
> > + * @DLH_REMEDY_POWER_CYCLE: device requires a power cycle to recover
> > + * @DLH_REMEDY_REIMAGE: device needs to be reflashed
> > + * @DLH_REMEDY_BAD_PART: indication of failing hardware, device needs to be
> > + *			replaced
> > + *
> > + * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
> > + * by the severity of the required remediation, and indicates the remediation
> > + * type to the user if it can't be applied automatically (e.g. "reimage").
> > + */
> > +enum devlink_health_reporter_remedy {
> > +	DLH_REMEDY_NONE = 1,
> > +	DLH_REMEDY_COMP_RESET,
> > +	DLH_REMEDY_RESET,
> > +	DLH_REMEDY_REINIT,
> > +	DLH_REMEDY_POWER_CYCLE,
> > +	DLH_REMEDY_REIMAGE,
> > +	DLH_REMEDY_BAD_PART,
> > +};  
> 
> Hi Jakub
> 
> Are there any cases where the host is the problem, not the device? The
> host driver needs to be unloaded and reloaded? The host needs a
> reboot?

I was thinking of REINIT addressing that case. Maybe RELOAD would 
be a better name since that's what the devlink command is called?
But also to answer your direct question, I haven't seen such case 
in practice, I don't think, just trying to cover all the bases.
