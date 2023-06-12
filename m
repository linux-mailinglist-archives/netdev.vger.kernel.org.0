Return-Path: <netdev+bounces-10016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B45A672BB01
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA6F61C20982
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B583ED303;
	Mon, 12 Jun 2023 08:42:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BF83C23
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:42:10 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083D2A8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:42:09 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f738f579ceso29311975e9.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686559327; x=1689151327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZv9jAWTaWzU7nrzu2Djk0eQ3SpMj9lpHMajexphw6M=;
        b=UR1vnIyZzeHtpw9hBnGyIaNcl6XBVrU30S1IeO2RNzyJXEARZGzrSpMdj9yMMpveXS
         H5f1F5Q4lfpHpy9TBWAvbRD+kUjs+5pduxfGUlL9TP7Uq31qDcfTOFYXOMDv33D3ccJC
         Q7m2l0d6PS3E2kwbTVKpNy8Sjbecy26F+k/k93bCBumDp5ciNVuhpFV+pYKwELBgJe6/
         O0BRIEzxj46xv8kWftLURdUYG6sw01yLS7mQ4PY4dEuN/8yLVDTVc4A3KbVZMyu1gZN/
         EQ/URRRdUUTqUAXBRI/qvbkzyHOnKQUaaCgJxeNdXb1jvFIjdvMkaObIWgKdqsD2Mh6e
         fFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686559327; x=1689151327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZv9jAWTaWzU7nrzu2Djk0eQ3SpMj9lpHMajexphw6M=;
        b=DWuZyJuYgNjdjuqJj2lWMZCWn3HjxWDj2Fh4tCHpDhwkyS+FZsuf8eTNwP+HHs3g+c
         Xawd1f/ZJJHZNj07ITbho7kzkMouRQHG/Op75vbXIJrge9UVPAdTFET3MSXGI8m7/n4z
         alyGr26MOye1R/PmiVmX+Rj2SgDpFMDIC6MrVx+H2DrMAViiR1ZouptOrhyi2UWQ+wnC
         M3vfxOGQLAcqHb1F1bTH6ePImeo8QbJw/mJdpuceXUJE9Z29q2+R4AuACGi+layfvoBk
         pWF+GgL3CSANskN9SZq01UUBZvxYmQd1mljmW63a1X6JaO3VoV1OOpU1OeTGM3sjbbCf
         nWzw==
X-Gm-Message-State: AC+VfDzhqFd9X1YDlJeN5WsPIP7YcVJro/YICoKDoPwNUXQPrTMnNBxh
	dhGYXaUt1uCBpVuXALcjT0YABw==
X-Google-Smtp-Source: ACHHUZ5/mqBK+0NbKCkqxMr4n9t/4ZJp0hxFrpVr/67v/DAMs3aykmEzq1PiRiVrjvKVtmnpkA92bw==
X-Received: by 2002:a7b:cc96:0:b0:3f7:eadb:9413 with SMTP id p22-20020a7bcc96000000b003f7eadb9413mr5329365wma.33.1686559327534;
        Mon, 12 Jun 2023 01:42:07 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id b10-20020adfe30a000000b00300aee6c9cesm11813978wrj.20.2023.06.12.01.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 01:42:05 -0700 (PDT)
Date: Mon, 12 Jun 2023 11:42:02 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pavel Machek <pavel@ucw.cz>, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-XXX] net: dsa: qca8k: uninitialized variable in
 hw_control_get()
Message-ID: <f7200756-81a3-4a43-939c-01fa91af6a9f@kadam.mountain>
References: <5dff3719-f827-45b6-a0d3-a00efed1099b@moroto.mountain>
 <6486d80d.5d0a0220.bb6d6.3cbd@mx.google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6486d80d.5d0a0220.bb6d6.3cbd@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The net-XXX in the subject was supposed to be net-next btw.  I did check
that it only applied to net-next but I messed up the subject...  :/

On Sun, Jun 11, 2023 at 06:04:31PM +0200, Christian Marangi wrote:
> On Mon, Jun 12, 2023 at 10:20:55AM +0300, Dan Carpenter wrote:
> > The caller, netdev_trig_activate(), passes an uninitialized value for
> > *rules.  This function sets bits to one but it doesn't zero out any
> > bits so there is a potential for uninitialized data to be used.
> > Zero out the *rules at the start of the function.
> > 
> > Fixes: e0256648c831 ("net: dsa: qca8k: implement hw_control ops")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> 
> Thanks for the fix but I wonder if this should be better fixed in
> netdev_trig_activate? By setting the mode as 0 directly there?
> 
> I assume other dev implementing the get ops would do the same mistake.

Yes.  You're obviously right on this.  I'm not sure what I was thinking.

I will resend.

regards,
dan carpenter


