Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBC61BF5E8
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3Kyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgD3Kym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:54:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F10C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 03:54:42 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so1325337wmc.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 03:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1kUu8NYflskoYjSwjqb8k5MDH107iHjRDdmZ+H/9EHs=;
        b=azvjiaX6Vd7a6YgrRJpDxA6ssFji1FUb/S13NZ5bXZlL2/yckme4ZApWCLTSsK+OvK
         a6PrLf9qlBdxcuEFbJ7ir3eanBzJORBELyK90K7NubKYZt5we7TtIkJpedsP+d6U+lZd
         KryiwV8osOzPm16sTdeNi6mxnpxqrkZ9WecwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1kUu8NYflskoYjSwjqb8k5MDH107iHjRDdmZ+H/9EHs=;
        b=lyy1dYWbQQdJojM1OZhhgUGJanTj1Q8bzsng5iXW0MTeGzZWoMoBoJkk+LFl/jG6An
         zy8JMoHfmpyiSrpiS0WsCRi/u+QPF/9isSNFyw55I5bNUxUNZX5G4PxvXg0fYpgmdrnz
         0ST1YT7ymtdWdaAKT6mLnkvpkBhs3AMzYCjE7Ga2aVwYEItFdgSDzzPg5kPnx3EYzqE+
         f05+d3WBiAUwnXw6OD7lKwqmlKALM4e7UrWxeMjy165JI8p4fz0NbgyYe5spYwXIBYgh
         +CojIyFScEZLrbBmTE0QiOZezWk+HUKQBK2UeOhWxTjh68y0MWDr1zMJ8sx6FbodG0JH
         6V9A==
X-Gm-Message-State: AGi0PuaR0LBD2LpKWjg01AHVZpmbKrrToM1rX5mde92MLCsUd3VWXaC6
        D/9GveZ/n7qyoHDfM3J/1mRv0w==
X-Google-Smtp-Source: APiQypK9Jjc3pOB6SPB2xdP0+46wLu1COBnOCge8LYEUtcAoztKZz9vEZVspJ5FD+db0DptMhuArog==
X-Received: by 2002:a1c:1d92:: with SMTP id d140mr2309689wmd.67.1588244081111;
        Thu, 30 Apr 2020 03:54:41 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b2sm3946555wrn.6.2020.04.30.03.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 03:54:40 -0700 (PDT)
References: <20200429181154.479310-1-jakub@cloudflare.com> <20200429181154.479310-3-jakub@cloudflare.com> <5ea9d43aa9298_220d2ac81567a5b8fa@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next 2/3] selftests/bpf: Test that lookup on SOCKMAP/SOCKHASH is allowed
In-reply-to: <5ea9d43aa9298_220d2ac81567a5b8fa@john-XPS-13-9370.notmuch>
Date:   Thu, 30 Apr 2020 12:54:39 +0200
Message-ID: <87h7x1utu8.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 09:23 PM CEST, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> Now that bpf_map_lookup_elem() is white-listed for SOCKMAP/SOCKHASH,
>> replace the tests which check that verifier prevents lookup on these map
>> types with ones that ensure that lookup operation is permitted, but only
>> with a release of acquired socket reference.
>> 
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>
> For completeness would be nice to add a test passing this into
> sk_select_reuseport to cover that case as well. Could come as
> a follow up patch imo.

Is this what you had in mind?

https://lore.kernel.org/bpf/20200430104738.494180-1-jakub@cloudflare.com/

Thanks for reviewing the series.
