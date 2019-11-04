Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253F0EE4A2
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 17:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbfKDQ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 11:27:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34351 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKDQ1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 11:27:44 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so806353pff.1
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 08:27:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rPUO42a0S3qiVkdlSdNuhnVHyjN6QIDCxl8B4rNZLgI=;
        b=n0+318lLHy8i3t10068qRgumZVCJ+swc3np2Z43/peuQwAxnvNugpJnAYOcW7nC0sc
         VzIXMzyQqMVHXffiSObiGlkq59eyq2/+rypf74KGiQKxg+aW7eOTTDdN8yJk3v82HJuL
         F6Kr/S5vaTpoEfcbNhVFGca8SGgEw3ucZpCsshDbNPButxatb27tT0XrDcVWEO1GIAi6
         dya3TMadvhLEyKMbXyxs7XTqdfuWaMDnMf4gi/S+eHQqw4h1iDjscAjmUPevnTyey87x
         a1l+BgewG+3exelrG9QSNlbV3ZeVZ/Y8A6CPUBKmJwDe4MS2Vz7Ff9KbfmVxe3hQ+KVg
         3XVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rPUO42a0S3qiVkdlSdNuhnVHyjN6QIDCxl8B4rNZLgI=;
        b=pmVp2/3CGSSejFfQygGhlrCjzBZCVEewIc8POTaoXmvvlWw216m1TDP8nvK3Ul7Wt7
         Uf/G9TrBB3IM3SZELUC8o4Xgs92q3deB2x38/dQC6doi7v4scXJryWGtz8KrP1RFNqLP
         oYkZgvrl0tHWWWPq03LBjzdmya8a+6iw5RejuHqrgg98+EWD/jNG1YnOAJSCo5TOr5mu
         iEjPcejdMnLZ2967EsSG70CbHRO0RaHS5OQg5xVdHBw59lXCJfrEouHcGVrkkNvilOCV
         G0ELC40MURh5MHp0VTpZU0ggV8REK+i2hWOFVmisDazB0YzOUXAGpR1XT6MdwoviAY0T
         6l+A==
X-Gm-Message-State: APjAAAVSoTK1ohBoDLF2pb9gS1MlQ9c511xJEbiaFEd0aT22zpw7zkac
        tPZ0fFLhPivwZZGpZkkuyuzgcw==
X-Google-Smtp-Source: APXvYqy6WYrXJYVzaoAEhFLP5e4SmtsVe0ylIbUCsgVmixU7NDvUkX9HJTB4HenAVIsBhnMSyjoAGQ==
X-Received: by 2002:a63:1b44:: with SMTP id b4mr31452890pgm.421.1572884861939;
        Mon, 04 Nov 2019 08:27:41 -0800 (PST)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id o12sm15989330pgl.86.2019.11.04.08.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 08:27:41 -0800 (PST)
Date:   Mon, 4 Nov 2019 08:27:21 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net-next] bpf: re-fix skip write only files in debugfs
Message-ID: <20191104082721.2c4304e8@cakuba.netronome.com>
In-Reply-To: <94ba2eebd8d6c48ca6da8626c9fa37f186d15f92.1572876157.git.daniel@iogearbox.net>
References: <94ba2eebd8d6c48ca6da8626c9fa37f186d15f92.1572876157.git.daniel@iogearbox.net>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Nov 2019 15:27:02 +0100, Daniel Borkmann wrote:
> Commit 5bc60de50dfe ("selftests: bpf: Don't try to read files without
> read permission") got reverted as the fix was not working as expected
> and real fix came in via 8101e069418d ("selftests: bpf: Skip write
> only files in debugfs"). When bpf-next got merged into net-next, the
> test_offload.py had a small conflict. Fix the resolution in ae8a76fb8b5d
> iby not reintroducing 5bc60de50dfe again.
> 
> Fixes: ae8a76fb8b5d ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next")
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Alexei Starovoitov <ast@kernel.org>

Ayayay :(

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

>  [
>    Hey Jakub, please take a look at the below merge fix ... still trying
>    to figure out why the netdev doesn't appear on my test node when I
>    wanted to run the test script, but seems independent of the fix.
> 
>    [...]
>    [ 1901.270493] netdevsim: probe of netdevsim4 failed with error -17
>    [...]
> 
>    # ./test_offload.py
>    Test destruction of generic XDP...
>    Traceback (most recent call last):
>     File "./test_offload.py", line 800, in <module>
>      simdev = NetdevSimDev()
>     File "./test_offload.py", line 355, in __init__
>      self.wait_for_netdevs(port_count)
>     File "./test_offload.py", line 390, in wait_for_netdevs
>      raise Exception("netdevices did not appear within timeout")
>    Exception: netdevices did not appear within timeout
>  ]
> 
>  tools/testing/selftests/bpf/test_offload.py | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
> index fc8a4319c1b2..1afa22c88e42 100755
> --- a/tools/testing/selftests/bpf/test_offload.py
> +++ b/tools/testing/selftests/bpf/test_offload.py
> @@ -314,7 +314,10 @@ def bpftool_prog_load(sample, file_name, maps=[], prog_type="xdp", dev=None,
>                  continue
>  
>              p = os.path.join(path, f)
> -            if os.path.isfile(p) and os.access(p, os.R_OK):
> +            if not os.stat(p).st_mode & stat.S_IRUSR:
> +                continue
> +
> +            if os.path.isfile(p):
>                  _, out = cmd('cat %s/%s' % (path, f))
>                  dfs[f] = out.strip()
>              elif os.path.isdir(p):
