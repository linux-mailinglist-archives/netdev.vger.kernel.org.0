Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D6A8846A
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfHIVKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:10:00 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43664 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfHIVKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 17:10:00 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so16568197qto.10
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 14:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=4EtwKrwy6tYuTQ3DE00lcICHQb8+MzmfXSYUX83rtAY=;
        b=UIUOSdsoQ5ZOZYPtbeLkuZ9ZDXpxD4HLIcuTZKSRSKll9iWoS0ro7NTVYZX6MIUni7
         08Koatj4f6SaSPRWdHVNUVFOXjZ5fm4+PNdibOxJAvsSdHCHHeHEMuoYdQMM/yGq/L0D
         g5h8dRkDo4BDrghusQCFBIKgJfYphGuDLKZ+UQ/LzfvXcWpLKrKU97m8BzD3p8+b97gp
         9g7dqWhRuOac+CU2ZBFvTBjxTJGQ5h7c6hZKoTaQH6QBgKnreKRMlYUiB4BOU70+Kn0Q
         8JSu5k4dkvsr0cUimOR7xOsXuJDR8HC9iMvFSVVppe7oFLcij9d1wPpDmfYGaEIF5RiF
         CYyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=4EtwKrwy6tYuTQ3DE00lcICHQb8+MzmfXSYUX83rtAY=;
        b=Wai5z5QI+ksJbG4az4ZQZQnE/JZJml8Mrov9CH9Ke0fp3/XdwWel61rmCLRp7/TjCZ
         LATerlOv6HfJTOJurq7XqyiIA3pPq3s0+xzTLmsqxMaAKfACg2bfytCa8TAfhAoM/uts
         PU/8rOaq3Jvt3yrcOQL1xndh0r4dORbNimxBK/RIB3pvMhZciLnJXYxQ/mgiokRPNnar
         KPsBR5yeDuZaJl82o772Eb79RjwbQhmJCpmYP9EO8+x2m6nucZIvNnXj8ur37n89qvRf
         4KzwMdWWsbNwGfkReiYECsALiBvJy9rTNMG7ltQdkeDaeWnL5tT0Ywicz3h87K5rhN0Z
         WSCw==
X-Gm-Message-State: APjAAAVuZm+y3WBm0aWfa9Xys/16UcuOgT0nDRArUh7//Qwl3K0mX4iZ
        bJ8icCZK/g98RL3EGwpuxkhjug==
X-Google-Smtp-Source: APXvYqybBg5M1CxCpsiP+31qcvII0mbx6B9fgWwq0FwMf96wSIk4HL2vFjWxLAVVyL9zW5BC0xEvDQ==
X-Received: by 2002:ac8:414b:: with SMTP id e11mr11981677qtm.174.1565384999701;
        Fri, 09 Aug 2019 14:09:59 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w1sm725410qte.36.2019.08.09.14.09.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 14:09:59 -0700 (PDT)
Date:   Fri, 9 Aug 2019 14:09:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Peter Wu <peter@lekensteyn.nl>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v3] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190809140956.24369b00@cakuba.netronome.com>
In-Reply-To: <20190809153210.GD2820@mini-arch>
References: <20190809003911.7852-1-peter@lekensteyn.nl>
        <20190809153210.GD2820@mini-arch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Aug 2019 08:32:10 -0700, Stanislav Fomichev wrote:
> On 08/09, Peter Wu wrote:
> > /proc/config has never existed as far as I can see, but /proc/config.gz
> > is present on Arch Linux. Add support for decompressing config.gz using
> > zlib which is a mandatory dependency of libelf. Replace existing stdio
> > functions with gzFile operations since the latter transparently handles
> > uncompressed and gzip-compressed files.
> > 
> > Cc: Quentin Monnet <quentin.monnet@netronome.com>
> > Signed-off-by: Peter Wu <peter@lekensteyn.nl>

Thanks for the patch, looks good to me now!

> >  tools/bpf/bpftool/Makefile  |   2 +-
> >  tools/bpf/bpftool/feature.c | 105 ++++++++++++++++++------------------
> >  2 files changed, 54 insertions(+), 53 deletions(-)
> > 
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index a7afea4dec47..078bd0dcfba5 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
> > @@ -52,7 +52,7 @@ ifneq ($(EXTRA_LDFLAGS),)
> >  LDFLAGS += $(EXTRA_LDFLAGS)
> >  endif
> >  
> > -LIBS = -lelf $(LIBBPF)
> > +LIBS = -lelf -lz $(LIBBPF)  
> You're saying in the commit description that bpftool already links
> against -lz (via -lelf), but then explicitly add -lz here, why?

It probably won't hurt to enable the zlib test:

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 078bd0dcfba5..8176632e519c 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -58,8 +58,8 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray
-FEATURE_DISPLAY = libbfd disassembler-four-args
+FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
+FEATURE_DISPLAY = libbfd disassembler-four-args zlib
 
 check_feat := 1
 NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall

And then we can test for it the way libbpf tests for elf:

all: zdep $(OUTPUT)bpftool

PHONY += zdep

zdep:
	@if [ "$(feature-zlib)" != "1" ]; then echo "No zlib found"; exit 1 ; fi

Or maybe just $(error ...), Stan what's your preference here? 
We don't have a precedent for hard tests of features in bpftool.
