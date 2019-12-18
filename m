Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA6E123EA1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 05:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfLREkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 23:40:47 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41599 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLREkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 23:40:46 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so489442pfw.8;
        Tue, 17 Dec 2019 20:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GrKfPHWlzDEJvr5AEBo/fYlRUfRELTxwLkCTPqqmL5k=;
        b=XDX7OygWR3o/AaSRFcMaG6KBpndn7POmPbXa0ahnXYjdD1xRPgLVAHFsUVHeV4E3Pn
         rcWCicvO3NFdRtdGEzchqV7808Mpl148Jls3F2Xte9cjATYJeh60kZ9YsiDTf9hjp8+p
         ATm3f+mEXaYhz7gqfYxL7ybnsncdHz7WICz5Yjm2XAKPRuEK2Owqge+1/7Q6Y/ijXhbz
         JNCNv6+z3nSI1J5sYDn4cL7fUpP05fVkQPeM40fxXy+15VByQORdRoluMEqlffXYKnG6
         lYckpOKKMl7YZueSMsVqK1lSoLIGRL1LU6smOWAn+f+rCanWu20zfE6Kg931oxO0TEkU
         8Dvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GrKfPHWlzDEJvr5AEBo/fYlRUfRELTxwLkCTPqqmL5k=;
        b=dGzM8DW+xk6N3a1nxsUl2D7MMDB+goNMQ4VXCT8Oqmw3R728V6amsmkmzf67JFgXT0
         PGW1zkZX29ToP+CvkoqxPwsHVSEo9g3Af7Ttz6CxWXJYFoi2ahvqzKGMcnO9JjBYUnSB
         Nax5Lo2gaOMtzMZjrF0W3OgNXG4zpv4TEzoY0MCms0VoeqK2VH7D59QypKw81Mk19CWl
         ckx7P311QAsj2k3AEEELgEESEWUp4/XS0MlzqPUQVvnRb8ANa7lZdNYzQ1TPQFU//1tG
         12/eCH4AFKUhoMal2+hJKk9FOEeNRMc6nDoTY4BN9uPCqIRxjmM+sijxPI4+XAiL+6+3
         57hw==
X-Gm-Message-State: APjAAAWaP/vMBPl8GzS+KLzxlSLqTFR9lMk/F5chV7z8DcUgY1ySvBXW
        UqI0dgimepTL4KPfMCJLT/U=
X-Google-Smtp-Source: APXvYqyyzxV7dEGa56Cg6K8AAx/tV3UCABXTF2we4KGAO9kAqp1sqWnzMe0COs+F87LFNJAdPquDyQ==
X-Received: by 2002:a63:1402:: with SMTP id u2mr701402pgl.224.1576644045967;
        Tue, 17 Dec 2019 20:40:45 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:250d:e71d:5a0a:9afe])
        by smtp.gmail.com with ESMTPSA id k60sm633881pjh.22.2019.12.17.20.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 20:40:45 -0800 (PST)
Date:   Wed, 18 Dec 2019 13:40:43 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Andrey Zhizhikin <andrey.z@gmail.com>, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, pmladek@suse.com,
        wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] tools lib api fs: fix gcc9 compilation error
Message-ID: <20191218044043.GB88635@google.com>
References: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
 <20191218031019.GB419@tigerII.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218031019.GB419@tigerII.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (19/12/18 12:10), Sergey Senozhatsky wrote:
> On (19/12/11 08:01), Andrey Zhizhikin wrote:
> [..]
> > @@ -210,6 +210,7 @@ static bool fs__env_override(struct fs *fs)
> >  	size_t name_len = strlen(fs->name);
> >  	/* name + "_PATH" + '\0' */
> >  	char upper_name[name_len + 5 + 1];
> > +
> >  	memcpy(upper_name, fs->name, name_len);
> >  	mem_toupper(upper_name, name_len);
> >  	strcpy(&upper_name[name_len], "_PATH");
> > @@ -219,7 +220,8 @@ static bool fs__env_override(struct fs *fs)
> >  		return false;
> >  
> >  	fs->found = true;
> > -	strncpy(fs->path, override_path, sizeof(fs->path));
> > +	strncpy(fs->path, override_path, sizeof(fs->path) - 1);
> > +	fs->path[sizeof(fs->path) - 1] = '\0';
> 
> I think the trend these days is to prefer stracpy/strscpy over
> strcpy/strlcpy/strncpy.

Scratch that. This is user-space, I should pay more attention.

	-ss
