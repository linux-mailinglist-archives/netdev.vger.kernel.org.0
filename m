Return-Path: <netdev+bounces-2995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6105704E9C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:04:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F2EF281574
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:04:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B803B27703;
	Tue, 16 May 2023 13:04:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A737734CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:04:39 +0000 (UTC)
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F586EA5
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:04:16 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 3f1490d57ef6-b9a6eec8611so3762175276.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684242255; x=1686834255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DyHzhEzewtSr9qT80gAaJVsweRm/vdYifkr1pznjePs=;
        b=GzDncsFtWn3PiK6yqKbw3AyG24JOvl8bqlLQIvAIdzzQ0FELfv20xMhlm9Q8Goa3WU
         PGaSPH4poNqcHAcUUyegimmR0+0OcvxE5TM20CDOxVJ22EEY6wVIV9yLDVOclhhfn19j
         Dq1JOARRbxhJ3sjcqGjnhjCtEQeiCA5P+F7RumEQXxRzFIS8BAiBtDftBJ4DkbOrFwDQ
         bWt8BzI3gItcBTae00pswDLrCJjJ9jJOilaxOGS6+NypQajgaxjt5g8d1vqdsywgM7Ry
         IwSXKwZdZChUUclMrPqt+/F+gSjOTjoLV+jFSr3aAqBIBMPU6JuUWdc9mv3i2cBUEd3Q
         gigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684242255; x=1686834255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DyHzhEzewtSr9qT80gAaJVsweRm/vdYifkr1pznjePs=;
        b=GBD620+u/AbDgc3w3PPY4WYmelbPJsDPatnjEmaoU3pmuPA2PkTCJr8VCyYDPhEeEX
         ZkPqwo7RYM+JT3xrNsvDETHg3R8PtjysAO+/faVPK6BOBnLH+q3Idjl9cpUyIl/QaZHD
         s9TrCMxXyOTmPfyPDDYCHAJ4ZO/XcbnLA1WYYiu0oOrZUHNYCKL3+gXmyz9dlxwfBQKq
         mlP+EOrGW5+Y9uIFn8LFEcF11mqVe4xavCaTzzfdXBZ01NlmdUMg1a8ftBEJ/5fUtIEL
         5/cAr+aIcIAWSfsU5vDYcEC1eLXWElAOCWbpNBzcza98piQnrQdkkKN3ykaECIL9/KOE
         T4QQ==
X-Gm-Message-State: AC+VfDxp/fC8Losml6/vwNBtTmnTrB557xzc3VASAQbf6PLV45vKPQ+0
	5+C2sZLm6MpgcxMMPXfsd9IjFb4XHJk7MAn/SFPpaQ==
X-Google-Smtp-Source: ACHHUZ5LLSZp5N8AjFtcsS+Nblq75Sx9hUmlFiigH+cSwbzXVQ2MmX0+UvUYUq2zTalIgFeaTqBJCdYWkYRvJvugECA=
X-Received: by 2002:a81:1cd0:0:b0:55d:a851:1aab with SMTP id
 c199-20020a811cd0000000b0055da8511aabmr33116341ywc.17.1684242255182; Tue, 16
 May 2023 06:04:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1684133170-18540-1-git-send-email-quic_rohiagar@quicinc.com>
In-Reply-To: <1684133170-18540-1-git-send-email-quic_rohiagar@quicinc.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 16 May 2023 15:04:03 +0200
Message-ID: <CACRpkdbu95hkFWJtCKoUXCyLfS2hxUywD41iF45ZtgKzqjXAJw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Refactor the pinctrl driver
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
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 8:46=E2=80=AFAM Rohit Agarwal <quic_rohiagar@quicin=
c.com> wrote:

> Changes in v2:
>  - Added changes for SM7150 as well.

This v2 patch set applied!

Yours,
Linus Walleij

