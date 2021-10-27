Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB35043CE8A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbhJ0QUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbhJ0QUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 12:20:01 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49092C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 09:17:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id h193so3433846pgc.1
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 09:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XP5mHd2FViJSWEoGH1lXskeJKznXpgQNroUOJoexVO4=;
        b=KewHQo8BEFHttzM274mTS+9FNgxq5fU6Pm4k5j0x/MsuLUHPLbhB0l2evl6e1Fzuo/
         Mu1npmfbyASQam6AtWs6Yr83gx6W5pl0GnESXQzU+rW69ItErVpzaVMVMAbAZeYEC5Kt
         4XpSGprM7xiqYkTLbr4axkXgTM+dNrVxeBypvbPetbmRguSUvaVY87R2WEK1Q3PuvDYr
         ZAVgh+dkRpAd/wvH/Y/D2WNkozhSUvjKanH2c6I1sHJa9o/Dn24P/7o/Iv+bca/aERnk
         MlbzPNx96QBWaSuRWNgzYVXaZj8tvrIxavY6tBDEi6cMXEn65VSG0VO6VPUq+odFeyYt
         SFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XP5mHd2FViJSWEoGH1lXskeJKznXpgQNroUOJoexVO4=;
        b=7XQmY9VLAt5qUMWlObnuPfyhQEMFvSfOYYH4PmYDrwnl0yW3nE08+y6yx520dAUXbs
         PFHfGcniGULCoUq04V4YOQ7HbchfLd0DBWGUw5ZavvvJkig/N65bCyDkOCT3j6V6DdF+
         iMjrO8kB+UgjMJ7r2D3JszmG6ctn+kVuAsQUMDcLHA247U10I7/x19tBnrZNSWSHR5KG
         r3yVCDic7XBVQhbR/ayTqrgvxUF/lH+OuuCdIvFtob8OpFz6K55/hP1rroxeUra/cn9T
         +lmPdZJgJHYFO2SEx+ZLhmfssiza54Da5TQRn9YC9RXZ/O3OYtw+nU4IQRApz/MneI4W
         4t2A==
X-Gm-Message-State: AOAM532ncokRwyH/wKT64riDBB/5uMWTHf20cXWOzS68ZwvnUJD+V/j3
        QvKKvNfmyBy7t5z0iTgg6FW01VphsZ6GQg==
X-Google-Smtp-Source: ABdhPJzab/FTai2ZMpVXKYgaHUFy9u76KTmEgJp0KocENWsQQlXFC8EjYrNogzST0v/KCFfA30akNw==
X-Received: by 2002:aa7:96f8:0:b0:47b:eb13:e0b6 with SMTP id i24-20020aa796f8000000b0047beb13e0b6mr22821377pfq.27.1635351455854;
        Wed, 27 Oct 2021 09:17:35 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id h14sm457491pfv.182.2021.10.27.09.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 09:17:35 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4 v4] amt: add multicast(IGMP) report message
 handler
To:     David Ahern <dsahern@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, dsahern@kernel.org, netdev@vger.kernel.org
Cc:     dkirjanov@suse.de
References: <20211026151016.25997-1-ap420073@gmail.com>
 <20211026151016.25997-4-ap420073@gmail.com>
 <f9f4dbfa-81aa-f88f-3e06-bd29acc25b19@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <9762b3a4-6d72-e5ce-e2bd-aa5deedfc686@gmail.com>
Date:   Thu, 28 Oct 2021 01:17:32 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f9f4dbfa-81aa-f88f-3e06-bd29acc25b19@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,
Thank you for your review!

