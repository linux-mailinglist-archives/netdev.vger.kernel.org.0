Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458302702A5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgIRQye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:54:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgIRQyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 12:54:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 210E920872;
        Fri, 18 Sep 2020 16:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600448073;
        bh=2S1Zxw7pNlv6x7eNjA+EDgL0rOxHZ/yTpGLU4mbFwag=;
        h=Date:From:To:Subject:In-Reply-To:References:From;
        b=SNjHHZgkYVnyLmkKpAtZIquct+oZNTqjcerlo3ZSzj/zkY0YjIrdZtZ6vkf3oLMZu
         q08Fd6OiO9YPlVQpA2k/gPqBAkR7z0ZK6IrMO7e6SZzF8h1D3vPmQgwRZdJWGPLM4J
         al7NJQLrguKA3i8NSnGNNl4P/ZpuT6/pgE5OjtXg=
Date:   Fri, 18 Sep 2020 09:54:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: [net-next v6 3/5] devlink: introduce flash update overwrite
 mask
Message-ID: <20200918095431.745f1d67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200918004529.533989-4-jacob.e.keller@intel.com>
References: <20200918004529.533989-1-jacob.e.keller@intel.com>
        <20200918004529.533989-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 17:45:27 -0700 Jacob Keller wrote:
> Sections of device flash may contain settings or device identifying
> information. When performing a flash update, it is generally expected
> that these settings and identifiers are not overwritten.
> 
> However, it may sometimes be useful to allow overwriting these fields
> when performing a flash update. Some examples include, 1) customizing
> the initial device config on first programming, such as overwriting
> default device identifying information, or 2) reverting a device
> configuration to known good state provided in the new firmware image, or
> 3) in case it is suspected that current firmware logic for managing the
> preservation of fields during an update is broken.
> 
> Although some devices are able to completely separate these types of
> settings and fields into separate components, this is not true for all
> hardware.
> 
> To support controlling this behavior, a new
> DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK is defined. This is an
> nla_bitfield32 which will define what subset of fields in a component
> should be overwritten during an update.
> 
> If no bits are specified, or of the overwrite mask is not provided, then
> an update should not overwrite anything, and should maintain the
> settings and identifiers as they are in the previous image.
> 
> If the overwrite mask has the DEVLINK_FLASH_OVERWRITE_SETTINGS bit set,
> then the device should be configured to overwrite any of the settings in
> the requested component with settings found in the provided image.
> 
> Similarly, if the DEVLINK_FLASH_OVERWRITE_IDENTIFIERS bit is set, the
> device should be configured to overwrite any device identifiers in the
> requested component with the identifiers from the image.
> 
> Multiple overwrite modes may be combined to indicate that a combination
> of the set of fields that should be overwritten.
> 
> Drivers which support the new overwrite mask must set the
> DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK in the
> supported_flash_update_params field of their devlink_ops.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
