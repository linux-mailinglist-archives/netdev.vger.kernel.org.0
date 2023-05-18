Return-Path: <netdev+bounces-3648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F817082A8
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 36F10281577
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1628923C96;
	Thu, 18 May 2023 13:29:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A38523C94
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:29:56 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 973B4EC
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:29:55 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.west.internal (Postfix) with ESMTP id 0FF6C3200583;
	Thu, 18 May 2023 09:29:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 18 May 2023 09:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684416593; x=1684502993; bh=Rf44Els0Z0CEy
	PrQ38wN3xlRA2yel6FJxGe2aZyOLsI=; b=rQkC2ayswjfduh0c74N1SviXljQ4x
	GYcq+1hjJEaxGZRK/D/ttqPJ85HE5lTg1k3RMEKMb/KWAB9oC1rtcXgR3taw5sZA
	upYyzUBOtf1WdIOpKYGNDX1AJ5kHqqc04LbcTggNTx7u7UDMzxfF/qHprh7wzrBv
	zUYWyT8o3xJ4FOoz8/tmk3G75V5Paoy5stSOHg4hwV2HrfIZ8/ZaNlHUIEnyVfm6
	QMFdoTFgTRp8w+HS4Pu25LUsiNr/WygM09mLqn7Jj8TOqv7FBlm4ROeYTzT2jWI+
	jYnCaPU0Y5/JN/gp9MUhas9vUIsc1Ef4WUT6kXslIg4CyziE0phlDlw+g==
X-ME-Sender: <xms:UShmZHqXLbQnpe_fkMgD-2TMtq5NnaQhfaSIBeKYjj2CGdz6jg7a5A>
    <xme:UShmZBo372V42aryW-9I55zOHqnteg8QxJAdcX0sXvPqwwzhNSOZ-rJ_mUyxle44R
    -oiPEjAu0zspZM>
X-ME-Received: <xmr:UShmZEMqtKEFh3YKka2i9nOvP-QKLMBhubftBegzD1JhJ8LRHmdKFrmY8QQBO-QQWlkD_ttvSKstDVRfVkG_WkR-xmQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeifedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefukfhfgggtuggjsehttdertddt
    tddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstg
    hhrdhorhhgqeenucggtffrrghtthgvrhhnpedvudefveekheeugeeftddvveefgfduieef
    udeifefgleekheegleegjeejgeeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UShmZK6cVQxnmyLC2rB4bKTjdiHaqBi0oDTqL6b70Ck4V5GEXi6dcQ>
    <xmx:UShmZG7O47uViAPVvXgTJMH68v61dzBuoXIxG9pJUGZqqO9cD76wMg>
    <xmx:UShmZChVxN0usz7ZmSS3iz8HEzqbmKgSFLomr2P0UFdXTRkWUOXsSg>
    <xmx:UShmZDzYstY6DGc6jSaAvwEO5w3u5FoU0JZ9dZffurAVDyQIQQCE5g>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 May 2023 09:29:52 -0400 (EDT)
Date: Thu, 18 May 2023 16:29:48 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v3] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGYoTIYd71a463vP@shredder>
References: <20230518040030.5935-1-vladimir@nikishkin.pw>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518040030.5935-1-vladimir@nikishkin.pw>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 12:00:30PM +0800, Vladimir Nikishkin wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> userspace nework stack. With nolocalbypass the packets are always
> forwarded to the userspace network stack, so userspace programs,
> such as tcpdump have a chance to process them.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
> v2=>v3: 1. replace fputs with print_string                                                                                                     2. fix 77 char line length                                                                                                             3. fix typos and improve man page                                                                                                      4. reformat strcmp usage                                                                                                        this patch matches commit 69474a8a5837be63f13c6f60a7d622b98ed5c539                                                                     in the main tree.                                                                                                                      

The changelog is corrupted

[...]

> +.sp
> +.RB [ no ] localbypass
> +- if FDB destination is local, with nolocalbypass set, forward encapsulated
> +packets to the userspace network stack. If there is a userspace process
> +listening for these packets, it will have a chance to process them. If
> +localbypass is active (default), bypass the userspace network stack and

s/userspace/kernel/

> +inject the packets ingit to the target VXLAN device, assuming one exists.

s/ingit/into/ ?

