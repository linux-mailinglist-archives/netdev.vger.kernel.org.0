Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF616F894
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 08:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgBZHgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 02:36:06 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38623 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgBZHgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 02:36:06 -0500
Received: by mail-wr1-f66.google.com with SMTP id e8so1657832wrm.5
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 23:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vZJyBk9lu1rD2qT5SftmPMZtuEheybwJNwMh28DMtwM=;
        b=McHjfQiP2MfCWpWh6In+efTkmR5day2EdpVK0zz9aWXVFtXNyFr5s+Ty0Jp09bnv5x
         giwD1pYAlibYR8WpBdokLDZU/JAkRJixIff1M4uF8wKM02YoLB76CctCk80dXlFh5x0w
         LAnVPm5I0Uiqj1wnz4nl1Wvm1preX89tkJnnEJQuVQhUsok1YA7cZ/EkHym50wg+B3Tv
         qtCpjF2rW80aE+ghH2PAcZ0el3b3Eptw+h7NttFdMEHH+D1upTwvvG1r1mlBtRKF65gb
         jGWjLflPkAYX6mftH2pWKjBIAKik3bI61l0k/A5XRxe+VKb3lGCWSmoG9vEeTiZ1KZme
         3l5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vZJyBk9lu1rD2qT5SftmPMZtuEheybwJNwMh28DMtwM=;
        b=cPfuKBOeNQhqS2OAu+jgeBra1/NlI0GeF9D8yuXkKA8hVwlHUyiq00NGCe3wacQ/FT
         ZxDnLtSCKUsCZnaHrONzcZ3FymwvcQX6fjW2D6jYllm3v2OE3kzinZKoNqzgcgoWclSx
         nfOucFIM5vlNNKubQjBCNrl1MPGEixvqnh+X8bMBdiFLPIPp0TyLRPv+/3EQnGNGh7DC
         HiCe3JejWtK0I8nJnKAAyxlo7LO1W2YV/5xm0HXbXu6nh9HnnWrbvm82TcrceF/16faC
         0dNkmAbpO1biUrsj+2Jg00FarEsHg3d6Ep8El4+X79ZBFWINwE+/Anka6nUkK2TjlS1o
         HMew==
X-Gm-Message-State: APjAAAVeWOfgkPDTi2/ohrPxUKyBcGrD0JHoCHDb1PdcCJSay69ss9wk
        tbFFyNDXK5wronyUoKy2YPci4w==
X-Google-Smtp-Source: APXvYqxIauiL13oUpxV81Yw9mPEJVigE5VceP3aF7sZGpUet2XmW8W0jTNx39PdZp5mLUTL7ce5yOw==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr3920831wro.357.1582702564250;
        Tue, 25 Feb 2020 23:36:04 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id q3sm1967095wrs.1.2020.02.25.23.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 23:36:03 -0800 (PST)
Date:   Wed, 26 Feb 2020 08:36:02 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        kuba@kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [patch net-next] iavf: use tc_cls_can_offload_basic() instead of
 chain check
Message-ID: <20200226073602.GB10533@nanopsycho>
References: <20200225121023.6011-1-jiri@resnulli.us>
 <469b51add666cf3df7381b6409a3972c70024c12.camel@intel.com>
 <20200225.132041.1071108395246034738.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200225.132041.1071108395246034738.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 10:20:41PM CET, davem@davemloft.net wrote:
>From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>Date: Tue, 25 Feb 2020 13:15:46 -0800
>
>> On Tue, 2020-02-25 at 13:10 +0100, Jiri Pirko wrote:
>>> From: Jiri Pirko <jiri@mellanox.com>
>>> 
>>> Looks like the iavf code actually experienced a race condition, when
>>> a
>>> developer took code before the check for chain 0 was put to helper.
>>> So use tc_cls_can_offload_basic() helper instead of direct check and
>>> move the check to _cb() so this is similar to i40e code.
>>> 
>>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> 
>> Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> 
>> Go ahead and pick this up Dave, thanks!
>
>Hmmm, Jiri this doesn't compile?

Crap :/ I shuffled with the patches too much. Will send v2. Sorry.

>
>  CC [M]  drivers/net/ethernet/intel/iavf/iavf_main.o
>drivers/net/ethernet/intel/iavf/iavf_main.c: In function ‘iavf_setup_tc_block_cb’:
>drivers/net/ethernet/intel/iavf/iavf_main.c:3089:7: error: implicit declaration of function ‘tc_cls_can_offload_basic’; did you mean ‘tc_cls_common_offload_init’? [-Werror=implicit-function-declaration]
>  if (!tc_cls_can_offload_basic(adapter->netdev, type_data))
>       ^~~~~~~~~~~~~~~~~~~~~~~~
>       tc_cls_common_offload_init
>
>Maybe it does depend upon something in the tc filter patch series?
