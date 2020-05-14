Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD031D314F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 15:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgENNbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 09:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726011AbgENNbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 09:31:05 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE86BC061A0C;
        Thu, 14 May 2020 06:31:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id w25so485879iol.12;
        Thu, 14 May 2020 06:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZIQf8pXyFlJJN1BUFT0QIJVogE4TI6IcnPHyJ9wZ8qY=;
        b=rOPcq7h14yK/EIdy3d4F8/OMYGBfgoPO7t/0oGs7Zz8TIZ4ZodmlOwTeQZy0bDF/0H
         KRpVKU5NYpHxR/OpnOTx1+pWZE32VUI3Vba0g6y0n6ycqY6wOlmMXuKEQCV5HeHARCon
         fxY025Pses6hAI+yQrwrxIK0B11hPrRKZHjd7/N7anTf8728aturXQpc19h5CGlkbSGx
         VHX501AocOSHUD7Xzs9lsqwc9xxoSftxLmhUkBjSp0O8SB+uxa/pzx6DbIYhp5RJ9XX6
         utCd9o2kO9nMYT1TZNvXQCdA8fEk1iLDW6BesKQ+D7kSHhaDVwwYgQ7aNwazuUvfMjZt
         sf7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZIQf8pXyFlJJN1BUFT0QIJVogE4TI6IcnPHyJ9wZ8qY=;
        b=DrhWUsKgIYCKT49THrFUuZVqL9AtXUJS6Sx2eObHRHOGMUBYh+XwPQ7STwByBEpcNP
         RI3XDpjKGPwas/12LsNqqf6bdqz+dVqA52NxWtL6HlbAztm2NSbzMCJvlO84GKz5EuUX
         zZGPaQInsOddDQ8ttsDqQ3oqDaFDmwnE0J7ZtndfbKmm7IEUbZUcvy4dP+IaBSu/dSuJ
         aUbVKGazejri2Abcg0bOAdEZ6n+2nmoNAXaXZ89MkjfG5SbsKDUuKhXWPIcKW6d/afqT
         0UkjOWbWUu2ez1rw0OjFcA5rdQ6Z2X7SEYqHs5e2gw26664R9WhFgT8EIeOZ+3OAoni+
         KBIg==
X-Gm-Message-State: AOAM531yCvv7OudfIi7wRPLSpdkSx2fZ8mLU4rnVg5A07juB+tVZ188R
        Mcgn55w3+NtmvqDUHbuurOM=
X-Google-Smtp-Source: ABdhPJwOvmv/0zzgsq8W9jcZJxjhQkAn2CND5zl8VniQGCosrghp6IcMoRjukJpMVlyHYeRJET/fEg==
X-Received: by 2002:a5d:8715:: with SMTP id u21mr4041819iom.46.1589463064161;
        Thu, 14 May 2020 06:31:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d10sm1140158ilr.2.2020.05.14.06.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 06:31:03 -0700 (PDT)
Date:   Thu, 14 May 2020 06:30:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, jakub@cloudflare.com,
        netdev@vger.kernel.org
Message-ID: <5ebd480fa503a_7f582b1a484825b47a@john-XPS-13-9370.notmuch>
In-Reply-To: <35846427-3770-f6ab-b1a6-c974a835f746@fb.com>
References: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
 <158939787911.17281.887645911866087465.stgit@john-Precision-5820-Tower>
 <35846427-3770-f6ab-b1a6-c974a835f746@fb.com>
Subject: Re: [bpf-next PATCH 2/3] bpf: sk_msg helpers for probe_* and
 *current_task*
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song wrote:
> 
> 
> On 5/13/20 12:24 PM, John Fastabend wrote:
> > Often it is useful when applying policy to know something about the
> > task. If the administrator has CAP_SYS_ADMIN rights then they can
> > use kprobe + sk_msg and link the two programs together to accomplish
> > this. However, this is a bit clunky and also means we have to call
> > sk_msg program and kprobe program when we could just use a single
> > program and avoid passing metadata through sk_msg/skb, socket, etc.
> > 
> > To accomplish this add probe_* helpers to sk_msg programs guarded
> > by a CAP_SYS_ADMIN check. New supported helpers are the following,
> > 
> >   BPF_FUNC_get_current_task
> >   BPF_FUNC_current_task_under_cgroup
> >   BPF_FUNC_probe_read_user
> >   BPF_FUNC_probe_read_kernel
> >   BPF_FUNC_probe_read
> >   BPF_FUNC_probe_read_user_str
> >   BPF_FUNC_probe_read_kernel_str
> >   BPF_FUNC_probe_read_str
> 
> I think this is a good idea. But this will require bpf program
> to be GPLed, probably it will be okay. Currently, for capabilities,
> it is CAP_SYS_ADMIN now, in the future, it may be CAP_PERFMON.

Right.

> 
> Also, do we want to remove BPF_FUNC_probe_read and
> BPF_FUNC_probe_read_str from the list? Since we
> introduce helpers to new program types, we can deprecate
> these two helpers right away.

Removed, Daniel had the same comment.

> 
> The new helpers will be subject to new security lockdown
> rules which may have impact on networking bpf programs
> on particular setup.

But only if these helpers are used. If not everything should
be the same I think.

> 
> > 
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---

[...]

> > @@ -6397,6 +6406,31 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >   		return &bpf_get_cgroup_classid_curr_proto;
> >   #endif
> >   	default:
> > +		break;
> > +	}
> > +
> > +	if (!capable(CAP_SYS_ADMIN))
> > +		return bpf_base_func_proto(func_id);
> > +
> > +	/* All helpers below are for CAP_SYS_ADMIN only */
> > +	switch (func_id) {
> > +	case BPF_FUNC_get_current_task:
> > +		return &bpf_get_current_task_proto;
> > +	case BPF_FUNC_current_task_under_cgroup:
> > +		return &bpf_current_task_under_cgroup_proto;
> > +	case BPF_FUNC_probe_read_user:
> > +		return &bpf_probe_read_user_proto;
> > +	case BPF_FUNC_probe_read_kernel:
> > +		return &bpf_probe_read_kernel_proto;
> > +	case BPF_FUNC_probe_read:
> > +		return &bpf_probe_read_compat_proto;
> > +	case BPF_FUNC_probe_read_user_str:
> > +		return &bpf_probe_read_user_str_proto;
> > +	case BPF_FUNC_probe_read_kernel_str:
> > +		return &bpf_probe_read_kernel_str_proto;
> > +	case BPF_FUNC_probe_read_str:
> > +		return &bpf_probe_read_compat_str_proto;
> > +	default:
> >   		return bpf_base_func_proto(func_id);
> 
> If we can get a consensus here, I think we can even folding all
> these bpf helpers (get_current_task, ..., probe_read_kernel_str)
> to bpf_base_func_proto, so any bpf program types including
> other networking types can use them.
> Any concerns?
> 

Nothing comes to mind. I'm OK to move them into base if folks
agree its useful there. I was putting them where I have a known
use case at the moment but doesn't bother me to make them more
widely available.
