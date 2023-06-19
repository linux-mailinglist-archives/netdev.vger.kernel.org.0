Return-Path: <netdev+bounces-11992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8E707359EA
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:43:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF4E01C20A89
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:43:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E51C31095F;
	Mon, 19 Jun 2023 14:43:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86C31FA9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:43:22 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1694890
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:43:21 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f62cf9755eso4522907e87.1
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1687185799; x=1689777799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jg4ozZVfolPqyn/t5WEFg1Uls/OOAkHpHShj9UmDbj0=;
        b=XM/YRcXn05iISSP7KE+IKbXpoTRTcJ718yU5TO6gcp/oHw+hYoh0ZSL4WhK5bcd+jf
         6mAAKvJM6L/16KW2cU/etYW1s4n/kP+ZnqPLRw8j4gkGd0gBhg1EckAqltFK62g5BFYv
         F4qZ8WHPYxeuBDUf/227tO1lNgF62oIqWUhWUrhBf9LFkoyFtowqLyVpxk38pWpTioks
         T7z7sbBXhgtHTmX23pNuwBDYalbF+BQqJh5pyC+/pn403N4z5DFsbO0q8GwU0+Gh0Tmo
         BacDMSvWblkXQmOTRpcEQLKJNp4qvOSKcG6e6P5B9YRsKldgvakXMH2eSJMQySdw+iGm
         LCgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687185799; x=1689777799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jg4ozZVfolPqyn/t5WEFg1Uls/OOAkHpHShj9UmDbj0=;
        b=eqsaX9R012mhbkF/WPOsy/nWxT9Z1m7Qf3k/u/v9fmF4020jrP/GuAMfcdoXd1XdyR
         sZTZINHedta461dpopK6U0/JtcBYc2WxtEnGNt7PvxsjGIok5cGLhTGRD9PmBLw02T8N
         NXG2UBTA3mTOaq01JoN7VU+Vx79xeJl/Keh6/OJTNetto1kHFDAn4ryo58ydBnc66NXo
         JT8vS8CVZE+zigqjV83SJDvJqoRg6RQTzN0ogl0sC7ERMOtvRLK+SlGgC1MCa62Jubbt
         nysd6p9ffvbvpK5WoC+0czrXowxNtiFVrACLcXbfayOaWIFRzJJnDKRlYONNLsD9WLDQ
         KurQ==
X-Gm-Message-State: AC+VfDxeHayldos2gDDtjTUzqc53ZHr/D1ZDKkJDH+AJlkT/paHL2+EV
	6FJufJM3SCrYdtBnyz4+UgWLnw==
X-Google-Smtp-Source: ACHHUZ6jK/vkslU8B7BumS0VEdj9EzsfjsiTwLT42WV7OsJvLgsBm6xMwCmMKVvxkyum5HDdV4pj/Q==
X-Received: by 2002:a19:da01:0:b0:4f8:3b15:b878 with SMTP id r1-20020a19da01000000b004f83b15b878mr4868043lfg.67.1687185799177;
        Mon, 19 Jun 2023 07:43:19 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k6-20020adfd846000000b003111025ec67sm13972121wrl.25.2023.06.19.07.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 07:43:18 -0700 (PDT)
Date: Mon, 19 Jun 2023 16:43:17 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Paul Moore <paul@paul-moore.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH net-next] netlabel: Reorder fields in 'struct
 netlbl_domaddr6_map'
Message-ID: <ZJBphdB/7k0Hk8y2@nanopsycho>
References: <aa109847260e51e174c823b6d1441f75be370f01.1687083361.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa109847260e51e174c823b6d1441f75be370f01.1687083361.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Sun, Jun 18, 2023 at 12:16:41PM CEST, christophe.jaillet@wanadoo.fr wrote:
>Group some variables based on their sizes to reduce hole and avoid padding.
>On x86_64, this shrinks the size of 'struct netlbl_domaddr6_map'
>from 72 to 64 bytes.
>
>It saves a few bytes of memory and is more cache-line friendly.
>
>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

