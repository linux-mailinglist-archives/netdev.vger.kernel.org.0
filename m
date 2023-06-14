Return-Path: <netdev+bounces-10843-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A3973081D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 21:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63FCF281516
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 19:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86B211C91;
	Wed, 14 Jun 2023 19:23:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684992EC11
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 19:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFEEC433C0;
	Wed, 14 Jun 2023 19:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686770631;
	bh=0BOdsM4cLRHTOlnYaLUt75A1t22AHk/Y2NVxpib67Lk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LzH04GlRF5zrYvxDTyooZehMnYtrAU8HDRBp7XI5z/Qeq+XvIo6isbmB/o2mdj3cn
	 NOZmbRUew3oY12cf3A2CbLChr1QB0EyKUwYE2jDdLhooiznKfJ7najj73QBEOUR6GK
	 EwRPvCT2gzouEFA9yJRyR+A4UvvCJ7RfoYr13yiXPNYP/IipZrJeEa1vvXLUoViu5g
	 d12ifIFaK8ZduX56cHNxvKhRjlpRo0Si4FScRYvU78L4X1qKmQdXlu/ujBvgj+Xxhl
	 JvQZhoDYA3x2vpl2BBkenu/HICpXzVZarXK17+kFqF3nNOBrV2EJSTO1c0x1hyOdHm
	 UGCEiVIaTAy2A==
Date: Wed, 14 Jun 2023 12:23:48 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc: Jiri Pirko <jiri@resnulli.us>, "vadfed@meta.com" <vadfed@meta.com>,
 "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>,
 "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
 <edumazet@google.com>, "vadfed@fb.com" <vadfed@fb.com>, "Brandeburg, Jesse"
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
Message-ID: <20230614122348.3e9b7e42@kernel.org>
In-Reply-To: <20230614121514.0d038aa3@kernel.org>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
	<20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
	<20230612154329.7bd2d52f@kernel.org>
	<ZIg8/0UJB9Lbyx2D@nanopsycho>
	<20230613093801.735cd341@kernel.org>
	<ZImH/6GzGdydC3U3@nanopsycho>
	<DM6PR11MB465799A5A9BB0B8E73A073449B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
	<20230614121514.0d038aa3@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 12:15:14 -0700 Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 12:21:29 +0000 Kubalewski, Arkadiusz wrote:
> > Surely, we can skip this discussion and split the nest attr into something like:
> > - PIN_A_PIN_PARENT_DEVICE,
> > - PIN_A_PIN_PARENT_PIN.  
> 
> Yup, exactly. Should a fairly change code wise, if I'm looking right.
                               ^ small

