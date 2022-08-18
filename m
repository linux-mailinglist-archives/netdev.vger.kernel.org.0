Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B115A5981AC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 12:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244174AbiHRKv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 06:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243983AbiHRKv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 06:51:56 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EC386701
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 03:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660819916; x=1692355916;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=JP1xjxxCbVWbb4jU6VPzpzb1N8DH/fp6MVbEQilgiQ4=;
  b=j6JqgFdvCpAgDFQSn3B+h2Jj6rMmRo8RBOlHoo97afYinUjMxJqLlCt5
   lLiAoEY06K6oAh+Odf+u1kcQkybKXzaUJ0ZazoVTrXSEs/D5wLP/TK06t
   JsgyZZnHF5/xrzyINsJASIR2nzWqeU+rtWMMFY+ATv5qVx/MH0DpE4M9Z
   crnwqnI7r69C5+Kr8otPA0FqPbmG3KyFNrgwCBpn/1HClMgaF003Qz/s6
   CEN+2ogqpQAOB2pGrV4J5i87NRKXYz6rWMrfI4P5EBvtF4X5sI8daVxkH
   eulFVorNa3gawKopEdbX5BZXoddP66qPHaLoLGuh8LXtma5wzz3xjsxgN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="379021526"
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="379021526"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:51:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,246,1654585200"; 
   d="scan'208";a="668054490"
Received: from dursu-mobl1.ger.corp.intel.com ([10.249.42.244])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:51:47 -0700
Date:   Thu, 18 Aug 2022 13:51:45 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
cc:     m.chetan.kumar@intel.com, Netdev <netdev@vger.kernel.org>,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Haijun Liu <haijun.liu@mediatek.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
Subject: Re: [PATCH net-next 2/5] net: wwan: t7xx: Infrastructure for early
 port configuration
In-Reply-To: <1bc73cf7-38d2-e30e-5d68-4a63a9186fd0@linux.intel.com>
Message-ID: <6f1b242-bd6f-7517-d9d8-d0e7dbba63d0@linux.intel.com>
References: <20220816042340.2416941-1-m.chetan.kumar@intel.com> <5a74770-94d3-f690-4aa1-59cdbbb29339@linux.intel.com> <1bc73cf7-38d2-e30e-5d68-4a63a9186fd0@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-468687397-1660819911=:1604"
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-468687397-1660819911=:1604
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 17 Aug 2022, Kumar, M Chetan wrote:

> On 8/17/2022 5:40 PM, Ilpo Järvinen wrote:
> > On Tue, 16 Aug 2022, m.chetan.kumar@intel.com wrote:
> > 
> > > From: Haijun Liu <haijun.liu@mediatek.com>
> > > 
> 
> <skip>
> 
> > > @@ -372,7 +435,8 @@ static int t7xx_port_proxy_recv_skb(struct cldma_queue
> > > *queue, struct sk_buff *s
> > >     	seq_num = t7xx_port_next_rx_seq_num(port, ccci_h);
> > >   	port_conf = port->port_conf;
> > > -	skb_pull(skb, sizeof(*ccci_h));
> > > +	if (!port->port_conf->is_early_port)
> > > +		skb_pull(skb, sizeof(*ccci_h));
> > 
> > This seems to be the only user for is_early_port, wouldn't be more obvious
> > to store the header size instead?
> 
> Early port doesn't carry header.
> If we change it to header size, skb_pull() operators on zero length.

Is that a problem?

> OR may need another such flag to bypass it.

You could use if (header_size) if you don't want to skb_pull with zero len 
so I don't know why another flag would be needed?


-- 
 i.

--8323329-468687397-1660819911=:1604--
