Return-Path: <netdev+bounces-6078-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA919714BEC
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5165B1C209FB
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D610882F;
	Mon, 29 May 2023 14:22:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4448486
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:22:42 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F698E8;
	Mon, 29 May 2023 07:22:33 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f6e72a1464so22082565e9.1;
        Mon, 29 May 2023 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685370151; x=1687962151;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vl5E9mH7Bi/ClQnlPR1LRMwr8a1e9GOqSgKO5eVDbSU=;
        b=ggFbeCNormcSCt72bW8IqNCobzV+UiIQWrJ9Ra/a1MX8/CEq8Vuu2VbkPylXs5EuPQ
         RNt0w9J+lWwJ4Z+A01vIG6BYwn74yVGk8J/cGKNjM7h+REbVxa2JPofUPwESHBHYJU90
         aT71CuC6NDB1jcXke5SD8VNO8AV1tKjvGTrjFlr1X+hsH/2hQQc+8oKAfJxcN9/HIdcr
         DTfWxy2yVqhgnMBPWupKvBk3t7qm+ViQ401ZLvgfGL7w+CfzSIIMzxv+87oV8OPrcxWD
         jsf40vMFg7CHF05UHz7hdf3gEmhRuPab2tFDg0ocOqFRrTs0npl6jyzn57vktB4yOfV0
         gwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685370151; x=1687962151;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vl5E9mH7Bi/ClQnlPR1LRMwr8a1e9GOqSgKO5eVDbSU=;
        b=I7CmJuIoTHKShWxP3IDCU0mga+WAZBXQG6HFDUahfo9D0qlDgGjyvHqVtvXNNwUlVA
         7XvDm+1bgg/BhtYVBl/IguaOR0J5ErTi6yGz6XSaX14JKZy4Od5rBOlU1UwbwixHNF8I
         LkBicOva69M4t1mlxeDVf21EP8oS/Z73KvnbjbD4+BYHFJiY3YOHjeUG5/JL+gc93nAZ
         ad/1+sAwH3a0tCDNbTP+NTFd+BvWkPINhsmOT6/GBhDKbCOXNEUqWRALFZiDaAdwlV8J
         F8FjkRpc/18VWXahfHGD8UdYfHVIFFh95I0wdfveW3FLA+9hz10LL6qlFa/rb6bupQ/b
         qrDQ==
X-Gm-Message-State: AC+VfDy2b9aL9/FP2gtYleqPzPI2SVo7gAgoCrHEnBXNUDSrJSe8fngM
	bwUn9iDhWo7hR5aXlwaARE0=
X-Google-Smtp-Source: ACHHUZ7L+Y8YK2pmRY6CMGxDXgKqI9PIYbA5LjI3TodqBKoH52Wli1y549++A2DTU7/h9dwYIpcbFA==
X-Received: by 2002:a7b:c448:0:b0:3f6:4cfc:79cb with SMTP id l8-20020a7bc448000000b003f64cfc79cbmr8855842wmi.31.1685370151110;
        Mon, 29 May 2023 07:22:31 -0700 (PDT)
Received: from Ansuel-xps. (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600c364600b003f6042d6da0sm14382269wmq.16.2023.05.29.07.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 07:22:30 -0700 (PDT)
Message-ID: <6474b526.050a0220.baa3e.31c1@mx.google.com>
X-Google-Original-Message-ID: <ZHSyI+ph47zQgpWw@Ansuel-xps.>
Date: Mon, 29 May 2023 16:09:39 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-leds@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 03/13] Documentation: leds: leds-class:
 Document new Hardware driven LEDs APIs
References: <20230527112854.2366-1-ansuelsmth@gmail.com>
 <20230527112854.2366-4-ansuelsmth@gmail.com>
 <ZHRd5wDnMrWZlwrd@debian.me>
 <871qiz5iqt.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qiz5iqt.fsf@meer.lwn.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 29, 2023 at 08:12:42AM -0600, Jonathan Corbet wrote:
> Bagas Sanjaya <bagasdotme@gmail.com> writes:
> 
> >> +    - hw_control_get_device:
> >> +                return the device associated with the LED driver in
> >> +                hw control. A trigger might use this to match the
> >> +                returned device from this function with a configured
> >> +                device for the trigger as the source for blinking
> >> +                events and correctly enable hw control.
> >> +                (example a netdev trigger configured to blink for a
> >> +                particular dev match the returned dev from get_device
> >> +                to set hw control)
> >> +
> >> +                Return a device or NULL if nothing is currently attached.
> > Returns a device name?
> 
> The return type of this function is struct device * - how would you
> expect it to return a name?
> 

Just to clarify, a device name can't be returned. Not every device have
a name and such name can be changed. An example is network device where
you can change the name of the interface.

Using the device prevents all of this problem. 

-- 
	Ansuel

