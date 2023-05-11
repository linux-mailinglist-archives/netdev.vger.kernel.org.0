Return-Path: <netdev+bounces-1645-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD5126FE9CA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 04:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F64B28159A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A731F189;
	Thu, 11 May 2023 02:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8ED2F2D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 02:20:22 +0000 (UTC)
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA72D180
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:20:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-2502f2854b2so1035926a91.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 19:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683771620; x=1686363620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bPVVu2202ryRmZRSsBFXxtFvR8OYbnStbiFs0POjB2c=;
        b=IPw0XaLcrBIGVaD08UVEuFW48t2re0l2zm++M+LZtLwpPkvoxUtyp7HGbEge/2b+a+
         kZ9+2ipoHD23mx+3RHgIesd2RHfTEjIq/SE8E68R6Tr7BCG02t6t5AoOt9vT4rVyIAl8
         2ulgfc/+KV3BFfuA8Vp/qYQpdvbdjVmK5bV3lM6hoxrDypPonnnB/axH1WpVO+myouK1
         9ALJ4XOH6056MV+dlriO1brifip3FegWa+hCk/reORs2eii/lEMh223S5/mbfXbOrvwO
         lRjKO48IJmVJx70Ioxd2tKQtRSPcKSUoMBOSPCCBgrYH8aoQ7k3iEtt2tAeQ7+dnpogG
         FrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683771620; x=1686363620;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPVVu2202ryRmZRSsBFXxtFvR8OYbnStbiFs0POjB2c=;
        b=g1977hKJecKrhqj4v+PVNN9wYNgi3CNunvK9HfNfC8IszeB0LgIoXaPIDyEXgmk/T1
         2XxPeea1JZ2rW9pHemFUnYx5XDsmBumb1NOAXsQwWOltJkwSNR11/H8M63nYZ8EghP5D
         tqvWLkgeYKiOZ5Vd/fOZXV8z4xYPUiDS0rGN/SuZmGus0Arvl7JGUXGWVjSRaxN5dr7r
         jzdnuO2KiGkYfDAPAj4wNHxsnzw/edo9vQ7OzO6F1eJG3KJteuu7CUudVEUVjYOETVNZ
         Tfxck45ZWPJuqHYFdHjpbICF8/qMAAXohizMszZ4nb6rKSN3O/uJTRoFe15+6hsqkD/1
         P5rw==
X-Gm-Message-State: AC+VfDysDq3hdHpBQCbB7w5krk+MWvmYxV2oJ/xHWSIeAYPUBr/dglpX
	7HLSqzRnH5TaUbbSA2Cqm/0=
X-Google-Smtp-Source: ACHHUZ6ejF0c99IWqPkXIKkqL2CypI7/rPTKUa8Ttb+wIlee8ljuvnuieHLJeXeFlit4f9j3nBvUmw==
X-Received: by 2002:a17:902:d505:b0:1a6:b196:619d with SMTP id b5-20020a170902d50500b001a6b196619dmr24148566plg.6.1683771620168;
        Wed, 10 May 2023 19:20:20 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id jn22-20020a170903051600b001a80ad9c599sm4490038plb.294.2023.05.10.19.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 19:20:19 -0700 (PDT)
Date: Wed, 10 May 2023 19:20:17 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 5/9] ptp: Add .getmaxphase callback to
 ptp_clock_info
Message-ID: <ZFxQ4TNisTvc1sn0@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-6-rrameshbabu@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510205306.136766-6-rrameshbabu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:53:02PM -0700, Rahul Rameshbabu wrote:

> +#define PTP_SHOW_CB_INT(name, cb)					\
> +static ssize_t cb##_show(struct device *dev,				\
> +			  struct device_attribute *attr, char *page)	\
> +{									\
> +	struct ptp_clock *ptp = dev_get_drvdata(dev);			\
> +	return snprintf(page, PAGE_SIZE-1, "%d\n",			\
> +			ptp->info->cb(ptp->info));			\
> +}									\
> +static DEVICE_ATTR(name, 0444, cb##_show, NULL);
> +
>  PTP_SHOW_INT(max_adjustment, max_adj);
> +PTP_SHOW_CB_INT(max_phase_adjustment, getmaxphase);

Ugh, please no macro here.  Just add it plainly like clock_name_show.
Rest of patch LGTM.

Thanks,
Richard

