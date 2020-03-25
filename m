Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71FB5192FAE
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 18:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCYRqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 13:46:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42298 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgCYRqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 13:46:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id h8so1489777pgs.9;
        Wed, 25 Mar 2020 10:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=n5l7lR6RVq3D9eTqUy+soFfKNYan/k5pxuRdf4THpTo=;
        b=sfHsEqyLPn4axw+hPHoVxM2t7jgxhJHXzCg4jHOcTyrTg6HOC4hRPLhULuPrh/WhKp
         s/Ka/r3ATa6wxS7IVarXnqkcdU0sxeY0vsx6w/vZARyAhrmdMqpi/ohDOBQn6u0/qu8h
         pza3Apbi3gQ+LPJ4II/IbjOblUSCgN4mjwztXCy4w8Nz/wBw+jqH30nJg/zUX1cmInHP
         oNgzATIXv0maovNHO6tK4n47Y9yjiH1I3Bdub6ui/k3j+2OMdv28bPaIRzosfeOTuWq9
         8n8c8hSOAAo0s7K+4kYvnZG7wpkeqStDpHq98vzrWl3ZBgd0r7oWabOX0L9aEmBf7HuD
         AXIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=n5l7lR6RVq3D9eTqUy+soFfKNYan/k5pxuRdf4THpTo=;
        b=Mmp1ayqzj6ouiMwbai+Y4Y1PqzOxw0ghLq85cQQm1SkXrw0ZIiKBtgo+HQqUvg/p+X
         S35PSk1oCZ4oifKnuzP/RC5JTSC5QHqRKK+rIdkQSEw1JIUBflbf/0SQzC1+zv5S0ukp
         WxnGKx3GJNWshyv0IUfpEQeeEQWm2TKgT4FTZSVUAiqH4l43OLssXjPQshTVhMHNo4F3
         l0PF00RUzzBtIlGR1nAPY4/iRl1c/KLOa2tQumiKUFUHJzkezZ4LGcebVe4nmjp0bRPj
         c3bSJsRnYRgFHoidKi2ioE78T9+yDbz1GAjKBZuP8CrpZ6scqnyMvchn6yyJr76ou943
         jvFg==
X-Gm-Message-State: ANhLgQ3hoLJOb96tYzLKYJgmVjDM14Utn+wqQkWqgIEXY7NW945+IP8g
        n5i198lHdVFzVWnSTcxFbT4=
X-Google-Smtp-Source: ADFU+vsQOEC7GRbchg0qsGDClwy+AoWByjF65/2cOtJnGyG05iFL+6Kxi1T9MyLOQ5C74gb4Np7n1Q==
X-Received: by 2002:aa7:94a6:: with SMTP id a6mr4566602pfl.214.1585158411891;
        Wed, 25 Mar 2020 10:46:51 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b339])
        by smtp.gmail.com with ESMTPSA id j8sm5058189pjb.4.2020.03.25.10.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 10:46:51 -0700 (PDT)
Date:   Wed, 25 Mar 2020 10:46:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v4 0/4] XDP: Support atomic replacement of XDP
 interface attachments
Message-ID: <20200325174647.4u2pfqvefmosbb2x@ast-mbp>
References: <158515700529.92963.17609642163080084530.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <158515700529.92963.17609642163080084530.stgit@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 06:23:25PM +0100, Toke Høiland-Jørgensen wrote:
> This series adds support for atomically replacing the XDP program loaded on an
> interface. This is achieved by means of a new netlink attribute that can specify
> the expected previous program to replace on the interface. If set, the kernel
> will compare this "expected id" attribute with the program currently loaded on
> the interface, and reject the operation if it does not match.
> 
> With this primitive, userspace applications can avoid stepping on each other's
> toes when simultaneously updating the loaded XDP program.
> 
> Changelog:
> 
> v4:
> - Switch back to passing FD instead of ID (Andrii)
> - Rename flag to XDP_FLAGS_REPLACE (for consistency with other similar uses)

please stop resending the set without concluding the previous three! discussion threads.
It's already hard enough for people to follow.
