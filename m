Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215481A6AF
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 06:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfEKEhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 00:37:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46753 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfEKEhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 00:37:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id t187so3944358pgb.13;
        Fri, 10 May 2019 21:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UYukucv8TKh0+v5GWyB7Tlv7mRIdfVYQX3Glv66VIQw=;
        b=BhTadKgUSYSyuSbjvV9r4iNRI9v6kX/UK39XJ6XUzwsLKQFarLP3R2ffrIqpL/UfvY
         LdS0aPn6WOMM197Bs4sRrdOksUTFwP3/kW4nfCPCT3X3r1/sW53fUZZZW5nuz2AtSmnG
         zd+ScySCXp4uFNnD0Cav+h+yLjRms0Df9hs3dw0n0yrh+9YK5NUl/wtxbxlZnb6EJ2PN
         Bqya/lBp5UU/E7r9fYR0djIHMxA4pwj4I5ggPCtHUpCUZN0HBqb5p1dQEXlIKQAsDF7Q
         okG0HdHtFFZo3mFFCsX/ISy0vSkny7VJVb3Znro211qyro2pDwJZdtOnYeTu1L6YTsUa
         VkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UYukucv8TKh0+v5GWyB7Tlv7mRIdfVYQX3Glv66VIQw=;
        b=RIGp1GqfF+1JAwQIaZnzb7nCX2LyCkn2N3UPJwjV2PRjruCG/6px/jNotq/2rwse6v
         qcbJV7sLvvGzkSI/FAyE8DqyM05r632f5DdajflzNUBjk1RyAo1L0gyn3eoozKrr6K4r
         xwiCNqr8/ZutxB1byQQMR7QkBCzmkcJHiLXe71qc4eiUkNYeCUZgnWtqlZd63oenF5Eu
         9cIraDFgL+oKNa5SbNO6Hms6yW6qtdEq27iJK9HkuTsatujNrvOV+pVd63tk4K01/vYz
         Jy6FoX0lYPeIzl+9XfPgzR+F1OjXMUJlL2yQDnOeJ3n8lLL3zW026rf/Vj6D6v13G85A
         SL5A==
X-Gm-Message-State: APjAAAUCc3qrXwKmWGgf/2pIjeJ66Wcv8Ii3654C3C4UVbnh87wDOoEC
        Z+GL9oJ/V7VYmz/hlEp2ELYeAf2Z
X-Google-Smtp-Source: APXvYqw25vH295BAqDckkGeVfGTzE/+V28snDGJNVNL9f9vsLkAH4tpdjb1EN2gNru1RZ7tfD/49Dw==
X-Received: by 2002:a63:ee10:: with SMTP id e16mr12005281pgi.207.1557549454123;
        Fri, 10 May 2019 21:37:34 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::b64b])
        by smtp.gmail.com with ESMTPSA id z66sm9656243pfz.83.2019.05.10.21.37.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 21:37:33 -0700 (PDT)
Date:   Fri, 10 May 2019 21:37:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     shuah@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        torvalds@linux-foundation.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] selftests: fix bpf build/test workflow regression when
 KBUILD_OUTPUT is set
Message-ID: <20190511043729.3o4enh35lrmne3kd@ast-mbp>
References: <20190511025249.32678-1-skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190511025249.32678-1-skhan@linuxfoundation.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 08:52:49PM -0600, Shuah Khan wrote:
> commit 8ce72dc32578 ("selftests: fix headers_install circular dependency")
> broke bpf build/test workflow. When KBUILD_OUTPUT is set, bpf objects end
> up in KBUILD_OUTPUT build directory instead of in ../selftests/bpf.
> 
> The following bpf workflow breaks when it can't find the test_verifier:
> 
> cd tools/testing/selftests/bpf; make; ./test_verifier;
> 
> Fix it to set OUTPUT only when it is undefined in lib.mk. It didn't need
> to be set in the first place.
> 
> Fixes: commit 8ce72dc32578 ("selftests: fix headers_install circular dependency")
> 
> Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

'git am' couldn't apply this patch because "sha1 information is lacking",
but the patch itself looks good.
Acked-by: Alexei Starovoitov <ast@kernel.org>
Thanks for the quick fix.

