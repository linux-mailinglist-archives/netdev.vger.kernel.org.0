Return-Path: <netdev+bounces-11696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F442733F15
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C86F1C20F95
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474C363CD;
	Sat, 17 Jun 2023 07:16:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC3A6122
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6C6C433C0;
	Sat, 17 Jun 2023 07:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686986206;
	bh=SXMxzkupl69XgQE1gIRNMtbifDnHxKajI1lVuAlonhI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pR9bjbOFinCB4jeZ+6kRKbxOCYZNNR4jPikGiYb/Q5EDZK7KRVBI+lFOSVwqD8w5Q
	 vzg3xmAjpYJg2W3sDGRBzkh90n734ANb7DUTsjNAXsziVxxtbndq+3S+dDcnvzsafD
	 7OVzrKCUKz+syiDlVQyu2xeffY/I46oS04G1wbKcuaKW4pPMzK1WJhuDZydpaeGGoI
	 r0PErEKExgQj0AkaSJ7EyT5HW8TcZTP7eRzXFB3iomZs8i0Z4bcAgBKeNo7xfq+tli
	 cT0NiW5cXDq1orS53xzviD4aONKfYKtwZMq3cfxGV64NOK/Nby6JO9MAyr5nxuNPRV
	 WuHcOk04Oh2aA==
Date: Sat, 17 Jun 2023 00:16:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>, Bhupesh Sharma
 <bhupesh.sharma@linaro.org>, Andy Gross <agross@kernel.org>, Bjorn
 Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>, Giuseppe Cavallaro
 <peppe.cavallaro@st.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com, Bartosz Golaszewski
 <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v2 00/23] arm64: qcom: sa8775p-ride: enable the first
 ethernet port
Message-ID: <20230617001644.4e093326@kernel.org>
In-Reply-To: <20230615121419.175862-1-brgl@bgdev.pl>
References: <20230615121419.175862-1-brgl@bgdev.pl>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 14:13:56 +0200 Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> There are three ethernet ports on sa8775p-ride. This series contains changes
> required to enable one of the two 1Gb ports (the third one is 10Gb). We need
> to add a new driver for the internal SerDes PHY, introduce several extensions
> to the MAC driver (while at it: tweak coding style a bit etc.) and finally
> add the relevant DT nodes.

Did I already ask you how do you envision this getting merged?
You have patches here for at least 3 different trees it seems.
Can you post the stmmac driver changes + bindings as a separate series?

>  drivers/phy/qualcomm/phy-qcom-sgmii-eth.c     | 451 ++++++++++++++++++

Noob question - what's the distinction between drivers/phy and
drivers/net/phy (or actually perhaps drivers/net/pcs in this case)? 

