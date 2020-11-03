Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183B62A3C41
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 06:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgKCFyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 00:54:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbgKCFyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 00:54:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604382874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2fl5tjNFV3PW85DHxc10S9tbrJNnWhGh5jiU6vVkExg=;
        b=GPb/l063k4FjxDoqemPrdmqX78Kf48iesdlj3sS9DSwXwaq8cSqgHzNnnuXmiNyzVzfab0
        40BsQuIWJedGi5f5UpIHe10w8In8eHcGRP+AS3wo+ev6+PUPhZ1nrIRAEVsaOrL7XvjZ9A
        eRR6m+4UXLi0qCyBiW1ROuA4uET+08Q=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-5N0dJhZ3NsOQvwEH6xYwTg-1; Tue, 03 Nov 2020 00:54:32 -0500
X-MC-Unique: 5N0dJhZ3NsOQvwEH6xYwTg-1
Received: by mail-pl1-f198.google.com with SMTP id q4so9996265plr.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 21:54:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2fl5tjNFV3PW85DHxc10S9tbrJNnWhGh5jiU6vVkExg=;
        b=e6JTV+GOgQWuadgzroo+B7FXX7VDXbCHxkpqI8+XxPMO+TGEKMiMUYktLEkXBLuCyh
         YNu3G1fonvlEgGu2lLQqHxPbmuaoHzLMYT3+SjUo9ItIY7O9/+9tgYBQu2GrsTsjYZFv
         g8hceD9V+X2OfJ0Hc+Sq+Gec6GbgPsoLyPJj+S75+j9As2NRy+9uqbdAJTdETOBup+Zx
         V3jk8cTVN9vebnnnLF8pTeREZycfqLR8dqBfhweHSWKtk/gNnDDmjqAi/kpBTzMuPLwC
         aQZHHI3iJb71ZgOSBPiok0JDDT7g/AiHQsoJ9l4tUPsJXiiBFnedPdzPU+s8WPJxDK1o
         RS3g==
X-Gm-Message-State: AOAM531JM8dk17Xa2sNLBbpplf9O8p2O0xT+WJMB9Q3d9mY29g5RCXLa
        oieBwdbaiJx4LM0xD83TO5aY9gAe6qH8j58Pz1nIpObXvI2BBvuzOPxYq4geq8A0VErFHEDJcHM
        trzF0U93fmdsT0XM=
X-Received: by 2002:a63:6c09:: with SMTP id h9mr15569131pgc.214.1604382871467;
        Mon, 02 Nov 2020 21:54:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3t6HhBjRzKu/CyOzq+iHNPZNWP9i1v2iHNlC1M+VhSqvFWOW3I74UVfYwkU0MAgpW/+jVWw==
X-Received: by 2002:a63:6c09:: with SMTP id h9mr15569117pgc.214.1604382871288;
        Mon, 02 Nov 2020 21:54:31 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 136sm3905540pfb.152.2020.11.02.21.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 21:54:30 -0800 (PST)
Date:   Tue, 3 Nov 2020 13:54:19 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 1/5] configure: add check_libbpf() for
 later libbpf support
Message-ID: <20201103055419.GI2408@dhcp-12-153.nay.redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-2-haliu@redhat.com>
 <78c5df29-bf06-0b60-d914-bdab3d65b198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78c5df29-bf06-0b60-d914-bdab3d65b198@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 08:37:37AM -0700, David Ahern wrote:
> On 10/29/20 9:11 AM, Hangbin Liu wrote:
> > This patch adds a check to see if we support libbpf. By default the
> > system libbpf will be used, but static linking against a custom libbpf
> > version can be achieved by passing LIBBPF_DIR to configure. FORCE_LIBBPF
> > can be set to force configure to abort if no suitable libbpf is found,
> > which is useful for automatic packaging that wants to enforce the
> > dependency.
> > 
> 
> Add an option to force libbpf off and use of the legacy code. i.e, yes
> it is installed, but don't use it.
> 
> configure script really needs a usage to dump options like disabling libbpf.
> 

Shouldn't we use libbpf by default if system support? The same like libmnl.
There is no options to force libnml off.

Thanks
Hangbin

