Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA107176B7F
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbgCCCup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:50:45 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46814 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgCCCul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 21:50:41 -0500
Received: by mail-pf1-f193.google.com with SMTP id o24so672099pfp.13;
        Mon, 02 Mar 2020 18:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=emH6vShjtJL1e6QEvQuX+tCS838vKDP2QVpnnXyWpHo=;
        b=c4v5DvD0yKY2nWhic0ttyzgqFGUst3S25+FIWYmn5lRc+HDiNv4iY9aANr8RFjlKGv
         ZqVbENC1BXPXcQuVOGemBKNTaBApyT0V728mzsMpzi1Jv+ildn0QhRbPTDlwZigynZ9T
         tgwcrloGRuunNslNSl0mOBxn1JnxQx0G+rcEafXCeZWg+GwvlhbH6Q84waEWOepmb6Q0
         3JehhnGtqdcdLye1akOZ4h3yFEh/U/CnHqasOw/9M7ZNPJ7j5tGG7mkw3OK1wbQeaFBV
         7rWM17OGy7RjADAj8ytLqzKwf/dXsIq2LSFcmT1K2zhcM0eW7TQVKBEjmVbkvF9MyyBY
         Fxxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=emH6vShjtJL1e6QEvQuX+tCS838vKDP2QVpnnXyWpHo=;
        b=Ytmx7z21VG5TjVazF2s/28qxt9PMA8MOPofku51dNhfSi05+nlk7D+QGspF8IY+Yl9
         yT0DBmbjFtpLh1oHREkrO7Qzp2NvT8adMy81q0l7oo99xHfQT3AVUdcbURQnX92GWufu
         YZ+E3rgSwcicaDgRcMO5nlvWbNiUBGvfb5eLg2aIzde5lgOXajwowzFjZ1b923HvtB3z
         Ir+1EZxxpjjAqLVpbuE6WT2BDSPKcqpBUb5t1rfzK3ixzQ1d3OXo0fAKUVJ9PFy1lXZc
         RixkRiwjsVaB8ixTjk/oQiQ2gLAJ4RvhoeqQoBbfTGtf5AB0J7qpjAHMeIZZ+UJSS+HC
         hW7w==
X-Gm-Message-State: ANhLgQ0XVnrlPJYW8rzOsyzgSkBd2JS6vPB2gyNzVAouXNMNAojkqutx
        jrcD786DFmEB1nzFLqRN1HA=
X-Google-Smtp-Source: ADFU+vuDDDxFvbu3znmlWDmZo6HG7XFrKGJ0xW4dPdBZDMbggXteE2GFN2Kz832EhOWt0mPbhYdcrQ==
X-Received: by 2002:a62:7696:: with SMTP id r144mr1990522pfc.177.1583203840340;
        Mon, 02 Mar 2020 18:50:40 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::7:1db6])
        by smtp.gmail.com with ESMTPSA id e189sm17384137pfa.139.2020.03.02.18.50.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 18:50:39 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:50:37 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce pinnable bpf_link abstraction
Message-ID: <20200303025035.si6agnvywvcgxj3s@ast-mbp>
References: <20200228223948.360936-1-andriin@fb.com>
 <20200228223948.360936-2-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228223948.360936-2-andriin@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 02:39:46PM -0800, Andrii Nakryiko wrote:
>  
> +int bpf_link_new_fd(struct bpf_link *link)
> +{
> +	return anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
> +}
...
> -	tr_fd = anon_inode_getfd("bpf-tracing-prog", &bpf_tracing_prog_fops,
> -				 prog, O_CLOEXEC);
> +	tr_fd = anon_inode_getfd("bpf-tracing-link", &bpf_link_fops,
> +				 &link->link, O_CLOEXEC);
...
> -	tp_fd = anon_inode_getfd("bpf-raw-tracepoint", &bpf_raw_tp_fops, raw_tp,
> -				 O_CLOEXEC);
> +	tp_fd = anon_inode_getfd("bpf-raw-tp-link", &bpf_link_fops,
> +				 &raw_tp->link, O_CLOEXEC);

I don't think different names are strong enough reason to open code it.
I think bpf_link_new_fd() should be used in all cases.
