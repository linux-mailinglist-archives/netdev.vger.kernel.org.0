Return-Path: <netdev+bounces-7339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E9771FC40
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2EF91C20C17
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 08:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E0F5687;
	Fri,  2 Jun 2023 08:42:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A2A53A0
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:42:28 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D6118D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 01:42:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-5147aee9d7cso2580259a12.3
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 01:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685695341; x=1688287341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ulq4OZiXYAieRrRq88dpEIE3RYucbrr7NukGwo0ANhU=;
        b=0KKmwxtDonKpBq+O708ULhKF4QlbPgf94kGe2VLNAjZ3+/QOc9xqt1INoayrixM/U3
         s3/WjddTz2GQ2z1bJaCKLSoShDhd/tLJZ0hO4VQ7IYRmCe9BsbKIk+vGYY7uD54N5YHI
         SKhalpFYKOOO79+ci8cH1Q8vQr3az7dBFptKctQuHtqF0tVTr798eU8JY+kzEBHYKdlo
         EG8R7khB6g31qGyNZT345mKl0EmenU+e6K/pciw7ZywPuuqi2j/5QP5yufxUDHoDaNRA
         s6S7XLUKEn48WzIYTvDaegOaUIB/DAjU7YKW+yUekoAuNWh3mjr1nLbxGBa0KCmVbuvz
         prag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685695341; x=1688287341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ulq4OZiXYAieRrRq88dpEIE3RYucbrr7NukGwo0ANhU=;
        b=lYdlC8Dbsr4ydUqQfCjytNrF64VYjWCuo7x0/yYW3DMJqYW9LT+EpQe2sQiB16FhEK
         7cLEZPPFYKTlukBSngNId7ahlB7cMJmqSdHXJ535rUZ9YGfCahbxCP/rgdp7/I34NtjU
         /we+EKarON8jzSuy8rfl91Bb0hcleU4vJlssnQYc6SXr+eNz03uZsu1I8+7afJ6HIGdQ
         mt+7BB10VPiTTyMOQz6F+m6iN7EsJo+xOffvxTEq7T0OS1+fqYv4C1mf5T3gwtOpurHE
         LgKM9DzcUJNSXJStrp8kzS7n3Lk+62cBF9eXwWYSZKq7ARsBvJXrykH8tf0C7/tPOQDt
         dgyw==
X-Gm-Message-State: AC+VfDy4mb55lQlafrxWnZVUMIWQG5hfnvdE1etPRrG55aDFWBg5adw0
	iaVn8nORg6+BvcJUM1kl4gGcbQ==
X-Google-Smtp-Source: ACHHUZ5ZsLXqx11LfoQxvoMVtqGUxOmwKXFSjmo5X8DLvf5yXtEl91+0aCV+faaobRckakgFHhjGHA==
X-Received: by 2002:a17:907:2d11:b0:973:ed4a:375f with SMTP id gs17-20020a1709072d1100b00973ed4a375fmr9939546ejc.46.1685695341354;
        Fri, 02 Jun 2023 01:42:21 -0700 (PDT)
Received: from [10.44.2.5] ([81.246.10.41])
        by smtp.gmail.com with ESMTPSA id o9-20020a1709064f8900b0094e6a9c1d24sm500066eju.12.2023.06.02.01.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 01:42:21 -0700 (PDT)
Message-ID: <68035bad-b53e-91cb-0e4a-007f27d62b05@tessares.net>
Date: Fri, 2 Jun 2023 10:42:20 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next RFC] net: skip printing "link become ready" v6
 msg
Content-Language: en-GB
To: David Ahern <dsahern@kernel.org>,
 Stephen Hemminger <stephen@networkplumber.org>
Cc: mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Mat Martineau <martineau@kernel.org>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20230601-net-next-skip_print_link_becomes_ready-v1-1-c13e64c14095@tessares.net>
 <20230601103742.71285cf1@hermes.local>
 <63ee166d-6b33-2293-4ff2-2c42d350580a@kernel.org>
From: Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <63ee166d-6b33-2293-4ff2-2c42d350580a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Stephen, David,

On 01/06/2023 19:43, David Ahern wrote:
> On 6/1/23 11:37 AM, Stephen Hemminger wrote:
>> On Thu, 01 Jun 2023 16:34:36 +0200
>> Matthieu Baerts <matthieu.baerts@tessares.net> wrote:
>>
>>> This following message is printed in the console each time a network
>>> device configured with an IPv6 addresses is ready to be used:
>>>
>>>   ADDRCONF(NETDEV_CHANGE): <iface>: link becomes ready
>>>
>>> When netns are being extensively used -- e.g. by re-creating netns with
>>> veth to discuss with each other for testing purposes like mptcp_join.sh
>>> selftest does -- it generates a lot of messages: more than 700 when
>>> executing mptcp_join.sh with the latest version.
>>
>> Don't add yet another network nerd knob.
>> Just change message from pr_info to pr_debug.
> 
> +1

Thank you both for your quick replies! I will send a patch doing that.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net

