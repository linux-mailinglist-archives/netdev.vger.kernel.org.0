Return-Path: <netdev+bounces-11181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B014731DDE
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 18:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2632828159A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 16:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9C18FBE6;
	Thu, 15 Jun 2023 16:31:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC5134469
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 16:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEB9C433C0;
	Thu, 15 Jun 2023 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686846674;
	bh=Ba6+TbNKPkyuZQ8mwf62Wv9MAIIfwgYKhkFTTivsGpQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=s1YJtKsSZsgntvLLc+qrvnOVQQhDVyH3F6XUy3g5A8+lB7tkTdRFI3SfmMEPNnk2d
	 2q/dbjFtLd1Aw2jP+9DEG5DJr+pqhO9oDZB/uxcF2Ag9SPFFqhMyVQOcLNBowYe5zE
	 otSbSVgQYUBwvuzaplXlDGaeztZq8Uko8zjAPxzcNLaAZap71zfoM3uM+IZH1ZzGpk
	 vPiyDB406693Cd8DuiuW4R/DhvKZALJwoZQCJLhn4SPvDUpPFajLkjjW1WNATWQwYc
	 WuAgp2ARLHo4SUDQG+4m8QjslVw+NgoWgQbe3ToSAEf0a5zxmY9gHkzcOCCx4XjFwy
	 yuZSApgamUczQ==
Date: Thu, 15 Jun 2023 09:31:11 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
 "vadfed@meta.com" <vadfed@meta.com>, "jonathan.lemon@gmail.com"
 <jonathan.lemon@gmail.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "davem@davemloft.net"
 <davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
 "vadfed@fb.com" <vadfed@fb.com>, "Brandeburg, Jesse"
 <jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
 <anthony.l.nguyen@intel.com>, "M, Saeed" <saeedm@nvidia.com>,
 "leon@kernel.org" <leon@kernel.org>, "richardcochran@gmail.com"
 <richardcochran@gmail.com>, "sj@kernel.org" <sj@kernel.org>,
 "javierm@redhat.com" <javierm@redhat.com>, "ricardo.canuelo@collabora.com"
 <ricardo.canuelo@collabora.com>, "mst@redhat.com" <mst@redhat.com>,
 "tzimmermann@suse.de" <tzimmermann@suse.de>, "Michalik, Michal"
 <michal.michalik@intel.com>, "gregkh@linuxfoundation.org"
 <gregkh@linuxfoundation.org>, "jacek.lawrynowicz@linux.intel.com"
 <jacek.lawrynowicz@linux.intel.com>, "airlied@redhat.com"
 <airlied@redhat.com>, "ogabbay@kernel.org" <ogabbay@kernel.org>,
 "arnd@arndb.de" <arnd@arndb.de>, "nipun.gupta@amd.com"
 <nipun.gupta@amd.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux@zary.sk"
 <linux@zary.sk>, "masahiroy@kernel.org" <masahiroy@kernel.org>,
 "benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
 "geert+renesas@glider.be" <geert+renesas@glider.be>, "Olech, Milena"
 <milena.olech@intel.com>, "kuniyu@amazon.com" <kuniyu@amazon.com>,
 "liuhangbin@gmail.com" <liuhangbin@gmail.com>, "hkallweit1@gmail.com"
 <hkallweit1@gmail.com>, "andy.ren@getcruise.com" <andy.ren@getcruise.com>,
 "razor@blackwall.org" <razor@blackwall.org>, "idosch@nvidia.com"
 <idosch@nvidia.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
 "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, "phil@nwl.cc"
 <phil@nwl.cc>, "claudiajkang@gmail.com" <claudiajkang@gmail.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
 <mschmidt@redhat.com>, "linux-clk@vger.kernel.org"
 <linux-clk@vger.kernel.org>, "vadim.fedorenko@linux.dev"
 <vadim.fedorenko@linux.dev>
Subject: Re: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Message-ID: <20230615093111.0ee762e4@kernel.org>
In-Reply-To: <ZIrldB4ic3zt9nIk@nanopsycho>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
	<20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
	<20230612154329.7bd2d52f@kernel.org>
	<ZIg8/0UJB9Lbyx2D@nanopsycho>
	<20230613093801.735cd341@kernel.org>
	<ZImH/6GzGdydC3U3@nanopsycho>
	<DM6PR11MB465799A5A9BB0B8E73A073449B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
	<20230614121514.0d038aa3@kernel.org>
	<20230614122348.3e9b7e42@kernel.org>
	<ZIrldB4ic3zt9nIk@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 12:18:28 +0200 Jiri Pirko wrote:
> Yeah, that is what we had originally. This just pushes out the
> different attr selection from the nest one level up to the actualy
> nesting attribute.

Oh no, no extra nesting. Let me try to fake up the output:

'pin': [{
 {'clock-id': 282574471561216,
  'module-name': 'ice',
  'pin-dpll-caps': 4,
  'pin-id': 13,
  'parent-device': [{'pin-id': 2, 'pin-state': 'connected'},
                    {'pin-id': 3, 'pin-state': 'disconnected'}],
  'parent-pin': [{'id': 0, 'pin-direction': 'input'},
                 {'id': 1, 'pin-direction': 'input'}],
  'pin-type': 'synce-eth-port'}
}]

> One downside of this is you will have 2 arrays of parent objects,
> one per parent type. Current code neatly groups them into a single array.
> 
> I guess this is a matter of personal preference, I'm fine either way.

Yeah, could be.

