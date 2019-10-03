Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2E4C9FE4
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 15:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729748AbfJCNxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 09:53:33 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46209 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbfJCNxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 09:53:33 -0400
Received: by mail-qk1-f193.google.com with SMTP id 201so2370653qkd.13;
        Thu, 03 Oct 2019 06:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=TpkjA3LW65msG3CvQi16HCXYdGoMoSMdGRoxqPOG4I4=;
        b=FdfZGbxmprz1kvgbwEzNX3EkCSr9vVCGFMlhJcnRbacHTztvrw590NufZWmAJp+Pwg
         rgeEvYS4ubo8zpXKwB22yN4s5ewj+TnSPBETwfxVhg+3i9quunCiGYWf1Sli9881aCyN
         2y0wad7PJ19CI4FenW3uVgOQevZTVqT0r0Xpijdu9F/kknYYvFLbylwONKdbQZCSUihk
         ZJRuF59mI0rUEh3QKPYy7ngMT4uHi41ktXGGEHgvSz9hrozMLGxPT3FqKx0CNDbXrAib
         2swnX5OIogGb5JL7YE3gKt/fKq4coTEAmoZdTDgOgO1Mek6LRtXhaCaR9vaK2/fnuSVO
         pVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=TpkjA3LW65msG3CvQi16HCXYdGoMoSMdGRoxqPOG4I4=;
        b=juj7bV5G1ee9dcOa1jKxnc/Ljy4UVea01WQe4w9mlXyOeozaKEjcZhDVeVvOlkSA1y
         qR6N2CKmzxcWuxMya6Mp7UETCZoWHeS9V12xxfh0vB9jUtRe5A15kRuBL4VxkzlxRHQU
         JnQubtki6eMnta2k3jxaPVQd8cIJ80Aq0LjDErr2nFbingFLCN6QOGIJe+olDpphyfqZ
         XXco3we/v2BkG6CMYvcvnQa1t1Oc5Rgg6qzGqXjGyzSFy9Xm+R2pG74msE5bL7CbGjjK
         yQ2QAN014p5kLOBUdw7Zgh9Ax25DcLB/JDe5cc+Te8CJ/wzdCkzuivBWZ3FQFbOHe8E2
         nECQ==
X-Gm-Message-State: APjAAAXod18kP26qwvO9XVKlVeJ6AYU9oBmNaEoNg0NEiHKH2CHJjgHF
        /YrbdbrL49DazvtZap4XFOM=
X-Google-Smtp-Source: APXvYqxHqsuuEatoPYupxJbwST/vrTp8midO8A+O1ohyobPpYfx/Ys6gIVdcD58UkSNfn8aHnM7xtg==
X-Received: by 2002:a37:8f02:: with SMTP id r2mr4487264qkd.197.1570110812084;
        Thu, 03 Oct 2019 06:53:32 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id d16sm1230778qkl.7.2019.10.03.06.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 06:53:30 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4720540DD3; Thu,  3 Oct 2019 10:53:28 -0300 (-03)
Date:   Thu, 3 Oct 2019 10:53:28 -0300
To:     KP Singh <kpsingh@chromium.org>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        adrian.hunter@intel.com, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/2] samples/bpf: fix build by setting HAVE_ATTR_TEST to
 zero
Message-ID: <20191003135328.GB18973@kernel.org>
References: <20191001113307.27796-1-bjorn.topel@gmail.com>
 <20191001113307.27796-3-bjorn.topel@gmail.com>
 <CAPhsuW627h-Sf8uCpaE4eyu+wpkOPK+6eXkOhwMBnvFVVDQdKQ@mail.gmail.com>
 <CACYkzJ6R4bY2B61fC-EYGn0f-osPOVrZEJsatWyJRFn9_1JN2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACYkzJ6R4bY2B61fC-EYGn0f-osPOVrZEJsatWyJRFn9_1JN2A@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Oct 03, 2019 at 02:19:42AM +0200, KP Singh escreveu:
> Tested-by: KP Singh <kpsingh@google.com>
> 
> I can confirm that samples/bpf are building for me now (x86_64,
> clang-8) after applying this series and:
> 
>  * https://lore.kernel.org/bpf/CAPhsuW5c9v0OnU4g+eYkPjBCuNMjC_69pFhzr=nTfDMAy4bK6w@mail.gmail.com
>  * https://lore.kernel.org/bpf/20191002191652.11432-1-kpsingh@chromium.org/
> 
> on the current bpf-next/master.
> 
> 
> - KP
> 
> On Wed, Oct 2, 2019 at 11:00 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Tue, Oct 1, 2019 at 4:36 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
> > >
> > > From: Björn Töpel <bjorn.topel@intel.com>
> > >
> > > To remove that test_attr__{enabled/open} are used by perf-sys.h, we
> > > set HAVE_ATTR_TEST to zero.
> > >
> > > Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> >
> > Acked-by: Song Liu <songliubraving@fb.com>

Thanks, applied.

- Arnaldo
