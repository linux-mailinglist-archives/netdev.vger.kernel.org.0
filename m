Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09E91A2B57
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfH3APl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:15:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:44904 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfH3APk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:15:40 -0400
Received: by mail-ed1-f65.google.com with SMTP id a21so5948420edt.11
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=YOdTkHd77X8g27PNbs+UfFuRdYaTWsb2ChxF6UVvFqY=;
        b=max+35Ou+7fjaaTzoKNRiTg3NOVCGPB5WNVDQVOCLRAm/n++xMOpES7wvllGineMZX
         rBV8Dbxio3MCukku3lnD9c1GlTXFcHET1rd1QjTKguczM5Cqe0gJnVVqJicuer9qlIN8
         yM5sYpzwegwqQ+ty24iS/th4o2NXszjVfK97cEEFNCRrEuhh6ziJShITFfEJx0oF64B4
         5sr03FT4iDL/fVuoHHmAy2W/Hh2zSG81F+Oh/DDxaFol1Np65RatFFCGrsnLMKGAZR+8
         jYxYc5bdEvwG9g4RZSc/opK4SdjzN24QCrDYPXK98fooyUff+4JAw9OKArn118WYw3eo
         r/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=YOdTkHd77X8g27PNbs+UfFuRdYaTWsb2ChxF6UVvFqY=;
        b=rb/sgowbSEsxMeJUlRP4ab3s5f5CWkMOSjnrCwyhmTRERhdogi6FJ6n1mXG6VyZesR
         x+HpN+zd+MVZu/qHFp1tBTjTSezJZPH7Is4WOB0JwVMOxY9OecxjyboR2aQFQsuNa+rY
         rPEH6M0TXstBVMbk+FdrE/nR2mpnKtcuEUrkliEjx4IeI/PVdUj7dgys2v/EnqAE4KHo
         48YIAVX0kkcyM5zj6nfg7y+KnOSMZnhNuyECgxUPMjtpGoXEU7H27oAFIbrh+O1DqZlg
         oFk0MK5AUWRzW+VHiVLrW6N6wAHT+hLu7NowjFoDZvMO2+DxdKH9hY+RmhP01YzkHJPs
         iYWA==
X-Gm-Message-State: APjAAAW/Mp5IfNbvPLkgJiDLtigLfjUXUTagXWTdwRdBhw4L414o89Fb
        3XY/q/AgC5IHApIHjTkmwigu+A==
X-Google-Smtp-Source: APXvYqx2PZAJD+0g9hp+MWKezqexDQ49dgsHp1U+O/sqlk/GUhuxVlrMQ66bUXkEmHGNQM2OiRZiNQ==
X-Received: by 2002:a50:c38f:: with SMTP id h15mr12724243edf.256.1567124138977;
        Thu, 29 Aug 2019 17:15:38 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r27sm716353edc.17.2019.08.29.17.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:15:38 -0700 (PDT)
Date:   Thu, 29 Aug 2019 17:15:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190829171513.7699dbf3@cakuba.netronome.com>
In-Reply-To: <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
References: <20190829064502.2750303-1-yhs@fb.com>
        <20190829113932.5c058194@cakuba.netronome.com>
        <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 16:13:59 -0700, Brian Vazquez wrote:
> > We need a per-map implementation of the exec side, but roughly maps
> > would do:
> >
> >         LIST_HEAD(deleted);
> >
> >         for entry in map {
> >                 struct map_op_ctx {
> >                         .key    = entry->key,
> >                         .value  = entry->value,
> >                 };
> >
> >                 act = BPF_PROG_RUN(filter, &map_op_ctx);
> >                 if (act & ~ACT_BITS)
> >                         return -EINVAL;
> >
> >                 if (act & DELETE) {
> >                         map_unlink(entry);
> >                         list_add(entry, &deleted);
> >                 }
> >                 if (act & STOP)
> >                         break;
> >         }
> >
> >         synchronize_rcu();
> >
> >         for entry in deleted {
> >                 struct map_op_ctx {
> >                         .key    = entry->key,
> >                         .value  = entry->value,
> >                 };
> >
> >                 BPF_PROG_RUN(dumper, &map_op_ctx);
> >                 map_free(entry);
> >         }
> >  
> Hi Jakub,
> 
> how would that approach support percpu maps?
> 
> I'm thinking of a scenario where you want to do some calculations on
> percpu maps and you are interested on the info on all the cpus not
> just the one that is running the bpf program. Currently on a pcpu map
> the bpf_map_lookup_elem helper only returns the pointer to the data of
> the executing cpu.

Right, we need to have the iteration outside of the bpf program itself,
and pass the element in through the context. That way we can feed each
per cpu entry into the program separately.
