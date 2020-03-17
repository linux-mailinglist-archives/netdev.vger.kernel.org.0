Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1156B188C4E
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCQRky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgCQRky (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 13:40:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 568832073E;
        Tue, 17 Mar 2020 17:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584466853;
        bh=KUHj/fuUeemlpkuOI07XUbnahmn3yc+vookLyNg2itc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dYZcAk8MGX3UZAUztXpcwat6pEnW66tfcvRX7MzfZtyGwKDKgJZIAw52z7qD7ZUdR
         3Efspf6nK2B2SRLc6hTYhk9N5p5WScZZk0FlpYCkSDQeI8MMxD2I8d1J4Y2jBmvVai
         54jAys+iGmVn1CRAseatEqMRlrzNxNQ+tVt1UAwk=
Date:   Tue, 17 Mar 2020 10:40:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
Message-ID: <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
        <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 20:44:38 +0530 Vasundhara Volam wrote:
> Add definition and documentation for the new generic info "drv.spec".
> "drv.spec" specifies the version of the software interfaces between
> driver and firmware.
> 
> Cc: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  Documentation/networking/devlink/devlink-info.rst | 6 ++++++
>  include/net/devlink.h                             | 3 +++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
> index 70981dd..0765a48 100644
> --- a/Documentation/networking/devlink/devlink-info.rst
> +++ b/Documentation/networking/devlink/devlink-info.rst
> @@ -59,6 +59,12 @@ board.manufacture
>  
>  An identifier of the company or the facility which produced the part.
>  
> +drv.spec
> +--------
> +
> +Firmware interface specification version of the software interfaces between

Why did you call this "drv" if the first sentence of the description
says it's a property of the firmware?

Upcoming Intel patches call this "fw.mgmt.api". Please use that name,
it makes far more sense.

> +driver and firmware. This tag displays spec version implemented by driver.
> +
>  fw
>  --
>  
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index c9ca86b..9c4d889 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -476,6 +476,9 @@ enum devlink_param_generic_id {
>  /* Revision of asic design */
>  #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV	"asic.rev"
>  
> +/* FW interface specification version implemented by driver */
> +#define DEVLINK_INFO_VERSION_GENERIC_DRV_SPEC	"drv.spec"
> +
>  /* Overall FW version */
>  #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
>  /* Control processor FW version */

