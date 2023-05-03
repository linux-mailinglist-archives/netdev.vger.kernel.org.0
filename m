Return-Path: <netdev+bounces-132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 619276F5544
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 11:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 850152811DB
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 09:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FDFAD5C;
	Wed,  3 May 2023 09:50:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B641109
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 09:50:50 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E6444A4
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 02:50:23 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so4768521a12.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 02:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1683107415; x=1685699415;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=nzMTrFJeM0hfAdWKmiaQPg61F2DkBF+Q5b+R7LJGe18=;
        b=dbIROcpIDkKA5++Dx8M1SceUo8/P/zf+SuuTFmmJO3yXxk+jWsBlsRrDs/+/kbYsud
         MdfDLV8URC5f5omRN1osLqpYoiOIZad+xEwYbrB1f3Do3tv99Z7Jb5ugnWRBJ/AFIy+0
         HJaxVUWNnD+2hQAsP+9GcD9iAYflpxwZJmEmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683107415; x=1685699415;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzMTrFJeM0hfAdWKmiaQPg61F2DkBF+Q5b+R7LJGe18=;
        b=OgvY/0DqVSyRFR8u0Mb41nVqXQeTsFGz+UZvHhxeX3GHCuKCQIo9NjOVjckOA+qhKj
         4YeLrbp4v483QVLTjJH1PnUPsfKs6kBqNC6xJi8dLT2IiWIxINwO9ood32CE0Yh7xdlO
         xXXa0rX1QVkDYFdinhUaodD+MYAa2LAWXcn164y2tYKdmsdmg3EO1wjqY+yNyuDfHhv+
         50EPRwhbGOd57PzYE1cwEMqmMb+xSmomi3thsWa950SzLy44dUs9Ac3LvJp5ZGv5XEdQ
         Vx4YDIXp+94WeDjikuyvswmZQSUdJ27pwsdD4btpoW1XeASzHncNT/Ef34u9jrzIzaKD
         a6Zg==
X-Gm-Message-State: AC+VfDysP5pzFt+vtc0KHKSL3BdSElg+CA2CMMATmUWW4C+sJQ5dBiU1
	St8HaImUHLPq14DHMl1GVecVcQ==
X-Google-Smtp-Source: ACHHUZ75wXd/QPqZRtaNQ+NzishUu9C0BDp22gA5MUVyvohW2Z2xI7CsaBCC+fmzj6LjNvOIBcMc1Q==
X-Received: by 2002:a17:907:7288:b0:961:ba7d:c5f4 with SMTP id dt8-20020a170907728800b00961ba7dc5f4mr1388892ejc.29.1683107415269;
        Wed, 03 May 2023 02:50:15 -0700 (PDT)
Received: from cloudflare.com (apn-31-0-32-7.dynamic.gprs.plus.pl. [31.0.32.7])
        by smtp.gmail.com with ESMTPSA id i25-20020a170906851900b0094f1b8901e1sm17126342ejx.68.2023.05.03.02.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 02:50:14 -0700 (PDT)
References: <20230502155159.305437-1-john.fastabend@gmail.com>
 <20230502155159.305437-4-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
 andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v7 03/13] bpf: sockmap, reschedule is now done
 through backlog
Date: Wed, 03 May 2023 11:49:57 +0200
In-reply-to: <20230502155159.305437-4-john.fastabend@gmail.com>
Message-ID: <87bkj13fsa.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 08:51 AM -07, John Fastabend wrote:
> Now that the backlog manages the reschedule() logic correctly we can drop
> the partial fix to reschedule from recvmsg hook.
>
> Rescheduling on recvmsg hook was added to address a corner case where we
> still had data in the backlog state but had nothing to kick it and
> reschedule the backlog worker to run and finish copying data out of the
> state. This had a couple limitations, first it required user space to
> kick it introducing an unnecessary EBUSY and retry. Second it only
> handled the ingress case and egress redirects would still be hung.
>
> With the correct fix, pushing the reschedule logic down to where the
> enomem error occurs we can drop this fix.
>
> Fixes: bec217197b412 ("skmsg: Schedule psock work if the cached skb exists on the psock")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

