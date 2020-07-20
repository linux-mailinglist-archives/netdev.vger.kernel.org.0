Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDE7225DB7
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 13:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgGTLqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 07:46:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59616 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728460AbgGTLqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 07:46:06 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B3E5820052;
        Mon, 20 Jul 2020 11:46:05 +0000 (UTC)
Received: from us4-mdac16-35.at1.mdlocal (unknown [10.110.49.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B29F16009B;
        Mon, 20 Jul 2020 11:46:05 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.105])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4E0E3220073;
        Mon, 20 Jul 2020 11:46:05 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E72589C0076;
        Mon, 20 Jul 2020 11:46:04 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 20 Jul
 2020 12:45:58 +0100
Subject: Re: [PATCH net-next] efx: convert to new udp_tunnel infrastructure
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <mhabets@solarflare.com>, <mslattery@solarflare.com>
References: <20200717235336.879264-1-kuba@kernel.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <a97d3321-3fee-5217-59e4-e56bfbaff7a3@solarflare.com>
Date:   Mon, 20 Jul 2020 12:45:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200717235336.879264-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25552.003
X-TM-AS-Result: No-16.714500-8.000000-10
X-TMASE-MatchedRID: cxtZ8fwm3r+2tlYdo0NnhOFgDmzNVVKoQZpQRfyCdHx3PducjiV5hf6R
        OKSr3u5/21BHKSeoeV6PWx38Q1qIm6ZY4PxfRMWEMIxbvM3AVogisyg/lfGoZ94Pu+dawjd01ZG
        U7XvKVplW7D3gkS/y0wtC55NTHrlBv2aCOqPEdVrBLypRtAo4yAeCHewokHM/UQ+YXiZ8bivjxO
        sQ+OAAXRvAApDnn3pemNG//eCbQoUApIQ1X2G0S5qvoi7RQmPSE3EgF0+MVuC/btrChQPzdLH9y
        3BGSBuXZbj0QOEOG9g4UoCJNJJ1MtQ2aCZEo62uboe6sMfg+k95dnPVq3ls7EdmDSBYfnJRIycc
        KU/Ugps7RD90+qXrUY6FQBpTJ4z5XvbPG2Z0ApcBUi8HrskMT8wx7VbZgGmK7L2+zGEubN5RkYT
        SpSslRX4oUbD1TOGvNSPFYRD9+/u1DfGM6db7XwrgwFF/sjumiK5qg1cmsr+KXNybanokT2NJMG
        UcSEAmB8yoLeoM1C9Gs8uSoUUvQDTuXZRUSTQGEpA219sDMzkGchEhVwJY32ww+4tkH8hHEUx8G
        SuSpKSV94KkDM4G5F+24nCsUSFNt7DW3B48kkHdB/CxWTRRu25FeHtsUoHuqmubqGyuttTDsiwO
        byTjuz3FapPVVwfS9XWmQ4PgDerFhXMjdQIJpg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--16.714500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25552.003
X-MDID: 1595245565-g7EsMTcluHEh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subject line prefix should probably be sfc:, that's what we
 usually use for this driver.

