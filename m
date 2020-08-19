Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97332491AB
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 02:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgHSAKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 20:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgHSAKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 20:10:47 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BC6C061389;
        Tue, 18 Aug 2020 17:10:47 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id s9so11156818lfs.4;
        Tue, 18 Aug 2020 17:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/oQ2SSvXXrYO+8KNfMT4XNQ8N/22aRZOb9JtB+BGTM=;
        b=b3slP6vE4+qaGv4+H9QuGZrlfztO01G52ybkAxWCPH3RGQ76WgHky9sni+pDeUL3dy
         1p74rsxuDRSAnQVvKB13TE9wjQ5mt76uO9yQ1OeFBqa2ygbc6UxIeHtgABdWZQD9htPm
         mIHGnib7N2rPRgaLivI1UkrQAcuzRjM+40GUFgR0X5ec0glVzPcgJTVWLQHwT0HXmBp0
         FfYWYuxlxCtsAbHV8tOFi0gwkyXVdMdPdY+CrSygjB1XCwhAv8l9GRvzaCh97rbeCyiZ
         cO18f0i91oHpZiZpqsdzBiB+n2bjQLYAjFDItMemXQaZy1WmHdfJsPiU5yB9O1V1Cwy2
         xiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/oQ2SSvXXrYO+8KNfMT4XNQ8N/22aRZOb9JtB+BGTM=;
        b=CJ3aTZP+vvUrpRJS4i4Gnw4R555kZ5V+umozVu9r2g7H9RQ795KJOmtq8Sq9Z3oLnd
         nabRmoTeWUZ2LuqrtS3j3w1v8yuDN9N+SbpvbxHXF8vznBkAEFgwtgn8D/qsVZmCrgWn
         3tKal7E9eppPZTqdYa2TPSmfleANMD3IfUDHyJ4VE0NoS79RyOl6pEnmDhQFom7LYw39
         g+GN2U6jlL3oRMyZjuPdMx5GgecyXdsaHeZKJJ11VTXXlrkM5pTnK1VahC2c+SWY4LW6
         Em6lCgvh6v+akIMPtFU0UvNKc48rFcMuOkIET/yTHqMh5r3Q8SGc0yfIEGAJuXn7b5IP
         7+qQ==
X-Gm-Message-State: AOAM530o0XCT3C8Gy2SYDQXyvtbXhDmBNdHyW3NBZ1FGF6oSnuHvYLO8
        53VwnRD4IzmW6nTFbbNJsd2K40YOkyoIvTsx5Mg=
X-Google-Smtp-Source: ABdhPJxPAgpQCnv7ijcI+9o4fSLPIiRVlcM82qNTeDI1h3D3jH72hgqJsvzjp8d7Gv2YwA+xXfaHR2nu1A2uVE/+j0c=
X-Received: by 2002:a05:6512:74b:: with SMTP id c11mr10679774lfs.119.1597795845438;
 Tue, 18 Aug 2020 17:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200818051641.21724-1-danieltimlee@gmail.com> <d68b548d-ed68-5ff1-5db7-1cebe0d19180@fb.com>
In-Reply-To: <d68b548d-ed68-5ff1-5db7-1cebe0d19180@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 18 Aug 2020 17:10:33 -0700
Message-ID: <CAADnVQ+v41221W0ix5Z8Jb49c0S3hr3=2onzCkjcqS-XBwDk=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples: bpf: Fix broken bpf programs due to
 removed symbol
To:     Yonghong Song <yhs@fb.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 9:01 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/17/20 10:16 PM, Daniel T. Lee wrote:
> >  From commit f1394b798814 ("block: mark blk_account_io_completion
> > static") symbol blk_account_io_completion() has been marked as static,
> > which makes it no longer possible to attach kprobe to this event.
> > Currently, there are broken samples due to this reason.
> >
> > As a solution to this, attach kprobe events to blk_account_io_done()
> > to modify them to perform the same behavior as before.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
