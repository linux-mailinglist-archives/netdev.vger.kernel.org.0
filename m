Return-Path: <netdev+bounces-2400-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B654D701B14
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 03:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A518F281851
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 01:45:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8D7110B;
	Sun, 14 May 2023 01:45:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B99310E3
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 01:45:41 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151651BD8
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 18:45:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-643465067d1so8423413b3a.0
        for <netdev@vger.kernel.org>; Sat, 13 May 2023 18:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684028738; x=1686620738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=da/1cOdwaRSaeRG4fR4u7h5w1C0269b/OMaCy4P4jEw=;
        b=PYg/BcxXE53HvZqSfC598oOmHMU8gu+3RVRHZfcB4c5WW30YazruIg/XlB/YDnZwPR
         aSzT3fipny6IQulv+szXXsR5KZVZPYQYwSbNkkFto2hbV+qq3OHdQBYrXZdeMTEaHcrX
         C+gf3MO809pe9rjE2TfmJHQVGEiJmArGhleZmsyV2NuZyOFI7H7uKkXWg/UU7Fc9+IF2
         4qo3bqdg4EEl1hvYLqki9Mkyn9RsYGaY41+zu/HGZjIVnFA1vbMy0dUZ+MB0IegORo87
         SCsjof4p5tMO4uKi6aHjNBzs+xw9XB+BpBcS6d4NhFfpyN/RZAo+ieucHYWTEcBMh3QA
         OtzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684028738; x=1686620738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=da/1cOdwaRSaeRG4fR4u7h5w1C0269b/OMaCy4P4jEw=;
        b=GGY/dbImfoJPTtxCI+paGMzBaSGrx33a3awj2vM+8M6HYU7s3ZKJ5dGMKETJVU8zO4
         ZbdaaXWxPfBc5YzAvhF0UgZTHMzMhu7b9f6VI9IGAYMl5GhcQlQn6H/osiZgFxxKSTxB
         asXNjerspcyU7UhTiSoraOEE0KlkIKHbsyCLkwayejoyAYj9gKe6cLpAOYAKxwCHVzni
         H3QIH49cqEg34YMmGkE+4gYkhSgz7Vnk69gy8xj9ueX6GHb/YoT1PARtIdss2QiSGOe9
         Ga6IjbGHW8woj+zPqvjiDWNPVnmI4cmlgpiDxvgAeItD/VoYAqo39kugSZdhqMHMNGfM
         jGjg==
X-Gm-Message-State: AC+VfDz5PX6VukTWTtRWUJXkxXwn3zyUa/ojhriJj5m5aXmn1EbiPSBY
	6dx5Qb1b8QZxsueLhi6Ib+9pxQ==
X-Google-Smtp-Source: ACHHUZ60AF1WAuOlqQS4R6g7FvSMJgcaiVNwGmF6Szu0Go73IzuOhXUtvJkap88ioDYIYMrXfcmXdw==
X-Received: by 2002:a05:6a00:158b:b0:64a:f730:1552 with SMTP id u11-20020a056a00158b00b0064af7301552mr6798178pfk.19.1684028738480;
        Sat, 13 May 2023 18:45:38 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id b20-20020aa78714000000b0062dbafced27sm7317314pfo.27.2023.05.13.18.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 18:45:38 -0700 (PDT)
Date: Sat, 13 May 2023 18:45:35 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Emil Tantilov <emil.s.tantilov@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, shannon.nelson@amd.com,
 simon.horman@corigine.com, leon@kernel.org, decot@google.com,
 willemb@google.com, Phani Burra <phani.r.burra@intel.com>,
 jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, Alan Brady
 <alan.brady@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, Shailendra
 Bhatnagar <shailendra.bhatnagar@intel.com>, Pavan Kumar Linga
 <pavan.kumar.linga@intel.com>
Subject: Re: [PATCH iwl-next v5 02/15] idpf: add module register and probe
 functionality
Message-ID: <20230513184535.1a07c5b3@hermes.local>
In-Reply-To: <20230513225710.3898-3-emil.s.tantilov@intel.com>
References: <20230513225710.3898-1-emil.s.tantilov@intel.com>
	<20230513225710.3898-3-emil.s.tantilov@intel.com>
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

On Sat, 13 May 2023 15:56:57 -0700
Emil Tantilov <emil.s.tantilov@intel.com> wrote:

> +struct idpf_hw {
> +	void __iomem *hw_addr;
> +	resource_size_t hw_addr_len;
> +
> +	void *back;
> +};

It is safer to use a typed pointer rather than untyped (void *) for
the back pointer. This could prevent bugs.

