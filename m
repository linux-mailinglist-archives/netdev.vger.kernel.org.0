Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A65D60C3B2
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 08:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJYGRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 02:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiJYGRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 02:17:45 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140138.outbound.protection.outlook.com [40.107.14.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD66443179;
        Mon, 24 Oct 2022 23:17:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMEoDe2nIt+bCB8pz/a8L6CvJiGhqZSba3HSURRirbzqhvWnZfk0pGGXH/E9iYeTrgAvI7PDZ4+7XNNPqxHP41x60QlxtQ/3kr8JUvNU2NFV6hv17F64RSajqTHnrM6snRasTZLdMcwNNH+gMIWMef933eyhV020dIY20uK9bXeoQw4JOQSB1bSpHyHB8fx4ByKhtTiZ7NyekjviigyD1II91qwN/6wcmqeeVxyV0AcPg20epcGB084Ao+1358Od+Mnh7ofP1NXPZCyZorfqUnSNcIa5iQeWzPBeBmNJjB/N0mkAH/Qa65wDo1ghr+GEwtOzT1NRayFSGW7fT3+0aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+4RQNJGc32rL50YW6Du2OWPmie5zimEStLpi+52w3fk=;
 b=BLxQfCsnMfm0L5ycwK7Az/tm5ErDnViFWIb8luemDeakcVfKoH06vtg/KpvnyhAwqCUyExeLArAW3WKRxU5PWNW0sCFsNBTyntFLa8nV70BkldGF3up2NEIrqMmJX9SjVpWMzV7uGsPtM51ifaDU2ReU5msi/2flfAdumnwYWHbXva8dANh84L8KmGPgWKwacgWGw3zuP2UZ3sw1On8tld2saQ8Hv5u0ZuZZ8QAxnwtgoiT5DJURioaRmn+e/QlPdF4lJfx0js5fFiZU/tdFWsNbbG9sXDm2Lzy6c9vLFTjgI1JWiSYkPvI1L9p+TdG+VkpX0E2rxDiLZlClWQlgoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 217.111.95.7) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+4RQNJGc32rL50YW6Du2OWPmie5zimEStLpi+52w3fk=;
 b=V0M+i6JXh3eJaZ9naYzImvQK6ZSXGMf3wLu5FUxXkNHtFh31mxSc+02Rtlw5eAs9V+RaUsAE0q7VwpR4QkVawhzHwKWoUDk2nCBz+Poi7iWcGEbI61fbXq9U5U5oezL64ITe81uawjST3nI9JBwDwhTjwsU7beeMQNHQfqkb1t0=
