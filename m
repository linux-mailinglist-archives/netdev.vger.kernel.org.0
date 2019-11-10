Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3AF6ACC
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfKJSfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:35:00 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41117 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfKJSe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 13:34:59 -0500
Received: by mail-qt1-f195.google.com with SMTP id o3so13190891qtj.8;
        Sun, 10 Nov 2019 10:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zm/3EwpJ2HpVRswz/zK4pzpGrD4TVxZKrD3+K9GZ4iY=;
        b=qyoFa2xMNU4aHM0tqRiizc+I4yFfG2qUhJY8hFVBCtjfRziHa1sqeNW4k37xkdowsD
         HSioVdyS2U6Y+bp97yrVMBZtO/zUlPGNAFzos+0RyfIOpopNWm0wd0/h2MibF13RTzbT
         xm0WOtxnZhUXRntduQDq3o2bdFj2QXCZK+bXehhUOMLceeXXhzOfGWqHdDlP6oTabXdE
         be6DFgNyqnvwVNdre13ZLwDxQJ2Qef97qQXP2gA0vdy7c/wCaa/hdlY14EfYSNPVQ5Mq
         02zcGRuLwN7uWT3kLe6JeosMm9J5xIuFHmSwFomCh9pQmupQ3mj0LFkMxyQV/NiK/qRv
         ws5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zm/3EwpJ2HpVRswz/zK4pzpGrD4TVxZKrD3+K9GZ4iY=;
        b=bS1MR2igA/PI3jXQFBfKcij3vRtFjpFVspnKAGEuaYBBS1opEFUaG7LTizSxPudtEK
         FiIWHAbmLTVSUwL5/yE9LYQdyoFpAdI0cOtzjqcdPo/7sO7nVyX//Zz3F5kojU7JKrmw
         45wK7bDXj1mECoJyrCDiPuy+eojb+u2b8TiNJKDhscIscnyYyngaeXG/PTVjQtekZjbO
         KOLvYhqtItq9fB8l0iRbYZwrK5j1ZnRvrYNPME/0q2wO8yTpsIQEcMrBUCsl3pR/Jcs3
         g3yXCvvs0K+O5uYHpgvUw/oXeNTkC4+OJ/1WAZblRPFUeaM6GlR+4Dukd6KaAkWxpp2X
         J80g==
X-Gm-Message-State: APjAAAXOu3fLBRVKnvnQ2utb6wGQb4ttgJa7Dk4g/JPp5AcTSRqJoO8Z
        WH4DsXbIIfDAB7eC8F95zF5+fs2yAmL+1I5zPpM=
X-Google-Smtp-Source: APXvYqxarf+BC2SmHAOJYwNrNQEO7/OrZnjZYBOKjwnb1bDVNyRuTbkekrIcgN23y7HGVYvqMYxtEFMSNZhCChe82OQ=
X-Received: by 2002:ac8:30f4:: with SMTP id w49mr22735294qta.35.1573410898868;
 Sun, 10 Nov 2019 10:34:58 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com> <90122A08-8AF0-4B22-886F-C863D96D119E@gmail.com>
In-Reply-To: <90122A08-8AF0-4B22-886F-C863D96D119E@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Sun, 10 Nov 2019 10:34:20 -0800
Message-ID: <CALDO+SaLAQaMixtzA2VEq4a08KJnm8M5hiyC0P0xmPaMjdq05w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] libbpf: support XDP_SHARED_UMEM with
 external XDP program
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 2:56 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
>
>
> On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:
>
> > Add support in libbpf to create multiple sockets that share a single
> > umem. Note that an external XDP program need to be supplied that
> > routes the incoming traffic to the desired sockets. So you need to
> > supply the libbpf_flag XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load
> > your own XDP program.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Tested-by: William Tu <u9012063@gmail.com>
