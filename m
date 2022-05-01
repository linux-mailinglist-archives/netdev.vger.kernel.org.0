Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5925164D2
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 16:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347797AbiEAOzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 10:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbiEAOzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 10:55:35 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A805714B
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 07:52:10 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BDF5F5C0084;
        Sun,  1 May 2022 10:52:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 01 May 2022 10:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651416727; x=
        1651503127; bh=ClOx8nKOAFevHapJnyTFZzSQZ1+WPiww8zy8vbVGIn8=; b=i
        vk2o+2bbMdNlsHoTLDek1q+y9lUjGpyUOYBwO6ytinUpDd6HQoAEc8nDJr4THs1p
        LPikNdScmfPYAzH3xYG3caJsKLsAFZiBUzXU3z4xXlijNbeFO8WnBfDMBF8SR/+p
        AuRToEvATGkS24qOX+Glu+Sw09isieaWGO4AoncSOjsQjKKS5xiHgKuITKtHlQBd
        xYOAUIDBneY7pp/NprjRw+Zmb7+1GTOWPE4Afw82OMnx2VuU8skvfn9bReB/gjIZ
        eHEj11d+HfBdXSw7RDie8OKfOdMgmjSIqC8lIqLtFtBOD4oKLBGYX9/QCQNXMxjy
        tdEwkgsIyDAvQYZKFTH7w==
X-ME-Sender: <xms:l55uYn0d_Ub1ZIebti3kMGVYG2MzpJgpdGmDCaAdLfJ4Rc4hJ3uCKA>
    <xme:l55uYmH4dX8uEI5NbVhdiWrKnYAxGa8SPe2STyIpMjPhR2U7JaHR5RaEnm5B0q7jD
    ARAxIqIPz_CI4Y>
X-ME-Received: <xmr:l55uYn4_LlFWfRbYK2rNkbXJjgCsReJ7gT-QYcyhz9a5pAbTATxsHNfaDYja>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdefgdekudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeehhfdtjedviefffeduuddvffegteeiieeguefgudffvdfftdefheeijedthfej
    keenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:l55uYs2oxy4-OJ8eXBfwxHuoWZ5CdHxEgSFpihC2QhtpO_FCtgaHqQ>
    <xmx:l55uYqHR6uv-X30XoVqcmF6GfTrWZ7t_xvN33HRI3RiVoK5-au3drw>
    <xmx:l55uYt-DpMrjlBGP5nWEi_v32AT1oj-2QjhgBcdxJNIw0EjOheHFvA>
    <xmx:l55uYvQRiEn_PZI2qUO1C_J1ksGGVA4OF_IcsMraOs_ac1syzP3Uog>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 1 May 2022 10:52:06 -0400 (EDT)
Date:   Sun, 1 May 2022 17:52:03 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2-next 06/11] ipstats: Add a group "link"
Message-ID: <Ym6ek66a6kMH3ZEu@shredder>
References: <cover.1650615982.git.petrm@nvidia.com>
 <c361fce0960093e31aabbc0b45bb0c870896339e.1650615982.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c361fce0960093e31aabbc0b45bb0c870896339e.1650615982.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 10:30:55AM +0200, Petr Machata wrote:
> +#define IPSTATS_RTA_PAYLOAD(TYPE, AT)					\
> +	({								\
> +		const struct rtattr *__at = (AT);			\
> +		TYPE *__ret = NULL;					\
> +									\
> +		if (__at != NULL &&					\
> +		    __at->rta_len - RTA_LENGTH(0) >= sizeof(TYPE))	\
> +			__ret = RTA_DATA(__at);				\
> +		__ret;							\
> +	})
> +
> +static int ipstats_show_64(struct ipstats_stat_show_attrs *attrs,
> +			   unsigned int group, unsigned int subgroup)
> +{
> +	struct rtnl_link_stats64 *stats;
> +	const struct rtattr *at;
> +	int err;
> +
> +	at = ipstats_stat_show_get_attr(attrs, group, subgroup, &err);
> +	if (at == NULL)
> +		return err;
> +
> +	stats = IPSTATS_RTA_PAYLOAD(struct rtnl_link_stats64, at);
> +	if (stats == NULL) {
> +		fprintf(stderr, "Error: attribute payload too short");

When I tested this on 5.15 / 5.16 everything was fine, but now I get:

$ ip stats show dev lo group link
1: lo: group link
Error: attribute payload too short

Payload on 5.16:

recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=[{nlmsg_len=224, nlmsg_type=RTM_NEWSTATS, nlmsg_flags=0, nlmsg_seq=1651407379, nlmsg_pid=330213}, {family=AF_UNSPEC, ifindex=if_nametoindex("lo"), filter_mask=1<<IFLA_STATS_UNSPEC}, [{nla_len=196, nla_type=IFLA_STATS_LINK_64}, {rx_packets=321113, tx_packets=321113, rx_bytes=322735996, tx_bytes=322735996, rx_errors=0, tx_errors=0, rx_dropped=0, tx_dropped=0, multicast=0, collisions=0, rx_length_errors=0, rx_over_errors=0, rx_crc_errors=0, rx_frame_errors=0, rx_fifo_errors=0, rx_missed_errors=0, tx_aborted_errors=0, tx_carrier_errors=0, tx_fifo_errors=0, tx_heartbeat_errors=0, tx_window_errors=0, rx_compressed=0, tx_compressed=0, rx_nohandler=0}]], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 224
1: lo: group link
Error: attribute payload too short+++ exited with 22 +++

Payload on net-next:

recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base=[{nlmsg_len=232, nlmsg_type=RTM_NEWSTATS, nlmsg_flags=0, nlmsg_seq=1651407411, nlmsg_pid=198}, {family=AF_UNSPEC, ifindex=if_nametoindex("lo"), filter_mask=1<<IFLA_STATS_UNSPEC}, [{nla_len=204, nla_type=IFLA_STATS_LINK_64}, {rx_packets=0, tx_packets=0, rx_bytes=0, tx_bytes=0, rx_errors=0, tx_errors=0, rx_dropped=0, tx_dropped=0, multicast=0, collisions=0, rx_length_errors=0, rx_over_errors=0, rx_crc_errors=0, rx_frame_errors=0, rx_fifo_errors=0, rx_missed_errors=0, tx_aborted_errors=0, tx_carrier_errors=0, tx_fifo_errors=0, tx_heartbeat_errors=0, tx_window_errors=0, rx_compressed=0, tx_compressed=0, rx_nohandler=0}]], iov_len=32768}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 232
1: lo: group link
    RX:  bytes packets errors dropped  missed   mcast           
             0       0      0       0       0       0 
    TX:  bytes packets errors dropped carrier collsns           
             0       0      0       0       0       0 
+++ exited with 0 +++

Note the difference in size of IFLA_STATS_LINK_64 which carries struct
rtnl_link_stats64: 196 bytes vs. 204 bytes

The 8 byte difference is most likely from the addition of
rx_otherhost_dropped at the end:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=794c24e9921f32ded4422833a990ccf11dc3c00e

I guess it worked for me because I didn't have this member in my copy of
the uAPI file, but it's now in iproute2-next:

https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=bba95837524d09ee2f0efdf6350b83a985f4b2f8

I was under the impression that such a size increase in a uAPI struct is
forbidden, which is why we usually avoid passing structs over netlink.

> +		return -EINVAL;
> +	}
> +
> +	open_json_object("stats64");
> +	print_stats64(stdout, stats, NULL, NULL);
> +	close_json_object();
> +	return 0;
> +}
