Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FCBC30C6
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbfJAJ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 05:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfJAJ7R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 05:59:17 -0400
Received: from localhost (unknown [89.205.130.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BAED2190F;
        Tue,  1 Oct 2019 09:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569923954;
        bh=6BQj7mEtfMmysioXhhYw2T2ycMJfZtHk5KXS+5M9J/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gsqEsnnhnu/YvGG69TnK4g5a2xTa+FgrBXr/RiK7xIdHcSVquGY5kk5UCPw0iPfki
         6IRV7Bm90LEpF2HwXQ4tSoA/ymTVqyAIm66I8530Ysgg8KutObDwHg80mjPMs70gDR
         DwW9tjRLUXtLNXrmKQhvnYg1xEvyDLnKrCMVglag=
Date:   Tue, 1 Oct 2019 11:59:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-kernel@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3] string-choice: add yesno(), onoff(),
 enableddisabled(), plural() helpers
Message-ID: <20191001095911.GA2945944@kroah.com>
References: <8e697984-03b5-44f3-304e-42d303724eaa@rasmusvillemoes.dk>
 <20191001080739.18513-1-jani.nikula@intel.com>
 <20191001093849.GA2945163@kroah.com>
 <87blv0dcol.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blv0dcol.fsf@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 12:42:34PM +0300, Jani Nikula wrote:
> On Tue, 01 Oct 2019, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > On Tue, Oct 01, 2019 at 11:07:39AM +0300, Jani Nikula wrote:
> >> The kernel has plenty of ternary operators to choose between constant
> >> strings, such as condition ? "yes" : "no", as well as value == 1 ? "" :
> >> "s":
> >> 
> >> $ git grep '? "yes" : "no"' | wc -l
> >> 258
> >> $ git grep '? "on" : "off"' | wc -l
> >> 204
> >> $ git grep '? "enabled" : "disabled"' | wc -l
> >> 196
> >> $ git grep '? "" : "s"' | wc -l
> >> 25
> >> 
> >> Additionally, there are some occurences of the same in reverse order,
> >> split to multiple lines, or otherwise not caught by the simple grep.
> >> 
> >> Add helpers to return the constant strings. Remove existing equivalent
> >> and conflicting functions in i915, cxgb4, and USB core. Further
> >> conversion can be done incrementally.
> >> 
> >> While the main goal here is to abstract recurring patterns, and slightly
> >> clean up the code base by not open coding the ternary operators, there
> >> are also some space savings to be had via better string constant
> >> pooling.
> >> 
> >> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> >> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> >> Cc: intel-gfx@lists.freedesktop.org
> >> Cc: Vishal Kulkarni <vishal@chelsio.com>
> >> Cc: netdev@vger.kernel.org
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> Cc: linux-usb@vger.kernel.org
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: linux-kernel@vger.kernel.org
> >> Cc: Julia Lawall <julia.lawall@lip6.fr>
> >> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> >> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org> # v1
> >
> > As this is a totally different version, please drop my reviewed-by as
> > that's really not true here :(
> 
> I did indicate it was for v1. Indeed v2 was different, but care to
> elaborate what's wrong with v3?

No idea, but I haven't reviewed it yet, so to put my tag on there isn't
the nicest...

greg k-h
