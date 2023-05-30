Return-Path: <netdev+bounces-6492-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 532A2716A1F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:54:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E953428120F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FBF41F192;
	Tue, 30 May 2023 16:54:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50891993D
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C67C433EF;
	Tue, 30 May 2023 16:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685465676;
	bh=vPQyIFgxVsqHdIX/qKp7H3EL0x5a5vFUNqB8Djp4MI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Wi2fu4m2iSHYlRY9EMe4vtlbIdcaGjMF6cPKbbt2kBcHRi2nmOe12LV7dt5BitEL5
	 00fnaTBwkTGAziZzvzPfmCXojzXrw9tB72qDaGL34i9bsaa4TrKNK5fqLbxP5MJ9Um
	 1wiWohaNrpzZcwj4Rs7SIgygXRu73eDVrNFedNkj9oubJGMzZY6YcV6pCkq9skn3B7
	 bJ7PCwFsUAYGCf43ZCekDoDKnxFVQ23YpzNt82iS+OAMLvEX9KYyvefQqj5oTYAfP9
	 hQc+nRBlrLMXUmZiFCvfITxnHQhnHxRTaPF0/BJ5HqCADxIKcGe8+oeme+5eB1nfIv
	 Kh6nGEQTeRPuA==
Date: Tue, 30 May 2023 09:54:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, saeedm@nvidia.com, moshe@nvidia.com,
 simon.horman@corigine.com, leon@kernel.org
Subject: Re: [patch net-next] devlink: bring port new reply back
Message-ID: <20230530095435.70a733fc@kernel.org>
In-Reply-To: <20230530063829.2493909-1-jiri@resnulli.us>
References: <20230530063829.2493909-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 May 2023 08:38:29 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In the offending fixes commit I mistakenly removed the reply message of
> the port new command. I was under impression it is a new port
> notification, partly due to the "notify" in the name of the helper
> function. Bring the code sending reply with new port message back, this
> time putting it directly to devlink_nl_cmd_port_new_doit()
> 
> Fixes: c496daeb8630 ("devlink: remove duplicate port notification")
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

FWIW it should be fairly trivial to write tests for notifications and
replies now that YNL exists and describes devlink..

