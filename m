Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B68512929
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 03:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbiD1CBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 22:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240745AbiD1CBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 22:01:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FAB5C354;
        Wed, 27 Apr 2022 18:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651111073; x=1682647073;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/vhHc0ORGV2b1XZMIu39ZLL/Kp9lOxc3E0MqPGKIEJE=;
  b=EyuawpL2Pw0PjrsueiDin4SZeO2BaW1lgdRCXEPSVhRNwwnRTAoRN72Q
   nd+CmR/xJmhKbUckjaayFifs3LnLV7XnDjQp+7XobWOnlhjo/QAGgxFZr
   Vvk/rSUDqVMMffSxDFenuVRRfQ7+pBUk7/9EKLn/QzeBVbndsqXK2gncf
   gASkKxRtX9ccyca86m9ehmdlQTvLUsii81h3YNXPfTYXId23kDxE/kC+/
   kH+lwO0Oto4YCMdGBqBn8OijJAG14agcVXIjn4KQrFGacKjRWd2EXcjMR
   /XsWVoXl+n8LkrlVRqR9Jtzs8CwJyzlAjWm7V1dKygRmX6ijyAWCQ3hWD
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="291287028"
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="291287028"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2022 18:57:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,294,1643702400"; 
   d="scan'208";a="681605449"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 27 Apr 2022 18:57:52 -0700
Received: from linux.intel.com (ssid-ilbpg3-teeminta.png.intel.com [10.88.227.74])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 00BCC580569;
        Wed, 27 Apr 2022 18:57:46 -0700 (PDT)
Date:   Thu, 28 Apr 2022 09:55:38 +0800
From:   Tan Tee Min <tee.min.tan@linux.intel.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ling Pei Lee <pei.lee.ling@intel.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Ong@vger.kernel.org, Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: disable Split Header (SPH) for
 Intel platforms
Message-ID: <20220428015538.GC26326@linux.intel.com>
References: <20220426074531.4115683-1-tee.min.tan@linux.intel.com>
 <8735i0ndy7.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735i0ndy7.fsf@kurt>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 03:58:56PM +0200, Kurt Kanzenbach wrote:
> Hi,
> 
> On Tue Apr 26 2022, Tan Tee Min wrote:
> > Based on DesignWare Ethernet QoS datasheet, we are seeing the limitation
> > of Split Header (SPH) feature is not supported for Ipv4 fragmented packet.
> > This SPH limitation will cause ping failure when the packets size exceed
> > the MTU size. For example, the issue happens once the basic ping packet
> > size is larger than the configured MTU size and the data is lost inside
> > the fragmented packet, replaced by zeros/corrupted values, and leads to
> > ping fail.
> >
> > So, disable the Split Header for Intel platforms.
> 
> Does this issue only apply on Intel platforms?

According to Synopsys IP support, they have confirmed the header-payload
splitting for IPv4 fragmented packets is not supported for the Synopsys
Ether IPs.

Intel platforms are integrating with GMAC EQoS IP which is impacted by the
limitation above, so we are changing the default SPH setting to disabled
for Intel Platforms only.

If anyone can confirm on their platform also having the same issues,
then we would change the SPH default to disable across the IPs.

Thanks,
Tee Min