On 18/07/2020 00:53, Jakub Kicinski wrote:
> Check MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED, before setting
> the info, which will hopefully protect us from -EPERM errors
Sorry, I forgot to pass on the answer I got from the firmware
 team, which was "TRUSTED is the wrong thing and there isn't a
 right thing".  The TRUSTED flag will be set on any function
 that can set UDP ports, but may also be set on some that can't
 (it's not clear what they're Trusted to do but this isn't it).
So it's OK to check it, but the EPERMs could still happen.
> the previous code was gracefully ignoring. Shared code reports
> the port information back to user space, so we really want
> to know what was added and what failed.
<snip>
> -static int efx_ef10_udp_tnl_add_port(struct efx_nic *efx,
> -				     struct efx_udp_tunnel tnl)
> -{
> -	struct efx_ef10_nic_data *nic_data = efx->nic_data;
> -	struct efx_udp_tunnel *match;
> -	char typebuf[8];
> -	size_t i;
> -	int rc;
> +	if (ti->type == UDP_TUNNEL_TYPE_VXLAN)
> +		efx_tunnel_type = TUNNEL_ENCAP_UDP_PORT_ENTRY_VXLAN;
> +	else
> +		efx_tunnel_type = TUNNEL_ENCAP_UDP_PORT_ENTRY_GENEVE;
I think I'd prefer to keep the switch() that explicitlychecks
 for UDP_TUNNEL_TYPE_GENEVE; even though the infrastructure
 makes sure it won't ever not be, I'd still feel more comfortable
 that way.  But it's up to you.
> @@ -3873,6 +3835,7 @@ static int efx_ef10_udp_tnl_add_port(struct efx_nic *efx,
>  static bool efx_ef10_udp_tnl_has_port(struct efx_nic *efx, __be16 port)
>  {
>  	struct efx_ef10_nic_data *nic_data = efx->nic_data;
> +	size_t i;
>  
>  	if (!(nic_data->datapath_caps &
>  	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
> @@ -3884,58 +3847,48 @@ static bool efx_ef10_udp_tnl_has_port(struct efx_nic *efx, __be16 port)
>  		 */
>  		return false;
>  
> -	return __efx_ef10_udp_tnl_lookup_port(efx, port) != NULL;
> +	for (i = 0; i < ARRAY_SIZE(nic_data->udp_tunnels); ++i)
> +		if (nic_data->udp_tunnels[i].port == port)
> +			return true;
> +
> +	return false;
>  }
>  
> -static int efx_ef10_udp_tnl_del_port(struct efx_nic *efx,
> -				     struct efx_udp_tunnel tnl)
> +static int efx_ef10_udp_tnl_unset_port(struct net_device *dev,
> +				       unsigned int table, unsigned int entry,
> +				       struct udp_tunnel_info *ti)
>  {
> -	struct efx_ef10_nic_data *nic_data = efx->nic_data;
> -	struct efx_udp_tunnel *match;
> -	char typebuf[8];
> +	struct efx_nic *efx = netdev_priv(dev);
> +	struct efx_ef10_nic_data *nic_data;
>  	int rc;
>  
> -	if (!(nic_data->datapath_caps &
> -	      (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN)))
> -		return 0;
> -
> -	efx_get_udp_tunnel_type_name(tnl.type, typebuf, sizeof(typebuf));
> -	netif_dbg(efx, drv, efx->net_dev, "Removing UDP tunnel (%s) port %d\n",
> -		  typebuf, ntohs(tnl.port));
> +	nic_data = efx->nic_data;
>  
>  	mutex_lock(&nic_data->udp_tunnels_lock);
>  	/* Make sure all TX are stopped while we remove from the table, else we
>  	 * might race against an efx_features_check().
>  	 */
>  	efx_device_detach_sync(efx);
> -
> -	match = __efx_ef10_udp_tnl_lookup_port(efx, tnl.port);
> -	if (match != NULL) {
> -		if (match->type == tnl.type) {
> -			if (--match->count) {
> -				/* Port is still in use, so nothing to do */
> -				netif_dbg(efx, drv, efx->net_dev,
> -					  "UDP tunnel port %d remains active\n",
> -					  ntohs(tnl.port));
> -				rc = 0;
> -				goto out_unlock;
> -			}
> -			rc = efx_ef10_set_udp_tnl_ports(efx, false);
> -			goto out_unlock;
> -		}
> -		efx_get_udp_tunnel_type_name(match->type,
> -					     typebuf, sizeof(typebuf));
> -		netif_warn(efx, drv, efx->net_dev,
> -			   "UDP port %d is actually in use by %s, not removing\n",
> -			   ntohs(tnl.port), typebuf);
> -	}
> -	rc = -ENOENT;
> -
> -out_unlock:
> +	nic_data->udp_tunnels[entry].port = 0;
I'm a little concerned that efx_ef10_udp_tnl_has_port(efx, 0);
 willgenerally return true, so in our yet-to-come TX offloads
 patch we'll need to check for !port when handling an skb with
 skb->encapsulation == true before calling has_port.
(I realise that the kernel almost certainly won't ever give us
 an skb with encap on UDP port 0, but it never hurts to be
 paranoid about things like that).
Could we not keep a 'valid'/'used' flag in the table, used in
 roughly the same way we were checking count != 0?

Apart from that this all looks fine, and the amount of deleted
 codemakes me happy :)

-ed
