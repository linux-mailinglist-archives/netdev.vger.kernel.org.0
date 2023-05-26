Return-Path: <netdev+bounces-5609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F447123FF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72C5A1C20FD1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A8D1549E;
	Fri, 26 May 2023 09:48:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F9E11C84
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:48:23 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0E5B3;
	Fri, 26 May 2023 02:48:22 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51456387606so748518a12.1;
        Fri, 26 May 2023 02:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685094501; x=1687686501;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RvBpCfcgBfq+TTHR4XXBywiR+cKDsO3EJnjHG46eiyI=;
        b=TChFGd7Y1k6dSQ6LFy1/fB482Lf7c+I3XtPjqRvs1ibBWeyN1xWAzQR8IyEKPXcSbw
         9xlqRWxOaIiia8xxZEG/VXqkThynX5agnxJfT3shAoAPTTZT0R1QINfHkrwdASQEzjIX
         4NxQSmZPmcYC6ZyR3PqYwVP8bdXJTaP2tFDb4Ez4CY9473l+Nzg9Zjjm6U1PgDxF2zzw
         sPW93TsfouXxomu4yFoEumPzSy6I1q/A+BUvPfUGvbmSitZKaRHOJqlZqMF0QV/zOLud
         6vupxqFqHXn87zDyt4AHE5hseZCWf+BYn98mcVijxPsflgouhKUA0xQjR61yX/WkpiuT
         ME/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685094501; x=1687686501;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RvBpCfcgBfq+TTHR4XXBywiR+cKDsO3EJnjHG46eiyI=;
        b=RKj5MapZ0yTAMH/lSIjuMfd+ERoOpdujXlV2DCRyTPDYqael8eYD475FYc6qo6+8aR
         7MERF6ZmB7W7nfhkf47fOSUstth08e9aaVE0ppQ11zzsWV7v9N8m0QaWU3U4OS2NZV3l
         X6XXpiXw4u3wU8zwN6x82xpMW2CeS4IafV83IBZeqgJ3DaCUdvRXGxt5KEFWx1lmdlS/
         FZF0TVh/zkLBLqsV4FZpW+NYNaIjp8JRNGHnxP9Lj/+gXXnR+cgShEakcV0zY+xgCB2J
         GeuLC5ap0v06ctYa5QvmszVJYnzwIm2YyW8Rhkmwbl6BSMFsSmhE9YmQxyf2FoLRCwoU
         stqQ==
X-Gm-Message-State: AC+VfDxE8q/LwXgaCHpPtJnNGhmuuJJivFn89JJ3Uuxhi+oV53sqqYxk
	vq6kS1GCpjK9erxw+pb0Qc8=
X-Google-Smtp-Source: ACHHUZ5484ZTFeoU13Z6zr8eadz/N4C4k1DEp9LNRPLgprzBk63f1yfx7F/tqm20ABBQs7tdt21BiQ==
X-Received: by 2002:aa7:cb50:0:b0:50c:358:1eba with SMTP id w16-20020aa7cb50000000b0050c03581ebamr808347edt.35.1685094500539;
        Fri, 26 May 2023 02:48:20 -0700 (PDT)
Received: from [192.168.0.107] ([77.124.85.177])
        by smtp.gmail.com with ESMTPSA id d8-20020a50fb08000000b00502689a06b2sm1367218edq.91.2023.05.26.02.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 02:48:20 -0700 (PDT)
Message-ID: <e1e3dea5-a393-180a-805a-a944ec778041@gmail.com>
Date: Fri, 26 May 2023 12:48:15 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] ice: Don't dereference NULL in ice_gns_read error
 path
Content-Language: en-US
To: Simon Horman <horms@kernel.org>,
 Jesse Brandeburg <jesse.brandeburg@intel.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>,
 Karol Kolacinski <karol.kolacinski@intel.com>,
 Sudhansu Sekhar Mishra <sudhansu.mishra@intel.com>,
 Dan Carpenter <dan.carpenter@linaro.org>, intel-wired-lan@lists.osuosl.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230525-null-ice-v1-1-30d10557b91e@kernel.org>
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20230525-null-ice-v1-1-30d10557b91e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 25/05/2023 13:52, Simon Horman wrote:
> If pf is NULL in ice_gns_read() then it will be dereferenced
> in the error path by a call to dev_dbg(ice_pf_to_dev(pf), ...).
> 
> Avoid this by simply returning in this case.
> If logging is desired an alternate approach might be to
> use pr_err() before returning.
> 
> Flagged by Smatch as:
> 
>    .../ice_gnss.c:196 ice_gnss_read() error: we previously assumed 'pf' could be null (see line 131)
> 
> Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---

LGTM.


Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

