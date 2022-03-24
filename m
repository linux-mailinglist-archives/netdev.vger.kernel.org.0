Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE04E6491
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345934AbiCXOCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiCXOCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:02:52 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB980A9953
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:01:20 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id s72so3904922pgc.5
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XTKTkeXiyppbP2htdDq7iVgYAkGXCBbQxtaJcRh5rUU=;
        b=jxWwGR/ToRI+cIroIxKFlY/pS92q1v6notFPt//1v3z/nwd3ALDiXldp9DwQDUTX+2
         piGnj3qg72Jh6hLMwyuVW8dx+Qh2czVO4x5LxMTs//ghdphfSiAuM8uqgcwuBLvyY14A
         qafJmdUyR9jhmHbvAF3DElJ/42k6fXEOKJmp2o2NYfenggI/QUBpwxUTmzyr9DizbBcK
         T3ML1vXxBiiK7DJ+mOJrZKVuHzBS01ofR8ZYaQRTzzVCZQUJ5zyIPUXeMKVkyaMqa8KD
         eV5j1/8wLtA3DDuaxjMqvk2m9OJ6GMziiA6Cmr2aBa+YhwNTFVYaiQwJ9EzBeckyNzG0
         9jxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XTKTkeXiyppbP2htdDq7iVgYAkGXCBbQxtaJcRh5rUU=;
        b=JDwKV1qS6nU0lA8b6Ale7ZhwGBT2+ZIZWPpr8OwTvP/MvXxSKHIKhg5JwMwlniSjzD
         hvNt9zvPC2UnKim2av5epK8U5znF5crzGnt+P7VivlYPI9LLZ0JZZjjPXBH3LlWmbYqA
         tO/aPoPwkSE3NvJ0gYOA80FSR9LXgOHrMGGwv42KraOz9kTxRoY4a/0L+QkaBeb4WY5b
         p/bXIzdUDI+uAIjRtezBEx8PdEZurzfSDlKrBrJABt2DpnyGvK8GPhf+zNTZS/NnmMoe
         V7TTC/JvtZ0+k7vOSW1jMRO7bztzlWsnvk234z1QPU9IB8kIE08smPR5SrZY2KdOCLW/
         LdeA==
X-Gm-Message-State: AOAM533KNkPv0lF30onPO6HtrGXh3JHs2TRDkedXIy6CHfbm4uqDY+C4
        OCLpvD/109g3oJ/EKUGtxfk=
X-Google-Smtp-Source: ABdhPJzoFrbFba6hbqW+aw8V+bzubjR9soK2mQ5sv0EDy/IoFW7sk+SXQ47O8eyHOB9+wDUXPdq3yg==
X-Received: by 2002:a63:2320:0:b0:381:f11:20d7 with SMTP id j32-20020a632320000000b003810f1120d7mr4115965pgj.612.1648130480331;
        Thu, 24 Mar 2022 07:01:20 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p128-20020a622986000000b004e1366dd88esm3513656pfp.160.2022.03.24.07.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 07:01:19 -0700 (PDT)
