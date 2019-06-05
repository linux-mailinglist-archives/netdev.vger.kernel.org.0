Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC370358E5
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 10:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFEIqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 04:46:10 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44063 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFEIqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 04:46:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id x47so17011849qtk.11
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 01:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=B0y/WxuAU3yeQ3Aesz+vtVfvhCNtGHIL8s7vHvFgqiA=;
        b=NViDpWtBe7V/aZszKVHDFomL5i8CKwbQmeabb2SU7Z7K8DpFDf08Onw9vBbAnMB6l4
         vSjgSu+hcRBcncirz5PM+u7NHjFLUOF3as2BOUsa9BjbMaR9Qsx5Nj9oFGXypDYy5S4V
         U+ZAMD3OmVhx2T0C0Cx6Ju68JcURQMR7wo8le8seo9rjsR2gBLw+1w/msxPW2HnT3zjb
         yBIfHmrp4pDdhoZokzgcqtAdZpSJ0igazbq3vrFpx2LtvN22zwOxQyfux5A+4QBqT6oC
         a/USnf44VuVwbR0FLTBjW9UC1kRx1Nw1b7QyBnite4vxE+4n7pxUjiiGDogXcQfBss9G
         2Y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=B0y/WxuAU3yeQ3Aesz+vtVfvhCNtGHIL8s7vHvFgqiA=;
        b=qK5Iazk6ErRQ3LxeXlLULqBknINN/22c6h0eZ31LjDXHRmGPZsoQB3WbKrwS269GdM
         kzl+XPfV+VUlo6yzFEZw7l4aBhUZKviQq4d6CKF/f5NB5+3E0XyGkmiNuMwT/ggFlpYU
         2fKsojiesyxeC4aPJoOvRrQHj3xyilZC/cDRekY4P2OwsKsCF9obKJ9MVKanZGCxJLPf
         ek1lTxvSSqaXbwIlYTDCQuYBynTpzLTW3YO0OrSxpaBdlsiseXmtCTrXc7sj2EiDueAT
         NLF70QjqDiRPRxpdm+6PBMMTrtIfnRbfNQV44pM7c96LucITlueRwjfWUNPlbHtcVYyq
         yDEQ==
X-Gm-Message-State: APjAAAWotHHeXAcAqAsJEUK0PWJoDWGCMMPnPwirYQGbdStaHzg9PK+O
        OPDqpmJ6b29GVRtybBzcdnOiuRCd9yfIpBDNoYY=
X-Google-Smtp-Source: APXvYqwtvvVfuQzGWe8VTBI0qVGfwUEQfBrkYkbfSkz635q54Xa9yKgppTRoHNmnymhs6acsdiEgt6BFx4VeUsOphfQ=
X-Received: by 2002:ac8:19ac:: with SMTP id u41mr15768882qtj.46.1559724368023;
 Wed, 05 Jun 2019 01:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190603163852.2535150-1-jonathan.lemon@gmail.com>
 <20190603163852.2535150-2-jonathan.lemon@gmail.com> <20190604184306.362d9d8e@carbon>
 <87399C88-4388-4857-AD77-E98527DEFDA4@gmail.com> <20190604181202.bose7inhbhfgb2rc@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190604181202.bose7inhbhfgb2rc@kafai-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 5 Jun 2019 10:45:56 +0200
Message-ID: <CAJ+HfNiQ-wO+sT_6FHAMHw7eDv-kMNjg0ecUmHa_TKg-gPXCyA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/2] bpf: Allow bpf_map_lookup_elem() on an xskmap
To:     Martin Lau <kafai@fb.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 20:13, Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Jun 04, 2019 at 10:25:23AM -0700, Jonathan Lemon wrote:
> > On 4 Jun 2019, at 9:43, Jesper Dangaard Brouer wrote:
> >
> > > On Mon, 3 Jun 2019 09:38:51 -0700
> > > Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > >> Currently, the AF_XDP code uses a separate map in order to
> > >> determine if an xsk is bound to a queue.  Instead of doing this,
> > >> have bpf_map_lookup_elem() return the queue_id, as a way of
> > >> indicating that there is a valid entry at the map index.
> > >
> > > Just a reminder, that once we choose a return value, there the
> > > queue_id, then it basically becomes UAPI, and we cannot change it.
> >
> > Yes - Alexei initially wanted to return the sk_cookie instead, but
> > that's 64 bits and opens up a whole other can of worms.
> >
> >
> > > Can we somehow use BTF to allow us to extend this later?
> > >
> > > I was also going to point out that, you cannot return a direct pointe=
r
> > > to queue_id, as BPF-prog side can modify this... but Daniel already
> > > pointed this out.
> >
> > So, I see three solutions here (for this and Toke's patchset also,
> > which is encountering the same problem).
> >
> > 1) add a scratch register (Toke's approach)
> > 2) add a PTR_TO_<type>, which has the access checked.  This is the most
> >    flexible approach, but does seem a bit overkill at the moment.
> I think it would be nice and more extensible to have PTR_TO_xxx.
> It could start with the existing PTR_TO_SOCKET
>
> or starting with a new PTR_TO_XDP_SOCK from the beginning is also fine.
>

Doesn't the PTR_TO_SOCKET path involve taking a ref and mandating
sk_release() from the fast path? :-(


Bj=C3=B6rn


> > 3) add another helper function, say, bpf_map_elem_present() which just
> >    returns a boolean value indicating whether there is a valid map entr=
y
> >    or not.
> >
> > I was starting to do 2), but wanted to get some more feedback first.
> > --
> > Jonathan
