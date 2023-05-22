Return-Path: <netdev+bounces-4419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD1570CA5D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F8AE1C20B9F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:07:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A224D171D2;
	Mon, 22 May 2023 20:07:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92601171A9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:07:59 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C62A95
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:07:58 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d2f3dd990so564224b3a.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684786078; x=1687378078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KKdTBkVhqFkb+s7KY4auAiN/t9lTQ60Up1ap8DhSWwE=;
        b=rwMMLqBZTeRfUpDnhp06IpXndmyymLD1ZGT2+C1JnQmNKzK8AsKLt2PwZwFrKLhVzG
         g/6E1vozPJvhchLodi4Pg2Jept9GejVo4xKe5IaFcTAi6XE2vKt+cJrfvQp6dsa4+025
         qAx6aknRZoUiQ9AB+DzxQTJSmzM3jErPRVRtm2CcxKQPegT2d34X4OQvEEyjJ2Sooaw0
         XOkSlV8nU6IAzd70nkuiNUdxVD0oyPJgWqT5nT9r68s9WEAe0PthNYnnERApZtw46pxN
         nIfV3RlgkR2S2pE4ExoRnYcNzYSCnykEITccW93Xn2in7xuCx9Ls7W8BUj2n2lUAMe9b
         iEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684786078; x=1687378078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKdTBkVhqFkb+s7KY4auAiN/t9lTQ60Up1ap8DhSWwE=;
        b=CbKkNZe/CuSDLZl3V0dxI4S+ftxzhYFCk98/Yz6edaRxS3XG4lnbRbh2Nc/roxMgqd
         oAr6IbKzhWxuTG2157d/tHQxiySaVJhHMcPb9lvsqdQt377dEZhKQL2k6yuGu+fTp5g1
         xxpYioi8JwAT3NHXU3RRZs5F+eJH40iIzEnZT/sr/s61ygGE0ksPbS4coxRTIIPdB/Cs
         wklKeM46qkyPSfJDM30I6ro10LvHmfWeriYPjoKrn3uv/rPoqnyHYbwPGjyAxd/Rq0z2
         RSoHbArn7PJy4nMK9rNRzmhiu0Iw10Zkza5erougk9YJwBjkhB+ttCoDQWElrBDj56hV
         KTdA==
X-Gm-Message-State: AC+VfDxI+kmMN4s8YeGTe1gCJMBEyD/6T4oGhkdbuoKxnUNFg1N2DNBy
	9T18KjhcsrtuVaVI7KWKbaM=
X-Google-Smtp-Source: ACHHUZ7uEELaneUUhgQMlRRRQ4jAu+HyYGZ1LOFk5aKEV8AnoXCOxffAFLm+NHQMHWWVBHb5DZ6/jw==
X-Received: by 2002:a05:6a00:4197:b0:63b:5257:6837 with SMTP id ca23-20020a056a00419700b0063b52576837mr11212174pfb.1.1684786077601;
        Mon, 22 May 2023 13:07:57 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:e:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v5-20020a654605000000b0050f7208b4bcsm269107pgq.89.2023.05.22.13.07.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 13:07:57 -0700 (PDT)
Date: Mon, 22 May 2023 13:07:55 -0700
From: Richard Cochran <richardcochran@gmail.com>
To: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc: netdev@vger.kernel.org, Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [PATCH net-next 1/9] ptp: Clarify ptp_clock_info .adjphase
 expects an internal servo to be used
Message-ID: <ZGvLm0Cxh+skT6zB@hoboy.vegasvil.org>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
 <20230510205306.136766-2-rrameshbabu@nvidia.com>
 <ZFxOZM9saCVDNIqD@hoboy.vegasvil.org>
 <87ttwizkki.fsf@nvidia.com>
 <ZF2No6gW3HlzZscV@hoboy.vegasvil.org>
 <87mt1w5mec.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt1w5mec.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 10:03:23AM -0700, Rahul Rameshbabu wrote:

> This point makes sense to me. However, I have a concern about the case
> where the linuxptp servo has not had a chance to make a single frequency
> adjustment (0 ppb) and .adjphase/LOCKED_STABLE state is initially
> called/reached. After converging, the frequency will be close to the
> remote time's server's frequency, but that frequency will likely not be
> 0 ppb. If .adjfine had been called previously, the difference between
> the remote time server's frequency and the cached frequency in the ptp
> stack would likely be significantly closer. That said, do you think it
> makes sense to have some kind of API that gives information about the
> in-HW controller such as the frequency offset it operated? Or maybe in
> general an API in the future for introspecting the state of this in-HW
> servo?

The whole point of hardware vendors doing this is to hide their
implementation from prying eyes.  So they are not going to provide
introspection at all.

Thanks,
Richard