Date:   Thu, 24 Mar 2022 07:01:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
Message-ID: <20220324140117.GE27824@hoboy.vegasvil.org>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-6-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322210722.6405-6-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 10:07:21PM +0100, Gerhard Engleder wrote:
> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
> index 54b9f54ac0b2..b7a8cf27c349 100644
> --- a/drivers/ptp/ptp_clock.c
> +++ b/drivers/ptp/ptp_clock.c
> @@ -450,6 +450,33 @@ void ptp_cancel_worker_sync(struct ptp_clock *ptp)
>  }
>  EXPORT_SYMBOL(ptp_cancel_worker_sync);
>  
> +ktime_t ptp_get_timestamp(int index,
> +			  const struct skb_shared_hwtstamps *hwtstamps,
> +			  bool cycles)
> +{
> +	char name[PTP_CLOCK_NAME_LEN] = "";
> +	struct ptp_clock *ptp;
> +	struct device *dev;
> +	ktime_t ts;
> +
> +	snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", index);
> +	dev = class_find_device_by_name(ptp_class, name);

This seems expensive for every single Rx frame in a busy PTP network.
Can't this be cached in the socket?

> +	if (!dev)
> +		return 0;
> +
> +	ptp = dev_get_drvdata(dev);
> +
> +	if (ptp->info->gettstamp)
> +		ts = ptp->info->gettstamp(ptp->info, hwtstamps, cycles);
> +	else
> +		ts = hwtstamps->hwtstamp;
> +
> +	put_device(dev);
> +
> +	return ts;
> +}
> +EXPORT_SYMBOL(ptp_get_timestamp);
> +
>  /* module operations */
>  
>  static void __exit ptp_exit(void)
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index cc6a7b2e267d..f4f0d8a880c6 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -133,6 +133,16 @@ struct ptp_system_timestamp {
>   *                   parameter cts: Contains timestamp (device,system) pair,
>   *                   where system time is realtime and monotonic.
>   *
> + * @gettstamp:  Get hardware timestamp based on normal/adjustable time or free
> + *              running time. If @getcycles64 or @getcyclesx64 are supported,
> + *              then this method is required to provide timestamps based on the
> + *              free running time. This method will be called if
> + *              SKBTX_HW_TSTAMP_PHC is set by the driver.
> + *              parameter hwtstamps: skb_shared_hwtstamps structure pointer.
> + *              parameter cycles: If false, then hardware timestamp based on
> + *              normal/adjustable time is requested. If true, then hardware
> + *              timestamp based on free running time is requested.
> + *
>   * @enable:   Request driver to enable or disable an ancillary feature.
>   *            parameter request: Desired resource to enable or disable.
>   *            parameter on: Caller passes one to enable or zero to disable.
> @@ -185,6 +195,9 @@ struct ptp_clock_info {
>  			    struct ptp_system_timestamp *sts);
>  	int (*getcrosscycles)(struct ptp_clock_info *ptp,
>  			      struct system_device_crosststamp *cts);
> +	ktime_t (*gettstamp)(struct ptp_clock_info *ptp,
> +			     const struct skb_shared_hwtstamps *hwtstamps,
> +			     bool cycles);
>  	int (*enable)(struct ptp_clock_info *ptp,
>  		      struct ptp_clock_request *request, int on);
>  	int (*verify)(struct ptp_clock_info *ptp, unsigned int pin,
> @@ -364,6 +377,19 @@ static inline void ptp_cancel_worker_sync(struct ptp_clock *ptp)
>   * a loadable module.
>   */
>  
> +/**
> + * ptp_get_timestamp() - get timestamp of ptp clock
> + *
> + * @index:     phc index of ptp pclock.
> + * @hwtstamps: skb_shared_hwtstamps structure pointer.
> + * @cycles:    true for timestamp based on cycles.
> + *
> + * Returns timestamp, or 0 on error.
> + */
> +ktime_t ptp_get_timestamp(int index,
> +			  const struct skb_shared_hwtstamps *hwtstamps,
> +			  bool cycles);
> +
>  /**
>   * ptp_get_vclocks_index() - get all vclocks index on pclock, and
>   *                           caller is responsible to free memory
> @@ -386,6 +412,10 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
>   */
>  ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index);
>  #else
> +static inline ktime_t ptp_get_timestamp(int index,
> +					const struct skb_shared_hwtstamps *hwtstamps,
> +					bool cycles);
> +{ return 0; }
>  static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
>  { return 0; }
>  static inline ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp,
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index f494ddbfc826..38929c113953 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -564,7 +564,10 @@ static inline bool skb_frag_must_loop(struct page *p)
>   * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
>   */
>  struct skb_shared_hwtstamps {
> -	ktime_t	hwtstamp;
> +	union {
> +		ktime_t	hwtstamp;
> +		void *phc_data;

needs kdoc update

> +	};
>  };
>  
>  /* Definitions for tx_flags in struct skb_shared_info */
> @@ -581,6 +584,9 @@ enum {
>  	/* generate hardware time stamp based on cycles if supported */
>  	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,
>  
> +	/* call PHC to get actual hardware time stamp */
> +	SKBTX_HW_TSTAMP_PHC = 1 << 3,
> +
>  	/* generate wifi status information (where possible) */
>  	SKBTX_WIFI_STATUS = 1 << 4,
>  
> diff --git a/net/socket.c b/net/socket.c
> index 2e932c058002..fe765d559086 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -804,21 +804,17 @@ static bool skb_is_swtx_tstamp(const struct sk_buff *skb, int false_tstamp)
>  	return skb->tstamp && !false_tstamp && skb_is_err_queue(skb);
>  }
>  
> -static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
> +static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
> +			   int if_index)
>  {
>  	struct scm_ts_pktinfo ts_pktinfo;
> -	struct net_device *orig_dev;
>  
>  	if (!skb_mac_header_was_set(skb))
>  		return;
>  
>  	memset(&ts_pktinfo, 0, sizeof(ts_pktinfo));
>  
> -	rcu_read_lock();
> -	orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> -	if (orig_dev)
> -		ts_pktinfo.if_index = orig_dev->ifindex;
> -	rcu_read_unlock();
> +	ts_pktinfo.if_index = if_index;
>  
>  	ts_pktinfo.pkt_length = skb->len - skb_mac_offset(skb);
>  	put_cmsg(msg, SOL_SOCKET, SCM_TIMESTAMPING_PKTINFO,
> @@ -838,6 +834,9 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  	int empty = 1, false_tstamp = 0;
>  	struct skb_shared_hwtstamps *shhwtstamps =
>  		skb_hwtstamps(skb);
> +	struct net_device *orig_dev;
> +	int if_index = 0;
> +	int phc_index = -1;
>  	ktime_t hwtstamp;
>  
>  	/* Race occurred between timestamp enabling and packet
> @@ -886,18 +885,32 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
>  	if (shhwtstamps &&
>  	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
>  	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
> -		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> -			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
> -							 sk->sk_bind_phc);
> +		rcu_read_lock();
> +		orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
> +		if (orig_dev) {
> +			if_index = orig_dev->ifindex;
> +			if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_PHC)
> +				phc_index = ethtool_get_phc(orig_dev);

again, this is something that can be cached, no?

> +		}
> +		rcu_read_unlock();
> +
> +		if ((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_PHC) &&
> +		    (phc_index != -1))
> +			hwtstamp = ptp_get_timestamp(phc_index, shhwtstamps,
> +						     sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC);
>  		else
>  			hwtstamp = shhwtstamps->hwtstamp;
>  
> +		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
> +			hwtstamp = ptp_convert_timestamp(&hwtstamp,
> +							 sk->sk_bind_phc);
> +
>  		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
>  			empty = 0;
>  
>  			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
>  			    !skb_is_err_queue(skb))
> -				put_ts_pktinfo(msg, skb);
> +				put_ts_pktinfo(msg, skb, if_index);
>  		}
>  	}
>  	if (!empty) {
> -- 
> 2.20.1
> 

Thanks,
Richard
