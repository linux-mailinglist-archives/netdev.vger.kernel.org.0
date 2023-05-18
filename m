Return-Path: <netdev+bounces-3655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E99170831A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF8FA1C210BB
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D7C18005;
	Thu, 18 May 2023 13:46:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6761023C8A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:46:46 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE85E56
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:46:44 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f450815d0bso20314525e9.0
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684417603; x=1687009603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n37kZ9OaSB2I1L9nZa5F9grWcO9GO9dx9m8E0RZj7ew=;
        b=rNt5bxcuBOipXy+gj9lj5he9BVeqcZDNLnR6RtNY2GSXk3UtdkW+T7MJJ9wqaAvx3G
         neACjsomII8ntdG81HZnQlevqETbR3yNN9OSYKrWkaLJ8ZPjRJiQI+JGEzXUjZo8W2K6
         elyZxK+hpLpt0FVRlQoNNs8lU9aaqwt1U6bWL1p8NmK2kvR66KFrUzY3pLmvngRQurCV
         1Dj740gakwCCd4d0Yqeb+jB/0cnHQk0aOJl++S66fVN+z2JhWsGeE5irsWNCgD68ALGt
         JdRdVX84KHxqf/QXqZhkW3f+1VW7lIMxuU5k2vaL1RCmEPcNQKh/QSErDySlmcxbsJA/
         SVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684417603; x=1687009603;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n37kZ9OaSB2I1L9nZa5F9grWcO9GO9dx9m8E0RZj7ew=;
        b=kxJ+N+Wxlpt7//dyJSI2N3j91ccwronzMxZyk+3vX7KdAHEH1lDwHMCQAUXGvHd5vA
         hPop7M/fQ+ixFJD/bBrtoW8BHriLgJyAiRzgCnT1N6Au8MuRoVhwXh8MTZwurKHSqPsr
         9Tx/UZ3NcSSfNgOph4NT6z70Qt5gsCsN5HG8j2OjBKySHDWHAjxUvV6Ltl307oOZuTdn
         cJv2b4L8mcVq64EY4DQL8WPlPD2CoRatOxXwcyncS4X/uNO5kxQX/P3q1nTnURPqTxqA
         w4y+boVrwyWEmrKiZj99KIPbHbkxonTaQ/dAybqwAmUN2a+usUXiyGCytQgD0GVCxvNr
         84BA==
X-Gm-Message-State: AC+VfDyP+Bq3AqVKrooUXwBEaZV5LXuYy2UF0LAmatWfT3IMH4l0ws7S
	whXE5p7t6awTZB3/pqmVoyJ2GWw4DyBIdup1mfq/oA==
X-Google-Smtp-Source: ACHHUZ4sg6CWtPLHXtpPccBwHuiBIUQk33g30SZ0fhjsgYp0KOauavRqRHfQsI71hiJkt9HYbOC8XxoBaQ7OD+0SV5s=
X-Received: by 2002:a7b:c852:0:b0:3f1:979f:a733 with SMTP id
 c18-20020a7bc852000000b003f1979fa733mr1740091wml.31.1684417603085; Thu, 18
 May 2023 06:46:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1684413670-12901-1-git-send-email-quic_rohiagar@quicinc.com> <1684413670-12901-3-git-send-email-quic_rohiagar@quicinc.com>
In-Reply-To: <1684413670-12901-3-git-send-email-quic_rohiagar@quicinc.com>
From: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Date: Thu, 18 May 2023 19:16:31 +0530
Message-ID: <CAH=2Ntze2sHoaY-x19u1iw-3QD_SPS0T0J5xw=xtOyRb6ryf5w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] MAINTAINERS: Update the entry for pinctrl maintainers
To: Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org, 
	linus.walleij@linaro.org, robh+dt@kernel.org, 
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, 
	richardcochran@gmail.com, manivannan.sadhasivam@linaro.org, 
	linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 18 May 2023 at 18:11, Rohit Agarwal <quic_rohiagar@quicinc.com> wrote:
>
> Update the entry for pinctrl bindings maintainer as the
> current one checks only in the .txt files.
>
> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e0ad886..c030984 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16672,7 +16672,7 @@ PIN CONTROLLER - QUALCOMM
>  M:     Bjorn Andersson <andersson@kernel.org>
>  L:     linux-arm-msm@vger.kernel.org
>  S:     Maintained
> -F:     Documentation/devicetree/bindings/pinctrl/qcom,*.txt
> +F:     Documentation/devicetree/bindings/pinctrl/qcom,*
>  F:     drivers/pinctrl/qcom/
>
>  PIN CONTROLLER - RENESAS
> --
> 2.7.4

Looks good now, so:

Reviewed-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Thanks.

