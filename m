Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D111B3A92
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgDVIvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:51:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:25276 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgDVIvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 04:51:33 -0400
IronPort-SDR: ZL2NothgWWaBiAwlK/g8jTemutKBriuxRq6bJFESvNmeggO2SYYr3ZxWnSkE1dfyph+uDO5tcy
 xSNYum4yatcQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 01:51:32 -0700
IronPort-SDR: iiv9b5p61LMYigVzyFdTkQemYR7HU3IMtiYvZn9eGn3HMisMF8oWZD2CKWBPVjSpWMmXzF6OF9
 B2qyHLlj8y5g==
X-IronPort-AV: E=Sophos;i="5.72,413,1580803200"; 
   d="scan'208";a="429836132"
Received: from otekdur-mobl.ger.corp.intel.com (HELO localhost) ([10.252.44.229])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 01:51:26 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Nicolas Pitre <nico@fluxnic.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "masahiroy\@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart\@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "airlied\@linux.ie" <airlied@linux.ie>,
        "jgg\@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kbuild\@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-rdma\@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jernej.skrabec\@siol.net" <jernej.skrabec@siol.net>,
        "arnd\@arndb.de" <arnd@arndb.de>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas\@kwiboo.se" <jonas@kwiboo.se>,
        "kieran.bingham+renesas\@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong\@baylibre.com" <narmstrong@baylibre.com>,
        "leon\@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20200417011146.83973-1-saeedm@mellanox.com> <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com> <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr> <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com> <87v9lu1ra6.fsf@intel.com> <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com> <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr> <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com> <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr>
Date:   Wed, 22 Apr 2020 11:51:23 +0300
Message-ID: <871rofdhtg.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Apr 2020, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Tue, 21 Apr 2020, Saeed Mahameed wrote:
>
>> On Tue, 2020-04-21 at 09:58 -0400, Nicolas Pitre wrote:
>> > On Tue, 21 Apr 2020, Saeed Mahameed wrote:
>> > 
>> > > I wonder how many of those 8889 cases wanted a weak dependency but
>> > > couldn't figure out how to do it ? 
>> > > 
>> > > Users of depends on FOO || !FOO
>> > > 
>> > > $ git ls-files | grep Kconfig | xargs grep -E \
>> > >   "depends\s+on\s+([A-Za-z0-9_]+)\s*\|\|\s*(\!\s*\1|\1\s*=\s*n)" \
>> > >  | wc -l
>> > > 
>> > > 156
>> > > 
>> > > a new keyword is required :) .. 
>> > > 
>> > > 
>> > > > In another mail I suggested
>> > > > 
>> > > > 	optionally depends on FOO
>> > > > 
>> > > > might be a better alternative than "uses".
>> > > > 
>> > > > 
>> > > 
>> > > how about just:
>> > >       optional FOO
>> > > 
>> > > It is clear and easy to document .. 
>> > 
>> > I don't dispute your argument for having a new keyword. But the most 
>> > difficult part as Arnd said is to find it. You cannot pretend that 
>> 
>> kconfig-language.rst  ?
>> 
>> > "optional FOO" is clear when it actually imposes a restriction when 
>> > FOO=m. Try to justify to people why they cannot select y because of
>> > this 
>> > "optional" thing.
>> > 
>> 
>> Then let's use "uses" it is more assertive. Documentation will cover
>> any vague anything about it .. 
>
> It uses what? And why can't I configure this with "uses FOO" when FOO=m?
> That's not any clearer. And saying that "this is weird but it is 
> described in the documentation" is not good enough. We must make things 
> clear in the first place.
>
> This is really a conditional dependency. That's all this is about.
> So why not simply making it so rather than fooling ourselves? All that 
> is required is an extension that would allow:
>
> 	depends on (expression) if (expression)
>
> This construct should be obvious even without reading the doc, is 
> already used extensively for other things already, and is flexible 
> enough to cover all sort of cases in addition to this particular one.

Okay, you convinced me. Now you only need to convince whoever is doing
the actual work of implementing this stuff. ;)

BR,
Jani.

-- 
Jani Nikula, Intel Open Source Graphics Center
