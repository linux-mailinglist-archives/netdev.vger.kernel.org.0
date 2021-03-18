Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51290340929
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 16:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhCRPr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 11:47:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:57776 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhCRPru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 11:47:50 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMusB-00090F-Vr; Thu, 18 Mar 2021 16:47:44 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMusB-000V3X-Fc; Thu, 18 Mar 2021 16:47:43 +0100
Subject: Re: [PATCH v3 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, toke@redhat.com,
        freysteinn.alfredsson@kau.se, lorenzo.bianconi@redhat.com,
        john.fastabend@gmail.com, jasowang@redhat.com, mst@redhat.com,
        thomas.petazzoni@bootlin.com, mw@semihalf.com,
        linux@armlinux.org.uk, ilias.apalodimas@linaro.org,
        netanel@amazon.com, akiyano@amazon.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, ioana.ciornei@nxp.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, grygorii.strashko@ti.com,
        ecree.xilinx@gmail.com, maciej.fijalkowski@intel.com
References: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <38ae780a-f54a-cba2-1648-07926e646ed0@iogearbox.net>
Date:   Thu, 18 Mar 2021 16:47:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26112/Thu Mar 18 12:08:11 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/21 12:06 PM, Lorenzo Bianconi wrote:
> We want to change the current ndo_xdp_xmit drop semantics because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped
> frames.
> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc
> 
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied, thanks!