On 10/28/21 12:08 AM, David Ahern wrote:
 > On 10/26/21 9:10 AM, Taehee Yoo wrote:
 >> +static bool amt_status_filter(struct amt_source_node *snode,
 >> +			      enum amt_filter filter)
 >> +{
 >
 > How about:
 > 	bool rc = false;
 >
 > and then
 >
 >> +	switch (filter) {
 >> +	case AMT_FILTER_FWD:
 >> +		if (snode->status == AMT_SOURCE_STATUS_FWD &&
 >> +		    snode->flags == AMT_SOURCE_OLD)
 >> +			rc = true;
 >> +		break;
 > similar change for the rest of the cases.
 >

Thanks, I will use it.

 >> +	case AMT_FILTER_D_FWD:
 >> +		if (snode->status == AMT_SOURCE_STATUS_D_FWD &&
 >> +		    snode->flags == AMT_SOURCE_OLD)
 >> +			return true;
 >> +		else
 >> +			return false;
 >> +	case AMT_FILTER_FWD_NEW:
 >> +		if (snode->status == AMT_SOURCE_STATUS_FWD &&
 >> +		    snode->flags == AMT_SOURCE_NEW)
 >> +			return true;
 >> +		else
 >> +			return false;
 >> +	case AMT_FILTER_D_FWD_NEW:
 >> +		if (snode->status == AMT_SOURCE_STATUS_D_FWD &&
 >> +		    snode->flags == AMT_SOURCE_NEW)
 >> +			return true;
 >> +		else
 >> +			return false;
 >> +	case AMT_FILTER_ALL:
 >> +		return true;
 >> +	case AMT_FILTER_NONE_NEW:
 >> +		if (snode->status == AMT_SOURCE_STATUS_NONE &&
 >> +		    snode->flags == AMT_SOURCE_NEW)
 >> +			return true;
 >> +		else
 >> +			return false;
 >> +	case AMT_FILTER_BOTH:
 >> +		if ((snode->status == AMT_SOURCE_STATUS_D_FWD ||
 >> +		     snode->status == AMT_SOURCE_STATUS_FWD) &&
 >> +		    snode->flags == AMT_SOURCE_OLD)
 >> +			return true;
 >> +		else
 >> +			return false;
 >> +	case AMT_FILTER_BOTH_NEW:
 >> +		if ((snode->status == AMT_SOURCE_STATUS_D_FWD ||
 >> +		     snode->status == AMT_SOURCE_STATUS_FWD) &&
 >> +		    snode->flags == AMT_SOURCE_NEW)
 >> +			return true;
 >> +		else
 >> +			return false;
 >> +	default:
 >> +		return false;
 >> +	}
 >> +
 >> +	return false;
 >> +}
 >> +
 >
 >
 >> +
 >> +/* If a source timer expires with a router filter-mode for the group of
 >> + * INCLUDE, the router concludes that traffic from this particular
 >> + * source is no longer desired on the attached network, and deletes the
 >> + * associated source record.
 >> + */
 >> +static void amt_source_work(struct work_struct *work)
 >> +{
 >> +	struct amt_source_node *snode = container_of(to_delayed_work(work),
 >> +						     struct amt_source_node,
 >> +						     source_timer);
 >> +	struct amt_group_node *gnode = snode->gnode;
 >> +	struct amt_dev *amt = gnode->amt;
 >> +	struct amt_tunnel_list *tunnel;
 >> +
 >> +	tunnel = gnode->tunnel_list;
 >> +	spin_lock_bh(&tunnel->lock);
 >> +	rcu_read_lock();
 >> +	if (gnode->filter_mode == MCAST_INCLUDE) {
 >> +		amt_destroy_source(snode);
 >> +		if (!gnode->nr_sources)
 >> +			amt_del_group(amt, gnode);
 >> +	} else {
 >> +/* When a router filter-mode for a group is EXCLUDE, source records are
 >> + * only deleted when the group timer expires
 >> + */
 >
 > comment needs to be indented.
 >

Okay, I will fix it.

 >> +		snode->status = AMT_SOURCE_STATUS_D_FWD;
 >> +	}
 >> +	rcu_read_unlock();
 >> +	spin_unlock_bh(&tunnel->lock);
 >> +}
 >> +
 >
 >

Thanks a lot for your reviews.
I will fix these things and send v2 patch.

Thanks,
Taehee
