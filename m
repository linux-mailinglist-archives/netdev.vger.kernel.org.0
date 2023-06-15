Return-Path: <netdev+bounces-11225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DE70732095
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 969B02814C2
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 20:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7087EAF8;
	Thu, 15 Jun 2023 20:05:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95080EAF5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 20:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8D5C433C8;
	Thu, 15 Jun 2023 20:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686859507;
	bh=CZRKMMFyvWLL7Fxx/I7YyvYMRKdHPJbcAAkIvVyEre0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DvetiO+ccq8E8j7W77N+P4EFu/yQ9EjvGSV7yR2aO2aVRgfgfK6W/jqszhwQzqC+E
	 Hy0TjSSV6yVbsZrKEyOCSO/lUgIXhomOa28NyMgNlLdERlr3tlIVvsDwgDMLRrevc9
	 QUyCjbkC5qPSzPD0sxhChiKMvV5Xy9sCy+49/YRRpu1Mtm/KKhPc0MsuuqaFeUSTNn
	 si0v5wROeDiIpCJKCxBw1xVa538lf5INBqNiSD+i4k1g/b7sft8yCA4g9WK9Bz+zrH
	 V/hzHjNCdRZ8HO91lpjsnaHbNhvy2jllGCV/HssiNI21iJLjEY8QwggElJGGXo2zJy
	 uhqyToDBuJdpg==
Date: Thu, 15 Jun 2023 13:05:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc: <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
 <simon.horman@corigine.com>, <andrew@lunn.ch>,
 <linux-kernel@vger.kernel.org>, <vincent.cheng.xh@renesas.com>,
 <harini.katakam@amd.com>, <git@amd.com>
Subject: Re: [PATCH V2] ptp: clockmatrix: Add Defer probe if firmware load
 fails
Message-ID: <20230615130506.3efb333c@kernel.org>
In-Reply-To: <20230614051204.1614722-1-sarath.babu.naidu.gaddam@amd.com>
References: <20230614051204.1614722-1-sarath.babu.naidu.gaddam@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 14 Jun 2023 10:42:04 +0530 Sarath Babu Naidu Gaddam wrote:
> Clock matrix driver can be probed before the rootfs containing
> firmware/initialization .bin is available. The current driver
> throws a warning and proceeds to execute probe even when firmware
> is not ready. Instead, defer probe and wait for the .bin file to
> be available.

The first-step fix should be to try to get the FW into initramfs.
For that driver should specify MODULE_FIRMWARE(), which I don't see
here.
-- 
pw-bot: cr

