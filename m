Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8376733E2EA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhCQAil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:38:41 -0400
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:38506 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhCQAie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:38:34 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 12H0c5oj010866; Wed, 17 Mar 2021 09:38:05 +0900
X-Iguazu-Qid: 2wHHVZPeG5ucmL6geC
X-Iguazu-QSIG: v=2; s=0; t=1615941485; q=2wHHVZPeG5ucmL6geC; m=S1/Z8TipOfdF+lZx/g/AJZmYGFrUSSpAGmySTsH17QU=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1113) id 12H0c3RV023313
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 17 Mar 2021 09:38:04 +0900
Received: from enc02.toshiba.co.jp (enc02.toshiba.co.jp [61.202.160.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx12-a.toshiba.co.jp (Postfix) with ESMTPS id BF73A1000CF;
        Wed, 17 Mar 2021 09:38:03 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 12H0c2BK015459;
        Wed, 17 Mar 2021 09:38:03 +0900
From:   Punit Agrawal <punit1.agrawal@toshiba.co.jp>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        daichi1.fukui@toshiba.co.jp, nobuhiro1.iwamatsu@toshiba.co.jp,
        Corinna Vinschen <vinschen@redhat.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [PATCH v4.4.y, v4.9.y] igb: Remove incorrect "unexpected SYS WRAP" log message
References: <20210225005406.530767-1-punit1.agrawal@toshiba.co.jp>
        <YDddMnkytDS76mYN@kroah.com>
Date:   Wed, 17 Mar 2021 09:38:01 +0900
In-Reply-To: <YDddMnkytDS76mYN@kroah.com> (Greg KH's message of "Thu, 25 Feb
        2021 09:17:54 +0100")
X-TSB-HOP: ON
Message-ID: <87wnu6sjh2.fsf@kokedama.swc.toshiba.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Greg KH <greg@kroah.com> writes:

> On Thu, Feb 25, 2021 at 09:54:06AM +0900, Punit Agrawal wrote:
>> From: Corinna Vinschen <vinschen@redhat.com>
>> 
>> commit 2643e6e90210e16c978919617170089b7c2164f7 upstream
>> 
>> TSAUXC.DisableSystime is never set, so SYSTIM runs into a SYS WRAP
>> every 1100 secs on 80580/i350/i354 (40 bit SYSTIM) and every 35000
>> secs on 80576 (45 bit SYSTIM).
>> 
>> This wrap event sets the TSICR.SysWrap bit unconditionally.
>> 
>> However, checking TSIM at interrupt time shows that this event does not
>> actually cause the interrupt.  Rather, it's just bycatch while the
>> actual interrupt is caused by, for instance, TSICR.TXTS.
>> 
>> The conclusion is that the SYS WRAP is actually expected, so the
>> "unexpected SYS WRAP" message is entirely bogus and just helps to
>> confuse users.  Drop it.
>> 
>> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
>> Acked-by: Jacob Keller <jacob.e.keller@intel.com>
>> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>> [ Due to confusion about stable rules for networking the request was
>> mistakenly sent to netdev only[0]. Apologies if you're seeing this
>> again. ]
>
> No signed-off-by: from you?  :(

Apologies for the missing the SoB. And thank you for applying the patch
to stable even so.

[ Sorry for the long dealy in responding. Our mail system was having
issues (dropping emails randomly) and looks like this mail got caught up
during that period. ]

