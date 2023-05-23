Return-Path: <netdev+bounces-4744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FDC570E16D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B3F7281361
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1300200CB;
	Tue, 23 May 2023 16:04:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54DA1F95D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:04:45 +0000 (UTC)
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98696DD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:04:44 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d2da69fdfso6012364b3a.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684857884; x=1687449884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/duuhfAcXcPa+QNzHCbgZWoxYmxgSdECZUc2Y4yF7EY=;
        b=P/pKOf6vXbINxItxFNLJ2LiZshXmg/r2eiDtr1X9Nu5Vta2x/eEoZVlCG/KcEhgFRo
         8n7OsooyIuhVhs+ERjBEuSHXnAep0/c7IMjswc6jRgwROFXMvoZyqpWgBFWsSfpV4hzn
         mpyAiYbDXRP8Gzqm5ETcJLeWK30knE/e5EZqPzIViJm5hF5Q5jUsZPZxwra/3Gq8MNUP
         aa0E2i4WHxf0P6KHkRv4l/Ipq5DBn/wZBG2nFtNy0iuxizkX9vTZ2BAq3RPj+p7ObR+r
         I2HQGYPiMYGebzvalZ7OdrA97WeOptYC6prhEGC+z4i2YgNKZapasAusGcMHkvlMtEX1
         bIdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684857884; x=1687449884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/duuhfAcXcPa+QNzHCbgZWoxYmxgSdECZUc2Y4yF7EY=;
        b=k6twjKDhY2aWiWCtknyEKUnxHJLx8Cq1JVjDzn55iHIOJ4p92FiOlXFovLXZcjUrpM
         sWlfqZVey/9BrD2W0Y4edkLZvun2PMQMKz4Hu9kXqCsAmRJ7dsj0kOaCExOaqPHLyAIj
         GBCZbolm8FNIerNl2KBNPNCJvxBpmktHSLoAZJPxYRW9ycNEr51MqThejF+dYevbZYbz
         qJ3SduP2iuBxJndlluinTgRCc1Z5o9dU7CB5BxGOWtIajXHVfJqa1Ff/5Okngy4pu4tn
         XbvZ459r55g3rIRdxPyHbkTm3Je4c/1glr0+lnT0UWdVV2Ed9aTb2eGdK8lUZdhj18/q
         ESKg==
X-Gm-Message-State: AC+VfDxTrov2DmXJ16cXCUcTBP0+j1BcaNwn49qao1EMXhpDMMFknOib
	/dXqMYtt1PsbDqmMJ1McOwRNcQ==
X-Google-Smtp-Source: ACHHUZ6mMlGd8UVfojRKE3Z9yXyIQcIv+6uZicWtuHjP5fAy2DY8KSdsyuItN0VoNSzRNjaMtTj07w==
X-Received: by 2002:a05:6a00:9a4:b0:63e:6b8a:7975 with SMTP id u36-20020a056a0009a400b0063e6b8a7975mr19572275pfg.9.1684857884089;
        Tue, 23 May 2023 09:04:44 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id a23-20020aa78657000000b0064d29d5c8e7sm5998723pfo.58.2023.05.23.09.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 09:04:43 -0700 (PDT)
Date: Tue, 23 May 2023 09:04:41 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v6] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <20230523090441.5a68d0db@hermes.local>
In-Reply-To: <20230523044805.22211-1-vladimir@nikishkin.pw>
References: <20230523044805.22211-1-vladimir@nikishkin.pw>
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

On Tue, 23 May 2023 12:48:05 +0800
Vladimir Nikishkin <vladimir@nikishkin.pw> wrote:

> +	if (tb[IFLA_VXLAN_LOCALBYPASS]) {
> +		__u8 localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);
> +
> +		print_bool(PRINT_JSON, "localbypass", NULL, localbypass);
> +		if (!localbypass)
> +			print_bool(PRINT_FP, NULL, "nolocalbypass ", true);
> +	}

This is backwards since nolocalbypass is the default.

