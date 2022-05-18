Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792F552C754
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiERXLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 19:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiERXLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 19:11:15 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6E13E1D
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 16:11:13 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id m1so3306945qkn.10
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 16:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4aaJAiKF0NpBJNKbPi8C9kHnK+9ppz9wLqAxbueWtPg=;
        b=jM4mp0oF6W9hVvuytmkBjo1KC8VpIsCoWscqjQBXA83D193XgeHHbW9BzKmoznDyAa
         dVKv+Yxj01pljgdxQaTjgsML+znq6RYXp9n1C2+WBrLKNZFzhWknLodeb18QDVUjsWON
         c/ekgiQ8IqQQ1y2JjGxEW2thRdlD5fjJWwEpZWOg7Xs0ZfM3foboZ7f0RoZlCYH4sxKZ
         GvQjJ4RQhxmKTScybt0jJy61HyZwtxzLiry/H/RsahjP56dXNkf6ZZO6OWAlTCLWNHmJ
         cRkfeAspfAJU/sSA7jGxU7N7PIpIbXzzxHg5QN6OWqMjCBbBW9c3qjdUQkt7SAFlzjBG
         T4Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4aaJAiKF0NpBJNKbPi8C9kHnK+9ppz9wLqAxbueWtPg=;
        b=an3/v0+ucZL5+ZiF0WWUeLuEAhtOvO7lK3/UB+l7Pg4FW95uAGnW8zsgr2EEEMVET/
         L8M6DBZm/FhRkEJowsuv32VGxs2I9O/5JOzhkhqtPaZRUs8jbr+NDzoTMHF2L72JmZk9
         lDIO5zh04NSkmsB8+GNdLO8U3hIy1ohwsqAcrkzCL+7tevaP350idJKfnO+JnAUFMAxl
         hekcjX+IQBbMdnEUuAo9S2N5yARUUR84OKDlURfTEfzU3lXmE1rAQKIwHIUcgGEYpy1U
         Wrkh2nD29WCs2LNKqVS1Vs/9dIE6ShipmtT6l08V2d8S9+l0uRX0qb8WJ4SFfmST9wyn
         1tMg==
X-Gm-Message-State: AOAM531uRDKrj1cDvsAQU5MwxUWOFCdbM7fx5wXO+zJFsBeQnYcqfe2U
        C9Qi4C5lJZRXvHhBTcEcaQKr1Q==
X-Google-Smtp-Source: ABdhPJys+8TIIBz9T4KGonaHQ0ArC8/aiNnL0IHXOlTPzOP+aQZNbqmfQBm+YU3N5sRThG8AXIKV7w==
X-Received: by 2002:a05:620a:4447:b0:6a0:3693:8cad with SMTP id w7-20020a05620a444700b006a036938cadmr1356713qkp.742.1652915472889;
        Wed, 18 May 2022 16:11:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id t16-20020ac86a10000000b002f39b99f6a0sm345029qtr.58.2022.05.18.16.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 16:11:12 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1nrSox-008hIQ-6t; Wed, 18 May 2022 20:11:11 -0300
Date:   Wed, 18 May 2022 20:11:11 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ajay Sharma <sharmaajay@microsoft.com>
Cc:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 05/12] net: mana: Set the DMA device max
 page size
Message-ID: <20220518231111.GQ63055@ziepe.ca>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
 <1652778276-2986-6-git-send-email-longli@linuxonhyperv.com>
 <20220517145949.GH63055@ziepe.ca>
 <PH7PR21MB3263EFA8F624F681C3B57636CECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220517193515.GN63055@ziepe.ca>
 <PH7PR21MB3263C44368F02B8AF8521C4ACECE9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <20220518000356.GO63055@ziepe.ca>
 <BL1PR21MB3283790E8270ED6C639AAB0DD6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
 <20220518160525.GP63055@ziepe.ca>
 <BL1PR21MB32831207F674356EAF8EE600D6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR21MB32831207F674356EAF8EE600D6D19@BL1PR21MB3283.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 09:05:22PM +0000, Ajay Sharma wrote:

> Use the ib_umem_find_best_pgsz() and rdma_for_each_block() API when
> registering an MR instead of coding it in the driver.

The dma_set_max_seg_size() has *nothing* to do with
ib_umem_find_best_pgsz() other than its value should be larger than
the largest set bit.

Again, it is supposed to be the maximum value the HW can support in a
ib_sge length field, which is usually 2G.

Jason
