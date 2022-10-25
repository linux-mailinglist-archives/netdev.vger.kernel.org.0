Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AB560D6AF
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 00:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiJYWAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 18:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiJYWAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 18:00:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074987E82A;
        Tue, 25 Oct 2022 15:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666735238; x=1698271238;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=44neLNb+622C3/v3IvkT8+w76MsPFc0VdmFApC/mlJI=;
  b=jvFDf5cNiksrX72OlI1IwLQf/ZzzlsYqYiIVmJp5VDxQ8TlFsDHklOIl
   rHX5pM0k90uRSzu+uG0SxL6S8JgiSgtZemdWOZ5bhZkPI+EUMucDQz5SX
   SKaWQlJCUxVIZCLddJkRSoFjNB9kJ1FP6CenG1CPCjujwuihDnwu8UVFm
   i3+sY1mY/aljTNKlRsBB+/lfUQj0OjTIzIo3pNby1CLhJyrxBGIqDqmxl
   fFFLbHcHMDa7uRHSafTTUqI5U+vlgbnfo/xJnDolOGfpRbMmZTkA5ITXk
   xzQwJS5qw0K/NhPhu7eE7nm3C52550uhKLTbv7y1QCVmCmhGatjQMPSGe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="308895372"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="308895372"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 15:00:37 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="774360203"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="774360203"
Received: from jlluce-mobl1.amr.corp.intel.com (HELO [10.212.217.182]) ([10.212.217.182])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 15:00:36 -0700
Message-ID: <b4a64b97-32d2-d83d-9146-ebc9a4cc9ff6@intel.com>
Date:   Tue, 25 Oct 2022 15:00:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
 <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/22 04:07, Peter Zijlstra wrote:
> I think the focus should be on finding the source sites, not protecting
> the target sites. Where can an attacker control the register content and
> have an indirect jump/call.

How would this work with something like 'struct file_operations' which
provide a rich set of indirect calls that frequently have fully
user-controlled values in registers?

It certainly wouldn't *hurt* to be zeroing out the registers that are
unused at indirect call sites.  But, the majority of gadgets in this
case used rdi and rsi, which are the least likely to be able to be
zapped at call sites.
