Return-Path: <netdev+bounces-8275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5DA37237E1
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 08:40:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 427FC1C20E3E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 06:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3A6D3D92;
	Tue,  6 Jun 2023 06:40:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9237190
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:40:08 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FB4C7
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 23:40:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-5149e65c218so8600343a12.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 23:40:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1686033605; x=1688625605;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5CQCcAk8cEBQ3CEoalpz0YnoxrTUAZVDO6QjioJ/VHs=;
        b=4h4yDAiC8US97kO+SbQnuRMoGzIFSq3M1m2M/91IFA+cY4kR62CnT60fwWy5IMUHNx
         TlSScr/ulSssWvXg4qCEJQucIH9lAQ9Shes0pWOsGxXfuYMGGOiNBtcOki7ykLF2adPt
         Os2Rp7/pBRTT83PkJhjHyKu+66P0xJmVeF1ik1ddQRpZuxO8WD6NyE+VwGGyowYM5y42
         x6vAwWfKXfAPZojuQRXMUquZZpWdWEZwjo/MNfNRXruIeriXFJAZa63nSIG0cW3WjrmD
         A7HKQvGS8KeLbyn1h2GiwHTllOAcodETJD6CsogOiTntwcG+rvJpPn/bRtv+nuLkILuW
         aCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686033605; x=1688625605;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5CQCcAk8cEBQ3CEoalpz0YnoxrTUAZVDO6QjioJ/VHs=;
        b=B9j8ndug0DVj5hZImRJXUBUdDjmlmpzAfKUE9/HAQpJZrjqEKN+rwlU1LjhZ/9V0u7
         TkK2v2uphMOjwN89pyx9ioUdxMqPNVP8nAfJvqkyAxpx0W7g+FudXXzyL2ho8kUyJ70u
         AhxszGIypPkH0UqE6HCLhooLtM5GR04ACxTPjgbgv1j5zeeREb/PN//Ef7Vs7XuLyY4a
         ZkNP4YhFNWDr7b9yvhayzJjd1YgZ0r2vZG0Flb0sjdigkyZ9C7V2Px4P+cbODxxgJcU1
         3+1VsMcsyJuxIrCo/tDLZwwlI8yTJBocl9yXAEi6mfhE0sFss5F7cwQlkpTd+Q1DYd0n
         nb1A==
X-Gm-Message-State: AC+VfDx9sEMjmBn/hNQAy5KD6U3MdeZ+3FsqGx3ogWnVwgSANG0s5cU2
	Mx3e1qVEDpFEfrKcSGxmofppNQ==
X-Google-Smtp-Source: ACHHUZ4tVSlfRhwwxcVaeSb8Y5DxlirY5q7dNhZsiiHjf1tXnjQrd4IhWdFfAIB7/jL9RfwPtRtWzA==
X-Received: by 2002:a17:907:2da8:b0:978:6e73:e66d with SMTP id gt40-20020a1709072da800b009786e73e66dmr1090329ejc.1.1686033605558;
        Mon, 05 Jun 2023 23:40:05 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id y11-20020a17090629cb00b009660e775691sm5121453eje.151.2023.06.05.23.40.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 23:40:05 -0700 (PDT)
Message-ID: <158ca1dd-cfe1-6ba9-87ea-52c9a04d585e@blackwall.org>
Date: Tue, 6 Jun 2023 09:40:03 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2-next v8] ip-link: add support for nolocalbypass
 in vxlan
To: Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
 idosch@nvidia.com, liuhangbin@gmail.com, eyal.birger@gmail.com,
 jtoppins@redhat.com, David Ahern <dsahern@gmail.com>
References: <20230606023202.22454-1-vladimir@nikishkin.pw>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230606023202.22454-1-vladimir@nikishkin.pw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/06/2023 05:32, Vladimir Nikishkin wrote:
> Add userspace support for the [no]localbypass vxlan netlink
> attribute. With localbypass on (default), the vxlan driver processes
> the packets destined to the local machine by itself, bypassing the
> userspace nework stack. With nolocalbypass the packets are always
> forwarded to the userspace network stack, so userspace programs,
> such as tcpdump have a chance to process them.
> 
> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
> ---
> v7=>v8: fix indentation. Make sure patch applies in iproute2-next.
> 
> ip/iplink_vxlan.c     | 10 ++++++++++
>  man/man8/ip-link.8.in | 10 ++++++++++
>  2 files changed, 20 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



