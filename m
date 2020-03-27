Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22E8194E8B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 02:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgC0Bhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 21:37:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41470 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgC0Bhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 21:37:31 -0400
Received: by mail-pf1-f196.google.com with SMTP id z65so3709765pfz.8;
        Thu, 26 Mar 2020 18:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EdXRfHfjBo+blE/9QsRok/ng6R1Kkf21ejKGHH5Nung=;
        b=r8bsD3op+uVDoxyox4Gc2FcMoo6Wz67YBJBZ7RKli4j7v3YAPlHNG8EGASRVccs90X
         k7qCZCyfzLdsS5ZNMkSp8HgMDSRBRpGzxfPLV5qpWq6vHDk/GeseDk2Ec0XleF7wXFgw
         /43oiWPXjCksD//mxl5ZOZ51TGRKe//6+GYYZNuMfyvSCq59+dO9AXHxbWL+ME25wC/k
         o7gyvCCjV1H8nXO2nGiEzcNEW73xZ3bVPKdjcgyctmzU1Winr76BeO2q38Y/8qunXsGV
         UYTy4LRRGjrvIIWKe27gF4QarGus//7UZ0hQEJxCOEERZ7yoTXR7+/nzMqOeVN9zHRs3
         jRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EdXRfHfjBo+blE/9QsRok/ng6R1Kkf21ejKGHH5Nung=;
        b=Y5AE7ty/VfQtM38ZVGsKnziQRgVJnsdrAgpyo9aEZbbq2AaAU3SpgRF1xVPHyC9gze
         V9SOriW37tuK7rqj7MI2jGJpjSNWReOPy216AbQB+L+pEB8W3/l2bocjGjT40F5Jib0Q
         A0ZwM5uPYT7uOtU3ZsaDsernEoGn0NIWPFrcQ7ST3RBATM8Kxkpm5h9di8H55B06AoB5
         0KCyBzITZY4W/TO7uQ5nBDGYJ5/KX7bRJbph5T6mUBcbKrZvpN4mMpjVVSEr5zqPAM9N
         OVYql+L2N6hC9DG32Pk8iyxPayDLSQHatSmL3l/O/OXU43J2VOQ+APrXHIHKFyd25rJq
         6jLg==
X-Gm-Message-State: ANhLgQ1lSPhj0ASfR+u7gI9IvK0EtKcmuVzi4EoB7NYM7vie//xUxdb9
        3KqIfgHdnAp1YlSp9HZX2W8aM6NX
X-Google-Smtp-Source: ADFU+vvfzIPDhNXRWNWYkZZp+31cqYgSs7tFqxEonAvMMM9l1cB+voeuADHexO8BEFheTXrqySPkvQ==
X-Received: by 2002:a63:a55d:: with SMTP id r29mr11798692pgu.248.1585273050121;
        Thu, 26 Mar 2020 18:37:30 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id e187sm2632983pfe.143.2020.03.26.18.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 18:37:29 -0700 (PDT)
Date:   Thu, 26 Mar 2020 18:37:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        netdev <netdev@vger.kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 08/11] net: ethernet: ti: cpts: move rx
 timestamp processing to ptp worker only
Message-ID: <20200327013727.GD9677@localhost>
References: <20200320194244.4703-1-grygorii.strashko@ti.com>
 <20200320194244.4703-9-grygorii.strashko@ti.com>
 <20200324134343.GD18149@localhost>
 <13dd9d58-7417-2f39-aa7d-dceae946482c@ti.com>
 <20200324165414.GA30483@localhost>
 <7fe92a12-798b-c008-5578-b34411717c5e@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe92a12-798b-c008-5578-b34411717c5e@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 01:15:45PM +0200, Grygorii Strashko wrote:
> I did additional testing and will drop this patch.
> Any other comments from you side?

I made a few minor comments.  Overall the series looks good.
For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
