Return-Path: <netdev+bounces-7640-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F131F720E7E
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 09:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63322281B93
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 07:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB8FBE40;
	Sat,  3 Jun 2023 07:35:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24E79E0
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:35:17 +0000 (UTC)
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B40E81A6
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:35:15 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-30aeee7c8a0so2153772f8f.1
        for <netdev@vger.kernel.org>; Sat, 03 Jun 2023 00:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1685777714; x=1688369714;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vS/oCChXdrXNuDjzTXaluarU5mcGap3sB8dhYCuURjc=;
        b=44DSy4GqZpuTQIEqmv1rl0FyYY8rfxsFPIZSauzX8vhKLg3IfpCpA5S34Dex0+Hw/c
         UdkHEc9mOwm/qPDGAOjf018P15ccFBzclRId24hPjhAcK2kiuehUrih8C5pp64tW+dBP
         K4jdc7UrLanW+lmybqoSK1JjSwL1W2hvTN1ALHrbAhsJam1w99vv5pj1gPSk62Iyqa9y
         WW3Zcvu1aUPbWMRwAFLM1QMBLMqgXdDr35OtYSq+t+eQq9b7bLPPEcPXZg2udxdOh1sT
         JxJCh07S9aV1KGaTJwZ1VW81UqsxsgbZW6JmUfohWet8HpLZ+M9utuEVcadW+RR6L6ZY
         yX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685777714; x=1688369714;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vS/oCChXdrXNuDjzTXaluarU5mcGap3sB8dhYCuURjc=;
        b=SMFC5CK4GY1aV9ZNGUD+SHr5ELFJpylw107B44r+HTc7NVVZrJRNK6hCD5mr2zH+rk
         0MSguhDF+yCc6UtD89f2DXBU8H/xRlDlzRGdmA5cq7Xo/PMnHmtPLPXfDuJNroYqgW+L
         4VE1IzWPcASOjK2LX15gKiCge9J3IWs4ZNF0h3MRV4zyhGfk4dKhi5pz9wYGInM0Oc2M
         ZYwPx4TGmG60LNmWxPirThGpWi+e/w3T/oPYD8sczjF6mZaX08rpnTzir03Ttskk+kwk
         EogLIvTI8lb/2TAbAecwMxmkaJHJLP2G+KkN6pVd4Hs0M69o250y7b2wfAcH5peYkvKy
         I7Uw==
X-Gm-Message-State: AC+VfDxwGjXd2KUDfUF3i2I6nFtxqsXUjjZNemAdDWVCzFA9Wm8BXg63
	wJ+7SCvHfKuEWrW5y+xlthAKEQ==
X-Google-Smtp-Source: ACHHUZ6u4bDI0ImNWdiKQNqrgXsOM6hawopfb0aVI0jMQKjei4E1qzszBSjaRsTtfxI3pikMwmAZoA==
X-Received: by 2002:a5d:6790:0:b0:30a:d9e6:7acd with SMTP id v16-20020a5d6790000000b0030ad9e67acdmr1561265wru.6.1685777714121;
        Sat, 03 Jun 2023 00:35:14 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:f035:39ca:d5b0:1b0? ([2a02:578:8593:1200:f035:39ca:d5b0:1b0])
        by smtp.gmail.com with ESMTPSA id i8-20020adfdec8000000b0030796e103a1sm3724234wrn.5.2023.06.03.00.35.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Jun 2023 00:35:13 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------ghqasT1MlglPr5sFfYBBlhBs"
Message-ID: <6f8d3039-e8cf-2e9d-50e3-a48770f624b5@tessares.net>
Date: Sat, 3 Jun 2023 09:35:12 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v3] net/ipv4: ping_group_range: allow GID from
 2147483648 to 4294967294 - manual merge
Content-Language: en-GB
To: Akihiro Suda <suda.gitsendemail@gmail.com>, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, segoon@openwall.com, kuniyu@amazon.com
Cc: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>, suda.kyoto@gmail.com,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20230601031305.55901-1-akihiro.suda.cz@hco.ntt.co.jp>
From: Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20230601031305.55901-1-akihiro.suda.cz@hco.ntt.co.jp>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a multi-part message in MIME format.
--------------ghqasT1MlglPr5sFfYBBlhBs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

