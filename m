Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30CE50D337
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbiDXQSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234208AbiDXQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:18:15 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E310764F8;
        Sun, 24 Apr 2022 09:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=dFgs9qbEcOWsSo2xl3UGtyLPP/Q/SV+0PLsA8mb0eTY=;
  b=dJdcRpTbIo2wX6tp1wmNIOoT4XSB97unPa6eLJxbBD6cK9oSQsZf2NAh
   MPSl5DWl6R2F4p+F2aI8TURJAZys3mHpOrWHoITR7itSnGDiz/bCLVsMs
   OP24VAz6XesPAIVv9yPxq5MeXovM/OmjTg5Ku7Nbv+sBksL1F+kW45Qcr
   M=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,286,1643670000"; 
   d="scan'208";a="12281397"
Received: from ip-214.net-89-2-7.rev.numericable.fr (HELO hadrien) ([89.2.7.214])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2022 18:15:08 +0200
Date:   Sun, 24 Apr 2022 18:15:06 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, jdenham@redhat.com, sbrivio@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v3 2/2] net: vxlan: vxlan_core.c: Add extack
 support to vxlan_fdb_delete
In-Reply-To: <0d09ad611bb78b9113491007955f2211f3a06e82.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
Message-ID: <alpine.DEB.2.22.394.2204241813210.7691@hadrien>
References: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com> <0d09ad611bb78b9113491007955f2211f3a06e82.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sun, 24 Apr 2022, Alaa Mohamed wrote:

> Add extack to vxlan_fdb_delete and vxlan_fdb_parse

It could be helpful to say more about what adding extack support involves.

>
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---
> changes in V2:
> 	- fix spelling vxlan_fdb_delete
> 	- add missing braces
> 	- edit error message
> ---
> changes in V3:
> 	fix errors reported by checkpatch.pl

But your changes would seem to also be introducing more checkpatch errors,
because the Linux kernel coding style puts a space before an { at the
start of an if branch.

julia

> ---
>  drivers/net/vxlan/vxlan_core.c | 36 +++++++++++++++++++++++-----------
>  1 file changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> index cf2f60037340..4e1886655101 100644
> --- a/drivers/net/vxlan/vxlan_core.c
> +++ b/drivers/net/vxlan/vxlan_core.c
> @@ -1129,19 +1129,23 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
>
>  static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>  			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
> -			   __be32 *vni, u32 *ifindex, u32 *nhid)
> +			   __be32 *vni, u32 *ifindex, u32 *nhid, struct netlink_ext_ack *extack)
>  {
>  	struct net *net = dev_net(vxlan->dev);
>  	int err;
>
>  	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
> -	    tb[NDA_PORT]))
> -		return -EINVAL;
> +	    tb[NDA_PORT])){
> +			NL_SET_ERR_MSG(extack, "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
> +			return -EINVAL;
> +		}
>
>  	if (tb[NDA_DST]) {
>  		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
> -		if (err)
> +		if (err){
> +			NL_SET_ERR_MSG(extack, "Unsupported address family");
>  			return err;
> +		}
>  	} else {
>  		union vxlan_addr *remote = &vxlan->default_dst.remote_ip;
>
> @@ -1157,24 +1161,30 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>  	}
>
>  	if (tb[NDA_PORT]) {
> -		if (nla_len(tb[NDA_PORT]) != sizeof(__be16))
> +		if (nla_len(tb[NDA_PORT]) != sizeof(__be16)){
> +			NL_SET_ERR_MSG(extack, "Invalid vxlan port");
>  			return -EINVAL;
> +		}
>  		*port = nla_get_be16(tb[NDA_PORT]);
>  	} else {
>  		*port = vxlan->cfg.dst_port;
>  	}
>
>  	if (tb[NDA_VNI]) {
> -		if (nla_len(tb[NDA_VNI]) != sizeof(u32))
> +		if (nla_len(tb[NDA_VNI]) != sizeof(u32)){
> +			NL_SET_ERR_MSG(extack, "Invalid vni");
>  			return -EINVAL;
> +		}
>  		*vni = cpu_to_be32(nla_get_u32(tb[NDA_VNI]));
>  	} else {
>  		*vni = vxlan->default_dst.remote_vni;
>  	}
>
>  	if (tb[NDA_SRC_VNI]) {
> -		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32))
> +		if (nla_len(tb[NDA_SRC_VNI]) != sizeof(u32)){
> +			NL_SET_ERR_MSG(extack, "Invalid src vni");
>  			return -EINVAL;
> +		}
>  		*src_vni = cpu_to_be32(nla_get_u32(tb[NDA_SRC_VNI]));
>  	} else {
>  		*src_vni = vxlan->default_dst.remote_vni;
> @@ -1183,12 +1193,16 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>  	if (tb[NDA_IFINDEX]) {
>  		struct net_device *tdev;
>
> -		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32))
> +		if (nla_len(tb[NDA_IFINDEX]) != sizeof(u32)){
> +			NL_SET_ERR_MSG(extack, "Invalid ifindex");
>  			return -EINVAL;
> +		}
>  		*ifindex = nla_get_u32(tb[NDA_IFINDEX]);
>  		tdev = __dev_get_by_index(net, *ifindex);
> -		if (!tdev)
> +		if (!tdev){
> +			NL_SET_ERR_MSG(extack,"Device not found");
>  			return -EADDRNOTAVAIL;
> +		}
>  	} else {
>  		*ifindex = 0;
>  	}
> @@ -1226,7 +1240,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
>  		return -EINVAL;
>
>  	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
> -			      &nhid);
> +			      &nhid, extack);
>  	if (err)
>  		return err;
>
> @@ -1291,7 +1305,7 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>  	int err;
>
>  	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
> -			      &nhid);
> +			      &nhid, extack);
>  	if (err)
>  		return err;
>
> --
> 2.36.0
>
>
>
