Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5267B20E
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 20:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfG3Sfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 14:35:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40982 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfG3Sfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 14:35:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so20156440pgg.8
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 11:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=J1p5Tz8BB9A9kMniGs6QJKyZWeIzdYuCjG7ayUAXfKg=;
        b=2Fn/toC3Kybnd5ejZlsY/1hR2Hy1REyTS6PyOdDWq+hqsTEdcscJvgX+R1G5xgyhQh
         V+XgBVR6e9arIgB2WPz2C2XLFG8ZakpIdOHSLy/Rv1VO42u4jMQecLK3/Ux7JYSRRujp
         BuSMRky/51rIYGXT2z4cycCZkjvMHjeJVu+Zpq3kMtXF3oBw0zK7OR/epDViYaC4rJzG
         c2wZONIYk9fDWYJ84Kemfq5Egmw9WiDQ5NNOfnesTdcLTfcSEK26wlyXaK1yfy9BS13D
         vq08etw2EzKqIqZStdbUYuPPuXAsz0HgErOrofls4gcRQl596c5Zbh/cgmXUXwR7rZw0
         JMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=J1p5Tz8BB9A9kMniGs6QJKyZWeIzdYuCjG7ayUAXfKg=;
        b=oPHkwst81lncHp/cfCG+/UF79KZk1eoO6HfVthw3fE9PMOKpsD7lZeltQEwk01Ok4d
         3ESR4jz2zZ0qBoVF0pfTHDLDmrNpg8umYEDedt0hbYYY2P2b0LFSgNMsAEOeYdQqfhCY
         NmZdUDq5cOu99sEwv10NGzDGt7bug5mJzymFXjdYEbtHNma71rQJx9CUthh2WV4ZdEon
         b4C0pp08mfAOGfPGkTTSNYB64Ph83HGHhEjd7S6je82nFnefOFJJjXoYcsx/mLmGQRFg
         2S2fS71Y89lVaDodr273Tbj8I66MdeuBFsdBW+qlC9yPluepRcONLCIO135IO9mVuPFJ
         ol4Q==
X-Gm-Message-State: APjAAAVrrMTHjkdRQy6SVfVdJhSbrcT7x8k70AOsVNjGcgCeTJndI3z/
        cfGVJOpHmEfBNBvi2yjvXmwkkA==
X-Google-Smtp-Source: APXvYqyCCePu08FplVG9p/ftdjNL+g8Qu/62QlzXm4O8WrCCWJLesATN4owhihBN/dFwLx4duNHRFg==
X-Received: by 2002:a65:514c:: with SMTP id g12mr110432306pgq.76.1564511745146;
        Tue, 30 Jul 2019 11:35:45 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id j12sm57446470pff.4.2019.07.30.11.35.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 11:35:44 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
Subject: Re: [PATCH v4 net-next 12/19] ionic: Add async link status check and
 basic stats
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-13-snelson@pensando.io>
 <1621fa0c5649e1afb07889db0972cf87e1580332.camel@mellanox.com>
