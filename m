Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817D86B9C4D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjCNQzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCNQzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:55:49 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A103FA674D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:55:46 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v16so15044332wrn.0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678812945;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q8MARdNzPB3Zg78qPJOBs9HVOykc+ZiAJjfKI+bFeq8=;
        b=G/QtC/YvlkdP3eRTlugppxAH81kIpebAsETRbCoKUnR1+8mb6HDzNwceZbAR5BkE2i
         jL5JDHQFFQE6IQHQtTdWIPOdaYuSbz3u4jjggTUq/anohAe9VINMdcV9axYd4k8ef5ae
         M+KYsuQrewQ78MpdflF0IVoKKp5iilnlsdEwkYfdDp8V7NUzdGm1OluHuvc+BEByUHck
         t+WkV3lF/MZ+1BLxpJpWRPTFHxB75FEe5U7v+zceeR3z2YevS6gh0iaLSuOLSHNuCYuh
         0gscLFcNdbwD3X1xIihA+EM4sIRIlHhTPgwg3V0Vj5/BfTF7mj9bgnWC8+bGusbz+IEN
         F1BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678812945;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8MARdNzPB3Zg78qPJOBs9HVOykc+ZiAJjfKI+bFeq8=;
        b=SFfF0EPP37vUYQBoI3fT5X+oTEmlr5nzzNARJFT3g33i/ZWcNj0aWjPYVjqhKbgZYG
         1PB1CtUkUVlg/OZvcqQCitsfvn8KL+RvRcaQfHUJbERpmFHZ26GWrPn5rQi0VuuNQyrX
         qDlCZCc0B1c7p1BY/I9f4Jls+iNM+s3HUQLj7Q/+7JyjcV7PsSQHzANBB9tl/wT/ujFV
         LVXCbEImHw8fb4Fhki94AqGSvWr3W7D4rbySpZELN1YVrCsI4ezC/CGxhc/mE8damaLX
         Rk1DHdP9F3ewp1QYUGJTjCeK1ghTRVr0r7BYhgTDNjTK+ATY/AjI8ZxEitTQbhN85CR7
         chqQ==
X-Gm-Message-State: AO0yUKWPFI645a62El0sodkwLcWXaacAlelHP1AFNgrdiP6VN5aQpl91
        HvjcBmNpfUj6JZHX8Z3cviE=
X-Google-Smtp-Source: AK7set+gabKaEOFj2gy5ZNNqsQh9JsO5bWdLBjG/j5XPTQlR7tLfQM+p7Ezm5Hta+8v8uQsCygkmhA==
X-Received: by 2002:a5d:4404:0:b0:2ce:a7f6:2fe5 with SMTP id z4-20020a5d4404000000b002cea7f62fe5mr7826244wrq.60.1678812945195;
        Tue, 14 Mar 2023 09:55:45 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id y2-20020adffa42000000b002c7163660a9sm2451718wrr.105.2023.03.14.09.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 09:55:44 -0700 (PDT)
Subject: Re: [PATCH RESEND net-next v4 3/4] sfc: support unicast PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com, richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-4-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <71e22d1e-336a-8e6a-9b36-708f07c632b2@gmail.com>
Date:   Tue, 14 Mar 2023 16:55:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230314100925.12040-4-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 10:09, Íñigo Huguet wrote:
> When sending a PTP event packet, add the correct filters that will make
> that future incoming unicast PTP event packets will be timestamped.
> The unicast address for the filter is gotten from the outgoing skb
> before sending it.
> 
> Until now they were not timestamped because only filters that match with
> the PTP multicast addressed were being configured into the NIC for the
> PTP special channel. Packets received through different channels are not
> timestamped, getting "received SYNC without timestamp" error in ptp4l.
> 
> Note that the inserted filters are never removed unless the NIC is stopped
> or reconfigured, so efx_ptp_stop is called. Removal of old filters will
> be handled by the next patch.
> 
> Additionally, cleanup a bit efx_ptp_xmit_skb_mc to use the reverse xmas
> tree convention and remove an unnecessary assignment to rc variable in
> void function.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Few nits below, but still
Acked-by: Edward Cree <ecree.xilinx@gmail.com>

> +static bool efx_ptp_filter_exists(struct list_head *ptp_list,
> +				  struct efx_filter_spec *spec)
> +{
> +	struct efx_ptp_rxfilter *rxfilter;
> +
> +	list_for_each_entry(rxfilter, ptp_list, list) {
> +		if (rxfilter->ether_type == spec->ether_type &&
> +		    rxfilter->loc_port == spec->loc_port &&
> +		    !memcmp(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host)))
> +			return true;
> +	}
> +
> +	return false;
> +}

Technically this could be more efficient if we used an rhashtable
 instead of a list, but I guess we don't expect the list to grow
 very long.

> +static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
> +					 struct sk_buff *skb)
> +{
> +	struct efx_ptp_data *ptp = efx->ptp_data;
> +	int rc;
> +
> +	if (!efx_ptp_valid_unicast_event_pkt(skb))
> +		return -EINVAL;
> +
> +	if (skb->protocol == htons(ETH_P_IP)) {
> +		__be32 addr = ip_hdr(skb)->saddr;
> +
> +		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_EVENT_PORT);
> +		if (rc < 0)
> +			goto fail;
> +
> +		rc = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_GENERAL_PORT);
> +		if (rc < 0)
> +			goto fail;
> +	} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
> +		/* IPv6 PTP only supported by devices with MAC hw timestamp */
> +		struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
> +
> +		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_EVENT_PORT);
> +		if (rc < 0)
> +			goto fail;
> +
> +		rc = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
> +						addr, PTP_GENERAL_PORT);
> +		if (rc < 0)
> +			goto fail;
> +	} else {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +
> +fail:
> +	efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
> +	return rc;
> +}

Why does failing to insert one filter mean we need to remove *all*
 the unicast filters we have?  (I'm not even sure it's necessary
 to remove the new EVENT filter if the GENERAL filter fails.)
