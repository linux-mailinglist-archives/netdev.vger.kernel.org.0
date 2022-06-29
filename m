Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677F7560462
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbiF2PTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233836AbiF2PTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:19:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F399A24BFA
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 08:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8212A60EC8
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 15:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0948BC34114;
        Wed, 29 Jun 2022 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656515979;
        bh=tLBQwVe0ndA2/6U5cX56akazDpzZj1TmPAaBtu08mIE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qzp4QRBc44PQ+vHPZwo0SR2XFHaxcFyy8eMYzzjXXFih2pbAjnhFk/WsHOxOuvtsD
         GVaNlzxTmgR+5bZWCMBSuVohJYVFdzau5cchVCvxUhfmNbU7zaM54r2PYxKqr6AVP2
         bdf2lyRbQPItpukrwDVOsYlcw8jHIL6xxQAAMOntYhm3JfpBsZeSXbrP1ysw8+2YR+
         yPVTyGywzM4RJxecVRAynbg5Q/81JdEx1rXfuiNzKGRRZIE//8BF8VbYTBSDevut73
         iiuKB6pbgUpnmN3KhRe75YRdp8hWWdbgzDAxN6SQ9KbfJH0Vhhxa2HREeJuN09VeMZ
         rN/kn78cSGAIA==
Date:   Wed, 29 Jun 2022 08:19:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        "boris.sukholitko@broadcom.com" <boris.sukholitko@broadcom.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "paulb@nvidia.com" <paulb@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "komachi.yoshiki@gmail.com" <komachi.yoshiki@gmail.com>,
        "zhangkaiheb@126.com" <zhangkaiheb@126.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Subject: Re: [RFC PATCH net-next v2 1/4] flow_dissector: Add PPPoE
 dissectors
Message-ID: <20220629081937.7270e7d7@kernel.org>
In-Reply-To: <MW4PR11MB57761A084A3A556F4070F8CDFDBB9@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
        <20220628112918.11296-2-marcin.szycik@linux.intel.com>
        <20220628214020.0f83fc21@kernel.org>
        <MW4PR11MB57761A084A3A556F4070F8CDFDBB9@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 07:44:50 +0000 Drewek, Wojciech wrote:
> > > +static bool is_ppp_proto_supported(__be16 proto)  
> > 
> > What does supported mean in this context?  
> 
> It means that only those protocols are going to be dissected.

We only dissect PPP_IP and PPP_IPV6. This looks more like a list of all
known protocols.
