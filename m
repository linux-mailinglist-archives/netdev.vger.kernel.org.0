Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2A5626E8
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 01:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiF3XNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 19:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbiF3XNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 19:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C2BC59274
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656630769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NJTz6TTYPiibEbFrJGuunU84ZTQOGySwDHV3J5pRPec=;
        b=W2bxRheMoL+15+COMb56/Y5XcvJsbxhGXwI4ieZTbiCxZ2Z2Phg+qC6wg9M7GUOOvaW0ui
        DeF90svPr7LJSm3PvgnLS3t4L/xjmY+EO69SEnNXytYulMtI2PtEF8UAIKEgKTZRGku2N1
        Ye8PLXpf0jKv39M/X53mCf+ypPgWUuE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-OLeDcKxRMl2cXRqzsg1Pyw-1; Thu, 30 Jun 2022 19:12:48 -0400
X-MC-Unique: OLeDcKxRMl2cXRqzsg1Pyw-1
Received: by mail-wm1-f70.google.com with SMTP id r4-20020a1c4404000000b003a02fa133ceso182042wma.2
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NJTz6TTYPiibEbFrJGuunU84ZTQOGySwDHV3J5pRPec=;
        b=bQtmdmZQr6AF1x9jJEJm+wZOZTa/YsxhWwzl51miVNE27I32TxP+3apR1tt220lPg8
         yqIOcEy0mwONCGS9ikAW+hWziNtCO88+GXPlJxu+TVuRlUrtNir0ITD1yr+l3nUkpmyZ
         wgV7Y7uLb8a9D2sYeeN1CTzzmUNcD7PcOSDK5Vf+8IuK8/WlbCqvfeKH56QYV8v4TqR4
         LaI/THWGOKOzJbZDo6OH5AQwl+pcX8h1DdqVVNxn6j/0RmmUQUV5wIKBBhG2gj3dbHjF
         34FglWEaPPF3Y08WBcv9/i/sf4FFiBXE4xyl5/K+v9dAA8khjU6KjYbhDWiO+UeLGpoo
         OIWg==
X-Gm-Message-State: AJIora8tsmoTYG5RdOgP7adyGZgMYOaldbykFsfEw20mOZ2IXnCI5rNe
        AJL+txGNdF+O4yyjvlhNcbMFS4et+YXBvY1WhQR18ysROrOAV52Nw0YZbPkrx5g87xgmBilHQkk
        n45b/W4JG9eb8LtBm
X-Received: by 2002:a7b:cc96:0:b0:3a0:4aa0:f053 with SMTP id p22-20020a7bcc96000000b003a04aa0f053mr15132039wma.89.1656630767286;
        Thu, 30 Jun 2022 16:12:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tzGEeKpPU2QJgFZfBZfnbC6qNg00CZfwhz9y7HZ3IRo/29uWs68Y3WtOkZ3zJ7mM9fGlZ/Ow==
X-Received: by 2002:a7b:cc96:0:b0:3a0:4aa0:f053 with SMTP id p22-20020a7bcc96000000b003a04aa0f053mr15132007wma.89.1656630767121;
        Thu, 30 Jun 2022 16:12:47 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id d10-20020adff2ca000000b0021a38089e99sm20545676wrp.57.2022.06.30.16.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 16:12:46 -0700 (PDT)
Date:   Fri, 1 Jul 2022 01:12:44 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, kuba@kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, kurt@linutronix.de, pablo@netfilter.org,
        pabeni@redhat.com, paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com, mostrows@earthlink.net,
        paulus@samba.org
Subject: Re: [RFC PATCH net-next v3 4/4] ice: Add support for PPPoE hardware
 offload
Message-ID: <20220630231244.GC392@debian.home>
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
 <20220629143859.209028-5-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629143859.209028-5-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 04:38:59PM +0200, Marcin Szycik wrote:
> Add support for creating PPPoE filters in switchdev mode. Add support
> for parsing PPPoE and PPP-specific tc options: pppoe_sid and ppp_proto.
> 
> Example filter:
> tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
>     1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR
> 
> Changes in iproute2 are required to use the new fields.
> 
> ICE COMMS DDP package is required to create a filter as it contains PPPoE
> profiles. Added a warning message when loaded DDP package does not contain
> required profiles.
> 
> Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
> will add this feature.
> 
> [0] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220420210048.5809-1-martyna.szapar-mudlaw@intel.com

Out of curiosity, can ice direct PPPoE Session packets to different
queues with RSS (based on the session ID)?

