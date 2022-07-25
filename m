Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F44058025B
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 18:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiGYQAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 12:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiGYQAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 12:00:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A6D3E2BF7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658764817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pXQd8qsiueUyNLCwLanEF1sKoZG5cu8SXoCPRLwZkzY=;
        b=TuozDdgD8LTOb1d7FZyXwLqTHa5AnLPBiNe0DKzMTpEagLGZSFa5Ko7RFtC4++WJbDkUTK
        29h5z97rGFT1Eu2kK5bCO6j7A5BnV0K/KGOLhen7NlHQaszwdaSDeNjJYx6kPcorKL+So9
        5dyIfpc/Xbl0XNoN19QHoZH2R7c2IAk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-LS_TrTNIPLa39Tl5oj3cHA-1; Mon, 25 Jul 2022 12:00:16 -0400
X-MC-Unique: LS_TrTNIPLa39Tl5oj3cHA-1
Received: by mail-wm1-f69.google.com with SMTP id 189-20020a1c02c6000000b003a2d01897e4so6354461wmc.9
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 09:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pXQd8qsiueUyNLCwLanEF1sKoZG5cu8SXoCPRLwZkzY=;
        b=YJTxenXg/YEiVxLge6qrUeulk8CEtQGSqx+Lf8CZdCXStYiAqenc3vKVAw2mKkS4yZ
         r8aGD6ZZ31B57vyltjnbx9sknIIHgdCWhzECPli9PcOT5Imhk4o+IzabeqgrxC3oLEeb
         Gre8omRi1Up5EBhnRgaBxFa5UMQjKZUjo+yKQKYM1pZ7qyzvLyttZBTTPSYzMp24/tG9
         ezlnlMZbzAqbzLPkUtvW+CSp4sYZLvoeXiOz9peFbuP4T5jqlxoFUkvNyNZa+sIosCJL
         ChH588RgV01vuBDXZ1vo4enOgGEMQaFS4Fgt5qPSQqeLLVbz+1vbOMS16kgP3+sXhSNv
         3pKg==
X-Gm-Message-State: AJIora+6xRb/oDAJ+lr45jOEKU0Dbh9W2YdgZsTFCxNOxRJql6Jgvw0S
        C+z8bb0ecU6Hu5xABguC4vM61dG7eCbxlK22ukIqTrBWjV1L67m5Ps06pUEzOXKYjw1CSE2EEat
        asxU4tw++PoRbJHT/
X-Received: by 2002:a05:600c:254f:b0:3a3:2848:caeb with SMTP id e15-20020a05600c254f00b003a32848caebmr21666519wma.187.1658764815135;
        Mon, 25 Jul 2022 09:00:15 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uRFiHVAeQRhZYDaNBmO7NkOHQC5P2zy+an+ev9rSBv3hAwokWe0rX9Gjcv5nhFilHb9QSZHA==
X-Received: by 2002:a05:600c:254f:b0:3a3:2848:caeb with SMTP id e15-20020a05600c254f00b003a32848caebmr21666496wma.187.1658764814837;
        Mon, 25 Jul 2022 09:00:14 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z21-20020a05600c0a1500b0039c454067ddsm15650521wmp.15.2022.07.25.09.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 09:00:14 -0700 (PDT)
Date:   Mon, 25 Jul 2022 18:00:11 +0200
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
        alexandr.lobakin@intel.com, mostrows@speakeasy.net,
        paulus@samba.org
Subject: Re: [RFC PATCH net-next v6 2/4] net/sched: flower: Add PPPoE filter
Message-ID: <20220725160011.GB18808@pc-4.home>
References: <20220718121813.159102-1-marcin.szycik@linux.intel.com>
 <20220718121813.159102-3-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718121813.159102-3-marcin.szycik@linux.intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 02:18:11PM +0200, Marcin Szycik wrote:
> From: Wojciech Drewek <wojciech.drewek@intel.com>
> 
> Add support for PPPoE specific fields for tc-flower.
> Those fields can be provided only when protocol was set
> to ETH_P_PPP_SES. Defines, dump, load and set are being done here.
> 
> Overwrite basic.n_proto only in case of PPP_IP and PPP_IPV6,
> otherwise leave it as ETH_P_PPP_SES.

Acked-by: Guillaume Nault <gnault@redhat.com>

