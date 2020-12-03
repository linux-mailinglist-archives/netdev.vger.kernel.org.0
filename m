Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADECE2CDFBA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgLCUcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 15:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgLCUcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:32:19 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383C3C061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 12:31:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=nHVjEpvs2Fmri4JAoPC81IEWZvNDuQdE/fAgnxZ1jX0=; b=l8z1Q/2Qnjli7kUqhmvYWFqXNs
        5KYce8jIXV3Wwo9bJ1I05gFUrGQuxf/8S0tDJEwTMhJOo24az8NqXBq/Gwn4ZuXdihYP0d22NV4QU
        Bm1eKWBqOP7VBACra6M+j3hPTKw5/4JD+jsoOHEYVJcxG8b8DfBGyBI45N/CbDiSeWKkDmcP2AmfW
        GPQMX2prA+iZ1wRoapMi7bZchmCj+hRdgVeIj6cn3lk8vPSd+vxjOq6tN/LmfJyXddSrvK0xx5zgF
        SOyMsaDlT78o0lSnN1jTRa+WLi0ht8v0ylXjxjG4naPmtliNr33PcNUDwZGSYPv6b1nxno67XJ2C/
        e2mm1jUw==;
Received: from [2601:1c0:6280:3f0::1494]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkvGA-0005vx-8C; Thu, 03 Dec 2020 20:31:26 +0000
Subject: Re: [PATCH net-next v4] devlink: Add devlink port documentation
To:     Parav Pandit <parav@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     jacob.e.keller@intel.com, Jiri Pirko <jiri@nvidia.com>
References: <20201130164119.571362-1-parav@nvidia.com>
 <20201203180255.5253-1-parav@nvidia.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b15782d6-8156-5468-4b05-cdc5246d789b@infradead.org>
Date:   Thu, 3 Dec 2020 12:31:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203180255.5253-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 12/3/20 10:02 AM, Parav Pandit wrote:
> Added documentation for devlink port and port function related commands.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Changelog:
> v3->v4:
>  - changed 'exist' to 'exists'
>  - added 'an' eswitch
>  - changed 'can have one' to 'consists of'
>  - changed 'who intents' to 'that intends'
>  - removed unnecessary comma
>  - rewrote description for the example diagram
>  - changed 'controller consist of' to 'controller consists of'
> v2->v3:
>  - rephrased many lines
>  - first paragraph now describe devlink port
>  - instead of saying PCI device/function, using PCI function every
>    where
>  - changed 'physical link layer' to 'link layer'
>  - made devlink port type description more clear
>  - made devlink port flavour description more clear
>  - moved devlink port type table after port flavour
>  - added description for the example diagram
>  - describe CPU port that its linked to DSA
>  - made devlink port description for eswitch port more clear
> v1->v2:
>  - Removed duplicate table entries for DEVLINK_PORT_FLAVOUR_VIRTUAL.
>  - replaced 'consist of' to 'consisting'
>  - changed 'can be' to 'can be of'
> ---
>  .../networking/devlink/devlink-port.rst       | 111 ++++++++++++++++++
>  Documentation/networking/devlink/index.rst    |   1 +
>  2 files changed, 112 insertions(+)
>  create mode 100644 Documentation/networking/devlink/devlink-port.rst
> 
> diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
> new file mode 100644
> index 000000000000..ac18cb8041dc
> --- /dev/null
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -0,0 +1,111 @@

I find that this doc is now readable.  :)

Other people can comment on the technical details.

thanks.

-- 
~Randy
Acked-by: Randy Dunlap <rdunlap@infradead.org>
