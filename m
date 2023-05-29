Return-Path: <netdev+bounces-6104-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0442714D4E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:46:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E7C81C20A30
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D82548F5A;
	Mon, 29 May 2023 15:45:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6796AB7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 15:45:57 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693ABC4;
	Mon, 29 May 2023 08:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=rOnUNLgy0uJnQ1Nieea+DB3PN7mIsSIgBYdXTpxYz0s=; b=eDwOtnbbikiiTvgrnireaeLzjV
	UK3lwNgEGiKJQQn2kFkNubbwxCXwKOLhM6rFtQdIp3oPcDMJPiOSyjOzv7XiG0NIRdqq5jl0LN5mX
	S6bXsbvi8RevSEG6O3lxir4+9YhOxcOwNopAn/jsutd0N5IyKB6NHaUSw9clcY9Ke8/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q3f45-00EF3c-4j; Mon, 29 May 2023 17:45:45 +0200
Date: Mon, 29 May 2023 17:45:45 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 08/13] leds: trigger: netdev: add support for
 LED hw control
Message-ID: <41bbeede-b88a-431f-8bcf-ba3c8a951dc5@lunn.ch>
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
 <20230527112854.2366-9-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527112854.2366-9-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>  static bool can_hw_control(struct led_netdev_data *trigger_data)
>  {
> +	unsigned int interval = atomic_read(&trigger_data->interval);
>  	struct led_classdev *led_cdev = trigger_data->led_cdev;
> +	unsigned long default_interval = msecs_to_jiffies(50);

nitpick:

We have 50 in netdev_trig_activate(). Now it is used twice, it would
be nice to replace it with a #define. I doubt it will ever get
changed, but we do want them to be identical.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

