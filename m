Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12C143CD19
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234640AbhJ0PKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbhJ0PKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:10:55 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E52C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:08:29 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id r6so3866704oiw.2
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 08:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1D/IWeLjOYONtbXts4yy8JSU/zm/hOaOqp5yldl8Kh4=;
        b=K8vU1zoum9As+xhsIyjjwW9ThdWKZg9dm0oZwc7fFo2dtpfxS8QE1HUlGJfC5ZO6bV
         5cPLC5+B4+qHmxOlwpoHhxYgDy0ujav4oNojvtJendQBSmph4PuWD5uQZsmC1D3XEe0D
         XRd6xD6HwNFYQp4ztiXwJVpIXEC9MNbQnBYR9w9hfGccDwlCUIXHyFDfS2tuPXyQFE9G
         Veam1tjvDgDT7rZkW8vjMjIyqh6U9/8F6kzpKympkQy81iiTLIfG7ydrIZLS8Cyt7MZ+
         pJlm9pseY+EMb/bGOs+JewIzLUKeoSb0k16Dy7tGS4fTW+LCpEPcwPkwdjaWEhqQ34MF
         qE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1D/IWeLjOYONtbXts4yy8JSU/zm/hOaOqp5yldl8Kh4=;
        b=okZDLQ1uMgTgORXIMFlzrQ5H2wGsXFf3qpQussFToEemTivbV1ug3vWXttiJZl5yEm
         MxTds2qBdrUaT6mbI1P7SnCAjU3jQsDREAePorqEvM3WqSd63lLg9DiszH3fUKDMSauf
         s8/GSJNxvTdmyaM/fncZH4wsk9cDlPy7o9eazgsWACXU3ETKoEVbmPAhlV0Y5njYfvB9
         hp1xn6aaHZec1VqmRKBpjGqi3NTSuA9kLyRRUz17D9e6tuu6xUoDnJ9w8sgn7Kzv0h7l
         KC2xg+FNS6ERdSsqpX75+2HKD6XFME72f5WlJiVsm/c0KmAPuQue9jU1v40tl1ivn1d7
         0eYA==
X-Gm-Message-State: AOAM533xwgYoeDB8HU12DopCuK/tr20t0zy+GT4JpNc2NA75kapOXhrH
        MpRVb12UuJr++6PYadhrqXGntZY798Y=
X-Google-Smtp-Source: ABdhPJyPWUsJQnLJ9IB1clqTOPCIPkmjxYTBl31rkmS1YAk+YxhAVtAlYH372AuV/RvCA3qQEdAWfg==
X-Received: by 2002:a54:4688:: with SMTP id k8mr4069403oic.70.1635347309290;
        Wed, 27 Oct 2021 08:08:29 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bb13sm110790oob.21.2021.10.27.08.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 08:08:28 -0700 (PDT)
Message-ID: <f9f4dbfa-81aa-f88f-3e06-bd29acc25b19@gmail.com>
Date:   Wed, 27 Oct 2021 09:08:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH net-next 3/4 v4] amt: add multicast(IGMP) report message
 handler
Content-Language: en-US
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, netdev@vger.kernel.org
Cc:     dkirjanov@suse.de
References: <20211026151016.25997-1-ap420073@gmail.com>
 <20211026151016.25997-4-ap420073@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211026151016.25997-4-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 9:10 AM, Taehee Yoo wrote:
> +static bool amt_status_filter(struct amt_source_node *snode,
> +			      enum amt_filter filter)
> +{

How about:
	bool rc = false;

and then

> +	switch (filter) {
> +	case AMT_FILTER_FWD:
> +		if (snode->status == AMT_SOURCE_STATUS_FWD &&
> +		    snode->flags == AMT_SOURCE_OLD)
> +			rc = true;
> +		break;
similar change for the rest of the cases.

> +	case AMT_FILTER_D_FWD:
> +		if (snode->status == AMT_SOURCE_STATUS_D_FWD &&
> +		    snode->flags == AMT_SOURCE_OLD)
> +			return true;
> +		else
> +			return false;
> +	case AMT_FILTER_FWD_NEW:
> +		if (snode->status == AMT_SOURCE_STATUS_FWD &&
> +		    snode->flags == AMT_SOURCE_NEW)
> +			return true;
> +		else
> +			return false;
> +	case AMT_FILTER_D_FWD_NEW:
> +		if (snode->status == AMT_SOURCE_STATUS_D_FWD &&
> +		    snode->flags == AMT_SOURCE_NEW)
> +			return true;
> +		else
> +			return false;
> +	case AMT_FILTER_ALL:
> +		return true;
> +	case AMT_FILTER_NONE_NEW:
> +		if (snode->status == AMT_SOURCE_STATUS_NONE &&
> +		    snode->flags == AMT_SOURCE_NEW)
> +			return true;
> +		else
> +			return false;
> +	case AMT_FILTER_BOTH:
> +		if ((snode->status == AMT_SOURCE_STATUS_D_FWD ||
> +		     snode->status == AMT_SOURCE_STATUS_FWD) &&
> +		    snode->flags == AMT_SOURCE_OLD)
> +			return true;
> +		else
> +			return false;
> +	case AMT_FILTER_BOTH_NEW:
> +		if ((snode->status == AMT_SOURCE_STATUS_D_FWD ||
> +		     snode->status == AMT_SOURCE_STATUS_FWD) &&
> +		    snode->flags == AMT_SOURCE_NEW)
> +			return true;
> +		else
> +			return false;
> +	default:
> +		return false;
> +	}
> +
> +	return false;
> +}
> +


> +
> +/* If a source timer expires with a router filter-mode for the group of
> + * INCLUDE, the router concludes that traffic from this particular
> + * source is no longer desired on the attached network, and deletes the
> + * associated source record.
> + */
> +static void amt_source_work(struct work_struct *work)
> +{
> +	struct amt_source_node *snode = container_of(to_delayed_work(work),
> +						     struct amt_source_node,
> +						     source_timer);
> +	struct amt_group_node *gnode = snode->gnode;
> +	struct amt_dev *amt = gnode->amt;
> +	struct amt_tunnel_list *tunnel;
> +
> +	tunnel = gnode->tunnel_list;
> +	spin_lock_bh(&tunnel->lock);
> +	rcu_read_lock();
> +	if (gnode->filter_mode == MCAST_INCLUDE) {
> +		amt_destroy_source(snode);
> +		if (!gnode->nr_sources)
> +			amt_del_group(amt, gnode);
> +	} else {
> +/* When a router filter-mode for a group is EXCLUDE, source records are
> + * only deleted when the group timer expires
> + */

comment needs to be indented.

> +		snode->status = AMT_SOURCE_STATUS_D_FWD;
> +	}
> +	rcu_read_unlock();
> +	spin_unlock_bh(&tunnel->lock);
> +}
> +


