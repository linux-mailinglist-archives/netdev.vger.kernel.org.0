Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EED4CCF9E
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 09:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiCDIJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 03:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiCDIJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 03:09:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5134CB0EA1
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 00:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646381293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7nW25NF/tKEkz41lufEGliwVBnK2C09c2SMWTt50ne4=;
        b=HdFjOLl8z0ZbwEfdqRucKkAspTlG5oBgisi0PyAzkVYqHTx55blVLJGrDGKDbPDa5py1es
        82E336n7FvgbEDY4kiWsbW91Sa7rbzqTy4TqgTddAid+xsJAkHpzEF0bmnRJYlVIxAriEb
        gNUkTtk9gM80E8ahioWN7LlpbXfzhdM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-1PxYKBjEOy6qS5K9fK4F9w-1; Fri, 04 Mar 2022 03:08:11 -0500
X-MC-Unique: 1PxYKBjEOy6qS5K9fK4F9w-1
Received: by mail-wm1-f70.google.com with SMTP id o207-20020a1ca5d8000000b0038977354e75so534031wme.1
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 00:08:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7nW25NF/tKEkz41lufEGliwVBnK2C09c2SMWTt50ne4=;
        b=bJ7LzV7ryIQYo885/Dx9SCjM0rBH5U0NlIQvM2gzIF1ecHcXPGcRQcG379ae1piNvb
         pD74SkEHc/S6JlUhKUcWqoa8pvI/xKBkTsPX2iqSARLPiwY10q4BOLbahmzTuMI3XgWg
         czp7D9VqI3s4XR+r5ASiGCHCBPKGRjIpzchjZYxT5zks6tLZW6lTBadSCHc1hrDW3QZY
         ewwipoo3v0K6jXcv3PY7D+vt1FvM0QNJNiZqTn61SmV2dAAjcFj7QKqn1+bwr2TF8Xev
         8sHkfR6BwjULwXdIhVxfnMcDvmHO8hVOVZblPRaSS/GaJdfCNa4edr4b1D0JB5J3ZqXT
         SI/g==
X-Gm-Message-State: AOAM532iZx7YBZUiSF/lafOfTLg5oHpHiLBnaOR8W9joGALQqX1ikuQV
        RHSoPeOu3u7rG1h2OHtv1ia7IkbPGwU2gagdGk1orEC+dXJv4pqU4Ol7zsvHKlXKHA1PTMfERUR
        vvdhiFYeHv4xFP5f2
X-Received: by 2002:adf:e2cf:0:b0:1ed:a702:5ef4 with SMTP id d15-20020adfe2cf000000b001eda7025ef4mr28735270wrj.487.1646381290547;
        Fri, 04 Mar 2022 00:08:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzWmNGl/lXwd8sVyeUwFDssSCLl0O441tyUAyHGIlcZJInmk3yIBuPPMjwxBJ7L/Xz8fSDmoQ==
X-Received: by 2002:adf:e2cf:0:b0:1ed:a702:5ef4 with SMTP id d15-20020adfe2cf000000b001eda7025ef4mr28735251wrj.487.1646381290279;
        Fri, 04 Mar 2022 00:08:10 -0800 (PST)
Received: from redhat.com ([2.52.16.157])
        by smtp.gmail.com with ESMTPSA id ay23-20020a5d6f17000000b001ea79f73fbcsm3762231wrb.25.2022.03.04.00.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 00:08:09 -0800 (PST)
Date:   Fri, 4 Mar 2022 03:08:04 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Melnychenko <andrew@daynix.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, kbuild-all@lists.01.org, yan@daynix.com,
        yuri.benditovich@daynix.com
Subject: Re: [PATCH v4 3/4] drivers/net/virtio_net: Added RSS hash report.
Message-ID: <20220304030742-mutt-send-email-mst@kernel.org>
References: <20220222120054.400208-4-andrew@daynix.com>
 <202202230342.HPYe6dHA-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202202230342.HPYe6dHA-lkp@intel.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 03:15:28AM +0800, kernel test robot wrote:
> Hi Andrew,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on mst-vhost/linux-next]
> [also build test WARNING on net/master horms-ipvs/master net-next/master linus/master v5.17-rc5 next-20220217]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]


Andrew,
do you plan to fix this?

> url:    https://github.com/0day-ci/linux/commits/Andrew-Melnychenko/RSS-support-for-VirtioNet/20220222-200334
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
> config: i386-randconfig-s002-20220221 (https://download.01.org/0day-ci/archive/20220223/202202230342.HPYe6dHA-lkp@intel.com/config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.4-dirty
>         # https://github.com/0day-ci/linux/commit/4fda71c17afd24d8afb675baa0bb14dbbc6cd23c
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Andrew-Melnychenko/RSS-support-for-VirtioNet/20220222-200334
>         git checkout 4fda71c17afd24d8afb675baa0bb14dbbc6cd23c
>         # save the config file to linux build tree
>         mkdir build_dir
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=i386 SHELL=/bin/bash
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> 
> sparse warnings: (new ones prefixed by >>)
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
>    drivers/net/virtio_net.c:1160:25: sparse: sparse: restricted __le16 degrades to integer
> >> drivers/net/virtio_net.c:1178:35: sparse: sparse: incorrect type in argument 2 (different base types) @@     expected unsigned int [usertype] hash @@     got restricted __le32 const [usertype] hash_value @@
>    drivers/net/virtio_net.c:1178:35: sparse:     expected unsigned int [usertype] hash
>    drivers/net/virtio_net.c:1178:35: sparse:     got restricted __le32 const [usertype] hash_value
> 
> vim +1178 drivers/net/virtio_net.c
> 
>   1151	
>   1152	static void virtio_skb_set_hash(const struct virtio_net_hdr_v1_hash *hdr_hash,
>   1153					struct sk_buff *skb)
>   1154	{
>   1155		enum pkt_hash_types rss_hash_type;
>   1156	
>   1157		if (!hdr_hash || !skb)
>   1158			return;
>   1159	
>   1160		switch (hdr_hash->hash_report) {
>   1161		case VIRTIO_NET_HASH_REPORT_TCPv4:
>   1162		case VIRTIO_NET_HASH_REPORT_UDPv4:
>   1163		case VIRTIO_NET_HASH_REPORT_TCPv6:
>   1164		case VIRTIO_NET_HASH_REPORT_UDPv6:
>   1165		case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
>   1166		case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
>   1167			rss_hash_type = PKT_HASH_TYPE_L4;
>   1168			break;
>   1169		case VIRTIO_NET_HASH_REPORT_IPv4:
>   1170		case VIRTIO_NET_HASH_REPORT_IPv6:
>   1171		case VIRTIO_NET_HASH_REPORT_IPv6_EX:
>   1172			rss_hash_type = PKT_HASH_TYPE_L3;
>   1173			break;
>   1174		case VIRTIO_NET_HASH_REPORT_NONE:
>   1175		default:
>   1176			rss_hash_type = PKT_HASH_TYPE_NONE;
>   1177		}
> > 1178		skb_set_hash(skb, hdr_hash->hash_value, rss_hash_type);
>   1179	}
>   1180	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

