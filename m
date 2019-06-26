Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B587556E16
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfFZPxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:53:38 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40901 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZPxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:53:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id a93so1673175pla.7
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BJcLrLEwu351G5IMdizOJKuXz8TgtEBz3UjqOExR7r4=;
        b=LLqoZ2WggVM4tQ2HxeMOzQW/kJwuB7puFZ1opQCI1T2Yxh8A/H6Wd7GDZxqDBIMGpU
         DBoqGmJ8eUGCqoOhYX6M+dnMMLi2VIjJUk0NsXlGwTUzqnHgtbQhv1pwemd5CK1cnMIu
         DbSFk3u6HsyXLYKrv4zTeaA90l+Uzy7jSDNvx0WYo+1pFLDjhucJo4xXDP+s38kikSPu
         sD29wJDdGzqZRziA+WLdDjUV6MJ2K9KYlOToe2AnCnuYVDCZtSYXDbafqRCg1m67Vnvz
         YcPp88zaIXDsedt4yW7uF8fOMpXq9VgkB+IRik3TpdHTEhI/e0qjqGe+Q/h4OeoP4HRw
         NVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BJcLrLEwu351G5IMdizOJKuXz8TgtEBz3UjqOExR7r4=;
        b=g8wN8SQs3JuCmi4tiPu9M5MpJ/+Ly4GaZ00xhp+qzyxdzEVW96G9jfgDLHZtOJLrPj
         8ouY2G8d+CGsMhqa3sLm4zlS5E3AqGVD0xw/PzbobvW1rfxBcbw/eHAjQCoWPWpu43C0
         E2GLGHWzt0EfVUGDe18oJfeONt22JZHX02OR9efKFcIBDNAy025PYBWumRCnqtfSQn/z
         fifRHzHCg9uH8BcDeBzvDN5lnrJxuEjwuNM8x1/otvAczVwLc1AZeQle92zuu0LMB04p
         dXc68vVOAT10g+UYw0vE6FKgHCmelPpap3Z6h6vej7h4mAew5nnfPP5vC+JPMZ4pMAMH
         AmXQ==
X-Gm-Message-State: APjAAAXncqciK1Y4M73ek9Bb3LFeq6/o4gLSh8o6JuuHxE+9cC3YQhbi
        wZ8jvQjzcWvKWW5rIHoNwrHjNlQMJfg=
X-Google-Smtp-Source: APXvYqys6Es+DfkELMqOfAmboi0ptURSR9aOUdvP0JqIX9YpsDefI1aXjFO9+9igrFWifpehP4DuMw==
X-Received: by 2002:a17:902:3103:: with SMTP id w3mr6417341plb.84.1561564417354;
        Wed, 26 Jun 2019 08:53:37 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id h62sm23654437pgc.54.2019.06.26.08.53.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 08:53:36 -0700 (PDT)
Subject: Re: [PATCH net-next 11/18] ionic: Add Rx filter and rx_mode nod
 support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-12-snelson@pensando.io>
 <20190625164456.606dd40a@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <2ded20ac-8643-2043-6154-edc4b7c66814@pensando.io>
Date:   Wed, 26 Jun 2019 08:53:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190625164456.606dd40a@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/19 4:44 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:17 -0700, Shannon Nelson wrote:
>> Add the Rx filtering and rx_mode NDO callbacks.  Also add
>> the deferred work thread handling needed to manage the filter
>> requests otuside of the netif_addr_lock spinlock.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>>   static int ionic_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto,
>>   				  u16 vid)
>>   {
>> -	netdev_info(netdev, "%s: stubbed\n", __func__);
>> +	struct lif *lif = netdev_priv(netdev);
>> +	struct ionic_admin_ctx ctx = {
>> +		.work = COMPLETION_INITIALIZER_ONSTACK(ctx.work),
>> +		.cmd.rx_filter_del = {
>> +			.opcode = CMD_OPCODE_RX_FILTER_DEL,
>> +			.lif_index = cpu_to_le16(lif->index),
>> +		},
>> +	};
>> +	struct rx_filter *f;
>> +	int err;
>> +
>> +	spin_lock_bh(&lif->rx_filters.lock);
>> +
>> +	f = ionic_rx_filter_by_vlan(lif, vid);
>> +	if (!f) {
>> +		spin_unlock_bh(&lif->rx_filters.lock);
>> +		return -ENOENT;
>> +	}
>> +
>> +	netdev_dbg(netdev, "rx_filter del VLAN %d (id %d)\n", vid,
>> +		   le32_to_cpu(ctx.cmd.rx_filter_del.filter_id));
>> +
>> +	ctx.cmd.rx_filter_del.filter_id = cpu_to_le32(f->filter_id);
>> +	ionic_rx_filter_free(lif, f);
>> +	spin_unlock_bh(&lif->rx_filters.lock);
>> +
>> +	err = ionic_adminq_post_wait(lif, &ctx);
>> +	if (err)
>> +		return err;
>>
>>   	return 0;
> nit: return directly?
Sure.

>
>>   }
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> index 8129fa20695a..c3ecf1df9c2c 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
>> @@ -60,6 +60,29 @@ struct qcq {
>>   #define napi_to_qcq(napi)	container_of(napi, struct qcq, napi)
>>   #define napi_to_cq(napi)	(&napi_to_qcq(napi)->cq)
>>   
>> +enum deferred_work_type {
>> +	DW_TYPE_RX_MODE,
>> +	DW_TYPE_RX_ADDR_ADD,
>> +	DW_TYPE_RX_ADDR_DEL,
>> +	DW_TYPE_LINK_STATUS,
>> +	DW_TYPE_LIF_RESET,
>> +};
>> +
>> +struct deferred_work {
> If you don't mind prefixing these structures with ionic_ that'd be
> great.  I'm worried deferred_work is too close to delayed_work..

Yes.

>
>> +	struct list_head list;
>> +	enum deferred_work_type type;
>> +	union {
>> +		unsigned int rx_mode;
>> +		u8 addr[ETH_ALEN];
>> +	};
>> +};
>> +
>> +struct deferred {
>> +	spinlock_t lock;		/* lock for deferred work list */
>> +	struct list_head list;
>> +	struct work_struct work;
>> +};

