Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C39F6C3081
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 11:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfJAJmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:42:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:41327 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfJAJmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 05:42:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 02:42:41 -0700
X-IronPort-AV: E=Sophos;i="5.64,570,1559545200"; 
   d="scan'208";a="185132814"
Received: from jnikula-mobl3.fi.intel.com (HELO localhost) ([10.237.66.161])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Oct 2019 02:42:37 -0700
From:   Jani Nikula <jani.nikula@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3] string-choice: add yesno(), onoff(), enableddisabled(), plural() helpers
In-Reply-To: <20191001093849.GA2945163@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <8e697984-03b5-44f3-304e-42d303724eaa@rasmusvillemoes.dk> <20191001080739.18513-1-jani.nikula@intel.com> <20191001093849.GA2945163@kroah.com>
Date:   Tue, 01 Oct 2019 12:42:34 +0300
Message-ID: <87blv0dcol.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Oct 2019, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Tue, Oct 01, 2019 at 11:07:39AM +0300, Jani Nikula wrote:
>> The kernel has plenty of ternary operators to choose between constant
>> strings, such as condition ? "yes" : "no", as well as value == 1 ? "" :
>> "s":
>> 
>> $ git grep '? "yes" : "no"' | wc -l
>> 258
>> $ git grep '? "on" : "off"' | wc -l
>> 204
>> $ git grep '? "enabled" : "disabled"' | wc -l
>> 196
>> $ git grep '? "" : "s"' | wc -l
>> 25
>> 
>> Additionally, there are some occurences of the same in reverse order,
>> split to multiple lines, or otherwise not caught by the simple grep.
>> 
>> Add helpers to return the constant strings. Remove existing equivalent
>> and conflicting functions in i915, cxgb4, and USB core. Further
>> conversion can be done incrementally.
>> 
>> While the main goal here is to abstract recurring patterns, and slightly
>> clean up the code base by not open coding the ternary operators, there
>> are also some space savings to be had via better string constant
>> pooling.
>> 
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
>> Cc: intel-gfx@lists.freedesktop.org
>> Cc: Vishal Kulkarni <vishal@chelsio.com>
>> Cc: netdev@vger.kernel.org
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-usb@vger.kernel.org
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Julia Lawall <julia.lawall@lip6.fr>
>> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> # v1
>
> As this is a totally different version, please drop my reviewed-by as
> that's really not true here :(

I did indicate it was for v1. Indeed v2 was different, but care to
elaborate what's wrong with v3?

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
