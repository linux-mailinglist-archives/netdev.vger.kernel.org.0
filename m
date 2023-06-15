Return-Path: <netdev+bounces-10953-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF31C730C40
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 02:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD1F21C20E28
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC61136E;
	Thu, 15 Jun 2023 00:36:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E1318F
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 00:36:22 +0000 (UTC)
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D123269A
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:36:21 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-30fa23e106bso4468463f8f.3
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 17:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686789379; x=1689381379;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHkXaOd7qRKf037qagBHI0+WXbHOgwyJxZL5RlVdXyA=;
        b=nwKdBkTDeGw3t6tVoNLO0Ta/nOVLlYIYz0B91FE7Qp25EfPXE81EKy5xGlQ6GxRCQ5
         zVdcic1tjsDQG2UsBExKIkPUjewb07Q35A+wN04HUsEy6KBXkQE8C5i32tZhm5wDjFSR
         Vq+rO7IJs3E4N9Fkq8BxVMBbiq4I3j2UEiXucgblucTykJDAEJOxpnnn8Fa1e0c2Gu1i
         GlDrYlRrLmI9g/pUoyszwHxe4r7TSAOWmLsEnZSohR0+gfdqFjoFNhYqpXSu6GEj+Mrf
         qYnYslHAnQnGNaMSjFW6NjLD65d4/EnDNBgyLAadgkQer/fFxnXT4aD8SDLAI6jIVrWy
         ndrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686789379; x=1689381379;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zHkXaOd7qRKf037qagBHI0+WXbHOgwyJxZL5RlVdXyA=;
        b=DAqNvjo4FqqaS/PPLxIL2ytufGhkRSxDCQSlkr/U7cd5lJXDMnmmy/smhu1ahcBnNp
         WnQ0GE4uZzjN5L6LycR0TnG78ZzEj+ANp6GhzXqOYo2bCf76hoLwQTnR4OZbgFjrNjNy
         i+6/EYMMXPJvpO2x+LRqLPKf/fy/Ab/C90oCCNfQEu4KWbyWS0eQ7B3dxBunER/1Wie0
         v53GnMG09z9G2m3+QodFmxeRkElX5FToGexgxpeVEJN6vTbCOHv6jDob+qFLFhQ4wx/K
         qNsbnhdaolM93CzWnkMVfGOVSYq3lD1hllufIkn/orI1WoHmpfFZoByquOws+qJLzdHv
         Y0rg==
X-Gm-Message-State: AC+VfDxHIf/NXBHGHDVBUcifKlVLf61tMXxeXnskpPmiBCegvzEmWlRW
	DFxN7Hv630LfbDp/EaxE0EdM5GYWrWc=
X-Google-Smtp-Source: ACHHUZ5+Hn9I0W9SWFBtrgxmgnLUP25oY6spET1+RGnm6FuO3kOOwwnIJPXaBZ/rmcZKorOJUPUEjQ==
X-Received: by 2002:a5d:6e11:0:b0:30f:b045:8b60 with SMTP id h17-20020a5d6e11000000b0030fb0458b60mr7302118wrz.69.1686789379349;
        Wed, 14 Jun 2023 17:36:19 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id 10-20020a05600c24ca00b003f7e4d143cfsm18639428wmu.15.2023.06.14.17.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 17:36:18 -0700 (PDT)
Subject: Re: [PATCH net] sfc: use budget for TX completions
To: Jakub Kicinski <kuba@kernel.org>, Martin Habets <habetsm.xilinx@gmail.com>
Cc: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-net-drivers@amd.com, Fei Liu <feliu@redhat.com>
References: <20230612144254.21039-1-ihuguet@redhat.com>
 <ZIl0OYvze+iTehWX@gmail.com> <20230614102744.71c91f20@kernel.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <a4e26da4-cb09-7537-60ff-fd00ec4c49d6@gmail.com>
Date: Thu, 15 Jun 2023 01:36:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230614102744.71c91f20@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 14/06/2023 18:27, Jakub Kicinski wrote:
> The documentation is pretty recent. I haven't seen this lockup once 
> in production or testing. Do multiple queues complete on the same CPU
> for SFC or something weird like that?

I think the key question here is can one CPU be using a TXQ to send
 while another CPU is in a NAPI poll on the same channel and thus
 trying to clean the EVQ that the TXQ is using.  If so the NAPI poll
 could last forever; if not then it shouldn't ever have more than 8k
 (or whatever the TX ring size is set to) events to process.
And even ignoring affinity of the core TXQs, at the very least XDP
 TXQs can serve different CPUs to the one on which their EVQ (and
 hence NAPI poll) lives, which means they can keep filling the EVQ
 as fast as the NAPI poll empties it, and thus keep ev_process
 looping forever.
In principle this can also happen with other kinds of events, e.g.
 if the MC goes crazy and generates infinite MCDI-event spam then
 NAPI poll will spin on that CPU forever eating the events.  So
 maybe this limit needs to be broader than just TX events?  A hard
 cap on the number of events (regardless of type) that can be
 consumed in a single efx_ef10_ev_process() invocation, perhaps?

-ed

