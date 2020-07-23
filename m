Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F17D22ABEA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 11:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgGWJrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 05:47:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34718 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgGWJrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 05:47:08 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 24AD560055;
        Thu, 23 Jul 2020 09:47:08 +0000 (UTC)
Received: from us4-mdac16-51.ut7.mdlocal (unknown [10.7.66.22])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 237858009E;
        Thu, 23 Jul 2020 09:47:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.32])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A5B0B80051;
        Thu, 23 Jul 2020 09:47:07 +0000 (UTC)
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 76F68B4005E;
        Thu, 23 Jul 2020 09:47:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jul
 2020 02:47:03 -0700
Subject: Re: [PATCH net-next v2] sfc: convert to new udp_tunnel infrastructure
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <mhabets@solarflare.com>, <mslattery@solarflare.com>
References: <20200722190510.2877742-1-kuba@kernel.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <76c2ae76-a692-e401-8e1e-623613c7e2ae@solarflare.com>
Date:   Thu, 23 Jul 2020 10:47:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200722190510.2877742-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ocex03.SolarFlarecom.com (10.20.40.36)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25558.005
X-TM-AS-Result: No-7.841500-4.000000-10
X-TMASE-MatchedRID: 6lay9u8oTUPmLzc6AOD8DfHkpkyUphL9BGvINcfHqhfAJMh4mAwEG2rj
        wa8vt1tROYJ3SQ0w581Hizrc8Q0i4n2eW53IO/e2iuSat/QiCL999ekRHlOQkX8ZdqjsUKEVvsi
        2jMsaAaWlXLVUVNECeXPGE+Ds3AoyVByxqzbqctCcnm0v4tsY4z8PLLfSydtv0SxMhOhuA0TsBZ
        ifJJpYe3c4vjE9oRYOBjdInGxYRP4RrCXRM6ZrEhIRh9wkXSlFzDHtVtmAaYqHX0cDZiY+DboQ3
        F22ueJHEDcT5hm6RzZXvAUXihO/5ZkhVf5yhpSEqjZ865FPtpqbYJTL8pwAnruqk4cq52pz6DpP
        3CGihU+MsMmsZgEW1NvOCxdj45ZfCQZYBny/onPnZxuPj9aY+7fHCp+e+coebDD7i2QfyEfbE7l
        i9U4xA+LzNWBegCW2RYvisGWbbS+3sNbcHjySQd0H8LFZNFG7CKFCmhdu5cU5x+yGNlo7K+q+eR
        a3zqX4hLP36Z0gPDP6w6S9MfgQcjOvEYIlaFk84MhTSVael2pzPXKeMHDMIDn0XEOnzvdPAOIcb
        JIffnuigEHy7J4S6ylkreA5r24aYnCi5itk3iprD5+Qup1qU56oP1a0mRIj
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.841500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25558.005
X-MDID: 1595497628-irxB44tHcbDo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/07/2020 20:05, Jakub Kicinski wrote:
> Check MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED, before setting
> the info, which will hopefully protect us from -EPERM errors
> the previous code was gracefully ignoring. Ed reports this
> is not the 100% correct bit, but it's the best approximation
> we have. Shared code reports the port information back to user
> space, so we really want to know what was added and what failed.
> Ignoring -EPERM is not an option.
>
> The driver does not call udp_tunnel_get_rx_info(), so its own
> management of table state is not really all that problematic,
> we can leave it be. This allows the driver to continue with its
> copious table syncing, and matching the ports to TX frames,
> which it will reportedly do one day.
>
> Leave the feature checking in the callbacks, as the device may
> remove the capabilities on reset.
>
> Inline the loop from __efx_ef10_udp_tnl_lookup_port() into
> efx_ef10_udp_tnl_has_port(), since it's the only caller now.
>
> With new infra this driver gains port replace - when space frees
> up in a full table a new port will be selected for offload.
> Plus efx will no longer sleep in an atomic context.
>
> v2:
>  - amend the commit message about TRUSTED not being 100%
>  - add TUNNEL_ENCAP_UDP_PORT_ENTRY_INVALID to mark unsed
>    entries
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Looks reasonable enough, have an
Acked-By: Edward Cree <ecree@solarflare.com>
