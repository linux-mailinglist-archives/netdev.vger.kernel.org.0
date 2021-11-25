Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0851F45D253
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347399AbhKYBM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:12:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:62925 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244798AbhKYBK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:10:27 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="232907818"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="232907818"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 17:07:17 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="510088158"
Received: from askirtik-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.223.232])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 17:07:16 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Stefan Dietrich <roots@gmx.de>
Cc:     Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
In-Reply-To: <20211124153449.72c9cfcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
 <YZ3q4OKhU2EPPttE@kroah.com>
 <8119066974f099aa11f08a4dad3653ac0ba32cd6.camel@gmx.de>
 <20211124153449.72c9cfcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 24 Nov 2021 17:07:16 -0800
Message-ID: <87a6htm4aj.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 24 Nov 2021 18:20:40 +0100 Stefan Dietrich wrote:
>> Hi all,
>> 
>> six exciting hours and a lot of learning later, here it is.
>> Symptomatically, the critical commit appears for me between 5.14.21-
>> 051421-generic and 5.15.0-051500rc2-generic - I did not find an amd64
>> build for rc1.
>> 
>> Please see the git-bisect output below and let me know how I may
>> further assist in debugging!
>
> Well, let's CC those involved, shall we? :)
>
> Thanks for working thru the bisection!
>
>> a90ec84837325df4b9a6798c2cc0df202b5680bd is the first bad commit
>> commit a90ec84837325df4b9a6798c2cc0df202b5680bd
>> Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Date:   Mon Jul 26 20:36:57 2021 -0700
>> 
>>     igc: Add support for PTP getcrosststamp()

Oh! That's interesting.

Can you try disabling CONFIG_PCIE_PTM in your kernel config? If it
works, then it's a point in favor that this commit is indeed the
problematic one.

I am still trying to think of what could be causing the lockup you are
seeing.


Cheers,
-- 
Vinicius
