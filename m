Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D289756A534
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 16:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiGGOOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 10:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235234AbiGGOOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 10:14:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C1A52F3A5
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 07:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657203261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iKA2qidqE9pif8xksazqs8JG1hIHW8krOJ1dxi9lmZ8=;
        b=F97WQ0ih57hOiHcfRQZ85dvtfLGuWlDSyV1idzYhdZ3k8vsrAf1jcXhOPGgEtoUB8vOpmk
        Ny5pl9e2IjZUGWMJjr8F7g3C18BBcC2XOLn/p1HJTHij5LehmPw9OZiqOnNNs+474zHUkt
        Gu01uGQYU5HaZyKpGhjD3YFb8ZU4C6Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-tOptrANyOA-Aa8r6ycdNFw-1; Thu, 07 Jul 2022 10:14:20 -0400
X-MC-Unique: tOptrANyOA-Aa8r6ycdNFw-1
Received: by mail-wr1-f70.google.com with SMTP id h29-20020adfaa9d000000b0021d67fc0b4aso2581480wrc.9
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 07:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iKA2qidqE9pif8xksazqs8JG1hIHW8krOJ1dxi9lmZ8=;
        b=b0TPVTrPzzHFNKEMQFOHv2+py8YO7o2AbKxGEDKFqJJEHpUNtJsnTvR4apfTHC7M4m
         bexrNvB3FNiPpNOmpN+PZx5rwAg7sOos9rboST/jBHTS0ED+svBCyybGWZ96nDdzaz7V
         j9CZ66sE/teMpwwd8EyUAACJuWfdDgouu+2KVPNYFEsp9CFZg4HZ0MU1+BaMeCM77DLj
         JP+r8f69Su3kGoGEzGtbWHhXkCEUxvYTKgo0g3u4dGCXTrz640pH9k/6e+nirexC2jZ1
         rJuI2eAg87FxYAh2am0qhMk5qtrN3UvsZkZCgCqZ9JxPIJ/BKvnocddT+ywzOjzl14wh
         3saw==
X-Gm-Message-State: AJIora8dkhWZ7+QEZ3E1IbnsEQOf20mJVzHG1QtL4RjC/vf8DUX2Oun+
        B9oHtWzSA/UUD/MqYYlfSSDR0bRI/gohUwqja3bOhl6oGhbXccUNGadF1ZmE/+6LIldkThHl4fN
        dk84PkFtqNMoqWNMd
X-Received: by 2002:adf:e949:0:b0:21d:89d4:91b3 with SMTP id m9-20020adfe949000000b0021d89d491b3mr2094534wrn.162.1657203259006;
        Thu, 07 Jul 2022 07:14:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t0tC7akjIJ0A2ue8fgkY10fu239iXuCRNeR9TTMvlyyTI5Zl5gI7Am80XPsX5PUO/VLRRMWw==
X-Received: by 2002:adf:e949:0:b0:21d:89d4:91b3 with SMTP id m9-20020adfe949000000b0021d89d491b3mr2094472wrn.162.1657203258587;
        Thu, 07 Jul 2022 07:14:18 -0700 (PDT)
Received: from debian.home (2a01cb058d1194004161f17a6a9ad508.ipv6.abo.wanadoo.fr. [2a01:cb05:8d11:9400:4161:f17a:6a9a:d508])
        by smtp.gmail.com with ESMTPSA id b4-20020a5d6344000000b0021d68a504cbsm12517211wrw.94.2022.07.07.07.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:14:17 -0700 (PDT)
Date:   Thu, 7 Jul 2022 16:14:15 +0200
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
Message-ID: <20220707141415.GB7483@debian.home>
References: <20220629143859.209028-1-marcin.szycik@linux.intel.com>
 <20220629143859.209028-5-marcin.szycik@linux.intel.com>
 <20220630231244.GC392@debian.home>
 <7a706a7e-d3bd-b4da-fa68-2cabf3e75871@linux.intel.com>
 <7aa3a974-6575-ade6-b863-feb25736ec0f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aa3a974-6575-ade6-b863-feb25736ec0f@linux.intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 11:54:08AM +0200, Marcin Szycik wrote:
> 
> 
> On 01-Jul-22 18:12, Marcin Szycik wrote:
> > 
> > 
> > On 01-Jul-22 01:12, Guillaume Nault wrote:
> >> On Wed, Jun 29, 2022 at 04:38:59PM +0200, Marcin Szycik wrote:
> >>> Add support for creating PPPoE filters in switchdev mode. Add support
> >>> for parsing PPPoE and PPP-specific tc options: pppoe_sid and ppp_proto.
> >>>
> >>> Example filter:
> >>> tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
> >>>     1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR
> >>>
> >>> Changes in iproute2 are required to use the new fields.
> >>>
> >>> ICE COMMS DDP package is required to create a filter as it contains PPPoE
> >>> profiles. Added a warning message when loaded DDP package does not contain
> >>> required profiles.
> >>>
> >>> Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
> >>> will add this feature.
> >>>
> >>> [0] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20220420210048.5809-1-martyna.szapar-mudlaw@intel.com
> >>
> >> Out of curiosity, can ice direct PPPoE Session packets to different
> >> queues with RSS (based on the session ID)?
> > 
> > Hardware should support it, but I'm not sure if it's possible with the current driver and how to configure it. I'll try to find out.
> 
> From what I understand, currently it's not possible to configure RSS for PPPoE session id, because ethtool does not support PPPoE.

Thanks, that's interesting. PPPoE support in RSS would have been useful
to me a few years ago. I've heard some former collegues tried to use
eBPF to work around this limitation and spread packets to different
cores.

