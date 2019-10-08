Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6A8CF0CC
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 04:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbfJHCXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 22:23:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38556 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729212AbfJHCXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 22:23:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id h195so9867440pfe.5
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 19:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=+SSvTX+QixrK9T0VspY303Q2XI9nw32esh6WHH9QsbY=;
        b=mH+C7BS4j+h83TR/36+HsnUASf8nQZLKzV9t8bANu+lz3unOLrDXms8wbfNmiaUeC6
         XpiqxUfHipZs1eg6Jzdlp/Mk8kPW1dV0IWi+YYaf6rZsg4/PGFtghYSKCNPnlqqQvNnc
         NaC8cMx8yw0kjjLKCZ3b9z7JmciNclbtgDnWLbnwhemDUqOUOBF58C3HSbbRyRn9MMdR
         ADkD2zt5wa4Av29lRQO+3Q4oYjseK2gcygUGCHP1QJ8Du8unn44fERwn4wv082cVTFjN
         65QmvtqDrsNVE0qnl6lnC3s5yUmy8a9qF0/3TMsTlz4CqcsII+sY9fAsNXvfpgxn5CZu
         hhNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=+SSvTX+QixrK9T0VspY303Q2XI9nw32esh6WHH9QsbY=;
        b=CCNFbBgTynftz6qoxGmd8ifSfgm+a5b1A6UMLP6VPzAzlJCV9boFIKXJtMvpIRsMzv
         dWJqnI9goGac1pyYgViEaIt4/cPflQkGxjApvWFzFYL0jgGxs0AFy5hyLPDTCNdTuQqt
         sJ/qPZPWqkG/U/V78oSkU1Qk1hN8dI0oXFjc5oq8j4+/lY/RlW97L/IXod8GTedEEuXx
         sKxv7T5XCP4yVGDnKqFp4FPGdYa6EZG34VKeUbxD3Oog0gXQBMqq7wog7op1ztJpsUPR
         EEMas6F+UltV5rdw+l7VSxCCypTM0NpVH/bef/FrvWyAEnRFprkbPWqD3gAK2/VHhbl3
         eYow==
X-Gm-Message-State: APjAAAULlfjcQBL0YBXWrgJkxL/Sz+iFt63oljfBHigyXNHfu5oGX1Iw
        wrChOaqd1AWeIMftrtTEVQEiCw==
X-Google-Smtp-Source: APXvYqxZmmyeqztLzWaYDLbZRLY9AIp2zymckuGJgUrFrsa+dGmrJSn6jUleJhbh7Q+PsjFa3GdeBw==
X-Received: by 2002:a05:6a00:8c:: with SMTP id c12mr35295871pfj.200.1570501418511;
        Mon, 07 Oct 2019 19:23:38 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id i190sm8368842pgc.93.2019.10.07.19.23.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 19:23:38 -0700 (PDT)
Date:   Mon, 7 Oct 2019 19:23:28 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] bpftool: fix bpftool build by switching to
 bpf_object__open_file()
Message-ID: <20191007192328.2d89f63e@cakuba.netronome.com>
In-Reply-To: <CAADnVQ+XrFG25PaT_859Vz+9HmenKm4F1y4m8F-KauKkBCZp7Q@mail.gmail.com>
References: <20191007225604.2006146-1-andriin@fb.com>
        <20191007185932.24d00391@cakuba.netronome.com>
        <CAADnVQ+XrFG25PaT_859Vz+9HmenKm4F1y4m8F-KauKkBCZp7Q@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 19:16:45 -0700, Alexei Starovoitov wrote:
> On Mon, Oct 7, 2019 at 7:00 PM Jakub Kicinski wrote:
> > On Mon, 7 Oct 2019 15:56:04 -0700, Andrii Nakryiko wrote:  
> > > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > > index 43fdbbfe41bb..27da96a797ab 100644
> > > --- a/tools/bpf/bpftool/prog.c
> > > +++ b/tools/bpf/bpftool/prog.c
> > > @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
> > >  static int load_with_options(int argc, char **argv, bool first_prog_only)
> > >  {
> > >       struct bpf_object_load_attr load_attr = { 0 };
> > > -     struct bpf_object_open_attr open_attr = {
> > > -             .prog_type = BPF_PROG_TYPE_UNSPEC,
> > > -     };
> > > +     enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
> > >       enum bpf_attach_type expected_attach_type;
> > >       struct map_replace *map_replace = NULL;
> > >       struct bpf_program *prog = NULL, *pos;  
> >
> > Please maintain reverse xmas tree..  
> 
> There are exceptions. I don't think it's worth doing everywhere.

Rule #0 stick to the existing code style.

"Previous line of code declaring this variable in a different way was
in this place" is a really weak argument and the only one which can be
made here...
