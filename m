Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BD5290D3B
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411284AbgJPVZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:25:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:25218 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411184AbgJPVXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:23:54 -0400
IronPort-SDR: 8ZbXoWfrhv18IeG1e0VOAjQzkqDCayyiOxtrnGXgqBq5MtrqTA8v/fvklqhwax9AFaGwyfrIxf
 r6CgeTT2wXvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9776"; a="153608562"
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="153608562"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:23:49 -0700
IronPort-SDR: 5LGwyFXpYoUlsa8inKZSZWjAu4kR9hXMXc07FbkcYnduJ1HdfemR5mpXkwfvaFMrzhD8h37yDl
 qfawOn/ArfMA==
X-IronPort-AV: E=Sophos;i="5.77,383,1596524400"; 
   d="scan'208";a="315041483"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.117.85])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2020 14:23:49 -0700
Date:   Fri, 16 Oct 2020 14:23:48 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Toke =?ISO-8859-1?Q?H=F8ila?= =?ISO-8859-1?Q?nd-J=F8rgensen?=" 
        <toke@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexandre Cassen <acassen@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] tools/include: Update if_link.h and netlink.h
Message-ID: <20201016142348.0000452b@intel.com>
In-Reply-To: <20201015223119.1712121-1-irogers@google.com>
References: <20201015223119.1712121-1-irogers@google.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ian,

Ian Rogers wrote:

> These are tested to be the latest as part of the tools/lib/bpf build.

But you didn't mention why you're making these changes, and you're
removing a lot of comments without explaining why/where there might be
a replacement or why the comments are useless. I now see that you're
adding actual kdoc which is good, except for the part where
you don't put kdoc on all the structures.

> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/include/uapi/linux/if_link.h | 269 +++++++++++++++++++++++++----
>  tools/include/uapi/linux/netlink.h | 107 ++++++++++++
>  2 files changed, 342 insertions(+), 34 deletions(-)
> 
> diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> index 781e482dc499..c4b23f06f69e 100644
> --- a/tools/include/uapi/linux/if_link.h
> +++ b/tools/include/uapi/linux/if_link.h
> @@ -7,24 +7,23 @@
>  
>  /* This struct should be in sync with struct rtnl_link_stats64 */

Maybe you should put a "definitions are available in the comment above
rtnl_link_stats64" comment here?

