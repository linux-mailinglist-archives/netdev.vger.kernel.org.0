Return-Path: <netdev+bounces-10797-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E40F73057D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:55:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D490D281010
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523822EC0D;
	Wed, 14 Jun 2023 16:55:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B8E7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:55:05 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222B61BC3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:55:01 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1b3be39e666so30352045ad.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686761700; x=1689353700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6LgA822bKKcxMBHVxX6v5W7L3vSWAmGDsxs16HkZGY=;
        b=c1ow5x401RjGlm7TOa38QPCRbvN6/VkUQ6pSSWZkGvprrpoyj5vLo8Di/jtAExbj21
         BHw8a+RwuD1AYKn6uMfxm5qckdugzwFRsQCuDzrmsb8iRtXZfVDN7ljoBuxko8OQVYor
         IGnzhQe1ej5SVKtiLnJt/c2WXjgWluDS7XqwPnfamLTb/XNqYqSWHgiHmIUIvDzQbQm3
         5AyPnJZa2PEpWCgfoxaWnKdbuHHHKCiQwquQKzbbeSLrwlKf2eu+h4oKNHVzVh6upMxg
         VMo18IlmET5awnOhusr4oc4L+8AeXlfppQLdQw8PJahIkeKwms5rTY6INicweKc1BwrV
         9Yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686761700; x=1689353700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L6LgA822bKKcxMBHVxX6v5W7L3vSWAmGDsxs16HkZGY=;
        b=i8/BFrsjojhgU1PYWabsehJQp9K9xVrOKSEemZSdYIsVNoqkoWVOEXizSyLbxqIi9f
         LhteCVIb/DAX2D9IWDWkWHdMi8EPSp2i7blP/8qbnJ9pOLl7xyLTvAXBAG+q/1v3MTG7
         JV8lndYy7t3/L1UprYubPbqw5e+JbLXtKG4WvHRfLtIKbWzvxmKXjt7hilu9gOqfBTrP
         yWw0XznjRpVWi3g2yZgK9i6L1Ff8Vc6jxRB3RGmgOL6jvE4cl+1ZXm8/XHJoxLG24/0v
         2o46qV4eq1xYe3rASYBuT5i9ul/q3U9rQjalGnzzfsLteDAvD1VUKxLp0k9K/tm5dRoc
         2cmw==
X-Gm-Message-State: AC+VfDz3IT81Rps74kXANfGUuyMd+/jkMjX+uZDSvMst1FY9/Jj1xnnB
	5TfNJUXXkM+pe6Avaebztb3v8/pCEOcZ5U3BK5ClUg==
X-Google-Smtp-Source: ACHHUZ6W10/O7XFGVuClpH8ZIF5T9RTgM3Qv3eWmgzSQK5rna0m+jq64v1TSYPmAjkI+uPNRqLg59Q==
X-Received: by 2002:a17:902:dac4:b0:1a9:6a10:70e9 with SMTP id q4-20020a170902dac400b001a96a1070e9mr2949499plx.33.1686761700599;
        Wed, 14 Jun 2023 09:55:00 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id ju20-20020a170903429400b001b20dc1b3c9sm1629457plb.200.2023.06.14.09.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 09:55:00 -0700 (PDT)
Date: Wed, 14 Jun 2023 09:54:58 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Marcin Szycik <marcin.szycik@linux.intel.com>
Cc: netdev@vger.kernel.org, dsahern@gmail.com, Michal Swiatkowski
 <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH iproute2-next] f_flower: implement pfcp opts
Message-ID: <20230614095458.54140ac7@hermes.local>
In-Reply-To: <20230614091758.11180-1-marcin.szycik@linux.intel.com>
References: <20230614091758.11180-1-marcin.szycik@linux.intel.com>
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

On Wed, 14 Jun 2023 11:17:58 +0200
Marcin Szycik <marcin.szycik@linux.intel.com> wrote:

> +static void flower_print_pfcp_opts(const char *name, struct rtattr *attr,
> +				   char *strbuf, int len)
> +{
> +	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX + 1];
> +	struct rtattr *i = RTA_DATA(attr);
> +	int rem = RTA_PAYLOAD(attr);
> +	__be64 seid;
> +	__u8 type;
> +
> +	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX, i, rem);
> +	type = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_TYPE]);
> +	seid = rta_getattr_be64(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_SEID]);
> +
> +	snprintf(strbuf, len, "%02x:%llx", type, seid);
> +}
> +

NAK you need to support JSON output.
Also whet if kernel gives partial data.