On 01/06/2023 05:13, Akihiro Suda wrote:
> With this commit, all the GIDs ("0 4294967294") can be written to the
> "net.ipv4.ping_group_range" sysctl.
> 
> Note that 4294967295 (0xffffffff) is an invalid GID (see gid_valid() in
> include/linux/uidgid.h), and an attempt to register this number will cause
> -EINVAL.
> 
> Prior to this commit, only up to GID 2147483647 could be covered.
> Documentation/networking/ip-sysctl.rst had "0 4294967295" as an example
> value, but this example was wrong and causing -EINVAL.

FYI, we got a small conflict when merging 'net' in 'net-next' in the
MPTCP tree due to this patch applied in 'net':

  e209fee4118f ("net/ipv4: ping_group_range: allow GID from 2147483648
to 4294967294")

and this one from 'net-next':

  ccce324dabfe ("tcp: make the first N SYN RTO backoffs linear")

----- Generic Message -----
The best is to avoid conflicts between 'net' and 'net-next' trees but if
they cannot be avoided when preparing patches, a note about how to fix
them is much appreciated.

The conflict has been resolved on our side[1] and the resolution we
suggest is attached to this email. Please report any issues linked to
this conflict resolution as it might be used by others. If you worked on
the mentioned patches, don't hesitate to ACK this conflict resolution.
---------------------------

Regarding this conflict, I simply took the modifications from both sides.

Cheers,
Matt

[1] https://github.com/multipath-tcp/mptcp_net-next/commit/f170c423f567
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
--------------ghqasT1MlglPr5sFfYBBlhBs
Content-Type: text/x-patch; charset=UTF-8;
 name="f170c423f56781e5957cd5b3c4de781515ed2c2c.patch"
Content-Disposition: attachment;
 filename="f170c423f56781e5957cd5b3c4de781515ed2c2c.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWNjIG5ldC9pcHY0L3N5c2N0bF9uZXRfaXB2NC5jCmluZGV4IDZhZTMzNDVhM2Jk
Ziw4OGRmZTUxZTY4ZjMuLjBiYjViMDMwODhlNwotLS0gYS9uZXQvaXB2NC9zeXNjdGxfbmV0
X2lwdjQuYworKysgYi9uZXQvaXB2NC9zeXNjdGxfbmV0X2lwdjQuYwpAQEAgLTM0LDkgLTM0
LDggKzM0LDkgQEBAIHN0YXRpYyBpbnQgaXBfdHRsX21pbiA9IDEKICBzdGF0aWMgaW50IGlw
X3R0bF9tYXggPSAyNTU7CiAgc3RhdGljIGludCB0Y3Bfc3luX3JldHJpZXNfbWluID0gMTsK
ICBzdGF0aWMgaW50IHRjcF9zeW5fcmV0cmllc19tYXggPSBNQVhfVENQX1NZTkNOVDsKICtz
dGF0aWMgaW50IHRjcF9zeW5fbGluZWFyX3RpbWVvdXRzX21heCA9IE1BWF9UQ1BfU1lOQ05U
OwotIHN0YXRpYyBpbnQgaXBfcGluZ19ncm91cF9yYW5nZV9taW5bXSA9IHsgMCwgMCB9Owot
IHN0YXRpYyBpbnQgaXBfcGluZ19ncm91cF9yYW5nZV9tYXhbXSA9IHsgR0lEX1RfTUFYLCBH
SURfVF9NQVggfTsKKyBzdGF0aWMgdW5zaWduZWQgbG9uZyBpcF9waW5nX2dyb3VwX3Jhbmdl
X21pbltdID0geyAwLCAwIH07Cisgc3RhdGljIHVuc2lnbmVkIGxvbmcgaXBfcGluZ19ncm91
cF9yYW5nZV9tYXhbXSA9IHsgR0lEX1RfTUFYLCBHSURfVF9NQVggfTsKICBzdGF0aWMgdTMy
IHUzMl9tYXhfZGl2X0haID0gVUlOVF9NQVggLyBIWjsKICBzdGF0aWMgaW50IG9uZV9kYXlf
c2VjcyA9IDI0ICogMzYwMDsKICBzdGF0aWMgdTMyIGZpYl9tdWx0aXBhdGhfaGFzaF9maWVs
ZHNfYWxsX21hc2sgX19tYXliZV91bnVzZWQgPQo=

--------------ghqasT1MlglPr5sFfYBBlhBs--