Message-ID: <2cd96b8d-d1ff-7cf9-1dc4-9acb51c207e9@pensando.io>
Date:   Tue, 30 Jul 2019 11:35:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1621fa0c5649e1afb07889db0972cf87e1580332.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/19 5:04 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:
>> Add code to handle the link status event, and wire up the
>> basic netdev hardware stats.
>>
>> Signed-off-by: Shannon Nelson<snelson@pensando.io>
>> ---
>>   .../net/ethernet/pensando/ionic/ionic_lif.c   | 116
>> ++++++++++++++++++
>>   .../net/ethernet/pensando/ionic/ionic_lif.h   |   1 +
>>   2 files changed, 117 insertions(+)
[...]
>> +	/* After outstanding events are processed we can check on
>> +	 * the link status and any outstanding interrupt credits.
>> +	 *
>> +	 * We wait until here to check on the link status in case
>> +	 * there was a long list of link events from a flap episode.
>> +	 */
>> +	if (test_bit(LIF_LINK_CHECK_NEEDED, lif->state)) {
>> +		struct ionic_deferred_work *work;
>> +
>> +		work = kzalloc(sizeof(*work), GFP_ATOMIC);
>> +		if (!work) {
>> +			netdev_err(lif->netdev, "%s OOM\n", __func__);
> why not having a pre allocated dedicated lif->link_check_work, instead
> of allocating in atomic context on every link check event ?

I don't want to worry about the possibility of additional requests 
driven from other threads using the same struct.

>> +		} else {
>> +			work->type = DW_TYPE_LINK_STATUS;
>> +			ionic_lif_deferred_enqueue(&lif->deferred,
>> work);
>> +		}
>> +	}
>> +
>>   return_to_napi:
>>   	return work_done;
>>   }
>>   
>> +static void ionic_get_stats64(struct net_device *netdev,
>> +			      struct rtnl_link_stats64 *ns)
>> +{
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct lif_stats *ls;
>> +
>> +	memset(ns, 0, sizeof(*ns));
>> +	ls = &lif->info->stats;
>> +
>> +	ns->rx_packets = le64_to_cpu(ls->rx_ucast_packets) +
>> +			 le64_to_cpu(ls->rx_mcast_packets) +
>> +			 le64_to_cpu(ls->rx_bcast_packets);
>> +
>> +	ns->tx_packets = le64_to_cpu(ls->tx_ucast_packets) +
>> +			 le64_to_cpu(ls->tx_mcast_packets) +
>> +			 le64_to_cpu(ls->tx_bcast_packets);
>> +
>> +	ns->rx_bytes = le64_to_cpu(ls->rx_ucast_bytes) +
>> +		       le64_to_cpu(ls->rx_mcast_bytes) +
>> +		       le64_to_cpu(ls->rx_bcast_bytes);
>> +
>> +	ns->tx_bytes = le64_to_cpu(ls->tx_ucast_bytes) +
>> +		       le64_to_cpu(ls->tx_mcast_bytes) +
>> +		       le64_to_cpu(ls->tx_bcast_bytes);
>> +
>> +	ns->rx_dropped = le64_to_cpu(ls->rx_ucast_drop_packets) +
>> +			 le64_to_cpu(ls->rx_mcast_drop_packets) +
>> +			 le64_to_cpu(ls->rx_bcast_drop_packets);
>> +
>> +	ns->tx_dropped = le64_to_cpu(ls->tx_ucast_drop_packets) +
>> +			 le64_to_cpu(ls->tx_mcast_drop_packets) +
>> +			 le64_to_cpu(ls->tx_bcast_drop_packets);
>> +
>> +	ns->multicast = le64_to_cpu(ls->rx_mcast_packets);
>> +
>> +	ns->rx_over_errors = le64_to_cpu(ls->rx_queue_empty);
>> +
>> +	ns->rx_missed_errors = le64_to_cpu(ls->rx_dma_error) +
>> +			       le64_to_cpu(ls->rx_queue_disabled) +
>> +			       le64_to_cpu(ls->rx_desc_fetch_error) +
>> +			       le64_to_cpu(ls->rx_desc_data_error);
>> +
>> +	ns->tx_aborted_errors = le64_to_cpu(ls->tx_dma_error) +
>> +				le64_to_cpu(ls->tx_queue_disabled) +
>> +				le64_to_cpu(ls->tx_desc_fetch_error) +
>> +				le64_to_cpu(ls->tx_desc_data_error);
>> +
>> +	ns->rx_errors = ns->rx_over_errors +
>> +			ns->rx_missed_errors;
>> +
>> +	ns->tx_errors = ns->tx_aborted_errors;
>> +}
>> +
>>   static int ionic_lif_addr_add(struct lif *lif, const u8 *addr)
>>   {
>>   	struct ionic_admin_ctx ctx = {
>> @@ -581,6 +693,7 @@ static int ionic_vlan_rx_kill_vid(struct
>> net_device *netdev, __be16 proto,
>>   static const struct net_device_ops ionic_netdev_ops = {
>>   	.ndo_open               = ionic_open,
>>   	.ndo_stop               = ionic_stop,
>> +	.ndo_get_stats64	= ionic_get_stats64,
>>   	.ndo_set_rx_mode	= ionic_set_rx_mode,
>>   	.ndo_set_features	= ionic_set_features,
>>   	.ndo_set_mac_address	= ionic_set_mac_address,
>> @@ -1418,6 +1531,8 @@ static int ionic_lif_init(struct lif *lif)
>>   
>>   	set_bit(LIF_INITED, lif->state);
>>   
>> +	ionic_link_status_check(lif);
>> +
>>   	return 0;
>>   
>>   err_out_notifyq_deinit:
>> @@ -1461,6 +1576,7 @@ int ionic_lifs_register(struct ionic *ionic)
>>   		return err;
>>   	}
>>   
> are events (NotifyQ) enabled at this stage ? if so then you might endup
> racing ionic_link_status_check with itself.

I'll look at that again to see what such a race might do.  I probably 
should add a test here and in a couple other spots to see if the link 
status check has already been requested.

sln

