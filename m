Return-Path: <netdev+bounces-4821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC7EC70E909
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 00:23:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CA5B1C20905
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB9A12B76;
	Tue, 23 May 2023 22:23:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F94BBE58
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:23:23 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95E9C5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:23:20 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64d2e8a842cso42906b3a.3
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 15:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684880600; x=1687472600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saD0Aw6lyfVJGsq9pqwqldricERkudrwliz8LkKRU+s=;
        b=yaVDWQP8mJWowKTwMabpjeh2Wi2gBZkoanchRino8Qx3ieeN+LpmtiYmo/QnFAxlPb
         TfTybE7omZoTHxftbaZF+WFkOpje2tPmH2o8E2Q0dBh7B6WiZ+/yNPOqc/tn2TdVq+7I
         lHgRgs5mVBAzxeeQtak9J5iRnhujvujFo+pmHa9SKc4En19patGmTbhebWhtf4sgUGoK
         3VWpsknQcTJjAah96WMeZAv66pH5JO2Xkyde4TGycn9fsAoR+tBTtIIauD9wOXtlb7bg
         2htm+t2xA+0CaKzSsMne8MMGL6V/bXvcYCVbK8EBZTGTh3LXAwaN/la5+HTUmyVNd85H
         J9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684880600; x=1687472600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saD0Aw6lyfVJGsq9pqwqldricERkudrwliz8LkKRU+s=;
        b=BgCAwHYBKSaLK3hODFs3kPFvQHAv6zRes98sMqG5uh8atxlgsEPrt63rmA+eY6Supe
         ci4Sgpew7DplU5SRmXxjjjNaproCDFAsQGW8rjxsIqYHg0RzNhDNtM+fVoRMLNzsLYjW
         71zDmVfxI9mpUsPxrjxeE/WG6Zs+vAmvBMllc2UPaxzwdCVKwPus7/AGmqqsm1vWhhgQ
         wM1ued4xDk2s90Qmh0OBAJFU2Ehxh8XgR04Vjo3YvSS1zponhh2fF69fgPE99uKtpE/W
         u7rbeoEMbOpEmLoAeFrl7uBUzAu1KLSHJQIyiK7cno9lVS+6002r7NXy4PCydtpsF344
         Pj+Q==
X-Gm-Message-State: AC+VfDzuuj69JqzWFb55ws/pYSn+0fBPypedFTj7hBMFLhbZsNH4NlQC
	Bsg8AdOTwfDujYZsK2/4teJFTQ==
X-Google-Smtp-Source: ACHHUZ63HlWFYy64NeICwrHBAqCExSChM4zSOFcqdOYw8CVetJEpkbrOHTfgKV0ec/s6d1wDYOPgPw==
X-Received: by 2002:a05:6a00:1a0f:b0:64d:88b:a342 with SMTP id g15-20020a056a001a0f00b0064d088ba342mr414881pfv.30.1684880600091;
        Tue, 23 May 2023 15:23:20 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id z19-20020aa785d3000000b0064ca1fa8442sm6461282pfn.178.2023.05.23.15.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 15:23:19 -0700 (PDT)
Date: Tue, 23 May 2023 15:23:17 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrea Claudi <aclaudi@redhat.com>
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
 razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
 eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v6] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <20230523152317.4cd1b838@hermes.local>
In-Reply-To: <ZG0H0OYaKlni3Je9@renaissance-vector>
References: <20230523044805.22211-1-vladimir@nikishkin.pw>
	<20230523090441.5a68d0db@hermes.local>
	<ZG0H0OYaKlni3Je9@renaissance-vector>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 23 May 2023 20:37:04 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> Stephen, I'll try to summarize the discussion we had in v5 here.
> 
> - We agree that it's a good idea to have JSON attributes printed both
>   when 'true' and 'false'. As Petr said, this makes the code less error
>   prone and makes it clear attribute is supported.
> - I have some concerns about printing options only when non-default
>   values are set. Non-JSON output is mostly consumed by humans, that
>   usually expects something to be visible if present/true/enabled. I
>   know I'm advocating for a change in the iproute output here, and we
>   usually don't do that, but I argue there's value in having a less
>   cluttered and confusing output.
> 
>   For example, let's take what you see with a default vxlan:
>   $ ip link add type vxlan id 12
>   $ ip -j link show vxlan0
>   [...] udpcsum noudp6zerocsumtx noudp6zerocsumrx [...]
> 
>   IMHO printing only "udpcsum" is enough to make the user aware that
>   the "udpcsum" feature is enabled and the rest is off.
> 
> I'm not against Vladimir's change, of course. But I would be very happy
> if we can agree on a direction for the output from now on, and try to
> enforce it, maybe deprecating the "old way" to print out stuff step by
> step, if we find it useful.
> 
> What do you think?
> Andrea

If you look at the other RFC patch set. It does change to always
print the state of all options.

