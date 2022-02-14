Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B584B5E71
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 00:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbiBNXwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 18:52:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiBNXwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 18:52:17 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D821221829
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:52:08 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z17so11742124plb.9
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 15:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lze8zeCGx3ibjslk2q3+r08wILlAYkXte9s79qWoM60=;
        b=kc27rM0wR0BoL9F+CRCgKVii8ZwHP2nWAqh1rqWvkjYGks++8YonuSj0JJ/SA6As7R
         FdTMoVnYI4a225epOxZhAAndDm0W6lqKF0kO0CHUrtq1lQ5c3euSk9KSvfJ3SajpPXsj
         b76/DGZ+GPaSIiHYFsRICW9tex3YlAkeQSqKBfV+GiCEhPD6UvubnCAooH/1ay+LsHzI
         Up1DTuuByRhfgM8Uw2ZusZ0viau6CSzcF5pfcW/1bS9W3aVK96P6X5XKno0OpUH/sfF6
         KNJPq6eEBOCQECZTTU3jPZA/t6VCP9sJzjJNX0MszF7ThdELmr6P9U4aBxulm6WZGv8E
         mdPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lze8zeCGx3ibjslk2q3+r08wILlAYkXte9s79qWoM60=;
        b=iEe1SPvOBnglFrZMxGKmYb5mXmEsq4S+bAAYuttBu/HFm8dessQSivKZuCqGly3tvr
         wLk2PSgcHLEFWvGLuA6nqXS2D+rJvhJ1NdRfBaqBpr+A8CuDU6rA365RbDUg6ULq5N9v
         VumZSsVE9dMtC+z6Bi6sS1/x1u62LXxFKb3x2CbzGQqtrgzNI8QYmK4olFJ7u6lzLyke
         g7zyGqThCp6D3y9qsvNyx8QNVaCDs37L5nNXLz6hwiLnxHhuABs3NrEnYE2B2DvKrlEp
         XSYVYHltKcOQCf5GvK+qu8zYgq8Ei6QcqS2302pWsJ4hJOGsDvYoAydceGjTw+yuPD2Z
         Ss3w==
X-Gm-Message-State: AOAM531bl63b9fR48GRi3FJDqA7s2/aKNXk68fO55WbSTB1HqmsX9mSO
        4BXTMMN7ya6ePW+3F8jZ6mKFyA==
X-Google-Smtp-Source: ABdhPJz43mhynG4v1HlXFRRO1FBm29xTV3+LndvsdOLx0+UoylxPWyou17gqzaKKm8uGwuyIv5HGiw==
X-Received: by 2002:a17:903:110c:: with SMTP id n12mr1501952plh.166.1644882728293;
        Mon, 14 Feb 2022 15:52:08 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id d16sm30871177pfj.1.2022.02.14.15.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 15:52:07 -0800 (PST)
Date:   Mon, 14 Feb 2022 15:52:05 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: bridge: vlan: check for errors from
 __vlan_del in __vlan_flush
Message-ID: <20220214155205.22135ebb@hermes.local>
In-Reply-To: <20220214233646.1592855-1-vladimir.oltean@nxp.com>
References: <20220214233646.1592855-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 01:36:46 +0200
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> +		if (err) {
> +			br_err(br,
> +			       "port %u(%s) failed to delete vlan %d: %pe\n",
> +			       (unsigned int) p->port_no, p->dev->name,
> +			       vlan->vid, ERR_PTR(err));

Don't understand this last argument here.
It takes an integer error number, then converts it to an error pointer
just so the error message can then decode with %pe? Why?

