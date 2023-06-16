Return-Path: <netdev+bounces-11561-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 696817339ED
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23780281702
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5148B1EA71;
	Fri, 16 Jun 2023 19:33:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4A21ACDB;
	Fri, 16 Jun 2023 19:33:30 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA5412B;
	Fri, 16 Jun 2023 12:33:28 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-982c996a193so146725966b.3;
        Fri, 16 Jun 2023 12:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686944007; x=1689536007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rDE4DprDtVlj2OCsSAeXNU+w16ip/BTxY/Rxz/iqhVs=;
        b=LytFrTDG5sr7JpHwHqn2rgW9P1VRg2NRAV0p8e7KDTz/KFaJJ031x5U0tqHLgQlRpe
         lYPtJvuPsi9yx4NPwOQvvj6BXMZGVocNJdXJjCagFjXWqKI3OHijFmLSfs3I7V42FusP
         FO6kvCNLD1nI7rjXWE8VkjAr+q83A8mGeK1vyeFPwLOJBDRgx9ew0uh2Ytsvzf113FnS
         TpAr6I4jMUZI30ZqBrLTG7jBDS3UW6MOyvuReOEzJoyg4JXD0tB+vULxKdC/bGMoRZSp
         gDQxBnYsxT/sJYFIhJg1Crv9fcQZXG4FV8cJ2mjvY3/E8OWfg+gD8xjhWAFNfPKJUQ4j
         Vcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686944007; x=1689536007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDE4DprDtVlj2OCsSAeXNU+w16ip/BTxY/Rxz/iqhVs=;
        b=lxW3HlykGQB6bqv3xZjUXY5VTj7vDp0EPnYpYr59rZFKGnK1tI/klhGkR/etqvMgYb
         h1lx8/XrUzTrYq4r9Vbt8BLaorryU/hoZH/6xWULyOO21bISJML+FZtT70XRPszm1K5h
         3ypmolzZXUUli5fVeXQyUzNSjNTI+l5Jj2yEumhsVhuet/t43qrzlMeGrYRkzt09pEYq
         lpLrTyq9HWggsCUkg4zE0SxEHm0vrP76TnEvbQBUCyNv6CZk6x4HdKhRnOjMu/jZBa9w
         V8rNBmXTFZZADvWeW6ZzAjREgdCSHYRn6r6qOCOzn3nmhHLwArlYwQaYumuTuj1lAwap
         t27Q==
X-Gm-Message-State: AC+VfDxZRuVzSsdSDxqMQZYN2WHUxw9ZGfvHI9+fae772rkKBgKfJ64U
	ZZZt1wJrQupIlVVnIAdmv2Oh4i6tes4AYMsm
X-Google-Smtp-Source: ACHHUZ74jd+VauVXSGMTiUQNjK6BL8mJP/uzGaqQY28VmE6FSZkWr37btKSwZdDJK4Ya5Ouqv9OtQQ==
X-Received: by 2002:a17:906:fe0e:b0:96f:f19b:887a with SMTP id wy14-20020a170906fe0e00b0096ff19b887amr2648185ejb.56.1686944006933;
        Fri, 16 Jun 2023 12:33:26 -0700 (PDT)
Received: from localhost (tor-exit-58.for-privacy.net. [185.220.101.58])
        by smtp.gmail.com with ESMTPSA id lc18-20020a170906f91200b009828cf02e4esm3169556ejb.214.2023.06.16.12.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 12:33:26 -0700 (PDT)
Date: Fri, 16 Jun 2023 22:33:25 +0300
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: Saeed Mahameed <saeed@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4 0/2] xdp_rxq_info_reg fixes for mlx5e
Message-ID: <ZIy49YoX3zcTRjpD@mail.gmail.com>
References: <20230614090006.594909-1-maxtram95@gmail.com>
 <20230615223250.422eb67a@kernel.org>
 <ZIyv3b+Cn2m+/Oi9@x130>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIyv3b+Cn2m+/Oi9@x130>
X-Spam-Status: No, score=1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 16 Jun 2023 at 11:54:21 -0700, Saeed Mahameed wrote:
> On 15 Jun 22:32, Jakub Kicinski wrote:
> > On Wed, 14 Jun 2023 12:00:04 +0300 Maxim Mikityanskiy wrote:
> > > Marked for net-next, as I'm not sure what the consensus was, but they
> > > can be applied cleanly to net as well.
> > 
> > Sorry for lack of clarity, you should drop the fixes tags.
> > If not implementing something was a bug most of the patches we merge
> > would have a fixes tag. That devalues the Fixes tag completely.
> > You can still ask Greg/Sasha to backport it later if you want.
> > 
> 
> You don't think this should go to net ?
> 
> The first 3 version were targeting net branch .. I don't know why Maxim
> decided to switch v4 to net-next, Maybe I missed an email ?
> 
> IMHO, I think these are net worthy since they are fixing issues with blabla,
> for commits claiming to add support for blabla.

I agree it's worth applying them to net, and I think it's a valid use
case for "Fixes" when the original commit says "implement X" but doesn't
implement X.

> I already applied those earlier to my net queue and was working on
> submission today, let me know if you are ok for me to send those two
> patches in my today's net PR.

If you were going to send these via net, that would be the best, please
go ahead and ignore my v4. I resent it solely because there was no
activity since February, and no one replied my ping two months ago [1].
Sorry for the noise.

Thanks,
Max

[1]: https://lore.kernel.org/all/ZDFPCxBz0u6ClXnQ@mail.gmail.com/

