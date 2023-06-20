Return-Path: <netdev+bounces-12151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B742C7366D2
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E83161C202ED
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0347C157;
	Tue, 20 Jun 2023 09:00:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A142CC147
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 09:00:39 +0000 (UTC)
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C9810F0;
	Tue, 20 Jun 2023 02:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=fqqJU+ep78UKaBVUFoBrywwL/ir5PEJDL2u/mTEGnJo=;
	t=1687251630; x=1688461230; b=kscnoBEY7Eu03mPc8sog1TzY7QUspS8m7HewNovK+HYTToI
	a9Aogl82R2UaU4/WfiAkLD+ngOfE5qhsaUH+e/b1nmLzlRPqF/jy+DOpvtKMVD987w/+2WcdUgjs4
	yq2BEDcX5tii4Iizfrmv1aJZSOVX3m3Kr6DSqF9ul6fuo8lU8OIOLxpBmjFrC0vL3LH4zJhPSVq8p
	/2rJXMdI/mysSMYGSQjFpv2otg510DvZkLBdmOjmKw7LMS8XKpe5cKD0niyHa0RiZAXN6bP6UDh7T
	2xDh+mlQiiA7tG/fIh4dTD34Ws0a0Q3mSoYkRG+jcBtekclJLHXUmZUrfJgXX6Dw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1qBXDp-00CKIa-1c;
	Tue, 20 Jun 2023 11:00:21 +0200
Message-ID: <0586c33fa2303dc184ef106b1d453ec2b183f45e.camel@sipsolutions.net>
Subject: Re: [PATCH 1/1] wifi: cfg80211: Allow multiple userpsace
 applications to receive the same registered management frame.
From: Johannes Berg <johannes@sipsolutions.net>
To: "quentin.feraboli" <quentin.feraboli@softathome.com>,
 davem@davemloft.net,  edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com,  linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
  linux-kernel@vger.kernel.org
Date: Tue, 20 Jun 2023 11:00:20 +0200
In-Reply-To: <20230620085751.31329-1-quentin.feraboli@softathome.com>
References: <20230620085751.31329-1-quentin.feraboli@softathome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.3 (3.48.3-1.fc38) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 2023-06-20 at 10:57 +0200, quentin.feraboli wrote:
> Currently, only one application can listen to a management frame type.
>=20

This is incorrect, since there's some responsibility involved when
userspace subscribes to this, and if multiple are subscribed then they
cannot all take those responsibilities.

johannes

