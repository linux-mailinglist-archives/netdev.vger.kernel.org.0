Return-Path: <netdev+bounces-5752-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF156712A44
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A7962818D9
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CC327713;
	Fri, 26 May 2023 16:11:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A634742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:11:16 +0000 (UTC)
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E29A18D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:11:09 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4f37b860173so1042080e87.2
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685117467; x=1687709467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zv6Et/o2vJnq9DI/Xfro4OfCJ69MVMQNjKnU8DtfuT4=;
        b=VzukazGCld+jAFWS8IFUso9SO51TpS9oyYn4OheWY3u2SyEd7+no2v4jCMVa1+4gNh
         SOqcFuBJJQK8SQ7VyktdX4P+6iqOffT38nR5qFWUO4NErpGOjWAjFDPB1lrreUgjTdUr
         Xr7LGFAL64TlriUYc8fpNWtzIaPtFLdmou6gKVCvwtzlvbik2wjEUfdsuk97e+XYRy5N
         kqPJ7kgMgFMlbWq5+jG/GfEws0NWPpJH6SNbS1exeDSjOAvRr9AftBW2fP42YrTKvVOf
         12NUFLQ/x6kFdM+kicM0FDQsQFhqnKKTuZrhD9AVvDWFWn/EZ6dgU5Rg4FwqgEPcdIzy
         6izQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685117467; x=1687709467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zv6Et/o2vJnq9DI/Xfro4OfCJ69MVMQNjKnU8DtfuT4=;
        b=TqHA3j8h9/WOzv+kMoGNsJhWimXNMkePU35dNy/OeOb+boNq2pgSvX7Y78FxehuH2M
         P/B3PiEYUUo8EMYYLMteBwFTyv+npu6UiziSl3KgWOJYJYfIDb5Q/jFqIXqR6PPcUQhR
         NKT2Po1mxxs2rCCi02N1r2Vu6TThmB3ype30I9kRcuqd6EqvbB922Fbd1ea3r8qP2u1I
         xnqGJ+HAwtXbRKNI1fWwbrWumut0IqIiD9oJ0oWPLFaGvDsdk855lvEjA1OY+UX5VwCA
         4KpuxP0SNhIff0Xk1ju20HyJc6JBQFdfq5DfL6nVOh8hMCx+z/BTFO4vv436OO6jvrB+
         enHw==
X-Gm-Message-State: AC+VfDxTnkIdqCPmeeks0GlulruRKXnEAsUyyCJ9GJaWIjB8AqyGht7l
	nJCpaSlx4BscTyBC/ioOx0sKuyNyXXgi5FuC6UCRWg==
X-Google-Smtp-Source: ACHHUZ6obE/Q8UNp563IPCuiGR1IgN4Q82ONYHibQTS5tTKEAU6GmCCswkQFT2eno5XaoIn23ro5JQ==
X-Received: by 2002:ac2:46e5:0:b0:4f4:ca61:82bb with SMTP id q5-20020ac246e5000000b004f4ca6182bbmr706240lfo.45.1685117467596;
        Fri, 26 May 2023 09:11:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u14-20020ac248ae000000b004f2769a120dsm672913lfg.249.2023.05.26.09.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 09:11:06 -0700 (PDT)
Date: Fri, 26 May 2023 18:11:05 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Simon Horman <horms@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Spelling corrections
Message-ID: <ZHDaGZeVZH8mZOsC@nanopsycho>
References: <20230526-devlink-spelling-v1-1-9a3e36cdebc8@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526-devlink-spelling-v1-1-9a3e36cdebc8@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 26, 2023 at 03:45:13PM CEST, horms@kernel.org wrote:
>Make some minor spelling corrections in comments.
>
>Found by inspection.
>
>Signed-off-by: Simon Horman <horms@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

