Return-Path: <netdev+bounces-7206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D744271F104
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0C331C210DA
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA9F4701C;
	Thu,  1 Jun 2023 17:43:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F20142501;
	Thu,  1 Jun 2023 17:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF30C433D2;
	Thu,  1 Jun 2023 17:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685641416;
	bh=b2gcd3dJB++dyO99vAGT9rIkgCvbeypWxYxoChQXHXY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tqHvoIYQCtkmBJcXfzi5Bifu/Ja0qfXqNcCvM0UurkX11FYxuANVpQz/bs7T1oB17
	 y01rsU+dhuiDX460ANq1Mwmh9Jtm1Xo8RJEMZU5MU9n4gkpBz5ZoPaOGXimV0f3lOk
	 2YRv3JH82u+zAIVBOW38Ik7Wj3bitGiT0oNQBzUichFAqwwI9tC2nVr9LhCN04FhA5
	 4twBsPeiO9izaWy30sOF0LftUlI2ieaxfOPsk9v15dZTqxkWJVP9uzrVvcebzPd4r3
	 NQzKJN9S883XO5iYq67+vbhfiHkDznmchHEwQ65cv65U705bdZroVMqDrPp7Gs6EkA
	 voErZ5DxEPriw==
Message-ID: <63ee166d-6b33-2293-4ff2-2c42d350580a@kernel.org>
Date: Thu, 1 Jun 2023 11:43:35 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next RFC] net: skip printing "link become ready" v6
 msg
Content-Language: en-US
To: Stephen Hemminger <stephen@networkplumber.org>,
 Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Mat Martineau <martineau@kernel.org>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net>
 <20230601103742.71285cf1@hermes.local>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230601103742.71285cf1@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/1/23 11:37 AM, Stephen Hemminger wrote:
> On Thu, 01 Jun 2023 16:34:36 +0200
> Matthieu Baerts <matthieu.baerts@tessares.net> wrote:
> 
>> This following message is printed in the console each time a network
>> device configured with an IPv6 addresses is ready to be used:
>>
>>   ADDRCONF(NETDEV_CHANGE): <iface>: link becomes ready
>>
>> When netns are being extensively used -- e.g. by re-creating netns with
>> veth to discuss with each other for testing purposes like mptcp_join.sh
>> selftest does -- it generates a lot of messages: more than 700 when
>> executing mptcp_join.sh with the latest version.
> 
> Don't add yet another network nerd knob.
> Just change message from pr_info to pr_debug.

+1

