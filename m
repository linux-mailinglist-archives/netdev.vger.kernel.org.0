Return-Path: <netdev+bounces-9740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0938E72A597
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:51:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 58A061C211C1
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A53E23D67;
	Fri,  9 Jun 2023 21:50:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF3223C8A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:50:29 +0000 (UTC)
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCF02D52
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:50:28 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7606d460da7so93389239f.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 14:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686347428; x=1688939428;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0opeDykdlitjLDC/1XpriL3PIwQW/KDDW1IeM9GcFgY=;
        b=IQL6y3pe2z4c980HLj2cMn84dkrAmvUtoTf1kFbgklBXjCMjOak44qjh567V1zPlEI
         2+/Nyzdna2BquU4mjmjb61UeeWLBaURtKwIECpXXaMfyPApHch7t57/1OWSw8ORAkWk8
         8bo15ThqL3TP+LGgaaf2ggcw/gmBydaoCa+s87vVNzaLbT/jYJR5pLL5NDtM/3XRzSSo
         Bp3FCqVoZ0s3X9PCiFrziPAynDzpEdk/gBwnfidR65BafBXfGYZWjss30OG6AWev3sku
         7w7yS7CTTeOjpsd0+b+miFW197KxfNsiRaDG1JvbRl8sjzkj2rpe+c8qaz8rKr5arvxj
         V/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686347428; x=1688939428;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0opeDykdlitjLDC/1XpriL3PIwQW/KDDW1IeM9GcFgY=;
        b=P3i0YX/rD2K5ZJXLRpwyqNtsiTPqPG1JdJOgvg/hphNjl0UbprcM2wyddsTo+1nH51
         4Tigf7ElvnyCY5C9SKARjGCiHQHMKPZs8GsEHloFd3533DoD55BllY8sh3Hvuy3/RwLv
         cZKOMbg5FO5hjfHwRVFDn2bFnsb0HeLrbVWx1kDa58ZrDvdt2QiML19/higqQSE8c4Rv
         eHgFrY5e6EI8qPEHJ8lfap/bz2UC0Wm/VX1bEyd3ck5IAUwB9yfLwmeYyxgb0eeqYo7q
         dAM2GEa0NjBCo7eOK9GRR5rONShXNus82EJalr+rvME72Iebxr6VsCS0Ook5fz/n8mxi
         H97Q==
X-Gm-Message-State: AC+VfDxL5EXy0cwXIQV3NgiXCClNhSxxHyF9RiXjQHP19AN1dPBYdTgN
	spnqic863xuK9puVxKF1Bw4=
X-Google-Smtp-Source: ACHHUZ7TiO+4FxAPkwVbe4uEho9N5HF6D4yPNHfjiq6hv1lR9UJfEa+ATBtfjCif/UHlni+NKEagjg==
X-Received: by 2002:a6b:5b03:0:b0:777:b85d:d3f4 with SMTP id v3-20020a6b5b03000000b00777b85dd3f4mr2491429ioh.21.1686347427866;
        Fri, 09 Jun 2023 14:50:27 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:446d:438:f71e:b310? ([2601:282:800:7ed0:446d:438:f71e:b310])
        by smtp.googlemail.com with ESMTPSA id d7-20020a5e8a07000000b00760e7a343c1sm1308558iok.30.2023.06.09.14.50.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 14:50:27 -0700 (PDT)
Message-ID: <eefe7871-caaa-3778-b143-517b16a83607@gmail.com>
Date: Fri, 9 Jun 2023 15:50:26 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH iproute2-next] f_flower: Add l2_miss support
Content-Language: en-US
To: Stephen Hemminger <stephen@networkplumber.org>,
 Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, jiri@nvidia.com, razor@blackwall.org,
 petrm@nvidia.com
References: <20230607153550.3829340-1-idosch@nvidia.com>
 <20230607095124.2dda16ec@hermes.local>
From: David Ahern <dsahern@gmail.com>
In-Reply-To: <20230607095124.2dda16ec@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/23 10:51 AM, Stephen Hemminger wrote:
> On Wed, 7 Jun 2023 18:35:50 +0300
> Ido Schimmel <idosch@nvidia.com> wrote:
> 
>> +		print_uint(PRINT_ANY, "l2_miss", "  l2_miss %d",
>> +			   rta_getattr_u8(attr));
> 
> Use %u for unsigned?

fixed up and applied

