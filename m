Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5865F4EDC39
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbiCaPBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 11:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiCaPBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 11:01:00 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447A6DCA9E;
        Thu, 31 Mar 2022 07:59:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mp11-20020a17090b190b00b001c79aa8fac4so3306932pjb.0;
        Thu, 31 Mar 2022 07:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bD8rMGk/tZWxT71BF804kfMU81gRaeK1q4kG+IQas9w=;
        b=XgLNnLcqnqgbtibLMmxAs2TBoL9T87JQhU9eBVwGCSBiTNFiR1f+bXSMdcTp03JpVf
         sDc8BUBUlV6L/KNvZP71IY4VwMMyIB/UbZaX2YmNxzmgvz/0s/toMGNqiZ1lXDp8q8CI
         n9HmNIx6CXG19lBD28SEyoNNYtvocxuUQnlSXVkywIdCVP0IInXrY/LNFxdcns03+AwH
         3LkcO9XXiWP05EJbebrWVAHhWRmbPDFWbLPVNXds+ffXdSyYdbxFLCmyzWJEtIQXeR9N
         wPu+H3IIVOMcKQNTJ+MzqP6TPWLU9nPiAbjBUZdOtzVJowB//YAjWj+fMCGgEpzo1MFd
         lC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bD8rMGk/tZWxT71BF804kfMU81gRaeK1q4kG+IQas9w=;
        b=8GWFbKFcJvsHKxubYXzhlAU7II5ajwNmrvnsowm6mLBx1r2azezbsN4JB1z05gTgXG
         3eGOienc1Q3/isPQG65Zucf9DIEwWRm2tmIO15kZ+6An/M87U/Pw4rnujHc35o7CHIWO
         6d86MS22vhFhRDKGwJ0H5C4gAspFgUbLtsfLv4Z//GWKjg6WFhhAW5kEFcaSmimhINBw
         p0Nd8vfqcFycEkakTZO+iNLrO1jepkkWErPEBLbY8YwSiEe0k3XQITwvhtGRzM7O1oxX
         K+Km1TijBSu/o+GO0yi0AMInxQYIagtvKCxF33fOGIm1cv0EmHPVpWE8X4ZESM+d5Bhb
         4drg==
X-Gm-Message-State: AOAM531kgK2g+LMvbDrQS92db1i+w/6ZbLAuxQbmR2UOsjoarEebnXCW
        buybYm+ZscZAVbanuNdBn2w=
X-Google-Smtp-Source: ABdhPJwzKetAlW05Y8IjshZGFfJZJU3IDJvLbDV2zSFkLYo3ZNm3VeGHM7hZaz+yZj1haqAX3hi5AA==
X-Received: by 2002:a17:90b:3e8c:b0:1c7:462c:af6b with SMTP id rj12-20020a17090b3e8c00b001c7462caf6bmr6596432pjb.150.1648738752645;
        Thu, 31 Mar 2022 07:59:12 -0700 (PDT)
Received: from localhost.lan (p9254142-ipngn10701marunouchi.tokyo.ocn.ne.jp. [180.57.16.142])
        by smtp.gmail.com with ESMTPSA id a17-20020a62e211000000b004faa5233213sm26458352pfi.101.2022.03.31.07.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 07:59:12 -0700 (PDT)
Received: from localhost (localhost [IPv6:::1])
        by localhost.lan (Postfix) with ESMTPSA id 1A017900EF4;
        Thu, 31 Mar 2022 14:59:10 +0000 (GMT)
Date:   Thu, 31 Mar 2022 14:59:09 +0000
From:   Vincent Pelletier <plr.vincent@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 2/5] netfilter: conntrack: sanitize table size
 default settings
Message-ID: <20220331145909.085a0f30@gmail.com>
In-Reply-To: <20210903163020.13741-3-pablo@netfilter.org>
References: <20210903163020.13741-1-pablo@netfilter.org>
        <20210903163020.13741-3-pablo@netfilter.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri,  3 Sep 2021 18:30:17 +0200, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> conntrack has two distinct table size settings:
> nf_conntrack_max and nf_conntrack_buckets.
> 
> The former limits how many conntrack objects are allowed to exist
> in each namespace.
> 
> The second sets the size of the hashtable.
> 
> As all entries are inserted twice (once for original direction, once for
> reply), there should be at least twice as many buckets in the table than
> the maximum number of conntrack objects that can exist at the same time.
> 
> Change the default multiplier to 1 and increase the chosen bucket sizes.
> This results in the same nf_conntrack_max settings as before but reduces
> the average bucket list length.
[...]
>  		nf_conntrack_htable_size
>  			= (((nr_pages << PAGE_SHIFT) / 16384)
>  			   / sizeof(struct hlist_head));
> -		if (nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
> -			nf_conntrack_htable_size = 65536;
> +		if (BITS_PER_LONG >= 64 &&
> +		    nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
> +			nf_conntrack_htable_size = 262144;
>  		else if (nr_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
> -			nf_conntrack_htable_size = 16384;
[...]
> +			nf_conntrack_htable_size = 65536;

With this formula, there seems to be a discontinuity between the
proportional and fixed regimes:
64bits: 4GB/16k/8 = 32k, which gets bumped to 256k
32bits: 1GB/16k/4 = 16k, which gets bumped to 64k

Is this intentional ?

The background for my interest in this formula comes from OpenWRT:
low-RAM devices intended to handle a lot of connections, which led
OpenWRT to use sysctl to increase the maximum number of entries in this
hash table compared to what this formula produces.
Unfortunately, the result is that not-so-low-RAM devices running
OpenWRT get the same limit as low-RAM devices, so I am trying to tweak
the divisor in the first expression and getting rid of the sysctl call.
But then I am failing to see how I should adapt the expressions in
these "if"s blocks.

If they were maximum sizes (say, something like
nf_conntrack_htable_size = max(nf_conntrack_htable_size, 256k)), I
would understand, but I find this discontinuity surprising.

Am I missing something ?

For reference, this change is
  commit d532bcd0b2699d84d71a0c71d37157ac6eb3be25
in Linus' tree.

Regards,
-- 
Vincent Pelletier
GPG fingerprint 983A E8B7 3B91 1598 7A92 3845 CAC9 3691 4257 B0C1
