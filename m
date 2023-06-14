Return-Path: <netdev+bounces-10834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375C873074E
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 20:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD5DE2813E8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DF2111B4;
	Wed, 14 Jun 2023 18:21:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC91D7F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 18:21:48 +0000 (UTC)
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761D4DF
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:21:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-25df7944f98so749741a91.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686766907; x=1689358907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdePemHp+kdZydp0AgGcRx+2vPtEPdq9XHrLFJVHJdE=;
        b=zSOOqXfxOLJT4QiXwBclh6Iy9X9eGn9GCyrKuLRCoOhzfZSjg9BC3ptbIA1TLm6G8W
         v9YAr7ANPEnzEQhusqBAKIgPBRwiQwAN+3c/QTDE+8HfkuEah/NHO0W/zHl0BLYM2TSW
         8F3c4oJmhKTuKbQtfaYp2FHfzQNDrpb9WlrxyiXOG/vfFaH4O8Ei58YY9WWrfA+lNyGn
         YSoonN2PxR29viJYkt+fagd81O31k8jaSseXMbOWoCWiz5HvjsTbpGHSRpyK7Y6NgSbo
         AqRr3brW4AI9Xoj2NrCMOM1GKztrfOpBVCF9MK8cZ+FBRX/3CSDQZPdnORBSUhZgrjdm
         42VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686766907; x=1689358907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wdePemHp+kdZydp0AgGcRx+2vPtEPdq9XHrLFJVHJdE=;
        b=T1v1Y15VU80rNrAUeK/oLqv5b1/j3GsZKfsXRhuJ0ETFkzp9qhzqmO9a5BOxn6p5mo
         7T2frgCImliGrhIXxBpmUqie86jWeh8IpWUQIX2mzfEYNCb/zZyvgX95WRSf0SuECy0F
         15wZIBVvU1Jiw0GFit521ci8GtXsTnF3m51xAFEpqSHGYz5K2ZSlChMUF/ceYm+71LG6
         T+FxVItzJ463S5YXzG4LS0EpSMTr7/iv1uF7YGQWOBDpJWC6Q5F3iDlX7dcJbVZZKBZZ
         P3OK+7G8PBXmS923+y+168oB09aWApVTUdQ9TlOrPPq46BT4lP9QVYYamHTWKSZn/n8/
         4C8g==
X-Gm-Message-State: AC+VfDzN+8z0soUn9/vJGEJusJ2oq8JsCxPdLfV4INoP/y21pLKLvOsu
	sGt0sNPQjhv8ZsJyxGg8Wugi4A==
X-Google-Smtp-Source: ACHHUZ5N7lmMAkDL1WYgHKwMHENDsjyGwXoNSbQ8fLQR1ildLnKq8BCUD3Qc9EJ7nm3ewHB9jvnZiQ==
X-Received: by 2002:a17:90a:db95:b0:259:45c2:7339 with SMTP id h21-20020a17090adb9500b0025945c27339mr2554589pjv.23.1686766906767;
        Wed, 14 Jun 2023 11:21:46 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090ab38500b0025bb1bdb989sm7936807pjr.29.2023.06.14.11.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 11:21:46 -0700 (PDT)
Date: Wed, 14 Jun 2023 11:21:44 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, Pavan Kumar Linga
 <pavan.kumar.linga@intel.com>, emil.s.tantilov@intel.com,
 jesse.brandeburg@intel.com, sridhar.samudrala@intel.com,
 shiraz.saleem@intel.com, sindhu.devale@intel.com, willemb@google.com,
 decot@google.com, andrew@lunn.ch, leon@kernel.org, mst@redhat.com,
 simon.horman@corigine.com, shannon.nelson@amd.com, Alan Brady
 <alan.brady@intel.com>, Joshua Hay <joshua.a.hay@intel.com>, Madhu Chittim
 <madhu.chittim@intel.com>, Phani Burra <phani.r.burra@intel.com>,
 Shailendra Bhatnagar <shailendra.bhatnagar@intel.com>
Subject: Re: [PATCH net-next v2 05/15] idpf: add create vport and netdev
 configuration
Message-ID: <20230614112144.55d2fdf9@hermes.local>
In-Reply-To: <20230614171428.1504179-6-anthony.l.nguyen@intel.com>
References: <20230614171428.1504179-1-anthony.l.nguyen@intel.com>
	<20230614171428.1504179-6-anthony.l.nguyen@intel.com>
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

On Wed, 14 Jun 2023 10:14:18 -0700
Tony Nguyen <anthony.l.nguyen@intel.com> wrote:

> +	/* TX */
> +	int num_txq;
> +	int num_complq;
> +	/* It makes more sense for descriptor count to be part of only idpf
> +	 * queue structure. But when user changes the count via ethtool, driver
> +	 * has to store that value somewhere other than queue structure as the
> +	 * queues will be freed and allocated again.
> +	 */
> +	int txq_desc_count;
> +	int complq_desc_count;
> +	int num_txq_grp;
> +	u32 txq_model;
> +
> +	/* RX */
> +	int num_rxq;
> +	int num_bufq;
> +	int rxq_desc_count;

If value can never be negative, you can avoid future errors by using
an unsigned type. Ideally to save space use u32 or u16.

