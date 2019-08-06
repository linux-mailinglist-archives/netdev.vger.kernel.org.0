Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A033882977
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 04:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731356AbfHFCAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 22:00:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46782 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbfHFCAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 22:00:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id r4so61619522qkm.13
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 19:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0X1LF4rr+yNf0Lo3MUAY5cv4lTkUOCR3KTd7rS7pRk0=;
        b=GoN1LmXwBLICF1IHJJtYC7awSwJI39yfOT+bRUwlByWmLM03eWaCAPAkgU3NtIqnZ5
         MvJ52m08LJVRTiw0FS0mF9eSlny8cDSYz9rm1QA3q4mwAyiXOgM9fIyiJZQmy7gsmKzX
         ura5SlG1JL9V+Xi/LDCjU+dPm3eZwRc6iWwoZ/0Os3NzD4pvVdjsb5Xed+xm5wyUrDiE
         J6P3Fg7Tn/d7x0CkxzU38NMsGcBijIbi8ceh92VM3D8YZcBpd8ZJY67D6qHVGTrZYXoc
         beVhF6mKO3dWLxSEKihFMhdFZicOR1/2NjAmvHpBQ82X3edkcdcuNAtwYDwj0XAuRXqe
         zhSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0X1LF4rr+yNf0Lo3MUAY5cv4lTkUOCR3KTd7rS7pRk0=;
        b=pXez5ConQ1SjblbjGZXxvKj2Vw5F9HitaoqKQi4q6acjYvC4tzCR4fXFHTaWY6kbrK
         WZtDeuZFQpskuxCcwyJYIJ0mRnhcKAZhifpK5QnA+yYv4od+VeHwncMdD/XPmPsYKuMU
         HFWWbUvFtTDn5eJjKZwGtFHNaiIZF7s8XzomYcgBP/shvs8lHJSuQr7XUOi43vBgC7ju
         VMKJPFNoGjGt/4juhm55O6XjSdWOdWOmqJaJTIR9A1s7ci1+2SG0Lm3OAc9n4oQ1zZnU
         GlV5vWaaAMdqFv3lctGAGGPpv+CBO5pTOO36bYt85cGIjupmM/Bdl1teNMydfaSfyXBX
         Bx6A==
X-Gm-Message-State: APjAAAWL2fXjM6J6UFTSfLJL5frrbXShAhFh6hFmY1b0WsVGea00czGW
        xxNo0xK+nggmkpZKZfqsQYO4Cg==
X-Google-Smtp-Source: APXvYqxxMUG7k2pYgsAHJVICVpGdZ/cTB2WstM1HyoR1+wR3wFcqfg/cNQ/egOtgpOC9fwr7n64I9w==
X-Received: by 2002:a05:620a:10b2:: with SMTP id h18mr1178053qkk.14.1565056806499;
        Mon, 05 Aug 2019 19:00:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v7sm39394822qte.86.2019.08.05.19.00.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 19:00:06 -0700 (PDT)
Date:   Mon, 5 Aug 2019 18:59:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v2] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190805185940.786af579@cakuba.netronome.com>
In-Reply-To: <20190806010702.3303-1-peter@lekensteyn.nl>
References: <20190806010702.3303-1-peter@lekensteyn.nl>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Aug 2019 02:07:02 +0100, Peter Wu wrote:
> /proc/config has never existed as far as I can see, but /proc/config.gz
> is present on Arch Linux. Execute an external gunzip program to avoid
> linking to zlib and rework the option scanning code since a pipe is not
> seekable. This also fixes a file handle leak on some error paths.

Please post the fix for the handle leak separately against the bpf tree.

> Fixes: 4567b983f78c ("tools: bpftool: add probes for kernel configuration options")

Other than the leak I'm not sure this qualifies as a bug.
Reading config.gz was consciously left to be implemented later.

> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  v2: fix style (reorder vars as reverse xmas tree, rename function,
>      braces), fallback to /proc/config.gz if uname() fails.
> 
> Hi,
> 
> Although Stanislav and Jakub suggested to use zlib in v1, I have not
> implemented that yet since the current patch is quite minimal.
> 
> Using zlib instead of executing an external gzip program would like add
> another 100-150 lines. It likely requires a bigger rewrite to avoid
> getline() assuming that no temporary file is used for the uncompressed
> config. If zlib is desired, I would suggest doing it in another patch.
> 
> Thoughts?

I'd rather avoid the fork and pipe. We already implicitly link against
zlib for libelf etc.
