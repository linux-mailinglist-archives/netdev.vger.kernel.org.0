Return-Path: <netdev+bounces-8954-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4532772666C
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09DDF281225
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407871773E;
	Wed,  7 Jun 2023 16:51:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333FF63B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:51:30 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656DF1FC0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:51:27 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-650c8cb68aeso4197419b3a.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 09:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686156687; x=1688748687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJtLShVQKhOyEQXDzZvKvycLChGPIaRjTVglRtQj7rQ=;
        b=cTC9aYFMUIBSb4AnsdzFqcVCEfe5xdj2tml4mu8Dg2g3fA58Grp3UVlAvINM2fRXb8
         zCCMZSzrTclgjoV975VBKhgGP5Zd3hwJoKcXJ78TwaNRx7FksvB8TgScaVyncq92z33i
         wNBtaYZQkOKBwTqVjXFfpc2VeFX9fhoY3CAtHDklp7J7tfIqZMbAnAY9+eQpi+do4YEP
         vxJTMuY+pD86Rx6HuuFbKtFaYXY+XIMz3l6ZutWb9e68kr+y1VbEPZw8llAA0t3TQBny
         +B8pKZBDq6Od9sY5QrvYPNJuWWc0+XPD6MTu8yejxoNDxmzgbo4J1T0TSK6/fXACbCjJ
         4DcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156687; x=1688748687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJtLShVQKhOyEQXDzZvKvycLChGPIaRjTVglRtQj7rQ=;
        b=ABMNI01rcaoHCEaJV0kq0jQD3r6uHC68d5NZ1C60cgpi4+SLg0h0TGo2G7L+mpsUU+
         iakPC97oDJp4jVdm+v8Ai9/HXx4Fn4+/XCIRcBxHAPmTeyfn/1qXUByr1kbhXs1/lFh2
         Iz6O/9ghIOCjnENVbaYgRXvgx3sSnQCVQhm82shSr4JRXibWje1UD9ttlB5G7SM+9ocV
         vTi9Fpu5XjxYAPo7mBlgYJMUeQAEDpLuualzRH5Z0hV5odYqYcK3vJBdoEFh1ZrIAn2s
         eCaPk4dA1BEFMSBYavTuXKqAWAngcpE814HYzocQvJyha67Mg644if78LVFXMB6tBwXC
         hf8Q==
X-Gm-Message-State: AC+VfDwzYn3W1sXxxKGOrGXk7sQqIuptIp7TyIISn2lPMkO7BWf6x0l1
	vghDChB9AwqKo6pUndNYlW0OOA==
X-Google-Smtp-Source: ACHHUZ7xx5GEzxKickdDJ4x3RiHttMmrIRQb4YHCJcCejQte35NHMdcFC1KZ0HC+AoecS1LMtnPaig==
X-Received: by 2002:a05:6a00:2da1:b0:662:def9:dc31 with SMTP id fb33-20020a056a002da100b00662def9dc31mr493461pfb.3.1686156686889;
        Wed, 07 Jun 2023 09:51:26 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f15-20020aa78b0f000000b0064fabbc047dsm8668746pfd.55.2023.06.07.09.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 09:51:26 -0700 (PDT)
Date: Wed, 7 Jun 2023 09:51:24 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: <netdev@vger.kernel.org>, <dsahern@gmail.com>, <jiri@nvidia.com>,
 <razor@blackwall.org>, <petrm@nvidia.com>
Subject: Re: [PATCH iproute2-next] f_flower: Add l2_miss support
Message-ID: <20230607095124.2dda16ec@hermes.local>
In-Reply-To: <20230607153550.3829340-1-idosch@nvidia.com>
References: <20230607153550.3829340-1-idosch@nvidia.com>
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

On Wed, 7 Jun 2023 18:35:50 +0300
Ido Schimmel <idosch@nvidia.com> wrote:

> +		print_uint(PRINT_ANY, "l2_miss", "  l2_miss %d",
> +			   rta_getattr_u8(attr));

Use %u for unsigned?

