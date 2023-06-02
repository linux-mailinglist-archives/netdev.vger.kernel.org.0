Return-Path: <netdev+bounces-7330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E28E771FB62
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CC03281682
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2467479FD;
	Fri,  2 Jun 2023 07:53:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EDE79FC
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EF9C433D2;
	Fri,  2 Jun 2023 07:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685692435;
	bh=XH5l+kAhJj2RsYxYAcPm2mIoXZkoLae+HowrUKup1UQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AeNLt/fCvTQ0N19RKQBtqbYxgE6fQDZAzEj6n5CWmZQBpn69YD1RCefmkQi8VI1Te
	 k92FEzgP6HyjFgmxz2zLhXrwKnMPbPzEBKy8dbQJwRfA0yGi0gbGW+9JjE7LsILOZz
	 YxPYWJ1FEpu7ASvlR+9yVLUrx4QQc5EkUvgGlNGz3418QztSgdGQC0xTHdhcc/HrAa
	 g3ZyD3ET5+dWyanokzuJGojr/C9NN1MNeXKAoEzHPZHejMpHAwA4Pu23E+9xa5h/Hz
	 9KRy49AjnBpyix20mT02pjEpgU6pk+Jhee91zgxgCpiS1VwkOUziVGAcrgI3L2Oocn
	 NzC41kU9ziCvQ==
Date: Fri, 2 Jun 2023 09:53:49 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: msmulski2@gmail.com
Cc: andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, simon.horman@corigine.com, Michal Smulski
 <michal.smulski@ooma.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: mv88e6xxx: implement USXGMII
 mode for mv88e6393x
Message-ID: <20230602095349.2ab53919@dellmb>
In-Reply-To: <20230602001705.2747-2-msmulski2@gmail.com>
References: <20230602001705.2747-1-msmulski2@gmail.com>
	<20230602001705.2747-2-msmulski2@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Jun 2023 17:17:04 -0700
msmulski2@gmail.com wrote:

>  				config->mac_capabilities |= MAC_5000FD |
>  					MAC_10000FD;
>  			}
> -			/* FIXME: USXGMII is not supported yet */
> -			/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */
> +			__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
>  		}
>  	}

The set_bit() should go into the if statement above, since 6361 does not support usxgmii:

 /* 6361 only supports up to 2500BaseX */
 if (!is_6361) {
 	__set_bit(PHY_INTERFACE_MODE_5GBASER, supported);
 	__set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
+	__set_bit(PHY_INTERFACE_MODE_USXGMII, supported);
 	config->mac_capabilities |= MAC_5000FD |
 		MAC_10000FD;
 }
-/* FIXME: USXGMII is not supported yet */
-/* __set_bit(PHY_INTERFACE_MODE_USXGMII, supported); */




Marek