Received: from AS9PR06CA0238.eurprd06.prod.outlook.com (2603:10a6:20b:45e::8)
 by DB9PR07MB8498.eurprd07.prod.outlook.com (2603:10a6:10:36d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 06:17:39 +0000
Received: from VE1EUR02FT074.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:45e:cafe::d4) by AS9PR06CA0238.outlook.office365.com
 (2603:10a6:20b:45e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23 via Frontend
 Transport; Tue, 25 Oct 2022 06:17:39 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 217.111.95.7)
 smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: Fail (protection.outlook.com: domain of arri.de does not
 designate 217.111.95.7 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.111.95.7; helo=mta.arri.de;
Received: from mta.arri.de (217.111.95.7) by
 VE1EUR02FT074.mail.protection.outlook.com (10.152.13.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Tue, 25 Oct 2022 06:17:38 +0000
Received: from n95hx1g2.localnet (192.168.54.54) by mta.arri.de (10.10.18.5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.32; Tue, 25 Oct
 2022 08:17:37 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <richardcochran@gmail.com>
Subject: Re: [RFC Patch net-next 5/6] net: dsa: microchip: Adding the ptp packet reception logic
Date:   Tue, 25 Oct 2022 08:17:37 +0200
Message-ID: <4458429.LvFx2qVVIh@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20221014152857.32645-6-arun.ramadoss@microchip.com>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com> <20221014152857.32645-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.54]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1EUR02FT074:EE_|DB9PR07MB8498:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ee67875-df49-434f-866c-08dab6509de3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yhwEbcjCakc/E8OF8ICBMq2tu0BXQwDb8S1LicWtJyqRx5jIQCraqvcjyrhLIwUEBfYLuW7btETRKRhOF+Tcp0T3Oa2OubTObwGpAu+NA8jo4whA1uIpvRJ4hwH2SEeuXuH7dIQOKl/Mx+tt27D5fdq4YxGc5ox+LFrDL0+0jHBxIc/LfkliQgYoByQ7RPtKAsOVWX3p0O6ZCxHdXx489XCKD8ZUQfuVjYQhMbzjBpSBgXce2l+K0JT7So1dkjl5Y702yNyZXHv3uSfIa46dQWBynegwXZxA/FLh7w05ul/hpRogUiN5luf3Wn7IqmNrmlHFDkZECqZA0CeC+2U2IOyeDRuQV4wqPvW8Yl9XeFELmEMj4OIRc5hfUQMVBRPZI1lxCdnriVS65ZSb+v3vPOpObwZQlxwIwz81yuu5fVZBe8IufDFng3ppeT3risED81xh+gPOT5LeKdguX6uxBYYcgFvFuredooMjwD+1kLccCmsuTiX4FxvG7f5gMxgYNAT5+QHeDBizRdEUEPbd/HtQuBf1ISpwtiiYInRMO+WRIhGXlv5QJWq/QDtmBX8ZuSVHnGCvQgAM/+g6walylNINnUWy8MV3+GvFnI8/MQ7vrvxW+q60Qv6QdPwADygg4PNCHiT5fealZgM7KBkEB4U66+5jHfQ1KGecSHcG3BPFAoKHpCR3HaUndw0jHDljuTLFWmJ6PtpXYIJp1mkvIkpY+Wh1/81topsLvVxKY0CA1tUb1gk55lS8QOoV4McqgKW7Cv7aX3LxL74gd8Swu/rpcBBOsT5dyXBYQaRcN126anJLugs75tXHK7VOeLP5nLK1U3n1WuXhN8CpH4c01gXuxlIma8XYf680/jy6aiQ=
X-Forefront-Antispam-Report: CIP:217.111.95.7;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199015)(46966006)(36840700001)(478600001)(83380400001)(26005)(41300700001)(9576002)(8936002)(450100002)(107886003)(70586007)(5660300002)(8676002)(4326008)(186003)(16526019)(336012)(316002)(36916002)(2906002)(9686003)(54906003)(110136005)(40480700001)(47076005)(426003)(86362001)(70206006)(82310400005)(33716001)(82740400003)(81166007)(356005)(36860700001)(39026012)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 06:17:38.8294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee67875-df49-434f-866c-08dab6509de3
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.7];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR02FT074.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR07MB8498
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Friday, 14 October 2022, 17:28:56 CEST, Arun Ramadoss wrote:
> This patch adds the routines for timestamping received ptp packets.
> Whenever the ptp packet is received, the 4 byte hardware time stamped
> value is append to its packet. This 4 byte value is extracted from the
> tail tag and reconstructed to absolute time and assigned to skb
> hwtstamp.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 12 +++++++++++
>  drivers/net/dsa/microchip/ksz_ptp.c    | 25 +++++++++++++++++++++
>  drivers/net/dsa/microchip/ksz_ptp.h    |  6 ++++++
>  include/linux/dsa/ksz_common.h         | 15 +++++++++++++
>  net/dsa/tag_ksz.c                      | 30 ++++++++++++++++++++++----
>  5 files changed, 84 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 0c0fdb7b7879..388731959b23 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -2426,6 +2426,17 @@ static enum dsa_tag_protocol ksz_get_tag_protocol(struct dsa_switch *ds,
>  	return proto;
>  }
>  
> +static int ksz_connect_tag_protocol(struct dsa_switch *ds,
> +				    enum dsa_tag_protocol proto)
> +{
> +	struct ksz_tagger_data *tagger_data;
> +
> +	tagger_data = ksz_tagger_data(ds);

NULL pointer dereference is here:

ksz_connect() is only called for "lan937x", not for the other KSZ switches.
If ksz_connect() shall only be called for PTP switches, the result of
ksz_tagger_data() may be NULL.

> +	tagger_data->meta_tstamp_handler = ksz_tstamp_reconstruct;
> +
> +	return 0;
> +}
> +
>  static int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
>  				   bool flag, struct netlink_ext_ack *extack)
>  {
> @@ -2819,6 +2830,7 @@ static int ksz_switch_detect(struct ksz_device *dev)
>  
>  static const struct dsa_switch_ops ksz_switch_ops = {
>  	.get_tag_protocol	= ksz_get_tag_protocol,
> +	.connect_tag_protocol   = ksz_connect_tag_protocol,
>  	.get_phy_flags		= ksz_get_phy_flags,
>  	.setup			= ksz_setup,
>  	.teardown		= ksz_teardown,
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.c b/drivers/net/dsa/microchip/ksz_ptp.c
> index 2cae543f7e0b..5ae6eedb6b39 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.c
> +++ b/drivers/net/dsa/microchip/ksz_ptp.c
> @@ -372,6 +372,31 @@ static int ksz_ptp_start_clock(struct ksz_device *dev)
>  	return 0;
>  }
>  
> +ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_ptp_data *ptp_data = &dev->ptp_data;
> +	struct timespec64 ts = ktime_to_timespec64(tstamp);
> +	struct timespec64 ptp_clock_time;
> +	struct timespec64 diff;
> +
> +	spin_lock_bh(&ptp_data->clock_lock);
> +	ptp_clock_time = ptp_data->clock_time;
> +	spin_unlock_bh(&ptp_data->clock_lock);
> +
> +	/* calculate full time from partial time stamp */
> +	ts.tv_sec = (ptp_clock_time.tv_sec & ~3) | ts.tv_sec;
> +
> +	/* find nearest possible point in time */
> +	diff = timespec64_sub(ts, ptp_clock_time);
> +	if (diff.tv_sec > 2)
> +		ts.tv_sec -= 4;
> +	else if (diff.tv_sec < -2)
> +		ts.tv_sec += 4;
> +
> +	return timespec64_to_ktime(ts);
> +}
> +
>  static const struct ptp_clock_info ksz_ptp_caps = {
>  	.owner		= THIS_MODULE,
>  	.name		= "Microchip Clock",
> diff --git a/drivers/net/dsa/microchip/ksz_ptp.h b/drivers/net/dsa/microchip/ksz_ptp.h
> index 7e5d374d2acf..9589909ab7d5 100644
> --- a/drivers/net/dsa/microchip/ksz_ptp.h
> +++ b/drivers/net/dsa/microchip/ksz_ptp.h
> @@ -28,6 +28,7 @@ int ksz_hwtstamp_get(struct dsa_switch *ds, int port, struct ifreq *ifr);
>  int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
>  int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p);
>  void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p);
> +ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp);
>  
>  #else
>  
> @@ -64,6 +65,11 @@ static inline int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
>  
>  static inline void ksz_ptp_irq_free(struct dsa_switch *ds, u8 p) {}
>  
> +static inline ktime_t ksz_tstamp_reconstruct(struct dsa_switch *ds, ktime_t tstamp)
> +{
> +	return 0;
> +}
> +
>  #endif	/* End of CONFIG_NET_DSA_MICROCHIOP_KSZ_PTP */
>  
>  #endif
> diff --git a/include/linux/dsa/ksz_common.h b/include/linux/dsa/ksz_common.h
> index 8903bce4753b..82edd7228b3c 100644
> --- a/include/linux/dsa/ksz_common.h
> +++ b/include/linux/dsa/ksz_common.h
> @@ -9,9 +9,24 @@
>  
>  #include <net/dsa.h>
>  
> +/* All time stamps from the KSZ consist of 2 bits for seconds and 30 bits for
> + * nanoseconds. This is NOT the same as 32 bits for nanoseconds.
> + */
> +#define KSZ_TSTAMP_SEC_MASK  GENMASK(31, 30)
> +#define KSZ_TSTAMP_NSEC_MASK GENMASK(29, 0)
> +
> +static inline ktime_t ksz_decode_tstamp(u32 tstamp)
> +{
> +	u64 ns = FIELD_GET(KSZ_TSTAMP_SEC_MASK, tstamp) * NSEC_PER_SEC +
> +		 FIELD_GET(KSZ_TSTAMP_NSEC_MASK, tstamp);
> +
> +	return ns_to_ktime(ns);
> +}
> +
>  struct ksz_tagger_data {
>  	bool (*hwtstamp_get_state)(struct dsa_switch *ds);
>  	void (*hwtstamp_set_state)(struct dsa_switch *ds, bool on);
> +	ktime_t (*meta_tstamp_handler)(struct dsa_switch *ds, ktime_t tstamp);
>  };
>  
>  static inline struct ksz_tagger_data *
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index ca1261b04fe7..937a3e70b471 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -164,6 +164,25 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
>  #define KSZ9477_TAIL_TAG_OVERRIDE	BIT(9)
>  #define KSZ9477_TAIL_TAG_LOOKUP		BIT(10)
>  
> +static void ksz_rcv_timestamp(struct sk_buff *skb, u8 *tag,
> +			      struct net_device *dev, unsigned int port)
> +{
> +	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
> +	u8 *tstamp_raw = tag - KSZ9477_PTP_TAG_LEN;
> +	struct dsa_switch *ds = dev->dsa_ptr->ds;
> +	struct ksz_tagger_data *tagger_data;
> +	ktime_t tstamp;
> +
> +	tagger_data = ksz_tagger_data(ds);

another potential NULL pointer dereference here:
> +	if (!tagger_data->meta_tstamp_handler)
> +		return;
> +
> +	/* convert time stamp and write to skb */
> +	tstamp = ksz_decode_tstamp(get_unaligned_be32(tstamp_raw));
> +	memset(hwtstamps, 0, sizeof(*hwtstamps));
> +	hwtstamps->hwtstamp = tagger_data->meta_tstamp_handler(ds, tstamp);
> +}
> +
>  static struct sk_buff *ksz9477_xmit(struct sk_buff *skb,
>  				    struct net_device *dev)
>  {
> @@ -197,8 +216,10 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
>  	unsigned int len = KSZ_EGRESS_TAG_LEN;
>  
>  	/* Extra 4-bytes PTP timestamp */
> -	if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
> +	if (tag[0] & KSZ9477_PTP_TAG_INDICATION) {
> +		ksz_rcv_timestamp(skb, tag, dev, port);
>  		len += KSZ9477_PTP_TAG_LEN;
> +	}
>  
>  	return ksz_common_rcv(skb, dev, port, len);
>  }
> @@ -257,10 +278,11 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
>   * tag0 : represents tag override, lookup and valid
>   * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2, 0x80=port8)
>   *
> - * For rcv, 1 byte is added before FCS.
> + * For rcv, 1/5 bytes is added before FCS.
>   * ---------------------------------------------------------------------------
> - * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
> + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|ts(4bytes)|tag0(1byte)|FCS(4bytes)
>   * ---------------------------------------------------------------------------
> + * ts   : time stamp (Present only if bit 7 of tag0 is set)
>   * tag0 : zero-based value represents port
>   *	  (eg, 0x00=port1, 0x02=port3, 0x07=port8)
>   */
> @@ -304,7 +326,7 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
>  	.rcv	= ksz9477_rcv,
>  	.connect = ksz_connect,
>  	.disconnect = ksz_disconnect,
> -	.needed_tailroom = LAN937X_EGRESS_TAG_LEN,
> +	.needed_tailroom = LAN937X_EGRESS_TAG_LEN + KSZ9477_PTP_TAG_LEN,
>  };
>  
>  DSA_TAG_DRIVER(lan937x_netdev_ops);
> 




