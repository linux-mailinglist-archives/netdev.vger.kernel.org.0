Return-Path: <netdev+bounces-9618-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E61A72A05A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:41:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 295882819CB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA3019BD3;
	Fri,  9 Jun 2023 16:41:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24A719E5E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:41:45 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E4B3A9C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:41:39 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f7353993cbso15618425e9.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 09:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686328897; x=1688920897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+1AVcllAn3iwjU08yRkcnifxFt3/r67zY2TJ0SgpYBA=;
        b=foi5I/JjKsd9mKLtadBqvhTs09YbWm1o2f3JMKkQFRGoYngq/yElwdYE2s3mtS26FB
         dpNAfgiU03NFa0HNsUf8HDsr5ZFhLGEKcrEKGTKa6UKlZdx8ACFtLJgm1ifBH+FEo4qG
         Hz9RDJeoH1Qg/SYjW05Z6GUlHMq2gVZffPoITVHqFqmZeI3vh4jkujBUwNWzP3ghWPhl
         Xj3mTI5Q89KPZGlFdl6nODpz8eK9ALAWSbViHpojR3DehTbHJrHz+TPVhlzABqzthIvq
         5Y8AAscfUMVBzjkm6hxVepTi758I0aaMiNqEMZcQBiqBzvx4uYO48AMKxaPVTVhMePtK
         QpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686328897; x=1688920897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1AVcllAn3iwjU08yRkcnifxFt3/r67zY2TJ0SgpYBA=;
        b=S50NQNQr4ktrek3derT/JYY9Xop8GP9ubeb0HIYFh1Xuv7MW4GleOlz/ebF42eZOkp
         +a/LSua4GWQ3gdVGGC0E7+IyRs4cJocz6xRbC/1c3/Fq7DgPfLinTQaEIWS09kqErrfx
         4hpJrs85ww679P95beVO39+t62glRuT8Ue/jxufBd3pj73MJgjhVDF4QK4Bg1zAdWwKK
         z9wbvObyDHy2z/3SP5cVid+5OB9/R7EZZw0kt6lA5NaYI+MvbEmlStlPkty8nl+UiQI9
         gaPG9lkY0INu7ZGwtOBtgALfyJo0QdFfGE2WD7++tsZFbk31+UNHZml1qYYIdig9yTai
         iLEA==
X-Gm-Message-State: AC+VfDyoVpypgPa99rE7CmilPyeGqP3uIbZHmlmtiKOdOTaJPIt2aiPG
	lRTyryvlBjYUOHRlNRCEeUEwdg==
X-Google-Smtp-Source: ACHHUZ4Hsb2q/diC3uQ3TI+OPWBWwVbviqd4QrCSbVAoe/3VEZOtD+ToJA9prjtmGOy2j4UO99NBZw==
X-Received: by 2002:a1c:7417:0:b0:3f6:84:3df6 with SMTP id p23-20020a1c7417000000b003f600843df6mr1925729wmc.10.1686328897648;
        Fri, 09 Jun 2023 09:41:37 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d650f000000b0030adfa48e1esm4877615wru.29.2023.06.09.09.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 09:41:35 -0700 (PDT)
Date: Fri, 9 Jun 2023 19:41:31 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: Vlad Yasevich <vladislav.yasevich@hp.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 net] sctp: fix an error code in sctp_sf_eat_auth()
Message-ID: <7899ff13-ab06-4970-a306-85b218486571@kadam.mountain>
References: <4629fee1-4c9f-4930-a210-beb7921fa5b3@moroto.mountain>
 <bfb9c077-b9a6-47f4-8cd8-a7a86b056a21@moroto.mountain>
 <CADvbK_f25PEaR1bSuyqeGQsoOp0v1Psaeu2zPhfEi8Zcu-J5Tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_f25PEaR1bSuyqeGQsoOp0v1Psaeu2zPhfEi8Zcu-J5Tw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 11:13:03AM -0400, Xin Long wrote:
> This one looks good to me.
> 
> But for the patch 1/2 (somehow it doesn't show up in my mailbox):
> 
>   default:
>   pr_err("impossible disposition %d in state %d, event_type %d, event_id %d\n",
>         status, state, event_type, subtype.chunk);
> - BUG();
> + error = status;
> + if (error >= 0)
> + error = -EINVAL;
> + WARN_ON_ONCE(1);
> 
> I think from the sctp_do_sm() perspective, it expects the state_fn
> status only from
> enum sctp_disposition. It is a BUG to receive any other values and
> must be fixed,
> as you did in 2/2. It does the same thing as other functions in SCTP code, like
> sctp_sf_eat_data_*(), sctp_retransmit() etc.

It is a bug, sure.  And after my patch is applied it will still trigger
a stack trace.  But we should only call the actual BUG() function
in order to prevent filesystem corruption or a privilege escalation or
something along those lines.

Calling BUG() makes the system unusable so it makes bugs harder to
debug.  This is even mentioned in checkpatch.pl "Do not crash the kernel
unless it is absolutely unavoidable--use WARN_ON_ONCE() plus recovery
code (if feasible) instead of BUG() or variants".

regards,
dan carpenter


