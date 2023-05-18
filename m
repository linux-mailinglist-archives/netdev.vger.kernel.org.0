Return-Path: <netdev+bounces-3689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D70AD708550
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 17:49:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 195B928189E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:49:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3491621097;
	Thu, 18 May 2023 15:49:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2571653A8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 15:49:13 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB79FB
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:49:11 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ae4c5e1388so22579745ad.1
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684424951; x=1687016951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51O3YwLrNhaRl52Xo7rglYvdZvK+Ec7onbfAhIMsDFA=;
        b=UPl7s2SrmrV8YdeijglnUr1dyZTxFCfODYwzbmIFEyn+P68g3VcqPQMGbvqWLuurP6
         FUnnSMoFM21RBZPVljlPmcnjS6FTxytrBhpXlrjWGxjJdy2P8fLFDFQnzlylGRuvmKGJ
         YIhZ1RYZw51Rs534dwtet/diM3aiRSBszj0agwz0seE8puNvK0Fwh7WpwSCJkLYmVjT/
         53OSR947EWbqylf8H0bKBgo958rEZzd9R66dkAS9Xqk6KEAiP2aFDUVoa4tTczmu9whY
         kVbh7f49tTRe1PkuIl0kT3CFKn38L1odzMj2cT5Wl9bdFhLmaG7L/B7dwMk0WFsUG/qF
         4bHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684424951; x=1687016951;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=51O3YwLrNhaRl52Xo7rglYvdZvK+Ec7onbfAhIMsDFA=;
        b=azDTN4vulpUncdIyWomaxJwE3eJyvOcCerN/sNR5bB+zapEkIaSW9D9BOz+MVddJ79
         C+PT4DPLXWIp1JrRnSfx654hgdGOY8JWNgvCLZb2WB/aHq8h61HmNbKfPlhsIPqsPUry
         vKcGBW89VWsynjsenYu+THaz/tgd/AUzZHghOVEqgwcgfMgZ9eaYISjVSFGJfTu4FjKD
         NiqNxQ3aWnjSVGMWx3lBv5FQNnISdW0iPxjeXW8GgFG3RqOOtPP/J42Q+l6cLdMTx3Gi
         F3VPc0dPATWJfmwEBNOe4T6lEj6/cl9MtStWJK8SS2o3gG7efmC1GlCVvFVoEml2jqNa
         cZuA==
X-Gm-Message-State: AC+VfDzlCSuV+00RuEVV9ZdosQ3VRTXC211bnmHZOx+ypf0VCil4fhY4
	McQsALJCPoW8V3iFgTp1EbKnTw==
X-Google-Smtp-Source: ACHHUZ4bSvMdqzRzJpLW1aIfzYWe5mfma+gGuX1ECnhZ5hCzgepV7Y9xyouCuDWc1+BWbPY4tw11hQ==
X-Received: by 2002:a17:902:6b08:b0:1ab:18ea:f922 with SMTP id o8-20020a1709026b0800b001ab18eaf922mr2751986plk.52.1684424950716;
        Thu, 18 May 2023 08:49:10 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id j7-20020a654287000000b0051b595b26adsm1279042pgp.91.2023.05.18.08.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 08:49:10 -0700 (PDT)
Date: Thu, 18 May 2023 08:49:08 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v4] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <20230518084908.7c0e14d4@hermes.local>
In-Reply-To: <20230518134601.17873-1-vladimir@nikishkin.pw>
References: <20230518134601.17873-1-vladimir@nikishkin.pw>
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

On Thu, 18 May 2023 21:46:01 +0800
Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:

> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
> +
> +		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
> +		if (localbypass) {
> +			print_string(PRINT_FP, NULL, "localbypass ", NULL);
> +		} else {
> +			print_string(PRINT_FP, NULL, "nolocalbypass ", NULL);
> +		}
> +	}

You don't have to print anything if nolocalbypass.  Use presence as
a boolean in JSON.

I.e.
	if (tb[IFLA_VXLAN_LOCALBYPASS] &&
	   rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS])) {
		print_bool(PRINT_ANY, "localbypass", "localbypass", true);
	}

That is what other options do.
Follows the best practices for changes to existing programs: your
new feature should look like all the others.

