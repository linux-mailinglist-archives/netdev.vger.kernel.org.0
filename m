Return-Path: <netdev+bounces-1813-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C746FF328
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:38:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5A721C20FF9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6ED19E69;
	Thu, 11 May 2023 13:37:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34831F920
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:37:06 +0000 (UTC)
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC47610E70
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:36:33 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 3f1490d57ef6-ba696d396a1so1316171276.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683812191; x=1686404191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFAIywGWIpHXBlSdgbcQzT1KF9uNjxkkfEt4tXTB8GY=;
        b=NC0E8vqh5yAN4U7/8Y4/aq1xl0d7frmoThyvYuilmHbwwjROn6dxNX8nVcnyidJB/m
         qatfvm0yPY+Hd+IP/3kpI+kcPi99ppeI5XYfd1P5Ruw8e75i5B1I1jbaaK1EdUI5Ymz3
         N4kZVZJsafykkM3zIzaecbyDFU9a7TqFZ8nTIJW3gaeoNugJowg7LiiQiuGkwZcnfe2q
         lYerGGZj/igiPYsHxKj+I0F9H0UjZcRTIQhb8OmxMG4483Qaftq0NXmGIOa6ecdW7Em0
         8DQri3W1uK6NdjjMQGKcHLW7JsaLdDl4yjoOza8ga5sM1fqbNV8dqJ7nnJ1cciewr7uX
         Ws8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812191; x=1686404191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cFAIywGWIpHXBlSdgbcQzT1KF9uNjxkkfEt4tXTB8GY=;
        b=NmD8ftKtoBVXJGgDMImZmwBgYsBka6uT6HIeCJEaYoFfxjwc2VwUBX8vK/FSkSaZ6V
         fEWpUfGpqbDtWgCVaVKU/qlmPws25ca9YH50yqzzL+4akDWRg941vOnhVBVkbIznsT8R
         Sij7VAITg1waHsTXYOhvlZjGFYsVua0fZtzA6XGWD3XxSjT8UPr6S2/i78lt+Nic/I64
         gg2yrJ3hEvypWFjDApqa54S4bvHHljys1vUJ/LRbf/wwVbf9zkODZRb4dJPjeVVJJGnM
         Mlpubr/tbyRt2NHsJQaR84NXubJAwLHWOsT3rNOF+fY+0fxf8xJW4Tx2KhcXeocNiTTA
         Rzlw==
X-Gm-Message-State: AC+VfDxMZOiY/AFmtjvF3WTqtx5xNejvy/Ya6PzfMULTJVPtr+NPeQOC
	n3VbLW26eWsjrstRsO7KjctFs+M5Hx1+TY+T+HqQ2A==
X-Google-Smtp-Source: ACHHUZ7QMtu9AVeo1bHy1+Z0/j5lqVmaGvWbkRPmujYL/1PGBpqhTIe8hp6y79vxcM6RG1l/dmxLaabpyZzUPNvVMDw=
X-Received: by 2002:a25:fc07:0:b0:b9a:6f77:9018 with SMTP id
 v7-20020a25fc07000000b00b9a6f779018mr19959978ybd.41.1683812191411; Thu, 11
 May 2023 06:36:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683730825-15668-1-git-send-email-quic_rohiagar@quicinc.com>
In-Reply-To: <1683730825-15668-1-git-send-email-quic_rohiagar@quicinc.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 11 May 2023 15:36:20 +0200
Message-ID: <CACRpkdZZKsLQbR0zttAWjxYWEPdWo3cHo_OVhuGxBZ89XhDTmw@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Add pinctrl support for SDX75
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org, 
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, 
	richardcochran@gmail.com, manivannan.sadhasivam@linaro.org, 
	andy.shevchenko@gmail.com, linux-arm-msm@vger.kernel.org, 
	linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 5:00=E2=80=AFPM Rohit Agarwal <quic_rohiagar@quicin=
c.com> wrote:

> Changes in v7:
>  - Collected reviewed by tags from Andy and updated the sdx75
>    driver with the new macro which was missed in v6 patch.

This looks good to me, but I definitely need Bjorn's ACK on the series
before I can merge this.

Yours,
Linus Walleij

