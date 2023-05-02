Return-Path: <netdev+bounces-39-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E66466F4D9A
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 01:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72CE0280D1D
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EEA0BA2B;
	Tue,  2 May 2023 23:33:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A1D9479
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 23:33:17 +0000 (UTC)
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7572128;
	Tue,  2 May 2023 16:33:14 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
	id 6D91DC020; Wed,  3 May 2023 01:33:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683070391; bh=DCCDMXns57nPsLdJGb9E6WpE+yDkCf8eWVUNtOrwEJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fElTX+cfICmZL/Fu+WBThks+fQBSCYqochAQKPK3NFK2PEcYAp64RlVcgHOswe7Ad
	 FeLCZ5ezU6FqXoBLBr37O5mnEhy3HJmFjIb/Hs2pXeopC1IgSxV5LFVRY57YXIhEFr
	 dOnUf8uF+V/OgDqIcQLPT7bfg4PbRSZUxIM/Hp4BczNij0VK28QB9Ry5t0XNGhENOT
	 nkspQCmnyMddo99E0cc5YEXQwndjTbsjoXA4G+lRE8kEowC4ENl3OGFdemaYBp47m4
	 0CGH73YIdSiDoOz7GYfDIl6DhfhQUhAdQBX4r1hqY8t610tHQHryBXBuO1noOl2nGX
	 /4kj1J4j5SX0w==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id 5DACFC009;
	Wed,  3 May 2023 01:33:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1683070390; bh=DCCDMXns57nPsLdJGb9E6WpE+yDkCf8eWVUNtOrwEJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gtQ3nlWPVXFopl3E1YZUCIWANx5teA4UF9pzxP7h1tdN/ZfjKGtb9QMHX1t2LtAfI
	 9OHKoimKjVXbx1cTMLcRLGhh9UY7Uk4f3RTt3/t1z+6PKH9l5R95zp6rVdeH66jilk
	 KQw1jrFOSj6TnYxiBqetin31Rlg+uA8VeG8e6jFFd3RMkZ11pU8cNAJ8+xT4lD3ewb
	 DcAOeYNdMdlqd3lnjo23oxG33adB0IETWclFyIr6ZRdE0qiom2KG4hMX5ARklmopHR
	 iu+T6SB1r0qoZF28eB2VaK9MmeZvyHwHZxDoTWSGtrYE8Mndre1XE/zQl4Y+ZM4Uz8
	 wuYfVtWC9TgKA==
Received: from localhost (odin.codewreck.org [local])
	by odin.codewreck.org (OpenSMTPD) with ESMTPA id 08906240;
	Tue, 2 May 2023 23:33:04 +0000 (UTC)
Date: Wed, 3 May 2023 08:32:49 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	v9fs@lists.linux.dev, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/5] 9p: fix ignored return value in v9fs_dir_release
Message-ID: <ZFGdob9PRHSR-6ff@codewreck.org>
References: <20230427-scan-build-v1-0-efa05d65e2da@codewreck.org>
 <20230427-scan-build-v1-1-efa05d65e2da@codewreck.org>
 <ZFEiOdK0/UxKiPQQ@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZFEiOdK0/UxKiPQQ@corigine.com>

Thanks for all the reviews!

Simon Horman wrote on Tue, May 02, 2023 at 04:46:17PM +0200:
> On Thu, Apr 27, 2023 at 08:23:34PM +0900, Dominique Martinet wrote:
> > retval from filemap_fdatawrite was immediately overwritten by the
> > following p9_fid_put: preserve any error in fdatawrite if there
> > was any first.
> > 
> > This fixes the following scan-build warning:
> > fs/9p/vfs_dir.c:220:4: warning: Value stored to 'retval' is never read [deadcode.DeadStores]
> >                         retval = filemap_fdatawrite(inode->i_mapping);
> >                         ^        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Perhaps:
> 
> Fixes: 89c58cb395ec ("fs/9p: fix error reporting in v9fs_dir_release")

Right, this one warrants a fix tag as it's the only real bug in this
series.
I'll add the Fixes and fix the typo in patch 5 and send a v2 later
today.

-- 
Dominique Martinet | Asmadeus

