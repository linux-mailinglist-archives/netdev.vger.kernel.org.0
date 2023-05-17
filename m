Return-Path: <netdev+bounces-3218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC5AA7060C9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B21328156E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EA17497;
	Wed, 17 May 2023 07:08:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766FE2CA9
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:08:32 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F73110;
	Wed, 17 May 2023 00:08:30 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50db7f0a1b4so573921a12.3;
        Wed, 17 May 2023 00:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684307309; x=1686899309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Na2ABieNKtLxKAl3637bFV6QDvaly2yHP2hD1sEKlQ=;
        b=jPSQNf4vNNAahIVMHkH+yTlI7QvYVnFddPXi8qWLoexwhlBoBgqDreeJD6UBzrR85G
         0BlpJWtMNU1skVlh2RnuBdpQAP9X40vBKIs8Smet5yW23ZvE7Yy2FqXLUVS0Pn0W58A6
         /lgNvH3HI0QSPivGq9GvjpfvwhOtFRrzq6UGmdhLgcZT+92Hiaj9I6a7apVcCC/YFW1s
         G+/sYVYhM0ZjwZBFhoAQpx1P7yt7tmFbWp+eEbRSzXaZk+/7TLDkCO8l3Umb3rfEC7RX
         ACqVpNZtsMukuzvEcIdpZIxuW3zO2GF1f1jq9B443HY3JTImyLM3v93JcGag3ea3CWTH
         noGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684307309; x=1686899309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Na2ABieNKtLxKAl3637bFV6QDvaly2yHP2hD1sEKlQ=;
        b=Dr3zvje+Q4wZGgBGNcCQA75CWtdXQV3kPpqL1B3d8K874WtFa1apCqfMrFhKODd2+W
         7luxDxgCI/pu1DS0ZHENQYmDho/3LETSc11dW+MdnJltJlpoI7OnUz1R57rSLvERugwl
         B5Kg6CprxpN0fPoQ5LHFfr+08nJf49ItMN+aYU/u5ImUD52okxwTKKizRRsqBHtz9bTZ
         KjmFrqD7FhOLBtDUGoUzGLWc1trBEmoZRfxs8KRp+X+S1PkJi4IeM2xwAmuHEW1XQKpZ
         GqySfk4x0/0iBHOhoDuzgDHpQBsfYDyfW3Wa58izK86GNcaNB64GrX+Px7CpFt4oxGIj
         PteQ==
X-Gm-Message-State: AC+VfDwgnC8sDOFUYGy+p88kvP7guV0tewlqfYa/QGKaM27gzuE6tHDc
	DtJYfq/h+Mel5ykauAOajww=
X-Google-Smtp-Source: ACHHUZ6D/bg8DZdF1/q9mPM1/Gx3MbL3e8VQapuROlxMlou8nyKqUtHk3nq/TedlhAkYFWhAM1Notw==
X-Received: by 2002:a17:907:6d10:b0:96a:eb2:9c5e with SMTP id sa16-20020a1709076d1000b0096a0eb29c5emr25270833ejc.63.1684307309134;
        Wed, 17 May 2023 00:08:29 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id hf27-20020a1709072c5b00b0096557203071sm11846455ejc.217.2023.05.17.00.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 00:08:28 -0700 (PDT)
Date: Wed, 17 May 2023 10:08:26 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH v5] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Message-ID: <20230517070826.ywncgnuyoi67zttg@skbuf>
References: <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515074525.53592-1-krzysztof.kozlowski@linaro.org>
 <20230515105035.kzmygf2ru2jhusek@skbuf>
 <20230516201000.49216ca0@kernel.org>
 <124a5697-9bcf-38ec-ca0e-5fbcae069646@linaro.org>
 <20230517070437.ixgvnru4a2wjgele@skbuf>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517070437.ixgvnru4a2wjgele@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 10:04:37AM +0300, Vladimir Oltean wrote:
> On Wed, May 17, 2023 at 09:01:38AM +0200, Krzysztof Kozlowski wrote:
> > Yes, apologies, I usually forget the net-next tag.
> > 
> > Shall I resend?
> 
> Probably not.

Although patchwork marked it as "not a local patch", so no tests ran on
it. Let's see what Jakub says.
https://patchwork.kernel.org/project/netdevbpf/patch/20230515074525.53592-1-krzysztof.kozlowski@linaro.org/

