Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB6511BB6
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 16:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfEBOrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 10:47:51 -0400
Received: from www62.your-server.de ([213.133.104.62]:54146 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBOru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 10:47:50 -0400
Received: from [78.46.172.2] (helo=sslproxy05.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hMCzt-0002Gp-Lg; Thu, 02 May 2019 16:47:41 +0200
Received: from [173.228.226.134] (helo=localhost.localdomain)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hMCzt-000FI5-7p; Thu, 02 May 2019 16:47:41 +0200
Subject: Re: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
 <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <806f5242-d509-e015-275e-ad0325f17222@iogearbox.net>
Date:   Thu, 2 May 2019 16:47:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25437/Thu May  2 09:59:34 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/29/2019 09:16 PM, Jeff Kirsher wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> GCC will generate jump tables for switch-statements with more than 5
> case statements. An entry into the jump table is an indirect call,
> which means that for CONFIG_RETPOLINE builds, this is rather
> expensive.
> 
> This commit replaces the switch-statement that acts on the XDP program
> result with an if-clause.
> 
> The if-clause was also refactored into a common function that can be
> used by AF_XDP zero-copy and non-zero-copy code.

Isn't it fixed upstream by now already (also in gcc)?

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce02ef06fcf7a399a6276adb83f37373d10cbbe1
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9d57ef15cbe327fe54416dd194ee0ea66ae53a4
