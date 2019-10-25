Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3FCE5260
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505916AbfJYRc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 13:32:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32768 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391596AbfJYRc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 13:32:26 -0400
Received: by mail-pg1-f195.google.com with SMTP id u23so1989109pgo.0
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 10:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=24Vup2W3++5vYZGl1stBcX2iZStl3z6uK5jR1VdjI8E=;
        b=fHBV3ImxSnzLptFNGwEmvsnR8b/+avimMH08zIkzvjBsRW7E4FZZcEyHcgRRPWeOp4
         6WqX9RBJI+Er8rFQn2p7IfXd/H6HF9nAm44OvmZbpbhbFWBfrL20xV4ZhX8mK+PkOuvn
         McWHMxbf6lcuPvVOYD6v7pBwHlNxA1c7WRXDTskdqrrtCjegZ+UWCD59mLj0RFE5KIsl
         nmgrTnDuoAnqjl/coDu3NZr8DFGFy65f/ZrIMWKB9v7QZgc2ot/iOUDuNosiP7h6tqWa
         880/gtibEc48OmJRXcLYEtnUs7oSeHDSuyEjxn5WF+oFupPqA4/S/RoGSJQXCvno1L/N
         FE3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=24Vup2W3++5vYZGl1stBcX2iZStl3z6uK5jR1VdjI8E=;
        b=Sr9IyGofXgkiNZY6bmVzEuhyAq/n2i5gFni1/0t4Xgn/4c0qiYXvrp/Fugx8+gC/Ks
         +fPmpyDt4s4qjjwG4HtviLPvnhAOcC+J6UuDcEOKrgrCDsmxp/aHnUVIsSbwtlC/5IbS
         3TeNuLAopCbQPsRDqoNPh2mXFIK+q9I3CAGC+5Nb3O8wqzfTha6VH2GHog120EA+yy7r
         Q0A8oVXaTwFvCH/3gbygpcMWg24PYf+ht1m2/eITNfweaaiwx34BCXyj62qUz2x+1O8r
         Aali3bRRgg/26E+t9yTV3tEI2V2ndSBk2VMtvusmxxdYLLGApPjoZ+ErjQWjoMDRvXVD
         hGtg==
X-Gm-Message-State: APjAAAWXZ/IG5RYPD//mLS0hZBrDQLHI4aaRxHqsn6KOUDT1fyOd0t9s
        7DnkY1i18jtGz/G2XXTnJaiQlg==
X-Google-Smtp-Source: APXvYqzWYjBkO+Ucbe2JGcCequ4PmeDRkTO4YebyEoa2L0kXlqC3baEh2R4XeFtVNYid9hfqjgGxlw==
X-Received: by 2002:a65:6781:: with SMTP id e1mr5881573pgr.173.1572024745622;
        Fri, 25 Oct 2019 10:32:25 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id o185sm3054384pfg.136.2019.10.25.10.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 10:32:25 -0700 (PDT)
Date:   Fri, 25 Oct 2019 10:32:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCHv2] bpftool: Try to read btf as raw data if elf read
 fails
Message-ID: <20191025103220.5df729a0@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAEf4BzY5o3rR3HXBPORm4NkX4SzDGTQ24p+TMmY8hxyb9+dN2g@mail.gmail.com>
References: <20191024132341.8943-1-jolsa@kernel.org>
        <20191024105414.65f7e323@cakuba.hsd1.ca.comcast.net>
        <aeb566cd-42a7-9b3a-d495-c71cdca08b86@fb.com>
        <20191025093116.67756660@cakuba.hsd1.ca.comcast.net>
        <CAEf4BzY5o3rR3HXBPORm4NkX4SzDGTQ24p+TMmY8hxyb9+dN2g@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Oct 2019 09:53:07 -0700, Andrii Nakryiko wrote:
> On Fri, Oct 25, 2019 at 9:31 AM Jakub Kicinski wrote:
> > On Fri, 25 Oct 2019 05:01:17 +0000, Andrii Nakryiko wrote:  
> > > >> +static bool is_btf_raw(const char *file)
> > > >> +{
> > > >> +  __u16 magic = 0;
> > > >> +  int fd;
> > > >> +
> > > >> +  fd = open(file, O_RDONLY);
> > > >> +  if (fd < 0)
> > > >> +          return false;
> > > >> +
> > > >> +  read(fd, &magic, sizeof(magic));
> > > >> +  close(fd);
> > > >> +  return magic == BTF_MAGIC;  
> > > >
> > > > Isn't it suspicious to read() 2 bytes into an u16 and compare to a
> > > > constant like endianness doesn't matter? Quick grep doesn't reveal
> > > > BTF_MAGIC being endian-aware..  
> > >
> > > Right now we support only loading BTF in native endianness, so I think
> > > this should do. If we ever add ability to load non-native endianness,
> > > then we'll have to adjust this.  
> >
> > This doesn't do native endianness, this does LE-only. It will not work
> > on BE machines.  
> 
> How is this LE-only? You have 2 first bytes in BE-encoding on BE
> machines and in LE-encoding on LE machines. You read those two bytes
> as is into u16, then do comparison to u16. Given all of that is
> supposed to be in native encoding, this will work. What am I missing?

I see so the on-disk format depends on the endianness of the writer?
You write it broken and therefore you can also read it broken.
And cross compilation etc. is, I presume, on the TODO list?

Got it.
