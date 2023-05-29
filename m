Return-Path: <netdev+bounces-6035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2351E71476B
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 11:48:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA914280E5A
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 09:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F20205683;
	Mon, 29 May 2023 09:48:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77567C
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 09:48:46 +0000 (UTC)
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A12D90
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 02:48:45 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-55db055b412so58969907b3.0
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 02:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685353724; x=1687945724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gkLT+DVMzICOnkgjPvqf4ZsRIt+r0mHmPWKwJTBzXWU=;
        b=CyDVTNmv1DnZ4uqfsBFy4mv/pjTmzqCkJpWiVzdJpXG2ug0CxBEqgyYxdlZjvSxSfI
         LUHvbKq8eYW7LzoUsp3uQ/aS+LGNCavbyjMbsXRhYBOSxEsWx4p1wiTweTbHK1m+eob6
         IqlIP3hjDac3skT4Eq7fAr5ljdVssSgOQ7ZWKCRa28Gxbe+DJYuYu36CmzpIZ4dJF84g
         egCaQxMqG9mAEs+bzE5smlDv8Bcx2ELQY4B3bsEM/QsuMfLdOR9vbGFWateb7AdUAeG2
         lmwug8b8FgVkUcFq7YhBcPRiUIzZ8nLwbCetyk+pZypV/3F0IblhNVai4APo7W9+u7lQ
         ac2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685353724; x=1687945724;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gkLT+DVMzICOnkgjPvqf4ZsRIt+r0mHmPWKwJTBzXWU=;
        b=EprF2xEJCp0Rtkzza4SAGCidBPqTLPbjVk9EekwkUlMdHHARMEQo6xoWKblKSnet0S
         5MYbBj8ClN/J5jY4cc6BwamP2Dm/v0wtXd4GIZz/knv/awN3liZaxt9/7zB9ujUI8u3m
         lUt95DKeUCxGmlnqKYu0VjCdRcWFAo2ttGxZHbBLQqZzYuhrjrZ6dZkxAxDS/eUROBTu
         KiDgj6SCagegGSRLuq1e9MuleiAkSBqzPanCbUeauhA1qbW+KdBKyJER8hQIeQy5NZ2o
         fQG1hgHXSq9+I4IgPNw1G3GvCOoa8zvZ4vMq+aKuAiie+VV6bjb5tzQbTauWJidawthS
         N3iw==
X-Gm-Message-State: AC+VfDz8cyvXT7dTewf4p2MGw58dBGcMfiSB2QJDAVy8hk9jVE7eUItw
	GxrALXQFRGlRmjSfXaFRbt89ucfYPNE31nhINY2OVw==
X-Google-Smtp-Source: ACHHUZ45PczqAN4JRC6veTjLq/Vb+3bm10ke8fPRMdk1dEMz8VzTvJT1CAFvipsfEvpARvYvLwKiaBMuDU7HWiITYEs=
X-Received: by 2002:a0d:d948:0:b0:561:89f1:6bb with SMTP id
 b69-20020a0dd948000000b0056189f106bbmr8975758ywe.6.1685353724684; Mon, 29 May
 2023 02:48:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1684425432-10072-1-git-send-email-quic_rohiagar@quicinc.com>
In-Reply-To: <1684425432-10072-1-git-send-email-quic_rohiagar@quicinc.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 29 May 2023 11:48:33 +0200
Message-ID: <CACRpkdYOOsOwLRw_5=MzmrwpBg8EnkgNKD1+gXjSUHqvtRuqkQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Add pinctrl support for SDX75
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org, 
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, 
	richardcochran@gmail.com, manivannan.sadhasivam@linaro.org, 
	linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 5:57=E2=80=AFPM Rohit Agarwal <quic_rohiagar@quicin=
c.com> wrote:

> Changes in v3:
>  - Addressing minor comments from Bhupesh related to reusing variable.

v3 patch set applied for kernel v6.5!

Good work on this!

Yours,
Linus Walleij