>  struct rtnl_link_stats {
> -	__u32	rx_packets;		/* total packets received	*/
> -	__u32	tx_packets;		/* total packets transmitted	*/
> -	__u32	rx_bytes;		/* total bytes received 	*/
> -	__u32	tx_bytes;		/* total bytes transmitted	*/
> -	__u32	rx_errors;		/* bad packets received		*/
> -	__u32	tx_errors;		/* packet transmit problems	*/
> -	__u32	rx_dropped;		/* no space in linux buffers	*/
> -	__u32	tx_dropped;		/* no space available in linux	*/
> -	__u32	multicast;		/* multicast packets received	*/
> +	__u32	rx_packets;
> +	__u32	tx_packets;
> +	__u32	rx_bytes;

Why is removing all the comments useful? You didn't make any useful
change here.

> +	__u32	tx_bytes;
> +	__u32	rx_errors;
> +	__u32	tx_errors;
> +	__u32	rx_dropped;
> +	__u32	tx_dropped;
> +	__u32	multicast;
>  	__u32	collisions;
> -
>  	/* detailed rx_errors: */
>  	__u32	rx_length_errors;
> -	__u32	rx_over_errors;		/* receiver ring buff overflow	*/
> -	__u32	rx_crc_errors;		/* recved pkt with crc error	*/
> -	__u32	rx_frame_errors;	/* recv'd frame alignment error */
> -	__u32	rx_fifo_errors;		/* recv'r fifo overrun		*/
> -	__u32	rx_missed_errors;	/* receiver missed packet	*/
> +	__u32	rx_over_errors;
> +	__u32	rx_crc_errors;

Same comment as above.

> +	__u32	rx_frame_errors;
> +	__u32	rx_fifo_errors;
> +	__u32	rx_missed_errors;
>  
>  	/* detailed tx_errors */
>  	__u32	tx_aborted_errors;
> @@ -37,29 +36,200 @@ struct rtnl_link_stats {
>  	__u32	rx_compressed;
>  	__u32	tx_compressed;
>  
> -	__u32	rx_nohandler;		/* dropped, no handler found	*/
> +	__u32	rx_nohandler;

And here too!

>  };
>  
> -/* The main device statistics structure */
> +/**
> + * struct rtnl_link_stats64 - The main device statistics structure.
> + *
> + * @rx_packets: Number of good packets received by the interface.
> + *   For hardware interfaces counts all good packets received from the device
> + *   by the host, including packets which host had to drop at various stages
> + *   of processing (even in the driver).

Oh, I see now. A good commit message would have prevented me burping on
this so much.

> + *
> + * @tx_packets: Number of packets successfully transmitted.
> + *   For hardware interfaces counts packets which host was able to successfully
> + *   hand over to the device, which does not necessarily mean that packets
> + *   had been successfully transmitted out of the device, only that device
> + *   acknowledged it copied them out of host memory.
> + *
> + * @rx_bytes: Number of good received bytes, corresponding to @rx_packets.
> + *
> + *   For IEEE 802.3 devices should count the length of Ethernet Frames
> + *   excluding the FCS.
> + *
> + * @tx_bytes: Number of good transmitted bytes, corresponding to @tx_packets.
> + *
> + *   For IEEE 802.3 devices should count the length of Ethernet Frames
> + *   excluding the FCS.
> + *
> + * @rx_errors: Total number of bad packets received on this network device.
> + *   This counter must include events counted by @rx_length_errors,
> + *   @rx_crc_errors, @rx_frame_errors and other errors not otherwise
> + *   counted.
> + *
> + * @tx_errors: Total number of transmit problems.
> + *   This counter must include events counter by @tx_aborted_errors,
> + *   @tx_carrier_errors, @tx_fifo_errors, @tx_heartbeat_errors,
> + *   @tx_window_errors and other errors not otherwise counted.
> + *
> + * @rx_dropped: Number of packets received but not processed,
> + *   e.g. due to lack of resources or unsupported protocol.
> + *   For hardware interfaces this counter should not include packets
> + *   dropped by the device which are counted separately in
> + *   @rx_missed_errors (since procfs folds those two counters together).
> + *
> + * @tx_dropped: Number of packets dropped on their way to transmission,
> + *   e.g. due to lack of resources.
> + *
> + * @multicast: Multicast packets received.
> + *   For hardware interfaces this statistic is commonly calculated
> + *   at the device level (unlike @rx_packets) and therefore may include
> + *   packets which did not reach the host.
> + *
> + *   For IEEE 802.3 devices this counter may be equivalent to:
> + *
> + *    - 30.3.1.1.21 aMulticastFramesReceivedOK
> + *
> + * @collisions: Number of collisions during packet transmissions.
> + *
> + * @rx_length_errors: Number of packets dropped due to invalid length.
> + *   Part of aggregate "frame" errors in `/proc/net/dev`.
> + *
> + *   For IEEE 802.3 devices this counter should be equivalent to a sum
> + *   of the following attributes:
> + *
> + *    - 30.3.1.1.23 aInRangeLengthErrors
> + *    - 30.3.1.1.24 aOutOfRangeLengthField
> + *    - 30.3.1.1.25 aFrameTooLongErrors
> + *
> + * @rx_over_errors: Receiver FIFO overflow event counter.
> + *
> + *   Historically the count of overflow events. Such events may be
> + *   reported in the receive descriptors or via interrupts, and may
> + *   not correspond one-to-one with dropped packets.
> + *
> + *   The recommended interpretation for high speed interfaces is -
> + *   number of packets dropped because they did not fit into buffers
> + *   provided by the host, e.g. packets larger than MTU or next buffer
> + *   in the ring was not available for a scatter transfer.
> + *
> + *   Part of aggregate "frame" errors in `/proc/net/dev`.
> + *
> + *   This statistics was historically used interchangeably with
> + *   @rx_fifo_errors.
> + *
> + *   This statistic corresponds to hardware events and is not commonly used
> + *   on software devices.
> + *
> + * @rx_crc_errors: Number of packets received with a CRC error.
> + *   Part of aggregate "frame" errors in `/proc/net/dev`.
> + *
> + *   For IEEE 802.3 devices this counter must be equivalent to:
> + *
> + *    - 30.3.1.1.6 aFrameCheckSequenceErrors
> + *
> + * @rx_frame_errors: Receiver frame alignment errors.
> + *   Part of aggregate "frame" errors in `/proc/net/dev`.
> + *
> + *   For IEEE 802.3 devices this counter should be equivalent to:
> + *
> + *    - 30.3.1.1.7 aAlignmentErrors
> + *
> + * @rx_fifo_errors: Receiver FIFO error counter.
> + *
> + *   Historically the count of overflow events. Those events may be
> + *   reported in the receive descriptors or via interrupts, and may
> + *   not correspond one-to-one with dropped packets.
> + *
> + *   This statistics was used interchangeably with @rx_over_errors.
> + *   Not recommended for use in drivers for high speed interfaces.
> + *
> + *   This statistic is used on software devices, e.g. to count software
> + *   packet queue overflow (can) or sequencing errors (GRE).
> + *
> + * @rx_missed_errors: Count of packets missed by the host.
> + *   Folded into the "drop" counter in `/proc/net/dev`.
> + *
> + *   Counts number of packets dropped by the device due to lack
> + *   of buffer space. This usually indicates that the host interface
> + *   is slower than the network interface, or host is not keeping up
> + *   with the receive packet rate.
> + *
> + *   This statistic corresponds to hardware events and is not used
> + *   on software devices.
> + *
> + * @tx_aborted_errors:
> + *   Part of aggregate "carrier" errors in `/proc/net/dev`.
> + *   For IEEE 802.3 devices capable of half-duplex operation this counter
> + *   must be equivalent to:
> + *
> + *    - 30.3.1.1.11 aFramesAbortedDueToXSColls
> + *
> + *   High speed interfaces may use this counter as a general device
> + *   discard counter.
> + *
> + * @tx_carrier_errors: Number of frame transmission errors due to loss
> + *   of carrier during transmission.
> + *   Part of aggregate "carrier" errors in `/proc/net/dev`.
> + *
> + *   For IEEE 802.3 devices this counter must be equivalent to:
> + *
> + *    - 30.3.1.1.13 aCarrierSenseErrors
> + *
> + * @tx_fifo_errors: Number of frame transmission errors due to device
> + *   FIFO underrun / underflow. This condition occurs when the device
> + *   begins transmission of a frame but is unable to deliver the
> + *   entire frame to the transmitter in time for transmission.
> + *   Part of aggregate "carrier" errors in `/proc/net/dev`.
> + *
> + * @tx_heartbeat_errors: Number of Heartbeat / SQE Test errors for
> + *   old half-duplex Ethernet.
> + *   Part of aggregate "carrier" errors in `/proc/net/dev`.
> + *
> + *   For IEEE 802.3 devices possibly equivalent to:
> + *
> + *    - 30.3.2.1.4 aSQETestErrors
> + *
> + * @tx_window_errors: Number of frame transmission errors due
> + *   to late collisions (for Ethernet - after the first 64B of transmission).
> + *   Part of aggregate "carrier" errors in `/proc/net/dev`.
> + *
> + *   For IEEE 802.3 devices this counter must be equivalent to:
> + *
> + *    - 30.3.1.1.10 aLateCollisions
> + *
> + * @rx_compressed: Number of correctly received compressed packets.
> + *   This counters is only meaningful for interfaces which support
> + *   packet compression (e.g. CSLIP, PPP).
> + *
> + * @tx_compressed: Number of transmitted compressed packets.
> + *   This counters is only meaningful for interfaces which support
> + *   packet compression (e.g. CSLIP, PPP).
> + *
> + * @rx_nohandler: Number of packets received on the interface
> + *   but dropped by the networking stack because the device is
> + *   not designated to receive packets (e.g. backup link in a bond).
> + */

I'm a big fan of the extra documentation here, does something in the
Documentation directory pick these up so they'll get published as part
of the sphinx documentation?

>  /* The struct should be in sync with struct ifmap */
> @@ -170,12 +339,22 @@ enum {
>  	IFLA_PROP_LIST,
>  	IFLA_ALT_IFNAME, /* Alternative ifname */
>  	IFLA_PERM_ADDRESS,
> +	IFLA_PROTO_DOWN_REASON,
>  	__IFLA_MAX
>  };
>  
>  
>  #define IFLA_MAX (__IFLA_MAX - 1)
>  
> +enum {
> +	IFLA_PROTO_DOWN_REASON_UNSPEC,
> +	IFLA_PROTO_DOWN_REASON_MASK,	/* u32, mask for reason bits */
> +	IFLA_PROTO_DOWN_REASON_VALUE,   /* u32, reason bit value */
> +
> +	__IFLA_PROTO_DOWN_REASON_CNT,
> +	IFLA_PROTO_DOWN_REASON_MAX = __IFLA_PROTO_DOWN_REASON_CNT - 1
> +};
> +
>  /* backwards compatibility for userspace */
>  #ifndef __KERNEL__
>  #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
> @@ -594,6 +773,18 @@ enum ifla_geneve_df {
>  	GENEVE_DF_MAX = __GENEVE_DF_END - 1,
>  };
>  
> +/* Bareudp section  */
> +enum {
> +	IFLA_BAREUDP_UNSPEC,
> +	IFLA_BAREUDP_PORT,
> +	IFLA_BAREUDP_ETHERTYPE,
> +	IFLA_BAREUDP_SRCPORT_MIN,
> +	IFLA_BAREUDP_MULTIPROTO_MODE,
> +	__IFLA_BAREUDP_MAX
> +};
> +
> +#define IFLA_BAREUDP_MAX (__IFLA_BAREUDP_MAX - 1)
> +
>  /* PPP section */
>  enum {
>  	IFLA_PPP_UNSPEC,
> @@ -895,7 +1086,14 @@ enum {
>  #define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
>  
>  
> -/* HSR section */
> +/* HSR/PRP section, both uses same interface */
> +
> +/* Different redundancy protocols for hsr device */
> +enum {
> +	HSR_PROTOCOL_HSR,
> +	HSR_PROTOCOL_PRP,
> +	HSR_PROTOCOL_MAX,
> +};
>  
>  enum {
>  	IFLA_HSR_UNSPEC,
> @@ -905,6 +1103,9 @@ enum {
>  	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
>  	IFLA_HSR_SEQ_NR,
>  	IFLA_HSR_VERSION,		/* HSR version */
> +	IFLA_HSR_PROTOCOL,		/* Indicate different protocol than
> +					 * HSR. For example PRP.
> +					 */
>  	__IFLA_HSR_MAX,
>  };

The rest of these changes "syncing" seem like they should be part of
another patch, These aren't about stats or documentation, and why not
use kdoc for these?  Now you're adding a bunch of trailing comments
again.
