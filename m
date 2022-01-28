Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AA649F126
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345491AbiA1Ckt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241696AbiA1Cks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:40:48 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F43C061714;
        Thu, 27 Jan 2022 18:40:47 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id v67so9723052oie.9;
        Thu, 27 Jan 2022 18:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LCUpKL6Q4YVQB78FuL+ZiIfU1lE3NIMRMuq43Mlq/lU=;
        b=bc7Ks/Qyk5hTF+gCMeDrnWUa0ihSQIEFjuKTmWMI3L6PIuX6YfhKHkpOCwgbJrHW/3
         m/C9g3jBBiMMr1NJb6PiClASWBx0kNSmIAu7ICCU+Sd/IyDzxZn7We64ahiQOp0GXreW
         t2S3nr6jVe+6hYql40I0zwYKIvjGdKIocEHuXwc6nD9XGSWTwMPA089Ar4ETV7FFk/dN
         0GpKAlCu6nTC2iHYO/E8kMGe3tHq1xGJN/lgBaMX+vYS1triBE2H52YyhHAF4SNT/oMP
         kfLC7OdodJUg3Vry7wO5BdVQa6bBxojGauPBcgiuvgo8wPa4wQkvCnN0ZZfZcfhaImUa
         9PVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LCUpKL6Q4YVQB78FuL+ZiIfU1lE3NIMRMuq43Mlq/lU=;
        b=xDLioeL38CBGTI6ftUOm3IAKPbaROPw75WqLiAC05tQPZGPkCagcSIHLNYrWrZP55e
         fRG73dyDB+UwId4hxbfB6OMPcowMbqCWzzGmx0bJnRDc0ea8lV4ZKxXMdyEy8zBMstvw
         JFgcK5MVnLA57MY9IDO1t8okk1H3AyzIkY0eEx37izMOqLW0P7Fmu2TmRIJYJ9YnvyeX
         TFB4u34oPqocEabijYyUeh0sOSP4N2EJ6ktfoaIYB2TuOvLJUckuY43xVfRnjoMI12VC
         ri204a/cRBp1Uv8Su3mwb1KYsRwAjOaVR905eM6XwTbV+uCbQlLQ7fMpe0owFI0+BFZJ
         tqsQ==
X-Gm-Message-State: AOAM532VykTiNQGyiBXMojyjboHQ7tVxjgGw7kl/WvGSLT4Vja9wYvaT
        AswFyqw5J0tZ34O/g5aQsZQ=
X-Google-Smtp-Source: ABdhPJz3wjrAWC9bvqx7lWWx1bRRiA9vCcE4qb3sL8ZtEOFfAndAg77ALs1pVxh+ZHBDuSkEoeL9fA==
X-Received: by 2002:a05:6808:1185:: with SMTP id j5mr4000156oil.75.1643337647283;
        Thu, 27 Jan 2022 18:40:47 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id h2sm2780353ots.51.2022.01.27.18.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 18:40:46 -0800 (PST)
Date:   Thu, 27 Jan 2022 18:40:39 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Brendan Jackman <jackmanb@google.com>,
        Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf <bpf@vger.kernel.org>
Message-ID: <61f357a749eef_738dc208ec@john.notmuch>
In-Reply-To: <c0831a45-3d39-891b-b89c-36167421d28b@iogearbox.net>
References: <20220127083240.1425481-1-houtao1@huawei.com>
 <CA+i-1C2HBja-8Am4gHkcrYdkruw0+sOaGDejc9DS-HfYVXVfyQ@mail.gmail.com>
 <c0831a45-3d39-891b-b89c-36167421d28b@iogearbox.net>
Subject: Re: [PATCH bpf-next] bpf, x86: remove unnecessary handling of BPF_SUB
 atomic op
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann wrote:
> On 1/27/22 11:48 AM, Brendan Jackman wrote:
> > Yep - BPF_SUB is also excluded in Documentation/networking/filter.rst,
> > plus the interpreter and verifier don't support it.
> > 
> > Thanks,
> > 
> > Acked-by: Brendan Jackman <jackmanb@google.com>
> 
> I was wondering about verifier specifically as well. Added a note to the
> commit log that verifier rejects BPF_SUB while applying, thanks!
> 

Thanks for the follow up Hou/Brendan LGTM as well. After its been
merged, but ACK from me as well.
