Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9603DD779
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhHBNnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:43:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233742AbhHBNne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:43:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627911804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=10E0KbDcNF3xBbVH8wjtzXO09PrLbKBJPWy5SH+LtDM=;
        b=WsBx5YkfjPkfswURjuiUcghF3MG0w7gtyysYutwqughefwtP6HIRx4pCsKLpY7IAnsuRe5
        xewJWmIytvbZ+i1YjY3cRLlFd6QNk06+pqyTPbQ4/8qa2mx3K2q0dGcb8z5td2i3I93aDd
        Hw3ROlt9gbRpK1CoUQASbTCRWkJHcQQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-YntAedaKPuWiW5G9If5R5Q-1; Mon, 02 Aug 2021 09:43:23 -0400
X-MC-Unique: YntAedaKPuWiW5G9If5R5Q-1
Received: by mail-wm1-f72.google.com with SMTP id o67-20020a1ca5460000b0290223be6fd23dso2894488wme.1
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 06:43:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=10E0KbDcNF3xBbVH8wjtzXO09PrLbKBJPWy5SH+LtDM=;
        b=ALKVxvG2XhVWuXcKjQE5fppnwOAEjig75MCYAYCtYg6EwVPV00UXqadj+aUJp9GL2J
         54MjSMBVNn3HFBgyaGk7rBp6HMUOsw15WyC1JDAZiWoDkgRJSMJ1ariIgjfyNYNRhRMF
         X1wY9uc6YO4SzR4hq0l/Xu4eXxl61Q8yK7euOCYelttBicBFSHCGLVGGAsfdgQKMAKUy
         Q+b8VPqSCS12dlxcztMyWpoROQe+9wKzqOKG1fIMYUHcbawf/aVkoM4PdHl10sSXAcP9
         knznU8/kWvIlKwDy+FcdQ83gKCXIr9vAAWPWLZbJHGScAua2A/zHoNv9ZBOpuzc2mxL7
         E1gw==
X-Gm-Message-State: AOAM532htxAQHaEwKvPzifpHPBn37ohl+KEnmL4ysLXte2+Wii2VRs0Q
        xFQz2UtWMdFU643d5lGXfSVwsxuXUnK1CKd71I/u6hNzyuYVc+cLvqnBppOW9FZhkL38xHgEVT7
        snTsELHgKzoNu5CSN
X-Received: by 2002:a5d:6d8c:: with SMTP id l12mr7607050wrs.290.1627911802418;
        Mon, 02 Aug 2021 06:43:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqlT6pmqx3O86acE7/FPgrql7S7TmLq+6UU6RuIU5lnEOJUjY+xHnA5ouKs2ESuJaT7LzhCQ==
X-Received: by 2002:a5d:6d8c:: with SMTP id l12mr7607042wrs.290.1627911802287;
        Mon, 02 Aug 2021 06:43:22 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h11sm6835219wmq.34.2021.08.02.06.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:43:21 -0700 (PDT)
Date:   Mon, 2 Aug 2021 15:43:20 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to find out name or id of newly created interface
Message-ID: <20210802134320.GB3756@pc-32.home>
References: <20210731203054.72mw3rbgcjuqbf4j@pali>
 <20210802100238.GA3756@pc-32.home>
 <20210802105825.td57b5rd3d6xfxfo@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210802105825.td57b5rd3d6xfxfo@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 12:58:25PM +0200, Pali Rohár wrote:
> On Monday 02 August 2021 12:02:38 Guillaume Nault wrote:
> > 
> > So the proper solution is to implement NLM_F_ECHO support for
> > RTM_NEWLINK messages (RTM_NEWROUTE is an example of netlink handler
> > that supports NLM_F_ECHO, see rtmsg_fib()).
> 
> Do you know if there is some workaround / other solution which can be
> used by userspace applications now? And also with stable kernels (which
> obviously do not receive this new NLM_F_ECHO support for RTM_NEWLINK)?

I unfortunately can't think of any clean solution. It might be possible
to create the new interface with attributes very unlikely to be used by
external programs and retrieve the interface name and id by monitoring
link creation messages (like 'ip monitor' does). But at this point it's
probably easier to just set the interface name and retry with a
different name every time it conflicted with an existing device.

Maybe someone else could propose less hacky solutions, but I really
can't think of anything else apart from implementing NLM_F_ECHO.

