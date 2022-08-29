Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8B05A443F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiH2HzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiH2HzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:55:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4E711A0B
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661759700; x=1693295700;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=b/c9LROBtbq6Z1JfJqAI/M0AfxOa/PcAfyoMxcckapA=;
  b=mOq5SQ/AssNJ22PoQxBkjC9sskI2Nlpdyp4y4EqZDlbZi6l3E+losL81
   bx0d3NLbfn75neOz6dy2ZAVhjwKSGPC4q8ZBSuteYQTeMO9ZsbCBRDEyI
   /Ptt3DoaMIA3GVvW/r3x20rZwCtQGOg2nF+0uWIGUQxSMyxAeANlL7iaJ
   mDvd3vrdIVj9m/g0sGDVi/iDMjUpEIIwTnMXHvsDT8qDnziNfxVeAp6z2
   fZSntRs0XhsAW9Xgzpx6yw6zwf0P/5rxae1ZZTJU2Hhxrj0TrSX2w3FNp
   7l5WGY6mGSX/D1QjI6QET1A6bs49NCv4JQxMmM0YigEbpwzTdkAwUGePK
   w==;
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="174580514"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2022 00:54:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 29 Aug 2022 00:54:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 29 Aug 2022 00:54:55 -0700
Date:   Mon, 29 Aug 2022 09:53:42 +0200
From:   "Allan W. Nielsen" <Allan.Nielsen@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, <Daniel.Machon@microchip.com>,
        <netdev@vger.kernel.org>, <vinicius.gomes@intel.com>,
        <vladimir.oltean@nxp.com>, <thomas.petazzoni@bootlin.com>,
        <maxime.chevallier@bootlin.com>, <roopa@nvidia.com>
Subject: Re: Basic PCP/DEI-based queue classification
Message-ID: <20220829075342.5ztd5hf4sznl7req@lx-anielsen>
References: <Yv9VO1DYAxNduw6A@DEN-LT-70577>
 <874jy8mo0n.fsf@nvidia.com>
 <YwKeVQWtVM9WC9Za@DEN-LT-70577>
 <87v8qklbly.fsf@nvidia.com>
 <YwXXqB64QLDuKObh@DEN-LT-70577>
 <87pmgpki9v.fsf@nvidia.com>
 <YwZoGJXgx/t/Qxam@DEN-LT-70577>
 <87k06xjplj.fsf@nvidia.com>
 <20220824175453.0bc82031@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20220824175453.0bc82031@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 24.08.2022 17:54, Jakub Kicinski wrote:
>For an uneducated maintainer like myself, how do embedded people look
>at DCB? Only place I've seen it used is in RDMA clusers. I suggested
>to Vladimir to look at DCBNL for frame preemption because it's the only
>existing API we have that's vaguely relevant to HW/prio control but he
>ended up going with ethtool.
>No preference here, just trying to map it out in my head.

As I work toghether with Daniel, I'm biased. But I work a lot with
embedded devices ;-)

I think this feature belong in DCB simply because DCB already have the
related configurations (like the default prio, priority-flow-control
etc), and it will be more logical for the user to find the PCP mapping
in the same place.

I think that framepreemption should be in ethtool as it is partly
defined in IEEE802.3 (the physical layer) and it is ethernet only
technology.

/Allan
