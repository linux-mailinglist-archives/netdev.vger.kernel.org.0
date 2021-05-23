Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52638DE1F
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 01:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhEWXrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 19:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbhEWXrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 19:47:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DE3C061574;
        Sun, 23 May 2021 16:45:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so10227297pjb.2;
        Sun, 23 May 2021 16:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t4U27o4bN+E4edMVs81xaohi1atx5g6UX4jkDMnrxlg=;
        b=csfKvXBA2uho4nzAG162Ei7MseLwv3OLikn4kqxVPH7wNOWg+J/s9XyMtEPBEkHAxv
         rKw3RGeSXEUKNUoZHq0U90I8lu7A5vcP5ujYEWM98a7tLPZhugyq6pLsoSz9usZyHv58
         0hVAE6osdbHdcH8UmAbfael/DNjQZP4Yq9PNtUWwICveMf7ymoYrwFS4eDmI8E2bvaDo
         uxf383bL514xsaeixuB81AxyGCjcpv58OoWHRTvTjVxcDPeIhkMAV32pA/4b+tE8drUm
         D5/xBiZg/8XUIEyVhU8/02y7yNw5wmSLnqKC5q7OC5eVEf9MlkZRWAWnXBuPGclzLB1c
         HvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t4U27o4bN+E4edMVs81xaohi1atx5g6UX4jkDMnrxlg=;
        b=JahEhr7W+RpfK2tf+RqCQnCAJtHrOvPQf7dWOFRNMVZm8WjfS+5r7l4In0Mzlwgl/6
         JFbYt0QKpmYzW32neF+efPnF45yXo7lQr4nQCfa+sCugbSe1ZXmpQiXY33N5s8xYzuYL
         lfukAI/oXvm7LMt79waevnlsHrfzwmTNjVYblZgItToTXwIcsBwqsPD99frFwF7EYrr+
         isxcXejWfF3SJnmWL5uFd+bovenO6Z9qUfckuLBSgmw54e08TJ2D4WdAdy3px+fIGRQ6
         OBbz0SLUgTOGASXoOiP+hbdMvqZv8EteWVz/Kdjq8YebggYSnwXAZ++0shbTJRiD+8M9
         r/Jg==
X-Gm-Message-State: AOAM53091raGrASyIcTmWAfJTHrTCHMuGTaM2i+9g5tEQTEopPobPDEY
        7m4RbpAZiipOI2eVAfMd7NA=
X-Google-Smtp-Source: ABdhPJyhwgIeLnBL7gK2ncjiVoho2lSly/lYt98V1CHuGo8Bw+ycH5+ysViFEMpms8K+m9um2wrAGA==
X-Received: by 2002:a17:903:10a:b029:f4:109c:dc08 with SMTP id y10-20020a170903010ab02900f4109cdc08mr22278232plc.10.1621813541760;
        Sun, 23 May 2021 16:45:41 -0700 (PDT)
Received: from Journey.localdomain ([223.226.180.251])
        by smtp.gmail.com with ESMTPSA id y26sm9817444pge.94.2021.05.23.16.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 16:45:41 -0700 (PDT)
Date:   Mon, 24 May 2021 05:15:34 +0530
From:   Hritik Vijay <hritikxx8@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: BPF: failed module verification on linux-next
Message-ID: <YKrpHqp0PlZDe5Q2@Journey.localdomain>
References: <20210519141936.GV8544@kitsune.suse.cz>
 <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:31:18PM -0700, Andrii Nakryiko wrote:
> It took me a while to reliably bisect this, but it clearly points to
> this commit:
> 
> e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_lock")
> 
I tried compiling 5.13.0-rc1-next-20210514 and observed the same error.
5.13.0-rc1-next-20210513 boots fine for me though.
Could there be that there's something more to this ?
I could try to recompile 5.13.0-rc1-next-20210514 but I'm pretty sure
that it didn't boot.

Hrtk
