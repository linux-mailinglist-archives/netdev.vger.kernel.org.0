Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0409F652252
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiLTOTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234016AbiLTOS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:18:59 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4591BEA5;
        Tue, 20 Dec 2022 06:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671545926; x=1703081926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=29ds9ocb2MYJd+jt0sFnoQawhblahvCPD7KE3BgiDmk=;
  b=K+fIsFm96i+1TZnqQNazs7y9nYBIhxZ/zgcx7GqULVOQQejAkTqwSlS9
   h3CSyfatCQph3lzhjDGDkmHbqW/jc0SJSEgn6viYf1DoalgpJAzIsCg82
   IOG3pnpcq05ZRh3204Hmko85Yhindjn1jLbQcQZfngDLMujahsebIEH/H
   qdsEbB8GpxKtzEXFyNp9iYXUamWXZL6kGYfsiM6xIP52GYpHBDkvlWlcR
   wnuP3whNSdIXWppY0cCDK7vGXx6Mh4R8KPXykLTgaNnk5gtkiR0wXWqja
   MXRsulg1xuYHgaIoNa/QpGkv+k1X3dZ5cuw6P0DtMhNUYKA/7rUQKbIkE
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="320798369"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="320798369"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:18:46 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="653121875"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="653121875"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 06:18:43 -0800
Date:   Tue, 20 Dec 2022 15:18:03 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc:  Fix potential resource leaks
Message-ID: <Y6HEG037kOJZbQ7+@localhost.localdomain>
References: <20221220134623.2084443-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220134623.2084443-1-linmq006@gmail.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 05:46:23PM +0400, Miaoqian Lin wrote:
> nfc_get_device() take reference for the device, add missing
> nfc_put_device() to release it when not need anymore.
> Also fix the style warnning by use error EOPNOTSUPP instead of
> ENOTSUPP.
> 
> Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
> Fixes: 29e76924cf08 ("nfc: netlink: Add capability to reply to vendor_cmd with data")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
Nice catch
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> -- 
> 2.25.1
> 
