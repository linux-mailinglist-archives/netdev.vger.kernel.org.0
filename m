Return-Path: <netdev+bounces-1781-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BE96FF213
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C40F1C20D4F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4692D1F948;
	Thu, 11 May 2023 13:03:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3579A1F931
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:03:53 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412D51FE0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:03:51 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f315712406so284849085e9.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683810229; x=1686402229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kHCckfFGgwMqKNo9TGxatbis6tZv5dNvnt6rVD3648Q=;
        b=cbJ8HJkYUlgr/+gfsTR6HSiMuUotFKFuuZG5LBJRPyUnwkfQjczacE77rLe0PpKXFO
         dtpGXIO36cZkpcFQSsf4a9NcANRxZRafoM5jIyEW3XyE2yPlebU3I/djNckn8QlDnCnk
         1Ori7R7wvSPAkzvk+SVDnRVKXoT2JV/JT16qFxyDXsY5+fvqv0cljxU5y2CH7xclu9vx
         u96E+gFmb3JC4AjHrvCTU8I4gIrh3DyTkMlaHAusjBlajiqpVGfQ6at4EfvRVSCztpxe
         XdSqwS8smtMsU3Jjzyj4kDR2fbmxLpzx7pMvo/sPlh0BjytKaiXHvV/bR8fiDtmXZQAA
         72lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683810229; x=1686402229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHCckfFGgwMqKNo9TGxatbis6tZv5dNvnt6rVD3648Q=;
        b=EL/zHBeNkOIfSFc7qonXuzzjm/8oqd23EY2uxjEj53bKrNg6uahdcnxPUkGHLfCrQe
         t+B5XmSyJK9jDp8wCE7o3RqtP2PSaU03HuikEzFqOa5cL6kTSz5pqqpn8sRScmlOOHop
         s7ZXUAriCZdBg6J1SJqvASM6Eyp8soQAF6+uUV8v6ZVj/F0gwAB4bF0Qn1L8daNA20Fw
         ADCXDaRd7JmX2DMAMge13bYv3hWTHf+V5rZf6G4qS/1OrAQeQKGTwPKiOg4WAjYccd5z
         sQCvEtPqFjVHnESt4Er7TKaMhA8X5hD8hNEUQGKTMqiNedNNKwCNzACgMgzSiyaZEnGg
         J/6A==
X-Gm-Message-State: AC+VfDx+EYzVmC0N+24mH3qmbMJl79uJfaeK68ZqYvvPOheTSpo8uyF/
	vcLftoEEr7PJYbv/88s0+pCW9/w3KP3EOYbkDco=
X-Google-Smtp-Source: ACHHUZ7roEStvVBfNoOay7Wys1mZMO/v/i7Om2sQK7iAtoDxXzQ+/UtWaohojpy3Pc4yB9Bw1ZMPIw==
X-Received: by 2002:adf:f388:0:b0:307:cf71:ed8c with SMTP id m8-20020adff388000000b00307cf71ed8cmr1012866wro.35.1683810229427;
        Thu, 11 May 2023 06:03:49 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id m2-20020a056000008200b0030630120e56sm20205767wrx.57.2023.05.11.06.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:03:47 -0700 (PDT)
Date: Thu, 11 May 2023 16:03:42 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Simon Horman <horms@kernel.org>
Cc: Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Per Liden <per.liden@nospam.ericsson.com>, netdev@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, smatch@vger.kernel.org
Subject: Re: [PATCH RFC net] tipic: guard against buffer overrun in
 bearer_name_validate()
Message-ID: <22710fbc-cbd9-4eb0-8e0f-7c2fd1f6d43a@kili.mountain>
References: <20230510-tpic-bearer_name_validate-v1-1-016d882e4e99@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510-tpic-bearer_name_validate-v1-1-016d882e4e99@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 02:48:11PM +0200, Simon Horman wrote:
> Smatch reports that copying media_name and if_name to name_parts may
> overwrite the destination.
> 
>  .../bearer.c:166 bearer_name_validate() error: strcpy() 'media_name' too large for 'name_parts->media_name' (32 vs 16)
>  .../bearer.c:167 bearer_name_validate() error: strcpy() 'if_name' too large for 'name_parts->if_name' (1010102 vs 16)
> 
> This does seem to be the case, although perhaps it never occurs in
> practice due to well formed input.
> 
> Guard against this possibility by using strscpy() and failing if
> truncation occurs.
> 

The existing code is safe as you say.  I still feel like strscpy() is
better than strcpy() unless it's a fast path.

The Smatch strlen() code is not very good.

   137  static int bearer_name_validate(const char *name,
   138                                  struct tipc_bearer_names *name_parts)
   139  {
   140          char name_copy[TIPC_MAX_BEARER_NAME];
   141          char *media_name;
   142          char *if_name;
   143          u32 media_len;
   144          u32 if_len;
   145  
   146          /* copy bearer name & ensure length is OK */
   147          if (strscpy(name_copy, name, TIPC_MAX_BEARER_NAME) < 0)
   148                  return 0;

Smatch tracks strlen() but it tracks it as a maximum.  So here smatch
says that strlen name_copy is 31.
TODO 1: It should really track it as a range 0-31.
TODO 2: Create module to track strlen if the strlen is stored in a
        variable.
TODO 3: Create a new module to say if a string is NUL terminated.  (not related to this bug)
TODO 4: Create a new module to say if a string is not NUL terminated. (not related)

   149  
   150          /* ensure all component parts of bearer name are present */
   151          media_name = name_copy;
   152          if_name = strchr(media_name, ':');

TODO 5: Add strchr() handling to Smatch *DONE in my tree*

   153          if (if_name == NULL)
   154                  return 0;
   155          *(if_name++) = 0;

TODO: 6: Before Smatch saw ++ and set strlen to unknown.  It should be
         set to 29.  *DONE in my tree*

TODO 7:  Create a new module to say that if_name points to the middle of
         the media_name buffer.  The *if_name = 0; means that media_name
         strlen is now 29.

   156          media_len = if_name - media_name;

TODO 8: This is saying that "media_len = strlen(media_name) + 1".
        Tricky to do.

   157          if_len = strlen(if_name) + 1;

TODO 9: The existing code has a bug here because it thinks if_name is
        length 29 so that means if_len is 30.  I hacked around this in
        my tree so now it says it is 1-30 but TODO 1 is the correct
        fix.

   158  
   159          /* validate component parts of bearer name */
   160          if ((media_len <= 1) || (media_len > TIPC_MAX_MEDIA_NAME) ||
   161              (if_len <= 1) || (if_len > TIPC_MAX_IF_NAME))
   162                  return 0;

I think TODO 2 would make this work automatically for if_name.

   163  
   164          /* return bearer name components, if necessary */
   165          if (name_parts) {
   166                  strcpy(name_parts->media_name, media_name);
   167                  strcpy(name_parts->if_name, if_name);
   168          }
   169          return 1;
   170  }

It's a lot of work to handle this correctly.  Most of it is not
complicated, except TODO 7-8 which are very hard.

regards,
dan carpenter


