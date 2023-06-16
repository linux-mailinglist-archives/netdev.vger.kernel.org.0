Return-Path: <netdev+bounces-11482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0423B7334C9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:29:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 261072817DA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:29:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CF918B0F;
	Fri, 16 Jun 2023 15:29:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24010A92E
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 15:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F062C433C8;
	Fri, 16 Jun 2023 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686929372;
	bh=uHw14CfDgFm3qF/lgfQPttPTHtaxTk+P7o41vYD1ukA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=k9qll1hWMhgOSBLmYNjwhB2Ub/qewRLy57iEOm4B9BkDJW8lyCnUgbkDQjBcnLd8s
	 7SnRSRjpb3xw41XxL1c7Zdv0CPs4DxpMvMQlg/waSEJOLPxXvW+6zzSEH3k364hBbR
	 9RdCdy3P7Od0pqFToZk64/v1PFVtSx5AWmoGG69wf9dGwMXcYY5Ek8qL+ljs9li4Hg
	 hkEyTDGMW9Sd5dOUztdPPYv1UwtP/8YcklwrJELht7j5SqoJe3JLiOIlAeYq7uePov
	 PgeZIdo26/4FtB9LiyKyV1KyI4ojyVaN4beLOivZajQJUwpVUEpvcL9zAAGxAq/tx3
	 Vc2IuLXyo74Jg==
Date: Fri, 16 Jun 2023 08:29:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Cc: "patchwork-bot+netdevbpf@kernel.org"
 <patchwork-bot+netdevbpf@kernel.org>, "Gardocki, PiotrX"
 <piotrx.gardocki@intel.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "intel-wired-lan@lists.osuosl.org"
 <intel-wired-lan@lists.osuosl.org>, "Kitszel, Przemyslaw"
 <przemyslaw.kitszel@intel.com>, "michal.swiatkowski@linux.intel.com"
 <michal.swiatkowski@linux.intel.com>, "pmenzel@molgen.mpg.de"
 <pmenzel@molgen.mpg.de>, "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
 "simon.horman@corigine.com" <simon.horman@corigine.com>, "Lobakin,
 Aleksander" <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next v3 0/3] optimize procedure of changing MAC
 address on interface
Message-ID: <20230616082931.4d265f51@kernel.org>
In-Reply-To: <DM4PR11MB6117E6A199A2CEF4694A6E0C8258A@DM4PR11MB6117.namprd11.prod.outlook.com>
References: <20230614145302.902301-1-piotrx.gardocki@intel.com>
	<168689522302.30897.3895006000334449942.git-patchwork-notify@kernel.org>
	<DM4PR11MB6117E6A199A2CEF4694A6E0C8258A@DM4PR11MB6117.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Jun 2023 10:02:12 +0000 Fijalkowski, Maciej wrote:
> > Here is the summary with links:
> >   - [net-next,v3,1/3] net: add check for current MAC address in dev_set=
_mac_address
> >     https://git.kernel.org/netdev/net-next/c/ad72c4a06acc
> >   - [net-next,v3,2/3] i40e: remove unnecessary check for old MAC =3D=3D=
 new MAC
> >     https://git.kernel.org/netdev/net-next/c/c45a6d1a23c5
> >   - [net-next,v3,3/3] ice: remove unnecessary check for old MAC =3D=3D =
new MAC
> >     https://git.kernel.org/netdev/net-next/c/96868cca7971 =20
>=20
> Ah, so next time I will respond to each revision with rev-by tags =F0=9F=
=98=89

I may have done this slightly out of spite :P
You tell the man that he didn't keep your R-b tag, why not throw it in
again in one of your responses? It's bit of a PITA for me to add it
manually. One tag in reply to the cover letter is enough FWIW (at least
on netdev, I explained to BPF folks how to get the tag propagation
from cover letter to work but I'm not 100% sure they set it up for
themselves).

