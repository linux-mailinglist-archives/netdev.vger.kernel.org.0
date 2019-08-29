Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71525A220C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfH2RT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:19:27 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33616 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbfH2RT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:19:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so2525175pfq.0;
        Thu, 29 Aug 2019 10:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z/fGCxw/3ULoIT8aORRfLQ9r2Znk6cE0sQKUHWa/d1E=;
        b=FUmghiQEpDcO4QEONWqCc+1OnmPyqcytwzVa3vrUELq5t1//ULsMpFn2ACMheVdLG4
         5hZknocFq1SuoJz+HN191Y1utAi+T1blJ0h+l2Up43A3RUSnrf61AAxnUldGc5O4MZil
         Y8c1IWNV0TIPYGPgj7HhKNba4P4g/xghmnuZMRpxootHqt+PyazaxcpgiyIHHTZ7uK3G
         DqzW40+zcGcPNXVZlPDN0c5RKdwlkwMraVyRpDVX48F37NCTowh4Ryex3W6j5PJpQCCp
         P0wK7Bpat2chIGiGsFrYfiZQycazYSXsoKOhf1KY+9a+kqtSmyIAsLLvB4eQ6qUQMsIq
         gNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z/fGCxw/3ULoIT8aORRfLQ9r2Znk6cE0sQKUHWa/d1E=;
        b=No3zRjWrIS7fjZsp04YSd2JUYH+FhPfma9KosMZl6iodWiasIQ1lUPSjruDDdnjBls
         76xh2buU3Jifm3ttW0Pyr4oLDbnTWVQPRSd8QwSXQdzqBZH3VpL7n74pqFQZrRJ7BALL
         djcTjCk5/q/62PeR7wUGpProGZbl5Iz+g27J/j+gRIwOeJFQesAxarSCzLiGz8/kh1rU
         t6e0ByqLKz2COtTARJgYhKov62qhhi6DwqMqgTFbqPzlEURECc2TT0XsGnIcxWHGQGLW
         6H3jIU/MbEiY0c1waO5cDx8MrsS9ZuEyW3VBCxSaYKTdAeaK+UNN6NoQEgHv3g1bbyEg
         VGiQ==
X-Gm-Message-State: APjAAAVEbTkmwoXYR0GIaDuw35rGDA6DN6tlklKkj5+7OUuSH5qjn/V1
        l6k8Z7bLbvroLE24uPBidzc=
X-Google-Smtp-Source: APXvYqwHILu4ZjnB0oHEehfMQtW1wWrlXUk091CIB1fkI5Mf/yPUYl8pahKP80qBGz6khJ8oE6Crzg==
X-Received: by 2002:a63:e20a:: with SMTP id q10mr9173763pgh.24.1567099166174;
        Thu, 29 Aug 2019 10:19:26 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:1347])
        by smtp.gmail.com with ESMTPSA id s16sm4664059pfs.6.2019.08.29.10.19.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 10:19:25 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:19:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190829171922.hkuceiurscsxk5jq@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828071421.GK2332@hirez.programming.kicks-ass.net>
 <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
 <20190829093434.36540972@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829093434.36540972@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 09:34:34AM -0400, Steven Rostedt wrote:
> 
> As the above seems to favor the idea of CAP_TRACING allowing write
> access to tracefs, should we have a CAP_TRACING_RO for just read access
> and limited perf abilities?

read only vs writeable is an attribute of the file system.
Bringing such things into caps seem wrong to me.

