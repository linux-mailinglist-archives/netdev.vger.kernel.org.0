Return-Path: <netdev+bounces-4825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A790E70E951
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 00:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14BF32810BD
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A7217744;
	Tue, 23 May 2023 22:55:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98253BA55
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 22:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A75C433D2;
	Tue, 23 May 2023 22:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684882504;
	bh=dS/YAPwYvnC+rAO3yycyAQlX67UojDPpvbvnHvURfM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QhbaASO3SX6oEMdYloRMuQu+fO8z7EMT6Ht41KN3RvFMYNoPMsHWom9rwqMLPqYZ9
	 //+ZB8v/Plyz8JALAqURXUge8kP3UmeQfQ6+S+LSpI4QQ1U4rXBt5vDQesaNq86tYv
	 ZZRxtxg6MnPtnwE+3ANCP55NxE5DtcDRXShPtJYT+E8PBAv8g4w2WZZuPEHYQZFHs9
	 9h2YAnK9oSGUbGB4YM/eGiCEkbB6FK5wiBpyqkwUuZ/aKT4ZUEkfdV5Vn9nZNUahxx
	 5C1SU3M+wUNnpn1DpA/PiI0bgIde1/DZkqe9wNHBHhkwAzjWR3F0qxgmJKysAbmOby
	 QPPia3CpkWBHQ==
Date: Tue, 23 May 2023 23:54:57 +0100
From: Conor Dooley <conor@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, simon.horman@corigine.com,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: Re: [PATCH net-next v4 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Message-ID: <20230523-unfailing-twisting-9cb092b14f6f@spud>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-3-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684878827-40672-3-git-send-email-justin.chen@broadcom.com>

Hey Justin,

On Tue, May 23, 2023 at 02:53:43PM -0700, Justin Chen wrote:

> +  compatible:
> +    enum:
> +      - brcm,asp-v2.0
> +      - brcm,bcm72165-asp
> +      - brcm,asp-v2.1
> +      - brcm,bcm74165-asp

> +        compatible = "brcm,bcm72165-asp", "brcm,asp-v2.0";

You can't do this, as Rob's bot has pointed out. Please test the
bindings :( You need one of these type of constructs:

compatible:
  oneOf:
    - items:
        - const: brcm,bcm72165-asp
        - const: brcm,asp-v2.0
    - items:
        - const: brcm,bcm74165-asp
        - const: brcm,asp-v2.1

Although, given either you or Florian said there are likely to be
multiple parts, going for an enum, rather than const for the brcm,bcm..
entry will prevent some churn. Up to you.

Cheers,
Conor.

