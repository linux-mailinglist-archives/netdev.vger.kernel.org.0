Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8FE36A170
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 15:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbhDXN4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 09:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbhDXN4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 09:56:22 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DE9C061574;
        Sat, 24 Apr 2021 06:55:43 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id d10so37072882pgf.12;
        Sat, 24 Apr 2021 06:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/IfCc4K/H4SL8+rPTPIaKDSNkTmlzfC3v2Rl0HkjeVE=;
        b=t00oA1GoI9otgXPldkNc4r8bGGvlJIE2dYZM61XRwV637L/B7l2OabCdo71Vf/HwXk
         ydKSJWdXUZeeQDuLAR2Qjq15Z38qSABOOlza965ysaGxFhlFG4hAhEd6cd/2umUQh/qt
         2fC2zjVnbtSj0VEvSsHEGcg+CzX540Jj7aYF5OcT5D5Voue+VasZ8LcBU/Nja11ss5ng
         mO6zb9QLNukAiXoCLJ3/YaQh5Oy02XOwXPEV9akIdyAr2NpMYgvotl9mgz+Q0B+qav+r
         zNm70LBiF/QJxhplFiHknbjF8ySpEAE8AVQgR14DsWtNHAHQmm3UbkET3w+/qXy+a2lN
         HQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/IfCc4K/H4SL8+rPTPIaKDSNkTmlzfC3v2Rl0HkjeVE=;
        b=XYrGrYl0ES2gFed9wZXV8TnWCnsaMm5syJB4uMsFeijqe0c1jZm9H7egAhVM66zDYs
         V0CCMuocmQfsBCXj36FVS0C0Trv8kc1D6OpIKnlQGaZ9JYJfEbhbK4dVuUsLT0Gk9j4S
         yiUUWjfk22wOIT8p4l9rBBL7FVY6StY3vqB1eMkSMj2VYizw/b2lQ6r5T88/4r3+QVKU
         WC/VQTPCtiHJIaithzzTTGz6V6BcX4zJktofLNiu65q/Tz62sDKbS+HqVkdTJaf9eNHe
         ftS3VqcGZk73/ghFuBZxn3giJjpUlEW309z5IyYmwA1NA9tYWmQmDsCsJNzFpuFG5a2N
         gdHQ==
X-Gm-Message-State: AOAM533vUQCTmFxYjcnp8k2XoXap7FI58QKLfCpRPvNjCnHp7iH4E+xn
        +nx/haEqe2hYDsoMZtg+k8skAD9kBapQbg==
X-Google-Smtp-Source: ABdhPJwNJZOCK2GywId07jAOeACOyrya2fJkK7PY8dK+LVltSE0mqNq1R+QO+w+XUO8EuAZomxNpzQ==
X-Received: by 2002:aa7:8d8a:0:b029:1f8:aa27:7203 with SMTP id i10-20020aa78d8a0000b02901f8aa277203mr8782067pfr.64.1619272542662;
        Sat, 24 Apr 2021 06:55:42 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t19sm7325688pgv.75.2021.04.24.06.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 06:55:41 -0700 (PDT)
Date:   Sat, 24 Apr 2021 21:55:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv9 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210424135528.GJ3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
 <20210422071454.2023282-3-liuhangbin@gmail.com>
 <20210422185332.3199ca2e@carbon>
 <87a6pqfb9x.fsf@toke.dk>
 <20210423185429.126492d0@carbon>
 <20210424010925.GG3465@Leo-laptop-t470s>
 <20210424090129.1b8fe377@carbon>
 <87zgxoc8kg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgxoc8kg.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 24, 2021 at 11:53:35AM +0200, Toke Høiland-Jørgensen wrote:
> >> Hi Jesper,
> >> 
> >> From the performance data, there is only a slightly impact. Do we still need
> >> to block the whole patch on this? Or if you have a better solution?
> >
> > I'm basically just asking you to add an unlikely() annotation:
> 
> Maybe the maintainers could add this while applying, though? Or we could
> fix it in a follow-up? Hangbin has been respinning this series with very
> minor changes for a while now, so I can certainly emphasise with his
> reluctance to keep doing this. IMO it's way past time to merge this
> already... :/

Not sure if Daniel will do it. If it's already missed the merge window. I can
post a new version.

Thanks
Hangbin
