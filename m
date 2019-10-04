Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03DD3CC1EB
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388428AbfJDRmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:42:24 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:38619 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387428AbfJDRmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 13:42:24 -0400
Received: by mail-qt1-f182.google.com with SMTP id j31so9663029qta.5
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 10:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CGQibz/G+Bzinb9EGCxDbBtL8/OLxBef6EyczHB3Ek8=;
        b=rRCDJ2e6cNcOaso3I3RAgr343YYPJHcxMWAeEvbice9eNgCj9mZj1wg/nXVNvpsGJr
         vR7yONyZ1YEKy9H5vgKYXcEqFXHFlA6vSjfuGKF8XKJ4TYyZUdLiIe1DTeWx9ikGPuTy
         LlJ5MQm+/I6mb8VK+9TbHKv1gyEM299NNxEQetxx4gmCKwB3b6aBL6FualW2PQuh0BDy
         j1XOUSM4IJg2p/X6B/j9gvjD6DEGFnK9Zw3KqPFKxN/mTbDuO34RLrU6WR5VgLA5dmDA
         ucc5yBArqe8XgQ76z82Z4HI3aeQXrVKdBKO6I6c4OmTpUzMCKW/eBbtQIiCNR+Qqhk/o
         H1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CGQibz/G+Bzinb9EGCxDbBtL8/OLxBef6EyczHB3Ek8=;
        b=iqxlGZinKTSoDc/a5V6ZBd9KKb3f3qXjdDpd7hvMcT/OcWYaEAsLW4JA1v2ePDnu5W
         EwjP3V8nl+bwFIL6u9yfVs0dKH/H8bCEf02cbr6WH9WKhirp31BY9hOZtZTjtYj1HMzL
         DJVGSzyRMDhKXV4wA15qS7goC3sJs/aTNKlj1pMbv2vC8qrSZ39XY0GJ0sIFvISIEjMR
         huTE93isjFUPa1pqe4TotQKDSUs5iivu6q/5AmAy2voI4CIcjbWDR0EopaYDIUSziGlm
         jVNAr051KEQeCHp/D/jOOklcFGnw+JLOQhNC+GtB7bHk835IwXU0ZBr8cALXSQkBFyp7
         S4Mg==
X-Gm-Message-State: APjAAAU6ButkhjE3oGo5pSB7P/YGBYcxHAR8sv4gyP3PZ4cCIg5E0IYZ
        iKgSxjObvB6ArICQbBfhWm+qCw==
X-Google-Smtp-Source: APXvYqzIcjfag5BKsxFA5rOT5vO2ElYaWHraQ7CMfvtdrRXQWfK/lNbIGWwJDX/MqfNphytrGz53Sw==
X-Received: by 2002:ac8:41ca:: with SMTP id o10mr16839676qtm.352.1570210943128;
        Fri, 04 Oct 2019 10:42:23 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o124sm3483751qke.66.2019.10.04.10.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 10:42:22 -0700 (PDT)
Date:   Fri, 4 Oct 2019 10:42:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 11/15] netdevsim: implement proper devlink
 reload
Message-ID: <20191004104217.23ec4a0d@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191004061914.GA2264@nanopsycho>
References: <20191003094940.9797-1-jiri@resnulli.us>
        <20191003094940.9797-12-jiri@resnulli.us>
        <20191003161730.6c61b48c@cakuba.hsd1.ca.comcast.net>
        <20191004061914.GA2264@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Oct 2019 08:19:14 +0200, Jiri Pirko wrote:
> >> @@ -84,20 +82,10 @@ int nsim_fib_set_max(struct nsim_fib_data *fib_data,
> >>  		entry = &fib_data->ipv6.rules;
> >>  		break;
> >>  	default:
> >> -		return 0;
> >> -	}
> >> -
> >> -	/* not allowing a new max to be less than curren occupancy
> >> -	 * --> no means of evicting entries
> >> -	 */
> >> -	if (val < entry->num) {
> >> -		NL_SET_ERR_MSG_MOD(extack, "New size is less than current occupancy");
> >> -		err = -EINVAL;  
> >
> >This change in behaviour should perhaps be mentioned in the commit
> >message. The reload will no longer fail if the resources are
> >insufficient.   
> 
> Reload is going to fail if the resources are insufficient. I have a
> selftest for that, please see the last patch.

Oh, because re-registering the fib notifier itself will fail? 
All good then, thanks.

> >Since we want to test reload more widely than just for the FIB limits
> >that does make sense to me. Is that the thinking?
