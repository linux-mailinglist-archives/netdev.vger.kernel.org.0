Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E49A3F7C
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 23:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfH3VKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 17:10:49 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:41289 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727304AbfH3VKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 17:10:49 -0400
Received: by mail-pg1-f179.google.com with SMTP id x15so4124791pgg.8
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 14:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/GuzhdNjy2NcRMD7ZIYIzekE3Y/DOnhL7kjjTi1rJ/o=;
        b=mOfKST65dfRYWiBFoH+fgcYEME+D4OX0l1Fe3X3/D0dUd9/v+s4Re5gnJRK4DBn6Am
         Mnr/zqBMZyH9eqZ3h4L9zC59/vjEako4G+NQc7cSkCPaxYNaCFGx0ipB9VGHVJFseWhT
         5xEQUhe4IkI1QCrbAduW3ZpftHHCOTyI/wvZFg15KA4RcOYFE5EHO2FqzP13hCxmOBby
         zdjrzuBgtRmyi+eJSDFWc1VlO7mvUFiTdFCuyEGeNwHk23crzgqXPF3L2dvubGTCbMAn
         0GPiS5N/lQxPeoKjRFqz3UQKbkLh5KGy9XkboU2KeFFsNMnNYirjWimA/R8GkgIpmyG6
         es3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/GuzhdNjy2NcRMD7ZIYIzekE3Y/DOnhL7kjjTi1rJ/o=;
        b=RkURZp87xrv481WuJ+c+GvmE6nRkmUfPmQ16MtvjqRseW0UKrd4fqll+/zDLXcmmmR
         IiqwWYFqNKCh9njoCxEhexI342J2wl3d2ezyYxuPmTi8wDhVkZ9P43kot/RAtzBZ7Cap
         fINERXo4hrlaGpLhNhfZ54ieiJI6RWltTE3IRsCcGD6zO2NpmKa2Gb6Yys4seatMhdGm
         XfDCB/VqjzRCvF1cAiu8+auxaX6P1VlPt48UmeFE62CBvU7wR489B3GtTdL1s9ySVNdq
         1odoHjWl4FvzTkjbZhQtTG/PeAjiQjR2XgtET4CKwZXCLLkrJFHh3gZ6SaT+2O7N24lQ
         fAqw==
X-Gm-Message-State: APjAAAWSko4fR0INLyLF6CCGG2bC9jlrO8pC9KLLWqPdYHYM5aKgfy1Z
        BbXjAvVZovlEBv7yJZIjULNRnw==
X-Google-Smtp-Source: APXvYqyXG4KDW2t1q2qQlyUDNDUK3nwls3NAExOanqypXZ6661oIf3DIfpwJsJul/GqjwO7ILcVEFg==
X-Received: by 2002:a65:458d:: with SMTP id o13mr14311587pgq.34.1567199448709;
        Fri, 30 Aug 2019 14:10:48 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a16sm9222896pfo.33.2019.08.30.14.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 14:10:48 -0700 (PDT)
Date:   Fri, 30 Aug 2019 14:10:24 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190830141024.743c8d02@cakuba.netronome.com>
In-Reply-To: <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
        <20190829113932.5c058194@cakuba.netronome.com>
        <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
        <20190829171513.7699dbf3@cakuba.netronome.com>
        <20190830201513.GA2101@mini-arch>
        <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 20:55:33 +0000, Yonghong Song wrote:
> > I guess you can hold off this series a bit and discuss it at LPC,
> > you have a talk dedicated to that :-) (and afaiu, you are all going)  
> 
> Absolutely. We will have a discussion on map batching and I signed
> on with that :-)

FWIW unfortunately neither Quentin nor I will be able to make the LPC
this year :( But the idea had been floated a few times (I'd certainly
not claim more authorship here than Ed or Alexei), and is simple enough
to move forward over email (I hope).
